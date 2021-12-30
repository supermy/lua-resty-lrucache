-- file myapp.lua: example "myapp" module

local _M = {}

-- alternatively: local lrucache = require "resty.lrucache.pureffi"
local lrucache = require "lib/resty/lrucache/pureffi"
-- local lrucache = require "lib/resty/lrucache"

-- we need to initialize the cache on the lua module level so that
-- it can be shared by all the requests served by each nginx worker process:
local c, err = lrucache.new(200)  -- allow up to 200 items in the cache
if not c then
    error("failed to create the cache: " .. (err or "unknown"))
end

function _M.go()
    c:set("dog", 32)
    c:set("cat", 56)
    print("dog: ", c:get("dog"))
    print("cat: ", c:get("cat"))

    c:set("dog", { age = 10 }, 0.1)  -- expire in 0.1 sec
    c:delete("dog")

    c:flush_all()  -- flush all the cached data
end

return _M