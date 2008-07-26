Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Jul 2008 23:33:10 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q6Wbs9002440
	for <xfs@oss.sgi.com>; Fri, 25 Jul 2008 23:32:38 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 557DC192E570
	for <xfs@oss.sgi.com>; Fri, 25 Jul 2008 23:33:48 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Qa2gNNVjMyhb388M for <xfs@oss.sgi.com>; Fri, 25 Jul 2008 23:33:48 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6Q6XdNg022939
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 08:33:39 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6Q6XdeU022937
	for xfs@oss.sgi.com; Sat, 26 Jul 2008 08:33:39 +0200
Date: Sat, 26 Jul 2008 08:33:39 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] stop using file_update_time
Message-ID: <20080726063339.GC22603@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_ichtime updates the xfs_inode and Linux inode timestamps just fine,
no need to call file_update_time and then copy the values over to the
XFS inode.  The only additional thing in file_update_time are checks
not applicable to the write path.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-07-24 08:37:09.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-07-24 08:37:18.000000000 +0200
@@ -134,52 +134,6 @@ xfs_ichgtime(
 }
 
 /*
- * Variant on the above which avoids querying the system clock
- * in situations where we know the Linux inode timestamps have
- * just been updated (and so we can update our inode cheaply).
- */
-void
-xfs_ichgtime_fast(
-	xfs_inode_t	*ip,
-	struct inode	*inode,
-	int		flags)
-{
-	timespec_t	*tvp;
-
-	/*
-	 * We're not supposed to change timestamps in readonly-mounted
-	 * filesystems.  Throw it away if anyone asks us.
-	 */
-	if (unlikely(IS_RDONLY(inode)))
-		return;
-
-	if (flags & XFS_ICHGTIME_MOD) {
-		tvp = &inode->i_mtime;
-		ip->i_d.di_mtime.t_sec = (__int32_t)tvp->tv_sec;
-		ip->i_d.di_mtime.t_nsec = (__int32_t)tvp->tv_nsec;
-	}
-	if (flags & XFS_ICHGTIME_CHG) {
-		tvp = &inode->i_ctime;
-		ip->i_d.di_ctime.t_sec = (__int32_t)tvp->tv_sec;
-		ip->i_d.di_ctime.t_nsec = (__int32_t)tvp->tv_nsec;
-	}
-
-	/*
-	 * We update the i_update_core field _after_ changing
-	 * the timestamps in order to coordinate properly with
-	 * xfs_iflush() so that we don't lose timestamp updates.
-	 * This keeps us from having to hold the inode lock
-	 * while doing this.  We use the SYNCHRONIZE macro to
-	 * ensure that the compiler does not reorder the update
-	 * of i_update_core above the timestamp updates above.
-	 */
-	SYNCHRONIZE();
-	ip->i_update_core = 1;
-	if (!(inode->i_state & I_NEW))
-		mark_inode_dirty_sync(inode);
-}
-
-/*
  * Hook in SELinux.  This is not quite correct yet, what we really need
  * here (as we do for default ACLs) is a mechanism by which creation of
  * these attrs can be journalled at inode creation time (along with the
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.h	2008-07-24 08:37:09.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.h	2008-07-24 08:37:40.000000000 +0200
@@ -26,9 +26,6 @@ extern const struct file_operations xfs_
 
 extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 
-extern void xfs_ichgtime(struct xfs_inode *, int);
-extern void xfs_ichgtime_fast(struct xfs_inode *, struct inode *, int);
-
 extern void xfs_setup_inode(struct xfs_inode *);
 
 #endif /* __XFS_IOPS_H__ */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2008-07-24 08:37:09.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2008-07-24 08:37:18.000000000 +0200
@@ -667,11 +667,8 @@ start:
 	if (new_size > xip->i_size)
 		xip->i_new_size = new_size;
 
-	if (likely(!(ioflags & IO_INVIS))) {
-		file_update_time(file);
-		xfs_ichgtime_fast(xip, inode,
-				  XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	}
+	if (likely(!(ioflags & IO_INVIS)))
+		xfs_ichgtime(xip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
 	/*
 	 * If the offset is beyond the size of the file, we have a couple
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-07-24 08:37:09.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-07-24 08:37:18.000000000 +0200
@@ -294,7 +294,6 @@ EXPORT_SYMBOL(xfs_dinode_from_disk);
 EXPORT_SYMBOL(xfs_sb_from_disk);
 EXPORT_SYMBOL(xfs_zero_eof);
 EXPORT_SYMBOL(xlog_recover_process_iunlinks);
-EXPORT_SYMBOL(xfs_ichgtime_fast);
 EXPORT_SYMBOL(xfs_free_eofblocks);
 
 EXPORT_SYMBOL(xfs_do_force_shutdown);
