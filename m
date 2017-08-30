Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45827 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdH3Qi5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 12:38:57 -0400
Date: Wed, 30 Aug 2017 09:38:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs: don't set v3 xflags for v2 inodes
Message-ID: <20170830163825.GQ4757@magnolia>
References: <20170830155517.GI4757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830155517.GI4757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>

Reject attempts to set XFLAGS that correspond to di_flags2 inode flags
if the inode isn't a v3 inode, because di_flags2 only exists on v3.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |   37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 06ca244..82d14fe 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1016,32 +1016,37 @@ xfs_diflags_to_linux(
 #endif
 }
 
+#define XFS_V3_INODE_XFLAGS	(FS_XFLAG_DAX | \
+				 FS_XFLAG_COWEXTSIZE)
 static int
-xfs_ioctl_setattr_xflags(
-	struct xfs_trans	*tp,
+xfs_check_diflags(
 	struct xfs_inode	*ip,
-	struct fsxattr		*fa)
+	__u32			xflags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
+	/* Can't set flags2 fields on a v2 inode. */
+	if (ip->i_d.di_version < 3 && (xflags & XFS_V3_INODE_XFLAGS))
+		return -EINVAL;
+
 	/* Can't change realtime flag if any extents are allocated. */
 	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
-	    XFS_IS_REALTIME_INODE(ip) != (fa->fsx_xflags & FS_XFLAG_REALTIME))
+	    XFS_IS_REALTIME_INODE(ip) != (xflags & FS_XFLAG_REALTIME))
 		return -EINVAL;
 
 	/* If realtime flag is set then must have realtime device */
-	if (fa->fsx_xflags & FS_XFLAG_REALTIME) {
+	if (xflags & FS_XFLAG_REALTIME) {
 		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
 		    (ip->i_d.di_extsize % mp->m_sb.sb_rextsize))
 			return -EINVAL;
 	}
 
 	/* Clear reflink if we are actually able to set the rt flag. */
-	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
+	if ((xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
 		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
 
 	/* Don't allow us to set DAX mode for a reflinked file for now. */
-	if ((fa->fsx_xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))
+	if ((xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))
 		return -EINVAL;
 
 	/*
@@ -1049,10 +1054,26 @@ xfs_ioctl_setattr_xflags(
 	 * we have appropriate permission.
 	 */
 	if (((ip->i_d.di_flags & (XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_APPEND)) ||
-	     (fa->fsx_xflags & (FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND))) &&
+	     (xflags & (FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND))) &&
 	    !capable(CAP_LINUX_IMMUTABLE))
 		return -EPERM;
 
+	return 0;
+}
+
+static int
+xfs_ioctl_setattr_xflags(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct fsxattr		*fa)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	int			ret;
+
+	ret = xfs_check_diflags(ip, fa->fsx_xflags);
+	if (ret)
+		return ret;
+
 	xfs_set_diflags(ip, fa->fsx_xflags);
 	xfs_diflags_to_linux(ip);
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
