Return-Path: <SRS0=mrUW=DL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F30C4363C
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Oct 2020 19:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6C942065D
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Oct 2020 19:11:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uxt6Muhe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgJDTLf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Oct 2020 15:11:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49016 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgJDTLf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Oct 2020 15:11:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 094J9vcu090277;
        Sun, 4 Oct 2020 19:11:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=TAKIgeJlHXrNMmGlIj1WIvTLasx7Sr+Iwwhl+jFvQz0=;
 b=uxt6MuheFrGLa64hqlDVKCRA1nVCiOFGxE7bJinZuO0yuG9W57pKoHPsIjZuN8HEmOX/
 dF4b06fqfIQMN9VroIi3CfOcNIozL9jl7Zv6adc1PeJHzpRnczNEmw9DbXtwP/IqsINI
 DSLJyhRNxHE5wcjjOyUAPLBt4wpFothX+gAmJS3hCiEauZyWsDJsjH+s+pw5jvHsqjfW
 ZZXFeXA3xUGUrj7KZR3rgOnCKxSq3QG1zQLdbhZUQNGn7l/IWSasiJNidpCWFfe7iCEY
 r8V0oWpeSy6BxscnfQXwV3na14kblBuJOqfA7hF/HUpiZe1asiS3q9PEff8GHBGhffA1 0Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33xhxmjtxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 04 Oct 2020 19:11:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 094JAggd074096;
        Sun, 4 Oct 2020 19:11:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33y36vrdda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 04 Oct 2020 19:11:28 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 094JBRDg025395;
        Sun, 4 Oct 2020 19:11:27 GMT
