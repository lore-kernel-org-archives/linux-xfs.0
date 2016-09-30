Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50172 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbcI3ULk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Sep 2016 16:11:40 -0400
Date: Fri, 30 Sep 2016 16:11:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 14/63] xfs: connect refcount adjust functions to upper
 layers
Message-ID: <20160930201137.GD64498@bfoster.bfoster>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520482520.29434.12158124022433689078.stgit@birch.djwong.org>
 <20160930162103.GA53197@bfoster.bfoster>
 <20160930194040.GV14092@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160930194040.GV14092@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Sep 30, 2016 at 12:40:40PM -0700, Darrick J. Wong wrote:
> On Fri, Sep 30, 2016 at 12:21:03PM -0400, Brian Foster wrote:
> > On Thu, Sep 29, 2016 at 08:07:05PM -0700, Darrick J. Wong wrote:
> > > Plumb in the upper level interface to schedule and finish deferred
> > > refcount operations via the deferred ops mechanism.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_defer.h    |    1 
> > >  fs/xfs/libxfs/xfs_refcount.c |  170 ++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/libxfs/xfs_refcount.h |   12 +++
> > >  fs/xfs/xfs_error.h           |    4 +
> > >  fs/xfs/xfs_refcount_item.c   |   73 ++++++++++++++++
> > >  fs/xfs/xfs_super.c           |    1 
> > >  fs/xfs/xfs_trace.h           |    3 +
> > >  fs/xfs/xfs_trans.h           |    8 +-
> > >  fs/xfs/xfs_trans_refcount.c  |  186 ++++++++++++++++++++++++++++++++++++++++++
> > >  9 files changed, 452 insertions(+), 6 deletions(-)
> > > 
> > > 
> > ...
> > > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > > index 599a8d2..e44007a 100644
> > > --- a/fs/xfs/xfs_refcount_item.c
> > > +++ b/fs/xfs/xfs_refcount_item.c
> > > @@ -396,9 +396,19 @@ xfs_cui_recover(
> > >  {
> > >  	int				i;
> > >  	int				error = 0;
> > > +	unsigned int			refc_type;
> > >  	struct xfs_phys_extent		*refc;
> > >  	xfs_fsblock_t			startblock_fsb;
> > >  	bool				op_ok;
> > > +	struct xfs_cud_log_item		*cudp;
> > > +	struct xfs_trans		*tp;
> > > +	struct xfs_btree_cur		*rcur = NULL;
> > > +	enum xfs_refcount_intent_type	type;
> > > +	xfs_fsblock_t			firstfsb;
> > > +	xfs_extlen_t			adjusted;
> > > +	struct xfs_bmbt_irec		irec;
> > > +	struct xfs_defer_ops		dfops;
> > > +	bool				requeue_only = false;
> > >  
> > >  	ASSERT(!test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags));
> > >  
> > > @@ -437,7 +447,68 @@ xfs_cui_recover(
> > >  		}
> > >  	}
> > >  
> > > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> > > +	if (error)
> > > +		return error;
> > > +	cudp = xfs_trans_get_cud(tp, cuip);
> > > +
> > > +	xfs_defer_init(&dfops, &firstfsb);
> > 
> > A comment would be nice here to point out the approach. E.g., that
> > refcount updates are initially deferred under normal runtime
> > circumstances, they handle reservation usage internally/dynamically, and
> > that since we're in recovery, we start the initial update directly and
> > defer the rest that won't fit in the transaction (worded better and
> > assuming I understand all that correctly ;P).
> 
> Yep, your understanding is correct.  I'll put that in as a comment.
> 
> > (Sorry for the comment requests and whatnot, BTW. I'm catching up from a
> > couple weeks of PTO, probably late to the game and not up to speed on
> > the latest status of the patchset. Feel free to defer, drop, or
> > conditionalize any of the aesthetic stuff to whenever is opportune if
> > this stuff is otherwise close to merge).
> 
> NP.  I appreciate review whenever I can get it. :)
> 
> (Plus, you found a bug! :) :))
> 
> > > +	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
> > > +		refc = &cuip->cui_format.cui_extents[i];
> > > +		refc_type = refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK;
> > > +		switch (refc_type) {
> > > +		case XFS_REFCOUNT_INCREASE:
> > > +		case XFS_REFCOUNT_DECREASE:
> > > +		case XFS_REFCOUNT_ALLOC_COW:
> > > +		case XFS_REFCOUNT_FREE_COW:
> > > +			type = refc_type;
> > > +			break;
> > > +		default:
> > > +			error = -EFSCORRUPTED;
> > > +			goto abort_error;
> > > +		}
> > > +		if (requeue_only)
> > > +			adjusted = 0;
> > > +		else
> > > +			error = xfs_trans_log_finish_refcount_update(tp, cudp,
> > > +				&dfops, type, refc->pe_startblock, refc->pe_len,
> > > +				&adjusted, &rcur);
> > > +		if (error)
> > > +			goto abort_error;
> > > +
> > > +		/* Requeue what we didn't finish. */
> > > +		if (adjusted < refc->pe_len) {
> > > +			irec.br_startblock = refc->pe_startblock + adjusted;
> > > +			irec.br_blockcount = refc->pe_len - adjusted;
> > 
> > Hmm, so it appears we walk the range of blocks from beginning to end,
> > but the refcount update code doesn't necessarily always work that way.
> > It merges the boundaries and walks the middle range from start to end.
> > So what happens if the call above ends up doing a right merge and then
> > skips out on any other changes due to the transaction reservation?
> 
> D'oh!  You've found a bug!  _refcount_adjust needs to communicate to
> its caller how much work is left, which does by incrementing *adjusted
> every time it finishes more work.  The caller then moves the start of
> the extent upwards by *adjusted.  Unfortunately, as you point out, a
> right merge actually does work at the upper end of the extent, and this
> is not correctly accounted for.
> 
> To fix this, I'll change _refcount_adjust to report the unfinished
> extent directly to the caller, which will simplify both the function and
> its callers' accounting considerably.
> 
> Good catch!
> 

Ok. Another option might be to perform the refcount update work in
order, but whatever is easier/cleaner is probably fine (and it's
probably easier to update the interface than the mechanism at this
point).

> > Brian
> > 
> > P.S., Even if I'm missing something and this is not an issue, do we have
> > any log recovery oriented reflink xfstests in the current test pile? If
> > not, I'd suggest that something as simple as a "do a bunch of reflinks +
> > xfs_io -c 'shutdown -f' + umount/mount" loop could go a long way towards
> > shaking out any issues. Log recovery can be a pita and otherwise
> > problems therein can go undetected for a surprising amount of time.
> 
> xfs/{313,316,321,324,326} use the error injection mechanism to test log
> recovery.
> 

Great, thanks. What about basic reflink support for fsstress? I suppose
if we had that, some of the existing fsstress->crash->recover tests
would provide coverage as well. One of the things I actually do every
now and then is run an infinite fsstress+remount loop in one thread and
and a randomly timed (e.g., every 0-30s) fs shutdown trigger in another.
That helps catch recovery issues, corruption issues, etc.

Brian

> --D
> 
> > 
> > > +			switch (type) {
> > > +			case XFS_REFCOUNT_INCREASE:
> > > +				error = xfs_refcount_increase_extent(
> > > +						tp->t_mountp, &dfops, &irec);
> > > +				break;
> > > +			case XFS_REFCOUNT_DECREASE:
> > > +				error = xfs_refcount_decrease_extent(
> > > +						tp->t_mountp, &dfops, &irec);
> > > +				break;
> > > +			default:
> > > +				ASSERT(0);
> > > +			}
> > > +			if (error)
> > > +				goto abort_error;
> > > +			requeue_only = true;
> > > +		}
> > > +	}
> > > +
> > > +	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> > > +	error = xfs_defer_finish(&tp, &dfops, NULL);
> > > +	if (error)
> > > +		goto abort_error;
> > >  	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
> > > -	xfs_cui_release(cuip);
> > > +	error = xfs_trans_commit(tp);
> > > +	return error;
> > > +
> > > +abort_error:
> > > +	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> > > +	xfs_defer_cancel(&dfops);
> > > +	xfs_trans_cancel(tp);
> > >  	return error;
> > >  }
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index abe69c6..6234622 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -1903,6 +1903,7 @@ init_xfs_fs(void)
> > >  
> > >  	xfs_extent_free_init_defer_op();
> > >  	xfs_rmap_update_init_defer_op();
> > > +	xfs_refcount_update_init_defer_op();
> > >  
> > >  	xfs_dir_startup();
> > >  
> > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > index fed1906..195a168 100644
> > > --- a/fs/xfs/xfs_trace.h
> > > +++ b/fs/xfs/xfs_trace.h
> > > @@ -2931,6 +2931,9 @@ DEFINE_AG_ERROR_EVENT(xfs_refcount_find_right_extent_error);
> > >  DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared);
> > >  DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared_result);
> > >  DEFINE_AG_ERROR_EVENT(xfs_refcount_find_shared_error);
> > > +#define DEFINE_REFCOUNT_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
> > > +DEFINE_REFCOUNT_DEFERRED_EVENT(xfs_refcount_defer);
> > > +DEFINE_REFCOUNT_DEFERRED_EVENT(xfs_refcount_deferred);
> > >  
> > >  TRACE_EVENT(xfs_refcount_finish_one_leftover,
> > >  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
> > > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > > index fe69e20..a7a87d2 100644
> > > --- a/fs/xfs/xfs_trans.h
> > > +++ b/fs/xfs/xfs_trans.h
> > > @@ -37,6 +37,8 @@ struct xfs_rud_log_item;
> > >  struct xfs_rui_log_item;
> > >  struct xfs_btree_cur;
> > >  struct xfs_cui_log_item;
> > > +struct xfs_cud_log_item;
> > > +struct xfs_defer_ops;
> > >  
> > >  typedef struct xfs_log_item {
> > >  	struct list_head		li_ail;		/* AIL pointers */
> > > @@ -252,11 +254,13 @@ int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
> > >  /* refcount updates */
> > >  enum xfs_refcount_intent_type;
> > >  
> > > +void xfs_refcount_update_init_defer_op(void);
> > >  struct xfs_cud_log_item *xfs_trans_get_cud(struct xfs_trans *tp,
> > >  		struct xfs_cui_log_item *cuip);
> > >  int xfs_trans_log_finish_refcount_update(struct xfs_trans *tp,
> > > -		struct xfs_cud_log_item *cudp,
> > > +		struct xfs_cud_log_item *cudp, struct xfs_defer_ops *dfops,
> > >  		enum xfs_refcount_intent_type type, xfs_fsblock_t startblock,
> > > -		xfs_extlen_t blockcount, struct xfs_btree_cur **pcur);
> > > +		xfs_extlen_t blockcount, xfs_extlen_t *adjusted,
> > > +		struct xfs_btree_cur **pcur);
> > >  
> > >  #endif	/* __XFS_TRANS_H__ */
> > > diff --git a/fs/xfs/xfs_trans_refcount.c b/fs/xfs/xfs_trans_refcount.c
> > > index b18d548..e3ac994 100644
> > > --- a/fs/xfs/xfs_trans_refcount.c
> > > +++ b/fs/xfs/xfs_trans_refcount.c
> > > @@ -56,15 +56,17 @@ int
> > >  xfs_trans_log_finish_refcount_update(
> > >  	struct xfs_trans		*tp,
> > >  	struct xfs_cud_log_item		*cudp,
> > > +	struct xfs_defer_ops		*dop,
> > >  	enum xfs_refcount_intent_type	type,
> > >  	xfs_fsblock_t			startblock,
> > >  	xfs_extlen_t			blockcount,
> > > +	xfs_extlen_t			*adjusted,
> > >  	struct xfs_btree_cur		**pcur)
> > >  {
> > >  	int				error;
> > >  
> > > -	/* XXX: leave this empty for now */
> > > -	error = -EFSCORRUPTED;
> > > +	error = xfs_refcount_finish_one(tp, dop, type, startblock,
> > > +			blockcount, adjusted, pcur);
> > >  
> > >  	/*
> > >  	 * Mark the transaction dirty, even on error. This ensures the
> > > @@ -78,3 +80,183 @@ xfs_trans_log_finish_refcount_update(
> > >  
> > >  	return error;
> > >  }
> > > +
> > > +/* Sort refcount intents by AG. */
> > > +static int
> > > +xfs_refcount_update_diff_items(
> > > +	void				*priv,
> > > +	struct list_head		*a,
> > > +	struct list_head		*b)
> > > +{
> > > +	struct xfs_mount		*mp = priv;
> > > +	struct xfs_refcount_intent	*ra;
> > > +	struct xfs_refcount_intent	*rb;
> > > +
> > > +	ra = container_of(a, struct xfs_refcount_intent, ri_list);
> > > +	rb = container_of(b, struct xfs_refcount_intent, ri_list);
> > > +	return  XFS_FSB_TO_AGNO(mp, ra->ri_startblock) -
> > > +		XFS_FSB_TO_AGNO(mp, rb->ri_startblock);
> > > +}
> > > +
> > > +/* Get an CUI. */
> > > +STATIC void *
> > > +xfs_refcount_update_create_intent(
> > > +	struct xfs_trans		*tp,
> > > +	unsigned int			count)
> > > +{
> > > +	struct xfs_cui_log_item		*cuip;
> > > +
> > > +	ASSERT(tp != NULL);
> > > +	ASSERT(count > 0);
> > > +
> > > +	cuip = xfs_cui_init(tp->t_mountp, count);
> > > +	ASSERT(cuip != NULL);
> > > +
> > > +	/*
> > > +	 * Get a log_item_desc to point at the new item.
> > > +	 */
> > > +	xfs_trans_add_item(tp, &cuip->cui_item);
> > > +	return cuip;
> > > +}
> > > +
> > > +/* Set the phys extent flags for this reverse mapping. */
> > > +static void
> > > +xfs_trans_set_refcount_flags(
> > > +	struct xfs_phys_extent		*refc,
> > > +	enum xfs_refcount_intent_type	type)
> > > +{
> > > +	refc->pe_flags = 0;
> > > +	switch (type) {
> > > +	case XFS_REFCOUNT_INCREASE:
> > > +	case XFS_REFCOUNT_DECREASE:
> > > +	case XFS_REFCOUNT_ALLOC_COW:
> > > +	case XFS_REFCOUNT_FREE_COW:
> > > +		refc->pe_flags |= type;
> > > +		break;
> > > +	default:
> > > +		ASSERT(0);
> > > +	}
> > > +}
> > > +
> > > +/* Log refcount updates in the intent item. */
> > > +STATIC void
> > > +xfs_refcount_update_log_item(
> > > +	struct xfs_trans		*tp,
> > > +	void				*intent,
> > > +	struct list_head		*item)
> > > +{
> > > +	struct xfs_cui_log_item		*cuip = intent;
> > > +	struct xfs_refcount_intent	*refc;
> > > +	uint				next_extent;
> > > +	struct xfs_phys_extent		*ext;
> > > +
> > > +	refc = container_of(item, struct xfs_refcount_intent, ri_list);
> > > +
> > > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > > +	cuip->cui_item.li_desc->lid_flags |= XFS_LID_DIRTY;
> > > +
> > > +	/*
> > > +	 * atomic_inc_return gives us the value after the increment;
> > > +	 * we want to use it as an array index so we need to subtract 1 from
> > > +	 * it.
> > > +	 */
> > > +	next_extent = atomic_inc_return(&cuip->cui_next_extent) - 1;
> > > +	ASSERT(next_extent < cuip->cui_format.cui_nextents);
> > > +	ext = &cuip->cui_format.cui_extents[next_extent];
> > > +	ext->pe_startblock = refc->ri_startblock;
> > > +	ext->pe_len = refc->ri_blockcount;
> > > +	xfs_trans_set_refcount_flags(ext, refc->ri_type);
> > > +}
> > > +
> > > +/* Get an CUD so we can process all the deferred refcount updates. */
> > > +STATIC void *
> > > +xfs_refcount_update_create_done(
> > > +	struct xfs_trans		*tp,
> > > +	void				*intent,
> > > +	unsigned int			count)
> > > +{
> > > +	return xfs_trans_get_cud(tp, intent);
> > > +}
> > > +
> > > +/* Process a deferred refcount update. */
> > > +STATIC int
> > > +xfs_refcount_update_finish_item(
> > > +	struct xfs_trans		*tp,
> > > +	struct xfs_defer_ops		*dop,
> > > +	struct list_head		*item,
> > > +	void				*done_item,
> > > +	void				**state)
> > > +{
> > > +	struct xfs_refcount_intent	*refc;
> > > +	xfs_extlen_t			adjusted;
> > > +	int				error;
> > > +
> > > +	refc = container_of(item, struct xfs_refcount_intent, ri_list);
> > > +	error = xfs_trans_log_finish_refcount_update(tp, done_item, dop,
> > > +			refc->ri_type,
> > > +			refc->ri_startblock,
> > > +			refc->ri_blockcount,
> > > +			&adjusted,
> > > +			(struct xfs_btree_cur **)state);
> > > +	/* Did we run out of reservation?  Requeue what we didn't finish. */
> > > +	if (!error && adjusted < refc->ri_blockcount) {
> > > +		ASSERT(refc->ri_type == XFS_REFCOUNT_INCREASE ||
> > > +		       refc->ri_type == XFS_REFCOUNT_DECREASE);
> > > +		refc->ri_startblock += adjusted;
> > > +		refc->ri_blockcount -= adjusted;
> > > +		return -EAGAIN;
> > > +	}
> > > +	kmem_free(refc);
> > > +	return error;
> > > +}
> > > +
> > > +/* Clean up after processing deferred refcounts. */
> > > +STATIC void
> > > +xfs_refcount_update_finish_cleanup(
> > > +	struct xfs_trans	*tp,
> > > +	void			*state,
> > > +	int			error)
> > > +{
> > > +	struct xfs_btree_cur	*rcur = state;
> > > +
> > > +	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> > > +}
> > > +
> > > +/* Abort all pending CUIs. */
> > > +STATIC void
> > > +xfs_refcount_update_abort_intent(
> > > +	void				*intent)
> > > +{
> > > +	xfs_cui_release(intent);
> > > +}
> > > +
> > > +/* Cancel a deferred refcount update. */
> > > +STATIC void
> > > +xfs_refcount_update_cancel_item(
> > > +	struct list_head		*item)
> > > +{
> > > +	struct xfs_refcount_intent	*refc;
> > > +
> > > +	refc = container_of(item, struct xfs_refcount_intent, ri_list);
> > > +	kmem_free(refc);
> > > +}
> > > +
> > > +static const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
> > > +	.type		= XFS_DEFER_OPS_TYPE_REFCOUNT,
> > > +	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
> > > +	.diff_items	= xfs_refcount_update_diff_items,
> > > +	.create_intent	= xfs_refcount_update_create_intent,
> > > +	.abort_intent	= xfs_refcount_update_abort_intent,
> > > +	.log_item	= xfs_refcount_update_log_item,
> > > +	.create_done	= xfs_refcount_update_create_done,
> > > +	.finish_item	= xfs_refcount_update_finish_item,
> > > +	.finish_cleanup = xfs_refcount_update_finish_cleanup,
> > > +	.cancel_item	= xfs_refcount_update_cancel_item,
> > > +};
> > > +
> > > +/* Register the deferred op type. */
> > > +void
> > > +xfs_refcount_update_init_defer_op(void)
> > > +{
> > > +	xfs_defer_init_op_type(&xfs_refcount_update_defer_type);
> > > +}
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
