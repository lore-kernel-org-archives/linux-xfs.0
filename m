Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C6B26AFB
	for <linux-xfs@vger.kernel.org>; Sat, 24 Aug 2024 03:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724470869; cv=none; b=HXUE/eA/elZDdwDKH6PgF29HYZcKBjp27FlJ5hjQkdozPiKMi1FjTbUIjgg05Wjz1+HDnLPKFQW30gSSwJztTbqrnUbAWXPX73OlNzDu1UKOE1tFTyZzh03YngED4Us3PDUtgVKfPP3CMq6hVeAXjArBx/QgXPZWkJb08FdcLWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724470869; c=relaxed/simple;
	bh=EU/hk6TgT8VvhDrHS6zKjTWIsbOiGPA5SYHs3KL/GUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoPTAenstCeEiqOd5ITyoDReotWR6mczmhgwUZFDp6Sou/49Caof7d+hWmNA23pCqUo1OUAEZyKmehgZ3sm9G6ufHqyDdWg4QREUZ331KON+6S2MGNgGn99MpFF+7iwQsJCl/ZS+QMFh0QkrqjD+2mV9cDn18MHDGcIqSpwzlnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b6hIJRRH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b6hIJRRH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wK+jMvys2kcQvsBhkNPMjz/OZhHGfbnBJE61BhsEFS4=; b=b6hIJRRHD/T/0wKccci1RIDirB
	MryFB+lawkhjs9jbrnybUbUp6Zl0bA7wpdU6d2PSA4gRqyoAIc5I8oBAMboFHylU2R4r1qxOxCGM/
	hyJKNgeB3JTytu6HtMqC6+4H39ELmkOgBd8BVe+HFvkOjiuCKJ8+GR/5JOIg1AVrxS08CP9A/dMit
	kX19XmaIOaMnaZ7CQ0LJf+mdYMIv75kS/i3wl9RZvj6UJT8TQpLj7Z2twpqHnAhSZdUPmsgGrc88d
	/LhqzoEGuUsk9YVIPMvEVihDVnmgZ1ZsNi9lg72RF8xbiSQ7TFqOcOkc0JUD+wHiy95Q2jNxh2RjU
	IzdALNpQ==;
Received: from 2a02-8389-2341-5b80-7457-864c-9b77-b751.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:7457:864c:9b77:b751] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shheC-00000001MPe-39hj;
	Sat, 24 Aug 2024 03:41:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] xfs: merge xfs_attr_leaf_try_add into xfs_attr_leaf_addname
Date: Sat, 24 Aug 2024 05:40:07 +0200
Message-ID: <20240824034100.1163020-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240824034100.1163020-1-hch@lst.de>
References: <20240824034100.1163020-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_attr_leaf_try_add is only called by xfs_attr_leaf_addname, and
merging the two will simplify a following error handling fix.

To facilitate this move the remote block state save/restore helpers up in
the file so that they don't need forward declarations now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 176 ++++++++++++++++-----------------------
 1 file changed, 74 insertions(+), 102 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f30bcc64100d56..b9df7a6b1f9d61 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -51,7 +51,6 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
-STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -437,6 +436,33 @@ xfs_attr_hashval(
 	return xfs_attr_hashname(name, namelen);
 }
 
+/* Save the current remote block info and clear the current pointers. */
+static void
+xfs_attr_save_rmt_blk(
+	struct xfs_da_args	*args)
+{
+	args->blkno2 = args->blkno;
+	args->index2 = args->index;
+	args->rmtblkno2 = args->rmtblkno;
+	args->rmtblkcnt2 = args->rmtblkcnt;
+	args->rmtvaluelen2 = args->rmtvaluelen;
+	args->rmtblkno = 0;
+	args->rmtblkcnt = 0;
+	args->rmtvaluelen = 0;
+}
+
+/* Set stored info about a remote block */
+static void
+xfs_attr_restore_rmt_blk(
+	struct xfs_da_args	*args)
+{
+	args->blkno = args->blkno2;
+	args->index = args->index2;
+	args->rmtblkno = args->rmtblkno2;
+	args->rmtblkcnt = args->rmtblkcnt2;
+	args->rmtvaluelen = args->rmtvaluelen2;
+}
+
 /*
  * PPTR_REPLACE operations require the caller to set the old and new names and
  * values explicitly.  Update the canonical fields to the new name and value
@@ -482,49 +508,77 @@ xfs_attr_complete_op(
 	return replace_state;
 }
 
+/*
+ * Try to add an attribute to an inode in leaf form.
+ */
 static int
 xfs_attr_leaf_addname(
 	struct xfs_attr_intent	*attr)
 {
 	struct xfs_da_args	*args = attr->xattri_da_args;
+	struct xfs_buf		*bp;
 	int			error;
 
 	ASSERT(xfs_attr_is_leaf(args->dp));
 
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, &bp);
+	if (error)
+		return error;
+
 	/*
-	 * Use the leaf buffer we may already hold locked as a result of
-	 * a sf-to-leaf conversion.
+	 * Look up the xattr name to set the insertion point for the new xattr.
 	 */
