Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51587C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C132206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FgfoSr+o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfKGSZk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:40 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44222 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfKGSZk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YrsKhBB4Pz9cYIH34Ek4YrhSUALawlhKNNRMkG5H1aA=; b=FgfoSr+oBkd24hi+4OS+B3H18
        Gn7133chG8dFVS+oCxY1+xBubJx6ion1gddDam7cKFm9sjtJxmJqOyb/YVM6lYJluhuFuY7qSZ+Q+
        oDymtdfP0XHrQYbHzT8DAirtP2mXVumiWmwSuemOGIXzkp4dKMKrDIYfT8rW9YoLaK+AASirix+aD
        EIdeHN952varNNspNN9FDTrNKua4/gjElvgP2YSznq8pjmLl4Ln0YfQu5W8T4xLi5G95ccG82YES2
        d6XnDv4D/0aFMhJMWSfzoy9AOOWOY/3Er0XwfXvH4McWYt/G6DvuchdyRTBUvR0yHfVbo66OH2xAt
        b4ta4nfHQ==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTU-0004Qn-4K
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:25:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 33/46] xfs: cleanup xfs_dir2_block_to_sf
Date:   Thu,  7 Nov 2019 19:23:57 +0100
Message-Id: <20191107182410.12660-34-hch@lst.de>
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
 fs/xfs/libxfs/xfs_dir2_sf.c | 68 ++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 39a537c61b04..a1aed589dc8c 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -255,64 +255,48 @@ xfs_dir2_block_sfsize(
  */
 int						/* error */
 xfs_dir2_block_to_sf(
-	xfs_da_args_t		*args,		/* operation arguments */
+	struct xfs_da_args	*args,		/* operation arguments */
 	struct xfs_buf		*bp,
 	int			size,		/* shortform directory size */
-	xfs_dir2_sf_hdr_t	*sfhp)		/* shortform directory hdr */
+	struct xfs_dir2_sf_hdr	*sfhp)		/* shortform directory hdr */
 {
-	xfs_dir2_data_hdr_t	*hdr;		/* block header */
-	xfs_dir2_data_entry_t	*dep;		/* data entry pointer */
-	xfs_inode_t		*dp;		/* incore directory inode */
-	xfs_dir2_data_unused_t	*dup;		/* unused data pointer */
-	char			*endptr;	/* end of data entries */
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
 	int			error;		/* error return value */
 	int			logflags;	/* inode logging flags */
-	xfs_mount_t		*mp;		/* filesystem mount point */
-	char			*ptr;		/* current data pointer */
-	xfs_dir2_sf_entry_t	*sfep;		/* shortform entry */
-	xfs_dir2_sf_hdr_t	*sfp;		/* shortform directory header */
-	xfs_dir2_sf_hdr_t	*dst;		/* temporary data buffer */
+	struct xfs_dir2_sf_entry *sfep;		/* shortform entry */
+	struct xfs_dir2_sf_hdr	*sfp;		/* shortform directory header */
+	unsigned int		offset = dp->d_ops->data_entry_offset;
+	unsigned int		end;
 
 	trace_xfs_dir2_block_to_sf(args);
 
-	dp = args->dp;
-	mp = dp->i_mount;
-
 	/*
-	 * allocate a temporary destination buffer the size of the inode
-	 * to format the data into. Once we have formatted the data, we
-	 * can free the block and copy the formatted data into the inode literal
-	 * area.
+	 * Allocate a temporary destination buffer the size of the inode to
+	 * format the data into.  Once we have formatted the data, we can free
+	 * the block and copy the formatted data into the inode literal area.
 	 */
-	dst = kmem_alloc(mp->m_sb.sb_inodesize, 0);
-	hdr = bp->b_addr;
-
-	/*
-	 * Copy the header into the newly allocate local space.
-	 */
-	sfp = (xfs_dir2_sf_hdr_t *)dst;
+	sfp = kmem_alloc(mp->m_sb.sb_inodesize, 0);
 	memcpy(sfp, sfhp, xfs_dir2_sf_hdr_size(sfhp->i8count));
 
 	/*
-	 * Set up to loop over the block's entries.
+	 * Loop over the active and unused entries.  Stop when we reach the
+	 * leaf/tail portion of the block.
 	 */
-	ptr = (char *)dp->d_ops->data_entry_p(hdr);
-	endptr = xfs_dir3_data_endp(args->geo, hdr);
+	end = xfs_dir3_data_endp(args->geo, bp->b_addr) - bp->b_addr;
 	sfep = xfs_dir2_sf_firstentry(sfp);
-	/*
-	 * Loop over the active and unused entries.
-	 * Stop when we reach the leaf/tail portion of the block.
-	 */
-	while (ptr < endptr) {
+	while (offset < end) {
+		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
+		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+
 		/*
 		 * If it's unused, just skip over it.
 		 */
-		dup = (xfs_dir2_data_unused_t *)ptr;
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			ptr += be16_to_cpu(dup->length);
+			offset += be16_to_cpu(dup->length);
 			continue;
 		}
-		dep = (xfs_dir2_data_entry_t *)ptr;
+
 		/*
 		 * Skip .
 		 */
@@ -330,9 +314,7 @@ xfs_dir2_block_to_sf(
 		 */
 		else {
 			sfep->namelen = dep->namelen;
-			xfs_dir2_sf_put_offset(sfep,
-				(xfs_dir2_data_aoff_t)
-				((char *)dep - (char *)hdr));
+			xfs_dir2_sf_put_offset(sfep, offset);
 			memcpy(sfep->name, dep->name, dep->namelen);
 			xfs_dir2_sf_put_ino(mp, sfp, sfep,
 					      be64_to_cpu(dep->inumber));
@@ -341,7 +323,7 @@ xfs_dir2_block_to_sf(
 
 			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
 		}
-		ptr += dp->d_ops->data_entsize(dep->namelen);
+		offset += dp->d_ops->data_entsize(dep->namelen);
 	}
 	ASSERT((char *)sfep - (char *)sfp == size);
 
@@ -360,7 +342,7 @@ xfs_dir2_block_to_sf(
 	 * Convert the inode to local format and copy the data in.
 	 */
 	ASSERT(dp->i_df.if_bytes == 0);
-	xfs_init_local_fork(dp, XFS_DATA_FORK, dst, size);
+	xfs_init_local_fork(dp, XFS_DATA_FORK, sfp, size);
 	dp->i_d.di_format = XFS_DINODE_FMT_LOCAL;
 	dp->i_d.di_size = size;
 
@@ -368,7 +350,7 @@ xfs_dir2_block_to_sf(
 	xfs_dir2_sf_check(args);
 out:
 	xfs_trans_log_inode(args->trans, dp, logflags);
-	kmem_free(dst);
+	kmem_free(sfp);
 	return error;
 }
 
-- 
2.20.1

