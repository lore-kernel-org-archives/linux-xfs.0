Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36766 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfETXRH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:17:07 -0400
Subject: [PATCH 03/12] libxfs: refactor online geometry queries
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 20 May 2019 16:17:00 -0700
Message-ID: <155839422001.68606.12869125311562128404.stgit@magnolia>
In-Reply-To: <155839420081.68606.4573219764134939943.stgit@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor all the open-coded XFS_IOC_FSGEOMETRY queries into a single
helper that we can use to standardize behaviors across mixed xfslibs
versions.  This is the prelude to introducing a new FSGEOMETRY version
in 5.2 and needing to fix the (relatively few) client programs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Makefile            |    9 +++++----
 fsr/xfs_fsr.c       |   25 +++----------------------
 growfs/Makefile     |    5 +++--
 growfs/xfs_growfs.c |   24 ++++++++----------------
 include/linux.h     |    5 +++++
 io/bmap.c           |    2 +-
 io/fsmap.c          |    2 +-
 io/open.c           |    2 +-
 io/stat.c           |    4 ++--
 libhandle/Makefile  |    2 +-
 libhandle/ioctl.c   |   26 ++++++++++++++++++++++++++
 quota/Makefile      |    4 ++--
 quota/free.c        |    5 ++---
 repair/Makefile     |    6 +++---
 repair/xfs_repair.c |    4 ++--
 rtcp/Makefile       |    3 +++
 rtcp/xfs_rtcp.c     |    6 +++---
 scrub/phase1.c      |    2 +-
 spaceman/Makefile   |    4 ++--
 spaceman/file.c     |    2 +-
 spaceman/info.c     |   24 +++++++-----------------
 21 files changed, 82 insertions(+), 84 deletions(-)
 create mode 100644 libhandle/ioctl.c


diff --git a/Makefile b/Makefile
index 9204bed8..b72a9209 100644
--- a/Makefile
+++ b/Makefile
@@ -99,14 +99,15 @@ $(LIB_SUBDIRS) $(TOOL_SUBDIRS): include libfrog
 $(DLIB_SUBDIRS) $(TOOL_SUBDIRS): libxfs
 db logprint: libxlog
 fsr: libhandle
-growfs: libxcmd
+growfs: libxcmd libhandle
 io: libxcmd libhandle
-quota: libxcmd
-repair: libxlog libxcmd
+quota: libxcmd libhandle
+repair: libxlog libxcmd libhandle
 copy: libxlog
 mkfs: libxcmd
-spaceman: libxcmd
+spaceman: libxcmd libhandle
 scrub: libhandle libxcmd
+rtcp: libhandle
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index fef6262c..968d133c 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -83,9 +83,8 @@ int cmp(const void *, const void *);
 static void tmp_init(char *mnt);
 static char * tmp_next(char *mnt);
 static void tmp_close(char *mnt);
-int xfs_getgeom(int , xfs_fsop_geom_v1_t * );
 
-static xfs_fsop_geom_v1_t fsgeom;	/* geometry of active mounted system */
+static struct xfs_fsop_geom fsgeom;	/* geometry of active mounted system */
 
 #define NMOUNT 64
 static int numfs;
@@ -102,12 +101,6 @@ static int	nfrags = 0;	/* Debug option: Coerse into specific number
 				 * of extents */
 static int	openopts = O_CREAT|O_EXCL|O_RDWR|O_DIRECT;
 
-static int
-xfs_fsgeometry(int fd, xfs_fsop_geom_v1_t *geom)
-{
-    return ioctl(fd, XFS_IOC_FSGEOMETRY_V1, geom);
-}
-
 static int
 xfs_bulkstat_single(int fd, xfs_ino_t *lastip, xfs_bstat_t *ubuffer)
 {
@@ -630,7 +623,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		return -1;
 	}
 
