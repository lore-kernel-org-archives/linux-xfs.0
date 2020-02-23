Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57175C35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2556720707
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K9yuJTey"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgBWCGI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:06:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45638 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgBWCGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N21DVa189059
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=A4NjDhH5vAtQV1i/SalJeICyXiPcfVICJ8MWByZAY7I=;
 b=K9yuJTeyx03uNCIzXWsNZCsX4kOSIAieXhGnLFkKaCv5lWtN+1Rri0oL9v3s54j5J2Rt
 O500hlO9eOLvuXQ+9GTp+ruM9yfkUP5dzHlqXAKfxVTDc/Ad3epoc38mBmeYGnyu7ALI
 1C4jI0avvZppgSeSz7AQ3UFDK+DPAxR8RNzrd6g0BmdX9hAbO7MDgFvpL2KHiCjmFnZO
 EK5yBSECA3icaABm32YXB5yY82efDu+sG6xtpUh8RYgYxmj67U9dVc3ZMmN0GGWKYndq
 /HStvj2xT/I1Yhu9wusYtXqz56kRZfA7TpvOTwVDZ8rssX8BAkn6I/q9rEfpJ1ti6gT4 iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yauqu21x5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N1w2TG146348
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ybdsd6q3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:04 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01N263r4031340
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:03 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:06:03 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 14/20] xfsprogs: Add delay ready attr remove routines
Date:   Sat, 22 Feb 2020 19:05:48 -0700
Message-Id: <20200223020554.1731-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223020554.1731-1-allison.henderson@oracle.com>
References: <20200223020554.1731-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies the attr remove routines to be delay ready. This means they no
longer roll or commit transactions, but instead return -EAGAIN to have the calling
routine roll and refresh the transaction. In this series, xfs_attr_remove_args has
become xfs_attr_remove_iter, which uses a sort of state machine like switch to keep
track of where it was when EAGAIN was returned. xfs_attr_node_removename has also
been modified to use the switch, and a  new version of xfs_attr_remove_args
consists of a simple loop to refresh the transaction until the operation is
completed.

This patch also adds a new struct xfs_delattr_context, which we will use to keep
track of the current state of an attribute operation. The new xfs_delattr_state
enum is used to track various operations that are in progress so that we know not
to repeat them, and resume where we left off before EAGAIN was returned to cycle
out the transaction. Other members take the place of local variables that need
to retain their values across multiple function recalls.

Below is a state machine diagram for attr remove operations. The XFS_DAS_* states
indicate places where the function would return -EAGAIN, and then immediately
resume from after being recalled by the calling function.  States marked as a
"subroutine state" indicate that they belong to a subroutine, and so the calling
function needs to pass them back to that subroutine to allow it to finish where
it left off. But they otherwise do not have a role in the calling function other
than just passing through.

 xfs_attr_remove_iter()
         XFS_DAS_RM_SHRINK     ─┐
         (subroutine state)     │
                                │
         XFS_DAS_RMTVAL_REMOVE ─┤
         (subroutine state)     │
                                └─>xfs_attr_node_removename()
                                                 │
                                                 v
                                         need to remove
                                   ┌─n──  rmt blocks?
                                   │             │
                                   │             y
                                   │             │
                                   │             v
                                   │  ┌─>XFS_DAS_RMTVAL_REMOVE
                                   │  │          │
                                   │  │          v
                                   │  └──y── more blks
                                   │         to remove?
                                   │             │
                                   │             n
                                   │             │
                                   │             v
                                   │         need to
                                   └─────> shrink tree? ─n─┐
                                                 │         │
                                                 y         │
                                                 │         │
                                                 v         │
                                         XFS_DAS_RM_SHRINK │
                                                 │         │
                                                 v         │
                                                done <─────┘

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c     | 114 +++++++++++++++++++++++++++++++++++++++++++-------
 libxfs/xfs_attr.h     |   1 +
 libxfs/xfs_da_btree.h |  30 +++++++++++++
 3 files changed, 129 insertions(+), 16 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 15b52e2..6b6b02b 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -367,11 +367,60 @@ xfs_has_attr(
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
+ *
+ * This function may return -EAGAIN to signal that the transaction needs to be
+ * rolled.  Callers should continue calling this function until they receive a
+ * return value other than -EAGAIN.
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
+	case XFS_DAS_RMTVAL_REMOVE:
+		goto node;
+	default:
+		break;
+	}
+
 	if (!xfs_inode_hasattr(dp)) {
 		error = -ENOATTR;
 	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
@@ -380,6 +429,7 @@ xfs_attr_remove_args(
 	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_removename(args);
 	} else {
+node:
 		error = xfs_attr_node_removename(args);
 	}
 
@@ -893,9 +943,8 @@ xfs_attr_leaf_removename(
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
@@ -1216,6 +1265,11 @@ out:
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
@@ -1228,10 +1282,24 @@ xfs_attr_node_removename(
 	struct xfs_inode	*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
+	state = args->dac.da_state;
+	blk = args->dac.blk;
+
+	/* State machine switch */
+	switch (args->dac.dela_state) {
+	case XFS_DAS_RMTVAL_REMOVE:
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
@@ -1241,6 +1309,14 @@ xfs_attr_node_removename(
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
@@ -1259,13 +1335,21 @@ xfs_attr_node_removename(
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
+	if (args->rmtblkno > 0) {
+		error = xfs_attr_rmtval_unmap(args);
+
+		if (error) {
+			if (error == -EAGAIN)
+				args->dac.dela_state = XFS_DAS_RMTVAL_REMOVE;
+			return error;
+		}
 
 		/*
 		 * Refill the state structure with buffers, the prior calls
@@ -1291,17 +1375,15 @@ xfs_attr_node_removename(
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
index bed4f40..0967564 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -43,9 +43,39 @@ enum xfs_dacmp {
 };
 
 /*
+ * Enum values for xfs_delattr_context.da_state
+ *
+ * These values are used by delayed attribute operations to keep track  of where
+ * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
+ * calling function to roll the transaction, and then recall the subroutine to
+ * finish the operation.  The enum is then used by the subroutine to jump back
+ * to where it was and resume executing where it left off.
+ */
+enum xfs_delattr_state {
+	XFS_DAS_RM_SHRINK,	/* We are shrinking the tree */
+	XFS_DAS_RMTVAL_REMOVE,	/* We are removing remote value blocks */
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
+	unsigned int		flags;
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

