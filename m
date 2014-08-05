Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 164127F90
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 14:59:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E9C10304053
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 12:59:13 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	TvXQWb0Ep2nI52S9 for <xfs@oss.sgi.com>;
	Tue, 05 Aug 2014 12:59:08 -0700 (PDT)
Date: Wed, 6 Aug 2014 05:59:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] xfs: consolidate superblock logging functions
Message-ID: <20140805195906.GY26465@dastard>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
	<1406791995-14723-3-git-send-email-david@fromorbit.com>
	<20140801143929.GC3582@laptop.bfoster>
	<20140804080930.GY20518@dastard>
	<20140804124836.GA4049@bfoster.bfoster>
	<20140804221526.GZ20518@dastard>
	<20140805000333.GA27760@bfoster.bfoster>
	<20140805003440.GB20518@dastard>
	<20140805123050.GA53538@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140805123050.GA53538@bfoster.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 05, 2014 at 08:30:51AM -0400, Brian Foster wrote:
> On Tue, Aug 05, 2014 at 10:34:40AM +1000, Dave Chinner wrote:
> > On Mon, Aug 04, 2014 at 08:03:33PM -0400, Brian Foster wrote:
> > > On Tue, Aug 05, 2014 at 08:15:26AM +1000, Dave Chinner wrote:
> > > > e.g. did you know that the xfs_fs_writable() check in
> > > > xfs_log_sbcount() is to prevent it from writing anything when
> > > > unmounting a fully frozen filesystem? i.e. xfs_log_sbcount needs to
> > > > succeed while a freeze is in progress, but fail when a freeze is
> > > > fully complete?
> > > > 
> > > 
> > > Hmm, so freeze_super() sets s_frozen to SB_FREEZE_FS before it calls
> > > into the fs. Given the xfs_fs_writable() logic, how is that going to
> > > differentiate a freezing fs from a frozen fs? It makes sense that this
> > > would avoid blocking on umount of a frozen fs, but it seems like we'd
> > > skip out just the same during the freeze sequence. Maybe I'm missing
> > > something...
> > 
> > Hmmm - that means we broke it at some point. xfs_attr_quiesce is
> > supposed to make the metadata uptodate on disk, so if it's not
> > updating the superblock (i.e. syncing all the counters) then it's
> > not doing the right thing - the sb counters on disk while the fs is
> > frozen are not uptodate and hence correct behaviour if we crash with
> > a frozen fs is dependent on log recovery finding a dirty log. That's
> > a nasty little landmine and needs to be fixed, even though it's not
> > causing issues at the moment (because we dirty the log after
> > quiescing the filesystem).
> > 
> 
> I'm wondering if that even helps in the case of a crash. It looks like
> we would skip the counter sync and subsequent action of logging the sb
> entirely.
> 
> Oh, according to the lazy sb counter commit log description we do some
> kind of counter rebuild across the AGI/AGF structures and log the result
> of that. So I take it that should a crash occur while in the frozen
> state, the simple act of causing a log recovery to occur on subsequent
> mount should rebuild everything correctly.

Right - it's log recovery that is hiding that little gem. We've been
talking about whether we can change freeze to leave the log clean
and so avoid the need for log recovery in snapshot images. If we
did that, then we'd have exposed this bug....

> > Did I mention this code is not at all obvious? :/
> > 
> 
> Heh. :P From what I can see, it looks like this has been the case since
> commit 92821e2b, which introduced xfs_log_sbcount().

*nod*

> Perhaps xfs_log_sbcount() requires an open coded s_frozen check a la
> the _xfs_trans_alloc() logic. E.g., skip out of SB_FREEZE_COMPLETE,
> proceed otherwise..?

Possibly. But it still also needs the RO and shutdown checks.
Perhaps passing xfs_fs_writable() a freeze level and checking
against that?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
