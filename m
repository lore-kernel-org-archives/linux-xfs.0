Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47998 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbeFCXWb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 19:22:31 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w53NMUqV052510
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:22:30 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2jbvynsfgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Jun 2018 23:22:30 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w53NMUiH029704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:22:30 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w53NMTSA016544
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:22:30 GMT
Subject: [PATCH 01/10] xfs: don't forbid setting dax flag on directories if
 device doesn't dax
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 03 Jun 2018 16:22:28 -0700
Message-ID: <152806814871.18187.4240645095990301961.stgit@magnolia>
In-Reply-To: <152806814253.18187.4009340462930782844.stgit@magnolia>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

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
index 5dd9e22b4a4c..82f7c83c1dad 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1098,12 +1098,14 @@ xfs_ioctl_setattr_dax_invalidate(
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
@@ -1114,6 +1116,9 @@ xfs_ioctl_setattr_dax_invalidate(
 	if (!(fa->fsx_xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
 		return 0;
 
+	if (S_ISDIR(inode->i_mode))
+		return 0;
+
 	/* lock, flush and invalidate mapping in preparation for flag change */
 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
 	error = filemap_write_and_wait(inode->i_mapping);

