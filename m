Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1322C47247
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDDD020774
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:49:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xwxXywZ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgD3WtY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:49:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60456 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgD3WtY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:49:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMlXLd066919
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:49:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=vN5HBFVxlYNNnYWZbhaUAV4M8mcX6GbtL1TN/XY1/GA=;
 b=xwxXywZ9FBrMUfjUhVHdtvm7dXNGXH6xk1vSsB6oepRHpGEtfPZHQ8RDwxyv3CHPr1sI
 fbQMQpZki6ljQgIppdptXBt/HCYCz4On284bkvv9D/wW55961Xk+eWSj8cTNtTA0k7st
 jr7PdzTQpjF1lfniD0cKbIPA8CjAkLT6zNLvAz4sdSu2zzECWNGLiZtz7avH1E038Cek
 Xc9zg+wT1SFKoUetbK+PTr0Ce+6rJqtgxAaUJIW0rImBYfJJpA1KsivPCLcjc+5dweJU
 4Td8O+P8MN6NZ6Q/6gvPPJjzeUXga+2H17xyE7oFuSptwG53BdkGNf7oXpi48Fi/jClN kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30r7f802en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:49:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgGVA141591
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30qtg23e0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:16 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UMlGSk012934
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:16 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:15 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 42/43] xfsprogs: Add delay ready attr set routines
Date:   Thu, 30 Apr 2020 15:46:59 -0700
Message-Id: <20200430224700.4183-43-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=3 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies the attr set routines to be delay ready. This means
they no longer roll or commit transactions, but instead return -EAGAIN
to have the calling routine roll and refresh the transaction.  In this
series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
state machine like switch to keep track of where it was when EAGAIN was
returned.

Two new helper functions have been added: xfs_attr_rmtval_set_init and
xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
xfs_attr_rmtval_set, but they store the current block in the delay attr
context to allow the caller to roll the transaction between allocations.
This helps to simplify and consolidate code used by
xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
now become a simple loop to refresh the transaction until the operation
is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
removed.

Below is a state machine diagram for attr set operations. The XFS_DAS_*
states indicate places where the function would return -EAGAIN, and then
immediately resume from after being recalled by the calling function.
States marked as a "subroutine state" indicate that they belong to a
subroutine, and so the calling function needs to pass them back to that
subroutine to allow it to finish where it left off.  But they otherwise
do not have a role in the calling function other than just passing
through.

 xfs_attr_set_iter()
                 │
                 v
  ┌──────n── fork has
  │         only 1 blk?
  │              │
  │              y
  │              │
  │              v
  │     xfs_attr_leaf_try_add()
  │              │
  │              v
  │          had enough
  ├──────n──   space?
  │              │
  │              y
  │              │
  │              v
  │      XFS_DAS_FOUND_LBLK  ──┐
  │                            │
  │      XFS_DAS_FLIP_LFLAG  ──┤
  │      (subroutine state)    │
  │                            │
  │                            └─>xfs_attr_leaf_addname()
  │                                              │
  │                                              v
  │                                            was this
  │                                           a rename? ──n─┐
  │                                              │          │
  │                                              y          │
  │                                              │          │
  │                                              v          │
  │                                        flip incomplete  │
  │                                            flag         │
  │                                              │          │
  │                                              v          │
  │                                      XFS_DAS_FLIP_LFLAG │
  │                                              │          │
  │                                              v          │
  │                                            remove       │
  │                        XFS_DAS_RM_LBLK ─> old name      │
  │                                 ^            │          │
  │                                 │            v          │
  │                                 └──────y── more to      │
  │                                            remove       │
  │                                              │          │
  │                                              n          │
  │                                              │          │
  │                                              v          │
  │                                             done <──────┘
  └────> XFS_DAS_FOUND_NBLK  ──┐
         (subroutine state)    │
                               │
         XFS_DAS_ALLOC_NODE  ──┤
         (subroutine state)    │
                               │
         XFS_DAS_FLIP_NFLAG  ──┤
         (subroutine state)    │
                               │
                               └─>xfs_attr_node_addname()
                                                 │
                                                 v
                                         find space to store
                                        attr. Split if needed
                                                 │
                                                 v
                                         XFS_DAS_FOUND_NBLK
                                                 │
                                                 v
                                   ┌─────n──  need to
                                   │        alloc blks?
                                   │             │
                                   │             y
                                   │             │
                                   │             v
                                   │  ┌─>XFS_DAS_ALLOC_NODE
                                   │  │          │
                                   │  │          v
                                   │  └──y── need to alloc
                                   │         more blocks?
                                   │             │
                                   │             n
                                   │             │
                                   │             v
                                   │          was this
                                   └────────> a rename? ──n─┐
                                                 │          │
                                                 y          │
                                                 │          │
                                                 v          │
                                           flip incomplete  │
                                               flag         │
                                                 │          │
                                                 v          │
                                         XFS_DAS_FLIP_NFLAG │
                                                 │          │
                                                 v          │
                                               remove       │
                           XFS_DAS_RM_NBLK ─> old name      │
                                    ^            │          │
                                    │            v          │
                                    └──────y── more to      │
                                               remove       │
                                                 │          │
                                                 n          │
                                                 │          │
                                                 v          │
                                                done <──────┘

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c        | 371 +++++++++++++++++++++++++++++++----------------
 libxfs/xfs_attr.h        | 127 +++++++++++++++-
 libxfs/xfs_attr_remote.c | 110 ++++++++------
 libxfs/xfs_attr_remote.h |   4 +
 4 files changed, 445 insertions(+), 167 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 0aa87c2..255db9e 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -45,7 +45,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  * Internal routines when attribute list is one block.
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
+STATIC int xfs_attr_leaf_addname(struct xfs_delattr_context *dac);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 
@@ -53,12 +53,13 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
-STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
 STATIC int xfs_attr_node_removename(struct xfs_delattr_context *dac);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
+STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
 
 void
 xfs_delattr_context_init(
@@ -228,8 +229,11 @@ xfs_attr_is_shortform(
 
 /*
  * Attempts to set an attr in shortform, or converts short form to leaf form if
- * there is not enough room.  If the attr is set, the transaction is committed
- * and set to NULL.
+ * there is not enough room.  This function is meant to operate as a helper
+ * routine to the delayed attribute functions.  It returns -EAGAIN to indicate
+ * that the calling function should roll the transaction, and then proceed to
+ * add the attr in leaf form.  This subroutine does not expect to be recalled
+ * again like the other delayed attr routines do.
  */
 STATIC int
 xfs_attr_set_shortform(
@@ -237,16 +241,16 @@ xfs_attr_set_shortform(
 	struct xfs_buf		**leaf_bp)
 {
 	struct xfs_inode	*dp = args->dp;
-	int			error, error2 = 0;
+	int			error = 0;
 
 	/*
 	 * Try to add the attr to the attribute list in the inode.
 	 */
 	error = xfs_attr_try_sf_addname(dp, args);
+
+	/* Should only be 0, -EEXIST or ENOSPC */
 	if (error != -ENOSPC) {
-		error2 = xfs_trans_commit(args->trans);
-		args->trans = NULL;
-		return error ? error : error2;
+		return error;
 	}
 	/*
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
@@ -259,20 +263,13 @@ xfs_attr_set_shortform(
 	/*
 	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
 	 * push cannot grab the half-baked leaf buffer and run into problems
-	 * with the write verifier. Once we're done rolling the transaction we
-	 * can release the hold and add the attr to the leaf.
+	 * with the write verifier.
 	 */
 	xfs_trans_bhold(args->trans, *leaf_bp);
-	error = xfs_defer_finish(&args->trans);
-	xfs_trans_bhold_release(args->trans, *leaf_bp);
-	if (error) {
-		xfs_trans_brelse(args->trans, *leaf_bp);
-		return error;
-	}
-
-	return 0;
+	return -EAGAIN;
 }
 
+STATIC
 int xfs_attr_defer_finish(
 	struct xfs_delattr_context	*dac)
 {
@@ -292,60 +289,128 @@ int
 xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
-	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf          *leaf_bp = NULL;
-	int			error = 0;
+	struct xfs_buf			*leaf_bp = NULL;
+	int				error = 0;
+	struct xfs_delattr_context	dac;
+
+	xfs_delattr_context_init(&dac, args);
+
+	do {
+		error = xfs_attr_set_iter(&dac, &leaf_bp);
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
+
+		if (leaf_bp) {
+			xfs_trans_bjoin(args->trans, leaf_bp);
+			xfs_trans_bhold(args->trans, leaf_bp);
+		}
+
+	} while (true);
+
+	return error;
+}
+
+/*
+ * Set the attribute specified in @args.
+ * This routine is meant to function as a delayed operation, and may return
+ * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ * returned.
+ */
+int
+xfs_attr_set_iter(
+	struct xfs_delattr_context	*dac,
+	struct xfs_buf			**leaf_bp)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_inode		*dp = args->dp;
+	int				error = 0;
+
+	/* State machine switch */
+	switch (dac->dela_state) {
+	case XFS_DAS_FLIP_LFLAG:
+	case XFS_DAS_FOUND_LBLK:
+		goto das_leaf;
+	case XFS_DAS_FOUND_NBLK:
+	case XFS_DAS_FLIP_NFLAG:
+	case XFS_DAS_ALLOC_NODE:
+		goto das_node;
+	default:
+		break;
+	}
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
 	 * leaf handling.  Otherwise, try to add the attribute to the shortform
 	 * list; if there's no room then convert the list to leaf format and try
-	 * again.
+	 * again. No need to set state as we will be in leaf form when we come
+	 * back
 	 */
 	if (xfs_attr_is_shortform(dp)) {
 
 		/*
-		 * If the attr was successfully set in shortform, the
-		 * transaction is committed and set to NULL.  Otherwise, is it
-		 * converted from shortform to leaf, and the transaction is
-		 * retained.
+		 * If the attr was successfully set in shortform, no need to
+		 * continue.  Otherwise, is it converted from shortform to leaf
+		 * and -EAGAIN is returned.
 		 */
-		error = xfs_attr_set_shortform(args, &leaf_bp);
-		if (error || !args->trans)
-			return error;
-	}
+		error = xfs_attr_set_shortform(args, leaf_bp);
+		if (error == -EAGAIN)
+			dac->flags |= XFS_DAC_DEFER_FINISH;
 
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_addname(args);
-		if (error != -ENOSPC)
-			return error;
+		return error;
+	}
 
-		/*
-		 * Promote the attribute list to the Btree format.
-		 */
-		error = xfs_attr3_leaf_to_node(args);
-		if (error)
-			return error;
+	/*
+	 * After a shortform to leaf conversion, we need to hold the leaf and
+	 * cylce out the transaction.  When we get back, we need to release
+	 * the leaf.
+	 */
+	if (*leaf_bp != NULL) {
+		xfs_trans_bhold_release(args->trans, *leaf_bp);
+		*leaf_bp = NULL;
+	}
 
-		/*
-		 * Commit that transaction so that the node_addname()
-		 * call can manage its own transactions.
-		 */
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+		error = xfs_attr_leaf_try_add(args, *leaf_bp);
+		switch (error) {
+		case -ENOSPC:
+			/*
+			 * Promote the attribute list to the Btree format.
+			 */
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
 
-		/*
-		 * Commit the current trans (including the inode) and
-		 * start a new one.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
+			/*
+			 * Commit that transaction so that the node_addname()
+			 * call can manage its own transactions.
+			 */
+			dac->flags |= XFS_DAC_DEFER_FINISH;
+			return -EAGAIN;
+		case 0:
+			dac->dela_state = XFS_DAS_FOUND_LBLK;
+			return -EAGAIN;
+		default:
 			return error;
+		}
+das_leaf:
+		error = xfs_attr_leaf_addname(dac);
+		if (error == -ENOSPC)
+			/* We will be in node form when we return */
+			return -EAGAIN;
 
+		return error;
 	}
-
-	error = xfs_attr_node_addname(args);
+das_node:
+	error = xfs_attr_node_addname(dac);
 	return error;
 }
 
