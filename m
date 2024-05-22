Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219934C89
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347238; cv=none; b=hHhAbCLbqcXF7k42fGeHE+oUMxu9VlAEfOvCcCPNH3O3i2TyO60388AtPtfkxE9b6oA6pSkKnnvS4MzAes7ZLi3ZRW5f1soJKgBH7RLzablBkQKdq3UsHk/WKTdbAADZudaHJ9T2cExF+SRoZrOH1X8G6e0pTdRGdHprXG32ens=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347238; c=relaxed/simple;
	bh=0NM1RcDkcSVmjOcPz5TYQxNmk3WOyqcRop6bet232/A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=swWyIRrme5hi6IfCBb3iqUytVWNzgkl/fui5N9W5B0+7oEw6Wky7c/KKs1FgjBWYZFjeYSwPjRkhcaAAjEnAymHWDrq8H6rle7ZcVAK9BDae1XJnpjHqWqTirY6UehhYbm0VJ6YBJ96dFJMW8o9wpGWsx81OiatSuPpZeQpiEbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vGjdmBXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vGjdmBXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4ADC2BD11;
	Wed, 22 May 2024 03:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347238;
	bh=0NM1RcDkcSVmjOcPz5TYQxNmk3WOyqcRop6bet232/A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vGjdmBXOqDGnUtUKwIhurvlCOVzfgDrfuVltPypB/SVw42W7ef5wBpzGCYWgkiqxt
	 zO2r0rQkncqrjiqRC1l7feCuvaMdXL5C6i5+4wxe7LdKmtZIq2VvEnWQt1gJ3q2flG
	 Ya+aH/ZnixmeyoJY3TmooRbK2LjC3CRfkOPHTqI/tNVpR4CGIx/sq5M97kBd9/SjYs
	 k0t/o+/afUj9QtLI/f6MX7VfCk83Zzk+axxIcvARwZyUzp0a3QBSv/d/BmBF044b4i
	 0pbU3jAzGfxhxTp1cUq52efxTc1dDCWp0PtkCq5yMKMJiG+VNo9ZJf/uuoSwlxShu7
	 egDFgfD3UCjMA==
Date: Tue, 21 May 2024 20:07:17 -0700
Subject: [PATCH 071/111] xfs: split xfs_inobt_insert_sprec
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532762.2478931.4220832994877296454.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 8541a7d9da2dd6e44f401f2363b21749b7413fc9

Split the finobt version that never merges and uses a different cursor
out of xfs_inobt_insert_sprec to prepare for removing xfs_btnum_t.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc.c |  148 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 96 insertions(+), 52 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 94f4f8690..4f3d7d4dc 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -524,16 +524,14 @@ __xfs_inobt_rec_merge(
 }
 
 /*
- * Insert a new sparse inode chunk into the associated inode btree. The inode
- * record for the sparse chunk is pre-aligned to a startino that should match
- * any pre-existing sparse inode record in the tree. This allows sparse chunks
- * to fill over time.
+ * Insert a new sparse inode chunk into the associated inode allocation btree.
+ * The inode record for the sparse chunk is pre-aligned to a startino that
+ * should match any pre-existing sparse inode record in the tree. This allows
+ * sparse chunks to fill over time.
  *
- * This function supports two modes of handling preexisting records depending on
- * the merge flag. If merge is true, the provided record is merged with the
+ * If no preexisting record exists, the provided record is inserted.
+ * If there is a preexisting record, the provided record is merged with the
  * existing record and updated in place. The merged record is returned in nrec.
- * If merge is false, an existing record is replaced with the provided record.
- * If no preexisting record exists, the provided record is always inserted.
  *
  * It is considered corruption if a merge is requested and not possible. Given
  * the sparse inode alignment constraints, this should never happen.
@@ -543,9 +541,7 @@ xfs_inobt_insert_sprec(
 	struct xfs_perag		*pag,
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
-	int				btnum,
-	struct xfs_inobt_rec_incore	*nrec,	/* in/out: new/merged rec. */
-	bool				merge)	/* merge or replace */
+	struct xfs_inobt_rec_incore	*nrec)	/* in/out: new/merged rec. */
 {
 	struct xfs_mount		*mp = pag->pag_mount;
 	struct xfs_btree_cur		*cur;
@@ -553,7 +549,7 @@ xfs_inobt_insert_sprec(
 	int				i;
 	struct xfs_inobt_rec_incore	rec;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, btnum);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_INO);
 
 	/* the new record is pre-aligned so we know where to look */
 	error = xfs_inobt_lookup(cur, nrec->ir_startino, XFS_LOOKUP_EQ, &i);
@@ -576,48 +572,45 @@ xfs_inobt_insert_sprec(
 	}
 
 	/*
-	 * A record exists at this startino. Merge or replace the record
-	 * depending on what we've been asked to do.
+	 * A record exists at this startino.  Merge the records.
 	 */
