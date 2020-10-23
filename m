Return-Path: <SRS0=+s6N=D6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CB8C388F9
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DDDC2223F
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:36:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mXmYnfFE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372883AbgJWGgq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 02:36:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44210 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372867AbgJWGgq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Oct 2020 02:36:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6PBuk106734
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:36:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=N0Zoi7zgFnmZ7O5sPkurhtPyb/HwD9bSsm1neh24g/M=;
 b=mXmYnfFE+AwVIv5TjpJyMLMLV6PKAiAnSUNWT+sa8+e+nqwOChCZFR/CO8ZYrNDPhwhf
 uiKmloyxvjJWjOs7G2b9g0xIN4TtnMzeDwPKtZCX0YZKcZ8zsGitaew57+TTMKG9mLC4
 uv3K4TjhN9zB3FrT4pxRAP5M3gqtsAI3S8ddmoeJkDFGOnuRQFYFOYUYDFXXILKEUHny
 rdlqui5QOz42kYjWqR0oP4QLqa0P5/m1CUdf59uY8vL1ZSmFvv+FNRyspqBxVSW0W3np
 MQNadx9TWzwGHkBbEIroPwEPhZ4kidAxHLzdcJAnHGa88VOSXEl3hBQIniRZYEG0ysPM cA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 349jrq1f12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:36:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6QATc100429
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 348a6reaes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:41 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09N6YfJH008913
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:34:41 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 23:34:41 -0700
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v13 02/10] xfs: Add delay ready attr remove routines
Date:   Thu, 22 Oct 2020 23:34:27 -0700
Message-Id: <20201023063435.7510-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201023063435.7510-1-allison.henderson@oracle.com>
References: <20201023063435.7510-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=4 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=4 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230045
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies the attr remove routines to be delay ready. This
means they no longer roll or commit transactions, but instead return
-EAGAIN to have the calling routine roll and refresh the transaction. In
this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
uses a sort of state machine like switch to keep track of where it was
when EAGAIN was returned. xfs_attr_node_removename has also been
modified to use the switch, and a new version of xfs_attr_remove_args
consists of a simple loop to refresh the transaction until the operation
is completed.  A new XFS_DAC_DEFER_FINISH flag is used to finish the
transaction where ever the existing code used to.

Calls to xfs_attr_rmtval_remove are replaced with the delay ready
version __xfs_attr_rmtval_remove. We will rename
__xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
done.

xfs_attr_rmtval_remove itself is still in use by the set routines (used
during a rename).  For reasons of preserving existing function, we
modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
set.  Similar to how xfs_attr_remove_args does here.  Once we transition
the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
used and will be removed.

This patch also adds a new struct xfs_delattr_context, which we will use
to keep track of the current state of an attribute operation. The new
xfs_delattr_state enum is used to track various operations that are in
progress so that we know not to repeat them, and resume where we left
off before EAGAIN was returned to cycle out the transaction. Other
members take the place of local variables that need to retain their
values across multiple function recalls.  See xfs_attr.h for a more
detailed diagram of the states.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 200 +++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_attr.h        |  72 +++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  37 ++++----
 fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 6 files changed, 241 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f4d39bf..6ca94cb 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -53,7 +53,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
-STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -264,6 +264,33 @@ xfs_attr_set_shortform(
 }
 
 /*
+ * Checks to see if a delayed attribute transaction should be rolled.  If so,
+ * also checks for a defer finish.  Transaction is finished and rolled as
+ * needed, and returns true of false if the delayed operation should continue.
+ */
+int
+xfs_attr_trans_roll(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	int				error = 0;
+
+	if (dac->flags & XFS_DAC_DEFER_FINISH) {
+		/*
+		 * The caller wants us to finish all the deferred ops so that we
+		 * avoid pinning the log tail with a large number of deferred
+		 * ops.
+		 */
+		dac->flags &= ~XFS_DAC_DEFER_FINISH;
+		error = xfs_defer_finish(&args->trans);
+		if (error)
+			return error;
+	}
+
+	return xfs_trans_roll_inode(&args->trans, args->dp);
+}
+
+/*
  * Set the attribute specified in @args.
  */
 int
@@ -364,23 +391,54 @@ xfs_has_attr(
  */
 int
 xfs_attr_remove_args(
-	struct xfs_da_args      *args)
+	struct xfs_da_args	*args)
 {
-	struct xfs_inode	*dp = args->dp;
-	int			error;
+	int				error = 0;
+	struct xfs_delattr_context	dac = {
+		.da_args	= args,
+	};
+
+	do {
+		error = xfs_attr_remove_iter(&dac);
+		if (error != -EAGAIN)
+			break;
+
+		error = xfs_attr_trans_roll(&dac);
+		if (error)
+			return error;
+
+	} while (true);
+
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
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_inode		*dp = args->dp;
+
+	if (dac->dela_state == XFS_DAS_RM_SHRINK)
+		goto node;
 
 	if (!xfs_inode_hasattr(dp)) {
-		error = -ENOATTR;
+		return -ENOATTR;
 	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
 		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
-		error = xfs_attr_shortform_remove(args);
+		return xfs_attr_shortform_remove(args);
 	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_removename(args);
-	} else {
-		error = xfs_attr_node_removename(args);
+		return xfs_attr_leaf_removename(args);
 	}
-
-	return error;
+node:
+	return  xfs_attr_node_removename_iter(dac);
 }
 
 /*
@@ -1178,10 +1236,11 @@ xfs_attr_leaf_mark_incomplete(
  */
 STATIC
 int xfs_attr_node_removename_setup(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	**state)
