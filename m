Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47930 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755597AbeDVPGm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Apr 2018 11:06:42 -0400
Subject: [PATCH 07/13] xfs: refactor incore dquot initialization functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 22 Apr 2018 08:06:37 -0700
Message-ID: <152440959784.29601.7345409188558922914.stgit@magnolia>
In-Reply-To: <152440954198.29601.14390250048915099607.stgit@magnolia>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

Create two incore dquot initialization functions that will help us to
disentangle dqget and dqread.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c |   80 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 50 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 62415f1..7154909 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -491,26 +491,14 @@ xfs_qm_dqtobp(
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
+xfs_qm_dqinit_once(
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
 
@@ -549,7 +537,52 @@ xfs_qm_dqread(
 	}
 
 	XFS_STATS_INC(mp, xs_qm_dquot);
+	return dqp;
+}
+
+/* Copy the in-core quota fields in from the on-disk buffer. */
+STATIC void
+xfs_qm_dqinit_from_buf(
+	struct xfs_dquot	*dqp,
+	struct xfs_disk_dquot	*ddqp)
+{
+	/* copy everything from disk dquot to the incore dquot */
+	memcpy(&dqp->q_core, ddqp, sizeof(xfs_disk_dquot_t));
+	xfs_qm_dquot_logitem_init(dqp);
+
+	/*
+	 * Reservation counters are defined as reservation plus current usage
+	 * to avoid having to add every time.
+	 */
+	dqp->q_res_bcount = be64_to_cpu(ddqp->d_bcount);
+	dqp->q_res_icount = be64_to_cpu(ddqp->d_icount);
+	dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
+
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
 
+	dqp = xfs_qm_dqinit_once(mp, id, type);
 	trace_xfs_dqread(dqp);
 
 	if (flags & XFS_QMOPT_DQALLOC) {
@@ -574,20 +607,7 @@ xfs_qm_dqread(
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
+	xfs_qm_dqinit_from_buf(dqp, ddqp);
 
 	/* Mark the buf so that this will stay incore a little longer */
 	xfs_buf_set_ref(bp, XFS_DQUOT_REF);

