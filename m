Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B328BC4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77C8F20B80
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:21:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aZVfVzNy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgJESVA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 14:21:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38454 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgJESU7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 14:20:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IA3aO190416;
        Mon, 5 Oct 2020 18:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=81Ux2bJMewxVADJWA4d/941v76AGbOuJcB3MOVxEs2w=;
 b=aZVfVzNybQ7kS7RE/ykSC4UYmBBbW02LXCV3VDzZuH4V4WZzuQwjHSDf4hWci5u0QZzn
 e67xmX9Pp2aUpG9Q9FYGnHqfxd5RzumyFGpUUPI3cm3aWTvdtDpItD8VJREcIyKPvA7d
 TSJeegD4CwojHw5pFOZWVT5HT5zk5Nx+1il6RXmlEPCiP1k/aB0feu4bN6sfqcBdGkUG
 tZG6pZhhsfRc4Iv6TBewGtGW01+qPvxX85WlF1bG/inATNvE7G/AN9A4ZriLsLk9xITE
 nZI1CQMXj1GP4MdrvFV9/mX9NCsevL/kiNn0+i9geP9ZOWvlkQ24nu3gW7J3I5CfuvL6 bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33ym34c4gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 18:20:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IAlFL014753;
        Mon, 5 Oct 2020 18:20:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33y36wtjhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 18:20:53 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 095IKqw1030308;
        Mon, 5 Oct 2020 18:20:52 GMT
Received: from localhost (/10.159.154.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 11:20:51 -0700
Subject: [PATCH 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@lst.de
Date:   Mon, 05 Oct 2020 11:20:50 -0700
Message-ID: <160192205008.2569680.4888893690951984814.stgit@magnolia>
In-Reply-To: <160192203063.2569680.11574287082065783377.stgit@magnolia>
References: <160192203063.2569680.11574287082065783377.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=3 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=3 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c  |   43 ++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_defer.h  |   11 +++++++++--
 fs/xfs/xfs_bmap_item.c     |    7 +++++--
 fs/xfs/xfs_extfree_item.c  |    2 +-
 fs/xfs/xfs_log_recover.c   |    7 ++++++-
 fs/xfs/xfs_refcount_item.c |    2 +-
 fs/xfs/xfs_rmap_item.c     |    2 +-
 7 files changed, 61 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index e19dc1ced7e6..4d2583758f3d 100644
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
+		ihold(VFS_I(capture_ip));
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

