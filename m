Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 Nov 2007 16:01:21 -0800 (PST)
Received: from b.mx.filmlight.ltd.uk (bongo.filmlight.ltd.uk [217.40.27.26])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA501Cbf001302
	for <xfs@oss.sgi.com>; Sun, 4 Nov 2007 16:01:13 -0800
Message-ID: <000001c81f3e$eff344b0$6501a8c0@BODDINGTON>
From: "Roger Willcocks" <roger@filmlight.ltd.uk>
References: <47249E7A.7060709@filmlight.ltd.uk> <47252F62.6030503@sgi.com> <47262CD0.5010708@filmlight.ltd.uk> <4726ADAE.9070206@sgi.com> <472769A1.5090605@filmlight.ltd.uk> <472A7940.5070800@sgi.com>
Subject: Re: bug: truncate to zero + setuid
Date: Sun, 4 Nov 2007 11:59:51 -0000
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0645_01C81EDA.353308E0"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.

------=_NextPart_000_0645_01C81EDA.353308E0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit

Timothy Shimmin wrote:
> Hi Roger,
>
...
> I don't like all these inconsistencies.

Take a look at the attached patch relative to the current cvs (it's a bit 
big to put
inline). The basic problem is it's currently unclear when to set the times 
from
va_atime etc. and when to set them to the current time. So I've used the 
already
defined XFS_AT_UPDxTIME flags to indicate that a time should be set to 'now'
and XFS_AT_xTIME to mean set it using va_xtime. This seems to fit well with
the current code and I wonder if that's how it was meant to work in the 
first
place. I've also removed the now redundant ATTR_UTIME flag and pulled
the null truncate to the top, which simplifies things.

One query: in both xfs_iops.c/xfs_vn_setattr and 
xfs_dm.c/xfs_dm_set_fileattr the
ATIME branch sets the inode's atime directly. This is probably something to 
do with
the comment above xfs_iops.c/xfs_ichgtime ('to make sure the access time 
update
will take') but it could probably be handled better.

> BTW, your locking looks wrong - it appears you don't unlock when the
> file is non-zero size.

Oops...

--
Roger


------=_NextPart_000_0645_01C81EDA.353308E0
Content-Type: application/octet-stream;
	name="xfs_setattr.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="xfs_setattr.patch"

diff -ur xfs.orig/linux-2.6/xfs_iops.c xfs/linux-2.6/xfs_iops.c
--- xfs.orig/linux-2.6/xfs_iops.c	2007-11-04 10:59:00.923480296 +0000
+++ xfs/linux-2.6/xfs_iops.c	2007-11-04 12:43:15.702609336 +0000
@@ -655,13 +655,21 @@
 		vattr.va_size =3D attr->ia_size;
 	}
 	if (ia_valid & ATTR_ATIME) {
-		vattr.va_mask |=3D XFS_AT_ATIME;
-		vattr.va_atime =3D attr->ia_atime;
-		inode->i_atime =3D attr->ia_atime;
+		if (ia_valid & ATTR_ATIME_SET) {
+			vattr.va_mask |=3D XFS_AT_ATIME;
+			vattr.va_atime =3D attr->ia_atime;
+			inode->i_atime =3D attr->ia_atime;
+		} else {
+			vattr.va_mask |=3D XFS_AT_UPDATIME;
+		}
 	}
 	if (ia_valid & ATTR_MTIME) {
-		vattr.va_mask |=3D XFS_AT_MTIME;
-		vattr.va_mtime =3D attr->ia_mtime;
+		if (ia_valid & ATTR_MTIME_SET) {
+			vattr.va_mask |=3D XFS_AT_MTIME;
+			vattr.va_mtime =3D attr->ia_mtime;
+		} else {
+			vattr.va_mask |=3D XFS_AT_UPDMTIME;
+		}
 	}
 	if (ia_valid & ATTR_CTIME) {
 		vattr.va_mask |=3D XFS_AT_CTIME;
@@ -674,8 +682,6 @@
 			inode->i_mode &=3D ~S_ISGID;
 	}
=20
-	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET))
-		flags |=3D ATTR_UTIME;
 #ifdef ATTR_NO_BLOCK
 	if ((ia_valid & ATTR_NO_BLOCK))
 		flags |=3D ATTR_NONBLOCK;
diff -ur xfs.orig/linux-2.6/xfs_vnode.h xfs/linux-2.6/xfs_vnode.h
--- xfs.orig/linux-2.6/xfs_vnode.h	2007-11-04 10:59:00.923480296 +0000
+++ xfs/linux-2.6/xfs_vnode.h	2007-11-04 11:01:33.338309720 +0000
@@ -270,7 +270,6 @@
 /*
  * Flags to vop_setattr/getattr.
  */
-#define	ATTR_UTIME	0x01	/* non-default utime(2) request */
 #define	ATTR_DMI	0x08	/* invocation from a DMI function */
 #define	ATTR_LAZY	0x80	/* set/get attributes lazily */
 #define	ATTR_NONBLOCK	0x100	/* return EAGAIN if operation would block */
