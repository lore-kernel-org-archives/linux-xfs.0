Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56866 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932563AbdIRJRm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 05:17:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 75/78] xfs: dont set v3 xflags for v2 inodes
Date: Mon, 18 Sep 2017 11:12:24 +0200
Message-Id: <20170918091137.866221071@linuxfoundation.org>
In-Reply-To: <20170918091126.077483037@linuxfoundation.org>
References: <20170918091126.077483037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit dd60687ee541ca3f6df8758f38e6f22f57c42a37 upstream.

Reject attempts to set XFLAGS that correspond to di_flags2 inode flags
if the inode isn't a v3 inode, because di_flags2 only exists on v3.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_ioctl.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -928,16 +928,15 @@ xfs_ioc_fsgetxattr(
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
@@ -967,19 +966,24 @@ xfs_set_diflags(
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
@@ -1020,6 +1024,7 @@ xfs_ioctl_setattr_xflags(
 	struct fsxattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	uint64_t		di_flags2;
 
 	/* Can't change realtime flag if any extents are allocated. */
 	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
@@ -1050,7 +1055,14 @@ xfs_ioctl_setattr_xflags(
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


