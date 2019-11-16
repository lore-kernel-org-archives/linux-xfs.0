Return-Path: <SRS0=QPje=ZI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180B5C432C3
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0A7A2068E
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VpYy1BCd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfKPSW3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Nov 2019 13:22:29 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35022 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfKPSW3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Nov 2019 13:22:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=05NVeRW/Gj6FEf02D8SOTXC2fYyPQhKv62/a1EHewAQ=; b=VpYy1BCdLqJuUi5qnDBUPOuKRY
        dHfKzcV+iYbM0TwDmuFewI/+dQInN78wagI2r2+O56nTobIs1mANyJmaoC4Ebabpsxe8YQUYKYfon
        gFsl8d+MNIgoE6472Ck5oNbAVlmK4/T+rabjpnrzXrp79nQGmA+UHbG0uREQ+Teo3INXmVRFOEJqw
        TouzgCa3GNKykBWAS32jXHxbM6kpD0MCIOe7Dx6g6YhUQpoXi/eAw9BDieqP1kBtNcFimwv29uxKu
        QcT/R7Dn2xWZwxHw/220uVD6OkK7dmXV6QDbzq85pa6KT3r2JANUGXMc4DDdSFMyooI8MAtkMuQ1Q
        ENhH9s1A==;
Received: from [2001:4bb8:180:3806:c70:4a89:bc61:6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iW2iK-0006ho-O3; Sat, 16 Nov 2019 18:22:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 4/9] xfs: remove the mappedbno argument to xfs_attr3_leaf_read
Date:   Sat, 16 Nov 2019 19:22:09 +0100
Message-Id: <20191116182214.23711-5-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116182214.23711-1-hch@lst.de>
References: <20191116182214.23711-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This argument is always hard coded to -1, so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c      | 10 +++++-----
 fs/xfs/libxfs/xfs_attr_leaf.c | 17 ++++++++---------
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 +--
 fs/xfs/xfs_attr_list.c        |  5 +++--
 4 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 510ca6974604..ebe6b0575f40 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -589,7 +589,7 @@ xfs_attr_leaf_addname(
 	 */
 	dp = args->dp;
 	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
 	if (error)
 		return error;
 
@@ -715,7 +715,7 @@ xfs_attr_leaf_addname(
 		 * remove the "old" attr from that block (neat, huh!)
 		 */
 		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
-					   -1, &bp);
+					   &bp);
 		if (error)
 			return error;
 
@@ -769,7 +769,7 @@ xfs_attr_leaf_removename(
 	 */
 	dp = args->dp;
 	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
 	if (error)
 		return error;
 
@@ -813,7 +813,7 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 	trace_xfs_attr_leaf_get(args);
 
 	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
 	if (error)
 		return error;
 
@@ -1173,7 +1173,7 @@ xfs_attr_node_removename(
 		ASSERT(state->path.blk[0].bp);
 		state->path.blk[0].bp = NULL;
 
-		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, -1, &bp);
+		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
 		if (error)
 			goto out;
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 85ec5945d29f..9c0cdb51955e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -430,13 +430,12 @@ xfs_attr3_leaf_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
-	xfs_daddr_t		mappedbno,
 	struct xfs_buf		**bpp)
 {
 	int			err;
 
-	err = xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
-				XFS_ATTR_FORK, &xfs_attr3_leaf_buf_ops);
+	err = xfs_da_read_buf(tp, dp, bno, -1, bpp, XFS_ATTR_FORK,
+			&xfs_attr3_leaf_buf_ops);
 	if (!err && tp && *bpp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_ATTR_LEAF_BUF);
 	return err;
@@ -1159,7 +1158,7 @@ xfs_attr3_leaf_to_node(
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
-	error = xfs_attr3_leaf_read(args->trans, dp, 0, -1, &bp1);
+	error = xfs_attr3_leaf_read(args->trans, dp, 0, &bp1);
 	if (error)
 		goto out;
 
@@ -1994,7 +1993,7 @@ xfs_attr3_leaf_toosmall(
 		if (blkno == 0)
 			continue;
 		error = xfs_attr3_leaf_read(state->args->trans, state->args->dp,
-					blkno, -1, &bp);
+					blkno, &bp);
 		if (error)
 			return error;
 
@@ -2730,7 +2729,7 @@ xfs_attr3_leaf_clearflag(
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
 	if (error)
 		return error;
 
@@ -2797,7 +2796,7 @@ xfs_attr3_leaf_setflag(
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
 	if (error)
 		return error;
 
@@ -2859,7 +2858,7 @@ xfs_attr3_leaf_flipflags(
 	/*
 	 * Read the block containing the "old" attr
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp1);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp1);
 	if (error)
 		return error;
 
@@ -2868,7 +2867,7 @@ xfs_attr3_leaf_flipflags(
 	 */
 	if (args->blkno2 != args->blkno) {
 		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno2,
-					   -1, &bp2);
+					   &bp2);
 		if (error)
 			return error;
 	} else {
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 16208a7743df..f4a188e28b7b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -108,8 +108,7 @@ int	xfs_attr_leaf_order(struct xfs_buf *leaf1_bp,
 				   struct xfs_buf *leaf2_bp);
 int	xfs_attr_leaf_newentsize(struct xfs_da_args *args, int *local);
 int	xfs_attr3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
-			xfs_dablk_t bno, xfs_daddr_t mappedbno,
-			struct xfs_buf **bpp);
+			xfs_dablk_t bno, struct xfs_buf **bpp);
 void	xfs_attr3_leaf_hdr_from_disk(struct xfs_da_geometry *geo,
 				     struct xfs_attr3_icleaf_hdr *to,
 				     struct xfs_attr_leafblock *from);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 0ec6606149a2..426f93cfb2ea 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -380,7 +380,8 @@ xfs_attr_node_list(
 			break;
 		cursor->blkno = leafhdr.forw;
 		xfs_trans_brelse(context->tp, bp);
-		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno, -1, &bp);
+		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno,
+					    &bp);
 		if (error)
 			return error;
 	}
@@ -500,7 +501,7 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
 	trace_xfs_attr_leaf_list(context);
 
 	context->cursor->blkno = 0;
-	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, -1, &bp);
+	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, &bp);
 	if (error)
 		return error;
 
-- 
2.20.1

