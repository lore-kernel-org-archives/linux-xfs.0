Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96494CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69C682085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:10:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MOkXrJIm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfKAWKY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:10:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53854 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWKX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:10:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LzhYbY+O1xXqJNY7BkhYBKpZe4luwoxSpeqJuOwOsyg=; b=MOkXrJImw9keAQQcSTdMEblbZ
        +m1aSzTXJK8xSsrYzL2TVg4TRj4EGVs9cCDTvvmL0fUEEO+sTsG1q8cMOp6eA9+Yx7UuJjMe0E+b6
        8tcVStasW7imtbW9kQKOWd0HRq257ef6FFtLHs+effgVGdmFLVI90zAHsubIqLepUOS06p/7roOwV
        OFUEm6ZlM1OjkavRupGwG/TKvLlt8IC4Hujl/MCLMRQE73kajUQ2GjDyCx2A8vN3wp1bwZcbFkFhW
        XbSb3/nABxDUYFUBUjjDlVPDkqIC2vSxncyZ/XDZsx7in/1/sl9t4OMmr/qYi+KS4OVI+NFZaXbOC
        v+bTqusLA==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf7f-0007Xu-Hy
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:10:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 33/34] xfs: merge xfs_dir2_data_freescan and xfs_dir2_data_freescan_int
Date:   Fri,  1 Nov 2019 15:07:18 -0700
Message-Id: <20191101220719.29100-34-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101220719.29100-1-hch@lst.de>
References: <20191101220719.29100-1-hch@lst.de>
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
---
 fs/xfs/libxfs/xfs_dir2.h       |  4 +---
 fs/xfs/libxfs/xfs_dir2_block.c | 10 +++++-----
 fs/xfs/libxfs/xfs_dir2_data.c  | 11 +----------
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  6 +++---
 fs/xfs/libxfs/xfs_dir2_node.c  |  4 ++--
 5 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index ccdbc612fb76..8bf4cf227740 100644
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
index 94d32e515478..4b3ea6730775 100644
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
index 9752a0da5b95..4304c62796dd 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -615,7 +615,7 @@ xfs_dir2_data_freeremove(
  * Given a data block, reconstruct its bestfree map.
  */
 void
-xfs_dir2_data_freescan_int(
+xfs_dir2_data_freescan(
 	struct xfs_mount	*mp,
 	struct xfs_dir2_data_hdr *hdr,
 	int			*loghead)
@@ -670,15 +670,6 @@ xfs_dir2_data_freescan_int(
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
index ff54c8f08ded..6912264e081e 100644
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
@@ -1413,7 +1413,7 @@ xfs_dir2_leaf_removename(
 	 * log the data block header if necessary.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(dp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(args, dbp);
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index e51b103fd429..a131ed5e5f3b 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1322,7 +1322,7 @@ xfs_dir2_leafn_remove(
 	 * Log the data block header if needed.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(dp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(args, dbp);
 	xfs_dir3_data_check(dp, dbp);
@@ -1970,7 +1970,7 @@ xfs_dir2_node_addname_int(
 
 	/* Rescan the freespace and log the data block if needed. */
 	if (needscan)
-		xfs_dir2_data_freescan(dp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(args, dbp);
 
-- 
2.20.1

