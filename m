Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47875 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbdBBH45 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 02:56:57 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/19] xfs: sanity check inode di_mode
Date: Thu,  2 Feb 2017 08:56:03 +0100
Message-Id: <1486022171-8076-12-git-send-email-hch@lst.de>
In-Reply-To: <1486022171-8076-1-git-send-email-hch@lst.de>
References: <1486022171-8076-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

From: Amir Goldstein <amir73il@gmail.com>

commit a324cbf10a3c67aaa10c9f47f7b5801562925bc2 upstream.

Check for invalid file type in xfs_dinode_verify()
and fail to load the inode structure from disk.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 977245d..37ee7f0 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -29,6 +29,7 @@
 #include "xfs_icache.h"
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
+#include "xfs_dir2.h"
 
 /*
  * Check that none of the inode's in the buffer have a next
@@ -398,6 +399,8 @@ xfs_dinode_verify(
 		return false;
 
 	mode = be16_to_cpu(dip->di_mode);
+	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
+		return false;
 
 	/* No zero-length symlinks/dirs. */
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && dip->di_size == 0)
-- 
2.1.4

