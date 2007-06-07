Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 01:18:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l578IfWt026810
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 01:18:43 -0700
Date: Thu, 7 Jun 2007 18:18:30 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS shrink functionality
Message-ID: <20070607081830.GR86004887@sgi.com>
References: <1180715974.10796.46.camel@localhost> <20070604001632.GA86004887@sgi.com> <20070604084154.GA8273@teal.hq.k1024.org> <20070604092115.GX85884050@sgi.com> <20070605080012.GA10677@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605080012.GA10677@teal.hq.k1024.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Ruben Porras <nahoo82@gmail.com>, xfs@oss.sgi.com, cw@f00f.org

On Tue, Jun 05, 2007 at 10:00:12AM +0200, Iustin Pop wrote:
> On Mon, Jun 04, 2007 at 07:21:15PM +1000, David Chinner wrote:
> > > allocated on an available AG and when you remove the originals, the
> > > to-be-shrinked AGs become free. Yes, utterly non-optimal, but it was the
> > > simplest way to do it based on what I knew at the time.
> > 
> > Not quite that simple, unfortunately. You can't leave the
> > AGs locked in the same way we do for a grow because we need
> > to be able to use the AGs to move stuff about and that
> > requires locking them. Hence we need a separate mechanism
> > to prevent allocation in a given AG outside of locking them.
> > 
> > Hence we need:
> > 
> > 	- a transaction to mark AGs "no-allocate"
> > 	- a transaction to mark AGs "allocatable"
> > 	- a flag in each AGF/AGI to say the AG is available for
> > 	  allocations (persistent over crashes)
> > 	- a flag in the per-ag structure to indicate allocation
> > 	  status of the AG.
> > 	- everywhere we select an AG for allocation, we need to
> > 	  check this flag and skip the AG if it's not available.
> > 
> > FWIW, the transactions can probably just be an extension of
> > xfs_alloc_log_agf() and xfs_alloc_log_agi()....
> 
> A question: do you think that the cost of having this in the code
> (especially the last part, check that flag in every allocation function)
> is acceptable? I mean, let's say one would write the patch to implement
> all this. Does it have a chance to be accepted? Or will people say it's
> only bloat? ...

Lots of ppl ask for shrink capability on XFS, so if it's implemented
and reviewed and passes QA tests, then I see no reason why it wouldn't
be accepted...

> > Yeah, 1) and 4) are separable parts of the problem and can be done
> > in any order. 2) can be implemented relatively easily as stated
> > above.
> > 
> > 3) is the hard one - we need to find the owner of each block
> > (metadata and data) remaining in the AGs to be removed. This may be
> > a directory btree block, a inode extent btree block, a data block,
> > and extended attr block, etc. Moving the data blocks is easy to
> > do (swap extents), but moving the metadata blocks is a major PITA
> > as it will need to be done transactionally and that will require
> > a bunch of new (complex) code to be written, I think. It will be
> > of equivalent complexity to defragmenting metadata....
> > 
> > If we ignore the metadata block problem then finding and moving the
> > data blocks should not be a problem - swap extents can be used for
> > that as well - but it will be extremely time consuming and won't
> > scale to large filesystem sizes....
> 
> So given these caveats, is there a chance that a) this will be actually
> useful and b) will this be accepted?

Look at it this way - if we get to the point where 3 is a problem, then
we've got most of a useful shrinker. That's way ahead of what we
have now and in a lot of cases it will just work.

The corner cases are the hard bit, but we can work on them incrementally
once the rest is done, and in doing so we'll also be introducing the
means by which to defragment metadata. IOWs, we kill two birds with
one stone at that point in time.

Likewise for the shrink case that needs to move the log - we've got hooks for
userspace tools to move the log, just no implementation. Implementing log moving
for shrink will also enable us to do online log resize and internal/external
log switching. Once again, two birds with one stone.

Hence I don't see these issues as showstoppers at all - getting to
the point of a full shrink implementation will give us other features
that we need to have anyway....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
