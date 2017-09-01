Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52596 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752367AbdIAUuH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 16:50:07 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dnstC-0000zn-E6
        for linux-xfs@vger.kernel.org; Fri, 01 Sep 2017 20:50:06 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: don't set v3 xflags for v2 inodes
Date: Fri,  1 Sep 2017 22:50:02 +0200
Message-Id: <20170901205002.2194-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Reject attempts to set XFLAGS that correspond to di_flags2 inode flags
if the inode isn't a v3 inode, because di_flags2 only exists on v3.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 06ca244c323a..5049e8ab6e30 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -931,16 +931,15 @@ xfs_ioc_fsgetxattr(
 	return 0;
 }
 
-STATIC void
-xfs_set_diflags(
+STATIC uint16_t
+xfs_flags2diflags(
 	struct xfs_inode	*ip,
 	unsigned int		xflags)
 {
-	unsigned int		di_flags;
-	uint64_t		di_flags2;
-
 	/* can't set PREALLOC this way, just preserve it */
-	di_flags = (ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
+	uint16_t		di_flags =
+		(ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
+
 	if (xflags & FS_XFLAG_IMMUTABLE)
 		di_flags |= XFS_DIFLAG_IMMUTABLE;
 	if (xflags & FS_XFLAG_APPEND)
@@ -970,19 +969,24 @@ xfs_set_diflags(
 		if (xflags & FS_XFLAG_EXTSIZE)
 			di_flags |= XFS_DIFLAG_EXTSIZE;
 	}
-	ip->i_d.di_flags = di_flags;
 
-	/* diflags2 only valid for v3 inodes. */
-	if (ip->i_d.di_version < 3)
-		return;
+	return di_flags;
+}
+
+STATIC uint64_t
+xfs_flags2diflags2(
+	struct xfs_inode	*ip,
+	unsigned int		xflags)
+{
+	uint64_t		di_flags2 =
+		(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
 
-	di_flags2 = (ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
 	if (xflags & FS_XFLAG_DAX)
 		di_flags2 |= XFS_DIFLAG2_DAX;
 	if (xflags & FS_XFLAG_COWEXTSIZE)
 		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
 
-	ip->i_d.di_flags2 = di_flags2;
+	return di_flags2;
 }
 
 STATIC void
@@ -1023,6 +1027,7 @@ xfs_ioctl_setattr_xflags(
 	struct fsxattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	uint64_t		di_flags2;
 
 	/* Can't change realtime flag if any extents are allocated. */
 	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
@@ -1053,7 +1058,14 @@ xfs_ioctl_setattr_xflags(
 	    !capable(CAP_LINUX_IMMUTABLE))
 		return -EPERM;
 
-	xfs_set_diflags(ip, fa->fsx_xflags);
+	/* diflags2 only valid for v3 inodes. */
+	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
+	if (di_flags2 && ip->i_d.di_version < 3)
+		return -EINVAL;
+
+	ip->i_d.di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
+	ip->i_d.di_flags2 = di_flags2;
+
 	xfs_diflags_to_linux(ip);
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-- 
2.11.0

