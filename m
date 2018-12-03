Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36482 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbeLCWZO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 17:25:14 -0500
Received: from ip-64-134-180-251.public.wayport.net ([64.134.180.251] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gTweP-000517-PN
        for linux-xfs@vger.kernel.org; Mon, 03 Dec 2018 22:25:13 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/11] xfs: report IOMAP_F_SHARED from xfs_file_iomap_begin_delay
Date: Mon,  3 Dec 2018 17:25:01 -0500
Message-Id: <20181203222503.30649-10-hch@lst.de>
In-Reply-To: <20181203222503.30649-1-hch@lst.de>
References: <20181203222503.30649-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

No user of it in the iomap code at the moment, but we should not
actively report wrong information if we can trivially get it right.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d19f99e5476a..bbc5d2e06b06 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -541,7 +541,7 @@ xfs_file_iomap_begin_delay(
 	struct xfs_bmbt_irec	imap, cmap;
 	struct xfs_iext_cursor	icur, ccur;
 	xfs_fsblock_t		prealloc_blocks = 0;
-	bool			eof = false, cow_eof = false, shared;
+	bool			eof = false, cow_eof = false, shared = false;
 	int			whichfork = XFS_DATA_FORK;
 	int			error = 0;
 
@@ -709,13 +709,14 @@ xfs_file_iomap_begin_delay(
 		if (imap.br_startoff > offset_fsb) {
 			xfs_trim_extent(&cmap, offset_fsb,
 					imap.br_startoff - offset_fsb);
-			error = xfs_bmbt_to_iomap(ip, iomap, &cmap, false);
+			error = xfs_bmbt_to_iomap(ip, iomap, &cmap, true);
 			goto out_unlock;
 		}
 		/* ensure we only report blocks we have a reservation for */
 		xfs_trim_extent(&imap, cmap.br_startoff, cmap.br_blockcount);
+		shared = true;
 	}
-	error = xfs_bmbt_to_iomap(ip, iomap, &imap, false);
+	error = xfs_bmbt_to_iomap(ip, iomap, &imap, shared);
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
-- 
2.19.1
