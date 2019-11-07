Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB74CC5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9130E206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oY7Rcuv+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbfKGSZd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:33 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44204 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfKGSZd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=b7RABoVBnES0Jx+F7q3+rPqCyYyWZbwW112ckBws6bc=; b=oY7Rcuv+tf10ZUE7HCSfY/25K
        be+MO5wGjHJ9zj0jd/ZBDVUn9qa33jSmXr844hFrkkYfaIBvpiqxvN2SwwXyxWu4/ItEVP36Gn0e9
        7AaLheICD10DXru6SgW49BakREBtFO6HxiJlxgcsfbRYpIxkzEOQl8G7MpmjTrJqRWGS5+Ybx8LQQ
        9CXQpaUqDaxDqFFkds/i/z6TmyY6sIeINTOeZIG1LETPL3QB6k50l06zSKyCKi0v0/ZZfH2WLu1UJ
        96TBh2SJ3Ulu0Mnl450o+rEQ0X2VWcCyVFgzSaI8q1XpoHFKZIyio6SPFyePkDl3NE/ywAJvvq8fO
        UHn3h8wZA==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTM-0004PT-Fy
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:25:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 30/46] xfs: cleanup xfs_dir2_leaf_getdents
Date:   Thu,  7 Nov 2019 19:23:54 +0100
Message-Id: <20191107182410.12660-31-hch@lst.de>
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

Use an offset as the main means for iteration, and only do pointer
arithmetics to find the data/unused entries.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dir2_readdir.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 0d234b649d65..c4314e9e3dd8 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -351,13 +351,13 @@ xfs_dir2_leaf_getdents(
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_data_entry_t	*dep;		/* data entry */
 	xfs_dir2_data_unused_t	*dup;		/* unused entry */
-	char			*ptr = NULL;	/* pointer to current data */
 	struct xfs_da_geometry	*geo = args->geo;
 	xfs_dablk_t		rablk = 0;	/* current readahead block */
 	xfs_dir2_off_t		curoff;		/* current overall offset */
 	int			length;		/* temporary length value */
 	int			byteoff;	/* offset in current block */
 	int			lock_mode;
+	unsigned int		offset = 0;
 	int			error = 0;	/* error return value */
 
 	/*
@@ -384,7 +384,7 @@ xfs_dir2_leaf_getdents(
 		 * If we have no buffer, or we're off the end of the
 		 * current buffer, need to get another one.
 		 */
-		if (!bp || ptr >= (char *)bp->b_addr + geo->blksize) {
+		if (!bp || offset + geo->blksize) {
 			if (bp) {
 				xfs_trans_brelse(args->trans, bp);
 				bp = NULL;
@@ -402,7 +402,7 @@ xfs_dir2_leaf_getdents(
 			/*
 			 * Find our position in the block.
 			 */
-			ptr = (char *)dp->d_ops->data_entry_p(hdr);
+			offset = dp->d_ops->data_entry_offset;
 			byteoff = xfs_dir2_byte_to_off(geo, curoff);
 			/*
 			 * Skip past the header.
@@ -413,20 +413,20 @@ xfs_dir2_leaf_getdents(
 			 * Skip past entries until we reach our offset.
 			 */
 			else {
-				while ((char *)ptr - (char *)hdr < byteoff) {
-					dup = (xfs_dir2_data_unused_t *)ptr;
+				while (offset < byteoff) {
+					dup = bp->b_addr + offset;
 
 					if (be16_to_cpu(dup->freetag)
 						  == XFS_DIR2_DATA_FREE_TAG) {
 
 						length = be16_to_cpu(dup->length);
-						ptr += length;
+						offset += length;
 						continue;
 					}
-					dep = (xfs_dir2_data_entry_t *)ptr;
+					dep = bp->b_addr + offset;
 					length =
 					   dp->d_ops->data_entsize(dep->namelen);
-					ptr += length;
+					offset += length;
 				}
 				/*
 				 * Now set our real offset.
@@ -434,28 +434,28 @@ xfs_dir2_leaf_getdents(
 				curoff =
 					xfs_dir2_db_off_to_byte(geo,
 					    xfs_dir2_byte_to_db(geo, curoff),
-					    (char *)ptr - (char *)hdr);
-				if (ptr >= (char *)hdr + geo->blksize) {
+					    offset);
+				if (offset >= geo->blksize)
 					continue;
-				}
 			}
 		}
+
 		/*
-		 * We have a pointer to an entry.
-		 * Is it a live one?
+		 * We have a pointer to an entry.  Is it a live one?
 		 */
-		dup = (xfs_dir2_data_unused_t *)ptr;
+		dup = bp->b_addr + offset;
+
 		/*
 		 * No, it's unused, skip over it.
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
 			length = be16_to_cpu(dup->length);
-			ptr += length;
+			offset += length;
 			curoff += length;
 			continue;
 		}
 
-		dep = (xfs_dir2_data_entry_t *)ptr;
+		dep = bp->b_addr + offset;
 		length = dp->d_ops->data_entsize(dep->namelen);
 		filetype = dp->d_ops->data_get_ftype(dep);
 
@@ -474,7 +474,7 @@ xfs_dir2_leaf_getdents(
 		/*
 		 * Advance to next entry in the block.
 		 */
-		ptr += length;
+		offset += length;
 		curoff += length;
 		/* bufsize may have just been a guess; don't go negative */
 		bufsize = bufsize > length ? bufsize - length : 0;
-- 
2.20.1

