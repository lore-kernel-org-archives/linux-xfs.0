Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F1D7462
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994553; cv=none; b=NXP+Wh5RXsMOyEoRFlPHTpoXuzmUpt8Xii2SHGua5JMK4cMvimVtDAdr5ohg0Q+tBZKfy/AaFwH6YHwVCqNkCDln3e2aJPwU+l7JW7opLZ07qesVNzlhKKiEgjf4tmbgM1fju03/ONCZHve00blRklVbHUHtRcDxZpJEJUFkNFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994553; c=relaxed/simple;
	bh=is33j7my9Q1gLEW+Pwd/LiMHK9XqVMb325AJdQg9TQg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l/TAZchH0zvmQPgZkHREcm+QOyEzWkJu2cJ1rOlLO6OtDxo9M5js36C4K0KO7Yfv0RLMFhUWGrpjTsjE9mVGYYYPiTOQZ+G2VK9AC3ix7aOfPrzgsDfpOIOio5uNIF3miqoFVzUYoxpVaeyOxrJjcCfX87cbiJcAWO3gCAa2r2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lCtLNUhV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lCtLNUhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1164C4CED3;
	Mon, 23 Dec 2024 22:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994552;
	bh=is33j7my9Q1gLEW+Pwd/LiMHK9XqVMb325AJdQg9TQg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lCtLNUhVvBVzQZq/Rx7TQfXC5P2jJr+FOMkznSVnDM3+W6bJMil2X0PAkL6VfoNIZ
	 0HEahH6cJ0dg+DjPs6ii2iZZOwHHAyN5sepo4PplQ3Nm6E56h3toCJNXw++u5UD9jJ
	 NMZbSL5bY8VMELyFCbfktV2Q0jcHH+dWUFBbF+VXEt0WZ4S0TJWQ6h1QyXDAZga0z1
	 yk3mqZsKdLUWI1oHFJUUy2GTEmaZ61ZrYpMzYF9QwQfALpEeyosTw06geuqC6YAzOm
	 fVh1Jd5lvRg3rxFOq2JnVfaoMSK+ijIXqkDIEQLzM00yMJSMScYckvXqGd7Tl6JpwR
	 kKBMgHvYT5yYA==
Date: Mon, 23 Dec 2024 14:55:52 -0800
Subject: [PATCH 7/8] xfs: hoist the node iroot update code out of
 xfs_btree_kill_iroot
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499417719.2379682.6853986468940948444.stgit@frogsfrogsfrogs>
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
code that copies keyptrs from an existing node child into the root block
to a separate function.  Remove some unnecessary conditionals and clean
up a few function calls in the new function.  Note that this change
reorders the ->free_block call with respect to the change in bc_nlevels
to make it easier to support inode root leaf blocks in the next patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

