Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B34E1833C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:41:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 72D278F804C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:41:36 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Bx1EJyflbXLEfFKr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:41:34 -0700 (PDT)
Subject: [PATCH 101/145] xfs: preallocate blocks for worst-case btree expansion
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:41:25 -0700
Message-ID: <146612768501.16048.10887544125329436696.stgit@birch.djwong.org>
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
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

To gracefully handle the situation where a CoW operation turns a
single refcount extent into a lot of tiny ones and then run out of
space when a tree split has to happen, use the per-AG reserved block
pool to pre-allocate all the space we'll ever need for a maximal
btree.  For a 4K block size, this only costs an overhead of 0.3% of
available disk space.

When reflink is enabled, we have an unfortunate problem with rmap --
since we can share a block billions of times, this means that the
reverse mapping btree can expand basically infinitely.  When an AG is
so full that there are no free blocks with which to expand the rmapbt,
the filesystem will shut down hard.

This is rather annoying to the user, so use the AG reservation code to
reserve a "reasonable" amount of space for rmap.  We'll prevent
reflinks and CoW operations if we think we're getting close to
exhausting an AG's free space rather than shutting down, but this
permanent reservation should be enough for "most" users.  Hopefully.

v2: Simplify the return value from xfs_perag_pool_free_block to a bool
so that we can easily call xfs_trans_binval for both the per-AG pool
and the real freeing case.  Without this we fail to invalidate the
btree buffer and will trip over the write verifier on a shrinking
refcount btree.

v3: Convert to the new per-AG reservation code.

v4: Combine this patch with the one that adds the rmapbt reservation,
since the rmapbt reservation is only needed for reflink filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch@lst.de: ensure that we invalidate the freed btree buffer]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag_resv.c        |   11 ++++++
 libxfs/xfs_alloc.c          |    2 -
 libxfs/xfs_refcount_btree.c |   61 ++++++++++++++++++++++++++++++---
 libxfs/xfs_refcount_btree.h |    3 ++
 libxfs/xfs_rmap_btree.c     |   80 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap_btree.h     |    7 ++++
 6 files changed, 157 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 03413e4..dd899d4 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -37,6 +37,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_btree.h"
+#include "xfs_refcount_btree.h"
 
 /*
  * Per-AG Block Reservations
@@ -224,6 +225,11 @@ xfs_ag_resv_init(
 	/* Create the metadata reservation. */
 	ask = used = 0;
 
+	err2 = xfs_refcountbt_calc_reserves(pag->pag_mount, pag->pag_agno,
+			&ask, &used);
+	if (err2 && !error)
+		error = err2;
+
 	err2 = __xfs_ag_resv_init(pag, XFS_AG_RESV_METADATA, ask, used);
 	if (err2 && !error)
 		error = err2;
@@ -235,6 +241,11 @@ init_agfl:
 	/* Create the AGFL metadata reservation */
 	ask = used = 0;
 
