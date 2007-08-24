Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 10:53:35 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7OHrT4p018151
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 10:53:33 -0700
Message-ID: <46CF1B22.7090007@sandeen.net>
Date: Fri, 24 Aug 2007 12:53:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] optimize XFS_IS_REALTIME_INODE w/o realtime config
References: <46C7627A.60503@sandeen.net> <20070824140822.GP72985246@sgi.com>
In-Reply-To: <20070824140822.GP72985246@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:

>
> This misses a bunch of tests (at least in the current tot)
> in xfs_bmap.c, xfs_bmap_btree.c, xfs_iget.c, dmapi/xfs_dm.c and
> linux-2.6/xfs_lrw.c. I think they are all in assert statements,
> but shoul dbe cleaned up as well.
>
> Cheers,
>
> Dave.
>   
Yup, sorry.  Here you go:

---------------

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

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6-xfs/fs/xfs/xfs_rtalloc.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rtalloc.h
+++ linux-2.6-xfs/fs/xfs/xfs_rtalloc.h
@@ -21,8 +21,6 @@
 struct xfs_mount;
 struct xfs_trans;
 
-#define XFS_IS_REALTIME_INODE(ip) ((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME)
-
 /* Min and max rt extent sizes, specified in bytes */
 #define	XFS_MAX_RTEXTSIZE	(1024 * 1024 * 1024)	/* 1GB */
 #define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64KB */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -758,7 +758,7 @@ xfs_ioctl(
 	case XFS_IOC_DIOINFO: {
 		struct dioattr	da;
 		xfs_buftarg_t	*target =
-			(ip->i_d.di_flags & XFS_DIFLAG_REALTIME) ?
+			XFS_IS_REALTIME_INODE(ip) ?
 			mp->m_rtdev_targp : mp->m_ddev_targp;
 
 		da.d_mem = da.d_miniosz = 1 << target->bt_sshift;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
@@ -216,7 +216,7 @@ xfs_read(
 
 	if (unlikely(ioflags & IO_ISDIRECT)) {
 		xfs_buftarg_t	*target =
-			(ip->i_d.di_flags & XFS_DIFLAG_REALTIME) ?
+			XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp;
 		if ((*offset & target->bt_smask) ||
 		    (size & target->bt_smask)) {
@@ -735,7 +735,7 @@ start:
 
 	if (ioflags & IO_ISDIRECT) {
 		xfs_buftarg_t	*target =
-			(xip->i_d.di_flags & XFS_DIFLAG_REALTIME) ?
+			XFS_IS_REALTIME_INODE(xip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp;
 
 		if ((pos & target->bt_smask) || (count & target->bt_smask)) {
@@ -976,7 +976,7 @@ xfs_bmap(
 	xfs_iocore_t	*io = &ip->i_iocore;
 
 	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
-	ASSERT(((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) != 0) ==
+	ASSERT((XFS_IS_REALTIME_INODE(ip) != 0) ==
 	       ((ip->i_iocore.io_flags & XFS_IOCORE_RT) != 0));
 
 	return xfs_iomap(io, offset, count, flags, iomapp, niomaps);
Index: linux-2.6-xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dfrag.c
+++ linux-2.6-xfs/fs/xfs/xfs_dfrag.c
@@ -185,8 +185,7 @@ xfs_swap_extents(
 	}
 
 	/* Verify both files are either real-time or non-realtime */
-	if ((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) !=
-	    (tip->i_d.di_flags & XFS_DIFLAG_REALTIME)) {
+	if (XFS_IS_REALTIME_INODE(ip) != XFS_IS_REALTIME_INODE(tip)) {
 		error = XFS_ERROR(EINVAL);
 		goto error0;
 	}
Index: linux-2.6-xfs/fs/xfs/xfs_iocore.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iocore.c
+++ linux-2.6-xfs/fs/xfs/xfs_iocore.c
@@ -94,7 +94,7 @@ xfs_iocore_inode_reinit(
 	xfs_iocore_t	*io = &ip->i_iocore;
 
 	io->io_flags = 0;
-	if (ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
+	if (XFS_IS_REALTIME_INODE(ip))
 		io->io_flags |= XFS_IOCORE_RT;
 	io->io_dmevmask = ip->i_d.di_dmevmask;
 	io->io_dmstate = ip->i_d.di_dmstate;
Index: linux-2.6-xfs/fs/xfs/xfs_rw.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rw.h
+++ linux-2.6-xfs/fs/xfs/xfs_rw.h
@@ -32,7 +32,7 @@ struct xfs_mount;
 static inline xfs_daddr_t
 xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
 {
-	return (((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME) ? \
+	return (XFS_IS_REALTIME_INODE(ip) ? \
 		 (xfs_daddr_t)XFS_FSB_TO_BB((ip)->i_mount, (fsb)) : \
 		 XFS_FSB_TO_DADDR((ip)->i_mount, (fsb)));
 }
@@ -61,7 +61,7 @@ xfs_get_extsz_hint(
 {
 	xfs_extlen_t	extsz;
 
-	if (unlikely(ip->i_d.di_flags & XFS_DIFLAG_REALTIME)) {
+	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
 		extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
 				? ip->i_d.di_extsize
 				: ip->i_mount->m_sb.sb_rextsize;
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
@@ -136,7 +136,7 @@ xfs_getattr(
 	default:
 		vap->va_rdev = 0;
 
-		if (!(ip->i_d.di_flags & XFS_DIFLAG_REALTIME)) {
+		if (!(XFS_IS_REALTIME_INODE(ip))) {
 			vap->va_blocksize = xfs_preferred_iosize(mp);
 		} else {
 
@@ -508,7 +508,7 @@ xfs_setattr(
 		 */
 		if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
 		    (mask & XFS_AT_XFLAGS) &&
-		    (ip->i_d.di_flags & XFS_DIFLAG_REALTIME) !=
+		    (XFS_IS_REALTIME_INODE(ip)) !=
 		    (vap->va_xflags & XFS_XFLAG_REALTIME)) {
 			code = XFS_ERROR(EINVAL);	/* EFBIG? */
 			goto error_return;
@@ -520,7 +520,7 @@ xfs_setattr(
 		if ((mask & XFS_AT_EXTSIZE) && vap->va_extsize != 0) {
 			xfs_extlen_t	size;
 
-			if ((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) ||
+			if (XFS_IS_REALTIME_INODE(ip) ||
 			    ((mask & XFS_AT_XFLAGS) &&
 			    (vap->va_xflags & XFS_XFLAG_REALTIME))) {
 				size = mp->m_sb.sb_rextsize <<
@@ -1146,7 +1146,7 @@ xfs_fsync(
 		 * If this inode is on the RT dev we need to flush that
 		 * cache as well.
 		 */
-		if (ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
+		if (XFS_IS_REALTIME_INODE(ip))
 			xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);
 	}
 
@@ -4068,7 +4068,7 @@ xfs_zero_remaining_bytes(
 	int			error = 0;
 
 	bp = xfs_buf_get_noaddr(mp->m_sb.sb_blocksize,
-				ip->i_d.di_flags & XFS_DIFLAG_REALTIME ?
+				XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp);
 
 	for (offset = startoff; offset <= endoff; offset = lastoffset + 1) {
@@ -4165,7 +4165,7 @@ xfs_free_file_space(
 	error = 0;
 	if (len <= 0)	/* if nothing being freed */
 		return error;
-	rt = (ip->i_d.di_flags & XFS_DIFLAG_REALTIME);
+	rt = XFS_IS_REALTIME_INODE(ip);
 	startoffset_fsb	= XFS_B_TO_FSB(mp, offset);
 	end_dmi_offset = offset + len;
 	endoffset_fsb = XFS_B_TO_FSBT(mp, end_dmi_offset);
Index: linux-2.6-xfs/fs/xfs/xfs_dinode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dinode.h
+++ linux-2.6-xfs/fs/xfs/xfs_dinode.h
@@ -273,6 +273,12 @@ typedef enum xfs_dinode_fmt
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
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
@@ -1107,7 +1107,7 @@ xfs_dm_direct_ok(
 
 	/* Realtime files can ONLY do direct I/O. */
 
-	if (ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
+	if (XFS_IS_REALTIME_INODE(ip))
 		return(1);
 
 	/* If direct I/O is disabled, or if the request is too small, use
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c
@@ -2969,7 +2969,7 @@ STATIC int
 xfs_bmap_alloc(
 	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
 {
-	if ((ap->ip->i_d.di_flags & XFS_DIFLAG_REALTIME) && ap->userdata)
+	if (XFS_IS_REALTIME_INODE(ap->ip) && ap->userdata)
 		return xfs_bmap_rtalloc(ap);
 	return xfs_bmap_btalloc(ap);
 }
@@ -3096,8 +3096,7 @@ xfs_bmap_del_extent(
 		/*
 		 * Realtime allocation.  Free it and record di_nblocks update.
 		 */
-		if (whichfork == XFS_DATA_FORK &&
-		    (ip->i_d.di_flags & XFS_DIFLAG_REALTIME)) {
+		if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
 			xfs_fsblock_t	bno;
 			xfs_filblks_t	len;
 
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
@@ -2062,8 +2062,7 @@ xfs_bmbt_insert(
 				pcur->bc_private.b.allocated;
 			pcur->bc_private.b.allocated = 0;
 			ASSERT((cur->bc_private.b.firstblock != NULLFSBLOCK) ||
-			       (cur->bc_private.b.ip->i_d.di_flags &
-				XFS_DIFLAG_REALTIME));
+			       XFS_IS_REALTIME_INODE(cur->bc_private.b.ip));
 			cur->bc_private.b.firstblock =
 				pcur->bc_private.b.firstblock;
 			ASSERT(cur->bc_private.b.flist ==
Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c
@@ -333,7 +333,7 @@ finish_inode:
 	ASSERT(ip->i_df.if_ext_max ==
 	       XFS_IFORK_DSIZE(ip) / sizeof(xfs_bmbt_rec_t));
 
-	ASSERT(((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) != 0) ==
+	ASSERT((XFS_IS_REALTIME_INODE(ip) != 0) ==
 	       ((ip->i_iocore.io_flags & XFS_IOCORE_RT) != 0));
 
 	xfs_iflags_set(ip, XFS_IMODIFIED);
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c
@@ -1298,7 +1298,7 @@ xfs_isize_check(
 	if ((ip->i_d.di_mode & S_IFMT) != S_IFREG)
 		return;
 
-	if (ip->i_d.di_flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_EXTSIZE))
+	if (XFS_IS_REALTIME_INODE(ip) || (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE))
 		return;
 
 	nimaps = 2;
