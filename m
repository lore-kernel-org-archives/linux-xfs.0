Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:37212 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726899AbfEYWnX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 May 2019 18:43:23 -0400
Date: Sun, 26 May 2019 08:43:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 00/11] xfs: rework extent allocation
Message-ID: <20190525224317.GZ29573@dread.disaster.area>
References: <20190522180546.17063-1-bfoster@redhat.com>
 <20190523015659.GL29573@dread.disaster.area>
 <20190523125535.GA20099@bfoster>
 <20190523221552.GM29573@dread.disaster.area>
 <20190524120015.GA32730@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524120015.GA32730@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 24, 2019 at 08:00:18AM -0400, Brian Foster wrote:
> On Fri, May 24, 2019 at 08:15:52AM +1000, Dave Chinner wrote:
> > On Thu, May 23, 2019 at 08:55:35AM -0400, Brian Foster wrote:
> > > Hmmm.. I suppose if I had a script that
> > > just dumped every applicable stride/delta value for an inode, I could
> > > dump all of those numbers into a file and we can process it from there..
> > 
> > See how the freesp commands work in xfs_db - they just generate a
> > set of {offset, size} tuples that are then bucketted appropriately.
> > This is probably the best way to do this at the moment - have xfs_db
> > walk the inode BMBTs outputting something like {extent size,
> > distance to next extent} tuples and everything else falls out from
> > how we bucket that information.
> > 
> 
> That sounds plausible. A bit more involved than what I'm currently
> working with, but we do already have a blueprint for the scanning
> implementation required to collect this data via the frag command.
> Perhaps some of this code between the frag/freesp can be generalized and
> reused. I'll take a closer look at it.
> 
> My only concern is I'd prefer to only go down this path as long as we
> plan to land the associated command in xfs_db. So this approach suggests
> to me that we add a "locality" command similar to frag/freesp that
> presents the locality state of the fs. For now I'm only really concerned
> with the data associated with known near mode allocations (i.e., such as
> the extent size:distance relationship you've outlined above) so we can
> evaluate these algorithmic changes, but this would be for fs devs only
> so we could always expand on it down the road if we want to assess
> different allocations. Hm?

Yup, I'm needing to do similar analysis myself to determine how
quickly I'm aging the filesystem, so having the tool in xfs_db or
xfs_spaceman would be very useful.

FWIW, the tool I've just started writing will just use fallocate and
truncate to hammer the allocation code as hard and as quickly as
possible - I want to do accelerated aging of the filesystem, and so
being able to run tens to hundreds of thousands of free space
manipulations a second is the goal here....

> > > > (*) Which, in reality, we really should reset because once we jump
> > > > AG we have no locality target and so should allow the full AG to be
> > > > considered. This "didn't reset target" issue is something I suspect
> > > > leads to the infamous "backwards allocation for sequential writes"
> > > > problems...
> > > 
> > > I think this is something that's handled at a higher level. In the
> > > nullfb case at least, we use the XFS_ALLOCTYPE_START_BNO allocation mode
> > > which is what allows us to iterate AGs.
> > 
> > The nullfb case isn't the problem here - I think the problem comes
> > when we fail the THIS_BNO/NEAR_BNO allocation attempts in
> > xfs_bmap_btalloc() and then fall back to XFS_ALLOCTYPE_START_BNO
> > with the same fsbno target.
> > 
> 
> Ok, that's the retry where we restore minlen from maxlen back to 1. Note
> that still depends on nullfb, but that's just context. I think the
> majority of the time data allocations come into the allocator as the
> first allocation in the transaction.
> 
> That aside, I've also seen that this particular retry is hotter than
> you'd think just by glancing at the code due to the whole minlen =
> maxlen thing in xfs_bmap_select_minlen() combined with potential size of
> delalloc extents. See the patches I posted a couple weeks ago in this
> area for example:
> 
>   https://marc.info/?l=linux-xfs&m=155671950608062&w=2
> 
> ... though I don't think they relate to the issue you're tracking here.
> 
> > > We start with a near mode
> > > allocation in the target AG. If that fails, xfs_alloc_vextent() switches
> > > over to XFS_ALLOCTYPE_THIS_AG for the remaining AGs. This lands in
> > > xfs_alloc_ag_vextent_size() which ignores args.agbno even if it's set.
> > 
> > Hmmm. I think you just pointed out a bug in this code. The initial
> > NEARBNO alloc sets ->min_agbno and ->max_agbno based on the
> > args->agbno, which xfs_alloc_compute_aligned then uses to determine
> > if the found free extent can be used. When we immediately fall back
> > to XFS_ALLOCTYPE_THIS_AG allocation, we don't reset
> > min_agbno/max_agbno, and so even though we ignore the args->agbno
> > target that is set when selecting a free extent, we still call
> > xfs_alloc_compute_aligned() to determine if it is appropriate to
> > use.
> > 
> 
> I don't see where the near mode alloc assigns ->[min|max]_agbno. The
> only place I see ->min_agbno used is for sparse inode chunk allocation.
> ->max_agbno is assigned in the near mode alloc when min == 0, but it's
> set to agsize so I'm guessing that this is just an initialization so the
> checking logic works with zeroed out values from the caller.

I did say:

> > Of course, I could be missing something obvious (still haven't
> > finished my morning coffee!), so it's worth checking I read the code
> > properly....

And that's clearly the case here - I read the code that clamps agbno
to min/max backwards....

> Just to clarify.. what exactly is the reverse allocation problem you're
> thinking about here? Logically increasing writes resulting in physically
> decreasing allocations? If so, have we confirmed that writes are indeed
> sequential when this occurs (obvious I guess, but worth asking).

Precisely this. And, yes, I've confirmed many times that it is
sequential writes that display it. It happens when the closest nearest free
extent is below the current target. i.e.:


+FFFFFFFFFFFFF+aaaaaaaT+bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb+FFFFF+

We just allocated "a" so the next allocation target is T, but "b" is
already allocated there. The freespace before "a" is larger than
the free space after "b" (which may be less than maxlen), and so the
"nearest best free space" is below the target. If "b" is large
enough, we end up with file allocation that looks like (where n =
relative file offset for the given allocation)

     +10+9+8+7+6+5+4+1+2+3+

i.e. allocation starts forward, uses the remaining ascending free
space in the extent, then starts allocating backwards as it takes
the nearest free space and trims off the top of the free extent for
the allocation.

> I'm not really familiar with this problem so I've not thought about it,
> but one random thought comes to mind: is there any chance of allocation
> interlocking behind extent frees contributing to this behavior? We do
> truncate files in reverse order an extent at a time and immediately
> finish the dfops (to free the extent and busy it) before we unmap the
> next piece.

Unlikely, because such extents are not immediately avaiable for
allocation (they are busy). And I've seen it on pure contended
sequential write workloads, too...

> If allocations could interlock with such frees (or busy
> clearing), I could see in theory how that might result in backwards
> allocations, but I'm just handwaving and not sure that's possible in
> practice.

Most of the cases I've seen have had the same symptom - "skip to
next AG, allocate at same high-up-in AGBNO target as the previous AG
wanted, then allocate backwards in the same AG until freespace
extent is exhausted. It then skips to some other freespace extent,
and depending on whether it's a forwards or backwards skip the
problem either goes away or continues. This is not a new behaviour,
I first saw it some 15 years ago, but I've never been able to
provoke it reliably enough with test code to get to the root
cause...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
