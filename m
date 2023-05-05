Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F091CC77B7F
	for <linux-xfs@archiver.kernel.org>; Fri,  5 May 2023 11:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjEEL1y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 May 2023 07:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjEEL1x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 May 2023 07:27:53 -0400
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4091AED3
        for <linux-xfs@vger.kernel.org>; Fri,  5 May 2023 04:27:33 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4QCSp82nVgz9ttD6
        for <linux-xfs@vger.kernel.org>; Fri,  5 May 2023 19:17:36 +0800 (CST)
Received: from [10.174.177.238] (unknown [10.174.177.238])
        by APP2 (Coremail) with SMTP id BqC_BwC35oAH6FRkDua0Bg--.38027S2;
        Fri, 05 May 2023 11:27:11 +0000 (GMT)
Message-ID: <e8cd5d7c-c551-2b3e-0337-3e3c743a7159@huaweicloud.com>
Date:   Fri, 5 May 2023 19:27:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/3] xfs: fix leak memory when xfs_attr_inactive fails
To:     kernel test robot <yujie.liu@intel.com>
Cc:     oe-lkp@lists.linux.dev, lkp@intel.com, linux-xfs@vger.kernel.org,
        djwong@kernel.org, dchinner@redhat.com, sandeen@redhat.com,
        guoxuenan@huaweicloud.com, houtao1@huawei.com, fangwei1@huawei.com,
        jack.qiu@huawei.com, yi.zhang@huawei.com
References: <202305051403.a18c1919-yujie.liu@intel.com>
Content-Language: en-US
From:   Guo Xuenan <guoxuenan@huaweicloud.com>
In-Reply-To: <202305051403.a18c1919-yujie.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: BqC_BwC35oAH6FRkDua0Bg--.38027S2
X-Coremail-Antispam: 1UD129KBjvAXoW3Aw4xAw45Wr1fCry5XrW5Wrg_yoW8Jw45Go
        Wayr45Cr4rKrW5JFyUJr43X34UJrn7GFsrGF1Uuw4UuF1DJa9rGr42y34jgw4Yqr45X3W5
        AryIqFy8J39rJr4kn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUUYg7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xva
        j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
        x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8
        JVWxJwA2z4x0Y4vEx4A2jsIE14v26r1j6r4UM28EF7xvwVC2z280aVCY1x0267AKxVW8JV
        W8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
        0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
        kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
        67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
        CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
        3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
        sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: xjxr53hhqd0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi robot :)

Please ignore this patch, this is not an official patch,
have already discussed this with Dave and sent v2 [1] with
this one removed.

