Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43974 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388924AbeGKRt6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jul 2018 13:49:58 -0400
Date: Wed, 11 Jul 2018 10:44:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_attr_leaf: use swap macro in xfs_attr3_leaf_rebalance
Message-ID: <20180711174421.GH32415@magnolia>
References: <20180709161247.GA4746@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180709161247.GA4746@embeddedor.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jul 09, 2018 at 11:12:47AM -0500, Gustavo A. R. Silva wrote:
> Make use of the swap macro and remove some unnecessary variables.
> This makes the code easier to read and maintain. Also, reduces the
> stack usage.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 76e9004..ec0bf96 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1570,17 +1570,10 @@ xfs_attr3_leaf_rebalance(
>  	 */
>  	swap = 0;
>  	if (xfs_attr3_leaf_order(blk1->bp, &ichdr1, blk2->bp, &ichdr2)) {
> -		struct xfs_da_state_blk	*tmp_blk;
> -		struct xfs_attr3_icleaf_hdr tmp_ichdr;
> +		swap(blk1, blk2);
>  
> -		tmp_blk = blk1;
> -		blk1 = blk2;
> -		blk2 = tmp_blk;
> -
> -		/* struct copies to swap them rather than reconverting */
> -		tmp_ichdr = ichdr1;
> -		ichdr1 = ichdr2;
> -		ichdr2 = tmp_ichdr;
> +		/* swap structures rather than reconverting them */
> +		swap(ichdr1, ichdr2);
>  
>  		leaf1 = blk1->bp->b_addr;
>  		leaf2 = blk2->bp->b_addr;
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
