Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58456 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752237AbeGCUjG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 16:39:06 -0400
Date: Tue, 3 Jul 2018 13:38:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/24] xfs: replace xfs_da_args->dfops accesses with
 ->t_dfops and remove
Message-ID: <20180703203850.GF32415@magnolia>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-10-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-10-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:21PM -0400, Brian Foster wrote:
> Now that xfs_da_args->dfops is always assigned from a ->t_dfops
> pointer (or one that is immediately attached), replace all
> downstream accesses of the former with the latter and remove the
> field from struct xfs_da_args.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c        | 103 ++++++++++++++++----------------
>  fs/xfs/libxfs/xfs_attr_leaf.c   |  24 ++++----
>  fs/xfs/libxfs/xfs_attr_remote.c |  23 +++----
>  fs/xfs/libxfs/xfs_bmap.c        |   1 -
>  fs/xfs/libxfs/xfs_da_btree.c    |  19 +++---
>  fs/xfs/libxfs/xfs_da_btree.h    |   1 -
>  fs/xfs/libxfs/xfs_dir2.c        |  65 ++++++++++----------
>  7 files changed, 117 insertions(+), 119 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index cc23c269f2bf..a14ab9b2669e 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -220,7 +220,6 @@ xfs_attr_set(
>  	args.value = value;
>  	args.valuelen = valuelen;
>  	args.firstblock = &firstblock;
> -	args.dfops = &dfops;
>  	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
>  	args.total = xfs_attr_calc_size(&args, &local);
>  
> @@ -407,7 +406,6 @@ xfs_attr_remove(
>  		return error;
>  
>  	args.firstblock = &firstblock;
> -	args.dfops = &dfops;
>  
>  	/*
>  	 * we have no control over the attribute names that userspace passes us
> @@ -539,11 +537,12 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>   * if bmap_one_block() says there is only one block (ie: no remote blks).
>   */
>  STATIC int
> -xfs_attr_leaf_addname(xfs_da_args_t *args)
> +xfs_attr_leaf_addname(
> +	struct xfs_da_args	*args)
>  {
> -	xfs_inode_t *dp;
> -	struct xfs_buf *bp;
> -	int retval, error, forkoff;
> +	struct xfs_inode	*dp;
> +	struct xfs_buf		*bp;
> +	int			retval, error, forkoff;
>  
>  	trace_xfs_attr_leaf_addname(args);
>  
> @@ -601,12 +600,12 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>  		 * Commit that transaction so that the node_addname() call
>  		 * can manage its own transactions.
>  		 */
> -		xfs_defer_init(args->dfops, args->firstblock);
> +		xfs_defer_init(args->trans->t_dfops, args->firstblock);
>  		error = xfs_attr3_leaf_to_node(args);
>  		if (error)
>  			goto out_defer_cancel;
> -		xfs_defer_ijoin(args->dfops, dp);
> -		error = xfs_defer_finish(&args->trans, args->dfops);
> +		xfs_defer_ijoin(args->trans->t_dfops, dp);
> +		error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
>  		if (error)
>  			goto out_defer_cancel;
>  
> @@ -690,13 +689,13 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>  		 * If the result is small enough, shrink it all into the inode.
>  		 */
>  		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			xfs_defer_init(args->dfops, args->firstblock);
> +			xfs_defer_init(args->trans->t_dfops, args->firstblock);
>  			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
>  				goto out_defer_cancel;
> -			xfs_defer_ijoin(args->dfops, dp);
> -			error = xfs_defer_finish(&args->trans, args->dfops);
> +			xfs_defer_ijoin(args->trans->t_dfops, dp);
> +			error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
>  			if (error)
>  				goto out_defer_cancel;
>  		}
> @@ -714,7 +713,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>  	}
>  	return error;
>  out_defer_cancel:
> -	xfs_defer_cancel(args->dfops);
> +	xfs_defer_cancel(args->trans->t_dfops);
>  	return error;
>  }
>  
> @@ -725,11 +724,12 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>   * if bmap_one_block() says there is only one block (ie: no remote blks).
>   */
>  STATIC int
> -xfs_attr_leaf_removename(xfs_da_args_t *args)
> +xfs_attr_leaf_removename(
> +	struct xfs_da_args	*args)
>  {
> -	xfs_inode_t *dp;
> -	struct xfs_buf *bp;
> -	int error, forkoff;
> +	struct xfs_inode	*dp;
> +	struct xfs_buf		*bp;
> +	int			error, forkoff;
>  
>  	trace_xfs_attr_leaf_removename(args);
>  
> @@ -754,19 +754,19 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
>  	 * If the result is small enough, shrink it all into the inode.
>  	 */
>  	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -		xfs_defer_init(args->dfops, args->firstblock);
> +		xfs_defer_init(args->trans->t_dfops, args->firstblock);
>  		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  		/* bp is gone due to xfs_da_shrink_inode */
>  		if (error)
>  			goto out_defer_cancel;
> -		xfs_defer_ijoin(args->dfops, dp);
> -		error = xfs_defer_finish(&args->trans, args->dfops);
> +		xfs_defer_ijoin(args->trans->t_dfops, dp);
> +		error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
>  		if (error)
>  			goto out_defer_cancel;
>  	}
>  	return 0;
>  out_defer_cancel:
> -	xfs_defer_cancel(args->dfops);
> +	xfs_defer_cancel(args->trans->t_dfops);
>  	return error;
>  }
>  
> @@ -817,13 +817,14 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>   * add a whole extra layer of confusion on top of that.
>   */
>  STATIC int
> -xfs_attr_node_addname(xfs_da_args_t *args)
> +xfs_attr_node_addname(
> +	struct xfs_da_args	*args)
>  {
> -	xfs_da_state_t *state;
> -	xfs_da_state_blk_t *blk;
> -	xfs_inode_t *dp;
> -	xfs_mount_t *mp;
> -	int retval, error;
> +	struct xfs_da_state	*state;
> +	struct xfs_da_state_blk	*blk;
> +	struct xfs_inode	*dp;
> +	struct xfs_mount	*mp;
> +	int			retval, error;
>  
>  	trace_xfs_attr_node_addname(args);
>  
> @@ -882,12 +883,13 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>  			 */
>  			xfs_da_state_free(state);
>  			state = NULL;
> -			xfs_defer_init(args->dfops, args->firstblock);
> +			xfs_defer_init(args->trans->t_dfops, args->firstblock);
>  			error = xfs_attr3_leaf_to_node(args);
>  			if (error)
>  				goto out_defer_cancel;
> -			xfs_defer_ijoin(args->dfops, dp);
> -			error = xfs_defer_finish(&args->trans, args->dfops);
> +			xfs_defer_ijoin(args->trans->t_dfops, dp);
> +			error = xfs_defer_finish(&args->trans,
> +						 args->trans->t_dfops);
>  			if (error)
>  				goto out_defer_cancel;
>  
> @@ -908,12 +910,12 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>  		 * in the index/blkno/rmtblkno/rmtblkcnt fields and
>  		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
>  		 */
> -		xfs_defer_init(args->dfops, args->firstblock);
> +		xfs_defer_init(args->trans->t_dfops, args->firstblock);
>  		error = xfs_da3_split(state);
>  		if (error)
>  			goto out_defer_cancel;
> -		xfs_defer_ijoin(args->dfops, dp);
> -		error = xfs_defer_finish(&args->trans, args->dfops);
> +		xfs_defer_ijoin(args->trans->t_dfops, dp);
> +		error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
>  		if (error)
>  			goto out_defer_cancel;
>  	} else {
> @@ -1006,12 +1008,12 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>  		 * Check to see if the tree needs to be collapsed.
>  		 */
>  		if (retval && (state->path.active > 1)) {
> -			xfs_defer_init(args->dfops, args->firstblock);
> +			xfs_defer_init(args->trans->t_dfops, args->firstblock);
>  			error = xfs_da3_join(state);
>  			if (error)
>  				goto out_defer_cancel;
> -			xfs_defer_ijoin(args->dfops, dp);
> -			error = xfs_defer_finish(&args->trans, args->dfops);
> +			xfs_defer_ijoin(args->trans->t_dfops, dp);
> +			error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
>  			if (error)
>  				goto out_defer_cancel;
>  		}
> @@ -1040,7 +1042,7 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>  		return error;
>  	return retval;
>  out_defer_cancel:
> -	xfs_defer_cancel(args->dfops);
> +	xfs_defer_cancel(args->trans->t_dfops);
>  	goto out;
>  }
>  
> @@ -1052,13 +1054,14 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>   * the root node (a special case of an intermediate node).
>   */
>  STATIC int
> -xfs_attr_node_removename(xfs_da_args_t *args)
> +xfs_attr_node_removename(
> +	struct xfs_da_args	*args)
>  {
> -	xfs_da_state_t *state;
> -	xfs_da_state_blk_t *blk;
> -	xfs_inode_t *dp;
> -	struct xfs_buf *bp;
> -	int retval, error, forkoff;
> +	struct xfs_da_state	*state;
> +	struct xfs_da_state_blk	*blk;
> +	struct xfs_inode	*dp;
> +	struct xfs_buf		*bp;
> +	int			retval, error, forkoff;
>  
>  	trace_xfs_attr_node_removename(args);
>  
> @@ -1130,12 +1133,12 @@ xfs_attr_node_removename(xfs_da_args_t *args)
>  	 * Check to see if the tree needs to be collapsed.
>  	 */
>  	if (retval && (state->path.active > 1)) {
> -		xfs_defer_init(args->dfops, args->firstblock);
> +		xfs_defer_init(args->trans->t_dfops, args->firstblock);
>  		error = xfs_da3_join(state);
>  		if (error)
>  			goto out_defer_cancel;
> -		xfs_defer_ijoin(args->dfops, dp);
> -		error = xfs_defer_finish(&args->trans, args->dfops);
> +		xfs_defer_ijoin(args->trans->t_dfops, dp);
> +		error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
>  		if (error)
>  			goto out_defer_cancel;
>  		/*
> @@ -1162,13 +1165,13 @@ xfs_attr_node_removename(xfs_da_args_t *args)
>  			goto out;
>  
>  		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			xfs_defer_init(args->dfops, args->firstblock);
> +			xfs_defer_init(args->trans->t_dfops, args->firstblock);
>  			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
>  				goto out_defer_cancel;
> -			xfs_defer_ijoin(args->dfops, dp);
> -			error = xfs_defer_finish(&args->trans, args->dfops);
> +			xfs_defer_ijoin(args->trans->t_dfops, dp);
> +			error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
>  			if (error)
>  				goto out_defer_cancel;
>  		} else
> @@ -1180,7 +1183,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
>  	xfs_da_state_free(state);
>  	return error;
>  out_defer_cancel:
> -	xfs_defer_cancel(args->dfops);
> +	xfs_defer_cancel(args->trans->t_dfops);
>  	goto out;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 76e90046731c..c131469db0f1 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -747,18 +747,18 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
>   */
>  int
>  xfs_attr_shortform_to_leaf(
> -	struct xfs_da_args	*args,
> -	struct xfs_buf		**leaf_bp)
> +	struct xfs_da_args		*args,
> +	struct xfs_buf			**leaf_bp)
>  {
> -	xfs_inode_t *dp;
> -	xfs_attr_shortform_t *sf;
> -	xfs_attr_sf_entry_t *sfe;
> -	xfs_da_args_t nargs;
> -	char *tmpbuffer;
> -	int error, i, size;
> -	xfs_dablk_t blkno;
> -	struct xfs_buf *bp;
> -	xfs_ifork_t *ifp;
> +	struct xfs_inode		*dp;
> +	struct xfs_attr_shortform	*sf;
> +	struct xfs_attr_sf_entry	*sfe;
> +	struct xfs_da_args		nargs;
> +	char				*tmpbuffer;
> +	int				error, i, size;
> +	xfs_dablk_t			blkno;
> +	struct xfs_buf			*bp;
> +	struct xfs_ifork		*ifp;
>  
>  	trace_xfs_attr_sf_to_leaf(args);
>  
> @@ -803,7 +803,6 @@ xfs_attr_shortform_to_leaf(
>  	nargs.dp = dp;
>  	nargs.geo = args->geo;
>  	nargs.firstblock = args->firstblock;
> -	nargs.dfops = args->dfops;
>  	nargs.total = args->total;
>  	nargs.whichfork = XFS_ATTR_FORK;
>  	nargs.trans = args->trans;
> @@ -1007,7 +1006,6 @@ xfs_attr3_leaf_to_shortform(
>  	nargs.geo = args->geo;
>  	nargs.dp = dp;
>  	nargs.firstblock = args->firstblock;
> -	nargs.dfops = args->dfops;
>  	nargs.total = args->total;
>  	nargs.whichfork = XFS_ATTR_FORK;
>  	nargs.trans = args->trans;
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index bf2e0371149b..577c4c372265 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -480,15 +480,16 @@ xfs_attr_rmtval_set(
>  		 * extent and then crash then the block may not contain the
>  		 * correct metadata after log recovery occurs.
>  		 */
> -		xfs_defer_init(args->dfops, args->firstblock);
> +		xfs_defer_init(args->trans->t_dfops, args->firstblock);
>  		nmap = 1;
>  		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
>  				  blkcnt, XFS_BMAPI_ATTRFORK, args->firstblock,
> -				  args->total, &map, &nmap, args->dfops);
> +				  args->total, &map, &nmap,
> +				  args->trans->t_dfops);
>  		if (error)
>  			goto out_defer_cancel;
> -		xfs_defer_ijoin(args->dfops, dp);
> -		error = xfs_defer_finish(&args->trans, args->dfops);
> +		xfs_defer_ijoin(args->trans->t_dfops, dp);
> +		error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
>  		if (error)
>  			goto out_defer_cancel;
>  
> @@ -522,7 +523,7 @@ xfs_attr_rmtval_set(
>  
>  		ASSERT(blkcnt > 0);
>  
> -		xfs_defer_init(args->dfops, args->firstblock);
> +		xfs_defer_init(args->trans->t_dfops, args->firstblock);
>  		nmap = 1;
>  		error = xfs_bmapi_read(dp, (xfs_fileoff_t)lblkno,
>  				       blkcnt, &map, &nmap,
> @@ -557,7 +558,7 @@ xfs_attr_rmtval_set(
>  	ASSERT(valuelen == 0);
>  	return 0;
>  out_defer_cancel:
> -	xfs_defer_cancel(args->dfops);
> +	xfs_defer_cancel(args->trans->t_dfops);
>  	args->trans = NULL;
>  	return error;
>  }
> @@ -626,14 +627,14 @@ xfs_attr_rmtval_remove(
>  	blkcnt = args->rmtblkcnt;
>  	done = 0;
>  	while (!done) {
> -		xfs_defer_init(args->dfops, args->firstblock);
> +		xfs_defer_init(args->trans->t_dfops, args->firstblock);
>  		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
>  				    XFS_BMAPI_ATTRFORK, 1, args->firstblock,
> -				    args->dfops, &done);
> +				    args->trans->t_dfops, &done);
>  		if (error)
>  			goto out_defer_cancel;
> -		xfs_defer_ijoin(args->dfops, args->dp);
> -		error = xfs_defer_finish(&args->trans, args->dfops);
> +		xfs_defer_ijoin(args->trans->t_dfops, args->dp);
> +		error = xfs_defer_finish(&args->trans, args->trans->t_dfops);
>  		if (error)
>  			goto out_defer_cancel;
>  
> @@ -646,7 +647,7 @@ xfs_attr_rmtval_remove(
>  	}
>  	return 0;
>  out_defer_cancel:
> -	xfs_defer_cancel(args->dfops);
> +	xfs_defer_cancel(args->trans->t_dfops);
>  	args->trans = NULL;
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index dbd07b0adfa3..93dbcf678e54 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1007,7 +1007,6 @@ xfs_bmap_add_attrfork_local(
>  		dargs.geo = ip->i_mount->m_dir_geo;
>  		dargs.dp = ip;
>  		dargs.firstblock = firstblock;
> -		dargs.dfops = tp->t_dfops;
>  		dargs.total = dargs.geo->fsbcount;
>  		dargs.whichfork = XFS_DATA_FORK;
>  		dargs.trans = tp;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 8a301402bbc4..d2048e4e93ec 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2063,7 +2063,7 @@ xfs_da_grow_inode_int(
>  	error = xfs_bmapi_write(tp, dp, *bno, count,
>  			xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
>  			args->firstblock, args->total, &map, &nmap,
> -			args->dfops);
> +			args->trans->t_dfops);
>  	if (error)
>  		return error;
>  
> @@ -2086,7 +2086,8 @@ xfs_da_grow_inode_int(
>  			error = xfs_bmapi_write(tp, dp, b, c,
>  					xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
>  					args->firstblock, args->total,
> -					&mapp[mapi], &nmap, args->dfops);
> +					&mapp[mapi], &nmap,
> +					args->trans->t_dfops);
>  			if (error)
>  				goto out_free_map;
>  			if (nmap < 1)
> @@ -2375,13 +2376,13 @@ xfs_da3_swap_lastblock(
>   */
>  int
>  xfs_da_shrink_inode(
> -	xfs_da_args_t	*args,
> -	xfs_dablk_t	dead_blkno,
> -	struct xfs_buf	*dead_buf)
> +	struct xfs_da_args	*args,
> +	xfs_dablk_t		dead_blkno,
> +	struct xfs_buf		*dead_buf)
>  {
> -	xfs_inode_t *dp;
> -	int done, error, w, count;
> -	xfs_trans_t *tp;
> +	struct xfs_inode	*dp;
> +	int			done, error, w, count;
> +	struct xfs_trans	*tp;
>  
>  	trace_xfs_da_shrink_inode(args);
>  
> @@ -2396,7 +2397,7 @@ xfs_da_shrink_inode(
>  		 */
>  		error = xfs_bunmapi(tp, dp, dead_blkno, count,
>  				    xfs_bmapi_aflag(w), 0, args->firstblock,
> -				    args->dfops, &done);
> +				    args->trans->t_dfops, &done);
>  		if (error == -ENOSPC) {
>  			if (w != XFS_DATA_FORK)
>  				break;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 28260073ae71..6b8a04f3f162 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -58,7 +58,6 @@ typedef struct xfs_da_args {
>  	xfs_ino_t	inumber;	/* input/output inode number */
>  	struct xfs_inode *dp;		/* directory inode to manipulate */
>  	xfs_fsblock_t	*firstblock;	/* ptr to firstblock for bmap calls */
> -	struct xfs_defer_ops *dfops;	/* ptr to freelist for bmap_finish */
>  	struct xfs_trans *trans;	/* current trans (changes over time) */
>  	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
>  	int		whichfork;	/* data or attribute fork */
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index ceedc3d31114..ffa288c37da0 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -239,8 +239,8 @@ xfs_dir_init(
>   */
>  int
>  xfs_dir_createname(
> -	xfs_trans_t		*tp,
> -	xfs_inode_t		*dp,
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*dp,
>  	struct xfs_name		*name,
>  	xfs_ino_t		inum,		/* new entry inode number */
>  	xfs_fsblock_t		*first,		/* bmap's firstblock */
> @@ -273,7 +273,6 @@ xfs_dir_createname(
>  	args->whichfork = XFS_DATA_FORK;
>  	args->trans = tp;
>  	ASSERT(tp->t_dfops || !first);
> -	args->dfops = tp->t_dfops;
>  	args->firstblock = first;
>  	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
>  	if (!inum)
> @@ -416,16 +415,16 @@ xfs_dir_lookup(
>   */
>  int
>  xfs_dir_removename(
> -	xfs_trans_t	*tp,
> -	xfs_inode_t	*dp,
> -	struct xfs_name	*name,
> -	xfs_ino_t	ino,
> -	xfs_fsblock_t	*first,		/* bmap's firstblock */
> -	xfs_extlen_t	total)		/* bmap's total block count */
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*dp,
> +	struct xfs_name		*name,
> +	xfs_ino_t		ino,
> +	xfs_fsblock_t		*first,		/* bmap's firstblock */
> +	xfs_extlen_t		total)		/* bmap's total block count */
>  {
> -	struct xfs_da_args *args;
> -	int		rval;
> -	int		v;		/* type-checking value */
> +	struct xfs_da_args	*args;
> +	int			rval;
> +	int			v;		/* type-checking value */
>  
>  	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
>  	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
> @@ -446,7 +445,6 @@ xfs_dir_removename(
>  	args->whichfork = XFS_DATA_FORK;
>  	args->trans = tp;
>  	ASSERT(tp->t_dfops);
> -	args->dfops = tp->t_dfops;
>  
>  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
>  		rval = xfs_dir2_sf_removename(args);
> @@ -478,16 +476,16 @@ xfs_dir_removename(
>   */
>  int
>  xfs_dir_replace(
> -	xfs_trans_t	*tp,
> -	xfs_inode_t	*dp,
> -	struct xfs_name	*name,		/* name of entry to replace */
> -	xfs_ino_t	inum,		/* new inode number */
> -	xfs_fsblock_t	*first,		/* bmap's firstblock */
> -	xfs_extlen_t	total)		/* bmap's total block count */
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*dp,
> +	struct xfs_name		*name,		/* name of entry to replace */
> +	xfs_ino_t		inum,		/* new inode number */
> +	xfs_fsblock_t		*first,		/* bmap's firstblock */
> +	xfs_extlen_t		total)		/* bmap's total block count */
>  {
> -	struct xfs_da_args *args;
> -	int		rval;
> -	int		v;		/* type-checking value */
> +	struct xfs_da_args	*args;
> +	int			rval;
> +	int			v;		/* type-checking value */
>  
>  	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
>  
> @@ -511,7 +509,6 @@ xfs_dir_replace(
>  	args->whichfork = XFS_DATA_FORK;
>  	args->trans = tp;
>  	ASSERT(tp->t_dfops);
> -	args->dfops = tp->t_dfops;
>  
>  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
>  		rval = xfs_dir2_sf_replace(args);
> @@ -645,17 +642,17 @@ xfs_dir2_isleaf(
>   */
>  int
>  xfs_dir2_shrink_inode(
> -	xfs_da_args_t	*args,
> -	xfs_dir2_db_t	db,
> -	struct xfs_buf	*bp)
> +	struct xfs_da_args	*args,
> +	xfs_dir2_db_t		db,
> +	struct xfs_buf		*bp)
>  {
> -	xfs_fileoff_t	bno;		/* directory file offset */
> -	xfs_dablk_t	da;		/* directory file offset */
> -	int		done;		/* bunmap is finished */
> -	xfs_inode_t	*dp;
> -	int		error;
> -	xfs_mount_t	*mp;
> -	xfs_trans_t	*tp;
> +	xfs_fileoff_t		bno;		/* directory file offset */
> +	xfs_dablk_t		da;		/* directory file offset */
> +	int			done;		/* bunmap is finished */
> +	struct xfs_inode	*dp;
> +	int			error;
> +	struct xfs_mount	*mp;
> +	struct xfs_trans	*tp;
>  
>  	trace_xfs_dir2_shrink_inode(args, db);
>  
> @@ -666,7 +663,7 @@ xfs_dir2_shrink_inode(
>  
>  	/* Unmap the fsblock(s). */
>  	error = xfs_bunmapi(tp, dp, da, args->geo->fsbcount, 0, 0,
> -			    args->firstblock, args->dfops, &done);
> +			    args->firstblock, args->trans->t_dfops, &done);
>  	if (error) {
>  		/*
>  		 * ENOSPC actually can happen if we're in a removename with no
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
