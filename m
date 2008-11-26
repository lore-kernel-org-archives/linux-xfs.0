Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ3PTXL001971 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 21:25:29 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F84315C75BE
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:25:27 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id hpq74kCz5HfQx1wE for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 19:25:27 -0800 (PST)
Message-Id: <20081126032027.099506160@sandeen.net>
References: <20081126032005.639750968@sandeen.net>
Date: Tue, 25 Nov 2008 21:20:07 -0600
From: sandeen@sandeen.net
Subject: [patch 02/12] Move compat ioctl structs & numbers into xfs_ioctl32.h
Content-Disposition: inline; filename=move_compat_ioctl_structs
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This makes the c file less cluttered and a bit more
readable.   Consistently name the ioctl number
macros with "_32" and the compatibility stuctures
with "_compat."  Rename the helpers which simply
copy in the arg with "_copyin" for easy identification.

Finally, for a few of the existing helpers, modify them
so that they directly call the native ioctl helper
after userspace argument fixup.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 16:32:39.822001133 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:09:29.867064329 -0600
@@ -49,36 +49,12 @@
 #define  _NATIVE_IOC(cmd, type) \
 	  _IOC(_IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd), sizeof(type))
 
-#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
-#define BROKEN_X86_ALIGNMENT
-#define _PACKED __attribute__((packed))
-/* on ia32 l_start is on a 32-bit boundary */
-typedef struct xfs_flock64_32 {
-	__s16		l_type;
-	__s16		l_whence;
-	__s64		l_start	__attribute__((packed));
-			/* len == 0 means until end of file */
-	__s64		l_len __attribute__((packed));
-	__s32		l_sysid;
-	__u32		l_pid;
-	__s32		l_pad[4];	/* reserve area */
-} xfs_flock64_32_t;
-
-#define XFS_IOC_ALLOCSP_32	_IOW ('X', 10, struct xfs_flock64_32)
-#define XFS_IOC_FREESP_32	_IOW ('X', 11, struct xfs_flock64_32)
-#define XFS_IOC_ALLOCSP64_32	_IOW ('X', 36, struct xfs_flock64_32)
-#define XFS_IOC_FREESP64_32	_IOW ('X', 37, struct xfs_flock64_32)
-#define XFS_IOC_RESVSP_32	_IOW ('X', 40, struct xfs_flock64_32)
-#define XFS_IOC_UNRESVSP_32	_IOW ('X', 41, struct xfs_flock64_32)
-#define XFS_IOC_RESVSP64_32	_IOW ('X', 42, struct xfs_flock64_32)
-#define XFS_IOC_UNRESVSP64_32	_IOW ('X', 43, struct xfs_flock64_32)
-
-/* just account for different alignment */
+#ifdef BROKEN_X86_ALIGNMENT
 STATIC unsigned long
 xfs_ioctl32_flock(
 	unsigned long		arg)
 {
-	xfs_flock64_32_t	__user *p32 = (void __user *)arg;
+	compat_xfs_flock64_t	__user *p32 = (void __user *)arg;
 	xfs_flock64_t		__user *p = compat_alloc_user_space(sizeof(*p));
 
 	if (copy_in_user(&p->l_type,	&p32->l_type,	sizeof(s16)) ||
@@ -93,32 +69,6 @@ xfs_ioctl32_flock(
 	return (unsigned long)p;
 }
 
-typedef struct compat_xfs_fsop_geom_v1 {
-	__u32		blocksize;	/* filesystem (data) block size */
-	__u32		rtextsize;	/* realtime extent size		*/
-	__u32		agblocks;	/* fsblocks in an AG		*/
-	__u32		agcount;	/* number of allocation groups	*/
-	__u32		logblocks;	/* fsblocks in the log		*/
-	__u32		sectsize;	/* (data) sector size, bytes	*/
-	__u32		inodesize;	/* inode size in bytes		*/
-	__u32		imaxpct;	/* max allowed inode space(%)	*/
-	__u64		datablocks;	/* fsblocks in data subvolume	*/
-	__u64		rtblocks;	/* fsblocks in realtime subvol	*/
-	__u64		rtextents;	/* rt extents in realtime subvol*/
-	__u64		logstart;	/* starting fsblock of the log	*/
-	unsigned char	uuid[16];	/* unique id of the filesystem	*/
-	__u32		sunit;		/* stripe unit, fsblocks	*/
-	__u32		swidth;		/* stripe width, fsblocks	*/
-	__s32		version;	/* structure version		*/
-	__u32		flags;		/* superblock version flags	*/
-	__u32		logsectsize;	/* log sector size, bytes	*/
-	__u32		rtsectsize;	/* realtime sector size, bytes	*/
-	__u32		dirblocksize;	/* directory block size, bytes	*/
-} __attribute__((packed)) compat_xfs_fsop_geom_v1_t;
-
-#define XFS_IOC_FSGEOMETRY_V1_32  \
-	_IOR ('X', 100, struct compat_xfs_fsop_geom_v1)
-
 STATIC unsigned long xfs_ioctl32_geom_v1(unsigned long arg)
 {
 	compat_xfs_fsop_geom_v1_t __user *p32 = (void __user *)arg;
@@ -129,12 +79,6 @@ STATIC unsigned long xfs_ioctl32_geom_v1
 	return (unsigned long)p;
 }
 
-typedef struct compat_xfs_inogrp {
-	__u64		xi_startino;	/* starting inode number	*/
-	__s32		xi_alloccount;	/* # bits set in allocmask	*/
-	__u64		xi_allocmask;	/* mask of allocated inodes	*/
-} __attribute__((packed)) compat_xfs_inogrp_t;
-
 STATIC int xfs_inumbers_fmt_compat(
 	void __user *ubuffer,
 	const xfs_inogrp_t *buffer,
@@ -155,19 +99,11 @@ STATIC int xfs_inumbers_fmt_compat(
 }
 
 #else
-
 #define xfs_inumbers_fmt_compat xfs_inumbers_fmt
-#define _PACKED
-
 #endif
 
 /* XFS_IOC_FSBULKSTAT and friends */
 
-typedef struct compat_xfs_bstime {
-	__s32		tv_sec;		/* seconds		*/
-	__s32		tv_nsec;	/* and nanoseconds	*/
-} compat_xfs_bstime_t;
-
 STATIC int xfs_bstime_store_compat(
 	compat_xfs_bstime_t __user *p32,
 	const xfs_bstime_t *p)
@@ -181,30 +117,6 @@ STATIC int xfs_bstime_store_compat(
 	return 0;
 }
 
-typedef struct compat_xfs_bstat {
-	__u64		bs_ino;		/* inode number			*/
-	__u16		bs_mode;	/* type and mode		*/
-	__u16		bs_nlink;	/* number of links		*/
-	__u32		bs_uid;		/* user id			*/
-	__u32		bs_gid;		/* group id			*/
-	__u32		bs_rdev;	/* device value			*/
-	__s32		bs_blksize;	/* block size			*/
-	__s64		bs_size;	/* file size			*/
-	compat_xfs_bstime_t bs_atime;	/* access time			*/
-	compat_xfs_bstime_t bs_mtime;	/* modify time			*/
-	compat_xfs_bstime_t bs_ctime;	/* inode change time		*/
-	int64_t		bs_blocks;	/* number of blocks		*/
-	__u32		bs_xflags;	/* extended flags		*/
-	__s32		bs_extsize;	/* extent size			*/
-	__s32		bs_extents;	/* number of extents		*/
-	__u32		bs_gen;		/* generation count		*/
-	__u16		bs_projid;	/* project id			*/
-	unsigned char	bs_pad[14];	/* pad space, unused		*/
-	__u32		bs_dmevmask;	/* DMIG event mask		*/
-	__u16		bs_dmstate;	/* DMIG state info		*/
-	__u16		bs_aextents;	/* attribute number of extents	*/
-} _PACKED compat_xfs_bstat_t;
-
 STATIC int xfs_bulkstat_one_fmt_compat(
 	void			__user *ubuffer,
 	const xfs_bstat_t	*buffer)
@@ -235,22 +147,6 @@ STATIC int xfs_bulkstat_one_fmt_compat(
 	return sizeof(*p32);
 }
 
-
-
-typedef struct compat_xfs_fsop_bulkreq {
-	compat_uptr_t	lastip;		/* last inode # pointer		*/
-	__s32		icount;		/* count of entries in buffer	*/
-	compat_uptr_t	ubuffer;	/* user buffer for inode desc.	*/
-	compat_uptr_t	ocount;		/* output count pointer		*/
-} compat_xfs_fsop_bulkreq_t;
-
-#define XFS_IOC_FSBULKSTAT_32 \
-	_IOWR('X', 101, struct compat_xfs_fsop_bulkreq)
-#define XFS_IOC_FSBULKSTAT_SINGLE_32 \
-	_IOWR('X', 102, struct compat_xfs_fsop_bulkreq)
-#define XFS_IOC_FSINUMBERS_32 \
-	_IOWR('X', 103, struct compat_xfs_fsop_bulkreq)
-
 /* copied from xfs_ioctl.c */
 STATIC int
 xfs_ioc_bulkstat_compat(
@@ -321,29 +217,6 @@ xfs_ioc_bulkstat_compat(
 	return 0;
 }
 
-
-
-typedef struct compat_xfs_fsop_handlereq {
-	__u32		fd;		/* fd for FD_TO_HANDLE		*/
-	compat_uptr_t	path;		/* user pathname		*/
-	__u32		oflags;		/* open flags			*/
-	compat_uptr_t	ihandle;	/* user supplied handle		*/
-	__u32		ihandlen;	/* user supplied length		*/
-	compat_uptr_t	ohandle;	/* user buffer for handle	*/
-	compat_uptr_t	ohandlen;	/* user buffer length		*/
-} compat_xfs_fsop_handlereq_t;
-
-#define XFS_IOC_PATH_TO_FSHANDLE_32 \
-	_IOWR('X', 104, struct compat_xfs_fsop_handlereq)
-#define XFS_IOC_PATH_TO_HANDLE_32 \
-	_IOWR('X', 105, struct compat_xfs_fsop_handlereq)
-#define XFS_IOC_FD_TO_HANDLE_32 \
-	_IOWR('X', 106, struct compat_xfs_fsop_handlereq)
-#define XFS_IOC_OPEN_BY_HANDLE_32 \
-	_IOWR('X', 107, struct compat_xfs_fsop_handlereq)
-#define XFS_IOC_READLINK_BY_HANDLE_32 \
-	_IOWR('X', 108, struct compat_xfs_fsop_handlereq)
-
 STATIC unsigned long xfs_ioctl32_fshandle(unsigned long arg)
 {
 	compat_xfs_fsop_handlereq_t __user *p32 = (void __user *)arg;
@@ -366,7 +239,6 @@ STATIC unsigned long xfs_ioctl32_fshandl
 	return (unsigned long)p;
 }
 
-
 STATIC long
 xfs_compat_ioctl(
 	int		mode,
@@ -405,9 +277,9 @@ xfs_compat_ioctl(
 	case XFS_IOC_ERROR_CLEARALL:
 		break;
 
-	case XFS_IOC32_GETXFLAGS:
-	case XFS_IOC32_SETXFLAGS:
-	case XFS_IOC32_GETVERSION:
+	case XFS_IOC_GETXFLAGS_32:
+	case XFS_IOC_SETXFLAGS_32:
+	case XFS_IOC_GETVERSION_32:
 		cmd = _NATIVE_IOC(cmd, long);
 		break;
 #ifdef BROKEN_X86_ALIGNMENT
@@ -427,7 +299,6 @@ xfs_compat_ioctl(
 		arg = xfs_ioctl32_geom_v1(arg);
 		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_geom_v1);
 		break;
-
 #else /* These are handled fine if no alignment issues */
 	case XFS_IOC_ALLOCSP:
 	case XFS_IOC_FREESP:
@@ -465,7 +336,6 @@ xfs_compat_ioctl(
 
 	error = xfs_ioctl(XFS_I(inode), file, mode, cmd, (void __user *)arg);
 	xfs_iflags_set(XFS_I(inode), XFS_IMODIFIED);
-
 	return error;
 }
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-11-24 16:32:39.822001133 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-11-24 17:09:29.340000915 -0600
@@ -18,7 +18,152 @@
 #ifndef __XFS_IOCTL32_H__
 #define __XFS_IOCTL32_H__
 
+#include <linux/compat.h>
+
 extern long xfs_file_compat_ioctl(struct file *, unsigned, unsigned long);
 extern long xfs_file_compat_invis_ioctl(struct file *, unsigned, unsigned long);
 
+/*
+ * on 32-bit arches, ioctl argument structures may have different sizes
+ * and/or alignment.  We define compat structures which match the
+ * 32-bit sizes/alignments here, and their associated ioctl numbers.
+ *
+ * xfs_ioctl32.c contains routines to copy these structures in and out.
+ */
+
+/* stock kernel-level ioctls we support */
+#define XFS_IOC_GETXFLAGS_32	FS_IOC32_GETFLAGS
+#define XFS_IOC_SETXFLAGS_32	FS_IOC32_SETFLAGS
+#define XFS_IOC_GETVERSION_32	FS_IOC32_GETVERSION
+
+/*
+ * On intel, even if sizes match, alignment and/or padding may differ.
+ */
+#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
+#define BROKEN_X86_ALIGNMENT
+#define __compat_packed __attribute__((packed))
+#else
+#define __compat_packed
+#endif
+
+typedef struct compat_xfs_bstime {
+	compat_time_t	tv_sec;		/* seconds		*/
+	__s32		tv_nsec;	/* and nanoseconds	*/
+} compat_xfs_bstime_t;
+
+typedef struct compat_xfs_bstat {
+	__u64		bs_ino;		/* inode number			*/
+	__u16		bs_mode;	/* type and mode		*/
+	__u16		bs_nlink;	/* number of links		*/
+	__u32		bs_uid;		/* user id			*/
+	__u32		bs_gid;		/* group id			*/
+	__u32		bs_rdev;	/* device value			*/
+	__s32		bs_blksize;	/* block size			*/
+	__s64		bs_size;	/* file size			*/
+	compat_xfs_bstime_t bs_atime;	/* access time			*/
+	compat_xfs_bstime_t bs_mtime;	/* modify time			*/
+	compat_xfs_bstime_t bs_ctime;	/* inode change time		*/
+	int64_t		bs_blocks;	/* number of blocks		*/
+	__u32		bs_xflags;	/* extended flags		*/
+	__s32		bs_extsize;	/* extent size			*/
+	__s32		bs_extents;	/* number of extents		*/
+	__u32		bs_gen;		/* generation count		*/
+	__u16		bs_projid;	/* project id			*/
+	unsigned char	bs_pad[14];	/* pad space, unused		*/
+	__u32		bs_dmevmask;	/* DMIG event mask		*/
+	__u16		bs_dmstate;	/* DMIG state info		*/
+	__u16		bs_aextents;	/* attribute number of extents	*/
+} __compat_packed compat_xfs_bstat_t;
+
+typedef struct compat_xfs_fsop_bulkreq {
+	compat_uptr_t	lastip;		/* last inode # pointer		*/
+	__s32		icount;		/* count of entries in buffer	*/
+	compat_uptr_t	ubuffer;	/* user buffer for inode desc.	*/
+	compat_uptr_t	ocount;		/* output count pointer		*/
+} compat_xfs_fsop_bulkreq_t;
+
+#define XFS_IOC_FSBULKSTAT_32 \
+	_IOWR('X', 101, struct compat_xfs_fsop_bulkreq)
+#define XFS_IOC_FSBULKSTAT_SINGLE_32 \
+	_IOWR('X', 102, struct compat_xfs_fsop_bulkreq)
+#define XFS_IOC_FSINUMBERS_32 \
+	_IOWR('X', 103, struct compat_xfs_fsop_bulkreq)
+
+typedef struct compat_xfs_fsop_handlereq {
+	__u32		fd;		/* fd for FD_TO_HANDLE		*/
+	compat_uptr_t	path;		/* user pathname		*/
+	__u32		oflags;		/* open flags			*/
+	compat_uptr_t	ihandle;	/* user supplied handle		*/
+	__u32		ihandlen;	/* user supplied length		*/
+	compat_uptr_t	ohandle;	/* user buffer for handle	*/
+	compat_uptr_t	ohandlen;	/* user buffer length		*/
+} compat_xfs_fsop_handlereq_t;
+
+#define XFS_IOC_PATH_TO_FSHANDLE_32 \
+	_IOWR('X', 104, struct compat_xfs_fsop_handlereq)
+#define XFS_IOC_PATH_TO_HANDLE_32 \
+	_IOWR('X', 105, struct compat_xfs_fsop_handlereq)
+#define XFS_IOC_FD_TO_HANDLE_32 \
+	_IOWR('X', 106, struct compat_xfs_fsop_handlereq)
+#define XFS_IOC_OPEN_BY_HANDLE_32 \
+	_IOWR('X', 107, struct compat_xfs_fsop_handlereq)
+#define XFS_IOC_READLINK_BY_HANDLE_32 \
+	_IOWR('X', 108, struct compat_xfs_fsop_handlereq)
+
+#ifdef BROKEN_X86_ALIGNMENT
+/* on ia32 l_start is on a 32-bit boundary */
+typedef struct compat_xfs_flock64 {
+	__s16		l_type;
+	__s16		l_whence;
+	__s64		l_start	__attribute__((packed));
+			/* len == 0 means until end of file */
+	__s64		l_len __attribute__((packed));
+	__s32		l_sysid;
+	__u32		l_pid;
+	__s32		l_pad[4];	/* reserve area */
+} compat_xfs_flock64_t;
+
+#define XFS_IOC_ALLOCSP_32	_IOW('X', 10, struct compat_xfs_flock64)
+#define XFS_IOC_FREESP_32	_IOW('X', 11, struct compat_xfs_flock64)
+#define XFS_IOC_ALLOCSP64_32	_IOW('X', 36, struct compat_xfs_flock64)
+#define XFS_IOC_FREESP64_32	_IOW('X', 37, struct compat_xfs_flock64)
+#define XFS_IOC_RESVSP_32	_IOW('X', 40, struct compat_xfs_flock64)
+#define XFS_IOC_UNRESVSP_32	_IOW('X', 41, struct compat_xfs_flock64)
+#define XFS_IOC_RESVSP64_32	_IOW('X', 42, struct compat_xfs_flock64)
+#define XFS_IOC_UNRESVSP64_32	_IOW('X', 43, struct compat_xfs_flock64)
+
+typedef struct compat_xfs_fsop_geom_v1 {
+	__u32		blocksize;	/* filesystem (data) block size */
+	__u32		rtextsize;	/* realtime extent size		*/
+	__u32		agblocks;	/* fsblocks in an AG		*/
+	__u32		agcount;	/* number of allocation groups	*/
+	__u32		logblocks;	/* fsblocks in the log		*/
+	__u32		sectsize;	/* (data) sector size, bytes	*/
+	__u32		inodesize;	/* inode size in bytes		*/
+	__u32		imaxpct;	/* max allowed inode space(%)	*/
+	__u64		datablocks;	/* fsblocks in data subvolume	*/
+	__u64		rtblocks;	/* fsblocks in realtime subvol	*/
+	__u64		rtextents;	/* rt extents in realtime subvol*/
+	__u64		logstart;	/* starting fsblock of the log	*/
+	unsigned char	uuid[16];	/* unique id of the filesystem	*/
+	__u32		sunit;		/* stripe unit, fsblocks	*/
+	__u32		swidth;		/* stripe width, fsblocks	*/
+	__s32		version;	/* structure version		*/
+	__u32		flags;		/* superblock version flags	*/
+	__u32		logsectsize;	/* log sector size, bytes	*/
+	__u32		rtsectsize;	/* realtime sector size, bytes	*/
+	__u32		dirblocksize;	/* directory block size, bytes	*/
+} __attribute__((packed)) compat_xfs_fsop_geom_v1_t;
+
+#define XFS_IOC_FSGEOMETRY_V1_32  \
+	_IOR('X', 100, struct compat_xfs_fsop_geom_v1)
+
+typedef struct compat_xfs_inogrp {
+	__u64		xi_startino;	/* starting inode number	*/
+	__s32		xi_alloccount;	/* # bits set in allocmask	*/
+	__u64		xi_allocmask;	/* mask of allocated inodes	*/
+} __attribute__((packed)) compat_xfs_inogrp_t;
+
+#endif /* BROKEN_X86_ALIGNMENT */
+
 #endif /* __XFS_IOCTL32_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_fs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_fs.h	2008-11-24 16:32:39.823001134 -0600
+++ linux-2.6-xfs/fs/xfs/xfs_fs.h	2008-11-24 16:33:23.934331695 -0600
@@ -426,10 +426,6 @@ typedef struct xfs_handle {
 #define XFS_IOC_GETXFLAGS	FS_IOC_GETFLAGS
 #define XFS_IOC_SETXFLAGS	FS_IOC_SETFLAGS
 #define XFS_IOC_GETVERSION	FS_IOC_GETVERSION
-/* 32-bit compat counterparts */
-#define XFS_IOC32_GETXFLAGS	FS_IOC32_GETFLAGS
-#define XFS_IOC32_SETXFLAGS	FS_IOC32_SETFLAGS
-#define XFS_IOC32_GETVERSION	FS_IOC32_GETVERSION
 
 /*
  * ioctl commands that replace IRIX fcntl()'s

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
