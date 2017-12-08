Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59498 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753331AbdLHORo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Dec 2017 09:17:44 -0500
Date: Fri, 8 Dec 2017 09:17:43 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 2/4] xfs: defer agfl block frees when dfops is
 available
Message-ID: <20171208141742.GC55826@bfoster.bfoster>
References: <20171207185810.48757-1-bfoster@redhat.com>
 <20171207185810.48757-3-bfoster@redhat.com>
 <20171207224126.GJ4094@dastard>
 <20171207225459.GL4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171207225459.GL4094@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 08, 2017 at 09:54:59AM +1100, Dave Chinner wrote:
> On Fri, Dec 08, 2017 at 09:41:26AM +1100, Dave Chinner wrote:
> > On Thu, Dec 07, 2017 at 01:58:08PM -0500, Brian Foster wrote:
> > > The AGFL fixup code executes before every block allocation/free and
> > > rectifies the AGFL based on the current, dynamic allocation
> > > requirements of the fs. The AGFL must hold a minimum number of
> > > blocks to satisfy a worst case split of the free space btrees caused
> > > by the impending allocation operation. The AGFL is also updated to
> > > maintain the implicit requirement for a minimum number of free slots
> > > to satisfy a worst case join of the free space btrees.
> > > 
> > > Since the AGFL caches individual blocks, AGFL reduction typically
> > > involves multiple, single block frees. We've had reports of
> > > transaction overrun problems during certain workloads that boil down
> > > to AGFL reduction freeing multiple blocks and consuming more space
> > > in the log than was reserved for the transaction.
> > > 
> > > Since the objective of freeing AGFL blocks is to ensure free AGFL
> > > free slots are available for the upcoming allocation, one way to
> > > address this problem is to release surplus blocks from the AGFL
> > > immediately but defer the free of those blocks (similar to how
> > > file-mapped blocks are unmapped from the file in one transaction and
> > > freed via a deferred operation) until the transaction is rolled.
> > > This turns AGFL reduction into an operation with predictable log
> > > reservation consumption.
> > > 
> > > Add the capability to defer AGFL block frees when a deferred ops
> > > list is handed to the AGFL fixup code. Deferring AGFL frees is a
> > > conditional behavior based on whether the caller has populated the
> > > new dfops field of the xfs_alloc_arg structure. A bit of
> > > customization is required to handle deferred completion processing
> > > because AGFL blocks are accounted against a separate reservation
> > > pool and AGFL are not inserted into the extent busy list when freed
> > > (they are inserted when used and released back to the AGFL). Reuse
> > > the majority of the existing deferred extent free infrastructure and
> > > customize it appropriately to handle AGFL blocks.
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
> > That said, I haven't traced through whether this matters or not,
> > but I suspect it does because freelist frees use XFS_AG_RESV_AGFL
> > and that avoids accounting the free to the superblock counters
> > because the block is already accounted as free space....
> 
> Just had another thought on this - this is going to cause a large
> number of alloc/free transactions to roll the transaction at least
> one more time. That means the logcount in the alloc/free transaction
> reservation should be bumped by one. i.e. so that the common case
> doesn't need to block and re-reserve grant space in the log to
> complete the transaction because it has rolled the more times than
> the reservation log count accounts for.
> 

Yeah, that is something else we need to consider. One thing that stands
out is that we don't seem to currently break down log count values into
operational units as we do for log reservation itself. We could just
bump them all, or at least whatever ones are used in contexts that are
now able to defer AGFL block frees. There aren't that many separate
values defined, but I wonder if something like:

#define XFS_BMAPFREE_LOG_COUNT 2	/* 1 deferred free + 1 AGFL free */
...
#define XFS_INACTIVE_LOG_COUNT (XFS_ALLOCFREE_LOG_COUNT + 1)
...

... would help make this more self-documenting. Hm?

I was also a little concerned about increasing the size of the
transactions again since I believe that a bump in log count increases
the initial reservation requirement (so we don't end up blocking on the
roll, as you point out). But now that I take a quick look with the above
in mind, it's probably the appropriate thing to do so long it can be
applied selectively/accurately. I'll look more into it..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
