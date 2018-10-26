Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:18234 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725817AbeJZJjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 05:39:11 -0400
Date: Fri, 26 Oct 2018 12:03:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes about 30ms to complete
Message-ID: <20181026010344.GD19305@dastard>
References: <CAGiyNfAUewzAjASPBccOk91PJ+nLS0nF4U3EvO4n59XsYu5P-w@mail.gmail.com>
 <20181023145339.GA7537@bfoster>
 <CAGiyNfAy+eTq+oba0Rb8Oe_kajFqD5a6rPnOkWPjC_E=foSqkg@mail.gmail.com>
 <20181024043416.GA19305@dastard>
 <20181024120926.GA46681@bfoster>
 <20181024223523.GB19305@dastard>
 <20181025132130.GA2819@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181025132130.GA2819@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Mao Cheng <chengmao2010@gmail.com>, linux-xfs@vger.kernel.org

On Thu, Oct 25, 2018 at 09:21:30AM -0400, Brian Foster wrote:
> On Thu, Oct 25, 2018 at 09:35:23AM +1100, Dave Chinner wrote:
> > On Wed, Oct 24, 2018 at 08:09:27AM -0400, Brian Foster wrote:
> > > I'm wondering
> > > if we could implement a smarter location based search using information
> > > available in the by-size tree. For example, suppose we could identify
> > > the closest minimally sized extents to agbno in order to better seed the
> > > left/right starting points of the location based search. This of course
> > > would require careful heuristics/tradeoffs to make sure we don't just
> > > replace a bnobt scan with a cntbt scan.
> > 
> > I wouldn't bother. I'd just take the "last block" algorithm and make
> > it search all the >= contiguous free space extents for best locality
> > before dropping back to the minlen search.
> > 
> 
> Ok, that makes sense. The caveat seems to be though that the "last
> block" algorithm searches all of the applicable records to discover the
> best locality. We could open up this search as such, but if free space
> happens to be completely fragmented to >= requested extents, that could
> mean every allocation falls into a full cntbt scan where a bnobt lookup
> would result in a much faster allocation.

Yup, we'll need to bound it so it doesn't do stupid things. :P

> So ISTM that we still need some kind of intelligent heuristic to fall
> back to the second algorithm to cover the "too many" case. What exactly
> that is may take some more thought, experimentation and testing.

Yeah, that's the difficulty with making core allocator algorithm
changes - how to characterise the effect of the change. I'm not sure
that's a huge problem in this case, though, because selecting a
matching contig freespace is almost always going to be better for
filesystem longetivty and freespace fragmentation resistance than
slecting a shorter freespace and doing lots more small allocations.
it's the 'lots of small allocations' that really makes the freespace
framgmentation spiral out of control, so if we can avoid that until
we've used all the matching contig free spaces we'll be better off
in the long run.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
