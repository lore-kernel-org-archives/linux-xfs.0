Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753580AbdFSK7I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jun 2017 06:59:08 -0400
Date: Mon, 19 Jun 2017 06:59:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170619105904.GA25255@bfoster.bfoster>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
 <20170616105445.3314-3-cmaiolino@redhat.com>
 <20170616183510.GC21846@wotan.suse.de>
 <20170616192445.GG5421@birch.djwong.org>
 <20170616193755.GD21846@wotan.suse.de>
 <3ff0e0c8-ef9c-b7f8-d37e-ed02e5766c40@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ff0e0c8-ef9c-b7f8-d37e-ed02e5766c40@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Jun 16, 2017 at 02:45:13PM -0500, Eric Sandeen wrote:
> On 6/16/17 2:37 PM, Luis R. Rodriguez wrote:
> > On Fri, Jun 16, 2017 at 12:24:45PM -0700, Darrick J. Wong wrote:
> >> On Fri, Jun 16, 2017 at 08:35:10PM +0200, Luis R. Rodriguez wrote:
> >>> On Fri, Jun 16, 2017 at 12:54:45PM +0200, Carlos Maiolino wrote:
> >>>> When a buffer has been failed during writeback, the inode items into it
> >>>> are kept flush locked, and are never resubmitted due the flush lock, so,
> >>>> if any buffer fails to be written, the items in AIL are never written to
> >>>> disk and never unlocked.
> >>>>
> >>>> This causes unmount operation to hang due these items flush locked in AIL,
> >>>
> >>> What type of hang? If it has occurred in production is there a trace somewhere?
> >>> what does it look like?
> >>>
> >>> You said you would work on an xfstest for this, how's that going? Otherewise
> >>> a commit log description of how to reproduce would be useful.
> >>
> >> I'm curious for an xfstest too, but I think Carlos /did/ tell us how to
> >> reproduce -- create a thinp device, format XFS, fill it up, and try to
> >> unmount.
> > 
> > Well he did mention to create a Dm-thin device with a fileystem larger than
> > the real device. You seem to have say just filling up a filsystem?
> 
> No - the case is filling up the /thinp device/, not the filesystem.
> 
> > 
> > Do both cases trigger the issue?
> 
> This whole issue has to do with errors from the block device during writeback;
> that's why the thin device is involved.  When the backing store fills, we
> see the IO errors that cause this problem.
> 
> >> I don't think there /is/ much of a trace, just xfsaild doing
> >> nothing and a bunch of ail items that are flush locked and stuck that way.
> > 
> > OK so no hung task seek, no crash, just a system call that never ends?
> > 
> > Is the issue recoverable? So unmount just never completes? Can we CTRL-C
> > (SIGINT) out of it?
> 
> No, you can't ctrl-c a stuck kernel.
> 
> >>>> but this also causes the items in AIL to never be written back, even when
> >>>> the IO device comes back to normal.
> >>>>
> >>>> I've been testing this patch with a DM-thin device, creating a
> >>>> filesystem larger than the real device.
> >>>>
> >>>> When writing enough data to fill the DM-thin device, XFS receives ENOSPC
> >>>> errors from the device, and keep spinning on xfsaild (when 'retry
> >>>> forever' configuration is set).
> >>>>
> >>>> At this point, the filesystem can not be unmounted because of the flush locked
> >>>> items in AIL, but worse, the items in AIL are never retried at all
> >>>> (once xfs_inode_item_push() will skip the items that are flush locked),
> >>>> even if the underlying DM-thin device is expanded to the proper size.
> >>>
> >>> Jeesh.
> >>>
> >>> If the above issue is a real hang, shoudl we not consider a sensible stable fix
> >>> to start off with ?
> >>
> >> Huh?  I thought this series is supposed to be the fix.
> > 
> > It seems like a rather large set of changes, if the issue was sevee I was hoping
> > for a stable candidate fix first. If its not fixing a severe issue then sure.
> 
> Fixes go uptream first, then to stable kernels if appropriate, right?
> 
> But not every fix is a trivial one-liner.  I don't think there is any simpler
> fix to be had, here.
> 

Yeah, this is kind of intended to be the simplest fix available as far
as I'm aware. TBH, I don't think the fix here is fundamentally that
complex (define a state for already flushed/failed log items), but
rather the code that needs to be modified to implement it has various
states and corner cases to manage that make it tricky to get right.

If we truly needed a stable worthy fix in short order, that would
probably be to revert ac8809f9a ("xfs: abort metadata writeback on
permanent errors"), which caused this regression by making the AIL
responsible for failed retries. A couple caveats I can think of with
that are that 1.) this would likely short circuit the recently added
error configuration api (which is kind of irrelevant if the underlying
error management code doesn't work correctly, but suggests that should
be reverted as well) and 2.) in doing so, this reverts back to the
hardcoded infinite retry behavior in XFS. That means that transient
errors may eventually recover, but the thinp enospc use case and whatnot
are still going to hang on umount. 

It hasn't seemed necessary to me to take that approach given the lower
prevalence of the issue and the fact that a solution had been worked out
for a while now. Though I suppose the longer we go without a fix in
place, the stronger the argument for something like that becomes.

Brian

> -Eric
> 
> >   Luis
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
