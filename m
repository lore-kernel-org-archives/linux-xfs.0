Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932129AbeB0Nzr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Feb 2018 08:55:47 -0500
Date: Tue, 27 Feb 2018 08:55:46 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/5] xfs: convert a few more directory asserts to
 corruption returns
Message-ID: <20180227135545.GC3479@bfoster.bfoster>
References: <151935118240.21654.10146641674018880885.stgit@magnolia>
 <151935119455.21654.14975075500644689016.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151935119455.21654.14975075500644689016.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 22, 2018 at 05:59:54PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Yet another round of playing whack-a-mole with directory code that
> asserts on corrupt on-disk metadata when it really should be returning
> -EFSCORRUPTED instead of ASSERTing.  Found by a xfs/391 crash while
> lastbit fuzzing of ltail.bestcount.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_dir2_leaf.c |    3 ++-
>  fs/xfs/libxfs/xfs_dir2_node.c |    5 +++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index d7e630f..d61d52d 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -1415,7 +1415,8 @@ xfs_dir2_leaf_removename(
>  	oldbest = be16_to_cpu(bf[0].length);
>  	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
>  	bestsp = xfs_dir2_leaf_bests_p(ltp);
> -	ASSERT(be16_to_cpu(bestsp[db]) == oldbest);
> +	if (be16_to_cpu(bestsp[db]) != oldbest)
> +		return -EFSCORRUPTED;
>  	/*
>  	 * Mark the former data entry unused.
>  	 */
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 239d97a..0839ffe 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -387,8 +387,9 @@ xfs_dir2_leaf_to_node(
>  	dp->d_ops->free_hdr_from_disk(&freehdr, free);
>  	leaf = lbp->b_addr;
>  	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
> -	ASSERT(be32_to_cpu(ltp->bestcount) <=
> -				(uint)dp->i_d.di_size / args->geo->blksize);
> +	if (be32_to_cpu(ltp->bestcount) >
> +				(uint)dp->i_d.di_size / args->geo->blksize)
> +		return -EFSCORRUPTED;
>  
>  	/*
>  	 * Copy freespace entries from the leaf block to the new block.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
