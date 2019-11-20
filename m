Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E92C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 11:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F17A1223D8
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 11:17:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k2+8JE91"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbfKTLRu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 06:17:50 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728118AbfKTLRu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 06:17:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=m+q99mosSkfGMZ9to8jQTION4cm3L/3LIFOMlbe0Z9o=; b=k2+8JE91RvNyF3/9kNJ/SCOwUh
        QR9W45zQ6aqZCghylvzHTm84zhUmzZBuzkUPMPsw7QntAojCT0c9LQuGkqvHNB/lWItxsiu+ucnkK
        xzMqhJ30uj+2+PPNjkxnCvx4/o7VL6mcpH8z0xbpmUvE4GoaW/VBmzDRSgm14ZirZeWZR4stKBwjv
        TYZYz1Jmu0YHa0gEE9D5OSKZPoXUt377Q/sRt69DQnAjk3duv7aQYQgujfcgDZApwzLsQG/sPjneg
        xD+bdoeJkg5fcW1lZ3eXeFP3t4beYpx3BuTEZ12bJ2byOh9Gd0RFamei6ctlulFVWN9eCI0NQd0Og
        gsPdxZyQ==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iXNzZ-0001TQ-VW; Wed, 20 Nov 2019 11:17:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/10] xfs: remove the mappedbno argument to xfs_da_get_buf
Date:   Wed, 20 Nov 2019 12:17:27 +0100
Message-Id: <20191120111727.16119-11-hch@lst.de>
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

Use the xfs_da_get_buf_daddr function directly for the two callers
that pass a mapped disk address, and then remove the mappedbno argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |  4 ++--
 fs/xfs/libxfs/xfs_da_btree.c  | 18 +++---------------
 fs/xfs/libxfs/xfs_da_btree.h  |  3 +--
 fs/xfs/libxfs/xfs_dir2_data.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_node.c |  2 +-
 fs/xfs/xfs_attr_inactive.c    | 24 +++++++++++++++++++-----
 7 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b0742c856de2..08d4b10ae2d5 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1162,7 +1162,7 @@ xfs_attr3_leaf_to_node(
 	if (error)
 		goto out;
 
-	error = xfs_da_get_buf(args->trans, dp, blkno, -1, &bp2, XFS_ATTR_FORK);
+	error = xfs_da_get_buf(args->trans, dp, blkno, &bp2, XFS_ATTR_FORK);
 	if (error)
 		goto out;
 
@@ -1223,7 +1223,7 @@ xfs_attr3_leaf_create(
 
 	trace_xfs_attr_leaf_create(args);
 
-	error = xfs_da_get_buf(args->trans, args->dp, blkno, -1, &bp,
+	error = xfs_da_get_buf(args->trans, args->dp, blkno, &bp,
 					    XFS_ATTR_FORK);
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 2f2723ee70ae..b7a2faffca7a 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -429,7 +429,7 @@ xfs_da3_node_create(
 	trace_xfs_da_node_create(args);
 	ASSERT(level <= XFS_DA_NODE_MAXDEPTH);
 
-	error = xfs_da_get_buf(tp, dp, blkno, -1, &bp, whichfork);
+	error = xfs_da_get_buf(tp, dp, blkno, &bp, whichfork);
 	if (error)
 		return error;
 	bp->b_ops = &xfs_da3_node_buf_ops;
@@ -656,7 +656,7 @@ xfs_da3_root_split(
 
 	dp = args->dp;
 	tp = args->trans;
-	error = xfs_da_get_buf(tp, dp, blkno, -1, &bp, args->whichfork);
+	error = xfs_da_get_buf(tp, dp, blkno, &bp, args->whichfork);
 	if (error)
 		return error;
 	node = bp->b_addr;
@@ -2577,7 +2577,6 @@ xfs_da_get_buf(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
-	xfs_daddr_t		mappedbno,
 	struct xfs_buf		**bpp,
 	int			whichfork)
 {
@@ -2588,22 +2587,11 @@ xfs_da_get_buf(
 	int			error;
 
 	*bpp = NULL;
-
-	if (mappedbno >= 0) {
-		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, mappedbno,
-				XFS_FSB_TO_BB(mp,
-					xfs_dabuf_nfsb(mp, whichfork)), 0);
-		goto done;
-	}
-
-	error = xfs_dabuf_map(dp, bno,
-			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
-			whichfork, &mapp, &nmap);
+	error = xfs_dabuf_map(dp, bno, 0, whichfork, &mapp, &nmap);
 	if (error || nmap == 0)
 		goto out_free;
 
 	bp = xfs_trans_get_buf_map(tp, mp->m_ddev_targp, mapp, nmap, 0);
-done:
 	error = bp ? bp->b_error : -EIO;
 	if (error) {
 		if (bp)
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index f83d18a5d5f1..e16610d1c14f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -203,8 +203,7 @@ int	xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno);
 int	xfs_da_grow_inode_int(struct xfs_da_args *args, xfs_fileoff_t *bno,
 			      int count);
 int	xfs_da_get_buf(struct xfs_trans *trans, struct xfs_inode *dp,
-			      xfs_dablk_t bno, xfs_daddr_t mappedbno,
-			      struct xfs_buf **bp, int whichfork);
+		xfs_dablk_t bno, struct xfs_buf **bp, int whichfork);
 int	xfs_da_read_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 		xfs_dablk_t bno, unsigned int flags, struct xfs_buf **bpp,
 		int whichfork, const struct xfs_buf_ops *ops);
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 34f87a12b09e..b9eba8213180 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -679,7 +679,7 @@ xfs_dir3_data_init(
 	 * Get the buffer set up for the block.
 	 */
 	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, blkno),
-			       -1, &bp, XFS_DATA_FORK);
+			       &bp, XFS_DATA_FORK);
 	if (error)
 		return error;
 	bp->b_ops = &xfs_dir3_data_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 8c6faf086ff9..a131b520aac7 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -355,7 +355,7 @@ xfs_dir3_leaf_get_buf(
 	       bno < xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET));
 
 	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, bno),
