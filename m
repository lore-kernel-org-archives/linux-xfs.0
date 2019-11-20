Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F111C432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 11:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEE46223D8
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 11:17:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LV3e/vEY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbfKTLRs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 06:17:48 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47750 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728118AbfKTLRs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 06:17:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PnY87yp59QNF3fdp+MDYGBYGvbOOtSt3zovNXA07WuA=; b=LV3e/vEY94SvFFEeQ+gunfqo0N
        tCVUHSw+f/g0bA/bScaj8+hHQCXjaHBZoJu3B5B/Cjo3ybs2CPGBNEauV/NKMGMkhqBnNb/oMGIcN
        AUkPVkb6D7owYQtn7/5CkcNbMfaYtTzZgJu5fRvgh7bWaBu/GekgcGpRmqPY05EaI6krr9N9jlFh0
        FywkjWCwH/4JwB7ZDOj6iAT7rWA0/vwl3/bZWMuFWFIqbEppWS9YFtFJZk9FDb+gi+x4kcQaZdUud
        AnSWAOmSBQQHn30SX2F5gRqCcYkgthtRqpmmKnciYvjnhHxoi/SfR78agfIT3eCPGU42skEXb4IqC
        Z4llxkFg==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iXNzX-0001T4-QX; Wed, 20 Nov 2019 11:17:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/10] xfs: remove the mappedbno argument to xfs_da_read_buf
