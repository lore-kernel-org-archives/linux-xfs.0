Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF272C433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D83208C7
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:31:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zg1KcUcC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgFYXbW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:31:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50832 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgFYXbN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:31:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNTJnB153059
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:31:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=WaFA2nUT2QpN6lFs0WPiy5RrUNBIhKH+20ulL+gNaaU=;
 b=Zg1KcUcChvnDmgVfRaNL/zrAjDhRrCzMFdqQ7ORXiMdpSO06nrSA2CH+YfP7HlBsIXT8
 n+Z8JLtvNZKUUnQRTE2EdD1Gkr+MC+kZlZxJ2Ox3/njm2HTCDmK0kxV/TbRFN56mdKwB
 aHiApuVWSV63i0hIhw0To/Qu5s7axiLIUJb8IgCTNXthJk/Q/RxPTombkKv86sWEZ/b3
 hNpYwBvKQwjsi9e28fcxBk+ADG1oOKrpndWshhnF4G4AQCpOUb96Z7hzDioGjqUMxWiN
 TDpuXTEtloF1bB2OSZEl5X72dMBQ7358TR6xzuOURc19mOvqQzBj+gO2yHsF66AKEsvw 9w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31uusu3af4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:31:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSIDx110944
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31uur9r3qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:08 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PNT7d2015785
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:07 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:29:07 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 24/26] xfsprogs: Add delay ready attr remove routines
Date:   Thu, 25 Jun 2020 16:28:46 -0700
Message-Id: <20200625232848.14465-25-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625232848.14465-1-allison.henderson@oracle.com>
References: <20200625232848.14465-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
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
values across multiple function recalls.  See xfs_attr.h for a more
detailed diagram of the states.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 include/libxfs.h         |   1 +
 libxfs/xfs_attr.c        | 155 +++++++++++++++++++++++++++++++++++------------
 libxfs/xfs_attr.h        |  73 ++++++++++++++++++++++
 libxfs/xfs_attr_leaf.c   |   2 +-
 libxfs/xfs_attr_remote.c |  40 +++++-------
 libxfs/xfs_attr_remote.h |   2 +-
 6 files changed, 208 insertions(+), 65 deletions(-)

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
index 6827440..cab637d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -53,7 +53,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
-STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_removename(struct xfs_delattr_context *dac);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -264,6 +264,32 @@ xfs_attr_set_shortform(
 }
 
 /*
+ * Checks to see if a delayed attribute transaction should be rolled.  If so,
+ * also checks for a defer finish.  Transaction is finished and rolled as
+ * needed, and returns true of false if the delayed operation should continue.
+ */
+bool
+xfs_attr_roll_again(
+	struct xfs_delattr_context	*dac,
+	int				*error)
+{
+	struct xfs_da_args		*args = dac->da_args;
+
+	if (*error != -EAGAIN)
+		return false;
+
+	if (dac->flags & XFS_DAC_DEFER_FINISH) {
+		dac->flags &= ~XFS_DAC_DEFER_FINISH;
+		*error = xfs_defer_finish(&args->trans);
+		if (*error)
+			return false;
+	}
+
+	*error = xfs_trans_roll_inode(&args->trans, args->dp);
+	return *error == 0;
+}
+
+/*
  * Set the attribute specified in @args.
  */
 int
@@ -364,23 +390,47 @@ xfs_has_attr(
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
+	} while (xfs_attr_roll_again(&dac, &error));
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
@@ -1177,11 +1227,12 @@ xfs_attr_leaf_mark_incomplete(
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
@@ -1191,6 +1242,13 @@ int xfs_attr_node_removename_setup(
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
@@ -1203,13 +1261,16 @@ int xfs_attr_node_removename_setup(
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
 
@@ -1226,21 +1287,35 @@ xfs_attr_node_remove_rmt(
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
@@ -1248,8 +1323,13 @@ xfs_attr_node_removename(
 	 * overflow the maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_node_remove_rmt(args, state);
-		if (error)
+		/*
+		 * May return -EAGAIN. Remove blocks until args->rmtblkno == 0
+		 */
+		error = xfs_attr_node_remove_rmt(dac, state);
+		if (error == -EAGAIN)
+			return error;
+		else if (error)
 			goto out;
 	}
 
@@ -1268,17 +1348,14 @@ xfs_attr_node_removename(
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
index 66575b8..5eb203f 100644
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
+bool xfs_attr_roll_again(struct xfs_delattr_context *dac, int *error);
 bool xfs_attr_namecheck(const void *name, size_t length);
+void xfs_delattr_context_init(struct xfs_delattr_context *dac,
+			      struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 15946f3..97877b2 100644
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
index 07b7193..9b75cad 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -675,12 +675,14 @@ xfs_attr_rmtval_invalidate(
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
+	xfs_dablk_t			lblkno;
+	int				blkcnt;
+	int				error = 0;
+	struct xfs_delattr_context	dac  = {
+		.da_args	= args,
+	};
 
 	trace_xfs_attr_rmtval_remove(args);
 
@@ -690,19 +692,10 @@ xfs_attr_rmtval_remove(
 	lblkno = args->rmtblkno;
 	blkcnt = args->rmtblkcnt;
 	do {
-		retval = __xfs_attr_rmtval_remove(args);
-		if (retval && retval != EAGAIN)
-			return retval;
-
-		/*
-		 * Close out trans and start the next one in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			return error;
-	} while (retval == -EAGAIN);
+		error = __xfs_attr_rmtval_remove(&dac);
+	} while (xfs_attr_roll_again(&dac, &error));
 
-	return 0;
+	return error;
 }
 
 /*
@@ -712,9 +705,10 @@ xfs_attr_rmtval_remove(
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
@@ -724,12 +718,10 @@ __xfs_attr_rmtval_remove(
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

