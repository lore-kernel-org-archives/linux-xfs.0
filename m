Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:31168 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965718AbdIYXOa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Sep 2017 19:14:30 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 5/7] xfs: introduce xfs_is_dax_state_changing
Date: Mon, 25 Sep 2017 17:14:02 -0600
Message-Id: <20170925231404.32723-6-ross.zwisler@linux.intel.com>
In-Reply-To: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

Pull this code out of xfs_ioctl_setattr_dax_invalidate() as it will be used
in multiple places soon.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/xfs/xfs_ioctl.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0433aef..386b437 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1020,6 +1020,27 @@ xfs_diflags_to_linux(
 #endif
 }
 
+static bool
+xfs_is_dax_state_changing(
+	unsigned int		xflags,
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	/*
+	 * If the DAX mount option was used we will update the DAX inode flag
+	 * as the user requested but we will continue to use DAX for I/O and
+	 * page faults regardless of how the inode flag is set.
+	 */
+	if (ip->i_mount->m_flags & XFS_MOUNT_DAX)
+		return false;
+	if ((xflags & FS_XFLAG_DAX) && IS_DAX(inode))
+		return false;
+	if (!(xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
+		return false;
+	return true;
+}
+
 static int
 xfs_ioctl_setattr_xflags(
 	struct xfs_trans	*tp,
@@ -1105,17 +1126,8 @@ xfs_ioctl_setattr_dax_invalidate(
 			return -EINVAL;
 	}
 
-	/*
-	 * If the DAX state is not changing, we have nothing to do here.  If
-	 * the DAX mount option was used we will update the DAX inode flag as
-	 * the user requested but we will continue to use DAX for I/O and page
-	 * faults regardless of how the inode flag is set.
-	 */
-	if (ip->i_mount->m_flags & XFS_MOUNT_DAX)
-		return 0;
-	if ((fa->fsx_xflags & FS_XFLAG_DAX) && IS_DAX(inode))
-		return 0;
-	if (!(fa->fsx_xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
+	/* If the DAX state is not changing, we have nothing to do here. */
+	if (!xfs_is_dax_state_changing(fa->fsx_xflags, ip))
 		return 0;
 
 	/* lock, flush and invalidate mapping in preparation for flag change */
-- 
2.9.5

