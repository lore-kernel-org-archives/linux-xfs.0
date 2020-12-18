Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28114C3526C
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFD6D23A79
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732892AbgLRHaI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:30:08 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36432 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732853AbgLRHaI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:30:08 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7KRsF001615
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=f1BT3r6Sore3n75YfWKclkzwEP66N9iyASpQezcJNXs=;
 b=r93o7wi23ZyT4GtpOqg9Rm+KFhCqxmQy5YGGLPc+iugLvWDkkAWu8cy+2QZZ8iIr8MdX
 ItJ2W6jEDC9Fza1x/XZLYcDG9j3P94nWP9QH7NSHsWILvP3N1jmwJDiJKJ3zfp48K6LB
 icszYVly0chTgJU+O9uAnblGY/RpshwbWYtjNAThHQZuwErN8snD/fgANvuaNWUHoaZb
 KhilAG4k7ACyJnA/vSEt4CTPjtzN6u83x1ZVKLdJBXX+WJreOx48EEeixg5iL+RppGa4
 DPQ5KAsrMFNhgvizODs5ioAWMR7xFwH4w+30jz3ynICULZtKxQTb4qQsTA/n2HSIfWyZ +w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35ckcbs6q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7LJFG120947
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35e6eud9s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:26 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BI7TPMm004230
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:25 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:29:25 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 12/15] xfs: Remove unused xfs_attr_*_args
Date:   Fri, 18 Dec 2020 00:29:14 -0700
Message-Id: <20201218072917.16805-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218072917.16805-1-allison.henderson@oracle.com>
References: <20201218072917.16805-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180052
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
These high level loops are now driven by the delayed operations code,
and can be removed.

Additionally collapse in the leaf_bp parameter of xfs_attr_set_iter
since we only have one caller that passes dac->leaf_bp

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 96 ++---------------------------------------
 fs/xfs/libxfs/xfs_attr.h        | 10 ++---
 fs/xfs/libxfs/xfs_attr_remote.c |  1 -
 fs/xfs/xfs_attr_item.c          |  8 ++--
 4 files changed, 9 insertions(+), 106 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 85b63bb..6e5a900 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -268,60 +268,6 @@ xfs_attr_set_shortform(
 }
 
 /*
- * Checks to see if a delayed attribute transaction should be rolled.  If so,
- * also checks for a defer finish.  Transaction is finished and rolled as
- * needed, and returns true of false if the delayed operation should continue.
- */
-STATIC int
-xfs_attr_trans_roll(
-	struct xfs_delattr_context	*dac)
-{
-	struct xfs_da_args		*args = dac->da_args;
-	int				error;
-
-	if (dac->flags & XFS_DAC_DEFER_FINISH) {
-		/*
-		 * The caller wants us to finish all the deferred ops so that we
-		 * avoid pinning the log tail with a large number of deferred
-		 * ops.
-		 */
-		dac->flags &= ~XFS_DAC_DEFER_FINISH;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-	} else
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-
-	return error;
-}
-
-/*
- * Set the attribute specified in @args.
- */
-int
-xfs_attr_set_args(
-	struct xfs_da_args	*args)
-{
-	struct xfs_buf			*leaf_bp = NULL;
-	int				error = 0;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_set_iter(&dac, &leaf_bp);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-	} while (true);
-
-	return error;
-}
-
-/*
  * Set the attribute specified in @args.
  * This routine is meant to function as a delayed operation, and may return
  * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
@@ -330,11 +276,11 @@ xfs_attr_set_args(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
+	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
 	int				error = 0;
 
 	/* State machine switch */
@@ -368,11 +314,7 @@ xfs_attr_set_iter(
 		 * continue.  Otherwise, is it converted from shortform to leaf
 		 * and -EAGAIN is returned.
 		 */
-		error = xfs_attr_set_shortform(args, leaf_bp);
-		if (error == -EAGAIN)
-			dac->flags |= XFS_DAC_DEFER_FINISH;
-
-		return error;
+		return xfs_attr_set_shortform(args, leaf_bp);
 	}
 
 	/*
@@ -409,7 +351,6 @@ xfs_attr_set_iter(
 		 * when we come back, we'll be a node, so we'll fall
 		 * down into the node handling code below
 		 */
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		trace_xfs_das_state_return(dac->dela_state);
 		return -EAGAIN;
 	case 0:
@@ -453,32 +394,6 @@ xfs_has_attr(
 
 /*
  * Remove the attribute specified in @args.
- */
-int
-xfs_attr_remove_args(
-	struct xfs_da_args	*args)
-{
-	int				error;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_remove_iter(&dac);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-
-	} while (true);
-
-	return error;
-}
-
-/*
- * Remove the attribute specified in @args.
  *
  * This function may return -EAGAIN to signal that the transaction needs to be
  * rolled.  Callers should continue calling this function until they receive a
@@ -897,7 +812,6 @@ xfs_attr_leaf_addname(
 		if (error)
 			return error;
 
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		trace_xfs_das_state_return(dac->dela_state);
 		return -EAGAIN;
 	}
@@ -1205,7 +1119,6 @@ xfs_attr_node_addname(
 			 * this. dela_state is still unset by this function at
 			 * this point.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_das_state_return(dac->dela_state);
 			return -EAGAIN;
 		}
@@ -1219,7 +1132,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1267,7 +1179,6 @@ xfs_attr_node_addname(
 			if (error)
 				return error;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_das_state_return(dac->dela_state);
 			return -EAGAIN;
 		}
@@ -1587,7 +1498,6 @@ xfs_attr_node_removename_iter(
 			if (error)
 				return error;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_das_state_return(dac->dela_state);
 			return -EAGAIN;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 5d3aa0c..4838094 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -387,9 +387,8 @@ enum xfs_delattr_state {
 /*
  * Defines for xfs_delattr_context.flags
  */
-#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
-#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
-#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
+#define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
+#define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -446,11 +445,8 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-		      struct xfs_buf **leaf_bp);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac);
 int xfs_has_attr(struct xfs_da_args *args);
-int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 25639c0..a5ff5e0 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -762,7 +762,6 @@ xfs_attr_rmtval_remove(
 	 * by the parent
 	 */
 	if (!done) {
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		trace_xfs_das_state_return(dac->dela_state);
 		return -EAGAIN;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index c3b94a7..3185350 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -291,7 +291,6 @@ int
 xfs_trans_attr(
 	struct xfs_delattr_context	*dac,
 	struct xfs_attrd_log_item	*attrdp,
-	struct xfs_buf			**leaf_bp,
 	uint32_t			op_flags)
 {
 	struct xfs_da_args		*args = dac->da_args;
@@ -304,7 +303,7 @@ xfs_trans_attr(
 	switch (op_flags) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		error = xfs_attr_set_iter(dac, leaf_bp);
+		error = xfs_attr_set_iter(dac);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
@@ -428,8 +427,7 @@ xfs_attr_finish_item(
 	 */
 	dac->da_args->trans = tp;
 
-	error = xfs_trans_attr(dac, done_item, &dac->leaf_bp,
-			       attr->xattri_op_flags);
+	error = xfs_trans_attr(dac, done_item, attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
@@ -625,7 +623,7 @@ xfs_attri_item_recover(
 	xfs_trans_ijoin(args.trans, ip, 0);
 
 	error = xfs_trans_attr(&attr.xattri_dac, done_item,
-			       &attr.xattri_dac.leaf_bp, attrp->alfi_op_flags);
+			       attrp->alfi_op_flags);
 	if (error == -EAGAIN) {
 		/*
 		 * There's more work to do, so make a new xfs_attr_item and add
-- 
2.7.4

