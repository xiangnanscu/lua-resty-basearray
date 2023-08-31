local setup = require('./lib/resty/basearray').setup
local array = setup({})
setmetatable(array, { __call = function(t, self) return setmetatable(self, t) end })
array.__index = array
function array.__eq(self, o)
  if type(o) ~= 'table' or #o ~= #self then
    return false
  end
  for i = 1, #self do
    if self[i] ~= o[i] then
      local tt, ot = type(self[i]), type(o[i])
      if tt ~= ot then
        return false
      elseif tt ~= 'table' then
        return false
      elseif not array.__eq(self[i], o[i]) then
        return false
      end
    end
  end
  return true
end

local p = function(e)
  print(e)
end
-- assert(array { 1, 2, 3 } + array { 3, 4 } == array { 1, 2, 3, 3, 4 })
-- assert(array { 1, 2, 3 } - array { 3, 4 } == array { 1, 2 })
-- assert(array { 'a', 'b', 'c' }:entries() == array { { 1, 'a' }, { 2, 'b' }, { 3, 'c' } })
assert(array { 1, 2, 3 }:every(function(n)
  return n > 0
end) == true)
assert(array { 0, 0, 0 }:fill(8) == array { 8, 8, 8 })
assert(array { 0, 0, 0 }:fill(8, 2, 3) == array { 0, 8, 8 })
assert(array { 1, 'not', 3, 'number' }:filter(function(e)
  return tonumber(e)
end) == array { 1, 3 })
assert(array { { id = 1 }, { id = 101 }, { id = 3 } }:find(function(e)
  return e.id == 101
end).id == 101)
assert(array { { id = 1 }, { id = 101 }, { id = 3 } }:find_index(function(e)
  return e.id == 101
end) == 2)
assert(array { 1, { 2 }, 3 }:flat() == array { 1, 2, 3 })
array { 'a', 'b', 'c' }:for_each(print)
assert(array { 1, 2, 3 }:includes(1) == true)
assert(array { 1, 2, 3 }:includes(1, 4) == false)
assert(array { 1, 2, 3 }:includes(5) == false)
assert(array { 'a', 'b' }:index_of('b') == 2)
assert(array { 'a', 'b', 'c' }:join('|') == 'a|b|c')
-- assert(array { 'a', 'b', 'c' }:keys() == array { 1, 2, 3 })
assert(array { 'a', 'b', 'b', 'c' }:last_index_of('b', -1) == 3)
assert(array { 'a', 'b', 'b', 'c' }:index_of('b') == 2)
assert(array { 1, 2, 3 }:map(function(n)
  return n + 10
end) == array { 11, 12, 13 })
assert(array { 1, 2, 100 }:pop() == 100)
assert(array { 1, 2, 3 }:reverse() == array { 3, 2, 1 })
local a = array { 1, 2, 3 }
assert(a:push(4, 5, 6) == 6)
assert(a == array { 1, 2, 3, 4, 5, 6 })
assert(a:shift() == 1)
assert(a == array { 2, 3, 4, 5, 6 })
assert(array { 1, 2, 3 }:reduce(function(x, y)
  return x + y
end) == 6)
assert(array { 1, 2, 3, 4 }:slice() == array { 1, 2, 3, 4 })
assert(array { 1, 2, 3, 4 }:slice(2) == array { 2, 3, 4 })
assert(array { 1, 2, 3, 4 }:slice(1, -1) == array { 1, 2, 3, 4 })
assert(array { 1, 2, 3, 4 }:slice(2, 3) == array { 2, 3 })
assert(array { 1, 2, 3 }:some(function(n)
  return n < 0
end) == false)
assert(array { -1, 2, 3 }:some(function(n)
  return n < 0
end) == true)
local b = array {}
assert(b:splice(1, 0, 1, 2, 3, 4) == array {})
assert(b == array { 1, 2, 3, 4 })
assert(b:splice(1, 1) == array { 1 })
assert(b == array { 2, 3, 4 })
assert(b:splice(2, 1, 5, 6) == array { 3 })
assert(b == array { 2, 5, 6, 4 })
local c = array {}
assert(c:unshift('c', 'd', 'e') == 3)
assert(c == array { 'c', 'd', 'e' })
p(c)
assert(c:unshift('a', 'b') == 5)
assert(c == array { 'a', 'b', 'c', 'd', 'e' })
assert(array { { id = 1 }, { id = 101 }, { id = 3 } }:map_key('id') == array { 1, 101, 3 })
assert(array { 1, 2, 2, 3 }:dup() == 2)
assert(array { 1, 2, 2, 3, 4, 4, 4, 5 }:dups() == array { 2, 2, 4, 4, 4 })
assert(array { 1, 2, 2, 3, 4, 4, 4, 5 }:uniq() == array { 1, 2, 3, 4, 5 })
p(array { 1, 2, 3, 4 }:combine(2))
print("all tests passed!")
