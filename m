Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8C3Vh2B080949 for <xfs@oss.sgi.com>; Fri, 11 Sep 2009 22:31:44 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 112CB1314EF6
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2009 20:32:52 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	GReRRRa4NAMcSkZY for <xfs@oss.sgi.com>;
	Fri, 11 Sep 2009 20:32:52 -0700 (PDT)
Date: Sat, 12 Sep 2009 13:32:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: make sure xfs_sync_fsdata covers the log
Message-ID: <20090912033249.GA6889@discord.disaster>
References: <20090827231558.057467775@bombadil.infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE83ABF3@cf--amer001e--3.americas.sgi.com>
	<20090903154551.GA16715@infradead.org>
	<20090911192904.GA2746@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090911192904.GA2746@infradead.org>
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
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Fri, Sep 11, 2009 at 03:29:04PM -0400, Christoph Hellwig wrote:
> On Thu, Sep 03, 2009 at 11:45:52AM -0400, Christoph Hellwig wrote:
> > 
> > FYI: I found some nasty deadlock in this on a large machine, please
> > hold back until I've sorted it out.
> 
> Turns out it's the following:
> 
> Thread A is in xfs_sync_fsdata from sys_sync, flushing the workqueues while
> holding b_sema of the superblock:
> 
> [78901.232282] Call Trace:
> [78901.232282]  [<c08700b5>] schedule_timeout+0x155/0x190
> [78901.232282]  [<c086f4f1>] wait_for_common+0x101/0x120
> [78901.232282]  [<c086f5a2>] wait_for_completion+0x12/0x20
> [78901.232282]  [<c01672ac>] flush_cpu_workqueue+0x3c/0x70
> [78901.232282]  [<c01679ae>] flush_workqueue+0x7e/0xa0
> [78901.232282]  [<c04ab409>] xfs_flush_buftarg+0x19/0x170
> [78901.232282]  [<c04fe9c8>] xfs_sync_fsdata+0xb8/0x150
> [78901.232282]  [<c04fef55>] xfs_quiesce_data+0x45/0x70
> [78901.232282]  [<c04d8810>] xfs_fs_sync_fs+0x20/0xd0
> [78901.232282]  [<c0206539>] __sync_filesystem+0x39/0x60
> [78901.232282]  [<c020663b>] sync_filesystems+0xdb/0x110
> [78901.232282]  [<c02066bb>] sys_sync+0x1b/0x40
> 
> 
> This causes a wakeup of xfsconvertd
> performing outstanding unwritten extent conversions:
> 
> [32160.551805] Call Trace:
> [32160.553843]  [<c08700b5>] schedule_timeout+0x155/0x190
> [32160.556965]  [<c0870f80>] __down+0x50/0x80
> [32160.557838]  [<c01703ae>] down+0x3e/0x40
> [32160.559675]  [<c04aa6a2>] xfs_buf_lock+0x32/0xe0
> [32160.560795]  [<c0495e15>] xfs_getsb+0x45/0x90
> [32160.561700]  [<c049ebf1>] xfs_trans_getsb+0x91/0x180
> [32160.562723]  [<c049c0f5>] xfs_trans_apply_sb_deltas+0x15/0x450
> [32160.564995]  [<c049c611>] _xfs_trans_commit+0xe1/0x410
> [32160.570459]  [<c04869ec>] xfs_iomap_write_unwritten+0x1cc/0x300
> [32160.571678]  [<c04a7da2>] xfs_end_bio_unwritten+0x62/0x70
> [32160.573007]  [<c0166c7d>] worker_thread+0x18d/0x280
> [32160.577650]  [<c0166af0>] ? worker_thread+0x0/0x280
> [32160.578666]  [<c016b3ec>] kthread+0x7c/0x90
> 
> Which we already hold in the Thread A.
> 
> I don't really see why we have to do these waits at all - xfsdatad and
> xfsconvertd are for data I/O completion and not buffers, and we already
> track their completion for data integrity syncs using the per-inode
> iocount that we wait for during the data writeout.

Basically the log covering code should only do anything if the
filesystem is otherwise idle - if a sync is running with concurrent
changes then we're not going to be able to cover the log, nor do we
need to because the concurrent transactions have the same effect as
covering the log - writing another record that ensures the log head
and tail are up to date on disk.

The issue here is that some other data IO completion not covered
by the sync() call is running a new transaction that modifies the
superblock, and it can't get the lock. I'd suggest that the
xfs_flush_buftarg() cal needs to be moved until after the superblock
write but before the cover check. That way the superblock will be
unlocked (due to IO completion) and the above xfsconvertd stack will
make progress and prevent the deadlock.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
