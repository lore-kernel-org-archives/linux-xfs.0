Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:36165 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725845AbeJ2JD7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Oct 2018 05:03:59 -0400
Date: Mon, 29 Oct 2018 11:17:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes about 30ms to complete
Message-ID: <20181029001739.GJ19305@dastard>
References: <20181023145339.GA7537@bfoster>
 <CAGiyNfAy+eTq+oba0Rb8Oe_kajFqD5a6rPnOkWPjC_E=foSqkg@mail.gmail.com>
 <20181024043416.GA19305@dastard>
 <20181024120926.GA46681@bfoster>
 <20181024223523.GB19305@dastard>
 <20181025132130.GA2819@bfoster>
 <20181026010344.GD19305@dastard>
 <20181026130334.GA16468@bfoster>
 <20181027031607.GI19305@dastard>
 <20181028140907.GA2050@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181028140907.GA2050@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Mao Cheng <chengmao2010@gmail.com>, linux-xfs@vger.kernel.org

On Sun, Oct 28, 2018 at 10:09:08AM -0400, Brian Foster wrote:
> On Sat, Oct 27, 2018 at 02:16:07PM +1100, Dave Chinner wrote:
> > On Fri, Oct 26, 2018 at 09:03:35AM -0400, Brian Foster wrote:
> > > On Fri, Oct 26, 2018 at 12:03:44PM +1100, Dave Chinner wrote:
> > > > On Thu, Oct 25, 2018 at 09:21:30AM -0400, Brian Foster wrote:
> > > > > On Thu, Oct 25, 2018 at 09:35:23AM +1100, Dave Chinner wrote:
> > > > > > On Wed, Oct 24, 2018 at 08:09:27AM -0400, Brian Foster wrote:
> > > > > > > I'm wondering
> > > > > > > if we could implement a smarter location based search using information
> > > > > > > available in the by-size tree. For example, suppose we could identify
> > > > > > > the closest minimally sized extents to agbno in order to better seed the
> > > > > > > left/right starting points of the location based search. This of course
> > > > > > > would require careful heuristics/tradeoffs to make sure we don't just
> > > > > > > replace a bnobt scan with a cntbt scan.
> > > > > > 
> > > > > > I wouldn't bother. I'd just take the "last block" algorithm and make
> > > > > > it search all the >= contiguous free space extents for best locality
> > > > > > before dropping back to the minlen search.
> > > > > > 
> > > > > 
> > > > > Ok, that makes sense. The caveat seems to be though that the "last
> > > > > block" algorithm searches all of the applicable records to discover the
> > > > > best locality. We could open up this search as such, but if free space
> > > > > happens to be completely fragmented to >= requested extents, that could
> > > > > mean every allocation falls into a full cntbt scan where a bnobt lookup
> > > > > would result in a much faster allocation.
> > > > 
> > > > Yup, we'll need to bound it so it doesn't do stupid things. :P
> > > > 
> > > 
> > > Yep.
> > > 
> > > > > So ISTM that we still need some kind of intelligent heuristic to fall
> > > > > back to the second algorithm to cover the "too many" case. What exactly
> > > > > that is may take some more thought, experimentation and testing.
> > > > 
> > > > Yeah, that's the difficulty with making core allocator algorithm
> > > > changes - how to characterise the effect of the change. I'm not sure
> > > > that's a huge problem in this case, though, because selecting a
> > > > matching contig freespace is almost always going to be better for
> > > > filesystem longetivty and freespace fragmentation resistance than
> > > > slecting a shorter freespace and doing lots more small allocations.
> > > > it's the 'lots of small allocations' that really makes the freespace
> > > > framgmentation spiral out of control, so if we can avoid that until
> > > > we've used all the matching contig free spaces we'll be better off
> > > > in the long run.
> > > > 
> > > 
> > > Ok, so I ran fs_mark against the metadump with your patch and a quick
> > > hack to unconditionally scan the cntbt if maxlen extents are available
> > > (up to mxr[0] records similar to your patch, to avoid excessive scans).
> > > The xfs_alloc_find_best_extent() patch alone didn't have much of a
> > > noticeable effect, but that is an isolated optimization and I'm only
> > > doing coarse measurements atm that probably hide it in the noise.
> > > 
> > > The write workload improves quite a bit with the addition of the cntbt
> > > change. Both throughput (via iostat 60s intervals) and fs_mark files/sec
> > > change from a slow high/low sweeping behavior to much more consistent
> > > and faster results. I see a sweep between 3-30 MB/s and ~30-250 f/sec
> > > change to a much more consistent 27-39MB/s and ~200-300 f/s.
> > 
> > That looks really promising. :)
> > 
> > > A 5 minute tracepoint sample consists of 100% xfs_alloc_near_first
> > > events which means we never fell back to the bnobt based search. I'm not
> > > sure the mxr thing is the right approach necessarily, I just wanted
> > > something quick that would demonstrate the potential upside gains
> > > without going off the rails.
> > 
> > *nod*. it's a good first approximation, though. The inobt limits
> > search to ~10 inobt records left and right (~1200 nearest inodes)
> > and if there were none free it allocated a new chunk.
> > 
> > The records in the by-size tree have a secondary sort order of
> > by-bno, so we know that as we walk the records of the same size,
> > we'll get closer to the target we want.
> > 
> 
> Yeah, this occurred to me while poking at the state of the cntbt trees
> of the metadump. I was thinking specifically about whether we could use
> that to optimize the existing algorithm a bit. For example, if we skip
> the lastblock logic and do find many maxlen extents, use the agbno of
> the first record to avoid sifting through the entire set. If the agbno
> was > the requested agbno, for example, we could probably end the search
> right there...

