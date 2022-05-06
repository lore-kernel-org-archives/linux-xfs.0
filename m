Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A8CC4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 09:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390541AbiEFJtn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 05:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355839AbiEFJtl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 05:49:41 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9087266ACF
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 02:45:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B6E4F10E6442
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 19:45:57 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nmuX6-008fMG-Kb
        for linux-xfs@vger.kernel.org; Fri, 06 May 2022 19:45:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nmuX6-0029T2-Jo
        for linux-xfs@vger.kernel.org;
        Fri, 06 May 2022 19:45:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/17] xfs: rework deferred attribute operation setup
Date:   Fri,  6 May 2022 19:45:40 +1000
Message-Id: <20220506094553.512973-5-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506094553.512973-1-david@fromorbit.com>
References: <20220506094553.512973-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6274ee55
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=xSR0dRpCO3c7DOpoyFMA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Logged attribute intents only have set and remove types - there is
no type of the replace operation. We should ahve a separate type for
a replace operation, as it needs to perform operations that neither
SET or REMOVE can perform.

Add this type to the intent items and rearrange the deferred
operation setup to reflect the different operations we are
performing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c       | 165 +++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_attr.h       |   2 -
 fs/xfs/libxfs/xfs_log_format.h |   1 +
 fs/xfs/xfs_attr_item.c         |   9 +-
 fs/xfs/xfs_trace.h             |   4 +
 5 files changed, 110 insertions(+), 71 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a4b0b20a3bab..817e15740f9c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -671,6 +671,81 @@ xfs_attr_lookup(
 	return xfs_attr_node_hasname(args, NULL);
 }
 
+static int
+xfs_attr_item_init(
+	struct xfs_da_args	*args,
+	unsigned int		op_flags,	/* op flag (set or remove) */
+	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
+{
+
+	struct xfs_attr_item	*new;
+
+	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
+	new->xattri_op_flags = op_flags;
+	new->xattri_da_args = args;
+
+	*attr = new;
+	return 0;
+}
+
+/* Sets an attribute for an inode as a deferred operation */
+static int
+xfs_attr_defer_add(
+	struct xfs_da_args	*args)
+{
+	struct xfs_attr_item	*new;
+	int			error = 0;
+
+	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
+	if (error)
+		return error;
+
+	new->xattri_dela_state = XFS_DAS_UNINIT;
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
+
+	return 0;
+}
+
+/* Sets an attribute for an inode as a deferred operation */
+static int
+xfs_attr_defer_replace(
+	struct xfs_da_args	*args)
+{
+	struct xfs_attr_item	*new;
+	int			error = 0;
+
+	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REPLACE, &new);
+	if (error)
+		return error;
+
+	new->xattri_dela_state = XFS_DAS_UNINIT;
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+	trace_xfs_attr_defer_replace(new->xattri_dela_state, args->dp);
+
+	return 0;
+}
+
+/* Removes an attribute for an inode as a deferred operation */
+static int
+xfs_attr_defer_remove(
+	struct xfs_da_args	*args)
+{
+
+	struct xfs_attr_item	*new;
+	int			error;
+
+	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
+	if (error)
+		return error;
+
+	new->xattri_dela_state = XFS_DAS_UNINIT;
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+	trace_xfs_attr_defer_remove(new->xattri_dela_state, args->dp);
+
+	return 0;
+}
+
 /*
  * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
@@ -759,29 +834,35 @@ xfs_attr_set(
 	}
 
 	error = xfs_attr_lookup(args);
-	if (args->value) {
-		if (error == -EEXIST && (args->attr_flags & XATTR_CREATE))
-			goto out_trans_cancel;
-		if (error == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
-			goto out_trans_cancel;
-		if (error != -ENOATTR && error != -EEXIST)
+	switch (error) {
+	case -EEXIST:
+		/* if no value, we are performing a remove operation */
+		if (!args->value) {
+			error = xfs_attr_defer_remove(args);
+			break;
+		}
+		/* Pure create fails if the attr already exists */
+		if (args->attr_flags & XATTR_CREATE)
 			goto out_trans_cancel;
 
