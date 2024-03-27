Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4112B1CD2B
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504840; cv=none; b=PP3f6sHmGKBU8pik87LIsBVCG3MZUKoGLimqcuGkYcvM7Txx/XTIehO8qHPJoMVFFRy3ZBHlW8WkY6Nkr24P5KpsyKDRGbJz7mD97p7FxPmFx4il/YOr05c4174QLRLhVoGazxR7nRp+ZF/ra2h2U3TuUDqkR2oBwlnWK2EDCrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504840; c=relaxed/simple;
	bh=OaOtmSqebHYUXBuY1IXvxa4xvuh3e1yG1YcVv8bUyjE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E1gmSv6cRN9DmXj83MckTbAVTtGXgo0BhGAJ3rZBdCOTFIwgJPDZ5OriYxobe8qZRs5pJ3OR/OKQ0XshqKU9rhLN1f64RMixTWWkWmI8yoFcacb7e755ZB/8yvD+Oh3GM7UZdnJd7KPowDU7Bjjw544sQfgcFQUqfBcPe1y7ddQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m126IQsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m126IQsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B69DC433F1;
	Wed, 27 Mar 2024 02:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504840;
	bh=OaOtmSqebHYUXBuY1IXvxa4xvuh3e1yG1YcVv8bUyjE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m126IQslhMRh6tKh9ylls4iqSymPUDxaG4HcU3QTinLVSJBoDjJANgV7x4JXy8KUg
	 FodN6Mb1oz38SNGztvTLQS3m4teiGC7wY+xaAUE3SSDdmI4BBaaOxgxL2iQ9q8zYaS
	 LAj8iE3JuLYpNTibTvBFFmezfTt6OY8/DpBLVDLlZJjS98A1YCyUrpx9ll1AaDNGfv
	 lE0E73MBKwZoQA7BiPNdMyNxeP/puiAuyNbcdU1mvZlg0ZPjvAgLx2fU4eewUwgx3i
	 MfnHk+UtQUcjP2YyeOGCkqQ1VCk2/2psTdTp2OXyYt24veEoUFsRgJU5KW4wrEABvq
	 1/drTJ2OWUNSg==
Date: Tue, 26 Mar 2024 19:00:39 -0700
Subject: [PATCH 08/10] xfs: validate explicit directory data buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150382258.3217370.6839962144803388341.stgit@frogsfrogsfrogs>
In-Reply-To: <171150382098.3217370.5208665628669220587.stgit@frogsfrogsfrogs>
References: <171150382098.3217370.5208665628669220587.stgit@frogsfrogsfrogs>
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

