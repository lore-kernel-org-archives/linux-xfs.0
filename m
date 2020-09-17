Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FF0C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1143420936
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:31:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qBPFZPU7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgIQDbv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 23:31:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51650 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgIQDbu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:31:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3OreD041012;
        Thu, 17 Sep 2020 03:31:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=X4jLA5Q+fU0/AudGVIH5N3Ks2ePAWfeDrhNsFnDpF0Q=;
 b=qBPFZPU74f+cB55z4WSZXg/96EZnUO5STdEjhzrnkZaGCaCgclhOFCrC5ncGyuSzwujM
 fn0trEb3RZyuaaOhu9/fGoRx+Z2XGKbQxHczrJ70MTP5f+wMrKu2ouliyRTUXJjQsq++
 HBpFC1in40HFefxIKBsnm6vwoCGbMbvk6y9z4KHLWsVL8gWDrvH1hir+vS726qAHcMG/
 0gOKGoChHoWomMVOpeEiHEDCdQamRQ/ocezH1+DAxSVv1rCgrvQmuQCNi6TM5x+6S4b1
 r6YXBf1kPfOyX/Jv7MzmDa8KbUuXTer4LDJiSEVzn0LTn1OEkn1YJxWEyAeaRtzuMRGe Ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33gp9megdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 03:31:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3OmNt041471;
        Thu, 17 Sep 2020 03:29:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33h892y5yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 03:29:45 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H3Tixn007145;
        Thu, 17 Sep 2020 03:29:44 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:29:43 +0000
