Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37818 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfBFSPf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Feb 2019 13:15:35 -0500
Date: Wed, 6 Feb 2019 10:15:23 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 6/9] xfs: distinguish between bnobt and cntbt magic
 values
Message-ID: <20190206181523.GU7991@magnolia>
References: <20190204145231.47034-1-bfoster@redhat.com>
 <20190204145231.47034-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204145231.47034-7-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 09:52:28AM -0500, Brian Foster wrote:
> The allocation btree verifiers share code that is unable to detect
> cross-tree magic value corruptions such as a bnobt block with a
> cntbt magic value. Populate the b_ops->magic field of the associated
> verifier structures such that the structure verifier can check the
> magic value against the expected value based on tree type.
> 
> The btree level check requires knowledge of the tree type to
> determine the appropriate maximum value. This was previously part of
> the hardcoded magic value checks. With that code removed, peek at
> the first magic value in the verifier to determine the expected tree
> type of the current block.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc_btree.c | 60 ++++++++++++++-------------------
>  1 file changed, 25 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 480d0f52da64..9fe949f6055e 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -297,48 +297,34 @@ xfs_allocbt_verify(
>  	struct xfs_perag	*pag = bp->b_pag;
>  	xfs_failaddr_t		fa;
>  	unsigned int		level;
> +	xfs_btnum_t		btnum = XFS_BTNUM_BNOi;
> +
> +	if (!xfs_verify_magic(bp, block->bb_magic))
> +		return __this_address;
> +
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		fa = xfs_btree_sblock_v5hdr_verify(bp);
> +		if (fa)
> +			return fa;
> +	}
>  
>  	/*
> -	 * magic number and level verification
> -	 *
> -	 * During growfs operations, we can't verify the exact level or owner as
> -	 * the perag is not fully initialised and hence not attached to the
> -	 * buffer.  In this case, check against the maximum tree depth.
> +	 * The perag may not be attached during grow operations or fully
> +	 * initialized from the AGF during log recovery. Therefore we can only
> +	 * check against maximum tree depth from those contexts.
>  	 *
> -	 * Similarly, during log recovery we will have a perag structure
> -	 * attached, but the agf information will not yet have been initialised
> -	 * from the on disk AGF. Again, we can only check against maximum limits
> -	 * in this case.
> +	 * Otherwise check against the per-tree limit. Peek at one of the
> +	 * verifier magic values to determine the type of tree we're verifying
> +	 * against.
>  	 */
>  	level = be16_to_cpu(block->bb_level);
> -	switch (block->bb_magic) {
> -	case cpu_to_be32(XFS_ABTB_CRC_MAGIC):
> -		fa = xfs_btree_sblock_v5hdr_verify(bp);
> -		if (fa)
> -			return fa;
> -		/* fall through */
> -	case cpu_to_be32(XFS_ABTB_MAGIC):
> -		if (pag && pag->pagf_init) {
> -			if (level >= pag->pagf_levels[XFS_BTNUM_BNOi])
> -				return __this_address;
> -		} else if (level >= mp->m_ag_maxlevels)
> +	if (bp->b_ops->magic[0] == cpu_to_be32(XFS_ABTC_MAGIC))
> +		btnum = XFS_BTNUM_CNTi;
> +	if (pag && pag->pagf_init) {
> +		if (level >= pag->pagf_levels[btnum])
>  			return __this_address;
> -		break;
> -	case cpu_to_be32(XFS_ABTC_CRC_MAGIC):
> -		fa = xfs_btree_sblock_v5hdr_verify(bp);
> -		if (fa)
> -			return fa;
> -		/* fall through */
> -	case cpu_to_be32(XFS_ABTC_MAGIC):
> -		if (pag && pag->pagf_init) {
> -			if (level >= pag->pagf_levels[XFS_BTNUM_CNTi])
> -				return __this_address;
> -		} else if (level >= mp->m_ag_maxlevels)
> -			return __this_address;
> -		break;
> -	default:
> +	} else if (level >= mp->m_ag_maxlevels)
>  		return __this_address;
> -	}
>  
>  	return xfs_btree_sblock_verify(bp, mp->m_alloc_mxr[level != 0]);
>  }
> @@ -379,6 +365,8 @@ xfs_allocbt_write_verify(
>  
>  const struct xfs_buf_ops xfs_bnobt_buf_ops = {
>  	.name = "xfs_bnobt",
> +	.magic = { cpu_to_be32(XFS_ABTB_MAGIC),
> +		   cpu_to_be32(XFS_ABTB_CRC_MAGIC) },
>  	.verify_read = xfs_allocbt_read_verify,
>  	.verify_write = xfs_allocbt_write_verify,
>  	.verify_struct = xfs_allocbt_verify,
> @@ -386,6 +374,8 @@ const struct xfs_buf_ops xfs_bnobt_buf_ops = {
>  
>  const struct xfs_buf_ops xfs_cntbt_buf_ops = {
>  	.name = "xfs_cntbt",
> +	.magic = { cpu_to_be32(XFS_ABTC_MAGIC),
> +		   cpu_to_be32(XFS_ABTC_CRC_MAGIC) },
>  	.verify_read = xfs_allocbt_read_verify,
>  	.verify_write = xfs_allocbt_write_verify,
>  	.verify_struct = xfs_allocbt_verify,
> -- 
> 2.17.2
> 
