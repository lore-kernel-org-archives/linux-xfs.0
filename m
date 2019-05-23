Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38940 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387616AbfEWWP5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 18:15:57 -0400
Date: Fri, 24 May 2019 08:15:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 00/11] xfs: rework extent allocation
Message-ID: <20190523221552.GM29573@dread.disaster.area>
References: <20190522180546.17063-1-bfoster@redhat.com>
 <20190523015659.GL29573@dread.disaster.area>
 <20190523125535.GA20099@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523125535.GA20099@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 08:55:35AM -0400, Brian Foster wrote:
> On Thu, May 23, 2019 at 11:56:59AM +1000, Dave Chinner wrote:
> > On Wed, May 22, 2019 at 02:05:35PM -0400, Brian Foster wrote:
> > > Hi all,
> > > 
> > > This is v2 of the extent allocation rework series. The changes in this
> > > version are mostly associated with code factoring, based on feedback to
> > > v1. The small mode helper refactoring has been isolated and pulled to
> > > the start of the series. The active flag that necessitated the btree
> > > cursor container structure has been pushed into the xfs_btree_cur
> > > private area. The resulting high level allocation code in
> > > xfs_ag_alloc_vextent() has been cleaned up to remove an unnecessary
> > > level of abstraction. Finally, there are various minor cleanups and
> > > fixes.
> > > 
> > > On the testing front, I've run a couple more filebench oriented tests
> > > since v1. The first is a high load, large filesystem, parallel file
> > > write+fsync test to try and determine whether the modified near mode
> > > allocation algorithm resulted in larger latencies in the common
> > > (non-fragmented) case. The results show comparable latencies, though the
> > > updated algorithm has a slightly faster overall runtime for whatever
> > > reason.
> > 
> > Probably indicative that over so many allocations, saving a few
> > microseconds of CPU time here and there adds up. That's also a fairly
> > good indication that the IO behaviour hasn't dramatically changed
> > between algorithms - we're not adding or removing a huge number of
> > seeks to the workload....
> > 
> 
> Makes sense. The goal here (and purpose for the higher level testing) is
> basically to confirm this doesn't break/regress the common
> (non-fragmented) allocation scenario. I suppose that's a bonus if we
> find some incremental speedups along the way..

*nod*

[snip]


> > In this case, 7TB, 32AGs = ~220GB per AG, so an AG skip will be
> > around 220 * 2^30 / 2^9 = ~460m sectors and:
> > 
> > > - baseline	- min: 8  max: 568752250 median: 434794.5 mean: 11446328
> > > - test		- min: 33 max: 568402234 median: 437405.5 mean: 11752963
> > > - by-size only	- min: 33 max: 568593146 median: 784805   mean: 11912300
> > 
> > max are all >460m sectors and so are AG skip distances.
> > 
> 
> Though it is interesting that the average and median are within that
> ~460m sector delta. I think that means this is at least catching some
> information on intra-AG locality as many of these files might not have
> had to jump AGs.

[....]

> But while I don't think the current number is completely bogus, I agree
> that it's diluted by those larger files that do happen to jump AGs and
> thus it is probably missing critical information about file extension
> allocation locality.

*nod*

[....]

> > So, AFAICT, the measure of locality we should be using to evaluate
> > the impact to locality of the new algorithm is the distance between
> > sequential extents in a file allocated within the same AG, not the
> > worst case distance from the inode....
> > 
> 
> Yeah, makes sense. I created metadumps of each filesystem created for
> this test in anticipation of tweaks to the post-processing heuristic.

Nice :)

> I assume we still want to fold this measurement up into some mean/median
> locality value for the overall filesystem for comparison purposes, but
> how would you prefer to see that tracked on a per-inode basis? I could
> still track the worst case stride from one extent to the next within an
> inode (provided they sit in the same AG), or we could do something like
> track the average stride for each inode, or average stride in general
> across all intra-AG extents.

Histograms are probably the best way to demonstrate the general
distribution of the data set. Average/median don't really convey
much other than whether the dataset is skewed to one end or another,
while histograms will give us a good indication in the change of
"distance from target" over a wide range of the filesystem. It can
even incorporate "skipped AG" as a bucket to indicate how often
thatis occurring and whether the change in algorithms
increase/decreases the occurence of that.

FWIW, I suspect a histogram that describes "extent size vs locality
of next extent" will give us an idea of whether small or large
allocations have worse locality. I'd also expect a measure like this
to give insight into how badly free space fragmentation is affecting
the filesystem, as it will tend to push the extent size distribution
towards the smaller end of the scale....

> Hmmm.. I suppose if I had a script that
> just dumped every applicable stride/delta value for an inode, I could
> dump all of those numbers into a file and we can process it from there..

See how the freesp commands work in xfs_db - they just generate a
set of {offset, size} tuples that are then bucketted appropriately.
This is probably the best way to do this at the moment - have xfs_db
walk the inode BMBTs outputting something like {extent size,
distance to next extent} tuples and everything else falls out from
how we bucket that information.


> > (*) Which, in reality, we really should reset because once we jump
> > AG we have no locality target and so should allow the full AG to be
> > considered. This "didn't reset target" issue is something I suspect
> > leads to the infamous "backwards allocation for sequential writes"
> > problems...
> 
> I think this is something that's handled at a higher level. In the
> nullfb case at least, we use the XFS_ALLOCTYPE_START_BNO allocation mode
> which is what allows us to iterate AGs.

The nullfb case isn't the problem here - I think the problem comes
when we fail the THIS_BNO/NEAR_BNO allocation attempts in
xfs_bmap_btalloc() and then fall back to XFS_ALLOCTYPE_START_BNO
with the same fsbno target.

> We start with a near mode
> allocation in the target AG. If that fails, xfs_alloc_vextent() switches
> over to XFS_ALLOCTYPE_THIS_AG for the remaining AGs. This lands in
> xfs_alloc_ag_vextent_size() which ignores args.agbno even if it's set.

Hmmm. I think you just pointed out a bug in this code. The initial
NEARBNO alloc sets ->min_agbno and ->max_agbno based on the
args->agbno, which xfs_alloc_compute_aligned then uses to determine
if the found free extent can be used. When we immediately fall back
to XFS_ALLOCTYPE_THIS_AG allocation, we don't reset
min_agbno/max_agbno, and so even though we ignore the args->agbno
target that is set when selecting a free extent, we still call
xfs_alloc_compute_aligned() to determine if it is appropriate to
use.

I think the bug here is that xfs_alloc_compute_aligned() applies the
NEARBNO args->min_agbno to the free extent found by the THIS_AG
allocation, and so if the large free extent in the new AG overlaps
min_agbno it selects the higher up part of the free extent that
starts at min_agbno, rather than using the start of the free
extent...

Of course, I could be missing something obvious (still haven't
finished my morning coffee!), so it's worth checking I read the code
properly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
