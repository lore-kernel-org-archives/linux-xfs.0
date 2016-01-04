Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 29D0E7F37
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 23:55:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 19C88304059
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 21:55:03 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vLKH841x3GCNaIFr for <xfs@oss.sgi.com>;
	Sun, 03 Jan 2016 21:55:01 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR
	promotion
Date: Mon,  4 Jan 2016 16:54:50 +1100
Message-Id: <1451886892-15548-2-git-send-email-david@fromorbit.com>
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

Hoist the ioctl definitions for the XFS_IOC_FS[SG]SETXATTR API from
fs/xfs/libxfs/xfs_fs.h to include/uapi/linux/fs.h so that the ioctls
can be used by all filesystems, not just XFS. This enables
(initially) ext4 to use the ioctl to set project IDs on inodes.

Based-on-patch-from: Li Xi <lixi@ddn.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_fs.h  | 51 +++++++++++++++++--------------------------------
 include/uapi/linux/fs.h | 32 +++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b2b73a9..dd29d0a 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -36,38 +36,23 @@ struct dioattr {
 #endif
 
 /*
- * Structure for XFS_IOC_FSGETXATTR[A] and XFS_IOC_FSSETXATTR.
+ * Flags for the bs_xflags/fsx_xflags field in FS_IOC_FS[GS]ETXATTR[A]
  */
-#ifndef HAVE_FSXATTR
-struct fsxattr {
-	__u32		fsx_xflags;	/* xflags field value (get/set) */
-	__u32		fsx_extsize;	/* extsize field value (get/set)*/
-	__u32		fsx_nextents;	/* nextents field value (get)	*/
-	__u32		fsx_projid;	/* project identifier (get/set) */
-	unsigned char	fsx_pad[12];
-};
-#endif
-
-/*
- * Flags for the bs_xflags/fsx_xflags field
- * There should be a one-to-one correspondence between these flags and the
- * XFS_DIFLAG_s.
- */
-#define XFS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
-#define XFS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
-#define XFS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
-#define XFS_XFLAG_APPEND	0x00000010	/* all writes append */
-#define XFS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
-#define XFS_XFLAG_NOATIME	0x00000040	/* do not update access time */
-#define XFS_XFLAG_NODUMP	0x00000080	/* do not include in backups */
-#define XFS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
-#define XFS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
-#define XFS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
-#define XFS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
-#define XFS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
-#define XFS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
-#define XFS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
-#define XFS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
+#define XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME
+#define XFS_XFLAG_PREALLOC	FS_XFLAG_PREALLOC
+#define XFS_XFLAG_IMMUTABLE	FS_XFLAG_IMMUTABLE
+#define XFS_XFLAG_APPEND	FS_XFLAG_APPEND
+#define XFS_XFLAG_SYNC		FS_XFLAG_SYNC
+#define XFS_XFLAG_NOATIME	FS_XFLAG_NOATIME
+#define XFS_XFLAG_NODUMP	FS_XFLAG_NODUMP
+#define XFS_XFLAG_RTINHERIT	FS_XFLAG_RTINHERIT
+#define XFS_XFLAG_PROJINHERIT	FS_XFLAG_PROJINHERIT
+#define XFS_XFLAG_NOSYMLINKS	FS_XFLAG_NOSYMLINKS
+#define XFS_XFLAG_EXTSIZE	FS_XFLAG_EXTSIZE
+#define XFS_XFLAG_EXTSZINHERIT	FS_XFLAG_EXTSZINHERIT
+#define XFS_XFLAG_NODEFRAG	FS_XFLAG_NODEFRAG
+#define XFS_XFLAG_FILESTREAM	FS_XFLAG_FILESTREAM
+#define XFS_XFLAG_HASATTR	FS_XFLAG_HASATTR
 
 /*
  * Structure for XFS_IOC_GETBMAP.
@@ -514,8 +499,8 @@ typedef struct xfs_swapext
 #define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
 #define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
 #define XFS_IOC_DIOINFO		_IOR ('X', 30, struct dioattr)
-#define XFS_IOC_FSGETXATTR	_IOR ('X', 31, struct fsxattr)
-#define XFS_IOC_FSSETXATTR	_IOW ('X', 32, struct fsxattr)
+#define XFS_IOC_FSGETXATTR	FS_IOC_FSGETXATTR
+#define XFS_IOC_FSSETXATTR	FS_IOC_FSSETXATTR
 #define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
 #define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
 #define XFS_IOC_GETBMAP		_IOWR('X', 38, struct getbmap)
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index f15d980..df175dd 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -110,6 +110,36 @@ struct inodes_stat_t {
 #define MS_MGC_VAL 0xC0ED0000
 #define MS_MGC_MSK 0xffff0000
 
+/*
+ * Structure for FS_IOC_FSGETXATTR[A] and FS_IOC_FSSETXATTR.
+ */
+struct fsxattr {
+	__u32		fsx_xflags;	/* xflags field value (get/set) */
+	__u32		fsx_extsize;	/* extsize field value (get/set)*/
+	__u32		fsx_nextents;	/* nextents field value (get)	*/
+	__u32		fsx_projid;	/* project identifier (get/set) */
+	unsigned char	fsx_pad[12];
+};
+
+/*
+ * Flags for the fsx_xflags field
+ */
+#define FS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
+#define FS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
+#define FS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
+#define FS_XFLAG_APPEND		0x00000010	/* all writes append */
+#define FS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
+#define FS_XFLAG_NOATIME	0x00000040	/* do not update access time */
+#define FS_XFLAG_NODUMP		0x00000080	/* do not include in backups */
+#define FS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
+#define FS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
+#define FS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
+#define FS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
+#define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
+#define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
+#define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
+#define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
+
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
 
@@ -169,6 +199,8 @@ struct inodes_stat_t {
 #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
 #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
 #define FS_IOC32_SETVERSION		_IOW('v', 2, int)
+#define FS_IOC_FSGETXATTR		_IOR ('X', 31, struct fsxattr)
+#define FS_IOC_FSSETXATTR		_IOW ('X', 32, struct fsxattr)
 
 /*
  * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