diff -ur xfs.orig/xfs_vnodeops.c xfs/xfs_vnodeops.c
--- xfs.orig/xfs_vnodeops.c	2007-11-04 10:59:00.917481208 +0000
+++ xfs/xfs_vnodeops.c	2007-11-04 12:07:44.917537904 +0000
@@ -214,10 +214,10 @@
 {
 	bhv_vnode_t		*vp =3D XFS_ITOV(ip);
 	xfs_mount_t		*mp =3D ip->i_mount;
-	xfs_trans_t		*tp;
+	xfs_trans_t		*tp =3D NULL;
 	int			mask;
 	int			code;
-	uint			lock_flags;
+	uint			lock_flags=3D0;
 	uint			commit_flags=3D0;
 	uid_t			uid=3D0, iuid=3D0;
 	gid_t			gid=3D0, igid=3D0;
@@ -244,21 +244,51 @@
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
=20
+	olddquot1 =3D olddquot2 =3D NULL;
+	udqp =3D gdqp =3D NULL;
+
+	/*
+	 * Truncate is special because it changes the file as well as
+	 * the attributes.
+	 */
+	if (mask & XFS_AT_SIZE) {
+		/* Must have write permission and not be a directory. */
+		if (VN_ISDIR(vp)) {
+			code =3D XFS_ERROR(EISDIR);
+			goto error_return;
+		} else if (!VN_ISREG(vp)) {
+			code =3D XFS_ERROR(EINVAL);
+			goto error_return;
+		}
+		/*
+		 * Short circuit the truncate case for zero length files.
+		 */
+		if (vap->va_size =3D=3D 0) {
+			xfs_ilock(ip, XFS_ILOCK_EXCL);
+			if ((ip->i_size =3D=3D 0) && (ip->i_d.di_nextents =3D=3D 0)) {
+				mask |=3D XFS_AT_UPDCTIME|XFS_AT_UPDMTIME;
+				mask &=3D ~XFS_AT_SIZE;
+			}
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		}
+	}
+
 	/*
 	 * Timestamps do not need to be logged and hence do not
 	 * need to be done within a transaction.
 	 */
 	if (mask & XFS_AT_UPDTIMES) {
-		ASSERT((mask & ~XFS_AT_UPDTIMES) =3D=3D 0);
 		timeflags =3D ((mask & XFS_AT_UPDATIME) ? XFS_ICHGTIME_ACC : 0) |
 			    ((mask & XFS_AT_UPDCTIME) ? XFS_ICHGTIME_CHG : 0) |
 			    ((mask & XFS_AT_UPDMTIME) ? XFS_ICHGTIME_MOD : 0);
-		xfs_ichgtime(ip, timeflags);
-		return 0;
+		mask &=3D ~XFS_AT_UPDTIMES;
 	}
=20
-	olddquot1 =3D olddquot2 =3D NULL;
-	udqp =3D gdqp =3D NULL;
+	if (mask =3D=3D 0) {
+		if (timeflags && !(flags & ATTR_DMI))
+			xfs_ichgtime(ip, timeflags);
+		return 0;
+	}
=20
 	/*
 	 * If disk quotas is on, we make sure that the dquots do exist on disk,
@@ -307,12 +337,11 @@
 	 * For the other attributes, we acquire the inode lock and
 	 * first do an error checking pass.
 	 */
-	tp =3D NULL;
 	lock_flags =3D XFS_ILOCK_EXCL;
 	if (flags & ATTR_NOLOCK)
 		need_iolock =3D 0;
 	if (!(mask & XFS_AT_SIZE)) {
-		if ((mask !=3D (XFS_AT_CTIME|XFS_AT_ATIME|XFS_AT_MTIME)) ||
+		if ((mask & ~(XFS_AT_CTIME|XFS_AT_ATIME|XFS_AT_MTIME)) !=3D 0 ||
 		    (mp->m_flags & XFS_MOUNT_WSYNC)) {
 			tp =3D xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
 			commit_flags =3D 0;
@@ -451,24 +480,6 @@
 	 * Truncate file.  Must have write permission and not be a directory.
 	 */
 	if (mask & XFS_AT_SIZE) {
-		/* Short circuit the truncate case for zero length files */
-		if ((vap->va_size =3D=3D 0) &&
-		   (ip->i_size =3D=3D 0) && (ip->i_d.di_nextents =3D=3D 0)) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			lock_flags &=3D ~XFS_ILOCK_EXCL;
-			if (mask & XFS_AT_CTIME)
-				xfs_ichgtime(ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-			code =3D 0;
-			goto error_return;
-		}
-
-		if (VN_ISDIR(vp)) {
-			code =3D XFS_ERROR(EISDIR);
-			goto error_return;
-		} else if (!VN_ISREG(vp)) {
-			code =3D XFS_ERROR(EINVAL);
-			goto error_return;
-		}
 		/*
 		 * Make sure that the dquots are attached to the inode.
 		 */
@@ -481,8 +492,7 @@
 	 */
 	if (mask & (XFS_AT_ATIME|XFS_AT_MTIME)) {
 		if (!file_owner) {
-			if ((flags & ATTR_UTIME) &&
-			    !capable(CAP_FOWNER)) {
+			if (!capable(CAP_FOWNER)) {
 				code =3D XFS_ERROR(EPERM);
 				goto error_return;
 			}
@@ -760,7 +770,7 @@
 			timeflags &=3D ~XFS_ICHGTIME_MOD;
 			timeflags |=3D XFS_ICHGTIME_CHG;
 		}
-		if (tp && (flags & ATTR_UTIME))
+		if (tp)
 			xfs_trans_log_inode (tp, ip, XFS_ILOG_CORE);
 	}
=20

------=_NextPart_000_0645_01C81EDA.353308E0--