Subject: [PATCH 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 16 Sep 2020 20:29:42 -0700
Message-ID: <160031338272.3624582.1273521883524627790.stgit@magnolia>
In-Reply-To: <160031336397.3624582.9639363323333392474.stgit@magnolia>
References: <160031336397.3624582.9639363323333392474.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=3 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=3 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_bui_item_recover, there exists a use-after-free bug with regards
to the inode that is involved in the bmap replay operation.  If the
mapping operation does not complete, we call xfs_bmap_unmap_extent to
create a deferred op to finish the unmapping work, and we retain a
pointer to the incore inode.

Unfortunately, the very next thing we do is commit the transaction and
drop the inode.  If reclaim tears down the inode before we try to finish
the defer ops, we dereference garbage and blow up.  Therefore, create a
way to join inodes to the defer ops freezer so that we can maintain the
xfs_inode reference until we're done with the inode.

Note: This imposes the requirement that there be enough memory to keep
every incore inode in memory throughout recovery.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c       |   57 +++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h       |   21 ++++++++++++++
 fs/xfs/libxfs/xfs_log_recover.h |   14 ++++++++--
 fs/xfs/xfs_bmap_item.c          |    8 +----
 fs/xfs/xfs_icache.c             |   41 ++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c        |   32 ++++++++++++++++++----
 fs/xfs/xfs_trans.h              |    6 ----
 7 files changed, 156 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index edfb3b9856c8..97523b394932 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -16,6 +16,7 @@
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 /*
  * Deferred Operations in XFS
@@ -555,6 +556,18 @@ xfs_defer_move(
 	xfs_defer_reset(stp);
 }
 
+/* Unlock the inodes attached to this dfops capture device. */
+static void
+xfs_defer_capture_iunlock(
+	struct xfs_defer_capture	*dfc)
+{
+	unsigned int			i;
+
+	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dfc->dfc_inodes[i]; i++)
+		xfs_iunlock(dfc->dfc_inodes[i], XFS_ILOCK_EXCL);
+	dfc->dfc_ilocked = false;
+}
+
 /*
  * Prepare a chain of fresh deferred ops work items to be completed later.  Log
  * recovery requires the ability to put off until later the actual finishing
@@ -568,14 +581,21 @@ xfs_defer_move(
  * transaction is committed.
  *
  * Note that the capture state is passed up to the caller and must be freed
- * even if the transaction commit returns error.
+ * even if the transaction commit returns error.  If inodes were passed in and
+ * a state capture structure was returned, the inodes are now owned by the
+ * state capture structure and the caller must not touch the inodes.
+ *
+ * If no structure is returned, the caller still owns the inodes.
  */
 int
 xfs_defer_capture(
 	struct xfs_trans		*tp,
-	struct xfs_defer_capture	**dfcp)
+	struct xfs_defer_capture	**dfcp,
+	struct xfs_inode		*ip1,
+	struct xfs_inode		*ip2)
 {
 	struct xfs_defer_capture	*dfc = NULL;
+	int				error;
 
 	if (!list_empty(&tp->t_dfops)) {
 		dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
@@ -594,10 +614,31 @@ xfs_defer_capture(
 		dfc->dfc_tres.tr_logcount = tp->t_log_count;
 		dfc->dfc_tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 		xfs_defer_reset(tp);
+
+		/*
+		 * Transfer responsibility for unlocking and releasing the
+		 * inodes to the capture structure.
+		 */
+		if (!ip1)
+			ip1 = ip2;
+		dfc->dfc_ilocked = true;
+		dfc->dfc_inodes[0] = ip1;
+		if (ip2 != ip1)
+			dfc->dfc_inodes[1] = ip2;
 	}
 
 	*dfcp = dfc;
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	if (error)
+		return error;
+
+	/*
+	 * Now that we've committed the transaction, it's safe to unlock the
+	 * inodes that were passed in if we've taken over their ownership.
+	 */
+	if (dfc)
+		xfs_defer_capture_iunlock(dfc);
+	return 0;
 }
 
 /* Attach a chain of captured deferred ops to a new transaction. */
@@ -609,6 +650,13 @@ xfs_defer_continue(
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
+	/* Lock and join the inodes to the new transaction. */
+	xfs_defer_continue_inodes(dfc, tp);
+	if (dfc->dfc_inodes[0])
+		xfs_trans_ijoin(tp, dfc->dfc_inodes[0], 0);
+	if (dfc->dfc_inodes[1])
+		xfs_trans_ijoin(tp, dfc->dfc_inodes[1], 0);
+
 	/* Move captured dfops chain and state to the transaction. */
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
 	tp->t_flags |= dfc->dfc_tpflags;
@@ -624,5 +672,8 @@ xfs_defer_capture_free(
 	struct xfs_defer_capture	*dfc)
 {
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
+	if (dfc->dfc_ilocked)
+		xfs_defer_capture_iunlock(dfc);
+	xfs_defer_capture_irele(dfc);
 	kmem_free(dfc);
 }
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index a788855aef69..4663a9026545 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -10,6 +10,12 @@ struct xfs_btree_cur;
 struct xfs_defer_op_type;
 struct xfs_defer_capture;
 
+/*
+ * Deferred operation item relogging limits.
+ */
+#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+#define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
+
 /*
  * Header for deferred operation list.
  */
@@ -78,15 +84,28 @@ struct xfs_defer_capture {
 	unsigned int		dfc_tpflags;
 	unsigned int		dfc_blkres;
 	struct xfs_trans_res	dfc_tres;
+
+	/*
+	 * Inodes to hold when we want to finish the deferred work items.
+	 * Always set the first element before setting the second.
+	 */
+	bool			dfc_ilocked;
+	struct xfs_inode	*dfc_inodes[XFS_DEFER_OPS_NR_INODES];
 };
 
 /*
  * Functions to capture a chain of deferred operations and continue them later.
  * This doesn't normally happen except log recovery.
  */
-int xfs_defer_capture(struct xfs_trans *tp, struct xfs_defer_capture **dfcp);
+int xfs_defer_capture(struct xfs_trans *tp, struct xfs_defer_capture **dfcp,
+		struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_defer_continue(struct xfs_defer_capture *dfc, struct xfs_trans *tp);
 void xfs_defer_capture_free(struct xfs_mount *mp,
 		struct xfs_defer_capture *dfc);
 
+/* These functions must be provided by the xfs implementation. */
+void xfs_defer_continue_inodes(struct xfs_defer_capture *dfc,
+		struct xfs_trans *tp);
+void xfs_defer_capture_irele(struct xfs_defer_capture *dfc);
+
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index c3563c5c033c..e8aba7c6e851 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -127,7 +127,17 @@ void xlog_recover_iodone(struct xfs_buf *bp);
 
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id);
-int xlog_recover_trans_commit(struct xfs_trans *tp,
-		struct xfs_defer_capture **dfcp);
+int xlog_recover_trans_commit_inodes(struct xfs_trans *tp,
+		struct xfs_defer_capture **dfcp, struct xfs_inode *ip1,
+		struct xfs_inode *ip2);
+
+static inline int
+xlog_recover_trans_commit(
+	struct xfs_trans		*tp,
+	struct xfs_defer_capture	**dfcp)
+{
+	return xlog_recover_trans_commit_inodes(tp, dfcp, NULL, NULL);
+}
+
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 6f589f04f358..8461285a9dd9 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -513,15 +513,11 @@ xfs_bui_item_recover(
 		xfs_bmap_unmap_extent(tp, ip, &irec);
 	}
 
-	/* Commit transaction, which frees tp. */
-	error = xlog_recover_trans_commit(tp, dfcp);
-	if (error)
-		goto err_unlock;
-	return 0;
+	/* Commit transaction, which frees the transaction and the inode. */
+	return xlog_recover_trans_commit_inodes(tp, dfcp, ip, NULL);
 
 err_cancel:
 	xfs_trans_cancel(tp);
-err_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 err_rele:
 	xfs_irele(ip);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 101028ebb571..5b1202cac4ea 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -12,6 +12,7 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_defer.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
@@ -1692,3 +1693,43 @@ xfs_start_block_reaping(
 	xfs_queue_eofblocks(mp);
 	xfs_queue_cowblocks(mp);
 }
+
+/*
+ * Prepare the inodes to participate in further log intent item recovery.
+ * For now, that means attaching dquots and locking them, since libxfs doesn't
+ * know how to do that.
+ */
+void
+xfs_defer_continue_inodes(
+	struct xfs_defer_capture	*dfc,
+	struct xfs_trans		*tp)
+{
+	int				i;
+	int				error;
+
+	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dfc->dfc_inodes[i]; i++) {
+		error = xfs_qm_dqattach(dfc->dfc_inodes[i]);
+		if (error)
+			tp->t_mountp->m_qflags &= ~XFS_ALL_QUOTA_CHKD;
+	}
+
+	if (dfc->dfc_inodes[1])
+		xfs_lock_two_inodes(dfc->dfc_inodes[0], XFS_ILOCK_EXCL,
+				    dfc->dfc_inodes[1], XFS_ILOCK_EXCL);
+	else if (dfc->dfc_inodes[0])
+		xfs_ilock(dfc->dfc_inodes[0], XFS_ILOCK_EXCL);
+	dfc->dfc_ilocked = true;
+}
+
+/* Release all the inodes attached to this dfops capture device. */
+void
+xfs_defer_capture_irele(
+	struct xfs_defer_capture	*dfc)
+{
+	unsigned int			i;
+
+	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dfc->dfc_inodes[i]; i++) {
+		xfs_irele(dfc->dfc_inodes[i]);
+		dfc->dfc_inodes[i] = NULL;
+	}
+}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index f5748c8f5157..9ac2726d42b4 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1791,16 +1791,38 @@ xlog_recover_release_intent(
 	spin_unlock(&ailp->ail_lock);
 }
 
