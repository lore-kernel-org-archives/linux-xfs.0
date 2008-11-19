Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAJ5Gbjv031822 for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 23:16:37 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9916A159EFC4
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 21:16:31 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id fQWk53sDB9t3Wovp for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2008 21:16:31 -0800 (PST)
Message-Id: <20081119044907.776640320@sandeen.net>
References: <20081119044401.573365619@sandeen.net>
Date: Tue, 18 Nov 2008 22:44:02 -0600
From: sandeen@sandeen.net
Subject: [patch 01/11] Move compat ioctl structs & numbers into xfs_ioctl32.h
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
Cc: hch@infradead.org

This makes the c file less cluttered and a bit more
readable   Consistently name the ioctl number
macros with "_32" and the compatibility stuctures
with "_compat."  Rename the helpers which simply
copy in the arg with "_copyin" for easy identification.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -49,36 +49,11 @@
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
-xfs_ioctl32_flock(
-	unsigned long		arg)
+xfs_ioctl32_flock_copyin(unsigned long arg)
 {
-	xfs_flock64_32_t	__user *p32 = (void __user *)arg;
+	compat_xfs_flock64_t	__user *p32 = (void __user *)arg;
 	xfs_flock64_t		__user *p = compat_alloc_user_space(sizeof(*p));
 
 	if (copy_in_user(&p->l_type,	&p32->l_type,	sizeof(s16)) ||
@@ -88,54 +63,24 @@ xfs_ioctl32_flock(
 	    copy_in_user(&p->l_sysid,	&p32->l_sysid,	sizeof(s32)) ||
 	    copy_in_user(&p->l_pid,	&p32->l_pid,	sizeof(u32)) ||
 	    copy_in_user(&p->l_pad,	&p32->l_pad,	4*sizeof(u32)))
-		return -EFAULT;
+		return -XFS_ERROR(EFAULT);
 
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
-STATIC unsigned long xfs_ioctl32_geom_v1(unsigned long arg)
+STATIC unsigned long
+xfs_ioctl32_geom_v1_copyin(unsigned long arg)
 {
 	compat_xfs_fsop_geom_v1_t __user *p32 = (void __user *)arg;
 	xfs_fsop_geom_v1_t __user *p = compat_alloc_user_space(sizeof(*p));
 
 	if (copy_in_user(p, p32, sizeof(*p32)))
-		return -EFAULT;
+		return -XFS_ERROR(EFAULT);
 	return (unsigned long)p;
 }
 
-typedef struct compat_xfs_inogrp {
-	__u64		xi_startino;	/* starting inode number	*/
-	__s32		xi_alloccount;	/* # bits set in allocmask	*/
-	__u64		xi_allocmask;	/* mask of allocated inodes	*/
-} __attribute__((packed)) compat_xfs_inogrp_t;
-
-STATIC int xfs_inumbers_fmt_compat(
+STATIC int
+xfs_inumbers_fmt_compat(
 	void __user *ubuffer,
 	const xfs_inogrp_t *buffer,
 	long count,
@@ -148,7 +93,7 @@ STATIC int xfs_inumbers_fmt_compat(
 		if (put_user(buffer[i].xi_startino,   &p32[i].xi_startino) ||
 		    put_user(buffer[i].xi_alloccount, &p32[i].xi_alloccount) ||
 		    put_user(buffer[i].xi_allocmask,  &p32[i].xi_allocmask))
-			return -EFAULT;
+			return -XFS_ERROR(EFAULT);
 	}
 	*written = count * sizeof(*p32);
 	return 0;
@@ -163,49 +108,22 @@ STATIC int xfs_inumbers_fmt_compat(
 
 /* XFS_IOC_FSBULKSTAT and friends */
 
-typedef struct compat_xfs_bstime {
-	__s32		tv_sec;		/* seconds		*/
-	__s32		tv_nsec;	/* and nanoseconds	*/
-} compat_xfs_bstime_t;
-
-STATIC int xfs_bstime_store_compat(
+STATIC int
+xfs_bstime_store_compat(
 	compat_xfs_bstime_t __user *p32,
 	const xfs_bstime_t *p)
 {
-	__s32 sec32;
+	compat_time_t	sec32;
 
 	sec32 = p->tv_sec;
 	if (put_user(sec32, &p32->tv_sec) ||
 	    put_user(p->tv_nsec, &p32->tv_nsec))
-		return -EFAULT;
+		return -XFS_ERROR(EFAULT);
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
-STATIC int xfs_bulkstat_one_fmt_compat(
+STATIC int
+xfs_bulkstat_one_fmt_compat(
 	void			__user *ubuffer,
 	const xfs_bstat_t	*buffer)
 {
@@ -231,26 +149,10 @@ STATIC int xfs_bulkstat_one_fmt_compat(
 	    put_user(buffer->bs_dmevmask, &p32->bs_dmevmask) ||
 	    put_user(buffer->bs_dmstate, &p32->bs_dmstate) ||
 	    put_user(buffer->bs_aextents, &p32->bs_aextents))
-		return -EFAULT;
+		return -XFS_ERROR(EFAULT);
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
@@ -270,20 +172,20 @@ xfs_ioc_bulkstat_compat(
 	/* should be called again (unused here, but used in dmapi) */
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
+		return -XFS_ERROR(EPERM);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -XFS_ERROR(EIO);
 
 	if (get_user(addr, &p32->lastip))
-		return -EFAULT;
+		return -XFS_ERROR(EFAULT);
 	bulkreq.lastip = compat_ptr(addr);
 	if (get_user(bulkreq.icount, &p32->icount) ||
 	    get_user(addr, &p32->ubuffer))
-		return -EFAULT;
+		return -XFS_ERROR(EFAULT);
 	bulkreq.ubuffer = compat_ptr(addr);
 	if (get_user(addr, &p32->ocount))
-		return -EFAULT;
+		return -XFS_ERROR(EFAULT);
 	bulkreq.ocount = compat_ptr(addr);
 
 	if (copy_from_user(&inlast, bulkreq.lastip, sizeof(__s64)))
@@ -310,41 +212,16 @@ xfs_ioc_bulkstat_compat(
 		return -error;
 
 	if (bulkreq.ocount != NULL) {
-		if (copy_to_user(bulkreq.lastip, &inlast,
-						sizeof(xfs_ino_t)))
-			return -XFS_ERROR(EFAULT);
-
-		if (copy_to_user(bulkreq.ocount, &count, sizeof(count)))
+		if (copy_to_user(bulkreq.lastip, &inlast, sizeof(xfs_ino_t)) ||
+		    copy_to_user(bulkreq.ocount, &count, sizeof(count)))
 			return -XFS_ERROR(EFAULT);
 	}
 
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
-STATIC unsigned long xfs_ioctl32_fshandle(unsigned long arg)
+STATIC unsigned long
+xfs_ioctl32_fshandle_copyin(unsigned long arg)
 {
 	compat_xfs_fsop_handlereq_t __user *p32 = (void __user *)arg;
 	xfs_fsop_handlereq_t __user *p = compat_alloc_user_space(sizeof(*p));
@@ -361,12 +238,11 @@ STATIC unsigned long xfs_ioctl32_fshandl
 	    put_user(compat_ptr(addr), &p->ohandle) ||
 	    get_user(addr, &p32->ohandlen) ||
 	    put_user(compat_ptr(addr), &p->ohandlen))
-		return -EFAULT;
+		return -XFS_ERROR(EFAULT);
 
 	return (unsigned long)p;
 }
 
-
 STATIC long
 xfs_compat_ioctl(
 	int		mode,
@@ -405,9 +281,9 @@ xfs_compat_ioctl(
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
@@ -420,11 +296,11 @@ xfs_compat_ioctl(
 	case XFS_IOC_UNRESVSP_32:
 	case XFS_IOC_RESVSP64_32:
 	case XFS_IOC_UNRESVSP64_32:
-		arg = xfs_ioctl32_flock(arg);
+		arg = xfs_ioctl32_flock_copyin(arg);
 		cmd = _NATIVE_IOC(cmd, struct xfs_flock64);
 		break;
 	case XFS_IOC_FSGEOMETRY_V1_32:
-		arg = xfs_ioctl32_geom_v1(arg);
+		arg = xfs_ioctl32_geom_v1_copyin(arg);
 		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_geom_v1);
 		break;
 
@@ -456,11 +332,11 @@ xfs_compat_ioctl(
 	case XFS_IOC_PATH_TO_FSHANDLE_32:
 	case XFS_IOC_OPEN_BY_HANDLE_32:
 	case XFS_IOC_READLINK_BY_HANDLE_32:
-		arg = xfs_ioctl32_fshandle(arg);
+		arg = xfs_ioctl32_fshandle_copyin(arg);
 		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_handlereq);
 		break;
 	default:
-		return -ENOIOCTLCMD;
+		return -XFS_ERROR(ENOIOCTLCMD);
 	}
 
 	error = xfs_ioctl(XFS_I(inode), file, mode, cmd, (void __user *)arg);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.h
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
@@ -18,7 +18,147 @@
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
+/*
+ * On intel, even if sizes match, alignment and/or padding may differ.
+ */
+#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
+#define BROKEN_X86_ALIGNMENT
+#define _PACKED __attribute__((packed))
+#else
+#define _PACKED
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
+} _PACKED compat_xfs_bstat_t;
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
--- linux-2.6-xfs.orig/fs/xfs/xfs_fs.h
+++ linux-2.6-xfs/fs/xfs/xfs_fs.h
@@ -427,9 +427,9 @@ typedef struct xfs_handle {
 #define XFS_IOC_SETXFLAGS	FS_IOC_SETFLAGS
 #define XFS_IOC_GETVERSION	FS_IOC_GETVERSION
 /* 32-bit compat counterparts */
-#define XFS_IOC32_GETXFLAGS	FS_IOC32_GETFLAGS
-#define XFS_IOC32_SETXFLAGS	FS_IOC32_SETFLAGS
-#define XFS_IOC32_GETVERSION	FS_IOC32_GETVERSION
+#define XFS_IOC_GETXFLAGS_32	FS_IOC32_GETFLAGS
+#define XFS_IOC_SETXFLAGS_32	FS_IOC32_SETFLAGS
+#define XFS_IOC_GETVERSION_32	FS_IOC32_GETVERSION
 
 /*
  * ioctl commands that replace IRIX fcntl()'s

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
