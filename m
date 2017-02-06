Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38025 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbdBFHrv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2017 02:47:51 -0500
Received: from 212095007106.public.telering.at ([212.95.7.106] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cae1b-000439-2B
        for linux-xfs@vger.kernel.org; Mon, 06 Feb 2017 07:47:47 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] xfs: introduce xfs_aligned_fsb_count
Date: Mon,  6 Feb 2017 08:47:35 +0100
Message-Id: <20170206074738.13978-2-hch@lst.de>
In-Reply-To: <20170206074738.13978-1-hch@lst.de>
References: <20170206074738.13978-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Factor a helper to calculate the extent-size aligned block out of the
iomap code, so that it can be reused by the upcoming reflink dio code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 11 ++---------
 fs/xfs/xfs_iomap.h | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d17aa3b9c6a5..9d811eb1a416 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -162,7 +162,7 @@ xfs_iomap_write_direct(
 	xfs_fileoff_t	last_fsb;
 	xfs_filblks_t	count_fsb, resaligned;
 	xfs_fsblock_t	firstfsb;
-	xfs_extlen_t	extsz, temp;
+	xfs_extlen_t	extsz;
 	int		nimaps;
 	int		quota_flag;
 	int		rt;
@@ -203,14 +203,7 @@ xfs_iomap_write_direct(
 	}
 	count_fsb = last_fsb - offset_fsb;
 	ASSERT(count_fsb > 0);
-
-	resaligned = count_fsb;
-	if (unlikely(extsz)) {
-		if ((temp = do_mod(offset_fsb, extsz)))
-			resaligned += temp;
-		if ((temp = do_mod(resaligned, extsz)))
-			resaligned += extsz - temp;
-	}
+	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb, extsz);
 
 	if (unlikely(rt)) {
 		resrtextents = qblocks = resaligned;
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 6d45cf01fcff..1fef4a5b71cb 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -33,6 +33,26 @@ void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
 		struct xfs_bmbt_irec *);
 xfs_extlen_t xfs_eof_alignment(struct xfs_inode *ip, xfs_extlen_t extsize);
 
+static inline xfs_filblks_t
+xfs_aligned_fsb_count(
+	xfs_fileoff_t		offset_fsb,
+	xfs_filblks_t		count_fsb,
+	xfs_extlen_t		extsz)
+{
+	if (extsz) {
+		xfs_extlen_t	align;
+
+		align = do_mod(offset_fsb, extsz);
+		if (align)
+			count_fsb += align;
+		align = do_mod(count_fsb, extsz);
+		if (align)
+			count_fsb += extsz - align;
+	}
+
+	return count_fsb;
+}
+
 extern struct iomap_ops xfs_iomap_ops;
 extern struct iomap_ops xfs_xattr_iomap_ops;
 
-- 
2.11.0