I hadn't considered that, but yes, that would also shorten the
second algorithm significantly in that case.

> > Hmmm. I wonder.
> > 
> > xfs_cntbt_key_diff() discriminates first by size, and then if size
> > matches by startblock. 
> > 
> > But xfs_alloc_vextent_near() does this:
> > 
> >       if ((error = xfs_alloc_lookup_ge(cnt_cur, 0, args->maxlen, &i)))
> >                 goto error0;
> > 
> > It sets the startblock of the target lookup to be 0, which means it
> > will always find the extent closest to the start of the AG of the
> > same size of larger. IOWs, it looks for size without considering
> > locality.
> > 
> 
> ... but I wasn't aware we could do this. ;)

It's a side effect of the way the xfs_cntbt_key_diff() calculates
the distance. It will binary search on the size (by returning +/-
diff based on size), but when the size matches (i.e. diff == 0), it
then allows the binary search to continue by returning +/- based on
the startblock diff.

i.e. it will find either the first extent of a closest size match
(no locality) or the closest physical locality match of the desired
size....

> > But the lookup can do both. ~if we change that to be:
> > 
> > 	error = xfs_alloc_lookup_ge(cnt_cur, args->agbno, args->maxlen, &i);
> > 
> > if will actually find the first block of size >= args->maxlen and
> > >= args->agbno. IOWs, it does the majority of the locality search
> > for us. All we need to do is check that the extent on the left side
> > of the return extent is closer to the target than the extent that is
> > returned.....
> > 
> > Which makes me wonder - can we just get rid of that first algorithm
> > (the lastblock search for largest) and replace it with a simple
> > lookup for args->agbno, args->maxlen + args->alignment?
> > 
> > That way we'll get an extent that will be big enough for alignment
> > to succeed if alignment is required, big enough to fit if alignment
> > is not required, or if nothing is found, we can then do a <= to find
> > the first extent smaller and closest to the target:
> > 
> > 	error = xfs_alloc_lookup_le(cnt_cur, args->agbno, args->maxlen, &i);
> > 
> > If the record returned has a length = args->maxlen, then we've
> > got the physically closest exact match and we should use it.
> > 
> > if the record is shorter than args->maxlen but > args->minlen, then
> > there are no extents large enough for maxlen, then we should check
> > if the right side record is closer to target and select between the
> > two.
> > 
> > And that can replace the entirity of xfs_alloc_ag_vextent_near.
> 
> My general sense to this point from the code and your feedback about the
> priority of the algorithm is the fundamental problem here is that the
> scope of the first algorithm is simply too narrow and the
> second/fallback algorithm too expensive.

A good summary :)

> At minimum, I think applying
> agbno lookups to the cntbt lookup as you describe here allows us to
> incorporate more locality into the first (maxlen) algorithm and widen
> its scope accordingly. This sounds like a great starting point to me.
> The tradeoff may be that we don't get the locality benefit of all >
> maxlen sized extents since the agbno part of the lookup is secondary to
> the size, but that may be a fine tradeoff if the benefit is we can use
> the first/faster algorithm for a whole lot more cases.
> 
> I'm actually curious if doing that as a first step to open up the first
> algo to _all_ maxlen cases has a noticeable effect on this workload. If
> so, that could be a nice intermediate step to avoid paying the penalty
> for the "too many >= maxlen extents" case before rewriting the broader
> algorithm. The remaining effort is then to absorb the second algorithm
> into the first such that the second is eventually no longer necessary.

Yes, that seems like a sensible first experiment to perform.

> > The existing "nothing >= maxlen" case that goes to
> > xfs_alloc_ag_vextent_small() selects the largest free extent at the
> > highest block number (right nost record) and so ignores locality.
> > The xfs_alloc_lookup_le() lookup does they same thing, except it
> > also picks the physically closest extent of the largest size. That's
> > an improvement.
> > 
> 
> That looks like another point where the first algorithm bails out too
> quickly as well. We find !maxlen extents, decrement to get the next
> (highest agbno) smallest record, then go on to check it for alignment
> and whatnot without any consideration for any other records that may
> exist of the same size.

Not quite....

> Unless I'm missing something, the fact that we
> decrement in the _small() case and jump back to the incrementing
> algorithm of the caller pretty much ensures we'll only consider one such
> record before going into the fan out search.

In that case the _small() allocation finds a candidate it sets ltlen
which triggers the "reset search from start of block" case in the
first algorithm. This walks from the start of the last block to the
first extent >= minlen in the last block and then begins the search
from there.  So it does consider all the candidate free extents
in the last block large enough to be valid in the _small() case.

