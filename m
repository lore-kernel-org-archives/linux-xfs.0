Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56922 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754080AbdJSOV4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:21:56 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/18]  xfs: handle racy AIO in xfs_reflink_end_cow
Date: Thu, 19 Oct 2017 16:21:15 +0200
Message-Id: <20171019142123.18109-11-hch@lst.de>
In-Reply-To: <20171019142123.18109-1-hch@lst.de>
References: <20171019142123.18109-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

commit e12199f85d0ad1b04ce6c425ad93cd847fe930bb upstream.

If we got two AIO writes into a COW area the second one might not have any
COW extents left to convert.  Handle that case gracefully instead of
triggering an assert or accessing beyond the bounds of the extent list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index f45fbf0db9bb..8c8390a7f121 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -735,7 +735,13 @@ xfs_reflink_end_cow(
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
 
@@ -807,6 +813,7 @@ xfs_reflink_end_cow(
 
 out_defer:
 	xfs_defer_cancel(&dfops);
+out_cancel:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out:
-- 
2.14.2

