Return-Path: <SRS0=0TO6=3H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C843C33CB8
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32E5D246AC
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 22:50:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q57REvQW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgARWuv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jan 2020 17:50:51 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53752 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgARWuu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jan 2020 17:50:50 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcxMM072182
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=zFJhZNjPwNG6JRqesXMZ4aSLcZyskc7Q7nQEa6zMUhQ=;
 b=Q57REvQWIaPYvtvCiIF221cEM25npJGEgxZR/NMuqDtqdsvOkDz6VcvbGtzI1ybbBdXx
 XJu5yRZMnTJjKKdkgMgRMcfF4hMukeGZZ0udFCAM8jXVNY0hrXUOQvQgu6Pn21Kes/u3
 rIbBesbqDyeEwKjgDUEIG41GPhRsUzPhWozMkfMvKtqUxk/38U2DCXemQftoxOwWkCi9
 yhkCYWgf88znBHrBQRuaDZuURYGDdsHWgD5flKaCa7JSILpXtGqYKefQhNy66wqS0fd2
 CxwRBm8dYXeOqYZvs+q8ykvK8JvAqVqnwqP6Nz0LeKHPkY/A/ISIvMo3fH8chZ/I1oWK WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xktnqsw63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMctAl162158
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xksc4ad11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:48 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00IMomfg030842
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:48 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 18 Jan 2020 14:50:47 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 15/16] xfs: Add delay ready attr remove routines
Date:   Sat, 18 Jan 2020 15:50:34 -0700
Message-Id: <20200118225035.19503-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200118225035.19503-1-allison.henderson@oracle.com>
References: <20200118225035.19503-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001180185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
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
is completed.  A helper function xfs_attr_node_shrink has also been
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
 fs/xfs/libxfs/xfs_attr.c     | 181 +++++++++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_attr.h     |   1 +
 fs/xfs/libxfs/xfs_da_btree.h |  24 ++++++
 fs/xfs/scrub/common.c        |   2 +
 fs/xfs/xfs_acl.c             |   2 +
 fs/xfs/xfs_attr_list.c       |   1 +
 fs/xfs/xfs_ioctl.c           |   2 +
 fs/xfs/xfs_ioctl32.c         |   2 +
 fs/xfs/xfs_iops.c            |   2 +
 fs/xfs/xfs_xattr.c           |   1 +
 10 files changed, 176 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 90e0b2d..92929ad 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -371,11 +371,60 @@ xfs_has_attr(
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
@@ -384,6 +433,7 @@ xfs_attr_remove_args(
 	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_removename(args);
 	} else {
+node:
 		error = xfs_attr_node_removename(args);
 	}
 
@@ -887,9 +937,8 @@ xfs_attr_leaf_removename(
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
@@ -1233,6 +1282,42 @@ xfs_attr_init_unmapstate(
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
+	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
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
@@ -1240,6 +1325,11 @@ xfs_attr_init_unmapstate(
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
@@ -1247,15 +1337,28 @@ xfs_attr_node_removename(
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
@@ -1265,18 +1368,36 @@ xfs_attr_node_removename(
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
@@ -1302,44 +1423,20 @@ xfs_attr_node_removename(
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
-		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
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
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+		error = xfs_attr_node_shrink(args, state);
 
 out:
 	if (state)
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index ce7b039..ea873a5 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -155,6 +155,7 @@ int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_remove_iter(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 bool xfs_attr_namecheck(const void *name, size_t length);
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 14f1be3..7fc87da 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -50,9 +50,33 @@ enum xfs_dacmp {
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
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 1887605..9a649d1 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -24,6 +24,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_log.h"
 #include "xfs_trans_priv.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 42ac847..d65e6d8 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -10,6 +10,8 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index d37743b..881b9a4 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -12,6 +12,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 28c07c9..7c1d9da 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -15,6 +15,8 @@
 #include "xfs_iwalk.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 769581a..d504f8f 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -17,6 +17,8 @@
 #include "xfs_itable.h"
 #include "xfs_fsops.h"
 #include "xfs_rtalloc.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_ioctl32.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e85bbf5..a2d299f 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -13,6 +13,8 @@
 #include "xfs_inode.h"
 #include "xfs_acl.h"
 #include "xfs_quota.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_trans.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 74133a5..d8dc72d 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -10,6 +10,7 @@
 #include "xfs_log_format.h"
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_acl.h"
 
-- 
2.7.4

