Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41314 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbeIRCXX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Sep 2018 22:23:23 -0400
Received: from 089144198037.atnat0007.highway.a1.net ([89.144.198.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g20XG-0005z2-C8
        for linux-xfs@vger.kernel.org; Mon, 17 Sep 2018 20:54:22 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/10] xfs: remove the unused shared argument to xfs_reflink_reserve_cow
Date: Mon, 17 Sep 2018 22:53:52 +0200
Message-Id: <20180917205354.15401-9-hch@lst.de>
In-Reply-To: <20180917205354.15401-1-hch@lst.de>
References: <20180917205354.15401-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c   |  4 +---
 fs/xfs/xfs_reflink.c | 12 +++++-------
 fs/xfs/xfs_reflink.h |  2 +-
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 2d08ace09e25..0d815b00643b 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -560,12 +560,10 @@ xfs_file_iomap_begin_delay(
 		if (xfs_is_reflink_inode(ip) &&
 		    ((flags & IOMAP_WRITE) ||
 		     got.br_state != XFS_EXT_UNWRITTEN)) {
-			bool		shared;
-
 			end_fsb = min(XFS_B_TO_FSB(mp, offset + count),
 					maxbytes_fsb);
 			xfs_trim_extent(&got, offset_fsb, end_fsb - offset_fsb);
-			error = xfs_reflink_reserve_cow(ip, &got, &shared);
+			error = xfs_reflink_reserve_cow(ip, &got);
 			if (error)
 				goto out_unlock;
 		}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d60d0eeed7b9..0b41d29d433d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -241,7 +241,7 @@ xfs_reflink_trim_around_shared(
 /*
  * Trim the passed in imap to the next shared/unshared extent boundary, and
  * if imap->br_startoff points to a shared extent reserve space for it in the
- * COW fork.  In this case *shared is set to true, else to false.
+ * COW fork.
  *
  * Note that imap will always contain the block numbers for the existing blocks
  * in the data fork, as the upper layers need them for read-modify-write
@@ -250,14 +250,14 @@ xfs_reflink_trim_around_shared(
 int
 xfs_reflink_reserve_cow(
 	struct xfs_inode	*ip,
-	struct xfs_bmbt_irec	*imap,
-	bool			*shared)
+	struct xfs_bmbt_irec	*imap)
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	struct xfs_bmbt_irec	got;
 	int			error = 0;
 	bool			eof = false, trimmed;
 	struct xfs_iext_cursor	icur;
+	bool			shared;
 
 	/*
 	 * Search the COW fork extent list first.  This serves two purposes:
@@ -273,18 +273,16 @@ xfs_reflink_reserve_cow(
 	if (!eof && got.br_startoff <= imap->br_startoff) {
 		trace_xfs_reflink_cow_found(ip, imap);
 		xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
-
-		*shared = true;
 		return 0;
 	}
 
 	/* Trim the mapping to the nearest shared extent boundary. */
-	error = xfs_reflink_trim_around_shared(ip, imap, shared, &trimmed);
+	error = xfs_reflink_trim_around_shared(ip, imap, &shared, &trimmed);
 	if (error)
 		return error;
 
 	/* Not shared?  Just report the (potentially capped) extent. */
-	if (!*shared)
+	if (!shared)
 		return 0;
 
 	/*
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index c585ad9552b2..b77f4079022a 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -13,7 +13,7 @@ extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *irec, bool *shared, bool *trimmed);
 
 extern int xfs_reflink_reserve_cow(struct xfs_inode *ip,
-		struct xfs_bmbt_irec *imap, bool *shared);
+		struct xfs_bmbt_irec *imap);
 extern int xfs_reflink_allocate_cow(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode);
 extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
-- 
2.18.0
