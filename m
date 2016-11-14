Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49307 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933664AbcKNRNW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2016 12:13:22 -0500
Received: from [83.175.99.196] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6Koq-0005UH-Fp
        for linux-xfs@vger.kernel.org; Mon, 14 Nov 2016 17:13:21 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/14] xfs: use new extent lookup helpers in __xfs_reflink_reserve_cow
Date: Mon, 14 Nov 2016 18:12:39 +0100
Message-Id: <1479143565-30615-9-git-send-email-hch@lst.de>
In-Reply-To: <1479143565-30615-1-git-send-email-hch@lst.de>
References: <1479143565-30615-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 52cdfba..35e02ce 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -243,10 +243,11 @@ xfs_reflink_reserve_cow(
 	struct xfs_bmbt_irec	*imap,
 	bool			*shared)
 {
-	struct xfs_bmbt_irec	got, prev;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	struct xfs_bmbt_irec	got;
 	xfs_fileoff_t		end_fsb, orig_end_fsb;
-	int			eof = 0, error = 0;
-	bool			trimmed;
+	int			error = 0;
+	bool			eof = false, trimmed;
 	xfs_extnum_t		idx;
 	xfs_extlen_t		align;
 
@@ -258,8 +259,9 @@ xfs_reflink_reserve_cow(
 	 * extent list is generally faster than going out to the shared extent
 	 * tree.
 	 */
-	xfs_bmap_search_extents(ip, imap->br_startoff, XFS_COW_FORK, &eof, &idx,
-			&got, &prev);
+
+	if (!xfs_iext_lookup_extent(ip, ifp, imap->br_startoff, &idx, &got))
+		eof = true;
 	if (!eof && got.br_startoff <= imap->br_startoff) {
 		trace_xfs_reflink_cow_found(ip, imap);
 		xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
-- 
2.1.4

