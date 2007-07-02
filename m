Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Jul 2007 08:05:13 -0700 (PDT)
Received: from mail.suse.cz (styx.suse.cz [82.119.242.94])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l62F58tL029032
	for <xfs@oss.sgi.com>; Mon, 2 Jul 2007 08:05:09 -0700
Date: Mon, 2 Jul 2007 17:05:09 +0200
From: Michal Marek <mmarek@suse.cz>
Subject: Re: [patch 3/3] Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and
	XFS_IOC_FSINUMBERS in compat mode (try3)
Message-ID: <20070702150509.GA32192@discovery.suse.cz>
References: <20070619132549.266927601@suse.cz> <20070619132726.893544847@suse.cz> <20070628034957.GE989688@sgi.com> <4688C812.9020200@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4688C812.9020200@suse.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 11:40:34AM +0200, Michal Marek wrote:
> David Chinner wrote:
> > I think we can remove xfs_bulkstat_one_compat() completely by using
> > the same method you used with the xfs_inumber_fmt functions.
> 
> You mean xfs_ioc_bulkstat_compat() -> native xfs_bulkstat() -> native
> xfs_bulkstat_one() -> a compat output formatter, so a
> pointer-to-function passed to pointer-to-function? ;) I could (ab)use
> the void *private_data arg which xfs_bulkstat passes unmodified to the
> formatter; xfs_bulkstat_one() doesn't make use of it atm. I'll try it
> and post the result in a while.

Hi David, what about this one? It about 30 lines shorter now :)


Subject: Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS in compat mode

* 32bit struct xfs_fsop_bulkreq has different size and layout of
  members, no matter the alignment. Move the code out of the #else
  branch (why was it there in the first place?). Define _32 variants of
  the ioctl constants.
* 32bit struct xfs_bstat is different because of time_t and on
  i386 because of different padding. Make xfs_bulkstat_one() accept a
  custom "output formater" in the private_data argument which takes care
  of the xfs_bulkstat_one_compat() that takes care of the different
  layout in the compat case.
* i386 struct xfs_inogrp has different padding. Add a similar "output
  formater" mecanism to xfs_inumbers().

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 fs/xfs/linux-2.6/xfs_ioctl.c   |    2 
 fs/xfs/linux-2.6/xfs_ioctl32.c |  221 ++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_itable.c            |   41 ++++++-
 fs/xfs/xfs_itable.h            |   20 +++
 4 files changed, 252 insertions(+), 32 deletions(-)

--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -28,12 +28,27 @@
 #include "xfs_vfs.h"
 #include "xfs_vnode.h"
 #include "xfs_dfrag.h"
+#include "xfs_sb.h"
+#include "xfs_log.h"
+#include "xfs_trans.h"
+#include "xfs_dmapi.h"
+#include "xfs_mount.h"
+#include "xfs_inum.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_sf.h"
+#include "xfs_attr_sf.h"
+#include "xfs_dinode.h"
+#include "xfs_itable.h"
+#include "xfs_error.h"
+#include "xfs_inode.h"
 
 #define  _NATIVE_IOC(cmd, type) \
 	  _IOC(_IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd), sizeof(type))
 
 #if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
 #define BROKEN_X86_ALIGNMENT
+#define _PACKED __attribute__((packed))
 /* on ia32 l_start is on a 32-bit boundary */
 typedef struct xfs_flock64_32 {
 	__s16		l_type;
@@ -111,35 +126,196 @@ STATIC unsigned long xfs_ioctl32_geom_v1
 	return (unsigned long)p;
 }
 
+typedef struct compat_xfs_inogrp {
+	__u64		xi_startino;	/* starting inode number	*/
+	__s32		xi_alloccount;	/* # bits set in allocmask	*/
+	__u64		xi_allocmask;	/* mask of allocated inodes	*/
+} __attribute__((packed)) compat_xfs_inogrp_t;
+
+STATIC int xfs_inumbers_fmt_compat(
+	void __user *ubuffer,
+	const xfs_inogrp_t *buffer,
+	long count,
+	long *written)
+{
+	compat_xfs_inogrp_t *p32 = ubuffer;
+	long i;
+
+	for (i = 0; i < count; i++) {
+		if (put_user(buffer[i].xi_startino,   &p32[i].xi_startino) ||
+		    put_user(buffer[i].xi_alloccount, &p32[i].xi_alloccount) ||
+		    put_user(buffer[i].xi_allocmask,  &p32[i].xi_allocmask))
+			return -EFAULT;
+	}
+	*written = count * sizeof(*p32);
+	return 0;
+}
+
 #else
 
