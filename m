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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698CAC3526E
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3928823A7C
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732960AbgLRH0x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:26:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55206 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732952AbgLRH0w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:26:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7Jwix122123
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=B7SIQqraM3rK8RMXLGNy1Ijea4eHOoaudtBeIQtxxT0=;
 b=Xtvei6yT8He+nvB7BSiQwGSoFHd4r2LN828lI1Xp1bpYgpMtGcZpY0ltjXMGzTNLe8El
 2znErGy5QHvhk2Twz9XmCgnSuU9TY7znowbMptDYigaBoAHl9S/C5zBr5O3EzpxGeWqV
 R7JC4uIgcP9O9RW6aKJKD/BPmA/xIFAGKVOXQnrnL2GigZTU5FDbO9rhrHcsXqs2X6Hm
 Xow64Xb31ofHzVT/WfGsVmTLVNxSTh0rTOf851uOE2caUvHQCWBE+VYvZg2YtzN7ob5s
 P1jjYnl3ftr5Wb2dZPGhtjbT6YPXC0EWJhDRXzF+UluLjPdxvxq1qgBUH5XOlftkng3e kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35cntmgy32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7LJVl119564
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35g3rft1w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:10 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BI7Q9bn002117
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:09 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:26:08 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 11/14] xfsprogs: Remove unused xfs_attr_*_args
Date:   Fri, 18 Dec 2020 00:25:52 -0700
Message-Id: <20201218072555.16694-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218072555.16694-1-allison.henderson@oracle.com>
References: <20201218072555.16694-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
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
 libxfs/defer_item.c      |  6 +--
 libxfs/xfs_attr.c        | 96 ++----------------------------------------------
 libxfs/xfs_attr.h        | 10 ++---
 libxfs/xfs_attr_remote.c |  1 -
 4 files changed, 8 insertions(+), 105 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index ab21173..054d158 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -131,7 +131,6 @@ int
 xfs_trans_attr(
 	struct xfs_delattr_context	*dac,
 	struct xfs_attrd_log_item	*attrdp,
-	struct xfs_buf			**leaf_bp,
 	uint32_t			op_flags)
 {
 	struct xfs_da_args		*args = dac->da_args;
@@ -144,7 +143,7 @@ xfs_trans_attr(
 	switch (op_flags) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		error = xfs_attr_set_iter(dac, leaf_bp);
+		error = xfs_attr_set_iter(dac);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q((args->dp)));
@@ -216,8 +215,7 @@ xfs_attr_finish_item(
 	 */
 	dac->da_args->trans = tp;
 
-	error = xfs_trans_attr(dac, ATTRD_ITEM(done), &dac->leaf_bp,
-			       attr->xattri_op_flags);
+	error = xfs_trans_attr(dac, ATTRD_ITEM(done), attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index dc0e44c..89f0ffd 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -267,60 +267,6 @@ xfs_attr_set_shortform(
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
@@ -329,11 +275,11 @@ xfs_attr_set_args(
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
@@ -367,11 +313,7 @@ xfs_attr_set_iter(
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
@@ -408,7 +350,6 @@ xfs_attr_set_iter(
 		 * when we come back, we'll be a node, so we'll fall
 		 * down into the node handling code below
 		 */
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		trace_xfs_das_state_return(dac->dela_state);
 		return -EAGAIN;
 	case 0:
@@ -452,32 +393,6 @@ xfs_has_attr(
 
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
@@ -896,7 +811,6 @@ xfs_attr_leaf_addname(
 		if (error)
 			return error;
 
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		trace_xfs_das_state_return(dac->dela_state);
 		return -EAGAIN;
 	}
@@ -1204,7 +1118,6 @@ xfs_attr_node_addname(
 			 * this. dela_state is still unset by this function at
 			 * this point.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_das_state_return(dac->dela_state);
 			return -EAGAIN;
 		}
@@ -1218,7 +1131,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1266,7 +1178,6 @@ das_alloc_node:
 			if (error)
 				return error;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_das_state_return(dac->dela_state);
 			return -EAGAIN;
 		}
@@ -1586,7 +1497,6 @@ xfs_attr_node_removename_iter(
 			if (error)
 				return error;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_das_state_return(dac->dela_state);
 			return -EAGAIN;
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 5d3aa0c..4838094 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
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
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index d08d8a4..1635e85 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -761,7 +761,6 @@ xfs_attr_rmtval_remove(
 	 * by the parent
 	 */
 	if (!done) {
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		trace_xfs_das_state_return(dac->dela_state);
 		return -EAGAIN;
 	}
-- 
2.7.4

