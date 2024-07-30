Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065CA8C13
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299340; cv=none; b=CpSmeI/PHagxfArBdowSerzCkGXkbCGh2QgI6cjNHpmk4zntpH3zZ5waLvUB/Vy8AgwuSyY53/GwXmONpansoGpdPbpLObJnJS/Y8TjARze/GNSsO4QVGxmAggzHSxnLpFtI5ewDAGIbYT8sLKwrXBCjG2T/l3oU58O/GubyL6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299340; c=relaxed/simple;
	bh=zydH+z+Y+1A1IRfDLBo7KiWFF2x6ElBeQ2EvFF7HVaY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pgCz2fac8FUkh+OEZgbO3u9qQyNv837rIivaGqm4C+FTIvPaTnEXj5JsyGSmOVgc2/BpwTdLLykIgHH+xbufSGQnFZuYqBqnhdw5I4P3ff0aS4+/8TFNhS36VKbsii+R1kpCJSkBK2lc6sxk4FeVrtCFmN3mb4uuKPHqVE4ruoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQyFFv96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQyFFv96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C03C32786;
	Tue, 30 Jul 2024 00:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299339;
	bh=zydH+z+Y+1A1IRfDLBo7KiWFF2x6ElBeQ2EvFF7HVaY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hQyFFv96d1hBx9DX4krj9r1BwXYb75UsKf+j81Yim41tlCdiUq3oE9TOCOfXSrbCx
	 5qoqau5jW3Xe/b+59+pHSwvx6w9C7tZxRJHaLfoSJLhPToFob13I/CbWviYanUU/od
	 B+tSGkOQ3RGKVU2kSRyAd7M6Kmm4aUqDGWkI2OL9bqg4FMQZcguWeLZYmaaeDQ8K1u
	 kXvCGYZiIRwH+XTR3Kpwj5XJqtXOQnPZsnqisHU9iO9Uuhz/Cer+HLSvRjyOGVCfQZ
	 B07tmEggNiHgK6Xp/nX1HAppBCMBm/WNp+NBLifEObY2PJmb/giVt+50EFcjGwgw7C
	 jsYSpcWfyerBQ==
Date: Mon, 29 Jul 2024 17:28:59 -0700
Subject: [PATCH 020/115] xfs: validate explicit directory data buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842724.1338752.8940938544601205900.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: cc6740ddb423db2066f7669eaaa377fdbf84ab1e

Port the existing directory data header checking function to accept an
owner number instead of an xfs_inode, then update the callsites to use
xfs_da_args.owner when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/namei.c              |    3 ++-
 libxfs/xfs_dir2.h       |    1 +
 libxfs/xfs_dir2_block.c |    3 ++-
 libxfs/xfs_dir2_data.c  |   16 ++++++++++------
 libxfs/xfs_dir2_leaf.c  |   21 +++++++++++----------
 libxfs/xfs_dir2_node.c  |    7 +++----
 libxfs/xfs_dir2_priv.h  |    3 ++-
 7 files changed, 31 insertions(+), 23 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index 5a6fd2036..d2541b78a 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -398,7 +398,8 @@ list_leafdir(
 		libxfs_trim_extent(&map, dabno, geo->leafblk - dabno);
 
 		/* Read the directory block of that first mapping. */
-		error = xfs_dir3_data_read(NULL, dp, map.br_startoff, 0, &bp);
+		error = xfs_dir3_data_read(NULL, dp, args->owner,
+				map.br_startoff, 0, &bp);
 		if (error)
 			break;
 
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 2f728c26a..d623bfdcd 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -102,6 +102,7 @@ extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
 xfs_failaddr_t xfs_dir3_leaf_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+xfs_failaddr_t xfs_dir3_data_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index c91559e59..6107e01ca 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -979,7 +979,8 @@ xfs_dir2_leaf_to_block(
 	 * Read the data block if we don't already have it, give up if it fails.
 	 */
 	if (!dbp) {
-		error = xfs_dir3_data_read(tp, dp, args->geo->datablk, 0, &dbp);
+		error = xfs_dir3_data_read(tp, dp, args->owner,
+				args->geo->datablk, 0, &dbp);
 		if (error)
 			return error;
 	}
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 6f3ccfeb6..0c77245ee 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -392,17 +392,20 @@ static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
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
 
@@ -413,6 +416,7 @@ int
 xfs_dir3_data_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	xfs_dablk_t		bno,
 	unsigned int		flags,
 	struct xfs_buf		**bpp)
@@ -426,7 +430,7 @@ xfs_dir3_data_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	fa = xfs_dir3_data_header_check(dp, *bpp);
+	fa = xfs_dir3_data_header_check(*bpp, owner);
 	if (fa) {
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 6ce2d4b28..1c12b5a66 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -883,9 +883,9 @@ xfs_dir2_leaf_addname(
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
@@ -1326,9 +1326,9 @@ xfs_dir2_leaf_lookup_int(
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
@@ -1368,9 +1368,9 @@ xfs_dir2_leaf_lookup_int(
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
@@ -1664,7 +1664,8 @@ xfs_dir2_leaf_trim_data(
 	/*
 	 * Read the offending data block.  We need its buffer.
 	 */
-	error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(geo, db), 0, &dbp);
+	error = xfs_dir3_data_read(tp, dp, args->owner,
+			xfs_dir2_db_to_da(geo, db), 0, &dbp);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index c0160d725..690407374 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -860,7 +860,7 @@ xfs_dir2_leafn_lookup_for_entry(
 				ASSERT(state->extravalid);
 				curbp = state->extrablk.bp;
 			} else {
-				error = xfs_dir3_data_read(tp, dp,
+				error = xfs_dir3_data_read(tp, dp, args->owner,
 						xfs_dir2_db_to_da(args->geo,
 								  newdb),
 						0, &curbp);
@@ -1946,9 +1946,8 @@ xfs_dir2_node_addname_int(
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
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 2f0e3ad47..879aa2e9f 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -78,7 +78,8 @@ extern void xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 extern xfs_failaddr_t __xfs_dir3_data_check(struct xfs_inode *dp,
 		struct xfs_buf *bp);
 int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
-		xfs_dablk_t bno, unsigned int flags, struct xfs_buf **bpp);
+		xfs_ino_t owner, xfs_dablk_t bno, unsigned int flags,
+		struct xfs_buf **bpp);
 int xfs_dir3_data_readahead(struct xfs_inode *dp, xfs_dablk_t bno,
 		unsigned int flags);
 