Date:   Wed, 20 Nov 2019 12:17:26 +0100
Message-Id: <20191120111727.16119-10-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191120111727.16119-1-hch@lst.de>
References: <20191120111727.16119-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the code for reading an already mapped block into
xfs_da3_node_read_mapped, which is the only caller ever passing a block
number in the mappedbno argument and replace the mappedbno argument with
the simple xfs_dabuf_get flags.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  |  2 +-
 fs/xfs/libxfs/xfs_da_btree.c   | 34 ++++++++++++++++------------------
 fs/xfs/libxfs/xfs_da_btree.h   |  5 ++---
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
 fs/xfs/libxfs/xfs_dir2_data.c  |  6 +++---
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 13 ++++++-------
 fs/xfs/libxfs/xfs_dir2_node.c  | 14 +++++++-------
 fs/xfs/libxfs/xfs_dir2_priv.h  |  4 ++--
 fs/xfs/scrub/dabtree.c         |  4 ++--
 fs/xfs/scrub/dir.c             |  9 +++++----
 fs/xfs/xfs_dir2_readdir.c      |  2 +-
 11 files changed, 47 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2d17ed342a96..b0742c856de2 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -434,7 +434,7 @@ xfs_attr3_leaf_read(
 {
 	int			err;
 
-	err = xfs_da_read_buf(tp, dp, bno, -1, bpp, XFS_ATTR_FORK,
+	err = xfs_da_read_buf(tp, dp, bno, 0, bpp, XFS_ATTR_FORK,
 			&xfs_attr3_leaf_buf_ops);
 	if (!err && tp && *bpp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_ATTR_LEAF_BUF);
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 04ee02379f3b..2f2723ee70ae 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -369,7 +369,7 @@ xfs_da3_node_read(
 {
 	int			error;
 
-	error = xfs_da_read_buf(tp, dp, bno, -1, bpp, whichfork,
+	error = xfs_da_read_buf(tp, dp, bno, 0, bpp, whichfork,
 			&xfs_da3_node_buf_ops);
 	if (error || !*bpp || !tp)
 		return error;
@@ -384,12 +384,22 @@ xfs_da3_node_read_mapped(
 	struct xfs_buf		**bpp,
 	int			whichfork)
 {
+	struct xfs_mount	*mp = dp->i_mount;
 	int			error;
 
-	error = xfs_da_read_buf(tp, dp, 0, mappedbno, bpp, whichfork,
-			&xfs_da3_node_buf_ops);
-	if (error || !*bpp || !tp)
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, mappedbno,
+			XFS_FSB_TO_BB(mp, xfs_dabuf_nfsb(mp, whichfork)), 0,
+			bpp, &xfs_da3_node_buf_ops);
+	if (error || !*bpp)
 		return error;
+
+	if (whichfork == XFS_ATTR_FORK)
+		xfs_buf_set_ref(*bpp, XFS_ATTR_BTREE_REF);
+	else
+		xfs_buf_set_ref(*bpp, XFS_DIR_BTREE_REF);
+
+	if (!tp)
+		return 0;
 	return xfs_da3_node_set_type(tp, *bpp);
 }
 
@@ -2618,7 +2628,7 @@ xfs_da_read_buf(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
-	xfs_daddr_t		mappedbno,
+	unsigned int		flags,
 	struct xfs_buf		**bpp,
 	int			whichfork,
 	const struct xfs_buf_ops *ops)
@@ -2630,24 +2640,12 @@ xfs_da_read_buf(
 	int			error;
 
 	*bpp = NULL;
-
-	if (mappedbno >= 0) {
-		error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-				mappedbno, XFS_FSB_TO_BB(mp,
-					xfs_dabuf_nfsb(mp, whichfork)),
-				0, &bp, ops);
-		goto done;
-	}
-
-	error = xfs_dabuf_map(dp, bno,
-			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
-			whichfork, &mapp, &nmap);
+	error = xfs_dabuf_map(dp, bno, flags, whichfork, &mapp, &nmap);
 	if (error || !nmap)
 		goto out_free;
 
 	error = xfs_trans_read_buf_map(mp, tp, mp->m_ddev_targp, mapp, nmap, 0,
 			&bp, ops);
-done:
 	if (error)
 		goto out_free;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 25bcbfa9016f..f83d18a5d5f1 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -206,9 +206,8 @@ int	xfs_da_get_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 			      xfs_dablk_t bno, xfs_daddr_t mappedbno,
 			      struct xfs_buf **bp, int whichfork);
 int	xfs_da_read_buf(struct xfs_trans *trans, struct xfs_inode *dp,
-			       xfs_dablk_t bno, xfs_daddr_t mappedbno,
-			       struct xfs_buf **bpp, int whichfork,
-			       const struct xfs_buf_ops *ops);
+		xfs_dablk_t bno, unsigned int flags, struct xfs_buf **bpp,
+		int whichfork, const struct xfs_buf_ops *ops);
 int	xfs_da_reada_buf(struct xfs_inode *dp, xfs_dablk_t bno,
 		unsigned int flags, int whichfork,
 		const struct xfs_buf_ops *ops);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 328a8dd53a22..d6ced59b9567 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -123,7 +123,7 @@ xfs_dir3_block_read(
 	struct xfs_mount	*mp = dp->i_mount;
 	int			err;
 
-	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, -1, bpp,
+	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, 0, bpp,
 				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
 	if (!err && tp && *bpp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
@@ -950,7 +950,7 @@ xfs_dir2_leaf_to_block(
 	 * Read the data block if we don't already have it, give up if it fails.
 	 */
 	if (!dbp) {
-		error = xfs_dir3_data_read(tp, dp, args->geo->datablk, -1, &dbp);
+		error = xfs_dir3_data_read(tp, dp, args->geo->datablk, 0, &dbp);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 2ab0c78aac3f..34f87a12b09e 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -400,13 +400,13 @@ xfs_dir3_data_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
-	xfs_daddr_t		mapped_bno,
+	unsigned int		flags,
 	struct xfs_buf		**bpp)
 {
 	int			err;
 
-	err = xfs_da_read_buf(tp, dp, bno, mapped_bno, bpp,
-				XFS_DATA_FORK, &xfs_dir3_data_buf_ops);
+	err = xfs_da_read_buf(tp, dp, bno, flags, bpp, XFS_DATA_FORK,
+			&xfs_dir3_data_buf_ops);
 	if (!err && tp && *bpp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
 	return err;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 482a974d6361..8c6faf086ff9 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -266,7 +266,7 @@ xfs_dir3_leaf_read(
 {
 	int			err;
 
-	err = xfs_da_read_buf(tp, dp, fbno, -1, bpp, XFS_DATA_FORK,
+	err = xfs_da_read_buf(tp, dp, fbno, 0, bpp, XFS_DATA_FORK,
 			&xfs_dir3_leaf1_buf_ops);
 	if (!err && tp && *bpp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAF1_BUF);
@@ -282,7 +282,7 @@ xfs_dir3_leafn_read(
 {
 	int			err;
 
-	err = xfs_da_read_buf(tp, dp, fbno, -1, bpp, XFS_DATA_FORK,
+	err = xfs_da_read_buf(tp, dp, fbno, 0, bpp, XFS_DATA_FORK,
 			&xfs_dir3_leafn_buf_ops);
 	if (!err && tp && *bpp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAFN_BUF);
@@ -826,7 +826,7 @@ xfs_dir2_leaf_addname(
 		 */
 		error = xfs_dir3_data_read(tp, dp,
 				   xfs_dir2_db_to_da(args->geo, use_block),
-				   -1, &dbp);
+				   0, &dbp);
 		if (error) {
 			xfs_trans_brelse(tp, lbp);
 			return error;
@@ -1268,7 +1268,7 @@ xfs_dir2_leaf_lookup_int(
 				xfs_trans_brelse(tp, dbp);
 			error = xfs_dir3_data_read(tp, dp,
 					   xfs_dir2_db_to_da(args->geo, newdb),
-					   -1, &dbp);
+					   0, &dbp);
 			if (error) {
 				xfs_trans_brelse(tp, lbp);
 				return error;
@@ -1310,7 +1310,7 @@ xfs_dir2_leaf_lookup_int(
 			xfs_trans_brelse(tp, dbp);
 			error = xfs_dir3_data_read(tp, dp,
 					   xfs_dir2_db_to_da(args->geo, cidb),
-					   -1, &dbp);
+					   0, &dbp);
 			if (error) {
 				xfs_trans_brelse(tp, lbp);
 				return error;
@@ -1602,8 +1602,7 @@ xfs_dir2_leaf_trim_data(
 	/*
 	 * Read the offending data block.  We need its buffer.
 	 */
-	error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(geo, db), -1,
-				   &dbp);
+	error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(geo, db), 0, &dbp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 2e2129fdb6a9..cc871345a141 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -212,14 +212,14 @@ __xfs_dir3_free_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		fbno,
-	xfs_daddr_t		mappedbno,
+	unsigned int		flags,
 	struct xfs_buf		**bpp)
 {
 	xfs_failaddr_t		fa;
 	int			err;
 
-	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
-				XFS_DATA_FORK, &xfs_dir3_free_buf_ops);
+	err = xfs_da_read_buf(tp, dp, fbno, flags, bpp, XFS_DATA_FORK,
+			&xfs_dir3_free_buf_ops);
 	if (err || !*bpp)
 		return err;
 
@@ -297,7 +297,7 @@ xfs_dir2_free_read(
 	xfs_dablk_t		fbno,
 	struct xfs_buf		**bpp)
 {
-	return __xfs_dir3_free_read(tp, dp, fbno, -1, bpp);
+	return __xfs_dir3_free_read(tp, dp, fbno, 0, bpp);
 }
 
 static int
@@ -307,7 +307,7 @@ xfs_dir2_free_try_read(
 	xfs_dablk_t		fbno,
 	struct xfs_buf		**bpp)
 {
-	return __xfs_dir3_free_read(tp, dp, fbno, -2, bpp);
+	return __xfs_dir3_free_read(tp, dp, fbno, XFS_DABUF_MAP_HOLE_OK, bpp);
 }
 
 static int
@@ -857,7 +857,7 @@ xfs_dir2_leafn_lookup_for_entry(
 				error = xfs_dir3_data_read(tp, dp,
 						xfs_dir2_db_to_da(args->geo,
 								  newdb),
-						-1, &curbp);
+						0, &curbp);
 				if (error)
 					return error;
 			}
@@ -1940,7 +1940,7 @@ xfs_dir2_node_addname_int(
 		/* Read the data block in. */
 		error = xfs_dir3_data_read(tp, dp,
 					   xfs_dir2_db_to_da(args->geo, dbno),
-					   -1, &dbp);
+					   0, &dbp);
 	}
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 15353b61051b..c031c53d0f0d 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -77,8 +77,8 @@ extern void xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 
 extern xfs_failaddr_t __xfs_dir3_data_check(struct xfs_inode *dp,
 		struct xfs_buf *bp);
-extern int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
-		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
+int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_dablk_t bno, unsigned int flags, struct xfs_buf **bpp);
 int xfs_dir3_data_readahead(struct xfs_inode *dp, xfs_dablk_t bno,
 		unsigned int flags);
 
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 85b9207359ec..97a15b6f2865 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -331,8 +331,8 @@ xchk_da_btree_block(
 		goto out_nobuf;
 
 	/* Read the buffer. */
-	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno, -2,
-			&blk->bp, dargs->whichfork,
+	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno,
+			XFS_DABUF_MAP_HOLE_OK, &blk->bp, dargs->whichfork,
 			&xchk_da_btree_buf_ops);
 	if (!xchk_da_process_error(ds, level, &error))
 		goto out_nobuf;
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 910e0bf85bd7..266da4e4bde6 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -229,7 +229,8 @@ xchk_dir_rec(
 		xchk_da_set_corrupt(ds, level);
 		goto out;
 	}
-	error = xfs_dir3_data_read(ds->dargs.trans, dp, rec_bno, -2, &bp);
+	error = xfs_dir3_data_read(ds->dargs.trans, dp, rec_bno,
+			XFS_DABUF_MAP_HOLE_OK, &bp);
 	if (!xchk_fblock_process_error(ds->sc, XFS_DATA_FORK, rec_bno,
 			&error))
 		goto out;
@@ -346,7 +347,7 @@ xchk_directory_data_bestfree(
 		error = xfs_dir3_block_read(sc->tp, sc->ip, &bp);
 	} else {
 		/* dir data format */
-		error = xfs_dir3_data_read(sc->tp, sc->ip, lblk, -1, &bp);
+		error = xfs_dir3_data_read(sc->tp, sc->ip, lblk, 0, &bp);
 	}
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		goto out;
@@ -557,7 +558,7 @@ xchk_directory_leaf1_bestfree(
 		if (best == NULLDATAOFF)
 			continue;
 		error = xfs_dir3_data_read(sc->tp, sc->ip,
-				i * args->geo->fsbcount, -1, &dbp);
+				i * args->geo->fsbcount, 0, &dbp);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
 				&error))
 			break;
@@ -608,7 +609,7 @@ xchk_directory_free_bestfree(
 		}
 		error = xfs_dir3_data_read(sc->tp, sc->ip,
 				(freehdr.firstdb + i) * args->geo->fsbcount,
-				-1, &dbp);
+				0, &dbp);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
 				&error))
 			break;
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 5df3d1e2b17f..0d3b640cf1cc 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -279,7 +279,7 @@ xfs_dir2_leaf_readbuf(
 	new_off = xfs_dir2_da_to_byte(geo, map.br_startoff);
 	if (new_off > *cur_off)
 		*cur_off = new_off;
-	error = xfs_dir3_data_read(args->trans, dp, map.br_startoff, -1, &bp);
+	error = xfs_dir3_data_read(args->trans, dp, map.br_startoff, 0, &bp);
 	if (error)
 		goto out;
 
-- 
2.20.1

