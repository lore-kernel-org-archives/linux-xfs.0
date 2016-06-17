Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 274A5819A
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:35:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 92C5FAC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:35:46 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 7eRmhdvPJr5iVCYG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:35:43 -0700 (PDT)
Subject: [PATCH 046/145] xfs: propagate bmap updates to rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:35:35 -0700
Message-ID: <146612733514.16048.2625675620980385531.stgit@birch.djwong.org>
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

When we map, unmap, or convert an extent in a file's data or attr
fork, schedule a respective update in the rmapbt.  Previous versions
of this patch required a 1:1 correspondence between bmap and rmap,
but this is no longer true.

v2: Remove the 1:1 correspondence requirement now that we have the
ability to make interval queries against the rmapbt.  Update the
commit message to reflect the broad restructuring of this patch.
Fix the bmap shift code to adjust the rmaps correctly.

v3: Use the deferred operations code to handle redo operations
atomically and deadlock free.  Plumb in all five rmap actions
(map, unmap, convert extent, alloc, free); we'll use the first
three now for file data, and reflink will want the last two.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trace.h     |    2 
 libxfs/defer_item.c     |   18 +++
 libxfs/util.c           |    1 
 libxfs/xfs_bmap.c       |   56 +++++++++-
 libxfs/xfs_rmap.c       |  252 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap_btree.h |   24 ++++
 6 files changed, 344 insertions(+), 9 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 55df410..00c2ccb 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -200,6 +200,8 @@
 #define trace_xfs_rmapbt_insert_error(...)	((void) 0)
 #define trace_xfs_rmapbt_delete(...)		((void) 0)
 #define trace_xfs_rmapbt_delete_error(...)	((void) 0)
+#define trace_xfs_rmap_defer(...)		((void) 0)
+#define trace_xfs_rmap_deferred(...)		((void) 0)
 
 #define trace_xfs_rmap_lookup_le_range_result(...)		((void) 0)
 #define trace_xfs_rmap_map_gtrec(...)		((void) 0)
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index cd88cfd..381c969 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -183,7 +183,20 @@ xfs_rmap_update_finish_item(
 	void				*done_item,
 	void				**state)
 {
-	return -EFSCORRUPTED;
+	struct xfs_rmap_intent		*rmap;
+	int				error;
+
+	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
+	error = xfs_rmap_finish_one(tp,
+			rmap->ri_type,
+			rmap->ri_owner, rmap->ri_whichfork,
+			rmap->ri_bmap.br_startoff,
+			rmap->ri_bmap.br_startblock,
+			rmap->ri_bmap.br_blockcount,
+			rmap->ri_bmap.br_state,
+			(struct xfs_btree_cur **)state);
+	kmem_free(rmap);
+	return error;
 }
 
 /* Clean up after processing deferred rmaps. */
@@ -193,6 +206,9 @@ xfs_rmap_update_finish_cleanup(
 	void			*state,
 	int			error)
 {
+	struct xfs_btree_cur	*rcur = state;
+
+	xfs_rmap_finish_one_cleanup(tp, rcur, error);
 }
 
 /* Abort all pending RUIs. */
diff --git a/libxfs/util.c b/libxfs/util.c
index 5b277c2..2ba6510 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -37,6 +37,7 @@
 #include "xfs_alloc.h"
 #include "xfs_bit.h"
 #include "list.h"
+#include "xfs_rmap_btree.h"
 
 /*
  * Calculate the worst case log unit reservation for a given superblock
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 453d073..e9ccec5 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -38,6 +38,7 @@
 #include "xfs_trace.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_quota_defs.h"
+#include "xfs_rmap_btree.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -2170,6 +2171,11 @@ xfs_bmap_add_extent_delay_real(
 		ASSERT(0);
 	}
 
+	/* add reverse mapping */
+	error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip, whichfork, new);
+	if (error)
+		goto done;
+
 	/* convert to a btree if necessary */
 	if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 		int	tmp_logflags;	/* partial log flag return val */
@@ -2706,6 +2712,11 @@ xfs_bmap_add_extent_unwritten_real(
 		ASSERT(0);
 	}
 
