Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56276 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756302AbdAIPjN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:39:13 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/32] xfs: check return value of _trans_reserve_quota_nblks
Date: Mon,  9 Jan 2017 16:38:33 +0100
Message-Id: <1483976343-661-3-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 4fd29ec47212c8cbf98916af519019ccc5e58e49 upstream.

Check the return value of xfs_trans_reserve_quota_nblks for errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c6eb219..71dd6d7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4902,8 +4902,11 @@ xfs_bmap_del_extent_delay(
 	 * sb counters as we might have to borrow some blocks for the
 	 * indirect block accounting.
 	 */
-	xfs_trans_reserve_quota_nblks(NULL, ip, -((long)del->br_blockcount), 0,
+	error = xfs_trans_reserve_quota_nblks(NULL, ip,
+			-((long)del->br_blockcount), 0,
 			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		return error;
 	ip->i_delayed_blks -= del->br_blockcount;
 
 	if (whichfork == XFS_COW_FORK)
-- 
2.1.4

