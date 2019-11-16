Return-Path: <SRS0=QPje=ZI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C17C432C3
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F9042068D
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bNb01asp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbfKPSWf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Nov 2019 13:22:35 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35038 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfKPSWf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Nov 2019 13:22:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FbXg6nFAA/eOuNYyby67FMG9CA1cVq7kvQ4CtkqYiuI=; b=bNb01aspU1aSgpT3dgcMtF/bl8
        zadap0sGuxOBpdaort5Vi42+QU6DQ9qkuzArY7tOF/RdUR9GCCKYnz1ZOVp9B2sXkjp/DW5G5JQV6
        SvGmo6qysrdGC7d0NYjXSLZ1Sw2JnPnurBeA9bYEAiniFTwrbH5E6NfhfqtOY46MmeclhTLfwfDaA
        m+XMZqmPcjHzWUHaiXhBjIpe1pkjkVCbGjoQkF/2HKBqynjVeyLZi2sS+C8O22rnKlTK7Ur4gQoOO
        F0YolT3yHFQAogL0rGijCr84s27Z0XEGUiFuLba4NgfXxI656hbQev3eNP/0YSB9p4qqxr+lXHjzf
        ymPUtKwQ==;
Received: from [2001:4bb8:180:3806:c70:4a89:bc61:6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iW2iR-0006if-5L; Sat, 16 Nov 2019 18:22:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 6/9] xfs: remove the mappedbno argument to xfs_dir3_leafn_read
Date:   Sat, 16 Nov 2019 19:22:11 +0100
Message-Id: <20191116182214.23711-7-hch@lst.de>
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
 fs/xfs/libxfs/xfs_dir2_leaf.c | 5 ++---
 fs/xfs/libxfs/xfs_dir2_node.c | 3 +--
 fs/xfs/libxfs/xfs_dir2_priv.h | 4 ++--
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 2eee4e299e19..a1fe45db61c3 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -278,13 +278,12 @@ xfs_dir3_leafn_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		fbno,
-	xfs_daddr_t		mappedbno,
 	struct xfs_buf		**bpp)
 {
 	int			err;
 
-	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
-				XFS_DATA_FORK, &xfs_dir3_leafn_buf_ops);
+	err = xfs_da_read_buf(tp, dp, fbno, -1, bpp, XFS_DATA_FORK,
+			&xfs_dir3_leafn_buf_ops);
 	if (!err && tp && *bpp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAFN_BUF);
 	return err;
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 5f30a1953a52..a5450229a7ef 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1554,8 +1554,7 @@ xfs_dir2_leafn_toosmall(
 		/*
 		 * Read the sibling leaf block.
 		 */
-		error = xfs_dir3_leafn_read(state->args->trans, dp,
-					    blkno, -1, &bp);
+		error = xfs_dir3_leafn_read(state->args->trans, dp, blkno, &bp);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index ade41556901a..3001cf82baa6 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -93,8 +93,8 @@ void xfs_dir2_leaf_hdr_to_disk(struct xfs_mount *mp, struct xfs_dir2_leaf *to,
 		struct xfs_dir3_icleaf_hdr *from);
 int xfs_dir3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, struct xfs_buf **bpp);
-extern int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
-		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
+int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_dablk_t fbno, struct xfs_buf **bpp);
 extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
 		struct xfs_buf *dbp);
 extern int xfs_dir2_leaf_addname(struct xfs_da_args *args);
-- 
2.20.1

