Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731929AbeGaNam (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jul 2018 09:30:42 -0400
Date: Tue, 31 Jul 2018 07:50:42 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/15] xfs: replace xfs_defer_ops ->dop_pending with
 on-stack list
Message-ID: <20180731115041.GF40201@bfoster>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-13-bfoster@redhat.com>
 <20180730204702.GM30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730204702.GM30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 01:47:02PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 30, 2018 at 12:45:17PM -0400, Brian Foster wrote:
> > The xfs_defer_ops ->dop_pending list is used to track active
> > deferred operations once intents are logged. These items must be
> > aborted in the event of an error. The list is populated as intents
> > are logged and items are removed as they complete (or are aborted).
> > 
> > Now that xfs_defer_finish() cancels on error, there is no need to
> > ever access ->dop_pending outside of xfs_defer_finish(). The list is
> > only ever populated after xfs_defer_finish() begins and is either
> > completed or cancelled before it returns.
> > 
> > Remove ->dop_pending from xfs_defer_ops and replace it with a local
> > list in the xfs_defer_finish() path. Pass the local list to the
> > various helpers now that it is not accessible via dfops. Note that
> > we have to check for NULL in the abort case as the final tx roll
> > occurs outside of the scope of the new local list (once the dfops
> > has completed and thus drained the list).
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.c | 80 ++++++++++++++++++++-------------------
> >  fs/xfs/libxfs/xfs_defer.h |  3 +-
> >  fs/xfs/xfs_trace.h        |  1 -
> >  fs/xfs/xfs_trans.h        |  1 -
> >  4 files changed, 43 insertions(+), 42 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 66848ede62c0..6bf792e2d61b 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
...
> > @@ -212,11 +216,13 @@ xfs_defer_trans_abort(
> >  	trace_xfs_defer_trans_abort(tp->t_mountp, dop, _RET_IP_);
> >  
> >  	/* Abort intent items that don't have a done item. */
> > -	list_for_each_entry(dfp, &dop->dop_pending, dfp_list) {
> > -		trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
> > -		if (dfp->dfp_intent && !dfp->dfp_done) {
> > -			dfp->dfp_type->abort_intent(dfp->dfp_intent);
> > -			dfp->dfp_intent = NULL;
> > +	if (dop_pending) {
> 
> /me kinda wonders if you could just make xfs_defer_finish pass an empty
> list_head into xfs_defer_trans_roll to avoid this extra indent, but I
> don't care all that much and maybe we should save the stack space. :)
> 

I started with something like that when hacking this up and eventually
replaced it because the indent didn't actually create any long lines.

> > +		list_for_each_entry(dfp, dop_pending, dfp_list) {
> > +			trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
> > +			if (dfp->dfp_intent && !dfp->dfp_done) {
> > +				dfp->dfp_type->abort_intent(dfp->dfp_intent);
> > +				dfp->dfp_intent = NULL;
> > +			}
> >  		}
> >  	}
> >  
...
> > @@ -446,34 +456,20 @@ xfs_defer_finish(
> >  /*
> >   * Free up any items left in the list.
> >   */
> > -void
> > -xfs_defer_cancel(
> > -	struct xfs_trans		*tp)
> > +static void
> > +__xfs_defer_cancel(
> 
> Maybe this should be xfs_defer_cancel_list?
> 

Sure.

> > +	struct list_head		*dop_list)
> >  {
> > -	struct xfs_defer_ops		*dop = tp->t_dfops;
> >  	struct xfs_defer_pending	*dfp;
> >  	struct xfs_defer_pending	*pli;
> >  	struct list_head		*pwi;
> >  	struct list_head		*n;
> >  
> > -	trace_xfs_defer_cancel(NULL, dop, _RET_IP_);
> > -
> >  	/*
> >  	 * Free the pending items.  Caller should already have arranged
> >  	 * for the intent items to be released.
> >  	 */
> > -	list_for_each_entry_safe(dfp, pli, &dop->dop_intake, dfp_list) {
> > -		trace_xfs_defer_intake_cancel(NULL, dfp);
> > -		list_del(&dfp->dfp_list);
> > -		list_for_each_safe(pwi, n, &dfp->dfp_work) {
> > -			list_del(pwi);
> > -			dfp->dfp_count--;
> > -			dfp->dfp_type->cancel_item(pwi);
> > -		}
> > -		ASSERT(dfp->dfp_count == 0);
> > -		kmem_free(dfp);
> > -	}
> > -	list_for_each_entry_safe(dfp, pli, &dop->dop_pending, dfp_list) {
> > +	list_for_each_entry_safe(dfp, pli, dop_list, dfp_list) {
> >  		trace_xfs_defer_pending_cancel(NULL, dfp);
> 
> trace_xfs_defer_cancel_list?
> 
> Maybe it's worth passing a *mp into this function so we can pass it to
> the tracepoint?
> 

Ok.

> >  		list_del(&dfp->dfp_list);
> >  		list_for_each_safe(pwi, n, &dfp->dfp_work) {
> > @@ -486,6 +482,14 @@ xfs_defer_cancel(
> >  	}
> >  }
> >  
> > +void
> > +xfs_defer_cancel(
> > +	struct xfs_trans	*tp)
> > +{
> > +	trace_xfs_defer_cancel(NULL, tp->t_dfops, _RET_IP_);
> 
> That NULL can be tp->t_mountp, right?  Since tp should never be NULL?
> 

Yeah, this will hopefully be replaced with the transaction reference so
that makes sense.

> > +	__xfs_defer_cancel(&tp->t_dfops->dop_intake);
> > +}
> > +
> >  /* Add an item for later deferred processing. */
> >  void
> >  xfs_defer_add(
...
> > diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> > index f051c8056141..363af16328cb 100644
> > --- a/fs/xfs/libxfs/xfs_defer.h
> > +++ b/fs/xfs/libxfs/xfs_defer.h
> > @@ -41,7 +41,8 @@ int xfs_defer_finish_noroll(struct xfs_trans **tp);
> >  int xfs_defer_finish(struct xfs_trans **tp);
> >  void xfs_defer_cancel(struct xfs_trans *);
> >  void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
> > -bool xfs_defer_has_unfinished_work(struct xfs_trans *tp);
> > +bool xfs_defer_has_unfinished_work(struct xfs_trans *tp,
> > +		struct list_head *dop_pending);
> 
> Eww, I dislike exposing this implementation detail in a public
> interface.  Assuming you take my suggestion in patch 1 to ASSERT if
> xfs_trans_{cancel,commit} encounter unfinished deferred work and a
> transaction we can't roll, there will be only three callers of this
> function, and only one of them knows about the pending item list.
> Perhaps the list_empty(dop_pending) check can be open-coded in
> xfs_defer_finish_noroll?
> 

Christoph points out there's only one caller left so I'll probably just
kill this off entirely.

Brian

> --D
> 
> >  void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
> >  
> >  /* Description of a deferred type. */
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 8807f1bb814a..6b55bbc09578 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -2393,7 +2393,6 @@ DEFINE_DEFER_ERROR_EVENT(xfs_defer_trans_roll_error);
> >  DEFINE_DEFER_ERROR_EVENT(xfs_defer_finish_error);
> >  
> >  DEFINE_DEFER_PENDING_EVENT(xfs_defer_intake_work);
> > -DEFINE_DEFER_PENDING_EVENT(xfs_defer_intake_cancel);
> >  DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_cancel);
> >  DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
> >  DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index 299656dbf324..1cdc7c0ebeac 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -96,7 +96,6 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
> >  #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
> >  struct xfs_defer_ops {
> >  	struct list_head	dop_intake;	/* unlogged pending work */
> > -	struct list_head	dop_pending;	/* logged pending work */
> >  };
> >  
> >  /*
> > -- 
> > 2.17.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
