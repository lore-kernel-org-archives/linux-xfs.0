Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F27CEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbiLaBTP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236051AbiLaBTO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:19:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B9A1DF2B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:19:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65F0AB81DF6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABADC433EF;
        Sat, 31 Dec 2022 01:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449550;
        bh=P40PRT6bIcYdkqa4pW2bJxsaJStQtWAgeSF5cmCPluw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y5KNhYxt7kZeO/JtQBrTftEtem3OWtwKAyfuHIKL2L9DFxQnAmUsZ2IRfCN6npQc2
         4RJEVn1BMXnyGiqQwkKKMgA1y4bq9XGdc+mOoDWbz4t0TeqrmLVUmzUaNEFChvQF9L
         6IRrGqn8+gaAuOf6NmMvvhWrnass0bODHpdHznET9fsPcZ9KaI1TLCuYXjlBYqD5TT
         /Oo5zSjo28bDsBGmVXy+YcFIr/TrGALHOAb5Dt0jGSI3E9rufnzBpeTghYmvpieu+a
         PKSUj+pWlZAdtjvMzYUn4zP5LY+DM7+6ghFX185x0ejQ89pL6CFxa+9SsMNCscs8Ht
         iXHXN5vUnHXpA==
Subject: [PATCH 11/14] xfs: hoist the node iroot update code out of
 xfs_btree_new_iroot
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:32 -0800
Message-ID: <167243865264.708933.17132105790885527230.stgit@magnolia>
In-Reply-To: <167243865089.708933.5645420573863731083.stgit@magnolia>
References: <167243865089.708933.5645420573863731083.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In preparation for allowing records in an inode btree root, hoist the
code that copies keyptrs from an existing node root into a child block
to a separate function.  Note that the new function explicitly computes
the keys of the new child block and stores that in the root block; while
the bmap btree could rely on leaving the key alone, realtime rmap needs
to set the new high key.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |  113 +++++++++++++++++++++++++++++----------------
 1 file changed, 74 insertions(+), 39 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index c2e6b4ea28bf..94df8c6000eb 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3091,6 +3091,77 @@ xfs_btree_iroot_realloc(
 			cur->bc_ops->iroot_ops, rec_diff);
 }
 
+/*
+ * Move the keys and pointers from a root block to a separate block.
+ *
+ * Since the keyptr size does not change, all we have to do is increase the
+ * tree height, copy the keyptrs to the new internal node (cblock), shrink
+ * the root, and copy the pointers there.
+ */
+STATIC int
+xfs_btree_promote_node_iroot(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	int			level,
+	struct xfs_buf		*cbp,
+	union xfs_btree_ptr	*cptr,
+	struct xfs_btree_block	*cblock)
+{
+	union xfs_btree_key	*ckp;
+	union xfs_btree_key	*kp;
+	union xfs_btree_ptr	*cpp;
+	union xfs_btree_ptr	*pp;
+	int			i;
+	int			error;
+	int			numrecs = xfs_btree_get_numrecs(block);
+
+	/*
+	 * Increase tree height, adjusting the root block level to match.
+	 * We cannot change the root btree node size until we've copied the
+	 * block contents to the new child block.
+	 */
+	be16_add_cpu(&block->bb_level, 1);
+	cur->bc_nlevels++;
+	cur->bc_levels[level + 1].ptr = 1;
+
+	/*
+	 * Adjust the root btree record count, then copy the keys from the old
+	 * root to the new child block.
+	 */
+	xfs_btree_set_numrecs(block, 1);
+	kp = xfs_btree_key_addr(cur, 1, block);
+	ckp = xfs_btree_key_addr(cur, 1, cblock);
+	xfs_btree_copy_keys(cur, ckp, kp, numrecs);
+
+	/* Check the pointers and copy them to the new child block. */
+	pp = xfs_btree_ptr_addr(cur, 1, block);
+	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
+	for (i = 0; i < numrecs; i++) {
+		error = xfs_btree_debug_check_ptr(cur, pp, i, level);
+		if (error)
+			return error;
+	}
+	xfs_btree_copy_ptrs(cur, cpp, pp, numrecs);
+
+	/*
+	 * Set the first keyptr to point to the new child block, then shrink
+	 * the memory buffer for the root block.
+	 */
+	error = xfs_btree_debug_check_ptr(cur, cptr, 0, level);
+	if (error)
+		return error;
+	xfs_btree_copy_ptrs(cur, pp, cptr, 1);
+	xfs_btree_get_keys(cur, cblock, kp);
+	xfs_btree_iroot_realloc(cur, 1 - numrecs);
+
+	/* Attach the new block to the cursor and log it. */
+	xfs_btree_setbuf(cur, level, cbp);
+	xfs_btree_log_block(cur, cbp, XFS_BB_ALL_BITS);
+	xfs_btree_log_keys(cur, cbp, 1, numrecs);
+	xfs_btree_log_ptrs(cur, cbp, 1, numrecs);
+	return 0;
+}
+
 /*
  * Copy the old inode root contents into a real block and make the
  * broot point to it.
@@ -3104,14 +3175,10 @@ xfs_btree_new_iroot(
 	struct xfs_buf		*cbp;		/* buffer for cblock */
 	struct xfs_btree_block	*block;		/* btree block */
 	struct xfs_btree_block	*cblock;	/* child btree block */
