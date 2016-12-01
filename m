Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:62348 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751686AbcLAURD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2016 15:17:03 -0500
Date: Fri, 2 Dec 2016 07:12:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS blocking suspend
Message-ID: <20161201201249.GE11750@dastard>
References: <20161201084757.GE12804@quack2.suse.cz>
 <20161201134452.GF22890@bfoster.bfoster>
 <20161201140959.GA16514@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161201140959.GA16514@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, jkosina@suse.cz

On Thu, Dec 01, 2016 at 03:09:59PM +0100, Jan Kara wrote:
> On Thu 01-12-16 08:44:52, Brian Foster wrote:
> > On Thu, Dec 01, 2016 at 09:47:57AM +0100, Jan Kara wrote:
> > > Hi,
> > > 
> > > I've got a report of xfs_aild blocking system suspend in 4.8.7 (in openSUSE
> > > Tumbleweed which is our rolling distro):
> > > 
> > > Freezing of tasks failed after 20.003 seconds (1 tasks refusing to freeze, wq_busy=0):
> > > xfsaild/sdb3    D 0000000000019680     0 918      2 0x00000080
> > >  ffff9e685409fb88 0000000000000000 ffff9e67beaea080 ffff9e68504c6000
> > >  ffff9e6677226b80 ffff9e68540a0000 ffff9e676068c6d8 ffff9e68504c6000
> > >  ffff9e685e48dc00 ffff9e676068c600 ffff9e685409fba0 ffffffffb66cfbac
> > > Call Trace:
> > >  [<ffffffffb66cfbac>] schedule+0x3c/0x90
> > >  [<ffffffffb66d2f1e>] schedule_timeout+0x22e/0x410
> > >  [<ffffffffb66d0f4a>] wait_for_completion+0x9a/0x100
> > >  [<ffffffffc0f0689e>] xfs_buf_submit_wait+0x7e/0x250 [xfs]
> > >  [<ffffffffc0f06ba8>] xfs_buf_read_map+0x108/0x190 [xfs]
> > >  [<ffffffffc0f340c0>] xfs_trans_read_buf_map+0x100/0x370 [xfs]
> > >  [<ffffffffc0ef631e>] xfs_imap_to_bp+0x5e/0xd0 [xfs]
> > >  [<ffffffffc0f1ac6a>] xfs_iflush+0xca/0x220 [xfs]                                                                                        
> > >  [<ffffffffc0f2b21b>] xfs_inode_item_push+0xcb/0x120 [xfs]
> > >  [<ffffffffc0f32e8e>] xfsaild+0x30e/0x770 [xfs]
> > >  [<ffffffffb609c5ed>] kthread+0xbd/0xe0
> > >  [<ffffffffb66d459f>] ret_from_fork+0x1f/0x40
> > > DWARF2 unwinder stuck at ret_from_fork+0x1f/0x40
> > > 
> > > Leftover inexact backtrace:
> > >  [<ffffffffb609c530>] ?  kthread_worker_fn+0x170/0x170
> > > 
> > > What I think has happened is that b_ioend_wq got already frozen during
> > > suspend and thus submitted read could not be completed (all buffer IO
> > > completions seem to be happening from workqueue now if I'm reading the code
> > > right) and thus xfs_aild never finished waiting for IO so that it could be
> > > frozen in try_to_freeze().
> > > 
> > 
> > Hmm, I'm not terribly familiar with the freezer, but shouldn't xfsaild()
> > end up frozen before the associated workqueues? Skimming through the
> > code, perhaps it is possible for the freezer to poke xfsaild(), but if
> > it doesn't actually wait for the freeze (and xfsaild() is busy doing
> > work), it goes ahead onto other tasks and potentially the workqueue if
> > it happens to not be busy at just the right time. Is that what you are
> > thinking?
> 
> Yes. Look at try_to_freeze_tasks() in kernel/power/process.c. We actually
> first do freeze_workqueues_begin() - which basically makes sure we do not
> start processing new workqueue items for freezable workqueues - and then
> walk over all processes and try to freeze them. So while xfs_aild may still
> be happily submitting IO, the IO completion workqueue is already frozen...

Right - kernel threads are not frozen until the hibernation snapshot
is taken later on. The hibernate code does:

	sys_sync()
	freeze_processes()
	  -> freezes workqueues
	hibernate_snapshot()
	  -> freezes kernel threads

I've been saying for close on 10 years now that this sys_sync()
doesn't "freeze" journalling filesystems that can submit internal
metadata IO from kernel threads asynchronously after sync is run. As
such, freezing the filesystem kernel threads and workqueues while it
is operating is always going to be racy and dangerous.

> > If so, perhaps we need some kind of way to pin the workqueue as busy so
> > long as xfsaild() is active..? I was also wondering how necessary it is
> > for this workqueue to be freezable, but that goes back to 8018ec083c
> > ("xfs: mark all internal workqueues as freezable") which apparently
> > added necessarily serialization to avoid reported corruptions.
> 
> Yeah, so currently there's no way to "pin the workqueue as busy" as you
> suggest. That would require new suspending primitive. And essentially you
> are just modelling suspend dependencies with this.
> 
> WRT workqueue being freezable - I think it is freezable because IO
> completion for unwritten extents leads to extent coversion which can
> generate new IO. Whether there isn't a better way for XFS to plug this IO
> source I cannot really tell.

Well, that's one problem - the bigger problem was that when
workqueue processing of periodic work (e.g. eof block trimming) ran
during the hibernate snapshot, the memory image would end up
inconsistent and so on resume the in-memory state of the filesystem
would not match what was on disk.  Which pretty much guarantees
corruption will occur at some point, so we have to suspend all the
work queues at some point.

I'll also point out that if we only had work queues (i.e. xfsaild
was a work queue) we'd still have this same problem, and the xfsaild
workqueue would block waiting for IO completion queued to a
different workqueue and so always return "busy" and hence trigger
the suspend failure. Similarly, everything as kernel threads has the
same problem if the IO completion threads were frozen first...

> Ultimately, the correct solution is to use filesystem freezing during
> suspend to quiesce the filesystem. However that requires more work on the
> suspend side - added Jiri to CC who promised to look into it some time ago
> ;).

I've been saying that for 10 years, too, so I'm not going to hold my
breathe waiting for someone to fix this problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