@@ -712,28 +777,30 @@ out_brelse:
  *
  * This leaf block cannot have a "remote" value, we only call this routine
  * if bmap_one_block() says there is only one block (ie: no remote blks).
+ *
+ * This routine is meant to function as a delayed operation, and may return
+ * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ * returned.
  */
 STATIC int
 xfs_attr_leaf_addname(
-	struct xfs_da_args	*args)
+	struct xfs_delattr_context	*dac)
 {
-	int			error, forkoff;
-	struct xfs_buf		*bp = NULL;
-	struct xfs_inode	*dp = args->dp;
-
-	trace_xfs_attr_leaf_addname(args);
-
-	error = xfs_attr_leaf_try_add(args, bp);
-	if (error)
-		return error;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_buf			*bp = NULL;
+	int				error, forkoff;
+	struct xfs_inode		*dp = args->dp;
 
-	/*
-	 * Commit the transaction that added the attr name so that
-	 * later routines can manage their own transactions.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		return error;
+	/* State machine switch */
+	switch (dac->dela_state) {
+	case XFS_DAS_FLIP_LFLAG:
+		goto das_flip_flag;
+	case XFS_DAS_RM_LBLK:
+		goto das_rm_lblk;
+	default:
+		break;
+	}
 
 	/*
 	 * If there was an out-of-line value, allocate the blocks we
@@ -741,12 +808,34 @@ xfs_attr_leaf_addname(
 	 * after we create the attribute so that we don't overflow the
 	 * maximum size of a transaction and/or hit a deadlock.
 	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
+
+	/* Open coded xfs_attr_rmtval_set without trans handling */
+	if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
+		dac->flags |= XFS_DAC_LEAF_ADDNAME_INIT;
+		if (args->rmtblkno > 0) {
+			error = xfs_attr_rmtval_set_init(dac);
+			if (error)
+				return error;
+		}
+	}
+
+	/*
+	 * Roll through the "value", allocating blocks on disk as
+	 * required.
+	 */
+	while (dac->blkcnt > 0) {
+		error = xfs_attr_rmtval_set_blk(dac);
 		if (error)
 			return error;
+
+		dac->flags |= XFS_DAC_DEFER_FINISH;
+		return -EAGAIN;
 	}
 
