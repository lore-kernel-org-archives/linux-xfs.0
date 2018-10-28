Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726450AbeJ1Wxy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 28 Oct 2018 18:53:54 -0400
Date: Sun, 28 Oct 2018 10:09:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes about 30ms to complete
Message-ID: <20181028140907.GA2050@bfoster>
References: <CAGiyNfAUewzAjASPBccOk91PJ+nLS0nF4U3EvO4n59XsYu5P-w@mail.gmail.com>
 <20181023145339.GA7537@bfoster>
 <CAGiyNfAy+eTq+oba0Rb8Oe_kajFqD5a6rPnOkWPjC_E=foSqkg@mail.gmail.com>
 <20181024043416.GA19305@dastard>
 <20181024120926.GA46681@bfoster>
 <20181024223523.GB19305@dastard>
 <20181025132130.GA2819@bfoster>
 <20181026010344.GD19305@dastard>
 <20181026130334.GA16468@bfoster>
 <20181027031607.GI19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181027031607.GI19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Mao Cheng <chengmao2010@gmail.com>, linux-xfs@vger.kernel.org

On Sat, Oct 27, 2018 at 02:16:07PM +1100, Dave Chinner wrote:
> On Fri, Oct 26, 2018 at 09:03:35AM -0400, Brian Foster wrote:
> > On Fri, Oct 26, 2018 at 12:03:44PM +1100, Dave Chinner wrote:
> > > On Thu, Oct 25, 2018 at 09:21:30AM -0400, Brian Foster wrote:
> > > > On Thu, Oct 25, 2018 at 09:35:23AM +1100, Dave Chinner wrote:
> > > > > On Wed, Oct 24, 2018 at 08:09:27AM -0400, Brian Foster wrote:
> > > > > > I'm wondering
> > > > > > if we could implement a smarter location based search using information
> > > > > > available in the by-size tree. For example, suppose we could identify
> > > > > > the closest minimally sized extents to agbno in order to better seed the
> > > > > > left/right starting points of the location based search. This of course
> > > > > > would require careful heuristics/tradeoffs to make sure we don't just
> > > > > > replace a bnobt scan with a cntbt scan.
> > > > > 
> > > > > I wouldn't bother. I'd just take the "last block" algorithm and make
> > > > > it search all the >= contiguous free space extents for best locality
> > > > > before dropping back to the minlen search.
> > > > > 
> > > > 
> > > > Ok, that makes sense. The caveat seems to be though that the "last
> > > > block" algorithm searches all of the applicable records to discover the
> > > > best locality. We could open up this search as such, but if free space
> > > > happens to be completely fragmented to >= requested extents, that could
> > > > mean every allocation falls into a full cntbt scan where a bnobt lookup
> > > > would result in a much faster allocation.
> > > 
> > > Yup, we'll need to bound it so it doesn't do stupid things. :P
> > > 
> > 
> > Yep.
> > 
> > > > So ISTM that we still need some kind of intelligent heuristic to fall
> > > > back to the second algorithm to cover the "too many" case. What exactly
> > > > that is may take some more thought, experimentation and testing.
> > > 
> > > Yeah, that's the difficulty with making core allocator algorithm
> > > changes - how to characterise the effect of the change. I'm not sure
> > > that's a huge problem in this case, though, because selecting a
> > > matching contig freespace is almost always going to be better for
> > > filesystem longetivty and freespace fragmentation resistance than
> > > slecting a shorter freespace and doing lots more small allocations.
> > > it's the 'lots of small allocations' that really makes the freespace
> > > framgmentation spiral out of control, so if we can avoid that until
> > > we've used all the matching contig free spaces we'll be better off
> > > in the long run.
> > > 
> > 
> > Ok, so I ran fs_mark against the metadump with your patch and a quick
> > hack to unconditionally scan the cntbt if maxlen extents are available
> > (up to mxr[0] records similar to your patch, to avoid excessive scans).
> > The xfs_alloc_find_best_extent() patch alone didn't have much of a
> > noticeable effect, but that is an isolated optimization and I'm only
> > doing coarse measurements atm that probably hide it in the noise.
> > 
> > The write workload improves quite a bit with the addition of the cntbt
> > change. Both throughput (via iostat 60s intervals) and fs_mark files/sec
> > change from a slow high/low sweeping behavior to much more consistent
> > and faster results. I see a sweep between 3-30 MB/s and ~30-250 f/sec
> > change to a much more consistent 27-39MB/s and ~200-300 f/s.
> 
> That looks really promising. :)
> 
> > A 5 minute tracepoint sample consists of 100% xfs_alloc_near_first
> > events which means we never fell back to the bnobt based search. I'm not
> > sure the mxr thing is the right approach necessarily, I just wanted
> > something quick that would demonstrate the potential upside gains
> > without going off the rails.
> 
> *nod*. it's a good first approximation, though. The inobt limits
> search to ~10 inobt records left and right (~1200 nearest inodes)
> and if there were none free it allocated a new chunk.
> 
> The records in the by-size tree have a secondary sort order of
> by-bno, so we know that as we walk the records of the same size,
> we'll get closer to the target we want.
> 

