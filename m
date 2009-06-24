Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5OLeF67105365 for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 16:40:15 -0500
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF8E896F867
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 14:49:09 -0700 (PDT)
Received: from cobra.newdream.net (cobra.newdream.net [66.33.216.30]) by
	cuda.sgi.com with ESMTP id pPu9PSSmwkEWTbW1 for
	<xfs@oss.sgi.com>; Wed, 24 Jun 2009 14:49:09 -0700 (PDT)
Date: Wed, 24 Jun 2009 14:40:42 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
Subject: Re: inconsistent lock state on 2.6.30?
In-Reply-To: <20090623170844.GA23971@infradead.org>
Message-ID: <Pine.LNX.4.64.0906241438100.24641@cobra.newdream.net>
References: <Pine.LNX.4.64.0906230925420.20462@cobra.newdream.net>
	<20090623170844.GA23971@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, 23 Jun 2009, Christoph Hellwig wrote:
> On Tue, Jun 23, 2009 at 09:26:04AM -0700, Sage Weil wrote:
> > Hi,
> > 
> > I have 6 machines using an XFS volume for logs, and strangely all 6 of 
> > them spit out the following at roughly the same time last night.  Most are 
> > around 50% full, all with a single directory full of large append-only 
> > files.  They're all running similar workloads, and are all nfs exported.
> > 
> > Is this a known issue?  If there's any other info that'd be helpful, let 
> > me know.
> 
> > [15995.063830] inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage.
> > [15995.063830] kswapd0/290 [HC0[0]:SC0[0]:HE1:SE1] takes:
> > [15995.063830]  (&(&ip->i_lock)->mr_lock){++++-?}, at: 
> > [<ffffffff803af57a>] xfs_ilock+0x5b/0x79
> > [15995.063830] {RECLAIM_FS-ON-R} state was registered at:
> 
> If I understand this correctly we take a rw/semaphore in the reclaim
> path, and also in a memory allocation that may call back into the fs.
> 
> I don't think the actual condition is new, but I've never seen the
> warning before.  The patch below should take care of it, can you give it
> a try?

Hmm, I caught it again:

