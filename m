Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o51NmpoY032997 for <xfs@oss.sgi.com>; Tue, 1 Jun 2010 18:48:51 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D6BD1584CA7
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 16:53:34 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	KKXwtUXcXCgAWjJF for <xfs@oss.sgi.com>;
	Tue, 01 Jun 2010 16:53:34 -0700 (PDT)
Date: Wed, 2 Jun 2010 09:51:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: inconsistent lock state (2.6.34, XFS inode shrinker)
Message-ID: <20100601235111.GH1395@dastard>
References: <20100601121322.1e8f9edf@multimensaje.es>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100601121322.1e8f9edf@multimensaje.es>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Pedro =?iso-8859-1?Q?M=2E_L=F3pez?= <pmlopez@multimensaje.es>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Jun 01, 2010 at 12:13:22PM +0200, Pedro M. L=F3pez wrote:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ INFO: inconsistent lock state ]
> 2.6.34 #1
> ---------------------------------
> inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> kswapd0/227 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  (&(&ip->i_iolock)->mr_lock#2){++++?+}, at: [<ffffffff8112c11f>]
> xfs_ilock+0x27/0x79 {RECLAIM_FS-ON-W} state was registered at:
>   [<ffffffff810510f5>] mark_held_locks+0x52/0x70
>   [<ffffffff81051198>] lockdep_trace_alloc+0x85/0x9f
>   [<ffffffff81073db2>] __alloc_pages_nodemask+0x7b/0x5b5
>   [<ffffffff8106f1e2>] grab_cache_page_write_begin+0x65/0xaa
>   [<ffffffff810bfaaa>] block_write_begin+0x38/0xcd
>   [<ffffffff81146f1f>] xfs_vm_write_begin+0x25/0x27
>   [<ffffffff8106e140>] generic_file_buffered_write+0x114/0x271
>   [<ffffffff8114aa31>] xfs_file_aio_write+0x4e1/0x70c
>   [<ffffffff8109d187>] do_sync_write+0xc6/0x103
>   [<ffffffff8109db5f>] vfs_write+0xad/0x172
>   [<ffffffff8109dcdd>] sys_write+0x45/0x6c
>   [<ffffffff81001f2b>] system_call_fastpath+0x16/0x1b
> irq event stamp: 62175
> hardirqs last  enabled at (62175): [<ffffffff8126fb03>]
> _raw_spin_unlock_irqrestore+0x3a/0x60 hardirqs last disabled at
> (62174): [<ffffffff8126f3a9>] _raw_spin_lock_irqsave+0x17/0x58 softirqs
> last  enabled at (61572): [<ffffffff8103398d>] __do_softirq+0x127/0x13e
> softirqs last disabled at (61543): [<ffffffff81002dcc>]
> call_softirq+0x1c/0x28
> =

> other info that might help us debug this:
> 2 locks held by kswapd0/227:
>  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff810797f0>]
> shrink_slab+0x38/0x144 #1:  (&xfs_mount_list_lock){++++.-}, at:
> [<ffffffff811503fc>] xfs_reclaim_inode_shrink+0x35/0x128
> =

> stack backtrace:
> Pid: 227, comm: kswapd0 Not tainted 2.6.34 #1
> Call Trace:
>  [<ffffffff81050b72>] print_usage_bug+0x1a4/0x1b5
>  [<ffffffff8100c995>] ? save_stack_trace+0x2a/0x47
>  [<ffffffff810516bc>] ? check_usage_forwards+0x0/0xcf
>  [<ffffffff81050e6d>] mark_lock+0x2ea/0x520
>  [<ffffffff81052b8a>] __lock_acquire+0x6c1/0x1607
>  [<ffffffff8116820b>] ? radix_tree_delete+0xd1/0x1d0
>  [<ffffffff81053b27>] lock_acquire+0x57/0x6d
>  [<ffffffff8112c11f>] ? xfs_ilock+0x27/0x79
>  [<ffffffff81046939>] down_write_nested+0x2a/0x4d
>  [<ffffffff8112c11f>] ? xfs_ilock+0x27/0x79
>  [<ffffffff8112c11f>] xfs_ilock+0x27/0x79
>  [<ffffffff8112c2eb>] xfs_ireclaim+0x93/0xb1
>  [<ffffffff8114f949>] xfs_reclaim_inode+0x1de/0x20a
>  [<ffffffff81150299>] xfs_inode_ag_walk+0x8b/0xe6
>  [<ffffffff8114f76b>] ? xfs_reclaim_inode+0x0/0x20a
>  [<ffffffff81150374>] xfs_inode_ag_iterator+0x80/0xd3
>  [<ffffffff8114f76b>] ? xfs_reclaim_inode+0x0/0x20a
>  [<ffffffff81150428>] xfs_reclaim_inode_shrink+0x61/0x128
>  [<ffffffff8107988b>] shrink_slab+0xd3/0x144
>  [<ffffffff81079c61>] balance_pgdat+0x365/0x59b
>  [<ffffffff81077908>] ? isolate_pages_global+0x0/0x212
>  [<ffffffff8107a089>] kswapd+0x1f2/0x20f
>  [<ffffffff81042e89>] ? autoremove_wake_function+0x0/0x34
>  [<ffffffff8126fb24>] ? _raw_spin_unlock_irqrestore+0x5b/0x60
>  [<ffffffff81079e97>] ? kswapd+0x0/0x20f
>  [<ffffffff81042ac7>] kthread+0x7a/0x82
>  [<ffffffff81002cd4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8126ff40>] ? restore_args+0x0/0x30
>  [<ffffffff81042a4d>] ? kthread+0x0/0x82
>  [<ffffffff81002cd0>] ? kernel_thread_helper+0x0/0x10

It's a false positive introduced in 2.6.34 by the inode shrinker.
That's one of several different false positive traces in 2.6.34,
but I can't do anything about them because the shrinkers require
global scope. The patches to customise the shrinker contexts (which
avoids all of these warnings) will fix this....

You may as well not run lockdep on anything with an XFS filesystem,
as these false positives will occur as soon as memory reclaim
triggers and turn lockdep off.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
