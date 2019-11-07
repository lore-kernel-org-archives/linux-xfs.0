Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849FAC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FC6D206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FUU0VXan"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKGSZv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:51 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44256 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbfKGSZu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/RfcZc0l9D2nYreGxBLug9MbSuiox7XlSpAEyYCYfbI=; b=FUU0VXanFJYbbs2qBmSsEgkmm
        fQpXUobO0tgntemz1EPudlMtFcQPDJTn+7UmGhuCkczsFnUUTSlv0m1Sxhd1/TFAJKRWo+/yRUJ5l
        du0aYfb0jziGlkcW0cenY6CdTlD8Tp47JW2Up0Gl/HkTBaSvAGZvakjzChHKZHeWzsr+NwvZSQF89
        S3sZKtWhrq0+DQNiZ2rJVZaibZxclj3sHVk7q5keKCh8fJr7eteLMmIJXscHmWBn2efQZ9VxE/9pW
        TG5TTfrmA8xwHU/r2bfEExz50iYUsTnMyGbPuw4rA0Za1+IJvY1B4SNJmbIPuJby2n4HWBxbvrWqj
        ow27ssUDg==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTe-0004Se-AB
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:25:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 37/46] xfs: replace xfs_dir3_data_endp with xfs_dir3_data_end_offset
Date:   Thu,  7 Nov 2019 19:24:01 +0100
Message-Id: <20191107182410.12660-38-hch@lst.de>
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

All the callers really want an offset into the buffer, so adopt
the helper to return that instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2.h      |  2 +-
 fs/xfs/libxfs/xfs_dir2_data.c | 29 +++++++++++++++--------------
 fs/xfs/libxfs/xfs_dir2_sf.c   |  2 +-
 fs/xfs/scrub/dir.c            | 10 +++++-----
 fs/xfs/xfs_dir2_readdir.c     |  2 +-
 5 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index a160f2d4ff37..3a4b98d4973d 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -266,7 +266,7 @@ xfs_dir2_leaf_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_leaf *lp)
 #define XFS_READDIR_BUFSIZE	(32768)
 
 unsigned char xfs_dir3_get_dtype(struct xfs_mount *mp, uint8_t filetype);
