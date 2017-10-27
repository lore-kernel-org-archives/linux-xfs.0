Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751176AbdJ0KvO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 06:51:14 -0400
Date: Fri, 27 Oct 2017 06:51:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: abort dir/attr btree operation if btree is
 obviously weird
Message-ID: <20171027105112.GB12642@bfoster.bfoster>
References: <150905816454.20365.10479338108395001494.stgit@magnolia>
 <150905817655.20365.5192555326576354285.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150905817655.20365.5192555326576354285.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 26, 2017 at 03:49:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Abort an dir/attr btree operation if the attr btree has obvious problems
> like loops back to the root or pointers don't point down the tree.
> Found by fuzzing btree[0].before to zero in xfs/402, which livelocks on
> the cycle in the attr btree.
> 
> Apply the same checks to xfs_da3_node_lookup_int.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_da_btree.c |   22 +++++++++++++++++++++-
>  fs/xfs/xfs_attr_list.c       |   20 ++++++++++++++++++++
>  2 files changed, 41 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 6d43358..6516115 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -1466,6 +1466,7 @@ xfs_da3_node_lookup_int(
>  	int			max;
>  	int			error;
>  	int			retval;
> +	unsigned int		expected_level = 0;
>  	struct xfs_inode	*dp = state->args->dp;
>  
>  	args = state->args;
> @@ -1474,7 +1475,7 @@ xfs_da3_node_lookup_int(
>  	 * Descend thru the B-tree searching each level for the right
>  	 * node to use, until the right hashval is found.
>  	 */
> -	blkno = (args->whichfork == XFS_DATA_FORK)? args->geo->leafblk : 0;
> +	blkno = args->geo->leafblk;
>  	for (blk = &state->path.blk[0], state->path.active = 1;
>  			 state->path.active <= XFS_DA_NODE_MAXDEPTH;
>  			 blk++, state->path.active++) {
> @@ -1517,6 +1518,18 @@ xfs_da3_node_lookup_int(
>  		dp->d_ops->node_hdr_from_disk(&nodehdr, node);
>  		btree = dp->d_ops->node_tree_p(node);
>  
> +		/* Tree taller than we can handle; bail out! */
> +		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH)
> +			return -EFSCORRUPTED;
> +
> +		/* Check the level from the root. */
> +		if (blkno == args->geo->leafblk)
> +			expected_level = nodehdr.level - 1;
> +		else if (expected_level != nodehdr.level)
> +			return -EFSCORRUPTED;
> +		else
> +			expected_level--;
> +
>  		max = nodehdr.count;
>  		blk->hashval = be32_to_cpu(btree[max - 1].hashval);
>  
> @@ -1562,8 +1575,15 @@ xfs_da3_node_lookup_int(
>  			blk->index = probe;
>  			blkno = be32_to_cpu(btree[probe].before);
>  		}
> +
> +		/* We can't point back to the root. */
> +		if (blkno == args->geo->leafblk)
> +			return -EFSCORRUPTED;
>  	}
>  
> +	if (expected_level != 0)
> +		return -EFSCORRUPTED;
> +
>  	/*
>  	 * A leaf block that ends in the hashval that we are interested in
>  	 * (final hashval == search hashval) means that the next block may
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 021ec5a..a360310 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -223,6 +223,7 @@ xfs_attr_node_list_lookup(
>  	struct xfs_buf			*bp;
>  	int				i;
>  	int				error = 0;
> +	unsigned int			expected_level = 0;
>  	uint16_t			magic;
>  
>  	ASSERT(*pbp == NULL);
> @@ -246,6 +247,18 @@ xfs_attr_node_list_lookup(
>  
>  		dp->d_ops->node_hdr_from_disk(&nodehdr, node);
>  
> +		/* Tree taller than we can handle; bail out! */
> +		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH)
> +			goto out_corruptbuf;
> +
> +		/* Check the level from the root node. */
> +		if (cursor->blkno == 0)
> +			expected_level = nodehdr.level - 1;
> +		else if (expected_level != nodehdr.level)
> +			goto out_corruptbuf;
> +		else
> +			expected_level--;
> +
>  		btree = dp->d_ops->node_tree_p(node);
>  		for (i = 0; i < nodehdr.count; btree++, i++) {
>  			if (cursor->hashval <= be32_to_cpu(btree->hashval)) {
> @@ -259,8 +272,15 @@ xfs_attr_node_list_lookup(
>  
>  		if (i == nodehdr.count)
>  			return 0;
> +
> +		/* We can't point back to the root. */
> +		if (cursor->blkno == 0)
> +			return -EFSCORRUPTED;
>  	}
>  
> +	if (expected_level != 0)
> +		goto out_corruptbuf;
> +
>  	*pbp = bp;
>  	return 0;
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
