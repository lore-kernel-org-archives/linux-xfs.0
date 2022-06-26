Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE29BC43334
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jun 2022 22:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiFZWED (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 18:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiFZWEC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 18:04:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961FC2DC6
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 15:04:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4ACD5B80D37
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 22:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0B2C34114;
        Sun, 26 Jun 2022 22:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656281039;
        bh=F8OX/v22jTdSlCYjhcbgW3UYLOxl8ig1hjNkb2P5tTg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IKHuYj6HzvKjVTguL9yb7goSOm4o6U4SeiBqrxxaKO/SeWneO7Ayl8AjP3Cyw95k3
         JrGjpmsw/J3qRmpR7a4rPiuuVdC69anZIDxCgIuGp2vUXCqLEoCTUTVZx6Sz3cX7B7
         2rIPAWX9vpI8ZVRHpw0A/K5wdNVwUcXthlpjgNkhG8p0tV5TyfR9dDxa+G6Qio3BgF
         aStnOYB4hjfGw2mWuOOHnTa7O5CsrXyFRXfqdgkP2n2jZL2EX520JE9eTlBX2wVW2t
         N28bCP+qE87HVD7kBEWSlj/fTVgl2QlBNryXhXyUS9Fgr5/rUrLHWDj2NJ6oksy3OC
         dgP3zorRrdwgg==
Subject: [PATCH 2/3] xfs: don't hold xattr leaf buffers across transaction
 rolls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 26 Jun 2022 15:03:58 -0700
Message-ID: <165628103862.4040423.16112028158389764844.stgit@magnolia>
In-Reply-To: <165628102728.4040423.16023948770805941408.stgit@magnolia>
References: <165628102728.4040423.16023948770805941408.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've established (again!) that empty xattr leaf buffers are
ok, we no longer need to bhold them to transactions when we're creating
new leaf blocks.  Get rid of the entire mechanism, which should simplify
the xattr code quite a bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c      |   38 +++++++++-----------------------------
 fs/xfs/libxfs/xfs_attr.h      |    5 -----
 fs/xfs/libxfs/xfs_attr_leaf.c |    9 ++-------
 fs/xfs/libxfs/xfs_attr_leaf.h |    3 +--
 fs/xfs/xfs_attr_item.c        |   22 ----------------------
 5 files changed, 12 insertions(+), 65 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1824f61621a2..224649a76cbb 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -50,7 +50,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
-STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
+STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -393,16 +393,10 @@ xfs_attr_sf_addname(
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, &attr->xattri_leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args);
 	if (error)
 		return error;
 
-	/*
-	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
-	 * push cannot grab the half-baked leaf buffer and run into problems
-	 * with the write verifier.
-	 */
-	xfs_trans_bhold(args->trans, attr->xattri_leaf_bp);
 	attr->xattri_dela_state = XFS_DAS_LEAF_ADD;
 out:
 	trace_xfs_attr_sf_addname_return(attr->xattri_dela_state, args->dp);
@@ -447,11 +441,9 @@ xfs_attr_leaf_addname(
 
 	/*
 	 * Use the leaf buffer we may already hold locked as a result of
-	 * a sf-to-leaf conversion. The held buffer is no longer valid
-	 * after this call, regardless of the result.
+	 * a sf-to-leaf conversion.
 	 */
-	error = xfs_attr_leaf_try_add(args, attr->xattri_leaf_bp);
-	attr->xattri_leaf_bp = NULL;
+	error = xfs_attr_leaf_try_add(args);
 
 	if (error == -ENOSPC) {
 		error = xfs_attr3_leaf_to_node(args);
@@ -497,8 +489,6 @@ xfs_attr_node_addname(
 	struct xfs_da_args	*args = attr->xattri_da_args;
 	int			error;
 
-	ASSERT(!attr->xattri_leaf_bp);
-
 	error = xfs_attr_node_addname_find_attr(attr);
 	if (error)
 		return error;
@@ -1215,24 +1205,14 @@ xfs_attr_restore_rmt_blk(
  */
 STATIC int
 xfs_attr_leaf_try_add(
-	struct xfs_da_args	*args,
-	struct xfs_buf		*bp)
+	struct xfs_da_args	*args)
 {
+	struct xfs_buf		*bp;
 	int			error;
 
-	/*
-	 * If the caller provided a buffer to us, it is locked and held in
-	 * the transaction because it just did a shortform to leaf conversion.
-	 * Hence we don't need to read it again. Otherwise read in the leaf
-	 * buffer.
-	 */
-	if (bp) {
-		xfs_trans_bhold_release(args->trans, bp);
-	} else {
-		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
-		if (error)
-			return error;
-	}
+	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
+	if (error)
+		return error;
 
 	/*
 	 * Look up the xattr name to set the insertion point for the new xattr.
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b4a2fc77017e..dfb47fa63c6d 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -515,11 +515,6 @@ struct xfs_attr_intent {
 	 */
 	struct xfs_attri_log_nameval	*xattri_nameval;
 
-	/*
-	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
-	 */
-	struct xfs_buf			*xattri_leaf_bp;
-
 	/* Used to keep track of current state of delayed operation */
 	enum xfs_delattr_state		xattri_dela_state;
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index be7c216ec8f2..997b3f3a9b94 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -958,14 +958,10 @@ xfs_attr_shortform_getvalue(
 	return -ENOATTR;
 }
 
-/*
- * Convert from using the shortform to the leaf.  On success, return the
- * buffer so that we can keep it locked until we're totally done with it.
- */
+/* Convert from using the shortform to the leaf format. */
 int
 xfs_attr_shortform_to_leaf(
-	struct xfs_da_args		*args,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_da_args		*args)
 {
 	struct xfs_inode		*dp;
 	struct xfs_attr_shortform	*sf;
@@ -1027,7 +1023,6 @@ xfs_attr_shortform_to_leaf(
 		sfe = xfs_attr_sf_nextentry(sfe);
 	}
 	error = 0;
-	*leaf_bp = bp;
 out:
 	kmem_free(tmpbuffer);
 	return error;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index efa757f1e912..368f4d9fa1d5 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -49,8 +49,7 @@ void	xfs_attr_shortform_create(struct xfs_da_args *args);
 void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
 int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
-int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
-			struct xfs_buf **leaf_bp);
+int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
 int	xfs_attr_sf_removename(struct xfs_da_args *args);
 int	xfs_attr_sf_findname(struct xfs_da_args *args,
 			     struct xfs_attr_sf_entry **sfep,
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 6ee905a09eb2..5077a7ad5646 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -455,8 +455,6 @@ static inline void
 xfs_attr_free_item(
 	struct xfs_attr_intent		*attr)
 {
-	ASSERT(attr->xattri_leaf_bp == NULL);
-
 	if (attr->xattri_da_state)
 		xfs_da_state_free(attr->xattri_da_state);
 	xfs_attri_log_nameval_put(attr->xattri_nameval);
@@ -511,10 +509,6 @@ xfs_attr_cancel_item(
 	struct xfs_attr_intent		*attr;
 
 	attr = container_of(item, struct xfs_attr_intent, xattri_list);
-	if (attr->xattri_leaf_bp) {
-		xfs_buf_relse(attr->xattri_leaf_bp);
-		attr->xattri_leaf_bp = NULL;
-	}
 	xfs_attr_free_item(attr);
 }
 
@@ -672,16 +666,6 @@ xfs_attri_item_recover(
 		if (error)
 			goto out_unlock;
 
-		/*
-		 * The defer capture structure took its own reference to the
-		 * attr leaf buffer and will give that to the continuation
-		 * transaction.  The attr intent struct drives the continuation
-		 * work, so release our refcount on the attr leaf buffer but
-		 * retain the pointer in the intent structure.
-		 */
-		if (attr->xattri_leaf_bp)
-			xfs_buf_relse(attr->xattri_leaf_bp);
-
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_irele(ip);
 		return 0;
@@ -692,13 +676,7 @@ xfs_attri_item_recover(
 	}
 
 	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
-
 out_unlock:
-	if (attr->xattri_leaf_bp) {
-		xfs_buf_relse(attr->xattri_leaf_bp);
-		attr->xattri_leaf_bp = NULL;
-	}
-
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
 out:

