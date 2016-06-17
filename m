Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AAB8D80E4
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:33:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4AA8430404E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:36 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id MFZYRI1OGqQNHdLy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:28 -0700 (PDT)
Subject: [PATCH 025/145] xfs: rename flist/free_list to dfops
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:33:21 -0700
Message-ID: <146612720098.16048.4119801736083912091.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Mechanical change of flist/free_list to dfops, since they're now
deferred ops, not just a freeing list.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/util.c            |   10 ++--
 libxfs/xfs_attr.c        |   62 ++++++++++++-------------
 libxfs/xfs_attr_leaf.c   |    4 +-
 libxfs/xfs_attr_remote.c |   18 ++++---
 libxfs/xfs_bmap.c        |  116 +++++++++++++++++++++++-----------------------
 libxfs/xfs_bmap.h        |   10 ++--
 libxfs/xfs_bmap_btree.c  |   14 +++---
 libxfs/xfs_btree.h       |    4 +-
 libxfs/xfs_da_btree.c    |    6 +-
 libxfs/xfs_da_btree.h    |    2 -
 libxfs/xfs_dir2.c        |   14 +++---
 libxfs/xfs_dir2.h        |    6 +-
 libxfs/xfs_ialloc.c      |   14 +++---
 libxfs/xfs_ialloc.h      |    2 -
 mkfs/proto.c             |   56 +++++++++++-----------
 repair/phase6.c          |   94 +++++++++++++++++++------------------
 repair/sb.c              |   10 ++--
 17 files changed, 221 insertions(+), 221 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 4b81818..5b277c2 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -493,7 +493,7 @@ libxfs_alloc_file_space(
 	xfs_filblks_t	allocated_fsb;
 	xfs_filblks_t	allocatesize_fsb;
 	xfs_fsblock_t	firstfsb;
-	struct xfs_defer_ops free_list;
+	struct xfs_defer_ops dfops;
 	xfs_bmbt_irec_t *imapp;
 	xfs_bmbt_irec_t imaps[1];
 	int		reccount;
@@ -535,16 +535,16 @@ libxfs_alloc_file_space(
 		}
 		xfs_trans_ijoin(tp, ip, 0);
 
-		xfs_defer_init(&free_list, &firstfsb);
+		xfs_defer_init(&dfops, &firstfsb);
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb, allocatesize_fsb,
 				xfs_bmapi_flags, &firstfsb, 0, imapp,
-				&reccount, &free_list);
+				&reccount, &dfops);
 
 		if (error)
 			goto error0;
 
 		/* complete the transaction */
-		error = xfs_defer_finish(&tp, &free_list, ip);
+		error = xfs_defer_finish(&tp, &dfops, ip);
 		if (error)
 			goto error0;
 
