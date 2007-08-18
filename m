Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 18 Aug 2007 14:19:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7ILJebm009572
	for <xfs@oss.sgi.com>; Sat, 18 Aug 2007 14:19:42 -0700
Received: from Liberator.local (unknown [10.0.0.69])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 184BE18DF93BA
	for <xfs@oss.sgi.com>; Sat, 18 Aug 2007 16:19:46 -0500 (CDT)
Message-ID: <46C7627A.60503@sandeen.net>
Date: Sat, 18 Aug 2007 16:19:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] optimize XFS_IS_REALTIME_INODE w/o realtime config
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Use XFS_IS_REALTIME_INODE in more places, and #define it to
0 if CONFIG_XFS_RT is off.  This should be safe because mount
checks in xfs_rtmount_init:

# define xfs_rtmount_init(m)    (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))

so if we get mounted w/o CONFIG_XFS_RT, no realtime inodes should
be encountered after that.

Defining XFS_IS_REALTIME_INODE to 0 saves a bit of stack space,
presumeably gcc can optimize around the various "if (0)" type
checks:

xfs_alloc_file_space	-8
xfs_bmap_adjacent	-16
xfs_bmapi		-8
xfs_bmap_rtalloc	-16
xfs_bunmapi		-28
xfs_free_file_space	-64
xfs_imap		+8  <-- ?  hmm.
xfs_iomap_write_direct	-12
xfs_qm_dqusage_adjust	-4
xfs_qm_vop_chown_reserve -4

Compile tested only at this point.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6.22.i386/fs/xfs/xfs_rtalloc.h
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/xfs_rtalloc.h
+++ linux-2.6.22.i386/fs/xfs/xfs_rtalloc.h
@@ -21,8 +21,6 @@
 struct xfs_mount;
 struct xfs_trans;
 
-#define XFS_IS_REALTIME_INODE(ip) ((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME)
-
 /* Min and max rt extent sizes, specified in bytes */
 #define	XFS_MAX_RTEXTSIZE	(1024 * 1024 * 1024)	/* 1GB */
 #define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64KB */
