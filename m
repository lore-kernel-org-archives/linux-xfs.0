Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A21419E985
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636158; cv=none; b=aIUUdphgyqyumuyjbYO1cHpxVfIgaCtyOypED9C7MypUowI/Qk8C28/mEmU/O8jwO/LSfMQ6hpcmlpby5Y9EFaL+APBFaW/YLF75JV/PZwpyOMaf8kNx0Hv0zYeaLySdtSkb9MV209aL6FUEqXtUmVsPuk2a4KAL2WamlOQDsp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636158; c=relaxed/simple;
	bh=is33j7my9Q1gLEW+Pwd/LiMHK9XqVMb325AJdQg9TQg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bu7kGF1iCRKFXSiqU/+5kGFakj5pJ4eVamdKD/z3d/DGzXLvEPvmNFkCfH6d09rzy5ZjNOz29i7oAqs7O9aTPJoKGE0lVzR+NSRgMjoVM1T9+skek8mkCszPuBbjVQR1pf1OzWQObH9I/pVYqIO4RDylU6lRLyuEHPYIJYjSuww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d9mK6hru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d9mK6hru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE7CC4CECE;
	Thu, 19 Dec 2024 19:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636157;
	bh=is33j7my9Q1gLEW+Pwd/LiMHK9XqVMb325AJdQg9TQg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d9mK6hruVpmPQxGj03KLuoXLPrAY7xXpSIQB71OFGu8arLjr004twEHjkIvGsx4SJ
	 msyL3oZfDrIJXvUv6FxSHgYuDIsI8wbDOI0fw6Vz22/JJ44Qvw5cwQWON2aA+h/qVe
	 gA0Gl3BedIe1JQvkFzPNMyuw1LqWodf2CiCCk9AmKkULKYm95ribVHYCoLk9xF0SKq
	 2QcDE3tvS6TVH/dNN1sGxNIRijnOGT0Fwwa5jPG8ic7MPdls8E3h6/mHfIRlGyV7ib
	 2zDztDJhU8T86+X9/BUhWeaZeOGRa/dmMTLbcCLgdxhmHJwDgJ+5irSYyyzBvWjYX6
	 vAVQ7166RmgAw==
Date: Thu, 19 Dec 2024 11:22:37 -0800
Subject: [PATCH 7/8] xfs: hoist the node iroot update code out of
 xfs_btree_kill_iroot
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463578770.1571062.10151970909407600917.stgit@frogsfrogsfrogs>
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

