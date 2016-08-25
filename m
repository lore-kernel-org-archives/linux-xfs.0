Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92C4D7D17
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:39:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE54BAC003
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:39:06 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id gDp3Nv3VGloxr509 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:39:05 -0700 (PDT)
Subject: [PATCH 65/71] xfs: check for invalid inode reflink flags
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:38:57 -0700
Message-ID: <147216833770.867.15426310797031939448.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

We don't support sharing blocks on the realtime device.  Flag inodes
with the reflink or cowextsize flags set when the reflink feature is
disabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   16 ++++++++++++++++
 fs/xfs/xfs_ioctl.c            |    4 ++++
 2 files changed, 20 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 2efa42c..9778891 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -386,6 +386,9 @@ xfs_dinode_verify(
 	xfs_ino_t		ino,
 	struct xfs_dinode	*dip)
 {
+	uint16_t		flags;
+	uint64_t		flags2;
+
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return false;
 
@@ -402,6 +405,19 @@ xfs_dinode_verify(
 		return false;
 	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_meta_uuid))
 		return false;
+
+	flags = be16_to_cpu(dip->di_flags);
+	flags2 = be64_to_cpu(dip->di_flags2);
+
+	/* don't allow reflink/cowextsize if we don't have reflink */
+	if ((flags2 & (XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)) &&
+            !xfs_sb_version_hasreflink(&mp->m_sb))
+		return false;
+
+	/* don't let reflink and realtime mix */
+	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
+		return false;
+
 	return true;
 }
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4d4531ee..c99c7bb 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1035,6 +1035,10 @@ xfs_ioctl_setattr_xflags(
 			return -EINVAL;
 	}
 
+	/* Don't allow us to set realtime mode for a reflinked file. */
+	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
+		return -EINVAL;
+
 	/*
 	 * Can't modify an immutable/append-only file unless
 	 * we have appropriate permission.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
