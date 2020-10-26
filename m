Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92131C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5900020872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nzQYpeaA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407483AbgJZXlI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:41:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58946 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407482AbgJZXlH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:41:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPTjS165174;
        Mon, 26 Oct 2020 23:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=NwrghQ4lXjMdeVM+PeMLVFq82zEq0fCOmYAE30zvqv4=;
 b=nzQYpeaAoSUTHDQQieHPbSv/Ru8lRl5omelkqbMnO9Dyiy06HPG/WS78GDvUv91iylJq
 TTXXqD4VVM48XMIbyrjtnHu0TPwd3fW5UtcuIcBSbDLsqjUuHt4z1hQaJEJXBHhMHacG
 SNVncL+IRoPpeE7gTI3pes8ITJ/MqgSLHMq+27rU8/A0d42Te9H+kZUtiFeX3gHcqqL2
 L2BhNPzxzdytWXmQCqw7acdhHBvvvAmkqtRqa2IVzy7cJ68IO4ZhDOS8G9VjbkAcmDrQ
 6eWC+eunRUTg6EryBKtaDqpNmtrjBvDIuVqWXCi+dnz0fXAvgxcYsusRYK/Ho2szf/v2 ag== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm3vuy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:38:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQERB032465;
        Mon, 26 Oct 2020 23:38:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cx1q2dbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:38:40 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNcdu2014110;
        Mon, 26 Oct 2020 23:38:39 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:38:39 -0700
Subject: [PATCH 16/21] xfs: fix an incore inode UAF in xfs_bui_recover
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:38:38 -0700
Message-ID: <160375551822.882906.6397999012355771666.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=2 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=2 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: ff4ab5e02a0447dd1e290883eb6cd7d94848e590

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_inode.h      |    6 ++++++
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/rdwr.c            |   11 ++++++++---
 libxfs/xfs_defer.c       |   42 +++++++++++++++++++++++++++++++++++++-----
 libxfs/xfs_defer.h       |   11 +++++++++--
 5 files changed, 61 insertions(+), 10 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 40310df6a785..742aebc8c3e3 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -36,6 +36,7 @@ struct inode {
 	uint32_t		i_gid;
 	uint32_t		i_nlink;
 	xfs_dev_t		i_rdev;	 /* This actually holds xfs_dev_t */
+	unsigned int		i_count;
 	unsigned long		i_state; /* Not actually used in userspace */
 	uint32_t		i_generation;
 	uint64_t		i_version;
@@ -61,6 +62,11 @@ static inline void i_gid_write(struct inode *inode, uint32_t gid)
 	inode->i_gid = gid;
 }
 
+static inline void ihold(struct inode *inode)
+{
+	inode->i_count++;
+}
+
 typedef struct xfs_inode {
 	struct cache_node	i_node;
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 419e6d9888cf..9a00ce6609b3 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -123,6 +123,7 @@
 #define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
 
 #define xfs_iread_extents		libxfs_iread_extents
+#define xfs_irele			libxfs_irele
 #define xfs_log_calc_minimum_size	libxfs_log_calc_minimum_size
 #define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
 #define xfs_log_sb			libxfs_log_sb
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 79c1029b1109..0001a459aa64 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1254,6 +1254,7 @@ libxfs_iget(
 	if (!ip)
 		return -ENOMEM;
 
+	VFS_I(ip)->i_count = 1;
 	ip->i_ino = ino;
 	ip->i_mount = mp;
 	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, 0);
@@ -1305,9 +1306,13 @@ void
 libxfs_irele(
 	struct xfs_inode	*ip)
 {
-	ASSERT(ip->i_itemp == NULL);
-	libxfs_idestroy(ip);
-	kmem_cache_free(xfs_inode_zone, ip);
+	VFS_I(ip)->i_count--;
+
+	if (VFS_I(ip)->i_count == 0) {
+		ASSERT(ip->i_itemp == NULL);
+		libxfs_idestroy(ip);
+		kmem_cache_free(xfs_inode_zone, ip);
+	}
 }
 
 /*
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 8e660f1a6cfc..efcb9e008275 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -551,10 +551,14 @@ xfs_defer_move(
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
 
@@ -580,6 +584,15 @@ xfs_defer_ops_capture(
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
 
@@ -590,24 +603,33 @@ xfs_defer_ops_release(
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
 
@@ -624,16 +646,26 @@ xfs_defer_ops_capture_and_commit(
 
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
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 6cde6f0713f7..05472f71fffe 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
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

