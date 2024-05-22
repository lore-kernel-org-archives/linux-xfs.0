Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9282328FD
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347488; cv=none; b=eh9CMMMgj3Kg+Bb2vBgyxqBsfsU+rOCQP5h2W43E6hiplqW/G7NPvi9tjXmoOpGAfYmbRI5apxpW0/adjeYq6BEZjufcXr6w7/bbLXQ3b1KAEBfIApq9+hlJcvgbPV2vj7nyWq7pgmx8A2MHRM/OQOX6xML/QTq5wa87qaKrKQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347488; c=relaxed/simple;
	bh=QMmUKa69BxE8i5BXWlytF0C+hhBlREqshxGZ+U56DX8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tnSaEEWZBQSeGgJB1y37tDkroM6WecRLKJ7+QFkVOnhgD1uitgMQwLlokJjyG4sVBIEwahAPGLzHrCBEOs0kUZD6DQE7nelTFFQ1XBxlHM4/UTI0kpFNUiUNPPT/FHfv6K9ds9AojQY+GNLn43yeS1ccbjHAGwVrMWNodSqa2dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JvR7NEV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JvR7NEV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D185C2BD11;
	Wed, 22 May 2024 03:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347488;
	bh=QMmUKa69BxE8i5BXWlytF0C+hhBlREqshxGZ+U56DX8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JvR7NEV8nAsDyI1dbUJLZsEGU3mshTCA9ko2hjQnfXQfM2nEgEGBueHxGycvMzc1W
	 s7za+9IQzknuxLF16em9xQ6c8fDiNN9Mj0WXN6N6KdbfNn4Sb0FJI0R2tY9Bm8uOPZ
	 ze+4F/xYb7DtR6PyWixjzTk0D5S/djPYhfLhmnMj7+UVS1Re/ybUHGL94o4IbP2Ls1
	 5IC1XDjiQeIakIMVObZgExRIWJ/azbPbVBbyt48ZDlO1ESdSHQ6B4qIZyOheUaFhhX
	 DWt2WYZLmlYmfKM99+bjh9vGOXDtMn7+4+x2bOHjnRGg3g4CV1W6Wj05IH52RnL04g
	 7at92ZJhmL4WQ==
Date: Tue, 21 May 2024 20:11:28 -0700
Subject: [PATCH 087/111] xfs: move and rename xfs_btree_read_bufl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533004.2478931.17800951189943064351.stgit@frogsfrogsfrogs>
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

Source kernel commit: 6a701eb8fbbb5f500684947883fd77ed0475fa82

Despite its name, xfs_btree_read_bufl doesn't contain any btree-related
functionaliy and isn't used by the btree code.  Move it to xfs_bmap.c,
hard code the refval and ops arguments and rename it to
xfs_bmap_read_buf.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c  |   33 +++++++++++++++++++++++++--------
 libxfs/xfs_btree.c |   30 ------------------------------
 libxfs/xfs_btree.h |   13 -------------
 3 files changed, 25 insertions(+), 51 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 86643f4c3..4790efd3d 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -220,6 +220,28 @@ xfs_bmap_forkoff_reset(
 	}
 }
 
