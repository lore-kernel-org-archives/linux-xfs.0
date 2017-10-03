Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33537 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdJCOeU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 10:34:20 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dzOH5-00076r-PF
        for linux-xfs@vger.kernel.org; Tue, 03 Oct 2017 14:34:20 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH]  xfs: handle racy AIO in xfs_reflink_end_cow
Date: Tue,  3 Oct 2017 16:34:16 +0200
Message-Id: <20171003143416.12188-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

If we got two AIO writes into a COW area the second one might not have any
COW extents left to convert.  Handle that case gracefully instead of
triggering an assert or accessing beyond the bounds of the extent list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3246815c24d6..37e603bf1591 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -736,7 +736,13 @@ xfs_reflink_end_cow(
 	/* If there is a hole at end_fsb - 1 go to the previous extent */
 	if (!xfs_iext_lookup_extent(ip, ifp, end_fsb - 1, &idx, &got) ||
 	    got.br_startoff > end_fsb) {
-		ASSERT(idx > 0);
+		/*
+		 * In case of racing, overlapping AIO writes no COW extents
+		 * might be left by the time I/O completes for the loser of
+		 * the race.  In that case we are done.
+		 */
+		if (idx <= 0)
+			goto out_cancel;
 		xfs_iext_get_extent(ifp, --idx, &got);
 	}
 
@@ -809,6 +815,7 @@ xfs_reflink_end_cow(
 
 out_defer:
 	xfs_defer_cancel(&dfops);
+out_cancel:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out:
-- 
2.14.1

