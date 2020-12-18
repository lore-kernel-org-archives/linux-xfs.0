Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A205C3526F
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EA8623A79
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732956AbgLRH0z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:26:55 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33602 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732959AbgLRH0y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:26:54 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7Jm4d000759
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=RPpjj6xY7D71F078BvmqbotzF0ROuElSNwQZVDxu8ck=;
 b=EDbFvp+gMEvfm7aAoHxRscjOMiHNq4roRlp081VnyIoB8P51ZF4MzGqSZZtm80gGMZLQ
 hHSAu2g8A+GtTwTVj/WtISKD3UQTe1TjwzXuX+AuUL4xcpGr+DYw+udMrd4Jm26KF3kM
 OlO76FTDccIXyoLRFGxtWJyufXy8S3ClY9PaS9t31cqeugI1mpxMn1FUrAQBm/+r7u6x
 w367D1j1j2n8MW3kO2HNqT2dinLeXkr8ZMGRpj3/ovZfq3kjELPzfe9Rjl1zA43R/oWG
 EMZ56k8uUKw5VNVVQR61CjxLrGs4/kL1eApc6dB3Njtr7k7gfBZJFe/OmKOgJeXNRtTE 3A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcbs6fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7LL2C044534
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35d7erys92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:11 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BI7QAHH020817
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:10 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:26:10 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 13/14] xfsprogs: Merge xfs_delattr_context into xfs_attr_item
Date:   Fri, 18 Dec 2020 00:25:54 -0700
Message-Id: <20201218072555.16694-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218072555.16694-1-allison.henderson@oracle.com>
References: <20201218072555.16694-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
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

This is a clean up patch that merges xfs_delattr_context into
xfs_attr_item.  Now that the refactoring is complete and the delayed
operation infastructure is in place, we can combine these to eliminate
the extra struct

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/defer_item.c      |  14 +++--
 libxfs/xfs_attr.c        | 138 +++++++++++++++++++++++------------------------
 libxfs/xfs_attr.h        |  40 ++++++--------
 libxfs/xfs_attr_remote.c |  34 ++++++------
 libxfs/xfs_attr_remote.h |   6 +--
 5 files changed, 112 insertions(+), 120 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 054d158..04a7534 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -129,11 +129,11 @@ static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
  */
 int
 xfs_trans_attr(
-	struct xfs_delattr_context	*dac,
+	struct xfs_attr_item		*attr,
 	struct xfs_attrd_log_item	*attrdp,
 	uint32_t			op_flags)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				error;
 
 	error = xfs_qm_dqattach_locked(args->dp, 0);
@@ -143,11 +143,11 @@ xfs_trans_attr(
 	switch (op_flags) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		error = xfs_attr_set_iter(dac);
+		error = xfs_attr_set_iter(attr);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q((args->dp)));
-		error = xfs_attr_remove_iter(dac);
+		error = xfs_attr_remove_iter(attr);
 		break;
 	default:
 		error = -EFSCORRUPTED;