+	error = xfs_attr_rmtval_set_value(args);
+	if (error)
+		return error;
+
 	if ((args->op_flags & XFS_DA_OP_RENAME) == 0) {
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
@@ -766,29 +855,33 @@ xfs_attr_leaf_addname(
 	 * In a separate transaction, set the incomplete flag on the "old" attr
 	 * and clear the incomplete flag on the "new" attr.
 	 */
-
 	error = xfs_attr3_leaf_flipflags(args);
 	if (error)
 		return error;
 	/*
 	 * Commit the flag value change and start the next trans in series.
 	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		return error;
-
+	dac->dela_state = XFS_DAS_FLIP_LFLAG;
+	return -EAGAIN;
+das_flip_flag:
 	/*
 	 * Dismantle the "old" attribute/value pair by removing a "remote" value
 	 * (if it exists).
 	 */
 	xfs_attr_restore_rmt_blk(args);
 
+	error = xfs_attr_rmtval_invalidate(args);
+	if (error)
+		return error;
+das_rm_lblk:
 	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_invalidate(args);
-		if (error)
-			return error;
+		error = __xfs_attr_rmtval_remove(dac);
+
+		if (error == -EAGAIN) {
+			dac->dela_state = XFS_DAS_RM_LBLK;
+			return -EAGAIN;
+		}
 
-		error = xfs_attr_rmtval_remove(args);
 		if (error)
 			return error;
 	}
@@ -958,16 +1051,23 @@ xfs_attr_node_hasname(
  *
  * "Remote" attribute values confuse the issue and atomic rename operations
  * add a whole extra layer of confusion on top of that.
+ *
+ * This routine is meant to function as a delayed operation, and may return
+ * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ *returned.
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_da_args	*args)
+	struct xfs_delattr_context	*dac)
 {
-	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
-	struct xfs_inode	*dp;
-	struct xfs_mount	*mp;
-	int			retval, error;
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_state		*state = NULL;
+	struct xfs_da_state_blk		*blk;
+	struct xfs_inode		*dp;
+	struct xfs_mount		*mp;
+	int				retval = 0;
+	int				error = 0;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -976,7 +1076,21 @@ xfs_attr_node_addname(
 	 */
 	dp = args->dp;
 	mp = dp->i_mount;
-restart:
+
+	/* State machine switch */
+	switch (dac->dela_state) {
+	case XFS_DAS_FLIP_NFLAG:
+		goto das_flip_flag;
+	case XFS_DAS_FOUND_NBLK:
+		goto das_found_nblk;
+	case XFS_DAS_ALLOC_NODE:
+		goto das_alloc_node;
+	case XFS_DAS_RM_NBLK:
+		goto das_rm_nblk;
+	default:
+		break;
+	}
+
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
@@ -1022,19 +1136,13 @@ restart:
 			error = xfs_attr3_leaf_to_node(args);
 			if (error)
 				goto out;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
 
 			/*
-			 * Commit the node conversion and start the next
-			 * trans in the chain.
+			 * Restart routine from the top.  No need to set  the
+			 * state
 			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
-			if (error)
-				goto out;
-
-			goto restart;
+			dac->flags |= XFS_DAC_DEFER_FINISH;
+			return -EAGAIN;
 		}
 
 		/*
@@ -1046,9 +1154,7 @@ restart:
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
+		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1063,13 +1169,9 @@ restart:
 	xfs_da_state_free(state);
 	state = NULL;
 
-	/*
-	 * Commit the leaf addition or btree split and start the next
-	 * trans in the chain.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		goto out;
+	dac->dela_state = XFS_DAS_FOUND_NBLK;
+	return -EAGAIN;
+das_found_nblk:
 
 	/*
 	 * If there was an out-of-line value, allocate the blocks we
@@ -1078,7 +1180,27 @@ restart:
 	 * maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
+		/* Open coded xfs_attr_rmtval_set without trans handling */
+		error = xfs_attr_rmtval_set_init(dac);
+		if (error)
+			return error;
+
+		/*
+		 * Roll through the "value", allocating blocks on disk as
+		 * required.
+		 */
+das_alloc_node:
+		while (dac->blkcnt > 0) {
+			error = xfs_attr_rmtval_set_blk(dac);
+			if (error)
+				return error;
+
+			dac->flags |= XFS_DAC_DEFER_FINISH;
+			dac->dela_state = XFS_DAS_ALLOC_NODE;
+			return -EAGAIN;
+		}
+
+		error = xfs_attr_rmtval_set_value(args);
 		if (error)
 			return error;
 	}
@@ -1108,22 +1230,28 @@ restart:
 	/*
 	 * Commit the flag value change and start the next trans in series
 	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		goto out;
-
+	dac->dela_state = XFS_DAS_FLIP_NFLAG;
+	return -EAGAIN;
+das_flip_flag:
 	/*
 	 * Dismantle the "old" attribute/value pair by removing a "remote" value
 	 * (if it exists).
 	 */
 	xfs_attr_restore_rmt_blk(args);
 
+	error = xfs_attr_rmtval_invalidate(args);
+	if (error)
+		return error;
+
+das_rm_nblk:
 	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_invalidate(args);
-		if (error)
-			return error;
+		error = __xfs_attr_rmtval_remove(dac);
+
+		if (error == -EAGAIN) {
+			dac->dela_state = XFS_DAS_RM_NBLK;
+			return -EAGAIN;
+		}
 
-		error = xfs_attr_rmtval_remove(args);
 		if (error)
 			return error;
 	}
