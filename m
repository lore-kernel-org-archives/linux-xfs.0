Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42122 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933601AbeGIQjx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jul 2018 12:39:53 -0400
Date: Mon, 9 Jul 2018 09:39:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_bmap_util: use swap macro
Message-ID: <20180709163939.GX32415@magnolia>
References: <20180709140539.GA17517@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180709140539.GA17517@embeddedor.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jul 09, 2018 at 09:05:39AM -0500, Gustavo A. R. Silva wrote:
> Make use of the swap macro and remove some unnecessary variables.
> This makes the code easier to read and maintain. Also, reduces the
> stack usage.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 83b1e8c..4b0b16f 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1691,7 +1691,6 @@ xfs_swap_extent_forks(
>  	int			*src_log_flags,
>  	int			*target_log_flags)
>  {
> -	struct xfs_ifork	tempifp, *ifp, *tifp;
>  	xfs_filblks_t		aforkblks = 0;
>  	xfs_filblks_t		taforkblks = 0;
>  	xfs_extnum_t		junk;
> @@ -1733,11 +1732,7 @@ xfs_swap_extent_forks(
>  	/*
>  	 * Swap the data forks of the inodes
>  	 */
> -	ifp = &ip->i_df;
> -	tifp = &tip->i_df;
> -	tempifp = *ifp;		/* struct copy */
> -	*ifp = *tifp;		/* struct copy */
> -	*tifp = tempifp;	/* struct copy */
> +	swap(ip->i_df, tip->i_df);
>  
>  	/*
>  	 * Fix the on-disk inode values

Why not use swap() on the di_nextents and di_format exchange below here
too?

> @@ -1987,14 +1982,10 @@ xfs_swap_extents(
>  
>  	/* Swap the cow forks. */
>  	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> -		xfs_extnum_t	extnum;
> -
>  		ASSERT(ip->i_cformat == XFS_DINODE_FMT_EXTENTS);
>  		ASSERT(tip->i_cformat == XFS_DINODE_FMT_EXTENTS);
>  
> -		extnum = ip->i_cnextents;
> -		ip->i_cnextents = tip->i_cnextents;
> -		tip->i_cnextents = extnum;
> +		swap(ip->i_cnextents, tip->i_cnextents);
>  
>  		cowfp = ip->i_cowfp;
>  		ip->i_cowfp = tip->i_cowfp;

Same here -- why not use swap on {ip,tip}->i_cowfp?

--D

> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
