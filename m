Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3H8Qf57034340 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 03:26:41 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	50oCZCIT6WApK5Cv for <xfs@oss.sgi.com>;
	Tue, 17 Apr 2012 01:26:37 -0700 (PDT)
Date: Tue, 17 Apr 2012 18:26:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/10] xfs: implement freezing by emptying the AIL
Message-ID: <20120417082633.GH6734@dastard>
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164644.830680325@bombadil.infradead.org>
	<4F8C22D4.3040908@sgi.com> <20120416235432.GZ6734@dastard>
	<20120417042023.GG6734@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120417042023.GG6734@dastard>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Apr 17, 2012 at 02:20:23PM +1000, Dave Chinner wrote:
> On Tue, Apr 17, 2012 at 09:54:32AM +1000, Dave Chinner wrote:
> > On Mon, Apr 16, 2012 at 08:47:00AM -0500, Mark Tinguely wrote:
> > > On 03/27/12 11:44, Christoph Hellwig wrote:
> > > >Now that we write back all metadata either synchronously or through the AIL
> > > >we can simply implement metadata freezing in terms of emptying the AIL.
> > > >
> > > >The implementation for this is fairly simply and straight-forward:  A new
> > > >routine is added that increments a counter that tells xfsaild to not stop
> > > >until the AIL is empty and then waits on a wakeup from
> > > >xfs_trans_ail_delete_bulk to signal that the AIL is empty.
> > > >
> > > >As usual the devil is in the details, in this case the filesystem shutdown
> > > >code.  Currently we are a bit sloppy there and do not continue ail pushing
> > > >in that case, and thus never reach the code in the log item implementations
> > > >that can unwind in case of a shutdown filesystem.  Also the code to
> > > >abort inode and dquot flushes was rather sloppy before and did not remove
> > > >the log items from the AIL, which had to be fixed as well.
> > > >
> > > >Also treat unmount the same way as freeze now, except that we still keep a
> > > >synchronous inode reclaim pass to make sure we reclaim all clean inodes, too.
> > > >
> > > >As an upside we can now remove the radix tree based inode writeback and
> > > >xfs_unmountfs_writesb.
> > > >
> > > >Signed-off-by: Christoph Hellwig<hch@lst.de>
> > > 
> > > Sorry for the empty email.
> > > 
> > > This series hangs my test boxes. This patch is the first indication
> > > of the hang. Reboot, and remove patch 4 and the test are successful.
> > > 
> > > The machine is still responsive. Only the SCRATCH filesystem from
> > > the test suite is hung.
> > > 
> > > Per Dave's observation, I added a couple inode reclaims to this
> > > patch and the test gets further (hangs on run 9 of test 068 rather
> > > than run 3).
> > 
> > That implies that there are dirty inodes at the VFS level leaking
> > through the freeze.
> > 
> > .....
> .....
> > So, what are the flusher threads doing - where are they stuck?
> 
> I have an answer of sorts:
> 
> 90580.054767]   task                        PC stack   pid father
> [90580.056035] flush-253:16    D 0000000000000001  4136 32084      2 0x00000000
> [90580.056035]  ffff880004c558a0 0000000000000046 ffff880068b6cd48 ffff880004c55cb0
> [90580.056035]  ffff88007b616280 ffff880004c55fd8 ffff880004c55fd8 ffff880004c55fd8
> [90580.056035]  ffff88000681e340 ffff88007b616280 ffff880004c558b0 ffff88007981e000
> [90580.056035] Call Trace:
> [90580.056035]  [<ffffffff81afcd19>] schedule+0x29/0x70
> [90580.056035]  [<ffffffff814801fd>] xfs_trans_alloc+0x5d/0xb0
> [90580.056035]  [<ffffffff81099eb0>] ? add_wait_queue+0x60/0x60
> [90580.056035]  [<ffffffff81416b14>] xfs_setfilesize_trans_alloc+0x34/0xb0
> [90580.056035]  [<ffffffff814186f5>] xfs_vm_writepage+0x4a5/0x560
> [90580.056035]  [<ffffffff81127507>] __writepage+0x17/0x40
> [90580.056035]  [<ffffffff81127b3d>] write_cache_pages+0x20d/0x460
> [90580.056035]  [<ffffffff811274f0>] ? set_page_dirty_lock+0x60/0x60
> [90580.056035]  [<ffffffff81127dda>] generic_writepages+0x4a/0x70
> [90580.056035]  [<ffffffff814167ec>] xfs_vm_writepages+0x4c/0x60
> [90580.056035]  [<ffffffff81129711>] do_writepages+0x21/0x40
> [90580.056035]  [<ffffffff8118ee42>] writeback_single_inode+0x112/0x380
> [90580.056035]  [<ffffffff8118f25e>] writeback_sb_inodes+0x1ae/0x270
> [90580.056035]  [<ffffffff8118f4c0>] wb_writeback+0xe0/0x320
> [90580.056035]  [<ffffffff8108724a>] ? try_to_del_timer_sync+0x8a/0x110
> [90580.056035]  [<ffffffff81190bc8>] wb_do_writeback+0xb8/0x1d0
> [90580.056035]  [<ffffffff81085f40>] ? usleep_range+0x50/0x50
> [90580.056035]  [<ffffffff81190d6b>] bdi_writeback_thread+0x8b/0x280
> [90580.056035]  [<ffffffff81190ce0>] ? wb_do_writeback+0x1d0/0x1d0
> [90580.056035]  [<ffffffff81099403>] kthread+0x93/0xa0
> [90580.056035]  [<ffffffff81b06f64>] kernel_thread_helper+0x4/0x10
> [90580.056035]  [<ffffffff81099370>] ? kthread_freezable_should_stop+0x70/0x70
> [90580.056035]  [<ffffffff81b06f60>] ? gs_change+0x13/0x13
> 
> A dirty inode has slipped through the freeze process, and the
> flusher thread is stuck trying to allocate a transaction for setting
> the file size. I can reproduce this fairly easily, so a a bit of
> tracing should tell me exactly what is going wrong....

