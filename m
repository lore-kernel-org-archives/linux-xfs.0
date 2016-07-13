Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9B42F7CA4
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 13:28:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5E0ED304059
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 11:28:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GS3B8YaujeZQFbPJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jul 2016 11:27:58 -0700 (PDT)
Date: Wed, 13 Jul 2016 14:27:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 038/119] xfs: convert unwritten status of reverse mappings
Message-ID: <20160713182754.GA34396@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612651582.12839.562287367335619574.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612651582.12839.562287367335619574.stgit@birch.djwong.org>
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

On Thu, Jun 16, 2016 at 06:21:55PM -0700, Darrick J. Wong wrote:
> Provide a function to convert an unwritten extent to a real one and
> vice versa.
> 
> v2: Move unwritten bit to rm_offset.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Just a few nits below. Those aside and with Darrick's bc_rec.b ->
bc_rec.r fix:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_rmap.c |  442 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trace.h       |    6 +
>  2 files changed, 448 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 1043c63..53ba14e 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -610,6 +610,448 @@ out_error:
>  	return error;
>  }
>  
> +#define RMAP_LEFT_CONTIG	(1 << 0)
> +#define RMAP_RIGHT_CONTIG	(1 << 1)
> +#define RMAP_LEFT_FILLING	(1 << 2)
> +#define RMAP_RIGHT_FILLING	(1 << 3)
> +#define RMAP_LEFT_VALID		(1 << 6)
> +#define RMAP_RIGHT_VALID	(1 << 7)
> +
> +#define LEFT		r[0]
> +#define RIGHT		r[1]
> +#define PREV		r[2]
> +#define NEW		r[3]
> +
> +/*
> + * Convert an unwritten extent to a real extent or vice versa.
> + * Does not handle overlapping extents.
> + */
> +STATIC int
> +__xfs_rmap_convert(
> +	struct xfs_btree_cur	*cur,
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len,
> +	bool			unwritten,
> +	struct xfs_owner_info	*oinfo)
> +{
...
> +
> +	/*
> +	 * For the initial lookup, look for and exact match or the left-adjacent

Typo:					    an

> +	 * record for our insertion point. This will also give us the record for
> +	 * start block contiguity tests.
> +	 */
> +	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, oldext, &i);
> +	if (error)
> +		goto done;
> +	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> +
...
> +
> +	/*
> +	 * Switch out based on the FILLING and CONTIG state bits.
> +	 */
> +	switch (state & (RMAP_LEFT_FILLING | RMAP_LEFT_CONTIG |
> +			 RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG)) {
...
> +	case RMAP_LEFT_FILLING | RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG:
> +		/*
> +		 * Setting all of a previous oldext extent to newext.
> +		 * The right neighbor is contiguous, the left is not.
> +		 */
> +		error = xfs_btree_increment(cur, 0, &i);
> +		if (error)
> +			goto done;
> +		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> +		trace_xfs_rmapbt_delete(mp, cur->bc_private.a.agno,
> +				RIGHT.rm_startblock, RIGHT.rm_blockcount,
> +				RIGHT.rm_owner, RIGHT.rm_offset,
> +				RIGHT.rm_flags);
> +		error = xfs_btree_delete(cur, &i);
> +		if (error)
> +			goto done;
> +		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> +		error = xfs_btree_decrement(cur, 0, &i);
> +		if (error)
> +			goto done;
> +		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
> +		NEW.rm_startblock = bno;
> +		NEW.rm_owner = owner;
> +		NEW.rm_offset = offset;

		NEW = PREV ?

> +		NEW.rm_blockcount = len + RIGHT.rm_blockcount;
> +		NEW.rm_flags = newext;
> +		error = xfs_rmap_update(cur, &NEW);
> +		if (error)
> +			goto done;
> +		break;
> +
...
>  struct xfs_rmapbt_query_range_info {
>  	xfs_rmapbt_query_range_fn	fn;
>  	void				*priv;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 3ebceb0..6466adc 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2497,6 +2497,10 @@ DEFINE_RMAP_EVENT(xfs_rmap_free_extent_error);
>  DEFINE_RMAP_EVENT(xfs_rmap_alloc_extent);
>  DEFINE_RMAP_EVENT(xfs_rmap_alloc_extent_done);
>  DEFINE_RMAP_EVENT(xfs_rmap_alloc_extent_error);
> +DEFINE_RMAP_EVENT(xfs_rmap_convert);
> +DEFINE_RMAP_EVENT(xfs_rmap_convert_done);
> +DEFINE_AG_ERROR_EVENT(xfs_rmap_convert_error);
> +DEFINE_AG_ERROR_EVENT(xfs_rmap_convert_state);
>  
>  DECLARE_EVENT_CLASS(xfs_rmapbt_class,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
> @@ -2551,6 +2555,8 @@ DEFINE_AG_ERROR_EVENT(xfs_rmapbt_delete_error);
>  DEFINE_AG_ERROR_EVENT(xfs_rmapbt_update_error);
>  DEFINE_RMAPBT_EVENT(xfs_rmap_lookup_le_range_result);
>  DEFINE_RMAPBT_EVENT(xfs_rmap_map_gtrec);
> +DEFINE_RMAPBT_EVENT(xfs_rmap_convert_gtrec);
> +DEFINE_RMAPBT_EVENT(xfs_rmap_find_left_neighbor_result);

xfs_rmap_convert_ltrec ?

Brian

>  
>  #endif /* _TRACE_XFS_H */
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
