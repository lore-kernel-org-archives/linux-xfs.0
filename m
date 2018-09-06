Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728047AbeIFUUQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Sep 2018 16:20:16 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 54954AC4F
        for <linux-xfs@vger.kernel.org>; Thu,  6 Sep 2018 15:44:09 +0000 (UTC)
From: Jeff Mahoney <jeffm@suse.com>
Subject: lockdep splat on 4.18.0
Message-ID: <e9324157-e423-d4d4-375b-6bd8f24c7c2a@suse.com>
Date: Thu, 6 Sep 2018 11:44:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks -

I hit this lockdep splat on 4.18.0 this morning (the + in the version is
due to btrfs patch; xfs is unmodified).  In my experience lockdep splats
involving mount are false positive, but Eric suggested I drop it here
just the same.

-Jeff

======================================================
WARNING: possible circular locking dependency detected
4.18.0-vanilla+ #8 Not tainted
------------------------------------------------------
kswapd0/56 is trying to acquire lock:
000000002f3c47dc (sb_internal){.+.+}, at: xfs_trans_alloc+0x19d/0x250 [xfs]

but task is already holding lock:
00000000e0553233 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x40

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (fs_reclaim){+.+.}:
       lock_acquire+0xbd/0x220
       __fs_reclaim_acquire+0x2c/0x40
       kmem_cache_alloc+0x2b/0x320
       kmem_zone_alloc+0x95/0x100 [xfs]
       xfs_trans_alloc+0x6f/0x250 [xfs]
       xlog_recover_process_intents+0x1f6/0x300 [xfs]
       xlog_recover_finish+0x18/0xa0 [xfs]
       xfs_log_mount_finish+0x6d/0x110 [xfs]
       xfs_mountfs+0x6f0/0xa40 [xfs]
       xfs_fs_fill_super+0x520/0x6e0 [xfs]
       mount_bdev+0x187/0x1c0
       mount_fs+0x3a/0x160
       vfs_kern_mount+0x66/0x150
       do_mount+0x1d9/0xcf0
       ksys_mount+0x7e/0xd0
       __x64_sys_mount+0x21/0x30
       do_syscall_64+0x5d/0x1a0
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (sb_internal){.+.+}:
       __lock_acquire+0x436/0x770
       lock_acquire+0xbd/0x220
       __sb_start_write+0x166/0x1d0
       xfs_trans_alloc+0x19d/0x250 [xfs]
       xfs_iomap_write_allocate+0x1d7/0x330 [xfs]
       xfs_map_blocks+0x2d7/0x550 [xfs]
       xfs_do_writepage+0x26b/0x7a0 [xfs]
       xfs_vm_writepage+0x28/0x50 [xfs]
       pageout.isra.51+0x1ca/0x450
       shrink_page_list+0x811/0xe30
       shrink_inactive_list+0x2e2/0x770
       shrink_node_memcg+0x32d/0x750
       shrink_node+0xc9/0x470
       balance_pgdat+0x175/0x360
       kswapd+0x181/0x5d0
       kthread+0xf8/0x130
       ret_from_fork+0x3a/0x50

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(sb_internal);
                               lock(fs_reclaim);
  lock(sb_internal);

 *** DEADLOCK ***

1 lock held by kswapd0/56:
 #0: 00000000e0553233 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x40

stack backtrace:
CPU: 0 PID: 56 Comm: kswapd0 Kdump: loaded Not tainted 4.18.0-vanilla+ #8
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.0.0-prebuilt.qemu-project.org 04/01/2014
Call Trace:
 dump_stack+0x78/0xb3
 print_circular_bug.isra.37+0x1f3/0x200
 check_prev_add.constprop.46+0x717/0x730
 validate_chain.isra.41+0x652/0x980
 __lock_acquire+0x436/0x770
 lock_acquire+0xbd/0x220
 ? xfs_trans_alloc+0x19d/0x250 [xfs]
 __sb_start_write+0x166/0x1d0
 ? xfs_trans_alloc+0x19d/0x250 [xfs]
 xfs_trans_alloc+0x19d/0x250 [xfs]
 xfs_iomap_write_allocate+0x1d7/0x330 [xfs]
 ? xfs_iext_lookup_extent+0x11f/0x140 [xfs]
 ? xfs_iunlock+0x132/0x2f0 [xfs]
 ? xfs_map_blocks+0x100/0x550 [xfs]
 xfs_map_blocks+0x2d7/0x550 [xfs]
 xfs_do_writepage+0x26b/0x7a0 [xfs]
 xfs_vm_writepage+0x28/0x50 [xfs]
 pageout.isra.51+0x1ca/0x450
 shrink_page_list+0x811/0xe30
 shrink_inactive_list+0x2e2/0x770
 shrink_node_memcg+0x32d/0x750
 shrink_node+0xc9/0x470
 balance_pgdat+0x175/0x360
 kswapd+0x181/0x5d0
 ? wait_woken+0x80/0x80
 kthread+0xf8/0x130
 ? balance_pgdat+0x360/0x360
 ? kthread_delayed_work_timer_fn+0x80/0x80
 ret_from_fork+0x3a/0x50


-- 
Jeff Mahoney
SUSE Labs
