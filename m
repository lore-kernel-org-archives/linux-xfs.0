Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 May 2008 23:02:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4C61krN031578
	for <xfs@oss.sgi.com>; Sun, 11 May 2008 23:01:46 -0700
Date: Mon, 12 May 2008 08:02:22 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/10] sort out opening and closing of the block devices
Message-ID: <20080512060222.GA15488@lst.de>
References: <20080501220105.GD2315@lst.de> <20080512020421.GW155679365@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512020421.GW155679365@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, May 12, 2008 at 12:04:21PM +1000, David Chinner wrote:
> error needs to be set to something here.

Fixed.

> > + out_free_rtdev_targ:
> > +	if (mp->m_rtdev_targp)
> > +		xfs_free_buftarg(mp->m_rtdev_targp);
> > + out_free_ddev_targ:
> > +	xfs_free_buftarg(mp->m_ddev_targp);
> > + out_close_rtdev:
> > +	if (mp->m_rtdev_targp)
> > +		xfs_blkdev_put(mp->m_rtdev_targp->bt_bdev);
> 
> And that looks broken - we either haven't allocated m_rtdev_targp
> yet or we've freed it above.

Yeah, we should just use the local struct block_device pointers here
(and for the logdev case just below)

> incremental patch to fix is fine...

But in the days of quit a new one is much easier :)

New patch below:


Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-12 07:45:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-12 08:00:10.000000000 +0200
@@ -766,6 +766,103 @@ xfs_blkdev_issue_flush(
 	blkdev_issue_flush(buftarg->bt_bdev, NULL);
 }
 
+STATIC void
+xfs_close_devices(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
+		xfs_free_buftarg(mp->m_logdev_targp);
+		xfs_blkdev_put(mp->m_logdev_targp->bt_bdev);
+	}
+	if (mp->m_rtdev_targp) {
+		xfs_free_buftarg(mp->m_rtdev_targp);
+		xfs_blkdev_put(mp->m_rtdev_targp->bt_bdev);
+	}
+	xfs_free_buftarg(mp->m_ddev_targp);
+}
+
+/*
+ * The file system configurations are:
+ *	(1) device (partition) with data and internal log
+ *	(2) logical volume with data and log subvolumes.
+ *	(3) logical volume with data, log, and realtime subvolumes.
+ *
+ * We only have to handle opening the log and realtime volumes here if
+ * they are present.  The data subvolume has already been opened by
+ * get_sb_bdev() and is stored in sb->s_bdev.
+ */
+STATIC int
+xfs_open_devices(
+	struct xfs_mount	*mp,
+	struct xfs_mount_args	*args)
+{
+	struct block_device	*ddev = mp->m_super->s_bdev;
+	struct block_device	*logdev = NULL, *rtdev = NULL;
+	int			error;
+
+	/*
+	 * Open real time and log devices - order is important.
+	 */
+	if (args->logname[0]) {
+		error = xfs_blkdev_get(mp, args->logname, &logdev);
+		if (error)
+			goto out;
+	}
+
+	if (args->rtname[0]) {
+		error = xfs_blkdev_get(mp, args->rtname, &rtdev);
+		if (error)
+			goto out_close_logdev;
+
+		if (rtdev == ddev || rtdev == logdev) {
+			cmn_err(CE_WARN,
+	"XFS: Cannot mount filesystem with identical rtdev and ddev/logdev.");
+			error = EINVAL;
+			goto out_close_rtdev;
+		}
+	}
+
+	/*
+	 * Setup xfs_mount buffer target pointers
+	 */
+	error = ENOMEM;
+	mp->m_ddev_targp = xfs_alloc_buftarg(ddev, 0);
+	if (!mp->m_ddev_targp)
+		goto out_close_rtdev;
+
+	if (rtdev) {
+		mp->m_rtdev_targp = xfs_alloc_buftarg(rtdev, 1);
+		if (!mp->m_rtdev_targp)
+			goto out_free_ddev_targ;
+	}
+
+	if (logdev && logdev != ddev) {
+		mp->m_logdev_targp = xfs_alloc_buftarg(logdev, 1);
+		if (!mp->m_logdev_targp)
+			goto out_free_rtdev_targ;
+	} else {
+		mp->m_logdev_targp = mp->m_ddev_targp;
+	}
+
+	return 0;
+
+ out_free_rtdev_targ:
+	if (mp->m_rtdev_targp)
+		xfs_free_buftarg(mp->m_rtdev_targp);
+ out_free_ddev_targ:
+	xfs_free_buftarg(mp->m_ddev_targp);
+ out_close_rtdev:
+	if (rtdev)
+		xfs_blkdev_put(rtdev);
+ out_close_logdev:
+	if (logdev && logdev != ddev)
+		xfs_blkdev_put(logdev);
+ out:
+	return error;
+}
+
+
+
 /*
  * XFS AIL push thread support
  */
@@ -1139,7 +1236,8 @@ xfs_fs_put_super(
 				unmount_event_flags);
 	}
 
