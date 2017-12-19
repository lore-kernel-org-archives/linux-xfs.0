Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:23743 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966446AbdLSEMm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 23:12:42 -0500
Date: Tue, 19 Dec 2017 15:12:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/13] xfs: have buffer verifier functions report failing
 address
Message-ID: <20171219041238.GM4094@dastard>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320951104.30654.17605262300441313090.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151320951104.30654.17605262300441313090.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 13, 2017 at 03:58:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Modify each function that checks the contents of a metadata buffer to
> return the instruction address of the failing test so that we can report
> more precise failure errors to the log.


> @@ -331,29 +332,29 @@ xfs_allocbt_verify(
>  	level = be16_to_cpu(block->bb_level);
>  	switch (block->bb_magic) {
>  	case cpu_to_be32(XFS_ABTB_CRC_MAGIC):
> -		if (!xfs_btree_sblock_v5hdr_verify(bp))
> -			return false;
> +		if ((fa = xfs_btree_sblock_v5hdr_verify(bp)))
> +			return fa;

I see a few of these.

		fa = xfs_btree_sblock_v5hdr_verify(bp);
		if (fa)
			return fa;

> @@ -4609,7 +4609,7 @@ xfs_btree_sblock_v5hdr_verify(
>   * @bp: buffer containing the btree block
>   * @max_recs: maximum records allowed in this btree node
>   */
> -bool
> +xfs_failaddr_t
>  xfs_btree_sblock_verify(
>  	struct xfs_buf		*bp,
>  	unsigned int		max_recs)
> @@ -4619,19 +4619,19 @@ xfs_btree_sblock_verify(
>  
>  	/* numrecs verification */
>  	if (be16_to_cpu(block->bb_numrecs) > max_recs)
> -		return false;
> +		return __this_address;
>  
>  	/* sibling pointer verification */
>  	if (!block->bb_u.s.bb_leftsib ||
>  	    (be32_to_cpu(block->bb_u.s.bb_leftsib) >= mp->m_sb.sb_agblocks &&
>  	     block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK)))
> -		return false;
> +		return __this_address;
>  	if (!block->bb_u.s.bb_rightsib ||
>  	    (be32_to_cpu(block->bb_u.s.bb_rightsib) >= mp->m_sb.sb_agblocks &&
>  	     block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK)))
> -		return false;
> +		return __this_address;

Out if scope for this patch, but like th e lblock verifying, I think
these are candidates for xfs_verify_agbno()?

> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 27297a6..87565b6 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -73,13 +73,13 @@ xfs_dir3_leaf1_check(
>  	} else if (leafhdr.magic != XFS_DIR2_LEAF1_MAGIC)
>  		return false;
>  
> -	return xfs_dir3_leaf_check_int(dp->i_mount, dp, &leafhdr, leaf);
> +	return xfs_dir3_leaf_check_int(dp->i_mount, dp, &leafhdr, leaf) == NULL;
>  }

Hmmmm - shouldn't we make xfs_dir3_leaf_check() dump the failaddr
so we know what debug check failed? This would improve the debug
failure reporting in this code, and seeing as we now have the info it
doesn't really make sense to throw it away without reporting it...

> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 682e2bf..00ded0a 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -76,13 +76,13 @@ xfs_dir3_leafn_check(
>  	} else if (leafhdr.magic != XFS_DIR2_LEAFN_MAGIC)
>  		return false;
>  
> -	return xfs_dir3_leaf_check_int(dp->i_mount, dp, &leafhdr, leaf);
> +	return xfs_dir3_leaf_check_int(dp->i_mount, dp, &leafhdr, leaf) == NULL;
>  }
>  #else
>  #define	xfs_dir3_leaf_check(dp, bp)
>  #endif

Same here.

> @@ -93,21 +93,21 @@ xfs_dir3_free_verify(
>  		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
>  
>  		if (hdr3->magic != cpu_to_be32(XFS_DIR3_FREE_MAGIC))
> -			return false;
> +			return __this_address;
>  		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
> -			return false;
> +			return __this_address;
>  		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
> -			return false;
> +			return __this_address;
>  		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
> -			return false;
> +			return __this_address;
>  	} else {
>  		if (hdr->magic != cpu_to_be32(XFS_DIR2_FREE_MAGIC))
> -			return false;
> +			return __this_address;
>  	}

/me wonders if there is opportunity for factoring this header check
seeing as it's repeated a few times, just with different magic
numbers...

> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 45c68d0..c441efb 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -41,7 +41,7 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
>  #ifdef DEBUG
>  #define	xfs_dir3_data_check(dp, bp) \
>  do { \
> -	if (!__xfs_dir3_data_check((dp), (bp))) { \
> +	if (__xfs_dir3_data_check((dp), (bp))) { \
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, \
>  				(bp)->b_target->bt_mount, (bp)->b_addr); \
>  	} \

This should capture the failaddr and dump it as part of the
corruption error, I think. Otherwise we lose what part of the
structure was considered corrupt from the error report.

> @@ -507,7 +507,7 @@ xfs_iread(
>  		return error;
>  
>  	/* even unallocated inodes are verified */
> -	if (!xfs_dinode_verify(mp, ip->i_ino, dip)) {
> +	if (xfs_dinode_verify(mp, ip->i_ino, dip)) {
>  		xfs_alert(mp, "%s: validation failed for inode %lld",
>  				__func__, ip->i_ino);

Capture the failaddr in the error message?

> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index a9c97a3..2317511 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -82,7 +82,7 @@ void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
>  #define	xfs_inobp_check(mp, bp)
>  #endif /* DEBUG */
>  
> -bool	xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
> -			  struct xfs_dinode *dip);
> +void	*xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
> +			   struct xfs_dinode *dip);

xfs_failaddr_t?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
