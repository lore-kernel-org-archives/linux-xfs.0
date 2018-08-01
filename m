Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49788 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389387AbeHAPFj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 11:05:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2A5287A7A
        for <linux-xfs@vger.kernel.org>; Wed,  1 Aug 2018 13:19:52 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE9452026D68
        for <linux-xfs@vger.kernel.org>; Wed,  1 Aug 2018 13:19:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 04/15] xfs: pass transaction to dfops reset/move helpers
Date: Wed,  1 Aug 2018 09:19:41 -0400
Message-Id: <20180801131952.60250-5-bfoster@redhat.com>
In-Reply-To: <20180801131952.60250-1-bfoster@redhat.com>
References: <20180801131952.60250-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

All callers pass ->t_dfops of the associated transactions. Refactor
the helpers to receive the transactions and facilitate further
cleanups between xfs_defer_ops and xfs_trans.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c  | 15 ++++++++++-----
 fs/xfs/libxfs/xfs_defer.h  |  2 +-
 fs/xfs/xfs_bmap_item.c     |  6 +++---
 fs/xfs/xfs_log_recover.c   |  2 +-
 fs/xfs/xfs_refcount_item.c |  6 +++---
 fs/xfs/xfs_trans.c         |  2 +-
 6 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index ebead781613f..e3517a53c525 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -324,9 +324,12 @@ xfs_defer_bjoin(
  */
 static void
 xfs_defer_reset(
-	struct xfs_defer_ops	*dop)
+	struct xfs_trans	*tp)
 {
+	struct xfs_defer_ops	*dop = tp->t_dfops;
+
 	ASSERT(!xfs_defer_has_unfinished_work(dop));
+
 	dop->dop_low = false;
 	memset(dop->dop_inodes, 0, sizeof(dop->dop_inodes));
 	memset(dop->dop_bufs, 0, sizeof(dop->dop_bufs));
@@ -457,7 +460,7 @@ xfs_defer_finish(
 		if (error)
 			return error;
 	}
-	xfs_defer_reset((*tp)->t_dfops);
+	xfs_defer_reset(*tp);
 	return 0;
 }
 
@@ -575,9 +578,11 @@ xfs_defer_init(
  */
 void
 xfs_defer_move(
-	struct xfs_defer_ops	*dst,
-	struct xfs_defer_ops	*src)
+	struct xfs_trans	*dtp,
+	struct xfs_trans	*stp)
 {
+	struct xfs_defer_ops	*dst = dtp->t_dfops;
+	struct xfs_defer_ops	*src = stp->t_dfops;
 	ASSERT(dst != src);
 
 	list_splice_init(&src->dop_intake, &dst->dop_intake);
@@ -587,5 +592,5 @@ xfs_defer_move(
 	memcpy(dst->dop_bufs, src->dop_bufs, sizeof(dst->dop_bufs));
 	dst->dop_low = src->dop_low;
 
-	xfs_defer_reset(src);
+	xfs_defer_reset(stp);
 }
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index da145fc04ae1..d60c50498fdf 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -55,7 +55,7 @@ void xfs_defer_init(struct xfs_trans *tp, struct xfs_defer_ops *dop);
 bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
 int xfs_defer_ijoin(struct xfs_defer_ops *dop, struct xfs_inode *ip);
 int xfs_defer_bjoin(struct xfs_defer_ops *dop, struct xfs_buf *bp);
-void xfs_defer_move(struct xfs_defer_ops *dst, struct xfs_defer_ops *src);
+void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
 
 /* Description of a deferred type. */
 struct xfs_defer_op_type {
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 57429055e608..b8a6be036cd7 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -446,7 +446,7 @@ xfs_bui_recover(
 	 * finishes them on completion. Transfer current dfops state to this
 	 * transaction and transfer the result back before we return.
 	 */
-	xfs_defer_move(tp->t_dfops, parent_tp->t_dfops);
+	xfs_defer_move(tp, parent_tp);
 	budp = xfs_trans_get_bud(tp, buip);
 
 	/* Grab the inode. */
@@ -494,7 +494,7 @@ xfs_bui_recover(
 	}
 
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
-	xfs_defer_move(parent_tp->t_dfops, tp->t_dfops);
+	xfs_defer_move(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
@@ -502,7 +502,7 @@ xfs_bui_recover(
 	return error;
 
 err_inode:
-	xfs_defer_move(parent_tp->t_dfops, tp->t_dfops);
+	xfs_defer_move(parent_tp, tp);
 	xfs_trans_cancel(tp);
 	if (ip) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index fc1ce9a644e3..a21dc61ec09e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4853,7 +4853,7 @@ xlog_finish_defer_ops(
 	if (error)
 		return error;
 	/* transfer all collected dfops to this transaction */
-	xfs_defer_move(tp->t_dfops, parent_tp->t_dfops);
+	xfs_defer_move(tp, parent_tp);
 
 	return xfs_trans_commit(tp);
 }
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 011e1d0640fb..4a417daae781 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -457,7 +457,7 @@ xfs_cui_recover(
 	 * finishes them on completion. Transfer current dfops state to this
 	 * transaction and transfer the result back before we return.
 	 */
-	xfs_defer_move(tp->t_dfops, parent_tp->t_dfops);
+	xfs_defer_move(tp, parent_tp);
 	cudp = xfs_trans_get_cud(tp, cuip);
 
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
@@ -522,13 +522,13 @@ xfs_cui_recover(
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
-	xfs_defer_move(parent_tp->t_dfops, tp->t_dfops);
+	xfs_defer_move(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	return error;
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	xfs_defer_move(parent_tp->t_dfops, tp->t_dfops);
+	xfs_defer_move(parent_tp, tp);
 	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 0d07cdcc5c7d..ae3c875a14e5 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -125,7 +125,7 @@ xfs_trans_dup(
 	if (tp->t_dfops != &tp->t_dfops_internal)
 		ntp->t_dfops = tp->t_dfops;
 	else
-		xfs_defer_move(ntp->t_dfops, tp->t_dfops);
+		xfs_defer_move(ntp, tp);
 
 	xfs_trans_dup_dqinfo(tp, ntp);
 
-- 
2.17.1