Received: from localhost (/10.159.155.224)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 04 Oct 2020 12:11:27 -0700
Date:   Sun, 4 Oct 2020 12:11:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v3.3 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
Message-ID: <20201004191127.GC49547@magnolia>
References: <160140142711.830434.5161910313856677767.stgit@magnolia>
 <160140144660.830434.10498291551366134327.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160140144660.830434.10498291551366134327.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9764 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=5 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010040146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9764 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=5 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010040146
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
v3.3: ihold the captured inode and let callers iunlock/irele their own
reference
v3.2: rebase on updated defer capture patches
---
 fs/xfs/libxfs/xfs_defer.c  |   43 ++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_defer.h  |   11 +++++++++--
 fs/xfs/xfs_bmap_item.c     |    7 +++++--
 fs/xfs/xfs_extfree_item.c  |    2 +-
 fs/xfs/xfs_inode.c         |    8 ++++++++
 fs/xfs/xfs_inode.h         |    2 ++
 fs/xfs/xfs_log_recover.c   |    7 ++++++-
 fs/xfs/xfs_refcount_item.c |    2 +-
 fs/xfs/xfs_rmap_item.c     |    2 +-
 9 files changed, 71 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index e19dc1ced7e6..00696c23670c 100644
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
+ * If capture_ip is not NULL, the capture structure will obtain an extra
+ * reference to the inode.
  */
 static struct xfs_defer_capture *
 xfs_defer_ops_capture(
-	struct xfs_trans		*tp)
+	struct xfs_trans		*tp,
+	struct xfs_inode		*capture_ip)
 {
 	struct xfs_defer_capture	*dfc;
 
@@ -582,6 +587,15 @@ xfs_defer_ops_capture(
 	/* Preserve the log reservation size. */
 	dfc->dfc_logres = tp->t_log_res;
 
+	/*
+	 * Grab an extra reference to this inode and attach it to the capture
+	 * structure.
+	 */
+	if (capture_ip) {
+		xfs_ihold(capture_ip);
+		dfc->dfc_capture_ip = capture_ip;
+	}
+
 	return dfc;
 }
 
@@ -592,24 +606,33 @@ xfs_defer_ops_release(
 	struct xfs_defer_capture	*dfc)
 {
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
+	if (dfc->dfc_capture_ip)
+		xfs_irele(dfc->dfc_capture_ip);
 	kmem_free(dfc);
 }
 
 /*
  * Capture any deferred ops and commit the transaction.  This is the last step
- * needed to finish a log intent item that we recovered from the log.
+ * needed to finish a log intent item that we recovered from the log.  If any
+ * of the deferred ops operate on an inode, the caller must pass in that inode
+ * so that the reference can be transferred to the capture structure.  The
+ * caller must hold ILOCK_EXCL on the inode, and must unlock it before calling
+ * xfs_defer_ops_continue.
  */
 int
 xfs_defer_ops_capture_and_commit(
 	struct xfs_trans		*tp,
+	struct xfs_inode		*capture_ip,
 	struct list_head		*capture_list)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_defer_capture	*dfc;
 	int				error;
 
+	ASSERT(!capture_ip || xfs_isilocked(capture_ip, XFS_ILOCK_EXCL));
+
 	/* If we don't capture anything, commit transaction and exit. */
-	dfc = xfs_defer_ops_capture(tp);
+	dfc = xfs_defer_ops_capture(tp, capture_ip);
 	if (!dfc)
 		return xfs_trans_commit(tp);
 
@@ -626,16 +649,26 @@ xfs_defer_ops_capture_and_commit(
 
 /*
  * Attach a chain of captured deferred ops to a new transaction and free the
- * capture structure.
+ * capture structure.  If an inode was captured, it will be passed back to the
+ * caller with ILOCK_EXCL held and joined to the transaction with lockflags==0.
+ * The caller now owns the inode reference.
  */
 void
 xfs_defer_ops_continue(
 	struct xfs_defer_capture	*dfc,
-	struct xfs_trans		*tp)
+	struct xfs_trans		*tp,
+	struct xfs_inode		**captured_ipp)
 {
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
+	/* Lock and join the captured inode to the new transaction. */
+	if (dfc->dfc_capture_ip) {
+		xfs_ilock(dfc->dfc_capture_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, dfc->dfc_capture_ip, 0);
+	}
+	*captured_ipp = dfc->dfc_capture_ip;
+
 	/* Move captured dfops chain and state to the transaction. */
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
 	tp->t_flags |= dfc->dfc_tpflags;
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 6cde6f0713f7..05472f71fffe 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -82,6 +82,12 @@ struct xfs_defer_capture {
 
 	/* Log reservation saved from the transaction. */
 	unsigned int		dfc_logres;
+
+	/*
+	 * An inode reference that must be maintained to complete the deferred
+	 * work.
+	 */
+	struct xfs_inode	*dfc_capture_ip;
 };
 
 /*
@@ -89,8 +95,9 @@ struct xfs_defer_capture {
  * This doesn't normally happen except log recovery.
  */
 int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
-		struct list_head *capture_list);
-void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp);
+		struct xfs_inode *capture_ip, struct list_head *capture_list);
+void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
+		struct xfs_inode **captured_ipp);
 void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
 
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 852411568d14..4570da07eb06 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -513,8 +513,11 @@ xfs_bui_item_recover(
 		xfs_bmap_unmap_extent(tp, ip, &irec);
 	}
 
-	/* Commit transaction, which frees the transaction. */
-	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
+	/*
+	 * Commit transaction, which frees the transaction and saves the inode
+	 * for later replay activities.
+	 */
+	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
 	if (error)
 		goto err_unlock;
 
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
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2bfbcf28b1bd..24b1e2244905 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3813,3 +3813,11 @@ xfs_iunlock2_io_mmap(
 	if (!same_inode)
 		inode_unlock(VFS_I(ip1));
 }
+
+/* Grab an extra reference to the VFS inode. */
+void
+xfs_ihold(
+	struct xfs_inode	*ip)
+{
+	ihold(VFS_I(ip));
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 751a3d1d7d84..e9b0186b594c 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -476,4 +476,6 @@ void xfs_end_io(struct work_struct *work);
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 
+void xfs_ihold(struct xfs_inode *ip);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 001e1585ddc6..a8289adc1b29 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2439,6 +2439,7 @@ xlog_finish_defer_ops(
 {
 	struct xfs_defer_capture *dfc, *next;
 	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
@@ -2464,9 +2465,13 @@ xlog_finish_defer_ops(
 		 * from recovering a single intent item.
 		 */
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
