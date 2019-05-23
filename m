Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58980 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbfEWMzo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 May 2019 08:55:44 -0400
Date: Thu, 23 May 2019 08:55:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 00/11] xfs: rework extent allocation
Message-ID: <20190523125535.GA20099@bfoster>
References: <20190522180546.17063-1-bfoster@redhat.com>
 <20190523015659.GL29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523015659.GL29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 11:56:59AM +1000, Dave Chinner wrote:
> On Wed, May 22, 2019 at 02:05:35PM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > This is v2 of the extent allocation rework series. The changes in this
> > version are mostly associated with code factoring, based on feedback to
> > v1. The small mode helper refactoring has been isolated and pulled to
> > the start of the series. The active flag that necessitated the btree
> > cursor container structure has been pushed into the xfs_btree_cur
> > private area. The resulting high level allocation code in
> > xfs_ag_alloc_vextent() has been cleaned up to remove an unnecessary
> > level of abstraction. Finally, there are various minor cleanups and
> > fixes.
> > 
> > On the testing front, I've run a couple more filebench oriented tests
> > since v1. The first is a high load, large filesystem, parallel file
> > write+fsync test to try and determine whether the modified near mode
> > allocation algorithm resulted in larger latencies in the common
> > (non-fragmented) case. The results show comparable latencies, though the
> > updated algorithm has a slightly faster overall runtime for whatever
> > reason.
> 
> Probably indicative that over so many allocations, saving a few
> microseconds of CPU time here and there adds up. That's also a fairly
> good indication that the IO behaviour hasn't dramatically changed
> between algorithms - we're not adding or removing a huge number of
> seeks to the workload....
> 

Makes sense. The goal here (and purpose for the higher level testing) is
basically to confirm this doesn't break/regress the common
(non-fragmented) allocation scenario. I suppose that's a bonus if we
find some incremental speedups along the way..

> > The second is another filebench test (but with a smaller fileset against
> > a smaller filesystem), but with the purpose of measuring "locality
> > effectiveness" of the updated algorithm via post-test analysis of the
> > resulting/populated filesystem. I've been thinking a bit about how to
> > test for locality since starting on this series and ultimately came up
> > with the following, fairly crude heuristic: track and compare the worst
> > locality allocation for each regular file inode in the fs.
> 
> OK, that's pretty crude :P
> 

Yeah, this was just a start and I figured it might generate some
feedback... ;)

> > This
> > essentially locates the most distant extent for each inode, tracks the
> > delta from that extent to the inode location on disk and calculates the
> > average worst case delta across the entire set of regular files. The
> > results show that the updated algorithm provides a comparable level of
> > locality to the existing algorithm.
> 
> The problem with this is that worse case locality isn't a
> particularly useful measure. In general, when you have allocator
> contention it occurs on the AGF locks and so the allocator skips to
> the next AG it can lock. That means if we have 32 AGs and 33
> allocations in progress at once, the AG that it chosen for
> allocation is going to be essentially random. This means worst case
> allocation locality is always going to be "ag skip" distances and so
> the jumps between AGs are going to largely dominate the measured
> locality distances.
> 

Good point. I was thinking about rerunning this with agcount=1 (with a
lighter workload) to isolate the analysis to a single AG, but wanted to
get this on the list for feedback given the time it takes populate the
fs and whatnot.

> In this case, 7TB, 32AGs = ~220GB per AG, so an AG skip will be
> around 220 * 2^30 / 2^9 = ~460m sectors and:
> 
> > - baseline	- min: 8  max: 568752250 median: 434794.5 mean: 11446328
> > - test		- min: 33 max: 568402234 median: 437405.5 mean: 11752963
> > - by-size only	- min: 33 max: 568593146 median: 784805   mean: 11912300
> 
> max are all >460m sectors and so are AG skip distances.
> 

Though it is interesting that the average and median are within that
~460m sector delta. I think that means this is at least catching some
information on intra-AG locality as many of these files might not have
had to jump AGs. Taking a look at the dataset, this could be because the
majority of these files are on the smaller side and consist of one or
two extents. There's also plenty of RAM (64GB) on the box I happened to
use.

For reference, the file sizes in the set are defined by the following
filebench mapping:

{{50, 4k, 1m},
 {35, 10m, 100m},
 {10, 500m, 1g},
 {5, 1g, 8g}
}

... where the first value is the percentage and the next two are a size
range. E.g., 50% of files are 4k-1m, 35% are 10m-100m, etc. I can
obviously tweak this however necessary to provide most useful results or
test different distributions.

But while I don't think the current number is completely bogus, I agree
that it's diluted by those larger files that do happen to jump AGs and
thus it is probably missing critical information about file extension
allocation locality.

> However, the changes you've made affect locality for allocations
> _within_ an AG, not across the filesystem, and so anything that
> skips to another AG really needs to be measured differently.
> 
> i.e. what we really need to measure here is "how close to target did
> we get?" and for extending writes the target is always the AGBNO of
> the end of the last extent.
> 
> The inode itself is only used as the target for the first extent, so
> using it as the only distance comparison ignores the fact we try to
> allocate as close to the end of the last extent as possible, not as
> close to the inode as possible. Hence once a file has jumped AG, it
> will stay in the new AG and not return to the original AG the inode
> is in. This means that once the file data changes locality, it tries
> to keep that same locality for the next data that is written, not
> force another seek back to the original location.
> 

Ok, I was thinking that locality is always based on inode location. I
see that xfs_bmap_btalloc() assigns ap->blkno (which makes its way to
args.fsbno/agbno) based on the inode, but I missed the
xfs_bmap_adjacent() call right after that which overrides ap->blkno
based on the previous extent, if applicable.

So this means that the worst case locality based on inode location is
actually invalid for (sequentially written) multi-extent files because
once we create a discontiguity, we're not measuring against the locality
target that was actually used by the algorithm (even within the same
AG).

> So, AFAICT, the measure of locality we should be using to evaluate
> the impact to locality of the new algorithm is the distance between
> sequential extents in a file allocated within the same AG, not the
> worst case distance from the inode....
> 

Yeah, makes sense. I created metadumps of each filesystem created for
this test in anticipation of tweaks to the post-processing heuristic.

I assume we still want to fold this measurement up into some mean/median
locality value for the overall filesystem for comparison purposes, but
how would you prefer to see that tracked on a per-inode basis? I could
still track the worst case stride from one extent to the next within an
inode (provided they sit in the same AG), or we could do something like
track the average stride for each inode, or average stride in general
across all intra-AG extents. Hmmm.. I suppose if I had a script that
just dumped every applicable stride/delta value for an inode, I could
dump all of those numbers into a file and we can process it from there..

I'll play around with this some more. Thanks for the feedback!

> Cheers,
> 
> Dave.
> 
> (*) Which, in reality, we really should reset because once we jump
> AG we have no locality target and so should allow the full AG to be
> considered. This "didn't reset target" issue is something I suspect
> leads to the infamous "backwards allocation for sequential writes"
> problems...
> 

I think this is something that's handled at a higher level. In the
nullfb case at least, we use the XFS_ALLOCTYPE_START_BNO allocation mode
which is what allows us to iterate AGs. We start with a near mode
allocation in the target AG. If that fails, xfs_alloc_vextent() switches
over to XFS_ALLOCTYPE_THIS_AG for the remaining AGs. This lands in
xfs_alloc_ag_vextent_size() which ignores args.agbno even if it's set.

Brian

> -- 
> Dave Chinner
> david@fromorbit.com
