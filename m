Return-Path: <SRS0=0TO6=3H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CC7C33CB7
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FE3E2469D
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:46:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LLY4/UPJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgARWqT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jan 2020 17:46:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36796 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgARWqT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jan 2020 17:46:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcvhl093545
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=brVM3u03GEwWl9SjfGlH14nArA8qSx6pWeP75jmYeMk=;
 b=LLY4/UPJ7rZZmX5z4tCfKvD1/6EYamqvQ+rkMW7Rxwc9N4ftFjhNyJhhKY2Wg5JL8sIx
 rjOsgWn7d0VJQk7/IzxKfaHGbcs5i8aAIcowpmP36T7qR8z1u/IIlnCH4bJDfFNuhB+n
 Mt3l7k377gBKujhH8mOrk9/ijHoylgTCblrxVAfLhX41NcwXVqbyjpCIVwfH2Jk2uFHs
 eF//KkQvFmwOT63ST5OM0Y2DOv/IgReUMb3k123sxThV3Gs3r0yQf5LxPg0GK3TvR6LQ
 1AIYKbazwTd+CcWIwfq0NbjwoTRRCJ9pGymh4w59KMpPdn6CbC6RatQtL1pPhIz6lXYY qA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xkseu244r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcueA070502
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xkq5p8yyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:18 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00IMkH2G025487
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:17 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 18 Jan 2020 14:46:17 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 16/17] xfsprogs: Add delay ready attr remove routines
Date:   Sat, 18 Jan 2020 15:45:57 -0700
Message-Id: <20200118224558.19382-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200118224558.19382-1-allison.henderson@oracle.com>
References: <20200118224558.19382-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001180185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001180185
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies the attr remove routines to be delay ready. This
means they no longer roll or commit transactions, but instead return
-EAGAIN to have the calling routine roll and refresh the transaction.
In this series, xfs_attr_remove_args has become xfs_attr_remove_iter,
which uses a sort of state machine like switch to keep track of where it
was when EAGAIN was returned. xfs_attr_node_removename has also been
modified to use the switch, and a  new version of xfs_attr_remove_args
consists of a simple loop to refresh the transaction until the operation
is completed. A helper function xfs_attr_node_shrink has also been
added to help simplify xfs_attr_node_removename and reduce length.

This patch also adds a new struct xfs_delattr_context, which we will use
to keep track of the current state of an attribute operation. The new
xfs_delattr_state enum is used to track various operations that are in
progress so that we know not to repeat them, and resume where we left
off before EAGAIN was returned to cycle out the transaction. Other
members take the place of local variables that need to retain their
values across multiple function recalls.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c     | 182 ++++++++++++++++++++++++++++++++++++++------------
 libxfs/xfs_attr.h     |   1 +
 libxfs/xfs_da_btree.h |  24 +++++++
 3 files changed, 164 insertions(+), 43 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 4ab97dd..c43d0d9 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -370,11 +370,60 @@ xfs_has_attr(
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
+		if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
+			args->dac.flags &= ~XFS_DAC_FINISH_TRANS;
+
+			err2 = xfs_defer_finish(&args->trans);
+			if (err2) {
+				error = err2;
+				goto out;
+			}
+		}
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
@@ -383,6 +432,7 @@ xfs_attr_remove_args(
 	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_removename(args);
 	} else {
+node:
 		error = xfs_attr_node_removename(args);
 	}
 
@@ -886,9 +936,8 @@ xfs_attr_leaf_removename(
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (error)
 			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
+
+		args->dac.flags |= XFS_DAC_FINISH_TRANS;
 	}
 	return 0;
 }
@@ -1232,6 +1281,42 @@ xfs_attr_init_unmapstate(
 	return 0;
 }
 