@@ -1156,9 +1284,8 @@ restart:
 		error = xfs_da3_join(state);
 		if (error)
 			goto out;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
+
+		dac->flags |= XFS_DAC_DEFER_FINISH;
 	}
 	retval = error = 0;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 0430c79..5cbefa90 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -106,6 +106,118 @@ struct xfs_attr_list_context {
  *	                                      v         │
  *	                                     done <─────┘
  *
+ *
+ * Below is a state machine diagram for attr set operations.
+ *
+ *  xfs_attr_set_iter()
+ *             │
+ *             v
+ *   ┌───n── fork has
+ *   │	    only 1 blk?
+ *   │		│
+ *   │		y
+ *   │		│
+ *   │		v
+ *   │	xfs_attr_leaf_try_add()
+ *   │		│
+ *   │		v
+ *   │	     had enough
+ *   ├───n────space?
+ *   │		│
+ *   │		y
+ *   │		│
+ *   │		v
+ *   │	XFS_DAS_FOUND_LBLK ──┐
+ *   │	                     │
+ *   │	XFS_DAS_FLIP_LFLAG ──┤
+ *   │	(subroutine state)   │
+ *   │		             │
+ *   │		             └─>xfs_attr_leaf_addname()
+ *   │		                      │
+ *   │		                      v
+ *   │		                   was this
+ *   │		                   a rename? ──n─┐
+ *   │		                      │          │
+ *   │		                      y          │
+ *   │		                      │          │
+ *   │		                      v          │
+ *   │		                flip incomplete  │
+ *   │		                    flag         │
+ *   │		                      │          │
+ *   │		                      v          │
+ *   │		              XFS_DAS_FLIP_LFLAG │
+ *   │		                      │          │
+ *   │		                      v          │
+ *   │		                    remove       │
+ *   │		XFS_DAS_RM_LBLK ─> old name      │
+ *   │		         ^            │          │
+ *   │		         │            v          │
+ *   │		         └──────y── more to      │
+ *   │		                    remove       │
+ *   │		                      │          │
+ *   │		                      n          │
+ *   │		                      │          │
+ *   │		                      v          │
+ *   │		                     done <──────┘
+ *   └──> XFS_DAS_FOUND_NBLK ──┐
+ *	  (subroutine state)   │
+ *	                       │
+ *	  XFS_DAS_ALLOC_NODE ──┤
+ *	  (subroutine state)   │
+ *	                       │
+ *	  XFS_DAS_FLIP_NFLAG ──┤
+ *	  (subroutine state)   │
+ *	                       │
+ *	                       └─>xfs_attr_node_addname()
+ *	                               │
+ *	                               v
+ *	                       find space to store
+ *	                      attr. Split if needed
+ *	                               │
+ *	                               v
+ *	                       XFS_DAS_FOUND_NBLK
+ *	                               │
+ *	                               v
+ *	                 ┌─────n──  need to
+ *	                 │        alloc blks?
+ *	                 │             │
+ *	                 │             y
+ *	                 │             │
+ *	                 │             v
+ *	                 │  ┌─>XFS_DAS_ALLOC_NODE
+ *	                 │  │          │
+ *	                 │  │          v
+ *	                 │  └──y── need to alloc
+ *	                 │         more blocks?
+ *	                 │             │
+ *	                 │             n
+ *	                 │             │
+ *	                 │             v
+ *	                 │          was this
+ *	                 └────────> a rename? ──n─┐
+ *	                               │          │
+ *	                               y          │
+ *	                               │          │
+ *	                               v          │
+ *	                         flip incomplete  │
+ *	                             flag         │
+ *	                               │          │
+ *	                               v          │
+ *	                       XFS_DAS_FLIP_NFLAG │
+ *	                               │          │
+ *	                               v          │
+ *	                             remove       │
+ *	         XFS_DAS_RM_NBLK ─> old name      │
+ *	                  ^            │          │
+ *	                  │            v          │
+ *	                  └──────y── more to      │
+ *	                             remove       │
+ *	                               │          │
+ *	                               n          │
+ *	                               │          │
+ *	                               v          │
+ *	                              done <──────┘
+ *
  */
 
 /*
@@ -120,6 +232,13 @@ struct xfs_attr_list_context {
 enum xfs_delattr_state {
 				      /* Zero is uninitalized */
 	XFS_DAS_RM_SHRINK	= 1,  /* We are shrinking the tree */
+	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
+	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
+	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
+	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
+	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
+	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
+	XFS_DAS_RM_NBLK,	      /* A rename is removing node blocks */
 };
 
 /*
@@ -127,6 +246,7 @@ enum xfs_delattr_state {
  */
 #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
 #define XFS_DAC_NODE_RMVNAME_INIT	0x02 /* xfs_attr_node_removename init */
