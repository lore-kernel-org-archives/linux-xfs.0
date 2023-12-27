Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6FBCA46
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hW+r9xJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6C3C433C7;
	Mon,  1 Jan 2024 00:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067456;
	bh=Y9G6e5rwpAJuhsd8UJ8Fg89/6N/EJOcdcMoFBECPKAU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hW+r9xJTNQs1XlvN0wz22kgb5ouYqozCEotunentS8WKw3r6H/o1PWMBMhksajQBM
	 vyYXFWSj7O7nkw/BcVI8PNH718y++SHgXghJJkPk4Kn8IVyGrU+QCekfk8rfBlV/D+
	 7/S1/QJloneTiDS0pxya7k0XwS1kqaB5hvZaqq7MY4bjrE31pmzt6+Xji7/mHhSTfs
	 c391aXE0DgE0+NrJuxQRY0htBwgs+jq4thAYURYXddmBqhKIBtkdXIJz+zUoADQNMU
	 sGA4MCv7ka91KHcSXWE13FbWWDcxCBPS52+oF1O2mmDdlrxUIYMLT/3L/PH1BZMNtO
	 7fSMhRYj/8osA==
Date: Sun, 31 Dec 2023 16:04:15 +9900
Subject: [PATCH 12/14] xfs: hoist the node iroot update code out of
 xfs_btree_kill_iroot
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405013363.1812545.7875319221336660828.stgit@frogsfrogsfrogs>
In-Reply-To: <170405013189.1812545.1581948480545654103.stgit@frogsfrogsfrogs>
References: <170405013189.1812545.1581948480545654103.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   94 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 34 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 5a21788c707..0f0198ae0cd 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -3704,6 +3704,63 @@ xfs_btree_insert(
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
+	int			diff;
+
+	/*
+	 * Adjust the root btree node size and the record count to match the
+	 * doomed child so that we can copy the keyptrs ahead of changing the
+	 * tree shape.
+	 */
+	diff = numrecs - cur->bc_ops->get_maxrecs(cur, level);
+	xfs_btree_iroot_realloc(cur, diff);
+	block = xfs_btree_get_iroot(cur);
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
@@ -3716,24 +3773,16 @@ STATIC int
 xfs_btree_kill_iroot(
 	struct xfs_btree_cur	*cur)
 {
-	int			whichfork = cur->bc_ino.whichfork;
 	struct xfs_inode	*ip = cur->bc_ino.ip;
-	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_block	*block;
 	struct xfs_btree_block	*cblock;
-	union xfs_btree_key	*kp;
-	union xfs_btree_key	*ckp;
-	union xfs_btree_ptr	*pp;
-	union xfs_btree_ptr	*cpp;
 	struct xfs_buf		*cbp;
 	int			level;
-	int			index;
 	int			numrecs;
 	int			error;
 #ifdef DEBUG
 	union xfs_btree_ptr	ptr;
 #endif
-	int			i;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
 	ASSERT(cur->bc_nlevels > 1);
@@ -3773,39 +3822,16 @@ xfs_btree_kill_iroot(
 	ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
 #endif
 
-	index = numrecs - cur->bc_ops->get_maxrecs(cur, level);
-	if (index) {
-		xfs_btree_iroot_realloc(cur, index);
-		block = ifp->if_broot;
-	}
-
-	be16_add_cpu(&block->bb_numrecs, index);
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

