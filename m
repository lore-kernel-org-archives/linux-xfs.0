Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45943 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932115AbdJaOXQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 10:23:16 -0400
Received: from bzq-164-168-31-210.red.bezeqint.net ([31.168.164.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e9XRj-0007fl-RJ
        for linux-xfs@vger.kernel.org; Tue, 31 Oct 2017 14:23:16 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/18] xfs: simplify xfs_reflink_convert_cow
Date: Tue, 31 Oct 2017 16:22:26 +0200
Message-Id: <20171031142230.11755-15-hch@lst.de>
In-Reply-To: <20171031142230.11755-1-hch@lst.de>
References: <20171031142230.11755-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Instead of looking up extents to convert and calling xfs_bmapi_write on
each of them just let xfs_bmapi_write handle the full range.  To make
this robust add a new XFS_BMAPI_CONVERT_ONLY that only converts ranges
and never allocates blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |  3 ++-
 fs/xfs/libxfs/xfs_bmap.h |  3 +++
 fs/xfs/xfs_reflink.c     | 29 +++++++++++------------------
 3 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 453dc1ae76ab..e020bd3f8717 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4330,7 +4330,8 @@ xfs_bmapi_write(
 		 * First, deal with the hole before the allocated space
 		 * that we found, if any.
 		 */
-		if (need_alloc || wasdelay) {
+		if ((need_alloc || wasdelay) &&
+		    !(flags & XFS_BMAPI_CONVERT_ONLY)) {
 			bma.eof = eof;
 			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
 			bma.wasdel = wasdelay;
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 195f335f4615..fba60ed7aea5 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -113,6 +113,9 @@ struct xfs_extent_free_item
 /* Only convert delalloc space, don't allocate entirely new extents */
 #define XFS_BMAPI_DELALLOC	0x400
 
+/* Only convert unwritten extents, don't allocate new hotels */
+#define XFS_BMAPI_CONVERT_ONLY	0x800
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 43bec0def51d..99c5d4dbc5d3 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -353,29 +353,22 @@ xfs_reflink_convert_cow(
 	xfs_off_t		offset,
 	xfs_off_t		count)
 {
-	struct xfs_bmbt_irec	got;
-	struct xfs_defer_ops	dfops;
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
-	struct xfs_iext_cursor	ext;
-	bool			found;
-	int			error = 0;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_filblks_t		count_fsb = end_fsb - offset_fsb;
+	struct xfs_bmbt_irec	imap;
+	struct xfs_defer_ops	dfops;
+	xfs_fsblock_t		first_block = NULLFSBLOCK;
+	int			nimaps = 1, error = 0;
 
-	/* Convert all the extents to real from unwritten. */
-	for (found = xfs_iext_lookup_extent(ip, ifp, offset_fsb, &ext, &got);
-	     found && got.br_startoff < end_fsb;
-	     found = xfs_iext_next_extent(ifp, &ext, &got)) {
-		error = xfs_reflink_convert_cow_extent(ip, &got, offset_fsb,
-				end_fsb - offset_fsb, &dfops);
-		if (error)
-			break;
-	}
+	ASSERT(count != 0);
 
-	/* Finish up. */
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	error = xfs_bmapi_write(NULL, ip, offset_fsb, count_fsb,
+			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT |
+			XFS_BMAPI_CONVERT_ONLY, &first_block, 0, &imap, &nimaps,
+			&dfops);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
-- 
2.14.2

