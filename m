Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C5D3B7CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 12:30:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4F5DF304048
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:30:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nGPip8f74hzZoWPM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 10:30:39 -0700 (PDT)
Date: Tue, 2 Aug 2016 13:30:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 17/47] xfs: rename flist/free_list to dfops
Message-ID: <20160802173037.GE54148@bfoster.bfoster>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907707745.25461.6093481173463297003.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907707745.25461.6093481173463297003.stgit@birch.djwong.org>
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

On Wed, Jul 20, 2016 at 09:57:57PM -0700, Darrick J. Wong wrote:
> Mechanical change of flist/free_list to dfops, since they're now
> deferred ops, not just a freeing list.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c        |   62 ++++++++++-----------
>  fs/xfs/libxfs/xfs_attr_leaf.c   |    4 +
>  fs/xfs/libxfs/xfs_attr_remote.c |   18 +++---
>  fs/xfs/libxfs/xfs_bmap.c        |  116 ++++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_bmap.h        |   10 ++-
>  fs/xfs/libxfs/xfs_bmap_btree.c  |   14 ++---
>  fs/xfs/libxfs/xfs_btree.h       |    4 +
>  fs/xfs/libxfs/xfs_da_btree.c    |    6 +-
>  fs/xfs/libxfs/xfs_da_btree.h    |    2 -
>  fs/xfs/libxfs/xfs_dir2.c        |   14 ++---
>  fs/xfs/libxfs/xfs_dir2.h        |    6 +-
>  fs/xfs/libxfs/xfs_ialloc.c      |   14 ++---
>  fs/xfs/libxfs/xfs_ialloc.h      |    2 -
>  fs/xfs/xfs_bmap_util.c          |   40 +++++++------
>  fs/xfs/xfs_dquot.c              |   10 ++-
>  fs/xfs/xfs_filestream.c         |    2 -
>  fs/xfs/xfs_inode.c              |   94 ++++++++++++++++----------------
>  fs/xfs/xfs_iomap.c              |   30 +++++-----
>  fs/xfs/xfs_rtalloc.c            |   10 ++-
>  fs/xfs/xfs_symlink.c            |   24 ++++----
>  20 files changed, 241 insertions(+), 241 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 66baf97..af1ecb1 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -204,7 +204,7 @@ xfs_attr_set(
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_da_args	args;
> -	struct xfs_defer_ops	flist;
> +	struct xfs_defer_ops	dfops;
>  	struct xfs_trans_res	tres;
>  	xfs_fsblock_t		firstblock;
>  	int			rsvd = (flags & ATTR_ROOT) != 0;
> @@ -222,7 +222,7 @@ xfs_attr_set(
>  	args.value = value;
>  	args.valuelen = valuelen;
>  	args.firstblock = &firstblock;
> -	args.flist = &flist;
> +	args.dfops = &dfops;
>  	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
>  	args.total = xfs_attr_calc_size(&args, &local);
>  
> @@ -317,13 +317,13 @@ xfs_attr_set(
>  		 * It won't fit in the shortform, transform to a leaf block.
>  		 * GROT: another possible req'mt for a double-split btree op.
>  		 */
> -		xfs_defer_init(args.flist, args.firstblock);
> +		xfs_defer_init(args.dfops, args.firstblock);
>  		error = xfs_attr_shortform_to_leaf(&args);
>  		if (!error)
> -			error = xfs_defer_finish(&args.trans, args.flist, dp);
> +			error = xfs_defer_finish(&args.trans, args.dfops, dp);
>  		if (error) {
>  			args.trans = NULL;
> -			xfs_defer_cancel(&flist);
> +			xfs_defer_cancel(&dfops);
>  			goto out;
>  		}
>  
> @@ -383,7 +383,7 @@ xfs_attr_remove(
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_da_args	args;
> -	struct xfs_defer_ops	flist;
> +	struct xfs_defer_ops	dfops;
>  	xfs_fsblock_t		firstblock;
>  	int			error;
>  
> @@ -400,7 +400,7 @@ xfs_attr_remove(
>  		return error;
>  
>  	args.firstblock = &firstblock;
> -	args.flist = &flist;
> +	args.dfops = &dfops;
>  
>  	/*
>  	 * we have no control over the attribute names that userspace passes us
> @@ -585,13 +585,13 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>  		 * Commit that transaction so that the node_addname() call
>  		 * can manage its own transactions.
>  		 */
> -		xfs_defer_init(args->flist, args->firstblock);
> +		xfs_defer_init(args->dfops, args->firstblock);
>  		error = xfs_attr3_leaf_to_node(args);
>  		if (!error)
> -			error = xfs_defer_finish(&args->trans, args->flist, dp);
> +			error = xfs_defer_finish(&args->trans, args->dfops, dp);
>  		if (error) {
>  			args->trans = NULL;
> -			xfs_defer_cancel(args->flist);
> +			xfs_defer_cancel(args->dfops);
>  			return error;
>  		}
>  
> @@ -675,15 +675,15 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>  		 * If the result is small enough, shrink it all into the inode.
>  		 */
>  		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			xfs_defer_init(args->flist, args->firstblock);
> +			xfs_defer_init(args->dfops, args->firstblock);
>  			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (!error)
>  				error = xfs_defer_finish(&args->trans,
> -							args->flist, dp);
> +							args->dfops, dp);
>  			if (error) {
>  				args->trans = NULL;
> -				xfs_defer_cancel(args->flist);
> +				xfs_defer_cancel(args->dfops);
>  				return error;
>  			}
>  		}
> @@ -738,14 +738,14 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
>  	 * If the result is small enough, shrink it all into the inode.
>  	 */
>  	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -		xfs_defer_init(args->flist, args->firstblock);
> +		xfs_defer_init(args->dfops, args->firstblock);
>  		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  		/* bp is gone due to xfs_da_shrink_inode */
>  		if (!error)
> -			error = xfs_defer_finish(&args->trans, args->flist, dp);
> +			error = xfs_defer_finish(&args->trans, args->dfops, dp);
>  		if (error) {
>  			args->trans = NULL;
> -			xfs_defer_cancel(args->flist);
> +			xfs_defer_cancel(args->dfops);
>  			return error;
>  		}
>  	}
> @@ -864,14 +864,14 @@ restart:
>  			 */
>  			xfs_da_state_free(state);
>  			state = NULL;
> -			xfs_defer_init(args->flist, args->firstblock);
> +			xfs_defer_init(args->dfops, args->firstblock);
>  			error = xfs_attr3_leaf_to_node(args);
>  			if (!error)
>  				error = xfs_defer_finish(&args->trans,
> -							args->flist, dp);
> +							args->dfops, dp);
>  			if (error) {
>  				args->trans = NULL;
> -				xfs_defer_cancel(args->flist);
> +				xfs_defer_cancel(args->dfops);
>  				goto out;
>  			}
>  
> @@ -892,13 +892,13 @@ restart:
>  		 * in the index/blkno/rmtblkno/rmtblkcnt fields and
>  		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
>  		 */
> -		xfs_defer_init(args->flist, args->firstblock);
> +		xfs_defer_init(args->dfops, args->firstblock);
>  		error = xfs_da3_split(state);
>  		if (!error)
> -			error = xfs_defer_finish(&args->trans, args->flist, dp);
> +			error = xfs_defer_finish(&args->trans, args->dfops, dp);
>  		if (error) {
>  			args->trans = NULL;
> -			xfs_defer_cancel(args->flist);
> +			xfs_defer_cancel(args->dfops);
>  			goto out;
>  		}
>  	} else {
> @@ -991,14 +991,14 @@ restart:
>  		 * Check to see if the tree needs to be collapsed.
>  		 */
>  		if (retval && (state->path.active > 1)) {
> -			xfs_defer_init(args->flist, args->firstblock);
> +			xfs_defer_init(args->dfops, args->firstblock);
>  			error = xfs_da3_join(state);
>  			if (!error)
>  				error = xfs_defer_finish(&args->trans,
> -							args->flist, dp);
> +							args->dfops, dp);
>  			if (error) {
>  				args->trans = NULL;
> -				xfs_defer_cancel(args->flist);
> +				xfs_defer_cancel(args->dfops);
>  				goto out;
>  			}
>  		}
> @@ -1114,13 +1114,13 @@ xfs_attr_node_removename(xfs_da_args_t *args)
>  	 * Check to see if the tree needs to be collapsed.
>  	 */
>  	if (retval && (state->path.active > 1)) {
> -		xfs_defer_init(args->flist, args->firstblock);
> +		xfs_defer_init(args->dfops, args->firstblock);
>  		error = xfs_da3_join(state);
>  		if (!error)
> -			error = xfs_defer_finish(&args->trans, args->flist, dp);
> +			error = xfs_defer_finish(&args->trans, args->dfops, dp);
>  		if (error) {
>  			args->trans = NULL;
> -			xfs_defer_cancel(args->flist);
> +			xfs_defer_cancel(args->dfops);
>  			goto out;
>  		}
>  		/*
> @@ -1147,15 +1147,15 @@ xfs_attr_node_removename(xfs_da_args_t *args)
>  			goto out;
>  
>  		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			xfs_defer_init(args->flist, args->firstblock);
> +			xfs_defer_init(args->dfops, args->firstblock);
>  			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (!error)
>  				error = xfs_defer_finish(&args->trans,
> -							args->flist, dp);
> +							args->dfops, dp);
>  			if (error) {
>  				args->trans = NULL;
> -				xfs_defer_cancel(args->flist);
> +				xfs_defer_cancel(args->dfops);
>  				goto out;
>  			}
>  		} else
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 01a5ecf..8ea91f3 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -792,7 +792,7 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
>  	nargs.dp = dp;
>  	nargs.geo = args->geo;
>  	nargs.firstblock = args->firstblock;
> -	nargs.flist = args->flist;
> +	nargs.dfops = args->dfops;
>  	nargs.total = args->total;
>  	nargs.whichfork = XFS_ATTR_FORK;
>  	nargs.trans = args->trans;
> @@ -922,7 +922,7 @@ xfs_attr3_leaf_to_shortform(
>  	nargs.geo = args->geo;
>  	nargs.dp = dp;
>  	nargs.firstblock = args->firstblock;
> -	nargs.flist = args->flist;
> +	nargs.dfops = args->dfops;
>  	nargs.total = args->total;
>  	nargs.whichfork = XFS_ATTR_FORK;
>  	nargs.trans = args->trans;
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index aabb516..d52f525 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -461,16 +461,16 @@ xfs_attr_rmtval_set(
>  		 * extent and then crash then the block may not contain the
>  		 * correct metadata after log recovery occurs.
>  		 */
> -		xfs_defer_init(args->flist, args->firstblock);
> +		xfs_defer_init(args->dfops, args->firstblock);
>  		nmap = 1;
>  		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
>  				  blkcnt, XFS_BMAPI_ATTRFORK, args->firstblock,
> -				  args->total, &map, &nmap, args->flist);
> +				  args->total, &map, &nmap, args->dfops);
>  		if (!error)
> -			error = xfs_defer_finish(&args->trans, args->flist, dp);
> +			error = xfs_defer_finish(&args->trans, args->dfops, dp);
>  		if (error) {
>  			args->trans = NULL;
> -			xfs_defer_cancel(args->flist);
> +			xfs_defer_cancel(args->dfops);
>  			return error;
>  		}
>  
> @@ -504,7 +504,7 @@ xfs_attr_rmtval_set(
>  
>  		ASSERT(blkcnt > 0);
>  
> -		xfs_defer_init(args->flist, args->firstblock);
> +		xfs_defer_init(args->dfops, args->firstblock);
>  		nmap = 1;
>  		error = xfs_bmapi_read(dp, (xfs_fileoff_t)lblkno,
>  				       blkcnt, &map, &nmap,
> @@ -604,16 +604,16 @@ xfs_attr_rmtval_remove(
>  	blkcnt = args->rmtblkcnt;
>  	done = 0;
>  	while (!done) {
> -		xfs_defer_init(args->flist, args->firstblock);
> +		xfs_defer_init(args->dfops, args->firstblock);
>  		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
>  				    XFS_BMAPI_ATTRFORK, 1, args->firstblock,
> -				    args->flist, &done);
> +				    args->dfops, &done);
>  		if (!error)
> -			error = xfs_defer_finish(&args->trans, args->flist,
> +			error = xfs_defer_finish(&args->trans, args->dfops,
>  						args->dp);
>  		if (error) {
>  			args->trans = NULL;
> -			xfs_defer_cancel(args->flist);
> +			xfs_defer_cancel(args->dfops);
>  			return error;
>  		}
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 71bf553..540a6b7 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -572,7 +572,7 @@ xfs_bmap_validate_ret(
>  void
>  xfs_bmap_add_free(
>  	struct xfs_mount	*mp,		/* mount point structure */
> -	struct xfs_defer_ops	*flist,		/* list of extents */
> +	struct xfs_defer_ops	*dfops,		/* list of extents */
>  	xfs_fsblock_t		bno,		/* fs block number of extent */
>  	xfs_filblks_t		len)		/* length of extent */
>  {
> @@ -596,7 +596,7 @@ xfs_bmap_add_free(
>  	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
>  	new->xefi_startblock = bno;
>  	new->xefi_blockcount = (xfs_extlen_t)len;
> -	xfs_defer_add(flist, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
> +	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
>  }
>  
>  /*
> @@ -649,7 +649,7 @@ xfs_bmap_btree_to_extents(
>  	cblock = XFS_BUF_TO_BLOCK(cbp);
>  	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
>  		return error;
> -	xfs_bmap_add_free(mp, cur->bc_private.b.flist, cbno, 1);
> +	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, cbno, 1);
>  	ip->i_d.di_nblocks--;
>  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
>  	xfs_trans_binval(tp, cbp);
> @@ -672,7 +672,7 @@ xfs_bmap_extents_to_btree(
>  	xfs_trans_t		*tp,		/* transaction pointer */
>  	xfs_inode_t		*ip,		/* incore inode pointer */
>  	xfs_fsblock_t		*firstblock,	/* first-block-allocated */
> -	struct xfs_defer_ops	*flist,		/* blocks freed in xaction */
> +	struct xfs_defer_ops	*dfops,		/* blocks freed in xaction */
>  	xfs_btree_cur_t		**curp,		/* cursor returned to caller */
>  	int			wasdel,		/* converting a delayed alloc */
>  	int			*logflagsp,	/* inode logging flags */
> @@ -721,7 +721,7 @@ xfs_bmap_extents_to_btree(
>  	 */
>  	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>  	cur->bc_private.b.firstblock = *firstblock;
> -	cur->bc_private.b.flist = flist;
> +	cur->bc_private.b.dfops = dfops;
>  	cur->bc_private.b.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
>  	/*
>  	 * Convert to a btree with two levels, one record in root.
> @@ -734,7 +734,7 @@ xfs_bmap_extents_to_btree(
>  	if (*firstblock == NULLFSBLOCK) {
>  		args.type = XFS_ALLOCTYPE_START_BNO;
>  		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
> -	} else if (flist->dop_low) {
> +	} else if (dfops->dop_low) {
>  		args.type = XFS_ALLOCTYPE_START_BNO;
>  		args.fsbno = *firstblock;
>  	} else {
> @@ -755,7 +755,7 @@ xfs_bmap_extents_to_btree(
>  	ASSERT(args.fsbno != NULLFSBLOCK);
>  	ASSERT(*firstblock == NULLFSBLOCK ||
>  	       args.agno == XFS_FSB_TO_AGNO(mp, *firstblock) ||
> -	       (flist->dop_low &&
> +	       (dfops->dop_low &&
>  		args.agno > XFS_FSB_TO_AGNO(mp, *firstblock)));
>  	*firstblock = cur->bc_private.b.firstblock = args.fsbno;
>  	cur->bc_private.b.allocated++;
> @@ -940,7 +940,7 @@ xfs_bmap_add_attrfork_btree(
>  	xfs_trans_t		*tp,		/* transaction pointer */
>  	xfs_inode_t		*ip,		/* incore inode pointer */
>  	xfs_fsblock_t		*firstblock,	/* first block allocated */
> -	struct xfs_defer_ops	*flist,		/* blocks to free at commit */
> +	struct xfs_defer_ops	*dfops,		/* blocks to free at commit */
>  	int			*flags)		/* inode logging flags */
>  {
>  	xfs_btree_cur_t		*cur;		/* btree cursor */
> @@ -953,7 +953,7 @@ xfs_bmap_add_attrfork_btree(
>  		*flags |= XFS_ILOG_DBROOT;
>  	else {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
> -		cur->bc_private.b.flist = flist;
> +		cur->bc_private.b.dfops = dfops;
>  		cur->bc_private.b.firstblock = *firstblock;
>  		if ((error = xfs_bmbt_lookup_ge(cur, 0, 0, 0, &stat)))
>  			goto error0;
> @@ -983,7 +983,7 @@ xfs_bmap_add_attrfork_extents(
>  	xfs_trans_t		*tp,		/* transaction pointer */
>  	xfs_inode_t		*ip,		/* incore inode pointer */
>  	xfs_fsblock_t		*firstblock,	/* first block allocated */
> -	struct xfs_defer_ops	*flist,		/* blocks to free at commit */
> +	struct xfs_defer_ops	*dfops,		/* blocks to free at commit */
>  	int			*flags)		/* inode logging flags */
>  {
>  	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
> @@ -992,7 +992,7 @@ xfs_bmap_add_attrfork_extents(
>  	if (ip->i_d.di_nextents * sizeof(xfs_bmbt_rec_t) <= XFS_IFORK_DSIZE(ip))
>  		return 0;
>  	cur = NULL;
> -	error = xfs_bmap_extents_to_btree(tp, ip, firstblock, flist, &cur, 0,
> +	error = xfs_bmap_extents_to_btree(tp, ip, firstblock, dfops, &cur, 0,
>  		flags, XFS_DATA_FORK);
>  	if (cur) {
>  		cur->bc_private.b.allocated = 0;
> @@ -1018,7 +1018,7 @@ xfs_bmap_add_attrfork_local(
>  	xfs_trans_t		*tp,		/* transaction pointer */
>  	xfs_inode_t		*ip,		/* incore inode pointer */
>  	xfs_fsblock_t		*firstblock,	/* first block allocated */
> -	struct xfs_defer_ops	*flist,		/* blocks to free at commit */
> +	struct xfs_defer_ops	*dfops,		/* blocks to free at commit */
>  	int			*flags)		/* inode logging flags */
>  {
>  	xfs_da_args_t		dargs;		/* args for dir/attr code */
> @@ -1031,7 +1031,7 @@ xfs_bmap_add_attrfork_local(
>  		dargs.geo = ip->i_mount->m_dir_geo;
>  		dargs.dp = ip;
>  		dargs.firstblock = firstblock;
> -		dargs.flist = flist;
> +		dargs.dfops = dfops;
>  		dargs.total = dargs.geo->fsbcount;
>  		dargs.whichfork = XFS_DATA_FORK;
>  		dargs.trans = tp;
> @@ -1059,7 +1059,7 @@ xfs_bmap_add_attrfork(
>  	int			rsvd)		/* xact may use reserved blks */
>  {
>  	xfs_fsblock_t		firstblock;	/* 1st block/ag allocated */
> -	struct xfs_defer_ops	flist;		/* freed extent records */
> +	struct xfs_defer_ops	dfops;		/* freed extent records */
>  	xfs_mount_t		*mp;		/* mount structure */
>  	xfs_trans_t		*tp;		/* transaction pointer */
>  	int			blks;		/* space reservation */
> @@ -1125,18 +1125,18 @@ xfs_bmap_add_attrfork(
>  	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
>  	ip->i_afp->if_flags = XFS_IFEXTENTS;
>  	logflags = 0;
> -	xfs_defer_init(&flist, &firstblock);
> +	xfs_defer_init(&dfops, &firstblock);
>  	switch (ip->i_d.di_format) {
>  	case XFS_DINODE_FMT_LOCAL:
> -		error = xfs_bmap_add_attrfork_local(tp, ip, &firstblock, &flist,
> +		error = xfs_bmap_add_attrfork_local(tp, ip, &firstblock, &dfops,
>  			&logflags);
>  		break;
>  	case XFS_DINODE_FMT_EXTENTS:
>  		error = xfs_bmap_add_attrfork_extents(tp, ip, &firstblock,
> -			&flist, &logflags);
> +			&dfops, &logflags);
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
> -		error = xfs_bmap_add_attrfork_btree(tp, ip, &firstblock, &flist,
> +		error = xfs_bmap_add_attrfork_btree(tp, ip, &firstblock, &dfops,
>  			&logflags);
>  		break;
>  	default:
> @@ -1165,7 +1165,7 @@ xfs_bmap_add_attrfork(
>  			xfs_log_sb(tp);
>  	}
>  
> -	error = xfs_defer_finish(&tp, &flist, NULL);
> +	error = xfs_defer_finish(&tp, &dfops, NULL);
>  	if (error)
>  		goto bmap_cancel;
>  	error = xfs_trans_commit(tp);
> @@ -1173,7 +1173,7 @@ xfs_bmap_add_attrfork(
>  	return error;
>  
>  bmap_cancel:
> -	xfs_defer_cancel(&flist);
> +	xfs_defer_cancel(&dfops);
>  trans_cancel:
>  	xfs_trans_cancel(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -1970,7 +1970,7 @@ xfs_bmap_add_extent_delay_real(
>  
>  		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
>  			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
> -					bma->firstblock, bma->flist,
> +					bma->firstblock, bma->dfops,
>  					&bma->cur, 1, &tmp_rval, whichfork);
>  			rval |= tmp_rval;
>  			if (error)
> @@ -2054,7 +2054,7 @@ xfs_bmap_add_extent_delay_real(
>  
>  		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
>  			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
> -				bma->firstblock, bma->flist, &bma->cur, 1,
> +				bma->firstblock, bma->dfops, &bma->cur, 1,
>  				&tmp_rval, whichfork);
>  			rval |= tmp_rval;
>  			if (error)
> @@ -2123,7 +2123,7 @@ xfs_bmap_add_extent_delay_real(
>  
>  		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
>  			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
> -					bma->firstblock, bma->flist, &bma->cur,
> +					bma->firstblock, bma->dfops, &bma->cur,
>  					1, &tmp_rval, whichfork);
>  			rval |= tmp_rval;
>  			if (error)
> @@ -2172,7 +2172,7 @@ xfs_bmap_add_extent_delay_real(
>  
>  		ASSERT(bma->cur == NULL);
>  		error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
> -				bma->firstblock, bma->flist, &bma->cur,
> +				bma->firstblock, bma->dfops, &bma->cur,
>  				da_old > 0, &tmp_logflags, whichfork);
>  		bma->logflags |= tmp_logflags;
>  		if (error)
> @@ -2214,7 +2214,7 @@ xfs_bmap_add_extent_unwritten_real(
>  	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
>  	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
>  	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
> -	struct xfs_defer_ops	*flist,	/* list of extents to be freed */
> +	struct xfs_defer_ops	*dfops,	/* list of extents to be freed */
>  	int			*logflagsp) /* inode logging flags */
>  {
>  	xfs_btree_cur_t		*cur;	/* btree cursor */
> @@ -2707,7 +2707,7 @@ xfs_bmap_add_extent_unwritten_real(
>  		int	tmp_logflags;	/* partial log flag return val */
>  
>  		ASSERT(cur == NULL);
> -		error = xfs_bmap_extents_to_btree(tp, ip, first, flist, &cur,
> +		error = xfs_bmap_extents_to_btree(tp, ip, first, dfops, &cur,
>  				0, &tmp_logflags, XFS_DATA_FORK);
>  		*logflagsp |= tmp_logflags;
>  		if (error)
> @@ -3100,7 +3100,7 @@ xfs_bmap_add_extent_hole_real(
>  
>  		ASSERT(bma->cur == NULL);
>  		error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
> -				bma->firstblock, bma->flist, &bma->cur,
> +				bma->firstblock, bma->dfops, &bma->cur,
>  				0, &tmp_logflags, whichfork);
>  		bma->logflags |= tmp_logflags;
>  		if (error)
> @@ -3675,7 +3675,7 @@ xfs_bmap_btalloc(
>  			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
>  		if (error)
>  			return error;
> -	} else if (ap->flist->dop_low) {
> +	} else if (ap->dfops->dop_low) {
>  		if (xfs_inode_is_filestream(ap->ip))
>  			args.type = XFS_ALLOCTYPE_FIRST_AG;
>  		else
> @@ -3708,7 +3708,7 @@ xfs_bmap_btalloc(
>  	 * is >= the stripe unit and the allocation offset is
>  	 * at the end of file.
>  	 */
> -	if (!ap->flist->dop_low && ap->aeof) {
> +	if (!ap->dfops->dop_low && ap->aeof) {
>  		if (!ap->offset) {
>  			args.alignment = stripe_align;
>  			atype = args.type;
> @@ -3801,7 +3801,7 @@ xfs_bmap_btalloc(
>  		args.minleft = 0;
>  		if ((error = xfs_alloc_vextent(&args)))
>  			return error;
> -		ap->flist->dop_low = true;
> +		ap->dfops->dop_low = true;
>  	}
>  	if (args.fsbno != NULLFSBLOCK) {
>  		/*
> @@ -3811,7 +3811,7 @@ xfs_bmap_btalloc(
>  		ASSERT(*ap->firstblock == NULLFSBLOCK ||
>  		       XFS_FSB_TO_AGNO(mp, *ap->firstblock) ==
>  		       XFS_FSB_TO_AGNO(mp, args.fsbno) ||
> -		       (ap->flist->dop_low &&
> +		       (ap->dfops->dop_low &&
>  			XFS_FSB_TO_AGNO(mp, *ap->firstblock) <
>  			XFS_FSB_TO_AGNO(mp, args.fsbno)));
>  
> @@ -3819,7 +3819,7 @@ xfs_bmap_btalloc(
>  		if (*ap->firstblock == NULLFSBLOCK)
>  			*ap->firstblock = args.fsbno;
>  		ASSERT(nullfb || fb_agno == args.agno ||
> -		       (ap->flist->dop_low && fb_agno < args.agno));
> +		       (ap->dfops->dop_low && fb_agno < args.agno));
>  		ap->length = args.len;
>  		ap->ip->i_d.di_nblocks += args.len;
>  		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
> @@ -4286,7 +4286,7 @@ xfs_bmapi_allocate(
>  	if (error)
>  		return error;
>  
> -	if (bma->flist->dop_low)
> +	if (bma->dfops->dop_low)
>  		bma->minleft = 0;
>  	if (bma->cur)
>  		bma->cur->bc_private.b.firstblock = *bma->firstblock;
> @@ -4295,7 +4295,7 @@ xfs_bmapi_allocate(
>  	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur) {
>  		bma->cur = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
>  		bma->cur->bc_private.b.firstblock = *bma->firstblock;
> -		bma->cur->bc_private.b.flist = bma->flist;
> +		bma->cur->bc_private.b.dfops = bma->dfops;
>  	}
>  	/*
>  	 * Bump the number of extents we've allocated
> @@ -4376,7 +4376,7 @@ xfs_bmapi_convert_unwritten(
>  		bma->cur = xfs_bmbt_init_cursor(bma->ip->i_mount, bma->tp,
>  					bma->ip, whichfork);
>  		bma->cur->bc_private.b.firstblock = *bma->firstblock;
> -		bma->cur->bc_private.b.flist = bma->flist;
> +		bma->cur->bc_private.b.dfops = bma->dfops;
>  	}
>  	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
>  				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
> @@ -4393,7 +4393,7 @@ xfs_bmapi_convert_unwritten(
>  	}
>  
>  	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, &bma->idx,
> -			&bma->cur, mval, bma->firstblock, bma->flist,
> +			&bma->cur, mval, bma->firstblock, bma->dfops,
>  			&tmp_logflags);
>  	/*
>  	 * Log the inode core unconditionally in the unwritten extent conversion
> @@ -4447,7 +4447,7 @@ xfs_bmapi_write(
>  	xfs_extlen_t		total,		/* total blocks needed */
>  	struct xfs_bmbt_irec	*mval,		/* output: map values */
>  	int			*nmap,		/* i/o: mval size/count */
> -	struct xfs_defer_ops	*flist)		/* i/o: list extents to free */
> +	struct xfs_defer_ops	*dfops)		/* i/o: list extents to free */
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp;
> @@ -4537,7 +4537,7 @@ xfs_bmapi_write(
>  	bma.ip = ip;
>  	bma.total = total;
>  	bma.userdata = 0;
> -	bma.flist = flist;
> +	bma.dfops = dfops;
>  	bma.firstblock = firstblock;
>  
>  	while (bno < end && n < *nmap) {
> @@ -4651,7 +4651,7 @@ error0:
>  			       XFS_FSB_TO_AGNO(mp, *firstblock) ==
>  			       XFS_FSB_TO_AGNO(mp,
>  				       bma.cur->bc_private.b.firstblock) ||
> -			       (flist->dop_low &&
> +			       (dfops->dop_low &&
>  				XFS_FSB_TO_AGNO(mp, *firstblock) <
>  				XFS_FSB_TO_AGNO(mp,
>  					bma.cur->bc_private.b.firstblock)));
> @@ -4735,7 +4735,7 @@ xfs_bmap_del_extent(
>  	xfs_inode_t		*ip,	/* incore inode pointer */
>  	xfs_trans_t		*tp,	/* current transaction pointer */
>  	xfs_extnum_t		*idx,	/* extent number to update/delete */
> -	struct xfs_defer_ops	*flist,	/* list of extents to be freed */
> +	struct xfs_defer_ops	*dfops,	/* list of extents to be freed */
>  	xfs_btree_cur_t		*cur,	/* if null, not a btree */
>  	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
>  	int			*logflagsp, /* inode logging flags */
> @@ -5023,7 +5023,7 @@ xfs_bmap_del_extent(
>  	 * If we need to, add to list of extents to delete.
>  	 */
>  	if (do_fx)
> -		xfs_bmap_add_free(mp, flist, del->br_startblock,
> +		xfs_bmap_add_free(mp, dfops, del->br_startblock,
>  			del->br_blockcount);
>  	/*
>  	 * Adjust inode # blocks in the file.
> @@ -5064,7 +5064,7 @@ xfs_bunmapi(
>  	xfs_extnum_t		nexts,		/* number of extents max */
>  	xfs_fsblock_t		*firstblock,	/* first allocated block
>  						   controls a.g. for allocs */
> -	struct xfs_defer_ops	*flist,		/* i/o: list extents to free */
> +	struct xfs_defer_ops	*dfops,		/* i/o: list extents to free */
>  	int			*done)		/* set if not done yet */
>  {
>  	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
> @@ -5137,7 +5137,7 @@ xfs_bunmapi(
>  		ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>  		cur->bc_private.b.firstblock = *firstblock;
> -		cur->bc_private.b.flist = flist;
> +		cur->bc_private.b.dfops = dfops;
>  		cur->bc_private.b.flags = 0;
>  	} else
>  		cur = NULL;
> @@ -5231,7 +5231,7 @@ xfs_bunmapi(
>  			}
>  			del.br_state = XFS_EXT_UNWRITTEN;
>  			error = xfs_bmap_add_extent_unwritten_real(tp, ip,
> -					&lastx, &cur, &del, firstblock, flist,
> +					&lastx, &cur, &del, firstblock, dfops,
>  					&logflags);
>  			if (error)
>  				goto error0;
> @@ -5290,7 +5290,7 @@ xfs_bunmapi(
>  				lastx--;
>  				error = xfs_bmap_add_extent_unwritten_real(tp,
>  						ip, &lastx, &cur, &prev,
> -						firstblock, flist, &logflags);
> +						firstblock, dfops, &logflags);
>  				if (error)
>  					goto error0;
>  				goto nodelete;
> @@ -5299,7 +5299,7 @@ xfs_bunmapi(
>  				del.br_state = XFS_EXT_UNWRITTEN;
>  				error = xfs_bmap_add_extent_unwritten_real(tp,
>  						ip, &lastx, &cur, &del,
> -						firstblock, flist, &logflags);
> +						firstblock, dfops, &logflags);
>  				if (error)
>  					goto error0;
>  				goto nodelete;
> @@ -5357,7 +5357,7 @@ xfs_bunmapi(
>  		} else if (cur)
>  			cur->bc_private.b.flags &= ~XFS_BTCUR_BPRV_WASDEL;
>  
> -		error = xfs_bmap_del_extent(ip, tp, &lastx, flist, cur, &del,
> +		error = xfs_bmap_del_extent(ip, tp, &lastx, dfops, cur, &del,
>  				&tmp_logflags, whichfork);
>  		logflags |= tmp_logflags;
>  		if (error)
> @@ -5391,7 +5391,7 @@ nodelete:
>  	 */
>  	if (xfs_bmap_needs_btree(ip, whichfork)) {
>  		ASSERT(cur == NULL);
> -		error = xfs_bmap_extents_to_btree(tp, ip, firstblock, flist,
> +		error = xfs_bmap_extents_to_btree(tp, ip, firstblock, dfops,
>  			&cur, 0, &tmp_logflags, whichfork);
>  		logflags |= tmp_logflags;
>  		if (error)
> @@ -5680,7 +5680,7 @@ xfs_bmap_shift_extents(
>  	int			*done,
>  	xfs_fileoff_t		stop_fsb,
>  	xfs_fsblock_t		*firstblock,
> -	struct xfs_defer_ops	*flist,
> +	struct xfs_defer_ops	*dfops,
>  	enum shift_direction	direction,
>  	int			num_exts)
>  {
> @@ -5725,7 +5725,7 @@ xfs_bmap_shift_extents(
>  	if (ifp->if_flags & XFS_IFBROOT) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>  		cur->bc_private.b.firstblock = *firstblock;
> -		cur->bc_private.b.flist = flist;
> +		cur->bc_private.b.dfops = dfops;
>  		cur->bc_private.b.flags = 0;
>  	}
>  
> @@ -5834,7 +5834,7 @@ xfs_bmap_split_extent_at(
>  	struct xfs_inode	*ip,
>  	xfs_fileoff_t		split_fsb,
>  	xfs_fsblock_t		*firstfsb,
> -	struct xfs_defer_ops	*free_list)
> +	struct xfs_defer_ops	*dfops)
>  {
>  	int				whichfork = XFS_DATA_FORK;
>  	struct xfs_btree_cur		*cur = NULL;
> @@ -5896,7 +5896,7 @@ xfs_bmap_split_extent_at(
>  	if (ifp->if_flags & XFS_IFBROOT) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>  		cur->bc_private.b.firstblock = *firstfsb;
> -		cur->bc_private.b.flist = free_list;
> +		cur->bc_private.b.dfops = dfops;
>  		cur->bc_private.b.flags = 0;
>  		error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
>  				got.br_startblock,
> @@ -5949,7 +5949,7 @@ xfs_bmap_split_extent_at(
>  		int tmp_logflags; /* partial log flag return val */
>  
>  		ASSERT(cur == NULL);
> -		error = xfs_bmap_extents_to_btree(tp, ip, firstfsb, free_list,
> +		error = xfs_bmap_extents_to_btree(tp, ip, firstfsb, dfops,
>  				&cur, 0, &tmp_logflags, whichfork);
>  		logflags |= tmp_logflags;
>  	}
> @@ -5973,7 +5973,7 @@ xfs_bmap_split_extent(
>  {
>  	struct xfs_mount        *mp = ip->i_mount;
>  	struct xfs_trans        *tp;
> -	struct xfs_defer_ops    free_list;
> +	struct xfs_defer_ops    dfops;
>  	xfs_fsblock_t           firstfsb;
>  	int                     error;
>  
> @@ -5985,21 +5985,21 @@ xfs_bmap_split_extent(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
> -	xfs_defer_init(&free_list, &firstfsb);
> +	xfs_defer_init(&dfops, &firstfsb);
>  
>  	error = xfs_bmap_split_extent_at(tp, ip, split_fsb,
> -			&firstfsb, &free_list);
> +			&firstfsb, &dfops);
>  	if (error)
>  		goto out;
>  
> -	error = xfs_defer_finish(&tp, &free_list, NULL);
> +	error = xfs_defer_finish(&tp, &dfops, NULL);
>  	if (error)
>  		goto out;
>  
>  	return xfs_trans_commit(tp);
>  
>  out:
> -	xfs_defer_cancel(&free_list);
> +	xfs_defer_cancel(&dfops);
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 3dc8393..dc01bb8 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -32,7 +32,7 @@ extern kmem_zone_t	*xfs_bmap_free_item_zone;
>   */
>  struct xfs_bmalloca {
>  	xfs_fsblock_t		*firstblock; /* i/o first block allocated */
> -	struct xfs_defer_ops	*flist;	/* bmap freelist */
> +	struct xfs_defer_ops	*dfops;	/* bmap freelist */
>  	struct xfs_trans	*tp;	/* transaction pointer */
>  	struct xfs_inode	*ip;	/* incore inode pointer */
>  	struct xfs_bmbt_irec	prev;	/* extent before the new one */
> @@ -164,7 +164,7 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
>  
>  int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
>  void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
> -void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *flist,
> +void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
>  			  xfs_fsblock_t bno, xfs_filblks_t len);
>  void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
>  int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
> @@ -186,18 +186,18 @@ int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
>  		xfs_fsblock_t *firstblock, xfs_extlen_t total,
>  		struct xfs_bmbt_irec *mval, int *nmap,
> -		struct xfs_defer_ops *flist);
> +		struct xfs_defer_ops *dfops);
>  int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
>  		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
> -		struct xfs_defer_ops *flist, int *done);
> +		struct xfs_defer_ops *dfops, int *done);
>  int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
>  		xfs_extnum_t num);
>  uint	xfs_default_attroffset(struct xfs_inode *ip);
>  int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
>  		int *done, xfs_fileoff_t stop_fsb, xfs_fsblock_t *firstblock,
> -		struct xfs_defer_ops *flist, enum shift_direction direction,
> +		struct xfs_defer_ops *dfops, enum shift_direction direction,
>  		int num_exts);
>  int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 1b7ba73..0df5318 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -407,11 +407,11 @@ xfs_bmbt_dup_cursor(
>  			cur->bc_private.b.ip, cur->bc_private.b.whichfork);
>  
>  	/*
> -	 * Copy the firstblock, flist, and flags values,
> +	 * Copy the firstblock, dfops, and flags values,
>  	 * since init cursor doesn't get them.
>  	 */
>  	new->bc_private.b.firstblock = cur->bc_private.b.firstblock;
> -	new->bc_private.b.flist = cur->bc_private.b.flist;
> +	new->bc_private.b.dfops = cur->bc_private.b.dfops;
>  	new->bc_private.b.flags = cur->bc_private.b.flags;
>  
>  	return new;
> @@ -424,7 +424,7 @@ xfs_bmbt_update_cursor(
>  {
>  	ASSERT((dst->bc_private.b.firstblock != NULLFSBLOCK) ||
>  	       (dst->bc_private.b.ip->i_d.di_flags & XFS_DIFLAG_REALTIME));
> -	ASSERT(dst->bc_private.b.flist == src->bc_private.b.flist);
> +	ASSERT(dst->bc_private.b.dfops == src->bc_private.b.dfops);
>  
>  	dst->bc_private.b.allocated += src->bc_private.b.allocated;
>  	dst->bc_private.b.firstblock = src->bc_private.b.firstblock;
> @@ -463,7 +463,7 @@ xfs_bmbt_alloc_block(
>  		 * block allocation here and corrupt the filesystem.
>  		 */
>  		args.minleft = args.tp->t_blk_res;
> -	} else if (cur->bc_private.b.flist->dop_low) {
> +	} else if (cur->bc_private.b.dfops->dop_low) {
>  		args.type = XFS_ALLOCTYPE_START_BNO;
>  	} else {
>  		args.type = XFS_ALLOCTYPE_NEAR_BNO;
> @@ -491,7 +491,7 @@ xfs_bmbt_alloc_block(
>  		error = xfs_alloc_vextent(&args);
>  		if (error)
>  			goto error0;
> -		cur->bc_private.b.flist->dop_low = true;
> +		cur->bc_private.b.dfops->dop_low = true;
>  	}
>  	if (args.fsbno == NULLFSBLOCK) {
>  		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> @@ -527,7 +527,7 @@ xfs_bmbt_free_block(
>  	struct xfs_trans	*tp = cur->bc_tp;
>  	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
>  
> -	xfs_bmap_add_free(mp, cur->bc_private.b.flist, fsbno, 1);
> +	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, fsbno, 1);
>  	ip->i_d.di_nblocks--;
>  
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> @@ -793,7 +793,7 @@ xfs_bmbt_init_cursor(
>  	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
>  	cur->bc_private.b.ip = ip;
>  	cur->bc_private.b.firstblock = NULLFSBLOCK;
> -	cur->bc_private.b.flist = NULL;
> +	cur->bc_private.b.dfops = NULL;
>  	cur->bc_private.b.allocated = 0;
>  	cur->bc_private.b.flags = 0;
>  	cur->bc_private.b.whichfork = whichfork;
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 6713af3..b8bbb21 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -255,12 +255,12 @@ typedef struct xfs_btree_cur
>  	union {
>  		struct {			/* needed for BNO, CNT, INO */
>  			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
> -			struct xfs_defer_ops *flist;	/* deferred updates */
> +			struct xfs_defer_ops *dfops;	/* deferred updates */
>  			xfs_agnumber_t	agno;	/* ag number */
>  		} a;
>  		struct {			/* needed for BMAP */
>  			struct xfs_inode *ip;	/* pointer to our inode */
> -			struct xfs_defer_ops *flist;	/* deferred updates */
> +			struct xfs_defer_ops *dfops;	/* deferred updates */
>  			xfs_fsblock_t	firstblock;	/* 1st blk allocated */
>  			int		allocated;	/* count of alloced */
>  			short		forksize;	/* fork's inode space */
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 097bf77..68594c7 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2030,7 +2030,7 @@ xfs_da_grow_inode_int(
>  	error = xfs_bmapi_write(tp, dp, *bno, count,
>  			xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
>  			args->firstblock, args->total, &map, &nmap,
> -			args->flist);
> +			args->dfops);
>  	if (error)
>  		return error;
>  
> @@ -2053,7 +2053,7 @@ xfs_da_grow_inode_int(
>  			error = xfs_bmapi_write(tp, dp, b, c,
>  					xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
>  					args->firstblock, args->total,
> -					&mapp[mapi], &nmap, args->flist);
> +					&mapp[mapi], &nmap, args->dfops);
>  			if (error)
>  				goto out_free_map;
>  			if (nmap < 1)
> @@ -2363,7 +2363,7 @@ xfs_da_shrink_inode(
>  		 */
>  		error = xfs_bunmapi(tp, dp, dead_blkno, count,
>  				    xfs_bmapi_aflag(w), 0, args->firstblock,
> -				    args->flist, &done);
> +				    args->dfops, &done);
>  		if (error == -ENOSPC) {
>  			if (w != XFS_DATA_FORK)
>  				break;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 249813a..98c75cb 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -70,7 +70,7 @@ typedef struct xfs_da_args {
>  	xfs_ino_t	inumber;	/* input/output inode number */
>  	struct xfs_inode *dp;		/* directory inode to manipulate */
>  	xfs_fsblock_t	*firstblock;	/* ptr to firstblock for bmap calls */
> -	struct xfs_defer_ops *flist;	/* ptr to freelist for bmap_finish */
> +	struct xfs_defer_ops *dfops;	/* ptr to freelist for bmap_finish */
>  	struct xfs_trans *trans;	/* current trans (changes over time) */
>  	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
>  	int		whichfork;	/* data or attribute fork */
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 0523100..20a96dd 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -260,7 +260,7 @@ xfs_dir_createname(
>  	struct xfs_name		*name,
>  	xfs_ino_t		inum,		/* new entry inode number */
>  	xfs_fsblock_t		*first,		/* bmap's firstblock */
> -	struct xfs_defer_ops	*flist,		/* bmap's freeblock list */
> +	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
>  	xfs_extlen_t		total)		/* bmap's total block count */
>  {
>  	struct xfs_da_args	*args;
> @@ -287,7 +287,7 @@ xfs_dir_createname(
>  	args->inumber = inum;
>  	args->dp = dp;
>  	args->firstblock = first;
> -	args->flist = flist;
> +	args->dfops = dfops;
>  	args->total = total;
>  	args->whichfork = XFS_DATA_FORK;
>  	args->trans = tp;
> @@ -437,7 +437,7 @@ xfs_dir_removename(
>  	struct xfs_name	*name,
>  	xfs_ino_t	ino,
>  	xfs_fsblock_t	*first,		/* bmap's firstblock */
> -	struct xfs_defer_ops	*flist,		/* bmap's freeblock list */
> +	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
>  	xfs_extlen_t	total)		/* bmap's total block count */
>  {
>  	struct xfs_da_args *args;
> @@ -459,7 +459,7 @@ xfs_dir_removename(
>  	args->inumber = ino;
>  	args->dp = dp;
>  	args->firstblock = first;
> -	args->flist = flist;
> +	args->dfops = dfops;
>  	args->total = total;
>  	args->whichfork = XFS_DATA_FORK;
>  	args->trans = tp;
> @@ -499,7 +499,7 @@ xfs_dir_replace(
>  	struct xfs_name	*name,		/* name of entry to replace */
>  	xfs_ino_t	inum,		/* new inode number */
>  	xfs_fsblock_t	*first,		/* bmap's firstblock */
> -	struct xfs_defer_ops	*flist,		/* bmap's freeblock list */
> +	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
>  	xfs_extlen_t	total)		/* bmap's total block count */
>  {
>  	struct xfs_da_args *args;
> @@ -524,7 +524,7 @@ xfs_dir_replace(
>  	args->inumber = inum;
>  	args->dp = dp;
>  	args->firstblock = first;
> -	args->flist = flist;
> +	args->dfops = dfops;
>  	args->total = total;
>  	args->whichfork = XFS_DATA_FORK;
>  	args->trans = tp;
> @@ -681,7 +681,7 @@ xfs_dir2_shrink_inode(
>  
>  	/* Unmap the fsblock(s). */
>  	error = xfs_bunmapi(tp, dp, da, args->geo->fsbcount, 0, 0,
> -			    args->firstblock, args->flist, &done);
> +			    args->firstblock, args->dfops, &done);
>  	if (error) {
>  		/*
>  		 * ENOSPC actually can happen if we're in a removename with no
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index c272f1a..becc926 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -129,18 +129,18 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
>  extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
>  				struct xfs_name *name, xfs_ino_t inum,
>  				xfs_fsblock_t *first,
> -				struct xfs_defer_ops *flist, xfs_extlen_t tot);
> +				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
>  extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
>  				struct xfs_name *name, xfs_ino_t *inum,
>  				struct xfs_name *ci_name);
>  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
>  				struct xfs_name *name, xfs_ino_t ino,
>  				xfs_fsblock_t *first,
> -				struct xfs_defer_ops *flist, xfs_extlen_t tot);
> +				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
>  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
>  				struct xfs_name *name, xfs_ino_t inum,
>  				xfs_fsblock_t *first,
> -				struct xfs_defer_ops *flist, xfs_extlen_t tot);
> +				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
>  extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
>  				struct xfs_name *name);
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 972b2ea..f0e1f71 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1818,7 +1818,7 @@ xfs_difree_inode_chunk(
>  	struct xfs_mount		*mp,
>  	xfs_agnumber_t			agno,
>  	struct xfs_inobt_rec_incore	*rec,
> -	struct xfs_defer_ops		*flist)
> +	struct xfs_defer_ops		*dfops)
>  {
>  	xfs_agblock_t	sagbno = XFS_AGINO_TO_AGBNO(mp, rec->ir_startino);
>  	int		startidx, endidx;
> @@ -1829,7 +1829,7 @@ xfs_difree_inode_chunk(
>  
>  	if (!xfs_inobt_issparse(rec->ir_holemask)) {
>  		/* not sparse, calculate extent info directly */
> -		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, sagbno),
> +		xfs_bmap_add_free(mp, dfops, XFS_AGB_TO_FSB(mp, agno, sagbno),
>  				  mp->m_ialloc_blks);
>  		return;
>  	}
> @@ -1873,7 +1873,7 @@ xfs_difree_inode_chunk(
>  
>  		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
>  		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
> -		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, agbno),
> +		xfs_bmap_add_free(mp, dfops, XFS_AGB_TO_FSB(mp, agno, agbno),
>  				  contigblk);
>  
>  		/* reset range to current bit and carry on... */
> @@ -1890,7 +1890,7 @@ xfs_difree_inobt(
>  	struct xfs_trans		*tp,
>  	struct xfs_buf			*agbp,
>  	xfs_agino_t			agino,
> -	struct xfs_defer_ops		*flist,
> +	struct xfs_defer_ops		*dfops,
>  	struct xfs_icluster		*xic,
>  	struct xfs_inobt_rec_incore	*orec)
>  {
> @@ -1977,7 +1977,7 @@ xfs_difree_inobt(
>  			goto error0;
>  		}
>  
> -		xfs_difree_inode_chunk(mp, agno, &rec, flist);
> +		xfs_difree_inode_chunk(mp, agno, &rec, dfops);
>  	} else {
>  		xic->deleted = 0;
>  
> @@ -2122,7 +2122,7 @@ int
>  xfs_difree(
>  	struct xfs_trans	*tp,		/* transaction pointer */
>  	xfs_ino_t		inode,		/* inode to be freed */
> -	struct xfs_defer_ops	*flist,		/* extents to free */
> +	struct xfs_defer_ops	*dfops,		/* extents to free */
>  	struct xfs_icluster	*xic)	/* cluster info if deleted */
>  {
>  	/* REFERENCED */
> @@ -2174,7 +2174,7 @@ xfs_difree(
>  	/*
>  	 * Fix up the inode allocation btree.
>  	 */
> -	error = xfs_difree_inobt(mp, tp, agbp, agino, flist, xic, &rec);
> +	error = xfs_difree_inobt(mp, tp, agbp, agino, dfops, xic, &rec);
>  	if (error)
>  		goto error0;
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 2e06b67..0bb8966 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -95,7 +95,7 @@ int					/* error */
>  xfs_difree(
>  	struct xfs_trans *tp,		/* transaction pointer */
>  	xfs_ino_t	inode,		/* inode to be freed */
> -	struct xfs_defer_ops *flist,	/* extents to free */
> +	struct xfs_defer_ops *dfops,	/* extents to free */
>  	struct xfs_icluster *ifree);	/* cluster info if deleted */
>  
>  /*
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 07954e8..3bbe46b 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -685,7 +685,7 @@ xfs_bmap_punch_delalloc_range(
>  		xfs_bmbt_irec_t	imap;
>  		int		nimaps = 1;
>  		xfs_fsblock_t	firstblock;
> -		struct xfs_defer_ops flist;
> +		struct xfs_defer_ops dfops;
>  
>  		/*
>  		 * Map the range first and check that it is a delalloc extent
> @@ -716,18 +716,18 @@ xfs_bmap_punch_delalloc_range(
>  		WARN_ON(imap.br_blockcount == 0);
>  
>  		/*
> -		 * Note: while we initialise the firstblock/flist pair, they
> +		 * Note: while we initialise the firstblock/dfops pair, they
>  		 * should never be used because blocks should never be
>  		 * allocated or freed for a delalloc extent and hence we need
>  		 * don't cancel or finish them after the xfs_bunmapi() call.
>  		 */
> -		xfs_defer_init(&flist, &firstblock);
> +		xfs_defer_init(&dfops, &firstblock);
>  		error = xfs_bunmapi(NULL, ip, start_fsb, 1, 0, 1, &firstblock,
> -					&flist, &done);
> +					&dfops, &done);
>  		if (error)
>  			break;
>  
> -		ASSERT(!xfs_defer_has_unfinished_work(&flist));
> +		ASSERT(!xfs_defer_has_unfinished_work(&dfops));
>  next_block:
>  		start_fsb++;
>  		remaining--;
> @@ -884,7 +884,7 @@ xfs_alloc_file_space(
>  	int			rt;
>  	xfs_trans_t		*tp;
>  	xfs_bmbt_irec_t		imaps[1], *imapp;
> -	struct xfs_defer_ops	free_list;
> +	struct xfs_defer_ops	dfops;
>  	uint			qblocks, resblks, resrtextents;
>  	int			error;
>  
> @@ -975,17 +975,17 @@ xfs_alloc_file_space(
>  
>  		xfs_trans_ijoin(tp, ip, 0);
>  
> -		xfs_defer_init(&free_list, &firstfsb);
> +		xfs_defer_init(&dfops, &firstfsb);
>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
>  					allocatesize_fsb, alloc_type, &firstfsb,
> -					resblks, imapp, &nimaps, &free_list);
> +					resblks, imapp, &nimaps, &dfops);
>  		if (error)
>  			goto error0;
>  
>  		/*
>  		 * Complete the transaction
>  		 */
> -		error = xfs_defer_finish(&tp, &free_list, NULL);
> +		error = xfs_defer_finish(&tp, &dfops, NULL);
>  		if (error)
>  			goto error0;
>  
> @@ -1008,7 +1008,7 @@ xfs_alloc_file_space(
>  	return error;
>  
>  error0:	/* Cancel bmap, unlock inode, unreserve quota blocks, cancel trans */
> -	xfs_defer_cancel(&free_list);
> +	xfs_defer_cancel(&dfops);
>  	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
>  
>  error1:	/* Just cancel transaction */
> @@ -1026,7 +1026,7 @@ xfs_unmap_extent(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
> -	struct xfs_defer_ops	free_list;
> +	struct xfs_defer_ops	dfops;
>  	xfs_fsblock_t		firstfsb;
>  	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
>  	int			error;
> @@ -1045,13 +1045,13 @@ xfs_unmap_extent(
>  
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	xfs_defer_init(&free_list, &firstfsb);
> +	xfs_defer_init(&dfops, &firstfsb);
>  	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, &firstfsb,
> -			&free_list, done);
> +			&dfops, done);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> -	error = xfs_defer_finish(&tp, &free_list, ip);
> +	error = xfs_defer_finish(&tp, &dfops, ip);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> @@ -1061,7 +1061,7 @@ out_unlock:
>  	return error;
>  
>  out_bmap_cancel:
> -	xfs_defer_cancel(&free_list);
> +	xfs_defer_cancel(&dfops);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  	goto out_unlock;
> @@ -1250,7 +1250,7 @@ xfs_shift_file_space(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
>  	int			error;
> -	struct xfs_defer_ops	free_list;
> +	struct xfs_defer_ops	dfops;
>  	xfs_fsblock_t		first_block;
>  	xfs_fileoff_t		stop_fsb;
>  	xfs_fileoff_t		next_fsb;
> @@ -1328,19 +1328,19 @@ xfs_shift_file_space(
>  
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
> -		xfs_defer_init(&free_list, &first_block);
> +		xfs_defer_init(&dfops, &first_block);
>  
>  		/*
>  		 * We are using the write transaction in which max 2 bmbt
>  		 * updates are allowed
>  		 */
>  		error = xfs_bmap_shift_extents(tp, ip, &next_fsb, shift_fsb,
> -				&done, stop_fsb, &first_block, &free_list,
> +				&done, stop_fsb, &first_block, &dfops,
>  				direction, XFS_BMAP_MAX_SHIFT_EXTENTS);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> -		error = xfs_defer_finish(&tp, &free_list, NULL);
> +		error = xfs_defer_finish(&tp, &dfops, NULL);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> @@ -1350,7 +1350,7 @@ xfs_shift_file_space(
>  	return error;
>  
>  out_bmap_cancel:
> -	xfs_defer_cancel(&free_list);
> +	xfs_defer_cancel(&dfops);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  	return error;
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 764e1cc..8ca21b8 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -307,7 +307,7 @@ xfs_qm_dqalloc(
>  	xfs_buf_t	**O_bpp)
>  {
>  	xfs_fsblock_t	firstblock;
> -	struct xfs_defer_ops flist;
> +	struct xfs_defer_ops dfops;
>  	xfs_bmbt_irec_t map;
>  	int		nmaps, error;
>  	xfs_buf_t	*bp;
> @@ -320,7 +320,7 @@ xfs_qm_dqalloc(
>  	/*
>  	 * Initialize the bmap freelist prior to calling bmapi code.
>  	 */
> -	xfs_defer_init(&flist, &firstblock);
> +	xfs_defer_init(&dfops, &firstblock);
>  	xfs_ilock(quotip, XFS_ILOCK_EXCL);
>  	/*
>  	 * Return if this type of quotas is turned off while we didn't
> @@ -336,7 +336,7 @@ xfs_qm_dqalloc(
>  	error = xfs_bmapi_write(tp, quotip, offset_fsb,
>  				XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
>  				&firstblock, XFS_QM_DQALLOC_SPACE_RES(mp),
> -				&map, &nmaps, &flist);
> +				&map, &nmaps, &dfops);
>  	if (error)
>  		goto error0;
>  	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
> @@ -382,7 +382,7 @@ xfs_qm_dqalloc(
>  
>  	xfs_trans_bhold(tp, bp);
>  
> -	error = xfs_defer_finish(tpp, &flist, NULL);
> +	error = xfs_defer_finish(tpp, &dfops, NULL);
>  	if (error)
>  		goto error1;
>  
> @@ -398,7 +398,7 @@ xfs_qm_dqalloc(
>  	return 0;
>  
>  error1:
> -	xfs_defer_cancel(&flist);
> +	xfs_defer_cancel(&dfops);
>  error0:
>  	xfs_iunlock(quotip, XFS_ILOCK_EXCL);
>  
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 3e990fb..4a33a33 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -386,7 +386,7 @@ xfs_filestream_new_ag(
>  	}
>  
>  	flags = (ap->userdata ? XFS_PICK_USERDATA : 0) |
> -	        (ap->flist->dop_low ? XFS_PICK_LOWSPACE : 0);
> +	        (ap->dfops->dop_low ? XFS_PICK_LOWSPACE : 0);
>  
>  	err = xfs_filestream_pick_ag(pip, startag, agp, flags, minlen);
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 3ce50da..e08eaea 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1123,7 +1123,7 @@ xfs_create(
>  	struct xfs_inode	*ip = NULL;
>  	struct xfs_trans	*tp = NULL;
>  	int			error;
> -	struct xfs_defer_ops	free_list;
> +	struct xfs_defer_ops	dfops;
>  	xfs_fsblock_t		first_block;
>  	bool                    unlock_dp_on_error = false;
>  	prid_t			prid;
> @@ -1183,7 +1183,7 @@ xfs_create(
>  		      XFS_IOLOCK_PARENT | XFS_ILOCK_PARENT);
>  	unlock_dp_on_error = true;
>  
> -	xfs_defer_init(&free_list, &first_block);
> +	xfs_defer_init(&dfops, &first_block);
>  
>  	/*
>  	 * Reserve disk quota and the inode.
> @@ -1220,7 +1220,7 @@ xfs_create(
>  	unlock_dp_on_error = false;
>  
>  	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
> -					&first_block, &free_list, resblks ?
> +					&first_block, &dfops, resblks ?
>  					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
>  	if (error) {
>  		ASSERT(error != -ENOSPC);
> @@ -1254,7 +1254,7 @@ xfs_create(
>  	 */
>  	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
>  
> -	error = xfs_defer_finish(&tp, &free_list, NULL);
> +	error = xfs_defer_finish(&tp, &dfops, NULL);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> @@ -1270,7 +1270,7 @@ xfs_create(
>  	return 0;
>  
>   out_bmap_cancel:
> -	xfs_defer_cancel(&free_list);
> +	xfs_defer_cancel(&dfops);
>   out_trans_cancel:
>  	xfs_trans_cancel(tp);
>   out_release_inode:
> @@ -1402,7 +1402,7 @@ xfs_link(
>  	xfs_mount_t		*mp = tdp->i_mount;
>  	xfs_trans_t		*tp;
>  	int			error;
> -	struct xfs_defer_ops	free_list;
> +	struct xfs_defer_ops	dfops;
>  	xfs_fsblock_t           first_block;
>  	int			resblks;
>  
> @@ -1453,7 +1453,7 @@ xfs_link(
>  			goto error_return;
>  	}
>  
> -	xfs_defer_init(&free_list, &first_block);
> +	xfs_defer_init(&dfops, &first_block);
>  
>  	/*
>  	 * Handle initial link state of O_TMPFILE inode
> @@ -1465,7 +1465,7 @@ xfs_link(
>  	}
>  
>  	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
> -					&first_block, &free_list, resblks);
> +					&first_block, &dfops, resblks);
>  	if (error)
>  		goto error_return;
>  	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> @@ -1483,9 +1483,9 @@ xfs_link(
>  	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
>  		xfs_trans_set_sync(tp);
>  
> -	error = xfs_defer_finish(&tp, &free_list, NULL);
> +	error = xfs_defer_finish(&tp, &dfops, NULL);
>  	if (error) {
> -		xfs_defer_cancel(&free_list);
> +		xfs_defer_cancel(&dfops);
>  		goto error_return;
>  	}
>  
> @@ -1527,7 +1527,7 @@ xfs_itruncate_extents(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp = *tpp;
> -	struct xfs_defer_ops	free_list;
> +	struct xfs_defer_ops	dfops;
>  	xfs_fsblock_t		first_block;
>  	xfs_fileoff_t		first_unmap_block;
>  	xfs_fileoff_t		last_block;
> @@ -1563,12 +1563,12 @@ xfs_itruncate_extents(
>  	ASSERT(first_unmap_block < last_block);
>  	unmap_len = last_block - first_unmap_block + 1;
>  	while (!done) {
> -		xfs_defer_init(&free_list, &first_block);
> +		xfs_defer_init(&dfops, &first_block);
>  		error = xfs_bunmapi(tp, ip,
>  				    first_unmap_block, unmap_len,
>  				    xfs_bmapi_aflag(whichfork),
>  				    XFS_ITRUNC_MAX_EXTENTS,
> -				    &first_block, &free_list,
> +				    &first_block, &dfops,
>  				    &done);
>  		if (error)
>  			goto out_bmap_cancel;
> @@ -1577,7 +1577,7 @@ xfs_itruncate_extents(
>  		 * Duplicate the transaction that has the permanent
>  		 * reservation and commit the old transaction.
>  		 */
> -		error = xfs_defer_finish(&tp, &free_list, ip);
> +		error = xfs_defer_finish(&tp, &dfops, ip);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> @@ -1603,7 +1603,7 @@ out_bmap_cancel:
>  	 * the transaction can be properly aborted.  We just need to make sure
>  	 * we're not holding any resources that we were not when we came in.
>  	 */
> -	xfs_defer_cancel(&free_list);
> +	xfs_defer_cancel(&dfops);
>  	goto out;
>  }
>  
> @@ -1744,7 +1744,7 @@ STATIC int
>  xfs_inactive_ifree(
>  	struct xfs_inode *ip)
>  {
> -	struct xfs_defer_ops	free_list;
> +	struct xfs_defer_ops	dfops;
>  	xfs_fsblock_t		first_block;
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
> @@ -1781,8 +1781,8 @@ xfs_inactive_ifree(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	xfs_defer_init(&free_list, &first_block);
> -	error = xfs_ifree(tp, ip, &free_list);
> +	xfs_defer_init(&dfops, &first_block);
> +	error = xfs_ifree(tp, ip, &dfops);
>  	if (error) {
>  		/*
>  		 * If we fail to free the inode, shut down.  The cancel
> @@ -1808,11 +1808,11 @@ xfs_inactive_ifree(
>  	 * Just ignore errors at this point.  There is nothing we can do except
>  	 * to try to keep going. Make sure it's not a silent error.
>  	 */
> -	error = xfs_defer_finish(&tp, &free_list, NULL);
> +	error = xfs_defer_finish(&tp, &dfops, NULL);
>  	if (error) {
>  		xfs_notice(mp, "%s: xfs_defer_finish returned error %d",
>  			__func__, error);
> -		xfs_defer_cancel(&free_list);
> +		xfs_defer_cancel(&dfops);
>  	}
>  	error = xfs_trans_commit(tp);
>  	if (error)
> @@ -2368,7 +2368,7 @@ int
>  xfs_ifree(
>  	xfs_trans_t	*tp,
>  	xfs_inode_t	*ip,
> -	struct xfs_defer_ops	*flist)
> +	struct xfs_defer_ops	*dfops)
>  {
>  	int			error;
>  	struct xfs_icluster	xic = { 0 };
> @@ -2387,7 +2387,7 @@ xfs_ifree(
>  	if (error)
>  		return error;
>  
> -	error = xfs_difree(tp, ip->i_ino, flist, &xic);
> +	error = xfs_difree(tp, ip->i_ino, dfops, &xic);
>  	if (error)
>  		return error;
>  
> @@ -2490,7 +2490,7 @@ xfs_remove(
>  	xfs_trans_t             *tp = NULL;
>  	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
>  	int                     error = 0;
> -	struct xfs_defer_ops	free_list;
> +	struct xfs_defer_ops	dfops;
>  	xfs_fsblock_t           first_block;
>  	uint			resblks;
>  
> @@ -2572,9 +2572,9 @@ xfs_remove(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	xfs_defer_init(&free_list, &first_block);
> +	xfs_defer_init(&dfops, &first_block);
>  	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
> -					&first_block, &free_list, resblks);
> +					&first_block, &dfops, resblks);
>  	if (error) {
>  		ASSERT(error != -ENOENT);
>  		goto out_bmap_cancel;
> @@ -2588,7 +2588,7 @@ xfs_remove(
>  	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
>  		xfs_trans_set_sync(tp);
>  
> -	error = xfs_defer_finish(&tp, &free_list, NULL);
> +	error = xfs_defer_finish(&tp, &dfops, NULL);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> @@ -2602,7 +2602,7 @@ xfs_remove(
>  	return 0;
>  
>   out_bmap_cancel:
> -	xfs_defer_cancel(&free_list);
> +	xfs_defer_cancel(&dfops);
>   out_trans_cancel:
>  	xfs_trans_cancel(tp);
>   std_return:
> @@ -2663,7 +2663,7 @@ xfs_sort_for_rename(
>  static int
>  xfs_finish_rename(
>  	struct xfs_trans	*tp,
> -	struct xfs_defer_ops	*free_list)
> +	struct xfs_defer_ops	*dfops)
>  {
>  	int			error;
>  
> @@ -2674,9 +2674,9 @@ xfs_finish_rename(
>  	if (tp->t_mountp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
>  		xfs_trans_set_sync(tp);
>  
> -	error = xfs_defer_finish(&tp, free_list, NULL);
> +	error = xfs_defer_finish(&tp, dfops, NULL);
>  	if (error) {
> -		xfs_defer_cancel(free_list);
> +		xfs_defer_cancel(dfops);
>  		xfs_trans_cancel(tp);
>  		return error;
>  	}
> @@ -2698,7 +2698,7 @@ xfs_cross_rename(
>  	struct xfs_inode	*dp2,
>  	struct xfs_name		*name2,
>  	struct xfs_inode	*ip2,
> -	struct xfs_defer_ops	*free_list,
> +	struct xfs_defer_ops	*dfops,
>  	xfs_fsblock_t		*first_block,
>  	int			spaceres)
>  {
> @@ -2710,14 +2710,14 @@ xfs_cross_rename(
>  	/* Swap inode number for dirent in first parent */
>  	error = xfs_dir_replace(tp, dp1, name1,
>  				ip2->i_ino,
> -				first_block, free_list, spaceres);
> +				first_block, dfops, spaceres);
>  	if (error)
>  		goto out_trans_abort;
>  
>  	/* Swap inode number for dirent in second parent */
>  	error = xfs_dir_replace(tp, dp2, name2,
>  				ip1->i_ino,
> -				first_block, free_list, spaceres);
> +				first_block, dfops, spaceres);
>  	if (error)
>  		goto out_trans_abort;
>  
> @@ -2732,7 +2732,7 @@ xfs_cross_rename(
>  		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
>  			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
>  						dp1->i_ino, first_block,
> -						free_list, spaceres);
> +						dfops, spaceres);
>  			if (error)
>  				goto out_trans_abort;
>  
> @@ -2759,7 +2759,7 @@ xfs_cross_rename(
>  		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
>  			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
>  						dp2->i_ino, first_block,
> -						free_list, spaceres);
> +						dfops, spaceres);
>  			if (error)
>  				goto out_trans_abort;
>  
> @@ -2798,10 +2798,10 @@ xfs_cross_rename(
>  	}
>  	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
> -	return xfs_finish_rename(tp, free_list);
> +	return xfs_finish_rename(tp, dfops);
>  
>  out_trans_abort:
> -	xfs_defer_cancel(free_list);
> +	xfs_defer_cancel(dfops);
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> @@ -2856,7 +2856,7 @@ xfs_rename(
>  {
>  	struct xfs_mount	*mp = src_dp->i_mount;
>  	struct xfs_trans	*tp;
> -	struct xfs_defer_ops	free_list;
> +	struct xfs_defer_ops	dfops;
>  	xfs_fsblock_t		first_block;
>  	struct xfs_inode	*wip = NULL;		/* whiteout inode */
>  	struct xfs_inode	*inodes[__XFS_SORT_INODES];
> @@ -2945,13 +2945,13 @@ xfs_rename(
>  		goto out_trans_cancel;
>  	}
>  
> -	xfs_defer_init(&free_list, &first_block);
> +	xfs_defer_init(&dfops, &first_block);
>  
>  	/* RENAME_EXCHANGE is unique from here on. */
>  	if (flags & RENAME_EXCHANGE)
>  		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
>  					target_dp, target_name, target_ip,
> -					&free_list, &first_block, spaceres);
> +					&dfops, &first_block, spaceres);
>  
>  	/*
>  	 * Set up the target.
> @@ -2973,7 +2973,7 @@ xfs_rename(
>  		 */
>  		error = xfs_dir_createname(tp, target_dp, target_name,
>  						src_ip->i_ino, &first_block,
> -						&free_list, spaceres);
> +						&dfops, spaceres);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> @@ -3013,7 +3013,7 @@ xfs_rename(
>  		 */
>  		error = xfs_dir_replace(tp, target_dp, target_name,
>  					src_ip->i_ino,
> -					&first_block, &free_list, spaceres);
> +					&first_block, &dfops, spaceres);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> @@ -3048,7 +3048,7 @@ xfs_rename(
>  		 */
>  		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
>  					target_dp->i_ino,
> -					&first_block, &free_list, spaceres);
> +					&first_block, &dfops, spaceres);
>  		ASSERT(error != -EEXIST);
>  		if (error)
>  			goto out_bmap_cancel;
> @@ -3087,10 +3087,10 @@ xfs_rename(
>  	 */
>  	if (wip) {
>  		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
> -					&first_block, &free_list, spaceres);
> +					&first_block, &dfops, spaceres);
>  	} else
>  		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
> -					   &first_block, &free_list, spaceres);
> +					   &first_block, &dfops, spaceres);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> @@ -3125,13 +3125,13 @@ xfs_rename(
>  	if (new_parent)
>  		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
>  
> -	error = xfs_finish_rename(tp, &free_list);
> +	error = xfs_finish_rename(tp, &dfops);
>  	if (wip)
>  		IRELE(wip);
>  	return error;
>  
>  out_bmap_cancel:
> -	xfs_defer_cancel(&free_list);
> +	xfs_defer_cancel(&dfops);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  out_release_wip:
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index dc93c20..2114d53 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -129,7 +129,7 @@ xfs_iomap_write_direct(
>  	int		quota_flag;
>  	int		rt;
>  	xfs_trans_t	*tp;
> -	struct xfs_defer_ops free_list;
> +	struct xfs_defer_ops dfops;
>  	uint		qblocks, resblks, resrtextents;
>  	int		error;
>  	int		lockmode;
> @@ -232,18 +232,18 @@ xfs_iomap_write_direct(
>  	 * From this point onwards we overwrite the imap pointer that the
>  	 * caller gave to us.
>  	 */
> -	xfs_defer_init(&free_list, &firstfsb);
> +	xfs_defer_init(&dfops, &firstfsb);
>  	nimaps = 1;
>  	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
>  				bmapi_flags, &firstfsb, resblks, imap,
> -				&nimaps, &free_list);
> +				&nimaps, &dfops);
>  	if (error)
>  		goto out_bmap_cancel;
>  
>  	/*
>  	 * Complete the transaction
>  	 */
> -	error = xfs_defer_finish(&tp, &free_list, NULL);
> +	error = xfs_defer_finish(&tp, &dfops, NULL);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> @@ -267,7 +267,7 @@ out_unlock:
>  	return error;
>  
>  out_bmap_cancel:
> -	xfs_defer_cancel(&free_list);
> +	xfs_defer_cancel(&dfops);
>  	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
> @@ -686,7 +686,7 @@ xfs_iomap_write_allocate(
>  	xfs_fileoff_t	offset_fsb, last_block;
>  	xfs_fileoff_t	end_fsb, map_start_fsb;
>  	xfs_fsblock_t	first_block;
> -	struct xfs_defer_ops	free_list;
> +	struct xfs_defer_ops	dfops;
>  	xfs_filblks_t	count_fsb;
>  	xfs_trans_t	*tp;
>  	int		nimaps;
> @@ -728,7 +728,7 @@ xfs_iomap_write_allocate(
>  			xfs_ilock(ip, XFS_ILOCK_EXCL);
>  			xfs_trans_ijoin(tp, ip, 0);
>  
> -			xfs_defer_init(&free_list, &first_block);
> +			xfs_defer_init(&dfops, &first_block);
>  
>  			/*
>  			 * it is possible that the extents have changed since
> @@ -784,11 +784,11 @@ xfs_iomap_write_allocate(
>  			error = xfs_bmapi_write(tp, ip, map_start_fsb,
>  						count_fsb, 0, &first_block,
>  						nres, imap, &nimaps,
> -						&free_list);
> +						&dfops);
>  			if (error)
>  				goto trans_cancel;
>  
> -			error = xfs_defer_finish(&tp, &free_list, NULL);
> +			error = xfs_defer_finish(&tp, &dfops, NULL);
>  			if (error)
>  				goto trans_cancel;
>  
> @@ -822,7 +822,7 @@ xfs_iomap_write_allocate(
>  	}
>  
>  trans_cancel:
> -	xfs_defer_cancel(&free_list);
> +	xfs_defer_cancel(&dfops);
>  	xfs_trans_cancel(tp);
>  error0:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -843,7 +843,7 @@ xfs_iomap_write_unwritten(
>  	int		nimaps;
>  	xfs_trans_t	*tp;
>  	xfs_bmbt_irec_t imap;
> -	struct xfs_defer_ops free_list;
> +	struct xfs_defer_ops dfops;
>  	xfs_fsize_t	i_size;
>  	uint		resblks;
>  	int		error;
> @@ -887,11 +887,11 @@ xfs_iomap_write_unwritten(
>  		/*
>  		 * Modify the unwritten extent state of the buffer.
>  		 */
> -		xfs_defer_init(&free_list, &firstfsb);
> +		xfs_defer_init(&dfops, &firstfsb);
>  		nimaps = 1;
>  		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
>  					XFS_BMAPI_CONVERT, &firstfsb, resblks,
> -					&imap, &nimaps, &free_list);
> +					&imap, &nimaps, &dfops);
>  		if (error)
>  			goto error_on_bmapi_transaction;
>  
> @@ -910,7 +910,7 @@ xfs_iomap_write_unwritten(
>  			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  		}
>  
> -		error = xfs_defer_finish(&tp, &free_list, NULL);
> +		error = xfs_defer_finish(&tp, &dfops, NULL);
>  		if (error)
>  			goto error_on_bmapi_transaction;
>  
> @@ -937,7 +937,7 @@ xfs_iomap_write_unwritten(
>  	return 0;
>  
>  error_on_bmapi_transaction:
> -	xfs_defer_cancel(&free_list);
> +	xfs_defer_cancel(&dfops);
>  	xfs_trans_cancel(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index c761a6a..802bcc3 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -770,7 +770,7 @@ xfs_growfs_rt_alloc(
>  	xfs_daddr_t		d;		/* disk block address */
>  	int			error;		/* error return value */
>  	xfs_fsblock_t		firstblock;/* first block allocated in xaction */
> -	struct xfs_defer_ops	flist;		/* list of freed blocks */
> +	struct xfs_defer_ops	dfops;		/* list of freed blocks */
>  	xfs_fsblock_t		fsbno;		/* filesystem block for bno */
>  	struct xfs_bmbt_irec	map;		/* block map output */
>  	int			nmap;		/* number of block maps */
> @@ -795,14 +795,14 @@ xfs_growfs_rt_alloc(
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
> -		xfs_defer_init(&flist, &firstblock);
> +		xfs_defer_init(&dfops, &firstblock);
>  		/*
>  		 * Allocate blocks to the bitmap file.
>  		 */
>  		nmap = 1;
>  		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
>  					XFS_BMAPI_METADATA, &firstblock,
> -					resblks, &map, &nmap, &flist);
> +					resblks, &map, &nmap, &dfops);
>  		if (!error && nmap < 1)
>  			error = -ENOSPC;
>  		if (error)
> @@ -810,7 +810,7 @@ xfs_growfs_rt_alloc(
>  		/*
>  		 * Free any blocks freed up in the transaction, then commit.
>  		 */
> -		error = xfs_defer_finish(&tp, &flist, NULL);
> +		error = xfs_defer_finish(&tp, &dfops, NULL);
>  		if (error)
>  			goto out_bmap_cancel;
>  		error = xfs_trans_commit(tp);
> @@ -863,7 +863,7 @@ xfs_growfs_rt_alloc(
>  	return 0;
>  
>  out_bmap_cancel:
> -	xfs_defer_cancel(&flist);
> +	xfs_defer_cancel(&dfops);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  	return error;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 3b005ec..58142ae 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -173,7 +173,7 @@ xfs_symlink(
>  	struct xfs_inode	*ip = NULL;
>  	int			error = 0;
>  	int			pathlen;
> -	struct xfs_defer_ops	free_list;
> +	struct xfs_defer_ops	dfops;
>  	xfs_fsblock_t		first_block;
>  	bool                    unlock_dp_on_error = false;
>  	xfs_fileoff_t		first_fsb;
> @@ -270,7 +270,7 @@ xfs_symlink(
>  	 * Initialize the bmap freelist prior to calling either
>  	 * bmapi or the directory create code.
>  	 */
> -	xfs_defer_init(&free_list, &first_block);
> +	xfs_defer_init(&dfops, &first_block);
>  
>  	/*
>  	 * Allocate an inode for the symlink.
> @@ -314,7 +314,7 @@ xfs_symlink(
>  
>  		error = xfs_bmapi_write(tp, ip, first_fsb, fs_blocks,
>  				  XFS_BMAPI_METADATA, &first_block, resblks,
> -				  mval, &nmaps, &free_list);
> +				  mval, &nmaps, &dfops);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> @@ -362,7 +362,7 @@ xfs_symlink(
>  	 * Create the directory entry for the symlink.
>  	 */
>  	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino,
> -					&first_block, &free_list, resblks);
> +					&first_block, &dfops, resblks);
>  	if (error)
>  		goto out_bmap_cancel;
>  	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> @@ -377,7 +377,7 @@ xfs_symlink(
>  		xfs_trans_set_sync(tp);
>  	}
>  
> -	error = xfs_defer_finish(&tp, &free_list, NULL);
> +	error = xfs_defer_finish(&tp, &dfops, NULL);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> @@ -393,7 +393,7 @@ xfs_symlink(
>  	return 0;
>  
>  out_bmap_cancel:
> -	xfs_defer_cancel(&free_list);
> +	xfs_defer_cancel(&dfops);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  out_release_inode:
> @@ -427,7 +427,7 @@ xfs_inactive_symlink_rmt(
>  	int		done;
>  	int		error;
>  	xfs_fsblock_t	first_block;
> -	struct xfs_defer_ops	free_list;
> +	struct xfs_defer_ops	dfops;
>  	int		i;
>  	xfs_mount_t	*mp;
>  	xfs_bmbt_irec_t	mval[XFS_SYMLINK_MAPS];
> @@ -466,7 +466,7 @@ xfs_inactive_symlink_rmt(
>  	 * Find the block(s) so we can inval and unmap them.
>  	 */
>  	done = 0;
> -	xfs_defer_init(&free_list, &first_block);
> +	xfs_defer_init(&dfops, &first_block);
>  	nmaps = ARRAY_SIZE(mval);
>  	error = xfs_bmapi_read(ip, 0, xfs_symlink_blocks(mp, size),
>  				mval, &nmaps, 0);
> @@ -486,17 +486,17 @@ xfs_inactive_symlink_rmt(
>  		xfs_trans_binval(tp, bp);
>  	}
>  	/*
> -	 * Unmap the dead block(s) to the free_list.
> +	 * Unmap the dead block(s) to the dfops.
>  	 */
>  	error = xfs_bunmapi(tp, ip, 0, size, 0, nmaps,
> -			    &first_block, &free_list, &done);
> +			    &first_block, &dfops, &done);
>  	if (error)
>  		goto error_bmap_cancel;
>  	ASSERT(done);
>  	/*
>  	 * Commit the first transaction.  This logs the EFI and the inode.
>  	 */
> -	error = xfs_defer_finish(&tp, &free_list, ip);
> +	error = xfs_defer_finish(&tp, &dfops, ip);
>  	if (error)
>  		goto error_bmap_cancel;
>  	/*
> @@ -526,7 +526,7 @@ xfs_inactive_symlink_rmt(
>  	return 0;
>  
>  error_bmap_cancel:
> -	xfs_defer_cancel(&free_list);
> +	xfs_defer_cancel(&dfops);
>  error_trans_cancel:
>  	xfs_trans_cancel(tp);
>  error_unlock:
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
