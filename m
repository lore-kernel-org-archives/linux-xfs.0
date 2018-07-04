Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43116 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752480AbeGDApP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:45:15 -0400
Date: Tue, 3 Jul 2018 17:45:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/25] xfs: use ->t_firstblock in xattr ops
Message-ID: <20180704004500.GF32415@magnolia>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-7-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:23:00PM -0400, Brian Foster wrote:
> Similar to the dirops code, the xattr code uses an on-stack
> firstblock variable for the various operations. This code rolls the
> underlying transaction in various places, however, which means we
> cannot simply replace the local firstblock vars with ->t_firstblock.
> Doing so (without further changes) would invalidate the memory
> pointed to by xfs_da_args.firstblock as soon as the first
> transaction rolls.
> 
> To avoid this problem, remove xfs_da_args.firstblock and replace all
> such accesses with ->t_firstblock at the same time. This ensures
> that accesses to the current firstblock always occur through the
> current transaction rather than a potentially invalid xfs_da_args
> pointer.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c        | 37 ++++++++++++++++-----------------
>  fs/xfs/libxfs/xfs_attr_leaf.c   |  2 --
>  fs/xfs/libxfs/xfs_attr_remote.c | 18 +++++++++-------
>  fs/xfs/libxfs/xfs_bmap.c        |  1 -
>  fs/xfs/libxfs/xfs_da_btree.c    |  7 +++----
>  fs/xfs/libxfs/xfs_da_btree.h    |  1 -
>  fs/xfs/libxfs/xfs_dir2.c        |  5 +----
>  7 files changed, 33 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 8a7e2c0308c4..153d2e29f872 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -204,7 +204,6 @@ xfs_attr_set(
>  	struct xfs_da_args	args;
>  	struct xfs_defer_ops	dfops;
>  	struct xfs_trans_res	tres;
> -	xfs_fsblock_t		firstblock;
>  	int			rsvd = (flags & ATTR_ROOT) != 0;
>  	int			error, err2, local;
>  
> @@ -219,7 +218,6 @@ xfs_attr_set(
>  
>  	args.value = value;
>  	args.valuelen = valuelen;
> -	args.firstblock = &firstblock;
>  	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
>  	args.total = xfs_attr_calc_size(&args, &local);
>  
> @@ -253,7 +251,7 @@ xfs_attr_set(
>  			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
>  	if (error)
>  		return error;
> -	xfs_defer_init(args.trans, &dfops, &firstblock);
> +	xfs_defer_init(args.trans, &dfops, &args.trans->t_firstblock);
>  
>  	xfs_ilock(dp, XFS_ILOCK_EXCL);
>  	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
> @@ -392,7 +390,6 @@ xfs_attr_remove(
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_da_args	args;
>  	struct xfs_defer_ops	dfops;
> -	xfs_fsblock_t		firstblock;
>  	int			error;
>  
>  	XFS_STATS_INC(mp, xs_attr_remove);
> @@ -404,8 +401,6 @@ xfs_attr_remove(
>  	if (error)
>  		return error;
>  
> -	args.firstblock = &firstblock;
> -
>  	/*
>  	 * we have no control over the attribute names that userspace passes us
>  	 * to remove, so we have to allow the name lookup prior to attribute
> @@ -427,7 +422,7 @@ xfs_attr_remove(
>  			&args.trans);
>  	if (error)
>  		return error;
> -	xfs_defer_init(args.trans, &dfops, &firstblock);
> +	xfs_defer_init(args.trans, &dfops, &args.trans->t_firstblock);
>  
>  	xfs_ilock(dp, XFS_ILOCK_EXCL);
>  	/*
> @@ -598,7 +593,8 @@ xfs_attr_leaf_addname(
>  		 * Commit that transaction so that the node_addname() call
>  		 * can manage its own transactions.
>  		 */
> -		xfs_defer_init(NULL, args->trans->t_dfops, args->firstblock);
> +		xfs_defer_init(args->trans, args->trans->t_dfops,
> +			       &args->trans->t_firstblock);
>  		error = xfs_attr3_leaf_to_node(args);
>  		if (error)
>  			goto out_defer_cancel;
> @@ -687,8 +683,8 @@ xfs_attr_leaf_addname(
>  		 * If the result is small enough, shrink it all into the inode.
>  		 */
>  		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			xfs_defer_init(NULL, args->trans->t_dfops,
> -				       args->firstblock);
> +			xfs_defer_init(args->trans, args->trans->t_dfops,
> +				       &args->trans->t_firstblock);
>  			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
> @@ -753,7 +749,8 @@ xfs_attr_leaf_removename(
>  	 * If the result is small enough, shrink it all into the inode.
>  	 */
>  	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -		xfs_defer_init(NULL, args->trans->t_dfops, args->firstblock);
> +		xfs_defer_init(args->trans, args->trans->t_dfops,
> +			       &args->trans->t_firstblock);
>  		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  		/* bp is gone due to xfs_da_shrink_inode */
>  		if (error)
> @@ -882,8 +879,8 @@ xfs_attr_node_addname(
>  			 */
>  			xfs_da_state_free(state);
>  			state = NULL;
> -			xfs_defer_init(NULL, args->trans->t_dfops,
> -				       args->firstblock);
> +			xfs_defer_init(args->trans, args->trans->t_dfops,
> +				       &args->trans->t_firstblock);
>  			error = xfs_attr3_leaf_to_node(args);
>  			if (error)
>  				goto out_defer_cancel;
> @@ -910,7 +907,8 @@ xfs_attr_node_addname(
>  		 * in the index/blkno/rmtblkno/rmtblkcnt fields and
>  		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
>  		 */
> -		xfs_defer_init(NULL, args->trans->t_dfops, args->firstblock);
> +		xfs_defer_init(args->trans, args->trans->t_dfops,
> +			       &args->trans->t_firstblock);
>  		error = xfs_da3_split(state);
>  		if (error)
>  			goto out_defer_cancel;
> @@ -1008,8 +1006,8 @@ xfs_attr_node_addname(
>  		 * Check to see if the tree needs to be collapsed.
>  		 */
>  		if (retval && (state->path.active > 1)) {
> -			xfs_defer_init(NULL, args->trans->t_dfops,
> -				       args->firstblock);
> +			xfs_defer_init(args->trans, args->trans->t_dfops,
> +				       &args->trans->t_firstblock);
>  			error = xfs_da3_join(state);
>  			if (error)
>  				goto out_defer_cancel;
> @@ -1134,7 +1132,8 @@ xfs_attr_node_removename(
>  	 * Check to see if the tree needs to be collapsed.
>  	 */
>  	if (retval && (state->path.active > 1)) {
> -		xfs_defer_init(NULL, args->trans->t_dfops, args->firstblock);
> +		xfs_defer_init(args->trans, args->trans->t_dfops,
> +			       &args->trans->t_firstblock);
>  		error = xfs_da3_join(state);
>  		if (error)
>  			goto out_defer_cancel;
> @@ -1166,8 +1165,8 @@ xfs_attr_node_removename(
>  			goto out;
>  
>  		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			xfs_defer_init(NULL, args->trans->t_dfops,
> -				       args->firstblock);
> +			xfs_defer_init(args->trans, args->trans->t_dfops,
> +				       &args->trans->t_firstblock);
>  			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index c131469db0f1..251304f3bc5d 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -802,7 +802,6 @@ xfs_attr_shortform_to_leaf(
>  	memset((char *)&nargs, 0, sizeof(nargs));
>  	nargs.dp = dp;
>  	nargs.geo = args->geo;
> -	nargs.firstblock = args->firstblock;
>  	nargs.total = args->total;
>  	nargs.whichfork = XFS_ATTR_FORK;
>  	nargs.trans = args->trans;
> @@ -1005,7 +1004,6 @@ xfs_attr3_leaf_to_shortform(
>  	memset((char *)&nargs, 0, sizeof(nargs));
>  	nargs.geo = args->geo;
>  	nargs.dp = dp;
> -	nargs.firstblock = args->firstblock;
>  	nargs.total = args->total;
>  	nargs.whichfork = XFS_ATTR_FORK;
>  	nargs.trans = args->trans;
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index ab7c2755ad8c..205098aeb4bc 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -480,11 +480,13 @@ xfs_attr_rmtval_set(
>  		 * extent and then crash then the block may not contain the
>  		 * correct metadata after log recovery occurs.
>  		 */
> -		xfs_defer_init(NULL, args->trans->t_dfops, args->firstblock);
> +		xfs_defer_init(args->trans, args->trans->t_dfops,
> +			       &args->trans->t_firstblock);
>  		nmap = 1;
>  		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
> -				  blkcnt, XFS_BMAPI_ATTRFORK, args->firstblock,
> -				  args->total, &map, &nmap);
> +				  blkcnt, XFS_BMAPI_ATTRFORK,
> +				  &args->trans->t_firstblock, args->total, &map,
> +				  &nmap);
>  		if (error)
>  			goto out_defer_cancel;
>  		xfs_defer_ijoin(args->trans->t_dfops, dp);
> @@ -522,7 +524,8 @@ xfs_attr_rmtval_set(
>  
>  		ASSERT(blkcnt > 0);
>  
> -		xfs_defer_init(NULL, args->trans->t_dfops, args->firstblock);
> +		xfs_defer_init(args->trans, args->trans->t_dfops,
> +			       &args->trans->t_firstblock);
>  		nmap = 1;
>  		error = xfs_bmapi_read(dp, (xfs_fileoff_t)lblkno,
>  				       blkcnt, &map, &nmap,
> @@ -626,10 +629,11 @@ xfs_attr_rmtval_remove(
>  	blkcnt = args->rmtblkcnt;
>  	done = 0;
>  	while (!done) {
> -		xfs_defer_init(NULL, args->trans->t_dfops, args->firstblock);
> +		xfs_defer_init(args->trans, args->trans->t_dfops,
> +			       &args->trans->t_firstblock);
>  		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
> -				    XFS_BMAPI_ATTRFORK, 1, args->firstblock,
> -				    &done);
> +				    XFS_BMAPI_ATTRFORK, 1,
> +				    &args->trans->t_firstblock, &done);
>  		if (error)
>  			goto out_defer_cancel;
>  		xfs_defer_ijoin(args->trans->t_dfops, args->dp);
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index fcd10b47044a..86097be47ae9 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1000,7 +1000,6 @@ xfs_bmap_add_attrfork_local(
>  		memset(&dargs, 0, sizeof(dargs));
>  		dargs.geo = ip->i_mount->m_dir_geo;
>  		dargs.dp = ip;
> -		dargs.firstblock = &tp->t_firstblock;
>  		dargs.total = dargs.geo->fsbcount;
>  		dargs.whichfork = XFS_DATA_FORK;
>  		dargs.trans = tp;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 68a72e3d9f53..2f2be86c10dc 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2059,10 +2059,9 @@ xfs_da_grow_inode_int(
>  	 * Try mapping it in one filesystem block.
>  	 */
>  	nmap = 1;
> -	ASSERT(args->firstblock != NULL);
>  	error = xfs_bmapi_write(tp, dp, *bno, count,
>  			xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
> -			args->firstblock, args->total, &map, &nmap);
> +			&tp->t_firstblock, args->total, &map, &nmap);
>  	if (error)
>  		return error;
>  
> @@ -2084,7 +2083,7 @@ xfs_da_grow_inode_int(
>  			c = (int)(*bno + count - b);
>  			error = xfs_bmapi_write(tp, dp, b, c,
>  					xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
> -					args->firstblock, args->total,
> +					&tp->t_firstblock, args->total,
>  					&mapp[mapi], &nmap);
>  			if (error)
>  				goto out_free_map;
> @@ -2394,7 +2393,7 @@ xfs_da_shrink_inode(
>  		 * the last block to the place we want to kill.
>  		 */
>  		error = xfs_bunmapi(tp, dp, dead_blkno, count,
> -				    xfs_bmapi_aflag(w), 0, args->firstblock,
> +				    xfs_bmapi_aflag(w), 0, &tp->t_firstblock,
>  				    &done);
>  		if (error == -ENOSPC) {
>  			if (w != XFS_DATA_FORK)
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 6b8a04f3f162..59e290ef334f 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -57,7 +57,6 @@ typedef struct xfs_da_args {
>  	xfs_dahash_t	hashval;	/* hash value of name */
>  	xfs_ino_t	inumber;	/* input/output inode number */
>  	struct xfs_inode *dp;		/* directory inode to manipulate */
> -	xfs_fsblock_t	*firstblock;	/* ptr to firstblock for bmap calls */
>  	struct xfs_trans *trans;	/* current trans (changes over time) */
>  	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
>  	int		whichfork;	/* data or attribute fork */
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 8a55990ca3a5..53e46fda8df4 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -271,7 +271,6 @@ xfs_dir_createname(
>  	args->total = total;
>  	args->whichfork = XFS_DATA_FORK;
>  	args->trans = tp;
> -	args->firstblock = &tp->t_firstblock;
>  	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
>  	if (!inum)
>  		args->op_flags |= XFS_DA_OP_JUSTCHECK;
> @@ -437,7 +436,6 @@ xfs_dir_removename(
>  	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
>  	args->inumber = ino;
>  	args->dp = dp;
> -	args->firstblock = &tp->t_firstblock;
>  	args->total = total;
>  	args->whichfork = XFS_DATA_FORK;
>  	args->trans = tp;
> @@ -500,7 +498,6 @@ xfs_dir_replace(
>  	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
>  	args->inumber = inum;
>  	args->dp = dp;
> -	args->firstblock = &tp->t_firstblock;
>  	args->total = total;
>  	args->whichfork = XFS_DATA_FORK;
>  	args->trans = tp;
> @@ -659,7 +656,7 @@ xfs_dir2_shrink_inode(
>  
>  	/* Unmap the fsblock(s). */
>  	error = xfs_bunmapi(tp, dp, da, args->geo->fsbcount, 0, 0,
> -			    args->firstblock, &done);
> +			    &tp->t_firstblock, &done);
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
