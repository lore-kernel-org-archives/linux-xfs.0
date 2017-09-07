Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58082 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753640AbdIGVIi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Sep 2017 17:08:38 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/2] xfs: always use DAX if mount option is used
Date: Thu,  7 Sep 2017 15:08:31 -0600
Message-Id: <20170907210832.17969-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20170907210832.17969-1-ross.zwisler@linux.intel.com>
References: <20170907210832.17969-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org

Before support for the per-inode DAX flag was disabled the XFS the code had
an issue where the user couldn't reliably tell whether or not DAX was being
used to service page faults and I/O when the DAX mount option was used.  In
this case each inode within the mounted filesystem started with S_DAX set
due to the mount option, but it could be cleared if someone touched the
individual inode flag.

For example (v4.13 and before):

  # mount | grep dax
  /dev/pmem0 on /mnt type xfs
  (rw,relatime,seclabel,attr2,dax,inode64,sunit=4096,swidth=4096,noquota)

  # touch /mnt/a /mnt/b   # both files currently use DAX

  # xfs_io -c "lsattr" /mnt/*  # neither has the DAX inode option set
  ----------e----- /mnt/a
  ----------e----- /mnt/b

  # xfs_io -c "chattr -x" /mnt/a  # this clears S_DAX for /mnt/a

  # xfs_io -c "lsattr" /mnt/*
  ----------e----- /mnt/a
  ----------e----- /mnt/b

We end up with both /mnt/a and /mnt/b looking identical from the point of
view of the mount option and from lsattr, but one is using DAX and the
other is not.

Fix this by always doing DAX I/O when either the mount option is set or
when the DAX inode flag is set.  This means that DAX will always be used
for all inodes on a filesystem mounted with -o dax, making the usage
reliable and detectable.

This does not fix the race issues that caused the XFS DAX inode option to
be disabled, so that option will still be disabled.  If/when we re-enable
it, though, I think we will want this issue to have been fixed.  I also do
think that we want to fix this in stable kernels.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
CC: stable@vger.kernel.org
---
 fs/xfs/xfs_ioctl.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5049e8a..26faeb9 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1013,7 +1013,7 @@ xfs_diflags_to_linux(
 	else
 		inode->i_flags &= ~S_NOATIME;
 #if 0	/* disabled until the flag switching races are sorted out */
-	if (xflags & FS_XFLAG_DAX)
+	if ((xflags & FS_XFLAG_DAX) || (ip->i_mount->m_flags & XFS_MOUNT_DAX))
 		inode->i_flags |= S_DAX;
 	else
 		inode->i_flags &= ~S_DAX;
@@ -1104,7 +1104,14 @@ xfs_ioctl_setattr_dax_invalidate(
 			return -EINVAL;
 	}
 
-	/* If the DAX state is not changing, we have nothing to do here. */
+	/*
+	 * If the DAX state is not changing, we have nothing to do here.  If
+	 * the DAX mount option was used we will update the DAX inode flag as
+	 * the user requested but we will continue to use DAX for I/O and page
+	 * faults regardless of how the inode flag is set.
+	 */
+	if (ip->i_mount->m_flags & XFS_MOUNT_DAX)
+		return 0;
 	if ((fa->fsx_xflags & FS_XFLAG_DAX) && IS_DAX(inode))
 		return 0;
 	if (!(fa->fsx_xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
-- 
2.9.5

