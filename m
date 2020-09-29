Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58176C4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F13EE20C09
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:44:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="inYOirPf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbgI2RoO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:44:14 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55240 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729909AbgI2RoN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 13:44:13 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THdwOC060962;
        Tue, 29 Sep 2020 17:44:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=o1PS46rSrhHYEK2QVll4+dguVd7newe8cRyNaEPujKo=;
 b=inYOirPfmph77qq62PRnu6JOKhqjAcrrSkZqquhwo83HNjKXlSsbyemcEtbQ9Gllwu24
 afks0yDb5Q0F6EPu+BQTxMWlmBbz9TgL/tExJizWZvyuhaqAZGLSMnBn+WTKyqlB6xBP
 dUhNc7+5NuUYmkwZS1uriwa8IYZ8JHDoeL6sSqmcb50wLo1PxEzWbDuszHILpgwLGiKr
 iI7/c9o/YnjKmhDikIH5JYFWkBJ3AIguTFKlj/P2wE85siUp1Oc1rbmxLiLp1c36VWZ5
 Dh6piKwxP0CfSurk8udDvdAR2M/mhi7ithi4ojwgPNP9RBbbkzDsqNCB3Zj2s27BPD4+ QA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33su5avcd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 17:44:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THeR05167305;
        Tue, 29 Sep 2020 17:44:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33tfhxyxau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 17:44:09 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08THi8vS017901;
        Tue, 29 Sep 2020 17:44:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 10:44:07 -0700
