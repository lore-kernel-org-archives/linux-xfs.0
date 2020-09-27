Return-Path: <SRS0=IMq7=DE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA671C4346E
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B7A923A33
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:44:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E7cowQCg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgI0XoE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Sep 2020 19:44:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55720 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgI0XoE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Sep 2020 19:44:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNhx29159588;
        Sun, 27 Sep 2020 23:43:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CcPAq/IkClaECU6TjpLOnVYcKCHAOf6RnntKf5uKq30=;
 b=E7cowQCgazIU3jYz+eJIZix4hBlEefT8lUztTBKhyMHz1eRmaRwaz19OhEsCE3O87HKV
 6PzNKoM8IYynb4BOu389UyifQmS8MooueOSmTqTtYQY7c/voXAr8bcge8RA4t5Wc2mhp
 +NZsKw7yOI5WbRzbEWXM0JowgJosxHzBLfAGMxxtrEoYr2mgqph0IB0pjCv2aulAb7b3
 JozE0EM8t4QOFabEv31wvpj2SKC6mzCD0BTkRTWQ/yIrYMKnD8/JP9gWDCE2Jp5jigPL
 sg8/zcfa3ZqMDfJTqs70S4AZUgxSTUgUMHgjp4351Y177/eGFInCwirjcf7Isd3Wv6F1 WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33swkkjh7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 27 Sep 2020 23:43:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNeNXq047724;
        Sun, 27 Sep 2020 23:41:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33tfhvkrh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Sep 2020 23:41:58 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08RNfwrB009998;
        Sun, 27 Sep 2020 23:41:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 27 Sep 2020 16:41:57 -0700
