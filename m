Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0L1LHGI042833 for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 19:21:18 -0600
Message-ID: <4B57ADB4.70002@kernel.org>
Date: Thu, 21 Jan 2010 10:28:20 +0900
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Subject: Circular locking dependency warning involing xfs on 2.6.27
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: lkml <linux-kernel@vger.kernel.org>, Alex Elder <aelder@sgi.com>, xfs@oss.sgi.com
Cc: Carsten Aulbert <carsten.aulbert@aei.mpg.de>

Hello,

This is on a pretty old kernel but Carsten reports that it happens
occassionally in a pretty large setup involving 1500+ machines (please
feel free to fill in).  This happens pretty sporadically so reporting
it just in case this is a yet unknown problem.  As I understand it,
testing with newer kernel isn't out of question but it being a
production environment, not a very easy thing.

Thanks.

[12207.016809] =======================================================
[12207.021881] [ INFO: possible circular locking dependency detected ]
[12207.021881] 2.6.27.43-atlas-generic #1
[12207.021881] -------------------------------------------------------
[12207.231253] inspiralSensMon/8833 is trying to acquire lock:
[12207.231253]  (iprune_mutex){--..}, at: [<ffffffff802b14df>] shrink_icache_memory+0x4b/0x23b
[12207.231253]
[12207.231253] but task is already holding lock:
[12207.231253]  (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffff8038edd8>] xfs_ilock+0x44/0x79
[12207.231253]
[12207.231253] which lock already depends on the new lock.
[12207.231253]
[12207.231253]
[12207.231253] the existing dependency chain (in reverse order) is:
[12207.231253]
[12207.231253] -> #1 (&(&ip->i_iolock)->mr_lock){----}:
[12207.231253]        [<ffffffff8025cdc8>] __lock_acquire+0x12a7/0x15bc
[12207.231253]        [<ffffffff8025d16a>] lock_acquire+0x8d/0xba
[12207.231253]        [<ffffffff80252a29>] down_write_nested+0x2a/0x36
[12207.231253]        [<ffffffff8038edbb>] xfs_ilock+0x27/0x79
[12207.231253]        [<ffffffff8038ef5c>] xfs_ireclaim+0x41/0x87
[12207.231253]        [<ffffffff803a73ef>] xfs_finish_reclaim+0x142/0x150
[12207.231253]        [<ffffffff803a754d>] xfs_reclaim+0x77/0xfc
[12207.231253]        [<ffffffff803b3b20>] xfs_fs_clear_inode+0xe2/0x106
[12207.231253]        [<ffffffff802b11a4>] clear_inode+0x71/0xca
[12207.231253]        [<ffffffff802b13e1>] dispose_list+0x5b/0x10e
[12207.231253]        [<ffffffff802b1699>] shrink_icache_memory+0x205/0x23b
[12207.231253]        [<ffffffff80282797>] shrink_slab+0xe3/0x158
[12207.231253]        [<ffffffff80282c1a>] kswapd+0x40e/0x572
[12207.231253]        [<ffffffff8024f409>] kthread+0x49/0x76
[12207.231253]        [<ffffffff80211ab9>] child_rip+0xa/0x11
[12207.231253]        [<ffffffffffffffff>] 0xffffffffffffffff
[12207.231253]
[12207.231253] -> #0 (iprune_mutex){--..}:
[12207.231253]        [<ffffffff8025cadd>] __lock_acquire+0xfbc/0x15bc
[12207.231253]        [<ffffffff8025d16a>] lock_acquire+0x8d/0xba
[12207.231253]        [<ffffffff805f3a50>] mutex_lock_nested+0xe3/0x28a
[12207.231253]        [<ffffffff802b14df>] shrink_icache_memory+0x4b/0x23b
[12207.231253]        [<ffffffff80282797>] shrink_slab+0xe3/0x158
[12207.231253]        [<ffffffff802832f0>] try_to_free_pages+0x227/0x313
[12207.231253]        [<ffffffff8027dbc6>] __alloc_pages_internal+0x261/0x40c
[12207.231253]        [<ffffffff8027f9c2>] __do_page_cache_readahead+0xf0/0x1f7
[12207.231253]        [<ffffffff8027fe26>] ondemand_readahead+0x1cf/0x1e4
[12207.231253]        [<ffffffff8027feb3>] page_cache_async_readahead+0x78/0x84
[12207.231253]        [<ffffffff80279dc9>] generic_file_aio_read+0x27d/0x5d6
[12207.231253]        [<ffffffff803b3609>] xfs_read+0x18e/0x205
[12207.231253]        [<ffffffff803af838>] xfs_file_aio_read+0x51/0x53
[12207.231253]        [<ffffffff8029d42b>] do_sync_read+0xe7/0x12d
[12207.231253]        [<ffffffff8029ddb2>] vfs_read+0xab/0x134
[12207.231253]        [<ffffffff8029deff>] sys_read+0x47/0x6f
[12207.231253]        [<ffffffff8021055a>] system_call_fastpath+0x16/0x1b
[12207.231253]        [<ffffffffffffffff>] 0xffffffffffffffff
[12207.231253]
[12207.231253] other info that might help us debug this:
[12207.231253]
[12207.231253] 2 locks held by inspiralSensMon/8833:
[12207.231253]  #0:  (&(&ip->i_iolock)->mr_lock){----}, at:
[<ffffffff8038edd8>] xfs_ilock+0x44/0x79
[12207.231253]  #1:  (shrinker_rwsem){----}, at: [<ffffffff802826ec>] shrink_slab+0x38/0x158
[12207.231253]
[12207.231253] stack backtrace:
[12207.231253] Pid: 8833, comm: inspiralSensMon Not tainted 2.6.27.43-atlas-generic #1
[12207.231253]
[12207.231253] Call Trace:
[12207.231253]  [<ffffffff8025b763>] print_circular_bug_tail+0xb8/0xc3
[12207.231253]  [<ffffffff8025cadd>] __lock_acquire+0xfbc/0x15bc
[12207.231253]  [<ffffffff8025d16a>] lock_acquire+0x8d/0xba
[12207.231253]  [<ffffffff802b14df>] ? shrink_icache_memory+0x4b/0x23b
[12207.231253]  [<ffffffff805f3a50>] mutex_lock_nested+0xe3/0x28a
[12207.231253]  [<ffffffff802b14df>] ? shrink_icache_memory+0x4b/0x23b
[12207.231253]  [<ffffffff802b14df>] ? shrink_icache_memory+0x4b/0x23b
[12207.231253]  [<ffffffff802b14df>] shrink_icache_memory+0x4b/0x23b
[12207.231253]  [<ffffffff80282797>] shrink_slab+0xe3/0x158
[12207.231253]  [<ffffffff802832f0>] try_to_free_pages+0x227/0x313
[12207.231253]  [<ffffffff80281464>] ? isolate_pages_global+0x0/0x34
[12207.231253]  [<ffffffff8027dbc6>] __alloc_pages_internal+0x261/0x40c
[12207.231253]  [<ffffffff8027f9c2>] __do_page_cache_readahead+0xf0/0x1f7
[12207.231253]  [<ffffffff8027f94d>] ? __do_page_cache_readahead+0x7b/0x1f7
[12207.231253]  [<ffffffff8027fe26>] ondemand_readahead+0x1cf/0x1e4
[12207.231253]  [<ffffffff8027feb3>] page_cache_async_readahead+0x78/0x84
[12207.231253]  [<ffffffff80278095>] ? find_get_page+0x0/0xc9
[12207.231253]  [<ffffffff80279dc9>] generic_file_aio_read+0x27d/0x5d6
[12207.231253]  [<ffffffff8038edd8>] ? xfs_ilock+0x44/0x79
[12207.231253]  [<ffffffff803b3609>] xfs_read+0x18e/0x205
[12207.231253]  [<ffffffff803af838>] xfs_file_aio_read+0x51/0x53
[12207.231253]  [<ffffffff8029d42b>] do_sync_read+0xe7/0x12d
[12207.231253]  [<ffffffff803e399c>] ? __up_write+0x29/0x11e
[12207.231253]  [<ffffffff8024f74a>] ? autoremove_wake_function+0x0/0x38
[12207.231253]  [<ffffffff8025b1d2>] ? trace_hardirqs_on_caller+0xf7/0x11b
[12207.231253]  [<ffffffff803e3a82>] ? __up_write+0x10f/0x11e
[12207.231253]  [<ffffffff803c49b4>] ? security_file_permission+0x11/0x13
[12207.231253]  [<ffffffff8029ddb2>] vfs_read+0xab/0x134
[12207.231253]  [<ffffffff8029deff>] sys_read+0x47/0x6f
[12207.231253]  [<ffffffff8021055a>] system_call_fastpath+0x16/0x1b

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
