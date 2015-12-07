--[[ ˾��ܲ ���ܽű� XavierCHN @ 2014.12.1]]
require('abilities/ability_generic')

-- �����ʹ�������
function OnYanjibo(keys)
    local caster = keys.caster
    local point = keys.target_points[1]
    local caster_origin = caster:GetOrigin()
    local direction =(point - caster_origin):Normalized()

    local effect_count = 0
    -- ����Ϊ�˾���ģ�� - -!
    -- �ͷ�������Ů�Ĺ������Ч
    caster:SetContextThink(DoUniqueString("fireeffect"),
    function()
        local p_index = ParticleManager:CreateParticle("particles/heroes/simayi/lina_spell_light_strike_array.vpcf", PATTACH_CUSTOMORIGIN, caster)
        local vec = caster_origin + direction *(100 + 200 * effect_count)
        ParticleManager:SetParticleControl(p_index, 0, vec)
        ParticleManager:ReleaseParticleIndex(p_index)
        effect_count = effect_count + 1
        -- �ܹ���������
        if effect_count >= 3 then return nil else return 0.1 end
    end ,
    0.1)
end

-- ��ȡ��������Ч��ĺ���
function GetHuoyanyPoints(keys)
    local caster = keys.caster
    local point = keys.target_points[1]
    local ability = keys.ability
    local radius = 200

    local result = { }
    for i = 1, 10 do
        local random_radius = RandomFloat(0, radius)
        -- ԲȦ��Χ�����10���ص�
        local random_vec = point + RandomVector(random_radius)
        table.insert(result, random_vec)
        -- ԲȦ��Χ���10���ص�
        random_vec = point + RandomVector(radius)
        table.insert(result, random_vec)
    end
    -- ������20����
    return result
end

function FireHuoyanyuParticle(keys)
    local caster = keys.caster
    -- ���Ϸ��ĺ�����ȡ20�������
    local points = GetHuoyanyPoints(keys)
    -- ����20��������ͷ��޸Ĺ���������Ч
    for _, point in pairs(points) do
        local p_index = ParticleManager:CreateParticle("particles/heroes/simayi/huoyanyu/mirana_starfall_attack_1.vpcf", PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(p_index, 0, point)
        ParticleManager:ReleaseParticleIndex(p_index)
    end
end

-- ���䡤��ʼ��ʱ��
function OnXingluo(keys)
    print("on xingluo")
    local caster = keys.caster
    local point = keys.target_points[1]   
    -- ��ʱ��ȡ���������Ч
    local p1 = ParticleManager:CreateParticle('particles/heroes/simayi/mirana_starfall_attack.vpcf', PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(p1, 0, point)
   ParticleManager:ReleaseParticleIndex(p1)
   GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("simayi_02"),function()
        local p = ParticleManager:CreateParticle('particles/units/heroes/hero_undying/undying_loadout.vpcf', PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControl(p, 0, point)
        ParticleManager:ReleaseParticleIndex(p)
   end,0.5)
end

-- ����������Ч
function OnXingluoEnd(keys)
    local caster = keys.caster
    local point = keys.target_points[1]
    local p_end = 'particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf'
    local p_index = ParticleManager:CreateParticle(p_end, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(p_index, 0, point)
    ParticleManager:ReleaseParticleIndex(p_index)
    local p_end = 'particles/units/heroes/hero_undying/undying_loadout.vpcf'
    local p_index = ParticleManager:CreateParticle(p_end, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(p_index, 0, point)
    ParticleManager:ReleaseParticleIndex(p_index)
end
function Onstartstun(keys)
    -- body
    local caster = keys.caster
    target=keys.target
    if target then
        for k,_target in pairs(target) do
            if _target:IsMagicImmune() then 
                 keys.ability:ApplyDataDrivenModifier(caster,_target, "sima_xingluo_stun_buff", {duration = 1.75})
            end
        end
    end
end