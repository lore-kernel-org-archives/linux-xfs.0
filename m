Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 15:00:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m41M0Khe001241
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 15:00:25 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2743F12ACED5
	for <xfs@oss.sgi.com>; Thu,  1 May 2008 15:01:01 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id iKrLYgxTkmDx3Ru4 for <xfs@oss.sgi.com>; Thu, 01 May 2008 15:01:01 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m41M0sF3002363
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 00:00:54 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m41M0sXZ002361
	for xfs@oss.sgi.com; Fri, 2 May 2008 00:00:54 +0200
Date: Fri, 2 May 2008 00:00:54 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/10] merge xfs_mount into xfs_fs_fill_super
Message-ID: <20080501220054.GB2315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_mount is already pretty linux-specific so merge it into
xfs_fs_fill_super to allow for a more structured mount code in the next
patches. xfs_start_flags and xfs_finish_flags also move to xfs_super.c.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.h	2008-05-01 19:06:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.h	2008-05-01 19:08:41.000000000 +0200
@@ -8,8 +8,6 @@ struct kstatfs;
 struct xfs_mount;
 struct xfs_mount_args;
 
-int xfs_mount(struct xfs_mount *mp, struct xfs_mount_args *args,
-		struct cred *credp);
 int xfs_sync(struct xfs_mount *mp, int flags);
 void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 		int lnnum);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-01 19:08:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-01 19:28:51.000000000 +0200
@@ -1367,6 +1367,235 @@ xfs_fs_setxquota(
 				   Q_XSETPQLIM), id, (caddr_t)fdq);
 }
 
