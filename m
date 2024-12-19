Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D7F19884C
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636986; cv=none; b=Uo3De9swXFtb+h/jOea+/o9TCKtRwlpBmdthM7z2+jGT7plShXuQ9JV2iSWaG46jzBdGXqa2zbRtPzhwyLs7VRKOI1qg/dOAsVU1QYVRKWrYBBW/T1XjPQ3w4h7N4faHlCRhdT3w9bQ7aWT+y5lpGNWnWJ/QSyJWy7tQgU/vtNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636986; c=relaxed/simple;
	bh=BHRbYOSOMrjEhH7hVLZtzQlLLm0zn+b3eJSp3UQQO2Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aRZ2qS6ipLu4JVg7dITTz1FI6ND7WHOCuuRPyYREEQDGDUnvSV+znl6juwfnTaHAVtPrqcIOpIlqa00PkACu/ClM0l8RctwjsYiKFzBzQr1rN7j1jj0SV/UP6FsanLC5okpmgISSmq6N36ypXBeywl/0x+bc47RyDgJZINx2wY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GllalgpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GllalgpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D734DC4CECE;
	Thu, 19 Dec 2024 19:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636985;
	bh=BHRbYOSOMrjEhH7hVLZtzQlLLm0zn+b3eJSp3UQQO2Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GllalgpGUtIgOLu39fi5mky6z4T2SFUu4bmXMppO4+8WsY6cNaZA+Ra6Xntks1uAV
	 YIKSTreFF01niGw9nCRtOS11U5ndY3+26pS9p+4gESfIoNNraDrYDOpshAIKENT05+
	 53jrEzRqkpxw9xwUg047NMkmGZC/VdHJDHTxSdJsqV+Ct4L8ak8oGV7qmslD7BrEwF
	 eqWEKTrv04uWvnTvUHgyTwsOUcprgNIFZbG8/561ZZLLzqjSG9qgp1sM/1+o8pLvXF
	 Y97eu3FQXH50OYnEzgCDTNuGONGejgA0bxa3JgbVATCiSbd1/kCFX5AcaXF9WldN7s
	 JqPAOXtzmLswg==
Date: Thu, 19 Dec 2024 11:36:25 -0800
Subject: [PATCH 13/43] xfs: refactor xfs_reflink_find_shared
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581201.1572761.8940967949660201516.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Move lookup of the perag structure from the callers into the helpers,
and return the offset into the extent of the shared region instead of
the block number that needs post-processing.  This prepares the
callsites for the creation of an rt-specific variant in the next patch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
[djwong: port to the middle of the rtreflink series for cleanliness]
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |  110 ++++++++++++++++++++++----------------------------
 fs/xfs/xfs_reflink.h |    2 -
 2 files changed, 50 insertions(+), 62 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 02457e176c4252..71b4743ffb7741 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -120,38 +120,46 @@
  */
 
 /*
- * Given an AG extent, find the lowest-numbered run of shared blocks
- * within that range and return the range in fbno/flen.  If
- * find_end_of_shared is true, return the longest contiguous extent of
- * shared blocks.  If there are no shared extents, fbno and flen will
- * be set to NULLAGBLOCK and 0, respectively.
+ * Given a file mapping for the data device, find the lowest-numbered run of
+ * shared blocks within that mapping and return it in shared_offset/shared_len.
+ * The offset is relative to the start of irec.
+ *
+ * If find_end_of_shared is true, return the longest contiguous extent of shared
+ * blocks.  If there are no shared extents, shared_offset and shared_len will be
+ * set to 0;
  */
 static int
 xfs_reflink_find_shared(
-	struct xfs_perag	*pag,
+	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agblock_t		agbno,
-	xfs_extlen_t		aglen,
-	xfs_agblock_t		*fbno,
-	xfs_extlen_t		*flen,
+	const struct xfs_bmbt_irec *irec,
+	xfs_extlen_t		*shared_offset,
+	xfs_extlen_t		*shared_len,
 	bool			find_end_of_shared)
 {
 	struct xfs_buf		*agbp;
+	struct xfs_perag	*pag;
 	struct xfs_btree_cur	*cur;
 	int			error;
+	xfs_agblock_t		orig_bno, found_bno;
+
+	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, irec->br_startblock));
+	orig_bno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
 
 	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
 	if (error)
-		return error;
-
-	cur = xfs_refcountbt_init_cursor(pag_mount(pag), tp, agbp, pag);
-
-	error = xfs_refcount_find_shared(cur, agbno, aglen, fbno, flen,
-			find_end_of_shared);
+		goto out;
 
