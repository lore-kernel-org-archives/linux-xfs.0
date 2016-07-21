Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 23CB87CA0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:58:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A1F088F8037
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:58:06 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 0hhR4JyWCxOeqcrZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:57:59 -0700 (PDT)
Subject: [PATCH 16/47] xfs: change xfs_bmap_{finish, cancel, init,
	free} -> xfs_defer_*
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:57:50 -0700
Message-ID: <146907707014.25461.326080392148826094.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Drop the compatibility shims that we were using to integrate the new
deferred operation mechanism into the existing code.  No new code.

v2: Also change xfs_bmap_free_item -> xfs_extent_free_item.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        |   58 ++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_attr_remote.c |   14 ++++-----
 fs/xfs/libxfs/xfs_bmap.c        |   46 ++++++++++++++---------------
 fs/xfs/libxfs/xfs_bmap.h        |   18 ++++++-----
 fs/xfs/libxfs/xfs_btree.h       |    5 ++-
 fs/xfs/libxfs/xfs_da_btree.h    |    4 +--
 fs/xfs/libxfs/xfs_defer.h       |    7 ----
 fs/xfs/libxfs/xfs_dir2.c        |    6 ++--
 fs/xfs/libxfs/xfs_dir2.h        |    8 +++--
 fs/xfs/libxfs/xfs_ialloc.c      |    6 ++--
 fs/xfs/libxfs/xfs_ialloc.h      |    2 +
 fs/xfs/libxfs/xfs_trans_resv.c  |    4 +--
 fs/xfs/xfs_bmap_util.c          |   28 +++++++++---------
 fs/xfs/xfs_bmap_util.h          |    2 +
 fs/xfs/xfs_dquot.c              |   10 +++---
 fs/xfs/xfs_inode.c              |   62 ++++++++++++++++++++-------------------
 fs/xfs/xfs_inode.h              |    4 +--
 fs/xfs/xfs_iomap.c              |   24 ++++++++-------
 fs/xfs/xfs_rtalloc.c            |    8 +++--
 fs/xfs/xfs_super.c              |    2 +
 fs/xfs/xfs_symlink.c            |   16 +++++-----
 fs/xfs/xfs_trans.h              |    5 ---
 fs/xfs/xfs_trans_extfree.c      |   36 +++++++++++------------
 23 files changed, 182 insertions(+), 193 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 79d3a30..66baf97 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -204,7 +204,7 @@ xfs_attr_set(
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
-	struct xfs_bmap_free	flist;
+	struct xfs_defer_ops	flist;
 	struct xfs_trans_res	tres;
 	xfs_fsblock_t		firstblock;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
@@ -317,13 +317,13 @@ xfs_attr_set(
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
 
@@ -383,7 +383,7 @@ xfs_attr_remove(
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
-	struct xfs_bmap_free	flist;
+	struct xfs_defer_ops	flist;
 	xfs_fsblock_t		firstblock;
 	int			error;
 
@@ -585,13 +585,13 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
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
 
@@ -675,15 +675,15 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
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
@@ -738,14 +738,14 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
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
@@ -864,14 +864,14 @@ restart:
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
 
@@ -892,13 +892,13 @@ restart:
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
@@ -991,14 +991,14 @@ restart:
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
@@ -1114,13 +1114,13 @@ xfs_attr_node_removename(xfs_da_args_t *args)
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
@@ -1147,15 +1147,15 @@ xfs_attr_node_removename(xfs_da_args_t *args)
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
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 93a9ce1..aabb516 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -461,16 +461,16 @@ xfs_attr_rmtval_set(
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
 
@@ -504,7 +504,7 @@ xfs_attr_rmtval_set(
 
 		ASSERT(blkcnt > 0);
 
-		xfs_bmap_init(args->flist, args->firstblock);
+		xfs_defer_init(args->flist, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)lblkno,
 				       blkcnt, &map, &nmap,
@@ -604,16 +604,16 @@ xfs_attr_rmtval_remove(
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
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e090d34..71bf553 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -572,11 +572,11 @@ xfs_bmap_validate_ret(
 void
 xfs_bmap_add_free(
 	struct xfs_mount	*mp,		/* mount point structure */
-	struct xfs_bmap_free	*flist,		/* list of extents */
+	struct xfs_defer_ops	*flist,		/* list of extents */
 	xfs_fsblock_t		bno,		/* fs block number of extent */
 	xfs_filblks_t		len)		/* length of extent */
 {
-	struct xfs_bmap_free_item	*new;		/* new element */
+	struct xfs_extent_free_item	*new;		/* new element */
 #ifdef DEBUG
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
@@ -594,9 +594,9 @@ xfs_bmap_add_free(
 #endif
 	ASSERT(xfs_bmap_free_item_zone != NULL);
 	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
-	new->xbfi_startblock = bno;
-	new->xbfi_blockcount = (xfs_extlen_t)len;
-	xfs_defer_add(flist, XFS_DEFER_OPS_TYPE_FREE, &new->xbfi_list);
+	new->xefi_startblock = bno;
+	new->xefi_blockcount = (xfs_extlen_t)len;
+	xfs_defer_add(flist, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
 }
 
 /*
@@ -672,7 +672,7 @@ xfs_bmap_extents_to_btree(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	xfs_fsblock_t		*firstblock,	/* first-block-allocated */
-	xfs_bmap_free_t		*flist,		/* blocks freed in xaction */
+	struct xfs_defer_ops	*flist,		/* blocks freed in xaction */
 	xfs_btree_cur_t		**curp,		/* cursor returned to caller */
 	int			wasdel,		/* converting a delayed alloc */
 	int			*logflagsp,	/* inode logging flags */
@@ -940,7 +940,7 @@ xfs_bmap_add_attrfork_btree(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	xfs_fsblock_t		*firstblock,	/* first block allocated */
-	xfs_bmap_free_t		*flist,		/* blocks to free at commit */
+	struct xfs_defer_ops	*flist,		/* blocks to free at commit */
 	int			*flags)		/* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;		/* btree cursor */
@@ -983,7 +983,7 @@ xfs_bmap_add_attrfork_extents(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	xfs_fsblock_t		*firstblock,	/* first block allocated */
-	xfs_bmap_free_t		*flist,		/* blocks to free at commit */
+	struct xfs_defer_ops	*flist,		/* blocks to free at commit */
 	int			*flags)		/* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
@@ -1018,7 +1018,7 @@ xfs_bmap_add_attrfork_local(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	xfs_fsblock_t		*firstblock,	/* first block allocated */
-	xfs_bmap_free_t		*flist,		/* blocks to free at commit */
+	struct xfs_defer_ops	*flist,		/* blocks to free at commit */
 	int			*flags)		/* inode logging flags */
 {
 	xfs_da_args_t		dargs;		/* args for dir/attr code */
@@ -1059,7 +1059,7 @@ xfs_bmap_add_attrfork(
 	int			rsvd)		/* xact may use reserved blks */
 {
 	xfs_fsblock_t		firstblock;	/* 1st block/ag allocated */
-	xfs_bmap_free_t		flist;		/* freed extent records */
+	struct xfs_defer_ops	flist;		/* freed extent records */
 	xfs_mount_t		*mp;		/* mount structure */
 	xfs_trans_t		*tp;		/* transaction pointer */
 	int			blks;		/* space reservation */
@@ -1125,7 +1125,7 @@ xfs_bmap_add_attrfork(
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
 	ip->i_afp->if_flags = XFS_IFEXTENTS;
 	logflags = 0;
-	xfs_bmap_init(&flist, &firstblock);
+	xfs_defer_init(&flist, &firstblock);
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		error = xfs_bmap_add_attrfork_local(tp, ip, &firstblock, &flist,
@@ -1165,7 +1165,7 @@ xfs_bmap_add_attrfork(
 			xfs_log_sb(tp);
 	}
 
-	error = xfs_bmap_finish(&tp, &flist, NULL);
+	error = xfs_defer_finish(&tp, &flist, NULL);
 	if (error)
 		goto bmap_cancel;
 	error = xfs_trans_commit(tp);
@@ -1173,7 +1173,7 @@ xfs_bmap_add_attrfork(
 	return error;
 
 bmap_cancel:
-	xfs_bmap_cancel(&flist);
+	xfs_defer_cancel(&flist);
 trans_cancel:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -2214,7 +2214,7 @@ xfs_bmap_add_extent_unwritten_real(
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
-	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
+	struct xfs_defer_ops	*flist,	/* list of extents to be freed */
 	int			*logflagsp) /* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor */
@@ -4447,7 +4447,7 @@ xfs_bmapi_write(
 	xfs_extlen_t		total,		/* total blocks needed */
 	struct xfs_bmbt_irec	*mval,		/* output: map values */
 	int			*nmap,		/* i/o: mval size/count */
-	struct xfs_bmap_free	*flist)		/* i/o: list extents to free */
+	struct xfs_defer_ops	*flist)		/* i/o: list extents to free */
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp;
@@ -4735,7 +4735,7 @@ xfs_bmap_del_extent(
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_trans_t		*tp,	/* current transaction pointer */
 	xfs_extnum_t		*idx,	/* extent number to update/delete */
-	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
+	struct xfs_defer_ops	*flist,	/* list of extents to be freed */
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
 	int			*logflagsp, /* inode logging flags */
@@ -5064,7 +5064,7 @@ xfs_bunmapi(
 	xfs_extnum_t		nexts,		/* number of extents max */
 	xfs_fsblock_t		*firstblock,	/* first allocated block
 						   controls a.g. for allocs */
-	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
+	struct xfs_defer_ops	*flist,		/* i/o: list extents to free */
 	int			*done)		/* set if not done yet */
 {
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
@@ -5680,7 +5680,7 @@ xfs_bmap_shift_extents(
 	int			*done,
 	xfs_fileoff_t		stop_fsb,
 	xfs_fsblock_t		*firstblock,
-	struct xfs_bmap_free	*flist,
+	struct xfs_defer_ops	*flist,
 	enum shift_direction	direction,
 	int			num_exts)
 {
@@ -5834,7 +5834,7 @@ xfs_bmap_split_extent_at(
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		split_fsb,
 	xfs_fsblock_t		*firstfsb,
-	struct xfs_bmap_free	*free_list)
+	struct xfs_defer_ops	*free_list)
 {
 	int				whichfork = XFS_DATA_FORK;
 	struct xfs_btree_cur		*cur = NULL;
@@ -5973,7 +5973,7 @@ xfs_bmap_split_extent(
 {
 	struct xfs_mount        *mp = ip->i_mount;
 	struct xfs_trans        *tp;
-	struct xfs_bmap_free    free_list;
+	struct xfs_defer_ops    free_list;
 	xfs_fsblock_t           firstfsb;
 	int                     error;
 
@@ -5985,21 +5985,21 @@ xfs_bmap_split_extent(
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
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 891b728..3dc8393 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -32,7 +32,7 @@ extern kmem_zone_t	*xfs_bmap_free_item_zone;
  */
 struct xfs_bmalloca {
 	xfs_fsblock_t		*firstblock; /* i/o first block allocated */
-	struct xfs_bmap_free	*flist;	/* bmap freelist */
+	struct xfs_defer_ops	*flist;	/* bmap freelist */
 	struct xfs_trans	*tp;	/* transaction pointer */
 	struct xfs_inode	*ip;	/* incore inode pointer */
 	struct xfs_bmbt_irec	prev;	/* extent before the new one */
@@ -62,11 +62,11 @@ struct xfs_bmalloca {
  * List of extents to be free "later".
  * The list is kept sorted on xbf_startblock.
  */
-struct xfs_bmap_free_item
+struct xfs_extent_free_item
 {
-	xfs_fsblock_t		xbfi_startblock;/* starting fs block number */
-	xfs_extlen_t		xbfi_blockcount;/* number of blocks in extent */
-	struct list_head	xbfi_list;
+	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
+	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
+	struct list_head	xefi_list;
 };
 
 #define	XFS_BMAP_MAX_NMAP	4
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
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index d111eb6..6713af3 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -19,7 +19,7 @@
 #define	__XFS_BTREE_H__
 
 struct xfs_buf;
-struct xfs_bmap_free;
+struct xfs_defer_ops;
 struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
@@ -255,11 +255,12 @@ typedef struct xfs_btree_cur
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
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 6e153e3..249813a 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
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
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 8d25086..b9b5a92 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -93,11 +93,4 @@ struct xfs_defer_op_type {
 
 void xfs_defer_init_op_type(const struct xfs_defer_op_type *type);
 
-/* XXX: compatibility shims, will go away in the next patch */
-#define xfs_bmap_finish		xfs_defer_finish
-#define xfs_bmap_cancel		xfs_defer_cancel
-#define xfs_bmap_init		xfs_defer_init
-#define xfs_bmap_free		xfs_defer_ops
-typedef struct xfs_defer_ops	xfs_bmap_free_t;
-
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 945c0345..0523100 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -260,7 +260,7 @@ xfs_dir_createname(
 	struct xfs_name		*name,
 	xfs_ino_t		inum,		/* new entry inode number */
 	xfs_fsblock_t		*first,		/* bmap's firstblock */
-	xfs_bmap_free_t		*flist,		/* bmap's freeblock list */
+	struct xfs_defer_ops	*flist,		/* bmap's freeblock list */
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
 	struct xfs_da_args	*args;
@@ -437,7 +437,7 @@ xfs_dir_removename(
 	struct xfs_name	*name,
 	xfs_ino_t	ino,
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
-	xfs_bmap_free_t	*flist,		/* bmap's freeblock list */
+	struct xfs_defer_ops	*flist,		/* bmap's freeblock list */
 	xfs_extlen_t	total)		/* bmap's total block count */
 {
 	struct xfs_da_args *args;
@@ -499,7 +499,7 @@ xfs_dir_replace(
 	struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t	inum,		/* new inode number */
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
-	xfs_bmap_free_t	*flist,		/* bmap's freeblock list */
+	struct xfs_defer_ops	*flist,		/* bmap's freeblock list */
 	xfs_extlen_t	total)		/* bmap's total block count */
 {
 	struct xfs_da_args *args;
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index e553536..c272f1a 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
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
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index c654310..972b2ea 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1818,7 +1818,7 @@ xfs_difree_inode_chunk(
 	struct xfs_mount		*mp,
 	xfs_agnumber_t			agno,
 	struct xfs_inobt_rec_incore	*rec,
-	struct xfs_bmap_free		*flist)
+	struct xfs_defer_ops		*flist)
 {
 	xfs_agblock_t	sagbno = XFS_AGINO_TO_AGBNO(mp, rec->ir_startino);
 	int		startidx, endidx;
@@ -1890,7 +1890,7 @@ xfs_difree_inobt(
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
 	xfs_agino_t			agino,
-	struct xfs_bmap_free		*flist,
+	struct xfs_defer_ops		*flist,
 	struct xfs_icluster		*xic,
 	struct xfs_inobt_rec_incore	*orec)
 {
@@ -2122,7 +2122,7 @@ int
 xfs_difree(
 	struct xfs_trans	*tp,		/* transaction pointer */
 	xfs_ino_t		inode,		/* inode to be freed */
-	struct xfs_bmap_free	*flist,		/* extents to free */
+	struct xfs_defer_ops	*flist,		/* extents to free */
 	struct xfs_icluster	*xic)	/* cluster info if deleted */
 {
 	/* REFERENCED */
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 6e450df..2e06b67 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -95,7 +95,7 @@ int					/* error */
 xfs_difree(
 	struct xfs_trans *tp,		/* transaction pointer */
 	xfs_ino_t	inode,		/* inode to be freed */
-	struct xfs_bmap_free *flist,	/* extents to free */
+	struct xfs_defer_ops *flist,	/* extents to free */
 	struct xfs_icluster *ifree);	/* cluster info if deleted */
 
 /*
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 68cb1e7..4c7eb9d 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -153,9 +153,9 @@ xfs_calc_finobt_res(
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
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d3c3d46..07954e8 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -685,7 +685,7 @@ xfs_bmap_punch_delalloc_range(
 		xfs_bmbt_irec_t	imap;
 		int		nimaps = 1;
 		xfs_fsblock_t	firstblock;
-		xfs_bmap_free_t flist;
+		struct xfs_defer_ops flist;
 
 		/*
 		 * Map the range first and check that it is a delalloc extent
@@ -721,7 +721,7 @@ xfs_bmap_punch_delalloc_range(
 		 * allocated or freed for a delalloc extent and hence we need
 		 * don't cancel or finish them after the xfs_bunmapi() call.
 		 */
-		xfs_bmap_init(&flist, &firstblock);
+		xfs_defer_init(&flist, &firstblock);
 		error = xfs_bunmapi(NULL, ip, start_fsb, 1, 0, 1, &firstblock,
 					&flist, &done);
 		if (error)
@@ -884,7 +884,7 @@ xfs_alloc_file_space(
 	int			rt;
 	xfs_trans_t		*tp;
 	xfs_bmbt_irec_t		imaps[1], *imapp;
-	xfs_bmap_free_t		free_list;
+	struct xfs_defer_ops	free_list;
 	uint			qblocks, resblks, resrtextents;
 	int			error;
 
@@ -975,7 +975,7 @@ xfs_alloc_file_space(
 
 		xfs_trans_ijoin(tp, ip, 0);
 
-		xfs_bmap_init(&free_list, &firstfsb);
+		xfs_defer_init(&free_list, &firstfsb);
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
 					allocatesize_fsb, alloc_type, &firstfsb,
 					resblks, imapp, &nimaps, &free_list);
@@ -985,7 +985,7 @@ xfs_alloc_file_space(
 		/*
 		 * Complete the transaction
 		 */
-		error = xfs_bmap_finish(&tp, &free_list, NULL);
+		error = xfs_defer_finish(&tp, &free_list, NULL);
 		if (error)
 			goto error0;
 
@@ -1008,7 +1008,7 @@ xfs_alloc_file_space(
 	return error;
 
 error0:	/* Cancel bmap, unlock inode, unreserve quota blocks, cancel trans */
-	xfs_bmap_cancel(&free_list);
+	xfs_defer_cancel(&free_list);
 	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
 
 error1:	/* Just cancel transaction */
@@ -1026,7 +1026,7 @@ xfs_unmap_extent(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
-	struct xfs_bmap_free	free_list;
+	struct xfs_defer_ops	free_list;
 	xfs_fsblock_t		firstfsb;
 	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 	int			error;
@@ -1045,13 +1045,13 @@ xfs_unmap_extent(
 
 	xfs_trans_ijoin(tp, ip, 0);
 
-	xfs_bmap_init(&free_list, &firstfsb);
+	xfs_defer_init(&free_list, &firstfsb);
 	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, &firstfsb,
 			&free_list, done);
 	if (error)
 		goto out_bmap_cancel;
 
-	error = xfs_bmap_finish(&tp, &free_list, NULL);
+	error = xfs_defer_finish(&tp, &free_list, ip);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -1061,7 +1061,7 @@ out_unlock:
 	return error;
 
 out_bmap_cancel:
-	xfs_bmap_cancel(&free_list);
+	xfs_defer_cancel(&free_list);
 out_trans_cancel:
 	xfs_trans_cancel(tp);
 	goto out_unlock;
@@ -1250,7 +1250,7 @@ xfs_shift_file_space(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	int			error;
-	struct xfs_bmap_free	free_list;
+	struct xfs_defer_ops	free_list;
 	xfs_fsblock_t		first_block;
 	xfs_fileoff_t		stop_fsb;
 	xfs_fileoff_t		next_fsb;
@@ -1328,7 +1328,7 @@ xfs_shift_file_space(
 
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-		xfs_bmap_init(&free_list, &first_block);
+		xfs_defer_init(&free_list, &first_block);
 
 		/*
 		 * We are using the write transaction in which max 2 bmbt
@@ -1340,7 +1340,7 @@ xfs_shift_file_space(
 		if (error)
 			goto out_bmap_cancel;
 
-		error = xfs_bmap_finish(&tp, &free_list, NULL);
+		error = xfs_defer_finish(&tp, &free_list, NULL);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -1350,7 +1350,7 @@ xfs_shift_file_space(
 	return error;
 
 out_bmap_cancel:
-	xfs_bmap_cancel(&free_list);
+	xfs_defer_cancel(&free_list);
 out_trans_cancel:
 	xfs_trans_cancel(tp);
 	return error;
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 51aadde..68a621a 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -21,7 +21,7 @@
 /* Kernel only BMAP related definitions and functions */
 
 struct xfs_bmbt_irec;
-struct xfs_bmap_free_item;
+struct xfs_extent_free_item;
 struct xfs_ifork;
 struct xfs_inode;
 struct xfs_mount;
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index be17f0a..764e1cc 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -307,7 +307,7 @@ xfs_qm_dqalloc(
 	xfs_buf_t	**O_bpp)
 {
 	xfs_fsblock_t	firstblock;
-	xfs_bmap_free_t flist;
+	struct xfs_defer_ops flist;
 	xfs_bmbt_irec_t map;
 	int		nmaps, error;
 	xfs_buf_t	*bp;
@@ -320,7 +320,7 @@ xfs_qm_dqalloc(
 	/*
 	 * Initialize the bmap freelist prior to calling bmapi code.
 	 */
-	xfs_bmap_init(&flist, &firstblock);
+	xfs_defer_init(&flist, &firstblock);
 	xfs_ilock(quotip, XFS_ILOCK_EXCL);
 	/*
 	 * Return if this type of quotas is turned off while we didn't
@@ -368,7 +368,7 @@ xfs_qm_dqalloc(
 			      dqp->dq_flags & XFS_DQ_ALLTYPES, bp);
 
 	/*
-	 * xfs_bmap_finish() may commit the current transaction and
+	 * xfs_defer_finish() may commit the current transaction and
 	 * start a second transaction if the freelist is not empty.
 	 *
 	 * Since we still want to modify this buffer, we need to
@@ -382,7 +382,7 @@ xfs_qm_dqalloc(
 
 	xfs_trans_bhold(tp, bp);
 
-	error = xfs_bmap_finish(tpp, &flist, NULL);
+	error = xfs_defer_finish(tpp, &flist, NULL);
 	if (error)
 		goto error1;
 
@@ -398,7 +398,7 @@ xfs_qm_dqalloc(
 	return 0;
 
 error1:
-	xfs_bmap_cancel(&flist);
+	xfs_defer_cancel(&flist);
 error0:
 	xfs_iunlock(quotip, XFS_ILOCK_EXCL);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d2389bb..3ce50da 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1123,7 +1123,7 @@ xfs_create(
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	xfs_bmap_free_t		free_list;
+	struct xfs_defer_ops	free_list;
 	xfs_fsblock_t		first_block;
 	bool                    unlock_dp_on_error = false;
 	prid_t			prid;
@@ -1183,7 +1183,7 @@ xfs_create(
 		      XFS_IOLOCK_PARENT | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
 
-	xfs_bmap_init(&free_list, &first_block);
+	xfs_defer_init(&free_list, &first_block);
 
 	/*
 	 * Reserve disk quota and the inode.
@@ -1254,7 +1254,7 @@ xfs_create(
 	 */
 	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
-	error = xfs_bmap_finish(&tp, &free_list, NULL);
+	error = xfs_defer_finish(&tp, &free_list, NULL);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -1270,7 +1270,7 @@ xfs_create(
 	return 0;
 
  out_bmap_cancel:
-	xfs_bmap_cancel(&free_list);
+	xfs_defer_cancel(&free_list);
  out_trans_cancel:
 	xfs_trans_cancel(tp);
  out_release_inode:
@@ -1402,7 +1402,7 @@ xfs_link(
 	xfs_mount_t		*mp = tdp->i_mount;
 	xfs_trans_t		*tp;
 	int			error;
-	xfs_bmap_free_t         free_list;
+	struct xfs_defer_ops	free_list;
 	xfs_fsblock_t           first_block;
 	int			resblks;
 
@@ -1453,7 +1453,7 @@ xfs_link(
 			goto error_return;
 	}
 
-	xfs_bmap_init(&free_list, &first_block);
+	xfs_defer_init(&free_list, &first_block);
 
 	/*
 	 * Handle initial link state of O_TMPFILE inode
@@ -1483,9 +1483,9 @@ xfs_link(
 	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
 		xfs_trans_set_sync(tp);
 
-	error = xfs_bmap_finish(&tp, &free_list, NULL);
+	error = xfs_defer_finish(&tp, &free_list, NULL);
 	if (error) {
-		xfs_bmap_cancel(&free_list);
+		xfs_defer_cancel(&free_list);
 		goto error_return;
 	}
 
@@ -1527,7 +1527,7 @@ xfs_itruncate_extents(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp = *tpp;
-	xfs_bmap_free_t		free_list;
+	struct xfs_defer_ops	free_list;
 	xfs_fsblock_t		first_block;
 	xfs_fileoff_t		first_unmap_block;
 	xfs_fileoff_t		last_block;
@@ -1563,7 +1563,7 @@ xfs_itruncate_extents(
 	ASSERT(first_unmap_block < last_block);
 	unmap_len = last_block - first_unmap_block + 1;
 	while (!done) {
-		xfs_bmap_init(&free_list, &first_block);
+		xfs_defer_init(&free_list, &first_block);
 		error = xfs_bunmapi(tp, ip,
 				    first_unmap_block, unmap_len,
 				    xfs_bmapi_aflag(whichfork),
@@ -1577,7 +1577,7 @@ xfs_itruncate_extents(
 		 * Duplicate the transaction that has the permanent
 		 * reservation and commit the old transaction.
 		 */
-		error = xfs_bmap_finish(&tp, &free_list, ip);
+		error = xfs_defer_finish(&tp, &free_list, ip);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -1603,7 +1603,7 @@ out_bmap_cancel:
 	 * the transaction can be properly aborted.  We just need to make sure
 	 * we're not holding any resources that we were not when we came in.
 	 */
-	xfs_bmap_cancel(&free_list);
+	xfs_defer_cancel(&free_list);
 	goto out;
 }
 
@@ -1744,7 +1744,7 @@ STATIC int
 xfs_inactive_ifree(
 	struct xfs_inode *ip)
 {
-	xfs_bmap_free_t		free_list;
+	struct xfs_defer_ops	free_list;
 	xfs_fsblock_t		first_block;
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
@@ -1781,7 +1781,7 @@ xfs_inactive_ifree(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	xfs_bmap_init(&free_list, &first_block);
+	xfs_defer_init(&free_list, &first_block);
 	error = xfs_ifree(tp, ip, &free_list);
 	if (error) {
 		/*
@@ -1808,11 +1808,11 @@ xfs_inactive_ifree(
 	 * Just ignore errors at this point.  There is nothing we can do except
 	 * to try to keep going. Make sure it's not a silent error.
 	 */
-	error = xfs_bmap_finish(&tp, &free_list, NULL);
+	error = xfs_defer_finish(&tp, &free_list, NULL);
 	if (error) {
-		xfs_notice(mp, "%s: xfs_bmap_finish returned error %d",
+		xfs_notice(mp, "%s: xfs_defer_finish returned error %d",
 			__func__, error);
-		xfs_bmap_cancel(&free_list);
+		xfs_defer_cancel(&free_list);
 	}
 	error = xfs_trans_commit(tp);
 	if (error)
@@ -2368,7 +2368,7 @@ int
 xfs_ifree(
 	xfs_trans_t	*tp,
 	xfs_inode_t	*ip,
-	xfs_bmap_free_t	*flist)
+	struct xfs_defer_ops	*flist)
 {
 	int			error;
 	struct xfs_icluster	xic = { 0 };
@@ -2475,7 +2475,7 @@ xfs_iunpin_wait(
  * directory entry.
  *
  * This is still safe from a transactional point of view - it is not until we
- * get to xfs_bmap_finish() that we have the possibility of multiple
+ * get to xfs_defer_finish() that we have the possibility of multiple
  * transactions in this operation. Hence as long as we remove the directory
  * entry and drop the link count in the first transaction of the remove
  * operation, there are no transactional constraints on the ordering here.
@@ -2490,7 +2490,7 @@ xfs_remove(
 	xfs_trans_t             *tp = NULL;
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
 	int                     error = 0;
-	xfs_bmap_free_t         free_list;
+	struct xfs_defer_ops	free_list;
 	xfs_fsblock_t           first_block;
 	uint			resblks;
 
@@ -2572,7 +2572,7 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	xfs_bmap_init(&free_list, &first_block);
+	xfs_defer_init(&free_list, &first_block);
 	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
 					&first_block, &free_list, resblks);
 	if (error) {
@@ -2588,7 +2588,7 @@ xfs_remove(
 	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
 		xfs_trans_set_sync(tp);
 
-	error = xfs_bmap_finish(&tp, &free_list, NULL);
+	error = xfs_defer_finish(&tp, &free_list, NULL);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -2602,7 +2602,7 @@ xfs_remove(
 	return 0;
 
  out_bmap_cancel:
-	xfs_bmap_cancel(&free_list);
+	xfs_defer_cancel(&free_list);
  out_trans_cancel:
 	xfs_trans_cancel(tp);
  std_return:
@@ -2663,7 +2663,7 @@ xfs_sort_for_rename(
 static int
 xfs_finish_rename(
 	struct xfs_trans	*tp,
-	struct xfs_bmap_free	*free_list)
+	struct xfs_defer_ops	*free_list)
 {
 	int			error;
 
@@ -2674,9 +2674,9 @@ xfs_finish_rename(
 	if (tp->t_mountp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
 		xfs_trans_set_sync(tp);
 
-	error = xfs_bmap_finish(&tp, free_list, NULL);
+	error = xfs_defer_finish(&tp, free_list, NULL);
 	if (error) {
-		xfs_bmap_cancel(free_list);
+		xfs_defer_cancel(free_list);
 		xfs_trans_cancel(tp);
 		return error;
 	}
@@ -2698,7 +2698,7 @@ xfs_cross_rename(
 	struct xfs_inode	*dp2,
 	struct xfs_name		*name2,
 	struct xfs_inode	*ip2,
-	struct xfs_bmap_free	*free_list,
+	struct xfs_defer_ops	*free_list,
 	xfs_fsblock_t		*first_block,
 	int			spaceres)
 {
@@ -2801,7 +2801,7 @@ xfs_cross_rename(
 	return xfs_finish_rename(tp, free_list);
 
 out_trans_abort:
-	xfs_bmap_cancel(free_list);
+	xfs_defer_cancel(free_list);
 	xfs_trans_cancel(tp);
 	return error;
 }
@@ -2856,7 +2856,7 @@ xfs_rename(
 {
 	struct xfs_mount	*mp = src_dp->i_mount;
 	struct xfs_trans	*tp;
-	struct xfs_bmap_free	free_list;
+	struct xfs_defer_ops	free_list;
 	xfs_fsblock_t		first_block;
 	struct xfs_inode	*wip = NULL;		/* whiteout inode */
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
@@ -2945,7 +2945,7 @@ xfs_rename(
 		goto out_trans_cancel;
 	}
 
-	xfs_bmap_init(&free_list, &first_block);
+	xfs_defer_init(&free_list, &first_block);
 
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE)
@@ -3131,7 +3131,7 @@ xfs_rename(
 	return error;
 
 out_bmap_cancel:
-	xfs_bmap_cancel(&free_list);
+	xfs_defer_cancel(&free_list);
 out_trans_cancel:
 	xfs_trans_cancel(tp);
 out_release_wip:
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 8eb78ec..e1a411e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -27,7 +27,7 @@
 struct xfs_dinode;
 struct xfs_inode;
 struct xfs_buf;
-struct xfs_bmap_free;
+struct xfs_defer_ops;
 struct xfs_bmbt_irec;
 struct xfs_inode_log_item;
 struct xfs_mount;
@@ -398,7 +398,7 @@ uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 
 uint		xfs_ip2xflags(struct xfs_inode *);
 int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
-			   struct xfs_bmap_free *);
+			   struct xfs_defer_ops *);
 int		xfs_itruncate_extents(struct xfs_trans **, struct xfs_inode *,
 				      int, xfs_fsize_t);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 023a4b4..dc93c20 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -129,7 +129,7 @@ xfs_iomap_write_direct(
 	int		quota_flag;
 	int		rt;
 	xfs_trans_t	*tp;
-	xfs_bmap_free_t free_list;
+	struct xfs_defer_ops free_list;
 	uint		qblocks, resblks, resrtextents;
 	int		error;
 	int		lockmode;
@@ -232,7 +232,7 @@ xfs_iomap_write_direct(
 	 * From this point onwards we overwrite the imap pointer that the
 	 * caller gave to us.
 	 */
-	xfs_bmap_init(&free_list, &firstfsb);
+	xfs_defer_init(&free_list, &firstfsb);
 	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
 				bmapi_flags, &firstfsb, resblks, imap,
@@ -243,7 +243,7 @@ xfs_iomap_write_direct(
 	/*
 	 * Complete the transaction
 	 */
-	error = xfs_bmap_finish(&tp, &free_list, NULL);
+	error = xfs_defer_finish(&tp, &free_list, NULL);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -267,7 +267,7 @@ out_unlock:
 	return error;
 
 out_bmap_cancel:
-	xfs_bmap_cancel(&free_list);
+	xfs_defer_cancel(&free_list);
 	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
 out_trans_cancel:
 	xfs_trans_cancel(tp);
@@ -686,7 +686,7 @@ xfs_iomap_write_allocate(
 	xfs_fileoff_t	offset_fsb, last_block;
 	xfs_fileoff_t	end_fsb, map_start_fsb;
 	xfs_fsblock_t	first_block;
-	xfs_bmap_free_t	free_list;
+	struct xfs_defer_ops	free_list;
 	xfs_filblks_t	count_fsb;
 	xfs_trans_t	*tp;
 	int		nimaps;
@@ -728,7 +728,7 @@ xfs_iomap_write_allocate(
 			xfs_ilock(ip, XFS_ILOCK_EXCL);
 			xfs_trans_ijoin(tp, ip, 0);
 
-			xfs_bmap_init(&free_list, &first_block);
+			xfs_defer_init(&free_list, &first_block);
 
 			/*
 			 * it is possible that the extents have changed since
@@ -788,7 +788,7 @@ xfs_iomap_write_allocate(
 			if (error)
 				goto trans_cancel;
 
-			error = xfs_bmap_finish(&tp, &free_list, NULL);
+			error = xfs_defer_finish(&tp, &free_list, NULL);
 			if (error)
 				goto trans_cancel;
 
@@ -822,7 +822,7 @@ xfs_iomap_write_allocate(
 	}
 
 trans_cancel:
-	xfs_bmap_cancel(&free_list);
+	xfs_defer_cancel(&free_list);
 	xfs_trans_cancel(tp);
 error0:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -843,7 +843,7 @@ xfs_iomap_write_unwritten(
 	int		nimaps;
 	xfs_trans_t	*tp;
 	xfs_bmbt_irec_t imap;
-	xfs_bmap_free_t free_list;
+	struct xfs_defer_ops free_list;
 	xfs_fsize_t	i_size;
 	uint		resblks;
 	int		error;
@@ -887,7 +887,7 @@ xfs_iomap_write_unwritten(
 		/*
 		 * Modify the unwritten extent state of the buffer.
 		 */
-		xfs_bmap_init(&free_list, &firstfsb);
+		xfs_defer_init(&free_list, &firstfsb);
 		nimaps = 1;
 		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
 					XFS_BMAPI_CONVERT, &firstfsb, resblks,
@@ -910,7 +910,7 @@ xfs_iomap_write_unwritten(
 			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 		}
 
-		error = xfs_bmap_finish(&tp, &free_list, NULL);
+		error = xfs_defer_finish(&tp, &free_list, NULL);
 		if (error)
 			goto error_on_bmapi_transaction;
 
@@ -937,7 +937,7 @@ xfs_iomap_write_unwritten(
 	return 0;
 
 error_on_bmapi_transaction:
-	xfs_bmap_cancel(&free_list);
+	xfs_defer_cancel(&free_list);
 	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 627f7e6..c761a6a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -770,7 +770,7 @@ xfs_growfs_rt_alloc(
 	xfs_daddr_t		d;		/* disk block address */
 	int			error;		/* error return value */
 	xfs_fsblock_t		firstblock;/* first block allocated in xaction */
-	struct xfs_bmap_free	flist;		/* list of freed blocks */
+	struct xfs_defer_ops	flist;		/* list of freed blocks */
 	xfs_fsblock_t		fsbno;		/* filesystem block for bno */
 	struct xfs_bmbt_irec	map;		/* block map output */
 	int			nmap;		/* number of block maps */
@@ -795,7 +795,7 @@ xfs_growfs_rt_alloc(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-		xfs_bmap_init(&flist, &firstblock);
+		xfs_defer_init(&flist, &firstblock);
 		/*
 		 * Allocate blocks to the bitmap file.
 		 */
@@ -810,7 +810,7 @@ xfs_growfs_rt_alloc(
 		/*
 		 * Free any blocks freed up in the transaction, then commit.
 		 */
-		error = xfs_bmap_finish(&tp, &flist, NULL);
+		error = xfs_defer_finish(&tp, &flist, NULL);
 		if (error)
 			goto out_bmap_cancel;
 		error = xfs_trans_commit(tp);
@@ -863,7 +863,7 @@ xfs_growfs_rt_alloc(
 	return 0;
 
 out_bmap_cancel:
-	xfs_bmap_cancel(&flist);
+	xfs_defer_cancel(&flist);
 out_trans_cancel:
 	xfs_trans_cancel(tp);
 	return error;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ce50474..688e650 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1701,7 +1701,7 @@ xfs_init_zones(void)
 		goto out_free_ioend_bioset;
 
 	xfs_bmap_free_item_zone = kmem_zone_init(
-			sizeof(struct xfs_bmap_free_item),
+			sizeof(struct xfs_extent_free_item),
 			"xfs_bmap_free_item");
 	if (!xfs_bmap_free_item_zone)
 		goto out_destroy_log_ticket_zone;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 20af47b..3b005ec 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -173,7 +173,7 @@ xfs_symlink(
 	struct xfs_inode	*ip = NULL;
 	int			error = 0;
 	int			pathlen;
-	struct xfs_bmap_free	free_list;
+	struct xfs_defer_ops	free_list;
 	xfs_fsblock_t		first_block;
 	bool                    unlock_dp_on_error = false;
 	xfs_fileoff_t		first_fsb;
@@ -270,7 +270,7 @@ xfs_symlink(
 	 * Initialize the bmap freelist prior to calling either
 	 * bmapi or the directory create code.
 	 */
-	xfs_bmap_init(&free_list, &first_block);
+	xfs_defer_init(&free_list, &first_block);
 
 	/*
 	 * Allocate an inode for the symlink.
@@ -377,7 +377,7 @@ xfs_symlink(
 		xfs_trans_set_sync(tp);
 	}
 
-	error = xfs_bmap_finish(&tp, &free_list, NULL);
+	error = xfs_defer_finish(&tp, &free_list, NULL);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -393,7 +393,7 @@ xfs_symlink(
 	return 0;
 
 out_bmap_cancel:
-	xfs_bmap_cancel(&free_list);
+	xfs_defer_cancel(&free_list);
 out_trans_cancel:
 	xfs_trans_cancel(tp);
 out_release_inode:
@@ -427,7 +427,7 @@ xfs_inactive_symlink_rmt(
 	int		done;
 	int		error;
 	xfs_fsblock_t	first_block;
-	xfs_bmap_free_t	free_list;
+	struct xfs_defer_ops	free_list;
 	int		i;
 	xfs_mount_t	*mp;
 	xfs_bmbt_irec_t	mval[XFS_SYMLINK_MAPS];
@@ -466,7 +466,7 @@ xfs_inactive_symlink_rmt(
 	 * Find the block(s) so we can inval and unmap them.
 	 */
 	done = 0;
-	xfs_bmap_init(&free_list, &first_block);
+	xfs_defer_init(&free_list, &first_block);
 	nmaps = ARRAY_SIZE(mval);
 	error = xfs_bmapi_read(ip, 0, xfs_symlink_blocks(mp, size),
 				mval, &nmaps, 0);
@@ -496,7 +496,7 @@ xfs_inactive_symlink_rmt(
 	/*
 	 * Commit the first transaction.  This logs the EFI and the inode.
 	 */
-	error = xfs_bmap_finish(&tp, &free_list, ip);
+	error = xfs_defer_finish(&tp, &free_list, ip);
 	if (error)
 		goto error_bmap_cancel;
 	/*
@@ -526,7 +526,7 @@ xfs_inactive_symlink_rmt(
 	return 0;
 
 error_bmap_cancel:
-	xfs_bmap_cancel(&free_list);
+	xfs_defer_cancel(&free_list);
 error_trans_cancel:
 	xfs_trans_cancel(tp);
 error_unlock:
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 005fbec..4a3721e 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -211,11 +211,6 @@ void		xfs_trans_log_buf(xfs_trans_t *, struct xfs_buf *, uint, uint);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 
 void		xfs_extent_free_init_defer_op(void);
-struct xfs_efi_log_item	*xfs_trans_get_efi(struct xfs_trans *, uint);
-void		xfs_trans_log_efi_extent(struct xfs_trans *,
-					 struct xfs_efi_log_item *,
-					 xfs_fsblock_t,
-					 xfs_extlen_t);
 struct xfs_efd_log_item	*xfs_trans_get_efd(struct xfs_trans *,
 				  struct xfs_efi_log_item *,
 				  uint);
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index a9f34ee..b484902 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -35,7 +35,7 @@
  * caller must use all nextents extents, because we are not
  * flexible about this at all.
  */
-struct xfs_efi_log_item *
+STATIC struct xfs_efi_log_item *
 xfs_trans_get_efi(struct xfs_trans	*tp,
 		  uint			nextents)
 {
@@ -59,7 +59,7 @@ xfs_trans_get_efi(struct xfs_trans	*tp,
  * extent is to be logged as needing to be freed.  It should
  * be called once for each extent to be freed.
  */
-void
+STATIC void
 xfs_trans_log_efi_extent(struct xfs_trans		*tp,
 			 struct xfs_efi_log_item	*efip,
 			 xfs_fsblock_t			start_block,
@@ -156,13 +156,13 @@ xfs_extent_free_diff_items(
 	struct list_head		*b)
 {
 	struct xfs_mount		*mp = priv;
-	struct xfs_bmap_free_item	*ra;
-	struct xfs_bmap_free_item	*rb;
+	struct xfs_extent_free_item	*ra;
+	struct xfs_extent_free_item	*rb;
 
-	ra = container_of(a, struct xfs_bmap_free_item, xbfi_list);
-	rb = container_of(b, struct xfs_bmap_free_item, xbfi_list);
-	return  XFS_FSB_TO_AGNO(mp, ra->xbfi_startblock) -
-		XFS_FSB_TO_AGNO(mp, rb->xbfi_startblock);
+	ra = container_of(a, struct xfs_extent_free_item, xefi_list);
+	rb = container_of(b, struct xfs_extent_free_item, xefi_list);
+	return  XFS_FSB_TO_AGNO(mp, ra->xefi_startblock) -
+		XFS_FSB_TO_AGNO(mp, rb->xefi_startblock);
 }
 
 /* Get an EFI. */
@@ -181,11 +181,11 @@ xfs_extent_free_log_item(
 	void				*intent,
 	struct list_head		*item)
 {
-	struct xfs_bmap_free_item	*free;
+	struct xfs_extent_free_item	*free;
 
-	free = container_of(item, struct xfs_bmap_free_item, xbfi_list);
-	xfs_trans_log_efi_extent(tp, intent, free->xbfi_startblock,
-			free->xbfi_blockcount);
+	free = container_of(item, struct xfs_extent_free_item, xefi_list);
+	xfs_trans_log_efi_extent(tp, intent, free->xefi_startblock,
+			free->xefi_blockcount);
 }
 
 /* Get an EFD so we can process all the free extents. */
@@ -207,13 +207,13 @@ xfs_extent_free_finish_item(
 	void				*done_item,
 	void				**state)
 {
-	struct xfs_bmap_free_item	*free;
+	struct xfs_extent_free_item	*free;
 	int				error;
 
-	free = container_of(item, struct xfs_bmap_free_item, xbfi_list);
+	free = container_of(item, struct xfs_extent_free_item, xefi_list);
 	error = xfs_trans_free_extent(tp, done_item,
-			free->xbfi_startblock,
-			free->xbfi_blockcount);
+			free->xefi_startblock,
+			free->xefi_blockcount);
 	kmem_free(free);
 	return error;
 }
@@ -231,9 +231,9 @@ STATIC void
 xfs_extent_free_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_bmap_free_item	*free;
+	struct xfs_extent_free_item	*free;
 
-	free = container_of(item, struct xfs_bmap_free_item, xbfi_list);
+	free = container_of(item, struct xfs_extent_free_item, xefi_list);
 	kmem_free(free);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
