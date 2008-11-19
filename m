Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAJ5H6wA031881 for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 23:17:06 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 832EE159F534
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 21:16:59 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id Pn4t75Ss78cOpVJO for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2008 21:16:59 -0800 (PST)
Message-Id: <20081119044908.948703484@sandeen.net>
References: <20081119044401.573365619@sandeen.net>
Date: Tue, 18 Nov 2008 22:44:05 -0600
From: sandeen@sandeen.net
Subject: [patch 04/11] Add compat handlers for swapext ioctl
Content-Disposition: inline; filename=compat_ioctl_swapext
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

The big hitter here was the bstat field, which contains
different sized time_t on 32 vs. 64 bit.  Add a copyin
function to translate the 32-bit arg to 64-bit, and
call the native ioctl.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -136,6 +136,65 @@ xfs_inumbers_fmt_compat(
 
 #endif
 
+/* tv_sec differs on 64 vs. 32 */
+STATIC int
+xfs_ioctl32_bstime_copyin(
+	xfs_bstime_t		__user *p,
+	compat_xfs_bstime_t	__user *p32)
+{
+	compat_time_t	sec32;
+	s32		nsec;
+
+	if (get_user(sec32,	&p32->tv_sec) ||
+	    put_user(sec32,	&p->tv_sec)   ||
+	    get_user(nsec,	&p32->tv_nsec)||
+	    put_user(nsec,	&p->tv_nsec))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
+
+/* xfs_bstat_t has differing alignment on intel, & bstime_t sizes everywhere */
+STATIC int
+xfs_ioctl32_bstat_copyin(
+	xfs_bstat_t		__user *p,
+	compat_xfs_bstat_t	__user *p32)
+{
+	if (copy_in_user(&p->bs_ino,	&p32->bs_ino,	sizeof(u64)) ||
+	    copy_in_user(&p->bs_mode,	&p32->bs_mode,	sizeof(u16)) ||
+	    copy_in_user(&p->bs_nlink,	&p32->bs_nlink,	sizeof(u16)) ||
+	    copy_in_user(&p->bs_uid,	&p32->bs_uid,	sizeof(u32)) ||
+	    copy_in_user(&p->bs_gid,	&p32->bs_gid,	sizeof(u32)) ||
+	    copy_in_user(&p->bs_rdev,	&p32->bs_rdev,	sizeof(u32)) ||
+	    copy_in_user(&p->bs_blksize, &p32->bs_blksize, sizeof(s32)) ||
+	    copy_in_user(&p->bs_size,	&p32->bs_size,	sizeof(s64)) ||
+	    xfs_ioctl32_bstime_copyin(&p->bs_atime, &p32->bs_atime) ||
+	    xfs_ioctl32_bstime_copyin(&p->bs_mtime, &p32->bs_mtime) ||
+	    xfs_ioctl32_bstime_copyin(&p->bs_ctime, &p32->bs_ctime) ||
+	    copy_in_user(&p->bs_blocks,	&p32->bs_size,	sizeof(s64)) ||
+	    copy_in_user(&p->bs_xflags,	&p32->bs_size,	sizeof(u32)) ||
+	    copy_in_user(&p->bs_extsize, &p32->bs_extsize, sizeof(s32)) ||
+	    copy_in_user(&p->bs_extents, &p32->bs_extents, sizeof(s32)) ||
+	    copy_in_user(&p->bs_gen,	&p32->bs_gen,	sizeof(u32)) ||
+	    copy_in_user(&p->bs_projid,	&p32->bs_projid, sizeof(u16)) ||
+	    copy_in_user(&p->bs_dmevmask, &p32->bs_dmevmask, sizeof(u32)) ||
+	    copy_in_user(&p->bs_dmstate, &p32->bs_dmstate, sizeof(u16)) ||
+	    copy_in_user(&p->bs_aextents, &p32->bs_aextents, sizeof(u16)))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
+
+STATIC unsigned long
+xfs_ioctl32_swapext_copyin(unsigned long arg)
+{
+	compat_xfs_swapext_t	__user *p32 = (void __user *)arg;
+        xfs_swapext_t		__user *p = compat_alloc_user_space(sizeof(*p));
+
+	if (copy_in_user(p, p32, offsetof(xfs_swapext_t, sx_stat)) ||
+	    xfs_ioctl32_bstat_copyin(&p->sx_stat, &p32->sx_stat))
+		return -XFS_ERROR(EFAULT);
+	return (unsigned long)p;
+}
+
 /* XFS_IOC_FSBULKSTAT and friends */
 
 STATIC int
@@ -351,11 +410,11 @@ xfs_compat_ioctl(
 	case XFS_IOC_UNRESVSP64:
 	case XFS_IOC_FSGEOMETRY_V1:
 		break;
-	/* xfs_bstat_t still has wrong u32 vs u64 alignment */
-	case XFS_IOC_SWAPEXT:
-		break;
-
 #endif
+	case XFS_IOC_SWAPEXT_32:
+		arg = xfs_ioctl32_swapext_copyin(arg);
+		cmd = _NATIVE_IOC(cmd, struct xfs_swapext);
+		break;
 	case XFS_IOC_FSBULKSTAT_32:
 	case XFS_IOC_FSBULKSTAT_SINGLE_32:
 	case XFS_IOC_FSINUMBERS_32:
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.h
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
@@ -105,6 +105,20 @@ typedef struct compat_xfs_fsop_handlereq
 #define XFS_IOC_READLINK_BY_HANDLE_32 \
 	_IOWR('X', 108, struct compat_xfs_fsop_handlereq)
 
+/* The bstat field in the swapext struct needs translation */
+typedef struct compat_xfs_swapext
+{
+	__int64_t		sx_version;	/* version */
+	__int64_t		sx_fdtarget;	/* fd of target file */
+	__int64_t		sx_fdtmp;	/* fd of tmp file */
+	xfs_off_t		sx_offset;	/* offset into file */
+	xfs_off_t		sx_length;	/* leng from offset */
+	char			sx_pad[16];	/* pad space, unused */
+	compat_xfs_bstat_t	sx_stat;	/* stat of target b4 copy */
+} _PACKED compat_xfs_swapext_t;
+
+#define XFS_IOC_SWAPEXT_32	_IOWR('X', 109, struct compat_xfs_swapext)
+
 #ifdef BROKEN_X86_ALIGNMENT
 /* on ia32 l_start is on a 32-bit boundary */
 typedef struct compat_xfs_flock64 {

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
