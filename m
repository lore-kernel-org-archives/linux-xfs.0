Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF38FC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 03:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239680AbiEPDdG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 May 2022 23:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239697AbiEPDc5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 23:32:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA401FCCA
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 20:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF198B80E16
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 03:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE51C385AA;
        Mon, 16 May 2022 03:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652671972;
        bh=f8BhL9ExW1WHQUCbHNoMo7aD+7V4c3bwFAxRr0QINf8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KHdvQCXD8fsV65WyGCr2QO1i/xRnd6t7i5go3uYiKSdhLvNFs43tTLwmmYM50XxgR
         R8Eo6EG/HaSIbtaTvjR3ClDcoq4ksNBzwx202CpLRIjDE9DhL3UAnUXtlrdj8TjEJx
         /lE9Pm0aV18An+wGsL61/0sNt8ZUFtuHJsfnoDucpzxLkXL2EjskghluTByW6rtb5A
         deAWHjmF24Y09RNLLRihFhV3ol/6jjW+O/btKaxdEZd46KX9PLzOR3l3h5dLXebCJj
         MMzadl5UBjqh9NQlrPun9HC2DVnIpY1bDYDk9+iP2Y7vhL1hETkVOyeP4TRxx9HjXO
         Vv/mEAal5q9Ug==
Subject: [PATCH 6/6] xfs: rename struct xfs_attr_item to xfs_attr_intent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 15 May 2022 20:32:52 -0700
Message-ID: <165267197212.626272.17091983335534894941.stgit@magnolia>
In-Reply-To: <165267193834.626272.10112290406449975166.stgit@magnolia>
References: <165267193834.626272.10112290406449975166.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Everywhere else in XFS, structures that capture the state of an ongoing
deferred work item all have names that end with "_intent".  The new
extended attribute deferred work items are not named as such, so fix it
to follow the naming convention used elsewhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c        |   52 ++++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_attr.h        |    8 +++---
 fs/xfs/libxfs/xfs_attr_remote.c |    6 ++---
 fs/xfs/libxfs/xfs_attr_remote.h |    6 ++---
 fs/xfs/xfs_attr_item.c          |   28 +++++++++++----------
 fs/xfs/xfs_attr_item.h          |    6 ++---
 6 files changed, 53 insertions(+), 53 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 4056edf9f06e..427cc07d412e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -57,9 +57,9 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
-static int xfs_attr_node_try_addname(struct xfs_attr_item *attr);
-STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item *attr);
-STATIC int xfs_attr_node_remove_attr(struct xfs_attr_item *attr);
+static int xfs_attr_node_try_addname(struct xfs_attr_intent *attr);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_intent *attr);
+STATIC int xfs_attr_node_remove_attr(struct xfs_attr_intent *attr);
 STATIC int xfs_attr_node_lookup(struct xfs_da_args *args,
 		struct xfs_da_state *state);
 
