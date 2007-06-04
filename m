Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Jun 2007 22:23:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l545NdWt006180
	for <xfs@oss.sgi.com>; Sun, 3 Jun 2007 22:23:43 -0700
Date: Mon, 4 Jun 2007 15:23:33 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: factor extracting extent size hints from the inode
Message-ID: <20070604052333.GR85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Replace frequently repeated, open coded extraction of the
extent size hint from the xfs_inode with a single helper
function.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_bmap.c     |   33 +++++++++++----------------------
 fs/xfs/xfs_iomap.c    |   19 ++++---------------
 fs/xfs/xfs_rw.h       |   22 ++++++++++++++++++++++
 fs/xfs/xfs_vnodeops.c |   17 +++++------------
 4 files changed, 42 insertions(+), 49 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-05-31 17:07:38.421796043 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-05-31 17:14:29.188303231 +1000
@@ -197,9 +197,8 @@ xfs_getattr(
 			 * realtime extent size or the realtime volume's
 			 * extent size.
 			 */
-			vap->va_blocksize = ip->i_d.di_extsize ?
-				(ip->i_d.di_extsize << mp->m_sb.sb_blocklog) :
-				(mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog);
+			vap->va_blocksize =
+				xfs_get_extsz_hint(ip) << mp->m_sb.sb_blocklog;
 		}
 		break;
 	}
