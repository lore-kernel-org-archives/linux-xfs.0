Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965438AbeEIQbV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 May 2018 12:31:21 -0400
Date: Wed, 9 May 2018 12:31:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 2/6] xfs: defer agfl block frees when dfops is
 available
Message-ID: <20180509163118.GB66101@bfoster.bfoster>
References: <20180418133119.21775-1-bfoster@redhat.com>
 <20180418133119.21775-3-bfoster@redhat.com>
 <20180509160418.GS11261@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509160418.GS11261@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 09, 2018 at 09:04:18AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 18, 2018 at 09:31:15AM -0400, Brian Foster wrote:
...
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c  | 51 ++++++++++++++++++++++++++++++---
> >  fs/xfs/libxfs/xfs_defer.h  |  1 +
> >  fs/xfs/xfs_trace.h         |  2 ++
> >  fs/xfs/xfs_trans.c         | 11 ++++++--
> >  fs/xfs/xfs_trans.h         |  1 +
> >  fs/xfs/xfs_trans_extfree.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++
> >  6 files changed, 129 insertions(+), 7 deletions(-)
> > 
...
> > diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
> > index ab438647592a..f5620796ae25 100644
> > --- a/fs/xfs/xfs_trans_extfree.c
> > +++ b/fs/xfs/xfs_trans_extfree.c
> > @@ -231,9 +231,79 @@ static const struct xfs_defer_op_type xfs_extent_free_defer_type = {
> >  	.cancel_item	= xfs_extent_free_cancel_item,
> >  };
> >  
> > +/*
> > + * AGFL blocks are accounted differently in the reserve pools and are not
> > + * inserted into the busy extent list.
> > + */
> > +STATIC int
> > +xfs_agfl_free_finish_item(
> > +	struct xfs_trans		*tp,
> > +	struct xfs_defer_ops		*dop,
> > +	struct list_head		*item,
> > +	void				*done_item,
> > +	void				**state)
> > +{
> > +	struct xfs_mount		*mp = tp->t_mountp;
> > +	struct xfs_efd_log_item		*efdp = done_item;
> > +	struct xfs_extent_free_item	*free;
> > +	struct xfs_extent		*extp;
> > +	struct xfs_buf			*agbp;
> > +	int				error;
> > +	xfs_agnumber_t			agno;
> > +	xfs_agblock_t			agbno;
> > +	uint				next_extent;
> > +
> > +	free = container_of(item, struct xfs_extent_free_item, xefi_list);
> > +	ASSERT(free->xefi_blockcount == 1);
> > +	agno = XFS_FSB_TO_AGNO(mp, free->xefi_startblock);
> > +	agbno = XFS_FSB_TO_AGBNO(mp, free->xefi_startblock);
> > +
> > +	trace_xfs_agfl_free_deferred(mp, agno, 0, agbno, free->xefi_blockcount);
> > +
> > +	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
> > +	if (!error)
> > +		error = xfs_free_agfl_block(tp, agno, agbno, agbp,
> > +					    &free->xefi_oinfo);
> > +
> > +	/*
> > +	 * Mark the transaction dirty, even on error. This ensures the
> > +	 * transaction is aborted, which:
> > +	 *
> > +	 * 1.) releases the EFI and frees the EFD
> > +	 * 2.) shuts down the filesystem
> > +	 */
> > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > +	efdp->efd_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> 
> FWIW I think this becomes:
> 
> 	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
> 
> after Dave's series to remove log item descriptors, afaict.
> Will fix it up when I pull that into the branch.
> 

Looks right, thanks!

Brian

> --D
> 
> > +
> > +	next_extent = efdp->efd_next_extent;
> > +	ASSERT(next_extent < efdp->efd_format.efd_nextents);
> > +	extp = &(efdp->efd_format.efd_extents[next_extent]);
> > +	extp->ext_start = free->xefi_startblock;
> > +	extp->ext_len = free->xefi_blockcount;
> > +	efdp->efd_next_extent++;
> > +
> > +	kmem_free(free);
> > +	return error;
> > +}
> > +
> > +
> > +/* sub-type with special handling for AGFL deferred frees */
> > +static const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
> > +	.type		= XFS_DEFER_OPS_TYPE_AGFL_FREE,
> > +	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
> > +	.diff_items	= xfs_extent_free_diff_items,
> > +	.create_intent	= xfs_extent_free_create_intent,
> > +	.abort_intent	= xfs_extent_free_abort_intent,
> > +	.log_item	= xfs_extent_free_log_item,
> > +	.create_done	= xfs_extent_free_create_done,
> > +	.finish_item	= xfs_agfl_free_finish_item,
> > +	.cancel_item	= xfs_extent_free_cancel_item,
> > +};
> > +
> >  /* Register the deferred op type. */
> >  void
> >  xfs_extent_free_init_defer_op(void)
> >  {
> >  	xfs_defer_init_op_type(&xfs_extent_free_defer_type);
> > +	xfs_defer_init_op_type(&xfs_agfl_free_defer_type);
> >  }
> > -- 
> > 2.13.6
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
