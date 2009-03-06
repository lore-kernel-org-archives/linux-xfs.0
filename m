Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n269cVK2202947 for <xfs@oss.sgi.com>; Fri, 6 Mar 2009 03:38:32 -0600
Received: from mail-bw0-f168.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3976B1C20792
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2009 01:38:04 -0800 (PST)
Received: from mail-bw0-f168.google.com (mail-bw0-f168.google.com
	[209.85.218.168]) by cuda.sgi.com with ESMTP id
	TYLdrHUnuksvhyEf for <xfs@oss.sgi.com>;
	Fri, 06 Mar 2009 01:38:04 -0800 (PST)
Received: by bwz12 with SMTP id 12so277381bwz.20
	for <xfs@oss.sgi.com>; Fri, 06 Mar 2009 01:38:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090303170248.GA7036@infradead.org>
References: <a4423d670902200952v5dc2fd91w3b54ab1db51a7fe2@mail.gmail.com>
	<20090224200740.GA9266@infradead.org> <49AD5401.30803@sandeen.net>
	<A277CB1C-4258-42EC-B1D9-F5CAAB962B42@sgi.com>
	<20090303170248.GA7036@infradead.org>
Date: Fri, 6 Mar 2009 12:30:53 +0300
Message-ID: <a4423d670903060130y61407cccp71d50d13c06a4bd@mail.gmail.com>
Subject: Re: next-20090220: XFS: inconsistent lock state
From: Alexander Beregalov <a.beregalov@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi

Is it the same issue?

[ INFO: inconsistent lock state ]
2.6.29-rc7-next-20090305 #8
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
kswapd0/318 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&(&ip->i_lock)->mr_lock){+++++?}, at: [<ffffffff803cbc4a>]
xfs_ilock+0xaa/0x120
{RECLAIM_FS-ON-W} state was registered at:
  [<ffffffff8026db49>] mark_held_locks+0x69/0x90
  [<ffffffff8026dbb1>] lockdep_trace_alloc+0x41/0xb0
  [<ffffffff802c6cbd>] kmem_cache_alloc+0x2d/0x100
  [<ffffffff803f37e7>] kmem_zone_alloc+0x97/0xe0
  [<ffffffff803f3849>] kmem_zone_zalloc+0x19/0x50
  [<ffffffff803b4955>] xfs_da_state_alloc+0x15/0x20
  [<ffffffff803c0387>] xfs_dir2_node_lookup+0x17/0x110
  [<ffffffff803b9688>] xfs_dir_lookup+0x1c8/0x1e0
  [<ffffffff803f08af>] xfs_lookup+0x4f/0xe0
  [<ffffffff803fcb99>] xfs_vn_lookup+0x49/0x90
  [<ffffffff802d5556>] do_lookup+0x1b6/0x250
  [<ffffffff802d5885>] __link_path_walk+0x295/0xec0
  [<ffffffff802d66ee>] path_walk+0x6e/0xe0
  [<ffffffff802d6866>] do_path_lookup+0xa6/0x1d0
  [<ffffffff802d6a65>] path_lookup_open+0x65/0xd0
  [<ffffffff802d796a>] do_filp_open+0xaa/0x8f0
  [<ffffffff802c8a48>] do_sys_open+0x78/0x110
  [<ffffffff802c8b0b>] sys_open+0x1b/0x20
  [<ffffffff8020bbdb>] system_call_fastpath+0x16/0x1b
  [<ffffffffffffffff>] 0xffffffffffffffff
irq event stamp: 531011
hardirqs last  enabled at (531011): [<ffffffff80284194>]
__rcu_read_unlock+0xa4/0xc0
hardirqs last disabled at (531010): [<ffffffff80284149>]
__rcu_read_unlock+0x59/0xc0
softirqs last  enabled at (524334): [<ffffffff80249719>]
__do_softirq+0x139/0x150
softirqs last disabled at (524329): [<ffffffff8020cd5c>] call_softirq+0x1c/0x30

other info that might help us debug this:
2 locks held by kswapd0/318:
 #0:  (shrinker_rwsem){++++..}, at: [<ffffffff802a4c12>] shrink_slab+0x32/0x1c0
 #1:  (iprune_mutex){+.+.-.}, at: [<ffffffff802dfbc4>]
shrink_icache_memory+0x84/0x2a0

stack backtrace:
Pid: 318, comm: kswapd0 Not tainted 2.6.29-rc7-next-20090305 #8
Call Trace:
 [<ffffffff8026ca5d>] print_usage_bug+0x17d/0x190
 [<ffffffff8026d9ad>] mark_lock+0x31d/0x450
 [<ffffffff8026cbd0>] ? check_usage_forwards+0x0/0xc0
 [<ffffffff8026ebcd>] __lock_acquire+0x40d/0x12a0
 [<ffffffff8026faf1>] lock_acquire+0x91/0xc0
 [<ffffffff803cbc4a>] ? xfs_ilock+0xaa/0x120
 [<ffffffff8025f7d0>] down_read_nested+0x50/0x90
 [<ffffffff803cbc4a>] ? xfs_ilock+0xaa/0x120
 [<ffffffff803cbc4a>] xfs_ilock+0xaa/0x120
 [<ffffffff803f09c4>] xfs_free_eofblocks+0x84/0x280
 [<ffffffff8026ea8c>] ? __lock_acquire+0x2cc/0x12a0
 [<ffffffff803f144e>] xfs_inactive+0xee/0x540
 [<ffffffff803fea57>] xfs_fs_clear_inode+0x67/0x70
 [<ffffffff802df7fa>] clear_inode+0x9a/0x120
 [<ffffffff802dfa60>] dispose_list+0x30/0x110
 [<ffffffff802dfd88>] shrink_icache_memory+0x248/0x2a0
 [<ffffffff802a4d3c>] shrink_slab+0x15c/0x1c0
 [<ffffffff802a6cba>] kswapd+0x56a/0x6b0
 [<ffffffff802374b6>] ? finish_task_switch+0x46/0x110
 [<ffffffff802a4120>] ? isolate_pages_global+0x0/0x270
 [<ffffffff8025b450>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff802a6750>] ? kswapd+0x0/0x6b0
 [<ffffffff8025af66>] kthread+0x56/0x90
 [<ffffffff8020cc5a>] child_rip+0xa/0x20
 [<ffffffff802374f9>] ? finish_task_switch+0x89/0x110
 [<ffffffff8063da36>] ? _spin_unlock_irq+0x36/0x60
 [<ffffffff8020c640>] ? restore_args+0x0/0x30
 [<ffffffff8025af10>] ? kthread+0x0/0x90
 [<ffffffff8020cc50>] ? child_rip+0x0/0x20

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
