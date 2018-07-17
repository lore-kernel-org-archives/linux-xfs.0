Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57700 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729758AbeGQRsc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jul 2018 13:48:32 -0400
Date: Tue, 17 Jul 2018 10:14:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: use swap macro in xfs_dir2_leafn_rebalance
Message-ID: <20180717171433.GU32415@magnolia>
References: <20180717161127.GA16337@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180717161127.GA16337@embeddedor.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jul 17, 2018 at 11:11:27AM -0500, Gustavo A. R. Silva wrote:
> Make use of the swap macro and remove unnecessary variable *tmp*. This
> makes the code easier to read and maintain. Also, slightly refactor some
> code.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_node.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 2daf874..f1bb343 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1012,7 +1012,7 @@ xfs_dir2_leafn_rebalance(
>  	int			oldstale;	/* old count of stale leaves */
>  #endif
>  	int			oldsum;		/* old total leaf count */
> -	int			swap;		/* swapped leaf blocks */
> +	int			swap_blocks;	/* swapped leaf blocks */
>  	struct xfs_dir2_leaf_entry *ents1;
>  	struct xfs_dir2_leaf_entry *ents2;
>  	struct xfs_dir3_icleaf_hdr hdr1;
> @@ -1023,13 +1023,10 @@ xfs_dir2_leafn_rebalance(
>  	/*
>  	 * If the block order is wrong, swap the arguments.
>  	 */
> -	if ((swap = xfs_dir2_leafn_order(dp, blk1->bp, blk2->bp))) {
> -		xfs_da_state_blk_t	*tmp;	/* temp for block swap */
> +	swap_blocks = xfs_dir2_leafn_order(dp, blk1->bp, blk2->bp);
> +	if (swap_blocks)
> +		swap(blk1, blk2);
>  
> -		tmp = blk1;
> -		blk1 = blk2;
> -		blk2 = tmp;
> -	}
>  	leaf1 = blk1->bp->b_addr;
>  	leaf2 = blk2->bp->b_addr;
>  	dp->d_ops->leaf_hdr_from_disk(&hdr1, leaf1);
> @@ -1093,11 +1090,11 @@ xfs_dir2_leafn_rebalance(
>  	 * Mark whether we're inserting into the old or new leaf.
>  	 */
>  	if (hdr1.count < hdr2.count)
> -		state->inleaf = swap;
> +		state->inleaf = swap_blocks;
>  	else if (hdr1.count > hdr2.count)
> -		state->inleaf = !swap;
> +		state->inleaf = !swap_blocks;
>  	else
> -		state->inleaf = swap ^ (blk1->index <= hdr1.count);
> +		state->inleaf = swap_blocks ^ (blk1->index <= hdr1.count);
>  	/*
>  	 * Adjust the expected index for insertion.
>  	 */
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