-void *xfs_dir3_data_endp(struct xfs_da_geometry *geo,
+unsigned int xfs_dir3_data_end_offset(struct xfs_da_geometry *geo,
 		struct xfs_dir2_data_hdr *hdr);
 bool xfs_dir2_namecheck(const void *name, size_t length);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 8c729270f9f1..f5fa8b9187b0 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -55,7 +55,6 @@ __xfs_dir3_data_check(
 	int			count;		/* count of entries found */
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_data_free_t	*dfp;		/* bestfree entry */
-	void			*endp;		/* end of useful data */
 	int			freeseen;	/* mask of bestfrees seen */
 	xfs_dahash_t		hash;		/* hash of current name */
 	int			i;		/* leaf index */
@@ -102,10 +101,9 @@ __xfs_dir3_data_check(
 	default:
 		return __this_address;
 	}
-	endp = xfs_dir3_data_endp(geo, hdr);
-	if (!endp)
+	end = xfs_dir3_data_end_offset(geo, hdr);
+	if (!end)
 		return __this_address;
-	end = endp - bp->b_addr;
 
 	/*
 	 * Account for zero bestfree entries.
@@ -590,7 +588,7 @@ xfs_dir2_data_freescan_int(
 	memset(bf, 0, sizeof(*bf) * XFS_DIR2_DATA_FD_COUNT);
 	*loghead = 1;
 
-	end = xfs_dir3_data_endp(geo, addr) - addr;
+	end = xfs_dir3_data_end_offset(geo, addr);
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = addr + offset;
 		struct xfs_dir2_data_entry	*dep = addr + offset;
@@ -784,11 +782,11 @@ xfs_dir2_data_make_free(
 {
 	xfs_dir2_data_hdr_t	*hdr;		/* data block pointer */
 	xfs_dir2_data_free_t	*dfp;		/* bestfree pointer */
-	char			*endptr;	/* end of data area */
 	int			needscan;	/* need to regen bestfree */
 	xfs_dir2_data_unused_t	*newdup;	/* new unused entry */
 	xfs_dir2_data_unused_t	*postdup;	/* unused entry after us */
 	xfs_dir2_data_unused_t	*prevdup;	/* unused entry before us */
+	unsigned int		end;
 	struct xfs_dir2_data_free *bf;
 
 	hdr = bp->b_addr;
@@ -796,8 +794,8 @@ xfs_dir2_data_make_free(
 	/*
 	 * Figure out where the end of the data area is.
 	 */
-	endptr = xfs_dir3_data_endp(args->geo, hdr);
-	ASSERT(endptr != NULL);
+	end = xfs_dir3_data_end_offset(args->geo, hdr);
+	ASSERT(end != 0);
 
 	/*
 	 * If this isn't the start of the block, then back up to
@@ -816,7 +814,7 @@ xfs_dir2_data_make_free(
 	 * If this isn't the end of the block, see if the entry after
 	 * us is free.
 	 */
-	if ((char *)hdr + offset + len < endptr) {
+	if (offset + len < end) {
 		postdup =
 			(xfs_dir2_data_unused_t *)((char *)hdr + offset + len);
 		if (be16_to_cpu(postdup->freetag) != XFS_DIR2_DATA_FREE_TAG)
@@ -1144,19 +1142,22 @@ xfs_dir2_data_use_free(
 }
 
 /* Find the end of the entry data in a data/block format dir block. */
-void *
-xfs_dir3_data_endp(
+unsigned int
+xfs_dir3_data_end_offset(
 	struct xfs_da_geometry		*geo,
 	struct xfs_dir2_data_hdr	*hdr)
 {
+	void				*p;
+
 	switch (hdr->magic) {
 	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
 	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
-		return xfs_dir2_block_leaf_p(xfs_dir2_block_tail_p(geo, hdr));
+		p = xfs_dir2_block_leaf_p(xfs_dir2_block_tail_p(geo, hdr));
+		return p - (void *)hdr;
 	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
 	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
-		return (char *)hdr + geo->blksize;
+		return geo->blksize;
 	default:
-		return NULL;
+		return 0;
 	}
 }
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index a1aed589dc8c..bb6491a3c473 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -283,7 +283,7 @@ xfs_dir2_block_to_sf(
 	 * Loop over the active and unused entries.  Stop when we reach the
 	 * leaf/tail portion of the block.
 	 */
-	end = xfs_dir3_data_endp(args->geo, bp->b_addr) - bp->b_addr;
+	end = xfs_dir3_data_end_offset(args->geo, bp->b_addr);
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 4cef21b9d336..7f03f0fb178a 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -187,7 +187,7 @@ xchk_dir_rec(
 	struct xfs_dir2_data_entry	*dent;
 	struct xfs_buf			*bp;
 	struct xfs_dir2_leaf_entry	*ent;
-	void				*endp;
+	unsigned int			end;
 	unsigned int			offset;
 	xfs_ino_t			ino;
 	xfs_dablk_t			rec_bno;
@@ -242,8 +242,8 @@ xchk_dir_rec(
 
 	/* Make sure we got a real directory entry. */
 	offset = mp->m_dir_inode_ops->data_entry_offset;
-	endp = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
-	if (!endp) {
+	end = xfs_dir3_data_end_offset(mp->m_dir_geo, bp->b_addr);
+	if (!end) {
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out_relse;
 	}
@@ -251,7 +251,7 @@ xchk_dir_rec(
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 	
-		if (offset >= endp - bp->b_addr) {
+		if (offset >= end) {
 			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 			goto out_relse;
 		}
@@ -390,7 +390,7 @@ xchk_directory_data_bestfree(
 
 	/* Make sure the bestfrees are actually the best free spaces. */
 	offset = d_ops->data_entry_offset;
-	end = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr) - bp->b_addr;
+	end = xfs_dir3_data_end_offset(mp->m_dir_geo, bp->b_addr);
 
 	/* Iterate the entries, stopping when we hit or go past the end. */
 	while (offset < end) {
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index c4314e9e3dd8..6d229aa93d01 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -175,7 +175,7 @@ xfs_dir2_block_getdents(
 	 * Each object is a real entry (dep) or an unused one (dup).
 	 */
 	offset = dp->d_ops->data_entry_offset;
-	end = xfs_dir3_data_endp(geo, bp->b_addr) - bp->b_addr;
+	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
-- 
2.20.1

