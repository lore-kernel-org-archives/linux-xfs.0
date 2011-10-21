Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9LKTHQW094494 for <xfs@oss.sgi.com>; Fri, 21 Oct 2011 15:29:17 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC46C1618A53
	for <xfs@oss.sgi.com>; Fri, 21 Oct 2011 13:29:14 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id JZNZ9OSUlEUP9PGk for
	<xfs@oss.sgi.com>; Fri, 21 Oct 2011 13:29:14 -0700 (PDT)
Date: Fri, 21 Oct 2011 22:29:11 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: XFS read hangs in 3.1-rc10
Message-ID: <20111021202911.GA1633@x4.trippels.de>
References: <20111020224214.GC22772@hostway.ca>
	<20111021132240.GA24136@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111021132240.GA24136@infradead.org>
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
Cc: linux-kernel@vger.kernel.org, Simon Kirby <sim@hostway.ca>, xfs@oss.sgi.com

On 2011.10.21 at 09:22 -0400, Christoph Hellwig wrote:
> On Thu, Oct 20, 2011 at 03:42:14PM -0700, Simon Kirby wrote:
> > 
> > [<ffffffff8126f205>] xfs_reclaim_inode+0x85/0x2b0
> > [<ffffffff8126f5b0>] xfs_reclaim_inodes_ag+0x180/0x2f0
> > [<ffffffff8126f74e>] xfs_reclaim_inodes_nr+0x2e/0x40
> > [<ffffffff8126ccf0>] xfs_fs_free_cached_objects+0x10/0x20
> > [<ffffffff81119a70>] prune_super+0x110/0x1b0
> > [<ffffffff810e4fa5>] shrink_slab+0x1e5/0x2a0
> > [<ffffffff810e5821>] kswapd+0x7c1/0xba0
> > [<ffffffff8107ada6>] kthread+0x96/0xb0
> > [<ffffffff816c0474>] kernel_thread_helper+0x4/0x10
> > [<ffffffffffffffff>] 0xffffffffffffffff
> 
> We're stuck in synchronous inode reclaim.
> 
> > All of the other processes that get stuck have this stack:
> > 
> > [<ffffffff81080587>] down+0x47/0x50
> > [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
> > [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
> > [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
> > [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
> > [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
> > [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
> 
> They are waiting for the AGI buffer to become unlocked.  The only reason
> it is held locked for longer time is when it is under I/O.
> 
> > 
> > By the way, xfs_reclaim_inode+0x85 (133) disassembles as:
> 
> > 
> > ...So the next function is wait_for_completion(), which is marked
> > __sched and thus doesn't show up in the trace.
> 
> So we're waiting for the inode to be flushed, aka I/O again.
> 
> What is interesting here is that we're always blocking on the AGI
> buffer - which is used during unlinks of inodes, and thus gets hit
> fairly heavily for a workload that does a lot of unlinks.
> 
> Given that you are doing a lot of unlinks I wonder if it is related
> to the recent ail pushing issues in that area.  While your symptoms
> looks completely different we could be blocking on the flush completion
> for an inode that gets stuck in the AIL.
> 
> Can you run with latest 3.0-stable plus the patches at:

Please not that he saw this in 3.1-rc10, too. And this version already
contains the fixes:
 % git describe --contains 0030807c66f0582
v3.1-rc10~5^2

I just saw similar symptoms while running a weekly rsync backup job. The
machine was stuck for a few seconds several times during that time (no
response to mouse or keyboard input). It always recovered by itself
after a short while.

This is an example output of latencytop during the rsync run:

Cause                                                Maximum     Percentage
[xfs_reclaim_inodes_ag]                           7847.0 msec         16.6 %
Fork() system call                                7777.1 msec         25.5 %
Creating block layer request                      5352.5 msec         18.1 %
[xfs_buf_iowait]                                  2000.4 msec         14.7 %
[down]                                            959.7 msec          2.0 %
Page fault                                        637.3 msec          1.4 %
[xfs_iunpin_wait]                                 557.4 msec          0.7 %
Unlinking file                                     66.8 msec          0.1 %

I also took some "perf timechart" recordings. If there is interest I
could post the svg images somewhere.

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