-typedef struct xfs_fsop_bulkreq32 {
+#define xfs_inumbers_fmt_compat xfs_inumbers_fmt
+#define _PACKED
+
+#endif
+
+/* XFS_IOC_FSBULKSTAT and friends */
+
+typedef struct compat_xfs_bstime {
+	__s32		tv_sec;		/* seconds		*/
+	__s32		tv_nsec;	/* and nanoseconds	*/
+} compat_xfs_bstime_t;
+
+STATIC int xfs_bstime_store_compat(
+	compat_xfs_bstime_t __user *p32,
+	const xfs_bstime_t *p)
+{
+	__s32 sec32;
+
+	sec32 = p->tv_sec;
+	if (put_user(sec32, &p32->tv_sec) ||
+	    put_user(p->tv_nsec, &p32->tv_nsec))
+		return -EFAULT;
+	return 0;
+}
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
+STATIC int xfs_bulkstat_one_fmt_compat(
+	void			__user *ubuffer,
+	const xfs_bstat_t	*buffer)
+{
+	compat_xfs_bstat_t __user *p32 = ubuffer;
+
+	if (put_user(buffer->bs_ino, &p32->bs_ino) ||
+	    put_user(buffer->bs_mode, &p32->bs_mode) ||
+	    put_user(buffer->bs_nlink, &p32->bs_nlink) ||
+	    put_user(buffer->bs_uid, &p32->bs_uid) ||
+	    put_user(buffer->bs_gid, &p32->bs_gid) ||
+	    put_user(buffer->bs_rdev, &p32->bs_rdev) ||
+	    put_user(buffer->bs_blksize, &p32->bs_blksize) ||
+	    put_user(buffer->bs_size, &p32->bs_size) ||
+	    xfs_bstime_store_compat(&p32->bs_atime, &buffer->bs_atime) ||
+	    xfs_bstime_store_compat(&p32->bs_mtime, &buffer->bs_mtime) ||
+	    xfs_bstime_store_compat(&p32->bs_ctime, &buffer->bs_ctime) ||
+	    put_user(buffer->bs_blocks, &p32->bs_blocks) ||
+	    put_user(buffer->bs_xflags, &p32->bs_xflags) ||
+	    put_user(buffer->bs_extsize, &p32->bs_extsize) ||
+	    put_user(buffer->bs_extents, &p32->bs_extents) ||
+	    put_user(buffer->bs_gen, &p32->bs_gen) ||
+	    put_user(buffer->bs_projid, &p32->bs_projid) ||
+	    put_user(buffer->bs_dmevmask, &p32->bs_dmevmask) ||
+	    put_user(buffer->bs_dmstate, &p32->bs_dmstate) ||
+	    put_user(buffer->bs_aextents, &p32->bs_aextents))
+		return -EFAULT;
+	return sizeof(*p32);
+}
+
+
+
+typedef struct compat_xfs_fsop_bulkreq {
 	compat_uptr_t	lastip;		/* last inode # pointer		*/
 	__s32		icount;		/* count of entries in buffer	*/
 	compat_uptr_t	ubuffer;	/* user buffer for inode desc.	*/
-	__s32		ocount;		/* output count pointer		*/
-} xfs_fsop_bulkreq32_t;
+	compat_uptr_t	ocount;		/* output count pointer		*/
+} compat_xfs_fsop_bulkreq_t;
 
