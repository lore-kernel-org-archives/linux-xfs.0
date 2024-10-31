Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CCB197A81
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416591; cv=none; b=YDOM6wtcjTdTcxC2Q9RTx4wY0Z0TKvbPM8K0bRrLCbSTamHi/N2ZyMxJjioRaB6f6k1XapO6QmHNbKSggXFbZbHJkVE8HQGB6ZI32lKu7NVBEODoa/AikjdFojLE3oSQxAtENAHfJlsFw6Nfky8q8PHi/eCX62ix4AcWzUBhnRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416591; c=relaxed/simple;
	bh=118/3KLdqtx9r1gFXye0oHE02j++kJbovvk0tJ/SVV4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vk0g6jf2fkn2XPXzrtSnEeT5x12EDlXMCI4v2azigrip/GtT30JRIKFKbIE4Np4ihMyCuCF9dVemFqcYpTRRGXInfVbHek0+NXaUQXBHkE3Rj9afUwgJXvaU6Bp+9mMU+rcbaldkv7Fv1CuROXVrGpGh04qpH4+PgNUV8lBpstA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OSxhn8et; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OSxhn8et"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE3FC4CEC3;
	Thu, 31 Oct 2024 23:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416591;
	bh=118/3KLdqtx9r1gFXye0oHE02j++kJbovvk0tJ/SVV4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OSxhn8etUNfWn67k1wDbfANDVdWSrRX0qSNIaNS1E4mGSyUwWtz4Uks39Upz3VvwS
	 vnTSPyphNhNNAuURPSJc4AXah3MnzV7xTv8xBg1LZOtmhq1Hpjcahdk1j4lVSe3HD6
	 25XlqOWxUh2v2SqALeBgXncAUzDCpx0DSUXDkK5p+WHPMAV7oeFvV0gSY0JFZo5J0V
	 wC4mT8XJf0qOAhLlNDTvtWIkjt3vDbNMNLWKC2wa1+/Vr+MiHVYF5nvTDPJB/F3xB5
	 2H/qjMq6WL6VbGToyFqsef8MxDCwkCjVX6qc5ekLWUbyFhqEydB6ndNxhDxz9WE/dZ
	 +oPVT1FPRI1RQ==
Date: Thu, 31 Oct 2024 16:16:30 -0700
Subject: [PATCH 30/41] xfs: merge xfs_attr_leaf_try_add into
 xfs_attr_leaf_addname
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566375.962545.14418281308095251932.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: b1c649da15c2e4c86344c8e5af69c8afa215efec

xfs_attr_leaf_try_add is only called by xfs_attr_leaf_addname, and
merging the two will simplify a following error handling fix.

To facilitate this move the remote block state save/restore helpers up in
the file so that they don't need forward declarations now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_attr.c |  176 ++++++++++++++++++++++-------------------------------
 1 file changed, 74 insertions(+), 102 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 9e1cce5776b3df..21c708beac60c7 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -50,7 +50,6 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
-STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -436,6 +435,33 @@ xfs_attr_hashval(
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
@@ -481,49 +507,77 @@ xfs_attr_complete_op(
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
@@ -1169,88 +1223,6 @@ xfs_attr_shortform_addname(
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

