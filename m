Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D741C2BA18
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02BDD2080C
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:12:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tJ7R6FMm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgDCWMo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:12:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47498 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728584AbgDCWMo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:12:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033MA4uF082987
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=QclhIMAuM/rABsclCLnlHsp4RPcAdCcbkE29evKGOkM=;
 b=tJ7R6FMmQMcFuFw2WDY4j4/+9ob3QZBm9G5gd4veVxP2Ln1rBz4UNsX0mRSY6urGC7O+
 XKbmvNtfZCppxX9HGcARkNoge+BJIhJx9rZOwOKcy8f6biilFf/ZFw4DFd6CFpbPq5ME
 GooZXFBqxWr95PwDE17hqMUhAx4+vZnX3TWS3clF2Ayf+t/VyoAiD1FK7bJI5dE+p/NX
 4bh9CgLvQJrVHRxcgh3mg/Lpv1fgspxxqGO014KJouE/uHTPbXotYgu+QW98zb4U7TZi
 76u1ttqElaLF3RswZ1EOPtKNjnaEDYgODgmm130PLxN4qM5lnEuem/wtXmSR4pVMsBxf aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 303cevkds7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:12:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M8NxQ062326
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 302ga617ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:12:42 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033MCgve010819
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:42 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:12:41 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 13/20] xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
Date:   Fri,  3 Apr 2020 15:12:22 -0700
Message-Id: <20200403221229.4995-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403221229.4995-1-allison.henderson@oracle.com>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In this patch, we hoist code from xfs_attr_set_args into two new helpers
xfs_attr_is_shortform and xfs_attr_set_shortform.  These two will help
to simplify xfs_attr_set_args when we get into delayed attrs later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 107 +++++++++++++++++++++++++++++++----------------
 1 file changed, 72 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 4225a94..ba26ffe 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -204,6 +204,66 @@ xfs_attr_try_sf_addname(
 }
 
 /*
+ * Check to see if the attr should be upgraded from non-existent or shortform to
+ * single-leaf-block attribute list.
+ */
+static inline bool
+xfs_attr_is_shortform(
+	struct xfs_inode    *ip)
+{
+	return ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
+	      (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
+	      ip->i_d.di_anextents == 0);
+}
+
+/*
+ * Attempts to set an attr in shortform, or converts the tree to leaf form if
+ * there is not enough room.  If the attr is set, the transaction is committed
+ * and set to NULL.
+ */
+STATIC int
+xfs_attr_set_shortform(
+	struct xfs_da_args	*args,
+	struct xfs_buf		**leaf_bp)
+{
+	struct xfs_inode	*dp = args->dp;
+	int			error, error2 = 0;
+
+	/*
+	 * Try to add the attr to the attribute list in the inode.
+	 */
+	error = xfs_attr_try_sf_addname(dp, args);
+	if (error != -ENOSPC) {
+		error2 = xfs_trans_commit(args->trans);
+		args->trans = NULL;
+		return error ? error : error2;
+	}
+	/*
+	 * It won't fit in the shortform, transform to a leaf block.  GROT:
+	 * another possible req'mt for a double-split btree op.
+	 */
+	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	if (error)
+		return error;
+
+	/*
+	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
+	 * push cannot grab the half-baked leaf buffer and run into problems
+	 * with the write verifier. Once we're done rolling the transaction we
+	 * can release the hold and add the attr to the leaf.
+	 */
+	xfs_trans_bhold(args->trans, *leaf_bp);
+	error = xfs_defer_finish(&args->trans);
+	xfs_trans_bhold_release(args->trans, *leaf_bp);
+	if (error) {
+		xfs_trans_brelse(args->trans, *leaf_bp);
+		return error;
+	}
+
+	return 0;
+}
+
+/*
  * Set the attribute specified in @args.
  */
 int
@@ -212,48 +272,25 @@ xfs_attr_set_args(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf          *leaf_bp = NULL;
-	int			error, error2 = 0;
+	int			error = 0;
 
 	/*
-	 * If the attribute list is non-existent or a shortform list,
-	 * upgrade it to a single-leaf-block attribute list.
+	 * If the attribute list is already in leaf format, jump straight to
+	 * leaf handling.  Otherwise, try to add the attribute to the shortform
+	 * list; if there's no room then convert the list to leaf format and try
+	 * again.
 	 */
-	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
-	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	     dp->i_d.di_anextents == 0)) {
-
-		/*
-		 * Try to add the attr to the attribute list in the inode.
-		 */
-		error = xfs_attr_try_sf_addname(dp, args);
-		if (error != -ENOSPC) {
-			error2 = xfs_trans_commit(args->trans);
-			args->trans = NULL;
-			return error ? error : error2;
-		}
-
-		/*
-		 * It won't fit in the shortform, transform to a leaf block.
-		 * GROT: another possible req'mt for a double-split btree op.
-		 */
-		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
-		if (error)
-			return error;
+	if (xfs_attr_is_shortform(dp)) {
 
 		/*
-		 * Prevent the leaf buffer from being unlocked so that a
-		 * concurrent AIL push cannot grab the half-baked leaf
-		 * buffer and run into problems with the write verifier.
-		 * Once we're done rolling the transaction we can release
-		 * the hold and add the attr to the leaf.
+		 * If the attr was successfully set in shortform, the
+		 * transaction is committed and set to NULL.  Otherwise, is it
+		 * converted from shortform to leaf, and the transaction is
+		 * retained.
 		 */
-		xfs_trans_bhold(args->trans, leaf_bp);
-		error = xfs_defer_finish(&args->trans);
-		xfs_trans_bhold_release(args->trans, leaf_bp);
-		if (error) {
-			xfs_trans_brelse(args->trans, leaf_bp);
+		error = xfs_attr_set_shortform(args, &leaf_bp);
+		if (error || !args->trans)
 			return error;
-		}
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-- 
2.7.4

