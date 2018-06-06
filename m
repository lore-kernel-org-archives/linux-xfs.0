Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:47399 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752762AbeFFDel (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 23:34:41 -0400
Date: Wed, 6 Jun 2018 13:34:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/14] xfs: repair free space btrees
Message-ID: <20180606033438.GN10363@dastard>
References: <152770863951.11611.5866814627357136911.stgit@magnolia>
 <152770865831.11611.7628478596629227707.stgit@magnolia>
 <20180604021234.GL10363@dastard>
 <20180606015026.GQ9437@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180606015026.GQ9437@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 05, 2018 at 06:50:26PM -0700, Darrick J. Wong wrote:
> On Mon, Jun 04, 2018 at 12:12:34PM +1000, Dave Chinner wrote:
> > On Wed, May 30, 2018 at 12:30:58PM -0700, Darrick J. Wong wrote:
> > > +
> > > +/* Free space btree repair. */
> > 
> > Can you add a decription of the algorithm used here.
> 
> Ok.
> 
> /*
>  * Free Space Btree Repair
>  * =======================
>  *
>  * The reverse mappings are supposed to record all space usage for the
>  * entire AG.  Therefore, we can recalculate the free extents in an AG
>  * by looking for gaps in the physical extents recorded in the rmapbt.
>  * On a reflink filesystem this is a little more tricky in that we have
>  * to be aware that the rmap records are allowed to overlap.
>  *
>  * We derive which blocks belonged to the old bnobt/cntbt by recording
>  * all the OWN_AG extents and subtracting out the blocks owned by all
>  * other OWN_AG metadata: the rmapbt blocks visited while iterating the
>  * reverse mappings and the AGFL blocks.
>  *
>  * Once we have both of those pieces, we can reconstruct the bnobt and
>  * cntbt by blowing out the free block state and freeing all the extents
>  * that we found.  This adds the requirement that we can't have any busy
>  * extents in the AG because the busy code cannot handle duplicate
>  * records.
>  *
>  * Note that we can only rebuild both free space btrees at the same
>  * time.

Ok, so if I've got this right, the limitations indicated in the last
two paragraphs are a result of makring space free by calling
xfs_free_extent() on all the extents in the list? If so, can you
mention that this is an implementation artifact, not a algorithmic
limitation?

> > > +/* Allocate a block from the (cached) longest extent in the AG. */
> > > +STATIC xfs_fsblock_t
> > > +xfs_repair_allocbt_alloc_from_longest(
> > > +	struct xfs_repair_alloc		*ra,
> > > +	struct xfs_repair_alloc_extent	**longest)
> > > +{
> > > +	xfs_fsblock_t			fsb;
> > > +
> > > +	if (*longest && (*longest)->len == 0) {
> > > +		list_del(&(*longest)->list);
> > > +		kmem_free(*longest);
> > > +		*longest = NULL;
> > > +	}
> > > +
> > > +	if (*longest == NULL) {
> > > +		*longest = xfs_repair_allocbt_get_longest(ra);
> > > +		if (*longest == NULL)
> > > +			return NULLFSBLOCK;
> > > +	}
> > > +
> > > +	fsb = XFS_AGB_TO_FSB(ra->sc->mp, ra->sc->sa.agno, (*longest)->bno);
> > > +	(*longest)->bno++;
> > > +	(*longest)->len--;
> > 
> > What if this makes the longest extent no longer the longest on the
> > extent list?
> 
> It should be fine, since all we do later is zero out the free space
> counters in the AG and start freeing extents.  The regular extent
> freeing code takes care to update the agf/perag longest-free counter
> appropriately.

Comment, please. :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
