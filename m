Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38006 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387944AbeHAVAH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 17:00:07 -0400
Date: Wed, 1 Aug 2018 12:12:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 10/15] xfs: clean out superfluous dfops dop params/vars
Message-ID: <20180801191248.GJ30972@magnolia>
References: <20180801131952.60250-1-bfoster@redhat.com>
 <20180801131952.60250-11-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180801131952.60250-11-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 01, 2018 at 09:19:47AM -0400, Brian Foster wrote:
> The dfops code still passes around the xfs_defer_ops pointer
> superfluously in a few places. Clean this up wherever the
> transaction will suffice.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_defer.c | 43 +++++++++++++++++++--------------------
>  fs/xfs/libxfs/xfs_defer.h |  2 +-
>  2 files changed, 22 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 66ef9341813b..7079f534c735 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -181,9 +181,9 @@ static const struct xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX];
>   */
>  STATIC void
>  xfs_defer_intake_work(
> -	struct xfs_trans		*tp,
> -	struct xfs_defer_ops		*dop)
> +	struct xfs_trans		*tp)
>  {
> +	struct xfs_defer_ops		*dop = tp->t_dfops;
>  	struct list_head		*li;
>  	struct xfs_defer_pending	*dfp;
>  
> @@ -204,9 +204,9 @@ xfs_defer_intake_work(
>  STATIC void
>  xfs_defer_trans_abort(
>  	struct xfs_trans		*tp,
> -	struct xfs_defer_ops		*dop,
>  	int				error)
>  {
> +	struct xfs_defer_ops		*dop = tp->t_dfops;
>  	struct xfs_defer_pending	*dfp;
>  
>  	trace_xfs_defer_trans_abort(tp->t_mountp, dop, _RET_IP_);
> @@ -230,7 +230,6 @@ STATIC int
>  xfs_defer_trans_roll(
>  	struct xfs_trans		**tp)
>  {
> -	struct xfs_defer_ops		*dop = (*tp)->t_dfops;
>  	struct xfs_buf_log_item		*bli;
>  	struct xfs_inode_log_item	*ili;
>  	struct xfs_log_item		*lip;
> @@ -272,14 +271,14 @@ xfs_defer_trans_roll(
>  		}
>  	}
>  
> -	trace_xfs_defer_trans_roll((*tp)->t_mountp, dop, _RET_IP_);
> +	trace_xfs_defer_trans_roll((*tp)->t_mountp, (*tp)->t_dfops, _RET_IP_);
>  
>  	/* Roll the transaction. */
>  	error = xfs_trans_roll(tp);
> -	dop = (*tp)->t_dfops;
>  	if (error) {
> -		trace_xfs_defer_trans_roll_error((*tp)->t_mountp, dop, error);
> -		xfs_defer_trans_abort(*tp, dop, error);
> +		trace_xfs_defer_trans_roll_error((*tp)->t_mountp,
> +						 (*tp)->t_dfops, error);
> +		xfs_defer_trans_abort(*tp,  error);
>  		return error;
>  	}
>  
> @@ -299,9 +298,10 @@ xfs_defer_trans_roll(
>  /* Do we have any work items to finish? */
>  bool
>  xfs_defer_has_unfinished_work(
> -	struct xfs_defer_ops		*dop)
> +	struct xfs_trans		*tp)

The WARN_ON_ONCE in __xfs_trans_commit needs to be converted too.
Will fix that on the way in.

--D

>  {
> -	return !list_empty(&dop->dop_pending) || !list_empty(&dop->dop_intake);
> +	return !list_empty(&tp->t_dfops->dop_pending) ||
> +		!list_empty(&tp->t_dfops->dop_intake);
>  }
>  
>  /*
> @@ -311,7 +311,7 @@ static void
>  xfs_defer_reset(
>  	struct xfs_trans	*tp)
>  {
> -	ASSERT(!xfs_defer_has_unfinished_work(tp->t_dfops));
> +	ASSERT(!xfs_defer_has_unfinished_work(tp));
>  
>  	/*
>  	 * Low mode state transfers across transaction rolls to mirror dfops
> @@ -332,7 +332,6 @@ int
>  xfs_defer_finish_noroll(
>  	struct xfs_trans		**tp)
>  {
> -	struct xfs_defer_ops		*dop = (*tp)->t_dfops;
>  	struct xfs_defer_pending	*dfp;
>  	struct list_head		*li;
>  	struct list_head		*n;
> @@ -342,24 +341,22 @@ xfs_defer_finish_noroll(
>  
>  	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
>  
> -	trace_xfs_defer_finish((*tp)->t_mountp, dop, _RET_IP_);
> +	trace_xfs_defer_finish((*tp)->t_mountp, (*tp)->t_dfops, _RET_IP_);
>  
>  	/* Until we run out of pending work to finish... */
> -	while (xfs_defer_has_unfinished_work(dop)) {
> +	while (xfs_defer_has_unfinished_work(*tp)) {
>  		/* Log intents for work items sitting in the intake. */
> -		xfs_defer_intake_work(*tp, dop);
> +		xfs_defer_intake_work(*tp);
>  
>  		/*
> -		 * Roll the transaction and update dop in case dfops was
> -		 * embedded in the transaction.
> +		 * Roll the transaction.
>  		 */
>  		error = xfs_defer_trans_roll(tp);
>  		if (error)
>  			goto out;
> -		dop = (*tp)->t_dfops;
>  
>  		/* Log an intent-done item for the first pending item. */
> -		dfp = list_first_entry(&dop->dop_pending,
> +		dfp = list_first_entry(&(*tp)->t_dfops->dop_pending,
>  				struct xfs_defer_pending, dfp_list);
>  		trace_xfs_defer_pending_finish((*tp)->t_mountp, dfp);
>  		dfp->dfp_done = dfp->dfp_type->create_done(*tp, dfp->dfp_intent,
> @@ -390,7 +387,7 @@ xfs_defer_finish_noroll(
>  				 */
>  				if (cleanup_fn)
>  					cleanup_fn(*tp, state, error);
> -				xfs_defer_trans_abort(*tp, dop, error);
> +				xfs_defer_trans_abort(*tp, error);
>  				goto out;
>  			}
>  		}
> @@ -420,9 +417,11 @@ xfs_defer_finish_noroll(
>  
>  out:
>  	if (error)
> -		trace_xfs_defer_finish_error((*tp)->t_mountp, dop, error);
> +		trace_xfs_defer_finish_error((*tp)->t_mountp, (*tp)->t_dfops,
> +					     error);
>  	 else
> -		trace_xfs_defer_finish_done((*tp)->t_mountp, dop, _RET_IP_);
> +		trace_xfs_defer_finish_done((*tp)->t_mountp, (*tp)->t_dfops,
> +					    _RET_IP_);
>  
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 0de7504e5651..f051c8056141 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -41,7 +41,7 @@ int xfs_defer_finish_noroll(struct xfs_trans **tp);
>  int xfs_defer_finish(struct xfs_trans **tp);
>  void xfs_defer_cancel(struct xfs_trans *);
>  void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
> -bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
> +bool xfs_defer_has_unfinished_work(struct xfs_trans *tp);
>  void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
>  
>  /* Description of a deferred type. */
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
