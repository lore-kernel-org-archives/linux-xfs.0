Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FD9C04E30
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3075C206C3
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:18:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VDGl8Vq8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfLLESP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 23:18:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45128 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbfLLESN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Dec 2019 23:18:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4EkHM129017
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=9t4yPu/02/ULhYDK0LL+n6aS7d/tdW1Db909crjG9J0=;
 b=VDGl8Vq8y33TtWiwrfCbO8RFirTukQ5SAvINJXeswrGC1pFgd85QMeqR1TdylvAwC3+N
 iL9nj8u4SkUWnUNSaMYxmnC9c+wbbMvYf0Ge7QfDm8cAWedWKg23pWgjPzB5hjxxm/iu
 8YFI4wqNolMpxpCu4dsnUOnubDyi+j9PfocDtlFhNoGw0qSXmI7r+nG/6X3vDWwYTlk1
 IeLYJ7VDKQjCN+1o1PYBGAsuT/QhB+MBds7LoxUY/DfJaZuO0z+IkuvTDWHVV4IC2yeH
 R52tAzqTZxrkLuMDmXPXDKgWP/M4UVXA90/P3dB7fox3kNHIfhiWK7lGEinwH5lNmuDf 2w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wr4qrre66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4EJ4R089467
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wubmd10rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:11 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBC4IAmN016324
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:11 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Dec 2019 20:18:10 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 13/14] xfsprogs: Add delay ready attr remove routines
Date:   Wed, 11 Dec 2019 21:18:02 -0700
Message-Id: <20191212041803.14018-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212041803.14018-1-allison.henderson@oracle.com>
References: <20191212041803.14018-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies the attr remove routines to be delay ready. This
means they no longer roll or commit transactions, but instead return
-EAGAIN to have the calling routine roll and refresh the transaction.
In this series, xfs_attr_remove_args has become
xfs_attr_remove_iter, which uses a sort of state machine like switch
to keep track of where it was when EAGAIN was returned.
xfs_attr_node_removename has also been modified to use the switch,
and a  new version of xfs_attr_remove_args consists of a simple loop
to refresh the transaction until the operation is completed.

