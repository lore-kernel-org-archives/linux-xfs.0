Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42854 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfFTQtz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:49:55 -0400
Subject: [PATCH 03/12] libfrog: refactor online geometry queries
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jun 2019 09:49:48 -0700
Message-ID: <156104938862.1172531.12358975440415614734.stgit@magnolia>
In-Reply-To: <156104936953.1172531.2121427277342917243.stgit@magnolia>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
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
 Makefile            |    1 +
 fsr/xfs_fsr.c       |   26 ++++----------------------
 growfs/xfs_growfs.c |   25 +++++++++----------------
 include/xfrog.h     |   22 ++++++++++++++++++++++
 io/bmap.c           |    3 ++-
 io/fsmap.c          |    3 ++-
 io/open.c           |    3 ++-
 io/stat.c           |    5 +++--
 libfrog/fsgeom.c    |   18 ++++++++++++++++++
 quota/free.c        |    6 +++---
 repair/xfs_repair.c |    5 +++--
 rtcp/Makefile       |    3 +++
 rtcp/xfs_rtcp.c     |    7 ++++---
 scrub/phase1.c      |    3 ++-
 spaceman/file.c     |    3 ++-
 spaceman/info.c     |   25 ++++++++-----------------
 16 files changed, 88 insertions(+), 70 deletions(-)
 create mode 100644 include/xfrog.h


diff --git a/Makefile b/Makefile
index 9204bed8..0edc2700 100644
--- a/Makefile
+++ b/Makefile
@@ -107,6 +107,7 @@ copy: libxlog
 mkfs: libxcmd
 spaceman: libxcmd
 scrub: libhandle libxcmd
+rtcp: libfrog
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index fef6262c..0bfecf37 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -11,6 +11,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_attr_sf.h"
 #include "path.h"
+#include "xfrog.h"
 
 #include <fcntl.h>
 #include <errno.h>
@@ -83,9 +84,8 @@ int cmp(const void *, const void *);
 static void tmp_init(char *mnt);
 static char * tmp_next(char *mnt);
 static void tmp_close(char *mnt);
-int xfs_getgeom(int , xfs_fsop_geom_v1_t * );
 
-static xfs_fsop_geom_v1_t fsgeom;	/* geometry of active mounted system */
+static struct xfs_fsop_geom fsgeom;	/* geometry of active mounted system */
 
 #define NMOUNT 64
 static int numfs;
@@ -102,12 +102,6 @@ static int	nfrags = 0;	/* Debug option: Coerse into specific number
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
@@ -630,7 +624,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		return -1;
 	}
 
-	if (xfs_getgeom(fsfd, &fsgeom) < 0 ) {
+	if (xfrog_geometry(fsfd, &fsgeom) < 0 ) {
 		fsrprintf(_("Skipping %s: could not get XFS geometry\n"),
 			  mntdir);
 		close(fsfd);
@@ -772,7 +766,7 @@ fsrfile(char *fname, xfs_ino_t ino)
 	}
 
 	/* Get the fs geometry */
