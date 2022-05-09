Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96898C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  9 May 2022 01:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiEIB32 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 May 2022 21:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235609AbiEIAph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 May 2022 20:45:37 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 302386573
        for <linux-xfs@vger.kernel.org>; Sun,  8 May 2022 17:41:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A6E2010E6405
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 10:41:41 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nnrT2-009hdR-I4
        for linux-xfs@vger.kernel.org; Mon, 09 May 2022 10:41:40 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nnrT2-003CQ2-Gi
        for linux-xfs@vger.kernel.org;
        Mon, 09 May 2022 10:41:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/18] xfs: switch attr remove to xfs_attri_set_iter
Date:   Mon,  9 May 2022 10:41:34 +1000
Message-Id: <20220509004138.762556-15-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509004138.762556-1-david@fromorbit.com>
References: <20220509004138.762556-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62786345
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=LxarZF53s-dAh__6FAIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that xfs_attri_set_iter() has initial states for removing
attributes, switch the pure attribute removal code over to using it.
This requires attrs being removed to always be marked as INCOMPLETE
before we start the removal due to the fact we look up the attr to
remove again in xfs_attr_node_remove_attr().

Note: this drops the fillstate/refillstate optimisations from
the remove path that avoid having to look up the path again after
setting the incomplete flag and removeing remote attrs. Restoring
that optimisation to this path is future Dave's problem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 21 +++++++++------------
 fs/xfs/libxfs/xfs_attr.h | 10 ++++++++++
 fs/xfs/xfs_attr_item.c   | 31 +++++++------------------------
 3 files changed, 26 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a6a9b1f8dce6..b935727cf517 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -499,13 +499,11 @@ int xfs_attr_node_removename_setup(
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
 		XFS_ATTR_LEAF_MAGIC);
 
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_leaf_mark_incomplete(args, *state);
-		if (error)
-			goto out;
-
+	error = xfs_attr_leaf_mark_incomplete(args, *state);
+	if (error)
+		goto out;
+	if (args->rmtblkno > 0)
 		error = xfs_attr_rmtval_invalidate(args);
-	}
 out:
 	if (error)
 		xfs_da_state_free(*state);
@@ -821,7 +819,7 @@ xfs_attr_defer_remove(
 	if (error)
 		return error;
 
-	new->xattri_dela_state = XFS_DAS_UNINIT;
+	new->xattri_dela_state = xfs_attr_init_remove_state(args);
 	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
 	trace_xfs_attr_defer_remove(new->xattri_dela_state, args->dp);
 
@@ -1391,16 +1389,15 @@ xfs_attr_node_remove_attr(
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state = NULL;
-	struct xfs_mount		*mp = args->dp->i_mount;
 	int				retval = 0;
 	int				error = 0;
 
 	/*
-	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
-	 * flag means that we will find the "old" attr, not the "new" one.
+	 * The attr we are removing has already been marked incomplete, so
+	 * we need to set the filter appropriately to re-find the "old"
+	 * attribute entry after any split ops.
 	 */
-	if (!xfs_has_larp(mp))
-		args->attr_filter |= XFS_ATTR_INCOMPLETE;
+	args->attr_filter |= XFS_ATTR_INCOMPLETE;
 	state = xfs_da_state_alloc(args);
 	state->inleaf = 0;
 	error = xfs_da3_node_lookup_int(state, &retval);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 7ea7c7fa31ac..6bef522533a4 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -593,6 +593,16 @@ xfs_attr_init_add_state(struct xfs_da_args *args)
 	return XFS_DAS_NODE_ADD;
 }
 
+static inline enum xfs_delattr_state
+xfs_attr_init_remove_state(struct xfs_da_args *args)
+{
+	if (xfs_attr_is_shortform(args->dp))
+		return XFS_DAS_SF_REMOVE;
+	if (xfs_attr_is_leaf(args->dp))
+		return XFS_DAS_LEAF_REMOVE;
+	return XFS_DAS_NODE_REMOVE;
+}
+
 static inline enum xfs_delattr_state
 xfs_attr_init_replace_state(struct xfs_da_args *args)
 {
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 740a55d07660..fb9549e7ea96 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -296,12 +296,9 @@ xfs_attrd_item_release(
 STATIC int
 xfs_xattri_finish_update(
 	struct xfs_attr_item		*attr,
-	struct xfs_attrd_log_item	*attrdp,
-	uint32_t			op_flags)
+	struct xfs_attrd_log_item	*attrdp)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
-	unsigned int			op = op_flags &
-					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
 	int				error;
 
 	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP)) {
@@ -309,22 +306,9 @@ xfs_xattri_finish_update(
 		goto out;
 	}
 
-	switch (op) {
-	case XFS_ATTR_OP_FLAGS_SET:
-	case XFS_ATTR_OP_FLAGS_REPLACE:
-		error = xfs_attr_set_iter(attr);
-		if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
-			error = -EAGAIN;
-		break;
-	case XFS_ATTR_OP_FLAGS_REMOVE:
-		ASSERT(XFS_IFORK_Q(args->dp));
-		error = xfs_attr_remove_iter(attr);
-		break;
-	default:
-		error = -EFSCORRUPTED;
-		break;
-	}
-
+	error = xfs_attr_set_iter(attr);
+	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
+		error = -EAGAIN;
 out:
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
@@ -432,8 +416,7 @@ xfs_attr_finish_item(
 	 */
 	attr->xattri_da_args->trans = tp;
 
-	error = xfs_xattri_finish_update(attr, done_item,
-					 attr->xattri_op_flags);
+	error = xfs_xattri_finish_update(attr, done_item);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
@@ -581,7 +564,7 @@ xfs_attri_item_recover(
 		attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
-		attr->xattri_dela_state = XFS_DAS_UNINIT;
+		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
 	default:
 		ASSERT(0);
@@ -600,7 +583,7 @@ xfs_attri_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	ret = xfs_xattri_finish_update(attr, done_item, attrp->alfi_op_flags);
+	ret = xfs_xattri_finish_update(attr, done_item);
 	if (ret == -EAGAIN) {
 		/* There's more work to do, so add it to this transaction */
 		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
-- 
2.35.1

