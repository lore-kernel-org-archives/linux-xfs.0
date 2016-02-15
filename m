Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE7A57CA3
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 23:22:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9F86E304059
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 21:22:30 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	PRCzqOfsGhUqecgB for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 21:22:28 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: XFS_DIFLAG2_DAX limited by PAGE_SIZE
Date: Mon, 15 Feb 2016 16:22:14 +1100
Message-Id: <1455513734-15192-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1455513734-15192-1-git-send-email-david@fromorbit.com>
References: <1455513734-15192-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: ross.zwisler@linux.intel.com, jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

If the block size of a filesystem is not at least PAGE_SIZEd, then
at this point in time DAX cannot be used due to the fact we can't
guarantee extents are page sized or aligned without further work.
Hence disallow setting the DAX flag on an inode if the block size is
too small. Also, be defensive and check the block size when reading
an inode in off disk.

In future, we want to allow DAX to work on any filesystem, so this
is temporary while we sort of the correct conbination of extent size
hints and allocation alignment configurations needed to guarantee
page sized and aligned extent allocation for DAX enabled files.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 12 ++++++++----
 fs/xfs/xfs_iops.c  |  1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a870d16..8e9cd3c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1080,11 +1080,15 @@ xfs_ioctl_setattr_dax_invalidate(
 
 	/*
 	 * It is only valid to set the DAX flag on regular files and
-	 * directories. On directories it serves as an inherit hint.
+	 * directories on filesystems where the block size is at least the page
+	 * size. On directories it serves as an inherit hint.
 	 */
-	if ((fa->fsx_xflags & FS_XFLAG_DAX) &&
-	    !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
-		return -EINVAL;
+	if (fa->fsx_xflags & FS_XFLAG_DAX) {
+		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
+			return -EINVAL;
+		if (ip->i_mount->m_sb.sb_blocksize != PAGE_SIZE)
+			return -EINVAL;
+	}
 
 	/* If the DAX state is not changing, we have nothing to do here. */
 	if ((fa->fsx_xflags & FS_XFLAG_DAX) && IS_DAX(inode))
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 9c984a0..fb7dc61 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1186,6 +1186,7 @@ xfs_diflags_to_iflags(
 	if (flags & XFS_DIFLAG_NOATIME)
 		inode->i_flags |= S_NOATIME;
 	if (S_ISREG(inode->i_mode) &&
+	    ip->i_mount->m_sb.sb_blocksize == PAGE_SIZE &&
 	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
 	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
 		inode->i_flags |= S_DAX;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