-	if (xfs_getgeom(fsfd, &fsgeom) < 0 ) {
+	if (xfrog_geometry(fsfd, &fsgeom) < 0 ) {
 		fsrprintf(_("Unable to get geom on fs for: %s\n"), fname);
 		goto out;
 	}
@@ -1612,18 +1606,6 @@ getnextents(int fd)
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
diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 20089d2b..28dd6d84 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -7,6 +7,7 @@
 #include "libxfs.h"
 #include "path.h"
 #include "fsgeom.h"
+#include "xfrog.h"
 
 static void
 usage(void)
@@ -165,22 +166,14 @@ main(int argc, char **argv)
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
+	if (xfrog_geometry(ffd, &geo)) {
+		fprintf(stderr, _(
+			"%s: cannot determine geometry of filesystem"
+			" mounted at %s: %s\n"),
+			progname, fname, strerror(errno));
+		exit(1);
 	}
+
 	isint = geo.logstart > 0;
 
 	/*
@@ -359,7 +352,7 @@ main(int argc, char **argv)
 		}
 	}
 
-	if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY_V1, &ngeo) < 0) {
+	if (xfrog_geometry(ffd, &ngeo)) {
 		fprintf(stderr, _("%s: XFS_IOC_FSGEOMETRY xfsctl failed: %s\n"),
 			progname, strerror(errno));
 		exit(1);
diff --git a/include/xfrog.h b/include/xfrog.h
new file mode 100644
index 00000000..5420b47c
--- /dev/null
+++ b/include/xfrog.h
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2002 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFROG_H__
+#define __XFROG_H__
+
+/*
+ * XFS Filesystem Random Online Gluecode
+ * =====================================
+ *
+ * These support functions wrap the more complex xfs ioctls so that xfs
+ * utilities can take advantage of them without having to deal with graceful
+ * degradation in the face of new ioctls.  They will also provide higher level
+ * abstractions when possible.
+ */
+
+struct xfs_fsop_geom;
+int xfrog_geometry(int fd, struct xfs_fsop_geom *fsgeo);
+
+#endif	/* __XFROG_H__ */
diff --git a/io/bmap.c b/io/bmap.c
index d408826a..5f0d12ca 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -9,6 +9,7 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
+#include "xfrog.h"
 
 static cmdinfo_t bmap_cmd;
 
@@ -105,7 +106,7 @@ bmap_f(
 		bmv_iflags &= ~(BMV_IF_PREALLOC|BMV_IF_NO_DMAPI_READ);
 
 	if (vflag) {
-		c = xfsctl(file->name, file->fd, XFS_IOC_FSGEOMETRY_V1, &fsgeo);
+		c = xfrog_geometry(file->fd, &fsgeo);
 		if (c < 0) {
 			fprintf(stderr,
 				_("%s: can't get geometry [\"%s\"]: %s\n"),
diff --git a/io/fsmap.c b/io/fsmap.c
index 477c36fc..d3ff7dea 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -9,6 +9,7 @@
 #include "path.h"
 #include "io.h"
 #include "input.h"
+#include "xfrog.h"
 
 static cmdinfo_t	fsmap_cmd;
 static dev_t		xfs_data_dev;
@@ -447,7 +448,7 @@ fsmap_f(
 	}
 
 	if (vflag) {
-		c = ioctl(file->fd, XFS_IOC_FSGEOMETRY, &fsgeo);
+		c = xfrog_geometry(file->fd, &fsgeo);
 		if (c < 0) {
 			fprintf(stderr,
 				_("%s: can't get geometry [\"%s\"]: %s\n"),
diff --git a/io/open.c b/io/open.c
index c7f5248a..997df119 100644
--- a/io/open.c
+++ b/io/open.c
@@ -9,6 +9,7 @@
 #include "init.h"
 #include "io.h"
 #include "libxfs.h"
+#include "xfrog.h"
 
 #ifndef __O_TMPFILE
 #if defined __alpha__
@@ -118,7 +119,7 @@ openfile(
 	if (flags & IO_PATH) {
 		/* Can't call ioctl() on O_PATH fds */
 		memset(geom, 0, sizeof(*geom));
-	} else if (xfsctl(path, fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
+	} else if (xfrog_geometry(fd, geom)) {
 		perror("XFS_IOC_FSGEOMETRY");
 		close(fd);
 		return -1;
diff --git a/io/stat.c b/io/stat.c
index 37c0b2e8..26b4eb68 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -12,6 +12,7 @@
 #include "io.h"
 #include "statx.h"
 #include "libxfs.h"
+#include "xfrog.h"
 
 #include <fcntl.h>
 
@@ -194,8 +195,8 @@ statfs_f(
 	}
 	if (file->flags & IO_FOREIGN)
 		return 0;
-	if ((xfsctl(file->name, file->fd, XFS_IOC_FSGEOMETRY_V1, &fsgeo)) < 0) {
-		perror("XFS_IOC_FSGEOMETRY_V1");
+	if (xfrog_geometry(file->fd, &fsgeo)) {
+		perror("XFS_IOC_FSGEOMETRY");
 	} else {
 		printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
 		printf(_("geom.agcount = %u\n"), fsgeo.agcount);
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 8879d161..a6dab3a8 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -4,6 +4,7 @@
  */
 #include "libxfs.h"
 #include "fsgeom.h"
+#include "xfrog.h"
 
 void
 xfs_report_geom(
@@ -67,3 +68,20 @@ xfs_report_geom(
 		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
 			(unsigned long long)geo->rtextents);
 }
+
+/* Try to obtain the xfs geometry. */
+int
+xfrog_geometry(
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
diff --git a/quota/free.c b/quota/free.c
index 1d13006e..f47001bf 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -8,6 +8,7 @@
 #include "command.h"
 #include "init.h"
 #include "quota.h"
+#include "xfrog.h"
 
 static cmdinfo_t free_cmd;
 
@@ -67,9 +68,8 @@ mount_free_space_data(
 	}
 
 	if (!(mount->fs_flags & FS_FOREIGN)) {
-		if ((xfsctl(mount->fs_dir, fd, XFS_IOC_FSGEOMETRY_V1,
-							&fsgeo)) < 0) {
-			perror("XFS_IOC_FSGEOMETRY_V1");
+		if (xfrog_geometry(fd, &fsgeo)) {
+			perror("XFS_IOC_FSGEOMETRY");
 			close(fd);
 			return 0;
 		}
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9657503f..e6717d3c 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -22,6 +22,7 @@
 #include "dinode.h"
 #include "slab.h"
 #include "rmap.h"
+#include "xfrog.h"
 
 /*
  * option tables for getsubopt calls
@@ -636,11 +637,11 @@ check_fs_vs_host_sectsize(
 {
 	int	fd;
 	long	old_flags;
-	struct xfs_fsop_geom_v1 geom = { 0 };
+	struct xfs_fsop_geom	geom = { 0 };
 
 	fd = libxfs_device_to_fd(x.ddev);
 
-	if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
+	if (xfrog_geometry(fd, &geom)) {
 		do_log(_("Cannot get host filesystem geometry.\n"
 	"Repair may fail if there is a sector size mismatch between\n"
 	"the image and the host filesystem.\n"));
diff --git a/rtcp/Makefile b/rtcp/Makefile
index 808b5378..264b4f27 100644
--- a/rtcp/Makefile
+++ b/rtcp/Makefile
@@ -9,6 +9,9 @@ LTCOMMAND = xfs_rtcp
 CFILES = xfs_rtcp.c
 LLDFLAGS = -static
 
+LLDLIBS = $(LIBFROG)
+LTDEPENDENCIES = $(LIBFROG)
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
index f928a86a..0b37ee89 100644
--- a/rtcp/xfs_rtcp.c
+++ b/rtcp/xfs_rtcp.c
@@ -5,6 +5,7 @@
  */
 
 #include "libxfs.h"
+#include "xfrog.h"
 
 int rtcp(char *, char *, int);
 int xfsrtextsize(char *path);
@@ -368,8 +369,8 @@ rtcp( char *source, char *target, int fextsize)
 int
 xfsrtextsize( char *path)
 {
-	int fd, rval, rtextsize;
-	xfs_fsop_geom_v1_t geo;
+	struct xfs_fsop_geom	geo;
+	int			fd, rval, rtextsize;
 
 	fd = open( path, O_RDONLY );
 	if ( fd < 0 ) {
@@ -377,7 +378,7 @@ xfsrtextsize( char *path)
 			progname, path, strerror(errno));
 		return -1;
 	}
-	rval = xfsctl( path, fd, XFS_IOC_FSGEOMETRY_V1, &geo );
+	rval = xfrog_geometry(fd, &geo);
 	close(fd);
 	if ( rval < 0 )
 		return -1;
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 04a5f4a9..5ab2a4fe 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -26,6 +26,7 @@
 #include "disk.h"
 #include "scrub.h"
 #include "repair.h"
+#include "xfrog.h"
 
 /* Phase 1: Find filesystem geometry (and clean up after) */
 
@@ -129,7 +130,7 @@ _("Does not appear to be an XFS filesystem!"));
 	}
 
 	/* Retrieve XFS geometry. */
-	error = ioctl(ctx->mnt_fd, XFS_IOC_FSGEOMETRY, &ctx->geo);
+	error = xfrog_geometry(ctx->mnt_fd, &ctx->geo);
 	if (error) {
 		str_errno(ctx, ctx->mntpoint);
 		return false;
diff --git a/spaceman/file.c b/spaceman/file.c
index 7e33e07e..9e983d79 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -6,6 +6,7 @@
  */
 
 #include "libxfs.h"
+#include "xfrog.h"
 #include <sys/mman.h>
 #include "command.h"
 #include "input.h"
@@ -56,7 +57,7 @@ openfile(
 		return -1;
 	}
 
-	if (ioctl(fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
+	if (xfrog_geometry(fd, geom)) {
 		if (errno == ENOTTY)
 			fprintf(stderr,
 _("%s: Not on a mounted XFS filesystem.\n"),
diff --git a/spaceman/info.c b/spaceman/info.c
index 01d0744a..e4dedee2 100644
--- a/spaceman/info.c
+++ b/spaceman/info.c
@@ -4,6 +4,7 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "libxfs.h"
+#include "xfrog.h"
 #include "command.h"
 #include "init.h"
 #include "path.h"
@@ -37,24 +38,14 @@ info_f(
 	}
 
 	/* get the current filesystem size & geometry */
-	error = ioctl(file->fd, XFS_IOC_FSGEOMETRY, &geo);
+	error = xfrog_geometry(file->fd, &geo);
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
