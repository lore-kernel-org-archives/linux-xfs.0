Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbeJZVki (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Oct 2018 17:40:38 -0400
Date: Fri, 26 Oct 2018 09:03:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes about 30ms to complete
Message-ID: <20181026130334.GA16468@bfoster>
References: <CAGiyNfAUewzAjASPBccOk91PJ+nLS0nF4U3EvO4n59XsYu5P-w@mail.gmail.com>
 <20181023145339.GA7537@bfoster>
 <CAGiyNfAy+eTq+oba0Rb8Oe_kajFqD5a6rPnOkWPjC_E=foSqkg@mail.gmail.com>
 <20181024043416.GA19305@dastard>
 <20181024120926.GA46681@bfoster>
 <20181024223523.GB19305@dastard>
 <20181025132130.GA2819@bfoster>
 <20181026010344.GD19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181026010344.GD19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Mao Cheng <chengmao2010@gmail.com>, linux-xfs@vger.kernel.org

On Fri, Oct 26, 2018 at 12:03:44PM +1100, Dave Chinner wrote:
> On Thu, Oct 25, 2018 at 09:21:30AM -0400, Brian Foster wrote:
> > On Thu, Oct 25, 2018 at 09:35:23AM +1100, Dave Chinner wrote:
> > > On Wed, Oct 24, 2018 at 08:09:27AM -0400, Brian Foster wrote:
> > > > I'm wondering
> > > > if we could implement a smarter location based search using information
> > > > available in the by-size tree. For example, suppose we could identify
> > > > the closest minimally sized extents to agbno in order to better seed the
> > > > left/right starting points of the location based search. This of course
> > > > would require careful heuristics/tradeoffs to make sure we don't just
> > > > replace a bnobt scan with a cntbt scan.
> > > 
> > > I wouldn't bother. I'd just take the "last block" algorithm and make
> > > it search all the >= contiguous free space extents for best locality
> > > before dropping back to the minlen search.
> > > 
> > 
> > Ok, that makes sense. The caveat seems to be though that the "last
> > block" algorithm searches all of the applicable records to discover the
> > best locality. We could open up this search as such, but if free space
> > happens to be completely fragmented to >= requested extents, that could
> > mean every allocation falls into a full cntbt scan where a bnobt lookup
> > would result in a much faster allocation.
> 
> Yup, we'll need to bound it so it doesn't do stupid things. :P
> 

Yep.

> > So ISTM that we still need some kind of intelligent heuristic to fall
> > back to the second algorithm to cover the "too many" case. What exactly
> > that is may take some more thought, experimentation and testing.
> 
> Yeah, that's the difficulty with making core allocator algorithm
> changes - how to characterise the effect of the change. I'm not sure
> that's a huge problem in this case, though, because selecting a
> matching contig freespace is almost always going to be better for
> filesystem longetivty and freespace fragmentation resistance than
> slecting a shorter freespace and doing lots more small allocations.
> it's the 'lots of small allocations' that really makes the freespace
> framgmentation spiral out of control, so if we can avoid that until
> we've used all the matching contig free spaces we'll be better off
> in the long run.
> 

Ok, so I ran fs_mark against the metadump with your patch and a quick
hack to unconditionally scan the cntbt if maxlen extents are available
(up to mxr[0] records similar to your patch, to avoid excessive scans).
The xfs_alloc_find_best_extent() patch alone didn't have much of a
noticeable effect, but that is an isolated optimization and I'm only
doing coarse measurements atm that probably hide it in the noise.

The write workload improves quite a bit with the addition of the cntbt
change. Both throughput (via iostat 60s intervals) and fs_mark files/sec
change from a slow high/low sweeping behavior to much more consistent
and faster results. I see a sweep between 3-30 MB/s and ~30-250 f/sec
change to a much more consistent 27-39MB/s and ~200-300 f/s.

A 5 minute tracepoint sample consists of 100% xfs_alloc_near_first
events which means we never fell back to the bnobt based search. I'm not
sure the mxr thing is the right approach necessarily, I just wanted
something quick that would demonstrate the potential upside gains
without going off the rails. One related concern I have with restricting
the locality of the search too much, for example, is that we use
NEAR_BNO allocs for other things like inode allocation locality that
might not be represented in this simple write only workload.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
