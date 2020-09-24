Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCEF2C4346E
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 06:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4406723600
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 06:06:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RrNQnnay"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgIXGGO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 02:06:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33200 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgIXGGO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 02:06:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08O65ADd067389;
        Thu, 24 Sep 2020 06:06:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=a+1YJFQGW9SFgSkyW4IsRs5ozuRHdz/1lJOL6J06Fjo=;
 b=RrNQnnayx4P8xjK/3uh3+MYFPOgQT9rnmO/m0KL+rc3T7PDel2GF0D26FrxnCI7agy68
 01KD1ME2XIsnZ+h4HZtX1vDu6Boe2wqiX5Z5rfkWasskIqZHLnQX54pAu4Cb4DQvkihG
 TieoSkg5YsgVf3TSUZzJyCczURzC4GBhZ4Oq+72fd/ptzsLePygXYpU+2ZKxKsIIRI0T
 cWHdzZ7Gwip5d/o/pwrkZesnt42+DZ1ld2I+pnvmd8ubVelJ9ndhNQE0Kvn7dNxtd9+r
 XwTN+USXA0Mi1W66mpBn48h95Okv4ATseFnnNucx7jUEzNt4kz9cY3/7qwlZB+4V043V hA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33ndnup701-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 06:06:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08O669L1147732;
        Thu, 24 Sep 2020 06:06:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33r28wjhhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Sep 2020 06:06:08 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08O66205032690;
        Thu, 24 Sep 2020 06:06:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 23:06:01 -0700
Date:   Wed, 23 Sep 2020 23:06:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
Message-ID: <20200924060601.GD7955@magnolia>
References: <160031336397.3624582.9639363323333392474.stgit@magnolia>
 <160031338272.3624582.1273521883524627790.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031338272.3624582.1273521883524627790.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=5 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=5 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009240049
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
v2: rebase on v2 of the previous patchset, and make it more clear that
xfs_defer_capture takes over ownership of the inodes
---
 fs/xfs/libxfs/xfs_defer.c       |   57 ++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_defer.h       |   21 ++++++++++++++
 fs/xfs/libxfs/xfs_log_recover.h |   11 ++++++--
 fs/xfs/xfs_bmap_item.c          |    8 +----
 fs/xfs/xfs_icache.c             |   41 ++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c        |   33 ++++++++++++++++++++---
 fs/xfs/xfs_trans.h              |    6 ----
 7 files changed, 156 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index b693d2c42c27..a99252271b24 100644
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
@@ -568,17 +581,26 @@ xfs_defer_move(
  * transaction is committed.
  *
  * Note that the capture state is passed up to the caller and must be freed
- * even if the transaction commit returns error.
+ * even if the transaction commit returns error.  If inodes were passed in and
+ * a state capture structure was returned, the inodes are now owned by the
+ * state capture structure and the caller must not touch the inodes.
+ *
+ * If *ipp1 or *ipp2 remain set, the caller still owns the inodes.
  */
 int
 xfs_defer_capture(
 	struct xfs_trans		*tp,
-	struct list_head		*capture_list)
+	struct list_head		*capture_list,
+	struct xfs_inode		**ipp1,
+	struct xfs_inode		**ipp2)
 {
 	struct xfs_defer_capture	*dfc;
 	struct xfs_mount		*mp = tp->t_mountp;
 	int				error;
 
+	/* Do not pass in an ipp2 without an ipp1. */
+	ASSERT(ipp1 || !ipp2);
+
 	if (list_empty(&tp->t_dfops))
 		return xfs_trans_commit(tp);
 
@@ -600,6 +622,21 @@ xfs_defer_capture(
 	dfc->dfc_tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 	xfs_defer_reset(tp);
 
+	/*
+	 * Transfer responsibility for unlocking and releasing the inodes to
+	 * the capture structure.
+	 */
+	dfc->dfc_ilocked = true;
+	if (ipp1) {
+		dfc->dfc_inodes[0] = *ipp1;
+		*ipp1 = NULL;
+	}
+	if (ipp2) {
+		if (*ipp2 != dfc->dfc_inodes[0])
+			dfc->dfc_inodes[1] = *ipp2;
+		*ipp2 = NULL;
+	}
+
 	/*
 	 * Commit the transaction.  If that fails, clean up the defer ops and
 	 * the dfc that we just created.  Otherwise, add the dfc to the list.
@@ -610,6 +647,12 @@ xfs_defer_capture(
 		return error;
 	}
 
+	/*
+	 * Now that we've committed the transaction, it's safe to unlock the
+	 * inodes that were passed in if we've taken over their ownership.
+	 */
+	xfs_defer_capture_iunlock(dfc);
+
 	list_add_tail(&dfc->dfc_list, capture_list);
 	return 0;
 }
@@ -623,6 +666,13 @@ xfs_defer_continue(
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
@@ -638,5 +688,8 @@ xfs_defer_capture_free(
 	struct xfs_defer_capture	*dfc)
 {
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
+	if (dfc->dfc_ilocked)
+		xfs_defer_capture_iunlock(dfc);
+	xfs_defer_capture_irele(dfc);
 	kmem_free(dfc);
 }
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 254d48e6e4dc..c52c57d35af6 100644
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
-int xfs_defer_capture(struct xfs_trans *tp, struct list_head *capture_list);
+int xfs_defer_capture(struct xfs_trans *tp, struct list_head *capture_list,
+		struct xfs_inode **ipp1, struct xfs_inode **ipp2);
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
index 4f752096f7c7..8cf5e23c0aef 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -125,7 +125,14 @@ void xlog_recover_iodone(struct xfs_buf *bp);
 
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
index ab9825ab14d5..37ba7a105b59 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1791,17 +1791,42 @@ xlog_recover_release_intent(
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
  * Freeze any deferred ops and commit the transaction.  This is the last step
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
-	return xfs_defer_capture(tp, capture_list);
+	int				error;
+
+	error = xfs_defer_capture(tp, capture_list, &ip1, &ip2);
+
+	/*
+	 * If we still have references to the inodes, either the capture
+	 * process did nothing or it failed; either way, we still own the
+	 * inodes, so unlock and release them.
+	 */
+	if (ip2 && ip2 != ip1)
+		xlog_recover_irele(ip2);
+	if (ip1)
+		xlog_recover_irele(ip1);
+	return error;
 }
 
 /******************************************************************************
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index b68272666ce1..e27df685d3cd 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -96,12 +96,6 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
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