Subject: [PATCH 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de
Date:   Tue, 29 Sep 2020 10:44:06 -0700
Message-ID: <160140144660.830434.10498291551366134327.stgit@magnolia>
In-Reply-To: <160140142711.830434.5161910313856677767.stgit@magnolia>
References: <160140142711.830434.5161910313856677767.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=3 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=3
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
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
 fs/xfs/libxfs/xfs_defer.c  |   55 ++++++++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_defer.h  |   11 +++++++--
 fs/xfs/xfs_bmap_item.c     |    8 ++----
 fs/xfs/xfs_extfree_item.c  |    2 +-
 fs/xfs/xfs_log_recover.c   |    7 +++++-
 fs/xfs/xfs_refcount_item.c |    2 +-
 fs/xfs/xfs_rmap_item.c     |    2 +-
 7 files changed, 67 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 4caaf5527403..c466a3177acc 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -16,6 +16,7 @@
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 /*
  * Deferred Operations in XFS
@@ -553,10 +554,14 @@ xfs_defer_move(
  * deferred ops state is transferred to the capture structure and the
  * transaction is then ready for the caller to commit it.  If there are no
  * intent items to capture, this function returns NULL.
+ *
+ * If inodes are passed in and this function returns a capture structure, the
+ * inodes are now owned by the capture structure.
  */
 static struct xfs_defer_capture *
 xfs_defer_ops_capture(
-	struct xfs_trans		*tp)
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip)
 {
 	struct xfs_defer_capture	*dfc;
 
@@ -588,6 +593,12 @@ xfs_defer_ops_capture(
 	dfc->dfc_tres.tr_logcount = 1;
 	dfc->dfc_tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 
+	/*
+	 * Transfer responsibility for unlocking and releasing the inodes to
+	 * the capture structure.
+	 */
+	dfc->dfc_ip = ip;
+
 	return dfc;
 }
 
@@ -598,29 +609,49 @@ xfs_defer_ops_release(
 	struct xfs_defer_capture	*dfc)
 {
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
+	if (dfc->dfc_ip)
+		xfs_irele(dfc->dfc_ip);
 	kmem_free(dfc);
 }
 
 /*
  * Capture any deferred ops and commit the transaction.  This is the last step
- * needed to finish a log intent item that we recovered from the log.
+ * needed to finish a log intent item that we recovered from the log.  If any
+ * of the deferred ops operate on an inode, the caller must pass in that inode
+ * so that the reference can be transferred to the capture structure.  The
+ * caller must hold ILOCK_EXCL on the inode, and must not touch the inode after
+ * this call returns.
  */
 int
 xfs_defer_ops_capture_and_commit(
 	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
 	struct list_head		*capture_list)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_defer_capture	*dfc;
 	int				error;
 
+	ASSERT(ip == NULL || xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
 	/* If we don't capture anything, commit transaction and exit. */
-	dfc = xfs_defer_ops_capture(tp);
-	if (!dfc)
-		return xfs_trans_commit(tp);
+	dfc = xfs_defer_ops_capture(tp, ip);
+	if (!dfc) {
+		error = xfs_trans_commit(tp);
+		if (ip) {
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			xfs_irele(ip);
+		}
+		return error;
+	}
 
-	/* Commit the transaction and add the capture structure to the list. */
+	/*
+	 * Commit the transaction and add the capture structure to the list.
+	 * Once that's done, we can unlock the inode.
+	 */
 	error = xfs_trans_commit(tp);
+	if (ip)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	if (error) {
 		xfs_defer_ops_release(mp, dfc);
 		return error;
@@ -632,16 +663,24 @@ xfs_defer_ops_capture_and_commit(
 
 /*
  * Attach a chain of captured deferred ops to a new transaction and free the
- * capture structure.
+ * capture structure.  A captured inode will be passed back to the caller.
  */
 void
 xfs_defer_ops_continue(
 	struct xfs_defer_capture	*dfc,
-	struct xfs_trans		*tp)
+	struct xfs_trans		*tp,
+	struct xfs_inode		**ipp)
 {
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
+	/* Lock and join the captured inode to the new transaction. */
+	if (dfc->dfc_ip) {
+		xfs_ilock(dfc->dfc_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, dfc->dfc_ip, 0);
+	}
+	*ipp = dfc->dfc_ip;
+
 	/* Move captured dfops chain and state to the transaction. */
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
 	tp->t_flags |= dfc->dfc_tpflags;
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index c447c79bbe74..3aaf702d4445 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -77,15 +77,22 @@ struct xfs_defer_capture {
 	unsigned int		dfc_tpflags;
 	unsigned int		dfc_blkres;
 	struct xfs_trans_res	dfc_tres;
+
+	/*
+	 * An inode reference that must be maintained to complete the deferred
+	 * work.
+	 */
+	struct xfs_inode	*dfc_ip;
 };
 
 /*
  * Functions to capture a chain of deferred operations and continue them later.
  * This doesn't normally happen except log recovery.
  */
-int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
+int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct list_head *capture_list);
-void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp);
+void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
+		struct xfs_inode **ipp);
 void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
 
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 1c9cb5a04bb5..0ffbc75bafe1 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -513,15 +513,11 @@ xfs_bui_item_recover(
 		xfs_bmap_unmap_extent(tp, ip, &irec);
 	}
 
-	/* Commit transaction, which frees tp. */
-	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
-	if (error)
-		goto err_unlock;
-	return 0;
+	/* Commit transaction, which frees the transaction and the inode. */
+	return xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
 
 err_cancel:
 	xfs_trans_cancel(tp);
-err_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 err_rele:
 	xfs_irele(ip);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 17d36fe5cfd0..3920542f5736 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -627,7 +627,7 @@ xfs_efi_item_recover(
 
 	}
 
-	return xfs_defer_ops_capture_and_commit(tp, capture_list);
+	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
 
 abort_error:
 	xfs_trans_cancel(tp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 46e750279634..90ad2bfdfa48 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2439,6 +2439,7 @@ xlog_finish_defer_ops(
 {
 	struct xfs_defer_capture *dfc, *next;
 	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
@@ -2449,9 +2450,13 @@ xlog_finish_defer_ops(
 
 		/* Transfer all collected dfops to this transaction. */
 		list_del_init(&dfc->dfc_list);
-		xfs_defer_ops_continue(dfc, tp);
+		xfs_defer_ops_continue(dfc, tp, &ip);
 
 		error = xfs_trans_commit(tp);
+		if (ip) {
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			xfs_irele(ip);
+		}
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 0478374add64..ad895b48f365 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -544,7 +544,7 @@ xfs_cui_item_recover(
 	}
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	return xfs_defer_ops_capture_and_commit(tp, capture_list);
+	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 0d8fa707f079..1163f32c3e62 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -567,7 +567,7 @@ xfs_rui_item_recover(
 	}
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
-	return xfs_defer_ops_capture_and_commit(tp, capture_list);
+	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
 
 abort_error:
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);