Index: linux-2.6.22.i386/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/linux-2.6/xfs_ioctl.c
+++ linux-2.6.22.i386/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -736,7 +736,7 @@ xfs_ioctl(
 	case XFS_IOC_DIOINFO: {
 		struct dioattr	da;
 		xfs_buftarg_t	*target =
-			(ip->i_d.di_flags & XFS_DIFLAG_REALTIME) ?
+			XFS_IS_REALTIME_INODE(ip) ?
 			mp->m_rtdev_targp : mp->m_ddev_targp;
 
 		da.d_mem = da.d_miniosz = 1 << target->bt_sshift;
Index: linux-2.6.22.i386/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/linux-2.6/xfs_lrw.c
+++ linux-2.6.22.i386/fs/xfs/linux-2.6/xfs_lrw.c
@@ -220,7 +220,7 @@ xfs_read(
 
 	if (unlikely(ioflags & IO_ISDIRECT)) {
 		xfs_buftarg_t	*target =
-			(ip->i_d.di_flags & XFS_DIFLAG_REALTIME) ?
+			XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp;
 		if ((*offset & target->bt_smask) ||
 		    (size & target->bt_smask)) {
@@ -694,7 +694,7 @@ start:
 
 	if (ioflags & IO_ISDIRECT) {
 		xfs_buftarg_t	*target =
-			(xip->i_d.di_flags & XFS_DIFLAG_REALTIME) ?
+			XFS_IS_REALTIME_INODE(xip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp;
 
 		if ((pos & target->bt_smask) || (count & target->bt_smask)) {
Index: linux-2.6.22.i386/fs/xfs/xfs_dfrag.c
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/xfs_dfrag.c
+++ linux-2.6.22.i386/fs/xfs/xfs_dfrag.c
@@ -184,8 +184,7 @@ xfs_swap_extents(
 	}
 
 	/* Verify both files are either real-time or non-realtime */
-	if ((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) !=
-	    (tip->i_d.di_flags & XFS_DIFLAG_REALTIME)) {
+	if (XFS_IS_REALTIME_INODE(ip) != XFS_IS_REALTIME_INODE(tip)) {
 		error = XFS_ERROR(EINVAL);
 		goto error0;
 	}
Index: linux-2.6.22.i386/fs/xfs/xfs_iocore.c
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/xfs_iocore.c
+++ linux-2.6.22.i386/fs/xfs/xfs_iocore.c
@@ -94,7 +94,7 @@ xfs_iocore_inode_reinit(
 	xfs_iocore_t	*io = &ip->i_iocore;
 
 	io->io_flags = 0;
-	if (ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
+	if (XFS_IS_REALTIME_INODE(ip))
 		io->io_flags |= XFS_IOCORE_RT;
 	io->io_dmevmask = ip->i_d.di_dmevmask;
 	io->io_dmstate = ip->i_d.di_dmstate;
Index: linux-2.6.22.i386/fs/xfs/xfs_rw.h
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/xfs_rw.h
+++ linux-2.6.22.i386/fs/xfs/xfs_rw.h
@@ -58,7 +58,7 @@ struct xfs_mount;
 static inline xfs_daddr_t
 xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
 {
-	return (((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME) ? \
+	return (XFS_IS_REALTIME_INODE(ip) ? \
 		 (xfs_daddr_t)XFS_FSB_TO_BB((ip)->i_mount, (fsb)) : \
 		 XFS_FSB_TO_DADDR((ip)->i_mount, (fsb)));
 }
@@ -87,7 +87,7 @@ xfs_get_extsz_hint(
 {
 	xfs_extlen_t	extsz;
 
-	if (unlikely(ip->i_d.di_flags & XFS_DIFLAG_REALTIME)) {
+	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
 		extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
 				? ip->i_d.di_extsize
 				: ip->i_mount->m_sb.sb_rextsize;
Index: linux-2.6.22.i386/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/xfs_vnodeops.c
+++ linux-2.6.22.i386/fs/xfs/xfs_vnodeops.c
@@ -144,7 +144,7 @@ xfs_getattr(
 	default:
 		vap->va_rdev = 0;
 
-		if (!(ip->i_d.di_flags & XFS_DIFLAG_REALTIME)) {
+		if (!(XFS_IS_REALTIME_INODE(ip))) {
 			vap->va_blocksize = xfs_preferred_iosize(mp);
 		} else {
 
@@ -521,7 +521,7 @@ xfs_setattr(
 		 */
 		if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
 		    (mask & XFS_AT_XFLAGS) &&
-		    (ip->i_d.di_flags & XFS_DIFLAG_REALTIME) !=
+		    (XFS_IS_REALTIME_INODE(ip)) !=
 		    (vap->va_xflags & XFS_XFLAG_REALTIME)) {
 			code = XFS_ERROR(EINVAL);	/* EFBIG? */
 			goto error_return;
@@ -533,7 +533,7 @@ xfs_setattr(
 		if ((mask & XFS_AT_EXTSIZE) && vap->va_extsize != 0) {
 			xfs_extlen_t	size;
 
-			if ((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) ||
+			if (XFS_IS_REALTIME_INODE(ip) ||
 			    ((mask & XFS_AT_XFLAGS) &&
 			    (vap->va_xflags & XFS_XFLAG_REALTIME))) {
 				size = mp->m_sb.sb_rextsize <<
@@ -1188,7 +1188,7 @@ xfs_fsync(
 		 * If this inode is on the RT dev we need to flush that
 		 * cache as well.
 		 */
-		if (ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
+		if (XFS_IS_REALTIME_INODE(ip))
 			xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);
 	}
 
@@ -4263,7 +4263,7 @@ xfs_zero_remaining_bytes(
 	int			error = 0;
 
 	bp = xfs_buf_get_noaddr(mp->m_sb.sb_blocksize,
-				ip->i_d.di_flags & XFS_DIFLAG_REALTIME ?
+				XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp);
 
 	for (offset = startoff; offset <= endoff; offset = lastoffset + 1) {
@@ -4360,7 +4360,7 @@ xfs_free_file_space(
 	error = 0;
 	if (len <= 0)	/* if nothing being freed */
 		return error;
-	rt = (ip->i_d.di_flags & XFS_DIFLAG_REALTIME);
+	rt = XFS_IS_REALTIME_INODE(ip);
 	startoffset_fsb	= XFS_B_TO_FSB(mp, offset);
 	end_dmi_offset = offset + len;
 	endoffset_fsb = XFS_B_TO_FSBT(mp, end_dmi_offset);
Index: linux-2.6.22.i386/fs/xfs/xfs_dinode.h
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/xfs_dinode.h
+++ linux-2.6.22.i386/fs/xfs/xfs_dinode.h
@@ -274,6 +274,12 @@ typedef enum xfs_dinode_fmt
 #define XFS_DIFLAG_NODEFRAG      (1 << XFS_DIFLAG_NODEFRAG_BIT)
 #define XFS_DIFLAG_FILESTREAM    (1 << XFS_DIFLAG_FILESTREAM_BIT)
 
+#ifdef CONFIG_XFS_RT
+#define XFS_IS_REALTIME_INODE(ip) ((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME)
+#else
+#define XFS_IS_REALTIME_INODE(ip) (0)
+#endif
+
 #define XFS_DIFLAG_ANY \
 	(XFS_DIFLAG_REALTIME | XFS_DIFLAG_PREALLOC | XFS_DIFLAG_NEWRTBM | \
 	 XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_APPEND | XFS_DIFLAG_SYNC | \