Yeah, this occurred to me while poking at the state of the cntbt trees
of the metadump. I was thinking specifically about whether we could use
that to optimize the existing algorithm a bit. For example, if we skip
the lastblock logic and do find many maxlen extents, use the agbno of
the first record to avoid sifting through the entire set. If the agbno
was > the requested agbno, for example, we could probably end the search
right there...

> Hmmm. I wonder.
> 
> xfs_cntbt_key_diff() discriminates first by size, and then if size
> matches by startblock. 
> 
> But xfs_alloc_vextent_near() does this:
> 
>       if ((error = xfs_alloc_lookup_ge(cnt_cur, 0, args->maxlen, &i)))
>                 goto error0;
> 
> It sets the startblock of the target lookup to be 0, which means it
> will always find the extent closest to the start of the AG of the
> same size of larger. IOWs, it looks for size without considering
> locality.
> 

... but I wasn't aware we could do this. ;)

> But the lookup can do both. ~if we change that to be:
> 
> 	error = xfs_alloc_lookup_ge(cnt_cur, args->agbno, args->maxlen, &i);
> 
> if will actually find the first block of size >= args->maxlen and
> >= args->agbno. IOWs, it does the majority of the locality search
> for us. All we need to do is check that the extent on the left side
> of the return extent is closer to the target than the extent that is
> returned.....
> 
> Which makes me wonder - can we just get rid of that first algorithm
> (the lastblock search for largest) and replace it with a simple
> lookup for args->agbno, args->maxlen + args->alignment?
> 
> That way we'll get an extent that will be big enough for alignment
> to succeed if alignment is required, big enough to fit if alignment
> is not required, or if nothing is found, we can then do a <= to find
> the first extent smaller and closest to the target:
> 
> 	error = xfs_alloc_lookup_le(cnt_cur, args->agbno, args->maxlen, &i);
> 
> If the record returned has a length = args->maxlen, then we've
> got the physically closest exact match and we should use it.
> 
> if the record is shorter than args->maxlen but > args->minlen, then
> there are no extents large enough for maxlen, then we should check
> if the right side record is closer to target and select between the
> two.
> 
> And that can replace the entirity of xfs_alloc_ag_vextent_near.
> 

My general sense to this point from the code and your feedback about the
priority of the algorithm is the fundamental problem here is that the
scope of the first algorithm is simply too narrow and the
second/fallback algorithm too expensive. At minimum, I think applying
agbno lookups to the cntbt lookup as you describe here allows us to
incorporate more locality into the first (maxlen) algorithm and widen
its scope accordingly. This sounds like a great starting point to me.
The tradeoff may be that we don't get the locality benefit of all >
maxlen sized extents since the agbno part of the lookup is secondary to
the size, but that may be a fine tradeoff if the benefit is we can use
the first/faster algorithm for a whole lot more cases.

I'm actually curious if doing that as a first step to open up the first
algo to _all_ maxlen cases has a noticeable effect on this workload. If
so, that could be a nice intermediate step to avoid paying the penalty
for the "too many >= maxlen extents" case before rewriting the broader
algorithm. The remaining effort is then to absorb the second algorithm
into the first such that the second is eventually no longer necessary.

