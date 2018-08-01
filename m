Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:45526 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388953AbeHANxV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 09:53:21 -0400
Date: Wed, 1 Aug 2018 08:07:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: use a local variable for magic number in
 xfs_da3_node_lookup_int
Message-ID: <20180801120750.GC48176@bfoster>
References: <153307925470.7924.18204385078598751297.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153307925470.7924.18204385078598751297.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 31, 2018 at 04:20:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use a local variable for the block magic number checks instead of
> abusing blk->magic.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_da_btree.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 9efbd2038ffb..8ffe17b223da 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -1481,6 +1481,7 @@ xfs_da3_node_lookup_int(
>  	int			error;
>  	int			retval;
>  	unsigned int		expected_level = 0;
> +	uint16_t		magic;
>  	struct xfs_inode	*dp = state->args->dp;
>  
>  	args = state->args;
> @@ -1505,17 +1506,17 @@ xfs_da3_node_lookup_int(
>  			return error;
>  		}
>  		curr = blk->bp->b_addr;
> -		blk->magic = be16_to_cpu(curr->magic);
> +		magic = be16_to_cpu(curr->magic);
>  
> -		if (blk->magic == XFS_ATTR_LEAF_MAGIC ||
> -		    blk->magic == XFS_ATTR3_LEAF_MAGIC) {
> +		if (magic == XFS_ATTR_LEAF_MAGIC ||
> +		    magic == XFS_ATTR3_LEAF_MAGIC) {
>  			blk->magic = XFS_ATTR_LEAF_MAGIC;
>  			blk->hashval = xfs_attr_leaf_lasthash(blk->bp, NULL);
>  			break;
>  		}
>  
> -		if (blk->magic == XFS_DIR2_LEAFN_MAGIC ||
> -		    blk->magic == XFS_DIR3_LEAFN_MAGIC) {
> +		if (magic == XFS_DIR2_LEAFN_MAGIC ||
> +		    magic == XFS_DIR3_LEAFN_MAGIC) {
>  			blk->magic = XFS_DIR2_LEAFN_MAGIC;
>  			blk->hashval = xfs_dir2_leaf_lasthash(args->dp,
>  							      blk->bp, NULL);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