+	/* update reverse mappings */
+	error = xfs_rmap_convert_extent(mp, dfops, ip, XFS_DATA_FORK, new);
+	if (error)
+		goto done;
+
 	/* convert to a btree if necessary */
 	if (xfs_bmap_needs_btree(ip, XFS_DATA_FORK)) {
 		int	tmp_logflags;	/* partial log flag return val */
@@ -3098,6 +3109,11 @@ xfs_bmap_add_extent_hole_real(
 		break;
 	}
 
+	/* add reverse mapping */
+	error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip, whichfork, new);
+	if (error)
+		goto done;
+
 	/* convert to a btree if necessary */
 	if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 		int	tmp_logflags;	/* partial log flag return val */
@@ -5024,6 +5040,14 @@ xfs_bmap_del_extent(
 		++*idx;
 		break;
 	}
+
+	/* remove reverse mapping */
+	if (!delay) {
+		error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, del);
+		if (error)
+			goto done;
+	}
+
 	/*
 	 * If we need to, add to list of extents to delete.
 	 */
@@ -5561,7 +5585,8 @@ xfs_bmse_shift_one(
 	struct xfs_bmbt_rec_host	*gotp,
 	struct xfs_btree_cur		*cur,
 	int				*logflags,
-	enum shift_direction		direction)
+	enum shift_direction		direction,
+	struct xfs_defer_ops		*dfops)
 {
 	struct xfs_ifork		*ifp;
 	struct xfs_mount		*mp;
@@ -5609,9 +5634,13 @@ xfs_bmse_shift_one(
 		/* check whether to merge the extent or shift it down */
 		if (xfs_bmse_can_merge(&adj_irec, &got,
 				       offset_shift_fsb)) {
-			return xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
-					      *current_ext, gotp, adj_irecp,
-					      cur, logflags);
+			error = xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
+					       *current_ext, gotp, adj_irecp,
+					       cur, logflags);
+			if (error)
+				return error;
+			adj_irec = got;
+			goto update_rmap;
 		}
 	} else {
 		startoff = got.br_startoff + offset_shift_fsb;
@@ -5648,9 +5677,10 @@ update_current_ext:
 		(*current_ext)--;
 	xfs_bmbt_set_startoff(gotp, startoff);
 	*logflags |= XFS_ILOG_CORE;
+	adj_irec = got;
 	if (!cur) {
 		*logflags |= XFS_ILOG_DEXT;
-		return 0;
+		goto update_rmap;
 	}
 
 	error = xfs_bmbt_lookup_eq(cur, got.br_startoff, got.br_startblock,
@@ -5660,8 +5690,18 @@ update_current_ext:
 	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 
 	got.br_startoff = startoff;
-	return xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
-			       got.br_blockcount, got.br_state);
+	error = xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
+			got.br_blockcount, got.br_state);
+	if (error)
+		return error;
+
+update_rmap:
+	/* update reverse mapping */
+	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, &adj_irec);
+	if (error)
+		return error;
+	adj_irec.br_startoff = startoff;
+	return xfs_rmap_map_extent(mp, dfops, ip, whichfork, &adj_irec);
 }
 
 /*
@@ -5789,7 +5829,7 @@ xfs_bmap_shift_extents(
 	while (nexts++ < num_exts) {
 		error = xfs_bmse_shift_one(ip, whichfork, offset_shift_fsb,
 					   &current_ext, gotp, cur, &logflags,
-					   direction);
+					   direction, dfops);
 		if (error)
 			goto del_cursor;
 		/*
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 47f37d7..7637903 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -34,6 +34,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_bmap.h"
+#include "xfs_inode.h"
 
 /*
  * Lookup the first record less than or equal to [bno, len, owner, offset]
@@ -1210,3 +1212,253 @@ xfs_rmapbt_query_range(
 	return xfs_btree_query_range(cur, &low_brec, &high_brec,
 			xfs_rmapbt_query_range_helper, &query);
 }
+
+/* Clean up after calling xfs_rmap_finish_one. */
+void
+xfs_rmap_finish_one_cleanup(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	*rcur,
+	int			error)
+{
+	struct xfs_buf		*agbp;
+
+	if (rcur == NULL)
+		return;
+	agbp = rcur->bc_private.a.agbp;
+	xfs_btree_del_cursor(rcur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_trans_brelse(tp, agbp);
+}
+
+/*
+ * Process one of the deferred rmap operations.  We pass back the
+ * btree cursor to maintain our lock on the rmapbt between calls.
+ * This saves time and eliminates a buffer deadlock between the
+ * superblock and the AGF because we'll always grab them in the same
+ * order.
+ */
+int
+xfs_rmap_finish_one(
+	struct xfs_trans		*tp,
+	enum xfs_rmap_intent_type	type,
+	__uint64_t			owner,
+	int				whichfork,
+	xfs_fileoff_t			startoff,
+	xfs_fsblock_t			startblock,
+	xfs_filblks_t			blockcount,
+	xfs_exntst_t			state,
+	struct xfs_btree_cur		**pcur)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_btree_cur		*rcur;
+	struct xfs_buf			*agbp = NULL;
+	int				error = 0;
+	xfs_agnumber_t			agno;
+	struct xfs_owner_info		oinfo;
+	xfs_agblock_t			bno;
+	bool				unwritten;
+
+	agno = XFS_FSB_TO_AGNO(mp, startblock);
+	ASSERT(agno != NULLAGNUMBER);
+	bno = XFS_FSB_TO_AGBNO(mp, startblock);
+
+	trace_xfs_rmap_deferred(mp, agno, type, bno, owner, whichfork,
+			startoff, blockcount, state);
+
+	if (XFS_TEST_ERROR(false, mp,
+			XFS_ERRTAG_RMAP_FINISH_ONE,
+			XFS_RANDOM_RMAP_FINISH_ONE))
+		return -EIO;
+
+	/*
+	 * If we haven't gotten a cursor or the cursor AG doesn't match
+	 * the startblock, get one now.
+	 */
+	rcur = *pcur;
+	if (rcur != NULL && rcur->bc_private.a.agno != agno) {
+		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
+		rcur = NULL;
+		*pcur = NULL;
+	}
+	if (rcur == NULL) {
+		error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
+		if (error)
+			return error;
+		if (!agbp)
+			return -EFSCORRUPTED;
+
+		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+		if (!rcur) {
+			error = -ENOMEM;
+			goto out_cur;
+		}
+	}
+	*pcur = rcur;
+
+	xfs_rmap_ino_owner(&oinfo, owner, whichfork, startoff);
+	unwritten = state == XFS_EXT_UNWRITTEN;
+	bno = XFS_FSB_TO_AGBNO(rcur->bc_mp, startblock);
+
+	switch (type) {
+	case XFS_RMAP_MAP:
+		error = xfs_rmap_map(rcur, bno, blockcount, unwritten, &oinfo);
+		break;
+	case XFS_RMAP_UNMAP:
+		error = xfs_rmap_unmap(rcur, bno, blockcount, unwritten,
+				&oinfo);
+		break;
+	case XFS_RMAP_CONVERT:
+		error = xfs_rmap_convert(rcur, bno, blockcount, !unwritten,
+				&oinfo);
+		break;
+	case XFS_RMAP_ALLOC:
+		error = __xfs_rmap_alloc(rcur, bno, blockcount, unwritten,
+				&oinfo);
+		break;
+	case XFS_RMAP_FREE:
+		error = __xfs_rmap_free(rcur, bno, blockcount, unwritten,
+				&oinfo);
+		break;
+	default:
+		ASSERT(0);
+		error = -EFSCORRUPTED;
+	}
+	return error;
+
+out_cur:
+	xfs_trans_brelse(tp, agbp);
+
+	return error;
+}
+
+/*
+ * Record a rmap intent; the list is kept sorted first by AG and then by
+ * increasing age.
+ */
+static int
+__xfs_rmap_add(
+	struct xfs_mount	*mp,
+	struct xfs_defer_ops	*dfops,
+	struct xfs_rmap_intent	*ri)
+{
+	struct xfs_rmap_intent	*new;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return 0;
+
+	trace_xfs_rmap_defer(mp, XFS_FSB_TO_AGNO(mp, ri->ri_bmap.br_startblock),
+			ri->ri_type,
+			XFS_FSB_TO_AGBNO(mp, ri->ri_bmap.br_startblock),
+			ri->ri_owner, ri->ri_whichfork,
+			ri->ri_bmap.br_startoff,
+			ri->ri_bmap.br_blockcount,
+			ri->ri_bmap.br_state);
+
+	new = kmem_zalloc(sizeof(struct xfs_rmap_intent), KM_SLEEP | KM_NOFS);
+	*new = *ri;
+
+	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_RMAP, &new->ri_list);
+	return 0;
+}
+
+/* Map an extent into a file. */
+int
+xfs_rmap_map_extent(
+	struct xfs_mount	*mp,
+	struct xfs_defer_ops	*dfops,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV)
+{
+	struct xfs_rmap_intent	ri;
+
+	ri.ri_type = XFS_RMAP_MAP;
+	ri.ri_owner = ip->i_ino;
+	ri.ri_whichfork = whichfork;
+	ri.ri_bmap = *PREV;
+
+	return __xfs_rmap_add(mp, dfops, &ri);
+}
+
+/* Unmap an extent out of a file. */
+int
+xfs_rmap_unmap_extent(
+	struct xfs_mount	*mp,
+	struct xfs_defer_ops	*dfops,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV)
+{
+	struct xfs_rmap_intent	ri;
+
+	ri.ri_type = XFS_RMAP_UNMAP;
+	ri.ri_owner = ip->i_ino;
+	ri.ri_whichfork = whichfork;
+	ri.ri_bmap = *PREV;
+
+	return __xfs_rmap_add(mp, dfops, &ri);
+}
+
+/* Convert a data fork extent from unwritten to real or vice versa. */
+int
+xfs_rmap_convert_extent(
+	struct xfs_mount	*mp,
+	struct xfs_defer_ops	*dfops,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV)
+{
+	struct xfs_rmap_intent	ri;
+
+	ri.ri_type = XFS_RMAP_CONVERT;
+	ri.ri_owner = ip->i_ino;
+	ri.ri_whichfork = whichfork;
+	ri.ri_bmap = *PREV;
+
+	return __xfs_rmap_add(mp, dfops, &ri);
+}
+
+/* Schedule the creation of an rmap for non-file data. */
+int
+xfs_rmap_alloc_defer(
+	struct xfs_mount	*mp,
+	struct xfs_defer_ops	*dfops,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	__uint64_t		owner)
+{
+	struct xfs_rmap_intent	ri;
+
+	ri.ri_type = XFS_RMAP_ALLOC;
+	ri.ri_owner = owner;
+	ri.ri_whichfork = XFS_DATA_FORK;
+	ri.ri_bmap.br_startblock = XFS_AGB_TO_FSB(mp, agno, bno);
+	ri.ri_bmap.br_blockcount = len;
+	ri.ri_bmap.br_startoff = 0;
+	ri.ri_bmap.br_state = XFS_EXT_NORM;
+
+	return __xfs_rmap_add(mp, dfops, &ri);
+}
+
+/* Schedule the deletion of an rmap for non-file data. */
+int
+xfs_rmap_free_defer(
+	struct xfs_mount	*mp,
+	struct xfs_defer_ops	*dfops,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	__uint64_t		owner)
+{
+	struct xfs_rmap_intent	ri;
+
+	ri.ri_type = XFS_RMAP_FREE;
+	ri.ri_owner = owner;
+	ri.ri_whichfork = XFS_DATA_FORK;
+	ri.ri_bmap.br_startblock = XFS_AGB_TO_FSB(mp, agno, bno);
+	ri.ri_bmap.br_blockcount = len;
+	ri.ri_bmap.br_startoff = 0;
+	ri.ri_bmap.br_state = XFS_EXT_NORM;
+
+	return __xfs_rmap_add(mp, dfops, &ri);
+}
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index aff60dc..5df406e 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -106,4 +106,28 @@ struct xfs_rmap_intent {
 	struct xfs_bmbt_irec			ri_bmap;
 };
 
+/* functions for updating the rmapbt based on bmbt map/unmap operations */
+int xfs_rmap_map_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
+		struct xfs_inode *ip, int whichfork,
+		struct xfs_bmbt_irec *imap);
+int xfs_rmap_unmap_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
+		struct xfs_inode *ip, int whichfork,
+		struct xfs_bmbt_irec *imap);
+int xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
+		struct xfs_inode *ip, int whichfork,
+		struct xfs_bmbt_irec *imap);
+int xfs_rmap_alloc_defer(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
+		xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
+		__uint64_t owner);
+int xfs_rmap_free_defer(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
+		xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
+		__uint64_t owner);
+
+void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
+		struct xfs_btree_cur *rcur, int error);
+int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
+		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
+		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
+		xfs_exntst_t state, struct xfs_btree_cur **pcur);
+
 #endif	/* __XFS_RMAP_BTREE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
