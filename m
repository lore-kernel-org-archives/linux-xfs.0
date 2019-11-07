Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCACC5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6C58206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:26:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m/9Ye7yW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbfKGS0L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:26:11 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44326 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728384AbfKGS0L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:26:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fKcxHnhtBRy0ZnEnAO6mu56gCQZXC0p39dFHwxFiM10=; b=m/9Ye7yWCVy2ABaPq38QbVG8TO
        ATuWmTKcD7ge/Rf8OEAnQgphm0Jdh4wuYDlPy2vtzwBW8KlinoPPj1cMmIPZ1c6s6wWLgtENjutfr
        URatk9Or+9qIMkBM4bhbYlNzCeLJgsIFPi4wv/L6WKAUr10fahKOayYx/IZLne4esRtutE3gI+I+h
        45Jg33tKKHgYVgZS59nFrADdWD6whT8flw6VfiIbXXTnlOIlsA2Dx/gYKOkCKFGhmPEiL3wks5orE
        QQQ0rPEz4AH4ExsyhkVWne+UThjlX7j/XLHeDmtBx1+tdISzoUA71NjTneISHaX6vLc2pgf3U5h4N
        +cljE5Rg==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTy-0004Vi-L1; Thu, 07 Nov 2019 18:26:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 45/46] xfs: merge xfs_dir2_data_freescan and xfs_dir2_data_freescan_int
Date:   Thu,  7 Nov 2019 19:24:09 +0100
Message-Id: <20191107182410.12660-46-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107182410.12660-1-hch@lst.de>
References: <20191107182410.12660-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is no real need for xfs_dir2_data_freescan wrapper, so rename
xfs_dir2_data_freescan_int to xfs_dir2_data_freescan and let the
callers dereference the mount pointer from the inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.h       |  4 +---
 fs/xfs/libxfs/xfs_dir2_block.c | 10 +++++-----
 fs/xfs/libxfs/xfs_dir2_data.c  | 11 +----------
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  6 +++---
 fs/xfs/libxfs/xfs_dir2_node.c  |  4 ++--
 5 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index a0cd423c79dd..34e7a0b64205 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -66,9 +66,7 @@ extern int xfs_dir2_isleaf(struct xfs_da_args *args, int *r);
 extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
 				struct xfs_buf *bp);
 
-extern void xfs_dir2_data_freescan_int(struct xfs_mount *mp,
-		struct xfs_dir2_data_hdr *hdr, int *loghead);
-extern void xfs_dir2_data_freescan(struct xfs_inode *dp,
+extern void xfs_dir2_data_freescan(struct xfs_mount *mp,
 		struct xfs_dir2_data_hdr *hdr, int *loghead);
 extern void xfs_dir2_data_log_entry(struct xfs_da_args *args,
 		struct xfs_buf *bp, struct xfs_dir2_data_entry *dep);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 0c481e55c981..358151ddfa75 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -311,7 +311,7 @@ xfs_dir2_block_compact(
 	 * This needs to happen before the next call to use_free.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(args->dp, hdr, needlog);
+		xfs_dir2_data_freescan(args->dp->i_mount, hdr, needlog);
 }
 
 /*
@@ -458,7 +458,7 @@ xfs_dir2_block_addname(
 		 * This needs to happen before the next call to use_free.
 		 */
 		if (needscan) {
-			xfs_dir2_data_freescan(dp, hdr, &needlog);
+			xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
 			needscan = 0;
 		}
 		/*
@@ -548,7 +548,7 @@ xfs_dir2_block_addname(
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(dp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(args, bp);
 	xfs_dir2_block_log_tail(tp, bp);
@@ -807,7 +807,7 @@ xfs_dir2_block_removename(
 	 * Fix up bestfree, log the header if necessary.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(dp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(args, bp);
 	xfs_dir3_data_check(dp, bp);
@@ -1014,7 +1014,7 @@ xfs_dir2_leaf_to_block(
 	 * Scan the bestfree if we need it and log the data block header.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(dp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(args, dbp);
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 0aa1d165c964..9e471a28b6c6 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -608,7 +608,7 @@ xfs_dir2_data_freeremove(
  * Given a data block, reconstruct its bestfree map.
  */
 void
-xfs_dir2_data_freescan_int(
+xfs_dir2_data_freescan(
 	struct xfs_mount		*mp,
 	struct xfs_dir2_data_hdr	*hdr,
 	int				*loghead)
@@ -655,15 +655,6 @@ xfs_dir2_data_freescan_int(
 	}
 }
 
-void
-xfs_dir2_data_freescan(
-	struct xfs_inode	*dp,
-	struct xfs_dir2_data_hdr *hdr,
-	int			*loghead)
-{
-	return xfs_dir2_data_freescan_int(dp->i_mount, hdr, loghead);
-}
-
 /*
  * Initialize a data block at the given block number in the directory.
  * Give back the buffer for the created block.
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index bc301c973450..2c67a9e24bd0 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -465,7 +465,7 @@ xfs_dir2_block_to_leaf(
 		hdr->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
 
 	if (needscan)
-		xfs_dir2_data_freescan(dp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
 	/*
 	 * Set up leaf tail and bests table.
 	 */
@@ -872,7 +872,7 @@ xfs_dir2_leaf_addname(
 	 * Need to scan fix up the bestfree table.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(dp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
 	/*
 	 * Need to log the data block's header.
 	 */
@@ -1415,7 +1415,7 @@ xfs_dir2_leaf_removename(
 	 * log the data block header if necessary.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(dp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(args, dbp);
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 5551be7c29df..3f36769f15af 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1328,7 +1328,7 @@ xfs_dir2_leafn_remove(
 	 * Log the data block header if needed.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(dp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(args, dbp);
 	xfs_dir3_data_check(dp, dbp);
@@ -1976,7 +1976,7 @@ xfs_dir2_node_addname_int(
 
 	/* Rescan the freespace and log the data block if needed. */
 	if (needscan)
-		xfs_dir2_data_freescan(dp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(args, dbp);
 
-- 
2.20.1