-	union xfs_btree_key	*ckp;		/* child key pointer */
-	union xfs_btree_ptr	*cpp;		/* child ptr pointer */
-	union xfs_btree_key	*kp;		/* pointer to btree key */
-	union xfs_btree_ptr	*pp;		/* pointer to block addr */
+	union xfs_btree_ptr	*pp;
 	union xfs_btree_ptr	nptr;		/* new block addr */
 	int			level;		/* btree level */
 	int			error;		/* error return code */
-	int			i;		/* loop counter */
 
 	XFS_BTREE_STATS_INC(cur, newroot);
 
@@ -3149,43 +3216,11 @@ xfs_btree_new_iroot(
 			cblock->bb_u.s.bb_blkno = bno;
 	}
 
-	be16_add_cpu(&block->bb_level, 1);
-	xfs_btree_set_numrecs(block, 1);
-	cur->bc_nlevels++;
-	ASSERT(cur->bc_nlevels <= cur->bc_maxlevels);
-	cur->bc_levels[level + 1].ptr = 1;
-
-	kp = xfs_btree_key_addr(cur, 1, block);
-	ckp = xfs_btree_key_addr(cur, 1, cblock);
-	xfs_btree_copy_keys(cur, ckp, kp, xfs_btree_get_numrecs(cblock));
-
-	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
-	for (i = 0; i < be16_to_cpu(cblock->bb_numrecs); i++) {
-		error = xfs_btree_debug_check_ptr(cur, pp, i, level);
-		if (error)
-			goto error0;
-	}
-
-	xfs_btree_copy_ptrs(cur, cpp, pp, xfs_btree_get_numrecs(cblock));
-
-	error = xfs_btree_debug_check_ptr(cur, &nptr, 0, level);
+	error = xfs_btree_promote_node_iroot(cur, block, level, cbp, &nptr,
+			cblock);
 	if (error)
 		goto error0;
 
-	xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
-
-	xfs_btree_iroot_realloc(cur, 1 - xfs_btree_get_numrecs(cblock));
-
-	xfs_btree_setbuf(cur, level, cbp);
-
-	/*
-	 * Do all this logging at the end so that
-	 * the root is at the right level.
-	 */
-	xfs_btree_log_block(cur, cbp, XFS_BB_ALL_BITS);
-	xfs_btree_log_keys(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
-	xfs_btree_log_ptrs(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
-
 	*logflags |=
 		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_ino.whichfork);
 	*stat = 1;

