Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41054 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731852AbeG3VHW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 17:07:22 -0400
Date: Mon, 30 Jul 2018 12:30:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/15] xfs: refactor internal dfops initialization
Message-ID: <20180730193048.GB30972@magnolia>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 12:45:06PM -0400, Brian Foster wrote:
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
> ---
>  fs/xfs/xfs_trans.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 7bf5c1202719..8d3b7f28b193 100644
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
> @@ -932,7 +926,7 @@ __xfs_trans_commit(
>  	trace_xfs_trans_commit(tp, _RET_IP_);
>  
>  	/* finish deferred items on final commit */
> -	if (!regrant && tp->t_dfops) {
> +	if (!regrant && (tp->t_flags & XFS_TRANS_PERM_LOG_RES)) {

The usage model of deferred ops is that one has to create a transaction
with a permanent reservation, and only then start attaching deferred ops
to the dfops inside the transaction.  It's a programming error if a
caller tries to finish deferred ops using a non-permanent transaction,
and prior to this patch t_dfops would be NULL and we'd blow up
immediately in xfs_defer_add(..., tp->t_dfops, ...);

However, now that we initialize t_dfops unconditionally, won't this
cause the above programming mistake to leak silently any incorrectly
queued defer ops?

--D

>  		error = xfs_defer_finish_noroll(&tp);
>  		if (error) {
>  			xfs_defer_cancel(tp);
> @@ -1029,7 +1023,7 @@ xfs_trans_cancel(
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