@@ -376,7 +376,7 @@ xfs_attr_try_sf_addname(
 
 static int
 xfs_attr_sf_addname(
-	struct xfs_attr_item		*attr)
+	struct xfs_attr_intent		*attr)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
@@ -422,7 +422,7 @@ xfs_attr_sf_addname(
  */
 static enum xfs_delattr_state
 xfs_attr_complete_op(
-	struct xfs_attr_item	*attr,
+	struct xfs_attr_intent	*attr,
 	enum xfs_delattr_state	replace_state)
 {
 	struct xfs_da_args	*args = attr->xattri_da_args;
@@ -438,7 +438,7 @@ xfs_attr_complete_op(
 
 static int
 xfs_attr_leaf_addname(
-	struct xfs_attr_item	*attr)
+	struct xfs_attr_intent	*attr)
 {
 	struct xfs_da_args	*args = attr->xattri_da_args;
 	int			error;
@@ -492,7 +492,7 @@ xfs_attr_leaf_addname(
  */
 static int
 xfs_attr_node_addname(
-	struct xfs_attr_item	*attr)
+	struct xfs_attr_intent	*attr)
 {
 	struct xfs_da_args	*args = attr->xattri_da_args;
 	int			error;
@@ -529,7 +529,7 @@ xfs_attr_node_addname(
 
 static int
 xfs_attr_rmtval_alloc(
-	struct xfs_attr_item		*attr)
+	struct xfs_attr_intent		*attr)
 {
 	struct xfs_da_args              *args = attr->xattri_da_args;
 	int				error = 0;
@@ -596,7 +596,7 @@ xfs_attr_leaf_mark_incomplete(
 /* Ensure the da state of an xattr deferred work item is ready to go. */
 static inline void
 xfs_attr_item_ensure_da_state(
-	struct xfs_attr_item	*attr)
+	struct xfs_attr_intent	*attr)
 {
 	struct xfs_da_args	*args = attr->xattri_da_args;
 
@@ -613,7 +613,7 @@ xfs_attr_item_ensure_da_state(
  */
 static
 int xfs_attr_node_removename_setup(
-	struct xfs_attr_item		*attr)
+	struct xfs_attr_intent		*attr)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state;
@@ -651,7 +651,7 @@ int xfs_attr_node_removename_setup(
  */
 static int
 xfs_attr_leaf_remove_attr(
-	struct xfs_attr_item		*attr)
+	struct xfs_attr_intent		*attr)
 {
 	struct xfs_da_args              *args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
@@ -716,7 +716,7 @@ xfs_attr_leaf_shrink(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_attr_item		*attr)
+	struct xfs_attr_intent		*attr)
 {
 	struct xfs_da_args              *args = attr->xattri_da_args;
 	int				error = 0;
@@ -893,13 +893,13 @@ xfs_attr_lookup(
 }
 
 static int
-xfs_attr_item_init(
+xfs_attr_intent_init(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags,	/* op flag (set or remove) */
-	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
+	struct xfs_attr_intent	**attr)		/* new xfs_attr_intent */
 {
 
-	struct xfs_attr_item	*new;
+	struct xfs_attr_intent	*new;
 
 	new = kmem_cache_zalloc(xfs_attr_intent_cache, GFP_NOFS | __GFP_NOFAIL);
 	new->xattri_op_flags = op_flags;
@@ -914,10 +914,10 @@ static int
 xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
-	struct xfs_attr_item	*new;
+	struct xfs_attr_intent	*new;
 	int			error = 0;
 
-	error = xfs_attr_item_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
+	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
 	if (error)
 		return error;
 
@@ -933,10 +933,10 @@ static int
 xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
-	struct xfs_attr_item	*new;
+	struct xfs_attr_intent	*new;
 	int			error = 0;
 
-	error = xfs_attr_item_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
+	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
 	if (error)
 		return error;
 
@@ -953,10 +953,10 @@ xfs_attr_defer_remove(
 	struct xfs_da_args	*args)
 {
 
-	struct xfs_attr_item	*new;
+	struct xfs_attr_intent	*new;
 	int			error;
 
-	error  = xfs_attr_item_init(args, XFS_ATTRI_OP_FLAGS_REMOVE, &new);
+	error  = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REMOVE, &new);
 	if (error)
 		return error;
 
@@ -1394,7 +1394,7 @@ xfs_attr_node_lookup(
 
 STATIC int
 xfs_attr_node_addname_find_attr(
-	 struct xfs_attr_item	*attr)
+	 struct xfs_attr_intent	*attr)
 {
 	struct xfs_da_args	*args = attr->xattri_da_args;
 	int			error;
@@ -1447,7 +1447,7 @@ xfs_attr_node_addname_find_attr(
  */
 static int
 xfs_attr_node_try_addname(
-	struct xfs_attr_item		*attr)
+	struct xfs_attr_intent		*attr)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state = attr->xattri_da_state;
@@ -1513,7 +1513,7 @@ xfs_attr_node_removename(
 
 static int
 xfs_attr_node_remove_attr(
-	struct xfs_attr_item		*attr)
+	struct xfs_attr_intent		*attr)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state = NULL;
@@ -1619,8 +1619,8 @@ xfs_attr_namecheck(
 int __init
 xfs_attr_intent_init_cache(void)
 {
-	xfs_attr_intent_cache = kmem_cache_create("xfs_attr_item",
-			sizeof(struct xfs_attr_item),
+	xfs_attr_intent_cache = kmem_cache_create("xfs_attr_intent",
+			sizeof(struct xfs_attr_intent),
 			0, 0, NULL);
 
 	return xfs_attr_intent_cache != NULL ? 0 : -ENOMEM;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 22a2f288c1c0..b88b6d74e4fc 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -434,7 +434,7 @@ struct xfs_attr_list_context {
  */
 
 /*
- * Enum values for xfs_attr_item.xattri_da_state
+ * Enum values for xfs_attr_intent.xattri_da_state
  *
  * These values are used by delayed attribute operations to keep track  of where
  * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
@@ -504,7 +504,7 @@ enum xfs_delattr_state {
 /*
  * Context used for keeping track of delayed attribute operations
  */
-struct xfs_attr_item {
+struct xfs_attr_intent {
 	/*
 	 * used to log this item to an intent containing a list of attrs to
 	 * commit later
@@ -551,8 +551,8 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_attr_item *attr);
-int xfs_attr_remove_iter(struct xfs_attr_item *attr);
+int xfs_attr_set_iter(struct xfs_attr_intent *attr);
+int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 4250159ecced..7298c148f848 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -568,7 +568,7 @@ xfs_attr_rmtval_stale(
  */
 int
 xfs_attr_rmtval_find_space(
-	struct xfs_attr_item		*attr)
+	struct xfs_attr_intent		*attr)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_bmbt_irec		*map = &attr->xattri_map;
@@ -598,7 +598,7 @@ xfs_attr_rmtval_find_space(
  */
 int
 xfs_attr_rmtval_set_blk(
-	struct xfs_attr_item		*attr)
+	struct xfs_attr_intent		*attr)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
@@ -674,7 +674,7 @@ xfs_attr_rmtval_invalidate(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_attr_item		*attr)
+	struct xfs_attr_intent		*attr)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				error, done;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 62b398edec3f..d097ec6c4dc3 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -12,9 +12,9 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int xfs_attr_rmtval_remove(struct xfs_attr_item *attr);
+int xfs_attr_rmtval_remove(struct xfs_attr_intent *attr);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
-int xfs_attr_rmtval_set_blk(struct xfs_attr_item *attr);
-int xfs_attr_rmtval_find_space(struct xfs_attr_item *attr);
+int xfs_attr_rmtval_set_blk(struct xfs_attr_intent *attr);
+int xfs_attr_rmtval_find_space(struct xfs_attr_intent *attr);
 #endif /* __XFS_ATTR_REMOTE_H__ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 1747127434b8..fb84f71388c4 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -300,7 +300,7 @@ xfs_attrd_item_intent(
  */
 STATIC int
 xfs_xattri_finish_update(
-	struct xfs_attr_item		*attr,
+	struct xfs_attr_intent		*attr,
 	struct xfs_attrd_log_item	*attrdp)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
@@ -338,7 +338,7 @@ STATIC void
 xfs_attr_log_item(
 	struct xfs_trans		*tp,
 	struct xfs_attri_log_item	*attrip,
-	struct xfs_attr_item		*attr)
+	struct xfs_attr_intent		*attr)
 {
 	struct xfs_attri_log_format	*attrp;
 
@@ -346,9 +346,9 @@ xfs_attr_log_item(
 	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
 
 	/*
-	 * At this point the xfs_attr_item has been constructed, and we've
+	 * At this point the xfs_attr_intent has been constructed, and we've
 	 * created the log intent. Fill in the attri log item and log format
-	 * structure with fields from this xfs_attr_item
+	 * structure with fields from this xfs_attr_intent
 	 */
 	attrp = &attrip->attri_format;
 	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
@@ -377,7 +377,7 @@ xfs_attr_create_intent(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_attri_log_item	*attrip;
-	struct xfs_attr_item		*attr;
+	struct xfs_attr_intent		*attr;
 
 	ASSERT(count == 1);
 
@@ -403,7 +403,7 @@ xfs_attr_create_intent(
 
 static inline void
 xfs_attr_free_item(
-	struct xfs_attr_item		*attr)
+	struct xfs_attr_intent		*attr)
 {
 	if (attr->xattri_da_state)
 		xfs_da_state_free(attr->xattri_da_state);
@@ -421,11 +421,11 @@ xfs_attr_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_attr_item		*attr;
+	struct xfs_attr_intent		*attr;
 	struct xfs_attrd_log_item	*done_item = NULL;
 	int				error;
 
-	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	attr = container_of(item, struct xfs_attr_intent, xattri_list);
 	if (done)
 		done_item = ATTRD_ITEM(done);
 
@@ -455,9 +455,9 @@ STATIC void
 xfs_attr_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_attr_item		*attr;
+	struct xfs_attr_intent		*attr;
 
-	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	attr = container_of(item, struct xfs_attr_intent, xattri_list);
 	xfs_attr_free_item(attr);
 }
 
@@ -469,10 +469,10 @@ xfs_attri_item_committed(
 	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
 
 	/*
-	 * The attrip refers to xfs_attr_item memory to log the name and value
+	 * The attrip refers to xfs_attr_intent memory to log the name and value
 	 * with the intent item. This already occurred when the intent was
 	 * committed so these fields are no longer accessed. Clear them out of
-	 * caution since we're about to free the xfs_attr_item.
+	 * caution since we're about to free the xfs_attr_intent.
 	 */
 	attrip->attri_name = NULL;
 	attrip->attri_value = NULL;
@@ -540,7 +540,7 @@ xfs_attri_item_recover(
 	struct list_head		*capture_list)
 {
 	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
-	struct xfs_attr_item		*attr;
+	struct xfs_attr_intent		*attr;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_inode		*ip;
 	struct xfs_da_args		*args;
@@ -565,7 +565,7 @@ xfs_attri_item_recover(
 	if (error)
 		return error;
 
-	attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
+	attr = kmem_zalloc(sizeof(struct xfs_attr_intent) +
 			   sizeof(struct xfs_da_args), KM_NOFS);
 	args = (struct xfs_da_args *)(attr + 1);
 
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index cc2fbc9d58a7..a40e702e0215 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -15,13 +15,13 @@ struct kmem_zone;
  * This is the "attr intention" log item.  It is used to log the fact that some
  * extended attribute operations need to be processed.  An operation is
  * currently either a set or remove.  Set or remove operations are described by
- * the xfs_attr_item which may be logged to this intent.
+ * the xfs_attr_intent which may be logged to this intent.
  *
  * During a normal attr operation, name and value point to the name and value
  * fields of the caller's xfs_da_args structure.  During a recovery, the name
  * and value buffers are copied from the log, and stored in a trailing buffer
- * attached to the xfs_attr_item until they are committed.  They are freed when
- * the xfs_attr_item itself is freed when the work is done.
+ * attached to the xfs_attr_intent until they are committed.  They are freed
+ * when the xfs_attr_intent itself is freed when the work is done.
  */
 struct xfs_attri_log_item {
 	struct xfs_log_item		attri_item;

