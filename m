Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C36D67F59
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 11:41:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 46658AC003
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 09:41:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wdRWMKz7l6HC9xjo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 09:41:25 -0700 (PDT)
Date: Thu, 25 Jun 2015 12:41:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 15/20] xfs: add an extent to the rmap btree
Message-ID: <20150625164123.GD36162@bfoster.bfoster>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
	<1433311497-10245-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1433311497-10245-16-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 03, 2015 at 04:04:52PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now all the btree, free space and transaction infrastructure is in
> place, we can finally add the code to insert reverse mappings to the
> rmap btree. Freeing will be done in a spearate patch, so just the
> addition operation can be focussed on here.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_rmap.c | 139 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 138 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 38a92a1..c1e5d23 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -120,6 +120,18 @@ out_error:
>  	return error;
>  }
>  
> +/*
> + * When we allocate a new block, the first thing we do is add a reference to the
> + * extent in the rmap btree. This takes the form of a [agbno, length, owner]
> + * record.  Newly inserted extents should never overlap with an existing extent
> + * in the rmap btree. Hence the insertion is a relatively trivial exercise,
> + * involving checking for adjacent records and merging if the new extent is
> + * contiguous and has the same owner.
> + *
> + * Note that we have no MAXEXTLEN limits here when merging as the length in the
> + * record has the full 32 bits available and hence a single record can track the
> + * entire space in the AG.
> + */
>  int
>  xfs_rmap_alloc(
>  	struct xfs_trans	*tp,
> @@ -130,18 +142,143 @@ xfs_rmap_alloc(
>  	uint64_t		owner)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_btree_cur	*cur;
> +	struct xfs_rmap_irec	ltrec;
> +	struct xfs_rmap_irec	gtrec;
> +	int			have_gt;
>  	int			error = 0;
> +	int			i;
>  
>  	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		return 0;
>  
>  	trace_xfs_rmap_alloc_extent(mp, agno, bno, len, owner);
> -	if (1)
> +	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
> +
> +	/*
> +	 * For the initial lookup, look for and exact match or the left-adjacent
> +	 * record for our insertion point. This will also give us the record for
> +	 * start block contiguity tests.
> +	 */
> +	error = xfs_rmap_lookup_le(cur, bno, len, owner, &i);
> +	if (error)
> +		goto out_error;
> +	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
> +

Are we intentionally relying on the fact that a left record will always
exist due to the static metadata blocks that start the AG? If so, I'd
just suggest to note that in the comment above.

Brian

> +	error = xfs_rmap_get_rec(cur, &ltrec, &i);
> +	if (error)
>  		goto out_error;
> +	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
> +	//printk("rmalloc ag %d bno 0x%x/0x%x/0x%llx, ltrec 0x%x/0x%x/0x%llx\n",
> +	//		agno, bno, len, owner, ltrec.rm_startblock,
> +	//		ltrec.rm_blockcount, ltrec.rm_owner);
> +
> +	XFS_WANT_CORRUPTED_GOTO(mp,
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
> +		error = xfs_rmap_get_rec(cur, &gtrec, &i);
> +		if (error)
> +			goto out_error;
> +		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
> +	//printk("rmalloc ag %d bno 0x%x/0x%x/0x%llx, gtrec 0x%x/0x%x/0x%llx\n",
> +	//		agno, bno, len, owner, gtrec.rm_startblock,
> +	//		gtrec.rm_blockcount, gtrec.rm_owner);
> +		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= gtrec.rm_startblock,
> +					out_error);
> +	} else {
> +		gtrec.rm_owner = XFS_RMAP_OWN_NULL;
> +	}
> +
> +	/*
> +	 * Note: cursor currently points one record to the right of ltrec, even
> +	 * if there is no record in the tree to the right.
> +	 */
> +	if (ltrec.rm_owner == owner &&
> +	    ltrec.rm_startblock + ltrec.rm_blockcount == bno) {
> +		/*
> +		 * left edge contiguous, merge into left record.
> +		 *
> +		 *       ltbno     ltlen
> +		 * orig:   |ooooooooo|
> +		 * adding:           |aaaaaaaaa|
> +		 * result: |rrrrrrrrrrrrrrrrrrr|
> +		 *                  bno       len
> +		 */
> +		//printk("add left\n");
> +		ltrec.rm_blockcount += len;
> +		if (gtrec.rm_owner == owner &&
> +		    bno + len == gtrec.rm_startblock) {
> +			//printk("add middle\n");
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
> +	} else if (gtrec.rm_owner == owner &&
> +		   bno + len == gtrec.rm_startblock) {
> +		/*
> +		 * right edge contiguous, merge into right record.
> +		 *
> +		 *                 gtbno     gtlen
> +		 * Orig:             |ooooooooo|
> +		 * adding: |aaaaaaaaa|
> +		 * Result: |rrrrrrrrrrrrrrrrrrr|
> +		 *        bno       len
> +		 */
> +		//printk("add right\n");
> +		gtrec.rm_startblock = bno;
> +		gtrec.rm_blockcount += len;
> +		error = xfs_rmap_update(cur, &gtrec);
> +		if (error)
> +			goto out_error;
> +	} else {
> +		//printk("add no match\n");
> +		/*
> +		 * no contiguous edge with identical owner, insert
> +		 * new record at current cursor position.
> +		 */
> +		cur->bc_rec.r.rm_startblock = bno;
> +		cur->bc_rec.r.rm_blockcount = len;
> +		cur->bc_rec.r.rm_owner = owner;
> +		error = xfs_btree_insert(cur, &i);
> +		if (error)
> +			goto out_error;
> +		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
> +	}
> +
>  	trace_xfs_rmap_alloc_extent_done(mp, agno, bno, len, owner);
> +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>  	return 0;
>  
>  out_error:
>  	trace_xfs_rmap_alloc_extent_error(mp, agno, bno, len, owner);
> +	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
>  	return error;
>  }
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
