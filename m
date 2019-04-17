Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43072 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfDQTFL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 15:05:11 -0400
Subject: [PATCH 6/8] xfs: don't allow most setxattr to immutable files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 17 Apr 2019 12:05:07 -0700
Message-ID: <155552790705.20411.14086909835362619590.stgit@magnolia>
In-Reply-To: <155552786671.20411.6442426840435740050.stgit@magnolia>
References: <155552786671.20411.6442426840435740050.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The chattr manpage has this to say about immutable files:

"A file with the 'i' attribute cannot be modified: it cannot be deleted
or renamed, no link can be created to this file, most of the file's
metadata can not be modified, and the file can not be opened in write
mode."

However, we don't actually check the immutable flag in the setattr code,
which means that we can update project ids and extent size hints on
supposedly immutable files.  Therefore, reject a setattr call on an
immutable file except for the case where we're trying to unset
IMMUTABLE.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |   47 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5862b7cead4c..b5b50006e807 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1038,6 +1038,41 @@ xfs_ioctl_setattr_flush(
 	return filemap_write_and_wait(inode->i_mapping);
 }
 
+/*
+ * If immutable is set and we are not clearing it, we're not allowed to change
+ * anything else in the inode.  Don't error out if we're only trying to set
+ * immutable on an immutable file.
+ */
+static int
+xfs_ioctl_setattr_immutable(
+	struct xfs_inode	*ip,
+	struct fsxattr		*fa,
+	uint16_t		di_flags,
+	uint64_t		di_flags2)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (!(ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE) ||
+	    !(di_flags & XFS_DIFLAG_IMMUTABLE))
+		return 0;
+
+	if ((ip->i_d.di_flags & ~XFS_DIFLAG_IMMUTABLE) !=
+	    (di_flags & ~XFS_DIFLAG_IMMUTABLE))
+		return -EPERM;
+	if (ip->i_d.di_version >= 3 && ip->i_d.di_flags2 != di_flags2)
+		return -EPERM;
+	if (xfs_get_projid(ip) != fa->fsx_projid)
+		return -EPERM;
+	if ((di_flags & (XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT)) &&
+	    ip->i_d.di_extsize != fa->fsx_extsize >> mp->m_sb.sb_blocklog)
+		return -EPERM;
+	if (ip->i_d.di_version >= 3 && (di_flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+	    ip->i_d.di_cowextsize != fa->fsx_cowextsize >> mp->m_sb.sb_blocklog)
+		return -EPERM;
+
+	return 0;
+}
+
 static int
 xfs_ioctl_setattr_xflags(
 	struct xfs_trans	*tp,
@@ -1045,7 +1080,9 @@ xfs_ioctl_setattr_xflags(
 	struct fsxattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	uint16_t		di_flags;
 	uint64_t		di_flags2;
+	int			error;
 
 	/* Can't change realtime flag if any extents are allocated. */
 	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
@@ -1076,12 +1113,18 @@ xfs_ioctl_setattr_xflags(
 	    !capable(CAP_LINUX_IMMUTABLE))
 		return -EPERM;
 
-	/* diflags2 only valid for v3 inodes. */
+	/* Don't allow changes to an immutable inode. */
+	di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
 	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
+	error = xfs_ioctl_setattr_immutable(ip, fa, di_flags, di_flags2);
+	if (error)
+		return error;
+
+	/* diflags2 only valid for v3 inodes. */
 	if (di_flags2 && ip->i_d.di_version < 3)
 		return -EINVAL;
 
-	ip->i_d.di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
+	ip->i_d.di_flags = di_flags;
 	ip->i_d.di_flags2 = di_flags2;
 
 	xfs_diflags_to_linux(ip);
