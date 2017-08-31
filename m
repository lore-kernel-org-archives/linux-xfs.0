Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36138 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751760AbdHaUe4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 16:34:56 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7VKYtqZ023007
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:34:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKYsop022501
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:34:55 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKYsgd006967
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:34:54 GMT
Subject: [PATCH 14/19] xfs: wire up rmap map and unmap to the realtime rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Aug 2017 13:34:51 -0700
Message-ID: <150421169176.17458.2448529442180019672.stgit@magnolia>
In-Reply-To: <150421160433.17458.10817316901867396010.stgit@magnolia>
References: <150421160433.17458.10817316901867396010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Connect the map and unmap reverse-mapping operations to the realtime
rmapbt via the deferred operation callbacks.  This enables us to
perform rmap operations against the correct btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   64 ++++++++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_rmap.h |    9 ++++--
 fs/xfs/xfs_rmap_item.c   |    8 +++++-
 fs/xfs/xfs_trans.h       |    9 ++++--
 fs/xfs/xfs_trans_rmap.c  |    7 +++--
 5 files changed, 63 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 2ce9bf55..c56a463 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -38,6 +38,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
+#include "xfs_rtrmap_btree.h"
 
 /* By convention, the rtrmapbt's "AG" number is NULLAGNUMBER. */
 static xfs_agnumber_t
@@ -2104,13 +2105,14 @@ xfs_rmap_finish_one_cleanup(
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
 
@@ -2124,6 +2126,7 @@ xfs_rmap_finish_one_cleanup(
 int
 xfs_rmap_finish_one(
 	struct xfs_trans		*tp,
+	struct xfs_defer_ops		*dfops,
 	enum xfs_rmap_intent_type	type,
 	uint64_t			owner,
 	int				whichfork,
@@ -2131,20 +2134,21 @@ xfs_rmap_finish_one(
 	xfs_fsblock_t			startblock,
 	xfs_filblks_t			blockcount,
 	xfs_exntst_t			state,
+	bool				realtime,
 	struct xfs_btree_cur		**pcur)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_btree_cur		*rcur;
 	struct xfs_buf			*agbp = NULL;
+	int				lockmode;
 	int				error = 0;
 	xfs_agnumber_t			agno;
 	struct xfs_owner_info		oinfo;
 	xfs_fsblock_t			bno;
 	bool				unwritten;
 
-	agno = XFS_FSB_TO_AGNO(mp, startblock);
-	ASSERT(agno != NULLAGNUMBER);
-	bno = XFS_FSB_TO_AGBNO(mp, startblock);
+	agno = realtime ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, startblock);
+	bno = realtime ? startblock : XFS_FSB_TO_AGBNO(mp, startblock);
 
 	trace_xfs_rmap_deferred(mp, agno, type, bno, owner, whichfork,
 			startoff, blockcount, state);
@@ -2163,31 +2167,45 @@ xfs_rmap_finish_one(
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
+			lockmode = XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP;
+			xfs_ilock(mp->m_rrmapip, lockmode);
+			xfs_trans_ijoin(tp, mp->m_rrmapip, lockmode);
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
@@ -2196,6 +2214,8 @@ xfs_rmap_finish_one(
 				&oinfo);
 		break;
 	case XFS_RMAP_FREE:
+		ASSERT(!realtime);
+		/* fall through */
 	case XFS_RMAP_UNMAP:
 		error = xfs_rmap_unmap(rcur, bno, blockcount, unwritten,
 				&oinfo);
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 1e58e02..d8d5fbb 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -204,10 +204,11 @@ int xfs_rmap_free_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
 
 void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
 		struct xfs_btree_cur *rcur, int error);
-int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
-		uint64_t owner, int whichfork, xfs_fileoff_t startoff,
-		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
-		xfs_exntst_t state, struct xfs_btree_cur **pcur);
+int xfs_rmap_finish_one(struct xfs_trans *tp, struct xfs_defer_ops *dfops,
+		enum xfs_rmap_intent_type type, uint64_t owner, int whichfork,
+		xfs_fileoff_t startoff, xfs_fsblock_t startblock,
+		xfs_filblks_t blockcount, xfs_exntst_t state, bool realtime,
+		struct xfs_btree_cur **pcur);
 
 int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 13490b5..c453f03 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -429,6 +429,8 @@ xfs_rui_recover(
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
 	bool				rt;
+	struct xfs_defer_ops		dfops;
+	xfs_fsblock_t			firstfsb;
 
 	ASSERT(!test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags));
 
@@ -476,6 +478,7 @@ xfs_rui_recover(
 		return error;
 	rudp = xfs_trans_get_rud(tp, ruip);
 
+	xfs_defer_init(&dfops, &firstfsb);
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
 		rmap = &ruip->rui_format.rui_extents[i];
 		state = (rmap->me_flags & XFS_RMAP_EXTENT_UNWRITTEN) ?
@@ -512,7 +515,7 @@ xfs_rui_recover(
 			error = -EFSCORRUPTED;
 			goto abort_error;
 		}
-		error = xfs_trans_log_finish_rmap_update(tp, rudp, type,
+		error = xfs_trans_log_finish_rmap_update(tp, &dfops, rudp, type,
 				rmap->me_owner, whichfork,
 				rmap->me_startoff, rmap->me_startblock,
 				rmap->me_len, state, rt, &rcur);
@@ -522,6 +525,9 @@ xfs_rui_recover(
 	}
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
+	error = xfs_defer_finish(&tp, &dfops, NULL);
+	if (error)
+		goto abort_error;
 	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
 	error = xfs_trans_commit(tp);
 	return error;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index cef1971..720f595 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -244,10 +244,11 @@ void xfs_rmap_update_init_defer_op(void);
 struct xfs_rud_log_item *xfs_trans_get_rud(struct xfs_trans *tp,
 		struct xfs_rui_log_item *ruip);
 int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
-		struct xfs_rud_log_item *rudp, enum xfs_rmap_intent_type type,
-		uint64_t owner, int whichfork, xfs_fileoff_t startoff,
-		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
-		xfs_exntst_t state, bool rt, struct xfs_btree_cur **pcur);
+		struct xfs_defer_ops *dfops, struct xfs_rud_log_item *rudp,
+		enum xfs_rmap_intent_type type, uint64_t owner, int whichfork,
+		xfs_fileoff_t startoff, xfs_fsblock_t startblock,
+		xfs_filblks_t blockcount, xfs_exntst_t state, bool rt,
+		struct xfs_btree_cur **pcur);
 
 /* refcount updates */
 enum xfs_refcount_intent_type;
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
index aab0d31..746feec 100644
--- a/fs/xfs/xfs_trans_rmap.c
+++ b/fs/xfs/xfs_trans_rmap.c
@@ -97,6 +97,7 @@ xfs_trans_get_rud(
 int
 xfs_trans_log_finish_rmap_update(
 	struct xfs_trans		*tp,
+	struct xfs_defer_ops		*dfops,
 	struct xfs_rud_log_item		*rudp,
 	enum xfs_rmap_intent_type	type,
 	uint64_t			owner,
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

