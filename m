Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E03957314
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423251; cv=none; b=NBPNpIOX3QORyWGI7Nhfga/4F83e13X2wIGvwcmKWnO/UT2ptGgfYWw5NIz8WV6K84UQL74OdoJ4S8HGcKAJ6X98AqIYUc+Ca9Yq3XfTXdyemnAUtvLVye0mdo6UunsQ360d+60ivYT8CUo+lu69aAg9Qx53ci5J9gdIxLvsRuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423251; c=relaxed/simple;
	bh=xNjkEz8RqzXm8pN1UqFIvbRAagulbtlEOwuDeuEmd0w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bayWLJZ/800AXwp+mLEl0MoIjHNWC6hB+lpqsT1Ndwggiq4XbsgPtIOHbwLM/d5hoVCN0mJyv9nDiwFw35/S/YEefJHjyifbblChMj4qCu1JAAxuY5lh9B8rXfKpoUxDXfgBCuXVwDJYzgZaPtrDmfI5eHviAaY+AD684MIN5Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NE2LPaxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NE2LPaxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14439C433F1;
	Tue, 26 Mar 2024 03:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423251;
	bh=xNjkEz8RqzXm8pN1UqFIvbRAagulbtlEOwuDeuEmd0w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NE2LPaxe5FTZFhOSV8dlk9E7NYit3afmDeUZWeI5N3AuWOBMtL8Do1mcDzgIDzDrz
	 fUow0yDEYS8cLsH3dnCBd6kLrAoTO3nMR09b4JVTDgsXGU/9KNdEpTmeZ9rpVrO8bU
	 h+WiH4c0NY9oJ58OqKNFC9zqm0c9D6USrgO4mFfvzjolsCM4Nwv15rGJs1zchesgSJ
	 gmhgYn40NFwcWC0vZ6U+3laUnFqlx8SNPFRv7IioC+oUISkFR4DoZLTp94myDCcg9W
	 7igpnG1BJsCUPjA8vVxsBe//fWHdwCcbHwTZYTXBxIeX4fPcoTiN3+0qt95C3IQA4o
	 6rI3IQIPosGPQ==
Date: Mon, 25 Mar 2024 20:20:50 -0700
Subject: [PATCH 2/2] xfs_repair: bulk load records into new btree blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142128260.2213983.10123609211113454964.stgit@frogsfrogsfrogs>
In-Reply-To: <171142128229.2213983.6809200974790500472.stgit@frogsfrogsfrogs>
References: <171142128229.2213983.6809200974790500472.stgit@frogsfrogsfrogs>
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

Amortize the cost of indirect calls further by loading a batch of
records into a new btree block instead of one record per ->get_record
call.  On a rmap btree with 3.9 million records, this reduces the
runtime of xfs_btree_bload by 3% for xfsprogs.  For the upcoming online
repair functionality, this will reduce runtime by 6% when spectre
mitigations are enabled in the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 repair/agbtree.c |  161 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 90 insertions(+), 71 deletions(-)


diff --git a/repair/agbtree.c b/repair/agbtree.c
index 981d8e340bf2..e014e216e0a5 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -220,15 +220,19 @@ get_bnobt_records(
 	struct bt_rebuild		*btr = priv;
 	struct xfs_alloc_rec_incore	*arec = &cur->bc_rec.a;
 	union xfs_btree_rec		*block_rec;
+	unsigned int			loaded;
 
-	btr->bno_rec = get_bno_rec(cur, btr->bno_rec);
-	arec->ar_startblock = btr->bno_rec->ex_startblock;
-	arec->ar_blockcount = btr->bno_rec->ex_blockcount;
-	btr->freeblks += btr->bno_rec->ex_blockcount;
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		btr->bno_rec = get_bno_rec(cur, btr->bno_rec);
+		arec->ar_startblock = btr->bno_rec->ex_startblock;
+		arec->ar_blockcount = btr->bno_rec->ex_blockcount;
+		btr->freeblks += btr->bno_rec->ex_blockcount;
 
-	block_rec = libxfs_btree_rec_addr(cur, idx, block);
-	cur->bc_ops->init_rec_from_cur(cur, block_rec);
-	return 1;
+		block_rec = libxfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	}
+
+	return loaded;
 }
 
 void
