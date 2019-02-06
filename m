Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54730 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfBFSPS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Feb 2019 13:15:18 -0500
Date: Wed, 6 Feb 2019 10:15:06 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 5/9] xfs: split up allocation btree verifier
Message-ID: <20190206181506.GT7991@magnolia>
References: <20190204145231.47034-1-bfoster@redhat.com>
 <20190204145231.47034-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204145231.47034-6-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 09:52:27AM -0500, Brian Foster wrote:
> Similar to the inode btree verifier, the same allocation btree
> verifier structure is shared between the by-bno (bnobt) and by-size
> (cntbt) btrees. This prevents the ability to distinguish magic
> values between them. Separate the verifier into two, one for each
> tree, and assign them appropriately. No functional changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c          |  4 ++--
>  fs/xfs/libxfs/xfs_alloc_btree.c | 14 ++++++++++----
>  fs/xfs/libxfs/xfs_shared.h      |  3 ++-
>  fs/xfs/scrub/agheader_repair.c  |  4 ++--
>  fs/xfs/xfs_log_recover.c        |  6 ++++--
>  5 files changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index bde67ef3ff43..1ef8acf35e7d 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -339,14 +339,14 @@ xfs_ag_init_headers(
>  	{ /* BNO root block */
>  		.daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_BNO_BLOCK(mp)),
>  		.numblks = BTOBB(mp->m_sb.sb_blocksize),
> -		.ops = &xfs_allocbt_buf_ops,
> +		.ops = &xfs_bnobt_buf_ops,
>  		.work = &xfs_bnoroot_init,
>  		.need_init = true
>  	},
>  	{ /* CNT root block */
>  		.daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_CNT_BLOCK(mp)),
>  		.numblks = BTOBB(mp->m_sb.sb_blocksize),
> -		.ops = &xfs_allocbt_buf_ops,
> +		.ops = &xfs_cntbt_buf_ops,
>  		.work = &xfs_cntroot_init,
>  		.need_init = true
>  	},
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 4e59cc8a2802..480d0f52da64 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -377,13 +377,19 @@ xfs_allocbt_write_verify(
>  
>  }
>  
> -const struct xfs_buf_ops xfs_allocbt_buf_ops = {
> -	.name = "xfs_allocbt",
> +const struct xfs_buf_ops xfs_bnobt_buf_ops = {
> +	.name = "xfs_bnobt",
>  	.verify_read = xfs_allocbt_read_verify,
>  	.verify_write = xfs_allocbt_write_verify,
>  	.verify_struct = xfs_allocbt_verify,
>  };
>  
> +const struct xfs_buf_ops xfs_cntbt_buf_ops = {
> +	.name = "xfs_cntbt",
> +	.verify_read = xfs_allocbt_read_verify,
> +	.verify_write = xfs_allocbt_write_verify,
> +	.verify_struct = xfs_allocbt_verify,
> +};
>  
>  STATIC int
>  xfs_bnobt_keys_inorder(
> @@ -448,7 +454,7 @@ static const struct xfs_btree_ops xfs_bnobt_ops = {
>  	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
>  	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
>  	.key_diff		= xfs_bnobt_key_diff,
> -	.buf_ops		= &xfs_allocbt_buf_ops,
> +	.buf_ops		= &xfs_bnobt_buf_ops,
>  	.diff_two_keys		= xfs_bnobt_diff_two_keys,
>  	.keys_inorder		= xfs_bnobt_keys_inorder,
>  	.recs_inorder		= xfs_bnobt_recs_inorder,
> @@ -470,7 +476,7 @@ static const struct xfs_btree_ops xfs_cntbt_ops = {
>  	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
>  	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
>  	.key_diff		= xfs_cntbt_key_diff,
> -	.buf_ops		= &xfs_allocbt_buf_ops,
> +	.buf_ops		= &xfs_cntbt_buf_ops,
>  	.diff_two_keys		= xfs_cntbt_diff_two_keys,
>  	.keys_inorder		= xfs_cntbt_keys_inorder,
>  	.recs_inorder		= xfs_cntbt_recs_inorder,
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 9855f4d2f98f..4e909791aeac 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -25,7 +25,8 @@ extern const struct xfs_buf_ops xfs_agf_buf_ops;
>  extern const struct xfs_buf_ops xfs_agi_buf_ops;
>  extern const struct xfs_buf_ops xfs_agf_buf_ops;
>  extern const struct xfs_buf_ops xfs_agfl_buf_ops;
> -extern const struct xfs_buf_ops xfs_allocbt_buf_ops;
> +extern const struct xfs_buf_ops xfs_bnobt_buf_ops;
> +extern const struct xfs_buf_ops xfs_cntbt_buf_ops;
>  extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
>  extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
>  extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 673be3cf7b8d..2799d1531639 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -341,12 +341,12 @@ xrep_agf(
>  	struct xrep_find_ag_btree	fab[XREP_AGF_MAX] = {
>  		[XREP_AGF_BNOBT] = {
>  			.rmap_owner = XFS_RMAP_OWN_AG,
> -			.buf_ops = &xfs_allocbt_buf_ops,
> +			.buf_ops = &xfs_bnobt_buf_ops,
>  			.magic = XFS_ABTB_CRC_MAGIC,
>  		},
>  		[XREP_AGF_CNTBT] = {
>  			.rmap_owner = XFS_RMAP_OWN_AG,
> -			.buf_ops = &xfs_allocbt_buf_ops,
> +			.buf_ops = &xfs_cntbt_buf_ops,
>  			.magic = XFS_ABTC_CRC_MAGIC,

/me wonders if this part of repair ought to be refactored to pull the
magic number from the buf_ops, though that's a separate patch for after
all the buf ops have been modified to have magic numbers.

This patch looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  		},
>  		[XREP_AGF_RMAPBT] = {
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 228c754bb137..5ad42d598333 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2439,10 +2439,12 @@ xlog_recover_validate_buf_type(
>  	case XFS_BLFT_BTREE_BUF:
>  		switch (magic32) {
>  		case XFS_ABTB_CRC_MAGIC:
> -		case XFS_ABTC_CRC_MAGIC:
>  		case XFS_ABTB_MAGIC:
> +			bp->b_ops = &xfs_bnobt_buf_ops;
> +			break;
> +		case XFS_ABTC_CRC_MAGIC:
>  		case XFS_ABTC_MAGIC:
> -			bp->b_ops = &xfs_allocbt_buf_ops;
> +			bp->b_ops = &xfs_cntbt_buf_ops;
>  			break;
>  		case XFS_IBT_CRC_MAGIC:
>  		case XFS_IBT_MAGIC:
> -- 
> 2.17.2
> 
