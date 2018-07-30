Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58240 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbeG3Vqz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 17:46:55 -0400
Date: Mon, 30 Jul 2018 13:10:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/15] xfs: pass transaction to dfops reset/move helpers
Message-ID: <20180730201012.GE30972@magnolia>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-5-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 12:45:09PM -0400, Brian Foster wrote:
> All callers pass ->t_dfops of the associated transactions. Refactor
> the helpers to receive the transactions and facilitate further
> cleanups between xfs_defer_ops and xfs_trans.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_defer.c  | 15 ++++++++++-----
>  fs/xfs/libxfs/xfs_defer.h  |  2 +-
>  fs/xfs/xfs_bmap_item.c     |  6 +++---
>  fs/xfs/xfs_log_recover.c   |  2 +-
>  fs/xfs/xfs_refcount_item.c |  6 +++---
>  fs/xfs/xfs_trans.c         |  2 +-
>  6 files changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index ebead781613f..e3517a53c525 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -324,9 +324,12 @@ xfs_defer_bjoin(
>   */
>  static void
>  xfs_defer_reset(
> -	struct xfs_defer_ops	*dop)
> +	struct xfs_trans	*tp)
>  {
> +	struct xfs_defer_ops	*dop = tp->t_dfops;
> +
>  	ASSERT(!xfs_defer_has_unfinished_work(dop));
> +
>  	dop->dop_low = false;
>  	memset(dop->dop_inodes, 0, sizeof(dop->dop_inodes));
>  	memset(dop->dop_bufs, 0, sizeof(dop->dop_bufs));
> @@ -457,7 +460,7 @@ xfs_defer_finish(
>  		if (error)
>  			return error;
>  	}
> -	xfs_defer_reset((*tp)->t_dfops);
> +	xfs_defer_reset(*tp);
>  	return 0;
>  }
>  
> @@ -575,9 +578,11 @@ xfs_defer_init(
>   */
>  void
>  xfs_defer_move(
> -	struct xfs_defer_ops	*dst,
> -	struct xfs_defer_ops	*src)
> +	struct xfs_trans	*dtp,
> +	struct xfs_trans	*stp)
>  {
> +	struct xfs_defer_ops	*dst = dtp->t_dfops;
> +	struct xfs_defer_ops	*src = stp->t_dfops;
>  	ASSERT(dst != src);
>  
>  	list_splice_init(&src->dop_intake, &dst->dop_intake);
> @@ -587,5 +592,5 @@ xfs_defer_move(
>  	memcpy(dst->dop_bufs, src->dop_bufs, sizeof(dst->dop_bufs));
>  	dst->dop_low = src->dop_low;
>  
> -	xfs_defer_reset(src);
> +	xfs_defer_reset(stp);
>  }
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index da145fc04ae1..d60c50498fdf 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -55,7 +55,7 @@ void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
>  bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
>  int xfs_defer_ijoin(struct xfs_defer_ops *dop, struct xfs_inode *ip);
>  int xfs_defer_bjoin(struct xfs_defer_ops *dop, struct xfs_buf *bp);
> -void xfs_defer_move(struct xfs_defer_ops *dst, struct xfs_defer_ops *src);
> +void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
>  
>  /* Description of a deferred type. */
>  struct xfs_defer_op_type {
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 992235e7c761..4b4318ea4b76 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -446,7 +446,7 @@ xfs_bui_recover(
>  	 * finishes them on completion. Transfer current dfops state to this
>  	 * transaction and transfer the result back before we return.
>  	 */
> -	xfs_defer_move(tp->t_dfops, itp->t_dfops);
> +	xfs_defer_move(tp, itp);
>  	budp = xfs_trans_get_bud(tp, buip);
>  
>  	/* Grab the inode. */
> @@ -494,7 +494,7 @@ xfs_bui_recover(
>  	}
>  
>  	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
> -	xfs_defer_move(itp->t_dfops, tp->t_dfops);
> +	xfs_defer_move(itp, tp);
>  	error = xfs_trans_commit(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	xfs_irele(ip);
> @@ -502,7 +502,7 @@ xfs_bui_recover(
>  	return error;
>  
>  err_inode:
> -	xfs_defer_move(itp->t_dfops, tp->t_dfops);
> +	xfs_defer_move(itp, tp);
>  	xfs_trans_cancel(tp);
>  	if (ip) {
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 6650b790e43b..b4edd93a18e9 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4853,7 +4853,7 @@ xlog_finish_defer_ops(
>  	if (error)
>  		return error;
>  	/* transfer all collected dfops to this transaction */
> -	xfs_defer_move(tp->t_dfops, itp->t_dfops);
> +	xfs_defer_move(tp, itp);
>  
>  	return xfs_trans_commit(tp);
>  }
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index d663ea1f4076..829b7a5bc707 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -457,7 +457,7 @@ xfs_cui_recover(
>  	 * finishes them on completion. Transfer current dfops state to this
>  	 * transaction and transfer the result back before we return.
>  	 */
> -	xfs_defer_move(tp->t_dfops, itp->t_dfops);
> +	xfs_defer_move(tp, itp);
>  	cudp = xfs_trans_get_cud(tp, cuip);
>  
>  	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
> @@ -522,13 +522,13 @@ xfs_cui_recover(
>  
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
>  	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
> -	xfs_defer_move(itp->t_dfops, tp->t_dfops);
> +	xfs_defer_move(itp, tp);
>  	error = xfs_trans_commit(tp);
>  	return error;
>  
>  abort_error:
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> -	xfs_defer_move(itp->t_dfops, tp->t_dfops);
> +	xfs_defer_move(itp, tp);
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index b0eeeaf6d24e..8c088568b05d 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -125,7 +125,7 @@ xfs_trans_dup(
>  	if (tp->t_dfops != &tp->t_dfops_internal)
>  		ntp->t_dfops = tp->t_dfops;
>  	else
> -		xfs_defer_move(ntp->t_dfops, tp->t_dfops);
> +		xfs_defer_move(ntp, tp);
>  
>  	xfs_trans_dup_dqinfo(tp, ntp);
>  
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