Subject: [PATCH 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de
Date:   Sun, 27 Sep 2020 16:41:56 -0700
Message-ID: <160125011691.174612.13255814016601281607.stgit@magnolia>
In-Reply-To: <160125009588.174612.13196702491335373645.stgit@magnolia>
References: <160125009588.174612.13196702491335373645.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=3 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009270227
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=3 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009270228
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
 fs/xfs/libxfs/xfs_defer.c       |   45 ++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_defer.h       |   22 ++++++++++++++++++-
 fs/xfs/libxfs/xfs_log_recover.h |   11 ++++++++--
 fs/xfs/xfs_bmap_item.c          |    8 ++-----
 fs/xfs/xfs_icache.c             |   41 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c        |   35 +++++++++++++++++++++++++-----
 fs/xfs/xfs_trans.h              |    6 -----
 7 files changed, 146 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index c53443252389..5a9436d83833 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -16,6 +16,7 @@
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 /*
  * Deferred Operations in XFS
@@ -541,6 +542,18 @@ xfs_defer_move(
 	stp->t_flags &= ~XFS_TRANS_LOWMODE;
 }
 
+/* Unlock the inodes attached to this dfops capture device. */
+void
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
@@ -553,13 +566,23 @@ xfs_defer_move(
  * deferred ops state is transferred to the capture structure and the
  * transaction is then ready for the caller to commit it.  If there are no
  * intent items to capture, this function returns NULL.
+ *
+ * If inodes are passed in and this function returns a capture structure, the
+ * inodes are now owned by the capture structure.  If the transaction commit
+ * succeeds, the caller must call xfs_defer_capture_iunlock to unlock the
+ * inodes before moving on to more recovery work.
  */
 struct xfs_defer_capture *
 xfs_defer_capture(
-	struct xfs_trans		*tp)
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip1,
+	struct xfs_inode		*ip2)
 {
 	struct xfs_defer_capture	*dfc;
 
+	/* Do not pass in an ipp2 without an ipp1. */
+	ASSERT(ip1 || !ip2);
+
 	if (list_empty(&tp->t_dfops))
 		return NULL;
 
@@ -582,6 +605,16 @@ xfs_defer_capture(
 	dfc->dfc_tres.tr_logcount = tp->t_log_count;
 	dfc->dfc_tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 
+	/*
+	 * Transfer responsibility for unlocking and releasing the inodes to
+	 * the capture structure.
+	 */
+	dfc->dfc_ilocked = true;
+	if (ip1)
+		dfc->dfc_inodes[0] = ip1;
+	if (ip2 && ip2 != ip1)
+		dfc->dfc_inodes[1] = ip2;
+
 	return dfc;
 }
 
@@ -594,6 +627,13 @@ xfs_defer_continue(
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
@@ -609,5 +649,8 @@ xfs_defer_capture_free(
 	struct xfs_defer_capture	*dfc)
 {
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
+	if (dfc->dfc_ilocked)
+		xfs_defer_capture_iunlock(dfc);
+	xfs_defer_capture_irele(dfc);
 	kmem_free(dfc);
 }
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 063276c063b6..2a4c63573e3d 100644
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
@@ -78,15 +84,29 @@ struct xfs_defer_capture {
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
-struct xfs_defer_capture *xfs_defer_capture(struct xfs_trans *tp);
+struct xfs_defer_capture *xfs_defer_capture(struct xfs_trans *tp,
+		struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_defer_continue(struct xfs_defer_capture *dfc, struct xfs_trans *tp);
+void xfs_defer_capture_iunlock(struct xfs_defer_capture *dfc);
 void xfs_defer_capture_free(struct xfs_mount *mp,
 		struct xfs_defer_capture *dfc);
 
+/* These functions must be provided outside of libxfs. */
+void xfs_defer_continue_inodes(struct xfs_defer_capture *dfc,
+		struct xfs_trans *tp);
+void xfs_defer_capture_irele(struct xfs_defer_capture *dfc);
+
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 8ad44b4195e8..1c87106a3a25 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -124,7 +124,14 @@ bool xlog_is_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id);
-int xlog_recover_trans_commit(struct xfs_trans *tp,
-		struct list_head *capture_list);
+int xlog_recover_trans_commit_inodes(struct xfs_trans *tp,
+		struct list_head *capture_list, struct xfs_inode *ip1,
+		struct xfs_inode *ip2);
+
+static inline int
+xlog_recover_trans_commit(struct xfs_trans *tp, struct list_head *capture_list)
+{
+	return xlog_recover_trans_commit_inodes(tp, capture_list, NULL, NULL);
+}
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index b6d3a5766148..fa52bfd66ce1 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -513,15 +513,11 @@ xfs_bui_item_recover(
 		xfs_bmap_unmap_extent(tp, ip, &irec);
 	}
 
-	/* Commit transaction, which frees tp. */
-	error = xlog_recover_trans_commit(tp, capture_list);
-	if (error)
-		goto err_unlock;
-	return 0;
+	/* Commit transaction, which frees the transaction and the inode. */
+	return xlog_recover_trans_commit_inodes(tp, capture_list, ip, NULL);
 
 err_cancel:
 	xfs_trans_cancel(tp);
-err_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 err_rele:
 	xfs_irele(ip);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index deb99300d171..c7f65e16534f 100644
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
@@ -1689,3 +1690,43 @@ xfs_start_block_reaping(
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
index 0d899ab7df2e..1463c3097240 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1755,23 +1755,43 @@ xlog_recover_release_intent(
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
  * Capture any deferred ops and commit the transaction.  This is the last step
  * needed to finish a log intent item that we recovered from the log, and will
- * take care of releasing all the relevant resources.
+ * take care of releasing all the relevant resources.  If we captured deferred
+ * ops, the inodes are attached to it and must not be touched.  If not, we have
+ * to unlock and free them ourselves.
  */
 int
-xlog_recover_trans_commit(
+xlog_recover_trans_commit_inodes(
 	struct xfs_trans		*tp,
-	struct list_head		*capture_list)
+	struct list_head		*capture_list,
+	struct xfs_inode		*ip1,
+	struct xfs_inode		*ip2)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_defer_capture	*dfc = xfs_defer_capture(tp);
+	struct xfs_defer_capture	*dfc = xfs_defer_capture(tp, ip1, ip2);
 	int				error;
 
 	/* If we don't capture anything, commit tp and exit. */
-	if (!dfc)
-		return xfs_trans_commit(tp);
+	if (!dfc) {
+		error = xfs_trans_commit(tp);
+
+		/* We still own the inodes, so unlock and release them. */
+		if (ip2 && ip2 != ip1)
+			xlog_recover_irele(ip2);
+		if (ip1)
+			xlog_recover_irele(ip1);
+		return error;
+	}
 
 	/*
 	 * Commit the transaction.  If that fails, clean up the defer ops and
@@ -1783,6 +1803,9 @@ xlog_recover_trans_commit(
 		return error;
 	}
 
+	/* Unlock the captured inodes so that we can move on with recovery. */
+	xfs_defer_capture_iunlock(dfc);
+
 	list_add_tail(&dfc->dfc_list, capture_list);
 	return 0;
 }
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index e3875a92a541..2e76e8c16e91 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -112,12 +112,6 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
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

