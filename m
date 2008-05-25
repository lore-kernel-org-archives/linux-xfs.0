Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 May 2008 12:07:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4PJ72vm022232
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:07:02 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B45251B066D
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:07:50 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id QVj1f9UfqI7aFatM for <xfs@oss.sgi.com>; Sun, 25 May 2008 12:07:50 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4PJ7fF3014098
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 21:07:41 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4PJ7fLN014096
	for xfs@oss.sgi.com; Sun, 25 May 2008 21:07:41 +0200
Date: Sun, 25 May 2008 21:07:41 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] kill struct xfs_mount_args
Message-ID: <20080525190741.GB13372@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

No need to parse the mount option into a structure before applying it
to struct xfs_mount.

The content of xfs_start_flags gets merged into xfs_parseargs.  Calls
inbetween don't care and can use mount members instead of the args
struct.

This patch uncovered that the mount option for shared filesystems wasn't
ever exposed on Linux.  The code to handle it is #if 0'ed in this patch
pending a decision on this feature.  I'll send a writeup about it to
the list soon.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-25 16:23:57.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-25 20:57:16.000000000 +0200
@@ -18,7 +18,6 @@
 #include "xfs.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_clnt.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
@@ -74,32 +73,6 @@ static kmem_zone_t *xfs_vnode_zone;
 static kmem_zone_t *xfs_ioend_zone;
 mempool_t *xfs_ioend_pool;
 
-STATIC struct xfs_mount_args *
-xfs_args_allocate(
-	struct super_block	*sb,
-	int			silent)
-{
-	struct xfs_mount_args	*args;
-
-	args = kzalloc(sizeof(struct xfs_mount_args), GFP_KERNEL);
-	if (!args)
-		return NULL;
-
-	args->logbufs = args->logbufsize = -1;
-	strncpy(args->fsname, sb->s_id, MAXNAMELEN);
-
-	/* Copy the already-parsed mount(2) flags we're interested in */
-	if (sb->s_flags & MS_DIRSYNC)
-		args->flags |= XFSMNT_DIRSYNC;
-	if (sb->s_flags & MS_SYNCHRONOUS)
-		args->flags |= XFSMNT_WSYNC;
-	if (silent)
-		args->flags |= XFSMNT_QUIET;
-	args->flags |= XFSMNT_32BITINODES;
-
-	return args;
-}
-
 #define MNTOPT_LOGBUFS	"logbufs"	/* number of XFS log buffers */
 #define MNTOPT_LOGBSIZE	"logbsize"	/* size of XFS log buffers */
 #define MNTOPT_LOGDEV	"logdev"	/* log device */
@@ -171,26 +144,54 @@ suffix_strtoul(char *s, char **endp, uns
 	return simple_strtoul((const char *)s, endp, base) << shift_left_factor;
 }
 
