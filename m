Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C436C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiF1UtY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiF1UtV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:49:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B262F01F
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:49:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECD626182E
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A53C341C8;
        Tue, 28 Jun 2022 20:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449351;
        bh=4IbRFRZ+pEppSjRMzR0jkY27Zjm6u+2PiR1dgdqsxIo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fqwSMdgqMj0IqmQm57Q1HLLPgAmQTjWSWgEm1qSxyB7cNF0xGyYs1Kj/zgXM4jfL3
         xu0Te8Bb4bmzm9qhKJX7NMyO1TWnIv8RY6CHtzKBBzam0PUEY++cH/6RnCrLXSn3jH
         YunFLxrZ6RZnNAtPyUZ9Bv8ZEsgw0G9A1J5fC/YQ/ACw+M9b+nRZeDvAoCAI+itKbh
         YFdEntvyQlyIaeKmr/a+Gcy2CAfmc+zcvijpE2GW1bLAvIiFRzh+PZyvaRK71fdVlJ
         Z7zuNmPa0PfDS8jhZBZ6amvA4GE6A+rKM48h/uJI4i+HYbtTM+KqvqtdGxz9Hx2ykJ
         baUEeL4MvbeOQ==
Subject: [PATCH 8/8] xfs: don't hold xattr leaf buffers across transaction
 rolls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:49:10 -0700
Message-ID: <165644935091.1089724.6853487454654769399.stgit@magnolia>
In-Reply-To: <165644930619.1089724.12201433387040577983.stgit@magnolia>
References: <165644930619.1089724.12201433387040577983.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 8b2fe54075e0d04a126ecfbeb714fea2f77fb8e4

Now that we've established (again!) that empty xattr leaf buffers are
ok, we no longer need to bhold them to transactions when we're creating
new leaf blocks.  Get rid of the entire mechanism, which should simplify
the xattr code quite a bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c      |   38 +++++++++-----------------------------
 libxfs/xfs_attr.h      |    5 -----
 libxfs/xfs_attr_leaf.c |    9 ++-------
 libxfs/xfs_attr_leaf.h |    3 +--
 4 files changed, 12 insertions(+), 43 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index dba528e6..08973934 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -48,7 +48,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
-STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
+STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -391,16 +391,10 @@ xfs_attr_sf_addname(
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
@@ -445,11 +439,9 @@ xfs_attr_leaf_addname(
 
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
@@ -495,8 +487,6 @@ xfs_attr_node_addname(
 	struct xfs_da_args	*args = attr->xattri_da_args;
 	int			error;
 
-	ASSERT(!attr->xattri_leaf_bp);
-
 	error = xfs_attr_node_addname_find_attr(attr);
 	if (error)
 		return error;
@@ -1213,24 +1203,14 @@ xfs_attr_restore_rmt_blk(
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
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index b4a2fc77..dfb47fa6 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
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
 
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 047ab01b..75d36141 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -927,14 +927,10 @@ xfs_attr_shortform_getvalue(
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
@@ -996,7 +992,6 @@ xfs_attr_shortform_to_leaf(
 		sfe = xfs_attr_sf_nextentry(sfe);
 	}
 	error = 0;
-	*leaf_bp = bp;
 out:
 	kmem_free(tmpbuffer);
 	return error;
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index efa757f1..368f4d9f 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
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

