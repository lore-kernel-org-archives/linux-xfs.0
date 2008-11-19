Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAJ4nsa7029984 for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 22:49:54 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36027159E75F
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 20:49:49 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id DZVay3YMQAAkYDw2 for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2008 20:49:49 -0800 (PST)
Message-Id: <20081119044909.622123679@sandeen.net>
References: <20081119044401.573365619@sandeen.net>
Date: Tue, 18 Nov 2008 22:44:07 -0600
From: sandeen@sandeen.net
Subject: [patch 06/11] Fix xfs_bulkstat_one size checks & error handling
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
Cc: hch@infradead.org

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
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -211,13 +211,18 @@ xfs_bstime_store_compat(
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
 	compat_xfs_bstat_t __user *p32 = ubuffer;
 
+	if (ubsize < sizeof(*p32))
+		return XFS_ERROR(ENOMEM);
 	if (put_user(buffer->bs_ino, &p32->bs_ino) ||
 	    put_user(buffer->bs_mode, &p32->bs_mode) ||
 	    put_user(buffer->bs_nlink, &p32->bs_nlink) ||
@@ -238,8 +243,10 @@ xfs_bulkstat_one_fmt_compat(
 	    put_user(buffer->bs_dmevmask, &p32->bs_dmevmask) ||
 	    put_user(buffer->bs_dmstate, &p32->bs_dmstate) ||
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
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.c
+++ linux-2.6-xfs/fs/xfs/xfs_itable.c
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
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.h
+++ linux-2.6-xfs/fs/xfs/xfs_itable.h
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
