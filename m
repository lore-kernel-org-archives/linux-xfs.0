Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8H0qjqG027286 for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 19:52:46 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE8D0DF53D3
	for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 18:05:24 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	T3Xr9Cj4a2ZhmAPc for <xfs@oss.sgi.com>;
	Thu, 16 Sep 2010 18:05:24 -0700 (PDT)
Date: Fri, 17 Sep 2010 10:52:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: -mm: xfs lockdep warning
Message-ID: <20100917005227.GJ24409@dastard>
References: <201009161546.16909.ruirui.r.yang@tieto.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009161546.16909.ruirui.r.yang@tieto.com>
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
To: Yang Ruirui <ruirui.r.yang@tieto.com>
Cc: hch@infradead.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>

On Thu, Sep 16, 2010 at 03:46:16PM +0800, Yang Ruirui wrote:
> Hi,
> 
> I got following lockdep warning, xfs related?

It's a false positive.

> [  604.416384] =================================
> [  604.416625] [ INFO: inconsistent lock state ]
> [  604.416625] 2.6.36-rc4-mm1 #2
> [  604.416625] ---------------------------------
> [  604.416625] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> [  604.416625] kswapd0/418 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [  604.416625]  (&(&ip->i_iolock)->mr_lock#2){++++?+}, at: [<ffffffff812046df>] xfs_ilock+0x94/0x137
> [  604.416625] {RECLAIM_FS-ON-W} state was registered at:
> [  604.416625]   [<ffffffff81065571>] mark_held_locks+0x4d/0x6b
> [  604.416625]   [<ffffffff81065641>] lockdep_trace_alloc+0xb2/0xd7
> [  604.416625]   [<ffffffff810ee215>] kmem_cache_alloc+0x2a/0x126
> [  604.416625]   [<ffffffff81225d5b>] kmem_zone_alloc+0x67/0xaf
> [  604.416625]   [<ffffffff81225db2>] kmem_zone_zalloc+0xf/0x30
> [  604.416625]   [<ffffffff8121dd73>] _xfs_trans_alloc+0x22/0x5f
> [  604.416625]   [<ffffffff8121ef9f>] xfs_trans_alloc+0x9d/0xaa
> [  604.416625]   [<ffffffff8122520c>] xfs_setattr+0x3d2/0x8b4
> [  604.416625]   [<ffffffff8122eea4>] xfs_vn_setattr+0x16/0x1a
> [  604.416625]   [<ffffffff81106ec7>] notify_change+0x18f/0x27d
> [  604.416625]   [<ffffffff810f1de1>] do_truncate+0x6a/0x88
> [  604.416625]   [<ffffffff810fd7ff>] do_last+0x588/0x58f
> [  604.416625]   [<ffffffff810fda43>] do_filp_open+0x23d/0x5db
> [  604.416625]   [<ffffffff810f1055>] do_sys_open+0x5a/0xf0
> [  604.416625]   [<ffffffff810f1114>] sys_open+0x1b/0x1d
> [  604.416625]   [<ffffffff81002b82>] system_call_fastpath+0x16/0x1b
> [  604.416625] irq event stamp: 144829
> [  604.416625] hardirqs last  enabled at (144829): [<ffffffff815c96ba>] _raw_spin_unlock_irqrestore+0x46/0x55
> [  604.416625] hardirqs last disabled at (144828): [<ffffffff815c910b>] _raw_spin_lock_irqsave+0x24/0x58
> [  604.416625] softirqs last  enabled at (142796): [<ffffffff8103fc97>] __do_softirq+0x1b6/0x1c7
> [  604.416625] softirqs last disabled at (142791): [<ffffffff81003afc>] call_softirq+0x1c/0x28
> [  604.416625] 
> [  604.416625] other info that might help us debug this:
> [  604.416625] 1 lock held by kswapd0/418:
> [  604.416625]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff810c682c>] shrink_slab+0x38/0x164
> [  604.416625] 
> [  604.416625] stack backtrace:
> [  604.416625] Pid: 418, comm: kswapd0 Not tainted 2.6.36-rc4-mm1 #2
> [  604.416625] Call Trace:
> [  604.416625]  [<ffffffff810652b0>] valid_state+0x18b/0x19e
> [  604.416625]  [<ffffffff8100db7b>] ? save_stack_trace+0x2a/0x48
> [  604.416625]  [<ffffffff81065ca9>] ? check_usage_forwards+0x0/0x7e
> [  604.416625]  [<ffffffff810653c9>] mark_lock+0x106/0x261
> [  604.416625]  [<ffffffff81364cef>] ? radix_tree_tag_clear+0xa5/0x108
> [  604.416625]  [<ffffffff8106676f>] __lock_acquire+0x3bb/0xe1f
> [  604.416625]  [<ffffffff810671c4>] ? __lock_acquire+0xe10/0xe1f
> [  604.416625]  [<ffffffff8100db7b>] ? save_stack_trace+0x2a/0x48
> [  604.416625]  [<ffffffff810671c4>] ? __lock_acquire+0xe10/0xe1f
> [  604.416625]  [<ffffffff81364ecd>] ? radix_tree_delete+0xad/0x1b7
> [  604.416625]  [<ffffffff810672ab>] lock_acquire+0xd8/0x104
> [  604.416625]  [<ffffffff812046df>] ? xfs_ilock+0x94/0x137
> [  604.416625]  [<ffffffff810586cf>] down_write_nested+0x4a/0x6d
> [  604.416625]  [<ffffffff812046df>] ? xfs_ilock+0x94/0x137
> [  604.416625]  [<ffffffff812046df>] xfs_ilock+0x94/0x137
> [  604.416625]  [<ffffffff81231c9f>] xfs_reclaim_inode+0x277/0x2c1
> [  604.416625]  [<ffffffff81232608>] xfs_inode_ag_walk+0x8e/0xe9
> [  604.416625]  [<ffffffff81231a28>] ? xfs_reclaim_inode+0x0/0x2c1
> [  604.416625]  [<ffffffff812326c7>] xfs_inode_ag_iterator+0x64/0xc3
> [  604.416625]  [<ffffffff81231a28>] ? xfs_reclaim_inode+0x0/0x2c1
> [  604.416625]  [<ffffffff81232762>] xfs_reclaim_inode_shrink+0x3c/0x83
> [  604.416625]  [<ffffffff810c68d5>] shrink_slab+0xe1/0x164
> [  604.416625]  [<ffffffff810c6f3c>] kswapd+0x5e4/0x864
> [  604.416625]  [<ffffffff8105499e>] ? autoremove_wake_function+0x0/0x38
> [  604.416625]  [<ffffffff810c6958>] ? kswapd+0x0/0x864
> [  604.416625]  [<ffffffff8105452d>] kthread+0x81/0x89
> [  604.416625]  [<ffffffff81003a04>] kernel_thread_helper+0x4/0x10
> [  604.416625]  [<ffffffff81096ee2>] ? watchdog+0x0/0x281
> [  604.416625]  [<ffffffff815c9ad0>] ? restore_args+0x0/0x30
> [  604.416625]  [<ffffffff810544ac>] ? kthread+0x0/0x89
> [  604.416625]  [<ffffffff81003a00>] ? kernel_thread_helper+0x0/0x10

Christoph, this implies an inode that has been marked for reclaim
that has not passed through xfs_fs_evict_inode() after being
initialised. If it went through the eviction process, the iolock
would have been re-initialised to a different context. Can you think
of any path that can get here without going through ->evict? I can't
off the top of my head...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
