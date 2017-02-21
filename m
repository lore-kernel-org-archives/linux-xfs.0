Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752571AbdBUOfK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Feb 2017 09:35:10 -0500
Date: Tue, 21 Feb 2017 09:35:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/8] xfs: provide a query_range function for freespace
 btrees
Message-ID: <20170221143509.GC3207@bfoster.bfoster>
References: <148738063792.29384.10681837280402457846.stgit@birch.djwong.org>
 <148738065667.29384.10238083345504563010.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148738065667.29384.10238083345504563010.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 17, 2017 at 05:17:36PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Implement a query_range function for the bnobt and cntbt.  This will
> be used for getfsmap fallback if there is no rmapbt and by the online
> scrub and repair code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_alloc.h |   10 ++++++++++
>  2 files changed, 52 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 9f06a21..526df17 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2875,3 +2875,45 @@ xfs_free_extent(
>  	xfs_trans_brelse(tp, agbp);
>  	return error;
>  }
> +
> +struct xfs_alloc_query_range_info {
> +	xfs_alloc_query_range_fn	fn;
> +	void				*priv;
> +};
> +
> +/* Format btree record and pass to our callback. */
> +STATIC int
> +xfs_alloc_query_range_helper(
> +	struct xfs_btree_cur		*cur,
> +	union xfs_btree_rec		*rec,
> +	void				*priv)
> +{
> +	struct xfs_alloc_query_range_info	*query = priv;
> +	struct xfs_alloc_rec_incore		irec;
> +
> +	irec.ar_startblock = be32_to_cpu(rec->alloc.ar_startblock);
> +	irec.ar_blockcount = be32_to_cpu(rec->alloc.ar_blockcount);
> +	return query->fn(cur, &irec, query->priv);
> +}
> +
> +/* Find all free space within a given range of blocks. */
> +int
> +xfs_alloc_query_range(
> +	struct xfs_btree_cur			*cur,
> +	struct xfs_alloc_rec_incore		*low_rec,
> +	struct xfs_alloc_rec_incore		*high_rec,
> +	xfs_alloc_query_range_fn		fn,
> +	void					*priv)
> +{
> +	union xfs_btree_irec			low_brec;
> +	union xfs_btree_irec			high_brec;
> +	struct xfs_alloc_query_range_info	query;
> +
> +	ASSERT(cur->bc_btnum == XFS_BTNUM_BNO);
> +	low_brec.a = *low_rec;
> +	high_brec.a = *high_rec;
> +	query.priv = priv;
> +	query.fn = fn;
> +	return xfs_btree_query_range(cur, &low_brec, &high_brec,
> +			xfs_alloc_query_range_helper, &query);
> +}
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 1d0f48a..f534998 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -223,4 +223,14 @@ int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
>  
>  xfs_extlen_t xfs_prealloc_blocks(struct xfs_mount *mp);
>  
> +typedef int (*xfs_alloc_query_range_fn)(
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_alloc_rec_incore	*rec,
> +	void				*priv);
> +
> +int xfs_alloc_query_range(struct xfs_btree_cur *cur,
> +		struct xfs_alloc_rec_incore *low_rec,
> +		struct xfs_alloc_rec_incore *high_rec,
> +		xfs_alloc_query_range_fn fn, void *priv);
> +
>  #endif	/* __XFS_ALLOC_H__ */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
