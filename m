Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40EDC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241708AbiERSzy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241709AbiERSzw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:55:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BED3B3DC
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:55:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 009CB6183D
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57854C385A5;
        Wed, 18 May 2022 18:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900150;
        bh=hV0X0Sfh8YVLUkZz+17F2L0pll0kzTT6EW04ICioicE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kHzhAbZ7xmWFUNZk2MGLHIWUfSsBNVRumVCx3YDO9f8hLUjgmLzW3jfv38qdN7dJX
         s4S9jPtwIN6yHe1yM5atp6NcFBJumka1g76j+bAA3rtg9qQVKErjq8KXCT7jCJH3Fm
         WhqBSULY2utJ28nUWJXXNG2qCa8Bh1Bilp7NforIclHTCpOpxFlemIKeFnCFXfi3he
         glAhRiqDVxn7/um8N6Z73y+FCO2GkDc5ZzbHBHBq5syglZ3zikbcB3J9h3tVNG/4VB
         Xvwu+JotYFzEMKHvKjDR7Q8FpiybwUUpgs0gY31ZYLpbi11h0GAsKcM9bveE8IeQal
         tjeM+EraVyq6Q==
Subject: [PATCH 1/7] xfs: clean up xfs_attr_node_hasname
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:55:49 -0700
Message-ID: <165290014984.1647637.6457441230229883518.stgit@magnolia>
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

The calling conventions of this function are a mess -- callers /can/
provide a pointer to a pointer to a state structure, but it's not
required, and as evidenced by the last two patches, the callers that do
weren't be careful enough about how to deal with an existing da state.

Push the allocation and freeing responsibilty to the callers, which
means that callers from the xattr node state machine steps now have the
visibility to allocate or free the da state structure as they please.
As a bonus, the node remove/add paths for larp-mode replaces can reset
the da state structure instead of freeing and immediately reallocating
it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c     |   63 +++++++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_da_btree.c |   11 +++++++
 fs/xfs/libxfs/xfs_da_btree.h |    1 +
 3 files changed, 44 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 576de34cfca0..3838109ef288 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -61,8 +61,8 @@ STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
 static int xfs_attr_node_try_addname(struct xfs_attr_item *attr);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item *attr);
 STATIC int xfs_attr_node_remove_attr(struct xfs_attr_item *attr);
-STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
-				 struct xfs_da_state **state);
+STATIC int xfs_attr_node_lookup(struct xfs_da_args *args,
+		struct xfs_da_state *state);
 
 int
 xfs_inode_hasattr(
@@ -594,6 +594,19 @@ xfs_attr_leaf_mark_incomplete(
 	return xfs_attr3_leaf_setflag(args);
 }
 
+/* Ensure the da state of an xattr deferred work item is ready to go. */
+static inline void
+xfs_attr_item_ensure_da_state(
+	struct xfs_attr_item	*attr)
+{
+	struct xfs_da_args	*args = attr->xattri_da_args;
+
+	if (!attr->xattri_da_state)
+		attr->xattri_da_state = xfs_da_state_alloc(args);
+	else
+		xfs_da_state_reset(attr->xattri_da_state, args);
+}
+
 /*
  * Initial setup for xfs_attr_node_removename.  Make sure the attr is there and
  * the blocks are valid.  Attr keys with remote blocks will be marked
@@ -607,7 +620,8 @@ int xfs_attr_node_removename_setup(
 	struct xfs_da_state		*state;
 	int				error;
 
-	error = xfs_attr_node_hasname(args, &attr->xattri_da_state);
+	xfs_attr_item_ensure_da_state(attr);
+	error = xfs_attr_node_lookup(args, attr->xattri_da_state);
 	if (error != -EEXIST)
 		goto out;
 	error = 0;
@@ -855,6 +869,7 @@ xfs_attr_lookup(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf		*bp = NULL;
+	struct xfs_da_state	*state;
 	int			error;
 
 	if (!xfs_inode_hasattr(dp))
@@ -872,7 +887,10 @@ xfs_attr_lookup(
 		return error;
 	}
 
-	return xfs_attr_node_hasname(args, NULL);
+	state = xfs_da_state_alloc(args);
+	error = xfs_attr_node_lookup(args, state);
+	xfs_da_state_free(state);
+	return error;
 }
 
 static int
@@ -1387,34 +1405,20 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 	return error;
 }
 
-/*
- * Return EEXIST if attr is found, or ENOATTR if not
- * statep: If not null is set to point at the found state.  Caller will
- *         be responsible for freeing the state in this case.
- */
+/* Return EEXIST if attr is found, or ENOATTR if not. */
 STATIC int
-xfs_attr_node_hasname(
+xfs_attr_node_lookup(
 	struct xfs_da_args	*args,
-	struct xfs_da_state	**statep)
+	struct xfs_da_state	*state)
 {
-	struct xfs_da_state	*state;
 	int			retval, error;
 
-	state = xfs_da_state_alloc(args);
-	if (statep != NULL) {
-		ASSERT(*statep == NULL);
-		*statep = state;
-	}
-
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
 	error = xfs_da3_node_lookup_int(state, &retval);
 	if (error)
-		retval = error;
-
-	if (!statep)
-		xfs_da_state_free(state);
+		return error;
 
 	return retval;
 }
@@ -1430,15 +1434,12 @@ xfs_attr_node_addname_find_attr(
 	struct xfs_da_args	*args = attr->xattri_da_args;
 	int			error;
 
-	if (attr->xattri_da_state)
-		xfs_da_state_free(attr->xattri_da_state);
-	attr->xattri_da_state = NULL;
-
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	error = xfs_attr_node_hasname(args, &attr->xattri_da_state);
+	xfs_attr_item_ensure_da_state(attr);
+	error = xfs_attr_node_lookup(args, attr->xattri_da_state);
 	switch (error) {
 	case -ENOATTR:
 		if (args->op_flags & XFS_DA_OP_REPLACE)
@@ -1599,7 +1600,7 @@ STATIC int
 xfs_attr_node_get(
 	struct xfs_da_args	*args)
 {
-	struct xfs_da_state	*state = NULL;
+	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
 	int			i;
 	int			error;
@@ -1609,7 +1610,8 @@ xfs_attr_node_get(
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
-	error = xfs_attr_node_hasname(args, &state);
+	state = xfs_da_state_alloc(args);
+	error = xfs_attr_node_lookup(args, state);
 	if (error != -EEXIST)
 		goto out_release;
 
@@ -1628,8 +1630,7 @@ xfs_attr_node_get(
 		state->path.blk[i].bp = NULL;
 	}
 
-	if (state)
-		xfs_da_state_free(state);
+	xfs_da_state_free(state);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index aa74f3fdb571..e7201dc68f43 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -117,6 +117,17 @@ xfs_da_state_free(xfs_da_state_t *state)
 	kmem_cache_free(xfs_da_state_cache, state);
 }
 
+void
+xfs_da_state_reset(
+	struct xfs_da_state	*state,
+	struct xfs_da_args	*args)
+{
+	xfs_da_state_kill_altpath(state);
+	memset(state, 0, sizeof(struct xfs_da_state));
+	state->args = args;
+	state->mp = state->args->dp->i_mount;
+}
+
 static inline int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork)
 {
 	if (whichfork == XFS_DATA_FORK)
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ed2303e4d46a..d33b7686a0b3 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -225,6 +225,7 @@ enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,
 
 struct xfs_da_state *xfs_da_state_alloc(struct xfs_da_args *args);
 void xfs_da_state_free(xfs_da_state_t *state);
+void xfs_da_state_reset(struct xfs_da_state *state, struct xfs_da_args *args);
 
 void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
 		struct xfs_da3_icnode_hdr *to, struct xfs_da_intnode *from);