-	if (merge) {
-		error = xfs_inobt_get_rec(cur, &rec, &i);
-		if (error)
-			goto error;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto error;
-		}
-		if (XFS_IS_CORRUPT(mp, rec.ir_startino != nrec->ir_startino)) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto error;
-		}
+	error = xfs_inobt_get_rec(cur, &rec, &i);
+	if (error)
+		goto error;
+	if (XFS_IS_CORRUPT(mp, i != 1)) {
+		xfs_btree_mark_sick(cur);
+		error = -EFSCORRUPTED;
+		goto error;
+	}
+	if (XFS_IS_CORRUPT(mp, rec.ir_startino != nrec->ir_startino)) {
+		xfs_btree_mark_sick(cur);
+		error = -EFSCORRUPTED;
+		goto error;
+	}
 
-		/*
-		 * This should never fail. If we have coexisting records that
-		 * cannot merge, something is seriously wrong.
-		 */
-		if (XFS_IS_CORRUPT(mp, !__xfs_inobt_can_merge(nrec, &rec))) {
-			xfs_btree_mark_sick(cur);
-			error = -EFSCORRUPTED;
-			goto error;
-		}
+	/*
+	 * This should never fail. If we have coexisting records that
+	 * cannot merge, something is seriously wrong.
+	 */
+	if (XFS_IS_CORRUPT(mp, !__xfs_inobt_can_merge(nrec, &rec))) {
+		xfs_btree_mark_sick(cur);
+		error = -EFSCORRUPTED;
+		goto error;
+	}
 
-		trace_xfs_irec_merge_pre(mp, pag->pag_agno, rec.ir_startino,
-					 rec.ir_holemask, nrec->ir_startino,
-					 nrec->ir_holemask);
+	trace_xfs_irec_merge_pre(mp, pag->pag_agno, rec.ir_startino,
+				 rec.ir_holemask, nrec->ir_startino,
+				 nrec->ir_holemask);
 
-		/* merge to nrec to output the updated record */
-		__xfs_inobt_rec_merge(nrec, &rec);
+	/* merge to nrec to output the updated record */
+	__xfs_inobt_rec_merge(nrec, &rec);
 
-		trace_xfs_irec_merge_post(mp, pag->pag_agno, nrec->ir_startino,
-					  nrec->ir_holemask);
+	trace_xfs_irec_merge_post(mp, pag->pag_agno, nrec->ir_startino,
+				  nrec->ir_holemask);
 
-		error = xfs_inobt_rec_check_count(mp, nrec);
-		if (error)
-			goto error;
-	}
+	error = xfs_inobt_rec_check_count(mp, nrec);
+	if (error)
+		goto error;
 
 	error = xfs_inobt_update(cur, nrec);
 	if (error)
@@ -631,6 +624,59 @@ xfs_inobt_insert_sprec(
 	return error;
 }
 
+/*
+ * Insert a new sparse inode chunk into the free inode btree. The inode
+ * record for the sparse chunk is pre-aligned to a startino that should match
+ * any pre-existing sparse inode record in the tree. This allows sparse chunks
+ * to fill over time.
+ *
+ * The new record is always inserted, overwriting a pre-existing record if
+ * there is one.
+ */
+STATIC int
+xfs_finobt_insert_sprec(
+	struct xfs_perag		*pag,
+	struct xfs_trans		*tp,
+	struct xfs_buf			*agbp,
+	struct xfs_inobt_rec_incore	*nrec)	/* in/out: new rec. */
+{
+	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_btree_cur		*cur;
+	int				error;
+	int				i;
+
+	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_FINO);
+
+	/* the new record is pre-aligned so we know where to look */
+	error = xfs_inobt_lookup(cur, nrec->ir_startino, XFS_LOOKUP_EQ, &i);
+	if (error)
+		goto error;
+	/* if nothing there, insert a new record and return */
+	if (i == 0) {
+		error = xfs_inobt_insert_rec(cur, nrec->ir_holemask,
+					     nrec->ir_count, nrec->ir_freecount,
+					     nrec->ir_free, &i);
+		if (error)
+			goto error;
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
+			error = -EFSCORRUPTED;
+			goto error;
+		}
+	} else {
+		error = xfs_inobt_update(cur, nrec);
+		if (error)
+			goto error;
+	}
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+error:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+
 /*
  * Allocate new inodes in the allocation group specified by agbp.  Returns 0 if
  * inodes were allocated in this AG; -EAGAIN if there was no space in this AG so
@@ -857,8 +903,7 @@ xfs_ialloc_ag_alloc(
 		 * if necessary. If a merge does occur, rec is updated to the
 		 * merged record.
 		 */
-		error = xfs_inobt_insert_sprec(pag, tp, agbp,
-				XFS_BTNUM_INO, &rec, true);
+		error = xfs_inobt_insert_sprec(pag, tp, agbp, &rec);
 		if (error == -EFSCORRUPTED) {
 			xfs_alert(args.mp,
 	"invalid sparse inode record: ino 0x%llx holemask 0x%x count %u",
@@ -882,8 +927,7 @@ xfs_ialloc_ag_alloc(
 		 * existing record with this one.
 		 */
 		if (xfs_has_finobt(args.mp)) {
-			error = xfs_inobt_insert_sprec(pag, tp, agbp,
-				       XFS_BTNUM_FINO, &rec, false);
+			error = xfs_finobt_insert_sprec(pag, tp, agbp, &rec);
 			if (error)
 				return error;
 		}

