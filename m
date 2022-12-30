Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB0AEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbiLaBS7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236051AbiLaBS6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:18:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360AD1AD9A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:18:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF6E3B81DF9
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EABC433EF;
        Sat, 31 Dec 2022 01:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449534;
        bh=Wpaa91irgJRDC7Jm1ipm9ZoYCEGj1HF9THhsRm6bAuY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eTlGlTXOQvTKZoUidA9neU4MFJJ8FWOE81vmaMESruzaZa/kZc5Xyjl4BgajRRbun
         ZxY2L5oBVgZgZOxbwxkMU7qQju7lYz0tkQQlf5glsoZUOnzZ+koufAvvSkiOrF4K9s
         D/kxrasV+eNzLa7TKbI4+iCFp3uJEcsB3J4QfcbbpT0G6wxFhq4L5+Mp5bIIF23o6N
         US8UP6xaNRwl6prVBCvk2tBkHtaydUcz2BvW9TdTFeOzPpYcHUJRSBBgOLX9iTbix9
         Mvmfd9814LwV7+m7yUOk2mQgfO2tqsAfBjMsm84uyS+b1PKs1uYQ+PwJhNOmBNjF8b
         znTKB9RWH62iw==
Subject: [PATCH 10/14] xfs: support leaves in the incore btree root block in
 xfs_iroot_realloc
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:32 -0800
Message-ID: <167243865250.708933.418868709687052909.stgit@magnolia>
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

Add some logic to xfs_iroot_realloc so that we can handle leaf records
in the btree root block correctly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.c |    4 +++-
 fs/xfs/libxfs/xfs_bmap_btree.h |    5 ++++-
 fs/xfs/libxfs/xfs_inode_fork.c |   12 +++++++-----
 fs/xfs/libxfs/xfs_inode_fork.h |    5 +++--
 fs/xfs/scrub/bmap_repair.c     |    2 +-
 5 files changed, 18 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index f9d4ca6ced1f..4c6a91acdad6 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -536,6 +536,7 @@ xfs_bmbt_broot_move(
 	size_t			dst_bytes,
 	struct xfs_btree_block	*src_broot,
 	size_t			src_bytes,
+	unsigned int		level,
 	unsigned int		numrecs)
 {
 	struct xfs_mount	*mp = ip->i_mount;
@@ -543,6 +544,7 @@ xfs_bmbt_broot_move(
 	void			*sptr;
 
 	ASSERT(xfs_bmap_bmdr_space(src_broot) <= xfs_inode_fork_size(ip, whichfork));
+	ASSERT(level > 0);
 
 	/*
 	 * We always have to move the pointers because they are not butted
@@ -857,7 +859,7 @@ xfs_bmbt_iroot_alloc(
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 
 	xfs_iroot_alloc(ip, whichfork,
-			xfs_bmap_broot_space_calc(ip->i_mount, 1));
+			xfs_bmap_broot_space_calc(ip->i_mount, 1, 1));
 
 	/* Fill in the root. */
 	xfs_btree_init_block(ip->i_mount, ifp->if_broot, &xfs_bmbt_ops, 1, 1,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index a9ddc9b42e61..d20321bfe2f6 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -161,8 +161,11 @@ xfs_bmap_broot_ptr_addr(
 static inline size_t
 xfs_bmap_broot_space_calc(
 	struct xfs_mount	*mp,
+	unsigned int		level,
 	unsigned int		nrecs)
 {
+	ASSERT(level > 0);
+
 	/*
 	 * If the bmbt root block is empty, we should be converting the fork
 	 * to extents format.  Hence, the size is zero.
@@ -183,7 +186,7 @@ xfs_bmap_broot_space(
 	struct xfs_mount	*mp,
 	struct xfs_bmdr_block	*bb)
 {
-	return xfs_bmap_broot_space_calc(mp, be16_to_cpu(bb->bb_numrecs));
+	return xfs_bmap_broot_space_calc(mp, 1, be16_to_cpu(bb->bb_numrecs));
 }
 
 /* Compute the space required for the ondisk root block. */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 0ac1c8dba2ed..b844bfd94e9c 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -395,6 +395,7 @@ xfs_iroot_realloc(
 	struct xfs_btree_block		*new_broot;
 	size_t				new_size;
 	size_t				old_size = ifp->if_broot_bytes;
+	unsigned int			level;
 	int				cur_max;
 	int				new_max;
 
@@ -409,16 +410,17 @@ xfs_iroot_realloc(
 	if (old_size == 0) {
 		ASSERT(rec_diff > 0);
 
-		new_size = ops->size(mp, rec_diff);
+		new_size = ops->size(mp, 0, rec_diff);
 		xfs_iroot_alloc(ip, whichfork, new_size);
 		return;
 	}
 
 	/* Compute the new and old record count and space requirements. */
-	cur_max = ops->maxrecs(mp, old_size, false);
+	level = be16_to_cpu(ifp->if_broot->bb_level);
+	cur_max = ops->maxrecs(mp, old_size, level == 0);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
-	new_size = ops->size(mp, new_max);
+	new_size = ops->size(mp, level, new_max);
 
 	if (rec_diff > 0) {
 		/*
@@ -430,7 +432,7 @@ xfs_iroot_realloc(
 					 GFP_NOFS | __GFP_NOFAIL);
 		ifp->if_broot_bytes = new_size;
 		ops->move(ip, whichfork, ifp->if_broot, new_size,
-				ifp->if_broot, old_size, cur_max);
+				ifp->if_broot, old_size, level, cur_max);
 		return;
 	}
 
@@ -447,7 +449,7 @@ xfs_iroot_realloc(
 	/* Reallocate the btree root and move the contents. */
 	new_broot = kmem_alloc(new_size, KM_NOFS);
 	ops->move(ip, whichfork, new_broot, new_size, ifp->if_broot,
-			ifp->if_broot_bytes, new_max);
+			ifp->if_broot_bytes, level, new_max);
 
 	kmem_free(ifp->if_broot);
 	ifp->if_broot = new_broot;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7d95c402f870..3734642917a7 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -277,7 +277,8 @@ struct xfs_ifork_broot_ops {
 			bool leaf);
 
 	/* Calculate the bytes required for the incore btree root block. */
-	size_t (*size)(struct xfs_mount *mp, unsigned int nrecs);
+	size_t (*size)(struct xfs_mount *mp, unsigned int level,
+			unsigned int nrecs);
 
 	/*
 	 * Move an incore btree root from one buffer to another.  Note that
@@ -287,7 +288,7 @@ struct xfs_ifork_broot_ops {
 	void (*move)(struct xfs_inode *ip, int whichfork,
 			struct xfs_btree_block *dst_broot, size_t dst_bytes,
 			struct xfs_btree_block *src_broot, size_t src_bytes,
-			unsigned int numrecs);
+			unsigned int level, unsigned int numrecs);
 };
 
 void xfs_iroot_realloc(struct xfs_inode *ip, int whichfork,
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 73ba5c514cde..0ad0f27fd8ca 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -437,7 +437,7 @@ xrep_bmap_iroot_size(
 {
 	ASSERT(level > 0);
 
-	return xfs_bmap_broot_space_calc(cur->bc_mp, nr_this_level);
+	return xfs_bmap_broot_space_calc(cur->bc_mp, level, nr_this_level);
 }
 
 /* Update the inode counters. */