> The existing "nothing >= maxlen" case that goes to
> xfs_alloc_ag_vextent_small() selects the largest free extent at the
> highest block number (right nost record) and so ignores locality.
> The xfs_alloc_lookup_le() lookup does they same thing, except it
> also picks the physically closest extent of the largest size. That's
> an improvement.
> 

That looks like another point where the first algorithm bails out too
quickly as well. We find !maxlen extents, decrement to get the next
(highest agbno) smallest record, then go on to check it for alignment
and whatnot without any consideration for any other records that may
exist of the same size. Unless I'm missing something, the fact that we
decrement in the _small() case and jump back to the incrementing
algorithm of the caller pretty much ensures we'll only consider one such
record before going into the fan out search.

> The lastblock case currently selects the physically closest largest
> free extent in the block that will fit the (aligned) length we
> require. We can get really close to that with a >= (args->agbno,
> args->maxlen + args->alignment) lookup
> 
> And the  <= (args->agbno, args->maxlen) finds us the largest,
> closest free extent that we can check against minlen and return
> that...
> 
> IOWs, something like this, which is a whole lot simpler and faster
> than the linear searches we do now and should return much better
> candidate extents:
> 

This all sounds pretty reasonable to me. I need to think more about the
details. I.e., whether we'd still want/need to fallback to a worst case
scan in certain cases, which may not be a problem if the first algorithm
is updated to find extents in almost all cases instead of being limited
to when there are a small number of maxlen extents.

I'm also wondering if we could enhance this further by repeating the
agbno lookup at the top for the next smallest extent size in the min/max
range when no suitable extent is found. Then perhaps the high level
algorithm is truly simplified to find the "largest available extent with
best locality for that size."

> 	check_left = true;
> 
> 	/* look for size and closeness */
> 	error = xfs_alloc_lookup_ge(cnt_cur, args->agbno,
> 				args->maxlen + alignment, &i);
> 	if (error)
> 		goto error0;
> 
> 	if (!i) {
> 		/*
> 		 * nothing >= target. Search for best <= instead so
> 		 * we get the get the largest closest match to what
> 		 * we are asking for.
> 		 */
> 		error = xfs_alloc_lookup_le(cnt_cur, args->agbno,
> 					args->maxlen + alignment, &i);
> 		if (error)
> 			goto error0;
> 
> 		/* try off the free list */
> 		if (!i) {
> 			error = xfs_alloc_ag_vextent_small(args, cnt_cur, &ltbno
> 			                                &ltlen, &i);
> 			......
> 			return ....;
> 		}
> 		check_left = false;
> 	}
> 
> 	/* best candidate found, get the record and check adjacent */
> 	error = xfs_alloc_get_rec(cnt_cur, &bno, &len, &i)
> 	....
> 
> 	if (check_left) {
> 		xfs_btree_increment(cnt_cur)
> 		xfs_alloc_get_rec(cnt_cur, altbno, &altlen &i)
> 		....
> 	} else {
> 		xfs_btree_decrement(cnt_cur)
> 		xfs_alloc_get_rec(cnt_cur, altbno, &altlen &i)
> 		....
> 	}
> 
> 	/* align results if required */
> 
> 	/* check against minlen */
> 
> 	/* compute distance diff to target */
> 
> 	/* select best extent, fixup trees */
> 
> 	/* return best extent */
> 
> > One related concern I have with restricting
> > the locality of the search too much, for example, is that we use
> > NEAR_BNO allocs for other things like inode allocation locality that
> > might not be represented in this simple write only workload.
> 
> Inode chunk allocation sets minlen == maxlen, in which case we
> should run your new by-size search to exhaustion and never hit the
> existing second algorithm. (i.e. don't bound it if minlen = maxlen)
> i.e. your new algorithm should get the same result as the existing
> code, but much faster because it's sonly searching extents we know
> can satisfy the allocation requirements. The proposed algorithm
> above would be even faster :P
> 

Yes, that makes sense. The search can potentially be made simpler in
that case. Also note that minlen == maxlen for most of the data extent
allocations in the test case I ran as well. It looks like the
xfs_bmap_btalloc*() path can use the longest free extent in the AG to
set a starting minlen and then we loosen constraints over multiple
allocation attempts if the first happen to fail.

Anyways, I'll play around with this more next week. Thanks for all of
the thoughts.

Brian

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
