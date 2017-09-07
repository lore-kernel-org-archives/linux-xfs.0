Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58082 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755608AbdIGVIj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Sep 2017 17:08:39 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/2] xfs: validate bdev support for DAX inode flag
Date: Thu,  7 Sep 2017 15:08:32 -0600
Message-Id: <20170907210832.17969-3-ross.zwisler@linux.intel.com>
In-Reply-To: <20170907210832.17969-1-ross.zwisler@linux.intel.com>
References: <20170907210832.17969-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org

Currently only the blocksize is checked, but we should really be calling
bdev_dax_supported() which also tests to make sure we can get a
struct dax_device and that the dax_direct_access() path is working.

This is the same check that we do for the "-o dax" mount option in
xfs_fs_fill_super().

This does not fix the race issues that caused the XFS DAX inode option to
be disabled, so that option will still be disabled.  If/when we re-enable
it, though, I think we will want this issue to have been fixed.  I also do
think that we want to fix this in stable kernels.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
CC: stable@vger.kernel.org
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