[1]: 
https://lore.kernel.org/linux-xfs/20230421113716.1890274-1-guoxuenan@huawei.com/
Thanks
Xuenan
On 2023/5/5 16:16, kernel test robot wrote:
> Hello,
>
> kernel test robot noticed "BUG_xfs_ili(Tainted:G_I):Objects_remaining_in_xfs_ili_on__kmem_cache_shutdown()" on:
>
> commit: c7c1088ea2d15f5020656c1bdd8f4805ef93cc09 ("[PATCH 1/3] xfs: fix leak memory when xfs_attr_inactive fails")
> url: https://github.com/intel-lab-lkp/linux/commits/Guo-Xuenan/xfs-fix-leak-memory-when-xfs_attr_inactive-fails/20230421-115047
> base: https://git.kernel.org/cgit/fs/xfs/xfs-linux.git for-next
> patch link: https://lore.kernel.org/all/20230421033142.1656296-2-guoxuenan@huawei.com/
> patch subject: [PATCH 1/3] xfs: fix leak memory when xfs_attr_inactive fails
>
> in testcase: xfstests
> version: xfstests-x86_64-06c027a-1_20230501
> with following parameters:
>
> 	disk: 4HDD
> 	fs: xfs
> 	test: xfs-reflink-rmapbt
>
> compiler: gcc-11
> test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) with 32G memory
>
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>
>
> If you fix the issue, kindly add following tag
> | Reported-by: kernel test robot <yujie.liu@intel.com>
> | Link: https://lore.kernel.org/oe-lkp/202305051403.a18c1919-yujie.liu@intel.com
>
>
> [  154.351061][ T7053] =============================================================================
> [  154.359924][ T7053] BUG xfs_ili (Tainted: G          I       ): Objects remaining in xfs_ili on __kmem_cache_shutdown()
> [  154.370673][ T7053] -----------------------------------------------------------------------------
> [  154.370673][ T7053]
> [  154.381678][ T7053] Slab 0x000000003de97eaf objects=31 used=1 fp=0x00000000942c6f8b flags=0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
> [  154.395197][ T7053] CPU: 0 PID: 7053 Comm: modprobe Tainted: G          I        6.3.0-rc6-00128-gc7c1088ea2d1 #1
> [  154.405427][ T7053] Hardware name: Dell Inc. OptiPlex 7040/0Y7WYT, BIOS 1.1.1 10/07/2015
> [  154.413492][ T7053] Call Trace:
> [  154.416624][ T7053]  <TASK>
> [ 154.419408][ T7053] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1))
> [ 154.423755][ T7053] slab_err (mm/slub.c:995)
> [ 154.427583][ T7053] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:202 include/linux/atomic/atomic-instrumented.h:543 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:186 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170)
> [ 154.432447][ T7053] ? _raw_spin_lock_bh (kernel/locking/spinlock.c:169)
> [ 154.437225][ T7053] ? start_poll_synchronize_srcu (kernel/rcu/srcutree.c:1306)
> [ 154.442867][ T7053] __kmem_cache_shutdown (include/linux/spinlock.h:350 mm/slub.c:4555 mm/slub.c:4586 mm/slub.c:4618)
> [ 154.447989][ T7053] kmem_cache_destroy (mm/slab_common.c:457 mm/slab_common.c:497 mm/slab_common.c:480)
> [ 154.452766][ T7053] xfs_destroy_caches (fs/xfs/xfs_super.c:2208) xfs
> [ 154.458274][ T7053] exit_xfs_fs (fs/xfs/./xfs_trace.h:134) xfs
> [ 154.463081][ T7053] __do_sys_delete_module+0x2ea/0x530
> [ 154.469330][ T7053] ? module_flags (kernel/module/main.c:694)
> [ 154.473848][ T7053] ? __fget_light (include/linux/atomic/atomic-arch-fallback.h:227 include/linux/atomic/atomic-instrumented.h:35 fs/file.c:1016)
> [ 154.478279][ T7053] ? __blkcg_punt_bio_submit (block/blk-cgroup.c:1840)
> [ 154.483749][ T7053] ? _raw_spin_lock (arch/x86/include/asm/atomic.h:202 include/linux/atomic/atomic-instrumented.h:543 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:186 include/linux/spinlock_api_smp.h:134 kernel/locking/spinlock.c:154)
> [ 154.488267][ T7053] ? _raw_write_lock_irq (kernel/locking/spinlock.c:153)
> [ 154.493216][ T7053] ? exit_to_user_mode_loop (include/linux/sched.h:2326 include/linux/resume_user_mode.h:61 kernel/entry/common.c:171)
> [ 154.498513][ T7053] ? exit_to_user_mode_prepare (kernel/entry/common.c:204)
> [ 154.503982][ T7053] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> [ 154.508247][ T7053] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> [  154.513983][ T7053] RIP: 0033:0x7f97ecfcc417
> [ 154.518250][ T7053] Code: 73 01 c3 48 8b 0d 79 1a 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 49 1a 0d 00 f7 d8 64 89 01 48
> All code
> ========
>     0:   73 01                   jae    0x3
>     2:   c3                      ret
>     3:   48 8b 0d 79 1a 0d 00    mov    0xd1a79(%rip),%rcx        # 0xd1a83
>     a:   f7 d8                   neg    %eax
>     c:   64 89 01                mov    %eax,%fs:(%rcx)
>     f:   48 83 c8 ff             or     $0xffffffffffffffff,%rax
>    13:   c3                      ret
>    14:   66 2e 0f 1f 84 00 00    cs nopw 0x0(%rax,%rax,1)
>    1b:   00 00 00
>    1e:   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
>    23:   b8 b0 00 00 00          mov    $0xb0,%eax
>    28:   0f 05                   syscall
>    2a:*  48 3d 01 f0 ff ff       cmp    $0xfffffffffffff001,%rax         <-- trapping instruction
>    30:   73 01                   jae    0x33
>    32:   c3                      ret
>    33:   48 8b 0d 49 1a 0d 00    mov    0xd1a49(%rip),%rcx        # 0xd1a83
>    3a:   f7 d8                   neg    %eax
>    3c:   64 89 01                mov    %eax,%fs:(%rcx)
>    3f:   48                      rex.W
>
> Code starting with the faulting instruction
> ===========================================
>     0:   48 3d 01 f0 ff ff       cmp    $0xfffffffffffff001,%rax
>     6:   73 01                   jae    0x9
>     8:   c3                      ret
>     9:   48 8b 0d 49 1a 0d 00    mov    0xd1a49(%rip),%rcx        # 0xd1a59
>    10:   f7 d8                   neg    %eax
>    12:   64 89 01                mov    %eax,%fs:(%rcx)
>    15:   48                      rex.W
> [  154.537679][ T7053] RSP: 002b:00007ffcbb650898 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
> [  154.545918][ T7053] RAX: ffffffffffffffda RBX: 000055c4d9f84d30 RCX: 00007f97ecfcc417
> [  154.553722][ T7053] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 000055c4d9f84d98
> [  154.561525][ T7053] RBP: 000055c4d9f84d30 R08: 0000000000000000 R09: 0000000000000000
> [  154.569329][ T7053] R10: 00007f97ed04cac0 R11: 0000000000000206 R12: 000055c4d9f84d98
> [  154.577135][ T7053] R13: 0000000000000000 R14: 0000000000000000 R15: 000055c4d9f84e40
> [  154.584940][ T7053]  </TASK>
> [  154.587811][ T7053] Disabling lock debugging due to kernel taint
> [  154.593798][ T7053] Object 0x0000000094871ff8 @offset=792
> [  154.599243][ T7053] ------------[ cut here ]------------
> [ 154.604558][ T7053] kmem_cache_destroy xfs_ili: Slab cache still has objects when called from xfs_destroy_caches (fs/xfs/xfs_super.c:2208) xfs
> [ 154.604737][ T7053] WARNING: CPU: 0 PID: 7053 at mm/slab_common.c:497 kmem_cache_destroy (mm/slab_common.c:497 mm/slab_common.c:480)
> [  154.625565][ T7053] Modules linked in: xfs(-) dm_mod ipmi_devintf ipmi_msghandler intel_rapl_msr btrfs intel_rapl_common blake2b_generic xor x86_pkg_temp_thermal raid6_pq intel_powerclamp zstd_compress coretemp libcrc32c kvm_intel kvm sd_mod irqbypass t10_pi crct10dif_pclmul crc32_pclmul crc64_rocksoft_generic crc64_rocksoft crc64 crc32c_intel sg ghash_clmulni_intel i915 sha512_ssse3 mei_wdt wmi_bmof drm_buddy intel_gtt rapl drm_display_helper intel_cstate intel_uncore ahci drm_kms_helper libahci mei_me syscopyarea intel_pch_thermal sysfillrect sysimgblt libata mei ttm video wmi intel_pmc_core acpi_pad fuse drm ip_tables [last unloaded: xfs]
> [  154.682341][ T7053] CPU: 0 PID: 7053 Comm: modprobe Tainted: G    B     I        6.3.0-rc6-00128-gc7c1088ea2d1 #1
> [  154.692603][ T7053] Hardware name: Dell Inc. OptiPlex 7040/0Y7WYT, BIOS 1.1.1 10/07/2015
> [ 154.700684][ T7053] RIP: 0010:kmem_cache_destroy (mm/slab_common.c:497 mm/slab_common.c:480)
> [ 154.706332][ T7053] Code: 89 ef 5b 5d 41 5c 41 5d e9 2d a2 13 00 c3 48 8b 55 60 48 8b 4c 24 20 48 c7 c6 40 db b2 83 48 c7 c7 f0 83 13 84 e8 60 2b 9e ff <0f> 0b eb ab 66 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 55 48
> All code
> ========
>     0:   89 ef                   mov    %ebp,%edi
>     2:   5b                      pop    %rbx
>     3:   5d                      pop    %rbp
>     4:   41 5c                   pop    %r12
>     6:   41 5d                   pop    %r13
>     8:   e9 2d a2 13 00          jmp    0x13a23a
>     d:   c3                      ret
>     e:   48 8b 55 60             mov    0x60(%rbp),%rdx
>    12:   48 8b 4c 24 20          mov    0x20(%rsp),%rcx
>    17:   48 c7 c6 40 db b2 83    mov    $0xffffffff83b2db40,%rsi
>    1e:   48 c7 c7 f0 83 13 84    mov    $0xffffffff841383f0,%rdi
>    25:   e8 60 2b 9e ff          call   0xffffffffff9e2b8a
>    2a:*  0f 0b                   ud2             <-- trapping instruction
>    2c:   eb ab                   jmp    0xffffffffffffffd9
>    2e:   66 66 2e 0f 1f 84 00    data16 cs nopw 0x0(%rax,%rax,1)
>    35:   00 00 00 00
>    39:   90                      nop
>    3a:   f3 0f 1e fa             endbr64
>    3e:   55                      push   %rbp
>    3f:   48                      rex.W
>
> Code starting with the faulting instruction
> ===========================================
>     0:   0f 0b                   ud2
>     2:   eb ab                   jmp    0xffffffffffffffaf
>     4:   66 66 2e 0f 1f 84 00    data16 cs nopw 0x0(%rax,%rax,1)
>     b:   00 00 00 00
>     f:   90                      nop
>    10:   f3 0f 1e fa             endbr64
>    14:   55                      push   %rbp
>    15:   48                      rex.W
> [  154.725739][ T7053] RSP: 0018:ffffc90000827e08 EFLAGS: 00010286
> [  154.731643][ T7053] RAX: 0000000000000000 RBX: 1ffff92000104fc8 RCX: 0000000000000027
> [  154.739452][ T7053] RDX: 0000000000000027 RSI: 0000000000000004 RDI: ffff888731428708
> [  154.747270][ T7053] RBP: ffff888865b8aa00 R08: 0000000000000001 R09: ffff88873142870b
> [  154.755088][ T7053] R10: ffffed10e62850e1 R11: 0000000000000001 R12: 0000000048020000
> [  154.762909][ T7053] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [  154.770731][ T7053] FS:  00007f97ecea7540(0000) GS:ffff888731400000(0000) knlGS:0000000000000000
> [  154.779497][ T7053] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  154.785920][ T7053] CR2: 00007ffcbb64d768 CR3: 00000002088a4003 CR4: 00000000003706f0
> [  154.793730][ T7053] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  154.801537][ T7053] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  154.809362][ T7053] Call Trace:
> [  154.812497][ T7053]  <TASK>
> [ 154.815286][ T7053] xfs_destroy_caches (fs/xfs/xfs_super.c:2208) xfs
> [ 154.820860][ T7053] exit_xfs_fs (fs/xfs/./xfs_trace.h:134) xfs
> [ 154.825737][ T7053] __do_sys_delete_module+0x2ea/0x530
> [ 154.832007][ T7053] ? module_flags (kernel/module/main.c:694)
> [ 154.836531][ T7053] ? __fget_light (include/linux/atomic/atomic-arch-fallback.h:227 include/linux/atomic/atomic-instrumented.h:35 fs/file.c:1016)
> [ 154.840967][ T7053] ? __blkcg_punt_bio_submit (block/blk-cgroup.c:1840)
> [ 154.846442][ T7053] ? _raw_spin_lock (arch/x86/include/asm/atomic.h:202 include/linux/atomic/atomic-instrumented.h:543 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:186 include/linux/spinlock_api_smp.h:134 kernel/locking/spinlock.c:154)
> [ 154.850962][ T7053] ? _raw_write_lock_irq (kernel/locking/spinlock.c:153)
> [ 154.855919][ T7053] ? exit_to_user_mode_loop (include/linux/sched.h:2326 include/linux/resume_user_mode.h:61 kernel/entry/common.c:171)
> [ 154.861220][ T7053] ? exit_to_user_mode_prepare (kernel/entry/common.c:204)
> [ 154.866693][ T7053] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> [ 154.870955][ T7053] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> [  154.876689][ T7053] RIP: 0033:0x7f97ecfcc417
> [ 154.880950][ T7053] Code: 73 01 c3 48 8b 0d 79 1a 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 49 1a 0d 00 f7 d8 64 89 01 48
> All code
> ========
>     0:   73 01                   jae    0x3
>     2:   c3                      ret
>     3:   48 8b 0d 79 1a 0d 00    mov    0xd1a79(%rip),%rcx        # 0xd1a83
>     a:   f7 d8                   neg    %eax
>     c:   64 89 01                mov    %eax,%fs:(%rcx)
>     f:   48 83 c8 ff             or     $0xffffffffffffffff,%rax
>    13:   c3                      ret
>    14:   66 2e 0f 1f 84 00 00    cs nopw 0x0(%rax,%rax,1)
>    1b:   00 00 00
>    1e:   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
>    23:   b8 b0 00 00 00          mov    $0xb0,%eax
>    28:   0f 05                   syscall
>    2a:*  48 3d 01 f0 ff ff       cmp    $0xfffffffffffff001,%rax         <-- trapping instruction
>    30:   73 01                   jae    0x33
>    32:   c3                      ret
>    33:   48 8b 0d 49 1a 0d 00    mov    0xd1a49(%rip),%rcx        # 0xd1a83
>    3a:   f7 d8                   neg    %eax
>    3c:   64 89 01                mov    %eax,%fs:(%rcx)
>    3f:   48                      rex.W
>
> Code starting with the faulting instruction
> ===========================================
>     0:   48 3d 01 f0 ff ff       cmp    $0xfffffffffffff001,%rax
>     6:   73 01                   jae    0x9
>     8:   c3                      ret
>     9:   48 8b 0d 49 1a 0d 00    mov    0xd1a49(%rip),%rcx        # 0xd1a59
>    10:   f7 d8                   neg    %eax
>    12:   64 89 01                mov    %eax,%fs:(%rcx)
>    15:   48                      rex.W
> [  154.900357][ T7053] RSP: 002b:00007ffcbb650898 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
> [  154.908626][ T7053] RAX: ffffffffffffffda RBX: 000055c4d9f84d30 RCX: 00007f97ecfcc417
> [  154.916435][ T7053] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 000055c4d9f84d98
> [  154.924243][ T7053] RBP: 000055c4d9f84d30 R08: 0000000000000000 R09: 0000000000000000
> [  154.932053][ T7053] R10: 00007f97ed04cac0 R11: 0000000000000206 R12: 000055c4d9f84d98
> [  154.939862][ T7053] R13: 0000000000000000 R14: 0000000000000000 R15: 000055c4d9f84e40
> [  154.947670][ T7053]  </TASK>
> [  154.950544][ T7053] ---[ end trace 0000000000000000 ]---
>
>
>

