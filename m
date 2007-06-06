Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 22:45:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l565jZWt019371
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 22:45:37 -0700
Message-ID: <46664A88.2000807@sgi.com>
Date: Wed, 06 Jun 2007 15:47:52 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: [REVIEW 1/2] - setting realtime and extent size hint flags via fcntl(XFS_IOC_FSSETXATTR)
Content-Type: multipart/mixed;
 boundary="------------080609010505080602030404"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------080609010505080602030404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes error handling when setting realtime and extent size hint
flags via fcntl(XFS_IOC_FSSETXATTR).
It also makes XFS_XFLAG_RTINHERIT/XFS_XFLAG_EXTSZINHERIT and
XFS_XFLAG_REALTIME/XFS_XFLAG_EXTSIZE flags mutually exclusive. Currently 
both,
the realtime and extent hint flags could be set at the same time,
which is not how the code is designed to work and could cause unexpected
behavior.
The realtime extent size is taken either from the on disk xfs inode 
di_extsize
(if set to non zero) or from the supperblock sb_rextsize fields. The parent
directory inheritance didn't inherit the di_extsize, which is also fixed in
this patch.

Regards,
Vlad

--------------080609010505080602030404
Content-Type: text/plain;
 name="fix_realtime_and_extent_hint_size_error_handling"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix_realtime_and_extent_hint_size_error_handling"

Index: linux-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-xfs.orig/fs/xfs/xfs_inode.c
+++ linux-xfs/fs/xfs/xfs_inode.c
@@ -793,6 +793,8 @@ _xfs_dic2xflags(
 	if (di_flags & XFS_DIFLAG_ANY) {
 		if (di_flags & XFS_DIFLAG_REALTIME)
 			flags |= XFS_XFLAG_REALTIME;
+		else if (di_flags & XFS_DIFLAG_EXTSIZE)
+			flags |= XFS_XFLAG_EXTSIZE;
 		if (di_flags & XFS_DIFLAG_PREALLOC)
 			flags |= XFS_XFLAG_PREALLOC;
 		if (di_flags & XFS_DIFLAG_IMMUTABLE)
@@ -807,14 +809,12 @@ _xfs_dic2xflags(
 			flags |= XFS_XFLAG_NODUMP;
 		if (di_flags & XFS_DIFLAG_RTINHERIT)
 			flags |= XFS_XFLAG_RTINHERIT;
+		else if (di_flags & XFS_DIFLAG_EXTSZINHERIT)
+			flags |= XFS_XFLAG_EXTSZINHERIT;
 		if (di_flags & XFS_DIFLAG_PROJINHERIT)
 			flags |= XFS_XFLAG_PROJINHERIT;
 		if (di_flags & XFS_DIFLAG_NOSYMLINKS)
 			flags |= XFS_XFLAG_NOSYMLINKS;
-		if (di_flags & XFS_DIFLAG_EXTSIZE)
-			flags |= XFS_XFLAG_EXTSIZE;
-		if (di_flags & XFS_DIFLAG_EXTSZINHERIT)
-			flags |= XFS_XFLAG_EXTSZINHERIT;
 		if (di_flags & XFS_DIFLAG_NODEFRAG)
 			flags |= XFS_XFLAG_NODEFRAG;
 	}
@@ -1200,9 +1200,12 @@ xfs_ialloc(
 			uint	di_flags = 0;
 
 			if ((mode & S_IFMT) == S_IFDIR) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT) {
 					di_flags |= XFS_DIFLAG_RTINHERIT;
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+					ip->i_d.di_extsize = pip->i_d.di_extsize;
+				}
+				else if (pip->i_d.di_flags &
+					 XFS_DIFLAG_EXTSZINHERIT) {
 					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
 					ip->i_d.di_extsize = pip->i_d.di_extsize;
 				}
@@ -1210,8 +1213,10 @@ xfs_ialloc(
 				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT) {
 					di_flags |= XFS_DIFLAG_REALTIME;
 					ip->i_iocore.io_flags |= XFS_IOCORE_RT;
+					ip->i_d.di_extsize = pip->i_d.di_extsize;
 				}
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+				else if (pip->i_d.di_flags &
+					 XFS_DIFLAG_EXTSZINHERIT) {
 					di_flags |= XFS_DIFLAG_EXTSIZE;
 					ip->i_d.di_extsize = pip->i_d.di_extsize;
 				}
Index: linux-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-xfs.orig/fs/xfs/xfs_vnodeops.c
+++ linux-xfs/fs/xfs/xfs_vnodeops.c
@@ -547,15 +547,35 @@ xfs_setattr(
 		}
 
 		/*
-		 * Can't change realtime flag if any extents are allocated.
+		 * Can't have both realtime and extent hint flags set at
+		 * the same time.
+		 */
+		if ((mask & XFS_AT_XFLAGS) &&
+		    (((vap->va_xflags &
+		      (XFS_XFLAG_REALTIME | XFS_XFLAG_EXTSIZE)) ==
+		       (XFS_XFLAG_REALTIME | XFS_XFLAG_EXTSIZE)) ||
+		      ((vap->va_xflags & XFS_XFLAG_REALTIME) &&
+		       (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)) ||
+		      ((vap->va_xflags & XFS_XFLAG_EXTSIZE) &&
+		       (ip->i_d.di_flags & XFS_DIFLAG_REALTIME)))) {
+			code = XFS_ERROR(EINVAL);
+			goto error_return;
+		}
+
+		/*
+		 * Can't change realtime and extent hint flags if any extents
+		 * are allocated.
 		 */
 		if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
 		    (mask & XFS_AT_XFLAGS) &&
-		    (ip->i_d.di_flags & XFS_DIFLAG_REALTIME) !=
-		    (vap->va_xflags & XFS_XFLAG_REALTIME)) {
+		    (((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) !=
+		       (vap->va_xflags & XFS_XFLAG_REALTIME)) ||
+		     ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) !=
+		       (vap->va_xflags & XFS_XFLAG_EXTSIZE)))) {
 			code = XFS_ERROR(EINVAL);	/* EFBIG? */
 			goto error_return;
 		}