+	err2 = xfs_rmapbt_calc_reserves(pag->pag_mount, pag->pag_agno,
+			&ask, &used);
+	if (err2 && !error)
+		error = err2;
+
 	err2 = __xfs_ag_resv_init(pag, XFS_AG_RESV_AGFL, ask, used);
 	if (err2 && !error)
 		error = err2;
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index ca3e7ce..33087e6 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -135,8 +135,6 @@ xfs_alloc_ag_max_usable(struct xfs_mount *mp)
 		/* rmap root block + full tree split on full AG */
 		blocks += 1 + (2 * mp->m_ag_maxlevels) - 1;
 	}
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
-		blocks += xfs_refcountbt_max_size(mp);
 
 	return mp->m_sb.sb_agblocks - blocks;
 }
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 8c1cba9..1b3ba07 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -75,6 +75,8 @@ xfs_refcountbt_alloc_block(
 	struct xfs_alloc_arg	args;		/* block allocation args */
 	int			error;		/* error return value */
 
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
@@ -84,6 +86,7 @@ xfs_refcountbt_alloc_block(
 	args.firstblock = args.fsbno;
 	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_REFC);
 	args.minlen = args.maxlen = args.prod = 1;
+	args.resv = XFS_AG_RESV_METADATA;
 
 	error = xfs_alloc_vextent(&args);
 	if (error)
@@ -115,17 +118,20 @@ xfs_refcountbt_free_block(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_trans	*tp = cur->bc_tp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 	struct xfs_owner_info	oinfo;
+	int			error;
 
 	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_private.a.agno,
 			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
-	xfs_bmap_add_free(mp, cur->bc_private.a.dfops, fsbno, 1,
-			&oinfo);
-	xfs_trans_binval(tp, bp);
-	return 0;
+	error = xfs_free_extent(cur->bc_tp, fsbno, 1, &oinfo,
+			XFS_AG_RESV_METADATA);
+	if (error)
+		return error;
+
+	xfs_trans_binval(cur->bc_tp, bp);
+	return error;
 }
 
 STATIC int
@@ -395,3 +401,48 @@ xfs_refcountbt_max_size(
 
 	return xfs_refcountbt_calc_size(mp, mp->m_sb.sb_agblocks);
 }
+
+/* Count the blocks in the reference count tree. */
+static int
+xfs_refcountbt_count_blocks(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		*tree_blocks)
+{
+	struct xfs_buf		*agbp;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		return error;
+	cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
+	error = xfs_btree_count_blocks(cur, tree_blocks);
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_trans_brelse(NULL, agbp);
+
+	return error;
+}
+
+/*
+ * Figure out how many blocks to reserve and how many are used by this btree.
+ */
+int
+xfs_refcountbt_calc_reserves(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		*ask,
+	xfs_extlen_t		*used)
+{
+	xfs_extlen_t		tree_len = 0;
+	int			error;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+
+	*ask += xfs_refcountbt_max_size(mp);
+	error = xfs_refcountbt_count_blocks(mp, agno, &tree_len);
+	*used += tree_len;
+
+	return error;
+}
diff --git a/libxfs/xfs_refcount_btree.h b/libxfs/xfs_refcount_btree.h
index 780b02f..3be7768 100644
--- a/libxfs/xfs_refcount_btree.h
+++ b/libxfs/xfs_refcount_btree.h
@@ -68,4 +68,7 @@ extern xfs_extlen_t xfs_refcountbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 extern xfs_extlen_t xfs_refcountbt_max_size(struct xfs_mount *mp);
 
+extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
+		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
+
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 3fedfd7..0b7da82 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -32,6 +32,7 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
+#include "xfs_ag_resv.h"
 
 /*
  * Reverse map btree.
@@ -58,6 +59,14 @@
  * try to recover tree and file data from corrupt primary metadata.
  */
 
+static bool
+xfs_rmapbt_need_reserve(
+	struct xfs_mount	*mp)
+{
+	return  xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+		xfs_sb_version_hasreflink(&mp->m_sb);
+}
+
 static struct xfs_btree_cur *
 xfs_rmapbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
@@ -479,3 +488,74 @@ xfs_rmapbt_compute_maxlevels(
 		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(mp,
 				mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
 }
+
+/* Calculate the refcount btree size for some records. */
+xfs_extlen_t
+xfs_rmapbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp, mp->m_rmap_mnr, len);
+}
+
+/*
+ * Calculate the maximum refcount btree size.
+ */
+xfs_extlen_t
+xfs_rmapbt_max_size(
+	struct xfs_mount	*mp)
+{
+	/* Bail out if we're uninitialized, which can happen in mkfs. */
+	if (mp->m_rmap_mxr[0] == 0)
+		return 0;
+
+	return xfs_rmapbt_calc_size(mp, mp->m_sb.sb_agblocks);
+}
+
+/* Count the blocks in the reference count tree. */
+static int
+xfs_rmapbt_count_blocks(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		*tree_blocks)
+{
+	struct xfs_buf		*agbp;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		return error;
+	cur = xfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
+	error = xfs_btree_count_blocks(cur, tree_blocks);
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_trans_brelse(NULL, agbp);
+
+	return error;
+}
+
+/*
+ * Figure out how many blocks to reserve and how many are used by this btree.
+ */
+int
+xfs_rmapbt_calc_reserves(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		*ask,
+	xfs_extlen_t		*used)
+{
+	xfs_extlen_t		pool_len;
+	xfs_extlen_t		tree_len = 0;
+	int			error;
+
+	if (!xfs_rmapbt_need_reserve(mp))
+		return 0;
+
+	/* Reserve 1% of the AG or enough for 1 block per record. */
+	pool_len = max(mp->m_sb.sb_agblocks / 100, xfs_rmapbt_max_size(mp));
+	*ask += pool_len;
+	error = xfs_rmapbt_count_blocks(mp, agno, &tree_len);
+	*used += tree_len;
+
+	return error;
+}
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index 5df406e..f398e8b 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -130,4 +130,11 @@ int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
 		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
 		xfs_exntst_t state, struct xfs_btree_cur **pcur);
 
+extern xfs_extlen_t xfs_rmapbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp);
+
+extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp,
+		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
+
 #endif	/* __XFS_RMAP_BTREE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
