Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38018 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754386AbeEHSE1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 14:04:27 -0400
Date: Tue, 8 May 2018 11:04:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/6] xfs: defer agfl block frees when dfops is
 available
Message-ID: <20180508180402.GV11261@magnolia>
References: <20180418133119.21775-1-bfoster@redhat.com>
 <20180418133119.21775-3-bfoster@redhat.com>
 <20180508011032.GF11261@magnolia>
 <20180508123140.GA4764@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180508123140.GA4764@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 08, 2018 at 08:31:40AM -0400, Brian Foster wrote:
> On Mon, May 07, 2018 at 06:10:32PM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 18, 2018 at 09:31:15AM -0400, Brian Foster wrote:
> ...
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_alloc.c  | 51 ++++++++++++++++++++++++++++++---
> > >  fs/xfs/libxfs/xfs_defer.h  |  1 +
> > >  fs/xfs/xfs_trace.h         |  2 ++
> > >  fs/xfs/xfs_trans.c         | 11 ++++++--
> > >  fs/xfs/xfs_trans.h         |  1 +
> > >  fs/xfs/xfs_trans_extfree.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  6 files changed, 129 insertions(+), 7 deletions(-)
> > > 
> ...
> > > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > > index 9d542dfe0052..834388c2c9de 100644
> > > --- a/fs/xfs/xfs_trans.h
> > > +++ b/fs/xfs/xfs_trans.h
> > > @@ -111,6 +111,7 @@ typedef struct xfs_trans {
> > >  	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
> > >  	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
> > >  	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
> > > +	struct xfs_defer_ops	*t_agfl_dfops;	/* optional agfl fixup dfops */
> > 
> > This more or less looks fine to me, with ^^^^ this one (incoherent) quibble:
> > 
> 
> I wouldn't call it incoherent...
> 
> > A thread can only have one transaction and one dfops in play at a time,
> > so could we just call this t_dfops and allow anyone to access it who
> > wants to add their own deferred operations?  Then we can stop passing
> > both tp and dfops all over the stack.  Can you think of a situation
> > where we would want access to t_dfops for deferred agfl frees but not
> > for any other deferred ops?
> > 
> 
> ... because that is precisely the secondary goal of this approach. :)
> Dave suggested this approach in a previous version and the last post
> actually used ->t_dfops rather than ->t_agfl_dfops and included some
> associated dfops parameter elimination cleanup I did along the way.
> 
> Christoph objected to the partial refactoring, however, so I'm trying to
> do this in two parts where the first is primarily focused on fixing the
> problems resolved by deferred agfl frees. The challenge is that I don't
> want to manually plumb dfops through new codepaths to control deferred
> agfl frees only to immediately turn around and clean that code out, and
> I certainly don't want to refactor all of our dfops code just to enable
> deferred agfl frees because it creates an unnecessary dependency for
> backports. As a result, I've stripped out as much refactoring as
> possible to try and make it clear that this is a bug fix series that
> happens to create a new xfs_trans field that will open wider cleanups in
> a follow on series.
> 
> IOW, I have a series in progress where patch 1 renames ->t_agfl_dfops
> back to ->t_dfops to essentially open it for general use and then starts
> to incorporate the broader cleanups like removing dfops from callstacks,
> alloc/bmap data structures, etc.

Seems reasonable.  I've occasionally thought that passing around (tp,
dfops, firstblock) is kinda bulky and silly.

> BTW, something I'm curious of your (and Dave, Christoph?) opinion on...
> another thing that was dropped (permanently) from the previous series
> was an update to xfs_defer_init() to do the ->t_dfops = &dfops
> assignment that is otherwise open-coded throughout here. While I don't
> have a strong preference on that for this series, the more broader
> cleanup I do the less I like the open-coded approach because it creates
> a tx setup requirement that's easy to miss (case in point: a function
> signature change is an easy way to verify all dfops have been associated
> with transactions). Instead, I'd prefer code that looks something like
> the following as the end result of the follow-on cleanup series:
> 
> 	struct xfs_trans	*tp;
> 	struct xfs_defer_ops	dfops;
> 
> 	xfs_trans_alloc(... &tp);
> 	xfs_defer_init(&dfops, &first_block, tp);
> 
> 	...
> 
> 	xfs_defer_finish(&tp);
> 	xfs_trans_commit(tp);
> 	...
> 
> Note that once we require association of dfops with tp, we don't have to
> pass dfops around to anywhere the tp isn't already needed, including
> xfs_defer_finish(). This also opens the possibility of doing things like
> replacing on-stack dfops with something that's just embedded in
> xfs_trans itself (optionally pushing down the init/finish calls into the
> trans infrastructure), but that would require changing how dfops are
> transferred to rolled transactions and whatnot. I haven't really got far
> enough to give that proper consideration, but that may be a possible 3rd
> step cleanup if there's value.