+	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
+	error = xfs_refcount_find_shared(cur, orig_bno, irec->br_blockcount,
+			&found_bno, shared_len, find_end_of_shared);
 	xfs_btree_del_cursor(cur, error);
-
 	xfs_trans_brelse(tp, agbp);
+
+	if (!error && *shared_len)
+		*shared_offset = found_bno - orig_bno;
+out:
+	xfs_perag_put(pag);
 	return error;
 }
 
@@ -172,11 +180,7 @@ xfs_reflink_trim_around_shared(
 	bool			*shared)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_perag	*pag;
-	xfs_agblock_t		agbno;
-	xfs_extlen_t		aglen;
-	xfs_agblock_t		fbno;
-	xfs_extlen_t		flen;
+	xfs_extlen_t		shared_offset, shared_len;
 	int			error = 0;
 
 	/* Holes, unwritten, and delalloc extents cannot be shared */
@@ -187,41 +191,33 @@ xfs_reflink_trim_around_shared(
 
 	trace_xfs_reflink_trim_around_shared(ip, irec);
 
-	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, irec->br_startblock));
-	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
-	aglen = irec->br_blockcount;
-
-	error = xfs_reflink_find_shared(pag, NULL, agbno, aglen, &fbno, &flen,
-			true);
-	xfs_perag_put(pag);
+	error = xfs_reflink_find_shared(mp, NULL, irec, &shared_offset,
+			&shared_len, true);
 	if (error)
 		return error;
 
-	*shared = false;
-	if (fbno == NULLAGBLOCK) {
+	if (!shared_len) {
 		/* No shared blocks at all. */
-		return 0;
-	}
-
-	if (fbno == agbno) {
+		*shared = false;
+	} else if (!shared_offset) {
 		/*
-		 * The start of this extent is shared.  Truncate the
-		 * mapping at the end of the shared region so that a
-		 * subsequent iteration starts at the start of the
-		 * unshared region.
+		 * The start of this mapping points to shared space.  Truncate
+		 * the mapping at the end of the shared region so that a
+		 * subsequent iteration starts at the start of the unshared
+		 * region.
 		 */
-		irec->br_blockcount = flen;
+		irec->br_blockcount = shared_len;
 		*shared = true;
-		return 0;
+	} else {
+		/*
+		 * There's a shared region that doesn't start at the beginning
+		 * of the mapping.  Truncate the mapping at the start of the
+		 * shared extent so that a subsequent iteration starts at the
+		 * start of the shared region.
+		 */
+		irec->br_blockcount = shared_offset;
+		*shared = false;
 	}
-
-	/*
-	 * There's a shared extent midway through this extent.
-	 * Truncate the mapping at the start of the shared
-	 * extent so that a subsequent iteration starts at the
-	 * start of the shared region.
-	 */
-	irec->br_blockcount = fbno - agbno;
 	return 0;
 }
 
@@ -1552,27 +1548,19 @@ xfs_reflink_inode_has_shared_extents(
 	*has_shared = false;
 	found = xfs_iext_lookup_extent(ip, ifp, 0, &icur, &got);
 	while (found) {
-		struct xfs_perag	*pag;
-		xfs_agblock_t		agbno;
-		xfs_extlen_t		aglen;
-		xfs_agblock_t		rbno;
-		xfs_extlen_t		rlen;
+		xfs_extlen_t		shared_offset, shared_len;
 
 		if (isnullstartblock(got.br_startblock) ||
 		    got.br_state != XFS_EXT_NORM)
 			goto next;
 
-		pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, got.br_startblock));
-		agbno = XFS_FSB_TO_AGBNO(mp, got.br_startblock);
-		aglen = got.br_blockcount;
-		error = xfs_reflink_find_shared(pag, tp, agbno, aglen,
-				&rbno, &rlen, false);
-		xfs_perag_put(pag);
+		error = xfs_reflink_find_shared(mp, tp, &got, &shared_offset,
+				&shared_len, false);
 		if (error)
 			return error;
 
 		/* Is there still a shared block here? */
-		if (rbno != NULLAGBLOCK) {
+		if (shared_len) {
 			*has_shared = true;
 			return 0;
 		}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 4a58e4533671c0..3bfd7ab9e1148a 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -25,7 +25,7 @@ xfs_can_free_cowblocks(struct xfs_inode *ip)
 	return true;
 }
 
-extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
+int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *irec, bool *shared);
 int xfs_bmap_trim_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
 		bool *shared);

