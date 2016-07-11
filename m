Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 212C67CA0
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2016 13:49:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E73A78F8037
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2016 11:49:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kCXtnkRXN3BPYDJp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jul 2016 11:49:12 -0700 (PDT)
Date: Mon, 11 Jul 2016 14:49:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 036/119] xfs: add an extent to the rmap btree
Message-ID: <20160711184908.GC32896@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612650302.12839.2761171937406229512.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612650302.12839.2761171937406229512.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Thu, Jun 16, 2016 at 06:21:43PM -0700, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now all the btree, free space and transaction infrastructure is in
> place, we can finally add the code to insert reverse mappings to the
> rmap btree. Freeing will be done in a separate patch, so just the
> addition operation can be focussed on here.
> 
> v2: Update alloc function to handle non-shared file data.  Isolate the
> part that makes changes from the part that initializes the rmap
> cursor; this will be useful for deferred updates.
> 
> [darrick: handle owner offsets when adding rmaps]
> [dchinner: remove remaining debug printk statements]
> [darrick: move unwritten bit to rm_offset]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/libxfs/xfs_rmap.c       |  225 +++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_rmap_btree.h |    1 
>  fs/xfs/xfs_trace.h             |    2 
>  3 files changed, 223 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 0e1721a..196e952 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -159,6 +159,218 @@ out_error:
>  	return error;
>  }
>  
> +/*
> + * A mergeable rmap should have the same owner, cannot be unwritten, and

Why can't it be unwritten? According to the code, it just looks like the
unwritten state must match between extents..?

> + * must be a bmbt rmap if we're asking about a bmbt rmap.
> + */
> +static bool
> +xfs_rmap_is_mergeable(
> +	struct xfs_rmap_irec	*irec,
> +	uint64_t		owner,
> +	uint64_t		offset,
> +	xfs_extlen_t		len,
> +	unsigned int		flags)
> +{

Also, why are we passing and not using offset and len? Is this modified
later?

One more comment nit below, otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	if (irec->rm_owner == XFS_RMAP_OWN_NULL)
> +		return false;
> +	if (irec->rm_owner != owner)
> +		return false;
> +	if ((flags & XFS_RMAP_UNWRITTEN) ^
> +	    (irec->rm_flags & XFS_RMAP_UNWRITTEN))
> +		return false;
> +	if ((flags & XFS_RMAP_ATTR_FORK) ^
> +	    (irec->rm_flags & XFS_RMAP_ATTR_FORK))
> +		return false;
> +	if ((flags & XFS_RMAP_BMBT_BLOCK) ^
> +	    (irec->rm_flags & XFS_RMAP_BMBT_BLOCK))
> +		return false;
> +	return true;
> +}
> +
> +/*
> + * When we allocate a new block, the first thing we do is add a reference to
> + * the extent in the rmap btree. This takes the form of a [agbno, length,
> + * owner, offset] record.  Flags are encoded in the high bits of the offset
> + * field.
> + */
> +STATIC int
> +__xfs_rmap_alloc(
> +	struct xfs_btree_cur	*cur,
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len,
> +	bool			unwritten,
> +	struct xfs_owner_info	*oinfo)
> +{
> +	struct xfs_mount	*mp = cur->bc_mp;
> +	struct xfs_rmap_irec	ltrec;
> +	struct xfs_rmap_irec	gtrec;
> +	int			have_gt;
> +	int			have_lt;
> +	int			error = 0;
> +	int			i;
> +	uint64_t		owner;
> +	uint64_t		offset;
> +	unsigned int		flags = 0;
> +	bool			ignore_off;
> +
> +	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
> +	ignore_off = XFS_RMAP_NON_INODE_OWNER(owner) ||
> +			(flags & XFS_RMAP_BMBT_BLOCK);
> +	if (unwritten)
> +		flags |= XFS_RMAP_UNWRITTEN;
> +	trace_xfs_rmap_alloc_extent(mp, cur->bc_private.a.agno, bno, len,
> +			unwritten, oinfo);
> +
> +	/*
> +	 * For the initial lookup, look for and exact match or the left-adjacent

					    an

Brian

> +	 * record for our insertion point. This will also give us the record for
> +	 * start block contiguity tests.
> +	 */
> +	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, flags,
> +			&have_lt);
> +	if (error)
> +		goto out_error;
> +	XFS_WANT_CORRUPTED_GOTO(mp, have_lt == 1, out_error);
> +
> +	error = xfs_rmap_get_rec(cur, &ltrec, &have_lt);
> +	if (error)
> +		goto out_error;
> +	XFS_WANT_CORRUPTED_GOTO(mp, have_lt == 1, out_error);
> +	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
> +			cur->bc_private.a.agno, ltrec.rm_startblock,
> +			ltrec.rm_blockcount, ltrec.rm_owner,
> +			ltrec.rm_offset, ltrec.rm_flags);
> +
> +	if (!xfs_rmap_is_mergeable(&ltrec, owner, offset, len, flags))
> +		have_lt = 0;
> +
> +	XFS_WANT_CORRUPTED_GOTO(mp,
> +		have_lt == 0 ||
> +		ltrec.rm_startblock + ltrec.rm_blockcount <= bno, out_error);
> +
> +	/*
> +	 * Increment the cursor to see if we have a right-adjacent record to our
> +	 * insertion point. This will give us the record for end block
> +	 * contiguity tests.
> +	 */
> +	error = xfs_btree_increment(cur, 0, &have_gt);
> +	if (error)
> +		goto out_error;
> +	if (have_gt) {
> +		error = xfs_rmap_get_rec(cur, &gtrec, &have_gt);
> +		if (error)
> +			goto out_error;
> +		XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 1, out_error);
> +		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= gtrec.rm_startblock,
> +					out_error);
> +		trace_xfs_rmap_map_gtrec(cur->bc_mp,
> +			cur->bc_private.a.agno, gtrec.rm_startblock,
> +			gtrec.rm_blockcount, gtrec.rm_owner,
> +			gtrec.rm_offset, gtrec.rm_flags);
> +		if (!xfs_rmap_is_mergeable(&gtrec, owner, offset, len, flags))
> +			have_gt = 0;
> +	}
> +
> +	/*
> +	 * Note: cursor currently points one record to the right of ltrec, even
> +	 * if there is no record in the tree to the right.
> +	 */
> +	if (have_lt &&
> +	    ltrec.rm_startblock + ltrec.rm_blockcount == bno &&
> +	    (ignore_off || ltrec.rm_offset + ltrec.rm_blockcount == offset)) {
> +		/*
> +		 * left edge contiguous, merge into left record.
> +		 *
> +		 *       ltbno     ltlen
> +		 * orig:   |ooooooooo|
> +		 * adding:           |aaaaaaaaa|
> +		 * result: |rrrrrrrrrrrrrrrrrrr|
> +		 *                  bno       len
> +		 */
> +		ltrec.rm_blockcount += len;
> +		if (have_gt &&
> +		    bno + len == gtrec.rm_startblock &&
> +		    (ignore_off || offset + len == gtrec.rm_offset) &&
> +		    (unsigned long)ltrec.rm_blockcount + len +
> +				gtrec.rm_blockcount <= XFS_RMAP_LEN_MAX) {
> +			/*
> +			 * right edge also contiguous, delete right record
> +			 * and merge into left record.
> +			 *
> +			 *       ltbno     ltlen    gtbno     gtlen
> +			 * orig:   |ooooooooo|         |ooooooooo|
> +			 * adding:           |aaaaaaaaa|
> +			 * result: |rrrrrrrrrrrrrrrrrrrrrrrrrrrrr|
> +			 */
> +			ltrec.rm_blockcount += gtrec.rm_blockcount;
> +			trace_xfs_rmapbt_delete(mp, cur->bc_private.a.agno,
> +					gtrec.rm_startblock,
> +					gtrec.rm_blockcount,
> +					gtrec.rm_owner,
> +					gtrec.rm_offset,
> +					gtrec.rm_flags);
> +			error = xfs_btree_delete(cur, &i);
> +			if (error)
> +				goto out_error;
> +			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
> +		}
> +
> +		/* point the cursor back to the left record and update */
> +		error = xfs_btree_decrement(cur, 0, &have_gt);
> +		if (error)
> +			goto out_error;
> +		error = xfs_rmap_update(cur, &ltrec);
> +		if (error)
> +			goto out_error;
> +	} else if (have_gt &&
> +		   bno + len == gtrec.rm_startblock &&
> +		   (ignore_off || offset + len == gtrec.rm_offset)) {
> +		/*
> +		 * right edge contiguous, merge into right record.
> +		 *
> +		 *                 gtbno     gtlen
> +		 * Orig:             |ooooooooo|
> +		 * adding: |aaaaaaaaa|
> +		 * Result: |rrrrrrrrrrrrrrrrrrr|
> +		 *        bno       len
> +		 */
> +		gtrec.rm_startblock = bno;
> +		gtrec.rm_blockcount += len;
> +		if (!ignore_off)
> +			gtrec.rm_offset = offset;
> +		error = xfs_rmap_update(cur, &gtrec);
> +		if (error)
> +			goto out_error;
> +	} else {
> +		/*
> +		 * no contiguous edge with identical owner, insert
> +		 * new record at current cursor position.
> +		 */
> +		cur->bc_rec.r.rm_startblock = bno;
> +		cur->bc_rec.r.rm_blockcount = len;
> +		cur->bc_rec.r.rm_owner = owner;
> +		cur->bc_rec.r.rm_offset = offset;
> +		cur->bc_rec.r.rm_flags = flags;
> +		trace_xfs_rmapbt_insert(mp, cur->bc_private.a.agno, bno, len,
> +			owner, offset, flags);
> +		error = xfs_btree_insert(cur, &i);
> +		if (error)
> +			goto out_error;
> +		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
> +	}
> +
> +	trace_xfs_rmap_alloc_extent_done(mp, cur->bc_private.a.agno, bno, len,
> +			unwritten, oinfo);
> +out_error:
> +	if (error)
> +		trace_xfs_rmap_alloc_extent_error(mp, cur->bc_private.a.agno,
> +				bno, len, unwritten, oinfo);
> +	return error;
> +}
> +
> +/*
> + * Add a reference to an extent in the rmap btree.
> + */
>  int
>  xfs_rmap_alloc(
>  	struct xfs_trans	*tp,
> @@ -169,19 +381,22 @@ xfs_rmap_alloc(
>  	struct xfs_owner_info	*oinfo)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	int			error = 0;
> +	struct xfs_btree_cur	*cur;
> +	int			error;
>  
>  	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		return 0;
>  
> -	trace_xfs_rmap_alloc_extent(mp, agno, bno, len, false, oinfo);
> -	if (1)
> +	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
> +	error = __xfs_rmap_alloc(cur, bno, len, false, oinfo);
> +	if (error)
>  		goto out_error;
> -	trace_xfs_rmap_alloc_extent_done(mp, agno, bno, len, false, oinfo);
> +
> +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>  	return 0;
>  
>  out_error:
> -	trace_xfs_rmap_alloc_extent_error(mp, agno, bno, len, false, oinfo);
> +	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> index e926c6e..9d92da5 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> @@ -67,6 +67,7 @@ int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_agblock_t bno,
>  int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
>  		int *stat);
>  
> +/* functions for updating the rmapbt for bmbt blocks and AG btree blocks */
>  int xfs_rmap_alloc(struct xfs_trans *tp, struct xfs_buf *agbp,
>  		   xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
>  		   struct xfs_owner_info *oinfo);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 6daafaf..3ebceb0 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2549,6 +2549,8 @@ DEFINE_RMAPBT_EVENT(xfs_rmapbt_delete);
>  DEFINE_AG_ERROR_EVENT(xfs_rmapbt_insert_error);
>  DEFINE_AG_ERROR_EVENT(xfs_rmapbt_delete_error);
>  DEFINE_AG_ERROR_EVENT(xfs_rmapbt_update_error);
> +DEFINE_RMAPBT_EVENT(xfs_rmap_lookup_le_range_result);
> +DEFINE_RMAPBT_EVENT(xfs_rmap_map_gtrec);
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