-	if (xfs_getgeom(fsfd, &fsgeom) < 0 ) {
+	if (xfs_fsgeometry(fsfd, &fsgeom) < 0 ) {
 		fsrprintf(_("Skipping %s: could not get XFS geometry\n"),
 			  mntdir);
 		close(fsfd);
@@ -772,7 +765,7 @@ fsrfile(char *fname, xfs_ino_t ino)
 	}
 
 	/* Get the fs geometry */
-	if (xfs_getgeom(fsfd, &fsgeom) < 0 ) {
+	if (xfs_fsgeometry(fsfd, &fsgeom) < 0 ) {
 		fsrprintf(_("Unable to get geom on fs for: %s\n"), fname);
 		goto out;
 	}
@@ -1612,18 +1605,6 @@ getnextents(int fd)
 	return(nextents);
 }
 
-/*
- * Get the fs geometry
- */
-int
-xfs_getgeom(int fd, xfs_fsop_geom_v1_t * fsgeom)
-{
-	if (xfs_fsgeometry(fd, fsgeom) < 0) {
-		return -1;
-	}
-	return 0;
-}
-
 /*
  * Get xfs realtime space information
  */
diff --git a/growfs/Makefile b/growfs/Makefile
index 4104cc0d..e0964587 100644
--- a/growfs/Makefile
+++ b/growfs/Makefile
@@ -9,7 +9,8 @@ LTCOMMAND = xfs_growfs
 
 CFILES = xfs_growfs.c
 
-LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LLDLIBS = $(LIBHANDLE) $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) \
+	  $(LIBPTHREAD)
 ifeq ($(ENABLE_READLINE),yes)
 LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
 endif
@@ -18,7 +19,7 @@ ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
 
-LTDEPENDENCIES = $(LIBXFS) $(LIBXCMD) $(LIBFROG)
+LTDEPENDENCIES = $(LIBHANDLE) $(LIBXFS) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
 default: depend $(LTCOMMAND)
diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 2af7e5ba..392e4a00 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -165,22 +165,14 @@ main(int argc, char **argv)
 	}
 
 	/* get the current filesystem size & geometry */
-	if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY, &geo) < 0) {
-		/*
-		 * OK, new xfsctl barfed - back off and try earlier version
-		 * as we're probably running an older kernel version.
-		 * Only field added in the v2 geometry xfsctl is "logsunit"
-		 * so we'll zero that out for later display (as zero).
-		 */
-		geo.logsunit = 0;
-		if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY_V1, &geo) < 0) {
-			fprintf(stderr, _(
-				"%s: cannot determine geometry of filesystem"
-				" mounted at %s: %s\n"),
-				progname, fname, strerror(errno));
-			exit(1);
-		}
+	if (xfs_fsgeometry(ffd, &geo)) {
+		fprintf(stderr, _(
+			"%s: cannot determine geometry of filesystem"
+			" mounted at %s: %s\n"),
+			progname, fname, strerror(errno));
+		exit(1);
 	}
+
 	isint = geo.logstart > 0;
 
 	/*
@@ -359,7 +351,7 @@ main(int argc, char **argv)
 		}
 	}
 
-	if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY_V1, &ngeo) < 0) {
+	if (xfs_fsgeometry(ffd, &ngeo)) {
 		fprintf(stderr, _("%s: XFS_IOC_FSGEOMETRY xfsctl failed: %s\n"),
 			progname, strerror(errno));
 		exit(1);
diff --git a/include/linux.h b/include/linux.h
index 8f3c32b0..5fe33117 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -323,4 +323,9 @@ fsmap_advance(
 #include <asm-generic/mman-common.h>
 #endif /* HAVE_MAP_SYNC */
 
+/* ioctl wrappers */
+
+struct xfs_fsop_geom;
+int xfs_fsgeometry(int fd, struct xfs_fsop_geom *fsgeo);
+
 #endif	/* __XFS_LINUX_H__ */
