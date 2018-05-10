Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41396 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965410AbeEJPaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 11:30:09 -0400
Subject: [PATCH 09/14] xfs: refactor incore dquot initialization functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 10 May 2018 08:29:48 -0700
Message-ID: <152596618807.27525.8539203811739734483.stgit@magnolia>
In-Reply-To: <152596612549.27525.9876256551560849585.stgit@magnolia>
References: <152596612549.27525.9876256551560849585.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

Create two incore dquot initialization functions that will help us to
disentangle dqget and dqread.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c |   81 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 51 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 376923fd2174..434137eb07a4 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -499,26 +499,14 @@ xfs_qm_dqtobp(
 	return 0;
 }
 
-
-/*
- * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
- * and release the buffer immediately.
- *
- * If XFS_QMOPT_DQALLOC is set, allocate a dquot on disk if it needed.
- */
-int
-xfs_qm_dqread(
+/* Allocate and initialize everything we need for an incore dquot. */
+STATIC struct xfs_dquot *
+xfs_dquot_alloc(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
-	uint			type,
-	uint			flags,
-	struct xfs_dquot	**O_dqpp)
+	uint			type)
 {
 	struct xfs_dquot	*dqp;
-	struct xfs_disk_dquot	*ddqp;
-	struct xfs_buf		*bp;
-	struct xfs_trans	*tp = NULL;
-	int			error;
 
 	dqp = kmem_zone_zalloc(xfs_qm_dqzone, KM_SLEEP);
 
@@ -556,8 +544,54 @@ xfs_qm_dqread(
 		break;
 	}
 
+	xfs_qm_dquot_logitem_init(dqp);
+
 	XFS_STATS_INC(mp, xs_qm_dquot);
+	return dqp;
+}
+
+/* Copy the in-core quota fields in from the on-disk buffer. */
+STATIC void
+xfs_dquot_from_disk(
+	struct xfs_dquot	*dqp,
+	struct xfs_disk_dquot	*ddqp)
+{
+	/* copy everything from disk dquot to the incore dquot */
+	memcpy(&dqp->q_core, ddqp, sizeof(xfs_disk_dquot_t));
+
+	/*
+	 * Reservation counters are defined as reservation plus current usage
+	 * to avoid having to add every time.
+	 */
+	dqp->q_res_bcount = be64_to_cpu(ddqp->d_bcount);
+	dqp->q_res_icount = be64_to_cpu(ddqp->d_icount);
+	dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
 
+	/* initialize the dquot speculative prealloc thresholds */
+	xfs_dquot_set_prealloc_limits(dqp);
+}
+
+/*
+ * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
+ * and release the buffer immediately.
+ *
+ * If XFS_QMOPT_DQALLOC is set, allocate a dquot on disk if it needed.
+ */
+int
+xfs_qm_dqread(
+	struct xfs_mount	*mp,
+	xfs_dqid_t		id,
+	uint			type,
+	uint			flags,
+	struct xfs_dquot	**O_dqpp)
+{
+	struct xfs_dquot	*dqp;
+	struct xfs_disk_dquot	*ddqp;
+	struct xfs_buf		*bp;
+	struct xfs_trans	*tp = NULL;
+	int			error;
+
+	dqp = xfs_dquot_alloc(mp, id, type);
 	trace_xfs_dqread(dqp);
 
 	if (flags & XFS_QMOPT_DQALLOC) {
@@ -582,20 +616,7 @@ xfs_qm_dqread(
 		goto error1;
 	}
 
-	/* copy everything from disk dquot to the incore dquot */
-	memcpy(&dqp->q_core, ddqp, sizeof(xfs_disk_dquot_t));
-	xfs_qm_dquot_logitem_init(dqp);
-
-	/*
-	 * Reservation counters are defined as reservation plus current usage
-	 * to avoid having to add every time.
-	 */
-	dqp->q_res_bcount = be64_to_cpu(ddqp->d_bcount);
-	dqp->q_res_icount = be64_to_cpu(ddqp->d_icount);
-	dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
-
-	/* initialize the dquot speculative prealloc thresholds */
-	xfs_dquot_set_prealloc_limits(dqp);
+	xfs_dquot_from_disk(dqp, ddqp);
 
 	/* Mark the buf so that this will stay incore a little longer */
 	xfs_buf_set_ref(bp, XFS_DQUOT_REF);

