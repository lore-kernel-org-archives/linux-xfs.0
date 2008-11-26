Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ3L16j000919 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 21:21:01 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A08315FDB31
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:21:00 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id 0kA22J9iGDadIzHK for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 19:21:00 -0800 (PST)
Message-Id: <20081126032028.571084174@sandeen.net>
References: <20081126032005.639750968@sandeen.net>
Date: Tue, 25 Nov 2008 21:20:12 -0600
From: sandeen@sandeen.net
Subject: [patch 07/12] Fix xfs_bulkstat_one size checks & error handling
Content-Disposition: inline; filename=bulkstat_one_size_and_error_fixes
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

The 32-bit xfs_blkstat_one handler was failing because
a size check checked whether the remaining (32-bit)
user buffer was less than the (64-bit) bulkstat buffer,
and failed with ENOMEM if so.  Move this check
into the respective handlers so that they check the
correct sizes.

Also, the formatters were returning negative errors
or positive bytes copied; this was odd in the positive
error value world of xfs, and handled wrong by at least
some of the callers, which treated the bytes returned
as an error value.  Move the bytes-used assignment
into the formatters.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:00:30.163063933 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:09:27.181063641 -0600
@@ -193,35 +193,43 @@ xfs_bstime_store_compat(
 	return 0;
 }
 
+/* Return 0 on success or positive error (to xfs_bulkstat()) */
 STATIC int
 xfs_bulkstat_one_fmt_compat(
 	void			__user *ubuffer,
+	int			ubsize,
+	int			*ubused,
 	const xfs_bstat_t	*buffer)
 {
 	compat_xfs_bstat_t	__user *p32 = ubuffer;
 
-	if (put_user(buffer->bs_ino, &p32->bs_ino) ||
-	    put_user(buffer->bs_mode, &p32->bs_mode) ||
-	    put_user(buffer->bs_nlink, &p32->bs_nlink) ||
-	    put_user(buffer->bs_uid, &p32->bs_uid) ||
-	    put_user(buffer->bs_gid, &p32->bs_gid) ||
-	    put_user(buffer->bs_rdev, &p32->bs_rdev) ||
-	    put_user(buffer->bs_blksize, &p32->bs_blksize) ||
-	    put_user(buffer->bs_size, &p32->bs_size) ||
+	if (ubsize < sizeof(*p32))
+		return XFS_ERROR(ENOMEM);
+
+	if (put_user(buffer->bs_ino,	  &p32->bs_ino)		||
+	    put_user(buffer->bs_mode,	  &p32->bs_mode)	||
+	    put_user(buffer->bs_nlink,	  &p32->bs_nlink)	||
+	    put_user(buffer->bs_uid,	  &p32->bs_uid)		||
+	    put_user(buffer->bs_gid,	  &p32->bs_gid)		||
+	    put_user(buffer->bs_rdev,	  &p32->bs_rdev)	||
+	    put_user(buffer->bs_blksize,  &p32->bs_blksize)	||
+	    put_user(buffer->bs_size,	  &p32->bs_size)	||
 	    xfs_bstime_store_compat(&p32->bs_atime, &buffer->bs_atime) ||
 	    xfs_bstime_store_compat(&p32->bs_mtime, &buffer->bs_mtime) ||
 	    xfs_bstime_store_compat(&p32->bs_ctime, &buffer->bs_ctime) ||
-	    put_user(buffer->bs_blocks, &p32->bs_blocks) ||
-	    put_user(buffer->bs_xflags, &p32->bs_xflags) ||
-	    put_user(buffer->bs_extsize, &p32->bs_extsize) ||
-	    put_user(buffer->bs_extents, &p32->bs_extents) ||
-	    put_user(buffer->bs_gen, &p32->bs_gen) ||
-	    put_user(buffer->bs_projid, &p32->bs_projid) ||
-	    put_user(buffer->bs_dmevmask, &p32->bs_dmevmask) ||
-	    put_user(buffer->bs_dmstate, &p32->bs_dmstate) ||
+	    put_user(buffer->bs_blocks,	  &p32->bs_blocks)	||
+	    put_user(buffer->bs_xflags,	  &p32->bs_xflags)	||
+	    put_user(buffer->bs_extsize,  &p32->bs_extsize)	||
+	    put_user(buffer->bs_extents,  &p32->bs_extents)	||
+	    put_user(buffer->bs_gen,	  &p32->bs_gen)		||
+	    put_user(buffer->bs_projid,	  &p32->bs_projid)	||
+	    put_user(buffer->bs_dmevmask, &p32->bs_dmevmask)	||
+	    put_user(buffer->bs_dmstate,  &p32->bs_dmstate)	||
 	    put_user(buffer->bs_aextents, &p32->bs_aextents))
-		return -XFS_ERROR(EFAULT);
-	return sizeof(*p32);
+		return XFS_ERROR(EFAULT);
+	if (ubused)
+		*ubused = sizeof(*p32);
+	return 0;
 }
 
 STATIC int
Index: linux-2.6-xfs/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.c	2008-11-24 17:00:30.168063416 -0600
+++ linux-2.6-xfs/fs/xfs/xfs_itable.c	2008-11-24 17:00:30.493043269 -0600
@@ -192,14 +192,21 @@ xfs_bulkstat_one_dinode(
 	}
 }
 
+/* Return 0 on success or positive error */
 STATIC int
 xfs_bulkstat_one_fmt(
 	void			__user *ubuffer,
+	int			ubsize,
+	int			*ubused,
 	const xfs_bstat_t	*buffer)
 {
+	if (ubsize < sizeof(*buffer))
+		return XFS_ERROR(ENOMEM);
 	if (copy_to_user(ubuffer, buffer, sizeof(*buffer)))
-		return -EFAULT;
-	return sizeof(*buffer);
+		return XFS_ERROR(EFAULT);
+	if (ubused)
+		*ubused = sizeof(*buffer);
+	return 0;
 }
 
 /*
@@ -227,8 +234,6 @@ xfs_bulkstat_one_int(
 
 	if (!buffer || xfs_internal_inum(mp, ino))
 		return XFS_ERROR(EINVAL);
-	if (ubsize < sizeof(*buf))
-		return XFS_ERROR(ENOMEM);
 
 	buf = kmem_alloc(sizeof(*buf), KM_SLEEP);
 
@@ -243,15 +248,11 @@ xfs_bulkstat_one_int(
 		xfs_bulkstat_one_dinode(mp, ino, dip, buf);
 	}
 
-	error = formatter(buffer, buf);
-	if (error < 0)  {
-		error = EFAULT;
+	error = formatter(buffer, ubsize, ubused, buf);
+	if (error)
 		goto out_free;
-	}
 
 	*stat = BULKSTAT_RV_DIDONE;
-	if (ubused)
-		*ubused = error;
 
  out_free:
 	kmem_free(buf);
Index: linux-2.6-xfs/fs/xfs/xfs_itable.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.h	2008-11-24 17:00:30.184607623 -0600
+++ linux-2.6-xfs/fs/xfs/xfs_itable.h	2008-11-24 17:00:30.509626060 -0600
@@ -71,6 +71,8 @@ xfs_bulkstat_single(
 
 typedef int (*bulkstat_one_fmt_pf)(  /* used size in bytes or negative error */
 	void			__user *ubuffer, /* buffer to write to */
+	int			ubsize,		 /* remaining user buffer sz */
+	int			*ubused,	 /* bytes used by formatter */
 	const xfs_bstat_t	*buffer);        /* buffer to read from */
 
 int

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
