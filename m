Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36146 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730984AbeITU0V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 16:26:21 -0400
Received: from 089144198037.atnat0007.highway.a1.net ([89.144.198.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g30A4-0006g7-A0
        for linux-xfs@vger.kernel.org; Thu, 20 Sep 2018 14:42:32 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/5] xfs: fix fork selection in xfs_find_trim_cow_extent
Date: Thu, 20 Sep 2018 16:42:18 +0200
Message-Id: <20180920144220.2181-4-hch@lst.de>
In-Reply-To: <20180920144220.2181-1-hch@lst.de>
References: <20180920144220.2181-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We should want to write directly into the data fork for blocks that don't
have an extent in the COW fork covering them yet.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d1758771f21a..b25ea7a3a0e7 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -369,9 +369,13 @@ xfs_find_trim_cow_extent(
 	 * If we don't find an overlapping extent, trim the range we need to
 	 * allocate to fit the hole we found.
 	 */
-	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got) ||
-	    got.br_startoff > offset_fsb)
+	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got))
+		got.br_startoff = offset_fsb + count_fsb;
+	if (got.br_startoff > offset_fsb) {
+		xfs_trim_extent(imap, imap->br_startoff,
+				got.br_startoff - imap->br_startoff);
 		return xfs_reflink_trim_around_shared(ip, imap, shared);
+	}
 
 	*shared = true;
 	if (isnullstartblock(got.br_startblock)) {
-- 
2.18.0