@@ -204,18 +204,16 @@ xfs_attr_finish_item(
 {
 	struct xfs_attr_item		*attr;
 	int				error;
-	struct xfs_delattr_context      *dac;
 
 	attr = container_of(item, struct xfs_attr_item, xattri_list);
-	dac = &attr->xattri_dac;
 
 	/*
 	 * Always reset trans after EAGAIN cycle
 	 * since the transaction is new
 	 */
-	dac->da_args->trans = tp;
+	attr->xattri_da_args->trans = tp;
 
-	error = xfs_trans_attr(dac, ATTRD_ITEM(done), attr->xattri_op_flags);
+	error = xfs_trans_attr(attr, ATTRD_ITEM(done), attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 89f0ffd..483d03c 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -45,7 +45,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  * Internal routines when attribute list is one block.
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_addname(struct xfs_delattr_context *dac);
+STATIC int xfs_attr_leaf_addname(struct xfs_attr_item *attr);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 
@@ -53,8 +53,8 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
-STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
-STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
+STATIC int xfs_attr_node_addname(struct xfs_attr_item *attr);
+STATIC int xfs_attr_node_removename_iter(struct xfs_attr_item *attr);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -275,27 +275,27 @@ xfs_attr_set_shortform(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
-	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
+	struct xfs_buf			**leaf_bp = &attr->xattri_leaf_bp;
 	int				error = 0;
 
 	/* State machine switch */
-	switch (dac->dela_state) {
+	switch (attr->xattri_dela_state) {
 	case XFS_DAS_FLIP_LFLAG:
 	case XFS_DAS_FOUND_LBLK:
 	case XFS_DAS_RM_LBLK:
-		return xfs_attr_leaf_addname(dac);
+		return xfs_attr_leaf_addname(attr);
 	case XFS_DAS_FOUND_NBLK:
 	case XFS_DAS_FLIP_NFLAG:
 	case XFS_DAS_ALLOC_NODE:
-		return xfs_attr_node_addname(dac);
+		return xfs_attr_node_addname(attr);
 	case XFS_DAS_UNINIT:
 		break;
 	default:
-		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
+		ASSERT(attr->xattri_dela_state != XFS_DAS_RM_SHRINK);
 		break;
 	}
 
@@ -327,7 +327,7 @@ xfs_attr_set_iter(
 	}
 
 	if (!xfs_bmap_one_block(dp, XFS_ATTR_FORK))
-		return xfs_attr_node_addname(dac);
+		return xfs_attr_node_addname(attr);
 
 	error = xfs_attr_leaf_try_add(args, *leaf_bp);
 	switch (error) {
@@ -350,11 +350,11 @@ xfs_attr_set_iter(
 		 * when we come back, we'll be a node, so we'll fall
 		 * down into the node handling code below
 		 */
-		trace_xfs_das_state_return(dac->dela_state);
+		trace_xfs_das_state_return(attr->xattri_dela_state);
 		return -EAGAIN;
 	case 0:
-		dac->dela_state = XFS_DAS_FOUND_LBLK;
-		trace_xfs_das_state_return(dac->dela_state);
+		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
+		trace_xfs_das_state_return(attr->xattri_dela_state);
 		return -EAGAIN;
 	}
 	return error;
@@ -400,13 +400,13 @@ xfs_has_attr(
  */
 int
 xfs_attr_remove_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
 
 	/* If we are shrinking a node, resume shrink */
-	if (dac->dela_state == XFS_DAS_RM_SHRINK)
+	if (attr->xattri_dela_state == XFS_DAS_RM_SHRINK)
 		goto node;
 
 	if (!xfs_inode_hasattr(dp))
@@ -421,7 +421,7 @@ xfs_attr_remove_iter(
 		return xfs_attr_leaf_removename(args);
 node:
 	/* If we are not short form or leaf, then proceed to remove node */
-	return  xfs_attr_node_removename_iter(dac);
+	return  xfs_attr_node_removename_iter(attr);
 }
 
 /*
@@ -572,7 +572,7 @@ xfs_attr_item_init(
 
 	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
 	new->xattri_op_flags = op_flags;
-	new->xattri_dac.da_args = args;
+	new->xattri_da_args = args;
 
 	*attr = new;
 	return 0;
@@ -767,16 +767,16 @@ out_brelse:
  */
 STATIC int
 xfs_attr_leaf_addname(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_buf			*bp = NULL;
 	int				error, forkoff;
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
-	switch (dac->dela_state) {
+	switch (attr->xattri_dela_state) {
 	case XFS_DAS_FLIP_LFLAG:
 		goto das_flip_flag;
 	case XFS_DAS_RM_LBLK:
@@ -793,10 +793,10 @@ xfs_attr_leaf_addname(
 	 */
 
 	/* Open coded xfs_attr_rmtval_set without trans handling */
-	if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
-		dac->flags |= XFS_DAC_LEAF_ADDNAME_INIT;
+	if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
+		attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
 		if (args->rmtblkno > 0) {
-			error = xfs_attr_rmtval_find_space(dac);
+			error = xfs_attr_rmtval_find_space(attr);
 			if (error)
 				return error;
 		}
@@ -806,12 +806,12 @@ xfs_attr_leaf_addname(
 	 * Roll through the "value", allocating blocks on disk as
 	 * required.
 	 */
-	if (dac->blkcnt > 0) {
-		error = xfs_attr_rmtval_set_blk(dac);
+	if (attr->xattri_blkcnt > 0) {
+		error = xfs_attr_rmtval_set_blk(attr);
 		if (error)
 			return error;
 
-		trace_xfs_das_state_return(dac->dela_state);
+		trace_xfs_das_state_return(attr->xattri_dela_state);
 		return -EAGAIN;
 	}
 
@@ -845,8 +845,8 @@ xfs_attr_leaf_addname(
 		/*
 		 * Commit the flag value change and start the next trans in series.
 		 */
-		dac->dela_state = XFS_DAS_FLIP_LFLAG;
-		trace_xfs_das_state_return(dac->dela_state);
+		attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
+		trace_xfs_das_state_return(attr->xattri_dela_state);
 		return -EAGAIN;
 	}
 das_flip_flag:
@@ -861,12 +861,12 @@ das_flip_flag:
 		return error;
 
 	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-	dac->dela_state = XFS_DAS_RM_LBLK;
+	attr->xattri_dela_state = XFS_DAS_RM_LBLK;
 das_rm_lblk:
 	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_remove(dac);
+		error = xfs_attr_rmtval_remove(attr);
 		if (error == -EAGAIN)
-			trace_xfs_das_state_return(dac->dela_state);
+			trace_xfs_das_state_return(attr->xattri_dela_state);
 		if (error)
 			return error;
 	}
@@ -1040,9 +1040,9 @@ xfs_attr_node_hasname(
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state = NULL;
 	struct xfs_da_state_blk		*blk;
 	int				retval = 0;
@@ -1052,7 +1052,7 @@ xfs_attr_node_addname(
 	trace_xfs_attr_node_addname(args);
 
 	/* State machine switch */
-	switch (dac->dela_state) {
+	switch (attr->xattri_dela_state) {
 	case XFS_DAS_FLIP_NFLAG:
 		goto das_flip_flag;
 	case XFS_DAS_FOUND_NBLK:
@@ -1118,7 +1118,7 @@ xfs_attr_node_addname(
 			 * this. dela_state is still unset by this function at
 			 * this point.
 			 */
-			trace_xfs_das_state_return(dac->dela_state);
+			trace_xfs_das_state_return(attr->xattri_dela_state);
 			return -EAGAIN;
 		}
 
@@ -1150,8 +1150,8 @@ xfs_attr_node_addname(
 	xfs_da_state_free(state);
 	state = NULL;
 
-	dac->dela_state = XFS_DAS_FOUND_NBLK;
-	trace_xfs_das_state_return(dac->dela_state);
+	attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
+	trace_xfs_das_state_return(attr->xattri_dela_state);
 	return -EAGAIN;
 das_found_nblk:
 
@@ -1163,7 +1163,7 @@ das_found_nblk:
 	 */
 	if (args->rmtblkno > 0) {
 		/* Open coded xfs_attr_rmtval_set without trans handling */
-		error = xfs_attr_rmtval_find_space(dac);
+		error = xfs_attr_rmtval_find_space(attr);
 		if (error)
 			return error;
 
@@ -1171,14 +1171,14 @@ das_found_nblk:
 		 * Roll through the "value", allocating blocks on disk as
 		 * required.  Set the state in case of -EAGAIN return code
 		 */
-		dac->dela_state = XFS_DAS_ALLOC_NODE;
+		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
 das_alloc_node:
-		if (dac->blkcnt > 0) {
-			error = xfs_attr_rmtval_set_blk(dac);
+		if (attr->xattri_blkcnt > 0) {
+			error = xfs_attr_rmtval_set_blk(attr);
 			if (error)
 				return error;
 
-			trace_xfs_das_state_return(dac->dela_state);
+			trace_xfs_das_state_return(attr->xattri_dela_state);
 			return -EAGAIN;
 		}
 
@@ -1213,8 +1213,8 @@ das_alloc_node:
 		/*
 		 * Commit the flag value change and start the next trans in series
 		 */
-		dac->dela_state = XFS_DAS_FLIP_NFLAG;
-		trace_xfs_das_state_return(dac->dela_state);
+		attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
+		trace_xfs_das_state_return(attr->xattri_dela_state);
 		return -EAGAIN;
 	}
 das_flip_flag:
@@ -1229,13 +1229,13 @@ das_flip_flag:
 		return error;
 
 	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-	dac->dela_state = XFS_DAS_RM_NBLK;
+	attr->xattri_dela_state = XFS_DAS_RM_NBLK;
 das_rm_nblk:
 	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_remove(dac);
+		error = xfs_attr_rmtval_remove(attr);
 
 		if (error == -EAGAIN)
-			trace_xfs_das_state_return(dac->dela_state);
+			trace_xfs_das_state_return(attr->xattri_dela_state);
 
 		if (error)
 			return error;
@@ -1343,10 +1343,10 @@ xfs_attr_leaf_mark_incomplete(
  */
 STATIC
 int xfs_attr_node_removename_setup(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		**state = &dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		**state = &attr->xattri_da_state;
 	int				error;
 
 	error = xfs_attr_node_hasname(args, state);
@@ -1370,7 +1370,7 @@ int xfs_attr_node_removename_setup(
 
 STATIC int
 xfs_attr_node_remove_rmt (
-	struct xfs_delattr_context	*dac,
+	struct xfs_attr_item		*attr,
 	struct xfs_da_state		*state)
 {
 	int				error = 0;
@@ -1378,9 +1378,9 @@ xfs_attr_node_remove_rmt (
 	/*
 	 * May return -EAGAIN to request that the caller recall this function
 	 */
-	error = xfs_attr_rmtval_remove(dac);
+	error = xfs_attr_rmtval_remove(attr);
 	if (error == -EAGAIN)
-		trace_xfs_das_state_return(dac->dela_state);
+		trace_xfs_das_state_return(attr->xattri_dela_state);
 	if (error)
 		return error;
 
@@ -1424,10 +1424,10 @@ xfs_attr_node_remove_cleanup(
  */
 STATIC int
 xfs_attr_node_remove_step(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		*state = dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		*state = attr->xattri_da_state;
 	int				error = 0;
 	/*
 	 * If there is an out-of-line value, de-allocate the blocks.
@@ -1438,7 +1438,7 @@ xfs_attr_node_remove_step(
 		/*
 		 * May return -EAGAIN. Remove blocks until args->rmtblkno == 0
 		 */
-		error = xfs_attr_node_remove_rmt(dac, state);
+		error = xfs_attr_node_remove_rmt(attr, state);
 		if (error)
 			return error;
 	}
@@ -1459,29 +1459,29 @@ xfs_attr_node_remove_step(
  */
 STATIC int
 xfs_attr_node_removename_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state = NULL;
 	int				retval, error;
 	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
 
-	if (!dac->da_state) {
-		error = xfs_attr_node_removename_setup(dac);
+	if (!attr->xattri_da_state) {
+		error = xfs_attr_node_removename_setup(attr);
 		if (error)
 			goto out;
 	}
-	state = dac->da_state;
+	state = attr->xattri_da_state;
 
-	switch (dac->dela_state) {
+	switch (attr->xattri_dela_state) {
 	case XFS_DAS_UNINIT:
 		/*
 		 * repeatedly remove remote blocks, remove the entry and join.
 		 * returns -EAGAIN or 0 for completion of the step.
 		 */
-		error = xfs_attr_node_remove_step(dac);
+		error = xfs_attr_node_remove_step(attr);
 		if (error)
 			break;
 
@@ -1497,8 +1497,8 @@ xfs_attr_node_removename_iter(
 			if (error)
 				return error;
 
-			dac->dela_state = XFS_DAS_RM_SHRINK;
-			trace_xfs_das_state_return(dac->dela_state);
+			attr->xattri_dela_state = XFS_DAS_RM_SHRINK;
+			trace_xfs_das_state_return(attr->xattri_dela_state);
 			return -EAGAIN;
 		}
 
@@ -1518,7 +1518,7 @@ xfs_attr_node_removename_iter(
 	}
 
 	if (error == -EAGAIN) {
-		trace_xfs_das_state_return(dac->dela_state);
+		trace_xfs_das_state_return(attr->xattri_dela_state);
 		return error;
 	}
 out:
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 4838094..8c70610 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -364,7 +364,7 @@ struct xfs_attr_list_context {
  */
 
 /*
- * Enum values for xfs_delattr_context.da_state
+ * Enum values for xfs_attr_item.xattri_da_state
  *
  * These values are used by delayed attribute operations to keep track  of where
  * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
@@ -385,7 +385,7 @@ enum xfs_delattr_state {
 };
 
 /*
- * Defines for xfs_delattr_context.flags
+ * Defines for xfs_attr_item.xattri_flags
  */
 #define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
 #define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
@@ -393,32 +393,25 @@ enum xfs_delattr_state {
 /*
  * Context used for keeping track of delayed attribute operations
  */
-struct xfs_delattr_context {
-	struct xfs_da_args      *da_args;
+struct xfs_attr_item {
+	struct xfs_da_args		*xattri_da_args;
 
 	/*
 	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
 	 */
-	struct xfs_buf		*leaf_bp;
+	struct xfs_buf			*xattri_leaf_bp;
 
 	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
-	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		lblkno;
-	int			blkcnt;
+	struct xfs_bmbt_irec		xattri_map;
+	xfs_dablk_t			xattri_lblkno;
+	int				xattri_blkcnt;
 
 	/* Used in xfs_attr_node_removename to roll through removing blocks */
-	struct xfs_da_state     *da_state;
+	struct xfs_da_state		*xattri_da_state;
 
 	/* Used to keep track of current state of delayed operation */
-	unsigned int            flags;
-	enum xfs_delattr_state  dela_state;
-};
-
-/*
- * List of attrs to commit later.
- */
-struct xfs_attr_item {
-	struct xfs_delattr_context	xattri_dac;
+	unsigned int			xattri_flags;
+	enum xfs_delattr_state		xattri_dela_state;
 
 	/*
 	 * Indicates if the attr operation is a set or a remove
@@ -426,7 +419,10 @@ struct xfs_attr_item {
 	 */
 	uint32_t			xattri_op_flags;
 
-	/* used to log this item to an intent */
+	/*
+	 * used to log this item to an intent containing a list of attrs to
+	 * commit later
+	 */
 	struct list_head		xattri_list;
 };
 
@@ -445,12 +441,10 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac);
+int xfs_attr_set_iter(struct xfs_attr_item *attr);
 int xfs_has_attr(struct xfs_da_args *args);
-int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_remove_iter(struct xfs_attr_item *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
-void xfs_delattr_context_init(struct xfs_delattr_context *dac,
-			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 int xfs_attr_set_deferred(struct xfs_da_args *args);
 int xfs_attr_remove_deferred(struct xfs_da_args *args);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 1635e85..c6fee2a 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -633,14 +633,14 @@ xfs_attr_rmtval_set(
  */
 int
 xfs_attr_rmtval_find_space(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_bmbt_irec		*map = &dac->map;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_bmbt_irec		*map = &attr->xattri_map;
 	int				error;
 
-	dac->lblkno = 0;
-	dac->blkcnt = 0;
+	attr->xattri_lblkno = 0;
+	attr->xattri_blkcnt = 0;
 	args->rmtblkcnt = 0;
 	args->rmtblkno = 0;
 	memset(map, 0, sizeof(struct xfs_bmbt_irec));
@@ -649,8 +649,8 @@ xfs_attr_rmtval_find_space(
 	if (error)
 		return error;
 
-	dac->blkcnt = args->rmtblkcnt;
-	dac->lblkno = args->rmtblkno;
+	attr->xattri_blkcnt = args->rmtblkcnt;
+	attr->xattri_lblkno = args->rmtblkno;
 
 	return 0;
 }
@@ -663,17 +663,17 @@ xfs_attr_rmtval_find_space(
  */
 int
 xfs_attr_rmtval_set_blk(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
-	struct xfs_bmbt_irec		*map = &dac->map;
+	struct xfs_bmbt_irec		*map = &attr->xattri_map;
 	int nmap;
 	int error;
 
 	nmap = 1;
-	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)dac->lblkno,
-				dac->blkcnt, XFS_BMAPI_ATTRFORK, args->total,
+	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)attr->xattri_lblkno,
+				attr->xattri_blkcnt, XFS_BMAPI_ATTRFORK, args->total,
 				map, &nmap);
 	if (error)
 		return error;
@@ -683,8 +683,8 @@ xfs_attr_rmtval_set_blk(
 	       (map->br_startblock != HOLESTARTBLOCK));
 
 	/* roll attribute extent map forwards */
-	dac->lblkno += map->br_blockcount;
-	dac->blkcnt -= map->br_blockcount;
+	attr->xattri_lblkno += map->br_blockcount;
+	attr->xattri_blkcnt -= map->br_blockcount;
 
 	return 0;
 }
@@ -737,9 +737,9 @@ xfs_attr_rmtval_invalidate(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				error, done;
 
 	/*
@@ -761,7 +761,7 @@ xfs_attr_rmtval_remove(
 	 * by the parent
 	 */
 	if (!done) {
-		trace_xfs_das_state_return(dac->dela_state);
+		trace_xfs_das_state_return(attr->xattri_dela_state);
 		return -EAGAIN;
 	}
 
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 6ae91af..d3aa27d 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -13,9 +13,9 @@ int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_remove(struct xfs_attr_item *attr);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
-int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
-int xfs_attr_rmtval_find_space(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_set_blk(struct xfs_attr_item *attr);
+int xfs_attr_rmtval_find_space(struct xfs_attr_item *attr);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4