Port the existing directory data header checking function to accept an
owner number instead of an xfs_inode, then update the callsites to use
xfs_da_args.owner when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2.h       |    1 +
 fs/xfs/libxfs/xfs_dir2_block.c |    3 ++-
 fs/xfs/libxfs/xfs_dir2_data.c  |   15 +++++++++------
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   21 +++++++++++----------
 fs/xfs/libxfs/xfs_dir2_node.c  |    7 +++----
 fs/xfs/libxfs/xfs_dir2_priv.h  |    3 ++-
 fs/xfs/scrub/dir.c             |   14 +++++++-------
 fs/xfs/scrub/readdir.c         |    2 +-
 fs/xfs/xfs_dir2_readdir.c      |    3 ++-
 9 files changed, 38 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 2f728c26a4162..d623bfdcd4218 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -102,6 +102,7 @@ extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
 xfs_failaddr_t xfs_dir3_leaf_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+xfs_failaddr_t xfs_dir3_data_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 61cbc668f228a..b20b08394aa06 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -982,7 +982,8 @@ xfs_dir2_leaf_to_block(
 	 * Read the data block if we don't already have it, give up if it fails.
 	 */
 	if (!dbp) {
-		error = xfs_dir3_data_read(tp, dp, args->geo->datablk, 0, &dbp);
+		error = xfs_dir3_data_read(tp, dp, args->owner,
+				args->geo->datablk, 0, &dbp);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index c3ef720b5ff6e..00c2061aed346 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -395,17 +395,19 @@ static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
 	.verify_write = xfs_dir3_data_write_verify,
 };
 
-static xfs_failaddr_t
+xfs_failaddr_t
 xfs_dir3_data_header_check(
-	struct xfs_inode	*dp,
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	xfs_ino_t		owner)
 {
-	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 
 	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_data_hdr *hdr3 = bp->b_addr;
 
-		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
+		ASSERT(hdr3->hdr.magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+
+		if (be64_to_cpu(hdr3->hdr.owner) != owner)
 			return __this_address;
 	}
 
@@ -416,6 +418,7 @@ int
 xfs_dir3_data_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	xfs_dablk_t		bno,
 	unsigned int		flags,
 	struct xfs_buf		**bpp)
@@ -429,7 +432,7 @@ xfs_dir3_data_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	fa = xfs_dir3_data_header_check(dp, *bpp);
+	fa = xfs_dir3_data_header_check(*bpp, owner);
 	if (fa) {
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 16a581e225a37..a6eee26044875 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -884,9 +884,9 @@ xfs_dir2_leaf_addname(
 		 * Already had space in some data block.
 		 * Just read that one in.
 		 */
-		error = xfs_dir3_data_read(tp, dp,
-				   xfs_dir2_db_to_da(args->geo, use_block),
-				   0, &dbp);
+		error = xfs_dir3_data_read(tp, dp, args->owner,
+				xfs_dir2_db_to_da(args->geo, use_block), 0,
+				&dbp);
 		if (error) {
 			xfs_trans_brelse(tp, lbp);
 			return error;
@@ -1327,9 +1327,9 @@ xfs_dir2_leaf_lookup_int(
 		if (newdb != curdb) {
 			if (dbp)
 				xfs_trans_brelse(tp, dbp);
-			error = xfs_dir3_data_read(tp, dp,
-					   xfs_dir2_db_to_da(args->geo, newdb),
-					   0, &dbp);
+			error = xfs_dir3_data_read(tp, dp, args->owner,
+					xfs_dir2_db_to_da(args->geo, newdb), 0,
+					&dbp);
 			if (error) {
 				xfs_trans_brelse(tp, lbp);
 				return error;
@@ -1369,9 +1369,9 @@ xfs_dir2_leaf_lookup_int(
 		ASSERT(cidb != -1);
 		if (cidb != curdb) {
 			xfs_trans_brelse(tp, dbp);
-			error = xfs_dir3_data_read(tp, dp,
-					   xfs_dir2_db_to_da(args->geo, cidb),
-					   0, &dbp);
+			error = xfs_dir3_data_read(tp, dp, args->owner,
+					xfs_dir2_db_to_da(args->geo, cidb), 0,
+					&dbp);
 			if (error) {
 				xfs_trans_brelse(tp, lbp);
 				return error;
@@ -1665,7 +1665,8 @@ xfs_dir2_leaf_trim_data(
 	/*
 	 * Read the offending data block.  We need its buffer.
 	 */
-	error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(geo, db), 0, &dbp);
+	error = xfs_dir3_data_read(tp, dp, args->owner,
+			xfs_dir2_db_to_da(geo, db), 0, &dbp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index e21965788188b..dc85197b8448e 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -863,7 +863,7 @@ xfs_dir2_leafn_lookup_for_entry(
 				ASSERT(state->extravalid);
 				curbp = state->extrablk.bp;
 			} else {
-				error = xfs_dir3_data_read(tp, dp,
+				error = xfs_dir3_data_read(tp, dp, args->owner,
 						xfs_dir2_db_to_da(args->geo,
 								  newdb),
 						0, &curbp);
@@ -1949,9 +1949,8 @@ xfs_dir2_node_addname_int(
 						  &freehdr, &findex);
 	} else {
 		/* Read the data block in. */
-		error = xfs_dir3_data_read(tp, dp,
-					   xfs_dir2_db_to_da(args->geo, dbno),
-					   0, &dbp);
+		error = xfs_dir3_data_read(tp, dp, args->owner,
+				xfs_dir2_db_to_da(args->geo, dbno), 0, &dbp);
 	}
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 2f0e3ad47b371..879aa2e9fd730 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -78,7 +78,8 @@ extern void xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 extern xfs_failaddr_t __xfs_dir3_data_check(struct xfs_inode *dp,
 		struct xfs_buf *bp);
 int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
-		xfs_dablk_t bno, unsigned int flags, struct xfs_buf **bpp);
+		xfs_ino_t owner, xfs_dablk_t bno, unsigned int flags,
+		struct xfs_buf **bpp);
 int xfs_dir3_data_readahead(struct xfs_inode *dp, xfs_dablk_t bno,
 		unsigned int flags);
 
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index d94e265a8e1f2..6b572196bb43d 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -196,8 +196,8 @@ xchk_dir_rec(
 		xchk_da_set_corrupt(ds, level);
 		goto out;
 	}
-	error = xfs_dir3_data_read(ds->dargs.trans, dp, rec_bno,
-			XFS_DABUF_MAP_HOLE_OK, &bp);
+	error = xfs_dir3_data_read(ds->dargs.trans, dp, ds->dargs.owner,
+			rec_bno, XFS_DABUF_MAP_HOLE_OK, &bp);
 	if (!xchk_fblock_process_error(ds->sc, XFS_DATA_FORK, rec_bno,
 			&error))
 		goto out;
@@ -318,7 +318,8 @@ xchk_directory_data_bestfree(
 		error = xfs_dir3_block_read(sc->tp, sc->ip, &bp);
 	} else {
 		/* dir data format */
-		error = xfs_dir3_data_read(sc->tp, sc->ip, lblk, 0, &bp);
+		error = xfs_dir3_data_read(sc->tp, sc->ip, sc->ip->i_ino, lblk,
+				0, &bp);
 	}
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		goto out;
@@ -531,10 +532,9 @@ xchk_directory_leaf1_bestfree(
 	/* Check all the bestfree entries. */
 	for (i = 0; i < bestcount; i++, bestp++) {
 		best = be16_to_cpu(*bestp);
-		error = xfs_dir3_data_read(sc->tp, sc->ip,
+		error = xfs_dir3_data_read(sc->tp, sc->ip, args->owner,
 				xfs_dir2_db_to_da(args->geo, i),
-				XFS_DABUF_MAP_HOLE_OK,
-				&dbp);
+				XFS_DABUF_MAP_HOLE_OK, &dbp);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
 				&error))
 			break;
@@ -597,7 +597,7 @@ xchk_directory_free_bestfree(
 			stale++;
 			continue;
 		}
-		error = xfs_dir3_data_read(sc->tp, sc->ip,
+		error = xfs_dir3_data_read(sc->tp, sc->ip, args->owner,
 				(freehdr.firstdb + i) * args->geo->fsbcount,
 				0, &dbp);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index fb98b7624994a..bed15a9524a2f 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -175,7 +175,7 @@ xchk_read_leaf_dir_buf(
 	if (new_off > *curoff)
 		*curoff = new_off;
 
-	return xfs_dir3_data_read(tp, dp, map.br_startoff, 0, bpp);
+	return xfs_dir3_data_read(tp, dp, dp->i_ino, map.br_startoff, 0, bpp);
 }
 
 /* Call a function for every entry in a leaf directory. */
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 4e811fa393add..2c03371b542ae 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -282,7 +282,8 @@ xfs_dir2_leaf_readbuf(
 	new_off = xfs_dir2_da_to_byte(geo, map.br_startoff);
 	if (new_off > *cur_off)
 		*cur_off = new_off;
-	error = xfs_dir3_data_read(args->trans, dp, map.br_startoff, 0, &bp);
+	error = xfs_dir3_data_read(args->trans, dp, args->owner,
+			map.br_startoff, 0, &bp);
 	if (error)
 		goto out;
 

