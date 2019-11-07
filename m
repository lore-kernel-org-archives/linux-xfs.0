Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A1AFC6196
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DDA4217D7
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:28:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eMas/8Ot"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbfKGB2z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:28:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37272 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbfKGB2z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:28:55 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SsCr180073
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=NfoKhgLj0MG2/PFNvd3NRTZlo4nT6rSD1Wzl/i5nFsM=;
 b=eMas/8OtFybDmGYv3rQxEHjLXJb42dPTNuUTGb0gWmPiH4G6yn0rG4gGc9vab2jsgz1b
 nsiqZ6XxrJEMTFNGtlhDKwoQdExubltqsbUZCgEKFRXtTthsVWoalR5vG6HUEu1e+fbJ
 NaKnB90pmgxKk0Kh7OhCVafdlfr2aZ+XU6ppkuK6aUPz3DV9FofWG31qfzvEwitIqOjB
 BawHpSIhNfThuDfjJNl6v8VmkaOcvQ9a0r1LmYWj55U5x0ToTfVtrZsPe53PaErLXiu8
 QW7wH1OLkQ4Q5Uy8bmNL7IOTGzz4KT1Vrh4ixdzTRytR0l0hJ3wSbaBoGbdKMWPic3XM 6Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w41w12pte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:28:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SmPe126981
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w41wfv9dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:28:49 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA71SnxR011272
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:49 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:28:49 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 16/17] xfs: Add delay ready attr remove routines
Date:   Wed,  6 Nov 2019 18:28:00 -0700
Message-Id: <20191107012801.22863-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107012801.22863-1-allison.henderson@oracle.com>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
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
 fs/xfs/libxfs/xfs_attr.c | 123 +++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_attr.h |   1 +
 2 files changed, 104 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 626d4a98..38d5c5c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -369,10 +369,56 @@ xfs_has_attr(
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
@@ -382,6 +428,7 @@ xfs_attr_remove_args(
 	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_removename(args);
 	} else {
+node:
 		error = xfs_attr_node_removename(args);
 	}
 
@@ -892,9 +939,6 @@ xfs_attr_leaf_removename(
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (error)
 			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
 	}
 	return 0;
 }
@@ -1212,6 +1256,11 @@ xfs_attr_node_addname(
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
@@ -1222,12 +1271,29 @@ xfs_attr_node_removename(
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
@@ -1237,6 +1303,14 @@ xfs_attr_node_removename(
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
@@ -1255,13 +1329,30 @@ xfs_attr_node_removename(
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
@@ -1287,17 +1378,12 @@ xfs_attr_node_removename(
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
@@ -1319,9 +1405,6 @@ xfs_attr_node_removename(
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (error)
 				goto out;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
 		} else
 			xfs_trans_brelse(args->trans, bp);
 	}
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 3b5dad4..fb8bf5b 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -152,6 +152,7 @@ int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_remove_later(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 bool xfs_attr_namecheck(const void *name, size_t length);
-- 
2.7.4