+/*
+ * Shrink an attribute from leaf to shortform
+ */
+STATIC int
+xfs_attr_node_shrink(
+	struct xfs_da_args	*args,
+	struct xfs_da_state     *state)
+{
+	struct xfs_inode	*dp = args->dp;
+	int			error, forkoff;
+	struct xfs_buf		*bp;
+
+	/*
+	 * Have to get rid of the copy of this dabuf in the state.
+	 */
+	ASSERT(state->path.active == 1);
+	ASSERT(state->path.blk[0].bp);
+	state->path.blk[0].bp = NULL;
+
+	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, -1, &bp);
+	if (error)
+		return error;
+
+	forkoff = xfs_attr_shortform_allfit(bp, dp);
+	if (forkoff) {
+		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+		/* bp is gone due to xfs_da_shrink_inode */
+		if (error)
+			return error;
+
+		args->dac.flags |= XFS_DAC_FINISH_TRANS;
+	} else
+		xfs_trans_brelse(args->trans, bp);
+
+	return 0;
+}
 
 /*
  * Remove a name from a B-tree attribute list.
@@ -1239,6 +1324,11 @@ xfs_attr_init_unmapstate(
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
@@ -1246,15 +1336,28 @@ xfs_attr_node_removename(
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
-	struct xfs_buf		*bp;
-	int			retval, error, forkoff;
+	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
+	state = args->dac.da_state;
+	blk = args->dac.blk;
+
+	/* State machine switch */
+	switch (args->dac.dela_state) {
+	case XFS_DAS_RM_NODE_BLKS:
+		goto rm_node_blks;
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
@@ -1264,18 +1367,36 @@ xfs_attr_node_removename(
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
 		error = xfs_attr_init_unmapstate(args, state);
 		if (error)
 			goto out;
 
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		error = xfs_attr_rmtval_invalidate(args);
 		if (error)
 			goto out;
+	}
 
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			goto out;
+rm_node_blks:
+
+	args->dac.dela_state = XFS_DAS_RM_NODE_BLKS;
+
+	if (args->rmtblkno > 0) {
+		error = xfs_attr_rmtval_unmap(args);
+
+		if (error) {
+			if (error == -EAGAIN)
+				args->dac.dela_state = XFS_DAS_RM_NODE_BLKS;
+			return error;
+		}
 
 		/*
 		 * Refill the state structure with buffers, the prior calls
@@ -1301,45 +1422,20 @@ xfs_attr_node_removename(
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
+		args->dac.flags |= XFS_DAC_FINISH_TRANS;
+		args->dac.dela_state = XFS_DAS_RM_SHRINK;
+		return -EAGAIN;
 	}
 
+rm_shrink:
+	args->dac.dela_state = XFS_DAS_RM_SHRINK;
+
 	/*
 	 * If the result is small enough, push it all into the inode.
 	 */
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		/*
-		 * Have to get rid of the copy of this dabuf in the state.
-		 */
-		ASSERT(state->path.active == 1);
-		ASSERT(state->path.blk[0].bp);
-		state->path.blk[0].bp = NULL;
-
-		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, -1, &bp);
-		if (error)
-			goto out;
-
-		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
-			/* bp is gone due to xfs_da_shrink_inode */
-			if (error)
-				goto out;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
-		} else
-			xfs_trans_brelse(args->trans, bp);
-	}
-	error = 0;
-
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+		error = xfs_attr_node_shrink(args, state);
 out:
 	if (state)
 		xfs_da_state_free(state);
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
index bed4f40..fe034d7 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -43,9 +43,33 @@ enum xfs_dacmp {
 };
 
 /*
+ * Enum values for xfs_delattr_context.da_state
+ */
+enum xfs_delattr_state {
+	XFS_DAS_RM_SHRINK	= 1, /* We are shrinking the tree */
+	XFS_DAS_RM_NODE_BLKS	= 2, /* We are removing node blocks */
+};
+
+/*
+ * Defines for xfs_delattr_context.flags
+ */
+#define	XFS_DAC_FINISH_TRANS	0x1 /* indicates to finish the transaction */
+
+/*
+ * Context used for keeping track of delayed attribute operations
+ */
+struct xfs_delattr_context {
+	struct xfs_da_state	*da_state;
+	struct xfs_da_state_blk *blk;
+	int			flags;
+	enum xfs_delattr_state	dela_state;
+};
+
+/*
  * Structure to ease passing around component names.
  */
 typedef struct xfs_da_args {
+	struct xfs_delattr_context dac; /* context used for delay attr ops */
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	struct xfs_name	name;		/* name, length and argument  flags*/
 	uint8_t		filetype;	/* filetype of inode for directories */
-- 
2.7.4

