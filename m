Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50596 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbfFXFxD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 01:53:03 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/12] xfs: simplify xfs_chain_bio
Date: Mon, 24 Jun 2019 07:52:43 +0200
Message-Id: <20190624055253.31183-3-hch@lst.de>
In-Reply-To: <20190624055253.31183-1-hch@lst.de>
References: <20190624055253.31183-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Move setting up operation and write hint to xfs_alloc_ioend, and
then just copy over all needed information from the previous bio
in xfs_chain_bio and stop passing various parameters to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a6f0f4761a37..9cceb90e77c5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -665,7 +665,6 @@ xfs_submit_ioend(
 
 	ioend->io_bio->bi_private = ioend;
 	ioend->io_bio->bi_end_io = xfs_end_bio;
-	ioend->io_bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
 
 	/*
 	 * If we are failing the IO now, just mark the ioend with an
@@ -679,7 +678,6 @@ xfs_submit_ioend(
 		return status;
 	}
 
-	ioend->io_bio->bi_write_hint = ioend->io_inode->i_write_hint;
 	submit_bio(ioend->io_bio);
 	return 0;
 }
@@ -691,7 +689,8 @@ xfs_alloc_ioend(
 	xfs_exntst_t		state,
 	xfs_off_t		offset,
 	struct block_device	*bdev,
-	sector_t		sector)
+	sector_t		sector,
+	struct writeback_control *wbc)
 {
 	struct xfs_ioend	*ioend;
 	struct bio		*bio;
@@ -699,6 +698,8 @@ xfs_alloc_ioend(
 	bio = bio_alloc_bioset(GFP_NOFS, BIO_MAX_PAGES, &xfs_ioend_bioset);
 	bio_set_dev(bio, bdev);
 	bio->bi_iter.bi_sector = sector;
+	bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
+	bio->bi_write_hint = inode->i_write_hint;
 
 	ioend = container_of(bio, struct xfs_ioend, io_inline_bio);
 	INIT_LIST_HEAD(&ioend->io_list);
@@ -719,24 +720,22 @@ xfs_alloc_ioend(
  * so that the bi_private linkage is set up in the right direction for the
  * traversal in xfs_destroy_ioend().
  */
-static void
+static struct bio *
 xfs_chain_bio(
-	struct xfs_ioend	*ioend,
-	struct writeback_control *wbc,
-	struct block_device	*bdev,
-	sector_t		sector)
+	struct bio		*prev)
 {
 	struct bio *new;
 
 	new = bio_alloc(GFP_NOFS, BIO_MAX_PAGES);
-	bio_set_dev(new, bdev);
-	new->bi_iter.bi_sector = sector;
-	bio_chain(ioend->io_bio, new);
-	bio_get(ioend->io_bio);		/* for xfs_destroy_ioend */
-	ioend->io_bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
-	ioend->io_bio->bi_write_hint = ioend->io_inode->i_write_hint;
-	submit_bio(ioend->io_bio);
-	ioend->io_bio = new;
+	bio_copy_dev(new, prev);
+	new->bi_iter.bi_sector = bio_end_sector(prev);
+	new->bi_opf = prev->bi_opf;
+	new->bi_write_hint = prev->bi_write_hint;
+
+	bio_chain(prev, new);
+	bio_get(prev);		/* for xfs_destroy_ioend */
+	submit_bio(prev);
+	return new;
 }
 
 /*
@@ -771,14 +770,14 @@ xfs_add_to_ioend(
 		if (wpc->ioend)
 			list_add(&wpc->ioend->io_list, iolist);
 		wpc->ioend = xfs_alloc_ioend(inode, wpc->fork,
-				wpc->imap.br_state, offset, bdev, sector);
+				wpc->imap.br_state, offset, bdev, sector, wbc);
 	}
 
 	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff, true)) {
 		if (iop)
 			atomic_inc(&iop->write_count);
 		if (bio_full(wpc->ioend->io_bio))
-			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
+			wpc->ioend->io_bio = xfs_chain_bio(wpc->ioend->io_bio);
 		bio_add_page(wpc->ioend->io_bio, page, len, poff);
 	}
 
-- 
2.20.1
