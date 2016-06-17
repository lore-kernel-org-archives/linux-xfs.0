Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C66E080AD
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:33:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 961A930404E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:29 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id mhGapm6kVpbNl6Ab (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:23 -0700 (PDT)
Subject: [PATCH 024/145] xfs: change xfs_bmap_{finish, cancel, init,
	free} -> xfs_defer_*
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:33:14 -0700
Message-ID: <146612719455.16048.11674455237736983086.stgit@birch.djwong.org>
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

Drop the compatibility shims that we were using to integrate the new
deferred operation mechanism into the existing code.  No new code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h         |    3 --
 libxfs/util.c            |    8 +++--
 libxfs/xfs_attr.c        |   58 ++++++++++++++++++++-------------------
 libxfs/xfs_attr_remote.c |   14 +++++----
 libxfs/xfs_bmap.c        |   38 +++++++++++++-------------
 libxfs/xfs_bmap.h        |   10 +++----
 libxfs/xfs_btree.h       |    5 ++-
 libxfs/xfs_da_btree.h    |    4 +--
 libxfs/xfs_defer.h       |    7 -----
 libxfs/xfs_dir2.c        |    6 ++--
 libxfs/xfs_dir2.h        |    8 +++--
 libxfs/xfs_ialloc.c      |    6 ++--
 libxfs/xfs_ialloc.h      |    2 +
 libxfs/xfs_trans_resv.c  |    4 +--
 mkfs/proto.c             |   30 ++++++++++----------
 repair/phase6.c          |   68 +++++++++++++++++++++++-----------------------
 16 files changed, 131 insertions(+), 140 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 71e758b..863b0e3 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -164,9 +164,6 @@ extern unsigned int	libxfs_log2_roundup(unsigned int i);
 
 extern int	libxfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
 				xfs_off_t, int, int);
-#define libxfs_bmap_finish	xfs_defer_finish
-#define libxfs_bmap_cancel	xfs_defer_cancel
-#define xfs_bmap_free_t		struct xfs_defer_ops
 
 extern void 	libxfs_fs_repair_cmn_err(int, struct xfs_mount *, char *, ...);
 extern void	libxfs_fs_cmn_err(int, struct xfs_mount *, char *, ...);
diff --git a/libxfs/util.c b/libxfs/util.c
index ab007b0..4b81818 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -493,7 +493,7 @@ libxfs_alloc_file_space(
 	xfs_filblks_t	allocated_fsb;
 	xfs_filblks_t	allocatesize_fsb;
 	xfs_fsblock_t	firstfsb;
-	xfs_bmap_free_t free_list;
+	struct xfs_defer_ops free_list;
 	xfs_bmbt_irec_t *imapp;
 	xfs_bmbt_irec_t imaps[1];
 	int		reccount;
@@ -535,7 +535,7 @@ libxfs_alloc_file_space(
 		}
 		xfs_trans_ijoin(tp, ip, 0);
 
-		xfs_bmap_init(&free_list, &firstfsb);
+		xfs_defer_init(&free_list, &firstfsb);
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb, allocatesize_fsb,
 				xfs_bmapi_flags, &firstfsb, 0, imapp,
 				&reccount, &free_list);
