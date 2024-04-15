Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC88157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224917; cv=none; b=DN2PoujLmzCUhLs57+fatE6YJwDKvawIRm0XHaYI9v6BkQLSyV3fuiMFtydt14H7Pq+SMry5bCgEezIy+76NJI6lT+yOGc38A+RCpk2cWhAIz5pvmNjq8GJZ3XYegelcuMcP0bkIwSylU9ns+QYuW/sBNVOZRl8uakTL1jPAowQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224917; c=relaxed/simple;
	bh=K6FAkL0P7SPxh+KKzRmxcxpw28hm8CRg0QXeOmGeJTo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OOrPXZt+3rzeygrT4yLfNQEGv3qZfFwnZQrIl/iYOuL+lGlCGXUFhj2wAhrwqPkkL9Eg39xZakqnsZDSzorkN/vI/gYHJhvgt9a34f8BAAzGGsep6agT696UG2DX3IFcP/tjXCCCc3XjpqCQifkyHU8ND6i05QjoEJCqdfHXG48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qdjDiSg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qdjDiSg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD491C113CC;
	Mon, 15 Apr 2024 23:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224917;
	bh=K6FAkL0P7SPxh+KKzRmxcxpw28hm8CRg0QXeOmGeJTo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qdjDiSg+dR0Gbzjpp825ZTjJQ/7LC5tN7rRRs7QjHGCqttXMKtPq8GmRjTOoME0o/
	 0/iOX66eqkmoWIe2ZtwUpksTO+Y+5j0AC1DFytAoMwnHUsbBUWv9F6avjjIfQ1d+HN
	 urjCI/mS740NjDkVlf7ChRBE34bsYgBNeo7ssxCOJdgN/U+xv5YUnr4X8RGVKEkYum
	 /GIkgVmqcpWJokUmhLqgH7Le9K/MWRgwNH32BifUZ3RA3XrC9YmPtikuaxUEq0SH0A
	 rKok8U0JROO7W8sH7X67W6QPqLY9lw9oS41kZxdoUccxHfrWhMmTArrv9ZM3wR/GI2
	 S4PspPNKFSpMQ==
Date: Mon, 15 Apr 2024 16:48:37 -0700
Subject: [PATCH 08/10] xfs: validate explicit directory data buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322382715.88250.4912308665553212590.stgit@frogsfrogsfrogs>
In-Reply-To: <171322382551.88250.5431690184825585631.stgit@frogsfrogsfrogs>
References: <171322382551.88250.5431690184825585631.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_dir2_data.c  |   16 ++++++++++------
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   21 +++++++++++----------
 fs/xfs/libxfs/xfs_dir2_node.c  |    7 +++----
 fs/xfs/libxfs/xfs_dir2_priv.h  |    3 ++-
 fs/xfs/scrub/dir.c             |   14 +++++++-------
 fs/xfs/scrub/readdir.c         |    2 +-
 fs/xfs/xfs_dir2_readdir.c      |    3 ++-
 9 files changed, 39 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 2f728c26a416..d623bfdcd421 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -102,6 +102,7 @@ extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
 xfs_failaddr_t xfs_dir3_leaf_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+xfs_failaddr_t xfs_dir3_data_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 61cbc668f228..b20b08394aa0 100644
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
index c3ef720b5ff6..ea0b9628df18 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -395,17 +395,20 @@ static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
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
+		if (hdr3->hdr.magic != cpu_to_be32(XFS_DIR3_DATA_MAGIC))
+			return __this_address;
+
+		if (be64_to_cpu(hdr3->hdr.owner) != owner)
 			return __this_address;
 	}
 
@@ -416,6 +419,7 @@ int
 xfs_dir3_data_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	xfs_dablk_t		bno,
 	unsigned int		flags,
 	struct xfs_buf		**bpp)
@@ -429,7 +433,7 @@ xfs_dir3_data_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	fa = xfs_dir3_data_header_check(dp, *bpp);
+	fa = xfs_dir3_data_header_check(*bpp, owner);
 	if (fa) {
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 53b808e2a5f0..0b1b852f6178 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -885,9 +885,9 @@ xfs_dir2_leaf_addname(
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
@@ -1328,9 +1328,9 @@ xfs_dir2_leaf_lookup_int(
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
@@ -1370,9 +1370,9 @@ xfs_dir2_leaf_lookup_int(
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
@@ -1666,7 +1666,8 @@ xfs_dir2_leaf_trim_data(
 	/*
 	 * Read the offending data block.  We need its buffer.
 	 */
-	error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(geo, db), 0, &dbp);
+	error = xfs_dir3_data_read(tp, dp, args->owner,
+			xfs_dir2_db_to_da(geo, db), 0, &dbp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index e21965788188..dc85197b8448 100644
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
index 2f0e3ad47b37..879aa2e9fd73 100644
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
index d94e265a8e1f..6b572196bb43 100644
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
index fb98b7624994..bed15a9524a2 100644
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
index 4e811fa393ad..2c03371b542a 100644
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
 

