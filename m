Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60996 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932533AbeCMOgW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 10:36:22 -0400
Received: from 77.117.139.172.wireless.dyn.drei.com ([77.117.139.172] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1evl2L-0004bn-Bj
        for linux-xfs@vger.kernel.org; Tue, 13 Mar 2018 14:36:21 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/8] xfs: minor cleanup for xfs_get_blocks
Date: Tue, 13 Mar 2018 15:35:58 +0100
Message-Id: <20180313143601.30028-6-hch@lst.de>
In-Reply-To: <20180313143601.30028-1-hch@lst.de>
References: <20180313143601.30028-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Simplify the control flow a bit in preparation for O_ATOMIC-related
changes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index c79a3ca20ef8..19eadc807056 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1335,17 +1335,16 @@ xfs_get_blocks(
 			&nimaps, 0);
 	if (error)
 		goto out_unlock;
-
-	if (nimaps) {
-		trace_xfs_get_blocks_found(ip, offset, size,
-			imap.br_state == XFS_EXT_UNWRITTEN ?
-				XFS_IO_UNWRITTEN : XFS_IO_OVERWRITE, &imap);
-		xfs_iunlock(ip, lockmode);
-	} else {
+	if (!nimaps) {
 		trace_xfs_get_blocks_notfound(ip, offset, size);
 		goto out_unlock;
 	}
 
+	trace_xfs_get_blocks_found(ip, offset, size,
+		imap.br_state == XFS_EXT_UNWRITTEN ?
+			XFS_IO_UNWRITTEN : XFS_IO_OVERWRITE, &imap);
+	xfs_iunlock(ip, lockmode);
+
 	/* trim mapping down to size requested */
 	xfs_map_trim_size(inode, iblock, bh_result, &imap, offset, size);
 
-- 
2.14.2

