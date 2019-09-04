Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B30C3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BA6621883
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:35:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D/X5bbJ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbfIDEfS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:35:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56672 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfIDEfO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:35:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844Xk9i038323;
        Wed, 4 Sep 2019 04:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=CZnLNVr9Gg4SoH5FVM/vt/8hSddoH1p5QFtGHs3UOuE=;
 b=D/X5bbJ8WDmOSC+e87WOILuaormyRm9YPw42uwtwK6L6pFETD496Eqx3RfPHmnq5SZMs
 iuhAaPaGBKxMZl3WdV7VMqqPyTeROfpBdU5Kl55IIrl5jvCdu1BZQBcEB/RLFQS9Psop
 QtTdP8dIIOV88Chk1RgDb1w7G9FmFGuyd1RS+SxXkecm3V6nvmHJWrRHgYDJ1WC7Wjcu
 N+Hi5Zgd2d++XHk3tc2/b1IKlzwMi6u95SvbQ06b2Hu8++WiwFHciApJCeR060jQRZXo
 tVdgFadxYA59yr53OEk9CXb9+SSQZW0p1eQYB8e2hsagfW2arqqc4MmJkoo/WEZAED8X MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ut69m80me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:34:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XiM9162923;
        Wed, 4 Sep 2019 04:34:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2usu52bete-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:34:59 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844Ywbv022758;
        Wed, 4 Sep 2019 04:34:58 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:34:57 -0700
Subject: [PATCH 2/8] libfrog: refactor online geometry queries
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>
Date:   Tue, 03 Sep 2019 21:34:56 -0700
Message-ID: <156757169641.1836891.7308269834087859806.stgit@magnolia>
In-Reply-To: <156757168368.1836891.15043200811666785244.stgit@magnolia>
References: <156757168368.1836891.15043200811666785244.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor all the open-coded XFS_IOC_FSGEOMETRY queries into a single
helper that we can use to standardize behaviors across mixed xfslibs
versions.  This is the prelude to introducing a new FSGEOMETRY version
in 5.2 and needing to fix the (relatively few) client programs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 Makefile            |    1 +
 fsr/xfs_fsr.c       |   28 ++++++----------------------
 growfs/xfs_growfs.c |   28 +++++++++++-----------------
 include/fsgeom.h    |    1 +
 io/bmap.c           |    7 ++++---
 io/fsmap.c          |    5 +++--
 io/open.c           |   15 +++++++++++----
 io/stat.c           |    8 ++++++--
 libfrog/fsgeom.c    |   25 +++++++++++++++++++++++++
 quota/free.c        |   10 ++++++----
 repair/xfs_repair.c |    8 +++++---
 rtcp/Makefile       |    3 +++
 rtcp/xfs_rtcp.c     |    9 +++++----
 scrub/common.h      |    2 ++
 scrub/phase1.c      |    5 +++--
 spaceman/file.c     |   12 ++++++++----
 spaceman/info.c     |   23 ++++++-----------------
 17 files changed, 106 insertions(+), 84 deletions(-)


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
index 1963a05e..50faddc8 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -11,6 +11,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_attr_sf.h"
 #include "path.h"
+#include "fsgeom.h"
 
 #include <fcntl.h>
 #include <errno.h>
@@ -83,9 +84,8 @@ int cmp(const void *, const void *);
 static void tmp_init(char *mnt);
 static char * tmp_next(char *mnt);
 static void tmp_close(char *mnt);
-int xfs_getgeom(int , struct xfs_fsop_geom_v1 * );
 
-static struct xfs_fsop_geom_v1 fsgeom;	/* geometry of active mounted system */
+static struct xfs_fsop_geom fsgeom;	/* geometry of active mounted system */
 
 #define NMOUNT 64
 static int numfs;
@@ -102,12 +102,6 @@ static int	nfrags = 0;	/* Debug option: Coerse into specific number
 				 * of extents */
 static int	openopts = O_CREAT|O_EXCL|O_RDWR|O_DIRECT;
 
-static int
-xfs_fsgeometry(int fd, struct xfs_fsop_geom_v1 *geom)
-{
-    return ioctl(fd, XFS_IOC_FSGEOMETRY_V1, geom);
-}
-
 static int
 xfs_bulkstat_single(int fd, xfs_ino_t *lastip, struct xfs_bstat *ubuffer)
 {
@@ -630,7 +624,8 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		return -1;
 	}
 
