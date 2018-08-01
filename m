Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53996 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389528AbeHAQUd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 12:20:33 -0400
Date: Wed, 1 Aug 2018 07:34:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 01/15] xfs: refactor internal dfops initialization
Message-ID: <20180801143420.GC30972@magnolia>
References: <20180801131952.60250-1-bfoster@redhat.com>
 <20180801131952.60250-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180801131952.60250-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 01, 2018 at 09:19:38AM -0400, Brian Foster wrote:
> The current transaction allocation code conditionally initializes
> the ->t_dfops indirection pointer. Transaction commit/cancel check
> the validity of the pointer to determine whether to finish/cancel
> the internal dfops.
> 
> This disallows the ability to use the internal dfops list as a
> temporary container (via xfs_trans_alloc_empty()). Refactor
> transaction allocation to always initialize ->t_dfops and check
> permanent reservation state on transaction commit/cancel.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trans.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 7bf5c1202719..12b6ad1558e6 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -281,13 +281,7 @@ xfs_trans_alloc(
>  	INIT_LIST_HEAD(&tp->t_items);
>  	INIT_LIST_HEAD(&tp->t_busy);
>  	tp->t_firstblock = NULLFSBLOCK;
> -	/*
> -	 * We only roll transactions with permanent log reservation. Don't init
> -	 * ->t_dfops to skip attempts to finish or cancel an empty dfops with a
> -	 * non-permanent res.
> -	 */
> -	if (resp->tr_logflags & XFS_TRANS_PERM_LOG_RES)
> -		xfs_defer_init(tp, &tp->t_dfops_internal);
> +	xfs_defer_init(tp, &tp->t_dfops_internal);
>  
>  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
>  	if (error) {
> @@ -931,8 +925,13 @@ __xfs_trans_commit(
>  
>  	trace_xfs_trans_commit(tp, _RET_IP_);
>  
> -	/* finish deferred items on final commit */
> -	if (!regrant && tp->t_dfops) {
> +	/*
> +	 * Finish deferred items on final commit. Only permanent transactions
> +	 * should ever have deferred ops.
> +	 */
> +	WARN_ON_ONCE(xfs_defer_has_unfinished_work(tp->t_dfops) &&
> +		     !(tp->t_flags & XFS_TRANS_PERM_LOG_RES));
> +	if (!regrant && (tp->t_flags & XFS_TRANS_PERM_LOG_RES)) {
>  		error = xfs_defer_finish_noroll(&tp);
>  		if (error) {
>  			xfs_defer_cancel(tp);
> @@ -1029,7 +1028,7 @@ xfs_trans_cancel(
>  
>  	trace_xfs_trans_cancel(tp, _RET_IP_);
>  
> -	if (tp->t_dfops)
> +	if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
>  		xfs_defer_cancel(tp);
>  
>  	/*
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