+#define XFS_DAC_LEAF_ADDNAME_INIT	0x04 /* xfs_attr_leaf_addname init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -134,6 +254,11 @@ enum xfs_delattr_state {
 struct xfs_delattr_context {
 	struct xfs_da_args      *da_args;
 
+	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
+	struct xfs_bmbt_irec	map;
+	xfs_dablk_t		lblkno;
+	int			blkcnt;
+
 	/* Used in xfs_attr_node_removename to roll through removing blocks */
 	struct xfs_da_state     *da_state;
 	struct xfs_da_state_blk *blk;
@@ -158,10 +283,10 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac, struct xfs_buf **leaf_bp);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
-int xfs_attr_defer_finish(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index be0f34d..d17f972 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -442,7 +442,7 @@ xfs_attr_rmtval_get(
  * Find a "hole" in the attribute address space large enough for us to drop the
  * new attribute's value into
  */
-STATIC int
+int
 xfs_attr_rmt_find_hole(
 	struct xfs_da_args	*args)
 {
@@ -469,7 +469,7 @@ xfs_attr_rmt_find_hole(
 	return 0;
 }
 
-STATIC int
+int
 xfs_attr_rmtval_set_value(
 	struct xfs_da_args	*args)
 {
@@ -629,6 +629,70 @@ xfs_attr_rmtval_set(
 }
 
 /*
+ * Find a hole for the attr and store it in the delayed attr context.  This
+ * initializes the context to roll through allocating an attr extent for a
+ * delayed attr operation
+ */
+int
+xfs_attr_rmtval_set_init(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_bmbt_irec		*map = &dac->map;
+	int error;
+
+	dac->lblkno = 0;
+	dac->blkcnt = 0;
+	args->rmtblkcnt = 0;
+	args->rmtblkno = 0;
+	memset(map, 0, sizeof(struct xfs_bmbt_irec));
+
+	error = xfs_attr_rmt_find_hole(args);
+	if (error)
+		return error;
+
+	dac->blkcnt = args->rmtblkcnt;
+	dac->lblkno = args->rmtblkno;
+
+	return error;
+}
+
+/*
+ * Write one block of the value associated with an attribute into the
+ * out-of-line buffer that we have defined for it. This is similar to a subset
+ * of xfs_attr_rmtval_set, but records the current block to the delayed attr
+ * context, and leaves transaction handling to the caller.
+ */
+int
+xfs_attr_rmtval_set_blk(
+	struct xfs_delattr_context	*dac)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_bmbt_irec		*map = &dac->map;
+	int nmap;
+	int error;
+
+	nmap = 1;
+	error = xfs_bmapi_write(args->trans, dp,
+		  (xfs_fileoff_t)dac->lblkno,
+		  dac->blkcnt, XFS_BMAPI_ATTRFORK,
+		  args->total, map, &nmap);
+	if (error)
+		return error;
+
+	ASSERT(nmap == 1);
+	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
+	       (map->br_startblock != HOLESTARTBLOCK));
+
+	/* roll attribute extent map forwards */
+	dac->lblkno += map->br_blockcount;
+	dac->blkcnt -= map->br_blockcount;
+
+	return 0;
+}
+
+/*
  * Remove the value associated with an attribute by deleting the
  * out-of-line buffer that it is stored on.
  */
@@ -670,48 +734,6 @@ xfs_attr_rmtval_invalidate(
 }
 
 /*
- * Remove the value associated with an attribute by deleting the
- * out-of-line buffer that it is stored on.
- */
-int
-xfs_attr_rmtval_remove(
-	struct xfs_da_args		*args)
-{
-	struct xfs_delattr_context	dac;
-	xfs_dablk_t			lblkno;
-	int				blkcnt;
-	int				error = 0;
-	int				retval = 0;
-
-	trace_xfs_attr_rmtval_remove(args);
-	xfs_delattr_context_init(&dac, args);
-
-	/*
-	 * Keep de-allocating extents until the remote-value region is gone.
-	 */
-	lblkno = args->rmtblkno;
-	blkcnt = args->rmtblkcnt;
-	do {
-		retval = __xfs_attr_rmtval_remove(&dac);
-		if (retval && retval != EAGAIN)
-			return retval;
-
-		error = xfs_attr_defer_finish(&dac);
-		if (error)
-			break;
-
-		/*
-		 * Close out trans and start the next one in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			return error;
-	} while (retval == -EAGAIN);
-
-	return 0;
-}
-
-/*
  * Remove the value associated with an attribute by deleting the out-of-line
  * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
  * transaction and recall the function
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 351da00..51a1c91 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -15,4 +15,8 @@ int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
 int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
+int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
+int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_set_init(struct xfs_delattr_context *dac);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4

