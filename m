Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6115D14287
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 00:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051589; cv=none; b=ZFkNNxRcaoMJgeyOdN7qI55F/iuRc0/+3vB1ObdA+GrYr6RASnZRzYDCoTSxHfCMINXULaAoS0zqJAPuZKVRWj+Jq68qZzr7i1WtAEoaRrOp6UraJNX+CIiPmF9KKpvr/YruFOqeWT+xRhyxeP9Ch2+FrJQT5LgA2hBthmxmrvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051589; c=relaxed/simple;
	bh=jKntoX+VVJwtqtyAupOucEX+i4XhfWVjVNW6f+ydVwI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZXRhAk4T/WoOB85+5n0PNNG1ENXEd+g7kkYzVBmFiZ7baxb9KhvY08h/5+6fGpOSR83naaiTDEug4iQQ/OhiGoFk7XAc1jXOfXKR0FZ0QSfkzCq+VRWIMvSTjIpcZVHFbpLVxC3SAGkN+zrWHqZziHrVVGuJ+GkpiV6Ic3tpcxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qx25Jg9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qx25Jg9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C648BC4CECE;
	Fri, 13 Dec 2024 00:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051588;
	bh=jKntoX+VVJwtqtyAupOucEX+i4XhfWVjVNW6f+ydVwI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qx25Jg9e8g5GjxucF4xKziPG4fmK7Yzo3uGmJzQZVt+m74gVX5/aafiNXvI+mh3w+
	 ygFAtAVacKaNkboxy2t5HYfu53UDbS6kqSeinMoK0BBZcJ9eAujrDgd4N32ZzK6uM2
	 /cAl6QPxz8g1Cx8p/n1qsE8xjmpTIV8/hS//A7BNoSMmXPiPKKL2WSFlNrQFm82cMh
	 ti7TvlIWFkLm3TAUWmihOBBWiYvec5l9s3bTKI7g9hgswkegELe8bUjHbJVxuKgOfF
	 Y3slvyqugPOV07raLKdCeOkoFxVkZ87RMpQiPID5mgTdDa7skWMhMVSb2Bqvjyyt9A
	 b054oeK0BDIsA==
Date: Thu, 12 Dec 2024 16:59:48 -0800
Subject: [PATCH 7/8] xfs: hoist the node iroot update code out of
 xfs_btree_kill_iroot
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405122280.1180922.16807915359252437057.stgit@frogsfrogsfrogs>
In-Reply-To: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
References: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
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
code that copies keyptrs from an existing node child into the root block
to a separate function.  Remove some unnecessary conditionals and clean
up a few function calls in the new function.  Note that this change
reorders the ->free_block call with respect to the change in bc_nlevels
to make it easier to support inode root leaf blocks in the next patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   84 +++++++++++++++++++++++++++++++--------------
 1 file changed, 57 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index ed09eeee916160..e83a8de5fb8746 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3726,6 +3726,60 @@ xfs_btree_insert(
 	return error;
 }
 
+/*
+ * Move the keyptrs from a child node block to the root block.
+ *
+ * Since the keyptr size does not change, all we have to do is increase the
+ * tree height, copy the keyptrs to the new internal node (cblock), shrink
+ * the root, and copy the pointers there.
+ */
+STATIC int
+xfs_btree_demote_node_child(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*cblock,
+	int			level,
+	int			numrecs)
+{
+	struct xfs_btree_block	*block;
+	union xfs_btree_key	*ckp;
+	union xfs_btree_key	*kp;
+	union xfs_btree_ptr	*cpp;
+	union xfs_btree_ptr	*pp;
+	int			i;
+	int			error;
+
+	/*
+	 * Adjust the root btree node size and the record count to match the
+	 * doomed child so that we can copy the keyptrs ahead of changing the
+	 * tree shape.
+	 */
+	block = cur->bc_ops->broot_realloc(cur, numrecs);
+
+	xfs_btree_set_numrecs(block, numrecs);
+	ASSERT(block->bb_numrecs == cblock->bb_numrecs);
+
+	/* Copy keys from the doomed block. */
+	kp = xfs_btree_key_addr(cur, 1, block);
+	ckp = xfs_btree_key_addr(cur, 1, cblock);
+	xfs_btree_copy_keys(cur, kp, ckp, numrecs);
+
+	/* Copy pointers from the doomed block. */
+	pp = xfs_btree_ptr_addr(cur, 1, block);
+	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
+	for (i = 0; i < numrecs; i++) {
+		error = xfs_btree_debug_check_ptr(cur, cpp, i, level - 1);
+		if (error)
+			return error;
+	}
+	xfs_btree_copy_ptrs(cur, pp, cpp, numrecs);
+
+	/* Decrease tree height, adjusting the root block level to match. */
+	cur->bc_levels[level - 1].bp = NULL;
+	be16_add_cpu(&block->bb_level, -1);
+	cur->bc_nlevels--;
+	return 0;
+}
+
 /*
  * Try to merge a non-leaf block back into the inode root.
  *
@@ -3741,10 +3795,6 @@ xfs_btree_kill_iroot(
 	struct xfs_inode	*ip = cur->bc_ino.ip;
 	struct xfs_btree_block	*block;
 	struct xfs_btree_block	*cblock;
-	union xfs_btree_key	*kp;
-	union xfs_btree_key	*ckp;
-	union xfs_btree_ptr	*pp;
-	union xfs_btree_ptr	*cpp;
 	struct xfs_buf		*cbp;
 	int			level;
 	int			numrecs;
@@ -3752,7 +3802,6 @@ xfs_btree_kill_iroot(
 #ifdef DEBUG
 	union xfs_btree_ptr	ptr;
 #endif
-	int			i;
 
 	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_INODE);
 	ASSERT(cur->bc_nlevels > 1);
@@ -3792,35 +3841,16 @@ xfs_btree_kill_iroot(
 	ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
 #endif
 
-	block = cur->bc_ops->broot_realloc(cur, numrecs);
-
-	block->bb_numrecs = be16_to_cpu(numrecs);
-	ASSERT(block->bb_numrecs == cblock->bb_numrecs);
-
-	kp = xfs_btree_key_addr(cur, 1, block);
-	ckp = xfs_btree_key_addr(cur, 1, cblock);
-	xfs_btree_copy_keys(cur, kp, ckp, numrecs);
-
-	pp = xfs_btree_ptr_addr(cur, 1, block);
-	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
-
-	for (i = 0; i < numrecs; i++) {
-		error = xfs_btree_debug_check_ptr(cur, cpp, i, level - 1);
-		if (error)
-			return error;
-	}
-
-	xfs_btree_copy_ptrs(cur, pp, cpp, numrecs);
+	error = xfs_btree_demote_node_child(cur, cblock, level, numrecs);
+	if (error)
+		return error;
 
 	error = xfs_btree_free_block(cur, cbp);
 	if (error)
 		return error;
 
-	cur->bc_levels[level - 1].bp = NULL;
-	be16_add_cpu(&block->bb_level, -1);
 	xfs_trans_log_inode(cur->bc_tp, ip,
 		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_ino.whichfork));
-	cur->bc_nlevels--;
 out0:
 	return 0;
 }

