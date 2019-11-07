Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3FCFC619D
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3871D21848
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:29:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hwP8ri0a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732882AbfKGB36 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:29:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52432 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbfKGB36 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:29:58 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71StXb154923
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=xb3+6xCOrNyPb897a+ACCMKHyS+Sxtz+tag9sWjT0yE=;
 b=hwP8ri0aL4Y6SldrrcNXavVtp2DnmxKAFCsmKzEzVe/iuqyBsfv+A1rJVvIVCJAhMVEl
 beg0LobJ1HTnS574ySncV9sApWMooFjhBqSSqb9/i8m7UNntQkq8m12kh1KxJFybO+Jn
 k7xQsjjBfz3/lEO80TxQwAtDVlMnab3qyQSbA53ex2Eg5w4gmgs8+kDaC5hg860Q0W8T
 R9+Zg1qxiUHtKZ0F70Jb3mkw5zQfk95aYxb/xJyT4SGaysYzz52+/GV1yIrXQWT9EB/w
 jluDvXizOD39dQtufBdyNFmcevi6aQbVliJZAbFLUOZWEWA10GFiBLSRo941JiF4PvLg Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w41w0tq9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SxUr008288
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w41wdmuqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:55 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA71Tt78009909
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:55 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:29:55 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 16/17] xfsprogs: Add delay ready attr remove routines
Date:   Wed,  6 Nov 2019 18:29:44 -0700
Message-Id: <20191107012945.22941-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107012945.22941-1-allison.henderson@oracle.com>
References: <20191107012945.22941-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies the attr remove routines to be delay ready.
This means they no longer roll or commit transactions, but instead
return -EAGAIN to have the calling routine roll and refresh the
transaction.  In this series, xfs_attr_remove_args has become
xfs_attr_remove_later, which uses a state machine to keep track
of where it was when EAGAIN was returned.  xfs_attr_node_removename
has also been modified to use the state machine, and a  new version of
xfs_attr_remove_args consists of a simple loop to refresh the
transaction until the operation is completed.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 123 +++++++++++++++++++++++++++++++++++++++++++++---------
 libxfs/xfs_attr.h |   1 +
 2 files changed, 104 insertions(+), 20 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index c204051..bbacba5 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -335,10 +335,56 @@ out:
  */
 int
 xfs_attr_remove_args(
+	struct xfs_da_args	*args)
+{
+	int			error = 0;
+	int			err2 = 0;
+
+	do {
+		error = xfs_attr_remove_later(args);
+		if (error && error != -EAGAIN)
+			goto out;
+
+		xfs_trans_log_inode(args->trans, args->dp,
+			XFS_ILOG_CORE | XFS_ILOG_ADATA);
+
+		err2 = xfs_trans_roll(&args->trans);
+		if (err2) {
+			error = err2;
+			goto out;
+		}
+
+		/* Rejoin inode */
+		xfs_trans_ijoin(args->trans, args->dp, 0);
+
+	} while (error == -EAGAIN);
+out:
+	return error;
+}
+
+/*
+ * Remove the attribute specified in @args.
+ * This routine is meant to function as a delayed operation, and may return
+ * -EGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ * returned.
+ */
+int
+xfs_attr_remove_later(
 	struct xfs_da_args      *args)
 {
 	struct xfs_inode	*dp = args->dp;
-	int			error;
+	int			error = 0;
+
+	/* State machine switch */
+	switch (args->dc.dc_state) {
+	case XFS_DC_RM_INVALIDATE:
+	case XFS_DC_RM_SHRINK:
+	case XFS_DC_RM_NODE_BLKS:
+		goto node;
+	default:
+		break;
+	}
 
 	if (!xfs_inode_hasattr(dp)) {
 		error = -ENOATTR;
@@ -348,6 +394,7 @@ xfs_attr_remove_args(
 	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_removename(args);
 	} else {
+node:
 		error = xfs_attr_node_removename(args);
 	}
 
@@ -858,9 +905,6 @@ xfs_attr_leaf_removename(
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (error)
 			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
 	}
 	return 0;
 }
@@ -1180,6 +1224,11 @@ out:
  * This will involve walking down the Btree, and may involve joining
  * leaf nodes and even joining intermediate nodes up to and including
  * the root node (a special case of an intermediate node).
+ *
+ * This routine is meant to function as a delayed operation, and may return
+ * -EAGAIN when the transaction needs to be rolled.  Calling functions
+ * will need to handle this, and recall the function until a successful error
+ * code is returned.
  */
 STATIC int
 xfs_attr_node_removename(
@@ -1190,12 +1239,29 @@ xfs_attr_node_removename(
 	struct xfs_buf		*bp;
 	int			retval, error, forkoff;
 	struct xfs_inode	*dp = args->dp;
+	int			done = 0;
 
 	trace_xfs_attr_node_removename(args);
+	state = args->dc.da_state;
+	blk = args->dc.blk;
+
+	/* State machine switch */
+	switch (args->dc.dc_state) {
+	case XFS_DC_RM_NODE_BLKS:
+		goto rm_node_blks;
+	case XFS_DC_RM_INVALIDATE:
+		goto rm_invalidate;
+	case XFS_DC_RM_SHRINK:
+		goto rm_shrink;
+	default:
+		break;
+	}
 
 	error = xfs_attr_node_hasname(args, &state);
 	if (error != -EEXIST)
 		goto out;
+	else
+		error = 0;
 
 	/*
 	 * If there is an out-of-line value, de-allocate the blocks.
@@ -1205,6 +1271,14 @@ xfs_attr_node_removename(
 	blk = &state->path.blk[ state->path.active-1 ];
 	ASSERT(blk->bp != NULL);
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+
+	/*
+	 * Store blk and state in the context incase we need to cycle out the
+	 * transaction
+	 */
+	args->dc.blk = blk;
+	args->dc.da_state = state;
+
 	if (args->rmtblkno > 0) {
 		/*
 		 * Fill in disk block numbers in the state structure
@@ -1223,13 +1297,30 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
 
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		args->dc.dc_state = XFS_DC_RM_INVALIDATE;
+		return -EAGAIN;
+rm_invalidate:
+		error = xfs_attr_rmtval_invalidate(args);
 		if (error)
 			goto out;
+rm_node_blks:
+		/*
+		 * Unmap value blocks for this attr.  This is similar to
+		 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
+		 * for new transactions
+		 */
+		while (!done && !error) {
+			error = xfs_bunmapi(args->trans, args->dp,
+				    args->rmtblkno, args->rmtblkcnt,
+				    XFS_BMAPI_ATTRFORK, 1, &done);
+			if (error)
+				return error;
 
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			goto out;
+			if (!done) {
+				args->dc.dc_state = XFS_DC_RM_NODE_BLKS;
+				return -EAGAIN;
+			}
+		}
 
 		/*
 		 * Refill the state structure with buffers, the prior calls
@@ -1255,17 +1346,12 @@ xfs_attr_node_removename(
 		error = xfs_da3_join(state);
 		if (error)
 			goto out;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
-		/*
-		 * Commit the Btree join operation and start a new trans.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			goto out;
+
+		args->dc.dc_state = XFS_DC_RM_SHRINK;
+		return -EAGAIN;
 	}
 
+rm_shrink:
 	/*
 	 * If the result is small enough, push it all into the inode.
 	 */
@@ -1287,9 +1373,6 @@ xfs_attr_node_removename(
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (error)
 				goto out;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
 		} else
 			xfs_trans_brelse(args->trans, bp);
 	}
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 3ac97e4..db1a2e5 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -150,6 +150,7 @@ int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_remove_later(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 bool xfs_attr_namecheck(const void *name, size_t length);
-- 
2.7.4