-		error = xfs_attr_set_deferred(args);
-		if (error)
+		error = xfs_attr_defer_replace(args);
+		break;
+	case -ENOATTR:
+		/* Can't remove what isn't there. */
+		if (!args->value)
 			goto out_trans_cancel;
 
-		/* shortform attribute has already been committed */
-		if (!args->trans)
-			goto out_unlock;
-	} else {
-		if (error != -EEXIST)
+		/* Pure replace fails if no existing attr to replace. */
+		if (args->attr_flags & XATTR_REPLACE)
 			goto out_trans_cancel;
 
-		error = xfs_attr_remove_deferred(args);
-		if (error)
-			goto out_trans_cancel;
+		error = xfs_attr_defer_add(args);
+		break;
+	default:
+		goto out_trans_cancel;
 	}
+	if (error)
+		goto out_trans_cancel;
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -845,58 +926,6 @@ xfs_attrd_destroy_cache(void)
 	xfs_attrd_cache = NULL;
 }
 
-STATIC int
-xfs_attr_item_init(
-	struct xfs_da_args	*args,
-	unsigned int		op_flags,	/* op flag (set or remove) */
-	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
-{
-
-	struct xfs_attr_item	*new;
-
-	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
-	new->xattri_op_flags = op_flags;
-	new->xattri_da_args = args;
-
-	*attr = new;
-	return 0;
-}
-
-/* Sets an attribute for an inode as a deferred operation */
-int
-xfs_attr_set_deferred(
-	struct xfs_da_args	*args)
-{
-	struct xfs_attr_item	*new;
-	int			error = 0;
-
-	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
-	if (error)
-		return error;
-
-	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
-
-	return 0;
-}
-
-/* Removes an attribute for an inode as a deferred operation */
-int
-xfs_attr_remove_deferred(
-	struct xfs_da_args	*args)
-{
-
-	struct xfs_attr_item	*new;
-	int			error;
-
-	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
-	if (error)
-		return error;
-
-	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
-
-	return 0;
-}
-
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index f6c13d2bfbcd..c9c867e3406c 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -521,8 +521,6 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
-int xfs_attr_set_deferred(struct xfs_da_args *args);
-int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
 extern struct kmem_cache	*xfs_attri_cache;
 extern struct kmem_cache	*xfs_attrd_cache;
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index a27492e99673..f7edd1ecf6d9 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -908,6 +908,7 @@ struct xfs_icreate_log {
  */
 #define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
+#define XFS_ATTR_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 5f8680b05079..fe1e37696634 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -311,6 +311,7 @@ xfs_xattri_finish_update(
 
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
+	case XFS_ATTR_OP_FLAGS_REPLACE:
 		error = xfs_attr_set_iter(attr);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
@@ -500,8 +501,14 @@ xfs_attri_validate(
 		return false;
 
 	/* alfi_op_flags should be either a set or remove */
-	if (op != XFS_ATTR_OP_FLAGS_SET && op != XFS_ATTR_OP_FLAGS_REMOVE)
+	switch (op) {
+	case XFS_ATTR_OP_FLAGS_SET:
+	case XFS_ATTR_OP_FLAGS_REPLACE:
+	case XFS_ATTR_OP_FLAGS_REMOVE:
+		break;
+	default:
 		return false;
+	}
 
 	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
 		return false;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index fec4198b738b..01ce0401aa32 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4154,6 +4154,10 @@ DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_defer_add);
+DEFINE_DAS_STATE_EVENT(xfs_attr_defer_replace);
+DEFINE_DAS_STATE_EVENT(xfs_attr_defer_remove);
+
 
 TRACE_EVENT(xfs_force_shutdown,
 	TP_PROTO(struct xfs_mount *mp, int ptag, int flags, const char *fname,
-- 
2.35.1

