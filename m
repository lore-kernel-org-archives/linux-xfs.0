Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbfBGU1P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 15:27:15 -0500
Date: Thu, 7 Feb 2019 15:27:13 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/8] xfs: use buf ops magic to detect btree block type
Message-ID: <20190207202713.GF61958@bfoster>
References: <20190207184105.17064-1-bfoster@redhat.com>
 <20190207185713.GI7991@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207185713.GI7991@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 07, 2019 at 10:57:13AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we encode block magic numbers in all the buffer ops, use that
> for block type detection in the ag header repair code instead of
> encoding magics directly in the repair code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/agheader_repair.c |    6 ------
>  fs/xfs/scrub/repair.c          |    3 ++-
>  fs/xfs/scrub/repair.h          |    3 ---
>  3 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 2799d1531639..64e31f87d490 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -342,22 +342,18 @@ xrep_agf(
>  		[XREP_AGF_BNOBT] = {
>  			.rmap_owner = XFS_RMAP_OWN_AG,
>  			.buf_ops = &xfs_bnobt_buf_ops,
> -			.magic = XFS_ABTB_CRC_MAGIC,
>  		},
>  		[XREP_AGF_CNTBT] = {
>  			.rmap_owner = XFS_RMAP_OWN_AG,
>  			.buf_ops = &xfs_cntbt_buf_ops,
> -			.magic = XFS_ABTC_CRC_MAGIC,
>  		},
>  		[XREP_AGF_RMAPBT] = {
>  			.rmap_owner = XFS_RMAP_OWN_AG,
>  			.buf_ops = &xfs_rmapbt_buf_ops,
> -			.magic = XFS_RMAP_CRC_MAGIC,
>  		},
>  		[XREP_AGF_REFCOUNTBT] = {
>  			.rmap_owner = XFS_RMAP_OWN_REFC,
>  			.buf_ops = &xfs_refcountbt_buf_ops,
> -			.magic = XFS_REFC_CRC_MAGIC,
>  		},
>  		[XREP_AGF_END] = {
>  			.buf_ops = NULL,
> @@ -875,12 +871,10 @@ xrep_agi(
>  		[XREP_AGI_INOBT] = {
>  			.rmap_owner = XFS_RMAP_OWN_INOBT,
>  			.buf_ops = &xfs_inobt_buf_ops,
> -			.magic = XFS_IBT_CRC_MAGIC,
>  		},
>  		[XREP_AGI_FINOBT] = {
>  			.rmap_owner = XFS_RMAP_OWN_INOBT,
>  			.buf_ops = &xfs_finobt_buf_ops,
> -			.magic = XFS_FIBT_CRC_MAGIC,
>  		},
>  		[XREP_AGI_END] = {
>  			.buf_ops = NULL
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 6acf1bfa0bfe..f28f4bad317b 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -743,7 +743,8 @@ xrep_findroot_block(
>  
>  	/* Ensure the block magic matches the btree type we're looking for. */
>  	btblock = XFS_BUF_TO_BLOCK(bp);
> -	if (be32_to_cpu(btblock->bb_magic) != fab->magic)
> +	ASSERT(fab->buf_ops->magic[1] != 0);
> +	if (btblock->bb_magic != fab->buf_ops->magic[1])
>  		goto out;
>  
>  	/*
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index f2fc18bb7605..d990314eb08b 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -42,9 +42,6 @@ struct xrep_find_ag_btree {
>  	/* in: buffer ops */
>  	const struct xfs_buf_ops	*buf_ops;
>  
> -	/* in: magic number of the btree */
> -	uint32_t			magic;
> -
>  	/* out: the highest btree block found and the tree height */
>  	xfs_agblock_t			root;
>  	unsigned int			height;
