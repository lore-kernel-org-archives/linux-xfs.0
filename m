Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55380 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752862AbeGCVZ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 17:25:27 -0400
Date: Tue, 3 Jul 2018 14:25:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 22/24] xfs: use ->t_dfops in cancel cow blocks operation
Message-ID: <20180703212513.GR32415@magnolia>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-23-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-23-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:34PM -0400, Brian Foster wrote:
> Use ->t_dfops of the transaction from the caller. Reset it before we
> return to avoid leaks of local stack memory.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_reflink.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 7cfe74d1514e..75a99bb020e4 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -553,6 +553,7 @@ xfs_reflink_cancel_cow_blocks(
>  	struct xfs_iext_cursor		icur;
>  	xfs_fsblock_t			firstfsb;
>  	struct xfs_defer_ops		dfops;
> +	struct xfs_defer_ops		*odfops = (*tpp)->t_dfops;
>  	int				error = 0;
>  
>  	if (!xfs_is_reflink_inode(ip))
> @@ -580,23 +581,24 @@ xfs_reflink_cancel_cow_blocks(
>  				break;
>  		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
>  			xfs_defer_init(&dfops, &firstfsb);
> +			(*tpp)->t_dfops = &dfops;
>  
>  			/* Free the CoW orphan record. */
>  			error = xfs_refcount_free_cow_extent(ip->i_mount,
> -					&dfops, del.br_startblock,
> +					(*tpp)->t_dfops, del.br_startblock,
>  					del.br_blockcount);
>  			if (error)
>  				break;
>  
> -			xfs_bmap_add_free(ip->i_mount, &dfops,
> +			xfs_bmap_add_free(ip->i_mount, (*tpp)->t_dfops,
>  					del.br_startblock, del.br_blockcount,
>  					NULL);
>  
>  			/* Roll the transaction */
> -			xfs_defer_ijoin(&dfops, ip);
> -			error = xfs_defer_finish(tpp, &dfops);
> +			xfs_defer_ijoin((*tpp)->t_dfops, ip);
> +			error = xfs_defer_finish(tpp, (*tpp)->t_dfops);
>  			if (error) {
> -				xfs_defer_cancel(&dfops);
> +				xfs_defer_cancel((*tpp)->t_dfops);
>  				break;
>  			}
>  
> @@ -621,7 +623,7 @@ xfs_reflink_cancel_cow_blocks(
>  	/* clear tag if cow fork is emptied */
>  	if (!ifp->if_bytes)
>  		xfs_inode_clear_cowblocks_tag(ip);
> -
> +	(*tpp)->t_dfops = odfops;
>  	return error;
>  }
>  
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