-			       -1, &bp, XFS_DATA_FORK);
+			       &bp, XFS_DATA_FORK);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index cc871345a141..a0cc5e240306 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -324,7 +324,7 @@ xfs_dir3_free_get_buf(
 	struct xfs_dir3_icfree_hdr hdr;
 
 	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, fbno),
-				   -1, &bp, XFS_DATA_FORK);
+			&bp, XFS_DATA_FORK);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index f1cafd82ec75..5ff49523d8ea 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -196,6 +196,7 @@ xfs_attr3_node_inactive(
 	struct xfs_buf		*bp,
 	int			level)
 {
+	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_blkinfo	*info;
 	xfs_dablk_t		child_fsb;
 	xfs_daddr_t		parent_blkno, child_blkno;
@@ -267,10 +268,16 @@ xfs_attr3_node_inactive(
 		/*
 		 * Remove the subsidiary block from the cache and from the log.
 		 */
-		error = xfs_da_get_buf(*trans, dp, 0, child_blkno, &child_bp,
-				       XFS_ATTR_FORK);
-		if (error)
+		child_bp = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
+				child_blkno,
+				XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0);
+		if (!child_bp)
+			return -EIO;
+		error = bp->b_error;
+		if (error) {
+			xfs_trans_brelse(*trans, child_bp);
 			return error;
+		}
 		xfs_trans_binval(*trans, child_bp);
 
 		/*
@@ -311,6 +318,7 @@ xfs_attr3_root_inactive(
 	struct xfs_trans	**trans,
 	struct xfs_inode	*dp)
 {
+	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_blkinfo	*info;
 	struct xfs_buf		*bp;
 	xfs_daddr_t		blkno;
@@ -353,9 +361,15 @@ xfs_attr3_root_inactive(
 	/*
 	 * Invalidate the incore copy of the root block.
 	 */
-	error = xfs_da_get_buf(*trans, dp, 0, blkno, &bp, XFS_ATTR_FORK);
-	if (error)
+	bp = xfs_trans_get_buf(*trans, mp->m_ddev_targp, blkno,
+			XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0);
+	if (!bp)
+		return -EIO;
+	error = bp->b_error;
+	if (error) {
+		xfs_trans_brelse(*trans, bp);
 		return error;
+	}
 	xfs_trans_binval(*trans, bp);	/* remove from cache */
 	/*
 	 * Commit the invalidate and start the next transaction.
-- 
2.20.1

