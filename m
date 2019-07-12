Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46116 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727363AbfGLNSM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jul 2019 09:18:12 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3399E28C3E
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 13:18:11 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203947] [xfstests generic/475]: general protection fault: 0000
 [#1] RIP: 0010:xfs_setfilesize_ioend+0xb1/0x220 [xfs]
Date: Fri, 12 Jul 2019 13:18:09 +0000
Message-ID: <bug-203947-201763-ReLntvoSoN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203947-201763@https.bugzilla.kernel.org/>
References: <bug-203947-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203947

--- Comment #14 from Zorro Lang (zlang@redhat.com) ---
(In reply to Zorro Lang from comment #13)
> (In reply to Luis Chamberlain from comment #12)
> > (In reply to Zorro Lang from comment #11)
> > > (In reply to Zorro Lang from comment #10)
> > > > (In reply to Darrick J. Wong from comment #9)
> > > > > Zorro,
> > > > > 
> > > > > If you get a chance, can you try this debugging patch, please?
> > > > 
> > > > Sure, I'll give it a try. With this bug together ... they both
> triggered
> > by
> > > > g/475. You really write a nice case :)
> > > > 
> > > > Both these two bugs are too hard to reproduce, so I only can try my
> best
> > to
> > > > test it, but I can't 100% verify they're fixed even if all test pass,
> > I'll
> > > > try to approach 99% :-P
> > > > 
> > > > BTW, if this's a separate bug, I'd like to report a new bug to track
> it,
> > to
> > > > avoid confusion.
> > > > 
> > > > Thanks,
> > > > Zorro
> > > 
> > > Updata: By merging the patches in comment 2 and comment 9, I can't
> > reproduce
> > > this bug and https://bugzilla.kernel.org/show_bug.cgi?id=204031, after
> > > running generic/475 on six different machines 3 days.
> > 
> > Can you try with just the patch in comment 2? Also it doesn't seem clear to
> > me yet if this is a regression or not. Did this used to work? If not sure
> > can you try with v4.19 and see if the issue also appears there?
> 
> I didn't try to make sure if it's a regression or not. Due to
> 1. This bug is very hard to be reproduced.
> 2. The reproducer(generic/475) might easily to trigger some other issues on
> old kernel.
> 
> Any way, I'll give it a try on v4.19, but I can't promise that I can find
> out if it's a regression:)

v4.19 reproduced two different panic [1] and [2], but none of them same as
above issues:

[1]
[  591.414884] kasan: GPF could be caused by NULL-ptr deref or user memory
access 
[  591.422117] general protection fault: 0000 [#1] SMP KASAN PTI 
[  591.427869] CPU: 19 PID: 17963 Comm: xfsaild/dm-0 Tainted: G    B   W       
 4.19.0 #1 
[  591.435865] Hardware name: Dell Inc. PowerEdge R740/00WGD1, BIOS 1.3.7
02/08/2018 
[  591.443394] RIP: 0010:xfs_buf_free+0x20f/0x5b0 [xfs] 
[  591.448364] Code: 80 02 00 00 0f 86 60 01 00 00 41 80 7d 00 00 0f 85 ff 02
00 00 48 8b 8b 40 02 00 00 44 89 fa 48 8d 14 d1 48 89 d1 48 c1 e9 03 <42> 80 3c
21 00 0f 85 c8 02 00 00 48 8b 3a 31 f6 41 83 c7 01 e8 d8 
[  591.467108] RSP: 0018:ffff880101e3fab0 EFLAGS: 00010246 
[  591.472334] RAX: 0000000000000000 RBX: ffff880001980680 RCX:
0000000000000000 
[  591.479466] RDX: 0000000000000000 RSI: 0000000000000008 RDI:
ffff8800019808c0 
[  591.486602] RBP: ffffed0000330120 R08: ffffed0005a681a1 R09:
ffffed0005a681a0 
[  591.493730] R10: ffffed0005a681a0 R11: ffff88002d340d03 R12:
dffffc0000000000 
[  591.500862] R13: ffffed0000330118 R14: ffff880001980900 R15:
0000000000000000 
[  591.507997] FS:  0000000000000000(0000) GS:ffff880119e00000(0000)
knlGS:0000000000000000 
[  591.516081] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  591.521827] CR2: 00007f39c4ebd228 CR3: 0000000013216002 CR4:
00000000007606e0 
[  591.528961] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000 
[  591.536094] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400 
[  591.543225] PKRU: 55555554 
[  591.545936] Call Trace: 
[  591.548438]  xfs_buf_rele+0x2f8/0xc80 [xfs] 
[  591.552672]  ? xfs_buf_hold+0x280/0x280 [xfs] 
[  591.557072]  ? xfs_buf_unlock+0x1ea/0x2d0 [xfs] 
[  591.561647]  ? __xfs_buf_submit+0x687/0x730 [xfs] 
[  591.566395]  ? xfs_buf_ioend+0x446/0x6f0 [xfs] 
[  591.570886]  __xfs_buf_submit+0x687/0x730 [xfs] 
[  591.575460]  ? xfs_buf_delwri_submit_buffers+0x36b/0xaa0 [xfs] 
[  591.581328]  xfs_buf_delwri_submit_buffers+0x36b/0xaa0 [xfs] 
[  591.587036]  ? xfsaild+0x94a/0x25a0 [xfs] 
[  591.591088]  ? xfs_bwrite+0x150/0x150 [xfs] 
[  591.595319]  ? xfs_iunlock+0x310/0x480 [xfs] 
[  591.599637]  ? xfsaild+0x940/0x25a0 [xfs] 
[  591.603697]  xfsaild+0x94a/0x25a0 [xfs] 
[  591.607542]  ? finish_task_switch+0xfc/0x6c0 
[  591.611860]  ? xfs_trans_ail_cursor_first+0x180/0x180 [xfs] 
[  591.617439]  ? lock_downgrade+0x5e0/0x5e0 
[  591.621450]  ? __kthread_parkme+0x59/0x180 
[  591.625553]  ? __kthread_parkme+0xb6/0x180 
[  591.629699]  ? xfs_trans_ail_cursor_first+0x180/0x180 [xfs] 
[  591.635273]  kthread+0x31a/0x3e0 
[  591.638505]  ? kthread_create_worker_on_cpu+0xc0/0xc0 
[  591.643558]  ret_from_fork+0x3a/0x50 
[  591.647140] Modules linked in: dm_mod iTCO_wdt iTCO_vendor_support dcdbas
intel_rapl skx_edac nfit x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
intel_cstate intel_uncore intel_rapl_perf dax_pmem device_dax nd_pmem pcspkr sg
i2c_i801 ipmi_ssif mei_me lpc_ich mei ipmi_si ipmi_devintf ipmi_msghandler
acpi_power_meter sunrpc ext4 mbcache vfat jbd2 fat xfs libcrc32c sr_mod cdrom
sd_mod crc32c_intel mgag200 i2c_algo_bit drm_kms_helper mlx5_core syscopyarea
sysfillrect sysimgblt fb_sys_fops ttm ahci ixgbe libahci mdio i40e drm
megaraid_sas libata dca tg3 mlxfw 
[  591.702756] ---[ end trace e658cafc4d56a43f ]--- 

[2]
[  852.300021] kasan: CONFIG_KASAN_INLINE enabled 
[  852.304474] kasan: GPF could be caused by NULL-ptr deref or user memory
access 
[  852.311699] general protection fault: 0000 [#1] SMP KASAN PTI 
[  852.317444] CPU: 3 PID: 18390 Comm: fsstress Tainted: G        W        
4.19.0 #1 
[  852.325010] Hardware name: Supermicro SYS-1018R-WR/X10SRW-F, BIOS 2.0
12/17/2015 
[  852.332464] RIP: 0010:xfs_trans_brelse+0xe7/0x560 [xfs] 
[  852.337690] Code: 83 7e 03 00 00 89 ed 48 0f a3 2d 74 d0 44 f2 0f 82 bc 02
00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 38 48 89 fa 48 c1 ea 03 <0f> b6 04
02 84 c0 74 08 3c 03 0f 8e f2 03 00 00 81 7b 38 3c 12 00 
[  852.356434] RSP: 0018:ffff8800402b78d8 EFLAGS: 00010202 
[  852.361660] RAX: dffffc0000000000 RBX: 0000000000000000 RCX:
0000000000000000 
[  852.368786] RDX: 0000000000000007 RSI: 000000000000000a RDI:
0000000000000038 
[  852.375910] RBP: 0000000000000003 R08: ffffed002307d0e1 R09:
ffffed002307d0e0 
[  852.383042] R10: ffffed002307d0e0 R11: ffff8801183e8707 R12:
ffff880015e74ac0 
[  852.390165] R13: 0000000000000007 R14: ffff880015e74cf8 R15:
ffff8800073e3a00 
[  852.397292] FS:  00007fe0d67d7b80(0000) GS:ffff880118200000(0000)
knlGS:0000000000000000 
[  852.405376] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  852.411115] CR2: 0000000000dfd000 CR3: 0000000009860002 CR4:
00000000003606e0 
[  852.418238] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000 
[  852.425363] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400 
[  852.432495] Call Trace: 
[  852.434996]  xfs_attr_set+0x81c/0xa90 [xfs] 
[  852.439214]  ? xfs_attr_get+0x530/0x530 [xfs] 
[  852.443576]  ? avc_has_perm+0xa5/0x4b0 
[  852.447330]  ? mark_held_locks+0x140/0x140 
[  852.451427]  ? avc_has_perm+0x283/0x4b0 
[  852.455267]  ? avc_has_perm_noaudit+0x480/0x480 
[  852.459800]  ? lock_downgrade+0x5e0/0x5e0 
[  852.463816]  ? creds_are_invalid+0x43/0xd0 
[  852.467974]  xfs_xattr_set+0x75/0xe0 [xfs] 
[  852.472074]  __vfs_setxattr+0xd0/0x130 
[  852.475824]  ? xattr_resolve_name+0x4e0/0x4e0 
[  852.480186]  __vfs_setxattr_noperm+0xe7/0x390 
[  852.484543]  vfs_setxattr+0xa3/0xd0 
[  852.488035]  setxattr+0x182/0x240 
[  852.491355]  ? vfs_setxattr+0xd0/0xd0 
[  852.495022]  ? filename_lookup.part.31+0x1f1/0x360 
[  852.499815]  ? mark_held_locks+0x140/0x140 
[  852.503916]  ? filename_parentat.part.30+0x3e0/0x3e0 
[  852.508882]  ? lock_acquire+0x14f/0x3b0 
[  852.512718]  ? mnt_want_write+0x3c/0xa0 
[  852.516560]  ? rcu_sync_lockdep_assert+0xf/0x110 
[  852.521178]  ? __sb_start_write+0x1b2/0x260 
[  852.525366]  path_setxattr+0x11b/0x130 
[  852.529118]  ? setxattr+0x240/0x240 
[  852.532610]  ? __audit_syscall_exit+0x76b/0xa90 
[  852.537143]  __x64_sys_setxattr+0xc0/0x160 
[  852.541244]  do_syscall_64+0xa5/0x4a0 
[  852.544908]  entry_SYSCALL_64_after_hwframe+0x49/0xbe 
[  852.549959] RIP: 0033:0x7fe0d5ccd38e 
[  852.553530] Code: 48 8b 0d fd 2a 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e
0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 bc 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d ca 2a 2c 00 f7 d8 64 89 01 48 
[  852.572277] RSP: 002b:00007ffd90fb1ce8 EFLAGS: 00000206 ORIG_RAX:
00000000000000bc 
[  852.579843] RAX: ffffffffffffffda RBX: 0000000000000050 RCX:
00007fe0d5ccd38e 
[  852.586968] RDX: 0000000000d3da40 RSI: 00007ffd90fb1d10 RDI:
0000000000d2d3e0 
[  852.594100] RBP: 0000000000000001 R08: 0000000000000002 R09:
00007ffd90fb1a57 
[  852.601224] R10: 0000000000000050 R11: 0000000000000206 R12:
0000000000000002 
[  852.608348] R13: 00000000000001ab R14: 0000000000d3da40 R15:
0000000000000050 
[  852.615477] Modules linked in: sunrpc ext4 mbcache jbd2 iTCO_wdt
iTCO_vendor_support intel_rapl sb_edac x86_pkg_temp_thermal coretemp kvm_intel
kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate
intel_uncore intel_rapl_perf pcspkr dax_pmem nd_pmem device_dax i2c_i801
lpc_ich ioatdma joydev mei_me sg mei wmi ipmi_ssif ipmi_si ipmi_devintf
ipmi_msghandler acpi_power_meter xfs libcrc32c dm_service_time sd_mod ast
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm
crc32c_intel ahci libahci igb mpt3sas libata raid_class dca scsi_transport_sas
i2c_algo_bit dm_multipath dm_mirror dm_region_hash dm_log dm_mod 
[  852.672554] ---[ end trace 10bad956ab83813f ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
