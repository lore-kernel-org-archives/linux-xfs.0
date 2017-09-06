Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39530 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754245AbdIFQni (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 12:43:38 -0400
Date: Wed, 6 Sep 2017 12:43:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/12] xfs: refactor verifier callers to print address of
 failing check
Message-ID: <20170906164336.GD55280@bfoster.bfoster>
References: <150394418979.24826.12970283067445908653.stgit@magnolia>
 <150394421513.24826.6202549158827016893.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150394421513.24826.6202549158827016893.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 28, 2017 at 11:16:55AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the callers of verifiers to print the instruction address of a
> failing check.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c          |   20 ++++++++++++--------
>  fs/xfs/libxfs/xfs_alloc_btree.c    |   12 ++++++++----
>  fs/xfs/libxfs/xfs_attr_leaf.c      |   10 ++++++----
>  fs/xfs/libxfs/xfs_attr_remote.c    |   12 +++++++-----
>  fs/xfs/libxfs/xfs_bmap_btree.c     |   12 ++++++++----
>  fs/xfs/libxfs/xfs_da_btree.c       |   11 +++++++----
>  fs/xfs/libxfs/xfs_dir2_block.c     |   10 ++++++----
>  fs/xfs/libxfs/xfs_dir2_data.c      |   12 +++++++-----
>  fs/xfs/libxfs/xfs_dir2_leaf.c      |   10 ++++++----
>  fs/xfs/libxfs/xfs_dir2_node.c      |   17 ++++++++++-------
>  fs/xfs/libxfs/xfs_dquot_buf.c      |    4 ++--
>  fs/xfs/libxfs/xfs_ialloc.c         |   10 ++++++----
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |   12 ++++++++----
>  fs/xfs/libxfs/xfs_inode_buf.c      |   24 +++++++++++++-----------
>  fs/xfs/libxfs/xfs_refcount_btree.c |   12 ++++++++----
>  fs/xfs/libxfs/xfs_rmap_btree.c     |   12 ++++++++----
>  fs/xfs/libxfs/xfs_sb.c             |    4 ++--
>  fs/xfs/libxfs/xfs_symlink_remote.c |   10 ++++++----
>  fs/xfs/xfs_error.c                 |    6 ++++--
>  fs/xfs/xfs_error.h                 |    2 +-
>  20 files changed, 135 insertions(+), 87 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 986456b..d49b1e3 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -556,6 +556,7 @@ xfs_agfl_read_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> +	void		*failed_at = __this_address;
>  

A non-NULL init strikes me as a little strange. Why not set it at the
point where a checksum fails, if that's the intent?

Brian

