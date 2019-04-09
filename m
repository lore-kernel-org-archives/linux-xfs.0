Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49068 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbfDIDTh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Apr 2019 23:19:37 -0400
Date: Mon, 8 Apr 2019 20:19:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 4/4] xfs: don't allow most setxattr to immutable files
Message-ID: <20190409031929.GE5147@magnolia>
References: <155466882175.633834.15261194784129614735.stgit@magnolia>
 <155466884962.633834.14320700092446721044.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155466884962.633834.14320700092446721044.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, amir73il@gmail.com
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

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
 fs/xfs/xfs_ioctl.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5a1b96dad901..67d12027f563 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1023,6 +1023,40 @@ xfs_ioctl_setattr_flush(
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
+	    !(fa->fsx_xflags & FS_XFLAG_IMMUTABLE))
+		return 0;
+
+	if ((ip->i_d.di_flags & ~XFS_DIFLAG_IMMUTABLE) !=
+	    (di_flags & ~XFS_DIFLAG_IMMUTABLE))
+		return -EPERM;
+	if (ip->i_d.di_version >= 3 && ip->i_d.di_flags2 != di_flags2)
+		return -EPERM;
+	if (xfs_get_projid(ip) != fa->fsx_projid)
+		return -EPERM;
+	if (ip->i_d.di_extsize != fa->fsx_extsize >> mp->m_sb.sb_blocklog)
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
@@ -1030,7 +1064,9 @@ xfs_ioctl_setattr_xflags(
 	struct fsxattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	uint16_t		di_flags;
 	uint64_t		di_flags2;
+	int			error;
 
 	/* Can't change realtime flag if any extents are allocated. */
 	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
@@ -1061,12 +1097,18 @@ xfs_ioctl_setattr_xflags(
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