+
 		/*
 		 * Extent size must be a multiple of the appropriate block
 		 * size, if set at all.
@@ -563,6 +583,16 @@ xfs_setattr(
 		if ((mask & XFS_AT_EXTSIZE) && vap->va_extsize != 0) {
 			xfs_extlen_t	size;
 
+			/*
+			 * Either realtime or extent hint flags must be set
+			 * when extent size is non zero
+			 */
+			if (!(vap->va_xflags &
+			     (XFS_XFLAG_REALTIME | XFS_XFLAG_EXTSIZE))) {
+				code = XFS_ERROR(EINVAL);
+				goto error_return;
+			}
+
 			if ((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) ||
 			    ((mask & XFS_AT_XFLAGS) &&
 			    (vap->va_xflags & XFS_XFLAG_REALTIME))) {
@@ -817,10 +847,11 @@ xfs_setattr(
 			if ((ip->i_d.di_mode & S_IFMT) == S_IFDIR) {
 				if (vap->va_xflags & XFS_XFLAG_RTINHERIT)
 					di_flags |= XFS_DIFLAG_RTINHERIT;
+				else if (vap->va_xflags &
+					 XFS_XFLAG_EXTSZINHERIT)
+					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
 				if (vap->va_xflags & XFS_XFLAG_NOSYMLINKS)
 					di_flags |= XFS_DIFLAG_NOSYMLINKS;
-				if (vap->va_xflags & XFS_XFLAG_EXTSZINHERIT)
-					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
 			} else if ((ip->i_d.di_mode & S_IFMT) == S_IFREG) {
 				if (vap->va_xflags & XFS_XFLAG_REALTIME) {
 					di_flags |= XFS_DIFLAG_REALTIME;

--------------080609010505080602030404--
