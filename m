Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:41349 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728410AbeJVSKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Oct 2018 14:10:01 -0400
Date: Mon, 22 Oct 2018 20:52:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ENSOPC on a 10% used disk
Message-ID: <20181022095207.GA6311@dastard>
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181018013727.GE6311@dastard>
 <39c3af2d-d591-c6bc-d586-245f1ca69a71@scylladb.com>
 <20181018100504.GH6311@dastard>
 <87bf239a-29c2-6db5-6781-42743c9c7d5d@scylladb.com>
 <85530ca3-22ef-21e5-a4da-1f924a6e2d7e@scylladb.com>
 <20181019075109.GM6311@dastard>
 <da5448d6-2ea1-ac8b-e21c-ce1124d400a1@scylladb.com>
 <20181021142847.GO6311@dastard>
 <0b69189c-033f-e7c1-3987-de67ea43d2ac@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b69189c-033f-e7c1-3987-de67ea43d2ac@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 22, 2018 at 11:35:26AM +0300, Avi Kivity wrote:
> 
> On 21/10/2018 17.28, Dave Chinner wrote:
> >On Sun, Oct 21, 2018 at 11:55:47AM +0300, Avi Kivity wrote:
> >>For sure fragmentation would have degraded performance sooner or
> >>later, but that's not as bad as that ENOSPC.
> >What it comes down to is that having looked into it, I don't know
> >why that ENOSPC error occurred.
> >
> >Alignment didn't cause it because alignment was being dropped - that
> >just caused free space fragmentation.  Extent size hints didn't
> >cause it because the size hints were dropped - that just caused
> >freespace fragmentation. A lack of free space
> >didn't cause it, because there was heaps of free space in all
> >allocation groups.
> >
> >But something tickled a corner case that triggered an allocation
> >failure that was interpretted as ENOSPC rather than retrying the
> >allocation.  Until I can reproduce the ENOSPC allocation failure
> >(and I tried!) then it'll be a mystery as to what caused it.
> 
> 
> The user reported the error happening multiple times, taking many
> hours to reproduce, but on more than one node. So it's an obscure
> corner case but not obscure enough to be a one-off event.

Yeah, as with all these sorts of things, the difficulty is in
reproducing it. I'll have a look through some of the higher level
code during the week to see if there's a min/max len condition I
missed somewhere that might lead to failure instead of a retry.
Because it shouldn't really fail at all because in the end a single
block allocation is allowable for normal extent size w/ alignemnt
allocation and there is heaps of free available.

> >>entire file. But I think that, given that the extent size is treated
> >>as a hint (or so I infer from the fact that we have <32MB extents),
> >>so should the alignment. Perhaps allocation with a hint should be
> >>performed in two passes, first trying to match size and alignment,
> >>and second relaxing both restrictions.
> >I think I already mentioned there were 5 separate attmepts to
> >allocate, each failure reducing restrictions:
> >
> >1. extent sized and contiguous to adjacent block in file
> >2. extent sized and aligned, at higher block in AG
> >3. extent sized, not aligned, at higher block in AG
> >4. >= minimum length, not aligned, anywhere in AG >= target AG
> 
> 
> Surprised at this one. Won't it skew usage in high AGs?

It's a constraint based on AG locking order. We always lock in
ascending AG order, so if we've locked AG 4 and modified the free
list in preparation for allocation, then failed to find an aligned
extent, that will remain locked until we finish the allocation
process and hence we can't lock AGs <= AG 4 otherwise we risk
deadlocking the allocator.....

> Perhaps it's rare enough not to matter.

It tends to be reare because we chose the ag ahead of time to ensure
that the majority of the time there is space available.

> Thanks for your patience in helping me understand this issue.

No worries, what I'm here for :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
