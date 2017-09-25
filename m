Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:31168 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965662AbdIYXO0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Sep 2017 19:14:26 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/7] xfs: validate bdev support for DAX inode flag
Date: Mon, 25 Sep 2017 17:13:59 -0600
Message-Id: <20170925231404.32723-3-ross.zwisler@linux.intel.com>
In-Reply-To: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

Currently only the blocksize is checked, but we should really be calling
bdev_dax_supported() which also tests to make sure we can get a
struct dax_device and that the dax_direct_access() path is working.

This is the same check that we do for the "-o dax" mount option in
xfs_fs_fill_super().

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 26faeb9..0433aef 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1088,6 +1088,7 @@ xfs_ioctl_setattr_dax_invalidate(
 	int			*join_flags)
 {
 	struct inode		*inode = VFS_I(ip);
+	struct super_block	*sb = inode->i_sb;
 	int			error;
 
 	*join_flags = 0;
@@ -1100,7 +1101,7 @@ xfs_ioctl_setattr_dax_invalidate(
 	if (fa->fsx_xflags & FS_XFLAG_DAX) {
 		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
 			return -EINVAL;
-		if (ip->i_mount->m_sb.sb_blocksize != PAGE_SIZE)
+		if (bdev_dax_supported(sb, sb->s_blocksize) < 0)
 			return -EINVAL;
 	}
 
-- 
2.9.5