@@ -544,7 +544,7 @@ libxfs_alloc_file_space(
 			goto error0;
 
 		/* complete the transaction */
-		error = xfs_bmap_finish(&tp, &free_list, ip);
+		error = xfs_defer_finish(&tp, &free_list, ip);
 		if (error)
 			goto error0;
 
@@ -562,7 +562,7 @@ libxfs_alloc_file_space(
 	return error;
 
 error0:	/* Cancel bmap, cancel trans */
-	xfs_bmap_cancel(&free_list);
+	xfs_defer_cancel(&free_list);
 	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index ee370dc..06b3c5d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -199,7 +199,7 @@ xfs_attr_set(
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
-	struct xfs_bmap_free	flist;
+	struct xfs_defer_ops	flist;
 	struct xfs_trans_res	tres;
 	xfs_fsblock_t		firstblock;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
@@ -312,13 +312,13 @@ xfs_attr_set(
 		 * It won't fit in the shortform, transform to a leaf block.
 		 * GROT: another possible req'mt for a double-split btree op.
 		 */
-		xfs_bmap_init(args.flist, args.firstblock);
+		xfs_defer_init(args.flist, args.firstblock);
 		error = xfs_attr_shortform_to_leaf(&args);
 		if (!error)
-			error = xfs_bmap_finish(&args.trans, args.flist, dp);
+			error = xfs_defer_finish(&args.trans, args.flist, dp);
 		if (error) {
 			args.trans = NULL;
-			xfs_bmap_cancel(&flist);
+			xfs_defer_cancel(&flist);
 			goto out;
 		}
 
@@ -378,7 +378,7 @@ xfs_attr_remove(
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
-	struct xfs_bmap_free	flist;
+	struct xfs_defer_ops	flist;
 	xfs_fsblock_t		firstblock;
 	int			error;
 
@@ -580,13 +580,13 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * Commit that transaction so that the node_addname() call
 		 * can manage its own transactions.
 		 */
-		xfs_bmap_init(args->flist, args->firstblock);
+		xfs_defer_init(args->flist, args->firstblock);
 		error = xfs_attr3_leaf_to_node(args);
 		if (!error)
-			error = xfs_bmap_finish(&args->trans, args->flist, dp);
+			error = xfs_defer_finish(&args->trans, args->flist, dp);
 		if (error) {
 			args->trans = NULL;
-			xfs_bmap_cancel(args->flist);
+			xfs_defer_cancel(args->flist);
 			return error;
 		}
 
@@ -670,15 +670,15 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 * If the result is small enough, shrink it all into the inode.
 		 */
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			xfs_bmap_init(args->flist, args->firstblock);
+			xfs_defer_init(args->flist, args->firstblock);
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (!error)
-				error = xfs_bmap_finish(&args->trans,
+				error = xfs_defer_finish(&args->trans,
 							args->flist, dp);
 			if (error) {
 				args->trans = NULL;
-				xfs_bmap_cancel(args->flist);
+				xfs_defer_cancel(args->flist);
 				return error;
 			}
 		}
@@ -733,14 +733,14 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 	 * If the result is small enough, shrink it all into the inode.
 	 */
 	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-		xfs_bmap_init(args->flist, args->firstblock);
+		xfs_defer_init(args->flist, args->firstblock);
 		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (!error)
-			error = xfs_bmap_finish(&args->trans, args->flist, dp);
+			error = xfs_defer_finish(&args->trans, args->flist, dp);
 		if (error) {
 			args->trans = NULL;
-			xfs_bmap_cancel(args->flist);
+			xfs_defer_cancel(args->flist);
 			return error;
 		}
 	}
@@ -859,14 +859,14 @@ restart:
 			 */
 			xfs_da_state_free(state);
 			state = NULL;
-			xfs_bmap_init(args->flist, args->firstblock);
+			xfs_defer_init(args->flist, args->firstblock);
 			error = xfs_attr3_leaf_to_node(args);
 			if (!error)
-				error = xfs_bmap_finish(&args->trans,
+				error = xfs_defer_finish(&args->trans,
 							args->flist, dp);
 			if (error) {
 				args->trans = NULL;
-				xfs_bmap_cancel(args->flist);
+				xfs_defer_cancel(args->flist);
 				goto out;
 			}
 
@@ -887,13 +887,13 @@ restart:
 		 * in the index/blkno/rmtblkno/rmtblkcnt fields and
 		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
 		 */
-		xfs_bmap_init(args->flist, args->firstblock);
+		xfs_defer_init(args->flist, args->firstblock);
 		error = xfs_da3_split(state);
 		if (!error)
-			error = xfs_bmap_finish(&args->trans, args->flist, dp);
+			error = xfs_defer_finish(&args->trans, args->flist, dp);
 		if (error) {
 			args->trans = NULL;
-			xfs_bmap_cancel(args->flist);
+			xfs_defer_cancel(args->flist);
 			goto out;
 		}
 	} else {
@@ -986,14 +986,14 @@ restart:
 		 * Check to see if the tree needs to be collapsed.
 		 */
 		if (retval && (state->path.active > 1)) {
-			xfs_bmap_init(args->flist, args->firstblock);
+			xfs_defer_init(args->flist, args->firstblock);
 			error = xfs_da3_join(state);
 			if (!error)
-				error = xfs_bmap_finish(&args->trans,
+				error = xfs_defer_finish(&args->trans,
 							args->flist, dp);
 			if (error) {
 				args->trans = NULL;
-				xfs_bmap_cancel(args->flist);
+				xfs_defer_cancel(args->flist);
 				goto out;
 			}
 		}
@@ -1109,13 +1109,13 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	 * Check to see if the tree needs to be collapsed.
 	 */
 	if (retval && (state->path.active > 1)) {
-		xfs_bmap_init(args->flist, args->firstblock);
+		xfs_defer_init(args->flist, args->firstblock);
 		error = xfs_da3_join(state);
 		if (!error)
-			error = xfs_bmap_finish(&args->trans, args->flist, dp);
+			error = xfs_defer_finish(&args->trans, args->flist, dp);
 		if (error) {
 			args->trans = NULL;
-			xfs_bmap_cancel(args->flist);
+			xfs_defer_cancel(args->flist);
 			goto out;
 		}
 		/*
@@ -1142,15 +1142,15 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 			goto out;
 
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			xfs_bmap_init(args->flist, args->firstblock);
+			xfs_defer_init(args->flist, args->firstblock);
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (!error)
-				error = xfs_bmap_finish(&args->trans,
+				error = xfs_defer_finish(&args->trans,
 							args->flist, dp);
 			if (error) {
 				args->trans = NULL;
-				xfs_bmap_cancel(args->flist);
+				xfs_defer_cancel(args->flist);
 				goto out;
 			}
 		} else
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index ed4cc94..dc545f0 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -456,16 +456,16 @@ xfs_attr_rmtval_set(
 		 * extent and then crash then the block may not contain the
 		 * correct metadata after log recovery occurs.
 		 */
-		xfs_bmap_init(args->flist, args->firstblock);
+		xfs_defer_init(args->flist, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
 				  blkcnt, XFS_BMAPI_ATTRFORK, args->firstblock,
 				  args->total, &map, &nmap, args->flist);
 		if (!error)
-			error = xfs_bmap_finish(&args->trans, args->flist, dp);
+			error = xfs_defer_finish(&args->trans, args->flist, dp);
 		if (error) {
 			args->trans = NULL;
-			xfs_bmap_cancel(args->flist);
+			xfs_defer_cancel(args->flist);
 			return error;
 		}
 
@@ -499,7 +499,7 @@ xfs_attr_rmtval_set(
 
 		ASSERT(blkcnt > 0);
 
-		xfs_bmap_init(args->flist, args->firstblock);
+		xfs_defer_init(args->flist, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)lblkno,
 				       blkcnt, &map, &nmap,
@@ -599,16 +599,16 @@ xfs_attr_rmtval_remove(
 	blkcnt = args->rmtblkcnt;
 	done = 0;
 	while (!done) {
-		xfs_bmap_init(args->flist, args->firstblock);
+		xfs_defer_init(args->flist, args->firstblock);
 		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
 				    XFS_BMAPI_ATTRFORK, 1, args->firstblock,
 				    args->flist, &done);
 		if (!error)
-			error = xfs_bmap_finish(&args->trans, args->flist,
+			error = xfs_defer_finish(&args->trans, args->flist,
 						args->dp);
 		if (error) {
 			args->trans = NULL;
-			xfs_bmap_cancel(args->flist);
+			xfs_defer_cancel(args->flist);
 			return error;
 		}
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index a2d8268..0faa0a9 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -564,7 +564,7 @@ xfs_bmap_validate_ret(
 void
 xfs_bmap_add_free(
 	struct xfs_mount	*mp,		/* mount point structure */
-	struct xfs_bmap_free	*flist,		/* list of extents */
+	struct xfs_defer_ops	*flist,		/* list of extents */
 	xfs_fsblock_t		bno,		/* fs block number of extent */
 	xfs_filblks_t		len)		/* length of extent */
 {
@@ -664,7 +664,7 @@ xfs_bmap_extents_to_btree(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	xfs_fsblock_t		*firstblock,	/* first-block-allocated */
-	xfs_bmap_free_t		*flist,		/* blocks freed in xaction */
+	struct xfs_defer_ops	*flist,		/* blocks freed in xaction */
 	xfs_btree_cur_t		**curp,		/* cursor returned to caller */
 	int			wasdel,		/* converting a delayed alloc */
 	int			*logflagsp,	/* inode logging flags */
@@ -932,7 +932,7 @@ xfs_bmap_add_attrfork_btree(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	xfs_fsblock_t		*firstblock,	/* first block allocated */
-	xfs_bmap_free_t		*flist,		/* blocks to free at commit */
+	struct xfs_defer_ops	*flist,		/* blocks to free at commit */
 	int			*flags)		/* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;		/* btree cursor */
@@ -975,7 +975,7 @@ xfs_bmap_add_attrfork_extents(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	xfs_fsblock_t		*firstblock,	/* first block allocated */
-	xfs_bmap_free_t		*flist,		/* blocks to free at commit */
+	struct xfs_defer_ops	*flist,		/* blocks to free at commit */
 	int			*flags)		/* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
@@ -1010,7 +1010,7 @@ xfs_bmap_add_attrfork_local(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	xfs_fsblock_t		*firstblock,	/* first block allocated */
-	xfs_bmap_free_t		*flist,		/* blocks to free at commit */
+	struct xfs_defer_ops	*flist,		/* blocks to free at commit */
 	int			*flags)		/* inode logging flags */
 {
 	xfs_da_args_t		dargs;		/* args for dir/attr code */
@@ -1051,7 +1051,7 @@ xfs_bmap_add_attrfork(
 	int			rsvd)		/* xact may use reserved blks */
 {
 	xfs_fsblock_t		firstblock;	/* 1st block/ag allocated */
-	xfs_bmap_free_t		flist;		/* freed extent records */
+	struct xfs_defer_ops	flist;		/* freed extent records */
 	xfs_mount_t		*mp;		/* mount structure */
 	xfs_trans_t		*tp;		/* transaction pointer */
 	int			blks;		/* space reservation */
@@ -1117,7 +1117,7 @@ xfs_bmap_add_attrfork(
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
 	ip->i_afp->if_flags = XFS_IFEXTENTS;
 	logflags = 0;
-	xfs_bmap_init(&flist, &firstblock);
+	xfs_defer_init(&flist, &firstblock);
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		error = xfs_bmap_add_attrfork_local(tp, ip, &firstblock, &flist,
@@ -1157,7 +1157,7 @@ xfs_bmap_add_attrfork(
 			xfs_log_sb(tp);
 	}
 
-	error = xfs_bmap_finish(&tp, &flist, NULL);
+	error = xfs_defer_finish(&tp, &flist, NULL);
 	if (error)
 		goto bmap_cancel;
 	error = xfs_trans_commit(tp);
@@ -1165,7 +1165,7 @@ xfs_bmap_add_attrfork(
 	return error;
 
 bmap_cancel:
-	xfs_bmap_cancel(&flist);
+	xfs_defer_cancel(&flist);
 trans_cancel:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -2206,7 +2206,7 @@ xfs_bmap_add_extent_unwritten_real(
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
-	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
+	struct xfs_defer_ops	*flist,	/* list of extents to be freed */
 	int			*logflagsp) /* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor */
@@ -4439,7 +4439,7 @@ xfs_bmapi_write(
 	xfs_extlen_t		total,		/* total blocks needed */
 	struct xfs_bmbt_irec	*mval,		/* output: map values */
 	int			*nmap,		/* i/o: mval size/count */
-	struct xfs_bmap_free	*flist)		/* i/o: list extents to free */
+	struct xfs_defer_ops	*flist)		/* i/o: list extents to free */
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp;
@@ -4727,7 +4727,7 @@ xfs_bmap_del_extent(
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_trans_t		*tp,	/* current transaction pointer */
 	xfs_extnum_t		*idx,	/* extent number to update/delete */
-	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
+	struct xfs_defer_ops	*flist,	/* list of extents to be freed */
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
 	int			*logflagsp, /* inode logging flags */
@@ -5056,7 +5056,7 @@ xfs_bunmapi(
 	xfs_extnum_t		nexts,		/* number of extents max */
 	xfs_fsblock_t		*firstblock,	/* first allocated block
 						   controls a.g. for allocs */
-	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
+	struct xfs_defer_ops	*flist,		/* i/o: list extents to free */
 	int			*done)		/* set if not done yet */
 {
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
@@ -5670,7 +5670,7 @@ xfs_bmap_shift_extents(
 	int			*done,
 	xfs_fileoff_t		stop_fsb,
 	xfs_fsblock_t		*firstblock,
-	struct xfs_bmap_free	*flist,
+	struct xfs_defer_ops	*flist,
 	enum shift_direction	direction,
 	int			num_exts)
 {
@@ -5824,7 +5824,7 @@ xfs_bmap_split_extent_at(
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		split_fsb,
 	xfs_fsblock_t		*firstfsb,
-	struct xfs_bmap_free	*free_list)
+	struct xfs_defer_ops	*free_list)
 {
 	int				whichfork = XFS_DATA_FORK;
 	struct xfs_btree_cur		*cur = NULL;
@@ -5963,7 +5963,7 @@ xfs_bmap_split_extent(
 {
 	struct xfs_mount        *mp = ip->i_mount;
 	struct xfs_trans        *tp;
-	struct xfs_bmap_free    free_list;
+	struct xfs_defer_ops    free_list;
 	xfs_fsblock_t           firstfsb;
 	int                     error;
 
@@ -5975,21 +5975,21 @@ xfs_bmap_split_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-	xfs_bmap_init(&free_list, &firstfsb);
+	xfs_defer_init(&free_list, &firstfsb);
 
 	error = xfs_bmap_split_extent_at(tp, ip, split_fsb,
 			&firstfsb, &free_list);
 	if (error)
 		goto out;
 
-	error = xfs_bmap_finish(&tp, &free_list, NULL);
+	error = xfs_defer_finish(&tp, &free_list, NULL);
 	if (error)
 		goto out;
 
 	return xfs_trans_commit(tp);
 
 out:
-	xfs_bmap_cancel(&free_list);
+	xfs_defer_cancel(&free_list);
 	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 9a74610..a779cc5 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -32,7 +32,7 @@ extern kmem_zone_t	*xfs_bmap_free_item_zone;
  */
 struct xfs_bmalloca {
 	xfs_fsblock_t		*firstblock; /* i/o first block allocated */
-	struct xfs_bmap_free	*flist;	/* bmap freelist */
+	struct xfs_defer_ops	*flist;	/* bmap freelist */
 	struct xfs_trans	*tp;	/* transaction pointer */
 	struct xfs_inode	*ip;	/* incore inode pointer */
 	struct xfs_bmbt_irec	prev;	/* extent before the new one */
@@ -164,7 +164,7 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
-void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_bmap_free *flist,
+void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *flist,
 			  xfs_fsblock_t bno, xfs_filblks_t len);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
@@ -186,18 +186,18 @@ int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
 		xfs_fsblock_t *firstblock, xfs_extlen_t total,
 		struct xfs_bmbt_irec *mval, int *nmap,
-		struct xfs_bmap_free *flist);
+		struct xfs_defer_ops *flist);
 int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
 		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
-		struct xfs_bmap_free *flist, int *done);
+		struct xfs_defer_ops *flist, int *done);
 int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
 		xfs_extnum_t num);
 uint	xfs_default_attroffset(struct xfs_inode *ip);
 int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
 		int *done, xfs_fileoff_t stop_fsb, xfs_fsblock_t *firstblock,
-		struct xfs_bmap_free *flist, enum shift_direction direction,
+		struct xfs_defer_ops *flist, enum shift_direction direction,
 		int num_exts);
 int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 0ec3055..ae714a8 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -19,7 +19,7 @@
 #define	__XFS_BTREE_H__
 
 struct xfs_buf;
-struct xfs_bmap_free;
+struct xfs_defer_ops;
 struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
@@ -234,11 +234,12 @@ typedef struct xfs_btree_cur
 	union {
 		struct {			/* needed for BNO, CNT, INO */
 			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
+			struct xfs_defer_ops *flist;	/* deferred updates */
 			xfs_agnumber_t	agno;	/* ag number */
 		} a;
 		struct {			/* needed for BMAP */
 			struct xfs_inode *ip;	/* pointer to our inode */
-			struct xfs_bmap_free *flist;	/* list to free after */
+			struct xfs_defer_ops *flist;	/* deferred updates */
 			xfs_fsblock_t	firstblock;	/* 1st blk allocated */
 			int		allocated;	/* count of alloced */
 			short		forksize;	/* fork's inode space */
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 6e153e3..249813a 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -19,7 +19,7 @@
 #ifndef __XFS_DA_BTREE_H__
 #define	__XFS_DA_BTREE_H__
 
-struct xfs_bmap_free;
+struct xfs_defer_ops;
 struct xfs_inode;
 struct xfs_trans;
 struct zone;
@@ -70,7 +70,7 @@ typedef struct xfs_da_args {
 	xfs_ino_t	inumber;	/* input/output inode number */
 	struct xfs_inode *dp;		/* directory inode to manipulate */
 	xfs_fsblock_t	*firstblock;	/* ptr to firstblock for bmap calls */
-	struct xfs_bmap_free *flist;	/* ptr to freelist for bmap_finish */
+	struct xfs_defer_ops *flist;	/* ptr to freelist for bmap_finish */
 	struct xfs_trans *trans;	/* current trans (changes over time) */
 	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
 	int		whichfork;	/* data or attribute fork */
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 4c05ba6..743fc32 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -94,11 +94,4 @@ struct xfs_defer_op_type {
 void xfs_defer_init_op_type(const struct xfs_defer_op_type *type);
 void xfs_defer_init_types(void);
 
-/* XXX: compatibility shims, will go away in the next patch */
-#define xfs_bmap_finish		xfs_defer_finish
-#define xfs_bmap_cancel		xfs_defer_cancel
-#define xfs_bmap_init		xfs_defer_init
-#define xfs_bmap_free		xfs_defer_ops
-typedef struct xfs_defer_ops	xfs_bmap_free_t;
-
 #endif /* __XFS_DEFER_H__ */
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 402611f..6edaa8e 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -258,7 +258,7 @@ xfs_dir_createname(
 	struct xfs_name		*name,
 	xfs_ino_t		inum,		/* new entry inode number */
 	xfs_fsblock_t		*first,		/* bmap's firstblock */
-	xfs_bmap_free_t		*flist,		/* bmap's freeblock list */
+	struct xfs_defer_ops	*flist,		/* bmap's freeblock list */
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
 	struct xfs_da_args	*args;
@@ -435,7 +435,7 @@ xfs_dir_removename(
 	struct xfs_name	*name,
 	xfs_ino_t	ino,
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
-	xfs_bmap_free_t	*flist,		/* bmap's freeblock list */
+	struct xfs_defer_ops	*flist,		/* bmap's freeblock list */
 	xfs_extlen_t	total)		/* bmap's total block count */
 {
 	struct xfs_da_args *args;
@@ -497,7 +497,7 @@ xfs_dir_replace(
 	struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t	inum,		/* new inode number */
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
-	xfs_bmap_free_t	*flist,		/* bmap's freeblock list */
+	struct xfs_defer_ops	*flist,		/* bmap's freeblock list */
 	xfs_extlen_t	total)		/* bmap's total block count */
 {
 	struct xfs_da_args *args;
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 0a62e73..5737d85 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -18,7 +18,7 @@
 #ifndef __XFS_DIR2_H__
 #define __XFS_DIR2_H__
 
-struct xfs_bmap_free;
+struct xfs_defer_ops;
 struct xfs_da_args;
 struct xfs_inode;
 struct xfs_mount;
@@ -129,18 +129,18 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_fsblock_t *first,
-				struct xfs_bmap_free *flist, xfs_extlen_t tot);
+				struct xfs_defer_ops *flist, xfs_extlen_t tot);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_fsblock_t *first,
-				struct xfs_bmap_free *flist, xfs_extlen_t tot);
+				struct xfs_defer_ops *flist, xfs_extlen_t tot);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_fsblock_t *first,
-				struct xfs_bmap_free *flist, xfs_extlen_t tot);
+				struct xfs_defer_ops *flist, xfs_extlen_t tot);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 44d5e76..d03570c 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1812,7 +1812,7 @@ xfs_difree_inode_chunk(
 	struct xfs_mount		*mp,
 	xfs_agnumber_t			agno,
 	struct xfs_inobt_rec_incore	*rec,
-	struct xfs_bmap_free		*flist)
+	struct xfs_defer_ops		*flist)
 {
 	xfs_agblock_t	sagbno = XFS_AGINO_TO_AGBNO(mp, rec->ir_startino);
 	int		startidx, endidx;
@@ -1884,7 +1884,7 @@ xfs_difree_inobt(
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
 	xfs_agino_t			agino,
-	struct xfs_bmap_free		*flist,
+	struct xfs_defer_ops		*flist,
 	struct xfs_icluster		*xic,
 	struct xfs_inobt_rec_incore	*orec)
 {
@@ -2116,7 +2116,7 @@ int
 xfs_difree(
 	struct xfs_trans	*tp,		/* transaction pointer */
 	xfs_ino_t		inode,		/* inode to be freed */
-	struct xfs_bmap_free	*flist,		/* extents to free */
+	struct xfs_defer_ops	*flist,		/* extents to free */
 	struct xfs_icluster	*xic)	/* cluster info if deleted */
 {
 	/* REFERENCED */
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index 6e450df..2e06b67 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -95,7 +95,7 @@ int					/* error */
 xfs_difree(
 	struct xfs_trans *tp,		/* transaction pointer */
 	xfs_ino_t	inode,		/* inode to be freed */
-	struct xfs_bmap_free *flist,	/* extents to free */
+	struct xfs_defer_ops *flist,	/* extents to free */
 	struct xfs_icluster *ifree);	/* cluster info if deleted */
 
 /*
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 9e519a5..c55220f 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -152,9 +152,9 @@ xfs_calc_finobt_res(
  * item logged to try to account for the overhead of the transaction mechanism.
  *
  * Note:  Most of the reservations underestimate the number of allocation
- * groups into which they could free extents in the xfs_bmap_finish() call.
+ * groups into which they could free extents in the xfs_defer_finish() call.
  * This is because the number in the worst case is quite high and quite
- * unusual.  In order to fix this we need to change xfs_bmap_finish() to free
+ * unusual.  In order to fix this we need to change xfs_defer_finish() to free
  * extents in only a single AG at a time.  This will require changes to the
  * EFI code as well, however, so that the EFI for the extents not freed is
  * logged again in each transaction.  See SGI PV #261917.
diff --git a/mkfs/proto.c b/mkfs/proto.c
index edbaa33..f0c33e4 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -27,7 +27,7 @@ static char *getstr(char **pp);
 static void fail(char *msg, int i);
 static void getres(struct xfs_mount *mp, uint blocks, struct xfs_trans **tpp);
 static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
-static int newfile(xfs_trans_t *tp, xfs_inode_t *ip, xfs_bmap_free_t *flist,
+static int newfile(xfs_trans_t *tp, xfs_inode_t *ip, struct xfs_defer_ops *flist,
 	xfs_fsblock_t *first, int dolocal, int logit, char *buf, int len);
 static char *newregfile(char **pp, int *len);
 static void rtinit(xfs_mount_t *mp);
@@ -236,7 +236,7 @@ static int
 newfile(
 	xfs_trans_t	*tp,
 	xfs_inode_t	*ip,
-	xfs_bmap_free_t	*flist,
+	struct xfs_defer_ops	*flist,
 	xfs_fsblock_t	*first,
 	int		dolocal,
 	int		logit,
@@ -329,7 +329,7 @@ newdirent(
 	struct xfs_name	*name,
 	xfs_ino_t	inum,
 	xfs_fsblock_t	*first,
-	xfs_bmap_free_t	*flist)
+	struct xfs_defer_ops	*flist)
 {
 	int	error;
 	int	rsv;
@@ -375,7 +375,7 @@ parseproto(
 	int		error;
 	xfs_fsblock_t	first;
 	int		flags;
-	xfs_bmap_free_t	flist;
+	struct xfs_defer_ops	flist;
 	int		fmt;
 	int		i;
 	xfs_inode_t	*ip;
@@ -460,7 +460,7 @@ parseproto(
 	xname.len = name ? strlen(name) : 0;
 	xname.type = 0;
 	flags = XFS_ILOG_CORE;
-	xfs_bmap_init(&flist, &first);
+	xfs_defer_init(&flist, &first);
 	switch (fmt) {
 	case IF_REGULAR:
 		buf = newregfile(pp, &len);
@@ -500,7 +500,7 @@ parseproto(
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		libxfs_trans_log_inode(tp, ip, flags);
 
-		error = -libxfs_bmap_finish(&tp, &flist, ip);
+		error = -xfs_defer_finish(&tp, &flist, ip);
 		if (error)
 			fail(_("Pre-allocated file creation failed"), error);
 		libxfs_trans_commit(tp);
@@ -582,7 +582,7 @@ parseproto(
 		}
 		newdirectory(mp, tp, ip, pip);
 		libxfs_trans_log_inode(tp, ip, flags);
-		error = -libxfs_bmap_finish(&tp, &flist, ip);
+		error = -xfs_defer_finish(&tp, &flist, ip);
 		if (error)
 			fail(_("Directory creation failed"), error);
 		libxfs_trans_commit(tp);
@@ -608,7 +608,7 @@ parseproto(
 		fail(_("Unknown format"), EINVAL);
 	}
 	libxfs_trans_log_inode(tp, ip, flags);
-	error = -libxfs_bmap_finish(&tp, &flist, ip);
+	error = -xfs_defer_finish(&tp, &flist, ip);
 	if (error) {
 		fail(_("Error encountered creating file from prototype file"),
 			error);
@@ -638,7 +638,7 @@ rtinit(
 	xfs_bmbt_irec_t	*ep;
 	int		error;
 	xfs_fsblock_t	first;
-	xfs_bmap_free_t	flist;
+	struct xfs_defer_ops	flist;
 	int		i;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
 	xfs_extlen_t	nsumblocks;
@@ -697,7 +697,7 @@ rtinit(
 
 	libxfs_trans_ijoin(tp, rbmip, 0);
 	bno = 0;
-	xfs_bmap_init(&flist, &first);
+	xfs_defer_init(&flist, &first);
 	while (bno < mp->m_sb.sb_rbmblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = -libxfs_bmapi_write(tp, rbmip, bno,
@@ -716,7 +716,7 @@ rtinit(
 		}
 	}
 
-	error = -libxfs_bmap_finish(&tp, &flist, rbmip);
+	error = -xfs_defer_finish(&tp, &flist, rbmip);
 	if (error) {
 		fail(_("Completion of the realtime bitmap failed"), error);
 	}
@@ -732,7 +732,7 @@ rtinit(
 		res_failed(i);
 	libxfs_trans_ijoin(tp, rsumip, 0);
 	bno = 0;
-	xfs_bmap_init(&flist, &first);
+	xfs_defer_init(&flist, &first);
 	while (bno < nsumblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = -libxfs_bmapi_write(tp, rsumip, bno,
@@ -750,7 +750,7 @@ rtinit(
 			bno += ep->br_blockcount;
 		}
 	}
-	error = -libxfs_bmap_finish(&tp, &flist, rsumip);
+	error = -xfs_defer_finish(&tp, &flist, rsumip);
 	if (error) {
 		fail(_("Completion of the realtime summary failed"), error);
 	}
@@ -765,7 +765,7 @@ rtinit(
 		if (i)
 			res_failed(i);
 		libxfs_trans_ijoin(tp, rbmip, 0);
-		xfs_bmap_init(&flist, &first);
+		xfs_defer_init(&flist, &first);
 		ebno = XFS_RTMIN(mp->m_sb.sb_rextents,
 			bno + NBBY * mp->m_sb.sb_blocksize);
 		error = -libxfs_rtfree_extent(tp, bno, (xfs_extlen_t)(ebno-bno));
@@ -773,7 +773,7 @@ rtinit(
 			fail(_("Error initializing the realtime space"),
 				error);
 		}
-		error = -libxfs_bmap_finish(&tp, &flist, rbmip);
+		error = -xfs_defer_finish(&tp, &flist, rbmip);
 		if (error) {
 			fail(_("Error completing the realtime space"), error);
 		}
diff --git a/repair/phase6.c b/repair/phase6.c
index d1acb68..961f7bc 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -484,7 +484,7 @@ mk_rbmino(xfs_mount_t *mp)
 	int		i;
 	int		nmap;
 	int		error;
-	xfs_bmap_free_t	flist;
+	struct xfs_defer_ops	flist;
 	xfs_fileoff_t	bno;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
 	int		vers;
@@ -550,7 +550,7 @@ mk_rbmino(xfs_mount_t *mp)
 
 	libxfs_trans_ijoin(tp, ip, 0);
 	bno = 0;
-	xfs_bmap_init(&flist, &first);
+	xfs_defer_init(&flist, &first);
 	while (bno < mp->m_sb.sb_rbmblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = -libxfs_bmapi_write(tp, ip, bno,
@@ -569,7 +569,7 @@ mk_rbmino(xfs_mount_t *mp)
 			bno += ep->br_blockcount;
 		}
 	}
-	error = -libxfs_bmap_finish(&tp, &flist, ip);
+	error = -xfs_defer_finish(&tp, &flist, ip);
 	if (error) {
 		do_error(
 		_("allocation of the realtime bitmap failed, error = %d\n"),
@@ -731,7 +731,7 @@ mk_rsumino(xfs_mount_t *mp)
 	int		nmap;
 	int		error;
 	int		nsumblocks;
-	xfs_bmap_free_t	flist;
+	struct xfs_defer_ops	flist;
 	xfs_fileoff_t	bno;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
 	int		vers;
@@ -789,7 +789,7 @@ mk_rsumino(xfs_mount_t *mp)
 	 * then allocate blocks for file and fill with zeroes (stolen
 	 * from mkfs)
 	 */
-	xfs_bmap_init(&flist, &first);
+	xfs_defer_init(&flist, &first);
 
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
 	tres.tr_logres = BBTOB(128);
@@ -803,7 +803,7 @@ mk_rsumino(xfs_mount_t *mp)
 
 	libxfs_trans_ijoin(tp, ip, 0);
 	bno = 0;
-	xfs_bmap_init(&flist, &first);
+	xfs_defer_init(&flist, &first);
 	while (bno < nsumblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = -libxfs_bmapi_write(tp, ip, bno,
@@ -821,7 +821,7 @@ mk_rsumino(xfs_mount_t *mp)
 			bno += ep->br_blockcount;
 		}
 	}
-	error = -libxfs_bmap_finish(&tp, &flist, ip);
+	error = -xfs_defer_finish(&tp, &flist, ip);
 	if (error) {
 		do_error(
 	_("allocation of the realtime summary ino failed, error = %d\n"),
@@ -919,7 +919,7 @@ mk_orphanage(xfs_mount_t *mp)
 	int		ino_offset = 0;
 	int		i;
 	int		error;
-	xfs_bmap_free_t	flist;
+	struct xfs_defer_ops	flist;
 	const int	mode = 0755;
 	int		nres;
 	struct xfs_name	xname;
@@ -945,7 +945,7 @@ mk_orphanage(xfs_mount_t *mp)
 	 * could not be found, create it
 	 */
 
-	xfs_bmap_init(&flist, &first);
+	xfs_defer_init(&flist, &first);
 
 	nres = XFS_MKDIR_SPACE_RES(mp, xname.len);
 	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir, nres, 0, 0, &tp);
@@ -1028,7 +1028,7 @@ mk_orphanage(xfs_mount_t *mp)
 	libxfs_dir_init(tp, ip, pip);
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	error = -libxfs_bmap_finish(&tp, &flist, ip);
+	error = -xfs_defer_finish(&tp, &flist, ip);
 	if (error) {
 		do_error(_("%s directory creation failed -- bmapf error %d\n"),
 			ORPHANAGE, error);
@@ -1057,7 +1057,7 @@ mv_orphanage(
 	xfs_inode_t		*ino_p;
 	xfs_trans_t		*tp;
 	xfs_fsblock_t		first;
-	xfs_bmap_free_t		flist;
+	struct xfs_defer_ops	flist;
 	int			err;
 	unsigned char		fname[MAXPATHLEN + 1];
 	int			nres;
@@ -1110,7 +1110,7 @@ mv_orphanage(
 			libxfs_trans_ijoin(tp, orphanage_ip, 0);
 			libxfs_trans_ijoin(tp, ino_p, 0);
 
-			xfs_bmap_init(&flist, &first);
+			xfs_defer_init(&flist, &first);
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
 						ino, &first, &flist, nres);
 			if (err)
@@ -1134,7 +1134,7 @@ mv_orphanage(
 			inc_nlink(VFS_I(ino_p));
 			libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
 
-			err = -libxfs_bmap_finish(&tp, &flist, ino_p);
+			err = -xfs_defer_finish(&tp, &flist, ino_p);
 			if (err)
 				do_error(
 	_("bmap finish failed (err - %d), filesystem may be out of space\n"),
@@ -1152,7 +1152,7 @@ mv_orphanage(
 			libxfs_trans_ijoin(tp, orphanage_ip, 0);
 			libxfs_trans_ijoin(tp, ino_p, 0);
 
-			xfs_bmap_init(&flist, &first);
+			xfs_defer_init(&flist, &first);
 
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
 						ino, &first, &flist, nres);
@@ -1181,7 +1181,7 @@ mv_orphanage(
 						err);
 			}
 
-			err = -libxfs_bmap_finish(&tp, &flist, ino_p);
+			err = -xfs_defer_finish(&tp, &flist, ino_p);
 			if (err)
 				do_error(
 	_("bmap finish failed (%d), filesystem may be out of space\n"),
@@ -1208,7 +1208,7 @@ mv_orphanage(
 		libxfs_trans_ijoin(tp, orphanage_ip, 0);
 		libxfs_trans_ijoin(tp, ino_p, 0);
 
-		xfs_bmap_init(&flist, &first);
+		xfs_defer_init(&flist, &first);
 		err = -libxfs_dir_createname(tp, orphanage_ip, &xname, ino,
 						&first, &flist, nres);
 		if (err)
@@ -1220,7 +1220,7 @@ mv_orphanage(
 		set_nlink(VFS_I(ino_p), 1);
 		libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
 
-		err = -libxfs_bmap_finish(&tp, &flist, ino_p);
+		err = -xfs_defer_finish(&tp, &flist, ino_p);
 		if (err)
 			do_error(
 	_("bmap finish failed (%d), filesystem may be out of space\n"),
@@ -1269,7 +1269,7 @@ longform_dir2_rebuild(
 	xfs_trans_t		*tp;
 	xfs_fileoff_t		lastblock;
 	xfs_fsblock_t		firstblock;
-	xfs_bmap_free_t		flist;
+	struct xfs_defer_ops	flist;
 	xfs_inode_t		pip;
 	dir_hash_ent_t		*p;
 	int			done;
@@ -1292,7 +1292,7 @@ longform_dir2_rebuild(
 	    xfs_dir_ino_validate(mp, pip.i_ino))
 		pip.i_ino = mp->m_sb.sb_rootino;
 
-	xfs_bmap_init(&flist, &firstblock);
+	xfs_defer_init(&flist, &firstblock);
 
 	nres = XFS_REMOVE_SPACE_RES(mp);
 	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
@@ -1320,7 +1320,7 @@ longform_dir2_rebuild(
 		goto out_bmap_cancel;
 	}
 
-	error = -libxfs_bmap_finish(&tp, &flist, ip);
+	error = -xfs_defer_finish(&tp, &flist, ip);
 
 	libxfs_trans_commit(tp);
 
@@ -1344,7 +1344,7 @@ longform_dir2_rebuild(
 
 		libxfs_trans_ijoin(tp, ip, 0);
 
-		xfs_bmap_init(&flist, &firstblock);
+		xfs_defer_init(&flist, &firstblock);
 		error = -libxfs_dir_createname(tp, ip, &p->name, p->inum,
 						&firstblock, &flist, nres);
 		if (error) {
@@ -1354,7 +1354,7 @@ _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"
 			goto out_bmap_cancel;
 		}
 
-		error = -libxfs_bmap_finish(&tp, &flist, ip);
+		error = -xfs_defer_finish(&tp, &flist, ip);
 		if (error) {
 			do_warn(
 	_("bmap finish failed (%d), filesystem may be out of space\n"),
@@ -1368,7 +1368,7 @@ _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"
 	return;
 
 out_bmap_cancel:
-	libxfs_bmap_cancel(&flist);
+	xfs_defer_cancel(&flist);
 	libxfs_trans_cancel(tp);
 	return;
 }
@@ -1388,7 +1388,7 @@ dir2_kill_block(
 	xfs_da_args_t	args;
 	int		error;
 	xfs_fsblock_t	firstblock;
-	xfs_bmap_free_t	flist;
+	struct xfs_defer_ops	flist;
 	int		nres;
 	xfs_trans_t	*tp;
 
@@ -1399,7 +1399,7 @@ dir2_kill_block(
 	libxfs_trans_ijoin(tp, ip, 0);
 	libxfs_trans_bjoin(tp, bp);
 	memset(&args, 0, sizeof(args));
-	xfs_bmap_init(&flist, &firstblock);
+	xfs_defer_init(&flist, &firstblock);
 	args.dp = ip;
 	args.trans = tp;
 	args.firstblock = &firstblock;
@@ -1414,7 +1414,7 @@ dir2_kill_block(
 	if (error)
 		do_error(_("shrink_inode failed inode %" PRIu64 " block %u\n"),
 			ip->i_ino, da_bno);
-	libxfs_bmap_finish(&tp, &flist, ip);
+	xfs_defer_finish(&tp, &flist, ip);
 	libxfs_trans_commit(tp);
 }
 
@@ -1448,7 +1448,7 @@ longform_dir2_entry_check_data(
 	char			*endptr;
 	int			error;
 	xfs_fsblock_t		firstblock;
-	xfs_bmap_free_t		flist;
+	struct xfs_defer_ops	flist;
 	char			fname[MAXNAMELEN + 1];
 	freetab_t		*freetab;
 	int			i;
@@ -1590,7 +1590,7 @@ longform_dir2_entry_check_data(
 	libxfs_trans_ijoin(tp, ip, 0);
 	libxfs_trans_bjoin(tp, bp);
 	libxfs_trans_bhold(tp, bp);
-	xfs_bmap_init(&flist, &firstblock);
+	xfs_defer_init(&flist, &firstblock);
 	if (be32_to_cpu(d->magic) != wantmagic) {
 		do_warn(
 	_("bad directory block magic # %#x for directory inode %" PRIu64 " block %d: "),
@@ -1889,7 +1889,7 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 		repair_dir2_data_freescan(mp, M_DIROPS(mp), d, &i);
 	if (needlog)
 		libxfs_dir2_data_log_header(&da, bp);
-	libxfs_bmap_finish(&tp, &flist, ip);
+	xfs_defer_finish(&tp, &flist, ip);
 	libxfs_trans_commit(tp);
 
 	/* record the largest free space in the freetab for later checking */
@@ -2805,7 +2805,7 @@ process_dir_inode(
 	int			ino_offset)
 {
 	xfs_ino_t		ino;
-	xfs_bmap_free_t		flist;
+	struct xfs_defer_ops	flist;
 	xfs_fsblock_t		first;
 	xfs_inode_t		*ip;
 	xfs_trans_t		*tp;
@@ -2943,7 +2943,7 @@ process_dir_inode(
 
 		libxfs_trans_ijoin(tp, ip, 0);
 
-		xfs_bmap_init(&flist, &first);
+		xfs_defer_init(&flist, &first);
 
 		error = -libxfs_dir_createname(tp, ip, &xfs_name_dotdot,
 					ip->i_ino, &first, &flist, nres);
@@ -2953,7 +2953,7 @@ process_dir_inode(
 
 		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-		error = -libxfs_bmap_finish(&tp, &flist, ip);
+		error = -xfs_defer_finish(&tp, &flist, ip);
 		ASSERT(error == 0);
 		libxfs_trans_commit(tp);
 
@@ -3001,7 +3001,7 @@ process_dir_inode(
 
 			libxfs_trans_ijoin(tp, ip, 0);
 
-			xfs_bmap_init(&flist, &first);
+			xfs_defer_init(&flist, &first);
 
 			error = -libxfs_dir_createname(tp, ip, &xfs_name_dot,
 					ip->i_ino, &first, &flist, nres);
@@ -3012,7 +3012,7 @@ process_dir_inode(
 
 			libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-			error = -libxfs_bmap_finish(&tp, &flist, ip);
+			error = -xfs_defer_finish(&tp, &flist, ip);
 			ASSERT(error == 0);
 			libxfs_trans_commit(tp);
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