@@ -4094,22 +4093,16 @@ xfs_alloc_file_space(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	rt = XFS_IS_REALTIME_INODE(ip);
-	if (unlikely(rt)) {
-		if (!(extsz = ip->i_d.di_extsize))
-			extsz = mp->m_sb.sb_rextsize;
-	} else {
-		extsz = ip->i_d.di_extsize;
-	}
-
 	if ((error = XFS_QM_DQATTACH(mp, ip, 0)))
 		return error;
 
 	if (len <= 0)
 		return XFS_ERROR(EINVAL);
 
+	rt = XFS_IS_REALTIME_INODE(ip);
+	extsz = xfs_get_extsz_hint(ip);
+
 	count = len;
-	error = 0;
 	imapp = &imaps[0];
 	nimaps = 1;
 	bmapi_flag = XFS_BMAPI_WRITE | (alloc_type ? XFS_BMAPI_PREALLOC : 0);
Index: 2.6.x-xfs-new/fs/xfs/xfs_rw.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_rw.h	2007-05-31 17:07:37.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_rw.h	2007-05-31 17:36:31.711921349 +1000
@@ -77,6 +77,28 @@ xfs_fsb_to_db_io(struct xfs_iocore *io, 
 #define XFS_FREE_EOF_LOCK	(1<<0)
 #define XFS_FREE_EOF_NOLOCK	(1<<1)
 
+
+/*
+ * helper function to extract extent size hint from inode
+ */
+STATIC_INLINE xfs_extlen_t
+xfs_get_extsz_hint(
+	xfs_inode_t	*ip)
+{
+	xfs_extlen_t	extsz;
+
+	if (unlikely(ip->i_d.di_flags & XFS_DIFLAG_REALTIME)) {
+		extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
+				? ip->i_d.di_extsize
+				: ip->i_mount->m_sb.sb_rextsize;
+		ASSERT(extsz);
+	} else {
+		extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
+				? ip->i_d.di_extsize : 0;
+	}
+	return extsz;
+}
+
 /*
  * Prototypes for functions in xfs_rw.c.
  */
Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap.c	2007-05-29 16:40:12.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap.c	2007-05-31 17:38:24.429227867 +1000
@@ -2618,8 +2618,7 @@ xfs_bmap_rtalloc(
 	xfs_rtblock_t	rtb;
 
 	mp = ap->ip->i_mount;
-	align = ap->ip->i_d.di_extsize ?
-		ap->ip->i_d.di_extsize : mp->m_sb.sb_rextsize;
+	align = xfs_get_extsz_hint(ap->ip);
 	prod = align / mp->m_sb.sb_rextsize;
 	error = xfs_bmap_extsize_align(mp, ap->gotp, ap->prevp,
 					align, 1, ap->eof, 0,
@@ -2727,9 +2726,7 @@ xfs_bmap_btalloc(
 	if (!args)
 		return XFS_ERROR(ENOMEM);
 	mp = ap->ip->i_mount;
-	align = (ap->userdata && ap->ip->i_d.di_extsize &&
-		(ap->ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)) ?
-		ap->ip->i_d.di_extsize : 0;
+	align = ap->userdata ? xfs_get_extsz_hint(ap->ip) : 0;
 	if (unlikely(align)) {
 		error = xfs_bmap_extsize_align(mp, ap->gotp, ap->prevp,
 						align, 0, ap->eof, 0, ap->conv,
@@ -2829,9 +2826,9 @@ xfs_bmap_btalloc(
 		args->total = ap->total;
 		args->minlen = ap->minlen;
 	}
-	if (unlikely(ap->userdata && ap->ip->i_d.di_extsize &&
-		    (ap->ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE))) {
-		args->prod = ap->ip->i_d.di_extsize;
+	/* apply extent size hints if obtained earlier */
+	if (unlikely(align)) {
+		args->prod = align;
 		if ((args->mod = (xfs_extlen_t)do_mod(ap->off, args->prod)))
 			args->mod = (xfs_extlen_t)(args->prod - args->mod);
 	} else if (mp->m_sb.sb_blocksize >= NBPP) {
@@ -3018,9 +3015,7 @@ xfs_bmap_filestreams(
 	 */
 	mp = ap->ip->i_mount;
 	rt = (ap->ip->i_d.di_flags & XFS_DIFLAG_REALTIME) && ap->userdata;
-	align = (ap->userdata && ap->ip->i_d.di_extsize &&
-		(ap->ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)) ?
-		ap->ip->i_d.di_extsize : 0;
+	align = ap->userdata ? xfs_get_extsz_hint(ap->ip) : 0;
 	if (align) {
 		error = xfs_bmap_extsize_align(mp, ap->gotp, ap->prevp,
 						align, rt,
@@ -3166,9 +3161,9 @@ xfs_bmap_filestreams(
 		args.total = ap->total;
 		args.minlen = ap->minlen;
 	}
-	if (ap->userdata && ap->ip->i_d.di_extsize &&
-	    (ap->ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)) {
-		args.prod = ap->ip->i_d.di_extsize;
+	/* apply extent size hint if found earlier */
+	if (align) {
+		args.prod = align;
 		if ((args.mod = (xfs_extlen_t)(do_mod(ap->off, args.prod))))
 			args.mod = (xfs_extlen_t)(args.prod - args.mod);
 	} else if (mp->m_sb.sb_blocksize >= NBPP) {
@@ -5224,12 +5219,7 @@ xfs_bmapi(
 				xfs_extlen_t	extsz;
 
 				/* Figure out the extent size, adjust alen */
-				if (rt) {
-					if (!(extsz = ip->i_d.di_extsize))
-						extsz = mp->m_sb.sb_rextsize;
-				} else {
-					extsz = ip->i_d.di_extsize;
-				}
+				extsz = xfs_get_extsz_hint(ip);
 				if (extsz) {
 					error = xfs_bmap_extsize_align(mp,
 							&got, &prev, extsz,
@@ -6170,8 +6160,7 @@ xfs_getbmap(
 		   ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
 		return XFS_ERROR(EINVAL);
 	if (whichfork == XFS_DATA_FORK) {
-		if ((ip->i_d.di_extsize && (ip->i_d.di_flags &
-				(XFS_DIFLAG_REALTIME|XFS_DIFLAG_EXTSIZE))) ||
+		if (xfs_get_extsz_hint(ip) ||
 		    ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC|XFS_DIFLAG_APPEND)){
 			prealloced = 1;
 			fixlen = XFS_MAXIOFFSET(mp);
Index: 2.6.x-xfs-new/fs/xfs/xfs_iomap.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iomap.c	2007-05-31 17:07:38.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_iomap.c	2007-05-31 17:30:22.096110172 +1000
@@ -451,19 +451,14 @@ xfs_iomap_write_direct(
 		return XFS_ERROR(error);
 
 	rt = XFS_IS_REALTIME_INODE(ip);
-	if (unlikely(rt)) {
-		if (!(extsz = ip->i_d.di_extsize))
-			extsz = mp->m_sb.sb_rextsize;
-	} else {
-		extsz = ip->i_d.di_extsize;
-	}
+	extsz = xfs_get_extsz_hint(ip);
 
 	isize = ip->i_size;
 	if (io->io_new_size > isize)
 		isize = io->io_new_size;
 
-  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-  	last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
+	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
 	if ((offset + count) > isize) {
 		error = xfs_iomap_eof_align_last_fsb(mp, io, isize, extsz,
 							&last_fsb);
@@ -666,13 +661,7 @@ xfs_iomap_write_delay(
 	if (error)
 		return XFS_ERROR(error);
 
-	if (XFS_IS_REALTIME_INODE(ip)) {
-		if (!(extsz = ip->i_d.di_extsize))
-			extsz = mp->m_sb.sb_rextsize;
-	} else {
-		extsz = ip->i_d.di_extsize;
-	}
-
+	extsz = xfs_get_extsz_hint(ip);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
 retry:
