Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 12 Jan 2008 17:46:52 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0D1kjmI021289
	for <xfs@oss.sgi.com>; Sat, 12 Jan 2008 17:46:47 -0800
Received: from ns1.anodized.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E57F3512BF0
	for <xfs@oss.sgi.com>; Sat, 12 Jan 2008 17:47:01 -0800 (PST)
Received: from ns1.anodized.com (ns1.anodized.com [204.15.208.61]) by cuda.sgi.com with ESMTP id oaIBHPtLJVFurhrY for <xfs@oss.sgi.com>; Sat, 12 Jan 2008 17:47:01 -0800 (PST)
Received: from ns1.anodized.com (localhost [127.0.0.1])
	by ns1.anodized.com (8.13.1/8.13.1) with ESMTP id m0D1l0XH031205
	for <xfs@oss.sgi.com>; Sat, 12 Jan 2008 17:47:00 -0800
Received: (from clayne@localhost)
	by ns1.anodized.com (8.13.1/8.13.1/Submit) id m0D1l0Ql031202
	for xfs@oss.sgi.com; Sat, 12 Jan 2008 17:47:00 -0800
Date: Sat, 12 Jan 2008 17:46:59 -0800
From: Christopher Layne <clayne@anodized.com>
Subject: xfs_fsr: circular dependency under 2.6.24-rc6
Message-ID: <20080113014659.GO26626@ns1.anodized.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.24-rc6 #1
-------------------------------------------------------
xfs_fsr/5694 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<ffffffff802a9f8f>] dio_get_page+0x4b/0x184

