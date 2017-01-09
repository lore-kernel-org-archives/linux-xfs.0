Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59506 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938653AbdAIPkL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:40:11 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 22/32] xfs: complain if we don't get nextents bmap records
Date: Mon,  9 Jan 2017 16:38:53 +0100
Message-Id: <1483976343-661-23-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 356a3225222e5bc4df88aef3419fb6424f18ab69 upstream.

When reading into memory all extents of a btree-format inode fork,
complain if the number of extents we find is not the same as the number
of extents reported in the inode core.  This is needed to stop an IO
action from accessing the garbage areas of the in-core fork.

[dchinner: removed redundant assert]

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d4481d4..a2a24fa 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1377,8 +1377,9 @@ xfs_bmap_read_extents(
 			return error;
 		block = XFS_BUF_TO_BLOCK(bp);
 	}
+	if (i != XFS_IFORK_NEXTENTS(ip, whichfork))
+		return -EFSCORRUPTED;
 	ASSERT(i == xfs_iext_count(ifp));
-	ASSERT(i == XFS_IFORK_NEXTENTS(ip, whichfork));
 	XFS_BMAP_TRACE_EXLIST(ip, i, whichfork);
 	return 0;
 error0:
-- 
2.1.4