@@ -562,7 +562,7 @@ libxfs_alloc_file_space(
 	return error;
 
 error0:	/* Cancel bmap, cancel trans */
-	xfs_defer_cancel(&free_list);
+	xfs_defer_cancel(&dfops);
 	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 06b3c5d..60513f9 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -199,7 +199,7 @@ xfs_attr_set(
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
-	struct xfs_defer_ops	flist;
+	struct xfs_defer_ops	dfops;
 	struct xfs_trans_res	tres;
 	xfs_fsblock_t		firstblock;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
@@ -217,7 +217,7 @@ xfs_attr_set(
 	args.value = value;
 	args.valuelen = valuelen;
 	args.firstblock = &firstblock;
-	args.flist = &flist;
+	args.dfops = &dfops;
 	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
 	args.total = xfs_attr_calc_size(&args, &local);
 
@@ -312,13 +312,13 @@ xfs_attr_set(
 		 * It won't fit in the shortform, transform to a leaf block.
 		 * GROT: another possible req'mt for a double-split btree op.
 		 */
-		xfs_defer_init(args.flist, args.firstblock);
+		xfs_defer_init(args.dfops, args.firstblock);
 		error = xfs_attr_shortform_to_leaf(&args);
 		if (!error)
-			error = xfs_defer_finish(&args.trans, args.flist, dp);
+			error = xfs_defer_finish(&args.trans, args.dfops, dp);
 		if (error) {
 			args.trans = NULL;
-			xfs_defer_cancel(&flist);
+			xfs_defer_cancel(&dfops);
 			goto out;
 		}
 
@@ -378,7 +378,7 @@ xfs_attr_remove(
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
-	struct xfs_defer_ops	flist;
+	struct xfs_defer_ops	dfops;
 	xfs_fsblock_t		firstblock;
 	int			error;
 
@@ -395,7 +395,7 @@ xfs_attr_remove(
 		return error;
 
 	args.firstblock = &firstblock;
-	args.flist = &flist;
+	args.dfops = &dfops;
 
 	/*
 	 * we have no control over the attribute names that userspace passes us
@@ -580,13 +580,13 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * Commit that transaction so that the node_addname() call
 		 * can manage its own transactions.
 		 */
-		xfs_defer_init(args->flist, args->firstblock);
+		xfs_defer_init(args->dfops, args->firstblock);
 		error = xfs_attr3_leaf_to_node(args);
 		if (!error)
-			error = xfs_defer_finish(&args->trans, args->flist, dp);
+			error = xfs_defer_finish(&args->trans, args->dfops, dp);
 		if (error) {
 			args->trans = NULL;
-			xfs_defer_cancel(args->flist);
+			xfs_defer_cancel(args->dfops);
 			return error;
 		}
 
@@ -670,15 +670,15 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * If the result is small enough, shrink it all into the inode.
 		 */
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			xfs_defer_init(args->flist, args->firstblock);
+			xfs_defer_init(args->dfops, args->firstblock);
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (!error)
 				error = xfs_defer_finish(&args->trans,
-							args->flist, dp);
+							args->dfops, dp);
 			if (error) {
 				args->trans = NULL;
-				xfs_defer_cancel(args->flist);
+				xfs_defer_cancel(args->dfops);
 				return error;
 			}
 		}
@@ -733,14 +733,14 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 	 * If the result is small enough, shrink it all into the inode.
 	 */
 	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-		xfs_defer_init(args->flist, args->firstblock);
+		xfs_defer_init(args->dfops, args->firstblock);
 		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (!error)
-			error = xfs_defer_finish(&args->trans, args->flist, dp);
+			error = xfs_defer_finish(&args->trans, args->dfops, dp);
 		if (error) {
 			args->trans = NULL;
-			xfs_defer_cancel(args->flist);
+			xfs_defer_cancel(args->dfops);
 			return error;
 		}
 	}
@@ -859,14 +859,14 @@ restart:
 			 */
 			xfs_da_state_free(state);
 			state = NULL;
-			xfs_defer_init(args->flist, args->firstblock);
+			xfs_defer_init(args->dfops, args->firstblock);
 			error = xfs_attr3_leaf_to_node(args);
 			if (!error)
 				error = xfs_defer_finish(&args->trans,
-							args->flist, dp);
+							args->dfops, dp);
 			if (error) {
 				args->trans = NULL;
-				xfs_defer_cancel(args->flist);
+				xfs_defer_cancel(args->dfops);
 				goto out;
 			}
 
@@ -887,13 +887,13 @@ restart:
 		 * in the index/blkno/rmtblkno/rmtblkcnt fields and
 		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
 		 */
-		xfs_defer_init(args->flist, args->firstblock);
+		xfs_defer_init(args->dfops, args->firstblock);
 		error = xfs_da3_split(state);
 		if (!error)
-			error = xfs_defer_finish(&args->trans, args->flist, dp);
+			error = xfs_defer_finish(&args->trans, args->dfops, dp);
 		if (error) {
 			args->trans = NULL;
-			xfs_defer_cancel(args->flist);
+			xfs_defer_cancel(args->dfops);
 			goto out;
 		}
 	} else {
@@ -986,14 +986,14 @@ restart:
 		 * Check to see if the tree needs to be collapsed.
 		 */
 		if (retval && (state->path.active > 1)) {
-			xfs_defer_init(args->flist, args->firstblock);
+			xfs_defer_init(args->dfops, args->firstblock);
 			error = xfs_da3_join(state);
 			if (!error)
 				error = xfs_defer_finish(&args->trans,
-							args->flist, dp);
+							args->dfops, dp);
 			if (error) {
 				args->trans = NULL;
-				xfs_defer_cancel(args->flist);
+				xfs_defer_cancel(args->dfops);
 				goto out;
 			}
 		}
@@ -1109,13 +1109,13 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	 * Check to see if the tree needs to be collapsed.
 	 */
 	if (retval && (state->path.active > 1)) {
-		xfs_defer_init(args->flist, args->firstblock);
+		xfs_defer_init(args->dfops, args->firstblock);
 		error = xfs_da3_join(state);
 		if (!error)
-			error = xfs_defer_finish(&args->trans, args->flist, dp);
+			error = xfs_defer_finish(&args->trans, args->dfops, dp);
 		if (error) {
 			args->trans = NULL;
-			xfs_defer_cancel(args->flist);
+			xfs_defer_cancel(args->dfops);
 			goto out;
 		}
 		/*
@@ -1142,15 +1142,15 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 			goto out;
 
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			xfs_defer_init(args->flist, args->firstblock);
+			xfs_defer_init(args->dfops, args->firstblock);
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (!error)
 				error = xfs_defer_finish(&args->trans,
-							args->flist, dp);
+							args->dfops, dp);
 			if (error) {
 				args->trans = NULL;
-				xfs_defer_cancel(args->flist);
+				xfs_defer_cancel(args->dfops);
 				goto out;
 			}
 		} else
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index d0eb0a7..0ca0347 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -787,7 +787,7 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 	nargs.dp = dp;
 	nargs.geo = args->geo;
 	nargs.firstblock = args->firstblock;
-	nargs.flist = args->flist;
+	nargs.dfops = args->dfops;
 	nargs.total = args->total;
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
@@ -917,7 +917,7 @@ xfs_attr3_leaf_to_shortform(
 	nargs.geo = args->geo;
 	nargs.dp = dp;
 	nargs.firstblock = args->firstblock;
-	nargs.flist = args->flist;
+	nargs.dfops = args->dfops;
 	nargs.total = args->total;
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index dc545f0..abe1705 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -456,16 +456,16 @@ xfs_attr_rmtval_set(
 		 * extent and then crash then the block may not contain the
 		 * correct metadata after log recovery occurs.
 		 */
-		xfs_defer_init(args->flist, args->firstblock);
+		xfs_defer_init(args->dfops, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
 				  blkcnt, XFS_BMAPI_ATTRFORK, args->firstblock,
-				  args->total, &map, &nmap, args->flist);
+				  args->total, &map, &nmap, args->dfops);
 		if (!error)
-			error = xfs_defer_finish(&args->trans, args->flist, dp);
+			error = xfs_defer_finish(&args->trans, args->dfops, dp);
 		if (error) {
 			args->trans = NULL;
-			xfs_defer_cancel(args->flist);
+			xfs_defer_cancel(args->dfops);
 			return error;
 		}
 
@@ -499,7 +499,7 @@ xfs_attr_rmtval_set(
 
 		ASSERT(blkcnt > 0);
 
-		xfs_defer_init(args->flist, args->firstblock);
+		xfs_defer_init(args->dfops, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)lblkno,
 				       blkcnt, &map, &nmap,
@@ -599,16 +599,16 @@ xfs_attr_rmtval_remove(
 	blkcnt = args->rmtblkcnt;
 	done = 0;
 	while (!done) {
-		xfs_defer_init(args->flist, args->firstblock);
+		xfs_defer_init(args->dfops, args->firstblock);
 		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
 				    XFS_BMAPI_ATTRFORK, 1, args->firstblock,
-				    args->flist, &done);
+				    args->dfops, &done);
 		if (!error)
-			error = xfs_defer_finish(&args->trans, args->flist,
+			error = xfs_defer_finish(&args->trans, args->dfops,
 						args->dp);
 		if (error) {
 			args->trans = NULL;
-			xfs_defer_cancel(args->flist);
+			xfs_defer_cancel(args->dfops);
 			return error;
 		}
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 0faa0a9..5385800 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -564,7 +564,7 @@ xfs_bmap_validate_ret(
 void
 xfs_bmap_add_free(
 	struct xfs_mount	*mp,		/* mount point structure */
-	struct xfs_defer_ops	*flist,		/* list of extents */
+	struct xfs_defer_ops	*dfops,		/* list of extents */
 	xfs_fsblock_t		bno,		/* fs block number of extent */
 	xfs_filblks_t		len)		/* length of extent */
 {
@@ -588,7 +588,7 @@ xfs_bmap_add_free(
 	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
 	new->xbfi_startblock = bno;
 	new->xbfi_blockcount = (xfs_extlen_t)len;
-	xfs_defer_add(flist, XFS_DEFER_OPS_TYPE_FREE, &new->xbfi_list);
+	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_FREE, &new->xbfi_list);
 }
 
 /*
@@ -641,7 +641,7 @@ xfs_bmap_btree_to_extents(
 	cblock = XFS_BUF_TO_BLOCK(cbp);
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
-	xfs_bmap_add_free(mp, cur->bc_private.b.flist, cbno, 1);
+	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, cbno, 1);
 	ip->i_d.di_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -664,7 +664,7 @@ xfs_bmap_extents_to_btree(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	xfs_fsblock_t		*firstblock,	/* first-block-allocated */
-	struct xfs_defer_ops	*flist,		/* blocks freed in xaction */
+	struct xfs_defer_ops	*dfops,		/* blocks freed in xaction */
 	xfs_btree_cur_t		**curp,		/* cursor returned to caller */
 	int			wasdel,		/* converting a delayed alloc */
 	int			*logflagsp,	/* inode logging flags */
@@ -713,7 +713,7 @@ xfs_bmap_extents_to_btree(
 	 */
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 	cur->bc_private.b.firstblock = *firstblock;
-	cur->bc_private.b.flist = flist;
+	cur->bc_private.b.dfops = dfops;
 	cur->bc_private.b.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
 	/*
 	 * Convert to a btree with two levels, one record in root.
@@ -726,7 +726,7 @@ xfs_bmap_extents_to_btree(
 	if (*firstblock == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
-	} else if (flist->dop_low) {
+	} else if (dfops->dop_low) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = *firstblock;
 	} else {
@@ -747,7 +747,7 @@ xfs_bmap_extents_to_btree(
 	ASSERT(args.fsbno != NULLFSBLOCK);
 	ASSERT(*firstblock == NULLFSBLOCK ||
 	       args.agno == XFS_FSB_TO_AGNO(mp, *firstblock) ||
-	       (flist->dop_low &&
+	       (dfops->dop_low &&
 		args.agno > XFS_FSB_TO_AGNO(mp, *firstblock)));
 	*firstblock = cur->bc_private.b.firstblock = args.fsbno;
 	cur->bc_private.b.allocated++;
@@ -932,7 +932,7 @@ xfs_bmap_add_attrfork_btree(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	xfs_fsblock_t		*firstblock,	/* first block allocated */
-	struct xfs_defer_ops	*flist,		/* blocks to free at commit */
+	struct xfs_defer_ops	*dfops,		/* blocks to free at commit */
 	int			*flags)		/* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;		/* btree cursor */
@@ -945,7 +945,7 @@ xfs_bmap_add_attrfork_btree(
 		*flags |= XFS_ILOG_DBROOT;
 	else {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
-		cur->bc_private.b.flist = flist;
+		cur->bc_private.b.dfops = dfops;
 		cur->bc_private.b.firstblock = *firstblock;
 		if ((error = xfs_bmbt_lookup_ge(cur, 0, 0, 0, &stat)))
 			goto error0;
@@ -975,7 +975,7 @@ xfs_bmap_add_attrfork_extents(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	xfs_fsblock_t		*firstblock,	/* first block allocated */
-	struct xfs_defer_ops	*flist,		/* blocks to free at commit */
+	struct xfs_defer_ops	*dfops,		/* blocks to free at commit */
 	int			*flags)		/* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
@@ -984,7 +984,7 @@ xfs_bmap_add_attrfork_extents(
 	if (ip->i_d.di_nextents * sizeof(xfs_bmbt_rec_t) <= XFS_IFORK_DSIZE(ip))
 		return 0;
 	cur = NULL;
-	error = xfs_bmap_extents_to_btree(tp, ip, firstblock, flist, &cur, 0,
+	error = xfs_bmap_extents_to_btree(tp, ip, firstblock, dfops, &cur, 0,
 		flags, XFS_DATA_FORK);
 	if (cur) {
 		cur->bc_private.b.allocated = 0;
@@ -1010,7 +1010,7 @@ xfs_bmap_add_attrfork_local(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	xfs_fsblock_t		*firstblock,	/* first block allocated */
-	struct xfs_defer_ops	*flist,		/* blocks to free at commit */
+	struct xfs_defer_ops	*dfops,		/* blocks to free at commit */
 	int			*flags)		/* inode logging flags */
 {
 	xfs_da_args_t		dargs;		/* args for dir/attr code */
@@ -1023,7 +1023,7 @@ xfs_bmap_add_attrfork_local(
 		dargs.geo = ip->i_mount->m_dir_geo;
 		dargs.dp = ip;
 		dargs.firstblock = firstblock;
-		dargs.flist = flist;
+		dargs.dfops = dfops;
 		dargs.total = dargs.geo->fsbcount;
 		dargs.whichfork = XFS_DATA_FORK;
 		dargs.trans = tp;
@@ -1051,7 +1051,7 @@ xfs_bmap_add_attrfork(
 	int			rsvd)		/* xact may use reserved blks */
 {
 	xfs_fsblock_t		firstblock;	/* 1st block/ag allocated */
-	struct xfs_defer_ops	flist;		/* freed extent records */
+	struct xfs_defer_ops	dfops;		/* freed extent records */
 	xfs_mount_t		*mp;		/* mount structure */
 	xfs_trans_t		*tp;		/* transaction pointer */
 	int			blks;		/* space reservation */
@@ -1117,18 +1117,18 @@ xfs_bmap_add_attrfork(
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
 	ip->i_afp->if_flags = XFS_IFEXTENTS;
 	logflags = 0;
-	xfs_defer_init(&flist, &firstblock);
+	xfs_defer_init(&dfops, &firstblock);
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_LOCAL:
-		error = xfs_bmap_add_attrfork_local(tp, ip, &firstblock, &flist,
+		error = xfs_bmap_add_attrfork_local(tp, ip, &firstblock, &dfops,
 			&logflags);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
 		error = xfs_bmap_add_attrfork_extents(tp, ip, &firstblock,
-			&flist, &logflags);
+			&dfops, &logflags);
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		error = xfs_bmap_add_attrfork_btree(tp, ip, &firstblock, &flist,
+		error = xfs_bmap_add_attrfork_btree(tp, ip, &firstblock, &dfops,
 			&logflags);
 		break;
 	default:
@@ -1157,7 +1157,7 @@ xfs_bmap_add_attrfork(
 			xfs_log_sb(tp);
 	}
 
-	error = xfs_defer_finish(&tp, &flist, NULL);
+	error = xfs_defer_finish(&tp, &dfops, NULL);
 	if (error)
 		goto bmap_cancel;
 	error = xfs_trans_commit(tp);
@@ -1165,7 +1165,7 @@ xfs_bmap_add_attrfork(
 	return error;
 
 bmap_cancel:
-	xfs_defer_cancel(&flist);
+	xfs_defer_cancel(&dfops);
 trans_cancel:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -1962,7 +1962,7 @@ xfs_bmap_add_extent_delay_real(
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-					bma->firstblock, bma->flist,
+					bma->firstblock, bma->dfops,
 					&bma->cur, 1, &tmp_rval, whichfork);
 			rval |= tmp_rval;
 			if (error)
@@ -2046,7 +2046,7 @@ xfs_bmap_add_extent_delay_real(
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-				bma->firstblock, bma->flist, &bma->cur, 1,
+				bma->firstblock, bma->dfops, &bma->cur, 1,
 				&tmp_rval, whichfork);
 			rval |= tmp_rval;
 			if (error)
@@ -2115,7 +2115,7 @@ xfs_bmap_add_extent_delay_real(
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-					bma->firstblock, bma->flist, &bma->cur,
+					bma->firstblock, bma->dfops, &bma->cur,
 					1, &tmp_rval, whichfork);
 			rval |= tmp_rval;
 			if (error)
@@ -2164,7 +2164,7 @@ xfs_bmap_add_extent_delay_real(
 
 		ASSERT(bma->cur == NULL);
 		error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-				bma->firstblock, bma->flist, &bma->cur,
+				bma->firstblock, bma->dfops, &bma->cur,
 				da_old > 0, &tmp_logflags, whichfork);
 		bma->logflags |= tmp_logflags;
 		if (error)
@@ -2206,7 +2206,7 @@ xfs_bmap_add_extent_unwritten_real(
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
-	struct xfs_defer_ops	*flist,	/* list of extents to be freed */
+	struct xfs_defer_ops	*dfops,	/* list of extents to be freed */
 	int			*logflagsp) /* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor */
@@ -2699,7 +2699,7 @@ xfs_bmap_add_extent_unwritten_real(
 		int	tmp_logflags;	/* partial log flag return val */
 
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, first, flist, &cur,
+		error = xfs_bmap_extents_to_btree(tp, ip, first, dfops, &cur,
 				0, &tmp_logflags, XFS_DATA_FORK);
 		*logflagsp |= tmp_logflags;
 		if (error)
@@ -3092,7 +3092,7 @@ xfs_bmap_add_extent_hole_real(
 
 		ASSERT(bma->cur == NULL);
 		error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-				bma->firstblock, bma->flist, &bma->cur,
+				bma->firstblock, bma->dfops, &bma->cur,
 				0, &tmp_logflags, whichfork);
 		bma->logflags |= tmp_logflags;
 		if (error)
@@ -3667,7 +3667,7 @@ xfs_bmap_btalloc(
 			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
 		if (error)
 			return error;
-	} else if (ap->flist->dop_low) {
+	} else if (ap->dfops->dop_low) {
 		if (xfs_inode_is_filestream(ap->ip))
 			args.type = XFS_ALLOCTYPE_FIRST_AG;
 		else
@@ -3700,7 +3700,7 @@ xfs_bmap_btalloc(
 	 * is >= the stripe unit and the allocation offset is
 	 * at the end of file.
 	 */
-	if (!ap->flist->dop_low && ap->aeof) {
+	if (!ap->dfops->dop_low && ap->aeof) {
 		if (!ap->offset) {
 			args.alignment = stripe_align;
 			atype = args.type;
@@ -3793,7 +3793,7 @@ xfs_bmap_btalloc(
 		args.minleft = 0;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
-		ap->flist->dop_low = true;
+		ap->dfops->dop_low = true;
 	}
 	if (args.fsbno != NULLFSBLOCK) {
 		/*
@@ -3803,7 +3803,7 @@ xfs_bmap_btalloc(
 		ASSERT(*ap->firstblock == NULLFSBLOCK ||
 		       XFS_FSB_TO_AGNO(mp, *ap->firstblock) ==
 		       XFS_FSB_TO_AGNO(mp, args.fsbno) ||
-		       (ap->flist->dop_low &&
+		       (ap->dfops->dop_low &&
 			XFS_FSB_TO_AGNO(mp, *ap->firstblock) <
 			XFS_FSB_TO_AGNO(mp, args.fsbno)));
 
@@ -3811,7 +3811,7 @@ xfs_bmap_btalloc(
 		if (*ap->firstblock == NULLFSBLOCK)
 			*ap->firstblock = args.fsbno;
 		ASSERT(nullfb || fb_agno == args.agno ||
-		       (ap->flist->dop_low && fb_agno < args.agno));
+		       (ap->dfops->dop_low && fb_agno < args.agno));
 		ap->length = args.len;
 		ap->ip->i_d.di_nblocks += args.len;
 		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
@@ -4278,7 +4278,7 @@ xfs_bmapi_allocate(
 	if (error)
 		return error;
 
-	if (bma->flist->dop_low)
+	if (bma->dfops->dop_low)
 		bma->minleft = 0;
 	if (bma->cur)
 		bma->cur->bc_private.b.firstblock = *bma->firstblock;
@@ -4287,7 +4287,7 @@ xfs_bmapi_allocate(
 	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur) {
 		bma->cur = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
 		bma->cur->bc_private.b.firstblock = *bma->firstblock;
-		bma->cur->bc_private.b.flist = bma->flist;
+		bma->cur->bc_private.b.dfops = bma->dfops;
 	}
 	/*
 	 * Bump the number of extents we've allocated
@@ -4368,7 +4368,7 @@ xfs_bmapi_convert_unwritten(
 		bma->cur = xfs_bmbt_init_cursor(bma->ip->i_mount, bma->tp,
 					bma->ip, whichfork);
 		bma->cur->bc_private.b.firstblock = *bma->firstblock;
-		bma->cur->bc_private.b.flist = bma->flist;
+		bma->cur->bc_private.b.dfops = bma->dfops;
 	}
 	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
 				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
@@ -4385,7 +4385,7 @@ xfs_bmapi_convert_unwritten(
 	}
 
 	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, &bma->idx,
-			&bma->cur, mval, bma->firstblock, bma->flist,
+			&bma->cur, mval, bma->firstblock, bma->dfops,
 			&tmp_logflags);
 	/*
 	 * Log the inode core unconditionally in the unwritten extent conversion
@@ -4439,7 +4439,7 @@ xfs_bmapi_write(
 	xfs_extlen_t		total,		/* total blocks needed */
 	struct xfs_bmbt_irec	*mval,		/* output: map values */
 	int			*nmap,		/* i/o: mval size/count */
-	struct xfs_defer_ops	*flist)		/* i/o: list extents to free */
+	struct xfs_defer_ops	*dfops)		/* i/o: list extents to free */
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp;
@@ -4529,7 +4529,7 @@ xfs_bmapi_write(
 	bma.ip = ip;
 	bma.total = total;
 	bma.userdata = 0;
-	bma.flist = flist;
+	bma.dfops = dfops;
 	bma.firstblock = firstblock;
 
 	while (bno < end && n < *nmap) {
@@ -4643,7 +4643,7 @@ error0:
 			       XFS_FSB_TO_AGNO(mp, *firstblock) ==
 			       XFS_FSB_TO_AGNO(mp,
 				       bma.cur->bc_private.b.firstblock) ||
-			       (flist->dop_low &&
+			       (dfops->dop_low &&
 				XFS_FSB_TO_AGNO(mp, *firstblock) <
 				XFS_FSB_TO_AGNO(mp,
 					bma.cur->bc_private.b.firstblock)));
@@ -4727,7 +4727,7 @@ xfs_bmap_del_extent(
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_trans_t		*tp,	/* current transaction pointer */
 	xfs_extnum_t		*idx,	/* extent number to update/delete */
-	struct xfs_defer_ops	*flist,	/* list of extents to be freed */
+	struct xfs_defer_ops	*dfops,	/* list of extents to be freed */
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
 	int			*logflagsp, /* inode logging flags */
@@ -5015,7 +5015,7 @@ xfs_bmap_del_extent(
 	 * If we need to, add to list of extents to delete.
 	 */
 	if (do_fx)
-		xfs_bmap_add_free(mp, flist, del->br_startblock,
+		xfs_bmap_add_free(mp, dfops, del->br_startblock,
 			del->br_blockcount);
 	/*
 	 * Adjust inode # blocks in the file.
@@ -5056,7 +5056,7 @@ xfs_bunmapi(
 	xfs_extnum_t		nexts,		/* number of extents max */
 	xfs_fsblock_t		*firstblock,	/* first allocated block
 						   controls a.g. for allocs */
-	struct xfs_defer_ops	*flist,		/* i/o: list extents to free */
+	struct xfs_defer_ops	*dfops,		/* i/o: list extents to free */
 	int			*done)		/* set if not done yet */
 {
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
@@ -5129,7 +5129,7 @@ xfs_bunmapi(
 		ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = *firstblock;
-		cur->bc_private.b.flist = flist;
+		cur->bc_private.b.dfops = dfops;
 		cur->bc_private.b.flags = 0;
 	} else
 		cur = NULL;
@@ -5221,7 +5221,7 @@ xfs_bunmapi(
 			}
 			del.br_state = XFS_EXT_UNWRITTEN;
 			error = xfs_bmap_add_extent_unwritten_real(tp, ip,
-					&lastx, &cur, &del, firstblock, flist,
+					&lastx, &cur, &del, firstblock, dfops,
 					&logflags);
 			if (error)
 				goto error0;
@@ -5280,7 +5280,7 @@ xfs_bunmapi(
 				lastx--;
 				error = xfs_bmap_add_extent_unwritten_real(tp,
 						ip, &lastx, &cur, &prev,
-						firstblock, flist, &logflags);
+						firstblock, dfops, &logflags);
 				if (error)
 					goto error0;
 				goto nodelete;
@@ -5289,7 +5289,7 @@ xfs_bunmapi(
 				del.br_state = XFS_EXT_UNWRITTEN;
 				error = xfs_bmap_add_extent_unwritten_real(tp,
 						ip, &lastx, &cur, &del,
-						firstblock, flist, &logflags);
+						firstblock, dfops, &logflags);
 				if (error)
 					goto error0;
 				goto nodelete;
@@ -5347,7 +5347,7 @@ xfs_bunmapi(
 		} else if (cur)
 			cur->bc_private.b.flags &= ~XFS_BTCUR_BPRV_WASDEL;
 
-		error = xfs_bmap_del_extent(ip, tp, &lastx, flist, cur, &del,
+		error = xfs_bmap_del_extent(ip, tp, &lastx, dfops, cur, &del,
 				&tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 		if (error)
@@ -5381,7 +5381,7 @@ nodelete:
 	 */
 	if (xfs_bmap_needs_btree(ip, whichfork)) {
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, firstblock, flist,
+		error = xfs_bmap_extents_to_btree(tp, ip, firstblock, dfops,
 			&cur, 0, &tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 		if (error)
@@ -5670,7 +5670,7 @@ xfs_bmap_shift_extents(
 	int			*done,
 	xfs_fileoff_t		stop_fsb,
 	xfs_fsblock_t		*firstblock,
-	struct xfs_defer_ops	*flist,
+	struct xfs_defer_ops	*dfops,
 	enum shift_direction	direction,
 	int			num_exts)
 {
@@ -5715,7 +5715,7 @@ xfs_bmap_shift_extents(
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = *firstblock;
-		cur->bc_private.b.flist = flist;
+		cur->bc_private.b.dfops = dfops;
 		cur->bc_private.b.flags = 0;
 	}
 
@@ -5824,7 +5824,7 @@ xfs_bmap_split_extent_at(
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		split_fsb,
 	xfs_fsblock_t		*firstfsb,
-	struct xfs_defer_ops	*free_list)
+	struct xfs_defer_ops	*dfops)
 {
 	int				whichfork = XFS_DATA_FORK;
 	struct xfs_btree_cur		*cur = NULL;
@@ -5886,7 +5886,7 @@ xfs_bmap_split_extent_at(
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = *firstfsb;
-		cur->bc_private.b.flist = free_list;
+		cur->bc_private.b.dfops = dfops;
 		cur->bc_private.b.flags = 0;
 		error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
 				got.br_startblock,
@@ -5939,7 +5939,7 @@ xfs_bmap_split_extent_at(
 		int tmp_logflags; /* partial log flag return val */
 
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, firstfsb, free_list,
+		error = xfs_bmap_extents_to_btree(tp, ip, firstfsb, dfops,
 				&cur, 0, &tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 	}
@@ -5963,7 +5963,7 @@ xfs_bmap_split_extent(
 {
 	struct xfs_mount        *mp = ip->i_mount;
 	struct xfs_trans        *tp;
-	struct xfs_defer_ops    free_list;
+	struct xfs_defer_ops    dfops;
 	xfs_fsblock_t           firstfsb;
 	int                     error;
 
@@ -5975,21 +5975,21 @@ xfs_bmap_split_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-	xfs_defer_init(&free_list, &firstfsb);
+	xfs_defer_init(&dfops, &firstfsb);
 
 	error = xfs_bmap_split_extent_at(tp, ip, split_fsb,
-			&firstfsb, &free_list);
+			&firstfsb, &dfops);
 	if (error)
 		goto out;
 
-	error = xfs_defer_finish(&tp, &free_list, NULL);
+	error = xfs_defer_finish(&tp, &dfops, NULL);
 	if (error)
 		goto out;
 
 	return xfs_trans_commit(tp);
 
 out:
-	xfs_defer_cancel(&free_list);
+	xfs_defer_cancel(&dfops);
 	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index a779cc5..6854e61 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -32,7 +32,7 @@ extern kmem_zone_t	*xfs_bmap_free_item_zone;
  */
 struct xfs_bmalloca {
 	xfs_fsblock_t		*firstblock; /* i/o first block allocated */
-	struct xfs_defer_ops	*flist;	/* bmap freelist */
+	struct xfs_defer_ops	*dfops;	/* bmap freelist */
 	struct xfs_trans	*tp;	/* transaction pointer */
 	struct xfs_inode	*ip;	/* incore inode pointer */
 	struct xfs_bmbt_irec	prev;	/* extent before the new one */
@@ -164,7 +164,7 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
-void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *flist,
+void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
 			  xfs_fsblock_t bno, xfs_filblks_t len);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
@@ -186,18 +186,18 @@ int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
 		xfs_fsblock_t *firstblock, xfs_extlen_t total,
 		struct xfs_bmbt_irec *mval, int *nmap,
-		struct xfs_defer_ops *flist);
+		struct xfs_defer_ops *dfops);
 int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
 		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
-		struct xfs_defer_ops *flist, int *done);
+		struct xfs_defer_ops *dfops, int *done);
 int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
 		xfs_extnum_t num);
 uint	xfs_default_attroffset(struct xfs_inode *ip);
 int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
 		int *done, xfs_fileoff_t stop_fsb, xfs_fsblock_t *firstblock,
-		struct xfs_defer_ops *flist, enum shift_direction direction,
+		struct xfs_defer_ops *dfops, enum shift_direction direction,
 		int num_exts);
 int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
 
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 8d4d4b0..d290769 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -404,11 +404,11 @@ xfs_bmbt_dup_cursor(
 			cur->bc_private.b.ip, cur->bc_private.b.whichfork);
 
 	/*
-	 * Copy the firstblock, flist, and flags values,
+	 * Copy the firstblock, dfops, and flags values,
 	 * since init cursor doesn't get them.
 	 */
 	new->bc_private.b.firstblock = cur->bc_private.b.firstblock;
-	new->bc_private.b.flist = cur->bc_private.b.flist;
+	new->bc_private.b.dfops = cur->bc_private.b.dfops;
 	new->bc_private.b.flags = cur->bc_private.b.flags;
 
 	return new;
@@ -421,7 +421,7 @@ xfs_bmbt_update_cursor(
 {
 	ASSERT((dst->bc_private.b.firstblock != NULLFSBLOCK) ||
 	       (dst->bc_private.b.ip->i_d.di_flags & XFS_DIFLAG_REALTIME));
-	ASSERT(dst->bc_private.b.flist == src->bc_private.b.flist);
+	ASSERT(dst->bc_private.b.dfops == src->bc_private.b.dfops);
 
 	dst->bc_private.b.allocated += src->bc_private.b.allocated;
 	dst->bc_private.b.firstblock = src->bc_private.b.firstblock;
@@ -460,7 +460,7 @@ xfs_bmbt_alloc_block(
 		 * block allocation here and corrupt the filesystem.
 		 */
 		args.minleft = args.tp->t_blk_res;
-	} else if (cur->bc_private.b.flist->dop_low) {
+	} else if (cur->bc_private.b.dfops->dop_low) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else {
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
@@ -488,7 +488,7 @@ xfs_bmbt_alloc_block(
 		error = xfs_alloc_vextent(&args);
 		if (error)
 			goto error0;
-		cur->bc_private.b.flist->dop_low = true;
+		cur->bc_private.b.dfops->dop_low = true;
 	}
 	if (args.fsbno == NULLFSBLOCK) {
 		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
@@ -524,7 +524,7 @@ xfs_bmbt_free_block(
 	struct xfs_trans	*tp = cur->bc_tp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 
-	xfs_bmap_add_free(mp, cur->bc_private.b.flist, fsbno, 1);
+	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, fsbno, 1);
 	ip->i_d.di_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
@@ -786,7 +786,7 @@ xfs_bmbt_init_cursor(
 	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
 	cur->bc_private.b.ip = ip;
 	cur->bc_private.b.firstblock = NULLFSBLOCK;
-	cur->bc_private.b.flist = NULL;
+	cur->bc_private.b.dfops = NULL;
 	cur->bc_private.b.allocated = 0;
 	cur->bc_private.b.flags = 0;
 	cur->bc_private.b.whichfork = whichfork;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index ae714a8..7483cac 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -234,12 +234,12 @@ typedef struct xfs_btree_cur
 	union {
 		struct {			/* needed for BNO, CNT, INO */
 			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
-			struct xfs_defer_ops *flist;	/* deferred updates */
+			struct xfs_defer_ops *dfops;	/* deferred updates */
 			xfs_agnumber_t	agno;	/* ag number */
 		} a;
 		struct {			/* needed for BMAP */
 			struct xfs_inode *ip;	/* pointer to our inode */
-			struct xfs_defer_ops *flist;	/* deferred updates */
+			struct xfs_defer_ops *dfops;	/* deferred updates */
 			xfs_fsblock_t	firstblock;	/* 1st blk allocated */
 			int		allocated;	/* count of alloced */
 			short		forksize;	/* fork's inode space */
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 298252e..bf24ade 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2025,7 +2025,7 @@ xfs_da_grow_inode_int(
 	error = xfs_bmapi_write(tp, dp, *bno, count,
 			xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
 			args->firstblock, args->total, &map, &nmap,
-			args->flist);
+			args->dfops);
 	if (error)
 		return error;
 
@@ -2048,7 +2048,7 @@ xfs_da_grow_inode_int(
 			error = xfs_bmapi_write(tp, dp, b, c,
 					xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
 					args->firstblock, args->total,
-					&mapp[mapi], &nmap, args->flist);
+					&mapp[mapi], &nmap, args->dfops);
 			if (error)
 				goto out_free_map;
 			if (nmap < 1)
@@ -2358,7 +2358,7 @@ xfs_da_shrink_inode(
 		 */
 		error = xfs_bunmapi(tp, dp, dead_blkno, count,
 				    xfs_bmapi_aflag(w), 0, args->firstblock,
-				    args->flist, &done);
+				    args->dfops, &done);
 		if (error == -ENOSPC) {
 			if (w != XFS_DATA_FORK)
 				break;
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 249813a..98c75cb 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -70,7 +70,7 @@ typedef struct xfs_da_args {
 	xfs_ino_t	inumber;	/* input/output inode number */
 	struct xfs_inode *dp;		/* directory inode to manipulate */
 	xfs_fsblock_t	*firstblock;	/* ptr to firstblock for bmap calls */
-	struct xfs_defer_ops *flist;	/* ptr to freelist for bmap_finish */
+	struct xfs_defer_ops *dfops;	/* ptr to freelist for bmap_finish */
 	struct xfs_trans *trans;	/* current trans (changes over time) */
 	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
 	int		whichfork;	/* data or attribute fork */
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 6edaa8e..4180a93 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -258,7 +258,7 @@ xfs_dir_createname(
 	struct xfs_name		*name,
 	xfs_ino_t		inum,		/* new entry inode number */
 	xfs_fsblock_t		*first,		/* bmap's firstblock */
-	struct xfs_defer_ops	*flist,		/* bmap's freeblock list */
+	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
 	struct xfs_da_args	*args;
@@ -285,7 +285,7 @@ xfs_dir_createname(
 	args->inumber = inum;
 	args->dp = dp;
 	args->firstblock = first;
-	args->flist = flist;
+	args->dfops = dfops;
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
@@ -435,7 +435,7 @@ xfs_dir_removename(
 	struct xfs_name	*name,
 	xfs_ino_t	ino,
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
-	struct xfs_defer_ops	*flist,		/* bmap's freeblock list */
+	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
 	xfs_extlen_t	total)		/* bmap's total block count */
 {
 	struct xfs_da_args *args;
@@ -457,7 +457,7 @@ xfs_dir_removename(
 	args->inumber = ino;
 	args->dp = dp;
 	args->firstblock = first;
-	args->flist = flist;
+	args->dfops = dfops;
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
@@ -497,7 +497,7 @@ xfs_dir_replace(
 	struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t	inum,		/* new inode number */
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
-	struct xfs_defer_ops	*flist,		/* bmap's freeblock list */
+	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
 	xfs_extlen_t	total)		/* bmap's total block count */
 {
 	struct xfs_da_args *args;
@@ -522,7 +522,7 @@ xfs_dir_replace(
 	args->inumber = inum;
 	args->dp = dp;
 	args->firstblock = first;
-	args->flist = flist;
+	args->dfops = dfops;
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
@@ -679,7 +679,7 @@ xfs_dir2_shrink_inode(
 
 	/* Unmap the fsblock(s). */
 	error = xfs_bunmapi(tp, dp, da, args->geo->fsbcount, 0, 0,
-			    args->firstblock, args->flist, &done);
+			    args->firstblock, args->dfops, &done);
 	if (error) {
 		/*
 		 * ENOSPC actually can happen if we're in a removename with no
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 5737d85..a9bab0e 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -129,18 +129,18 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_fsblock_t *first,
-				struct xfs_defer_ops *flist, xfs_extlen_t tot);
+				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_fsblock_t *first,
-				struct xfs_defer_ops *flist, xfs_extlen_t tot);
+				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_fsblock_t *first,
-				struct xfs_defer_ops *flist, xfs_extlen_t tot);
+				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index d03570c..1545338 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1812,7 +1812,7 @@ xfs_difree_inode_chunk(
 	struct xfs_mount		*mp,
 	xfs_agnumber_t			agno,
 	struct xfs_inobt_rec_incore	*rec,
-	struct xfs_defer_ops		*flist)
+	struct xfs_defer_ops		*dfops)
 {
 	xfs_agblock_t	sagbno = XFS_AGINO_TO_AGBNO(mp, rec->ir_startino);
 	int		startidx, endidx;
@@ -1823,7 +1823,7 @@ xfs_difree_inode_chunk(
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
-		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, sagbno),
+		xfs_bmap_add_free(mp, dfops, XFS_AGB_TO_FSB(mp, agno, sagbno),
 				  mp->m_ialloc_blks);
 		return;
 	}
@@ -1867,7 +1867,7 @@ xfs_difree_inode_chunk(
 
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
-		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, agbno),
+		xfs_bmap_add_free(mp, dfops, XFS_AGB_TO_FSB(mp, agno, agbno),
 				  contigblk);
 
 		/* reset range to current bit and carry on... */
@@ -1884,7 +1884,7 @@ xfs_difree_inobt(
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
 	xfs_agino_t			agino,
-	struct xfs_defer_ops		*flist,
+	struct xfs_defer_ops		*dfops,
 	struct xfs_icluster		*xic,
 	struct xfs_inobt_rec_incore	*orec)
 {
@@ -1971,7 +1971,7 @@ xfs_difree_inobt(
 			goto error0;
 		}
 
-		xfs_difree_inode_chunk(mp, agno, &rec, flist);
+		xfs_difree_inode_chunk(mp, agno, &rec, dfops);
 	} else {
 		xic->deleted = 0;
 
@@ -2116,7 +2116,7 @@ int
 xfs_difree(
 	struct xfs_trans	*tp,		/* transaction pointer */
 	xfs_ino_t		inode,		/* inode to be freed */
-	struct xfs_defer_ops	*flist,		/* extents to free */
+	struct xfs_defer_ops	*dfops,		/* extents to free */
 	struct xfs_icluster	*xic)	/* cluster info if deleted */
 {
 	/* REFERENCED */
@@ -2168,7 +2168,7 @@ xfs_difree(
 	/*
 	 * Fix up the inode allocation btree.
 	 */
-	error = xfs_difree_inobt(mp, tp, agbp, agino, flist, xic, &rec);
+	error = xfs_difree_inobt(mp, tp, agbp, agino, dfops, xic, &rec);
 	if (error)
 		goto error0;
 
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index 2e06b67..0bb8966 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -95,7 +95,7 @@ int					/* error */
 xfs_difree(
 	struct xfs_trans *tp,		/* transaction pointer */
 	xfs_ino_t	inode,		/* inode to be freed */
-	struct xfs_defer_ops *flist,	/* extents to free */
+	struct xfs_defer_ops *dfops,	/* extents to free */
 	struct xfs_icluster *ifree);	/* cluster info if deleted */
 
 /*
diff --git a/mkfs/proto.c b/mkfs/proto.c
index f0c33e4..cf9ed77 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -27,7 +27,7 @@ static char *getstr(char **pp);
 static void fail(char *msg, int i);
 static void getres(struct xfs_mount *mp, uint blocks, struct xfs_trans **tpp);
 static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
-static int newfile(xfs_trans_t *tp, xfs_inode_t *ip, struct xfs_defer_ops *flist,
+static int newfile(xfs_trans_t *tp, xfs_inode_t *ip, struct xfs_defer_ops *dfops,
 	xfs_fsblock_t *first, int dolocal, int logit, char *buf, int len);
 static char *newregfile(char **pp, int *len);
 static void rtinit(xfs_mount_t *mp);
@@ -236,7 +236,7 @@ static int
 newfile(
 	xfs_trans_t	*tp,
 	xfs_inode_t	*ip,
-	struct xfs_defer_ops	*flist,
+	struct xfs_defer_ops	*dfops,
 	xfs_fsblock_t	*first,
 	int		dolocal,
 	int		logit,
@@ -267,7 +267,7 @@ newfile(
 		nb = XFS_B_TO_FSB(mp, len);
 		nmap = 1;
 		error = -libxfs_bmapi_write(tp, ip, 0, nb, 0, first, nb,
-				&map, &nmap, flist);
+				&map, &nmap, dfops);
 		if (error) {
 			fail(_("error allocating space for a file"), error);
 		}
@@ -329,14 +329,14 @@ newdirent(
 	struct xfs_name	*name,
 	xfs_ino_t	inum,
 	xfs_fsblock_t	*first,
-	struct xfs_defer_ops	*flist)
+	struct xfs_defer_ops	*dfops)
 {
 	int	error;
 	int	rsv;
 
 	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
 
-	error = -libxfs_dir_createname(tp, pip, name, inum, first, flist, rsv);
+	error = -libxfs_dir_createname(tp, pip, name, inum, first, dfops, rsv);
 	if (error)
 		fail(_("directory createname error"), error);
 }
@@ -375,7 +375,7 @@ parseproto(
 	int		error;
 	xfs_fsblock_t	first;
 	int		flags;
-	struct xfs_defer_ops	flist;
+	struct xfs_defer_ops	dfops;
 	int		fmt;
 	int		i;
 	xfs_inode_t	*ip;
@@ -460,7 +460,7 @@ parseproto(
 	xname.len = name ? strlen(name) : 0;
 	xname.type = 0;
 	flags = XFS_ILOG_CORE;
-	xfs_defer_init(&flist, &first);
+	xfs_defer_init(&dfops, &first);
 	switch (fmt) {
 	case IF_REGULAR:
 		buf = newregfile(pp, &len);
@@ -469,12 +469,12 @@ parseproto(
 					   &creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
-		flags |= newfile(tp, ip, &flist, &first, 0, 0, buf, len);
+		flags |= newfile(tp, ip, &dfops, &first, 0, 0, buf, len);
 		if (buf)
 			free(buf);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_REG_FILE;
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
 		break;
 
 	case IF_RESERVED:			/* pre-allocated space only */
@@ -497,10 +497,10 @@ parseproto(
 		libxfs_trans_ijoin(tp, pip, 0);
 
 		xname.type = XFS_DIR3_FT_REG_FILE;
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
 		libxfs_trans_log_inode(tp, ip, flags);
 
-		error = -xfs_defer_finish(&tp, &flist, ip);
+		error = -xfs_defer_finish(&tp, &dfops, ip);
 		if (error)
 			fail(_("Pre-allocated file creation failed"), error);
 		libxfs_trans_commit(tp);
@@ -519,7 +519,7 @@ parseproto(
 		}
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_BLKDEV;
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
 		flags |= XFS_ILOG_DEV;
 		break;
 
@@ -533,7 +533,7 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_CHRDEV;
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
 		flags |= XFS_ILOG_DEV;
 		break;
 
@@ -545,7 +545,7 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_FIFO;
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
 		break;
 	case IF_SYMLINK:
 		buf = getstr(pp);
@@ -555,10 +555,10 @@ parseproto(
 				&creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
-		flags |= newfile(tp, ip, &flist, &first, 1, 1, buf, len);
+		flags |= newfile(tp, ip, &dfops, &first, 1, 1, buf, len);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_SYMLINK;
-		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
+		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
 		break;
 	case IF_DIRECTORY:
 		getres(mp, 0, &tp);
@@ -576,13 +576,13 @@ parseproto(
 			libxfs_trans_ijoin(tp, pip, 0);
 			xname.type = XFS_DIR3_FT_DIR;
 			newdirent(mp, tp, pip, &xname, ip->i_ino,
-				  &first, &flist);
+				  &first, &dfops);
 			inc_nlink(VFS_I(pip));
 			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 		}
 		newdirectory(mp, tp, ip, pip);
 		libxfs_trans_log_inode(tp, ip, flags);
-		error = -xfs_defer_finish(&tp, &flist, ip);
+		error = -xfs_defer_finish(&tp, &dfops, ip);
 		if (error)
 			fail(_("Directory creation failed"), error);
 		libxfs_trans_commit(tp);
@@ -608,7 +608,7 @@ parseproto(
 		fail(_("Unknown format"), EINVAL);
 	}
 	libxfs_trans_log_inode(tp, ip, flags);
-	error = -xfs_defer_finish(&tp, &flist, ip);
+	error = -xfs_defer_finish(&tp, &dfops, ip);
 	if (error) {
 		fail(_("Error encountered creating file from prototype file"),
 			error);
@@ -638,7 +638,7 @@ rtinit(
 	xfs_bmbt_irec_t	*ep;
 	int		error;
 	xfs_fsblock_t	first;
-	struct xfs_defer_ops	flist;
+	struct xfs_defer_ops	dfops;
 	int		i;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
 	xfs_extlen_t	nsumblocks;
@@ -697,13 +697,13 @@ rtinit(
 
 	libxfs_trans_ijoin(tp, rbmip, 0);
 	bno = 0;
-	xfs_defer_init(&flist, &first);
+	xfs_defer_init(&dfops, &first);
 	while (bno < mp->m_sb.sb_rbmblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = -libxfs_bmapi_write(tp, rbmip, bno,
 				(xfs_extlen_t)(mp->m_sb.sb_rbmblocks - bno),
 				0, &first, mp->m_sb.sb_rbmblocks,
-				map, &nmap, &flist);
+				map, &nmap, &dfops);
 		if (error) {
 			fail(_("Allocation of the realtime bitmap failed"),
 				error);
@@ -716,7 +716,7 @@ rtinit(
 		}
 	}
 
-	error = -xfs_defer_finish(&tp, &flist, rbmip);
+	error = -xfs_defer_finish(&tp, &dfops, rbmip);
 	if (error) {
 		fail(_("Completion of the realtime bitmap failed"), error);
 	}
@@ -732,13 +732,13 @@ rtinit(
 		res_failed(i);
 	libxfs_trans_ijoin(tp, rsumip, 0);
 	bno = 0;
-	xfs_defer_init(&flist, &first);
+	xfs_defer_init(&dfops, &first);
 	while (bno < nsumblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = -libxfs_bmapi_write(tp, rsumip, bno,
 				(xfs_extlen_t)(nsumblocks - bno),
 				0, &first, nsumblocks,
-				map, &nmap, &flist);
+				map, &nmap, &dfops);
 		if (error) {
 			fail(_("Allocation of the realtime summary failed"),
 				error);
@@ -750,7 +750,7 @@ rtinit(
 			bno += ep->br_blockcount;
 		}
 	}
-	error = -xfs_defer_finish(&tp, &flist, rsumip);
+	error = -xfs_defer_finish(&tp, &dfops, rsumip);
 	if (error) {
 		fail(_("Completion of the realtime summary failed"), error);
 	}
@@ -765,7 +765,7 @@ rtinit(
 		if (i)
 			res_failed(i);
 		libxfs_trans_ijoin(tp, rbmip, 0);
-		xfs_defer_init(&flist, &first);
+		xfs_defer_init(&dfops, &first);
 		ebno = XFS_RTMIN(mp->m_sb.sb_rextents,
 			bno + NBBY * mp->m_sb.sb_blocksize);
 		error = -libxfs_rtfree_extent(tp, bno, (xfs_extlen_t)(ebno-bno));
@@ -773,7 +773,7 @@ rtinit(
 			fail(_("Error initializing the realtime space"),
 				error);
 		}
-		error = -xfs_defer_finish(&tp, &flist, rbmip);
+		error = -xfs_defer_finish(&tp, &dfops, rbmip);
 		if (error) {
 			fail(_("Error completing the realtime space"), error);
 		}
diff --git a/repair/phase6.c b/repair/phase6.c
index 961f7bc..0194580 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -484,7 +484,7 @@ mk_rbmino(xfs_mount_t *mp)
 	int		i;
 	int		nmap;
 	int		error;
-	struct xfs_defer_ops	flist;
+	struct xfs_defer_ops	dfops;
 	xfs_fileoff_t	bno;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
 	int		vers;
@@ -550,13 +550,13 @@ mk_rbmino(xfs_mount_t *mp)
 
 	libxfs_trans_ijoin(tp, ip, 0);
 	bno = 0;
-	xfs_defer_init(&flist, &first);
+	xfs_defer_init(&dfops, &first);
 	while (bno < mp->m_sb.sb_rbmblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = -libxfs_bmapi_write(tp, ip, bno,
 			  (xfs_extlen_t)(mp->m_sb.sb_rbmblocks - bno),
 			  0, &first, mp->m_sb.sb_rbmblocks,
-			  map, &nmap, &flist);
+			  map, &nmap, &dfops);
 		if (error) {
 			do_error(
 			_("couldn't allocate realtime bitmap, error = %d\n"),
@@ -569,7 +569,7 @@ mk_rbmino(xfs_mount_t *mp)
 			bno += ep->br_blockcount;
 		}
 	}
-	error = -xfs_defer_finish(&tp, &flist, ip);
+	error = -xfs_defer_finish(&tp, &dfops, ip);
 	if (error) {
 		do_error(
 		_("allocation of the realtime bitmap failed, error = %d\n"),
@@ -731,7 +731,7 @@ mk_rsumino(xfs_mount_t *mp)
 	int		nmap;
 	int		error;
 	int		nsumblocks;
-	struct xfs_defer_ops	flist;
+	struct xfs_defer_ops	dfops;
 	xfs_fileoff_t	bno;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
 	int		vers;
@@ -789,7 +789,7 @@ mk_rsumino(xfs_mount_t *mp)
 	 * then allocate blocks for file and fill with zeroes (stolen
 	 * from mkfs)
 	 */
-	xfs_defer_init(&flist, &first);
+	xfs_defer_init(&dfops, &first);
 
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
 	tres.tr_logres = BBTOB(128);
@@ -803,12 +803,12 @@ mk_rsumino(xfs_mount_t *mp)
 
 	libxfs_trans_ijoin(tp, ip, 0);
 	bno = 0;
-	xfs_defer_init(&flist, &first);
+	xfs_defer_init(&dfops, &first);
 	while (bno < nsumblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = -libxfs_bmapi_write(tp, ip, bno,
 			  (xfs_extlen_t)(nsumblocks - bno),
-			  0, &first, nsumblocks, map, &nmap, &flist);
+			  0, &first, nsumblocks, map, &nmap, &dfops);
 		if (error) {
 			do_error(
 		_("couldn't allocate realtime summary inode, error = %d\n"),
@@ -821,7 +821,7 @@ mk_rsumino(xfs_mount_t *mp)
 			bno += ep->br_blockcount;
 		}
 	}
-	error = -xfs_defer_finish(&tp, &flist, ip);
+	error = -xfs_defer_finish(&tp, &dfops, ip);
 	if (error) {
 		do_error(
 	_("allocation of the realtime summary ino failed, error = %d\n"),
@@ -919,7 +919,7 @@ mk_orphanage(xfs_mount_t *mp)
 	int		ino_offset = 0;
 	int		i;
 	int		error;
-	struct xfs_defer_ops	flist;
+	struct xfs_defer_ops	dfops;
 	const int	mode = 0755;
 	int		nres;
 	struct xfs_name	xname;
@@ -945,7 +945,7 @@ mk_orphanage(xfs_mount_t *mp)
 	 * could not be found, create it
 	 */
 
-	xfs_defer_init(&flist, &first);
+	xfs_defer_init(&dfops, &first);
 
 	nres = XFS_MKDIR_SPACE_RES(mp, xname.len);
 	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir, nres, 0, 0, &tp);
@@ -1007,7 +1007,7 @@ mk_orphanage(xfs_mount_t *mp)
 	 * create the actual entry
 	 */
 	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, &first,
-					&flist, nres);
+					&dfops, nres);
 	if (error)
 		do_error(
 		_("can't make %s, createname error %d\n"),
@@ -1028,7 +1028,7 @@ mk_orphanage(xfs_mount_t *mp)
 	libxfs_dir_init(tp, ip, pip);
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	error = -xfs_defer_finish(&tp, &flist, ip);
+	error = -xfs_defer_finish(&tp, &dfops, ip);
 	if (error) {
 		do_error(_("%s directory creation failed -- bmapf error %d\n"),
 			ORPHANAGE, error);
@@ -1057,7 +1057,7 @@ mv_orphanage(
 	xfs_inode_t		*ino_p;
 	xfs_trans_t		*tp;
 	xfs_fsblock_t		first;
-	struct xfs_defer_ops	flist;
+	struct xfs_defer_ops	dfops;
 	int			err;
 	unsigned char		fname[MAXPATHLEN + 1];
 	int			nres;
@@ -1110,9 +1110,9 @@ mv_orphanage(
 			libxfs_trans_ijoin(tp, orphanage_ip, 0);
 			libxfs_trans_ijoin(tp, ino_p, 0);
 
-			xfs_defer_init(&flist, &first);
+			xfs_defer_init(&dfops, &first);
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
-						ino, &first, &flist, nres);
+						ino, &first, &dfops, nres);
 			if (err)
 				do_error(
 	_("name create failed in %s (%d), filesystem may be out of space\n"),
@@ -1125,7 +1125,7 @@ mv_orphanage(
 			libxfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
 
 			err = -libxfs_dir_createname(tp, ino_p, &xfs_name_dotdot,
-					orphanage_ino, &first, &flist, nres);
+					orphanage_ino, &first, &dfops, nres);
 			if (err)
 				do_error(
 	_("creation of .. entry failed (%d), filesystem may be out of space\n"),
@@ -1134,7 +1134,7 @@ mv_orphanage(
 			inc_nlink(VFS_I(ino_p));
 			libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
 
-			err = -xfs_defer_finish(&tp, &flist, ino_p);
+			err = -xfs_defer_finish(&tp, &dfops, ino_p);
 			if (err)
 				do_error(
 	_("bmap finish failed (err - %d), filesystem may be out of space\n"),
@@ -1152,10 +1152,10 @@ mv_orphanage(
 			libxfs_trans_ijoin(tp, orphanage_ip, 0);
 			libxfs_trans_ijoin(tp, ino_p, 0);
 
-			xfs_defer_init(&flist, &first);
+			xfs_defer_init(&dfops, &first);
 
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
-						ino, &first, &flist, nres);
+						ino, &first, &dfops, nres);
 			if (err)
 				do_error(
 	_("name create failed in %s (%d), filesystem may be out of space\n"),
@@ -1174,14 +1174,14 @@ mv_orphanage(
 			if (entry_ino_num != orphanage_ino)  {
 				err = -libxfs_dir_replace(tp, ino_p,
 						&xfs_name_dotdot, orphanage_ino,
-						&first, &flist, nres);
+						&first, &dfops, nres);
 				if (err)
 					do_error(
 	_("name replace op failed (%d), filesystem may be out of space\n"),
 						err);
 			}
 
-			err = -xfs_defer_finish(&tp, &flist, ino_p);
+			err = -xfs_defer_finish(&tp, &dfops, ino_p);
 			if (err)
 				do_error(
 	_("bmap finish failed (%d), filesystem may be out of space\n"),
@@ -1208,9 +1208,9 @@ mv_orphanage(
 		libxfs_trans_ijoin(tp, orphanage_ip, 0);
 		libxfs_trans_ijoin(tp, ino_p, 0);
 
-		xfs_defer_init(&flist, &first);
+		xfs_defer_init(&dfops, &first);
 		err = -libxfs_dir_createname(tp, orphanage_ip, &xname, ino,
-						&first, &flist, nres);
+						&first, &dfops, nres);
 		if (err)
 			do_error(
 	_("name create failed in %s (%d), filesystem may be out of space\n"),
@@ -1220,7 +1220,7 @@ mv_orphanage(
 		set_nlink(VFS_I(ino_p), 1);
 		libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
 
-		err = -xfs_defer_finish(&tp, &flist, ino_p);
+		err = -xfs_defer_finish(&tp, &dfops, ino_p);
 		if (err)
 			do_error(
 	_("bmap finish failed (%d), filesystem may be out of space\n"),
@@ -1269,7 +1269,7 @@ longform_dir2_rebuild(
 	xfs_trans_t		*tp;
 	xfs_fileoff_t		lastblock;
 	xfs_fsblock_t		firstblock;
-	struct xfs_defer_ops	flist;
+	struct xfs_defer_ops	dfops;
 	xfs_inode_t		pip;
 	dir_hash_ent_t		*p;
 	int			done;
@@ -1292,7 +1292,7 @@ longform_dir2_rebuild(
 	    xfs_dir_ino_validate(mp, pip.i_ino))
 		pip.i_ino = mp->m_sb.sb_rootino;
 
-	xfs_defer_init(&flist, &firstblock);
+	xfs_defer_init(&dfops, &firstblock);
 
 	nres = XFS_REMOVE_SPACE_RES(mp);
 	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
@@ -1306,7 +1306,7 @@ longform_dir2_rebuild(
 
 	/* free all data, leaf, node and freespace blocks */
 	error = -libxfs_bunmapi(tp, ip, 0, lastblock, XFS_BMAPI_METADATA, 0,
-				&firstblock, &flist, &done);
+				&firstblock, &dfops, &done);
 	if (error) {
 		do_warn(_("xfs_bunmapi failed -- error - %d\n"), error);
 		goto out_bmap_cancel;
@@ -1320,7 +1320,7 @@ longform_dir2_rebuild(
 		goto out_bmap_cancel;
 	}
 
-	error = -xfs_defer_finish(&tp, &flist, ip);
+	error = -xfs_defer_finish(&tp, &dfops, ip);
 
 	libxfs_trans_commit(tp);
 
@@ -1344,9 +1344,9 @@ longform_dir2_rebuild(
 
 		libxfs_trans_ijoin(tp, ip, 0);
 
-		xfs_defer_init(&flist, &firstblock);
+		xfs_defer_init(&dfops, &firstblock);
 		error = -libxfs_dir_createname(tp, ip, &p->name, p->inum,
-						&firstblock, &flist, nres);
+						&firstblock, &dfops, nres);
 		if (error) {
 			do_warn(
 _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"),
@@ -1354,7 +1354,7 @@ _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"
 			goto out_bmap_cancel;
 		}
 
-		error = -xfs_defer_finish(&tp, &flist, ip);
+		error = -xfs_defer_finish(&tp, &dfops, ip);
 		if (error) {
 			do_warn(
 	_("bmap finish failed (%d), filesystem may be out of space\n"),
@@ -1368,7 +1368,7 @@ _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"
 	return;
 
 out_bmap_cancel:
-	xfs_defer_cancel(&flist);
+	xfs_defer_cancel(&dfops);
 	libxfs_trans_cancel(tp);
 	return;
 }
@@ -1388,7 +1388,7 @@ dir2_kill_block(
 	xfs_da_args_t	args;
 	int		error;
 	xfs_fsblock_t	firstblock;
-	struct xfs_defer_ops	flist;
+	struct xfs_defer_ops	dfops;
 	int		nres;
 	xfs_trans_t	*tp;
 
@@ -1399,11 +1399,11 @@ dir2_kill_block(
 	libxfs_trans_ijoin(tp, ip, 0);
 	libxfs_trans_bjoin(tp, bp);
 	memset(&args, 0, sizeof(args));
-	xfs_defer_init(&flist, &firstblock);
+	xfs_defer_init(&dfops, &firstblock);
 	args.dp = ip;
 	args.trans = tp;
 	args.firstblock = &firstblock;
-	args.flist = &flist;
+	args.dfops = &dfops;
 	args.whichfork = XFS_DATA_FORK;
 	args.geo = mp->m_dir_geo;
 	if (da_bno >= mp->m_dir_geo->leafblk && da_bno < mp->m_dir_geo->freeblk)
@@ -1414,7 +1414,7 @@ dir2_kill_block(
 	if (error)
 		do_error(_("shrink_inode failed inode %" PRIu64 " block %u\n"),
 			ip->i_ino, da_bno);
-	xfs_defer_finish(&tp, &flist, ip);
+	xfs_defer_finish(&tp, &dfops, ip);
 	libxfs_trans_commit(tp);
 }
 
@@ -1448,7 +1448,7 @@ longform_dir2_entry_check_data(
 	char			*endptr;
 	int			error;
 	xfs_fsblock_t		firstblock;
-	struct xfs_defer_ops	flist;
+	struct xfs_defer_ops	dfops;
 	char			fname[MAXNAMELEN + 1];
 	freetab_t		*freetab;
 	int			i;
@@ -1590,7 +1590,7 @@ longform_dir2_entry_check_data(
 	libxfs_trans_ijoin(tp, ip, 0);
 	libxfs_trans_bjoin(tp, bp);
 	libxfs_trans_bhold(tp, bp);
-	xfs_defer_init(&flist, &firstblock);
+	xfs_defer_init(&dfops, &firstblock);
 	if (be32_to_cpu(d->magic) != wantmagic) {
 		do_warn(
 	_("bad directory block magic # %#x for directory inode %" PRIu64 " block %d: "),
@@ -1889,7 +1889,7 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 		repair_dir2_data_freescan(mp, M_DIROPS(mp), d, &i);
 	if (needlog)
 		libxfs_dir2_data_log_header(&da, bp);
-	xfs_defer_finish(&tp, &flist, ip);
+	xfs_defer_finish(&tp, &dfops, ip);
 	libxfs_trans_commit(tp);
 
 	/* record the largest free space in the freetab for later checking */
@@ -2805,7 +2805,7 @@ process_dir_inode(
 	int			ino_offset)
 {
 	xfs_ino_t		ino;
-	struct xfs_defer_ops	flist;
+	struct xfs_defer_ops	dfops;
 	xfs_fsblock_t		first;
 	xfs_inode_t		*ip;
 	xfs_trans_t		*tp;
@@ -2943,17 +2943,17 @@ process_dir_inode(
 
 		libxfs_trans_ijoin(tp, ip, 0);
 
-		xfs_defer_init(&flist, &first);
+		xfs_defer_init(&dfops, &first);
 
 		error = -libxfs_dir_createname(tp, ip, &xfs_name_dotdot,
-					ip->i_ino, &first, &flist, nres);
+					ip->i_ino, &first, &dfops, nres);
 		if (error)
 			do_error(
 	_("can't make \"..\" entry in root inode %" PRIu64 ", createname error %d\n"), ino, error);
 
 		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-		error = -xfs_defer_finish(&tp, &flist, ip);
+		error = -xfs_defer_finish(&tp, &dfops, ip);
 		ASSERT(error == 0);
 		libxfs_trans_commit(tp);
 
@@ -3001,10 +3001,10 @@ process_dir_inode(
 
 			libxfs_trans_ijoin(tp, ip, 0);
 
-			xfs_defer_init(&flist, &first);
+			xfs_defer_init(&dfops, &first);
 
 			error = -libxfs_dir_createname(tp, ip, &xfs_name_dot,
-					ip->i_ino, &first, &flist, nres);
+					ip->i_ino, &first, &dfops, nres);
 			if (error)
 				do_error(
 	_("can't make \".\" entry in dir ino %" PRIu64 ", createname error %d\n"),
@@ -3012,7 +3012,7 @@ process_dir_inode(
 
 			libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-			error = -xfs_defer_finish(&tp, &flist, ip);
+			error = -xfs_defer_finish(&tp, &dfops, ip);
 			ASSERT(error == 0);
 			libxfs_trans_commit(tp);
 		}
diff --git a/repair/sb.c b/repair/sb.c
index 4eef14a..803125c 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -653,7 +653,7 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 
 		retval = get_sb(sb, off, size, agno);
 		if (retval == XR_EOF)
-			goto out_free_list;
+			goto out_dfops;
 
 		if (retval == XR_OK) {
 			/*
@@ -675,7 +675,7 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 	retval = 0;
 	if (num_ok < num_sbs / 2) {
 		retval = XR_INSUFF_SEC_SB;
-		goto out_free_list;
+		goto out_dfops;
 	}
 
 	current = get_best_geo(list);
@@ -703,7 +703,7 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 				exit(1);
 			}
 		}
-		goto out_free_list;
+		goto out_dfops;
 	case 1:
 		/*
 		 * If we only have a single allocation group there is no
@@ -718,7 +718,7 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 	  "Use the -o force_geometry option to proceed.\n"));
 			exit(1);
 		}
-		goto out_free_list;
+		goto out_dfops;
 	default:
 		/*
 		 * at least half of the probed superblocks have
@@ -758,7 +758,7 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 		sb_width = sb->sb_width;
 	}
 
-out_free_list:
+out_dfops:
 	free_geo(list);
 	free(sb);
 	return retval;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
