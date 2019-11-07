Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CECC5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23D18206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HqnxI28C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfKGSZa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:30 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44198 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfKGSZa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LKV1/lUs02aHlM0WRuYbg3qhg1XSEnY07wo/6eGjhfY=; b=HqnxI28CDuFfh+4NqIHIKSckX
        lh3GUnyJAHXG+BcI79fiwltgSrEA0T4yd8Z3c0W/fWiy4ivcmk1I+gpu67WkyXRhMNuIQrNM7pv1N
        9OqSyIfTrpxV2XF720wKnZiJdqjKysEYZfA8xO0udoHdDiU/Kgo6cFXFUYKe5Tl4+zkoafAPx/TEP
        vxFdkbNtxYLRz6fKHk3VkQwPqbWe3HQnRPAMvQnpsc4PWgmCSF9B8gqbTUzbq8Z4jWL5C2Ww/cI3n
        8k3nWc7XPOsFvqndekZPhhobHMnrmh0d63uE710P0y3G1mu11QBoulNjDonlECvGzNsTXQtv8QZ8p
        63O793Ifw==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTJ-0004P2-V2
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:25:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 29/46] xfs: cleanup xfs_dir2_block_getdents
Date:   Thu,  7 Nov 2019 19:23:53 +0100
Message-Id: <20191107182410.12660-30-hch@lst.de>
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
 fs/xfs/xfs_dir2_readdir.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 187bb51875c2..0d234b649d65 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -142,17 +142,14 @@ xfs_dir2_block_getdents(
 	struct dir_context	*ctx)
 {
 	struct xfs_inode	*dp = args->dp;	/* incore directory inode */
-	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	struct xfs_buf		*bp;		/* buffer for block */
-	xfs_dir2_data_entry_t	*dep;		/* block data entry */
-	xfs_dir2_data_unused_t	*dup;		/* block unused entry */
-	char			*endptr;	/* end of the data entries */
 	int			error;		/* error return value */
-	char			*ptr;		/* current data entry */
 	int			wantoff;	/* starting block offset */
 	xfs_off_t		cook;
 	struct xfs_da_geometry	*geo = args->geo;
 	int			lock_mode;
+	unsigned int		offset;
+	unsigned int		end;
 
 	/*
 	 * If the block number in the offset is out of range, we're done.
@@ -171,44 +168,39 @@ xfs_dir2_block_getdents(
 	 * We'll skip entries before this.
 	 */
 	wantoff = xfs_dir2_dataptr_to_off(geo, ctx->pos);
-	hdr = bp->b_addr;
 	xfs_dir3_data_check(dp, bp);
-	/*
-	 * Set up values for the loop.
-	 */
-	ptr = (char *)dp->d_ops->data_entry_p(hdr);
-	endptr = xfs_dir3_data_endp(geo, hdr);
 
 	/*
 	 * Loop over the data portion of the block.
 	 * Each object is a real entry (dep) or an unused one (dup).
 	 */
-	while (ptr < endptr) {
+	offset = dp->d_ops->data_entry_offset;
+	end = xfs_dir3_data_endp(geo, bp->b_addr) - bp->b_addr;
+	while (offset < end) {
+		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
+		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
 		uint8_t filetype;
 
-		dup = (xfs_dir2_data_unused_t *)ptr;
 		/*
 		 * Unused, skip it.
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			ptr += be16_to_cpu(dup->length);
+			offset += be16_to_cpu(dup->length);
 			continue;
 		}
 
-		dep = (xfs_dir2_data_entry_t *)ptr;
-
 		/*
 		 * Bump pointer for the next iteration.
 		 */
-		ptr += dp->d_ops->data_entsize(dep->namelen);
+		offset += dp->d_ops->data_entsize(dep->namelen);
+
 		/*
 		 * The entry is before the desired starting point, skip it.
 		 */
-		if ((char *)dep - (char *)hdr < wantoff)
+		if (offset < wantoff)
 			continue;
 
-		cook = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
-					    (char *)dep - (char *)hdr);
+		cook = xfs_dir2_db_off_to_dataptr(geo, geo->datablk, offset);
 
 		ctx->pos = cook & 0x7fffffff;
 		filetype = dp->d_ops->data_get_ftype(dep);
-- 
2.20.1

