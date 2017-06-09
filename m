Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47088 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751578AbdFIMyR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Jun 2017 08:54:17 -0400
Date: Fri, 9 Jun 2017 08:54:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 11/13] xfs: return the hash value of a leaf1 directory
 block
Message-ID: <20170609125414.GB10685@bfoster.bfoster>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643870873.23065.5974641750134566189.stgit@birch.djwong.org>
 <20170608182236.GL4530@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170608182236.GL4530@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 08, 2017 at 11:22:36AM -0700, Darrick J. Wong wrote:
> Modify the existing dir leafn lasthash function to enable us to
> calculate the highest hash value of a leaf1 block.  This will be used by
> the directory scrubbing code to check the sanity of hashes in leaf1
> directory blocks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Thanks for the update..

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_da_btree.c  |   10 +++++-----
>  fs/xfs/libxfs/xfs_dir2_node.c |   10 ++++++----
>  fs/xfs/libxfs/xfs_dir2_priv.h |    2 +-
>  3 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 48f1136..356f21d 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -1282,7 +1282,7 @@ xfs_da3_fixhashpath(
>  			return;
>  		break;
>  	case XFS_DIR2_LEAFN_MAGIC:
> -		lasthash = xfs_dir2_leafn_lasthash(dp, blk->bp, &count);
> +		lasthash = xfs_dir2_leaf_lasthash(dp, blk->bp, &count);
>  		if (count == 0)
>  			return;
>  		break;
> @@ -1502,8 +1502,8 @@ xfs_da3_node_lookup_int(
>  		if (blk->magic == XFS_DIR2_LEAFN_MAGIC ||
>  		    blk->magic == XFS_DIR3_LEAFN_MAGIC) {
>  			blk->magic = XFS_DIR2_LEAFN_MAGIC;
> -			blk->hashval = xfs_dir2_leafn_lasthash(args->dp,
> -							       blk->bp, NULL);
> +			blk->hashval = xfs_dir2_leaf_lasthash(args->dp,
> +							      blk->bp, NULL);
>  			break;
>  		}
>  
> @@ -1929,8 +1929,8 @@ xfs_da3_path_shift(
>  			blk->magic = XFS_DIR2_LEAFN_MAGIC;
>  			ASSERT(level == path->active-1);
>  			blk->index = 0;
> -			blk->hashval = xfs_dir2_leafn_lasthash(args->dp,
> -							       blk->bp, NULL);
> +			blk->hashval = xfs_dir2_leaf_lasthash(args->dp,
> +							      blk->bp, NULL);
>  			break;
>  		default:
>  			ASSERT(0);
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index bbd1238..682e2bf 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -528,7 +528,7 @@ xfs_dir2_free_hdr_check(
>   * Stale entries are ok.
>   */
>  xfs_dahash_t					/* hash value */
> -xfs_dir2_leafn_lasthash(
> +xfs_dir2_leaf_lasthash(
>  	struct xfs_inode *dp,
>  	struct xfs_buf	*bp,			/* leaf buffer */
>  	int		*count)			/* count of entries in leaf */
> @@ -540,7 +540,9 @@ xfs_dir2_leafn_lasthash(
>  	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
>  
>  	ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
> -	       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
> +	       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC ||
> +	       leafhdr.magic == XFS_DIR2_LEAF1_MAGIC ||
> +	       leafhdr.magic == XFS_DIR3_LEAF1_MAGIC);
>  
>  	if (count)
>  		*count = leafhdr.count;
> @@ -1405,8 +1407,8 @@ xfs_dir2_leafn_split(
>  	/*
>  	 * Update last hashval in each block since we added the name.
>  	 */
> -	oldblk->hashval = xfs_dir2_leafn_lasthash(dp, oldblk->bp, NULL);
> -	newblk->hashval = xfs_dir2_leafn_lasthash(dp, newblk->bp, NULL);
> +	oldblk->hashval = xfs_dir2_leaf_lasthash(dp, oldblk->bp, NULL);
> +	newblk->hashval = xfs_dir2_leaf_lasthash(dp, newblk->bp, NULL);
>  	xfs_dir3_leaf_check(dp, oldblk->bp);
>  	xfs_dir3_leaf_check(dp, newblk->bp);
>  	return error;
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 576f2d2..6d24209 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -95,7 +95,7 @@ extern bool xfs_dir3_leaf_check_int(struct xfs_mount *mp, struct xfs_inode *dp,
>  /* xfs_dir2_node.c */
>  extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
>  		struct xfs_buf *lbp);
> -extern xfs_dahash_t xfs_dir2_leafn_lasthash(struct xfs_inode *dp,
> +extern xfs_dahash_t xfs_dir2_leaf_lasthash(struct xfs_inode *dp,
>  		struct xfs_buf *bp, int *count);
>  extern int xfs_dir2_leafn_lookup_int(struct xfs_buf *bp,
>  		struct xfs_da_args *args, int *indexp,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
