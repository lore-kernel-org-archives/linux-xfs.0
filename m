Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 133897F5A
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:29:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CBABE304051
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:29:48 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id t7WXUIYfXUzBIud4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:29:47 -0700 (PDT)
Subject: [PATCH 109/119] xfs: don't mix reflink and DAX mode for now
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:29:38 -0700
Message-ID: <146612697833.12839.1404813608223714641.stgit@birch.djwong.org>
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

Since we don't have a strategy for handling both DAX and reflink,
for now we'll just prohibit both being set at the same time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    4 ++++
 fs/xfs/xfs_file.c             |    4 ++++
 fs/xfs/xfs_ioctl.c            |    4 ++++
 fs/xfs/xfs_iops.c             |    1 +
 4 files changed, 13 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index c4cbd2b..3f7053a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -412,6 +412,10 @@ xfs_dinode_verify(
 	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
 		return false;
 
+	/* don't let reflink and dax mix */
+	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags2 & XFS_DIFLAG2_DAX))
+		return false;
+
 	return true;
 }
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ad6a467..e8e93f8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1126,6 +1126,10 @@ xfs_file_share_range(
 	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
 		return -EINVAL;
 
+	/* Don't share DAX file data for now. */
+	if (IS_DAX(inode_in) || IS_DAX(inode_out))
+		return -EINVAL;
+
 	/* Are we going all the way to the end? */
 	isize = i_size_read(inode_in);
 	if (isize == 0)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f103b15..aa9645c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1035,6 +1035,10 @@ xfs_ioctl_setattr_xflags(
 	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
 		return -EINVAL;
 
+	/* Don't allow us to set DAX mode for a reflinked file for now. */
+	if ((fa->fsx_xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))
+		return -EINVAL;
+
 	/*
 	 * Can't modify an immutable/append-only file unless
 	 * we have appropriate permission.
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0fa86bd..95073db 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1217,6 +1217,7 @@ xfs_diflags_to_iflags(
 		inode->i_flags |= S_NOATIME;
 	if (S_ISREG(inode->i_mode) &&
 	    ip->i_mount->m_sb.sb_blocksize == PAGE_SIZE &&
+	    !xfs_is_reflink_inode(ip) &&
 	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
 	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
 		inode->i_flags |= S_DAX;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
