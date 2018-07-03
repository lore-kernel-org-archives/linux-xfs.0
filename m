Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58130 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753009AbeGCVZm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 17:25:42 -0400
Date: Tue, 3 Jul 2018 14:25:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 23/24] xfs: use ->t_dfops in reflink cow recover path
Message-ID: <20180703212527.GS32415@magnolia>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-24-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-24-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:35PM -0400, Brian Foster wrote:
> Use ->t_dfops of the leftover COW reservation cleanup transaction.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_refcount.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 8e330a196060..df67821fb5f4 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1692,18 +1692,19 @@ xfs_refcount_recover_cow_leftovers(
>  
>  		/* Free the orphan record */
>  		xfs_defer_init(&dfops, &fsb);
> +		tp->t_dfops = &dfops;
>  		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
>  		fsb = XFS_AGB_TO_FSB(mp, agno, agbno);
> -		error = xfs_refcount_free_cow_extent(mp, &dfops, fsb,
> +		error = xfs_refcount_free_cow_extent(mp, tp->t_dfops, fsb,
>  				rr->rr_rrec.rc_blockcount);
>  		if (error)
>  			goto out_defer;
>  
>  		/* Free the block. */
> -		xfs_bmap_add_free(mp, &dfops, fsb,
> +		xfs_bmap_add_free(mp, tp->t_dfops, fsb,
>  				rr->rr_rrec.rc_blockcount, NULL);
>  
> -		error = xfs_defer_finish(&tp, &dfops);
> +		error = xfs_defer_finish(&tp, tp->t_dfops);
>  		if (error)
>  			goto out_defer;
>  
> @@ -1717,7 +1718,7 @@ xfs_refcount_recover_cow_leftovers(
>  
>  	return error;
>  out_defer:
> -	xfs_defer_cancel(&dfops);
> +	xfs_defer_cancel(tp->t_dfops);
>  out_trans:
>  	xfs_trans_cancel(tp);
>  out_free:
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
