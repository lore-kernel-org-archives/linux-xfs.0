Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54272 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbeJATPW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 15:15:22 -0400
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g6xSL-0004JT-P3
        for linux-xfs@vger.kernel.org; Mon, 01 Oct 2018 12:37:45 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/7] xfs: fix fork selection in xfs_find_trim_cow_extent
Date: Mon,  1 Oct 2018 05:37:40 -0700
Message-Id: <20181001123741.32005-7-hch@lst.de>
In-Reply-To: <20181001123741.32005-1-hch@lst.de>
References: <20181001123741.32005-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 1e39a7d21c7e..ead35209ffae 100644
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
2.19.0
