Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9LDMhFB073411 for <xfs@oss.sgi.com>; Fri, 21 Oct 2011 08:22:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8913F16C3C0F
	for <xfs@oss.sgi.com>; Fri, 21 Oct 2011 06:30:54 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	sWYmGTfiXASPiszY for <xfs@oss.sgi.com>;
	Fri, 21 Oct 2011 06:30:54 -0700 (PDT)
Date: Fri, 21 Oct 2011 09:22:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS read hangs in 3.1-rc10
Message-ID: <20111021132240.GA24136@infradead.org>
References: <20111020224214.GC22772@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111020224214.GC22772@hostway.ca>
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
To: Simon Kirby <sim@hostway.ca>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 20, 2011 at 03:42:14PM -0700, Simon Kirby wrote:
> 
> [<ffffffff8126f205>] xfs_reclaim_inode+0x85/0x2b0
> [<ffffffff8126f5b0>] xfs_reclaim_inodes_ag+0x180/0x2f0
> [<ffffffff8126f74e>] xfs_reclaim_inodes_nr+0x2e/0x40
> [<ffffffff8126ccf0>] xfs_fs_free_cached_objects+0x10/0x20
> [<ffffffff81119a70>] prune_super+0x110/0x1b0
> [<ffffffff810e4fa5>] shrink_slab+0x1e5/0x2a0
> [<ffffffff810e5821>] kswapd+0x7c1/0xba0
> [<ffffffff8107ada6>] kthread+0x96/0xb0
> [<ffffffff816c0474>] kernel_thread_helper+0x4/0x10
> [<ffffffffffffffff>] 0xffffffffffffffff

We're stuck in synchronous inode reclaim.

> All of the other processes that get stuck have this stack:
> 
> [<ffffffff81080587>] down+0x47/0x50
> [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
> [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
> [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
> [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
> [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
> [<ffffffff8129e161>] xfs_read_agi+0x71/0x100

They are waiting for the AGI buffer to become unlocked.  The only reason
it is held locked for longer time is when it is under I/O.

> 
> By the way, xfs_reclaim_inode+0x85 (133) disassembles as:

> 
> ...So the next function is wait_for_completion(), which is marked
> __sched and thus doesn't show up in the trace.

So we're waiting for the inode to be flushed, aka I/O again.



What is interesting here is that we're always blocking on the AGI
buffer - which is used during unlinks of inodes, and thus gets hit
fairly heavily for a workload that does a lot of unlinks.

> When the clog happens, "iostat -x -k 1" shows no reads from the XFS
> devices, though writes keep happening. "vmstat 1" matches. I tried
> switching schedulers from CFQ to deadline -- no difference. Queue depth
> is empty on the devices and nothing is actually clogged up at the device
> -- it's not actually plugged at the controller or disk. I did a sysreq-w
> while this was happening. About 10 seconds later, everything unclogs and
> continues. Sysreq-W output below. I poked around at the various XFS
> tracepoints in /sys/kernel/debug/tracing/events/xfs, but I'm not sure
> which tracepoints to use and many of them scroll too fast to see
> anything. Any suggestions?

Given that you are doing a lot of unlinks I wonder if it is related
to the recent ail pushing issues in that area.  While your symptoms
looks completely different we could be blocking on the flush completion
for an inode that gets stuck in the AIL.

Can you run with latest 3.0-stable plus the patches at:

	http://oss.sgi.com/pipermail/xfs/2011-October/053464.html

If this doesn't help I'll probably need to come up with some tracing
patches for you.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
