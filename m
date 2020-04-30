Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C430FC4725B
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 940B42074A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BNzADr3v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgD3WrW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:47:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48524 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbgD3WrV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:47:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhYYq047418
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=m/1nSXlMW8w7A1al2HPe6GiHzMfvf762uD1a6NIvN4Q=;
 b=BNzADr3vqtTqPKK3tjKkzgIKUcQ0gN/NoZbyb3fu3XHXzUlO7VEAhGOCouJSP9m0KFrc
 3KYmJ8rZyCr46cdG/+XXrvYiyK7y/C76CjzC3tyrQr4U3JyF3B4/gPzWVtrStPAxStnd
 eVV/L10zsgUznevZUtWUhpfAC62sasuYXEKxHH+TlAQzknKwi9fS7DRDzWfE1HyIPeMf
 k2gX86hyoMTatLibMXzRUtfztA2TeD/XLzj+124HCSEKG3qjycXOIKxWMTQ8qloB22I0
 Pw4nfKNlAnQbhewze1U+fFeUDtg6k+0Sk/7Dc7tXI6uZEsmuulOTpVXjgAXf3SSa5z54 Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30r7f5r27c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgtJt076902
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30r7f8a0br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:17 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UMlFRR012931
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:16 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:15 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 41/43] xfsprogs: Add delay ready attr remove routines
Date:   Thu, 30 Apr 2020 15:46:58 -0700
Message-Id: <20200430224700.4183-42-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 impostorscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
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
is completed. A new XFS_DAC_DEFER_FINISH flag is used to finish the
transaction where ever the existing code used to.

Calls to xfs_attr_rmtval_remove are replaced with the delay ready
version __xfs_attr_rmtval_remove. We will rename
__xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
done.

xfs_attr_rmtval_remove itself is still in use by the set routines (used
during a rename).  For reasons of perserving existing function, we
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
values across multiple function recalls.

Below is a state machine diagram for attr remove operations. The
XFS_DAS_* states indicate places where the function would return
-EAGAIN, and then immediately resume from after being recalled by the
calling function.  States marked as a "subroutine state" indicate that
they belong to a subroutine, and so the calling function needs to pass
them back to that subroutine to allow it to finish where it left off.
But they otherwise do not have a role in the calling function other than
just passing through.

 xfs_attr_remove_iter()
         XFS_DAS_RM_SHRINK     ─┐
         (subroutine state)     │
                                └─>xfs_attr_node_removename()
                                                 │
                                                 v
                                              need to
                                           shrink tree? ─n─┐
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
 include/libxfs.h         |   1 +
 libxfs/xfs_attr.c        | 161 +++++++++++++++++++++++++++++++++++------------
 libxfs/xfs_attr.h        |  73 +++++++++++++++++++++
 libxfs/xfs_attr_leaf.c   |   2 +-
 libxfs/xfs_attr_remote.c |  31 +++++----
 libxfs/xfs_attr_remote.h |   2 +-
 6 files changed, 216 insertions(+), 54 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 1244783..33ec7f1 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -169,6 +169,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #include "xfs_ialloc.h"
 
 #include "xfs_attr_leaf.h"
+#include "xfs_attr.h"
 #include "xfs_attr_remote.h"
 #include "xfs_trans_space.h"
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 5e4013c3..0aa87c2 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -54,12 +54,21 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
-STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_removename(struct xfs_delattr_context *dac);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
+void
+xfs_delattr_context_init(
+	struct xfs_delattr_context	*dac,
+	struct xfs_da_args		*args)
+{
+	memset(dac, 0, sizeof(struct xfs_delattr_context));
+	dac->da_args = args;
+}
+
 int
 xfs_inode_hasattr(
 	struct xfs_inode	*ip)
@@ -264,6 +273,18 @@ xfs_attr_set_shortform(
 	return 0;
 }
 
+int xfs_attr_defer_finish(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+
+	if (!(dac->flags & XFS_DAC_DEFER_FINISH))
+		return 0;
+
+	dac->flags &= ~XFS_DAC_DEFER_FINISH;
+	return xfs_defer_finish(&args->trans);
+}
+
 /*
  * Set the attribute specified in @args.
  */
