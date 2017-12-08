Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38700 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752387AbdLHDoG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 22:44:06 -0500
Subject: [PATCH 1/5] xfs: add the ability to join a held buffer to a
 defer_ops
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 07 Dec 2017 19:39:09 -0800
Message-ID: <151270434945.12194.16466347732765177795.stgit@magnolia>
In-Reply-To: <151270433736.12194.14709247629624139846.stgit@magnolia>
References: <151270433736.12194.14709247629624139846.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, libor.klepac@bcom.cz, bfoster@redhat.com, alex@zadarastorage.com, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

In certain cases, defer_ops callers will lock a buffer and want to hold
the lock across transaction rolls.  Similar to ijoined inodes, we want
to dirty & join the buffer with each transaction roll in defer_finish so
that afterwards the caller still owns the buffer lock and we haven't
inadvertently pinned the log.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c |   39 ++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_defer.h |    5 ++++-
 2 files changed, 40 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 072ebfe..087fea0 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -249,6 +249,10 @@ xfs_defer_trans_roll(
 	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dop->dop_inodes[i]; i++)
 		xfs_trans_log_inode(*tp, dop->dop_inodes[i], XFS_ILOG_CORE);
 
+	/* Hold the (previously bjoin'd) buffer locked across the roll. */
+	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS && dop->dop_bufs[i]; i++)
+		xfs_trans_dirty_buf(*tp, dop->dop_bufs[i]);
+
 	trace_xfs_defer_trans_roll((*tp)->t_mountp, dop);
 
 	/* Roll the transaction. */
@@ -264,6 +268,12 @@ xfs_defer_trans_roll(
 	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dop->dop_inodes[i]; i++)
 		xfs_trans_ijoin(*tp, dop->dop_inodes[i], 0);
 
+	/* Rejoin the buffers and dirty them so the log moves forward. */
+	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS && dop->dop_bufs[i]; i++) {
+		xfs_trans_bjoin(*tp, dop->dop_bufs[i]);
+		xfs_trans_bhold(*tp, dop->dop_bufs[i]);
+	}
+
 	return error;
 }
 
@@ -295,6 +305,31 @@ xfs_defer_ijoin(
 		}
 	}
 
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
+/*
+ * Add this buffer to the deferred op.  Each joined buffer is relogged
+ * each time we roll the transaction.
+ */
+int
+xfs_defer_bjoin(
+	struct xfs_defer_ops		*dop,
+	struct xfs_buf			*bp)
+{
+	int				i;
+
+	for (i = 0; i < XFS_DEFER_OPS_NR_BUFS; i++) {
+		if (dop->dop_bufs[i] == bp)
+			return 0;
+		else if (dop->dop_bufs[i] == NULL) {
+			dop->dop_bufs[i] = bp;
+			return 0;
+		}
+	}
+
+	ASSERT(0);
 	return -EFSCORRUPTED;
 }
 
@@ -493,9 +528,7 @@ xfs_defer_init(
 	struct xfs_defer_ops		*dop,
 	xfs_fsblock_t			*fbp)
 {
-	dop->dop_committed = false;
-	dop->dop_low = false;
-	memset(&dop->dop_inodes, 0, sizeof(dop->dop_inodes));
+	memset(dop, 0, sizeof(struct xfs_defer_ops));
 	*fbp = NULLFSBLOCK;
 	INIT_LIST_HEAD(&dop->dop_intake);
 	INIT_LIST_HEAD(&dop->dop_pending);
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index d4f046d..045beac 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -59,6 +59,7 @@ enum xfs_defer_ops_type {
 };
 
 #define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+#define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 struct xfs_defer_ops {
 	bool			dop_committed;	/* did any trans commit? */
@@ -66,8 +67,9 @@ struct xfs_defer_ops {
 	struct list_head	dop_intake;	/* unlogged pending work */
 	struct list_head	dop_pending;	/* logged pending work */
 
-	/* relog these inodes with each roll */
+	/* relog these with each roll */
 	struct xfs_inode	*dop_inodes[XFS_DEFER_OPS_NR_INODES];
+	struct xfs_buf		*dop_bufs[XFS_DEFER_OPS_NR_BUFS];
 };
 
 void xfs_defer_add(struct xfs_defer_ops *dop, enum xfs_defer_ops_type type,
@@ -77,6 +79,7 @@ void xfs_defer_cancel(struct xfs_defer_ops *dop);
 void xfs_defer_init(struct xfs_defer_ops *dop, xfs_fsblock_t *fbp);
 bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
 int xfs_defer_ijoin(struct xfs_defer_ops *dop, struct xfs_inode *ip);
+int xfs_defer_bjoin(struct xfs_defer_ops *dop, struct xfs_buf *bp);
 
 /* Description of a deferred type. */
 struct xfs_defer_op_type {