-	xfs_unmountfs(mp, NULL);
+	xfs_unmountfs(mp);
+	xfs_close_devices(mp);
 	xfs_qmops_put(mp);
 	xfs_dmops_put(mp);
 	kmem_free(mp);
@@ -1586,16 +1684,6 @@ xfs_finish_flags(
 	return 0;
 }
 
-/*
- * The file system configurations are:
- *	(1) device (partition) with data and internal log
- *	(2) logical volume with data and log subvolumes.
- *	(3) logical volume with data, log, and realtime subvolumes.
- *
- * We only have to handle opening the log and realtime volumes here if
- * they are present.  The data subvolume has already been opened by
- * get_sb_bdev() and is stored in vfsp->vfs_super->s_bdev.
- */
 STATIC int
 xfs_fs_fill_super(
 	struct super_block	*sb,
@@ -1605,8 +1693,6 @@ xfs_fs_fill_super(
 	struct inode		*root;
 	struct xfs_mount	*mp = NULL;
 	struct xfs_mount_args	*args = xfs_args_allocate(sb, silent);
-	struct block_device	*ddev = sb->s_bdev;
-	struct block_device	*logdev = NULL, *rtdev = NULL;
 	int			flags = 0, error;
 
 	mp = xfs_mount_init();
@@ -1636,61 +1722,14 @@ xfs_fs_fill_super(
 		goto fail_vfsop;
 	error = xfs_qmops_get(mp, args);
 	if (error)
-		goto fail_vfsop;
+		goto out_put_dmops;
 
 	if (args->flags & XFSMNT_QUIET)
 		flags |= XFS_MFSI_QUIET;
 
-	/*
-	 * Open real time and log devices - order is important.
-	 */
-	if (args->logname[0]) {
-		error = xfs_blkdev_get(mp, args->logname, &logdev);
-		if (error)
-			goto fail_vfsop;
-	}
-	if (args->rtname[0]) {
-		error = xfs_blkdev_get(mp, args->rtname, &rtdev);
-		if (error) {
-			xfs_blkdev_put(logdev);
-			goto fail_vfsop;
-		}
-
-		if (rtdev == ddev || rtdev == logdev) {
-			cmn_err(CE_WARN,
-	"XFS: Cannot mount filesystem with identical rtdev and ddev/logdev.");
-			xfs_blkdev_put(logdev);
-			xfs_blkdev_put(rtdev);
-			error = EINVAL;
-			goto fail_vfsop;
-		}
-	}
-
-	/*
-	 * Setup xfs_mount buffer target pointers
-	 */
-	error = ENOMEM;
-	mp->m_ddev_targp = xfs_alloc_buftarg(ddev, 0);
-	if (!mp->m_ddev_targp) {
-		xfs_blkdev_put(logdev);
-		xfs_blkdev_put(rtdev);
-		goto fail_vfsop;
-	}
-	if (rtdev) {
-		mp->m_rtdev_targp = xfs_alloc_buftarg(rtdev, 1);
-		if (!mp->m_rtdev_targp) {
-			xfs_blkdev_put(logdev);
-			xfs_blkdev_put(rtdev);
-			goto error0;
-		}
-	}
-	mp->m_logdev_targp = (logdev && logdev != ddev) ?
-				xfs_alloc_buftarg(logdev, 1) : mp->m_ddev_targp;
-	if (!mp->m_logdev_targp) {
-		xfs_blkdev_put(logdev);
-		xfs_blkdev_put(rtdev);
-		goto error0;
-	}
+	error = xfs_open_devices(mp, args);
+	if (error)
+		goto out_put_qmops;
 
 	/*
 	 * Setup flags based on mount(2) options and then the superblock
@@ -1710,7 +1749,9 @@ xfs_fs_fill_super(
 	 */
 	error = xfs_setsize_buftarg(mp->m_ddev_targp, mp->m_sb.sb_blocksize,
 				    mp->m_sb.sb_sectsize);
-	if (!error && logdev && logdev != ddev) {
+	if (error)
+		goto error2;
+	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
 		unsigned int	log_sector_size = BBSIZE;
 
 		if (xfs_sb_version_hassector(&mp->m_sb))
@@ -1718,13 +1759,16 @@ xfs_fs_fill_super(
 		error = xfs_setsize_buftarg(mp->m_logdev_targp,
 					    mp->m_sb.sb_blocksize,
 					    log_sector_size);
+		if (error)
+			goto error2;
 	}
-	if (!error && rtdev)
+	if (mp->m_rtdev_targp) {
 		error = xfs_setsize_buftarg(mp->m_rtdev_targp,
 					    mp->m_sb.sb_blocksize,
 					    mp->m_sb.sb_sectsize);
-	if (error)
-		goto error2;
+		if (error)
+			goto error2;
+	}
 
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
 		xfs_mountfs_check_barriers(mp);
@@ -1780,13 +1824,14 @@ xfs_fs_fill_super(
 		xfs_freesb(mp);
  error1:
 	xfs_binval(mp->m_ddev_targp);
-	if (logdev && logdev != ddev)
+	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_binval(mp->m_logdev_targp);
-	if (rtdev)
+	if (mp->m_rtdev_targp)
 		xfs_binval(mp->m_rtdev_targp);
- error0:
-	xfs_unmountfs_close(mp, NULL);
+	xfs_close_devices(mp);
+ out_put_qmops:
 	xfs_qmops_put(mp);
+ out_put_dmops:
 	xfs_dmops_put(mp);
 	goto fail_vfsop;
 
@@ -1812,7 +1857,8 @@ xfs_fs_fill_super(
 
 	IRELE(mp->m_rootip);
 
-	xfs_unmountfs(mp, NULL);
+	xfs_unmountfs(mp);
+	xfs_close_devices(mp);
 	xfs_qmops_put(mp);
 	xfs_dmops_put(mp);
 	kmem_free(mp);
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-05-12 07:45:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-05-12 07:45:05.000000000 +0200
@@ -1278,7 +1278,7 @@ xfs_mountfs(
  * log and makes sure that incore structures are freed.
  */
 int
-xfs_unmountfs(xfs_mount_t *mp, struct cred *cr)
+xfs_unmountfs(xfs_mount_t *mp)
 {
 	__uint64_t	resblks;
 	int		error = 0;
@@ -1345,7 +1345,6 @@ xfs_unmountfs(xfs_mount_t *mp, struct cr
 	 */
 	ASSERT(mp->m_inodes == NULL);
 
-	xfs_unmountfs_close(mp, cr);
 	if ((mp->m_flags & XFS_MOUNT_NOUUID) == 0)
 		uuid_table_remove(&mp->m_sb.sb_uuid);
 
@@ -1356,16 +1355,6 @@ xfs_unmountfs(xfs_mount_t *mp, struct cr
 	return 0;
 }
 
-void
-xfs_unmountfs_close(xfs_mount_t *mp, struct cred *cr)
-{
-	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
-		xfs_free_buftarg(mp->m_logdev_targp, 1);
-	if (mp->m_rtdev_targp)
-		xfs_free_buftarg(mp->m_rtdev_targp, 1);
-	xfs_free_buftarg(mp->m_ddev_targp, 0);
-}
-
 STATIC void
 xfs_unmountfs_wait(xfs_mount_t *mp)
 {
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-05-12 07:45:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-05-12 07:45:05.000000000 +0200
@@ -518,8 +518,7 @@ extern void	xfs_mount_free(xfs_mount_t *
 extern int	xfs_mountfs(xfs_mount_t *mp, int);
 extern void	xfs_mountfs_check_barriers(xfs_mount_t *mp);
 
-extern int	xfs_unmountfs(xfs_mount_t *, struct cred *);
-extern void	xfs_unmountfs_close(xfs_mount_t *, struct cred *);
+extern int	xfs_unmountfs(xfs_mount_t *);
 extern int	xfs_unmountfs_writesb(xfs_mount_t *);
 extern int	xfs_unmount_flush(xfs_mount_t *, int);
 extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.h	2008-05-12 07:45:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h	2008-05-12 07:45:05.000000000 +0200
@@ -78,9 +78,6 @@ extern void xfs_initialize_vnode(struct 
 extern void xfs_flush_inode(struct xfs_inode *);
 extern void xfs_flush_device(struct xfs_inode *);
 
-extern int  xfs_blkdev_get(struct xfs_mount *, const char *,
-				struct block_device **);
-extern void xfs_blkdev_put(struct block_device *);
 extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
 
 extern const struct export_operations xfs_export_operations;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2008-05-12 07:45:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c	2008-05-12 07:45:05.000000000 +0200
@@ -1412,13 +1412,10 @@ xfs_unregister_buftarg(
 
 void
 xfs_free_buftarg(
-	xfs_buftarg_t		*btp,
-	int			external)
+	xfs_buftarg_t		*btp)
 {
 	xfs_flush_buftarg(btp, 1);
 	xfs_blkdev_issue_flush(btp);
-	if (external)
-		xfs_blkdev_put(btp->bt_bdev);
 	xfs_free_bufhash(btp);
 	iput(btp->bt_mapping->host);
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2008-05-12 07:45:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h	2008-05-12 07:45:05.000000000 +0200
@@ -410,7 +410,7 @@ static inline void xfs_bdwrite(void *mp,
  *	Handling of buftargs.
  */
 extern xfs_buftarg_t *xfs_alloc_buftarg(struct block_device *, int);
-extern void xfs_free_buftarg(xfs_buftarg_t *, int);
+extern void xfs_free_buftarg(xfs_buftarg_t *);
 extern void xfs_wait_buftarg(xfs_buftarg_t *);
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
 extern int xfs_flush_buftarg(xfs_buftarg_t *, int);