+	struct xfs_delattr_context	*dac,
+	struct xfs_da_state		**state)
 {
-	int			error;
+	struct xfs_da_args		*args = dac->da_args;
+	int				error;
 
 	error = xfs_attr_node_hasname(args, state);
 	if (error != -EEXIST)
@@ -1191,6 +1250,12 @@ int xfs_attr_node_removename_setup(
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
 		XFS_ATTR_LEAF_MAGIC);
 
+	/*
+	 * Store state in the context incase we need to cycle out the
+	 * transaction
+	 */
+	dac->da_state = *state;
+
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_leaf_mark_incomplete(args, *state);
 		if (error)
@@ -1203,13 +1268,16 @@ int xfs_attr_node_removename_setup(
 }
 
 STATIC int
-xfs_attr_node_remove_rmt(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
+xfs_attr_node_remove_rmt (
+	struct xfs_delattr_context	*dac,
+	struct xfs_da_state		*state)
 {
-	int			error = 0;
+	int				error = 0;
 
-	error = xfs_attr_rmtval_remove(args);
+	/*
+	 * May return -EAGAIN to request that the caller recall this function
+	 */
+	error = __xfs_attr_rmtval_remove(dac);
 	if (error)
 		return error;
 
@@ -1221,21 +1289,27 @@ xfs_attr_node_remove_rmt(
 }
 
 /*
- * Remove a name from a B-tree attribute list.
+ * Step through removeing a name from a B-tree attribute list.
  *
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
 xfs_attr_node_remove_step(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
+	struct xfs_delattr_context	*dac)
 {
-	struct xfs_da_state_blk	*blk;
-	int			retval, error;
-	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		*state;
+	struct xfs_da_state_blk		*blk;
+	int				retval, error = 0;
 
+	state = dac->da_state;
 
 	/*
 	 * If there is an out-of-line value, de-allocate the blocks.
@@ -1243,7 +1317,10 @@ xfs_attr_node_remove_step(
 	 * overflow the maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_node_remove_rmt(args, state);
+		/*
+		 * May return -EAGAIN. Remove blocks until args->rmtblkno == 0
+		 */
+		error = xfs_attr_node_remove_rmt(dac, state);
 		if (error)
 			return error;
 	}
@@ -1257,21 +1334,18 @@ xfs_attr_node_remove_step(
 	xfs_da3_fixhashpath(state, &state->path);
 
 	/*
-	 * Check to see if the tree needs to be collapsed.
+	 * Check to see if the tree needs to be collapsed.  Set the flag to
+	 * indicate that the calling function needs to move the to shrink
+	 * operation
 	 */
 	if (retval && (state->path.active > 1)) {
 		error = xfs_da3_join(state);
 		if (error)
 			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-		/*
-		 * Commit the Btree join operation and start a new trans.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
+
+		dac->flags |= XFS_DAC_DEFER_FINISH;
+		dac->dela_state = XFS_DAS_RM_SHRINK;
+		return -EAGAIN;
 	}
 
 	return error;
@@ -1282,31 +1356,53 @@ xfs_attr_node_remove_step(
  *
  * This routine will find the blocks of the name to remove, remove them and
  * shirnk the tree if needed.
+ *
+ * This routine is meant to function as either an inline or delayed operation,
+ * and may return -EAGAIN when the transaction needs to be rolled.  Calling
+ * functions will need to handle this, and recall the function until a
+ * successful error code is returned.
  */
 STATIC int
-xfs_attr_node_removename(
-	struct xfs_da_args	*args)
+xfs_attr_node_removename_iter(
+	struct xfs_delattr_context	*dac)
 {
-	struct xfs_da_state	*state;
-	int			error;
-	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		*state;
+	int				error;
+	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
+	state = dac->da_state;
 
-	error = xfs_attr_node_removename_setup(args, &state);
-	if (error)
-		goto out;
+	if ((dac->flags & XFS_DAC_NODE_RMVNAME_INIT) == 0) {
+		dac->flags |= XFS_DAC_NODE_RMVNAME_INIT;
+		error = xfs_attr_node_removename_setup(dac, &state);
+		if (error)
+			goto out;
+	}
 
-	error = xfs_attr_node_remove_step(args, state);
-	if (error)
-		goto out;
+	switch (dac->dela_state) {
+	case XFS_DAS_UNINIT:
+		error = xfs_attr_node_remove_step(dac);
+		if (error)
+			break;
 
-	/*
-	 * If the result is small enough, push it all into the inode.
-	 */
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
-		error = xfs_attr_node_shrink(args, state);
+		/* do not break, proceed to shrink if needed */
+	case XFS_DAS_RM_SHRINK:
+		/*
+		 * If the result is small enough, push it all into the inode.
+		 */
+		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+			error = xfs_attr_node_shrink(args, state);
 
+		break;
+	default:
+		ASSERT(0);
+		return -EINVAL;
+	}
+
+	if (error == -EAGAIN)
+		return error;
 out:
 	if (state)
 		xfs_da_state_free(state);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 3e97a93..64dcf0f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -74,6 +74,74 @@ struct xfs_attr_list_context {
 };
 
 
+/*
+ * ========================================================================
+ * Structure used to pass context around among the delayed routines.
+ * ========================================================================
+ */
+
+/*
+ * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
+ * states indicate places where the function would return -EAGAIN, and then
+ * immediately resume from after being recalled by the calling function. States
+ * marked as a "subroutine state" indicate that they belong to a subroutine, and
+ * so the calling function needs to pass them back to that subroutine to allow
+ * it to finish where it left off. But they otherwise do not have a role in the
+ * calling function other than just passing through.
+ *
+ * xfs_attr_remove_iter()
+ *	  XFS_DAS_RM_SHRINK ─┐
+ *	  (subroutine state) │
+ *	                     └─>xfs_attr_node_removename()
+ *	                                      │
+ *	                                      v
+ *	                                   need to
+ *	                                shrink tree? ─n─┐
+ *	                                      │         │
+ *	                                      y         │
+ *	                                      │         │
+ *	                                      v         │
+ *	                              XFS_DAS_RM_SHRINK │
+ *	                                      │         │
+ *	                                      v         │
+ *	                                     done <─────┘
+ *
+ */
+
+/*
+ * Enum values for xfs_delattr_context.da_state
+ *
+ * These values are used by delayed attribute operations to keep track  of where
+ * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
+ * calling function to roll the transaction, and then recall the subroutine to
+ * finish the operation.  The enum is then used by the subroutine to jump back
+ * to where it was and resume executing where it left off.
+ */
+enum xfs_delattr_state {
+	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
+	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
+};
+
+/*
+ * Defines for xfs_delattr_context.flags
+ */
+#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
+#define XFS_DAC_NODE_RMVNAME_INIT	0x02 /* xfs_attr_node_removename init */
+
+/*
+ * Context used for keeping track of delayed attribute operations
+ */
+struct xfs_delattr_context {
+	struct xfs_da_args      *da_args;
+
+	/* Used in xfs_attr_node_removename to roll through removing blocks */
+	struct xfs_da_state     *da_state;
+
+	/* Used to keep track of current state of delayed operation */
+	unsigned int            flags;
+	enum xfs_delattr_state  dela_state;
+};
+
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
@@ -91,6 +159,10 @@ int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
+void xfs_delattr_context_init(struct xfs_delattr_context *dac,
+			      struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index bb128db..338377e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -19,8 +19,8 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_attr_sf.h"
-#include "xfs_attr_remote.h"
 #include "xfs_attr.h"
+#include "xfs_attr_remote.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 48d8e9c..1426c15 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -674,10 +674,12 @@ xfs_attr_rmtval_invalidate(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_da_args      *args)
+	struct xfs_da_args		*args)
 {
-	int			error;
-	int			retval;
+	int				error;
+	struct xfs_delattr_context	dac  = {
+		.da_args	= args,
+	};
 
 	trace_xfs_attr_rmtval_remove(args);
 
@@ -685,19 +687,17 @@ xfs_attr_rmtval_remove(
 	 * Keep de-allocating extents until the remote-value region is gone.
 	 */
 	do {
-		retval = __xfs_attr_rmtval_remove(args);
-		if (retval && retval != -EAGAIN)
-			return retval;
+		error = __xfs_attr_rmtval_remove(&dac);
+		if (error != -EAGAIN)
+			break;
 
-		/*
-		 * Close out trans and start the next one in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		error = xfs_attr_trans_roll(&dac);
 		if (error)
 			return error;
-	} while (retval == -EAGAIN);
 
-	return 0;
+	} while (true);
+
+	return error;
 }
 
 /*
@@ -707,9 +707,10 @@ xfs_attr_rmtval_remove(
  */
 int
 __xfs_attr_rmtval_remove(
-	struct xfs_da_args	*args)
+	struct xfs_delattr_context	*dac)
 {
-	int			error, done;
+	struct xfs_da_args		*args = dac->da_args;
+	int				error, done;
 
 	/*
 	 * Unmap value blocks for this attr.
@@ -719,12 +720,10 @@ __xfs_attr_rmtval_remove(
 	if (error)
 		return error;
 
-	error = xfs_defer_finish(&args->trans);
-	if (error)
-		return error;
-
-	if (!done)
+	if (!done) {
+		dac->flags |= XFS_DAC_DEFER_FINISH;
 		return -EAGAIN;
+	}
 
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 9eee615..002fd30 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
+int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
 #endif /* __XFS_ATTR_REMOTE_H__ */
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index bfad669..aaa7e66 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -15,10 +15,10 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
+#include "xfs_attr.h"
 #include "xfs_attr_remote.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
-#include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_quota.h"
 #include "xfs_dir2.h"
-- 
2.7.4

