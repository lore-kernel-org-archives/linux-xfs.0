Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D2A1CDA13
	for <linux-xfs@vger.kernel.org>; Tue,  3 Sep 2024 04:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725337716; cv=none; b=D9nKXJJrzfXtUEUx4sDV0Nljiiszd+ALDiTuepSe2XTjyaQCawPLlZEzqvXk/9UYBUkT7yRbxvQ9Hbm5qsIVd+JxKakZCbGEiJRhxcEKhXYkg5mAqUVwbJuwfumBsLUB9kHf6xmTkZg/TDm5GcCRKBVhhZobxhDRLJUYed6lINg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725337716; c=relaxed/simple;
	bh=tBvW5Z9lVJtwrSa2hwfVw8ukUvXD+dtVUjtmWo5XFlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKxmFWW9/obs5yfA01n7F6qiCTktK6ipbE6xMtKzt/TWGiTeNItokyNPRcKU0oLIj3sUtZYzmM0ZQvGJvlrrfvIqOvXD9z0TekJ/mDW3SrG+KlxNMwqJzjh3d5k6pXx6xwbfxsbuP/u46FOFgHTF62NQkzs6Zp7mklm0bhYiV8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jAO02Mga; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jAO02Mga"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tslOzHyIw9n2M1OlDaxLxT1sl9Stod98GjZzGOWykLs=; b=jAO02Mga6HDZPr+D3uOwTY89Y8
	/7Cvz5ZZ52f6U3mmpO0EebBx8jYfblD1HbnGhH6QAKQ91Ws4Ps+B9R6/ElZAMnHIdOfrpX93mw000
	XnZatu2B/FAFMtuO8rKAxW/L6wy8PRZ+mU3xrozywifIC6Tv0l4LNll4y1HWxYSCPtT5gGjOXM9o/
	RsY3Owm0bQkz5uBoQ14pq8TxB+ovMPuFd2MRCI45G0Nx2ba0QALs+zt/0p8uenTHiiEXaeieNuLCA
	1r8k2AdCTBh9aeG4u56AepNC/224oa4syt/mVgCarOaGpdaibffROIyAoDgTFcq30aKrVTFSsrFfb
	wCSMwOhQ==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1slL9d-0000000GI6J-004R;
	Tue, 03 Sep 2024 04:28:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/7] xfs: merge xfs_attr_leaf_try_add into xfs_attr_leaf_addname
Date: Tue,  3 Sep 2024 07:27:43 +0300
Message-ID: <20240903042825.2700365-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240903042825.2700365-1-hch@lst.de>
References: <20240903042825.2700365-1-hch@lst.de>
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
2.45.2

