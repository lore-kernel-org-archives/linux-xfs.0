Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41073 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751992AbdIQVHg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:36 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 43/47] xfs: disable per-inode DAX flag
Date: Sun, 17 Sep 2017 14:07:08 -0700
Message-Id: <20170917210712.10804-44-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

commit 742d84290739ae908f1b61b7d17ea382c8c0073a upstream.

Currently flag switching can be used to easily crash the kernel.  Disable
the per-inode DAX flag until that is sorted out.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 73cfc7179124..be54216027b6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1005,11 +1005,12 @@ xfs_diflags_to_linux(
 		inode->i_flags |= S_NOATIME;
 	else
 		inode->i_flags &= ~S_NOATIME;
+#if 0	/* disabled until the flag switching races are sorted out */
 	if (xflags & FS_XFLAG_DAX)
 		inode->i_flags |= S_DAX;
 	else
 		inode->i_flags &= ~S_DAX;
-
+#endif
 }
 
 static int
-- 
2.14.1

