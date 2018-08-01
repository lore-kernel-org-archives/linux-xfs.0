Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55526 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389372AbeHAQVt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 12:21:49 -0400
Date: Wed, 1 Aug 2018 07:35:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 02/15] xfs: use transaction for intent recovery
 instead of raw dfops
Message-ID: <20180801143542.GD30972@magnolia>
References: <20180801131952.60250-1-bfoster@redhat.com>
 <20180801131952.60250-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180801131952.60250-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 01, 2018 at 09:19:39AM -0400, Brian Foster wrote:
> Log intent recovery is the last user of an external (on-stack)
> dfops. The pattern exists because the dfops is used to collect
> additional deferred operations queued during the whole recovery
> sequence. The dfops is finished with a new transaction after intent
> recovery completes.
> 
> We already have a mechanism to create an empty, container-like
> transaction to support the scrub infrastructure. We can reuse that
> mechanism here to drop the final user of external dfops. This
> facilitates folding dfops state (i.e., dop_low) into the
> transaction, the elimination of now unused external dfops support
> and also eliminates the only caller of __xfs_defer_cancel().
> 
> Replace the on-stack dfops with an empty transaction and pass it
> around to the various helpers that queue and finish deferred
> operations during intent recovery.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_item.c     | 12 ++++-----
>  fs/xfs/xfs_bmap_item.h     |  3 +--
>  fs/xfs/xfs_log_recover.c   | 51 ++++++++++++++++++++++----------------
>  fs/xfs/xfs_refcount_item.c | 12 ++++-----
>  fs/xfs/xfs_refcount_item.h |  3 +--
>  5 files changed, 43 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index e1d6c127b07d..57429055e608 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -375,9 +375,8 @@ xfs_bud_init(
>   */
>  int
>  xfs_bui_recover(
> -	struct xfs_mount		*mp,
> -	struct xfs_bui_log_item		*buip,
> -	struct xfs_defer_ops		*dfops)
> +	struct xfs_trans		*parent_tp,
> +	struct xfs_bui_log_item		*buip)
>  {
>  	int				error = 0;
>  	unsigned int			bui_type;
> @@ -393,6 +392,7 @@ xfs_bui_recover(
>  	struct xfs_trans		*tp;
>  	struct xfs_inode		*ip = NULL;
>  	struct xfs_bmbt_irec		irec;
> +	struct xfs_mount		*mp = parent_tp->t_mountp;
>  
>  	ASSERT(!test_bit(XFS_BUI_RECOVERED, &buip->bui_flags));
>  
> @@ -446,7 +446,7 @@ xfs_bui_recover(
>  	 * finishes them on completion. Transfer current dfops state to this
>  	 * transaction and transfer the result back before we return.
>  	 */
> -	xfs_defer_move(tp->t_dfops, dfops);
> +	xfs_defer_move(tp->t_dfops, parent_tp->t_dfops);
>  	budp = xfs_trans_get_bud(tp, buip);
>  
>  	/* Grab the inode. */
> @@ -494,7 +494,7 @@ xfs_bui_recover(
>  	}
>  
>  	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
> -	xfs_defer_move(dfops, tp->t_dfops);
> +	xfs_defer_move(parent_tp->t_dfops, tp->t_dfops);
>  	error = xfs_trans_commit(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	xfs_irele(ip);
> @@ -502,7 +502,7 @@ xfs_bui_recover(
>  	return error;
>  
>  err_inode:
> -	xfs_defer_move(dfops, tp->t_dfops);
> +	xfs_defer_move(parent_tp->t_dfops, tp->t_dfops);
>  	xfs_trans_cancel(tp);
>  	if (ip) {
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
> index fd1a1b13df51..89e043a88bb8 100644
> --- a/fs/xfs/xfs_bmap_item.h
> +++ b/fs/xfs/xfs_bmap_item.h
> @@ -79,7 +79,6 @@ struct xfs_bud_log_item *xfs_bud_init(struct xfs_mount *,
>  		struct xfs_bui_log_item *);
>  void xfs_bui_item_free(struct xfs_bui_log_item *);
>  void xfs_bui_release(struct xfs_bui_log_item *);
> -int xfs_bui_recover(struct xfs_mount *mp, struct xfs_bui_log_item *buip,
> -		struct xfs_defer_ops *dfops);
> +int xfs_bui_recover(struct xfs_trans *parent_tp, struct xfs_bui_log_item *buip);
>  
>  #endif	/* __XFS_BMAP_ITEM_H__ */
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 7776fde9430c..fc1ce9a644e3 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4733,10 +4733,9 @@ xlog_recover_cancel_rui(
>  /* Recover the CUI if necessary. */
>  STATIC int
>  xlog_recover_process_cui(
> -	struct xfs_mount		*mp,
> +	struct xfs_trans		*parent_tp,
>  	struct xfs_ail			*ailp,
> -	struct xfs_log_item		*lip,
> -	struct xfs_defer_ops		*dfops)
> +	struct xfs_log_item		*lip)
>  {
>  	struct xfs_cui_log_item		*cuip;
>  	int				error;
> @@ -4749,7 +4748,7 @@ xlog_recover_process_cui(
>  		return 0;
>  
>  	spin_unlock(&ailp->ail_lock);
> -	error = xfs_cui_recover(mp, cuip, dfops);
> +	error = xfs_cui_recover(parent_tp, cuip);
>  	spin_lock(&ailp->ail_lock);
>  
>  	return error;
> @@ -4774,10 +4773,9 @@ xlog_recover_cancel_cui(
>  /* Recover the BUI if necessary. */
>  STATIC int
>  xlog_recover_process_bui(
> -	struct xfs_mount		*mp,
> +	struct xfs_trans		*parent_tp,
>  	struct xfs_ail			*ailp,
> -	struct xfs_log_item		*lip,
> -	struct xfs_defer_ops		*dfops)
> +	struct xfs_log_item		*lip)
>  {
>  	struct xfs_bui_log_item		*buip;
>  	int				error;
> @@ -4790,7 +4788,7 @@ xlog_recover_process_bui(
>  		return 0;
>  
>  	spin_unlock(&ailp->ail_lock);
> -	error = xfs_bui_recover(mp, buip, dfops);
> +	error = xfs_bui_recover(parent_tp, buip);
>  	spin_lock(&ailp->ail_lock);
>  
>  	return error;
> @@ -4829,9 +4827,9 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
>  /* Take all the collected deferred ops and finish them in order. */
>  static int
>  xlog_finish_defer_ops(
> -	struct xfs_mount	*mp,
> -	struct xfs_defer_ops	*dfops)
> +	struct xfs_trans	*parent_tp)
>  {
> +	struct xfs_mount	*mp = parent_tp->t_mountp;
>  	struct xfs_trans	*tp;
>  	int64_t			freeblks;
>  	uint			resblks;
> @@ -4855,7 +4853,7 @@ xlog_finish_defer_ops(
>  	if (error)
>  		return error;
>  	/* transfer all collected dfops to this transaction */
> -	xfs_defer_move(tp->t_dfops, dfops);
> +	xfs_defer_move(tp->t_dfops, parent_tp->t_dfops);
>  
>  	return xfs_trans_commit(tp);
>  }
> @@ -4880,22 +4878,34 @@ STATIC int
>  xlog_recover_process_intents(
>  	struct xlog		*log)
>  {
> -	struct xfs_defer_ops	dfops;
> +	struct xfs_trans	*parent_tp;
>  	struct xfs_ail_cursor	cur;
>  	struct xfs_log_item	*lip;
>  	struct xfs_ail		*ailp;
> -	int			error = 0;
> +	int			error;
>  #if defined(DEBUG) || defined(XFS_WARN)
>  	xfs_lsn_t		last_lsn;
>  #endif
>  
> +	/*
> +	 * The intent recovery handlers commit transactions to complete recovery
> +	 * for individual intents, but any new deferred operations that are
> +	 * queued during that process are held off until the very end. The
> +	 * purpose of this transaction is to serve as a container for deferred
> +	 * operations. Each intent recovery handler must transfer dfops here
> +	 * before its local transaction commits, and we'll finish the entire
> +	 * list below.
> +	 */
> +	error = xfs_trans_alloc_empty(log->l_mp, &parent_tp);
> +	if (error)
> +		return error;
> +
>  	ailp = log->l_ailp;
>  	spin_lock(&ailp->ail_lock);
>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
>  #if defined(DEBUG) || defined(XFS_WARN)
>  	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
>  #endif
> -	xfs_defer_init(NULL, &dfops);
>  	while (lip != NULL) {
>  		/*
>  		 * We're done when we see something other than an intent.
> @@ -4930,12 +4940,10 @@ xlog_recover_process_intents(
>  			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
>  			break;
>  		case XFS_LI_CUI:
> -			error = xlog_recover_process_cui(log->l_mp, ailp, lip,
> -					&dfops);
> +			error = xlog_recover_process_cui(parent_tp, ailp, lip);
>  			break;
>  		case XFS_LI_BUI:
> -			error = xlog_recover_process_bui(log->l_mp, ailp, lip,
> -					&dfops);
> +			error = xlog_recover_process_bui(parent_tp, ailp, lip);
>  			break;
>  		}
>  		if (error)
> @@ -4945,10 +4953,9 @@ xlog_recover_process_intents(
>  out:
>  	xfs_trans_ail_cursor_done(&cur);
>  	spin_unlock(&ailp->ail_lock);
> -	if (error)
> -		__xfs_defer_cancel(&dfops);
> -	else
> -		error = xlog_finish_defer_ops(log->l_mp, &dfops);
> +	if (!error)
> +		error = xlog_finish_defer_ops(parent_tp);
> +	xfs_trans_cancel(parent_tp);
>  
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index d3582a06626f..011e1d0640fb 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -380,9 +380,8 @@ xfs_cud_init(
>   */
>  int
>  xfs_cui_recover(
> -	struct xfs_mount		*mp,
> -	struct xfs_cui_log_item		*cuip,
> -	struct xfs_defer_ops		*dfops)
> +	struct xfs_trans		*parent_tp,
> +	struct xfs_cui_log_item		*cuip)
>  {
>  	int				i;
>  	int				error = 0;
> @@ -398,6 +397,7 @@ xfs_cui_recover(
>  	xfs_extlen_t			new_len;
>  	struct xfs_bmbt_irec		irec;
>  	bool				requeue_only = false;
> +	struct xfs_mount		*mp = parent_tp->t_mountp;
>  
>  	ASSERT(!test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags));
>  
> @@ -457,7 +457,7 @@ xfs_cui_recover(
>  	 * finishes them on completion. Transfer current dfops state to this
>  	 * transaction and transfer the result back before we return.
>  	 */
> -	xfs_defer_move(tp->t_dfops, dfops);
> +	xfs_defer_move(tp->t_dfops, parent_tp->t_dfops);
>  	cudp = xfs_trans_get_cud(tp, cuip);
>  
>  	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
> @@ -522,13 +522,13 @@ xfs_cui_recover(
>  
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
>  	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
> -	xfs_defer_move(dfops, tp->t_dfops);
> +	xfs_defer_move(parent_tp->t_dfops, tp->t_dfops);
>  	error = xfs_trans_commit(tp);
>  	return error;
>  
>  abort_error:
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> -	xfs_defer_move(dfops, tp->t_dfops);
> +	xfs_defer_move(parent_tp->t_dfops, tp->t_dfops);
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
> index dd830b69cd1e..3896dcc2368f 100644
> --- a/fs/xfs/xfs_refcount_item.h
> +++ b/fs/xfs/xfs_refcount_item.h
> @@ -82,7 +82,6 @@ struct xfs_cud_log_item *xfs_cud_init(struct xfs_mount *,
>  		struct xfs_cui_log_item *);
>  void xfs_cui_item_free(struct xfs_cui_log_item *);
>  void xfs_cui_release(struct xfs_cui_log_item *);
> -int xfs_cui_recover(struct xfs_mount *mp, struct xfs_cui_log_item *cuip,
> -		struct xfs_defer_ops *dfops);
> +int xfs_cui_recover(struct xfs_trans *parent_tp, struct xfs_cui_log_item *cuip);
>  
>  #endif	/* __XFS_REFCOUNT_ITEM_H__ */
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
