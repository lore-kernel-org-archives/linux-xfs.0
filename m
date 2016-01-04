Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D7D177F3F
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 23:55:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4E1D4AC002
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 21:55:06 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	tUBGl2Gxqcps4pVJ for <xfs@oss.sgi.com>;
	Sun, 03 Jan 2016 21:55:03 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: use FS_XFLAG definitions directly
Date: Mon,  4 Jan 2016 16:54:51 +1100
Message-Id: <1451886892-15548-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1451886892-15548-1-git-send-email-david@fromorbit.com>
References: <1451886892-15548-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, ext4@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that the ioctls have been hoisted up to the VFS level, use
the VFs definitions directly and remove the XFS specific definitions
completely. Userspace is going to have to handle the change of this
interface separately, so removing the definitions from xfs_fs.h is
not an issue here at all.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h |  2 --
 fs/xfs/libxfs/xfs_fs.h     | 19 ------------
 fs/xfs/xfs_inode.c         | 32 ++++++++++----------
 fs/xfs/xfs_ioctl.c         | 74 +++++++++++++++++++++++-----------------------
 4 files changed, 53 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 8774498..f28eeab 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -984,8 +984,6 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 
 /*
  * Values for di_flags
- * There should be a one-to-one correspondence between these flags and the
- * XFS_XFLAG_s.
  */
 #define XFS_DIFLAG_REALTIME_BIT  0	/* file's blocks come from rt area */
 #define XFS_DIFLAG_PREALLOC_BIT  1	/* file space has been preallocated */
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index dd29d0a..fffe3d0 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -36,25 +36,6 @@ struct dioattr {
 #endif
 
 /*
- * Flags for the bs_xflags/fsx_xflags field in FS_IOC_FS[GS]ETXATTR[A]
- */
-#define XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME
-#define XFS_XFLAG_PREALLOC	FS_XFLAG_PREALLOC
-#define XFS_XFLAG_IMMUTABLE	FS_XFLAG_IMMUTABLE
-#define XFS_XFLAG_APPEND	FS_XFLAG_APPEND
-#define XFS_XFLAG_SYNC		FS_XFLAG_SYNC
-#define XFS_XFLAG_NOATIME	FS_XFLAG_NOATIME
-#define XFS_XFLAG_NODUMP	FS_XFLAG_NODUMP
-#define XFS_XFLAG_RTINHERIT	FS_XFLAG_RTINHERIT
-#define XFS_XFLAG_PROJINHERIT	FS_XFLAG_PROJINHERIT
-#define XFS_XFLAG_NOSYMLINKS	FS_XFLAG_NOSYMLINKS
-#define XFS_XFLAG_EXTSIZE	FS_XFLAG_EXTSIZE
-#define XFS_XFLAG_EXTSZINHERIT	FS_XFLAG_EXTSZINHERIT
-#define XFS_XFLAG_NODEFRAG	FS_XFLAG_NODEFRAG
-#define XFS_XFLAG_FILESTREAM	FS_XFLAG_FILESTREAM
-#define XFS_XFLAG_HASATTR	FS_XFLAG_HASATTR
-
-/*
  * Structure for XFS_IOC_GETBMAP.
  * On input, fill in bmv_offset and bmv_length of the first structure
  * to indicate the area of interest in the file, and bmv_entries with
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8ee3939..ca9ca5a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -616,33 +616,33 @@ _xfs_dic2xflags(
 
 	if (di_flags & XFS_DIFLAG_ANY) {
 		if (di_flags & XFS_DIFLAG_REALTIME)
-			flags |= XFS_XFLAG_REALTIME;
+			flags |= FS_XFLAG_REALTIME;
 		if (di_flags & XFS_DIFLAG_PREALLOC)
-			flags |= XFS_XFLAG_PREALLOC;
+			flags |= FS_XFLAG_PREALLOC;
 		if (di_flags & XFS_DIFLAG_IMMUTABLE)
-			flags |= XFS_XFLAG_IMMUTABLE;
+			flags |= FS_XFLAG_IMMUTABLE;
 		if (di_flags & XFS_DIFLAG_APPEND)
-			flags |= XFS_XFLAG_APPEND;
+			flags |= FS_XFLAG_APPEND;
 		if (di_flags & XFS_DIFLAG_SYNC)
-			flags |= XFS_XFLAG_SYNC;
+			flags |= FS_XFLAG_SYNC;
 		if (di_flags & XFS_DIFLAG_NOATIME)
-			flags |= XFS_XFLAG_NOATIME;
+			flags |= FS_XFLAG_NOATIME;
 		if (di_flags & XFS_DIFLAG_NODUMP)
-			flags |= XFS_XFLAG_NODUMP;
+			flags |= FS_XFLAG_NODUMP;
 		if (di_flags & XFS_DIFLAG_RTINHERIT)
-			flags |= XFS_XFLAG_RTINHERIT;
+			flags |= FS_XFLAG_RTINHERIT;
 		if (di_flags & XFS_DIFLAG_PROJINHERIT)
-			flags |= XFS_XFLAG_PROJINHERIT;
+			flags |= FS_XFLAG_PROJINHERIT;
 		if (di_flags & XFS_DIFLAG_NOSYMLINKS)
-			flags |= XFS_XFLAG_NOSYMLINKS;
+			flags |= FS_XFLAG_NOSYMLINKS;
 		if (di_flags & XFS_DIFLAG_EXTSIZE)
-			flags |= XFS_XFLAG_EXTSIZE;
+			flags |= FS_XFLAG_EXTSIZE;
 		if (di_flags & XFS_DIFLAG_EXTSZINHERIT)
-			flags |= XFS_XFLAG_EXTSZINHERIT;
+			flags |= FS_XFLAG_EXTSZINHERIT;
 		if (di_flags & XFS_DIFLAG_NODEFRAG)
-			flags |= XFS_XFLAG_NODEFRAG;
+			flags |= FS_XFLAG_NODEFRAG;
 		if (di_flags & XFS_DIFLAG_FILESTREAM)
-			flags |= XFS_XFLAG_FILESTREAM;
+			flags |= FS_XFLAG_FILESTREAM;
 	}
 
 	return flags;
@@ -655,7 +655,7 @@ xfs_ip2xflags(
 	xfs_icdinode_t		*dic = &ip->i_d;
 
 	return _xfs_dic2xflags(dic->di_flags) |
-				(XFS_IFORK_Q(ip) ? XFS_XFLAG_HASATTR : 0);
+				(XFS_IFORK_Q(ip) ? FS_XFLAG_HASATTR : 0);
 }
 
 uint
@@ -663,7 +663,7 @@ xfs_dic2xflags(
 	xfs_dinode_t		*dip)
 {
 	return _xfs_dic2xflags(be16_to_cpu(dip->di_flags)) |
-				(XFS_DFORK_Q(dip) ? XFS_XFLAG_HASATTR : 0);
+				(XFS_DFORK_Q(dip) ? FS_XFLAG_HASATTR : 0);
 }
 
 /*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d42738d..94b35eb3 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -859,25 +859,25 @@ xfs_merge_ioc_xflags(
 	unsigned int	xflags = start;
 
 	if (flags & FS_IMMUTABLE_FL)
-		xflags |= XFS_XFLAG_IMMUTABLE;
+		xflags |= FS_XFLAG_IMMUTABLE;
 	else
-		xflags &= ~XFS_XFLAG_IMMUTABLE;
+		xflags &= ~FS_XFLAG_IMMUTABLE;
 	if (flags & FS_APPEND_FL)
-		xflags |= XFS_XFLAG_APPEND;
+		xflags |= FS_XFLAG_APPEND;
 	else
-		xflags &= ~XFS_XFLAG_APPEND;
+		xflags &= ~FS_XFLAG_APPEND;
 	if (flags & FS_SYNC_FL)
-		xflags |= XFS_XFLAG_SYNC;
+		xflags |= FS_XFLAG_SYNC;
 	else
-		xflags &= ~XFS_XFLAG_SYNC;
+		xflags &= ~FS_XFLAG_SYNC;
 	if (flags & FS_NOATIME_FL)
-		xflags |= XFS_XFLAG_NOATIME;
+		xflags |= FS_XFLAG_NOATIME;
 	else
-		xflags &= ~XFS_XFLAG_NOATIME;
+		xflags &= ~FS_XFLAG_NOATIME;
 	if (flags & FS_NODUMP_FL)
-		xflags |= XFS_XFLAG_NODUMP;
+		xflags |= FS_XFLAG_NODUMP;
 	else
-		xflags &= ~XFS_XFLAG_NODUMP;
+		xflags &= ~FS_XFLAG_NODUMP;
 
 	return xflags;
 }
@@ -948,33 +948,33 @@ xfs_set_diflags(
 
 	/* can't set PREALLOC this way, just preserve it */
 	di_flags = (ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
-	if (xflags & XFS_XFLAG_IMMUTABLE)
+	if (xflags & FS_XFLAG_IMMUTABLE)
 		di_flags |= XFS_DIFLAG_IMMUTABLE;
-	if (xflags & XFS_XFLAG_APPEND)
+	if (xflags & FS_XFLAG_APPEND)
 		di_flags |= XFS_DIFLAG_APPEND;
-	if (xflags & XFS_XFLAG_SYNC)
+	if (xflags & FS_XFLAG_SYNC)
 		di_flags |= XFS_DIFLAG_SYNC;
-	if (xflags & XFS_XFLAG_NOATIME)
+	if (xflags & FS_XFLAG_NOATIME)
 		di_flags |= XFS_DIFLAG_NOATIME;
-	if (xflags & XFS_XFLAG_NODUMP)
+	if (xflags & FS_XFLAG_NODUMP)
 		di_flags |= XFS_DIFLAG_NODUMP;
-	if (xflags & XFS_XFLAG_NODEFRAG)
+	if (xflags & FS_XFLAG_NODEFRAG)
 		di_flags |= XFS_DIFLAG_NODEFRAG;
-	if (xflags & XFS_XFLAG_FILESTREAM)
+	if (xflags & FS_XFLAG_FILESTREAM)
 		di_flags |= XFS_DIFLAG_FILESTREAM;
 	if (S_ISDIR(ip->i_d.di_mode)) {
-		if (xflags & XFS_XFLAG_RTINHERIT)
+		if (xflags & FS_XFLAG_RTINHERIT)
 			di_flags |= XFS_DIFLAG_RTINHERIT;
-		if (xflags & XFS_XFLAG_NOSYMLINKS)
+		if (xflags & FS_XFLAG_NOSYMLINKS)
 			di_flags |= XFS_DIFLAG_NOSYMLINKS;
-		if (xflags & XFS_XFLAG_EXTSZINHERIT)
+		if (xflags & FS_XFLAG_EXTSZINHERIT)
 			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
-		if (xflags & XFS_XFLAG_PROJINHERIT)
+		if (xflags & FS_XFLAG_PROJINHERIT)
 			di_flags |= XFS_DIFLAG_PROJINHERIT;
 	} else if (S_ISREG(ip->i_d.di_mode)) {
-		if (xflags & XFS_XFLAG_REALTIME)
+		if (xflags & FS_XFLAG_REALTIME)
 			di_flags |= XFS_DIFLAG_REALTIME;
-		if (xflags & XFS_XFLAG_EXTSIZE)
+		if (xflags & FS_XFLAG_EXTSIZE)
 			di_flags |= XFS_DIFLAG_EXTSIZE;
 	}
 
@@ -988,19 +988,19 @@ xfs_diflags_to_linux(
 	struct inode		*inode = VFS_I(ip);
 	unsigned int		xflags = xfs_ip2xflags(ip);
 
-	if (xflags & XFS_XFLAG_IMMUTABLE)
+	if (xflags & FS_XFLAG_IMMUTABLE)
 		inode->i_flags |= S_IMMUTABLE;
 	else
 		inode->i_flags &= ~S_IMMUTABLE;
-	if (xflags & XFS_XFLAG_APPEND)
+	if (xflags & FS_XFLAG_APPEND)
 		inode->i_flags |= S_APPEND;
 	else
 		inode->i_flags &= ~S_APPEND;
-	if (xflags & XFS_XFLAG_SYNC)
+	if (xflags & FS_XFLAG_SYNC)
 		inode->i_flags |= S_SYNC;
 	else
 		inode->i_flags &= ~S_SYNC;
-	if (xflags & XFS_XFLAG_NOATIME)
+	if (xflags & FS_XFLAG_NOATIME)
 		inode->i_flags |= S_NOATIME;
 	else
 		inode->i_flags &= ~S_NOATIME;
@@ -1016,11 +1016,11 @@ xfs_ioctl_setattr_xflags(
 
 	/* Can't change realtime flag if any extents are allocated. */
 	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
-	    XFS_IS_REALTIME_INODE(ip) != (fa->fsx_xflags & XFS_XFLAG_REALTIME))
+	    XFS_IS_REALTIME_INODE(ip) != (fa->fsx_xflags & FS_XFLAG_REALTIME))
 		return -EINVAL;
 
 	/* If realtime flag is set then must have realtime device */
-	if (fa->fsx_xflags & XFS_XFLAG_REALTIME) {
+	if (fa->fsx_xflags & FS_XFLAG_REALTIME) {
 		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
 		    (ip->i_d.di_extsize % mp->m_sb.sb_rextsize))
 			return -EINVAL;
@@ -1031,7 +1031,7 @@ xfs_ioctl_setattr_xflags(
 	 * we have appropriate permission.
 	 */
 	if (((ip->i_d.di_flags & (XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_APPEND)) ||
-	     (fa->fsx_xflags & (XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND))) &&
+	     (fa->fsx_xflags & (FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND))) &&
 	    !capable(CAP_LINUX_IMMUTABLE))
 		return -EPERM;
 
@@ -1095,8 +1095,8 @@ out_cancel:
  * extent size hint validation is somewhat cumbersome. Rules are:
  *
  * 1. extent size hint is only valid for directories and regular files
- * 2. XFS_XFLAG_EXTSIZE is only valid for regular files
- * 3. XFS_XFLAG_EXTSZINHERIT is only valid for directories.
+ * 2. FS_XFLAG_EXTSIZE is only valid for regular files
+ * 3. FS_XFLAG_EXTSZINHERIT is only valid for directories.
  * 4. can only be changed on regular files if no extents are allocated
  * 5. can be changed on directories at any time
  * 6. extsize hint of 0 turns off hints, clears inode flags.
@@ -1112,10 +1112,10 @@ xfs_ioctl_setattr_check_extsize(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
-	if ((fa->fsx_xflags & XFS_XFLAG_EXTSIZE) && !S_ISREG(ip->i_d.di_mode))
+	if ((fa->fsx_xflags & FS_XFLAG_EXTSIZE) && !S_ISREG(ip->i_d.di_mode))
 		return -EINVAL;
 
-	if ((fa->fsx_xflags & XFS_XFLAG_EXTSZINHERIT) &&
+	if ((fa->fsx_xflags & FS_XFLAG_EXTSZINHERIT) &&
 	    !S_ISDIR(ip->i_d.di_mode))
 		return -EINVAL;
 
@@ -1132,7 +1132,7 @@ xfs_ioctl_setattr_check_extsize(
 			return -EINVAL;
 
 		if (XFS_IS_REALTIME_INODE(ip) ||
-		    (fa->fsx_xflags & XFS_XFLAG_REALTIME)) {
+		    (fa->fsx_xflags & FS_XFLAG_REALTIME)) {
 			size = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
 		} else {
 			size = mp->m_sb.sb_blocksize;
@@ -1143,7 +1143,7 @@ xfs_ioctl_setattr_check_extsize(
 		if (fa->fsx_extsize % size)
 			return -EINVAL;
 	} else
-		fa->fsx_xflags &= ~(XFS_XFLAG_EXTSIZE | XFS_XFLAG_EXTSZINHERIT);
+		fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT);
 
 	return 0;
 }
@@ -1168,7 +1168,7 @@ xfs_ioctl_setattr_check_projid(
 
 	if (xfs_get_projid(ip) != fa->fsx_projid)
 		return -EINVAL;
-	if ((fa->fsx_xflags & XFS_XFLAG_PROJINHERIT) !=
+	if ((fa->fsx_xflags & FS_XFLAG_PROJINHERIT) !=
 	    (ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT))
 		return -EINVAL;
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
