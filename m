Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50510 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbfFGM4W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jun 2019 08:56:22 -0400
Date: Fri, 7 Jun 2019 08:56:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 00/11] xfs: rework extent allocation
Message-ID: <20190607125618.GB57123@bfoster>
References: <20190522180546.17063-1-bfoster@redhat.com>
 <20190523015659.GL29573@dread.disaster.area>
 <20190523125535.GA20099@bfoster>
 <20190523221552.GM29573@dread.disaster.area>
 <20190524120015.GA32730@bfoster>
 <20190525224317.GZ29573@dread.disaster.area>
 <20190531171136.GA26315@bfoster>
 <20190606220558.GB14308@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606220558.GB14308@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 07, 2019 at 08:05:59AM +1000, Dave Chinner wrote:
> On Fri, May 31, 2019 at 01:11:36PM -0400, Brian Foster wrote:
> > On Sun, May 26, 2019 at 08:43:17AM +1000, Dave Chinner wrote:
> > > Most of the cases I've seen have had the same symptom - "skip to
> > > next AG, allocate at same high-up-in AGBNO target as the previous AG
> > > wanted, then allocate backwards in the same AG until freespace
> > > extent is exhausted. It then skips to some other freespace extent,
> > > and depending on whether it's a forwards or backwards skip the
> > > problem either goes away or continues. This is not a new behaviour,
> > > I first saw it some 15 years ago, but I've never been able to
> > > provoke it reliably enough with test code to get to the root
> > > cause...
> > > 
> > 
> > I guess the biggest question to me is whether we're more looking for a
> > backwards searching pattern or a pattern where we split up a larger free
> > extent into smaller chunks (in reverse), or both. I can definitely see
> > some isolated areas where a backwards search could lead to this
> > behavior. E.g., my previous experiment to replace near mode allocs with
> > size mode allocs always allocates in reverse when free space is
> > sufficiently fragmented. To see this in practice would require repeated
> > size mode allocations, however, which I think is unlikely because once
> > we jump AGs and do a size mode alloc, the subsequent allocs should be
> > near mode within the new AG (unless we jump again and again, which I
> > don't think is consistent with what you're describing).
> > 
> > Hmm, the next opportunity for this kind of behavior in the near mode
> > allocator is probably the bnobt left/right span. This would require the
> > right circumstances to hit. We'd have to bypass the first (cntbt)
> > algorithm then find a closer extent in the left mode search vs. the
> > right mode search, and then probably repeat that across however many
> > allocations it takes to work out of this state.
> > 
> > If instead we're badly breaking up an extent in the wrong order, it
> > looks like we do have the capability to allocate the right portion of an
> > extent (in xfs_alloc_compute_diff()) but that is only enabled for non
> > data allocations. xfs_alloc_compute_aligned() can cause a similar effect
> > if alignment is set, but I'm not sure that would break up an extent into
> > more than one usable chunk.
> 
> This is pretty much matches what I've been able to infer about the
> cause, but lacking a way to actually trigger it and be able to
> monitor the behviour in real time is where I've got stuck on this.
> I see the result in aged, fragmented filesystems and can infer how
> it may have occurred, but can't cause it to occur on demand...
> 

Ok.

> > In any event, maybe I'll hack some temporary code in the xfs_db locality
> > stuff to quickly flag whether I happen to get lucky enough to reproduce
> > any instances of this during the associated test workloads (and if so,
> > try and collect more data).
> 
> *nod*
> 
> Best we can do, I think, and hope we stumble across an easily
> reproducable trigger...
> 

Unfortunately I haven't seen any instances of this in the workloads I
ran to generate the most recent datasets. I have a couple more
experiments to try though so I'll keep an eye out.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