+/*
+ * This function fills in xfs_mount_t fields based on mount args.
+ * Note: the superblock has _not_ yet been read in.
+ *
+ * Note that this function leaks the various device name allocations on
+ * failure.  The caller takes care of them.
+ */
 STATIC int
 xfs_parseargs(
 	struct xfs_mount	*mp,
 	char			*options,
-	struct xfs_mount_args	*args,
-	int			update)
+	char			**mtpt)
 {
+	struct super_block	*sb = mp->m_super;
 	char			*this_char, *value, *eov;
-	int			dsunit, dswidth, vol_dsunit, vol_dswidth;
-	int			iosize;
+	int			dsunit = 0;
+	int			dswidth = 0;
+	int			iosize = 0;
 	int			dmapi_implies_ikeep = 1;
+	uchar_t			iosizelog = 0;
 
-	args->flags |= XFSMNT_BARRIER;
-	args->flags2 |= XFSMNT2_COMPAT_IOSIZE;
+	/*
+	 * Copy binary VFS mount flags we are interested in.
+	 */
+	if (sb->s_flags & MS_RDONLY)
+		mp->m_flags |= XFS_MOUNT_RDONLY;
+	if (sb->s_flags & MS_DIRSYNC)
+		mp->m_flags |= XFS_MOUNT_DIRSYNC;
+	if (sb->s_flags & MS_SYNCHRONOUS)
+		mp->m_flags |= XFS_MOUNT_WSYNC;
+
+	/*
+	 * Set some default flags that could be cleared by the mount option
+	 * parsing.
+	 */
+	mp->m_flags |= XFS_MOUNT_BARRIER;
+	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+
+	/*
+	 * These can be overridden by the mount option parsing.
+	 */
+	mp->m_logbufs = -1;
+	mp->m_logbsize = -1;
 
 	if (!options)
 		goto done;
 
-	iosize = dsunit = dswidth = vol_dsunit = vol_dswidth = 0;
-
 	while ((this_char = strsep(&options, ",")) != NULL) {
 		if (!*this_char)
 			continue;
@@ -204,7 +205,7 @@ xfs_parseargs(
 					this_char);
 				return EINVAL;
 			}
-			args->logbufs = simple_strtoul(value, &eov, 10);
+			mp->m_logbufs = simple_strtoul(value, &eov, 10);
 		} else if (!strcmp(this_char, MNTOPT_LOGBSIZE)) {
 			if (!value || !*value) {
 				cmn_err(CE_WARN,
@@ -212,7 +213,7 @@ xfs_parseargs(
 					this_char);
 				return EINVAL;
 			}
-			args->logbufsize = suffix_strtoul(value, &eov, 10);
+			mp->m_logbsize = suffix_strtoul(value, &eov, 10);
 		} else if (!strcmp(this_char, MNTOPT_LOGDEV)) {
 			if (!value || !*value) {
 				cmn_err(CE_WARN,
@@ -220,7 +221,9 @@ xfs_parseargs(
 					this_char);
 				return EINVAL;
 			}
-			strncpy(args->logname, value, MAXNAMELEN);
+			mp->m_logname = kstrndup(value, MAXNAMELEN, GFP_KERNEL);
+			if (!mp->m_logname)
+				return ENOMEM;
 		} else if (!strcmp(this_char, MNTOPT_MTPT)) {
 			if (!value || !*value) {
 				cmn_err(CE_WARN,
@@ -228,7 +231,9 @@ xfs_parseargs(
 					this_char);
 				return EINVAL;
 			}
-			strncpy(args->mtpt, value, MAXNAMELEN);
+			*mtpt = kstrndup(value, MAXNAMELEN, GFP_KERNEL);
+			if (!*mtpt)
+				return ENOMEM;
 		} else if (!strcmp(this_char, MNTOPT_RTDEV)) {
 			if (!value || !*value) {
 				cmn_err(CE_WARN,
@@ -236,7 +241,9 @@ xfs_parseargs(
 					this_char);
 				return EINVAL;
 			}
-			strncpy(args->rtname, value, MAXNAMELEN);
+			mp->m_rtname = kstrndup(value, MAXNAMELEN, GFP_KERNEL);
+			if (!mp->m_rtname)
+				return ENOMEM;
 		} else if (!strcmp(this_char, MNTOPT_BIOSIZE)) {
 			if (!value || !*value) {
 				cmn_err(CE_WARN,
@@ -245,8 +252,7 @@ xfs_parseargs(
 				return EINVAL;
 			}
 			iosize = simple_strtoul(value, &eov, 10);
-			args->flags |= XFSMNT_IOSIZE;
-			args->iosizelog = (uint8_t) iosize;
+			iosizelog = (uint8_t) iosize;
 		} else if (!strcmp(this_char, MNTOPT_ALLOCSIZE)) {
 			if (!value || !*value) {
 				cmn_err(CE_WARN,
@@ -255,8 +261,7 @@ xfs_parseargs(
 				return EINVAL;
 			}
 			iosize = suffix_strtoul(value, &eov, 10);
-			args->flags |= XFSMNT_IOSIZE;
-			args->iosizelog = ffs(iosize) - 1;
+			iosizelog = ffs(iosize) - 1;
 		} else if (!strcmp(this_char, MNTOPT_GRPID) ||
 			   !strcmp(this_char, MNTOPT_BSDGROUPS)) {
 			mp->m_flags |= XFS_MOUNT_GRPID;
@@ -264,23 +269,25 @@ xfs_parseargs(
 			   !strcmp(this_char, MNTOPT_SYSVGROUPS)) {
 			mp->m_flags &= ~XFS_MOUNT_GRPID;
 		} else if (!strcmp(this_char, MNTOPT_WSYNC)) {
-			args->flags |= XFSMNT_WSYNC;
+			mp->m_flags |= XFS_MOUNT_WSYNC;
 		} else if (!strcmp(this_char, MNTOPT_OSYNCISOSYNC)) {
-			args->flags |= XFSMNT_OSYNCISOSYNC;
+			mp->m_flags |= XFS_MOUNT_OSYNCISOSYNC;
 		} else if (!strcmp(this_char, MNTOPT_NORECOVERY)) {
-			args->flags |= XFSMNT_NORECOVERY;
+			mp->m_flags |= XFS_MOUNT_NORECOVERY;
 		} else if (!strcmp(this_char, MNTOPT_INO64)) {
-			args->flags |= XFSMNT_INO64;
-#if !XFS_BIG_INUMS
+#if XFS_BIG_INUMS
+			mp->m_flags |= XFS_MOUNT_INO64;
+			mp->m_inoadd = XFS_INO64_OFFSET;
+#else
 			cmn_err(CE_WARN,
 				"XFS: %s option not allowed on this system",
 				this_char);
 			return EINVAL;
 #endif
 		} else if (!strcmp(this_char, MNTOPT_NOALIGN)) {
-			args->flags |= XFSMNT_NOALIGN;
+			mp->m_flags |= XFS_MOUNT_NOALIGN;
 		} else if (!strcmp(this_char, MNTOPT_SWALLOC)) {
-			args->flags |= XFSMNT_SWALLOC;
+			mp->m_flags |= XFS_MOUNT_SWALLOC;
 		} else if (!strcmp(this_char, MNTOPT_SUNIT)) {
 			if (!value || !*value) {
 				cmn_err(CE_WARN,
@@ -298,7 +305,7 @@ xfs_parseargs(
 			}
 			dswidth = simple_strtoul(value, &eov, 10);
 		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
-			args->flags &= ~XFSMNT_32BITINODES;
+			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
 #if !XFS_BIG_INUMS
 			cmn_err(CE_WARN,
 				"XFS: %s option not allowed on this system",
@@ -306,56 +313,60 @@ xfs_parseargs(
 			return EINVAL;
 #endif
 		} else if (!strcmp(this_char, MNTOPT_NOUUID)) {
-			args->flags |= XFSMNT_NOUUID;
+			mp->m_flags |= XFS_MOUNT_NOUUID;
 		} else if (!strcmp(this_char, MNTOPT_BARRIER)) {
-			args->flags |= XFSMNT_BARRIER;
+			mp->m_flags |= XFS_MOUNT_BARRIER;
 		} else if (!strcmp(this_char, MNTOPT_NOBARRIER)) {
-			args->flags &= ~XFSMNT_BARRIER;
+			mp->m_flags &= ~XFS_MOUNT_BARRIER;
 		} else if (!strcmp(this_char, MNTOPT_IKEEP)) {
-			args->flags |= XFSMNT_IKEEP;
+			mp->m_flags |= XFS_MOUNT_IKEEP;
 		} else if (!strcmp(this_char, MNTOPT_NOIKEEP)) {
 			dmapi_implies_ikeep = 0;
-			args->flags &= ~XFSMNT_IKEEP;
+			mp->m_flags &= ~XFS_MOUNT_IKEEP;
 		} else if (!strcmp(this_char, MNTOPT_LARGEIO)) {
-			args->flags2 &= ~XFSMNT2_COMPAT_IOSIZE;
+			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
 		} else if (!strcmp(this_char, MNTOPT_NOLARGEIO)) {
-			args->flags2 |= XFSMNT2_COMPAT_IOSIZE;
+			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
 		} else if (!strcmp(this_char, MNTOPT_ATTR2)) {
-			args->flags |= XFSMNT_ATTR2;
+			mp->m_flags |= XFS_MOUNT_ATTR2;
 		} else if (!strcmp(this_char, MNTOPT_NOATTR2)) {
-			args->flags &= ~XFSMNT_ATTR2;
-			args->flags |= XFSMNT_NOATTR2;
+			mp->m_flags &= ~XFS_MOUNT_ATTR2;
+			mp->m_flags |= XFS_MOUNT_NOATTR2;
 		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
-			args->flags2 |= XFSMNT2_FILESTREAMS;
+			mp->m_flags |= XFS_MOUNT_FILESTREAMS;
 		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
-			args->flags &= ~(XFSMNT_UQUOTAENF|XFSMNT_UQUOTA);
-			args->flags &= ~(XFSMNT_GQUOTAENF|XFSMNT_GQUOTA);
+			mp->m_qflags &= ~(XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
+					  XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
+					  XFS_UQUOTA_ENFD | XFS_OQUOTA_ENFD);
 		} else if (!strcmp(this_char, MNTOPT_QUOTA) ||
 			   !strcmp(this_char, MNTOPT_UQUOTA) ||
 			   !strcmp(this_char, MNTOPT_USRQUOTA)) {
-			args->flags |= XFSMNT_UQUOTA | XFSMNT_UQUOTAENF;
+			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
+					 XFS_UQUOTA_ENFD);
 		} else if (!strcmp(this_char, MNTOPT_QUOTANOENF) ||
 			   !strcmp(this_char, MNTOPT_UQUOTANOENF)) {
-			args->flags |= XFSMNT_UQUOTA;
-			args->flags &= ~XFSMNT_UQUOTAENF;
+			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
+			mp->m_qflags &= ~XFS_UQUOTA_ENFD;
 		} else if (!strcmp(this_char, MNTOPT_PQUOTA) ||
 			   !strcmp(this_char, MNTOPT_PRJQUOTA)) {
-			args->flags |= XFSMNT_PQUOTA | XFSMNT_PQUOTAENF;
+			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
+					 XFS_OQUOTA_ENFD);
 		} else if (!strcmp(this_char, MNTOPT_PQUOTANOENF)) {
-			args->flags |= XFSMNT_PQUOTA;
-			args->flags &= ~XFSMNT_PQUOTAENF;
+			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
+			mp->m_qflags &= ~XFS_OQUOTA_ENFD;
 		} else if (!strcmp(this_char, MNTOPT_GQUOTA) ||
 			   !strcmp(this_char, MNTOPT_GRPQUOTA)) {
-			args->flags |= XFSMNT_GQUOTA | XFSMNT_GQUOTAENF;
+			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
+					 XFS_OQUOTA_ENFD);
 		} else if (!strcmp(this_char, MNTOPT_GQUOTANOENF)) {
-			args->flags |= XFSMNT_GQUOTA;
-			args->flags &= ~XFSMNT_GQUOTAENF;
+			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
+			mp->m_qflags &= ~XFS_OQUOTA_ENFD;
 		} else if (!strcmp(this_char, MNTOPT_DMAPI)) {
-			args->flags |= XFSMNT_DMAPI;
+			mp->m_flags |= XFS_MOUNT_DMAPI;
 		} else if (!strcmp(this_char, MNTOPT_XDSM)) {
-			args->flags |= XFSMNT_DMAPI;
+			mp->m_flags |= XFS_MOUNT_DMAPI;
 		} else if (!strcmp(this_char, MNTOPT_DMI)) {
-			args->flags |= XFSMNT_DMAPI;
+			mp->m_flags |= XFS_MOUNT_DMAPI;
 		} else if (!strcmp(this_char, "ihashsize")) {
 			cmn_err(CE_WARN,
 	"XFS: ihashsize no longer used, option is deprecated.");
@@ -373,27 +384,29 @@ xfs_parseargs(
 		}
 	}
 
-	if (args->flags & XFSMNT_NORECOVERY) {
-		if ((mp->m_flags & XFS_MOUNT_RDONLY) == 0) {
-			cmn_err(CE_WARN,
-				"XFS: no-recovery mounts must be read-only.");
-			return EINVAL;
-		}
+	/*
+	 * no recovery flag requires a read-only mount
+	 */
+	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
+	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		cmn_err(CE_WARN, "XFS: no-recovery mounts must be read-only.");
+		return EINVAL;
 	}
 
-	if ((args->flags & XFSMNT_NOALIGN) && (dsunit || dswidth)) {
+	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit || dswidth)) {
 		cmn_err(CE_WARN,
 	"XFS: sunit and swidth options incompatible with the noalign option");
 		return EINVAL;
 	}
 
-	if ((args->flags & XFSMNT_GQUOTA) && (args->flags & XFSMNT_PQUOTA)) {
+	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
+	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE))) {
 		cmn_err(CE_WARN,
 			"XFS: cannot mount with both project and group quota");
 		return EINVAL;
 	}
 
-	if ((args->flags & XFSMNT_DMAPI) && *args->mtpt == '\0') {
+	if ((mp->m_flags & XFS_MOUNT_DMAPI) && !mtpt) {
 		printk("XFS: %s option needs the mount point option as well\n",
 			MNTOPT_DMAPI);
 		return EINVAL;
@@ -421,27 +434,66 @@ xfs_parseargs(
 	 * Note that if "ikeep" or "noikeep" mount options are
 	 * supplied, then they are honored.
 	 */
-	if ((args->flags & XFSMNT_DMAPI) && dmapi_implies_ikeep)
-		args->flags |= XFSMNT_IKEEP;
+	if ((mp->m_flags & XFS_MOUNT_DMAPI) && dmapi_implies_ikeep)
+		mp->m_flags |= XFS_MOUNT_IKEEP;
 
-	if ((args->flags & XFSMNT_NOALIGN) != XFSMNT_NOALIGN) {
+done:
+	if (!(mp->m_flags & XFS_MOUNT_NOALIGN)) {
+		/*
+		 * At this point the superblock has not been read
+		 * in, therefore we do not know the block size.
+		 * Before the mount call ends we will convert
+		 * these to FSBs.
+		 */
 		if (dsunit) {
-			args->sunit = dsunit;
-			args->flags |= XFSMNT_RETERR;
-		} else {
-			args->sunit = vol_dsunit;
+			mp->m_dalign = dsunit;
+			mp->m_flags |= XFS_MOUNT_RETERR;
 		}
-		dswidth ? (args->swidth = dswidth) :
-			  (args->swidth = vol_dswidth);
-	} else {
-		args->sunit = args->swidth = 0;
+
+		if (dswidth)
+			mp->m_swidth = dswidth;
+	}
+
+	if (mp->m_logbufs != -1 &&
+	    mp->m_logbufs != 0 &&
+	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
+	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
+		cmn_err(CE_WARN,
+			"XFS: invalid logbufs value: %d [not %d-%d]",
+			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
+		return XFS_ERROR(EINVAL);
+	}
+	if (mp->m_logbsize != -1 &&
+	    mp->m_logbsize !=  0 &&
+	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
+	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
+	     !is_power_of_2(mp->m_logbsize))) {
+		cmn_err(CE_WARN,
+	"XFS: invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
+			mp->m_logbsize);
+		return XFS_ERROR(EINVAL);
+	}
+
+	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
+	if (!mp->m_fsname)
+		return ENOMEM;
+	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
+
+	if (iosizelog) {
+		if (iosizelog > XFS_MAX_IO_LOG ||
+		    iosizelog < XFS_MIN_IO_LOG) {
+			cmn_err(CE_WARN,
+		"XFS: invalid log iosize: %d [not %d-%d]",
+				iosizelog, XFS_MIN_IO_LOG,
+				XFS_MAX_IO_LOG);
+			return XFS_ERROR(EINVAL);
+		}
+
+		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
+		mp->m_readio_log = iosizelog;
+		mp->m_writeio_log = iosizelog;
 	}
 
-done:
-	if (args->flags & XFSMNT_32BITINODES)
-		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
-	if (args->flags2)
-		args->flags |= XFSMNT_FLAGS2;
 	return 0;
 }
 
@@ -693,8 +745,7 @@ xfs_close_devices(
  */
 STATIC int
 xfs_open_devices(
-	struct xfs_mount	*mp,
-	struct xfs_mount_args	*args)
+	struct xfs_mount	*mp)
 {
 	struct block_device	*ddev = mp->m_super->s_bdev;
 	struct block_device	*logdev = NULL, *rtdev = NULL;
@@ -703,14 +754,14 @@ xfs_open_devices(
 	/*
 	 * Open real time and log devices - order is important.
 	 */
-	if (args->logname[0]) {
-		error = xfs_blkdev_get(mp, args->logname, &logdev);
+	if (mp->m_logname) {
+		error = xfs_blkdev_get(mp, mp->m_logname, &logdev);
 		if (error)
 			goto out;
 	}
 
-	if (args->rtname[0]) {
-		error = xfs_blkdev_get(mp, args->rtname, &rtdev);
+	if (mp->m_rtname) {
+		error = xfs_blkdev_get(mp, mp->m_rtname, &rtdev);
 		if (error)
 			goto out_close_logdev;
 
@@ -1411,175 +1462,28 @@ xfs_fs_setxquota(
 
 /*
  * This function fills in xfs_mount_t fields based on mount args.
- * Note: the superblock has _not_ yet been read in.
- */
-STATIC int
-xfs_start_flags(
-	struct xfs_mount_args	*ap,
-	struct xfs_mount	*mp)
-{
-	int			error;
-
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
-
-	error = ENOMEM;
-
-	mp->m_logbsize = ap->logbufsize;
-	mp->m_fsname_len = strlen(ap->fsname) + 1;
-
-	mp->m_fsname = kstrdup(ap->fsname, GFP_KERNEL);
-	if (!mp->m_fsname)
-		goto out;
-
-	if (ap->rtname[0]) {
-		mp->m_rtname = kstrdup(ap->rtname, GFP_KERNEL);
-		if (!mp->m_rtname)
-			goto out_free_fsname;
-
-	}
-
-	if (ap->logname[0]) {
-		mp->m_logname = kstrdup(ap->logname, GFP_KERNEL);
-		if (!mp->m_logname)
-			goto out_free_rtname;
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
-
-
- out_free_rtname:
-	kfree(mp->m_rtname);
- out_free_fsname:
-	kfree(mp->m_fsname);
- out:
-	return error;
-}
-
-/*
- * This function fills in xfs_mount_t fields based on mount args.
  * Note: the superblock _has_ now been read in.
  */
 STATIC int
 xfs_finish_flags(
-	struct xfs_mount_args	*ap,
 	struct xfs_mount	*mp)
 {
 	int			ronly = (mp->m_flags & XFS_MOUNT_RDONLY);
 
 	/* Fail a mount where the logbuf is smaller then the log stripe */
 	if (xfs_sb_version_haslogv2(&mp->m_sb)) {
-		if ((ap->logbufsize <= 0) &&
-		    (mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE)) {
+		if (mp->m_logbsize <= 0 &&
+		    mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE) {
 			mp->m_logbsize = mp->m_sb.sb_logsunit;
-		} else if (ap->logbufsize > 0 &&
-			   ap->logbufsize < mp->m_sb.sb_logsunit) {
+		} else if (mp->m_logbsize > 0 &&
+			   mp->m_logbsize < mp->m_sb.sb_logsunit) {
 			cmn_err(CE_WARN,
 	"XFS: logbuf size must be greater than or equal to log stripe size");
 			return XFS_ERROR(EINVAL);
 		}
 	} else {
 		/* Fail a mount if the logbuf is larger than 32K */
-		if (ap->logbufsize > XLOG_BIG_RECORD_BSIZE) {
+		if (mp->m_logbsize > XLOG_BIG_RECORD_BSIZE) {
 			cmn_err(CE_WARN,
 	"XFS: logbuf size for version 1 logs must be 16K or 32K");
 			return XFS_ERROR(EINVAL);
@@ -1591,7 +1495,7 @@ xfs_finish_flags(
 	 * told by noattr2 to turn it off
 	 */
 	if (xfs_sb_version_hasattr2(&mp->m_sb) &&
-	    !(ap->flags & XFSMNT_NOATTR2))
+	    !(mp->m_flags & XFS_MOUNT_NOATTR2))
 		mp->m_flags |= XFS_MOUNT_ATTR2;
 
 	/*
@@ -1603,6 +1507,7 @@ xfs_finish_flags(
 		return XFS_ERROR(EROFS);
 	}
 
+#if 0 /* shared mounts were never supported on Linux */
 	/*
 	 * check for shared mount.
 	 */
@@ -1625,25 +1530,11 @@ xfs_finish_flags(
 		/*
 		 * Shared XFS V0 can't deal with DMI.  Return EINVAL.
 		 */
-		if (mp->m_sb.sb_shared_vn == 0 && (ap->flags & XFSMNT_DMAPI))
+		if (mp->m_sb.sb_shared_vn == 0 &&
+		    (mp->m_flags & XFS_MOUNT_DMAPI))
 			return XFS_ERROR(EINVAL);
 	}
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
+#endif
 
 	return 0;
 }
@@ -1656,16 +1547,12 @@ xfs_fs_fill_super(
 {
 	struct inode		*root;
 	struct xfs_mount	*mp = NULL;
-	struct xfs_mount_args	*args;
 	int			flags = 0, error = ENOMEM;
-
-	args = xfs_args_allocate(sb, silent);
-	if (!args)
-		return -ENOMEM;
+	char			*mtpt = NULL;
 
 	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
 	if (!mp)
-		goto out_free_args;
+		goto out;
 
 	spin_lock_init(&mp->m_sb_lock);
 	mutex_init(&mp->m_ilock);
@@ -1678,12 +1565,9 @@ xfs_fs_fill_super(
 	mp->m_super = sb;
 	sb->s_fs_info = mp;
 
-	if (sb->s_flags & MS_RDONLY)
-		mp->m_flags |= XFS_MOUNT_RDONLY;
-
-	error = xfs_parseargs(mp, (char *)data, args, 0);
+	error = xfs_parseargs(mp, (char *)data, &mtpt);
 	if (error)
-		goto out_free_mp;
+		goto out_free_fsname;
 
 	sb_min_blocksize(sb, BBSIZE);
 	sb->s_xattr = xfs_xattr_handlers;
@@ -1691,33 +1575,28 @@ xfs_fs_fill_super(
 	sb->s_qcop = &xfs_quotactl_operations;
 	sb->s_op = &xfs_super_operations;
 
-	error = xfs_dmops_get(mp, args);
+	error = xfs_dmops_get(mp);
 	if (error)
-		goto out_free_mp;
-	error = xfs_qmops_get(mp, args);
+		goto out_free_fsname;
+	error = xfs_qmops_get(mp);
 	if (error)
 		goto out_put_dmops;
 
-	if (args->flags & XFSMNT_QUIET)
+	if (silent)
 		flags |= XFS_MFSI_QUIET;
 
-	error = xfs_open_devices(mp, args);
+	error = xfs_open_devices(mp);
 	if (error)
 		goto out_put_qmops;
 
 	if (xfs_icsb_init_counters(mp))
 		mp->m_flags |= XFS_MOUNT_NO_PERCPU_SB;
 
-	/*
-	 * Setup flags based on mount(2) options and then the superblock
-	 */
-	error = xfs_start_flags(args, mp);
-	if (error)
-		goto out_free_fsname;
 	error = xfs_readsb(mp, flags);
 	if (error)
-		goto out_free_fsname;
-	error = xfs_finish_flags(args, mp);
+		goto out_destroy_counters;
+
+	error = xfs_finish_flags(mp);
 	if (error)
 		goto out_free_sb;
 
@@ -1736,7 +1615,7 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_filestream_unmount;
 
-	XFS_SEND_MOUNT(mp, DM_RIGHT_NULL, args->mtpt, args->fsname);
+	XFS_SEND_MOUNT(mp, DM_RIGHT_NULL, mtpt, mp->m_fsname);
 
 	sb->s_dirt = 1;
 	sb->s_magic = XFS_SB_MAGIC;
@@ -1769,27 +1648,27 @@ xfs_fs_fill_super(
 		goto fail_vnrele;
 	}
 
-	xfs_itrace_exit(XFS_I(sb->s_root->d_inode));
+	kfree(mtpt);
 
-	kfree(args);
+	xfs_itrace_exit(XFS_I(sb->s_root->d_inode));
 	return 0;
 
  out_filestream_unmount:
 	xfs_filestream_unmount(mp);
  out_free_sb:
 	xfs_freesb(mp);
- out_free_fsname:
-	xfs_free_fsname(mp);
+ out_destroy_counters:
 	xfs_icsb_destroy_counters(mp);
 	xfs_close_devices(mp);
  out_put_qmops:
 	xfs_qmops_put(mp);
  out_put_dmops:
 	xfs_dmops_put(mp);
- out_free_mp:
+ out_free_fsname:
+	xfs_free_fsname(mp);
+	kfree(mtpt);
 	kfree(mp);
- out_free_args:
-	kfree(args);
+ out:
 	return -error;
 
  fail_vnrele:
Index: linux-2.6-xfs/fs/xfs/xfs_clnt.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_clnt.h	2008-05-25 16:23:44.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,105 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_CLNT_H__
-#define __XFS_CLNT_H__
-
-/*
- * XFS arguments structure, constructed from the arguments we
- * are passed via the mount system call.
- *
- * NOTE: The mount system call is handled differently between
- * Linux and IRIX.  In IRIX we worked work with a binary data
- * structure coming in across the syscall interface from user
- * space (the mount userspace knows about each filesystem type
- * and the set of valid options for it, and converts the users
- * argument string into a binary structure _before_ making the
- * system call), and the ABI issues that this implies.
- *
- * In Linux, we are passed a comma separated set of options;
- * ie. a NULL terminated string of characters.  Userspace mount
- * code does not have any knowledge of mount options expected by
- * each filesystem type and so each filesystem parses its mount
- * options in kernel space.
- *
- * For the Linux port, we kept this structure pretty much intact
- * and use it internally (because the existing code groks it).
- */
-struct xfs_mount_args {
-	int	flags;		/* flags -> see XFSMNT_... macros below */
-	int	flags2;		/* flags -> see XFSMNT2_... macros below */
-	int	logbufs;	/* Number of log buffers, -1 to default */
-	int	logbufsize;	/* Size of log buffers, -1 to default */
-	char	fsname[MAXNAMELEN+1];	/* data device name */
-	char	rtname[MAXNAMELEN+1];	/* realtime device filename */
-	char	logname[MAXNAMELEN+1];	/* journal device filename */
-	char	mtpt[MAXNAMELEN+1];	/* filesystem mount point */
-	int	sunit;		/* stripe unit (BBs) */
-	int	swidth;		/* stripe width (BBs), multiple of sunit */
-	uchar_t iosizelog;	/* log2 of the preferred I/O size */
-	int	ihashsize;	/* inode hash table size (buckets) */
-};
-
-/*
- * XFS mount option flags -- args->flags1
- */
-#define	XFSMNT_ATTR2		0x00000001	/* allow ATTR2 EA format */
-#define	XFSMNT_WSYNC		0x00000002	/* safe mode nfs mount
-						 * compatible */
-#define	XFSMNT_INO64		0x00000004	/* move inode numbers up
-						 * past 2^32 */
-#define XFSMNT_UQUOTA		0x00000008	/* user quota accounting */
-#define XFSMNT_PQUOTA		0x00000010	/* IRIX prj quota accounting */
-#define XFSMNT_UQUOTAENF	0x00000020	/* user quota limit
-						 * enforcement */
-#define XFSMNT_PQUOTAENF	0x00000040	/* IRIX project quota limit
-						 * enforcement */
-#define XFSMNT_QUIET		0x00000080	/* don't report mount errors */
-#define XFSMNT_NOALIGN		0x00000200	/* don't allocate at
-						 * stripe boundaries*/
-#define XFSMNT_RETERR		0x00000400	/* return error to user */
-#define XFSMNT_NORECOVERY	0x00000800	/* no recovery, implies
-						 * read-only mount */
-#define XFSMNT_SHARED		0x00001000	/* shared XFS mount */
-#define XFSMNT_IOSIZE		0x00002000	/* optimize for I/O size */
-#define XFSMNT_OSYNCISOSYNC	0x00004000	/* o_sync is REALLY o_sync */
-						/* (osyncisdsync is default) */
-#define XFSMNT_NOATTR2		0x00008000	/* turn off ATTR2 EA format */
-#define XFSMNT_32BITINODES	0x00200000	/* restrict inodes to 32
-						 * bits of address space */
-#define XFSMNT_GQUOTA		0x00400000	/* group quota accounting */
-#define XFSMNT_GQUOTAENF	0x00800000	/* group quota limit
-						 * enforcement */
-#define XFSMNT_NOUUID		0x01000000	/* Ignore fs uuid */
-#define XFSMNT_DMAPI		0x02000000	/* enable dmapi/xdsm */
-#define XFSMNT_BARRIER		0x04000000	/* use write barriers */
-#define XFSMNT_IKEEP		0x08000000	/* inode cluster delete */
-#define XFSMNT_SWALLOC		0x10000000	/* turn on stripe width
-						 * allocation */
-#define XFSMNT_DIRSYNC		0x40000000	/* sync creat,link,unlink,rename
-						 * symlink,mkdir,rmdir,mknod */
-#define XFSMNT_FLAGS2		0x80000000	/* more flags set in flags2 */
-
-/*
- * XFS mount option flags -- args->flags2
- */
-#define XFSMNT2_COMPAT_IOSIZE	0x00000001	/* don't report large preferred
-						 * I/O size in stat(2) */
-#define XFSMNT2_FILESTREAMS	0x00000002	/* enable the filestreams
-						 * allocator */
-
-#endif	/* __XFS_CLNT_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_dmops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dmops.c	2008-05-25 16:23:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dmops.c	2008-05-25 16:23:58.000000000 +0200
@@ -25,7 +25,6 @@
 #include "xfs_inum.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
-#include "xfs_clnt.h"
 
 
 static struct xfs_dmops xfs_dmcore_stub = {
@@ -38,9 +37,9 @@ static struct xfs_dmops xfs_dmcore_stub 
 };
 
 int
-xfs_dmops_get(struct xfs_mount *mp, struct xfs_mount_args *args)
+xfs_dmops_get(struct xfs_mount *mp)
 {
-	if (args->flags & XFSMNT_DMAPI) {
+	if (mp->m_flags & XFS_MOUNT_DMAPI) {
 		struct xfs_dmops *ops;
 
 		ops = symbol_get(xfs_dmcore_xfs);
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-05-25 16:23:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-05-25 16:23:58.000000000 +0200
@@ -540,9 +540,9 @@ extern void	xfs_sb_from_disk(struct xfs_
 extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
 extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
 
-extern int	xfs_dmops_get(struct xfs_mount *, struct xfs_mount_args *);
+extern int	xfs_dmops_get(struct xfs_mount *);
 extern void	xfs_dmops_put(struct xfs_mount *);
-extern int	xfs_qmops_get(struct xfs_mount *, struct xfs_mount_args *);
+extern int	xfs_qmops_get(struct xfs_mount *);
 extern void	xfs_qmops_put(struct xfs_mount *);
 
 extern struct xfs_dmops xfs_dmcore_xfs;
Index: linux-2.6-xfs/fs/xfs/xfs_qmops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_qmops.c	2008-05-25 16:23:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_qmops.c	2008-05-25 16:23:58.000000000 +0200
@@ -28,7 +28,6 @@
 #include "xfs_mount.h"
 #include "xfs_quota.h"
 #include "xfs_error.h"
-#include "xfs_clnt.h"
 
 
 STATIC struct xfs_dquot *
@@ -131,9 +130,11 @@ static struct xfs_qmops xfs_qmcore_stub 
 };
 
 int
-xfs_qmops_get(struct xfs_mount *mp, struct xfs_mount_args *args)
+xfs_qmops_get(struct xfs_mount *mp)
 {
-	if (args->flags & (XFSMNT_UQUOTA | XFSMNT_PQUOTA | XFSMNT_GQUOTA)) {
+	if (mp->m_qflags & (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
+			    XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
+			    XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE)) {
 		struct xfs_qmops *ops;
 
 		ops = symbol_get(xfs_qmcore_xfs);
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2008-05-25 16:23:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2008-05-25 16:23:58.000000000 +0200
@@ -49,7 +49,6 @@
 #include "xfs_extfree_item.h"
 #include "xfs_acl.h"
 #include "xfs_attr.h"
-#include "xfs_clnt.h"
 #include "xfs_mru_cache.h"
 #include "xfs_filestream.h"
 #include "xfs_fsops.h"
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-05-25 16:23:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-05-25 16:23:58.000000000 +0200
@@ -21,7 +21,6 @@
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
-#include "xfs_clnt.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-05-25 16:23:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-05-25 16:23:58.000000000 +0200
@@ -22,7 +22,6 @@
 #include "xfs_log.h"
 #include "xfs_imap.h"
 #include "xfs_inum.h"
-#include "xfs_clnt.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm.c	2008-05-25 16:23:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm.c	2008-05-25 16:23:58.000000000 +0200
@@ -20,7 +20,6 @@
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
-#include "xfs_clnt.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm_bhv.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm_bhv.c	2008-05-25 16:23:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm_bhv.c	2008-05-25 16:23:58.000000000 +0200
@@ -20,7 +20,6 @@
 #include "xfs_bit.h"
 #include "xfs_log.h"
 #include "xfs_inum.h"
-#include "xfs_clnt.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
