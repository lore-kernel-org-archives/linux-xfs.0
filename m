Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ3Q1de002025 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 21:26:01 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD0DA15FE875
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:26:00 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id psWW4AS9wLYenlD4 for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 19:26:00 -0800 (PST)
Message-Id: <20081126032027.433459551@sandeen.net>
References: <20081126032005.639750968@sandeen.net>
Date: Tue, 25 Nov 2008 21:20:08 -0600
From: sandeen@sandeen.net
Subject: [patch 03/12] Clean up some existing compat ioctl calls
Content-Disposition: inline; filename=compat_IOW_call_cleanups
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

Create a new xfs_ioctl.h file which has prototypes for
ioctl helpers that may be called in compat mode.

Change several compat ioctl cases which are IOW to simply copy
in the userspace argument, then call the common ioctl helper.

This also fixes xfs_compat_ioc_fsgeometry_v1(), which had
it backwards before; it copied in an (empty) arg, then copied
out the native result, which probably corrupted userspace.  It
should be translating on the copyout.

Also, a bit of formatting cleanup for consistency, and conversion
of all error returns to use XFS_ERROR().

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-11-24 16:59:35.190001432 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-11-24 17:09:26.128001872 -0600
@@ -68,7 +68,7 @@
  * XFS_IOC_PATH_TO_HANDLE
  *    returns full handle for a path
  */
-STATIC int
+int
 xfs_find_handle(
 	unsigned int		cmd,
 	xfs_fsop_handlereq_t	*hreq)
@@ -245,7 +245,7 @@ xfs_vget_fsop_handlereq(
 	return 0;
 }
 
