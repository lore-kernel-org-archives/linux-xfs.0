Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45946 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725796AbfAaO4T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 09:56:19 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A61F3312D5
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 14:56:18 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202349] Extreme desktop freezes during sustained write
 operations with XFS
Date: Thu, 31 Jan 2019 14:56:16 +0000
Message-ID: <bug-202349-201763-n6IPRYZHBi@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202349-201763@https.bugzilla.kernel.org/>
References: <bug-202349-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202349

--- Comment #12 from nfxjfg@googlemail.com ---
So I tried on the following kernel versions: 4.19.19 4.19.16 4.19.0 4.18.20
4.16.14
It happened on all of them.

Reproduction is a bit spotty. The script I first posted doesn't work reliably
anymore. I guess it depends on the kind and amount of memory pressure.

Despite hard reproduction, it's not an obscure issue. I've also hit it when
compiling the kernel on a XFS filesystem on a hard disk.

My reproduction steps are now as following (and yes they're absurd):

- run memtester 12G (make sure "free memory" as shown in top goes to very low
while running the test)
- start video playback (I used mpv with some random 720p video)
- run test.sh (maybe until 100k files)
- run sync
- run rm -rf /mnt/tmp1/tests/
- switch to another virtual desktop with lots of firefox windows (yeah...), and
switch back
- video playback gets noticeably interrupted for a moment

This happened even on 4.16.14.

dmesg except when I "caught" it again on 4.19.19 (there's nothing new I guess):

[  250.656494] sysrq: SysRq : Show Blocked State
[  250.656505]   task                        PC stack   pid father
[  250.656581] kswapd0         D    0    91      2 0x80000000
[  250.656585] Call Trace:
[  250.656600]  ? __schedule+0x23d/0x830
[  250.656604]  schedule+0x28/0x80
[  250.656608]  schedule_timeout+0x23e/0x360
[  250.656612]  wait_for_completion+0xeb/0x150
[  250.656617]  ? wake_up_q+0x70/0x70
[  250.656623]  ? __xfs_buf_submit+0x112/0x230
[  250.656625]  ? xfs_bwrite+0x25/0x60
[  250.656628]  xfs_buf_iowait+0x22/0xc0
[  250.656631]  __xfs_buf_submit+0x112/0x230
[  250.656633]  xfs_bwrite+0x25/0x60
[  250.656637]  xfs_reclaim_inode+0x2e5/0x310
[  250.656640]  xfs_reclaim_inodes_ag+0x19e/0x2d0
[  250.656645]  xfs_reclaim_inodes_nr+0x31/0x40
[  250.656650]  super_cache_scan+0x14c/0x1a0
[  250.656656]  do_shrink_slab+0x129/0x270
[  250.656660]  shrink_slab+0x201/0x280
[  250.656663]  shrink_node+0xd6/0x420
[  250.656666]  kswapd+0x3d3/0x6c0
[  250.656670]  ? mem_cgroup_shrink_node+0x140/0x140
[  250.656674]  kthread+0x110/0x130
[  250.656677]  ? kthread_create_worker_on_cpu+0x40/0x40
[  250.656680]  ret_from_fork+0x24/0x30
[  250.656785] Xorg            D    0   850    836 0x00400004
[  250.656789] Call Trace:
[  250.656792]  ? __schedule+0x23d/0x830
[  250.656795]  schedule+0x28/0x80
[  250.656798]  schedule_preempt_disabled+0xa/0x10
[  250.656801]  __mutex_lock.isra.5+0x28b/0x460
[  250.656806]  ? xfs_perag_get_tag+0x2d/0xc0
[  250.656808]  xfs_reclaim_inodes_ag+0x286/0x2d0
[  250.656811]  ? isolate_lru_pages.isra.55+0x34f/0x400
[  250.656817]  ? list_lru_add+0xb2/0x190
[  250.656819]  ? list_lru_isolate_move+0x40/0x60
[  250.656824]  ? iput+0x1f0/0x1f0
[  250.656827]  xfs_reclaim_inodes_nr+0x31/0x40
[  250.656829]  super_cache_scan+0x14c/0x1a0
[  250.656832]  do_shrink_slab+0x129/0x270
[  250.656836]  shrink_slab+0x144/0x280
[  250.656838]  shrink_node+0xd6/0x420
[  250.656841]  do_try_to_free_pages+0xb6/0x350
[  250.656844]  try_to_free_pages+0xce/0x180
[  250.656856]  __alloc_pages_slowpath+0x347/0xc70
[  250.656863]  __alloc_pages_nodemask+0x25c/0x280
[  250.656875]  ttm_pool_populate+0x25e/0x480 [ttm]
[  250.656880]  ? kmalloc_large_node+0x37/0x60
[  250.656883]  ? __kmalloc_node+0x204/0x2a0
[  250.656891]  ttm_populate_and_map_pages+0x24/0x250 [ttm]
[  250.656899]  ttm_tt_populate.part.9+0x1b/0x60 [ttm]
[  250.656907]  ttm_tt_bind+0x42/0x60 [ttm]
[  250.656915]  ttm_bo_handle_move_mem+0x258/0x4e0 [ttm]
[  250.656995]  ? amdgpu_bo_subtract_pin_size+0x50/0x50 [amdgpu]
[  250.657003]  ttm_bo_validate+0xe7/0x110 [ttm]
[  250.657079]  ? amdgpu_bo_subtract_pin_size+0x50/0x50 [amdgpu]
[  250.657105]  ? drm_vma_offset_add+0x46/0x50 [drm]
[  250.657113]  ttm_bo_init_reserved+0x342/0x380 [ttm]
[  250.657189]  amdgpu_bo_do_create+0x19c/0x400 [amdgpu]
[  250.657266]  ? amdgpu_bo_subtract_pin_size+0x50/0x50 [amdgpu]
[  250.657269]  ? try_to_wake_up+0x44/0x450
[  250.657343]  amdgpu_bo_create+0x30/0x200 [amdgpu]
[  250.657349]  ? cpumask_next_wrap+0x2c/0x70
[  250.657352]  ? sched_clock_cpu+0xc/0xb0
[  250.657355]  ? select_idle_sibling+0x293/0x3a0
[  250.657431]  amdgpu_gem_object_create+0x8b/0x110 [amdgpu]
[  250.657509]  amdgpu_gem_create_ioctl+0x1d0/0x290 [amdgpu]
[  250.657516]  ? tracing_record_taskinfo_skip+0x40/0x50
[  250.657518]  ? tracing_record_taskinfo+0xe/0xa0
[  250.657594]  ? amdgpu_gem_object_close+0x1c0/0x1c0 [amdgpu]
[  250.657614]  drm_ioctl_kernel+0x7f/0xd0 [drm]
[  250.657619]  ? sock_sendmsg+0x30/0x40
[  250.657639]  drm_ioctl+0x1e4/0x380 [drm]
[  250.657715]  ? amdgpu_gem_object_close+0x1c0/0x1c0 [amdgpu]
[  250.657720]  ? do_futex+0x2a1/0xa30
[  250.657802]  amdgpu_drm_ioctl+0x49/0x80 [amdgpu]
[  250.657828]  do_vfs_ioctl+0x8d/0x5d0
[  250.657832]  ? __x64_sys_futex+0x133/0x15b
[  250.657835]  ksys_ioctl+0x60/0x90
[  250.657838]  __x64_sys_ioctl+0x16/0x20
[  250.657842]  do_syscall_64+0x4a/0xd0
[  250.657845]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  250.657849] RIP: 0033:0x7f12b52dc747
[  250.657855] Code: Bad RIP value.
[  250.657856] RSP: 002b:00007ffceccab168 EFLAGS: 00003246 ORIG_RAX:
0000000000000010
[  250.657860] RAX: ffffffffffffffda RBX: 00007ffceccab250 RCX:
00007f12b52dc747
[  250.657861] RDX: 00007ffceccab1c0 RSI: 00000000c0206440 RDI:
000000000000000e
[  250.657863] RBP: 00007ffceccab1c0 R08: 0000559b8f644890 R09:
00007f12b53a7cb0
[  250.657864] R10: 0000559b8e72a010 R11: 0000000000003246 R12:
00000000c0206440
[  250.657865] R13: 000000000000000e R14: 0000559b8e7bf500 R15:
0000559b8f644890


Also I noticed some more bad behavior. When I copied hundreds of gigabytes from
a SSD block device to a XFS file system on a HDD, I got _severe_ problems with
tasks hanging. They got stuck in something like io_scheduler (I don't think I
have the log anymore; could probably reproduce if needed). This was also a
"desktop randomly freezes on heavy background I/O". Although the freezes were
worse (waiting for up to a minute for small I/O to finish!), it's overall not
as bad as the one this bug is about, because most hangs seemed to be about
accesses to the same filesystem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
