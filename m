Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50417 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754914AbdJSOXH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:23:07 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/16] xfs: evict CoW fork extents when performing finsert/fcollapse
Date: Thu, 19 Oct 2017 16:22:45 +0200
Message-Id: <20171019142259.20082-3-hch@lst.de>
In-Reply-To: <20171019142259.20082-1-hch@lst.de>
References: <20171019142259.20082-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 3af423b03435c81036fa710623d3ae92fbe346a3 upstream.

When we perform an finsert/fcollapse operation, cancel all the CoW
extents for the affected file offset range so that they don't end up
pointing to the wrong blocks.

Reported-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 5ffefac081f7..5fccf9811e66 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1445,7 +1445,19 @@ xfs_shift_file_space(
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
-- 
2.14.2

