Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51260 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbeEaWTO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 18:19:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4VMGMCF100966
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 22:19:13 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2janje1345-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 22:19:13 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4VMJCn0011413
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 22:19:13 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4VMJCPO001286
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 22:19:12 GMT
Date: Thu, 31 May 2018 15:19:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: don't forbid setting dax flag on directories if device
 doesn't dax
Message-ID: <20180531221911.GD7825@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

On a directory, the DAX flag is merely a hint that files created in the
directory should have the DAX flag set at creation time.  We don't care
if the underlying device supports DAX or not because directory metadata
are always cached in DRAM.  We don't care if new files get the flag even
if the device doesn't support DAX because we always check for DAX
support before setting the VFS flag (S_DAX).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3d72dfc9c83f..78b2e29ffae3 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1086,12 +1086,14 @@ xfs_ioctl_setattr_dax_invalidate(
 	/*
 	 * It is only valid to set the DAX flag on regular files and
 	 * directories on filesystems where the block size is equal to the page
-	 * size. On directories it serves as an inherit hint.
+	 * size. On directories it serves as an inherited hint so we don't
+	 * have to check the device for dax support or flush pagecache.
 	 */
 	if (fa->fsx_xflags & FS_XFLAG_DAX) {
 		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
 			return -EINVAL;
-		if (!bdev_dax_supported(xfs_find_bdev_for_inode(VFS_I(ip)),
+		if (S_ISREG(inode->i_mode) &&
+		    !bdev_dax_supported(xfs_find_bdev_for_inode(VFS_I(ip)),
 				sb->s_blocksize))
 			return -EINVAL;
 	}
@@ -1102,6 +1104,9 @@ xfs_ioctl_setattr_dax_invalidate(
 	if (!(fa->fsx_xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
 		return 0;
 
+	if (S_ISDIR(inode->i_mode))
+		return 0;
+
 	/* lock, flush and invalidate mapping in preparation for flag change */
 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
 	error = filemap_write_and_wait(inode->i_mapping);
