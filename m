Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33160 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753780AbdIDPuU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Sep 2017 11:50:20 -0400
Date: Mon, 4 Sep 2017 08:49:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/2] xfs: evict CoW fork extents when performing
 finsert/fcollapse
Message-ID: <20170904154941.GB4660@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>

When we perform an finsert/fcollapse operation, cancel all the CoW
extents for the affected file offset range so that they don't end up
pointing to the wrong blocks.

Reported-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index cd9a540..bc6c6e1 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1459,7 +1459,19 @@ xfs_shift_file_space(
 		return error;
 
 	/*
-	 * The extent shiting code works on extent granularity. So, if
+	 * Clean out anything hanging around in the cow fork now that
+	 * we've flushed all the dirty data out to disk to avoid having
+	 * CoW extents at the wrong offsets.
+	 */
+	if (xfs_is_reflink_inode(ip)) {
+		error = xfs_reflink_cancel_cow_range(ip, offset, NULLFILEOFF,
+				true);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * The extent shifting code works on extent granularity. So, if
 	 * stop_fsb is not the starting block of extent, we need to split
 	 * the extent at stop_fsb.
 	 */
