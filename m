Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10412 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756405AbeAHV4F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jan 2018 16:56:05 -0500
Date: Mon, 8 Jan 2018 16:56:03 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 2/4] xfs: defer agfl block frees when dfops is
 available
Message-ID: <20180108215602.GA43411@bfoster.bfoster>
References: <20171207185810.48757-1-bfoster@redhat.com>
 <20171207185810.48757-3-bfoster@redhat.com>
 <20171207224126.GJ4094@dastard>
 <20171208141629.GB55826@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171208141629.GB55826@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

cc Darrick

On Fri, Dec 08, 2017 at 09:16:30AM -0500, Brian Foster wrote:
> On Fri, Dec 08, 2017 at 09:41:26AM +1100, Dave Chinner wrote:
> > On Thu, Dec 07, 2017 at 01:58:08PM -0500, Brian Foster wrote:
...
> > 
> > Ok, so it uses the EFI/EFD to make sure that the block freeing is
> > logged and replayed. So my question is:
> > 
> > > +/*
> > > + * AGFL blocks are accounted differently in the reserve pools and are not
> > > + * inserted into the busy extent list.
> > > + */
> > > +STATIC int
> > > +xfs_agfl_free_finish_item(
> > > +	struct xfs_trans		*tp,
> > > +	struct xfs_defer_ops		*dop,
> > > +	struct list_head		*item,
> > > +	void				*done_item,
> > > +	void				**state)
> > > +{
> > 
> > How does this function get called by log recovery when processing
> > the EFI as there is no flag in the EFI that says this was a AGFL
> > block?
> > 
> 
> It doesn't...
> 
> > That said, I haven't traced through whether this matters or not,
> > but I suspect it does because freelist frees use XFS_AG_RESV_AGFL
> > and that avoids accounting the free to the superblock counters
> > because the block is already accounted as free space....
> > 
> 
> I don't think it does matter. I actually tested log recovery precisely
> for this question, to see whether the traditional EFI recovery path
> would disrupt accounting or anything and I didn't reproduce any problems
> (well, except for that rmap record cleanup failure thing).
> 
> However, I do still need to trace through and understand why that is, to
> know for sure that there aren't any problems lurking here (and if not, I
> should probably document it), but I suspect the reason is that the
> differences between how agfl and regular blocks are handled here only
> affect in-core state of the AG reservation pools. These are all
> reinitialized from zero on a subsequent mount based on the on-disk state
> (... but good point, and I will try to confirm that before posting a
> non-RFC variant).
> 

After catching back up with this and taking a closer look at the code, I
can confirm that generic EFI recovery works fine for deferred AGFL block
frees. What happens is essentially that the slot is freed and the block
free is deferred in a particular tx. If we crash before that tx commits,
then obviously nothing changes and we're fine. If we crash after that tx
commits, EFI recovery frees the block and the AGFL reserve pool
adjustment is irrelevant as the in-core res counters are initialized
from the current state of the fs after log recovery has completed (so
even if we knew this was an agfl block, attempting reservation
adjustments at recovery time would probably be wrong).

That aside, looking through the perag res code had me a bit curious
about why we reserve all agfl blocks in the first place. IIUC, the AGFL
reserve pool actually serves the rmapbt, since that (and that alone) is
what the mount time reservation is based on. AGFL blocks can be used for
other purposes, however, and the current runtime reservation is adjusted
based on all AGFL activity. Is there a reason this reserve pool does not
specifically target rmapbt allocations? Doesn't not doing so allow some
percentage of the rmapbt reserved blocks to be consumed by other
structures (alloc btrees) until/unless the fs is remounted? I'm
wondering if specifically there's a risk of something like the
following:

- mount fs with some number N of AGFL reserved blocks based on current
  rmapbt state. Suppose the size of the rmapbt is R.
- A bunch of agfl blocks are used over time (U). Suppose 50% of those go
  to the rmapbt and the other 50% to alloc btrees and whatnot.
  ar_reserved is reduced by U, but R only increases by U/2.
- a bunch more unrelated physical allocations occur and consume all
  non-reserved space
- the fs unmounts/mounts and the perag code looks for the remaining U/2
  blocks to reserve for the rmapbt, but not all of those blocks are
  available because we depleted the reserved pool faster than the rmapbt
  grew.

Darrick, hm? FWIW, a quick test to allocate 100% of an AG to a file,
punch out every other block for a few minutes and then remount kind of
shows what I'm wondering about:

 mount-3215  [002] ...1  1642.401846: xfs_ag_resv_init: dev 253:3 agno 0 resv 2 freeblks 259564 flcount 6 resv 3193 ask 3194 len 3194
...
 <...>-28260 [000] ...1  1974.946866: xfs_ag_resv_alloc_extent: dev 253:3 agno 0 resv 2 freeblks 36317 flcount 9 resv 2936 ask 3194 len 1                                                                                            
 <...>-28428 [002] ...1  1976.371830: xfs_ag_resv_alloc_extent: dev 253:3 agno 0 resv 2 freeblks 36483 flcount 9 resv 2935 ask 3194 len 1                                                                                            
 <...>-28490 [002] ...1  1976.898147: xfs_ag_resv_alloc_extent: dev 253:3 agno 0 resv 2 freeblks 36544 flcount 9 resv 2934 ask 3194 len 1                                                                                            
 <...>-28491 [002] ...1  1976.907967: xfs_ag_resv_alloc_extent: dev 253:3 agno 0 resv 2 freeblks 36544 flcount 9 resv 2933 ask 3194 len 1                                                                                            
umount-28664 [002] ...1  1983.335444: xfs_ag_resv_free: dev 253:3 agno 0 resv 2 freeblks 36643 flcount 10 resv 2932 ask 3194 len 0                                                                                                   
 mount-28671 [000] ...1  1991.396640: xfs_ag_resv_init: dev 253:3 agno 0 resv 2 freeblks 36643 flcount 10 resv 3038 ask 3194 len 3194                    

We consume the res as we go, unmount with some held reservation value,
immediately remount and the associated reservation has jumped by 100
blocks or so. (Granted, whether this can manifest into a tangible
problem may be another story altogether.).

Brian

> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
