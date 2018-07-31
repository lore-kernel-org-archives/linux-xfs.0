Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726801AbeGaN1v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jul 2018 09:27:51 -0400
Date: Tue, 31 Jul 2018 07:47:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/15] xfs: use transaction for intent recovery instead
 of raw dfops
Message-ID: <20180731114750.GB40201@bfoster>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-3-bfoster@redhat.com>
 <20180730200909.GC30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730200909.GC30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 01:09:09PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 30, 2018 at 12:45:07PM -0400, Brian Foster wrote:
> > Log intent recovery is the last user of an external (on-stack)
> > dfops. The pattern exists because the dfops is used to collect
> > additional deferred operations queued during the whole recovery
> > sequence. The dfops is finished with a new transaction after intent
> > recovery completes.
> > 
> > We already have a mechanism to create an empty, container-like
> > transaction to support the scrub infrastructure. We can reuse that
> > mechanism here to drop the final user of external dfops. This
> > facilitates folding dfops state (i.e., dop_low) into the
> > transaction, the elimination of now unused external dfops support
> > and also eliminates the only caller of __xfs_defer_cancel().
> > 
> > Replace the on-stack dfops with an empty transaction and pass it
> > around to the various helpers that queue and finish deferred
> > operations during intent recovery.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_bmap_item.c     | 12 +++++------
> >  fs/xfs/xfs_bmap_item.h     |  3 +--
> >  fs/xfs/xfs_log_recover.c   | 42 ++++++++++++++++++--------------------
> >  fs/xfs/xfs_refcount_item.c | 12 +++++------
> >  fs/xfs/xfs_refcount_item.h |  3 +--
> >  5 files changed, 34 insertions(+), 38 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index e1d6c127b07d..992235e7c761 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -375,9 +375,8 @@ xfs_bud_init(
> >   */
> >  int
> >  xfs_bui_recover(
> > -	struct xfs_mount		*mp,
> > -	struct xfs_bui_log_item		*buip,
> > -	struct xfs_defer_ops		*dfops)
> > +	struct xfs_trans		*itp,
> 
> "itp"?
> 
> Oh, the intent-holder transaction...
> 

Yeah..

> > +	struct xfs_bui_log_item		*buip)
> >  {
> >  	int				error = 0;
> >  	unsigned int			bui_type;
...
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 7776fde9430c..6650b790e43b 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
...
> > @@ -4880,22 +4878,25 @@ STATIC int
> >  xlog_recover_process_intents(
> >  	struct xlog		*log)
> >  {
> > -	struct xfs_defer_ops	dfops;
> > +	struct xfs_trans	*tp;
> >  	struct xfs_ail_cursor	cur;
> >  	struct xfs_log_item	*lip;
> >  	struct xfs_ail		*ailp;
> > -	int			error = 0;
> > +	int			error;
> >  #if defined(DEBUG) || defined(XFS_WARN)
> >  	xfs_lsn_t		last_lsn;
> >  #endif
> >  
> > +	error = xfs_trans_alloc_empty(log->l_mp, &tp);
> 
> Here's where we allocate the intent-placeholder transaction, so why
> isn't this named "itp" as well?
> 

I only used itp where tp conflicted with a local transaction (the
contexts where we have to transfer state back and forth between two
transactions).

> I think I have a handle on what this patch does, though the variable
> naming itp/tp is a little confusing.
> 

I have no real preference on the naming. I can call it parent_tp as
Christoph suggests and use that up and down the chain rather than only
in the contexts where both transactions exist if you think that is more
clear..?

Brian

> --D
> 
> > +	if (error)
> > +		return error;
> > +
> >  	ailp = log->l_ailp;
> >  	spin_lock(&ailp->ail_lock);
> >  	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> >  #if defined(DEBUG) || defined(XFS_WARN)
> >  	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
> >  #endif
> > -	xfs_defer_init(NULL, &dfops);
> >  	while (lip != NULL) {
> >  		/*
> >  		 * We're done when we see something other than an intent.
> > @@ -4930,12 +4931,10 @@ xlog_recover_process_intents(
> >  			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
> >  			break;
> >  		case XFS_LI_CUI:
> > -			error = xlog_recover_process_cui(log->l_mp, ailp, lip,
> > -					&dfops);
> > +			error = xlog_recover_process_cui(tp, ailp, lip);
> >  			break;
> >  		case XFS_LI_BUI:
> > -			error = xlog_recover_process_bui(log->l_mp, ailp, lip,
> > -					&dfops);
> > +			error = xlog_recover_process_bui(tp, ailp, lip);
> >  			break;
> >  		}
> >  		if (error)
> > @@ -4945,10 +4944,9 @@ xlog_recover_process_intents(
> >  out:
> >  	xfs_trans_ail_cursor_done(&cur);
> >  	spin_unlock(&ailp->ail_lock);
> > -	if (error)
> > -		__xfs_defer_cancel(&dfops);
> > -	else
> > -		error = xlog_finish_defer_ops(log->l_mp, &dfops);
> > +	if (!error)
> > +		error = xlog_finish_defer_ops(tp);
> > +	xfs_trans_cancel(tp);
> >  
> >  	return error;
> >  }
> > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > index d3582a06626f..d663ea1f4076 100644
> > --- a/fs/xfs/xfs_refcount_item.c
> > +++ b/fs/xfs/xfs_refcount_item.c
> > @@ -380,9 +380,8 @@ xfs_cud_init(
> >   */
> >  int
> >  xfs_cui_recover(
> > -	struct xfs_mount		*mp,
> > -	struct xfs_cui_log_item		*cuip,
> > -	struct xfs_defer_ops		*dfops)
> > +	struct xfs_trans		*itp,
> > +	struct xfs_cui_log_item		*cuip)
> >  {
> >  	int				i;
> >  	int				error = 0;
> > @@ -398,6 +397,7 @@ xfs_cui_recover(
> >  	xfs_extlen_t			new_len;
> >  	struct xfs_bmbt_irec		irec;
> >  	bool				requeue_only = false;
> > +	struct xfs_mount		*mp = itp->t_mountp;
> >  
> >  	ASSERT(!test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags));
> >  
> > @@ -457,7 +457,7 @@ xfs_cui_recover(
> >  	 * finishes them on completion. Transfer current dfops state to this
> >  	 * transaction and transfer the result back before we return.
> >  	 */
> > -	xfs_defer_move(tp->t_dfops, dfops);
> > +	xfs_defer_move(tp->t_dfops, itp->t_dfops);
> >  	cudp = xfs_trans_get_cud(tp, cuip);
> >  
> >  	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
> > @@ -522,13 +522,13 @@ xfs_cui_recover(
> >  
> >  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> >  	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
> > -	xfs_defer_move(dfops, tp->t_dfops);
> > +	xfs_defer_move(itp->t_dfops, tp->t_dfops);
> >  	error = xfs_trans_commit(tp);
> >  	return error;
> >  
> >  abort_error:
> >  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> > -	xfs_defer_move(dfops, tp->t_dfops);
> > +	xfs_defer_move(itp->t_dfops, tp->t_dfops);
> >  	xfs_trans_cancel(tp);
> >  	return error;
> >  }
> > diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
> > index dd830b69cd1e..98895da52c1f 100644
> > --- a/fs/xfs/xfs_refcount_item.h
> > +++ b/fs/xfs/xfs_refcount_item.h
> > @@ -82,7 +82,6 @@ struct xfs_cud_log_item *xfs_cud_init(struct xfs_mount *,
> >  		struct xfs_cui_log_item *);
> >  void xfs_cui_item_free(struct xfs_cui_log_item *);
> >  void xfs_cui_release(struct xfs_cui_log_item *);
> > -int xfs_cui_recover(struct xfs_mount *mp, struct xfs_cui_log_item *cuip,
> > -		struct xfs_defer_ops *dfops);
> > +int xfs_cui_recover(struct xfs_trans *itp, struct xfs_cui_log_item *cuip);
> >  
> >  #endif	/* __XFS_REFCOUNT_ITEM_H__ */
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