@@ -364,23 +385,57 @@ xfs_has_attr(
  */
 int
 xfs_attr_remove_args(
-	struct xfs_da_args      *args)
+	struct xfs_da_args	*args)
 {
-	struct xfs_inode	*dp = args->dp;
-	int			error;
+	int			error = 0;
+	struct			xfs_delattr_context dac;
+
+	xfs_delattr_context_init(&dac, args);
+
+	do {
+		error = xfs_attr_remove_iter(&dac);
+		if (error != -EAGAIN)
+			break;
+
+		error = xfs_attr_defer_finish(&dac);
+		if (error)
+			break;
+
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (error)
+			break;
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
 	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
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
+	return  xfs_attr_node_removename(dac);
 }
 
 /*
@@ -1178,15 +1233,17 @@ xfs_attr_leaf_mark_incomplete(
 
 /*
  * Initial setup for xfs_attr_node_removename.  Make sure the attr is there and
- * the blocks are valid.  Any remote blocks will be marked incomplete.
+ * the blocks are valid.  Any remote blocks will be marked incomplete and
+ * invalidated.
  */
 STATIC
 int xfs_attr_node_removename_setup(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	**state)
+	struct xfs_delattr_context	*dac,
+	struct xfs_da_state		**state)
 {
-	int			error;
-	struct xfs_da_state_blk	*blk;
+	struct xfs_da_args		*args = dac->da_args;
+	int				error;
+	struct xfs_da_state_blk		*blk;
 
 	error = xfs_attr_node_hasname(args, state);
 	if (error != -EEXIST)
@@ -1196,6 +1253,13 @@ int xfs_attr_node_removename_setup(
 	ASSERT(blk->bp != NULL);
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
+	/*
+	 * Store blk and state in the context incase we need to cycle out the
+	 * transaction
+	 */
+	dac->blk = blk;
+	dac->da_state = *state;
+
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_leaf_mark_incomplete(args, *state);
 		if (error)
@@ -1211,12 +1275,15 @@ int xfs_attr_node_removename_setup(
 
 STATIC int
 xfs_attr_node_removename_rmt (
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
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
 
@@ -1233,21 +1300,35 @@ xfs_attr_node_removename_rmt (
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
-	struct xfs_da_args	*args)
+	struct xfs_delattr_context	*dac)
 {
-	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
-	int			retval, error;
-	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		*state;
+	struct xfs_da_state_blk		*blk;
+	int				retval, error;
+	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
+	state = dac->da_state;
+	blk = dac->blk;
 
-	error = xfs_attr_node_removename_setup(args, &state);
-	if (error)
-		goto out;
+	if (dac->dela_state == XFS_DAS_RM_SHRINK)
+		goto das_rm_shrink;
+
+	if ((dac->flags & XFS_DAC_NODE_RMVNAME_INIT) == 0) {
+		dac->flags |= XFS_DAC_NODE_RMVNAME_INIT;
+		error = xfs_attr_node_removename_setup(dac, &state);
+		if (error)
+			goto out;
+	}
 
 	/*
 	 * If there is an out-of-line value, de-allocate the blocks.
@@ -1255,8 +1336,13 @@ xfs_attr_node_removename(
 	 * overflow the maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_node_removename_rmt(args, state);
-		if (error)
+		/*
+		 * May return -EAGAIN. Remove blocks until args->rmtblkno == 0
+		 */
+		error = xfs_attr_node_removename_rmt(dac, state);
+		if (error == -EAGAIN)
+			return error;
+		else if (error)
 			goto out;
 	}
 
@@ -1275,17 +1361,14 @@ xfs_attr_node_removename(
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
+		dac->flags |= XFS_DAC_DEFER_FINISH;
+		dac->dela_state = XFS_DAS_RM_SHRINK;
+		return -EAGAIN;
 	}
 
+das_rm_shrink:
+
 	/*
 	 * If the result is small enough, push it all into the inode.
 	 */
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 66575b8..0430c79 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -74,6 +74,75 @@ struct xfs_attr_list_context {
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
+				      /* Zero is uninitalized */
+	XFS_DAS_RM_SHRINK	= 1,  /* We are shrinking the tree */
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
+	struct xfs_da_state_blk *blk;
+
+	/* Used to keep track of current state of delayed operation */
+	unsigned int            flags;
+	enum xfs_delattr_state  dela_state;
+};
+
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
@@ -91,6 +160,10 @@ int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_defer_finish(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
+void xfs_delattr_context_init(struct xfs_delattr_context *dac,
+			      struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index e3f8457..22e565cc 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -19,8 +19,8 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_attr_sf.h"
-#include "xfs_attr_remote.h"
 #include "xfs_attr.h"
+#include "xfs_attr_remote.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_trace.h"
 #include "xfs_dir2.h"
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 7765ee9..be0f34d 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -675,14 +675,16 @@ xfs_attr_rmtval_invalidate(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_da_args      *args)
+	struct xfs_da_args		*args)
 {
-	xfs_dablk_t		lblkno;
-	int			blkcnt;
-	int			error = 0;
-	int			retval = 0;
+	struct xfs_delattr_context	dac;
+	xfs_dablk_t			lblkno;
+	int				blkcnt;
+	int				error = 0;
+	int				retval = 0;
 
 	trace_xfs_attr_rmtval_remove(args);
+	xfs_delattr_context_init(&dac, args);
 
 	/*
 	 * Keep de-allocating extents until the remote-value region is gone.
@@ -690,10 +692,14 @@ xfs_attr_rmtval_remove(
 	lblkno = args->rmtblkno;
 	blkcnt = args->rmtblkcnt;
 	do {
-		retval = __xfs_attr_rmtval_remove(args);
+		retval = __xfs_attr_rmtval_remove(&dac);
 		if (retval && retval != EAGAIN)
 			return retval;
 
+		error = xfs_attr_defer_finish(&dac);
+		if (error)
+			break;
+
 		/*
 		 * Close out trans and start the next one in the chain.
 		 */
@@ -712,9 +718,10 @@ xfs_attr_rmtval_remove(
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
@@ -724,12 +731,10 @@ __xfs_attr_rmtval_remove(
 	if (error)
 		return error;
 
-	error = xfs_defer_finish(&args->trans);
-	if (error)
-		return error;
-
-	if (!done)
+	if (!done) {
+		dac->flags &= ~XFS_DAC_DEFER_FINISH;
 		return -EAGAIN;
+	}
 
 	return error;
 }
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index ee3337b..351da00 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
+int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4

