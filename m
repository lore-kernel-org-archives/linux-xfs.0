Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E37B7462
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994537; cv=none; b=mp65LNF1R6QCA07AY3mc1S8vmadgivN1bUA5eMfKyBLRZkZ+n8bKOHrjGUFJiamboFoQK5IaVsbytjQu1BWfBJ+PF9pYzElXDAsH4RRTub/NVjplOuzmlwndOlIq6pU4+yasyDc1QdzD4M+V2J6qpmF258H68ZvLWaxql1D5hk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994537; c=relaxed/simple;
	bh=85JbGjkkPI2HkN089DZD0SSmdQV7DjxhJMd0rku1rso=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ETFNgZ30afb6Q0EAaTjUw6gONG8HpI4TX5YHRlQkWbiuB5eoO5//+nWt5nENFkAkpcocOhViSUizmQaAsJonT1TG8ULuzIua+qdaK+ZpeXUE0lOCYQ2UGXwWZak15OyALbOMnHKQp+82QTj1zINcXfqXYx1Goe3CAYb3BlNMUr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5yzAel/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5yzAel/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B482C4CED3;
	Mon, 23 Dec 2024 22:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994537;
	bh=85JbGjkkPI2HkN089DZD0SSmdQV7DjxhJMd0rku1rso=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z5yzAel/9cDm8+ARVHtUfu5dnp9SAyuwYvWMeocWZM8HakxDY0K7KOfQzjsWrOBKq
	 Wj/roxAKt23vvlnLyMZ8MBfRWeju8Q5Ovm07mCOv6cc0vx5/DyVDYeErT4c3SViGZI
	 8rqV6wIFO6vTSQj2wQ+Ttay+KFp8MVLsHFBpJ/cPKYVzatx+uSJY6SXR7UWrdlt72r
	 CU7WfUDK+mFF1GdCD9UTv/Qh2rp8T2KdYHw5QM6QSxAo3YVWPuordWcb8+XsJws0Yq
	 zEK2Za6XTQtzF2cic7uApX0y7GFeqy2D4WDfIWbe7cv1OmDA7fOX3LlcRKpMrcsfHD
	 eCrhM08Ycnz6w==
Date: Mon, 23 Dec 2024 14:55:36 -0800
Subject: [PATCH 6/8] xfs: hoist the node iroot update code out of
 xfs_btree_new_iroot
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499417702.2379682.10100078027850297613.stgit@frogsfrogsfrogs>
In-Reply-To: <173499417579.2379682.13016361690239662927.stgit@frogsfrogsfrogs>
References: <173499417579.2379682.13016361690239662927.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In preparation for allowing records in an inode btree root, hoist the
code that copies keyptrs from an existing node root into a child block
to a separate function.  Note that the new function explicitly computes
the keys of the new child block and stores that in the root block; while
the bmap btree could rely on leaving the key alone, realtime rmap needs
to set the new high key.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree.c |  117 +++++++++++++++++++++++++++++----------------
 1 file changed, 76 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 672746f7217cff..ed09eeee916160 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3078,6 +3078,78 @@ xfs_btree_split(
 #define xfs_btree_split	__xfs_btree_split
 #endif /* __KERNEL__ */
 
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
+
+	cur->bc_ops->broot_realloc(cur, 1);
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
@@ -3091,14 +3163,10 @@ xfs_btree_new_iroot(
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
 
@@ -3136,45 +3204,12 @@ xfs_btree_new_iroot(
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
-	cur->bc_ops->broot_realloc(cur, 1);
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
-	*logflags |=
-		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_ino.whichfork);
+	*logflags |= XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_ino.whichfork);
 	*stat = 1;
 	return 0;
 error0:

