Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE8A2CA9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548421; cv=none; b=AggrTPlka2rIeu7TEXsuopOxMnbH0JqIoXZiguSxQ0jpHM6SHfrSxDDiDgZIsF5BXzX/miJ18/3Xg8psrCOtfn0uRQYJ2iZPnZYwcucIknswwaZeeURcOMHG5AKfHvDVLO5G/l879+s3aP6v2fpHF6/39FmUtdA68501YtxGoOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548421; c=relaxed/simple;
	bh=7dNQiJfyRSMyRqjETsUSLQcg+OCcblkIYpXKKxSVboQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RPb5OOQbSaNiNiB1srRPg2reUzIZQLUwDen7j4hlYUIzIr2wSpoLHf5Mu1jyzj4ViLjiKCaXX7SroIrl6gqLKWgsFuJffe4+EgUhstfM4TQVopjjZzo8V5/C1jFeenyLipQH3LZN+9lMbRM1b/9WG6/CNXOfW5YwqRpz3PQemgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q+XMWZKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q+XMWZKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362F8C4CEE4;
	Mon, 21 Oct 2024 22:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548421;
	bh=7dNQiJfyRSMyRqjETsUSLQcg+OCcblkIYpXKKxSVboQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q+XMWZKJCZdZPMZEfjcEOxoayaiFg0AXIOmMMEAoyDRlVdrrDbreRsMRXdQnT0GJt
	 unOLoFriBcZ0uPJrqyrswEKK+Yl/8DKRl/1wdKDneUgo7bTc8mXfjmc2h1dQdxCuV8
	 rXucXq7HmedS+H3o1w5bcRPjGvoXD/q/RnTpOcoCVEj7Ljzdkup4wMxKdgxMYH5x2L
	 JbNmsKd6s4XI/bJxfynLrl7rCGXevMdCh8BC/yDqVbwdzLUf16mw/KqZaTN7MF2Iw1
	 LjdjJruEbcAEInHRrOXxZ9e+xnCrGghhGN3pw2XMQdAWbLzK2kqDoILZDMOigvHAAu
	 Q8FlCR45xQovg==
Date: Mon, 21 Oct 2024 15:07:00 -0700
Subject: [PATCH 31/37] xfs: return bool from xfs_attr3_leaf_add
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783940.34558.9452060147958145742.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 346c1d46d4c631c0c88592d371f585214d714da4

xfs_attr3_leaf_add only has two potential return values, indicating if the
entry could be added or not.  Replace the errno return with a bool so that
ENOSPC from it can't easily be confused with a real ENOSPC.