diff --git a/io/bmap.c b/io/bmap.c
index d408826a..9103fe72 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -105,7 +105,7 @@ bmap_f(
 		bmv_iflags &= ~(BMV_IF_PREALLOC|BMV_IF_NO_DMAPI_READ);
 
 	if (vflag) {
-		c = xfsctl(file->name, file->fd, XFS_IOC_FSGEOMETRY_V1, &fsgeo);
+		c = xfs_fsgeometry(file->fd, &fsgeo);
 		if (c < 0) {
 			fprintf(stderr,
 				_("%s: can't get geometry [\"%s\"]: %s\n"),
diff --git a/io/fsmap.c b/io/fsmap.c
index 477c36fc..9c310bd8 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -447,7 +447,7 @@ fsmap_f(
 	}
 
 	if (vflag) {
-		c = ioctl(file->fd, XFS_IOC_FSGEOMETRY, &fsgeo);
+		c = xfs_fsgeometry(file->fd, &fsgeo);
 		if (c < 0) {
 			fprintf(stderr,
 				_("%s: can't get geometry [\"%s\"]: %s\n"),
diff --git a/io/open.c b/io/open.c
index a406ea54..b6aacb83 100644
--- a/io/open.c
+++ b/io/open.c
@@ -118,7 +118,7 @@ openfile(
 	if (flags & IO_PATH) {
 		/* Can't call ioctl() on O_PATH fds */
 		memset(geom, 0, sizeof(*geom));
-	} else if (xfsctl(path, fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
+	} else if (xfs_fsgeometry(fd, geom)) {
 		perror("XFS_IOC_FSGEOMETRY");
 		close(fd);
 		return -1;
diff --git a/io/stat.c b/io/stat.c
index 37c0b2e8..5399ed4f 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -194,8 +194,8 @@ statfs_f(
 	}
 	if (file->flags & IO_FOREIGN)
 		return 0;
-	if ((xfsctl(file->name, file->fd, XFS_IOC_FSGEOMETRY_V1, &fsgeo)) < 0) {
-		perror("XFS_IOC_FSGEOMETRY_V1");
+	if (xfs_fsgeometry(file->fd, &fsgeo)) {
+		perror("XFS_IOC_FSGEOMETRY");
 	} else {
 		printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
 		printf(_("geom.agcount = %u\n"), fsgeo.agcount);
diff --git a/libhandle/Makefile b/libhandle/Makefile
index f297a59e..a358549c 100644
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -12,7 +12,7 @@ LT_AGE = 0
 
 LTLDFLAGS += -Wl,--version-script,libhandle.sym
 
-CFILES = handle.c jdm.c
+CFILES = handle.c ioctl.c jdm.c
 LSRCFILES = libhandle.sym
 
 default: ltdepend $(LTLIBRARY)
diff --git a/libhandle/ioctl.c b/libhandle/ioctl.c
new file mode 100644
index 00000000..5c954bd0
--- /dev/null
+++ b/libhandle/ioctl.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include <string.h>
+
+/* Wrappers for Linux ioctls. */
+
+/* Try to obtain the xfs geometry. */
+int
+xfs_fsgeometry(
+	int			fd,
+	struct xfs_fsop_geom	*fsgeo)
+{
+	int			ret;
+
+	memset(fsgeo, 0, sizeof(*fsgeo));
+
+	ret = ioctl(fd, XFS_IOC_FSGEOMETRY, fsgeo);
+	if (!ret)
+		return 0;
+
+	return ioctl(fd, XFS_IOC_FSGEOMETRY_V1, fsgeo);
+}
diff --git a/quota/Makefile b/quota/Makefile
index 384f023a..db6174b9 100644
--- a/quota/Makefile
+++ b/quota/Makefile
@@ -10,8 +10,8 @@ HFILES = init.h quota.h
 CFILES = init.c util.c \
 	edit.c free.c linux.c path.c project.c quot.c quota.c report.c state.c
 
-LLDLIBS = $(LIBXCMD) $(LIBFROG)
-LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
+LLDLIBS = $(LIBHANDLE) $(LIBXCMD) $(LIBFROG)
+LTDEPENDENCIES = $(LIBHANDLE) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static
 
 ifeq ($(ENABLE_READLINE),yes)
diff --git a/quota/free.c b/quota/free.c
index 1d13006e..e95af8eb 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -67,9 +67,8 @@ mount_free_space_data(
 	}
 
 	if (!(mount->fs_flags & FS_FOREIGN)) {
-		if ((xfsctl(mount->fs_dir, fd, XFS_IOC_FSGEOMETRY_V1,
-							&fsgeo)) < 0) {
-			perror("XFS_IOC_FSGEOMETRY_V1");
+		if (xfs_fsgeometry(fd, &fsgeo)) {
+			perror("XFS_IOC_FSGEOMETRY");
 			close(fd);
 			return 0;
 		}
diff --git a/repair/Makefile b/repair/Makefile
index 0964499a..a5cab8f1 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -20,9 +20,9 @@ CFILES = agheader.c attr_repair.c avl.c bmap.c btree.c \
 	progress.c prefetch.c rmap.c rt.c sb.c scan.c slab.c threads.c \
 	versions.c xfs_repair.c
 
-LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) \
-	$(LIBPTHREAD) $(LIBBLKID)
-LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG)
+LLDLIBS = $(LIBHANDLE) $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG) $(LIBUUID) \
+	  $(LIBRT) $(LIBPTHREAD) $(LIBBLKID)
+LTDEPENDENCIES = $(LIBHANDLE) $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
 default: depend $(LTCOMMAND)
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9657503f..a569b958 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -636,11 +636,11 @@ check_fs_vs_host_sectsize(
 {
 	int	fd;
 	long	old_flags;
-	struct xfs_fsop_geom_v1 geom = { 0 };
+	struct xfs_fsop_geom	geom = { 0 };
 
 	fd = libxfs_device_to_fd(x.ddev);
 
-	if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
+	if (xfs_fsgeometry(fd, &geom)) {
 		do_log(_("Cannot get host filesystem geometry.\n"
 	"Repair may fail if there is a sector size mismatch between\n"
 	"the image and the host filesystem.\n"));
diff --git a/rtcp/Makefile b/rtcp/Makefile
index 808b5378..e51ba165 100644
--- a/rtcp/Makefile
+++ b/rtcp/Makefile
@@ -9,6 +9,9 @@ LTCOMMAND = xfs_rtcp
 CFILES = xfs_rtcp.c
 LLDFLAGS = -static
 
+LLDLIBS = $(LIBHANDLE)
+LTDEPENDENCIES = $(LIBHANDLE)
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
index f928a86a..3a9e9a2f 100644
--- a/rtcp/xfs_rtcp.c
+++ b/rtcp/xfs_rtcp.c
@@ -368,8 +368,8 @@ rtcp( char *source, char *target, int fextsize)
 int
 xfsrtextsize( char *path)
 {
-	int fd, rval, rtextsize;
-	xfs_fsop_geom_v1_t geo;
+	struct xfs_fsop_geom	geo;
+	int			fd, rval, rtextsize;
 
 	fd = open( path, O_RDONLY );
 	if ( fd < 0 ) {
@@ -377,7 +377,7 @@ xfsrtextsize( char *path)
 			progname, path, strerror(errno));
 		return -1;
 	}
-	rval = xfsctl( path, fd, XFS_IOC_FSGEOMETRY_V1, &geo );
+	rval = xfs_fsgeometry(fd, &geo);
 	close(fd);
 	if ( rval < 0 )
 		return -1;
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 04a5f4a9..a4e9c9af 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -129,7 +129,7 @@ _("Does not appear to be an XFS filesystem!"));
 	}
 
 	/* Retrieve XFS geometry. */
-	error = ioctl(ctx->mnt_fd, XFS_IOC_FSGEOMETRY, &ctx->geo);
+	error = xfs_fsgeometry(ctx->mnt_fd, &ctx->geo);
 	if (error) {
 		str_errno(ctx, ctx->mntpoint);
 		return false;
diff --git a/spaceman/Makefile b/spaceman/Makefile
index b1c1b16d..69c70531 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -10,8 +10,8 @@ HFILES = init.h space.h
 CFILES = info.c init.c file.c prealloc.c trim.c
 LSRCFILES = xfs_info.sh
 
-LLDLIBS = $(LIBXCMD) $(LIBFROG)
-LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
+LLDLIBS = $(LIBHANDLE) $(LIBXCMD) $(LIBFROG)
+LTDEPENDENCIES = $(LIBHANDLE) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static
 
 ifeq ($(ENABLE_READLINE),yes)
diff --git a/spaceman/file.c b/spaceman/file.c
index 98549517..d2acf5db 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -56,7 +56,7 @@ openfile(
 		return -1;
 	}
 
-	if (ioctl(fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
+	if (xfs_fsgeometry(fd, geom)) {
 		if (errno == ENOTTY)
 			fprintf(stderr,
 _("%s: Not on a mounted XFS filesystem.\n"),
diff --git a/spaceman/info.c b/spaceman/info.c
index 01d0744a..bcefdcb8 100644
--- a/spaceman/info.c
+++ b/spaceman/info.c
@@ -37,24 +37,14 @@ info_f(
 	}
 
 	/* get the current filesystem size & geometry */
-	error = ioctl(file->fd, XFS_IOC_FSGEOMETRY, &geo);
+	error = xfs_fsgeometry(file->fd, &geo);
 	if (error) {
-		/*
-		 * OK, new xfsctl barfed - back off and try earlier version
-		 * as we're probably running an older kernel version.
-		 * Only field added in the v2 geometry xfsctl is "logsunit"
-		 * so we'll zero that out for later display (as zero).
-		 */
-		geo.logsunit = 0;
-		error = ioctl(file->fd, XFS_IOC_FSGEOMETRY_V1, &geo);
-		if (error) {
-			fprintf(stderr, _(
-				"%s: cannot determine geometry of filesystem"
-				" mounted at %s: %s\n"),
-				progname, file->name, strerror(errno));
-			exitcode = 1;
-			return 0;
-		}
+		fprintf(stderr, _(
+			"%s: cannot determine geometry of filesystem"
+			" mounted at %s: %s\n"),
+			progname, file->name, strerror(errno));
+		exitcode = 1;
+		return 0;
 	}
 
 	xfs_report_geom(&geo, file->fs_path.fs_name, file->fs_path.fs_log,
