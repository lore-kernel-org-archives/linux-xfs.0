Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49685 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933841AbcKNRNa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2016 12:13:30 -0500
Received: from [83.175.99.196] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6Koz-0005eS-Md
        for linux-xfs@vger.kernel.org; Mon, 14 Nov 2016 17:13:30 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/14] xfs: use new extent lookup helpers in xfs_reflink_trim_irec_to_next_cow
Date: Mon, 14 Nov 2016 18:12:41 +0100
Message-Id: <1479143565-30615-11-git-send-email-hch@lst.de>
In-Reply-To: <1479143565-30615-1-git-send-email-hch@lst.de>
References: <1479143565-30615-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

And remove the unused return value.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 33 ++++++++++++---------------------
 fs/xfs/xfs_reflink.h |  2 +-
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 6056fd1..0668490 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -452,43 +452,34 @@ xfs_reflink_find_cow_mapping(
 /*
  * Trim an extent to end at the next CoW reservation past offset_fsb.
  */
-int
+void
 xfs_reflink_trim_irec_to_next_cow(
 	struct xfs_inode		*ip,
 	xfs_fileoff_t			offset_fsb,
 	struct xfs_bmbt_irec		*imap)
 {
-	struct xfs_bmbt_irec		irec;
-	struct xfs_ifork		*ifp;
-	struct xfs_bmbt_rec_host	*gotp;
+	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	struct xfs_bmbt_irec		got;
 	xfs_extnum_t			idx;
 
 	if (!xfs_is_reflink_inode(ip))
-		return 0;
+		return;
 
 	/* Find the extent in the CoW fork. */
-	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
-	gotp = xfs_iext_bno_to_ext(ifp, offset_fsb, &idx);
-	if (!gotp)
-		return 0;
-	xfs_bmbt_get_all(gotp, &irec);
+	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got))
+		return;
 
 	/* This is the extent before; try sliding up one. */
-	if (irec.br_startoff < offset_fsb) {
-		idx++;
-		if (idx >= xfs_iext_count(ifp))
-			return 0;
-		gotp = xfs_iext_get_ext(ifp, idx);
-		xfs_bmbt_get_all(gotp, &irec);
+	if (got.br_startoff < offset_fsb) {
+		if (!xfs_iext_get_extent(ifp, idx + 1, &got))
+			return;
 	}
 
-	if (irec.br_startoff >= imap->br_startoff + imap->br_blockcount)
-		return 0;
+	if (got.br_startoff >= imap->br_startoff + imap->br_blockcount)
+		return;
 
-	imap->br_blockcount = irec.br_startoff - imap->br_startoff;
+	imap->br_blockcount = got.br_startoff - imap->br_startoff;
 	trace_xfs_reflink_trim_irec(ip, imap);
-
-	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index cff5fc3..aa6a4d6 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -32,7 +32,7 @@ extern int xfs_reflink_allocate_cow_range(struct xfs_inode *ip,
 		xfs_off_t offset, xfs_off_t count);
 extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
 		struct xfs_bmbt_irec *imap);
-extern int xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
+extern void xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
 		xfs_fileoff_t offset_fsb, struct xfs_bmbt_irec *imap);
 
 extern int xfs_reflink_cancel_cow_blocks(struct xfs_inode *ip,
-- 
2.1.4

