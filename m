Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6D4ED7F9F
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:29:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 278F7304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:29:39 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3ljWjPSTGT50eA1z (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:29:37 -0700 (PDT)
Subject: [PATCH 108/119] xfs: don't allow realtime and reflinked files to mix
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:29:32 -0700
Message-ID: <146612697207.12839.14767562689881261858.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

We don't support sharing blocks on the realtime device.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   10 ++++++++++
 fs/xfs/xfs_ioctl.c            |    4 ++++
 2 files changed, 14 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 2efa42c..c4cbd2b 100644
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
 
@@ -402,6 +405,13 @@ xfs_dinode_verify(
 		return false;
 	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_meta_uuid))
 		return false;
+
+	/* don't let reflink and realtime mix */
+	flags = be16_to_cpu(dip->di_flags);
+	flags2 = be64_to_cpu(dip->di_flags2);
+	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
+		return false;
+
 	return true;
 }
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d2b4e81..f103b15 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1031,6 +1031,10 @@ xfs_ioctl_setattr_xflags(
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
