Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40642 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729418AbfGVJvA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jul 2019 05:51:00 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/12] iomap: zero newly allocated mapped blocks
Date: Mon, 22 Jul 2019 11:50:24 +0200
Message-Id: <20190722095024.19075-13-hch@lst.de>
In-Reply-To: <20190722095024.19075-1-hch@lst.de>
References: <20190722095024.19075-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

File systems like gfs2 don't support delayed allocations or unwritten
extents and thus allocate normal mapped blocks to fill holes.  To
cover the case of such file systems allocating new blocks to fill holes
also zero out mapped blocks with the new flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 91a9796f8a7c..ba0511131868 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -226,6 +226,14 @@ iomap_read_inline_data(struct inode *inode, struct page *page,
 	SetPageUptodate(page);
 }
 
+static inline bool iomap_block_needs_zeroing(struct inode *inode,
+		struct iomap *iomap, loff_t pos)
+{
+	return iomap->type != IOMAP_MAPPED ||
+		(iomap->flags & IOMAP_F_NEW) ||
+		pos >= i_size_read(inode);
+}
+
 static loff_t
 iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		struct iomap *iomap)
@@ -249,7 +257,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	if (plen == 0)
 		goto done;
 
-	if (iomap->type != IOMAP_MAPPED || pos >= i_size_read(inode)) {
+	if (iomap_block_needs_zeroing(inode, iomap, pos)) {
 		zero_user(page, poff, plen);
 		iomap_set_range_uptodate(page, poff, plen);
 		goto done;
@@ -563,7 +571,7 @@ iomap_read_page_sync(struct inode *inode, loff_t block_start, struct page *page,
 	struct bio_vec bvec;
 	struct bio bio;
 
-	if (iomap->type != IOMAP_MAPPED || block_start >= i_size_read(inode)) {
+	if (iomap_block_needs_zeroing(inode, iomap, block_start)) {
 		zero_user_segments(page, poff, from, to, poff + plen);
 		iomap_set_range_uptodate(page, poff, plen);
 		return 0;
-- 
2.20.1
