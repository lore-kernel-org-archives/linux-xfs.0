Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC34AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbiLaBRj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236047AbiLaBRi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:17:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15C91CB3B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:17:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C79261D79
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBABCC433EF;
        Sat, 31 Dec 2022 01:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449456;
        bh=oRy5N9oi3E1wtIqPTLjNbIeHuE6yWcI6pc/WITKayYI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XUUJlzMtzYoZbZenijN3Lx/JOJ4Rz00hO+HNk9Ag7h7EbLoo9lKn+6yPsaVnDHycA
         vUJExxDMrTzuRc7J7kWlZz9z47Isf6jJ00vv+oRENyRLu96tUm6T0vSX4rsz3PL22o
         uFWiCKye8d0mE8RkIJekHZhTWXk4liBLaapcYMgl5v2cZastH+0x8qsI7MOUZYE2i9
         nA9eZtUThUwHlIl5K9M4YaY8WG/yy2yQhYS/bxmXCdhuUrX3USFJ+I8WI+CfajNGlL
         yzj38K6emewRc8yWsXpq9h2jnkR/E6zlrwPSzspE99215nTZ9C8pD/h2rdV2aQBjYI
         9AQkyTaZX4axg==
Subject: [PATCH 05/14] xfs: hoist the code that moves the incore inode fork
 broot memory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:31 -0800
Message-ID: <167243865180.708933.1395874514497911625.stgit@magnolia>
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

Whenever we change the size of the memory buffer holding an inode fork
btree root block, we have to copy the contents over.  Refactor all this
into a single function that handles both, in preparation for making
xfs_iroot_realloc more generic.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c |   99 +++++++++++++++++++++++-----------------
 1 file changed, 57 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index b73b971b83cd..16782d3630d2 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -369,6 +369,50 @@ xfs_iroot_free(
 	ifp->if_broot = NULL;
 }
 
+/* Move the bmap btree root from one incore buffer to another. */
+static void
+xfs_ifork_move_broot(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_btree_block	*dst_broot,
+	size_t			dst_bytes,
+	struct xfs_btree_block	*src_broot,
+	size_t			src_bytes,
+	unsigned int		numrecs)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	void			*dptr;
+	void			*sptr;
+
+	ASSERT(xfs_bmap_bmdr_space(src_broot) <= xfs_inode_fork_size(ip, whichfork));
+
+	/*
+	 * We always have to move the pointers because they are not butted
+	 * against the btree block header.
+	 */
+	if (numrecs) {
+		sptr = xfs_bmap_broot_ptr_addr(mp, src_broot, 1, src_bytes);
+		dptr = xfs_bmap_broot_ptr_addr(mp, dst_broot, 1, dst_bytes);
+		memmove(dptr, sptr, numrecs * sizeof(xfs_fsblock_t));
+	}
+
+	if (src_broot == dst_broot)
+		return;
+
+	/*
+	 * If the root is being totally relocated, we have to migrate the block
+	 * header and the keys that come after it.
+	 */
+	memcpy(dst_broot, src_broot, xfs_bmbt_block_len(mp));
+
+	/* Now copy the keys, which come right after the header. */
+	if (numrecs) {
+		sptr = xfs_bmbt_key_addr(mp, src_broot, 1);
+		dptr = xfs_bmbt_key_addr(mp, dst_broot, 1);
+		memcpy(dptr, sptr, numrecs * sizeof(struct xfs_bmbt_key));
+	}
+}
+
 /*
  * Reallocate the space for if_broot based on the number of records
  * being added or deleted as indicated in rec_diff.  Move the records
@@ -395,12 +439,11 @@ xfs_iroot_realloc(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	int			cur_max;
-	struct xfs_ifork	*ifp;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_block	*new_broot;
 	int			new_max;
 	size_t			new_size;
-	char			*np;
-	char			*op;
+	size_t			old_size = ifp->if_broot_bytes;
 
 	/*
 	 * Handle the degenerate case quietly.
@@ -409,13 +452,12 @@ xfs_iroot_realloc(
 		return;
 	}
 
-	ifp = xfs_ifork_ptr(ip, whichfork);
 	if (rec_diff > 0) {
 		/*
 		 * If there wasn't any memory allocated before, just
 		 * allocate it now and get out.
 		 */
-		if (ifp->if_broot_bytes == 0) {
+		if (old_size == 0) {
 			new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
 			xfs_iroot_alloc(ip, whichfork, new_size);
 			return;
@@ -424,22 +466,16 @@ xfs_iroot_realloc(
 		/*
 		 * If there is already an existing if_broot, then we need
 		 * to realloc() it and shift the pointers to their new
-		 * location.  The records don't change location because
-		 * they are kept butted up against the btree block header.
+		 * location.
 		 */
-		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
+		cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
 		new_max = cur_max + rec_diff;
 		new_size = xfs_bmap_broot_space_calc(mp, new_max);
 		ifp->if_broot = krealloc(ifp->if_broot, new_size,
 					 GFP_NOFS | __GFP_NOFAIL);
-		op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-						     ifp->if_broot_bytes);
-		np = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-						     (int)new_size);
-		ifp->if_broot_bytes = (int)new_size;
-		ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
-			xfs_inode_fork_size(ip, whichfork));
-		memmove(np, op, cur_max * (uint)sizeof(xfs_fsblock_t));
+		ifp->if_broot_bytes = new_size;
+		xfs_ifork_move_broot(ip, whichfork, ifp->if_broot, new_size,
+				ifp->if_broot, old_size, cur_max);
 		return;
 	}
 
@@ -448,8 +484,8 @@ xfs_iroot_realloc(
 	 * if_broot buffer.  It must already exist.  If we go to zero
 	 * records, just get rid of the root and clear the status bit.
 	 */
-	ASSERT((ifp->if_broot != NULL) && (ifp->if_broot_bytes > 0));
-	cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
+	ASSERT((ifp->if_broot != NULL) && (old_size > 0));
+	cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
 	if (new_max > 0)
@@ -461,35 +497,14 @@ xfs_iroot_realloc(
 		return;
 	}
 
-	/* First copy over the btree block header. */
+	/* Reallocate the btree root and move the contents. */
 	new_broot = kmem_alloc(new_size, KM_NOFS);
-	memcpy(new_broot, ifp->if_broot, xfs_bmbt_block_len(ip->i_mount));
+	xfs_ifork_move_broot(ip, whichfork, new_broot, new_size, ifp->if_broot,
+			old_size, new_max);
 
-	/*
-	 * Only copy the keys and pointers if there are any.
-	 */
-	if (new_max > 0) {
-		/*
-		 * First copy the keys.
-		 */
-		op = (char *)xfs_bmbt_key_addr(mp, ifp->if_broot, 1);
-		np = (char *)xfs_bmbt_key_addr(mp, new_broot, 1);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_key_t));
-
-		/*
-		 * Then copy the pointers.
-		 */
-		op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-						     ifp->if_broot_bytes);
-		np = (char *)xfs_bmap_broot_ptr_addr(mp, new_broot, 1,
-						     (int)new_size);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_fsblock_t));
-	}
 	kmem_free(ifp->if_broot);
 	ifp->if_broot = new_broot;
 	ifp->if_broot_bytes = (int)new_size;
-	ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
-		xfs_inode_fork_size(ip, whichfork));
 	return;
 }
 

