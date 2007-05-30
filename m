Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 May 2007 07:55:38 -0700 (PDT)
Received: from mail.suse.cz (styx.suse.cz [82.119.242.94])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4UEtTWt018616
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 07:55:30 -0700
Message-Id: <20070530143044.060544510@suse.cz>
References: <20070530125954.706423971@suse.cz>
Date: Wed, 30 May 2007 14:59:57 +0200
From: Michal Marek <mmarek@suse.cz>
Subject: [patch 3/3] Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS in compat mode
Content-Disposition: inline; filename=xfs-compat-ioctl-bulkstat.patch
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

* 32bit struct xfs_fsop_bulkreq has different size and layout of
  members, no matter the alignment. Move the code out of the #else
  branch (why was it there in the first place?). Define _32 variants of
  the ioctl constants.
* 32bit struct xfs_bstat is different on 32bit (because of time_t and on
  i386 becaus of different padding). Create a new function
  xfs_ioctl32_bulkstat_wrap(), which allocates extra ->ubuffer and
  converts the elements to the 32bit format after the original ioctl
  returns. Same for i386 struct xfs_inogrp.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 fs/xfs/linux-2.6/xfs_ioctl32.c |  262 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 238 insertions(+), 24 deletions(-)

--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -109,35 +109,249 @@ STATIC unsigned long xfs_ioctl32_geom_v1
 	return (unsigned long)p;
 }
 
-#else
+typedef struct xfs_inogrp32 {
+	__u64		xi_startino;	/* starting inode number	*/
+	__s32		xi_alloccount;	/* # bits set in allocmask	*/
+	__u64		xi_allocmask;	/* mask of allocated inodes	*/
+} __attribute__((packed)) xfs_inogrp32_t;
+
+STATIC int xfs_inogrp_store_compat(
+	xfs_inogrp32_t __user  *p32,
+	xfs_inogrp_t __user *p)
+{
+#define copy(memb) copy_in_user(&p32->memb, &p->memb, sizeof(p32->memb))
+	if (copy(xi_startino) ||
+	    copy(xi_alloccount) ||
+	    copy(xi_allocmask))
+		return -EFAULT;
+	return 0;
+#undef copy
+}
+
+#endif
+
+/* XFS_IOC_FSBULKSTAT and friends */
+
+typedef struct xfs_bstime32 {
+	__s32		tv_sec;		/* seconds		*/
+	__s32		tv_nsec;	/* and nanoseconds	*/
+} xfs_bstime32_t;
+
+static int xfs_bstime_store_compat(
+	xfs_bstime32_t __user *p32,
+	xfs_bstime_t __user *p)
+{
+	time_t sec;
+	__s32 sec32;
+
+	if (get_user(sec, &p->tv_sec))
+		return -EFAULT;
+	sec32 = sec;
+	if (put_user(sec32, &p32->tv_sec) ||
+	    copy_in_user(&p32->tv_nsec, &p->tv_nsec, sizeof(__s32)))
+		return -EFAULT;
+	return 0;
+}
+
+typedef struct xfs_bstat32 {
+	__u64		bs_ino;		/* inode number			*/
+	__u16		bs_mode;	/* type and mode		*/
+	__u16		bs_nlink;	/* number of links		*/
+	__u32		bs_uid;		/* user id			*/
+	__u32		bs_gid;		/* group id			*/
+	__u32		bs_rdev;	/* device value			*/
+	__s32		bs_blksize;	/* block size			*/
+	__s64		bs_size;	/* file size			*/
+	xfs_bstime32_t	bs_atime;	/* access time			*/
+	xfs_bstime32_t	bs_mtime;	/* modify time			*/
+	xfs_bstime32_t	bs_ctime;	/* inode change time		*/
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
+}
+#ifdef BROKEN_X86_ALIGNMENT
+	__attribute__((packed))
+#endif
+	xfs_bstat32_t;
+
+static int xfs_bstat_store_compat(
+	xfs_bstat32_t __user *p32,
+	xfs_bstat_t __user *p)
+{
+#define copy(memb) copy_in_user(&p32->memb, &p->memb, sizeof(p32->memb))
+	if (copy(bs_ino) ||
+	    copy(bs_mode) ||
+	    copy(bs_nlink) ||
+	    copy(bs_uid) ||
+	    copy(bs_gid) ||
+	    copy(bs_rdev) ||
+	    copy(bs_blksize) ||
+	    copy(bs_size) ||
+	    xfs_bstime_store_compat(&p32->bs_atime, &p->bs_atime) ||
+	    xfs_bstime_store_compat(&p32->bs_mtime, &p->bs_mtime) ||
+	    xfs_bstime_store_compat(&p32->bs_ctime, &p->bs_ctime) ||
+	    copy(bs_blocks) ||
+	    copy(bs_xflags) ||
+	    copy(bs_extsize) ||
+	    copy(bs_extents) ||
+	    copy(bs_gen) ||
+	    copy(bs_projid) ||
+	    copy(bs_pad[14]) ||
+	    copy(bs_dmevmask) ||
+	    copy(bs_dmstate) ||
+	    copy(bs_aextents))
+		return -EFAULT;
+	return 0;
+#undef copy
+}
 
 typedef struct xfs_fsop_bulkreq32 {
 	compat_uptr_t	lastip;		/* last inode # pointer		*/
 	__s32		icount;		/* count of entries in buffer	*/
 	compat_uptr_t	ubuffer;	/* user buffer for inode desc.	*/
-	__s32		ocount;		/* output count pointer		*/
+	compat_uptr_t	ocount;		/* output count pointer		*/
 } xfs_fsop_bulkreq32_t;
