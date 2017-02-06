Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53082 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbdBFHrw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2017 02:47:52 -0500
Received: from 212095007106.public.telering.at ([212.95.7.106] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cae1f-00043e-BD
        for linux-xfs@vger.kernel.org; Mon, 06 Feb 2017 07:47:52 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] xfs: return the converted extent in __xfs_reflink_convert_cow
Date: Mon,  6 Feb 2017 08:47:36 +0100
Message-Id: <20170206074738.13978-3-hch@lst.de>
In-Reply-To: <20170206074738.13978-1-hch@lst.de>
References: <20170206074738.13978-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We'll need it for the direct I/O code.  Also rename the function to
xfs_reflink_convert_cow_extent to describe it a bit better.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index ae9ba9b6d48f..e6b8af91e9a4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -325,24 +325,23 @@ xfs_reflink_reserve_cow(
 
 /* Convert part of an unwritten CoW extent to a real one. */
 STATIC int
-__xfs_reflink_convert_cow(
+xfs_reflink_convert_cow_extent(
 	struct xfs_inode		*ip,
 	struct xfs_bmbt_irec		*imap,
 	xfs_fileoff_t			offset_fsb,
 	xfs_filblks_t			count_fsb,
 	struct xfs_defer_ops		*dfops)
 {
-	struct xfs_bmbt_irec		irec = *imap;
 	xfs_fsblock_t			first_block;
 	int				nimaps = 1;
 
-	xfs_trim_extent(&irec, offset_fsb, count_fsb);
-	trace_xfs_reflink_convert_cow(ip, &irec);
-	if (irec.br_blockcount == 0)
+	xfs_trim_extent(imap, offset_fsb, count_fsb);
+	trace_xfs_reflink_convert_cow(ip, imap);
+	if (imap->br_blockcount == 0)
 		return 0;
-	return xfs_bmapi_write(NULL, ip, irec.br_startoff, irec.br_blockcount,
+	return xfs_bmapi_write(NULL, ip, imap->br_startoff, imap->br_blockcount,
 			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT, &first_block,
-			0, &irec, &nimaps, dfops);
+			0, imap, &nimaps, dfops);
 }
 
 /* Convert all of the unwritten CoW extents in a file's range to real ones. */
@@ -372,7 +371,7 @@ xfs_reflink_convert_cow(
 	     found = xfs_iext_get_extent(ifp, ++idx, &got)) {
 		if (got.br_state == XFS_EXT_NORM)
 			continue;
-		error = __xfs_reflink_convert_cow(ip, &got, offset_fsb,
+		error = xfs_reflink_convert_cow_extent(ip, &got, offset_fsb,
 				end_fsb - offset_fsb, &dfops);
 		if (error)
 			break;
-- 
2.11.0

