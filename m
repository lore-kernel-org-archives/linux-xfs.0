Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50998 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932115AbdJaOXN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 10:23:13 -0400
Received: from bzq-164-168-31-210.red.bezeqint.net ([31.168.164.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e9XRg-0007fV-SI
        for linux-xfs@vger.kernel.org; Tue, 31 Oct 2017 14:23:13 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/18] xfs: iterate backwards in xfs_reflink_cancel_cow_blocks
Date: Tue, 31 Oct 2017 16:22:25 +0200
Message-Id: <20171031142230.11755-14-hch@lst.de>
In-Reply-To: <20171031142230.11755-1-hch@lst.de>
References: <20171031142230.11755-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This follow the iteration oder for extent deletion in both the regular
reflink I/O completion path and normal block truncation, and makes
implementing the new incore extent list easier.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cadf0ff68003..43bec0def51d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -569,12 +569,20 @@ xfs_reflink_cancel_cow_blocks(
 
 	if (!xfs_is_reflink_inode(ip))
 		return 0;
-	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &ext, &got))
+	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &ext, &got))
 		return 0;
 
-	while (got.br_startoff < end_fsb) {
+	/* Walk backwards until we're out of the I/O range... */
+	while (got.br_startoff + got.br_blockcount > offset_fsb) {
 		del = got;
 		xfs_trim_extent(&del, offset_fsb, end_fsb - offset_fsb);
+
+		/* Extent delete may have bumped ext forward */
+		if (!del.br_blockcount) {
+			xfs_iext_prev(ifp, &ext);
+			goto next_extent;
+		}
+
 		trace_xfs_reflink_cancel_cow(ip, &del);
 
 		if (isnullstartblock(del.br_startblock)) {
@@ -612,8 +620,8 @@ xfs_reflink_cancel_cow_blocks(
 			/* Remove the mapping from the CoW fork. */
 			xfs_bmap_del_extent_cow(ip, &ext, &got, &del);
 		}
-
-		if (!xfs_iext_next_extent(ifp, &ext, &got))
+next_extent:
+		if (!xfs_iext_get_extent(ifp, &ext, &got))
 			break;
 	}
 
-- 
2.14.2

