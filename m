Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37194 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751345AbdFFNdG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jun 2017 09:33:06 -0400
Date: Tue, 6 Jun 2017 09:33:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/13] xfs: plumb in needed functions for range querying
 of various btrees
Message-ID: <20170606133302.GD51630@bfoster.bfoster>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643867088.23065.12909617449604566367.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149643867088.23065.12909617449604566367.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 02, 2017 at 02:24:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Plumb in the pieces (init_high_key, diff_two_keys) necessary to call
> query_range on the inode space and block mapping btrees and to extract
> raw btree records.  This will eventually be used by the inobt and bmbt
> scrubbers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap_btree.c   |   22 ++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc_btree.c |   26 ++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index e23495e..85de225 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -573,6 +573,16 @@ xfs_bmbt_init_key_from_rec(
>  }
>  
>  STATIC void
> +xfs_bmbt_init_high_key_from_rec(
> +	union xfs_btree_key	*key,
> +	union xfs_btree_rec	*rec)
> +{
> +	key->bmbt.br_startoff = cpu_to_be64(
> +			xfs_bmbt_disk_get_startoff(&rec->bmbt) +
> +			xfs_bmbt_disk_get_blockcount(&rec->bmbt) - 1);
> +}
> +
> +STATIC void
>  xfs_bmbt_init_rec_from_cur(
>  	struct xfs_btree_cur	*cur,
>  	union xfs_btree_rec	*rec)
> @@ -597,6 +607,16 @@ xfs_bmbt_key_diff(
>  				      cur->bc_rec.b.br_startoff;
>  }
>  
> +STATIC int64_t
> +xfs_bmbt_diff_two_keys(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_key	*k1,
> +	union xfs_btree_key	*k2)
> +{
> +	return (int64_t)be64_to_cpu(k1->bmbt.br_startoff) -
> +			  be64_to_cpu(k2->bmbt.br_startoff);
> +}
> +
>  static bool
>  xfs_bmbt_verify(
>  	struct xfs_buf		*bp)
> @@ -720,9 +740,11 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
>  	.get_minrecs		= xfs_bmbt_get_minrecs,
>  	.get_dmaxrecs		= xfs_bmbt_get_dmaxrecs,
>  	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
> +	.init_high_key_from_rec	= xfs_bmbt_init_high_key_from_rec,
>  	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
>  	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
>  	.key_diff		= xfs_bmbt_key_diff,
> +	.diff_two_keys		= xfs_bmbt_diff_two_keys,
>  	.buf_ops		= &xfs_bmbt_buf_ops,
>  	.keys_inorder		= xfs_bmbt_keys_inorder,
>  	.recs_inorder		= xfs_bmbt_recs_inorder,
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 6b1ddeb..317caba 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -175,6 +175,18 @@ xfs_inobt_init_key_from_rec(
>  }
>  
>  STATIC void
> +xfs_inobt_init_high_key_from_rec(
> +	union xfs_btree_key	*key,
> +	union xfs_btree_rec	*rec)
> +{
> +	__u32			x;
> +
> +	x = be32_to_cpu(rec->inobt.ir_startino);
> +	x += XFS_INODES_PER_CHUNK - 1;
> +	key->inobt.ir_startino = cpu_to_be32(x);
> +}
> +
> +STATIC void
>  xfs_inobt_init_rec_from_cur(
>  	struct xfs_btree_cur	*cur,
>  	union xfs_btree_rec	*rec)
> @@ -228,6 +240,16 @@ xfs_inobt_key_diff(
>  			  cur->bc_rec.i.ir_startino;
>  }
>  
> +STATIC int64_t
> +xfs_inobt_diff_two_keys(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_key	*k1,
> +	union xfs_btree_key	*k2)
> +{
> +	return (int64_t)be32_to_cpu(k1->inobt.ir_startino) -
> +			  be32_to_cpu(k2->inobt.ir_startino);
> +}
> +
>  static int
>  xfs_inobt_verify(
>  	struct xfs_buf		*bp)
> @@ -333,10 +355,12 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
>  	.get_minrecs		= xfs_inobt_get_minrecs,
>  	.get_maxrecs		= xfs_inobt_get_maxrecs,
>  	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
> +	.init_high_key_from_rec	= xfs_inobt_init_high_key_from_rec,
>  	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
>  	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
>  	.key_diff		= xfs_inobt_key_diff,
>  	.buf_ops		= &xfs_inobt_buf_ops,
> +	.diff_two_keys		= xfs_inobt_diff_two_keys,
>  	.keys_inorder		= xfs_inobt_keys_inorder,
>  	.recs_inorder		= xfs_inobt_recs_inorder,
>  };
> @@ -352,10 +376,12 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
>  	.get_minrecs		= xfs_inobt_get_minrecs,
>  	.get_maxrecs		= xfs_inobt_get_maxrecs,
>  	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
> +	.init_high_key_from_rec	= xfs_inobt_init_high_key_from_rec,
>  	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
>  	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
>  	.key_diff		= xfs_inobt_key_diff,
>  	.buf_ops		= &xfs_inobt_buf_ops,
> +	.diff_two_keys		= xfs_inobt_diff_two_keys,
>  	.keys_inorder		= xfs_inobt_keys_inorder,
>  	.recs_inorder		= xfs_inobt_recs_inorder,
>  };
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