+static int
+xfs_bmap_read_buf(
+	struct xfs_mount	*mp,		/* file system mount point */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	xfs_fsblock_t		fsbno,		/* file system block number */
+	struct xfs_buf		**bpp)		/* buffer for fsbno */
+{
+	struct xfs_buf		*bp;		/* return value */
+	int			error;
+
+	if (!xfs_verify_fsbno(mp, fsbno))
+		return -EFSCORRUPTED;
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(mp, fsbno), mp->m_bsize, 0, &bp,
+			&xfs_bmbt_buf_ops);
+	if (!error) {
+		xfs_buf_set_ref(bp, XFS_BMAP_BTREE_REF);
+		*bpp = bp;
+	}
+	return error;
+}
+
 #ifdef DEBUG
 STATIC struct xfs_buf *
 xfs_bmap_get_bp(
@@ -359,9 +381,7 @@ xfs_bmap_check_leaf_extents(
 		bp = xfs_bmap_get_bp(cur, XFS_FSB_TO_DADDR(mp, bno));
 		if (!bp) {
 			bp_release = 1;
-			error = xfs_btree_read_bufl(mp, NULL, bno, &bp,
-						XFS_BMAP_BTREE_REF,
-						&xfs_bmbt_buf_ops);
+			error = xfs_bmap_read_buf(mp, NULL, bno, &bp);
 			if (xfs_metadata_is_sick(error))
 				xfs_btree_mark_sick(cur);
 			if (error)
@@ -448,9 +468,7 @@ xfs_bmap_check_leaf_extents(
 		bp = xfs_bmap_get_bp(cur, XFS_FSB_TO_DADDR(mp, bno));
 		if (!bp) {
 			bp_release = 1;
-			error = xfs_btree_read_bufl(mp, NULL, bno, &bp,
-						XFS_BMAP_BTREE_REF,
-						&xfs_bmbt_buf_ops);
+			error = xfs_bmap_read_buf(mp, NULL, bno, &bp);
 			if (xfs_metadata_is_sick(error))
 				xfs_btree_mark_sick(cur);
 			if (error)
@@ -567,8 +585,7 @@ xfs_bmap_btree_to_extents(
 		return -EFSCORRUPTED;
 	}
 #endif
-	error = xfs_btree_read_bufl(mp, tp, cbno, &cbp, XFS_BMAP_BTREE_REF,
-				&xfs_bmbt_buf_ops);
+	error = xfs_bmap_read_buf(mp, tp, cbno, &cbp);
 	if (xfs_metadata_is_sick(error))
 		xfs_btree_mark_sick(cur);
 	if (error)
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 7168a5753..a989b2da2 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -856,36 +856,6 @@ xfs_btree_offsets(
 	}
 }
 
-/*
- * Get a buffer for the block, return it read in.
- * Long-form addressing.
- */
-int
-xfs_btree_read_bufl(
-	struct xfs_mount	*mp,		/* file system mount point */
-	struct xfs_trans	*tp,		/* transaction pointer */
-	xfs_fsblock_t		fsbno,		/* file system block number */
-	struct xfs_buf		**bpp,		/* buffer for fsbno */
-	int			refval,		/* ref count value for buffer */
-	const struct xfs_buf_ops *ops)
-{
-	struct xfs_buf		*bp;		/* return value */
-	xfs_daddr_t		d;		/* real disk block address */
-	int			error;
-
-	if (!xfs_verify_fsbno(mp, fsbno))
-		return -EFSCORRUPTED;
-	d = XFS_FSB_TO_DADDR(mp, fsbno);
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, d,
-				   mp->m_bsize, 0, &bp, ops);
-	if (error)
-		return error;
-	if (bp)
-		xfs_buf_set_ref(bp, refval);
-	*bpp = bp;
-	return 0;
-}
-
 STATIC int
 xfs_btree_readahead_fsblock(
 	struct xfs_btree_cur	*cur,
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index c48b4fdeb..bacd67cc8 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -378,19 +378,6 @@ xfs_btree_offsets(
 	int			*first,	/* output: first byte offset */
 	int			*last);	/* output: last byte offset */
 
-/*
- * Get a buffer for the block, return it read in.
- * Long-form addressing.
- */
-int					/* error */
-xfs_btree_read_bufl(
-	struct xfs_mount	*mp,	/* file system mount point */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_fsblock_t		fsbno,	/* file system block number */
-	struct xfs_buf		**bpp,	/* buffer for fsbno */
-	int			refval,	/* ref count value for buffer */
-	const struct xfs_buf_ops *ops);
-
 /*
  * Initialise a new btree block header
  */