Remove the return value from the xfs_attr3_leaf_add_work helper entirely,
as it always return 0.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_attr.c      |   13 +++++--------
 libxfs/xfs_attr_leaf.c |   37 +++++++++++++++++++------------------
 libxfs/xfs_attr_leaf.h |    2 +-
 3 files changed, 25 insertions(+), 27 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 21c708beac60c7..9ac7124b0a7bc1 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -556,10 +556,7 @@ xfs_attr_leaf_addname(
 	 * or perform more xattr manipulations. Otherwise there is nothing more
 	 * to do and we can return success.
 	 */
-	error = xfs_attr3_leaf_add(bp, args);
-	if (error) {
-		if (error != -ENOSPC)
-			return error;
+	if (!xfs_attr3_leaf_add(bp, args)) {
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
@@ -573,7 +570,7 @@ xfs_attr_leaf_addname(
 	}
 
 	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
-	return error;
+	return 0;
 
 out_brelse:
 	xfs_trans_brelse(args->trans, bp);
@@ -1398,21 +1395,21 @@ xfs_attr_node_try_addname(
 {
 	struct xfs_da_state		*state = attr->xattri_da_state;
 	struct xfs_da_state_blk		*blk;
-	int				error;
+	int				error = 0;
 
 	trace_xfs_attr_node_addname(state->args);
 
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
-	error = xfs_attr3_leaf_add(blk->bp, state->args);
-	if (error == -ENOSPC) {
+	if (!xfs_attr3_leaf_add(blk->bp, state->args)) {
 		if (state->path.active == 1) {
 			/*
 			 * Its really a single leaf node, but it had
 			 * out-of-line values so it looked like it *might*
 			 * have been a b-tree. Let the caller deal with this.
 			 */
+			error = -ENOSPC;
 			goto out;
 		}
 
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index db2e48d719d36f..3028ef0cd3cb2c 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -44,7 +44,7 @@
  */
 STATIC int xfs_attr3_leaf_create(struct xfs_da_args *args,
 				 xfs_dablk_t which_block, struct xfs_buf **bpp);
-STATIC int xfs_attr3_leaf_add_work(struct xfs_buf *leaf_buffer,
+STATIC void xfs_attr3_leaf_add_work(struct xfs_buf *leaf_buffer,
 				   struct xfs_attr3_icleaf_hdr *ichdr,
 				   struct xfs_da_args *args, int freemap_index);
 STATIC void xfs_attr3_leaf_compact(struct xfs_da_args *args,
@@ -992,10 +992,8 @@ xfs_attr_shortform_to_leaf(
 		xfs_attr_sethash(&nargs);
 		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error == -ENOATTR);
-		error = xfs_attr3_leaf_add(bp, &nargs);
-		ASSERT(error != -ENOSPC);
-		if (error)
-			goto out;
+		if (!xfs_attr3_leaf_add(bp, &nargs))
+			ASSERT(0);
 		sfe = xfs_attr_sf_nextentry(sfe);
 	}
 	error = 0;
@@ -1337,8 +1335,9 @@ xfs_attr3_leaf_split(
 	struct xfs_da_state_blk	*oldblk,
 	struct xfs_da_state_blk	*newblk)
 {
-	xfs_dablk_t blkno;
-	int error;
+	bool			added;
+	xfs_dablk_t		blkno;
+	int			error;
 
 	trace_xfs_attr_leaf_split(state->args);
 
@@ -1373,10 +1372,10 @@ xfs_attr3_leaf_split(
 	 */
 	if (state->inleaf) {
 		trace_xfs_attr_leaf_add_old(state->args);
-		error = xfs_attr3_leaf_add(oldblk->bp, state->args);
+		added = xfs_attr3_leaf_add(oldblk->bp, state->args);
 	} else {
 		trace_xfs_attr_leaf_add_new(state->args);
-		error = xfs_attr3_leaf_add(newblk->bp, state->args);
+		added = xfs_attr3_leaf_add(newblk->bp, state->args);
 	}
 
 	/*
@@ -1384,13 +1383,15 @@ xfs_attr3_leaf_split(
 	 */
 	oldblk->hashval = xfs_attr_leaf_lasthash(oldblk->bp, NULL);
 	newblk->hashval = xfs_attr_leaf_lasthash(newblk->bp, NULL);
-	return error;
+	if (!added)
+		return -ENOSPC;
+	return 0;
 }
 
 /*
  * Add a name to the leaf attribute list structure.
  */
-int
+bool
 xfs_attr3_leaf_add(
 	struct xfs_buf		*bp,
 	struct xfs_da_args	*args)
@@ -1399,6 +1400,7 @@ xfs_attr3_leaf_add(
 	struct xfs_attr3_icleaf_hdr ichdr;
 	int			tablesize;
 	int			entsize;
+	bool			added = true;
 	int			sum;
 	int			tmp;
 	int			i;
@@ -1427,7 +1429,7 @@ xfs_attr3_leaf_add(
 		if (ichdr.freemap[i].base < ichdr.firstused)
 			tmp += sizeof(xfs_attr_leaf_entry_t);
 		if (ichdr.freemap[i].size >= tmp) {
-			tmp = xfs_attr3_leaf_add_work(bp, &ichdr, args, i);
+			xfs_attr3_leaf_add_work(bp, &ichdr, args, i);
 			goto out_log_hdr;
 		}
 		sum += ichdr.freemap[i].size;
@@ -1439,7 +1441,7 @@ xfs_attr3_leaf_add(
 	 * no good and we should just give up.
 	 */
 	if (!ichdr.holes && sum < entsize)
-		return -ENOSPC;
+		return false;
 
 	/*
 	 * Compact the entries to coalesce free space.
@@ -1452,24 +1454,24 @@ xfs_attr3_leaf_add(
 	 * free region, in freemap[0].  If it is not big enough, give up.
 	 */
 	if (ichdr.freemap[0].size < (entsize + sizeof(xfs_attr_leaf_entry_t))) {
-		tmp = -ENOSPC;
+		added = false;
 		goto out_log_hdr;
 	}
 
-	tmp = xfs_attr3_leaf_add_work(bp, &ichdr, args, 0);
+	xfs_attr3_leaf_add_work(bp, &ichdr, args, 0);
 
 out_log_hdr:
 	xfs_attr3_leaf_hdr_to_disk(args->geo, leaf, &ichdr);
 	xfs_trans_log_buf(args->trans, bp,
 		XFS_DA_LOGRANGE(leaf, &leaf->hdr,
 				xfs_attr3_leaf_hdr_size(leaf)));
-	return tmp;
+	return added;
 }
 
 /*
  * Add a name to a leaf attribute list structure.
  */
-STATIC int
+STATIC void
 xfs_attr3_leaf_add_work(
 	struct xfs_buf		*bp,
 	struct xfs_attr3_icleaf_hdr *ichdr,
@@ -1587,7 +1589,6 @@ xfs_attr3_leaf_add_work(
 		}
 	}
 	ichdr->usedbytes += xfs_attr_leaf_entsize(leaf, args->index);
-	return 0;
 }
 
 /*
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index bac219589896ad..589f810eedc0d8 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -76,7 +76,7 @@ int	xfs_attr3_leaf_split(struct xfs_da_state *state,
 int	xfs_attr3_leaf_lookup_int(struct xfs_buf *leaf,
 					struct xfs_da_args *args);
 int	xfs_attr3_leaf_getvalue(struct xfs_buf *bp, struct xfs_da_args *args);
-int	xfs_attr3_leaf_add(struct xfs_buf *leaf_buffer,
+bool	xfs_attr3_leaf_add(struct xfs_buf *leaf_buffer,
 				 struct xfs_da_args *args);
 int	xfs_attr3_leaf_remove(struct xfs_buf *leaf_buffer,
 				    struct xfs_da_args *args);