-STATIC unsigned long
-xfs_ioctl32_bulkstat(
-	unsigned long		arg)
+#define XFS_IOC_FSBULKSTAT_32 \
+	_IOWR('X', 101, struct compat_xfs_fsop_bulkreq)
+#define XFS_IOC_FSBULKSTAT_SINGLE_32 \
+	_IOWR('X', 102, struct compat_xfs_fsop_bulkreq)
+#define XFS_IOC_FSINUMBERS_32 \
+	_IOWR('X', 103, struct compat_xfs_fsop_bulkreq)
+
+/* copied from xfs_ioctl.c */
+STATIC int
+xfs_ioc_bulkstat_compat(
+	xfs_mount_t		*mp,
+	unsigned int		cmd,
+	void			__user *arg)
 {
-	xfs_fsop_bulkreq32_t	__user *p32 = (void __user *)arg;
-	xfs_fsop_bulkreq_t	__user *p = compat_alloc_user_space(sizeof(*p));
+	compat_xfs_fsop_bulkreq_t __user *p32 = (void __user *)arg;
 	u32			addr;
+	xfs_fsop_bulkreq_t	bulkreq;
+	int			count;	/* # of records returned */
+	xfs_ino_t		inlast;	/* last inode number */
+	int			done;
+	int			error;
+
+	/* done = 1 if there are more stats to get and if bulkstat */
+	/* should be called again (unused here, but used in dmapi) */
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -XFS_ERROR(EIO);
 
-	if (get_user(addr, &p32->lastip) ||
-	    put_user(compat_ptr(addr), &p->lastip) ||
-	    copy_in_user(&p->icount, &p32->icount, sizeof(s32)) ||
-	    get_user(addr, &p32->ubuffer) ||
-	    put_user(compat_ptr(addr), &p->ubuffer) ||
-	    get_user(addr, &p32->ocount) ||
-	    put_user(compat_ptr(addr), &p->ocount))
+	if (get_user(addr, &p32->lastip))
 		return -EFAULT;
+	bulkreq.lastip = compat_ptr(addr);
+	if (get_user(bulkreq.icount, &p32->icount) ||
+	    get_user(addr, &p32->ubuffer))
+		return -EFAULT;
+	bulkreq.ubuffer = compat_ptr(addr);
+	if (get_user(addr, &p32->ocount))
+		return -EFAULT;
+	bulkreq.ocount = compat_ptr(addr);
 
-	return (unsigned long)p;
+	if (copy_from_user(&inlast, bulkreq.lastip, sizeof(__s64)))
+		return -XFS_ERROR(EFAULT);
+
+	if ((count = bulkreq.icount) <= 0)
+		return -XFS_ERROR(EINVAL);
+
+	if (cmd == XFS_IOC_FSINUMBERS)
+		error = xfs_inumbers(mp, &inlast, &count,
+				bulkreq.ubuffer, xfs_inumbers_fmt_compat);
+	else {
+		/* declare a var to get a warning in case the type changes */
+		bulkstat_one_fmt_pf formatter = xfs_bulkstat_one_fmt_compat;
+		error = xfs_bulkstat(mp, &inlast, &count,
+			xfs_bulkstat_one, formatter,
+			sizeof(compat_xfs_bstat_t), bulkreq.ubuffer,
+			BULKSTAT_FG_QUICK, &done);
+	}
+	if (error)
+		return -error;
+
+	if (bulkreq.ocount != NULL) {
+		if (copy_to_user(bulkreq.lastip, &inlast,
+						sizeof(xfs_ino_t)))
+			return -XFS_ERROR(EFAULT);
+
+		if (copy_to_user(bulkreq.ocount, &count, sizeof(count)))
+			return -XFS_ERROR(EFAULT);
+	}
+
+	return 0;
 }
