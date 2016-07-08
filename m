Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 451097CDC
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 13:34:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B75058F8039
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 11:34:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bHjLOPJJ4SaFiAfv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Jul 2016 11:34:05 -0700 (PDT)
Date: Fri, 8 Jul 2016 14:34:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 034/119] xfs: teach rmapbt to support interval queries
Message-ID: <20160708183403.GF59278@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612649050.12839.2803288971604662823.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612649050.12839.2803288971604662823.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Thu, Jun 16, 2016 at 06:21:30PM -0700, Darrick J. Wong wrote:
> Now that the generic btree code supports querying all records within a
> range of keys, use that functionality to allow us to ask for all the
> extents mapped to a range of physical blocks.
> 
> v2: Move unwritten bit to rm_offset.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_rmap.c       |   43 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_rmap_btree.h |    9 ++++++++
>  2 files changed, 52 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index c6a5a0b..0e1721a 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -184,3 +184,46 @@ out_error:
>  	trace_xfs_rmap_alloc_extent_error(mp, agno, bno, len, false, oinfo);
>  	return error;
>  }
> +
> +struct xfs_rmapbt_query_range_info {
> +	xfs_rmapbt_query_range_fn	fn;
> +	void				*priv;
> +};
> +
> +/* Format btree record and pass to our callback. */
> +STATIC int
> +xfs_rmapbt_query_range_helper(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_rec	*rec,
> +	void			*priv)
> +{
> +	struct xfs_rmapbt_query_range_info	*query = priv;
> +	struct xfs_rmap_irec			irec;
> +	int					error;
> +
> +	error = xfs_rmapbt_btrec_to_irec(rec, &irec);
> +	if (error)
> +		return error;
> +	return query->fn(cur, &irec, query->priv);
> +}
> +
> +/* Find all rmaps between two keys. */
> +int
> +xfs_rmapbt_query_range(
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_rmap_irec		*low_rec,
> +	struct xfs_rmap_irec		*high_rec,
> +	xfs_rmapbt_query_range_fn	fn,
> +	void				*priv)
> +{
> +	union xfs_btree_irec		low_brec;
> +	union xfs_btree_irec		high_brec;
> +	struct xfs_rmapbt_query_range_info	query;
> +
> +	low_brec.r = *low_rec;
> +	high_brec.r = *high_rec;

Some checks or asserts that these are actually in order couldn't hurt.
Otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	query.priv = priv;
> +	query.fn = fn;
> +	return xfs_btree_query_range(cur, &low_brec, &high_brec,
> +			xfs_rmapbt_query_range_helper, &query);
> +}
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> index 796071c..e926c6e 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> @@ -74,4 +74,13 @@ int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
>  		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
>  		  struct xfs_owner_info *oinfo);
>  
> +typedef int (*xfs_rmapbt_query_range_fn)(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_rmap_irec	*rec,
> +	void			*priv);
> +
> +int xfs_rmapbt_query_range(struct xfs_btree_cur *cur,
> +		struct xfs_rmap_irec *low_rec, struct xfs_rmap_irec *high_rec,
> +		xfs_rmapbt_query_range_fn fn, void *priv);
> +
>  #endif	/* __XFS_RMAP_BTREE_H__ */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
