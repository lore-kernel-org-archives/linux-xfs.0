Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732698AbfHHQF5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Aug 2019 12:05:57 -0400
Date: Thu, 8 Aug 2019 11:05:55 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 2/3] xfs: remove more ondisk directory corruption asserts
Message-ID: <20190808160555.GA19733@redhat.com>
References: <156527561023.1960675.17007470833732765300.stgit@magnolia>
 <156527562244.1960675.10725983010213633067.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156527562244.1960675.10725983010213633067.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Aug 08, 2019 at 07:47:02AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Continue our game of replacing ASSERTs for corrupt ondisk metadata with
> EFSCORRUPTED returns.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good to me.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_da_btree.c  |   19 ++++++++++++-------
>  fs/xfs/libxfs/xfs_dir2_node.c |    3 ++-
>  2 files changed, 14 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index d1c77fd0815d..0bf56e94bfe9 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -487,10 +487,8 @@ xfs_da3_split(
>  	ASSERT(state->path.active == 0);
>  	oldblk = &state->path.blk[0];
>  	error = xfs_da3_root_split(state, oldblk, addblk);
> -	if (error) {
> -		addblk->bp = NULL;
> -		return error;	/* GROT: dir is inconsistent */
> -	}
> +	if (error)
> +		goto out;
>  
>  	/*
>  	 * Update pointers to the node which used to be block 0 and just got
> @@ -505,7 +503,10 @@ xfs_da3_split(
>  	 */
>  	node = oldblk->bp->b_addr;
>  	if (node->hdr.info.forw) {
> -		ASSERT(be32_to_cpu(node->hdr.info.forw) == addblk->blkno);
> +		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
> +			error = -EFSCORRUPTED;
> +			goto out;
> +		}
>  		node = addblk->bp->b_addr;
>  		node->hdr.info.back = cpu_to_be32(oldblk->blkno);
>  		xfs_trans_log_buf(state->args->trans, addblk->bp,
> @@ -514,15 +515,19 @@ xfs_da3_split(
>  	}
>  	node = oldblk->bp->b_addr;
>  	if (node->hdr.info.back) {
> -		ASSERT(be32_to_cpu(node->hdr.info.back) == addblk->blkno);
> +		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
> +			error = -EFSCORRUPTED;
> +			goto out;
> +		}
>  		node = addblk->bp->b_addr;
>  		node->hdr.info.forw = cpu_to_be32(oldblk->blkno);
>  		xfs_trans_log_buf(state->args->trans, addblk->bp,
>  				  XFS_DA_LOGRANGE(node, &node->hdr.info,
>  				  sizeof(node->hdr.info)));
>  	}
> +out:
>  	addblk->bp = NULL;
> -	return 0;
> +	return error;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index afcc6642690a..1fc44efc344d 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -741,7 +741,8 @@ xfs_dir2_leafn_lookup_for_entry(
>  	ents = dp->d_ops->leaf_ents_p(leaf);
>  
>  	xfs_dir3_leaf_check(dp, bp);
> -	ASSERT(leafhdr.count > 0);
> +	if (leafhdr.count <= 0)
> +		return -EFSCORRUPTED;
>  
>  	/*
>  	 * Look up the hash value in the leaf entries.
> 
