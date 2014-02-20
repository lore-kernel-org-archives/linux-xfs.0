Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9E5127FC0
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 07:10:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 061D1AC003
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 05:10:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5j894nA9rZqtB8re for
	<xfs@oss.sgi.com>; Thu, 20 Feb 2014 05:10:15 -0800 (PST)
Message-ID: <5305FEAA.702@redhat.com>
Date: Thu, 20 Feb 2014 08:10:02 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 9/9 V2] xfs: modify verifiers to differentiate CRC from
	other errors
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>	<1392767549-25574-10-git-send-email-sandeen@redhat.com>
	<53057208.3010308@sandeen.net>
In-Reply-To: <53057208.3010308@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On 02/19/2014 10:10 PM, Eric Sandeen wrote:
> Modify all read & write verifiers to differentiate
> between CRC errors and other inconsistencies.
> 
> This sets the appropriate error number on bp->b_error,
> and then calls xfs_verifier_error() if something went
> wrong.  That function will issue the appropriate message
> to the user.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 

Looks good to me, thanks Eric.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> V2: Fix inexplicably lost XFS_*_CRC_OFF macros, and
> rework xfs_agi_read_verify() to be similar to other
> verifiers, per Brian's review
> 
> diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
> index 9c7cf3d..c1cf6a3 100644
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -474,7 +474,6 @@ xfs_agfl_read_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> -	int		agfl_ok = 1;
>  
>  	/*
>  	 * There is no verification of non-crc AGFLs because mkfs does not
> @@ -485,14 +484,13 @@ xfs_agfl_read_verify(
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
>  		return;
>  
> -	agfl_ok = xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF);
> -
> -	agfl_ok = agfl_ok && xfs_agfl_verify(bp);
> -
> -	if (!agfl_ok) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF))
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (!xfs_agfl_verify(bp))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> -	}
> +
> +	if (bp->b_error)
> +		xfs_verifier_error(bp);
>  }
>  
>  static void
> @@ -507,8 +505,8 @@ xfs_agfl_write_verify(
>  		return;
>  
>  	if (!xfs_agfl_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  
> @@ -2236,18 +2234,17 @@ xfs_agf_read_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> -	int		agf_ok = 1;
> -
> -	if (xfs_sb_version_hascrc(&mp->m_sb))
> -		agf_ok = xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF);
>  
> -	agf_ok = agf_ok && xfs_agf_verify(mp, bp);
> -
> -	if (unlikely(XFS_TEST_ERROR(!agf_ok, mp, XFS_ERRTAG_ALLOC_READ_AGF,
> -			XFS_RANDOM_ALLOC_READ_AGF))) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> +	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (XFS_TEST_ERROR(!xfs_agf_verify(mp, bp), mp,
> +				XFS_ERRTAG_ALLOC_READ_AGF,
> +				XFS_RANDOM_ALLOC_READ_AGF))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> -	}
> +
> +	if (bp->b_error)
> +		xfs_verifier_error(bp);
>  }
>  
>  static void
> @@ -2258,8 +2255,8 @@ xfs_agf_write_verify(
>  	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  
>  	if (!xfs_agf_verify(mp, bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
> index 144d3b0..cc1eadc 100644
> --- a/fs/xfs/xfs_alloc_btree.c
> +++ b/fs/xfs/xfs_alloc_btree.c
> @@ -355,12 +355,14 @@ static void
>  xfs_allocbt_read_verify(
>  	struct xfs_buf	*bp)
>  {
> -	if (!(xfs_btree_sblock_verify_crc(bp) &&
> -	      xfs_allocbt_verify(bp))) {
> -		trace_xfs_btree_corrupt(bp, _RET_IP_);
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> -				     bp->b_target->bt_mount, bp->b_addr);
> +	if (!xfs_btree_sblock_verify_crc(bp))
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (!xfs_allocbt_verify(bp))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +
> +	if (bp->b_error) {
> +		trace_xfs_btree_corrupt(bp, _RET_IP_);
> +		xfs_verifier_error(bp);
>  	}
>  }
>  
> @@ -370,9 +372,8 @@ xfs_allocbt_write_verify(
>  {
>  	if (!xfs_allocbt_verify(bp)) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> -				     bp->b_target->bt_mount, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  	xfs_btree_sblock_calc_crc(bp);
> diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
> index b552378..fe9587f 100644
> --- a/fs/xfs/xfs_attr_leaf.c
> +++ b/fs/xfs/xfs_attr_leaf.c
> @@ -213,8 +213,8 @@ xfs_attr3_leaf_write_verify(
>  	struct xfs_attr3_leaf_hdr *hdr3 = bp->b_addr;
>  
>  	if (!xfs_attr3_leaf_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  
> @@ -239,12 +239,14 @@ xfs_attr3_leaf_read_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  
> -	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
> -	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF)) ||
> -	    !xfs_attr3_leaf_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> +	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF))
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (!xfs_attr3_leaf_verify(bp))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> -	}
> +
> +	if (bp->b_error)
> +		xfs_verifier_error(bp);
>  }
>  
>  const struct xfs_buf_ops xfs_attr3_leaf_buf_ops = {
> diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
> index 5549d69..6e37823 100644
> --- a/fs/xfs/xfs_attr_remote.c
> +++ b/fs/xfs/xfs_attr_remote.c
> @@ -125,7 +125,6 @@ xfs_attr3_rmt_read_verify(
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
>  	char		*ptr;
>  	int		len;
> -	bool		corrupt = false;
>  	xfs_daddr_t	bno;
>  
>  	/* no verification of non-crc buffers */
> @@ -140,11 +139,11 @@ xfs_attr3_rmt_read_verify(
>  	while (len > 0) {
>  		if (!xfs_verify_cksum(ptr, XFS_LBSIZE(mp),
>  				      XFS_ATTR3_RMT_CRC_OFF)) {
> -			corrupt = true;
> +			xfs_buf_ioerror(bp, EFSBADCRC);
>  			break;
>  		}
>  		if (!xfs_attr3_rmt_verify(mp, ptr, XFS_LBSIZE(mp), bno)) {
> -			corrupt = true;
> +			xfs_buf_ioerror(bp, EFSCORRUPTED);
>  			break;
>  		}
>  		len -= XFS_LBSIZE(mp);
> @@ -152,10 +151,9 @@ xfs_attr3_rmt_read_verify(
>  		bno += mp->m_bsize;
>  	}
>  
> -	if (corrupt) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> -		xfs_buf_ioerror(bp, EFSCORRUPTED);
> -	} else
> +	if (bp->b_error)
> +		xfs_verifier_error(bp);
> +	else
>  		ASSERT(len == 0);
>  }
>  
> @@ -180,9 +178,8 @@ xfs_attr3_rmt_write_verify(
>  
>  	while (len > 0) {
>  		if (!xfs_attr3_rmt_verify(mp, ptr, XFS_LBSIZE(mp), bno)) {
> -			XFS_CORRUPTION_ERROR(__func__,
> -					    XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>  			xfs_buf_ioerror(bp, EFSCORRUPTED);
> +			xfs_verifier_error(bp);
>  			return;
>  		}
>  		if (bip) {
> diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
> index 706bc3f..818d546 100644
> --- a/fs/xfs/xfs_bmap_btree.c
> +++ b/fs/xfs/xfs_bmap_btree.c
> @@ -780,12 +780,14 @@ static void
>  xfs_bmbt_read_verify(
>  	struct xfs_buf	*bp)
>  {
> -	if (!(xfs_btree_lblock_verify_crc(bp) &&
> -	      xfs_bmbt_verify(bp))) {
> -		trace_xfs_btree_corrupt(bp, _RET_IP_);
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> -				     bp->b_target->bt_mount, bp->b_addr);
> +	if (!xfs_btree_lblock_verify_crc(bp))
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (!xfs_bmbt_verify(bp))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +
> +	if (bp->b_error) {
> +		trace_xfs_btree_corrupt(bp, _RET_IP_);
> +		xfs_verifier_error(bp);
>  	}
>  }
>  
> @@ -794,11 +796,9 @@ xfs_bmbt_write_verify(
>  	struct xfs_buf	*bp)
>  {
>  	if (!xfs_bmbt_verify(bp)) {
> -		xfs_warn(bp->b_target->bt_mount, "bmbt daddr 0x%llx failed", bp->b_bn);
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> -				     bp->b_target->bt_mount, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  	xfs_btree_lblock_calc_crc(bp);
> diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
> index 75ef990..1f5af79 100644
> --- a/fs/xfs/xfs_da_btree.c
> +++ b/fs/xfs/xfs_da_btree.c
> @@ -185,8 +185,8 @@ xfs_da3_node_write_verify(
>  	struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
>  
>  	if (!xfs_da3_node_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  
> @@ -209,17 +209,20 @@ static void
>  xfs_da3_node_read_verify(
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	struct xfs_da_blkinfo	*info = bp->b_addr;
>  
>  	switch (be16_to_cpu(info->magic)) {
>  		case XFS_DA3_NODE_MAGIC:
> -			if (!xfs_buf_verify_cksum(bp, XFS_DA3_NODE_CRC_OFF))
> +			if (!xfs_buf_verify_cksum(bp, XFS_DA3_NODE_CRC_OFF)) {
> +				xfs_buf_ioerror(bp, EFSBADCRC);
>  				break;
> +			}
>  			/* fall through */
>  		case XFS_DA_NODE_MAGIC:
> -			if (!xfs_da3_node_verify(bp))
> +			if (!xfs_da3_node_verify(bp)) {
> +				xfs_buf_ioerror(bp, EFSCORRUPTED);
>  				break;
> +			}
>  			return;
>  		case XFS_ATTR_LEAF_MAGIC:
>  		case XFS_ATTR3_LEAF_MAGIC:
> @@ -236,8 +239,7 @@ xfs_da3_node_read_verify(
>  	}
>  
>  	/* corrupt block */
> -	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> -	xfs_buf_ioerror(bp, EFSCORRUPTED);
> +	xfs_verifier_error(bp);
>  }
>  
>  const struct xfs_buf_ops xfs_da3_node_buf_ops = {
> diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
> index 724377e..4f6a38c 100644
> --- a/fs/xfs/xfs_dir2_block.c
> +++ b/fs/xfs/xfs_dir2_block.c
> @@ -89,12 +89,14 @@ xfs_dir3_block_read_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  
> -	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
> -	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF)) ||
> -	    !xfs_dir3_block_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> +	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (!xfs_dir3_block_verify(bp))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> -	}
> +
> +	if (bp->b_error)
> +		xfs_verifier_error(bp);
>  }
>  
>  static void
> @@ -106,8 +108,8 @@ xfs_dir3_block_write_verify(
>  	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
>  
>  	if (!xfs_dir3_block_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
> index 74ae85e..afa4ad5 100644
> --- a/fs/xfs/xfs_dir2_data.c
> +++ b/fs/xfs/xfs_dir2_data.c
> @@ -241,7 +241,6 @@ static void
>  xfs_dir3_data_reada_verify(
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
>  
>  	switch (hdr->magic) {
> @@ -255,8 +254,8 @@ xfs_dir3_data_reada_verify(
>  		xfs_dir3_data_verify(bp);
>  		return;
>  	default:
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		break;
>  	}
>  }
> @@ -267,12 +266,14 @@ xfs_dir3_data_read_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  
> -	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
> -	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF)) ||
> -	    !xfs_dir3_data_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> +	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
> +		 xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (!xfs_dir3_data_verify(bp))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> -	}
> +
> +	if (bp->b_error)
> +		xfs_verifier_error(bp);
>  }
>  
>  static void
> @@ -284,8 +285,8 @@ xfs_dir3_data_write_verify(
>  	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
>  
>  	if (!xfs_dir3_data_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
> index dffb61b..d36e97d 100644
> --- a/fs/xfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/xfs_dir2_leaf.c
> @@ -179,12 +179,14 @@ __read_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  
> -	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
> -	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF)) ||
> -	    !xfs_dir3_leaf_verify(bp, magic)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> +	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF))
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (!xfs_dir3_leaf_verify(bp, magic))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> -	}
> +
> +	if (bp->b_error)
> +		xfs_verifier_error(bp);
>  }
>  
>  static void
> @@ -197,8 +199,8 @@ __write_verify(
>  	struct xfs_dir3_leaf_hdr *hdr3 = bp->b_addr;
>  
>  	if (!xfs_dir3_leaf_verify(bp, magic)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
> index 0904b20..cb434d7 100644
> --- a/fs/xfs/xfs_dir2_node.c
> +++ b/fs/xfs/xfs_dir2_node.c
> @@ -115,12 +115,14 @@ xfs_dir3_free_read_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  
> -	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
> -	     !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF)) ||
> -	    !xfs_dir3_free_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> +	    !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF))
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (!xfs_dir3_free_verify(bp))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> -	}
> +
> +	if (bp->b_error)
> +		xfs_verifier_error(bp);
>  }
>  
>  static void
> @@ -132,8 +134,8 @@ xfs_dir3_free_write_verify(
>  	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
>  
>  	if (!xfs_dir3_free_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/xfs_dquot_buf.c b/fs/xfs/xfs_dquot_buf.c
> index d401457..610da81 100644
> --- a/fs/xfs/xfs_dquot_buf.c
> +++ b/fs/xfs/xfs_dquot_buf.c
> @@ -257,10 +257,13 @@ xfs_dquot_buf_read_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  
> -	if (!xfs_dquot_buf_verify_crc(mp, bp) || !xfs_dquot_buf_verify(mp, bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +	if (!xfs_dquot_buf_verify_crc(mp, bp))
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (!xfs_dquot_buf_verify(mp, bp))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> -	}
> +
> +	if (bp->b_error)
> +		xfs_verifier_error(bp);
>  }
>  
>  /*
> @@ -275,8 +278,8 @@ xfs_dquot_buf_write_verify(
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  
>  	if (!xfs_dquot_buf_verify(mp, bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  }
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index 4657586..5959b3b 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -1568,18 +1568,17 @@ xfs_agi_read_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> -	int		agi_ok = 1;
>  
> -	if (xfs_sb_version_hascrc(&mp->m_sb))
> -		agi_ok = xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF);
> -
> -	agi_ok = agi_ok && xfs_agi_verify(bp);
> -
> -	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
> -			XFS_RANDOM_IALLOC_READ_AGI))) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> +	    !xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF))
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (XFS_TEST_ERROR(!xfs_agi_verify(bp), mp,
> +				XFS_ERRTAG_IALLOC_READ_AGI,
> +				XFS_RANDOM_IALLOC_READ_AGI))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> -	}
> +
> +	if (bp->b_error)
> +		xfs_verifier_error(bp);
>  }
>  
>  static void
> @@ -1590,8 +1589,8 @@ xfs_agi_write_verify(
>  	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  
>  	if (!xfs_agi_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
> index 0028c50..7e309b1 100644
> --- a/fs/xfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/xfs_ialloc_btree.c
> @@ -243,12 +243,14 @@ static void
>  xfs_inobt_read_verify(
>  	struct xfs_buf	*bp)
>  {
> -	if (!(xfs_btree_sblock_verify_crc(bp) &&
> -	      xfs_inobt_verify(bp))) {
> -		trace_xfs_btree_corrupt(bp, _RET_IP_);
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> -				     bp->b_target->bt_mount, bp->b_addr);
> +	if (!xfs_btree_sblock_verify_crc(bp))
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (!xfs_inobt_verify(bp))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +
> +	if (bp->b_error) {
> +		trace_xfs_btree_corrupt(bp, _RET_IP_);
> +		xfs_verifier_error(bp);
>  	}
>  }
>  
> @@ -258,9 +260,8 @@ xfs_inobt_write_verify(
>  {
>  	if (!xfs_inobt_verify(bp)) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> -				     bp->b_target->bt_mount, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  	xfs_btree_sblock_calc_crc(bp);
> diff --git a/fs/xfs/xfs_inode_buf.c b/fs/xfs/xfs_inode_buf.c
> index 606b43a..24e9939 100644
> --- a/fs/xfs/xfs_inode_buf.c
> +++ b/fs/xfs/xfs_inode_buf.c
> @@ -102,8 +102,7 @@ xfs_inode_buf_verify(
>  			}
>  
>  			xfs_buf_ioerror(bp, EFSCORRUPTED);
> -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_HIGH,
> -					     mp, dip);
> +			xfs_verifier_error(bp);
>  #ifdef DEBUG
>  			xfs_alert(mp,
>  				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
> diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
> index 818359f..b134aa8 100644
> --- a/fs/xfs/xfs_sb.c
> +++ b/fs/xfs/xfs_sb.c
> @@ -614,7 +614,7 @@ xfs_sb_read_verify(
>  			/* Only fail bad secondaries on a known V5 filesystem */
>  			if (bp->b_bn == XFS_SB_DADDR ||
>  			    xfs_sb_version_hascrc(&mp->m_sb)) {
> -				error = EFSCORRUPTED;
> +				error = EFSBADCRC;
>  				goto out_error;
>  			}
>  		}
> @@ -623,10 +623,9 @@ xfs_sb_read_verify(
>  
>  out_error:
>  	if (error) {
> -		if (error == EFSCORRUPTED)
> -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> -					     mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, error);
> +		if (error == EFSCORRUPTED || error == EFSBADCRC)
> +			xfs_verifier_error(bp);
>  	}
>  }
>  
> @@ -661,9 +660,8 @@ xfs_sb_write_verify(
>  
>  	error = xfs_sb_verify(bp, false);
>  	if (error) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
> -				     mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, error);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/xfs_symlink_remote.c b/fs/xfs/xfs_symlink_remote.c
> index defa09f..9b32052 100644
> --- a/fs/xfs/xfs_symlink_remote.c
> +++ b/fs/xfs/xfs_symlink_remote.c
> @@ -133,11 +133,13 @@ xfs_symlink_read_verify(
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
>  		return;
>  
> -	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF) ||
> -	    !xfs_symlink_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF))
> +		xfs_buf_ioerror(bp, EFSBADCRC);
> +	else if (!xfs_symlink_verify(bp))
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> -	}
> +
> +	if (bp->b_error)
> +		xfs_verifier_error(bp);
>  }
>  
>  static void
> @@ -152,8 +154,8 @@ xfs_symlink_write_verify(
>  		return;
>  
>  	if (!xfs_symlink_verify(bp)) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		xfs_verifier_error(bp);
>  		return;
>  	}
>  
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
