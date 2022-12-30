Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD89EC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbiL3X7Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbiL3X7Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:59:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D4A16588
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:59:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EECD61CAB
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66B2C433EF;
        Fri, 30 Dec 2022 23:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444753;
        bh=QCViV2p4egx2kGvG/E18SeW4DWwvBus9w0VDcahRZ0c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sBoW6rbxc22cVC9sPrFF39ye33X/bBtcAjwHb60SyuvNlWA7cwsGQH9//pIz+dGl9
         bR6ONwoYEDNzBBVlf0VZ4a7iiYgFFvjlfRg7VtpNU4cfjNSKscxp0HXjq8osjLqdLd
         5gWHvqkEU3q8z0BlwEYKavVn62hpAC8m/xCXDQCIPSMB/+9Qu22FGJ+/cxH1jsAJLh
         njC2227gqc/Qw+kszxRNvPsUGjw9M9kxRDZtJPsqq76JplNnUq36800paBW1LYd+28
         lw5bV4sAk8sNsmkcT93s8CtvW0mqVJBxRElno5VlLEkJdMU01DM5XP3cfcmwwV27H1
         cUb0QlC9jCSsw==
Subject: [PATCH 7/9] xfs: validate explicit directory data buffer owners
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:09 -0800
Message-ID: <167243844934.700244.14400842742894388891.stgit@magnolia>
In-Reply-To: <167243844821.700244.10251762547708755105.stgit@magnolia>
References: <167243844821.700244.10251762547708755105.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Port the existing directory data header checking function to accept an
owner number instead of an xfs_inode, then update the callsites to use
xfs_da_args.owner when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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
index b5ad503e47b3..2c2564c2158d 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -90,6 +90,7 @@ extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
 xfs_failaddr_t xfs_dir3_leaf_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+xfs_failaddr_t xfs_dir3_data_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 6bda6a490671..184341bb1f6a 100644
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
index c3ef720b5ff6..00c2061aed34 100644
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
index 16a581e225a3..a6eee2604487 100644
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
index 8a7b5f030a6c..22267a6e651a 100644
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
index 81348bea8add..01b00edfeb6d 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -193,8 +193,8 @@ xchk_dir_rec(
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
@@ -311,7 +311,8 @@ xchk_directory_data_bestfree(
 		error = xfs_dir3_block_read(sc->tp, sc->ip, &bp);
 	} else {
 		/* dir data format */
-		error = xfs_dir3_data_read(sc->tp, sc->ip, lblk, 0, &bp);
+		error = xfs_dir3_data_read(sc->tp, sc->ip, sc->ip->i_ino, lblk,
+				0, &bp);
 	}
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		goto out;
@@ -524,10 +525,9 @@ xchk_directory_leaf1_bestfree(
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
@@ -590,7 +590,7 @@ xchk_directory_free_bestfree(
 			stale++;
 			continue;
 		}
-		error = xfs_dir3_data_read(sc->tp, sc->ip,
+		error = xfs_dir3_data_read(sc->tp, sc->ip, args->owner,
 				(freehdr.firstdb + i) * args->geo->fsbcount,
 				0, &dbp);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index 59a658362b2b..b385325707e0 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -177,7 +177,7 @@ xchk_read_leaf_dir_buf(
 	if (new_off > *curoff)
 		*curoff = new_off;
 
-	return xfs_dir3_data_read(tp, dp, map.br_startoff, 0, bpp);
+	return xfs_dir3_data_read(tp, dp, dp->i_ino, map.br_startoff, 0, bpp);
 }
 
 /* Call a function for every entry in a leaf directory. */
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index fc2524b8f1f1..37a521f47f20 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -284,7 +284,8 @@ xfs_dir2_leaf_readbuf(
 	new_off = xfs_dir2_da_to_byte(geo, map.br_startoff);
 	if (new_off > *cur_off)
 		*cur_off = new_off;
-	error = xfs_dir3_data_read(args->trans, dp, map.br_startoff, 0, &bp);
+	error = xfs_dir3_data_read(args->trans, dp, args->owner,
+			map.br_startoff, 0, &bp);
 	if (error)
 		goto out;
 