-	error = xfs_attr_leaf_try_add(args);
-
-	if (error == -ENOSPC) {
-		error = xfs_attr3_leaf_to_node(args);
-		if (error)
-			return error;
+	error = xfs_attr3_leaf_lookup_int(bp, args);
+	switch (error) {
+	case -ENOATTR:
+		if (args->op_flags & XFS_DA_OP_REPLACE)
+			goto out_brelse;
+		break;
+	case -EEXIST:
+		if (!(args->op_flags & XFS_DA_OP_REPLACE))
+			goto out_brelse;
 
+		trace_xfs_attr_leaf_replace(args);
 		/*
-		 * We're not in leaf format anymore, so roll the transaction and
-		 * retry the add to the newly allocated node block.
+		 * Save the existing remote attr state so that the current
+		 * values reflect the state of the new attribute we are about to
+		 * add, not the attribute we just found and will remove later.
 		 */
-		attr->xattri_dela_state = XFS_DAS_NODE_ADD;
-		goto out;
+		xfs_attr_save_rmt_blk(args);
+		break;
+	case 0:
+		break;
+	default:
+		goto out_brelse;
 	}
-	if (error)
-		return error;
 
 	/*
 	 * We need to commit and roll if we need to allocate remote xattr blocks
 	 * or perform more xattr manipulations. Otherwise there is nothing more
 	 * to do and we can return success.
 	 */
-	if (args->rmtblkno)
+	error = xfs_attr3_leaf_add(bp, args);
+	if (error) {
+		if (error != -ENOSPC)
+			return error;
+		error = xfs_attr3_leaf_to_node(args);
+		if (error)
+			return error;
+
+		attr->xattri_dela_state = XFS_DAS_NODE_ADD;
+	} else if (args->rmtblkno) {
 		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
-	else
-		attr->xattri_dela_state = xfs_attr_complete_op(attr,
-							XFS_DAS_LEAF_REPLACE);
-out:
+	} else {
+		attr->xattri_dela_state =
+			xfs_attr_complete_op(attr, XFS_DAS_LEAF_REPLACE);
+	}
+
 	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
 	return error;
+
+out_brelse:
+	xfs_trans_brelse(args->trans, bp);
+	return error;
 }
 
 /*
@@ -1170,88 +1224,6 @@ xfs_attr_shortform_addname(
  * External routines when attribute list is one block
  *========================================================================*/
 
-/* Save the current remote block info and clear the current pointers. */
-static void
-xfs_attr_save_rmt_blk(
-	struct xfs_da_args	*args)
-{
-	args->blkno2 = args->blkno;
-	args->index2 = args->index;
-	args->rmtblkno2 = args->rmtblkno;
-	args->rmtblkcnt2 = args->rmtblkcnt;
-	args->rmtvaluelen2 = args->rmtvaluelen;
-	args->rmtblkno = 0;
-	args->rmtblkcnt = 0;
-	args->rmtvaluelen = 0;
-}
-
-/* Set stored info about a remote block */
-static void
-xfs_attr_restore_rmt_blk(
-	struct xfs_da_args	*args)
-{
-	args->blkno = args->blkno2;
-	args->index = args->index2;
-	args->rmtblkno = args->rmtblkno2;
-	args->rmtblkcnt = args->rmtblkcnt2;
-	args->rmtvaluelen = args->rmtvaluelen2;
-}
-
-/*
- * Tries to add an attribute to an inode in leaf form
- *
- * This function is meant to execute as part of a delayed operation and leaves
- * the transaction handling to the caller.  On success the attribute is added
- * and the inode and transaction are left dirty.  If there is not enough space,
- * the attr data is converted to node format and -ENOSPC is returned. Caller is
- * responsible for handling the dirty inode and transaction or adding the attr
- * in node format.
- */
-STATIC int
-xfs_attr_leaf_try_add(
-	struct xfs_da_args	*args)
-{
-	struct xfs_buf		*bp;
-	int			error;
-
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, &bp);
-	if (error)
-		return error;
-
-	/*
-	 * Look up the xattr name to set the insertion point for the new xattr.
-	 */
-	error = xfs_attr3_leaf_lookup_int(bp, args);
-	switch (error) {
-	case -ENOATTR:
-		if (args->op_flags & XFS_DA_OP_REPLACE)
-			goto out_brelse;
-		break;
-	case -EEXIST:
-		if (!(args->op_flags & XFS_DA_OP_REPLACE))
-			goto out_brelse;
-
-		trace_xfs_attr_leaf_replace(args);
-		/*
-		 * Save the existing remote attr state so that the current
-		 * values reflect the state of the new attribute we are about to
-		 * add, not the attribute we just found and will remove later.
-		 */
-		xfs_attr_save_rmt_blk(args);
-		break;
-	case 0:
-		break;
-	default:
-		goto out_brelse;
-	}
-
-	return xfs_attr3_leaf_add(bp, args);
-
-out_brelse:
-	xfs_trans_brelse(args->trans, bp);
-	return error;
-}
-
 /*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
-- 
2.43.0

