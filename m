Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D605BA2B
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295862; cv=none; b=IM+CCPXwefLrjkWV+IrH+Nsw3mOm/qNeNd3H/jz8T0sX40p75/V8Pg9+aBsxDffgabELcIQvqj9yD2jMqNnMlEdQQnujWjK7A+mkf1ZdwSGswseuiGbD3E4ZhrabO9UKrKmzLOzQJno6bOlTyJhnJqtw7NNiCiUWEjPYMwoOsNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295862; c=relaxed/simple;
	bh=oMg+DpkSYbXJe8Wt6irm5nCfjZExmGKIEUPdEfT4T+U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r/LOvJBjNPLn75BHpyza429TkEGX7hHc+zkb9Z6XIg3ncyAhJS0Fmu66/fUIuQihcMRexcHtdVFnajPEGmGF/4xxp6dStz9ccuE6NrrvR3ebcB5Fp2KLlWV32g9/liwKJr+vSz5FMcs7/SNCEJ1HFeycXg8nswidvxCZeuc2Ctg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OYXjN1mt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OYXjN1mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1BDC433C7;
	Wed, 13 Mar 2024 02:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295862;
	bh=oMg+DpkSYbXJe8Wt6irm5nCfjZExmGKIEUPdEfT4T+U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OYXjN1mttNONpvltqNSUnBAS0JVGAfkUKckEae/fr1a0TnVj6g+vsTXluUcyovNSi
	 PqE7kY0W0TaZXgCMNsW8lMHUiVGRoxAGIzXvnT+nJy1+MMBr3S1YEOUVTy2vV7K+kF
	 Sq/yV0fo+2qjGSoTbkmpPmFaYrnVkxrh+ja8tVi+wU04S/GeeBdDtZAzZMCjggqjJG
	 U32I8ix8mL8gxigReGHB9lIwL8CEOoBjvOc1OS2ucsIdjdbZbdyVL+wU5V31VlS/IC
	 ktBDxQQFuzSVOBiC/mqO5v/PSYVOQquWJxgY1BbhUdCINqk8oJ3UOgbeH++oKYYG5g
	 JdzzcWAoytohA==
Date: Tue, 12 Mar 2024 19:11:01 -0700
Subject: [PATCH 2/2] xfs_repair: bulk load records into new btree blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029432531.2063452.98834952088069975.stgit@frogsfrogsfrogs>
In-Reply-To: <171029432500.2063452.8809888062166577820.stgit@frogsfrogsfrogs>
References: <171029432500.2063452.8809888062166577820.stgit@frogsfrogsfrogs>
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