Not sure.  There are places where it seems to make sense to be able to
_defer_finish but still have a transaction around to continue making
changes afterwards.  Or at least, the attr and quota code seems to do
that. :P

Also, there's one funny case where we can have a dfops but no
transaction, which is xlog_recover_process_intents ->
xlog_finish_defer_ops.  We create a dfops to collect new intents created
as part of replaying unfinished intents that were in the dirty log, but
since the intent recovery functions create and commit their own
transactions, we don't create the transaction that goes with the dfops
until we're done replaying old intents and ready to finish the new
intents.

--D


> Anyways, I'd really like to avoid having to switch back and forth
> between the xfs_defer_init() tweak and open-coded assignment if
> possible. Any thoughts/preferences on either approach?
> Brian
> 
> > Separate cleanup, of course, and sorry if this has already been asked.
> > 
> > Other than that this looks ok enough to test,
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > --D
> > 
> > 
> > >  	unsigned int		t_flags;	/* misc flags */
> > >  	int64_t			t_icount_delta;	/* superblock icount change */
> > >  	int64_t			t_ifree_delta;	/* superblock ifree change */
> > > diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
> > > index ab438647592a..f5620796ae25 100644
> > > --- a/fs/xfs/xfs_trans_extfree.c
> > > +++ b/fs/xfs/xfs_trans_extfree.c
> > > @@ -231,9 +231,79 @@ static const struct xfs_defer_op_type xfs_extent_free_defer_type = {
> > >  	.cancel_item	= xfs_extent_free_cancel_item,
> > >  };
> > >  
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
> > > +	struct xfs_mount		*mp = tp->t_mountp;
> > > +	struct xfs_efd_log_item		*efdp = done_item;
> > > +	struct xfs_extent_free_item	*free;
> > > +	struct xfs_extent		*extp;
> > > +	struct xfs_buf			*agbp;
> > > +	int				error;
> > > +	xfs_agnumber_t			agno;
> > > +	xfs_agblock_t			agbno;
> > > +	uint				next_extent;
> > > +
> > > +	free = container_of(item, struct xfs_extent_free_item, xefi_list);
> > > +	ASSERT(free->xefi_blockcount == 1);
> > > +	agno = XFS_FSB_TO_AGNO(mp, free->xefi_startblock);
> > > +	agbno = XFS_FSB_TO_AGBNO(mp, free->xefi_startblock);
> > > +
> > > +	trace_xfs_agfl_free_deferred(mp, agno, 0, agbno, free->xefi_blockcount);
> > > +
> > > +	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
> > > +	if (!error)
> > > +		error = xfs_free_agfl_block(tp, agno, agbno, agbp,
> > > +					    &free->xefi_oinfo);
> > > +
> > > +	/*
> > > +	 * Mark the transaction dirty, even on error. This ensures the
> > > +	 * transaction is aborted, which:
> > > +	 *
> > > +	 * 1.) releases the EFI and frees the EFD
> > > +	 * 2.) shuts down the filesystem
> > > +	 */
> > > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > > +	efdp->efd_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> > > +
> > > +	next_extent = efdp->efd_next_extent;
> > > +	ASSERT(next_extent < efdp->efd_format.efd_nextents);
> > > +	extp = &(efdp->efd_format.efd_extents[next_extent]);
> > > +	extp->ext_start = free->xefi_startblock;
> > > +	extp->ext_len = free->xefi_blockcount;
> > > +	efdp->efd_next_extent++;
> > > +
> > > +	kmem_free(free);
> > > +	return error;
> > > +}
> > > +
> > > +
> > > +/* sub-type with special handling for AGFL deferred frees */
> > > +static const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
> > > +	.type		= XFS_DEFER_OPS_TYPE_AGFL_FREE,
> > > +	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
> > > +	.diff_items	= xfs_extent_free_diff_items,
> > > +	.create_intent	= xfs_extent_free_create_intent,
> > > +	.abort_intent	= xfs_extent_free_abort_intent,
> > > +	.log_item	= xfs_extent_free_log_item,
> > > +	.create_done	= xfs_extent_free_create_done,
> > > +	.finish_item	= xfs_agfl_free_finish_item,
> > > +	.cancel_item	= xfs_extent_free_cancel_item,
> > > +};
> > > +
> > >  /* Register the deferred op type. */
> > >  void
> > >  xfs_extent_free_init_defer_op(void)
> > >  {
> > >  	xfs_defer_init_op_type(&xfs_extent_free_defer_type);
> > > +	xfs_defer_init_op_type(&xfs_agfl_free_defer_type);
> > >  }
> > > -- 
> > > 2.13.6
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
