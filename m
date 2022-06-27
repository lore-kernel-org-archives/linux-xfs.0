Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F66AC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 21:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241016AbiF0Vfh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 17:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239964AbiF0Vfg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 17:35:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A413D10FF
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 14:35:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FEC3B81BAE
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 21:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12999C34115;
        Mon, 27 Jun 2022 21:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656365733;
        bh=Q7TgWx/0RKhXvkQ8obfi0b/DVhvNqJ6vEvS+UcRCoXw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ap9IWy0YzW18Ibdo/jetRPWKhiEk0fbXGZOy0p949v0L2Qhok80Juz8L6kEsxhFrz
         R6ODcGPpV6N+8WHmN4xY70JPzzBRK/YbIUtY3ZBpra8A7eEt8cgmkBJBvHSfRCp0Jd
         vpG6StdNj054FZhjJ8t0jTgVaboqVMdiUv4X2Eu0fosAsVc6QacYW00F0qGC9RanFQ
         YepNJPN105jN9noZipvNYPkSkrBnjkZ/pG8xtG4ABsnTgdzAz0ZaYxkWyi17+Zcy4P
         Xm5VPFz+iszytGbijkbg7KrqrUYUr3lYe7dpmhIpXVtMSQtoYTY5qRXy5LnZ1SvRKp
         WX8ndG78ZEuBQ==
Subject: [PATCH 2/3] xfs: don't hold xattr leaf buffers across transaction
 rolls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com
Date:   Mon, 27 Jun 2022 14:35:32 -0700
Message-ID: <165636573259.355536.12934485931353699280.stgit@magnolia>
In-Reply-To: <165636572124.355536.216420713221853575.stgit@magnolia>
References: <165636572124.355536.216420713221853575.stgit@magnolia>
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

The original justification for using bhold here was to prevent the AIL
from trying to write the empty leaf block into the fs during the brief
time that we release the buffer lock.  The reason for /that/ was to
prevent recovery from tripping over the empty ondisk block.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
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
index f6629960e17b..8f47396f8dd2 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -930,14 +930,10 @@ xfs_attr_shortform_getvalue(
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
@@ -999,7 +995,6 @@ xfs_attr_shortform_to_leaf(
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

