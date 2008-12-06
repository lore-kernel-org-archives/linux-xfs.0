Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB7DW2Z8009085 for <xfs@oss.sgi.com>; Sun, 7 Dec 2008 07:32:02 -0600
Received: from mga14.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2849D16D621A
	for <xfs@oss.sgi.com>; Sun,  7 Dec 2008 05:32:00 -0800 (PST)
Received: from mga14.intel.com (mga14.intel.com [143.182.124.37]) by
	cuda.sgi.com with ESMTP id SkD17YpPUgQFqF7k for
	<xfs@oss.sgi.com>; Sun, 07 Dec 2008 05:32:00 -0800 (PST)
Date: Sat, 6 Dec 2008 21:20:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
Subject: xfs: possible circular locking dependency detected
Message-ID: <20081206132023.GA21235@localhost>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: David Chinner <dgc@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi Dave,

I got this warning while accessing xfs on usb storage.
Is this a real problem?

Thanks,
Fengguang

 =======================================================
 [ INFO: possible circular locking dependency detected ]
 2.6.28-rc7 #85
 -------------------------------------------------------
 rsync/20106 is trying to acquire lock:
  (iprune_mutex){--..}, at: [<ffffffff811070a4>] shrink_icache_memory+0x84/0x290

 but task is already holding lock:
  (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffffa030fcc5>] xfs_ilock+0x75/0xb0 [xfs]

 which lock already depends on the new lock.


 the existing dependency chain (in reverse order) is:

 -> #1 (&(&ip->i_iolock)->mr_lock){----}:
        [<ffffffff810799b2>] __lock_acquire+0x12e2/0x18c0
        [<ffffffff8107a029>] lock_acquire+0x99/0xd0
        [<ffffffff8106a937>] down_write_nested+0x57/0x90
        [<ffffffffa030fcf5>] xfs_ilock+0xa5/0xb0 [xfs]
        [<ffffffffa030fea6>] xfs_ireclaim+0x46/0x90 [xfs]
        [<ffffffffa032d8de>] xfs_finish_reclaim+0x5e/0x1a0 [xfs]
        [<ffffffffa032dc3b>] xfs_reclaim+0x11b/0x120 [xfs]
        [<ffffffffa033cd4e>] xfs_fs_clear_inode+0xee/0x120 [xfs]
        [<ffffffff81106e50>] clear_inode+0x90/0x140
        [<ffffffff81106f38>] dispose_list+0x38/0x120
        [<ffffffff81107263>] shrink_icache_memory+0x243/0x290
        [<ffffffff810c3ae5>] shrink_slab+0x125/0x180
        [<ffffffff810c4362>] kswapd+0x542/0x6a0
        [<ffffffff8106610e>] kthread+0x4e/0x90
        [<ffffffff8100dc99>] child_rip+0xa/0x11
        [<ffffffffffffffff>] 0xffffffffffffffff

 -> #0 (iprune_mutex){--..}:
        [<ffffffff81079aff>] __lock_acquire+0x142f/0x18c0
        [<ffffffff8107a029>] lock_acquire+0x99/0xd0
        [<ffffffff8148220e>] mutex_lock_nested+0xce/0x320
        [<ffffffff811070a4>] shrink_icache_memory+0x84/0x290
        [<ffffffff810c3ae5>] shrink_slab+0x125/0x180
        [<ffffffff810c4b46>] try_to_free_pages+0x286/0x3f0
        [<ffffffff810bcba5>] __alloc_pages_internal+0x255/0x5b0
        [<ffffffff810e275b>] alloc_pages_current+0x7b/0x100
        [<ffffffff810b5340>] __page_cache_alloc+0x10/0x20
        [<ffffffff810bf0e8>] __do_page_cache_readahead+0x138/0x250
        [<ffffffff810bf2df>] ondemand_readahead+0xdf/0x3c0
        [<ffffffff810bf669>] page_cache_async_readahead+0xa9/0xc0
        [<ffffffff810b5e39>] do_generic_file_read+0x259/0x4d0
        [<ffffffff810b6ff0>] generic_file_aio_read+0xd0/0x1c0
        [<ffffffffa033c5ea>] xfs_read+0x12a/0x280 [xfs]
        [<ffffffffa0337c46>] xfs_file_aio_read+0x56/0x60 [xfs]
        [<ffffffff810f1459>] do_sync_read+0xf9/0x140
        [<ffffffff810f20c8>] vfs_read+0xc8/0x180
        [<ffffffff810f2285>] sys_read+0x55/0x90
        [<ffffffff8100c62a>] system_call_fastpath+0x16/0x1b
        [<ffffffffffffffff>] 0xffffffffffffffff

 other info that might help us debug this:

 2 locks held by rsync/20106:
  #0:  (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffffa030fcc5>] xfs_ilock+0x75/0xb0 [xfs]
  #1:  (shrinker_rwsem){----}, at: [<ffffffff810c39f7>] shrink_slab+0x37/0x180

 stack backtrace:
 Pid: 20106, comm: rsync Not tainted 2.6.28-rc7 #85
 Call Trace:
  [<ffffffff81078298>] print_circular_bug_tail+0xd8/0xe0
  [<ffffffff81079aff>] __lock_acquire+0x142f/0x18c0
  [<ffffffff810c0576>] ? __pagevec_release+0x26/0x40
  [<ffffffff8107a029>] lock_acquire+0x99/0xd0
  [<ffffffff811070a4>] ? shrink_icache_memory+0x84/0x290
  [<ffffffff8148220e>] mutex_lock_nested+0xce/0x320
  [<ffffffff811070a4>] ? shrink_icache_memory+0x84/0x290
  [<ffffffff811070a4>] ? shrink_icache_memory+0x84/0x290
  [<ffffffff811070a4>] shrink_icache_memory+0x84/0x290
  [<ffffffff810c3ae5>] shrink_slab+0x125/0x180
  [<ffffffff810c4b46>] try_to_free_pages+0x286/0x3f0
  [<ffffffff810c1640>] ? isolate_pages_global+0x0/0x260
  [<ffffffff810bcba5>] __alloc_pages_internal+0x255/0x5b0
  [<ffffffff810e275b>] alloc_pages_current+0x7b/0x100
  [<ffffffff810b5340>] __page_cache_alloc+0x10/0x20
  [<ffffffff810bf0e8>] __do_page_cache_readahead+0x138/0x250
  [<ffffffff810bf07a>] ? __do_page_cache_readahead+0xca/0x250
  [<ffffffff810bf2df>] ondemand_readahead+0xdf/0x3c0
  [<ffffffff81013e49>] ? sched_clock+0x9/0x10
  [<ffffffff810bf669>] page_cache_async_readahead+0xa9/0xc0
  [<ffffffff810b5e39>] do_generic_file_read+0x259/0x4d0
  [<ffffffff810b47a0>] ? file_read_actor+0x0/0x190
  [<ffffffff810b6ff0>] generic_file_aio_read+0xd0/0x1c0
  [<ffffffffa030fcc5>] ? xfs_ilock+0x75/0xb0 [xfs]
  [<ffffffffa033c5ea>] xfs_read+0x12a/0x280 [xfs]
  [<ffffffffa0337c46>] xfs_file_aio_read+0x56/0x60 [xfs]
  [<ffffffff810f1459>] do_sync_read+0xf9/0x140
  [<ffffffff81066560>] ? autoremove_wake_function+0x0/0x40
  [<ffffffff811ecdaf>] ? _raw_spin_unlock+0x7f/0xb0
  [<ffffffff81483f9d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
  [<ffffffff810f20c8>] vfs_read+0xc8/0x180
  [<ffffffff810f2285>] sys_read+0x55/0x90
  [<ffffffff8100c62a>] system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
