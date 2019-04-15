Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:32978 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726094AbfDOKNt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Apr 2019 06:13:49 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D8B6528927
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 10:13:48 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203329] New: WARNING at kernel/locking/lockdep.c:
 lockdep_register_key() and lockdep_unregister_key()
Date: Mon, 15 Apr 2019 10:13:47 +0000
Message-ID: <bug-203329-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203329

            Bug ID: 203329
           Summary: WARNING at kernel/locking/lockdep.c:
                    lockdep_register_key() and lockdep_unregister_key()
           Product: File System
           Version: 2.5
    Kernel Version: 5.1.0-rc4+
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

When I did regression test on linux
5.1.0-rc4+(HEAD=4443f8e6ac7755cd775c70d08be8042dc2f936cb), xfs/274 and
generic/165 trigger kernel warning when mount/umount XFS:

[26340.837818] run fstests xfs/274 at 2019-04-14 12:42:09
[26341.218234] XFS (vda5): Unmounting Filesystem
[26342.228302] XFS (vda5): Mounting V5 Filesystem
[26342.289070] XFS (vda5): Ending clean mount
[26342.327646] XFS (vda5): Unmounting Filesystem
[26343.316159] XFS (vda5): Mounting V5 Filesystem
[26343.369290] XFS (vda5): Ending clean mount
[26343.418799] XFS (vda5): Unmounting Filesystem
[26345.693271] WARNING: CPU: 7 PID: 3341 at kernel/locking/lockdep.c:1025
lockdep_register_key+0x1b0/0x1e0
[26345.693683] Modules linked in: dm_log_writes dm_thin_pool dm_persistent_data
dm_bio_prison sd_mod sg dm_snapshot dm_bufio ext4 mbcache jbd2 loop dm_flakey
dm_mod sunrpc pseries_rng xts virtio_balloon vmx_crypto xfs libcrc32c
virtio_net net_failover virtio_console virtio_blk failover [last unloaded:
scsi_debug]
[26345.694417] CPU: 7 PID: 3341 Comm: mount Tainted: G        W        
5.1.0-rc4+ #1
[26345.694636] NIP:  c0000000001cc720 LR: c0000000001cc590 CTR:
fffffffffffffffb
[26345.694848] REGS: c0000001f2def670 TRAP: 0700   Tainted: G        W         
(5.1.0-rc4+)
[26345.695058] MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 48022448 
XER: 20000000
[26345.695286] CFAR: c0000000001cc594 IRQMASK: 0 
               GPR00: c0000000001674dc c0000001f2def900 c000000001c07700
0000000000000001 
               GPR04: c000000000f8b270 c000000001df7690 0000000000000000
3ffffffd18b7f179 
               GPR08: c000000001a5d4d8 c000000002e50000 c000000001a5d4e8
d000000007e17868 
               GPR12: 0000000000002200 c00000003fff6280 000000013f765f30
000000013f76afe0 
               GPR16: 000000013f76afd0 000000013f76afc8 000000013f76afc0
0000000000000000 
               GPR20: ffffffffffffffff 0000000000000000 00007fffd95fe521
0000000000000001 
               GPR24: c0000002e7510000 c000000001df72a0 c0000002e7510000
d000000007e38e88 
               GPR28: c000000001a5d420 c000000001a5d578 c000000001a5d538
c000000001a5d538 
[26345.697088] NIP [c0000000001cc720] lockdep_register_key+0x1b0/0x1e0
[26345.697273] LR [c0000000001cc590] lockdep_register_key+0x20/0x1e0
[26345.697455] Call Trace:
[26345.697549] [c0000001f2def900] [ffff0a00ffffff04] 0xffff0a00ffffff04
(unreliable)
[26345.697774] [c0000001f2def970] [c0000000001674dc]
alloc_workqueue+0x1ac/0x5d8
[26345.698204] [c0000001f2defa30] [d000000007dc57d4]
xfs_init_mount_workqueues+0x3c/0x200 [xfs]
[26345.698511] [c0000001f2defaa0] [d000000007dc6a24]
xfs_fs_fill_super+0x34c/0x820 [xfs]
[26345.698750] [c0000001f2defb50] [c0000000004db47c] mount_bdev+0x25c/0x290
[26345.698992] [c0000001f2defbf0] [d000000007dc4270] xfs_fs_mount+0x28/0x50
[xfs]
[26345.699206] [c0000001f2defc10] [c0000000005386cc] legacy_get_tree+0x4c/0xb0
[26345.699385] [c0000001f2defc40] [c0000000004d8dfc] vfs_get_tree+0x6c/0x1e0
[26345.699564] [c0000001f2defcc0] [c000000000514ddc] do_mount+0xbac/0x1100
[26345.699744] [c0000001f2defdb0] [c0000000005158e8] ksys_mount+0x158/0x180
[26345.699932] [c0000001f2defe00] [c000000000515930] sys_mount+0x20/0x30
[26345.700119] [c0000001f2defe20] [c00000000000b488] system_call+0x5c/0x70
[26345.700299] Instruction dump:
[26345.700407] 2f890000 409eff78 3c82ff37 3c62ff38 38840328 3863f748 4bf62fd5
60000000 
[26345.700626] 0fe00000 4bffff58 60000000 60000000 <0fe00000> 38210070 e8010010
ebe1fff8 
[26345.700844] irq event stamp: 0
[26345.700956] hardirqs last  enabled at (0): [<0000000000000000>]          
(null)
[26345.701189] hardirqs last disabled at (0): [<c00000000012c030>]
copy_process.isra.4.part.5+0x660/0x1f30
[26345.701439] softirqs last  enabled at (0): [<c00000000012c030>]
copy_process.isra.4.part.5+0x660/0x1f30
[26345.701696] softirqs last disabled at (0): [<0000000000000000>]          
(null)
[26345.701908] ---[ end trace 4f50c38c90076780 ]---
[26345.704912] XFS (vda5): Mounting V5 Filesystem
[26345.765221] XFS (vda5): Ending clean mount
[26347.217633] XFS (vda3): Unmounting Filesystem
[26347.679509] XFS (vda5): Unmounting Filesystem
[26347.684992] WARNING: CPU: 3 PID: 3765 at kernel/locking/lockdep.c:4906
lockdep_unregister_key+0x1d0/0x290
[26347.685308] Modules linked in: dm_log_writes dm_thin_pool dm_persistent_data
dm_bio_prison sd_mod sg dm_snapshot dm_bufio ext4 mbcache jbd2 loop dm_flakey
dm_mod sunrpc pseries_rng xts virtio_balloon vmx_crypto xfs libcrc32c
virtio_net net_failover virtio_console virtio_blk failover [last unloaded:
scsi_debug]
[26347.688614] CPU: 3 PID: 3765 Comm: umount Tainted: G        W        
5.1.0-rc4+ #1
[26347.688819] NIP:  c0000000001cdf80 LR: c0000000001cde30 CTR:
0000000000000000
[26347.689031] REGS: c0000001e2bc7800 TRAP: 0700   Tainted: G        W         
(5.1.0-rc4+)
[26347.689220] MSR:  800000010282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]> 
CR: 44008448  XER: 00000000
[26347.689461] CFAR: c0000000001cde34 IRQMASK: 0 
               GPR00: c0000000001cde24 c0000001e2bc7a90 c000000001c07700