+/*
+ * This function fills in xfs_mount_t fields based on mount args.
+ * Note: the superblock has _not_ yet been read in.
+ */
+STATIC int
+xfs_start_flags(
+	struct xfs_mount_args	*ap,
+	struct xfs_mount	*mp)
+{
+	/* Values are in BBs */
+	if ((ap->flags & XFSMNT_NOALIGN) != XFSMNT_NOALIGN) {
+		/*
+		 * At this point the superblock has not been read
+		 * in, therefore we do not know the block size.
+		 * Before the mount call ends we will convert
+		 * these to FSBs.
+		 */
+		mp->m_dalign = ap->sunit;
+		mp->m_swidth = ap->swidth;
+	}
+
+	if (ap->logbufs != -1 &&
+	    ap->logbufs != 0 &&
+	    (ap->logbufs < XLOG_MIN_ICLOGS ||
+	     ap->logbufs > XLOG_MAX_ICLOGS)) {
+		cmn_err(CE_WARN,
+			"XFS: invalid logbufs value: %d [not %d-%d]",
+			ap->logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
+		return XFS_ERROR(EINVAL);
+	}
+	mp->m_logbufs = ap->logbufs;
+	if (ap->logbufsize != -1 &&
+	    ap->logbufsize !=  0 &&
+	    (ap->logbufsize < XLOG_MIN_RECORD_BSIZE ||
+	     ap->logbufsize > XLOG_MAX_RECORD_BSIZE ||
+	     !is_power_of_2(ap->logbufsize))) {
+		cmn_err(CE_WARN,
+	"XFS: invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
+			ap->logbufsize);
+		return XFS_ERROR(EINVAL);
+	}
+	mp->m_logbsize = ap->logbufsize;
+	mp->m_fsname_len = strlen(ap->fsname) + 1;
+	mp->m_fsname = kmem_alloc(mp->m_fsname_len, KM_SLEEP);
+	strcpy(mp->m_fsname, ap->fsname);
+	if (ap->rtname[0]) {
+		mp->m_rtname = kmem_alloc(strlen(ap->rtname) + 1, KM_SLEEP);
+		strcpy(mp->m_rtname, ap->rtname);
+	}
+	if (ap->logname[0]) {
+		mp->m_logname = kmem_alloc(strlen(ap->logname) + 1, KM_SLEEP);
+		strcpy(mp->m_logname, ap->logname);
+	}
+
+	if (ap->flags & XFSMNT_WSYNC)
+		mp->m_flags |= XFS_MOUNT_WSYNC;
+#if XFS_BIG_INUMS
+	if (ap->flags & XFSMNT_INO64) {
+		mp->m_flags |= XFS_MOUNT_INO64;
+		mp->m_inoadd = XFS_INO64_OFFSET;
+	}
+#endif
+	if (ap->flags & XFSMNT_RETERR)
+		mp->m_flags |= XFS_MOUNT_RETERR;
+	if (ap->flags & XFSMNT_NOALIGN)
+		mp->m_flags |= XFS_MOUNT_NOALIGN;
+	if (ap->flags & XFSMNT_SWALLOC)
+		mp->m_flags |= XFS_MOUNT_SWALLOC;
+	if (ap->flags & XFSMNT_OSYNCISOSYNC)
+		mp->m_flags |= XFS_MOUNT_OSYNCISOSYNC;
+	if (ap->flags & XFSMNT_32BITINODES)
+		mp->m_flags |= XFS_MOUNT_32BITINODES;
+
+	if (ap->flags & XFSMNT_IOSIZE) {
+		if (ap->iosizelog > XFS_MAX_IO_LOG ||
+		    ap->iosizelog < XFS_MIN_IO_LOG) {
+			cmn_err(CE_WARN,
+		"XFS: invalid log iosize: %d [not %d-%d]",
+				ap->iosizelog, XFS_MIN_IO_LOG,
+				XFS_MAX_IO_LOG);
+			return XFS_ERROR(EINVAL);
+		}
+
+		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
+		mp->m_readio_log = mp->m_writeio_log = ap->iosizelog;
+	}
+
+	if (ap->flags & XFSMNT_IKEEP)
+		mp->m_flags |= XFS_MOUNT_IKEEP;
+	if (ap->flags & XFSMNT_DIRSYNC)
+		mp->m_flags |= XFS_MOUNT_DIRSYNC;
+	if (ap->flags & XFSMNT_ATTR2)
+		mp->m_flags |= XFS_MOUNT_ATTR2;
+	if (ap->flags & XFSMNT_NOATTR2)
+		mp->m_flags |= XFS_MOUNT_NOATTR2;
+
+	if (ap->flags2 & XFSMNT2_COMPAT_IOSIZE)
+		mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+
+	/*
+	 * no recovery flag requires a read-only mount
+	 */
+	if (ap->flags & XFSMNT_NORECOVERY) {
+		if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+			cmn_err(CE_WARN,
+	"XFS: tried to mount a FS read-write without recovery!");
+			return XFS_ERROR(EINVAL);
+		}
+		mp->m_flags |= XFS_MOUNT_NORECOVERY;
+	}
+
+	if (ap->flags & XFSMNT_NOUUID)
+		mp->m_flags |= XFS_MOUNT_NOUUID;
+	if (ap->flags & XFSMNT_BARRIER)
+		mp->m_flags |= XFS_MOUNT_BARRIER;
+	else
+		mp->m_flags &= ~XFS_MOUNT_BARRIER;
+
+	if (ap->flags2 & XFSMNT2_FILESTREAMS)
+		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
+
+	if (ap->flags & XFSMNT_DMAPI)
+		mp->m_flags |= XFS_MOUNT_DMAPI;
+	return 0;
+}
+
+/*
+ * This function fills in xfs_mount_t fields based on mount args.
+ * Note: the superblock _has_ now been read in.
+ */
+STATIC int
+xfs_finish_flags(
+	struct xfs_mount_args	*ap,
+	struct xfs_mount	*mp)
+{
+	int			ronly = (mp->m_flags & XFS_MOUNT_RDONLY);
+
+	/* Fail a mount where the logbuf is smaller then the log stripe */
+	if (xfs_sb_version_haslogv2(&mp->m_sb)) {
+		if ((ap->logbufsize <= 0) &&
+		    (mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE)) {
+			mp->m_logbsize = mp->m_sb.sb_logsunit;
+		} else if (ap->logbufsize > 0 &&
+			   ap->logbufsize < mp->m_sb.sb_logsunit) {
+			cmn_err(CE_WARN,
+	"XFS: logbuf size must be greater than or equal to log stripe size");
+			return XFS_ERROR(EINVAL);
+		}
+	} else {
+		/* Fail a mount if the logbuf is larger than 32K */
+		if (ap->logbufsize > XLOG_BIG_RECORD_BSIZE) {
+			cmn_err(CE_WARN,
+	"XFS: logbuf size for version 1 logs must be 16K or 32K");
+			return XFS_ERROR(EINVAL);
+		}
+	}
+
+	/*
+	 * mkfs'ed attr2 will turn on attr2 mount unless explicitly
+	 * told by noattr2 to turn it off
+	 */
+	if (xfs_sb_version_hasattr2(&mp->m_sb) &&
+	    !(ap->flags & XFSMNT_NOATTR2))
+		mp->m_flags |= XFS_MOUNT_ATTR2;
+
+	/*
+	 * prohibit r/w mounts of read-only filesystems
+	 */
+	if ((mp->m_sb.sb_flags & XFS_SBF_READONLY) && !ronly) {
+		cmn_err(CE_WARN,
+	"XFS: cannot mount a read-only filesystem as read-write");
+		return XFS_ERROR(EROFS);
+	}
+
+	/*
+	 * check for shared mount.
+	 */
+	if (ap->flags & XFSMNT_SHARED) {
+		if (!xfs_sb_version_hasshared(&mp->m_sb))
+			return XFS_ERROR(EINVAL);
+
+		/*
+		 * For IRIX 6.5, shared mounts must have the shared
+		 * version bit set, have the persistent readonly
+		 * field set, must be version 0 and can only be mounted
+		 * read-only.
+		 */
+		if (!ronly || !(mp->m_sb.sb_flags & XFS_SBF_READONLY) ||
+		     (mp->m_sb.sb_shared_vn != 0))
+			return XFS_ERROR(EINVAL);
+
+		mp->m_flags |= XFS_MOUNT_SHARED;
+
+		/*
+		 * Shared XFS V0 can't deal with DMI.  Return EINVAL.
+		 */
+		if (mp->m_sb.sb_shared_vn == 0 && (ap->flags & XFSMNT_DMAPI))
+			return XFS_ERROR(EINVAL);
+	}
+
+	if (ap->flags & XFSMNT_UQUOTA) {
+		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
+		if (ap->flags & XFSMNT_UQUOTAENF)
+			mp->m_qflags |= XFS_UQUOTA_ENFD;
+	}
+
+	if (ap->flags & XFSMNT_GQUOTA) {
+		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
+		if (ap->flags & XFSMNT_GQUOTAENF)
+			mp->m_qflags |= XFS_OQUOTA_ENFD;
+	} else if (ap->flags & XFSMNT_PQUOTA) {
+		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
+		if (ap->flags & XFSMNT_PQUOTAENF)
+			mp->m_qflags |= XFS_OQUOTA_ENFD;
+	}
+
+	return 0;
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
+ * get_sb_bdev() and is stored in vfsp->vfs_super->s_bdev.
+ */
 STATIC int
 xfs_fs_fill_super(
 	struct super_block	*sb,
@@ -1376,7 +1605,9 @@ xfs_fs_fill_super(
 	struct inode		*root;
 	struct xfs_mount	*mp = NULL;
 	struct xfs_mount_args	*args = xfs_args_allocate(sb, silent);
-	int			error;
+	struct block_device	*ddev = sb->s_bdev;
+	struct block_device	*logdev = NULL, *rtdev = NULL;
+	int			flags = 0, error;
 
 	mp = xfs_mount_init();
 
@@ -1400,10 +1631,114 @@ xfs_fs_fill_super(
 	sb->s_qcop = &xfs_quotactl_operations;
 	sb->s_op = &xfs_super_operations;
 
-	error = xfs_mount(mp, args, NULL);
+	error = xfs_dmops_get(mp, args);
+	if (error)
+		goto fail_vfsop;
+	error = xfs_qmops_get(mp, args);
 	if (error)
 		goto fail_vfsop;
 
+	if (args->flags & XFSMNT_QUIET)
+		flags |= XFS_MFSI_QUIET;
+
+	/*
+	 * Open real time and log devices - order is important.
+	 */
+	if (args->logname[0]) {
+		error = xfs_blkdev_get(mp, args->logname, &logdev);
+		if (error)
+			goto fail_vfsop;
+	}
+	if (args->rtname[0]) {
+		error = xfs_blkdev_get(mp, args->rtname, &rtdev);
+		if (error) {
+			xfs_blkdev_put(logdev);
+			goto fail_vfsop;
+		}
+
+		if (rtdev == ddev || rtdev == logdev) {
+			cmn_err(CE_WARN,
+	"XFS: Cannot mount filesystem with identical rtdev and ddev/logdev.");
+			xfs_blkdev_put(logdev);
+			xfs_blkdev_put(rtdev);
+			error = EINVAL;
+			goto fail_vfsop;
+		}
+	}
+
+	/*
+	 * Setup xfs_mount buffer target pointers
+	 */
+	error = ENOMEM;
+	mp->m_ddev_targp = xfs_alloc_buftarg(ddev, 0);
+	if (!mp->m_ddev_targp) {
+		xfs_blkdev_put(logdev);
+		xfs_blkdev_put(rtdev);
+		goto fail_vfsop;
+	}
+	if (rtdev) {
+		mp->m_rtdev_targp = xfs_alloc_buftarg(rtdev, 1);
+		if (!mp->m_rtdev_targp) {
+			xfs_blkdev_put(logdev);
+			xfs_blkdev_put(rtdev);
+			goto error0;
+		}
+	}
+	mp->m_logdev_targp = (logdev && logdev != ddev) ?
+				xfs_alloc_buftarg(logdev, 1) : mp->m_ddev_targp;
+	if (!mp->m_logdev_targp) {
+		xfs_blkdev_put(logdev);
+		xfs_blkdev_put(rtdev);
+		goto error0;
+	}
+
+	/*
+	 * Setup flags based on mount(2) options and then the superblock
+	 */
+	error = xfs_start_flags(args, mp);
+	if (error)
+		goto error1;
+	error = xfs_readsb(mp, flags);
+	if (error)
+		goto error1;
+	error = xfs_finish_flags(args, mp);
+	if (error)
+		goto error2;
+
+	/*
+	 * Setup xfs_mount buffer target pointers based on superblock
+	 */
+	error = xfs_setsize_buftarg(mp->m_ddev_targp, mp->m_sb.sb_blocksize,
+				    mp->m_sb.sb_sectsize);
+	if (!error && logdev && logdev != ddev) {
+		unsigned int	log_sector_size = BBSIZE;
+
+		if (xfs_sb_version_hassector(&mp->m_sb))
+			log_sector_size = mp->m_sb.sb_logsectsize;
+		error = xfs_setsize_buftarg(mp->m_logdev_targp,
+					    mp->m_sb.sb_blocksize,
+					    log_sector_size);
+	}
+	if (!error && rtdev)
+		error = xfs_setsize_buftarg(mp->m_rtdev_targp,
+					    mp->m_sb.sb_blocksize,
+					    mp->m_sb.sb_sectsize);
+	if (error)
+		goto error2;
+
+	if (mp->m_flags & XFS_MOUNT_BARRIER)
+		xfs_mountfs_check_barriers(mp);
+
+	error = xfs_filestream_mount(mp);
+	if (error)
+		goto error2;
+
+	error = xfs_mountfs(mp, flags);
+	if (error)
+		goto error2;
+
+	XFS_SEND_MOUNT(mp, DM_RIGHT_NULL, args->mtpt, args->fsname);
+
 	sb->s_dirt = 1;
 	sb->s_magic = XFS_SB_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
@@ -1440,7 +1775,22 @@ xfs_fs_fill_super(
 	kmem_free(args, sizeof(*args));
 	return 0;
 
-fail_vnrele:
+ error2:
+	if (mp->m_sb_bp)
+		xfs_freesb(mp);
+ error1:
+	xfs_binval(mp->m_ddev_targp);
+	if (logdev && logdev != ddev)
+		xfs_binval(mp->m_logdev_targp);
+	if (rtdev)
+		xfs_binval(mp->m_rtdev_targp);
+ error0:
+	xfs_unmountfs_close(mp, NULL);
+	xfs_qmops_put(mp);
+	xfs_dmops_put(mp);
+	goto fail_vfsop;
+
+ fail_vnrele:
 	if (sb->s_root) {
 		dput(sb->s_root);
 		sb->s_root = NULL;
@@ -1448,7 +1798,7 @@ fail_vnrele:
 		iput(root);
 	}
 
-fail_unmount:
+ fail_unmount:
 	/*
 	 * Blow away any referenced inode in the filestreams cache.
 	 * This can and will cause log traffic as inodes go inactive
@@ -1467,7 +1817,7 @@ fail_unmount:
 	xfs_dmops_put(mp);
 	kmem_free(mp, sizeof(xfs_mount_t));
 
-fail_vfsop:
+ fail_vfsop:
 	kmem_free(args, sizeof(*args));
 	return -error;
 }
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2008-05-01 19:08:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2008-05-01 19:20:09.000000000 +0200
@@ -189,375 +189,6 @@ xfs_cleanup(void)
 	kmem_zone_destroy(xfs_log_ticket_zone);
 }
 
-/*
- * xfs_start_flags
- *
- * This function fills in xfs_mount_t fields based on mount args.
- * Note: the superblock has _not_ yet been read in.
- */
-STATIC int
-xfs_start_flags(
-	struct xfs_mount_args	*ap,
-	struct xfs_mount	*mp)
-{
-	/* Values are in BBs */
-	if ((ap->flags & XFSMNT_NOALIGN) != XFSMNT_NOALIGN) {
-		/*
-		 * At this point the superblock has not been read
-		 * in, therefore we do not know the block size.
-		 * Before the mount call ends we will convert
-		 * these to FSBs.
-		 */
-		mp->m_dalign = ap->sunit;
-		mp->m_swidth = ap->swidth;
-	}
-
-	if (ap->logbufs != -1 &&
-	    ap->logbufs != 0 &&
-	    (ap->logbufs < XLOG_MIN_ICLOGS ||
-	     ap->logbufs > XLOG_MAX_ICLOGS)) {
-		cmn_err(CE_WARN,
-			"XFS: invalid logbufs value: %d [not %d-%d]",
-			ap->logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
-		return XFS_ERROR(EINVAL);
-	}
-	mp->m_logbufs = ap->logbufs;
-	if (ap->logbufsize != -1 &&
-	    ap->logbufsize !=  0 &&
-	    (ap->logbufsize < XLOG_MIN_RECORD_BSIZE ||
-	     ap->logbufsize > XLOG_MAX_RECORD_BSIZE ||
-	     !is_power_of_2(ap->logbufsize))) {
-		cmn_err(CE_WARN,
-	"XFS: invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
-			ap->logbufsize);
-		return XFS_ERROR(EINVAL);
-	}
-	mp->m_logbsize = ap->logbufsize;
-	mp->m_fsname_len = strlen(ap->fsname) + 1;
-	mp->m_fsname = kmem_alloc(mp->m_fsname_len, KM_SLEEP);
-	strcpy(mp->m_fsname, ap->fsname);
-	if (ap->rtname[0]) {
-		mp->m_rtname = kmem_alloc(strlen(ap->rtname) + 1, KM_SLEEP);
-		strcpy(mp->m_rtname, ap->rtname);
-	}
-	if (ap->logname[0]) {
-		mp->m_logname = kmem_alloc(strlen(ap->logname) + 1, KM_SLEEP);
-		strcpy(mp->m_logname, ap->logname);
-	}
-
-	if (ap->flags & XFSMNT_WSYNC)
-		mp->m_flags |= XFS_MOUNT_WSYNC;
-#if XFS_BIG_INUMS
-	if (ap->flags & XFSMNT_INO64) {
-		mp->m_flags |= XFS_MOUNT_INO64;
-		mp->m_inoadd = XFS_INO64_OFFSET;
-	}
-#endif
-	if (ap->flags & XFSMNT_RETERR)
-		mp->m_flags |= XFS_MOUNT_RETERR;
-	if (ap->flags & XFSMNT_NOALIGN)
-		mp->m_flags |= XFS_MOUNT_NOALIGN;
-	if (ap->flags & XFSMNT_SWALLOC)
-		mp->m_flags |= XFS_MOUNT_SWALLOC;
-	if (ap->flags & XFSMNT_OSYNCISOSYNC)
-		mp->m_flags |= XFS_MOUNT_OSYNCISOSYNC;
-	if (ap->flags & XFSMNT_32BITINODES)
-		mp->m_flags |= XFS_MOUNT_32BITINODES;
-
-	if (ap->flags & XFSMNT_IOSIZE) {
-		if (ap->iosizelog > XFS_MAX_IO_LOG ||
-		    ap->iosizelog < XFS_MIN_IO_LOG) {
-			cmn_err(CE_WARN,
-		"XFS: invalid log iosize: %d [not %d-%d]",
-				ap->iosizelog, XFS_MIN_IO_LOG,
-				XFS_MAX_IO_LOG);
-			return XFS_ERROR(EINVAL);
-		}
-
-		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
-		mp->m_readio_log = mp->m_writeio_log = ap->iosizelog;
-	}
-
-	if (ap->flags & XFSMNT_IKEEP)
-		mp->m_flags |= XFS_MOUNT_IKEEP;
-	if (ap->flags & XFSMNT_DIRSYNC)
-		mp->m_flags |= XFS_MOUNT_DIRSYNC;
-	if (ap->flags & XFSMNT_ATTR2)
-		mp->m_flags |= XFS_MOUNT_ATTR2;
-	if (ap->flags & XFSMNT_NOATTR2)
-		mp->m_flags |= XFS_MOUNT_NOATTR2;
-
-	if (ap->flags2 & XFSMNT2_COMPAT_IOSIZE)
-		mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-
-	/*
-	 * no recovery flag requires a read-only mount
-	 */
-	if (ap->flags & XFSMNT_NORECOVERY) {
-		if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
-			cmn_err(CE_WARN,
-	"XFS: tried to mount a FS read-write without recovery!");
-			return XFS_ERROR(EINVAL);
-		}
-		mp->m_flags |= XFS_MOUNT_NORECOVERY;
-	}
-
-	if (ap->flags & XFSMNT_NOUUID)
-		mp->m_flags |= XFS_MOUNT_NOUUID;
-	if (ap->flags & XFSMNT_BARRIER)
-		mp->m_flags |= XFS_MOUNT_BARRIER;
-	else
-		mp->m_flags &= ~XFS_MOUNT_BARRIER;
-
-	if (ap->flags2 & XFSMNT2_FILESTREAMS)
-		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
-
-	if (ap->flags & XFSMNT_DMAPI)
-		mp->m_flags |= XFS_MOUNT_DMAPI;
-	return 0;
-}
-
-/*
- * This function fills in xfs_mount_t fields based on mount args.
- * Note: the superblock _has_ now been read in.
- */
-STATIC int
-xfs_finish_flags(
-	struct xfs_mount_args	*ap,
-	struct xfs_mount	*mp)
-{
-	int			ronly = (mp->m_flags & XFS_MOUNT_RDONLY);
-
-	/* Fail a mount where the logbuf is smaller then the log stripe */
-	if (xfs_sb_version_haslogv2(&mp->m_sb)) {
-		if ((ap->logbufsize <= 0) &&
-		    (mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE)) {
-			mp->m_logbsize = mp->m_sb.sb_logsunit;
-		} else if (ap->logbufsize > 0 &&
-			   ap->logbufsize < mp->m_sb.sb_logsunit) {
-			cmn_err(CE_WARN,
-	"XFS: logbuf size must be greater than or equal to log stripe size");
-			return XFS_ERROR(EINVAL);
-		}
-	} else {
-		/* Fail a mount if the logbuf is larger than 32K */
-		if (ap->logbufsize > XLOG_BIG_RECORD_BSIZE) {
-			cmn_err(CE_WARN,
-	"XFS: logbuf size for version 1 logs must be 16K or 32K");
-			return XFS_ERROR(EINVAL);
-		}
-	}
-
-	/*
-	 * mkfs'ed attr2 will turn on attr2 mount unless explicitly
-	 * told by noattr2 to turn it off
-	 */
-	if (xfs_sb_version_hasattr2(&mp->m_sb) &&
-	    !(ap->flags & XFSMNT_NOATTR2))
-		mp->m_flags |= XFS_MOUNT_ATTR2;
-
-	/*
-	 * prohibit r/w mounts of read-only filesystems
-	 */
-	if ((mp->m_sb.sb_flags & XFS_SBF_READONLY) && !ronly) {
-		cmn_err(CE_WARN,
-	"XFS: cannot mount a read-only filesystem as read-write");
-		return XFS_ERROR(EROFS);
-	}
-
-	/*
-	 * check for shared mount.
-	 */
-	if (ap->flags & XFSMNT_SHARED) {
-		if (!xfs_sb_version_hasshared(&mp->m_sb))
-			return XFS_ERROR(EINVAL);
-
-		/*
-		 * For IRIX 6.5, shared mounts must have the shared
-		 * version bit set, have the persistent readonly
-		 * field set, must be version 0 and can only be mounted
-		 * read-only.
-		 */
-		if (!ronly || !(mp->m_sb.sb_flags & XFS_SBF_READONLY) ||
-		     (mp->m_sb.sb_shared_vn != 0))
-			return XFS_ERROR(EINVAL);
-
-		mp->m_flags |= XFS_MOUNT_SHARED;
-
-		/*
-		 * Shared XFS V0 can't deal with DMI.  Return EINVAL.
-		 */
-		if (mp->m_sb.sb_shared_vn == 0 && (ap->flags & XFSMNT_DMAPI))
-			return XFS_ERROR(EINVAL);
-	}
-
-	if (ap->flags & XFSMNT_UQUOTA) {
-		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
-		if (ap->flags & XFSMNT_UQUOTAENF)
-			mp->m_qflags |= XFS_UQUOTA_ENFD;
-	}
-
-	if (ap->flags & XFSMNT_GQUOTA) {
-		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
-		if (ap->flags & XFSMNT_GQUOTAENF)
-			mp->m_qflags |= XFS_OQUOTA_ENFD;
-	} else if (ap->flags & XFSMNT_PQUOTA) {
-		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
-		if (ap->flags & XFSMNT_PQUOTAENF)
-			mp->m_qflags |= XFS_OQUOTA_ENFD;
-	}
-
-	return 0;
-}
-
-/*
- * xfs_mount
- *
- * The file system configurations are:
- *	(1) device (partition) with data and internal log
- *	(2) logical volume with data and log subvolumes.
- *	(3) logical volume with data, log, and realtime subvolumes.
- *
- * We only have to handle opening the log and realtime volumes here if
- * they are present.  The data subvolume has already been opened by
- * get_sb_bdev() and is stored in vfsp->vfs_super->s_bdev.
- */
-int
-xfs_mount(
-	struct xfs_mount	*mp,
-	struct xfs_mount_args	*args,
-	cred_t			*credp)
-{
-	struct block_device	*ddev, *logdev, *rtdev;
-	int			flags = 0, error;
-
-	ddev = mp->m_super->s_bdev;
-	logdev = rtdev = NULL;
-
-	error = xfs_dmops_get(mp, args);
-	if (error)
-		return error;
-	error = xfs_qmops_get(mp, args);
-	if (error)
-		return error;
-
-	if (args->flags & XFSMNT_QUIET)
-		flags |= XFS_MFSI_QUIET;
-
-	/*
-	 * Open real time and log devices - order is important.
-	 */
-	if (args->logname[0]) {
-		error = xfs_blkdev_get(mp, args->logname, &logdev);
-		if (error)
-			return error;
-	}
-	if (args->rtname[0]) {
-		error = xfs_blkdev_get(mp, args->rtname, &rtdev);
-		if (error) {
-			xfs_blkdev_put(logdev);
-			return error;
-		}
-
-		if (rtdev == ddev || rtdev == logdev) {
-			cmn_err(CE_WARN,
-	"XFS: Cannot mount filesystem with identical rtdev and ddev/logdev.");
-			xfs_blkdev_put(logdev);
-			xfs_blkdev_put(rtdev);
-			return EINVAL;
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
-		return error;
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
-
-	/*
-	 * Setup flags based on mount(2) options and then the superblock
-	 */
-	error = xfs_start_flags(args, mp);
-	if (error)
-		goto error1;
-	error = xfs_readsb(mp, flags);
-	if (error)
-		goto error1;
-	error = xfs_finish_flags(args, mp);
-	if (error)
-		goto error2;
-
-	/*
-	 * Setup xfs_mount buffer target pointers based on superblock
-	 */
-	error = xfs_setsize_buftarg(mp->m_ddev_targp, mp->m_sb.sb_blocksize,
-				    mp->m_sb.sb_sectsize);
-	if (!error && logdev && logdev != ddev) {
-		unsigned int	log_sector_size = BBSIZE;
-
-		if (xfs_sb_version_hassector(&mp->m_sb))
-			log_sector_size = mp->m_sb.sb_logsectsize;
-		error = xfs_setsize_buftarg(mp->m_logdev_targp,
-					    mp->m_sb.sb_blocksize,
-					    log_sector_size);
-	}
-	if (!error && rtdev)
-		error = xfs_setsize_buftarg(mp->m_rtdev_targp,
-					    mp->m_sb.sb_blocksize,
-					    mp->m_sb.sb_sectsize);
-	if (error)
-		goto error2;
-
-	if (mp->m_flags & XFS_MOUNT_BARRIER)
-		xfs_mountfs_check_barriers(mp);
-
-	if ((error = xfs_filestream_mount(mp)))
-		goto error2;
-
-	error = xfs_mountfs(mp, flags);
-	if (error)
-		goto error2;
-
-	XFS_SEND_MOUNT(mp, DM_RIGHT_NULL, args->mtpt, args->fsname);
-
-	return 0;
-
-error2:
-	if (mp->m_sb_bp)
-		xfs_freesb(mp);
-error1:
-	xfs_binval(mp->m_ddev_targp);
-	if (logdev && logdev != ddev)
-		xfs_binval(mp->m_logdev_targp);
-	if (rtdev)
-		xfs_binval(mp->m_rtdev_targp);
-error0:
-	xfs_unmountfs_close(mp, credp);
-	xfs_qmops_put(mp);
-	xfs_dmops_put(mp);
-	return error;
-}
-
 STATIC void
 xfs_quiesce_fs(
 	xfs_mount_t		*mp)