@@ -388,65 +392,72 @@ get_inobt_records(
 {
 	struct bt_rebuild		*btr = priv;
 	struct xfs_inobt_rec_incore	*irec = &cur->bc_rec.i;
-	struct ino_tree_node		*ino_rec;
-	union xfs_btree_rec		*block_rec;
-	int				inocnt = 0;
-	int				finocnt = 0;
-	int				k;
-
-	btr->ino_rec = ino_rec = get_ino_rec(cur, btr->ino_rec);
-
-	/* Transform the incore record into an on-disk record. */
-	irec->ir_startino = ino_rec->ino_startnum;
-	irec->ir_free = ino_rec->ir_free;
-
-	for (k = 0; k < sizeof(xfs_inofree_t) * NBBY; k++)  {
-		ASSERT(is_inode_confirmed(ino_rec, k));
-
-		if (is_inode_sparse(ino_rec, k))
-			continue;
-		if (is_inode_free(ino_rec, k))
-			finocnt++;
-		inocnt++;
-	}
+	unsigned int			loaded = 0;
+
+	while (loaded < nr_wanted) {
+		struct ino_tree_node	*ino_rec;
+		union xfs_btree_rec	*block_rec;
+		int			inocnt = 0;
+		int			finocnt = 0;
+		int			k;
+
+		btr->ino_rec = ino_rec = get_ino_rec(cur, btr->ino_rec);
 
-	irec->ir_count = inocnt;
-	irec->ir_freecount = finocnt;
-
-	if (xfs_has_sparseinodes(cur->bc_mp)) {
-		uint64_t		sparse;
-		int			spmask;
-		uint16_t		holemask;
-
-		/*
-		 * Convert the 64-bit in-core sparse inode state to the
-		 * 16-bit on-disk holemask.
-		 */
-		holemask = 0;
-		spmask = (1 << XFS_INODES_PER_HOLEMASK_BIT) - 1;
-		sparse = ino_rec->ir_sparse;
-		for (k = 0; k < XFS_INOBT_HOLEMASK_BITS; k++) {
-			if (sparse & spmask) {
-				ASSERT((sparse & spmask) == spmask);
-				holemask |= (1 << k);
-			} else
-				ASSERT((sparse & spmask) == 0);
-			sparse >>= XFS_INODES_PER_HOLEMASK_BIT;
+		/* Transform the incore record into an on-disk record. */
+		irec->ir_startino = ino_rec->ino_startnum;
+		irec->ir_free = ino_rec->ir_free;
+
+		for (k = 0; k < sizeof(xfs_inofree_t) * NBBY; k++)  {
+			ASSERT(is_inode_confirmed(ino_rec, k));
+
+			if (is_inode_sparse(ino_rec, k))
+				continue;
+			if (is_inode_free(ino_rec, k))
+				finocnt++;
+			inocnt++;
 		}
 
-		irec->ir_holemask = holemask;
-	} else {
-		irec->ir_holemask = 0;
-	}
+		irec->ir_count = inocnt;
+		irec->ir_freecount = finocnt;
 
-	if (btr->first_agino == NULLAGINO)
-		btr->first_agino = ino_rec->ino_startnum;
-	btr->freecount += finocnt;
-	btr->count += inocnt;
+		if (xfs_has_sparseinodes(cur->bc_mp)) {
+			uint64_t		sparse;
+			int			spmask;
+			uint16_t		holemask;
+
+			/*
+			 * Convert the 64-bit in-core sparse inode state to the
+			 * 16-bit on-disk holemask.
+			 */
+			holemask = 0;
+			spmask = (1 << XFS_INODES_PER_HOLEMASK_BIT) - 1;
+			sparse = ino_rec->ir_sparse;
+			for (k = 0; k < XFS_INOBT_HOLEMASK_BITS; k++) {
+				if (sparse & spmask) {
+					ASSERT((sparse & spmask) == spmask);
+					holemask |= (1 << k);
+				} else
+					ASSERT((sparse & spmask) == 0);
+				sparse >>= XFS_INODES_PER_HOLEMASK_BIT;
+			}
+
+			irec->ir_holemask = holemask;
+		} else {
+			irec->ir_holemask = 0;
+		}
+
+		if (btr->first_agino == NULLAGINO)
+			btr->first_agino = ino_rec->ino_startnum;
+		btr->freecount += finocnt;
+		btr->count += inocnt;
+
+		block_rec = libxfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+		loaded++;
+		idx++;
+	}
 
-	block_rec = libxfs_btree_rec_addr(cur, idx, block);
-	cur->bc_ops->init_rec_from_cur(cur, block_rec);
-	return 1;
+	return loaded;
 }
 
 /* Initialize both inode btree cursors as needed. */
@@ -585,13 +596,17 @@ get_rmapbt_records(
 	struct xfs_rmap_irec		*rec;
 	struct bt_rebuild		*btr = priv;
 	union xfs_btree_rec		*block_rec;
+	unsigned int			loaded;
 
-	rec = pop_slab_cursor(btr->slab_cursor);
-	memcpy(&cur->bc_rec.r, rec, sizeof(struct xfs_rmap_irec));
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		rec = pop_slab_cursor(btr->slab_cursor);
+		memcpy(&cur->bc_rec.r, rec, sizeof(struct xfs_rmap_irec));
 
-	block_rec = libxfs_btree_rec_addr(cur, idx, block);
-	cur->bc_ops->init_rec_from_cur(cur, block_rec);
-	return 1;
+		block_rec = libxfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	}
+
+	return loaded;
 }
 
 /* Set up the rmap rebuild parameters. */
@@ -663,13 +678,17 @@ get_refcountbt_records(
 	struct xfs_refcount_irec	*rec;
 	struct bt_rebuild		*btr = priv;
 	union xfs_btree_rec		*block_rec;
+	unsigned int			loaded;
 
-	rec = pop_slab_cursor(btr->slab_cursor);
-	memcpy(&cur->bc_rec.rc, rec, sizeof(struct xfs_refcount_irec));
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		rec = pop_slab_cursor(btr->slab_cursor);
+		memcpy(&cur->bc_rec.rc, rec, sizeof(struct xfs_refcount_irec));
 
-	block_rec = libxfs_btree_rec_addr(cur, idx, block);
-	cur->bc_ops->init_rec_from_cur(cur, block_rec);
-	return 1;
+		block_rec = libxfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	}
+
+	return loaded;
 }
 
 /* Set up the refcount rebuild parameters. */