-#endif
+
+
 
 typedef struct compat_xfs_fsop_handlereq {
 	__u32		fd;		/* fd for FD_TO_HANDLE		*/
@@ -261,12 +437,13 @@ xfs_compat_ioctl(
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
+		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_bulkreq);
+		return xfs_ioc_bulkstat_compat(XFS_BHVTOI(VNHEAD(vp))->i_mount,
+				cmd, (void*)arg);
 	case XFS_IOC_FD_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_FSHANDLE_32:
--- linux-2.6.orig/fs/xfs/xfs_itable.h
+++ linux-2.6/fs/xfs/xfs_itable.h
@@ -69,6 +69,10 @@ xfs_bulkstat_single(
 	char			__user *buffer,
 	int			*done);
 
+typedef int (*bulkstat_one_fmt_pf)(  /* used size in bytes or negative error */
+	void			__user *ubuffer, /* buffer to write to */
+	const xfs_bstat_t	*buffer);        /* buffer to read from */
+
 int
 xfs_bulkstat_one(
 	xfs_mount_t		*mp,
@@ -86,11 +90,25 @@ xfs_internal_inum(
 	xfs_mount_t		*mp,
 	xfs_ino_t		ino);
 
+typedef int (*inumbers_fmt_pf)(
+	void			__user *ubuffer, /* buffer to write to */
+	const xfs_inogrp_t	*buffer,	/* buffer to read from */
+	long			count,		/* # of elements to read */
+	long			*written);	/* # of bytes written */
+
+int
+xfs_inumbers_fmt(
+	void			__user *ubuffer, /* buffer to write to */
+	const xfs_inogrp_t	*buffer,	/* buffer to read from */
+	long			count,		/* # of elements to read */
+	long			*written);	/* # of bytes written */
+
 int					/* error status */
 xfs_inumbers(
 	xfs_mount_t		*mp,	/* mount point for filesystem */
 	xfs_ino_t		*last,	/* last inode returned */
 	int			*count,	/* size of buffer/count returned */
-	xfs_inogrp_t		__user *buffer);/* buffer with inode info */
+	void			__user *buffer, /* buffer with inode info */
+	inumbers_fmt_pf		formatter);
 
 #endif	/* __XFS_ITABLE_H__ */
--- linux-2.6.orig/fs/xfs/xfs_itable.c
+++ linux-2.6/fs/xfs/xfs_itable.c
@@ -202,6 +202,16 @@ xfs_bulkstat_one_dinode(
 	return 0;
 }
 
+STATIC int
+xfs_bulkstat_one_fmt(
+	void			__user *ubuffer,
+	const xfs_bstat_t	*buffer)
+{
+	if (copy_to_user(ubuffer, buffer, sizeof(*buffer)))
+		return -EFAULT;
+	return sizeof(*buffer);
+}
+
 /*
  * Return stat information for one inode.
  * Return 0 if ok, else errno.
@@ -221,6 +231,7 @@ xfs_bulkstat_one(
 	xfs_bstat_t	*buf;		/* return buffer */
 	int		error = 0;	/* error value */
 	xfs_dinode_t	*dip;		/* dinode inode pointer */
+	bulkstat_one_fmt_pf formatter = private_data ? : xfs_bulkstat_one_fmt;
 
 	dip = (xfs_dinode_t *)dibuff;
 	*stat = BULKSTAT_RV_NOTHING;
@@ -243,14 +254,14 @@ xfs_bulkstat_one(
 		xfs_bulkstat_one_dinode(mp, ino, dip, buf);
 	}
 
-	if (copy_to_user(buffer, buf, sizeof(*buf)))  {
+	if ((error = formatter(buffer, buf)) < 0)  {
 		error = EFAULT;
 		goto out_free;
 	}
 
 	*stat = BULKSTAT_RV_DIDONE;
 	if (ubused)
-		*ubused = sizeof(*buf);
+		*ubused = error;
 
  out_free:
 	kmem_free(buf, sizeof(*buf));
@@ -748,6 +759,19 @@ xfs_bulkstat_single(
 	return 0;
 }
 
+int
+xfs_inumbers_fmt(
+	void			__user *ubuffer, /* buffer to write to */
+	const xfs_inogrp_t	*buffer,	/* buffer to read from */
+	long			count,		/* # of elements to read */
+	long			*written)	/* # of bytes written */
+{
+	if (copy_to_user(ubuffer, buffer, count * sizeof(*buffer)))
+		return -EFAULT;
+	*written = count * sizeof(*buffer);
+	return 0;
+}
+
 /*
  * Return inode number table for the filesystem.
  */
@@ -756,7 +780,8 @@ xfs_inumbers(
 	xfs_mount_t	*mp,		/* mount point for filesystem */
 	xfs_ino_t	*lastino,	/* last inode returned */
 	int		*count,		/* size of buffer/count returned */
-	xfs_inogrp_t	__user *ubuffer)/* buffer with inode descriptions */
+	void		__user *ubuffer,/* buffer with inode descriptions */
+	inumbers_fmt_pf	formatter)
 {
 	xfs_buf_t	*agbp;
 	xfs_agino_t	agino;
@@ -835,12 +860,12 @@ xfs_inumbers(
 		bufidx++;
 		left--;
 		if (bufidx == bcount) {
-			if (copy_to_user(ubuffer, buffer,
-					bufidx * sizeof(*buffer))) {
+			long written;
+			if (formatter(ubuffer, buffer, bufidx, &written)) {
 				error = XFS_ERROR(EFAULT);
 				break;
 			}
-			ubuffer += bufidx;
+			ubuffer += written;
 			*count += bufidx;
 			bufidx = 0;
 		}
@@ -862,8 +887,8 @@ xfs_inumbers(
 	}
 	if (!error) {
 		if (bufidx) {
-			if (copy_to_user(ubuffer, buffer,
-					bufidx * sizeof(*buffer)))
+			long written;
+			if (formatter(ubuffer, buffer, bufidx, &written))
 				error = XFS_ERROR(EFAULT);
 			else
 				*count += bufidx;
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -1019,7 +1019,7 @@ xfs_ioc_bulkstat(
 
 	if (cmd == XFS_IOC_FSINUMBERS)
 		error = xfs_inumbers(mp, &inlast, &count,
-						bulkreq.ubuffer);
+					bulkreq.ubuffer, xfs_inumbers_fmt);
 	else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE)
 		error = xfs_bulkstat_single(mp, &inlast,
 						bulkreq.ubuffer, &done);