But, yes, it may not be considering them all.

> > The lastblock case currently selects the physically closest largest
> > free extent in the block that will fit the (aligned) length we
> > require. We can get really close to that with a >= (args->agbno,
> > args->maxlen + args->alignment) lookup
> > 
> > And the  <= (args->agbno, args->maxlen) finds us the largest,
> > closest free extent that we can check against minlen and return
> > that...
> > 
> > IOWs, something like this, which is a whole lot simpler and faster
> > than the linear searches we do now and should return much better
> > candidate extents:
> > 
> 
> This all sounds pretty reasonable to me. I need to think more about the
> details. I.e., whether we'd still want/need to fallback to a worst case
> scan in certain cases, which may not be a problem if the first algorithm
> is updated to find extents in almost all cases instead of being limited
> to when there are a small number of maxlen extents.

I think we can avoid the brute force by-bno search by being smart
with a by minlen by size search in the worst case.

> I'm also wondering if we could enhance this further by repeating the
> agbno lookup at the top for the next smallest extent size in the min/max
> range when no suitable extent is found. Then perhaps the high level
> algorithm is truly simplified to find the "largest available extent with
> best locality for that size."

We get that automatically from a <= lookup on the by size tree. i.e:

> > 	check_left = true;
> > 
> > 	/* look for size and closeness */
> > 	error = xfs_alloc_lookup_ge(cnt_cur, args->agbno,
> > 				args->maxlen + alignment, &i);
> > 	if (error)
> > 		goto error0;
> > 
> > 	if (!i) {
> > 		/*
> > 		 * nothing >= target. Search for best <= instead so
> > 		 * we get the get the largest closest match to what
> > 		 * we are asking for.
> > 		 */
> > 		error = xfs_alloc_lookup_le(cnt_cur, args->agbno,
> > 					args->maxlen + alignment, &i);

This search here will find the largest extent size that is <=
maxlen + alignment. it will either match the size and be the closest
physical extent, or it will be the largest smaller extent size
available (w/ no physical locality implied).

If we then want the physically closest extent of that largest size,
then we have to grab the length out of the record and redo the
lookup with that exact size so the by-cnt diff matches and it falls
through to checking the block numbers in the records.

I suspect what we want here is a xfs_btree_lookup_from() still of
operation that doesn't completely restart the btree search. The
cursor already holds the the path we searched to get to the current
block, so the optimal search method here is to walk back up the
current to find the point where there might be ptrs to a different
block and rerun the search from there. i.e. look at the parent block
to see if the adjacent records indicate the search might span
multiple blocks at the current level, and restart the binary search
at the level where multiple ptrs to the same extent size are found.
This means we don't have to binary search from the top of the tree
down if we've already got a cursor that points to the first extent
of the candidate size...

> > Inode chunk allocation sets minlen == maxlen, in which case we
> > should run your new by-size search to exhaustion and never hit the
> > existing second algorithm. (i.e. don't bound it if minlen = maxlen)
> > i.e. your new algorithm should get the same result as the existing
> > code, but much faster because it's sonly searching extents we know
> > can satisfy the allocation requirements. The proposed algorithm
> > above would be even faster :P
> 
> Yes, that makes sense. The search can potentially be made simpler in
> that case. Also note that minlen == maxlen for most of the data extent
> allocations in the test case I ran as well. It looks like the
> xfs_bmap_btalloc*() path can use the longest free extent in the AG to
> set a starting minlen and then we loosen constraints over multiple
> allocation attempts if the first happen to fail.

*nod*

FWIW, xfs_alloc_ag_vextent_size() is effectively minlen == maxlen
allocation. It will either return a maxlen freespace (aligned if
necessary) or fail.

However, now that I look, it does not consider physical locality at
all - it's just a "take the first extent of size large enough to fit
the desired size" algorithm, and it also falls back to a linear
search of extents >= the size target until it finds an extent that
aligns correctly.

I think this follows from the case that xfs_alloc_ag_vextent_size()
is used - it's used for the XFS_ALLOCTYPE_THIS_AG policy, which
means "find the first extent of at least maxlen in this AG". So
it's really just a special case of a near allocation where the
physical locatlity target is the start of the AG. i.e:
XFS_ALLOCTYPE_NEAR_BNO w/ {minlen = maxlen, args->agbno = 0}

IOWs, I suspect we need to step back for a moment and consider how
we should refactor this code because the different algorithms are
currently a result of separation by high level policy rather than
low level allocation selection requirements and as such, we have
some semi-duplication in functionality in the algorithms that could
be removed. Right now it seems the policies fall into these
categories:

	1. size >= maxlen, nearest bno 0 (_size)
	2. exact bno, size >= minlen (_exact)
	3. size >= maxlen, nearest bno target (_near algorithm 1)
	4. size >= minlen, nearest bno target (_near, algorithm 2)

Case 1 is the same as case 3 but with a neares bno target of 0.
Case 2 is the same as case 4 except it fails if the nearest bno
target is not an exact match. Seems like a lot of scope for
factoring and simplification here - there's only two free extent
selection algorithms here, not 4....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