>  	/*
>  	 * There is no verification of non-crc AGFLs because mkfs does not
> @@ -568,11 +569,11 @@ xfs_agfl_read_verify(
>  
>  	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF))
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (xfs_agfl_verify(bp))
> +	else if ((failed_at = xfs_agfl_verify(bp)))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error)
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  }
>  
>  static void
> @@ -581,14 +582,15 @@ xfs_agfl_write_verify(
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> +	void			*failed_at;
>  
>  	/* no verification of non-crc AGFLs */
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
>  		return;
>  
> -	if (xfs_agfl_verify(bp)) {
> +	if ((failed_at = xfs_agfl_verify(bp))) {
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  		return;
>  	}
>  
> @@ -2450,16 +2452,17 @@ xfs_agf_read_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> +	void		*failed_at = __this_address;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (XFS_TEST_ERROR(xfs_agf_verify(mp, bp), mp,
> +	else if (XFS_TEST_ERROR((failed_at = xfs_agf_verify(mp, bp)), mp,
>  				XFS_ERRTAG_ALLOC_READ_AGF))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error)
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  }
>  
>  static void
> @@ -2468,10 +2471,11 @@ xfs_agf_write_verify(
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> +	void			*failed_at;
>  
> -	if (xfs_agf_verify(mp, bp)) {
> +	if ((failed_at = xfs_agf_verify(mp, bp))) {
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 81e3bbc..8d4c004 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -364,14 +364,16 @@ static void
>  xfs_allocbt_read_verify(
>  	struct xfs_buf	*bp)
>  {
> +	void		*failed_at = __this_address;
> +
>  	if (!xfs_btree_sblock_verify_crc(bp))
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (xfs_allocbt_verify(bp))
> +	else if ((failed_at = xfs_allocbt_verify(bp)))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  	}
>  }
>  
> @@ -379,10 +381,12 @@ static void
>  xfs_allocbt_write_verify(
>  	struct xfs_buf	*bp)
>  {
> -	if (xfs_allocbt_verify(bp)) {
> +	void		*failed_at;
> +
> +	if ((failed_at = xfs_allocbt_verify(bp))) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  		return;
>  	}
>  	xfs_btree_sblock_calc_crc(bp);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 0a7cd48..16bc966 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -295,10 +295,11 @@ xfs_attr3_leaf_write_verify(
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  	struct xfs_attr3_leaf_hdr *hdr3 = bp->b_addr;
> +	void			*failed_at;
>  
> -	if (xfs_attr3_leaf_verify(bp)) {
> +	if ((failed_at = xfs_attr3_leaf_verify(bp))) {
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  		return;
>  	}
>  
> @@ -322,15 +323,16 @@ xfs_attr3_leaf_read_verify(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +	void			*failed_at = __this_address;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF))
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (xfs_attr3_leaf_verify(bp))
> +	else if ((failed_at = xfs_attr3_leaf_verify(bp)))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error)
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  }
>  
>  const struct xfs_buf_ops xfs_attr3_leaf_buf_ops = {
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 20d56bf..d33a4d3 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -122,6 +122,7 @@ xfs_attr3_rmt_read_verify(
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
>  	char		*ptr;
> +	void		*failed_at = __this_address;
>  	int		len;
>  	xfs_daddr_t	bno;
>  	int		blksize = mp->m_attr_geo->blksize;
> @@ -140,7 +141,7 @@ xfs_attr3_rmt_read_verify(
>  			xfs_buf_ioerror(bp, -EFSBADCRC);
>  			break;
>  		}
> -		if (xfs_attr3_rmt_verify(mp, ptr, blksize, bno)) {
> +		if ((failed_at = xfs_attr3_rmt_verify(mp, ptr, blksize, bno))) {
>  			xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  			break;
>  		}
> @@ -150,7 +151,7 @@ xfs_attr3_rmt_read_verify(
>  	}
>  
>  	if (bp->b_error)
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  	else
>  		ASSERT(len == 0);
>  }
> @@ -160,6 +161,7 @@ xfs_attr3_rmt_write_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> +	void		*failed_at;
>  	int		blksize = mp->m_attr_geo->blksize;
>  	char		*ptr;
>  	int		len;
> @@ -177,9 +179,9 @@ xfs_attr3_rmt_write_verify(
>  	while (len > 0) {
>  		struct xfs_attr3_rmt_hdr *rmt = (struct xfs_attr3_rmt_hdr *)ptr;
>  
> -		if (xfs_attr3_rmt_verify(mp, ptr, blksize, bno)) {
> +		if ((failed_at = xfs_attr3_rmt_verify(mp, ptr, blksize, bno))) {
>  			xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -			xfs_verifier_error(bp);
> +			xfs_verifier_error(bp, failed_at);
>  			return;
>  		}
>  
> @@ -189,7 +191,7 @@ xfs_attr3_rmt_write_verify(
>  		 */
>  		if (rmt->rm_lsn != cpu_to_be64(NULLCOMMITLSN)) {
>  			xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -			xfs_verifier_error(bp);
> +			xfs_verifier_error(bp, __this_address);
>  			return;
>  		}
>  		xfs_update_cksum(ptr, blksize, XFS_ATTR3_RMT_CRC_OFF);
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 875e4fe..d613080 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -660,14 +660,16 @@ static void
>  xfs_bmbt_read_verify(
>  	struct xfs_buf	*bp)
>  {
> +	void		*failed_at = __this_address;
> +
>  	if (!xfs_btree_lblock_verify_crc(bp))
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (xfs_bmbt_verify(bp))
> +	else if ((failed_at = xfs_bmbt_verify(bp)))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  	}
>  }
>  
> @@ -675,10 +677,12 @@ static void
>  xfs_bmbt_write_verify(
>  	struct xfs_buf	*bp)
>  {
> -	if (xfs_bmbt_verify(bp)) {
> +	void		*failed_at;
> +
> +	if ((failed_at = xfs_bmbt_verify(bp))) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  		return;
>  	}
>  	xfs_btree_lblock_calc_crc(bp);
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 2ce0fee..f3544fb 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -184,10 +184,11 @@ xfs_da3_node_write_verify(
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  	struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
> +	void			*failed_at;
>  
> -	if (xfs_da3_node_verify(bp)) {
> +	if ((failed_at = xfs_da3_node_verify(bp))) {
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  		return;
>  	}
>  
> @@ -211,6 +212,7 @@ xfs_da3_node_read_verify(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_da_blkinfo	*info = bp->b_addr;
> +	void			*failed_at = __this_address;
>  
>  	switch (be16_to_cpu(info->magic)) {
>  		case XFS_DA3_NODE_MAGIC:
> @@ -220,7 +222,7 @@ xfs_da3_node_read_verify(
>  			}
>  			/* fall through */
>  		case XFS_DA_NODE_MAGIC:
> -			if (xfs_da3_node_verify(bp)) {
> +			if ((failed_at = xfs_da3_node_verify(bp))) {
>  				xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  				break;
>  			}
> @@ -236,12 +238,13 @@ xfs_da3_node_read_verify(
>  			bp->b_ops->verify_read(bp);
>  			return;
>  		default:
> +			failed_at = __this_address;
>  			xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  			break;
>  	}
>  
>  	/* corrupt block */
> -	xfs_verifier_error(bp);
> +	xfs_verifier_error(bp, failed_at);
>  }
>  
>  const struct xfs_buf_ops xfs_da3_node_buf_ops = {
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 480a180..6c54d03 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -86,15 +86,16 @@ xfs_dir3_block_read_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +	void			*failed_at = __this_address;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (xfs_dir3_block_verify(bp))
> +	else if ((failed_at = xfs_dir3_block_verify(bp)))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error)
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  }
>  
>  static void
> @@ -104,10 +105,11 @@ xfs_dir3_block_write_verify(
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
> +	void			*failed_at;
>  
> -	if (xfs_dir3_block_verify(bp)) {
> +	if ((failed_at = xfs_dir3_block_verify(bp))) {
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index b2375bf..5e27b71 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -268,7 +268,7 @@ xfs_dir3_data_reada_verify(
>  		return;
>  	default:
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, __this_address);
>  		break;
>  	}
>  }
> @@ -278,15 +278,16 @@ xfs_dir3_data_read_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +	void			*failed_at = __this_address;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
>  		 xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (xfs_dir3_data_verify(bp))
> +	else if ((failed_at = xfs_dir3_data_verify(bp)))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error)
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  }
>  
>  static void
> @@ -296,10 +297,11 @@ xfs_dir3_data_write_verify(
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
> +	void			*failed_at;
>  
> -	if (xfs_dir3_data_verify(bp)) {
> +	if ((failed_at = xfs_dir3_data_verify(bp))) {
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 6eb7939..00dcfef 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -181,15 +181,16 @@ __read_verify(
>  	uint16_t	magic)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +	void			*failed_at = __this_address;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF))
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (xfs_dir3_leaf_verify(bp, magic))
> +	else if ((failed_at = xfs_dir3_leaf_verify(bp, magic)))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error)
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  }
>  
>  static void
> @@ -200,10 +201,11 @@ __write_verify(
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  	struct xfs_dir3_leaf_hdr *hdr3 = bp->b_addr;
> +	void			*failed_at;
>  
> -	if (xfs_dir3_leaf_verify(bp, magic)) {
> +	if ((failed_at = xfs_dir3_leaf_verify(bp, magic))) {
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index b596b5f..a11585b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -115,15 +115,16 @@ xfs_dir3_free_read_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +	void			*failed_at = __this_address;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	    !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF))
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (xfs_dir3_free_verify(bp))
> +	else if ((failed_at = xfs_dir3_free_verify(bp)))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error)
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  }
>  
>  static void
> @@ -133,10 +134,11 @@ xfs_dir3_free_write_verify(
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
> +	void			*failed_at;
>  
> -	if (xfs_dir3_free_verify(bp)) {
> +	if ((failed_at = xfs_dir3_free_verify(bp))) {
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  		return;
>  	}
>  
> @@ -156,7 +158,7 @@ const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
>  };
>  
>  /* Everything ok in the free block header? */
> -static bool
> +static void *
>  xfs_dir3_free_header_check(
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		fbno,
> @@ -200,6 +202,7 @@ __xfs_dir3_free_read(
>  	xfs_daddr_t		mappedbno,
>  	struct xfs_buf		**bpp)
>  {
> +	void			*failed_at;
>  	int			err;
>  
>  	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
> @@ -208,9 +211,9 @@ __xfs_dir3_free_read(
>  		return err;
>  
>  	/* Check things that we can't do in the verifier. */
> -	if (xfs_dir3_free_header_check(dp, fbno, *bpp)) {
> +	if ((failed_at = xfs_dir3_free_header_check(dp, fbno, *bpp))) {
>  		xfs_buf_ioerror(*bpp, -EFSCORRUPTED);
> -		xfs_verifier_error(*bpp);
> +		xfs_verifier_error(*bpp, failed_at);
>  		xfs_trans_brelse(tp, *bpp);
>  		return -EFSCORRUPTED;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 747085b..5561011 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -254,7 +254,7 @@ xfs_dquot_buf_read_verify(
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error)
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, __this_address);
>  }
>  
>  /*
> @@ -289,7 +289,7 @@ xfs_dquot_buf_write_verify(
>  
>  	if (!xfs_dquot_buf_verify(mp, bp, XFS_QMOPT_DOWARN)) {
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, __this_address);
>  		return;
>  	}
>  }
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 0f374ad..c63b708 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2547,16 +2547,17 @@ xfs_agi_read_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> +	void		*failed_at = __this_address;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	    !xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF))
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (XFS_TEST_ERROR(xfs_agi_verify(bp), mp,
> +	else if (XFS_TEST_ERROR((failed_at = xfs_agi_verify(bp)), mp,
>  				XFS_ERRTAG_IALLOC_READ_AGI))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error)
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  }
>  
>  static void
> @@ -2565,10 +2566,11 @@ xfs_agi_write_verify(
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> +	void			*failed_at;
>  
> -	if (xfs_agi_verify(bp)) {
> +	if ((failed_at = xfs_agi_verify(bp))) {
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 89e928c..38d6a50 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -294,14 +294,16 @@ static void
>  xfs_inobt_read_verify(
>  	struct xfs_buf	*bp)
>  {
> +	void		*failed_at = __this_address;
> +
>  	if (!xfs_btree_sblock_verify_crc(bp))
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (xfs_inobt_verify(bp))
> +	else if ((failed_at = xfs_inobt_verify(bp)))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  	}
>  }
>  
> @@ -309,10 +311,12 @@ static void
>  xfs_inobt_write_verify(
>  	struct xfs_buf	*bp)
>  {
> -	if (xfs_inobt_verify(bp)) {
> +	void		*failed_at;
> +
> +	if ((failed_at = xfs_inobt_verify(bp))) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  		return;
>  	}
>  	xfs_btree_sblock_calc_crc(bp);
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 02700428..a5bcf2b 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -113,7 +113,7 @@ xfs_inode_buf_verify(
>  			}
>  
>  			xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -			xfs_verifier_error(bp);
> +			xfs_verifier_error(bp, __this_address);
>  #ifdef DEBUG
>  			xfs_alert(mp,
>  				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
> @@ -468,14 +468,15 @@ xfs_dinode_calc_crc(
>   */
>  int
>  xfs_iread(
> -	xfs_mount_t	*mp,
> -	xfs_trans_t	*tp,
> -	xfs_inode_t	*ip,
> -	uint		iget_flags)
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	uint			iget_flags)
>  {
> -	xfs_buf_t	*bp;
> -	xfs_dinode_t	*dip;
> -	int		error;
> +	struct xfs_buf		*bp;
> +	struct xfs_dinode	*dip;
> +	void			*failed_at;
> +	int			error;
>  
>  	/*
>  	 * Fill in the location information in the in-core inode.
> @@ -506,9 +507,10 @@ xfs_iread(
>  		return error;
>  
>  	/* even unallocated inodes are verified */
> -	if (xfs_dinode_verify(mp, ip->i_ino, dip)) {
> -		xfs_alert(mp, "%s: validation failed for inode %lld",
> -				__func__, ip->i_ino);
> +	failed_at = xfs_dinode_verify(mp, ip->i_ino, dip);
> +	if (failed_at) {
> +		xfs_alert(mp, "%s: validation failed for inode %lld at %pF",
> +				__func__, ip->i_ino, failed_at);
>  
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, dip);
>  		error = -EFSCORRUPTED;
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 48f651a..8d6c0fc 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -255,14 +255,16 @@ STATIC void
>  xfs_refcountbt_read_verify(
>  	struct xfs_buf	*bp)
>  {
> +	void		*failed_at = __this_address;
> +
>  	if (!xfs_btree_sblock_verify_crc(bp))
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (xfs_refcountbt_verify(bp))
> +	else if ((failed_at = xfs_refcountbt_verify(bp)))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  	}
>  }
>  
> @@ -270,10 +272,12 @@ STATIC void
>  xfs_refcountbt_write_verify(
>  	struct xfs_buf	*bp)
>  {
> -	if (xfs_refcountbt_verify(bp)) {
> +	void		*failed_at;
> +
> +	if ((failed_at = xfs_refcountbt_verify(bp))) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  		return;
>  	}
>  	xfs_btree_sblock_calc_crc(bp);
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index 77e23c9..4fd77e7 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -347,14 +347,16 @@ static void
>  xfs_rmapbt_read_verify(
>  	struct xfs_buf	*bp)
>  {
> +	void		*failed_at = __this_address;
> +
>  	if (!xfs_btree_sblock_verify_crc(bp))
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (xfs_rmapbt_verify(bp))
> +	else if ((failed_at = xfs_rmapbt_verify(bp)))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  	}
>  }
>  
> @@ -362,10 +364,12 @@ static void
>  xfs_rmapbt_write_verify(
>  	struct xfs_buf	*bp)
>  {
> -	if (xfs_rmapbt_verify(bp)) {
> +	void		*failed_at;
> +
> +	if ((failed_at = xfs_rmapbt_verify(bp))) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  		return;
>  	}
>  	xfs_btree_sblock_calc_crc(bp);
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 9b5aae2..9b49640 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -643,7 +643,7 @@ xfs_sb_read_verify(
>  	if (error) {
>  		xfs_buf_ioerror(bp, error);
>  		if (error == -EFSCORRUPTED || error == -EFSBADCRC)
> -			xfs_verifier_error(bp);
> +			xfs_verifier_error(bp, __this_address);
>  	}
>  }
>  
> @@ -679,7 +679,7 @@ xfs_sb_write_verify(
>  	error = xfs_sb_verify(bp, false);
>  	if (error) {
>  		xfs_buf_ioerror(bp, error);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, __this_address);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
> index b53a4c9..1ac8c4d 100644
> --- a/fs/xfs/libxfs/xfs_symlink_remote.c
> +++ b/fs/xfs/libxfs/xfs_symlink_remote.c
> @@ -129,6 +129,7 @@ xfs_symlink_read_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> +	void		*failed_at = __this_address;
>  
>  	/* no verification of non-crc buffers */
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
> @@ -136,11 +137,11 @@ xfs_symlink_read_verify(
>  
>  	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF))
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (xfs_symlink_verify(bp))
> +	else if ((failed_at = xfs_symlink_verify(bp)))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error)
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  }
>  
>  static void
> @@ -149,14 +150,15 @@ xfs_symlink_write_verify(
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> +	void			*failed_at;
>  
>  	/* no verification of non-crc buffers */
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
>  		return;
>  
> -	if (xfs_symlink_verify(bp)) {
> +	if ((failed_at = xfs_symlink_verify(bp))) {
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, failed_at);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 782bc00..1022e98 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -345,7 +345,8 @@ xfs_corruption_error(
>   */
>  void
>  xfs_verifier_error(
> -	struct xfs_buf		*bp)
> +	struct xfs_buf		*bp,
> +	void			*failed_at)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
>  
> @@ -354,7 +355,8 @@ xfs_verifier_error(
>  
>  	xfs_alert(mp, "Metadata %s detected at %pF, %s block 0x%llx",
>  		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
> -		  __return_address, bp->b_ops->name, bp->b_bn);
> +		  failed_at ? failed_at : __return_address, bp->b_ops->name,
> +		  bp->b_bn);
>  
>  	xfs_alert(mp, "Unmount and run xfs_repair");
>  
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index 6ee23eb..c204b8a 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -25,7 +25,7 @@ extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
>  extern void xfs_corruption_error(const char *tag, int level,
>  			struct xfs_mount *mp, void *p, const char *filename,
>  			int linenum, void *ra);
> -extern void xfs_verifier_error(struct xfs_buf *bp);
> +extern void xfs_verifier_error(struct xfs_buf *bp, void *failed_at);
>  
>  #define	XFS_ERROR_REPORT(e, lvl, mp)	\
>  	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
