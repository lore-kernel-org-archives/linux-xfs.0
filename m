Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39881 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752057AbdEIJAW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 May 2017 05:00:22 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d810H-0007Lp-GD
        for linux-xfs@vger.kernel.org; Tue, 09 May 2017 09:00:21 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: remove XFS_HSIZE
Date: Tue,  9 May 2017 11:00:18 +0200
Message-Id: <20170509090018.30094-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

XFS_HSIZE is an extremly confusing way to calculate the size of handle_t.
Given that handle_t always only had two sizes, and one of them isn't
even covered by XFS_HSIZE to start with just remove the macro and use
a constant sizeof expression.

Note that XFS_HSIZE isn't used in xfsprogs, xfsdump or xfstests either.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h | 4 ----
 fs/xfs/xfs_ioctl.c     | 3 +--
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 095bdf049a3f..a9aa13e66046 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -446,10 +446,6 @@ typedef struct xfs_handle {
 } xfs_handle_t;
 #define ha_fsid ha_u._ha_fsid
 
-#define XFS_HSIZE(handle)	(((char *) &(handle).ha_fid.fid_pad	 \
-				 - (char *) &(handle))			  \
-				 + (handle).ha_fid.fid_len)
-
 /*
  * Structure passed to XFS_IOC_SWAPEXT
  */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6190697603c9..f6af76975bc8 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -120,8 +120,7 @@ xfs_find_handle(
 		handle.ha_fid.fid_pad = 0;
 		handle.ha_fid.fid_gen = inode->i_generation;
 		handle.ha_fid.fid_ino = ip->i_ino;
-
-		hsize = XFS_HSIZE(handle);
+		hsize = sizeof(xfs_handle_t);
 	}
 
 	error = -EFAULT;
-- 
2.11.0