-STATIC int
+int
 xfs_open_by_handle(
 	xfs_mount_t		*mp,
 	xfs_fsop_handlereq_t	*hreq,
@@ -356,7 +356,7 @@ do_readlink(
 }
 
 
-STATIC int
+int
 xfs_readlink_by_handle(
 	xfs_mount_t		*mp,
 	xfs_fsop_handlereq_t	*hreq,
@@ -652,7 +652,7 @@ xfs_attrmulti_by_handle(
 	return -error;
 }
 
-STATIC int
+int
 xfs_ioc_space(
 	struct xfs_inode	*ip,
 	struct inode		*inode,
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.h	2008-11-24 17:09:26.128001872 -0600
@@ -0,0 +1,47 @@
+/*
+ * Copyright (c) 2008 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_IOCTL_H__
+#define __XFS_IOCTL_H__
+
+extern int
+xfs_ioc_space(
+	struct xfs_inode	*ip,
+	struct inode		*inode,
+	struct file		*filp,
+	int			ioflags,
+	unsigned int		cmd,
+	xfs_flock64_t		*bf);
+
+extern int
+xfs_find_handle(
+	unsigned int		cmd,
+	xfs_fsop_handlereq_t	*hreq);
+
+extern int
+xfs_open_by_handle(
+	xfs_mount_t		*mp,
+	xfs_fsop_handlereq_t	*hreq,
+	struct file		*parfilp,
+	struct inode		*parinode);
+
+extern int
+xfs_readlink_by_handle(
+	xfs_mount_t		*mp,
+	xfs_fsop_handlereq_t	*hreq,
+	struct inode		*parinode);
+#endif
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 16:59:35.191002158 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:09:29.340000915 -0600
@@ -44,55 +44,62 @@
 #include "xfs_error.h"
 #include "xfs_dfrag.h"
 #include "xfs_vnodeops.h"
+#include "xfs_fsops.h"
+#include "xfs_ioctl.h"
 #include "xfs_ioctl32.h"
 
 #define  _NATIVE_IOC(cmd, type) \
 	  _IOC(_IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd), sizeof(type))
 
 #ifdef BROKEN_X86_ALIGNMENT
-STATIC unsigned long
-xfs_ioctl32_flock(
-	unsigned long		arg)
+STATIC int
+xfs_compat_flock64_copyin(
+	xfs_flock64_t		*bf,
+	compat_xfs_flock64_t	__user *arg32)
 {
-	compat_xfs_flock64_t	__user *p32 = (void __user *)arg;
-	xfs_flock64_t		__user *p = compat_alloc_user_space(sizeof(*p));
-
-	if (copy_in_user(&p->l_type,	&p32->l_type,	sizeof(s16)) ||
-	    copy_in_user(&p->l_whence,	&p32->l_whence, sizeof(s16)) ||
-	    copy_in_user(&p->l_start,	&p32->l_start,	sizeof(s64)) ||
-	    copy_in_user(&p->l_len,	&p32->l_len,	sizeof(s64)) ||
-	    copy_in_user(&p->l_sysid,	&p32->l_sysid,	sizeof(s32)) ||
-	    copy_in_user(&p->l_pid,	&p32->l_pid,	sizeof(u32)) ||
-	    copy_in_user(&p->l_pad,	&p32->l_pad,	4*sizeof(u32)))
-		return -EFAULT;
-
-	return (unsigned long)p;
+	if (get_user(bf->l_type,	&arg32->l_type) ||
+	    get_user(bf->l_whence,	&arg32->l_whence) ||
+	    get_user(bf->l_start,	&arg32->l_start) ||
+	    get_user(bf->l_len,		&arg32->l_len) ||
+	    get_user(bf->l_sysid,	&arg32->l_sysid) ||
+	    get_user(bf->l_pid,		&arg32->l_pid) ||
+	    copy_from_user(bf->l_pad,	&arg32->l_pad,	4*sizeof(u32)))
+		return -XFS_ERROR(EFAULT);
+	return 0;
 }
 
-STATIC unsigned long xfs_ioctl32_geom_v1(unsigned long arg)
+STATIC int
+xfs_compat_ioc_fsgeometry_v1(
+	struct xfs_mount	  *mp,
+	compat_xfs_fsop_geom_v1_t __user *arg32)
 {
-	compat_xfs_fsop_geom_v1_t __user *p32 = (void __user *)arg;
-	xfs_fsop_geom_v1_t __user *p = compat_alloc_user_space(sizeof(*p));
+	xfs_fsop_geom_t		  fsgeo;
+	int			  error;
 
-	if (copy_in_user(p, p32, sizeof(*p32)))
-		return -EFAULT;
-	return (unsigned long)p;
+	error = xfs_fs_geometry(mp, &fsgeo, 3);
+	if (error)
+		return -error;
+	/* The 32-bit variant simply has some padding at the end */
+	if (copy_to_user(arg32, &fsgeo, sizeof(struct compat_xfs_fsop_geom_v1)))
+		return -XFS_ERROR(EFAULT);
+	return 0;
 }
 
-STATIC int xfs_inumbers_fmt_compat(
-	void __user *ubuffer,
-	const xfs_inogrp_t *buffer,
-	long count,
-	long *written)
+STATIC int
+xfs_inumbers_fmt_compat(
+	void			__user *ubuffer,
+	const xfs_inogrp_t	*buffer,
+	long			count,
+	long			*written)
 {
-	compat_xfs_inogrp_t __user *p32 = ubuffer;
-	long i;
+	compat_xfs_inogrp_t	__user *p32 = ubuffer;
+	long			i;
 
 	for (i = 0; i < count; i++) {
 		if (put_user(buffer[i].xi_startino,   &p32[i].xi_startino) ||
 		    put_user(buffer[i].xi_alloccount, &p32[i].xi_alloccount) ||
 		    put_user(buffer[i].xi_allocmask,  &p32[i].xi_allocmask))
-			return -EFAULT;
+			return -XFS_ERROR(EFAULT);
 	}
 	*written = count * sizeof(*p32);
 	return 0;
@@ -104,24 +111,26 @@ STATIC int xfs_inumbers_fmt_compat(
 
 /* XFS_IOC_FSBULKSTAT and friends */
 
-STATIC int xfs_bstime_store_compat(
-	compat_xfs_bstime_t __user *p32,
-	const xfs_bstime_t *p)
+STATIC int
+xfs_bstime_store_compat(
+	compat_xfs_bstime_t	__user *p32,
+	const xfs_bstime_t	*p)
 {
-	__s32 sec32;
+	__s32			sec32;
 
 	sec32 = p->tv_sec;
 	if (put_user(sec32, &p32->tv_sec) ||
 	    put_user(p->tv_nsec, &p32->tv_nsec))
-		return -EFAULT;
+		return -XFS_ERROR(EFAULT);
 	return 0;
 }
 
-STATIC int xfs_bulkstat_one_fmt_compat(
+STATIC int
+xfs_bulkstat_one_fmt_compat(
 	void			__user *ubuffer,
 	const xfs_bstat_t	*buffer)
 {
-	compat_xfs_bstat_t __user *p32 = ubuffer;
+	compat_xfs_bstat_t	__user *p32 = ubuffer;
 
 	if (put_user(buffer->bs_ino, &p32->bs_ino) ||
 	    put_user(buffer->bs_mode, &p32->bs_mode) ||
@@ -143,7 +152,7 @@ STATIC int xfs_bulkstat_one_fmt_compat(
 	    put_user(buffer->bs_dmevmask, &p32->bs_dmevmask) ||
 	    put_user(buffer->bs_dmstate, &p32->bs_dmstate) ||
 	    put_user(buffer->bs_aextents, &p32->bs_aextents))
-		return -EFAULT;
+		return -XFS_ERROR(EFAULT);
 	return sizeof(*p32);
 }
 
@@ -166,20 +175,20 @@ xfs_ioc_bulkstat_compat(
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
@@ -217,38 +226,40 @@ xfs_ioc_bulkstat_compat(
 	return 0;
 }
 
-STATIC unsigned long xfs_ioctl32_fshandle(unsigned long arg)
+STATIC int
+xfs_compat_handlereq_copyin(
+	xfs_fsop_handlereq_t		*hreq,
+	compat_xfs_fsop_handlereq_t	__user *arg32)
 {
-	compat_xfs_fsop_handlereq_t __user *p32 = (void __user *)arg;
-	xfs_fsop_handlereq_t __user *p = compat_alloc_user_space(sizeof(*p));
-	u32 addr;
-
-	if (copy_in_user(&p->fd, &p32->fd, sizeof(__u32)) ||
-	    get_user(addr, &p32->path) ||
-	    put_user(compat_ptr(addr), &p->path) ||
-	    copy_in_user(&p->oflags, &p32->oflags, sizeof(__u32)) ||
-	    get_user(addr, &p32->ihandle) ||
-	    put_user(compat_ptr(addr), &p->ihandle) ||
-	    copy_in_user(&p->ihandlen, &p32->ihandlen, sizeof(__u32)) ||
-	    get_user(addr, &p32->ohandle) ||
-	    put_user(compat_ptr(addr), &p->ohandle) ||
-	    get_user(addr, &p32->ohandlen) ||
-	    put_user(compat_ptr(addr), &p->ohandlen))
-		return -EFAULT;
+	compat_xfs_fsop_handlereq_t	hreq32;
+
+	if (copy_from_user(&hreq32, arg32, sizeof(compat_xfs_fsop_handlereq_t)))
+		return -XFS_ERROR(EFAULT);
+
+	hreq->fd = hreq32.fd;
+	hreq->path = compat_ptr(hreq32.path);
+	hreq->oflags = hreq32.oflags;
+	hreq->ihandle = compat_ptr(hreq32.ihandle);
+	hreq->ihandlen = hreq32.ihandlen;
+	hreq->ohandle = compat_ptr(hreq32.ohandle);
+	hreq->ohandlen = compat_ptr(hreq32.ohandlen);
 
-	return (unsigned long)p;
+	return 0;
 }
 
 STATIC long
 xfs_compat_ioctl(
-	int		mode,
-	struct file	*file,
+	xfs_inode_t	*ip,
+	struct file	*filp,
+	int		ioflags,
 	unsigned	cmd,
-	unsigned long	arg)
+	void		__user *arg)
 {
-	struct inode	*inode = file->f_path.dentry->d_inode;
+	struct inode	*inode = filp->f_path.dentry->d_inode;
+	xfs_mount_t	*mp = ip->i_mount;
 	int		error;
 
+	xfs_itrace_entry(XFS_I(inode));
 	switch (cmd) {
 	case XFS_IOC_DIOINFO:
 	case XFS_IOC_FSGEOMETRY:
@@ -291,14 +302,16 @@ xfs_compat_ioctl(
 	case XFS_IOC_RESVSP_32:
 	case XFS_IOC_UNRESVSP_32:
 	case XFS_IOC_RESVSP64_32:
-	case XFS_IOC_UNRESVSP64_32:
-		arg = xfs_ioctl32_flock(arg);
+	case XFS_IOC_UNRESVSP64_32: {
+		struct xfs_flock64	bf;
+
+		if (xfs_compat_flock64_copyin(&bf, arg))
+			return -XFS_ERROR(EFAULT);
 		cmd = _NATIVE_IOC(cmd, struct xfs_flock64);
-		break;
+		return xfs_ioc_space(ip, inode, filp, ioflags, cmd, &bf);
+	}
 	case XFS_IOC_FSGEOMETRY_V1_32:
-		arg = xfs_ioctl32_geom_v1(arg);
-		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_geom_v1);
-		break;
+		return xfs_compat_ioc_fsgeometry_v1(mp, arg);
 #else /* These are handled fine if no alignment issues */
 	case XFS_IOC_ALLOCSP:
 	case XFS_IOC_FREESP:
@@ -324,35 +337,55 @@ xfs_compat_ioctl(
 				cmd, (void __user*)arg);
 	case XFS_IOC_FD_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_HANDLE_32:
-	case XFS_IOC_PATH_TO_FSHANDLE_32:
-	case XFS_IOC_OPEN_BY_HANDLE_32:
-	case XFS_IOC_READLINK_BY_HANDLE_32:
-		arg = xfs_ioctl32_fshandle(arg);
+	case XFS_IOC_PATH_TO_FSHANDLE_32: {
+		struct xfs_fsop_handlereq	hreq;
+
+		if (xfs_compat_handlereq_copyin(&hreq, arg))
+			return -XFS_ERROR(EFAULT);
 		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_handlereq);
-		break;
+		return xfs_find_handle(cmd, &hreq);
+	}
+	case XFS_IOC_OPEN_BY_HANDLE_32: {
+		struct xfs_fsop_handlereq	hreq;
+
+		if (xfs_compat_handlereq_copyin(&hreq, arg))
+			return -XFS_ERROR(EFAULT);
+		return xfs_open_by_handle(mp, &hreq, filp, inode);
+	}
+	case XFS_IOC_READLINK_BY_HANDLE_32: {
+		struct xfs_fsop_handlereq	hreq;
+
+		if (xfs_compat_handlereq_copyin(&hreq, arg))
+			return -XFS_ERROR(EFAULT);
+		return xfs_readlink_by_handle(mp, &hreq, inode);
+	}
 	default:
-		return -ENOIOCTLCMD;
+		return -XFS_ERROR(ENOIOCTLCMD);
 	}
 
-	error = xfs_ioctl(XFS_I(inode), file, mode, cmd, (void __user *)arg);
-	xfs_iflags_set(XFS_I(inode), XFS_IMODIFIED);
+	error = xfs_ioctl(ip, filp, ioflags, cmd, arg);
 	return error;
 }
 
 long
 xfs_file_compat_ioctl(
-	struct file		*file,
-	unsigned		cmd,
-	unsigned long		arg)
+	struct file		*filp,
+	unsigned int		cmd,
+	unsigned long		p)
 {
-	return xfs_compat_ioctl(0, file, cmd, arg);
+	struct inode	*inode = filp->f_path.dentry->d_inode;
+
+	return xfs_compat_ioctl(XFS_I(inode), filp, 0, cmd, (void __user *)p);
 }
 
 long
 xfs_file_compat_invis_ioctl(
-	struct file		*file,
-	unsigned		cmd,
-	unsigned long		arg)
+	struct file		*filp,
+	unsigned int		cmd,
+	unsigned long		p)
 {
-	return xfs_compat_ioctl(IO_INVIS, file, cmd, arg);
+	struct inode	*inode = filp->f_path.dentry->d_inode;
+
+	return xfs_compat_ioctl(XFS_I(inode), filp, IO_INVIS, cmd,
+				(void __user *)p);
 }

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
