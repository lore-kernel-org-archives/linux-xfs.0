Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ3KThX000813 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 21:20:30 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ADEA415FCD6A
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:20:28 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id S3PFNJh4Rlkmgwrk for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 19:20:28 -0800 (PST)
Message-Id: <20081126032027.741040886@sandeen.net>
References: <20081126032005.639750968@sandeen.net>
Date: Tue, 25 Nov 2008 21:20:09 -0600
From: sandeen@sandeen.net
Subject: [patch 04/12] Add compat handlers for swapext ioctl
Content-Disposition: inline; filename=compat_swapext_v2
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

The big hitter here was the bstat field, which contains
different sized time_t on 32 vs. 64 bit.  Add a copyin
function to translate the 32-bit arg to 64-bit, and
call the swapext ioctl helper.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:00:13.028001846 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:09:28.789064125 -0600
@@ -109,6 +109,50 @@ xfs_inumbers_fmt_compat(
 #define xfs_inumbers_fmt_compat xfs_inumbers_fmt
 #endif
 
+STATIC int
+xfs_ioctl32_bstime_copyin(
+	xfs_bstime_t		*bstime,
+	compat_xfs_bstime_t	__user *bstime32)
+{
+	compat_time_t		sec32;	/* tv_sec differs on 64 vs. 32 */
+
+	if (get_user(sec32,		&bstime32->tv_sec)	||
+	    get_user(bstime->tv_nsec,	&bstime32->tv_nsec))
+		return -XFS_ERROR(EFAULT);
+	bstime->tv_sec = sec32;
+	return 0;
+}
+
+/* xfs_bstat_t has differing alignment on intel, & bstime_t sizes everywhere */
+STATIC int
+xfs_ioctl32_bstat_copyin(
+	xfs_bstat_t		*bstat,
+	compat_xfs_bstat_t	__user *bstat32)
+{
+	if (get_user(bstat->bs_ino,	&bstat32->bs_ino)	||
+	    get_user(bstat->bs_mode,	&bstat32->bs_mode)	||
+	    get_user(bstat->bs_nlink,	&bstat32->bs_nlink)	||
+	    get_user(bstat->bs_uid,	&bstat32->bs_uid)	||
+	    get_user(bstat->bs_gid,	&bstat32->bs_gid)	||
+	    get_user(bstat->bs_rdev,	&bstat32->bs_rdev)	||
+	    get_user(bstat->bs_blksize,	&bstat32->bs_blksize)	||
+	    get_user(bstat->bs_size,	&bstat32->bs_size)	||
+	    xfs_ioctl32_bstime_copyin(&bstat->bs_atime, &bstat32->bs_atime) ||
+	    xfs_ioctl32_bstime_copyin(&bstat->bs_mtime, &bstat32->bs_mtime) ||
+	    xfs_ioctl32_bstime_copyin(&bstat->bs_ctime, &bstat32->bs_ctime) ||
+	    get_user(bstat->bs_blocks,	&bstat32->bs_size)	||
+	    get_user(bstat->bs_xflags,	&bstat32->bs_size)	||
+	    get_user(bstat->bs_extsize,	&bstat32->bs_extsize)	||
+	    get_user(bstat->bs_extents,	&bstat32->bs_extents)	||
+	    get_user(bstat->bs_gen,	&bstat32->bs_gen)	||
+	    get_user(bstat->bs_projid,	&bstat32->bs_projid)	||
+	    get_user(bstat->bs_dmevmask, &bstat32->bs_dmevmask)	||
+	    get_user(bstat->bs_dmstate,	&bstat32->bs_dmstate)	||
+	    get_user(bstat->bs_aextents, &bstat32->bs_aextents))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
+
 /* XFS_IOC_FSBULKSTAT and friends */
 
 STATIC int
@@ -293,6 +337,18 @@ xfs_compat_ioctl(
 	case XFS_IOC_GETVERSION_32:
 		cmd = _NATIVE_IOC(cmd, long);
 		break;
+	case XFS_IOC_SWAPEXT: {
+		struct xfs_swapext	  sxp;
+		struct compat_xfs_swapext __user *sxu = arg;
+
+		/* Bulk copy in up to the sx_stat field, then grab bstat */
+		if (copy_from_user(&sxp, sxu,
+				   offsetof(xfs_swapext_t, sx_stat)) ||
+		    xfs_ioctl32_bstat_copyin(&sxp.sx_stat, &sxu->sx_stat))
+			return -XFS_ERROR(EFAULT);
+		error = xfs_swapext(&sxp);
+		return -error;
+	}
 #ifdef BROKEN_X86_ALIGNMENT
 	/* xfs_flock_t has wrong u32 vs u64 alignment */
 	case XFS_IOC_ALLOCSP_32:
@@ -323,11 +379,6 @@ xfs_compat_ioctl(
 	case XFS_IOC_UNRESVSP64:
 	case XFS_IOC_FSGEOMETRY_V1:
 		break;
-
-	/* xfs_bstat_t still has wrong u32 vs u64 alignment */
-	case XFS_IOC_SWAPEXT:
-		break;
-
 #endif
 	case XFS_IOC_FSBULKSTAT_32:
 	case XFS_IOC_FSBULKSTAT_SINGLE_32:
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-11-24 16:59:35.191002158 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-11-24 17:09:28.789064125 -0600
@@ -110,6 +110,19 @@ typedef struct compat_xfs_fsop_handlereq
 #define XFS_IOC_READLINK_BY_HANDLE_32 \
 	_IOWR('X', 108, struct compat_xfs_fsop_handlereq)
 
+/* The bstat field in the swapext struct needs translation */
+typedef struct compat_xfs_swapext {
+	__int64_t		sx_version;	/* version */
+	__int64_t		sx_fdtarget;	/* fd of target file */
+	__int64_t		sx_fdtmp;	/* fd of tmp file */
+	xfs_off_t		sx_offset;	/* offset into file */
+	xfs_off_t		sx_length;	/* leng from offset */
+	char			sx_pad[16];	/* pad space, unused */
+	compat_xfs_bstat_t	sx_stat;	/* stat of target b4 copy */
+} __compat_packed compat_xfs_swapext_t;
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