0000000000000001 
               GPR04: 0000000000001328 0000000000000000 0000000000000000
0000000000000001 
               GPR08: 0000000000000000 c000000002e50000 0000000000000000
d000000007e15e28 
               GPR12: 0000000000008800 c00000003fffae80 0000000000000000
0000000000000000 
               GPR16: 0000000000000000 0000000000000000 0000000000000000
0000000000000000 
               GPR20: 0000000000000000 0000000000000000 0000000000000000
0000000000000000 
               GPR24: 00000001246a5ea0 00000001246a6500 00000001246bf6e8
c0000000026267e8 
               GPR28: c000000000f8b4e8 0000000000005140 c000000001dfb950
c000000001a5fd38 
[26347.691071] NIP [c0000000001cdf80] lockdep_unregister_key+0x1d0/0x290
[26347.691240] LR [c0000000001cde30] lockdep_unregister_key+0x80/0x290
[26347.691399] Call Trace:
[26347.691472] [c0000001e2bc7a90] [c0000000001cde24]
lockdep_unregister_key+0x74/0x290 (unreliable)
[26347.691712] [c0000001e2bc7ae0] [c000000000165968]
destroy_workqueue+0x298/0x3a0
[26347.692016] [c0000001e2bc7b40] [d000000007dc59c4]
xfs_destroy_mount_workqueues+0x2c/0xa0 [xfs]
[26347.692341] [c0000001e2bc7b70] [d000000007dc6f9c] xfs_fs_put_super+0xa4/0xf0
[xfs]
[26347.692536] [c0000001e2bc7be0] [c0000000004d88c8]
generic_shutdown_super+0xb8/0x170
[26347.692737] [c0000001e2bc7c50] [c0000000004d8d38] kill_block_super+0x38/0x90
[26347.692935] [c0000001e2bc7c80] [c0000000004d96d0]
deactivate_locked_super+0x80/0x100
[26347.693133] [c0000001e2bc7cb0] [c00000000050ed44] cleanup_mnt+0x64/0xc0
[26347.693302] [c0000001e2bc7ce0] [c000000000169558] task_work_run+0x118/0x180
[26347.693464] [c0000001e2bc7d30] [c000000000023e24]
do_notify_resume+0x414/0x480
[26347.693652] [c0000001e2bc7e20] [c00000000000dec4]
ret_from_except_lite+0x70/0x74
[26347.693847] Instruction dump:
[26347.693947] f9280000 419e0008 f9090008 3d205dea 6129dbee 792907c6 6529f000
61290200 
[26347.694150] f92a0008 4bffff54 60000000 60000000 <0fe00000> 38210050 e8010010
eb61ffd8 
[26347.694366] irq event stamp: 0
[26347.694468] hardirqs last  enabled at (0): [<0000000000000000>]          
(null)
[26347.694665] hardirqs last disabled at (0): [<c00000000012c030>]
copy_process.isra.4.part.5+0x660/0x1f30
[26347.694885] softirqs last  enabled at (0): [<c00000000012c030>]
copy_process.isra.4.part.5+0x660/0x1f30
[26347.695111] softirqs last disabled at (0): [<0000000000000000>]          
(null)
[26347.695301] ---[ end trace 4f50c38c90076781 ]---
[26347.881761] XFS (vda5): Mounting V5 Filesystem
[26347.921784] XFS (vda5): Ending clean mount

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