-
-STATIC unsigned long
-xfs_ioctl32_bulkstat(
-	unsigned long		arg)
+#define XFS_IOC_FSBULKSTAT_32	     _IOWR('X', 101, struct xfs_fsop_bulkreq32)
+#define XFS_IOC_FSBULKSTAT_SINGLE_32 _IOWR('X', 102, struct xfs_fsop_bulkreq32)
+#define XFS_IOC_FSINUMBERS_32	     _IOWR('X', 103, struct xfs_fsop_bulkreq32)
+
+#define MAX_BSTAT_LEN \
+	((__s32)((64*1024 - sizeof(xfs_fsop_bulkreq_t)) / sizeof(xfs_bstat_t)))
+#define MAX_INOGRP_LEN \
+	((__s32)((64*1024 - sizeof(xfs_fsop_bulkreq_t)) / sizeof(xfs_inogrp_t)))
+
+STATIC int
+xfs_ioctl32_bulkstat_wrap(
+	bhv_vnode_t	*vp,
+	struct inode    *inode,
+	struct file     *file,
+	int             mode,
+	unsigned        cmd,
+	unsigned long   arg)
 {
-	xfs_fsop_bulkreq32_t	__user *p32 = (void __user *)arg;
-	xfs_fsop_bulkreq_t	__user *p = compat_alloc_user_space(sizeof(*p));
-	u32			addr;
-
-	if (get_user(addr, &p32->lastip) ||
-	    put_user(compat_ptr(addr), &p->lastip) ||
-	    copy_in_user(&p->icount, &p32->icount, sizeof(s32)) ||
-	    get_user(addr, &p32->ubuffer) ||
-	    put_user(compat_ptr(addr), &p->ubuffer) ||
-	    get_user(addr, &p32->ocount) ||
-	    put_user(compat_ptr(addr), &p->ocount))
+	xfs_fsop_bulkreq32_t __user *p32 = (void __user *)arg;
+	xfs_fsop_bulkreq_t tmp;
+	u32 addr;
+	void *buf32;
+	int err;
+
+	if (get_user(addr, &p32->lastip))
+		return 0;
+	tmp.lastip = compat_ptr(addr);
+	if (get_user(tmp.icount, &p32->icount) ||
+	    get_user(addr, &p32->ubuffer))
 		return -EFAULT;
+	buf32 = compat_ptr(addr);
+	if (get_user(addr, &p32->ocount))
+		return -EFAULT;
+	tmp.ocount = compat_ptr(addr);
 
-	return (unsigned long)p;
-}
+	if (tmp.icount <= 0)
+		return -EINVAL;
+
+	if (cmd == XFS_IOC_FSBULKSTAT_32)
+		cmd = XFS_IOC_FSBULKSTAT;
+	if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32)
+		cmd = XFS_IOC_FSBULKSTAT_SINGLE;
+	if (cmd == XFS_IOC_FSINUMBERS_32)
+		cmd = XFS_IOC_FSINUMBERS;
+
+	if (cmd == XFS_IOC_FSBULKSTAT || cmd == XFS_IOC_FSBULKSTAT_SINGLE) {
+		xfs_fsop_bulkreq_t __user *p;
+		xfs_bstat_t __user *bs;
+		xfs_bstat32_t __user *bs32 = buf32;
+		__s32 total_ocount = 0;
+		p = compat_alloc_user_space(sizeof(*p) +
+			sizeof(xfs_bstat_t) * min(MAX_BSTAT_LEN, tmp.icount));
+		bs = (xfs_bstat_t __user *)(p + 1);
+		tmp.ubuffer = bs;
+		if (copy_to_user(p, &tmp, sizeof(*p)))
+			return -EFAULT;
+		while (tmp.icount) {
+			__s32 icount = min(MAX_BSTAT_LEN, tmp.icount);
+			__s32 ocount;
+			int i;
+
+			if (put_user(icount, &p->icount))
+				return -EFAULT;
+			err = bhv_vop_ioctl(vp, inode, file, mode, cmd,
+					(void __user *)p);
+			if (err)
+				return err;
+			if (get_user(ocount, p->ocount))
+				return -EFAULT;
+			for (i = 0; i < ocount; i++) {
+				if (xfs_bstat_store_compat(bs32 +
+						total_ocount + i, bs + i))
+					return -EFAULT;
+			}
+			total_ocount += ocount;
+			tmp.icount -= icount;
+		}
+		if (put_user(total_ocount, p->ocount))
+			return -EFAULT;
+		return 0;
+	}
+	if (cmd == XFS_IOC_FSINUMBERS) {
+#ifdef BROKEN_X86_ALIGNMENT
+		xfs_fsop_bulkreq_t __user *p;
+		xfs_inogrp_t __user *ig;
+		xfs_inogrp32_t __user *ig32 = buf32;
+		__s32 total_ocount = 0;
+		p = compat_alloc_user_space(sizeof(*p) +
+			sizeof(xfs_inogrp_t) * min(MAX_INOGRP_LEN, tmp.icount));
+		ig = (xfs_inogrp_t __user *)(p + 1);
+		tmp.ubuffer = ig;
+		if (copy_to_user(p, &tmp, sizeof(*p)))
+			return -EFAULT;
+
+		while (tmp.icount) {
+			__s32 icount = min(MAX_INOGRP_LEN, tmp.icount);
+			__s32 ocount;
+			int i;
+
+			if (put_user(icount, &p->icount))
+				return -EFAULT;
+			err = bhv_vop_ioctl(vp, inode, file, mode, cmd,
+					(void __user *)p);
+			if (err)
+				return err;
+			if (get_user(ocount, p->ocount))
+				return -EFAULT;
+			for (i = 0; i < ocount; i++) {
+				if (xfs_inogrp_store_compat(ig32 +
+						total_ocount + i, ig + i))
+					return -EFAULT;
+			}
+			tmp.icount -= icount;
+			total_ocount += ocount;
+		}
+		if (put_user(total_ocount, p->ocount))
+			return -EFAULT;
+#else
+		xfs_fsop_bulkreq_t __user *p;
+		p = compat_alloc_user_space(sizeof(*p));
+		tmp.ubuffer = buf32;
+		if (copy_to_user(p, &tmp, sizeof(*p)))
+			return -EFAULT;
+
+		err = bhv_vop_ioctl(vp, inode, file, mode, cmd,
+				(void __user *)p);
+		if (err)
+			return err;
 #endif
+		return 0;
+	}
+	return -ENOSYS;
+}
+
 
 typedef struct xfs_fsop_handlereq32 {
 	__u32		fd;		/* fd for FD_TO_HANDLE		*/
@@ -253,12 +467,12 @@ xfs_compat_ioctl(
 	case XFS_IOC_SWAPEXT:
 		break;
 
-	case XFS_IOC_FSBULKSTAT_SINGLE:
-	case XFS_IOC_FSBULKSTAT:
-	case XFS_IOC_FSINUMBERS:
-		arg = xfs_ioctl32_bulkstat(arg);
-		break;
 #endif
+	case XFS_IOC_FSBULKSTAT_32:
+	case XFS_IOC_FSBULKSTAT_SINGLE_32:
+	case XFS_IOC_FSINUMBERS_32:
+		return xfs_ioctl32_bulkstat_wrap(vp, inode, file, mode, cmd,
+				arg);
 	case XFS_IOC_FD_TO_HANDLE_32:
 		arg = xfs_ioctl32_fshandle(arg);
 		cmd = XFS_IOC_FD_TO_HANDLE;

-- 
