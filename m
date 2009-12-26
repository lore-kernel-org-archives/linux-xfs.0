Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBQL784i082986 for <xfs@oss.sgi.com>; Sat, 26 Dec 2009 15:07:09 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A95AB1290C4
	for <xfs@oss.sgi.com>; Sat, 26 Dec 2009 13:07:51 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.187]) by cuda.sgi.com with ESMTP id
	jXc0fBnR0NeCHT8e for <xfs@oss.sgi.com>;
	Sat, 26 Dec 2009 13:07:51 -0800 (PST)
Date: Sat, 26 Dec 2009 13:07:49 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: lockdep: inconsistent lock state
Message-ID: <alpine.DEB.2.01.0912261255380.3483@bogon.housecafe.de>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com
Cc: LKML <linux-kernel@vger.kernel.org>

Hi,

during tests with bonnie++ on an XFS filesystem, the warning below is 
issued. From the message's timestamps, the warning occurs during the 
"Create files in sequential order" phase. I've put a few more details and 
the config here: http://nerdbynature.de/bits/2.6.33-rc2/xfs_ilock

Something similar has been reported in http://lkml.org/lkml/2009/2/20/269 
(for 2.6.29-rc5) and a fix for this false positive made its way into 
mainline as ed93ec3907f063268ced18728d0653f6199d100c - so I take it this 
is a different issue then?

Thanks,
Christian.

 =================================
 [ INFO: inconsistent lock state ]
 2.6.33-rc2 #1
 ---------------------------------
 inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
 kswapd1/245 [HC0[0]:SC0[0]:HE1:SE1] takes:
  (&(&ip->i_iolock)->mr_lock#2){++++?+}, at: [<ffffffff81252f25>] xfs_ilock+0x65/0xa0
 {RECLAIM_FS-ON-W} state was registered at:
   [<ffffffff810625d2>] mark_held_locks+0x72/0xa0
   [<ffffffff810626b0>] lockdep_trace_alloc+0xb0/0xe0
   [<ffffffff8108c69a>] __alloc_pages_nodemask+0x7a/0x6a0
   [<ffffffff810b3096>] alloc_pages_current+0x76/0xe0
   [<ffffffff81086b3b>] __page_cache_alloc+0xb/0x10
   [<ffffffff810883ca>] grab_cache_page_write_begin+0x7a/0xc0
   [<ffffffff810eda9c>] block_write_begin+0x8c/0x100
   [<ffffffff81272655>] xfs_vm_write_begin+0x25/0x30
   [<ffffffff8108634e>] generic_file_buffered_write+0xfe/0x260
   [<ffffffff8127a963>] xfs_write+0x903/0x9a0
   [<ffffffff812766c6>] xfs_file_aio_write+0x56/0x60
   [<ffffffff810c4c8a>] do_sync_write+0xca/0x110
   [<ffffffff810c4f20>] vfs_write+0xb0/0x170
   [<ffffffff810c570c>] sys_write+0x4c/0x80
   [<ffffffff81002dab>] system_call_fastpath+0x16/0x1b
 irq event stamp: 58749209
 hardirqs last  enabled at (58749209): [<ffffffff810629f3>] debug_check_no_locks_freed+0xa3/0x150
 hardirqs last disabled at (58749208): [<ffffffff81062990>] debug_check_no_locks_freed+0x40/0x150
 softirqs last  enabled at (58729526): [<ffffffff8103e05e>] __do_softirq+0xfe/0x150
 softirqs last disabled at (58729495): [<ffffffff81003c4c>] call_softirq+0x1c/0x30
 
 other info that might help us debug this:
 2 locks held by kswapd1/245:
  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff81092798>] shrink_slab+0x38/0x1a0
  #1:  (iprune_sem){.+.+.-}, at: [<ffffffff810da41a>] shrink_icache_memory+0x7a/0x2d0
 
 stack backtrace:
 Pid: 245, comm: kswapd1 Not tainted 2.6.33-rc2 #1
 Call Trace:
  [<ffffffff81061490>] print_usage_bug+0x170/0x180
  [<ffffffff810624b7>] mark_lock+0x367/0x410
  [<ffffffff81062df9>] __lock_acquire+0x259/0x1560
  [<ffffffff81063099>] ? __lock_acquire+0x4f9/0x1560
  [<ffffffff812532d3>] ? xfs_ireclaim+0x83/0xe0
  [<ffffffff8127d2aa>] ? xfs_fs_destroy_inode+0x6a/0x120
  [<ffffffff81055f2d>] ? sched_clock_local+0x1d/0x90
  [<ffffffff8106418f>] lock_acquire+0x8f/0xb0
  [<ffffffff81252f25>] ? xfs_ilock+0x65/0xa0
  [<ffffffff810560e3>] ? cpu_clock+0x43/0x50
  [<ffffffff810544c1>] down_write_nested+0x51/0x90
  [<ffffffff81252f25>] ? xfs_ilock+0x65/0xa0
  [<ffffffff81252f25>] xfs_ilock+0x65/0xa0
  [<ffffffff812532f7>] xfs_ireclaim+0xa7/0xe0
  [<ffffffff8127d335>] xfs_fs_destroy_inode+0xf5/0x120
  [<ffffffff810d9d3a>] destroy_inode+0x2a/0x50
  [<ffffffff810da31d>] dispose_list+0x9d/0x120
  [<ffffffff810da57b>] shrink_icache_memory+0x1db/0x2d0
  [<ffffffff81092798>] ? shrink_slab+0x38/0x1a0
  [<ffffffff81092895>] shrink_slab+0x135/0x1a0
  [<ffffffff8109526c>] balance_pgdat+0x4fc/0x6e0
  [<ffffffff810923b0>] ? isolate_pages_global+0x0/0x220
  [<ffffffff81095516>] kswapd+0xc6/0x290
  [<ffffffff8104fd10>] ? autoremove_wake_function+0x0/0x40
  [<ffffffff81095450>] ? kswapd+0x0/0x290
  [<ffffffff8104f86e>] kthread+0xae/0xc0
  [<ffffffff810628ed>] ? trace_hardirqs_on_caller+0x14d/0x1a0
  [<ffffffff81003b54>] kernel_thread_helper+0x4/0x10
  [<ffffffff814adc3c>] ? restore_args+0x0/0x30
  [<ffffffff8104f7c0>] ? kthread+0x0/0xc0
  [<ffffffff81003b50>] ? kernel_thread_helper+0x0/0x10

-- 
BOFH excuse #323:

Your processor has processed too many instructions.  Turn it off immediately, do not type any commands!!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
