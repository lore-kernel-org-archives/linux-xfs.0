Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B79218047
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:45:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7C4C230404E
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:45:10 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id NafcRIwJAvwBAp9X (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:45:08 -0700 (PDT)
Subject: [PATCH 15/20] xfs: wire up rmap map and unmap to the realtime rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:45:01 -0700
Message-ID: <147216870139.3688.13864882802473337845.stgit@birch.djwong.org>
In-Reply-To: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
References: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Connect the map and unmap reverse-mapping operations to the realtime
rmapbt via the deferred operation callbacks.  This enables us to
perform rmap operations against the correct btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   63 ++++++++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_rmap.h |    9 ++++---
 fs/xfs/xfs_rmap_item.c   |    8 +++++-
 fs/xfs/xfs_trans.h       |    9 ++++---
 fs/xfs/xfs_trans_rmap.c  |    7 +++--
 5 files changed, 62 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 73e8dc4..f3e47d6 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -38,6 +38,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
+#include "xfs_rtrmap_btree.h"
 
 /* By convention, the rtrmapbt's "AG" number is NULLAGNUMBER. */
 static xfs_agnumber_t
@@ -2062,13 +2063,14 @@ xfs_rmap_finish_one_cleanup(
 	struct xfs_btree_cur	*rcur,
 	int			error)
 {
-	struct xfs_buf		*agbp;
+	struct xfs_buf		*agbp = NULL;
 
 	if (rcur == NULL)
 		return;
-	agbp = rcur->bc_private.a.agbp;
+	if (!(rcur->bc_flags & XFS_BTREE_LONG_PTRS))
+		agbp = rcur->bc_private.a.agbp;
 	xfs_btree_del_cursor(rcur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
-	if (error)
+	if (error && agbp)
 		xfs_trans_brelse(tp, agbp);
 }
 
@@ -2082,6 +2084,7 @@ xfs_rmap_finish_one_cleanup(
 int
 xfs_rmap_finish_one(
 	struct xfs_trans		*tp,
+	struct xfs_defer_ops		*dfops,
 	enum xfs_rmap_intent_type	type,
 	__uint64_t			owner,
 	int				whichfork,
@@ -2089,6 +2092,7 @@ xfs_rmap_finish_one(
 	xfs_fsblock_t			startblock,
 	xfs_filblks_t			blockcount,
 	xfs_exntst_t			state,
+	bool				realtime,
 	struct xfs_btree_cur		**pcur)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
@@ -2100,9 +2104,8 @@ xfs_rmap_finish_one(
 	xfs_fsblock_t			bno;
 	bool				unwritten;
 
-	agno = XFS_FSB_TO_AGNO(mp, startblock);
-	ASSERT(agno != NULLAGNUMBER);
-	bno = XFS_FSB_TO_AGBNO(mp, startblock);
+	agno = realtime ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, startblock);
+	bno = realtime ? startblock : XFS_FSB_TO_AGBNO(mp, startblock);
 
 	trace_xfs_rmap_deferred(mp, agno, type, bno, owner, whichfork,
 			startoff, blockcount, state);
@@ -2122,31 +2125,45 @@ xfs_rmap_finish_one(
 		*pcur = NULL;
 	}
 	if (rcur == NULL) {
-		/*
-		 * Refresh the freelist before we start changing the
-		 * rmapbt, because a shape change could cause us to
-		 * allocate blocks.
-		 */
-		error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
-		if (error)
-			return error;
-		if (!agbp)
-			return -EFSCORRUPTED;
-
-		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
-		if (!rcur) {
-			error = -ENOMEM;
-			goto out_cur;
+		if (realtime) {
+			xfs_ilock(mp->m_rrmapip,
+					XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
+			xfs_trans_ijoin(tp, mp->m_rrmapip, XFS_ILOCK_EXCL);
+			rcur = xfs_rtrmapbt_init_cursor(mp, tp, mp->m_rrmapip);
+			if (!rcur) {
+				error = -ENOMEM;
+				goto out_cur;
+			}
+			rcur->bc_private.b.dfops = dfops;
+			rcur->bc_private.b.flags = 0;
+		} else {
+			/*
+			 * Refresh the freelist before we start changing the
+			 * rmapbt, because a shape change could cause us to
+			 * allocate blocks.
+			 */
+			error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
+			if (error)
+				return error;
+			if (!agbp)
+				return -EFSCORRUPTED;
+
+			rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+			if (!rcur) {
+				error = -ENOMEM;
+				goto out_cur;
+			}
 		}
 	}
 	*pcur = rcur;
 
 	xfs_rmap_ino_owner(&oinfo, owner, whichfork, startoff);
 	unwritten = state == XFS_EXT_UNWRITTEN;
-	bno = XFS_FSB_TO_AGBNO(rcur->bc_mp, startblock);
 
 	switch (type) {
 	case XFS_RMAP_ALLOC:
+		ASSERT(!realtime);
+		/* fall through */
 	case XFS_RMAP_MAP:
 		error = xfs_rmap_map(rcur, bno, blockcount, unwritten, &oinfo);
 		break;
@@ -2155,6 +2172,8 @@ xfs_rmap_finish_one(
 				&oinfo);
 		break;
 	case XFS_RMAP_FREE:
+		ASSERT(!realtime);
+		/* fall through */
 	case XFS_RMAP_UNMAP:
 		error = xfs_rmap_unmap(rcur, bno, blockcount, unwritten,
 				&oinfo);
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 0850310..8d9c48f2 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -202,10 +202,11 @@ int xfs_rmap_free_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
 
 void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
 		struct xfs_btree_cur *rcur, int error);
-int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
-		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
-		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
-		xfs_exntst_t state, struct xfs_btree_cur **pcur);
+int xfs_rmap_finish_one(struct xfs_trans *tp, struct xfs_defer_ops *dfops,
+		enum xfs_rmap_intent_type type, __uint64_t owner, int whichfork,
+		xfs_fileoff_t startoff, xfs_fsblock_t startblock,
+		xfs_filblks_t blockcount, xfs_exntst_t state, bool realtime,
+		struct xfs_btree_cur **pcur);
 
 int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 01d6edf..a57aebb 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -446,6 +446,8 @@ xfs_rui_recover(
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
 	bool				rt;
+	struct xfs_defer_ops		dfops;
+	xfs_fsblock_t			firstfsb;
 
 	ASSERT(!test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags));
 
@@ -493,6 +495,7 @@ xfs_rui_recover(
 		return error;
 	rudp = xfs_trans_get_rud(tp, ruip);
 
+	xfs_defer_init(&dfops, &firstfsb);
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
 		rmap = &ruip->rui_format.rui_extents[i];
 		state = (rmap->me_flags & XFS_RMAP_EXTENT_UNWRITTEN) ?
@@ -529,7 +532,7 @@ xfs_rui_recover(
 			error = -EFSCORRUPTED;
 			goto abort_error;
 		}
-		error = xfs_trans_log_finish_rmap_update(tp, rudp, type,
+		error = xfs_trans_log_finish_rmap_update(tp, &dfops, rudp, type,
 				rmap->me_owner, whichfork,
 				rmap->me_startoff, rmap->me_startblock,
 				rmap->me_len, state, rt, &rcur);
@@ -539,6 +542,9 @@ xfs_rui_recover(
 	}
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
+	error = xfs_defer_finish(&tp, &dfops, NULL);
+	if (error)
+		goto abort_error;
 	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
 	error = xfs_trans_commit(tp);
 	return error;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index fbd7bc8..17ac0e8 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -248,10 +248,11 @@ void xfs_rmap_update_init_defer_op(void);
 struct xfs_rud_log_item *xfs_trans_get_rud(struct xfs_trans *tp,
 		struct xfs_rui_log_item *ruip);
 int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
-		struct xfs_rud_log_item *rudp, enum xfs_rmap_intent_type type,
-		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
-		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
-		xfs_exntst_t state, bool rt, struct xfs_btree_cur **pcur);
+		struct xfs_defer_ops *dfops, struct xfs_rud_log_item *rudp,
+		enum xfs_rmap_intent_type type, __uint64_t owner, int whichfork,
+		xfs_fileoff_t startoff, xfs_fsblock_t startblock,
+		xfs_filblks_t blockcount, xfs_exntst_t state, bool rt,
+		struct xfs_btree_cur **pcur);
 
 /* refcount updates */
 enum xfs_refcount_intent_type;
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
index 9240157b..e80002e 100644
--- a/fs/xfs/xfs_trans_rmap.c
+++ b/fs/xfs/xfs_trans_rmap.c
@@ -97,6 +97,7 @@ xfs_trans_get_rud(
 int
 xfs_trans_log_finish_rmap_update(
 	struct xfs_trans		*tp,
+	struct xfs_defer_ops		*dfops,
 	struct xfs_rud_log_item		*rudp,
 	enum xfs_rmap_intent_type	type,
 	__uint64_t			owner,
@@ -110,8 +111,8 @@ xfs_trans_log_finish_rmap_update(
 {
 	int				error;
 
-	error = xfs_rmap_finish_one(tp, type, owner, whichfork, startoff,
-			startblock, blockcount, state, pcur);
+	error = xfs_rmap_finish_one(tp, dfops, type, owner, whichfork, startoff,
+			startblock, blockcount, state, rt, pcur);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
@@ -220,7 +221,7 @@ xfs_rmap_update_finish_item(
 	int				error;
 
 	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
-	error = xfs_trans_log_finish_rmap_update(tp, done_item,
+	error = xfs_trans_log_finish_rmap_update(tp, dop, done_item,
 			rmap->ri_type,
 			rmap->ri_owner, rmap->ri_whichfork,
 			rmap->ri_bmap.br_startoff,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
