Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41274 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbfAACZu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:25:50 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012PD8x179530
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:49 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2pp1jqx480-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:25:49 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012PmFp002209
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:48 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012Pm5S030185
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:48 GMT
Subject: [PATCH 13/20] xfs: wire up rmap map and unmap to the realtime rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:25:47 -0800
Message-ID: <154630954732.8108.5050462517254118598.stgit@magnolia>
In-Reply-To: <154630945466.8108.16578904812191021263.stgit@magnolia>
References: <154630945466.8108.16578904812191021263.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_rmap.c |   62 ++++++++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_rmap.h |    2 +
 fs/xfs/xfs_log_recover.c |    6 ++--
 fs/xfs/xfs_rmap_item.c   |   11 +++++++-
 fs/xfs/xfs_rmap_item.h   |    2 +
 fs/xfs/xfs_trans_rmap.c  |    2 +
 6 files changed, 56 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 0031799ac45f..664a2532aa7c 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -28,6 +28,7 @@
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
+#include "xfs_rtrmap_btree.h"
 
 /* By convention, the rtrmapbt's "AG" number is NULLAGNUMBER. */
 static xfs_agnumber_t
@@ -2190,13 +2191,14 @@ xfs_rmap_finish_one_cleanup(
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
 	xfs_btree_del_cursor(rcur, error);
-	if (error)
+	if (error && agbp)
 		xfs_trans_brelse(tp, agbp);
 }
 
@@ -2217,20 +2219,21 @@ xfs_rmap_finish_one(
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
@@ -2249,31 +2252,44 @@ xfs_rmap_finish_one(
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
@@ -2282,6 +2298,8 @@ xfs_rmap_finish_one(
 				&oinfo);
 		break;
 	case XFS_RMAP_FREE:
+		ASSERT(!realtime);
+		/* fall through */
 	case XFS_RMAP_UNMAP:
 		error = xfs_rmap_unmap(rcur, bno, blockcount, unwritten,
 				&oinfo);
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 92be7585b4c8..3f9f3d311899 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -179,7 +179,7 @@ void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
 int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
 		uint64_t owner, int whichfork, xfs_fileoff_t startoff,
 		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
-		xfs_exntst_t state, struct xfs_btree_cur **pcur);
+		xfs_exntst_t state, bool realtime, struct xfs_btree_cur **pcur);
 
 int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index be969bbca522..561184fbd5a0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4687,7 +4687,7 @@ xlog_recover_cancel_efi(
 /* Recover the RUI if necessary. */
 STATIC int
 xlog_recover_process_rui(
-	struct xfs_mount		*mp,
+	struct xfs_trans		*parent_tp,
 	struct xfs_ail			*ailp,
 	struct xfs_log_item		*lip)
 {
@@ -4702,7 +4702,7 @@ xlog_recover_process_rui(
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
-	error = xfs_rui_recover(mp, ruip);
+	error = xfs_rui_recover(parent_tp, ruip);
 	spin_lock(&ailp->ail_lock);
 
 	return error;
@@ -4931,7 +4931,7 @@ xlog_recover_process_intents(
 			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
 			break;
 		case XFS_LI_RUI:
-			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
+			error = xlog_recover_process_rui(parent_tp, ailp, lip);
 			break;
 		case XFS_LI_CUI:
 			error = xlog_recover_process_cui(parent_tp, ailp, lip);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 2fe98a300d0e..bc4d1e7ae602 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -401,7 +401,7 @@ xfs_rud_init(
  */
 int
 xfs_rui_recover(
-	struct xfs_mount		*mp,
+	struct xfs_trans		*parent_tp,
 	struct xfs_rui_log_item		*ruip)
 {
 	int				i;
@@ -415,6 +415,7 @@ xfs_rui_recover(
 	xfs_exntst_t			state;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
+	struct xfs_mount		*mp = parent_tp->t_mountp;
 	bool				rt;
 
 	ASSERT(!test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags));
@@ -462,6 +463,12 @@ xfs_rui_recover(
 			mp->m_rmap_maxlevels, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
+	/*
+	 * Recovery stashes all deferred ops during intent processing and
+	 * finishes them on completion. Transfer current dfops state to this
+	 * transaction and transfer the result back before we return.
+	 */
+	xfs_defer_move(tp, parent_tp);
 	rudp = xfs_trans_get_rud(tp, ruip);
 
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
@@ -511,10 +518,12 @@ xfs_rui_recover(
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
+	xfs_defer_move(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	return error;
 
 abort_error:
+	xfs_defer_move(parent_tp, tp);
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
 	xfs_trans_cancel(tp);
 	return error;
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 7e482baa27f5..6e61d13f3c3c 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -84,6 +84,6 @@ int xfs_rui_copy_format(struct xfs_log_iovec *buf,
 		struct xfs_rui_log_format *dst_rui_fmt);
 void xfs_rui_item_free(struct xfs_rui_log_item *);
 void xfs_rui_release(struct xfs_rui_log_item *);
-int xfs_rui_recover(struct xfs_mount *mp, struct xfs_rui_log_item *ruip);
+int xfs_rui_recover(struct xfs_trans *parent_tp, struct xfs_rui_log_item *ruip);
 
 #endif	/* __XFS_RMAP_ITEM_H__ */
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
index da135e959eb9..94d6adc98eb2 100644
--- a/fs/xfs/xfs_trans_rmap.c
+++ b/fs/xfs/xfs_trans_rmap.c
@@ -98,7 +98,7 @@ xfs_trans_log_finish_rmap_update(
 	int				error;
 
 	error = xfs_rmap_finish_one(tp, type, owner, whichfork, startoff,
-			startblock, blockcount, state, pcur);
+			startblock, blockcount, state, rt, pcur);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
