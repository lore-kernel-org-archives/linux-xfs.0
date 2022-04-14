Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0590AC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 09:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242016AbiDNJs5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 05:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242306AbiDNJsQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 05:48:16 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3EB107A982
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 02:44:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E6B8C10C79AE
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 19:44:37 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1new1k-00HZKk-7U
        for linux-xfs@vger.kernel.org; Thu, 14 Apr 2022 19:44:36 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1new1k-00AX0J-6T
        for linux-xfs@vger.kernel.org;
        Thu, 14 Apr 2022 19:44:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/16] xfs: split attr replace op setup from create op setup
Date:   Thu, 14 Apr 2022 19:44:33 +1000
Message-Id: <20220414094434.2508781-16-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220414094434.2508781-1-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6257ed06
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=jyeKvGXlvUz2ESOJE8gA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

In preparation for having a different replace algorithm when LARP
mode is active.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 194 ++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_attr.h |   2 -
 2 files changed, 112 insertions(+), 84 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 34c31077b08f..772506d44bfa 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -724,6 +724,96 @@ xfs_attr_lookup(
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
+	if (xfs_attr_is_shortform(args->dp))
+		new->xattri_dela_state = XFS_DAS_SF_ADD;
+	else if (xfs_attr_is_leaf(args->dp))
+		new->xattri_dela_state = XFS_DAS_LEAF_ADD;
+	else
+		new->xattri_dela_state = XFS_DAS_NODE_ADD;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
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
+	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
+	if (error)
+		return error;
+
+	if (xfs_attr_is_shortform(args->dp))
+		new->xattri_dela_state = XFS_DAS_SF_ADD;
+	else if (xfs_attr_is_leaf(args->dp))
+		new->xattri_dela_state = XFS_DAS_LEAF_ADD;
+	else
+		new->xattri_dela_state = XFS_DAS_NODE_ADD;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
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
+	if (xfs_attr_is_shortform(args->dp))
+		new->xattri_dela_state = XFS_DAS_SF_REMOVE;
+	else if (xfs_attr_is_leaf(args->dp))
+		new->xattri_dela_state = XFS_DAS_LEAF_REMOVE;
+	else
+		new->xattri_dela_state = XFS_DAS_NODE_REMOVE;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*
  * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
@@ -812,29 +902,35 @@ xfs_attr_set(
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
@@ -898,72 +994,6 @@ xfs_attrd_destroy_cache(void)
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
-	if (xfs_attr_is_shortform(args->dp))
-		new->xattri_dela_state = XFS_DAS_SF_ADD;
-	else if (xfs_attr_is_leaf(args->dp))
-		new->xattri_dela_state = XFS_DAS_LEAF_ADD;
-	else
-		new->xattri_dela_state = XFS_DAS_NODE_ADD;
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
-	if (xfs_attr_is_shortform(args->dp))
-		new->xattri_dela_state = XFS_DAS_SF_REMOVE;
-	else if (xfs_attr_is_leaf(args->dp))
-		new->xattri_dela_state = XFS_DAS_LEAF_REMOVE;
-	else
-		new->xattri_dela_state = XFS_DAS_NODE_REMOVE;
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
index e4b11ac243d7..cac7dfcf2dbe 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -559,8 +559,6 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
-int xfs_attr_set_deferred(struct xfs_da_args *args);
-int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
 extern struct kmem_cache	*xfs_attri_cache;
 extern struct kmem_cache	*xfs_attrd_cache;
-- 
2.35.1