Yeah, it's pretty clear what is happening here. We don't have
freeze protection against EOF zeroing operations. At least
xfs_setattr_size() and xfs_change_file_space() fail to check for
freeze, and that is initially what I though was causing this problem.

However, adding freeze checks into the relevant paths didn't make
the hangs go away, so there's more to it than that. Basically, we've
been getting races between checking for freeze, the dirtying of the
pages and the flusher thread syncing out the dirty data. i.e.:

Thread 1		Thread 2		freeze		flusher thread
write inode A
check for freeze
					grab s_umount
					SB_FREEZE_WRITE
					writeback_inodes_sb()
								iterate dirty inodes
								inode A not in flush
					sync_inodes_sb()
								iterate dirty inodes
								inode A not in flush
dirty pages
mark inode A dirty
write inode A done.
					SB_FREEZE_TRANS
					drop s_umount
					freeze done
			sync
			grab s_umount
								iterate dirty inodes
								Flush dirty inode A


Before we added the transactional inode size updates, this race
simply went unnoticed because nothing caused the flusher thread to
block. All the problems I see are due to overwrites of allocated
space - if there was real allocation then the delalloc conversion
would have always hung. Now we see that when we need to extend the
file size when writing, we ahve to allocate a transaction and hence
the flusher thread now hangs.

While I can "fix" the xfs_setattr_size() and xfs_change_file_space()
triggers, they don't close the above race condition, so this problem
is essentially unfixable in XFS. The only reason we have not tripped
over it before is that the flusher thread didn't hang waiting for a
transaction reservation when the race was hit.

So why didn't this happen before Christoph's patch set? That's
something I can't explain. Oh, wait, yes I can - 068 hangs even
without this patch of Christoph's. Actually, looking at my xfstests
logs, I can trace the start of the failures back to mid march, and
that coincided with an update to the xfstests installed on my test
boxes. Which coincides with when my machines first saw this change:

commit 281627df3eb55e1b729b9bb06fff5ff112929646
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Mar 13 08:41:05 2012 +0000

    xfs: log file size updates at I/O completion time

That confirms my analysis above - the problem is being exposed by new
code in the writeback path that does transaction allocation where it
didn't used to.

Clearly the problem is not really the new code in Christoph's
patches - it's an existing freeze problem that has previously
resulted in data writes occuring after a freeze has completed (of
which we have had rare complaints about). That sounds pretty dire,
except for one thing: Jan Kara's patch set that fixes all these
freeze problems:

https://lkml.org/lkml/2012/4/16/356

And now that I've run some testing with Jan's patch series, along
with Christoph's and mine (75-odd patches ;), a couple of my test
VMs have been running test 068 in a tight loop for about half an
hour without a hang, so I'd consider this problem fixed by Jan's
freeze fixes given I could reliably hang it in 2-3 minutes before
adding Jan's patch set to my stack.

So the fix for this problem is getting Jan's patch set into the
kernel at the same time we get the inode size logging changes into
the kernel. What do people think about that for a plan?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
