Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632C7194A73
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636142; cv=none; b=GGY5BjMo5qY/2sr76yOloq27u90y8MCjRFcng9nk+B8Gs2QArbGKW0EoB4Jgmy3Khw8pf8efOsOYJBxAHbBGgGcmVhDacaqJkr3QJegvRcGHwnyNYZyz3oN7AmVYiZ7S9s46NJnS7aTDPU1WEOPQpZrOVSkBHAxmhYWp7XigmLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636142; c=relaxed/simple;
	bh=85JbGjkkPI2HkN089DZD0SSmdQV7DjxhJMd0rku1rso=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TrrEI2Smaijx0Ws7SLV+hPPBod/U9Cwse9RaI/KDJ7NSqrqCNmqPYC+uhchdfCymr5MXEESCgArz5x/zTLMHuBUYgeqPT3E4DTDWyY2ut2GRZfrUdvtuoiPLHDdm7B5sZyf6LGmpnqtl3LA0qiWxdXup8bz+J7k0y3bgLy64JIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFuPPG8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFuPPG8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC53DC4CECE;
	Thu, 19 Dec 2024 19:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636141;
	bh=85JbGjkkPI2HkN089DZD0SSmdQV7DjxhJMd0rku1rso=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZFuPPG8l43BUFVLT9PuX6E7LAxsWEXj1UQ0ew4WCJHf7JsUwK8dtHOKW1pWVDx9TB
	 WqEmprbaDvOGqlIVOJlv/GdKVdIjTuo+sjHg91bGoeWMJfvy1Af3RE9W+uP/OWUmnu
	 kXdDZj+fAI1vLt6wDg3me4OJdm/z7kK79R9cCP9b3iUr5fTeeY1QGM88Y389tVZkDf
	 4Cr+YNeX+DELhgdT6EekZi81Egjz4E7Z0pCvIJ/c7WDj8jAZ2BGj+sQgI93nBa96KT
	 Iz5Dp1UGrK21WaCN4aE1k5hcbXw+BJna5qXXQIISo5jK2D59GMn6OITyIXDOqhcZtq
	 MurdZwM6SNDoQ==
Date: Thu, 19 Dec 2024 11:22:21 -0800
Subject: [PATCH 6/8] xfs: hoist the node iroot update code out of
 xfs_btree_new_iroot
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463578753.1571062.4558580052014705437.stgit@frogsfrogsfrogs>
In-Reply-To: <173463578631.1571062.6149474539778937307.stgit@frogsfrogsfrogs>
References: <173463578631.1571062.6149474539778937307.stgit@frogsfrogsfrogs>
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

