Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62A9C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241757AbiERS42 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241746AbiERS41 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:56:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357C619CB72
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:56:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B72316183D
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BEEC34100;
        Wed, 18 May 2022 18:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900184;
        bh=9boY4t5P1idJPwS6cOv8ggNtADJsbb/ZFC8gnafvG14=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Q3hWJuF8L2gfiQTrwUnSoSnyIWduW0GQWpJm+qeZx4be6KGgjzmuibyPCq3T67rTD
         su/n9DqwKiSor9R8hWsmszXPlCrH+vPkm4sD18a/Y/OMV7L9/DrHEtHA1FQYlHgWVH
         CJ/uuaQ/qvf4QYblgkcDMeifiHNFV3wVGpHDHGWmhjOpXDlTL6Lxv+NyfNroYlpNzg
         YQAK7GyZzfAjWrBX6gk27GWPAZ3AAay2Huw/60CAptkyAtkgi0HUGhoypMbuDB9mtu
         YPECy0s+SiH0YbQ9hNOhOcnnWcQYMTN+0xvrNPCMlXl712hrj1w4SKnvgxawkiRbWh
         GpVLRCtg6aXog==
Subject: [PATCH 7/7] xfs: rename struct xfs_attr_item to xfs_attr_intent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:56:23 -0700
Message-ID: <165290018363.1647637.1431221002395576716.stgit@magnolia>
In-Reply-To: <165290014409.1647637.4876706578208264219.stgit@magnolia>
References: <165290014409.1647637.4876706578208264219.stgit@magnolia>
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
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        |   52 ++++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_attr.h        |    8 +++---
 fs/xfs/libxfs/xfs_attr_remote.c |    6 ++---
 fs/xfs/libxfs/xfs_attr_remote.h |    6 ++---
 fs/xfs/xfs_attr_item.c          |   26 ++++++++++----------
 fs/xfs/xfs_attr_item.h          |    6 ++---
 6 files changed, 52 insertions(+), 52 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b1300bd10318..4a53a0f5f7ed 100644
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
 	struct xfs_da_state		*state = xfs_da_state_alloc(args);
@@ -1616,8 +1616,8 @@ xfs_attr_namecheck(
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
index e271462c4f04..b92fe707159a 100644
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
@@ -506,7 +506,7 @@ struct xfs_attri_log_nameval;
 /*
  * Context used for keeping track of delayed attribute operations
  */
-struct xfs_attr_item {
+struct xfs_attr_intent {
 	/*
 	 * used to log this item to an intent containing a list of attrs to
 	 * commit later
@@ -559,8 +559,8 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
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
index 4b7919ff0fc6..2d16961b95db 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -357,7 +357,7 @@ xfs_attrd_item_intent(
  */
 STATIC int
 xfs_xattri_finish_update(
-	struct xfs_attr_item		*attr,
+	struct xfs_attr_intent		*attr,
 	struct xfs_attrd_log_item	*attrdp)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
@@ -395,7 +395,7 @@ STATIC void
 xfs_attr_log_item(
 	struct xfs_trans		*tp,
 	struct xfs_attri_log_item	*attrip,
-	const struct xfs_attr_item	*attr)
+	const struct xfs_attr_intent	*attr)
 {
 	struct xfs_attri_log_format	*attrp;
 
@@ -403,9 +403,9 @@ xfs_attr_log_item(
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
@@ -427,7 +427,7 @@ xfs_attr_create_intent(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_attri_log_item	*attrip;
-	struct xfs_attr_item		*attr;
+	struct xfs_attr_intent		*attr;
 
 	ASSERT(count == 1);
 
@@ -438,7 +438,7 @@ xfs_attr_create_intent(
 	 * Each attr item only performs one attribute operation at a time, so
 	 * this is a list of one
 	 */
-	attr = list_first_entry_or_null(items, struct xfs_attr_item,
+	attr = list_first_entry_or_null(items, struct xfs_attr_intent,
 			xattri_list);
 
 	/*
@@ -470,7 +470,7 @@ xfs_attr_create_intent(
 
 static inline void
 xfs_attr_free_item(
-	struct xfs_attr_item		*attr)
+	struct xfs_attr_intent		*attr)
 {
 	if (attr->xattri_da_state)
 		xfs_da_state_free(attr->xattri_da_state);
@@ -490,11 +490,11 @@ xfs_attr_finish_item(
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
 
@@ -524,9 +524,9 @@ STATIC void
 xfs_attr_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_attr_item		*attr;
+	struct xfs_attr_intent		*attr;
 
-	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	attr = container_of(item, struct xfs_attr_intent, xattri_list);
 	xfs_attr_free_item(attr);
 }
 
@@ -586,7 +586,7 @@ xfs_attri_item_recover(
 	struct list_head		*capture_list)
 {
 	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
-	struct xfs_attr_item		*attr;
+	struct xfs_attr_intent		*attr;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_inode		*ip;
 	struct xfs_da_args		*args;
@@ -613,7 +613,7 @@ xfs_attri_item_recover(
 	if (error)
 		return error;
 
-	attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
+	attr = kmem_zalloc(sizeof(struct xfs_attr_intent) +
 			   sizeof(struct xfs_da_args), KM_NOFS);
 	args = (struct xfs_da_args *)(attr + 1);
 
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index 5141dc809d65..a00393144bca 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -23,13 +23,13 @@ struct xfs_attri_log_nameval {
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