[ 7822.230090] =================================
[ 7822.230208] [ INFO: inconsistent lock state ]
[ 7822.230208] 2.6.30 #22
[ 7822.230208] ---------------------------------
[ 7822.230208] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[ 7822.230208] kswapd0/290 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 7822.230208]  (&(&ip->i_iolock)->mr_lock){++++?+}, at: [<ffffffff803af53a>] xfs_ilock+0x27/0x79
[ 7822.230208] {RECLAIM_FS-ON-W} state was registered at:
[ 7822.230208]   [<ffffffff8025c297>] mark_held_locks+0x4d/0x6b
[ 7822.230208]   [<ffffffff8025c35d>] lockdep_trace_alloc+0xa8/0xc3
[ 7822.230208]   [<ffffffff80287c4e>] __alloc_pages_internal+0x6d/0x457
[ 7822.230208]   [<ffffffff802a7eb6>] alloc_pages_current+0xbe/0xc6
[ 7822.230208]   [<ffffffff80281c19>] grab_cache_page_write_begin+0x5e/0xa2
[ 7822.230208]   [<ffffffff802d2aa5>] block_write_begin+0x3d/0xcf
[ 7822.230208]   [<ffffffff803cb634>] xfs_vm_write_begin+0x25/0x27
[ 7822.230208]   [<ffffffff802825ba>] generic_file_buffered_write+0x139/0x2ff
[ 7822.230208]   [<ffffffff803d172a>] xfs_write+0x4de/0x717
[ 7822.230208]   [<ffffffff803ce0f1>] xfs_file_aio_write+0x61/0x63
[ 7822.230208]   [<ffffffff802b080e>] do_sync_write+0xe7/0x12d
[ 7822.340754]   [<ffffffff802b11c3>] vfs_write+0xae/0x137
[ 7822.340754]   [<ffffffff802b1310>] sys_write+0x47/0x6e
[ 7822.340754]   [<ffffffff8020bb2b>] system_call_fastpath+0x16/0x1b
[ 7822.340754]   [<ffffffffffffffff>] 0xffffffffffffffff
[ 7822.340754] irq event stamp: 10734119
[ 7822.340754] hardirqs last  enabled at (10734119): [<ffffffff8062372c>] _spin_unlock_irqrestore+0x3f/0x68
[ 7822.340754] hardirqs last disabled at (10734118): [<ffffffff80623a80>] _spin_lock_irqsave+0x19/0x7f
[ 7822.340754] softirqs last  enabled at (10734016): [<ffffffff80240850>] __do_softirq+0x1d9/0x1e5
[ 7822.340754] softirqs last disabled at (10733825): [<ffffffff8020ccbc>] call_softirq+0x1c/0x28
[ 7822.340754] 
[ 7822.340754] other info that might help us debug this:
[ 7822.340754] 2 locks held by kswapd0/290:
[ 7822.340754]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff8028d80c>] shrink_slab+0x38/0x188
[ 7822.340754]  #1:  (iprune_mutex){+.+.-.}, at: [<ffffffff802c3a2b>] shrink_icache_memory+0x4b/0x23b
[ 7822.340754] 
[ 7822.340754] stack backtrace:
[ 7822.340754] Pid: 290, comm: kswapd0 Not tainted 2.6.30 #22
[ 7822.340754] Call Trace:
[ 7822.340754]  [<ffffffff8025bd01>] print_usage_bug+0x1b2/0x1c3
[ 7822.456334]  [<ffffffff8025c8e2>] ? check_usage_forwards+0x0/0x9c
[ 7822.460330]  [<ffffffff8025c00c>] mark_lock+0x2fa/0x538
[ 7822.464330]  [<ffffffff8025d9d5>] __lock_acquire+0x80d/0x16a9
[ 7822.464330]  [<ffffffff8025e967>] lock_acquire+0xf6/0x11a
[ 7822.464330]  [<ffffffff803af53a>] ? xfs_ilock+0x27/0x79
[ 7822.464330]  [<ffffffff80252ab1>] down_write_nested+0x46/0x7a
[ 7822.464330]  [<ffffffff803af53a>] ? xfs_ilock+0x27/0x79
[ 7822.464330]  [<ffffffff803af53a>] xfs_ilock+0x27/0x79
[ 7822.464330]  [<ffffffff803af648>] xfs_ireclaim+0x8d/0x153
[ 7822.464330]  [<ffffffff803d3e74>] xfs_reclaim_inode+0x131/0x13f
[ 7822.464330]  [<ffffffff803c6194>] xfs_reclaim+0x98/0xa9
[ 7822.464330]  [<ffffffff803d2532>] xfs_fs_destroy_inode+0x37/0x57
[ 7822.464330]  [<ffffffff802c38d3>] destroy_inode+0x3a/0x4f
[ 7822.464330]  [<ffffffff802c39ac>] dispose_list+0xc4/0xf8
[ 7822.464330]  [<ffffffff802c3be5>] shrink_icache_memory+0x205/0x23b
[ 7822.464330]  [<ffffffff8028d8b3>] shrink_slab+0xdf/0x188
[ 7822.464330]  [<ffffffff8028e109>] kswapd+0x4fc/0x6b2
[ 7822.464330]  [<ffffffff80232c88>] ? finish_task_switch+0x3b/0xdc
[ 7822.464330]  [<ffffffff8028b848>] ? isolate_pages_global+0x0/0x208
[ 7822.464330]  [<ffffffff8024fd10>] ? autoremove_wake_function+0x0/0x38
[ 7822.464330]  [<ffffffff8025c568>] ? trace_hardirqs_on+0xd/0xf
[ 7822.464330]  [<ffffffff8028dc0d>] ? kswapd+0x0/0x6b2
[ 7822.464330]  [<ffffffff8028dc0d>] ? kswapd+0x0/0x6b2
[ 7822.464330]  [<ffffffff8024f8d1>] kthread+0x56/0x83
[ 7822.464330]  [<ffffffff8020cbba>] child_rip+0xa/0x20
[ 7822.464330]  [<ffffffff8020c580>] ? restore_args+0x0/0x30
[ 7822.464330]  [<ffffffff8062064f>] ? __schedule+0xf9/0x948
[ 7822.464330]  [<ffffffff8024f87b>] ? kthread+0x0/0x83
[ 7822.464330]  [<ffffffff8020cbb0>] ? child_rip+0x0/0x20

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
