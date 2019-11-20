Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A756C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 11:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B79D223D8
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 11:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S77Jk0T2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbfKTLRj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 06:17:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47718 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfKTLRj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 06:17:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1q8+mFDyEN8jgN8GhcRMUZNrfddHImhv8G1lkML9Qy8=; b=S77Jk0T29XhWXPMZLOdNaA72c+
        WUBbfKv+E9AHg3KnymQYWyaqvXdRXm41CxNkefrWCBKpeFDprwL7Sq8wyWsK51wYnZz7+U3eFDHeq
        Z1kTtCSzAGEya7WBxSYmesy8VfbfvfXwZBixSeIr5rQQA2VAy5rzhhLzXa8pkHEF2TBuELyEJVDr6
        dwavau9XS4eXG3NYh0di023getLR13BSJ55n+xqrKjuAyUSC0TfvK5LkZWEWqA4PhURyEaCXjDqFf
        Q5kXHtkL/9oHcoHLbDJ2Z5QlFWCne68kzO48Ol7/ZzUy9R2bn/LjN0H2/NS2Dk90eXMBZ80CW49i+
        3I/vzFKw==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iXNzP-0001RZ-2A; Wed, 20 Nov 2019 11:17:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/10] xfs: remove the mappedbno argument to xfs_attr3_leaf_read
Date:   Wed, 20 Nov 2019 12:17:22 +0100
Message-Id: <20191120111727.16119-6-hch@lst.de>
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

This argument is always hard coded to -1, so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
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
index 86155260d8b9..2d17ed342a96 100644
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
 
@@ -1996,7 +1995,7 @@ xfs_attr3_leaf_toosmall(
 		if (blkno == 0)
 			continue;
 		error = xfs_attr3_leaf_read(state->args->trans, state->args->dp,
-					blkno, -1, &bp);
+					blkno, &bp);
 		if (error)
 			return error;
 
@@ -2732,7 +2731,7 @@ xfs_attr3_leaf_clearflag(
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
 	if (error)
 		return error;
 
@@ -2799,7 +2798,7 @@ xfs_attr3_leaf_setflag(
 	/*
 	 * Set up the operation.
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
 	if (error)
 		return error;
 
@@ -2861,7 +2860,7 @@ xfs_attr3_leaf_flipflags(
 	/*
 	 * Read the block containing the "old" attr
 	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp1);
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp1);
 	if (error)
 		return error;
 
@@ -2870,7 +2869,7 @@ xfs_attr3_leaf_flipflags(
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
index 7a099df88a0c..fe914368ea7e 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -377,7 +377,8 @@ xfs_attr_node_list(
 			break;
 		cursor->blkno = leafhdr.forw;
 		xfs_trans_brelse(context->tp, bp);
-		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno, -1, &bp);
+		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno,
+					    &bp);
 		if (error)
 			return error;
 	}
@@ -495,7 +496,7 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
 	trace_xfs_attr_leaf_list(context);
 
 	context->cursor->blkno = 0;
-	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, -1, &bp);
+	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, &bp);
 	if (error)
 		return error;
 
-- 
2.20.1