-	if (xfs_getgeom(fsfd, &fsgeom) < 0 ) {
+	ret = xfrog_geometry(fsfd, &fsgeom);
+	if (ret) {
 		fsrprintf(_("Skipping %s: could not get XFS geometry\n"),
 			  mntdir);
 		close(fsfd);
@@ -772,7 +767,8 @@ fsrfile(char *fname, xfs_ino_t ino)
 	}
 
 	/* Get the fs geometry */
-	if (xfs_getgeom(fsfd, &fsgeom) < 0 ) {
+	error = xfrog_geometry(fsfd, &fsgeom);
+	if (error) {
 		fsrprintf(_("Unable to get geom on fs for: %s\n"), fname);
 		goto out;
 	}
@@ -1612,18 +1608,6 @@ getnextents(int fd)
 	return(nextents);
 }
 
-/*
- * Get the fs geometry
- */
-int
-xfs_getgeom(int fd, struct xfs_fsop_geom_v1 *fsgeom)
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
index 20089d2b..4d48617a 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -63,6 +63,7 @@ main(int argc, char **argv)
 	fs_path_t		*fs;	/* mount point information */
 	libxfs_init_t		xi;	/* libxfs structure */
 	char			rpath[PATH_MAX];
+	int			ret;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
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
+	ret = xfrog_geometry(ffd, &geo);
+	if (ret) {
+		fprintf(stderr,
+	_("%s: cannot determine geometry of filesystem mounted at %s: %s\n"),
+			progname, fname, strerror(ret));
+		exit(1);
 	}
+
 	isint = geo.logstart > 0;
 
 	/*
@@ -359,9 +352,10 @@ main(int argc, char **argv)
 		}
 	}
 
-	if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY_V1, &ngeo) < 0) {
+	ret = xfrog_geometry(ffd, &ngeo);
+	if (ret) {
 		fprintf(stderr, _("%s: XFS_IOC_FSGEOMETRY xfsctl failed: %s\n"),
-			progname, strerror(errno));
+			progname, strerror(ret));
 		exit(1);
 	}
 	if (geo.datablocks != ngeo.datablocks)
diff --git a/include/fsgeom.h b/include/fsgeom.h
index ed8c9b1e..8ea16a35 100644
--- a/include/fsgeom.h
+++ b/include/fsgeom.h
@@ -7,5 +7,6 @@
 
 void xfs_report_geom(struct xfs_fsop_geom *geo, const char *mntpoint,
 		const char *logname, const char *rtname);
+int xfrog_geometry(int fd, struct xfs_fsop_geom *fsgeo);
 
 #endif /* _LIBFROG_FSGEOM_H_ */
diff --git a/io/bmap.c b/io/bmap.c
index d408826a..d4262cf2 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -9,6 +9,7 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
+#include "fsgeom.h"
 
 static cmdinfo_t bmap_cmd;
 
@@ -105,11 +106,11 @@ bmap_f(
 		bmv_iflags &= ~(BMV_IF_PREALLOC|BMV_IF_NO_DMAPI_READ);
 
 	if (vflag) {
-		c = xfsctl(file->name, file->fd, XFS_IOC_FSGEOMETRY_V1, &fsgeo);
-		if (c < 0) {
+		c = xfrog_geometry(file->fd, &fsgeo);
+		if (c) {
 			fprintf(stderr,
 				_("%s: can't get geometry [\"%s\"]: %s\n"),
-				progname, file->name, strerror(errno));
+				progname, file->name, strerror(c));
 			exitcode = 1;
 			return 0;
 		}
diff --git a/io/fsmap.c b/io/fsmap.c
index 477c36fc..67baa817 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -9,6 +9,7 @@
 #include "path.h"
 #include "io.h"
 #include "input.h"
+#include "fsgeom.h"
 
 static cmdinfo_t	fsmap_cmd;
 static dev_t		xfs_data_dev;
@@ -447,8 +448,8 @@ fsmap_f(
 	}
 
 	if (vflag) {
-		c = ioctl(file->fd, XFS_IOC_FSGEOMETRY, &fsgeo);
-		if (c < 0) {
+		c = xfrog_geometry(file->fd, &fsgeo);
+		if (c) {
 			fprintf(stderr,
 				_("%s: can't get geometry [\"%s\"]: %s\n"),
 				progname, file->name, strerror(errno));
diff --git a/io/open.c b/io/open.c
index c7f5248a..ba6c4969 100644
--- a/io/open.c
+++ b/io/open.c
@@ -9,6 +9,7 @@
 #include "init.h"
 #include "io.h"
 #include "libxfs.h"
+#include "fsgeom.h"
 
 #ifndef __O_TMPFILE
 #if defined __alpha__
@@ -118,10 +119,16 @@ openfile(
 	if (flags & IO_PATH) {
 		/* Can't call ioctl() on O_PATH fds */
 		memset(geom, 0, sizeof(*geom));
-	} else if (xfsctl(path, fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
-		perror("XFS_IOC_FSGEOMETRY");
-		close(fd);
-		return -1;
+	} else {
+		int	ret;
+
+		ret = xfrog_geometry(fd, geom);
+		if (ret) {
+			errno = ret;
+			perror("XFS_IOC_FSGEOMETRY");
+			close(fd);
+			return -1;
+		}
 	}
 
 	if (!(flags & (IO_READONLY | IO_PATH)) && (flags & IO_REALTIME)) {
diff --git a/io/stat.c b/io/stat.c
index 37c0b2e8..4c1cc83d 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -12,6 +12,7 @@
 #include "io.h"
 #include "statx.h"
 #include "libxfs.h"
+#include "fsgeom.h"
 
 #include <fcntl.h>
 
@@ -178,6 +179,7 @@ statfs_f(
 	struct xfs_fsop_counts	fscounts;
 	struct xfs_fsop_geom	fsgeo;
 	struct statfs		st;
+	int			ret;
 
 	printf(_("fd.path = \"%s\"\n"), file->name);
 	if (platform_fstatfs(file->fd, &st) < 0) {
@@ -194,8 +196,10 @@ statfs_f(
 	}
 	if (file->flags & IO_FOREIGN)
 		return 0;
-	if ((xfsctl(file->name, file->fd, XFS_IOC_FSGEOMETRY_V1, &fsgeo)) < 0) {
-		perror("XFS_IOC_FSGEOMETRY_V1");
+	ret = xfrog_geometry(file->fd, &fsgeo);
+	if (ret) {
+		errno = ret;
+		perror("XFS_IOC_FSGEOMETRY");
 	} else {
 		printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
 		printf(_("geom.agcount = %u\n"), fsgeo.agcount);
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 8879d161..20a92ec1 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -67,3 +67,28 @@ xfs_report_geom(
 		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
 			(unsigned long long)geo->rtextents);
 }
+
+/* Try to obtain the xfs geometry.  On error returns a positive error code. */
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
+	ret = ioctl(fd, XFS_IOC_FSGEOMETRY_V4, fsgeo);
+	if (!ret)
+		return 0;
+
+	ret = ioctl(fd, XFS_IOC_FSGEOMETRY_V1, fsgeo);
+	if (!ret)
+		return 0;
+
+	return errno;
+}
diff --git a/quota/free.c b/quota/free.c
index 1d13006e..a8b6bd1f 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -8,6 +8,7 @@
 #include "command.h"
 #include "init.h"
 #include "quota.h"
+#include "fsgeom.h"
 
 static cmdinfo_t free_cmd;
 
@@ -51,7 +52,7 @@ mount_free_space_data(
 	struct xfs_fsop_geom	fsgeo;
 	struct statfs		st;
 	uint64_t		logsize, count, free;
-	int			fd;
+	int			fd, ret;
 
 	if ((fd = open(mount->fs_dir, O_RDONLY)) < 0) {
 		exitcode = 1;
@@ -67,9 +68,10 @@ mount_free_space_data(
 	}
 
 	if (!(mount->fs_flags & FS_FOREIGN)) {
-		if ((xfsctl(mount->fs_dir, fd, XFS_IOC_FSGEOMETRY_V1,
-							&fsgeo)) < 0) {
-			perror("XFS_IOC_FSGEOMETRY_V1");
+		ret = xfrog_geometry(fd, &fsgeo);
+		if (ret) {
+			errno = ret;
+			perror("XFS_IOC_FSGEOMETRY");
 			close(fd);
 			return 0;
 		}
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index ce70e2de..e414c4fb 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -22,6 +22,7 @@
 #include "dinode.h"
 #include "slab.h"
 #include "rmap.h"
+#include "fsgeom.h"
 
 /*
  * option tables for getsubopt calls
@@ -634,13 +635,14 @@ static void
 check_fs_vs_host_sectsize(
 	struct xfs_sb	*sb)
 {
-	int	fd;
+	int	fd, ret;
 	long	old_flags;
-	struct xfs_fsop_geom_v1 geom = { 0 };
+	struct xfs_fsop_geom	geom = { 0 };
 
 	fd = libxfs_device_to_fd(x.ddev);
 
-	if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
+	ret = xfrog_geometry(fd, &geom);
+	if (ret) {
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
index 1027c913..f6ef0e6c 100644
--- a/rtcp/xfs_rtcp.c
+++ b/rtcp/xfs_rtcp.c
@@ -5,6 +5,7 @@
  */
 
 #include "libxfs.h"
+#include "fsgeom.h"
 
 int rtcp(char *, char *, int);
 int xfsrtextsize(char *path);
@@ -368,8 +369,8 @@ rtcp( char *source, char *target, int fextsize)
 int
 xfsrtextsize( char *path)
 {
-	int fd, rval, rtextsize;
-	struct xfs_fsop_geom_v1 geo;
+	struct xfs_fsop_geom	geo;
+	int			fd, rval, rtextsize;
 
 	fd = open( path, O_RDONLY );
 	if ( fd < 0 ) {
@@ -377,9 +378,9 @@ xfsrtextsize( char *path)
 			progname, path, strerror(errno));
 		return -1;
 	}
-	rval = xfsctl( path, fd, XFS_IOC_FSGEOMETRY_V1, &geo );
+	rval = xfrog_geometry(fd, &geo);
 	close(fd);
-	if ( rval < 0 )
+	if (rval)
 		return -1;
 
 	rtextsize = geo.rtextsize * geo.blocksize;
diff --git a/scrub/common.h b/scrub/common.h
index e85a0333..33555891 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -28,6 +28,8 @@ void __str_out(struct scrub_ctx *ctx, const char *descr, enum error_level level,
 
 #define str_errno(ctx, str) \
 	__str_out(ctx, str, S_ERROR,	errno,	__FILE__, __LINE__, NULL)
+#define str_liberror(ctx, error, str) \
+	__str_out(ctx, str, S_ERROR,	error,	__FILE__, __LINE__, NULL)
 #define str_error(ctx, str, ...) \
 	__str_out(ctx, str, S_ERROR,	0,	__FILE__, __LINE__, __VA_ARGS__)
 #define str_warn(ctx, str, ...) \
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 04a5f4a9..9a2edf29 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -26,6 +26,7 @@
 #include "disk.h"
 #include "scrub.h"
 #include "repair.h"
+#include "fsgeom.h"
 
 /* Phase 1: Find filesystem geometry (and clean up after) */
 
@@ -129,9 +130,9 @@ _("Does not appear to be an XFS filesystem!"));
 	}
 
 	/* Retrieve XFS geometry. */
-	error = ioctl(ctx->mnt_fd, XFS_IOC_FSGEOMETRY, &ctx->geo);
+	error = xfrog_geometry(ctx->mnt_fd, &ctx->geo);
 	if (error) {
-		str_errno(ctx, ctx->mntpoint);
+		str_liberror(ctx, error, _("Retrieving XFS geometry"));
 		return false;
 	}
 
diff --git a/spaceman/file.c b/spaceman/file.c
index 7e33e07e..72ef27f3 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -12,6 +12,7 @@
 #include "init.h"
 #include "path.h"
 #include "space.h"
+#include "fsgeom.h"
 
 static cmdinfo_t print_cmd;
 
@@ -48,7 +49,7 @@ openfile(
 	struct fs_path	*fs_path)
 {
 	struct fs_path	*fsp;
-	int		fd;
+	int		fd, ret;
 
 	fd = open(path, 0);
 	if (fd < 0) {
@@ -56,13 +57,16 @@ openfile(
 		return -1;
 	}
 
-	if (ioctl(fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
-		if (errno == ENOTTY)
+	ret = xfrog_geometry(fd, geom);
+	if (ret) {
+		if (ret == ENOTTY)
 			fprintf(stderr,
 _("%s: Not on a mounted XFS filesystem.\n"),
 					path);
-		else
+		else {
+			errno = ret;
 			perror("XFS_IOC_FSGEOMETRY");
+		}
 		close(fd);
 		return -1;
 	}
diff --git a/spaceman/info.c b/spaceman/info.c
index 01d0744a..151594a8 100644
--- a/spaceman/info.c
+++ b/spaceman/info.c
@@ -37,24 +37,13 @@ info_f(
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
+		fprintf(stderr,
+	_("%s: cannot determine geometry of filesystem mounted at %s: %s\n"),
+			progname, file->name, strerror(error));
+		exitcode = 1;
+		return 0;
 	}
 
 	xfs_report_geom(&geo, file->fs_path.fs_name, file->fs_path.fs_log,