but task is already holding lock:
 (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffff802f4c5f>] xfs_ilock+0x4d/0x8d

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&(&ip->i_iolock)->mr_lock){----}:
       [<ffffffff80250f04>] __lock_acquire+0xb2b/0xd3f
       [<ffffffff802f4c38>] xfs_ilock+0x26/0x8d
       [<ffffffff8025119c>] lock_acquire+0x84/0xa8
       [<ffffffff802f4c38>] xfs_ilock+0x26/0x8d
       [<ffffffff8024fd51>] mark_held_locks+0x58/0x72
       [<ffffffff802497c2>] down_write_nested+0x39/0x45
       [<ffffffff802f4c38>] xfs_ilock+0x26/0x8d
       [<ffffffff802f4e39>] xfs_ireclaim+0x37/0x7a
       [<ffffffff8030ec2b>] xfs_finish_reclaim+0x15d/0x16b
       [<ffffffff8031b671>] xfs_fs_clear_inode+0xca/0xeb
       [<ffffffff80298535>] clear_inode+0x94/0xeb
       [<ffffffff80298835>] dispose_list+0x58/0xfa
       [<ffffffff80298bc4>] invalidate_inodes+0xd9/0xf7
       [<ffffffff80288381>] generic_shutdown_super+0x39/0xf3
       [<ffffffff80288448>] kill_block_super+0xd/0x1e
       [<ffffffff802884f3>] deactivate_super+0x49/0x61
       [<ffffffff8029addc>] sys_umount+0x1f5/0x206
       [<ffffffff80477917>] trace_hardirqs_on_thunk+0x35/0x3a
       [<ffffffff8024ff40>] trace_hardirqs_on+0x121/0x14c
       [<ffffffff80477917>] trace_hardirqs_on_thunk+0x35/0x3a
       [<ffffffff8020b6ce>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (iprune_mutex){--..}:
       [<ffffffff80250f04>] __lock_acquire+0xb2b/0xd3f
       [<ffffffff80298919>] shrink_icache_memory+0x42/0x214
       [<ffffffff8025119c>] lock_acquire+0x84/0xa8
       [<ffffffff80298919>] shrink_icache_memory+0x42/0x214
       [<ffffffff802510f7>] __lock_acquire+0xd1e/0xd3f
       [<ffffffff80298919>] shrink_icache_memory+0x42/0x214
       [<ffffffff80476bba>] mutex_lock_nested+0xfd/0x297
       [<ffffffff80295968>] prune_dcache+0xd8/0x184
       [<ffffffff80298919>] shrink_icache_memory+0x42/0x214
       [<ffffffff802694ff>] shrink_slab+0xe7/0x15a
       [<ffffffff8026a1eb>] try_to_free_pages+0x17a/0x24b
       [<ffffffff80264c7b>] __alloc_pages+0x208/0x34e
       [<ffffffff8026dcd0>] handle_mm_fault+0x211/0x66d
       [<ffffffff80479eda>] do_page_fault+0x3bd/0x743
       [<ffffffff80333ecb>] __up_write+0x21/0x112
       [<ffffffff80333ecb>] __up_write+0x21/0x112
       [<ffffffff80478124>] _spin_unlock_irqrestore+0x3e/0x44
       [<ffffffff80477917>] trace_hardirqs_on_thunk+0x35/0x3a
       [<ffffffff8024ff40>] trace_hardirqs_on+0x121/0x14c
       [<ffffffff8047834d>] error_exit+0x0/0xa9
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&mm->mmap_sem){----}:
       [<ffffffff80250e09>] __lock_acquire+0xa30/0xd3f
       [<ffffffff802a9f8f>] dio_get_page+0x4b/0x184
       [<ffffffff8025119c>] lock_acquire+0x84/0xa8
       [<ffffffff802a9f8f>] dio_get_page+0x4b/0x184
       [<ffffffff80476ed4>] down_read+0x32/0x3b
       [<ffffffff802a9f8f>] dio_get_page+0x4b/0x184
       [<ffffffff80338b47>] __spin_lock_init+0x29/0x47
       [<ffffffff802aaa7c>] __blockdev_direct_IO+0x3fc/0x9c6
       [<ffffffff8024e2f5>] lockdep_init_map+0x8f/0x460
       [<ffffffff803143de>] xfs_vm_direct_IO+0x101/0x134
       [<ffffffff803146ee>] xfs_get_blocks_direct+0x0/0x11
       [<ffffffff80313e95>] xfs_end_io_direct+0x0/0x82
       [<ffffffff80333ecb>] __up_write+0x21/0x112
       [<ffffffff8026022f>] generic_file_direct_IO+0xcd/0x103
       [<ffffffff802602c5>] generic_file_direct_write+0x60/0xfd
       [<ffffffff8031b1f9>] xfs_write+0x4ed/0x760
       [<ffffffff802f4bbf>] xfs_iunlock+0x37/0x85
       [<ffffffff8031aced>] xfs_read+0x1f1/0x210
       [<ffffffff8028637d>] do_sync_write+0xd1/0x118
       [<ffffffff802510f7>] __lock_acquire+0xd1e/0xd3f
       [<ffffffff80246df0>] autoremove_wake_function+0x0/0x2e
       [<ffffffff802b7cc5>] dnotify_parent+0x1f/0x6d
       [<ffffffff80286ace>] vfs_write+0xad/0x136
       [<ffffffff80287005>] sys_write+0x45/0x6e
       [<ffffffff8020b6ce>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by xfs_fsr/5694:
 #0:  (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffff802f4c5f>] xfs_ilock+0x4d/0x8d

stack backtrace:
Pid: 5694, comm: xfs_fsr Not tainted 2.6.24-rc6 #1

Call Trace:
 [<ffffffff8024f0b3>] print_circular_bug_tail+0x69/0x72
 [<ffffffff80250e09>] __lock_acquire+0xa30/0xd3f
 [<ffffffff802a9f8f>] dio_get_page+0x4b/0x184
 [<ffffffff8025119c>] lock_acquire+0x84/0xa8
 [<ffffffff802a9f8f>] dio_get_page+0x4b/0x184
 [<ffffffff80476ed4>] down_read+0x32/0x3b
 [<ffffffff802a9f8f>] dio_get_page+0x4b/0x184
 [<ffffffff80338b47>] __spin_lock_init+0x29/0x47
 [<ffffffff802aaa7c>] __blockdev_direct_IO+0x3fc/0x9c6
 [<ffffffff8024e2f5>] lockdep_init_map+0x8f/0x460
 [<ffffffff803143de>] xfs_vm_direct_IO+0x101/0x134
 [<ffffffff803146ee>] xfs_get_blocks_direct+0x0/0x11
 [<ffffffff80313e95>] xfs_end_io_direct+0x0/0x82
 [<ffffffff80333ecb>] __up_write+0x21/0x112
 [<ffffffff8026022f>] generic_file_direct_IO+0xcd/0x103
 [<ffffffff802602c5>] generic_file_direct_write+0x60/0xfd
 [<ffffffff8031b1f9>] xfs_write+0x4ed/0x760
 [<ffffffff802f4bbf>] xfs_iunlock+0x37/0x85
 [<ffffffff8031aced>] xfs_read+0x1f1/0x210
 [<ffffffff8028637d>] do_sync_write+0xd1/0x118
 [<ffffffff802510f7>] __lock_acquire+0xd1e/0xd3f
 [<ffffffff80246df0>] autoremove_wake_function+0x0/0x2e
 [<ffffffff802b7cc5>] dnotify_parent+0x1f/0x6d
 [<ffffffff80286ace>] vfs_write+0xad/0x136
 [<ffffffff80287005>] sys_write+0x45/0x6e
 [<ffffffff8020b6ce>] system_call+0x7e/0x83


--

xfs issue or kernel issue?

-cl