This patch also adds a new struct xfs_delattr_context, which we will
use to keep track of the current state of an attribute operation.
The new xfs_delattr_state enum is used to track various operations
that are in progress so that we know not to repeat them, and resume
where we left off before EAGAIN was returned to cycle out the
transaction. Other members take the place of local variables that
need to retain their values across multiple function recalls.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c     | 127 ++++++++++++++++++++++++++++++++++++++++++--------
 libxfs/xfs_attr.h     |   1 +
 libxfs/xfs_da_btree.h |  16 +++++++
 3 files changed, 125 insertions(+), 19 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 357824c..579afed 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -356,11 +356,51 @@ xfs_has_attr(
  */
 int
 xfs_attr_remove_args(
+	struct xfs_da_args	*args)
+{
+	int			error = 0;
+	int			err2 = 0;
+
+	do {
+		error = xfs_attr_remove_iter(args);
+		if (error && error != -EAGAIN)
+			goto out;
+
+		err2 = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (err2) {
+			error = err2;
+			goto out;
+		}
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
+xfs_attr_remove_iter(
 	struct xfs_da_args      *args)
 {
 	struct xfs_inode	*dp = args->dp;
 	int			error;
 
+	/* State machine switch */
+	switch (args->dac.dela_state) {
+	case XFS_DAS_RM_INVALIDATE:
+	case XFS_DAS_RM_SHRINK:
+	case XFS_DAS_RM_NODE_BLKS:
+		goto node;
+	default:
+		break;
+	}
+
 	if (!xfs_inode_hasattr(dp)) {
 		error = -ENOATTR;
 	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
@@ -369,6 +409,7 @@ xfs_attr_remove_args(
 	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_removename(args);
 	} else {
+node:
 		error = xfs_attr_node_removename(args);
 	}
 
@@ -872,9 +913,6 @@ xfs_attr_leaf_removename(
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (error)
 			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
 	}
 	return 0;
 }
@@ -1195,6 +1233,11 @@ out:
  * This will involve walking down the Btree, and may involve joining
  * leaf nodes and even joining intermediate nodes up to and including
  * the root node (a special case of an intermediate node).
+ *
+ * This routine is meant to function as either an inline or delayed operation,
+ * and may return -EAGAIN when the transaction needs to be rolled.  Calling
+ * functions will need to handle this, and recall the function until a
+ * successful error code is returned.
  */
 STATIC int
 xfs_attr_node_removename(
@@ -1205,12 +1248,29 @@ xfs_attr_node_removename(
 	struct xfs_buf		*bp;
 	int			retval, error, forkoff;
 	struct xfs_inode	*dp = args->dp;
+	int			done = 0;
 
 	trace_xfs_attr_node_removename(args);
+	state = args->dac.da_state;
+	blk = args->dac.blk;
+
+	/* State machine switch */
+	switch (args->dac.dela_state) {
+	case XFS_DAS_RM_NODE_BLKS:
+		goto rm_node_blks;
+	case XFS_DAS_RM_INVALIDATE:
+		goto rm_invalidate;
+	case XFS_DAS_RM_SHRINK:
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
@@ -1220,6 +1280,14 @@ xfs_attr_node_removename(
 	blk = &state->path.blk[ state->path.active-1 ];
 	ASSERT(blk->bp != NULL);
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+
+	/*
+	 * Store blk and state in the context incase we need to cycle out the
+	 * transaction
+	 */
+	args->dac.blk = blk;
+	args->dac.da_state = state;
+
 	if (args->rmtblkno > 0) {
 		/*
 		 * Fill in disk block numbers in the state structure
@@ -1238,13 +1306,40 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
 
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			goto out;
+		args->dac.dela_state = XFS_DAS_RM_INVALIDATE;
+		return -EAGAIN;
+	}
+
+rm_invalidate:
+	args->dac.dela_state = XFS_DAS_RM_INVALIDATE;
 
-		error = xfs_attr_rmtval_remove(args);
+	if (args->rmtblkno > 0) {
+		error = xfs_attr_rmtval_invalidate(args);
 		if (error)
 			goto out;
+	}
+
+rm_node_blks:
+
+	args->dac.dela_state = XFS_DAS_RM_NODE_BLKS;
+	if (args->rmtblkno > 0) {
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
+
+			if (!done) {
+				args->dac.dela_state = XFS_DAS_RM_NODE_BLKS;
+				return -EAGAIN;
+			}
+		}
 
 		/*
 		 * Refill the state structure with buffers, the prior calls
@@ -1270,17 +1365,14 @@ xfs_attr_node_removename(
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
+		args->dac.dela_state = XFS_DAS_RM_SHRINK;
+		return -EAGAIN;
 	}
 
+rm_shrink:
+	args->dac.dela_state = XFS_DAS_RM_SHRINK;
+
 	/*
 	 * If the result is small enough, push it all into the inode.
 	 */
@@ -1301,9 +1393,6 @@ xfs_attr_node_removename(
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
index 3b5dad4..f6ac571 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -152,6 +152,7 @@ int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_remove_iter(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 bool xfs_attr_namecheck(const void *name, size_t length);
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index bed4f40..1cec0a5c 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -42,10 +42,26 @@ enum xfs_dacmp {
 	XFS_CMP_CASE		/* names are same but differ in case */
 };
 
+enum xfs_delattr_state {
+	XFS_DAS_RM_INVALIDATE	= 1, /* We are invalidating blocks */
+	XFS_DAS_RM_SHRINK	= 2, /* We are shrinking the tree */
+	XFS_DAS_RM_NODE_BLKS	= 3,/* We are removing node blocks */
+};
+
+/*
+ * Context used for keeping track of delayed attribute operations
+ */
+struct xfs_delattr_context {
+	struct xfs_da_state	*da_state;
+	struct xfs_da_state_blk *blk;
+	enum xfs_delattr_state	dela_state;
+};
+
 /*
  * Structure to ease passing around component names.
  */
 typedef struct xfs_da_args {
+	struct xfs_delattr_context dac;/* context used for delay attr ops */
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	struct xfs_name	name;		/* name, length and argument  flags*/
 	uint8_t		filetype;	/* filetype of inode for directories */
-- 
2.7.4