+static inline void
+xlog_recover_irele(
+	struct xfs_inode	*ip)
+{
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_irele(ip);
+}
+
 /*
- * Freeze any deferred ops and commit the transaction.  This is the last step
- * needed to finish a log intent item that we recovered from the log.
+ * Freeze any deferred ops, commit the transaction, and deal with the inodes.
+ * This is the last step needed to finish a log intent item that we recovered
+ * from the log.  If we captured deferred ops, the inodes are attached to it
+ * and must not be touched.  If not, we have to unlock and free them ourselves.
  */
 int
-xlog_recover_trans_commit(
+xlog_recover_trans_commit_inodes(
 	struct xfs_trans		*tp,
-	struct xfs_defer_capture	**dfcp)
+	struct xfs_defer_capture	**dfcp,
+	struct xfs_inode		*ip1,
+	struct xfs_inode		*ip2)
 {
-	return xfs_defer_capture(tp, dfcp);
+	int				error;
+
+	error = xfs_defer_capture(tp, dfcp, ip1, ip2);
+	if (*dfcp)
+		return error;
+
+	if (ip2 && ip2 != ip1)
+		xlog_recover_irele(ip2);
+	if (ip1)
+		xlog_recover_irele(ip1);
+	return error;
 }
 
 /******************************************************************************
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index c88240961aa1..995c1513693c 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -97,12 +97,6 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
 #define XFS_ITEM_LOCKED		2
 #define XFS_ITEM_FLUSHING	3
 
-/*
- * Deferred operation item relogging limits.
- */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
-#define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
-
 /*
  * This is the structure maintained for every active transaction.
  */

