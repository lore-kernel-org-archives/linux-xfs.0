Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38857 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757468AbcLAOKD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Dec 2016 09:10:03 -0500
Date: Thu, 1 Dec 2016 15:09:59 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: XFS blocking suspend
Message-ID: <20161201140959.GA16514@quack2.suse.cz>
References: <20161201084757.GE12804@quack2.suse.cz>
 <20161201134452.GF22890@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161201134452.GF22890@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org, jkosina@suse.cz

On Thu 01-12-16 08:44:52, Brian Foster wrote:
> On Thu, Dec 01, 2016 at 09:47:57AM +0100, Jan Kara wrote:
> > Hi,
> > 
> > I've got a report of xfs_aild blocking system suspend in 4.8.7 (in openSUSE
> > Tumbleweed which is our rolling distro):
> > 
> > Freezing of tasks failed after 20.003 seconds (1 tasks refusing to freeze, wq_busy=0):
> > xfsaild/sdb3    D 0000000000019680     0 918      2 0x00000080
> >  ffff9e685409fb88 0000000000000000 ffff9e67beaea080 ffff9e68504c6000
> >  ffff9e6677226b80 ffff9e68540a0000 ffff9e676068c6d8 ffff9e68504c6000
> >  ffff9e685e48dc00 ffff9e676068c600 ffff9e685409fba0 ffffffffb66cfbac
> > Call Trace:
> >  [<ffffffffb66cfbac>] schedule+0x3c/0x90
> >  [<ffffffffb66d2f1e>] schedule_timeout+0x22e/0x410
> >  [<ffffffffb66d0f4a>] wait_for_completion+0x9a/0x100
> >  [<ffffffffc0f0689e>] xfs_buf_submit_wait+0x7e/0x250 [xfs]
> >  [<ffffffffc0f06ba8>] xfs_buf_read_map+0x108/0x190 [xfs]
> >  [<ffffffffc0f340c0>] xfs_trans_read_buf_map+0x100/0x370 [xfs]
> >  [<ffffffffc0ef631e>] xfs_imap_to_bp+0x5e/0xd0 [xfs]
> >  [<ffffffffc0f1ac6a>] xfs_iflush+0xca/0x220 [xfs]                                                                                        
> >  [<ffffffffc0f2b21b>] xfs_inode_item_push+0xcb/0x120 [xfs]
> >  [<ffffffffc0f32e8e>] xfsaild+0x30e/0x770 [xfs]
> >  [<ffffffffb609c5ed>] kthread+0xbd/0xe0
> >  [<ffffffffb66d459f>] ret_from_fork+0x1f/0x40
> > DWARF2 unwinder stuck at ret_from_fork+0x1f/0x40
> > 
> > Leftover inexact backtrace:
> >  [<ffffffffb609c530>] ?  kthread_worker_fn+0x170/0x170
> > 
> > What I think has happened is that b_ioend_wq got already frozen during
> > suspend and thus submitted read could not be completed (all buffer IO
> > completions seem to be happening from workqueue now if I'm reading the code
> > right) and thus xfs_aild never finished waiting for IO so that it could be
> > frozen in try_to_freeze().
> > 
> 
> Hmm, I'm not terribly familiar with the freezer, but shouldn't xfsaild()
> end up frozen before the associated workqueues? Skimming through the
> code, perhaps it is possible for the freezer to poke xfsaild(), but if
> it doesn't actually wait for the freeze (and xfsaild() is busy doing
> work), it goes ahead onto other tasks and potentially the workqueue if
> it happens to not be busy at just the right time. Is that what you are
> thinking?

Yes. Look at try_to_freeze_tasks() in kernel/power/process.c. We actually
first do freeze_workqueues_begin() - which basically makes sure we do not
start processing new workqueue items for freezable workqueues - and then
walk over all processes and try to freeze them. So while xfs_aild may still
be happily submitting IO, the IO completion workqueue is already frozen...

> If so, perhaps we need some kind of way to pin the workqueue as busy so
> long as xfsaild() is active..? I was also wondering how necessary it is
> for this workqueue to be freezable, but that goes back to 8018ec083c
> ("xfs: mark all internal workqueues as freezable") which apparently
> added necessarily serialization to avoid reported corruptions.

Yeah, so currently there's no way to "pin the workqueue as busy" as you
suggest. That would require new suspending primitive. And essentially you
are just modelling suspend dependencies with this.

WRT workqueue being freezable - I think it is freezable because IO
completion for unwritten extents leads to extent coversion which can
generate new IO. Whether there isn't a better way for XFS to plug this IO
source I cannot really tell.

Ultimately, the correct solution is to use filesystem freezing during
suspend to quiesce the filesystem. However that requires more work on the
suspend side - added Jiri to CC who promised to look into it some time ago
;).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
