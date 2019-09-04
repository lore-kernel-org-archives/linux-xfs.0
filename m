Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC8D2C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7393F23402
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 06:14:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JCYX88nx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfIDGOM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 02:14:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40998 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfIDGOL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 02:14:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8469CA7117653;
        Wed, 4 Sep 2019 06:14:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=LP1tp8BU4JX2FoIttcX7G9qkxfepdxUiv5C89OM4FoU=;
 b=JCYX88nxzidmp8cswmRMDaaqXLgjnz0GB6OhedjN1UAaq880Ys7IyDhdUrVhMWW3dKaP
 mxGr1AUEuw4Jq5Q6xDpmhHGLv8KUpU5qtBqPl88Tze6h3PT+4+YozX1UZgnvCySyiOix
 5eeiB25jTeRwWWxmUrMzzXYjjwoRRjfFsYWCRDR3tU4HUWhcJp1uD21s18BYhDSPcNU9
 iRyL1iJ0LpHzGBM96zH92XEY5PDA3v6idkGkWSHPxqFZ4VQHM/TGkYfpwnHqQ9jjp9qp
 or/5MD30aUV2LzODPiX0PHsLXynEe7ufcEH9XAZPxEvVCWYlf4iD8UOGfe8aEXkL3MjT MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ut7qrg2wt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 06:14:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844cbmo035769;
        Wed, 4 Sep 2019 04:38:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2usu51c5us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:38:42 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844cfeU016869;
        Wed, 4 Sep 2019 04:38:41 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:38:41 -0700
Subject: [PATCH 3/4] xfs_spaceman: embed struct xfs_fd in struct fileio
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:38:35 -0700
Message-ID: <156757191522.1838733.5801986036398693019.stgit@magnolia>
In-Reply-To: <156757189636.1838733.8025635445292375382.stgit@magnolia>
References: <156757189636.1838733.8025635445292375382.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040066
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the open-coded fd and geometry fields of struct fileio with a
single xfs_fd, which will enable us to use it natively throughout
xfs_spaceman in upcoming patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 spaceman/file.c     |   31 +++++++++++--------------------
 spaceman/freesp.c   |   30 +++++++++++++++++-------------
 spaceman/info.c     |   19 +++----------------
 spaceman/init.c     |   11 +++++++----
 spaceman/prealloc.c |   15 ++++++++-------
 spaceman/space.h    |    9 +++++----
 spaceman/trim.c     |   40 +++++++++++++++++++++-------------------
 7 files changed, 72 insertions(+), 83 deletions(-)


diff --git a/spaceman/file.c b/spaceman/file.c
index 29b7d9ce..43b87e14 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -11,8 +11,8 @@
 #include "input.h"
 #include "init.h"
 #include "libfrog/paths.h"
-#include "space.h"
 #include "libfrog/fsgeom.h"
+#include "space.h"
 
 static cmdinfo_t print_cmd;
 
@@ -45,19 +45,13 @@ print_f(
 int
 openfile(
 	char		*path,
-	struct xfs_fsop_geom *geom,
+	struct xfs_fd	*xfd,
 	struct fs_path	*fs_path)
 {
 	struct fs_path	*fsp;
-	int		fd, ret;
-
-	fd = open(path, 0);
-	if (fd < 0) {
-		perror(path);
-		return -1;
-	}
+	int		ret;
 
-	ret = xfrog_geometry(fd, geom);
+	ret = xfd_open(xfd, path, O_RDONLY);
 	if (ret) {
 		if (ret == ENOTTY)
 			fprintf(stderr,
@@ -65,9 +59,8 @@ _("%s: Not on a mounted XFS filesystem.\n"),
 					path);
 		else {
 			errno = ret;
-			perror("XFS_IOC_FSGEOMETRY");
+			perror(path);
 		}
-		close(fd);
 		return -1;
 	}
 
@@ -75,19 +68,18 @@ _("%s: Not on a mounted XFS filesystem.\n"),
 	if (!fsp) {
 		fprintf(stderr, _("%s: cannot find mount point."),
 			path);
-		close(fd);
+		xfd_close(xfd);
 		return -1;
 	}
 	memcpy(fs_path, fsp, sizeof(struct fs_path));
 
-	return fd;
+	return xfd->fd;
 }
 
 int
 addfile(
 	char		*name,
-	int		fd,
-	struct xfs_fsop_geom *geometry,
+	struct xfs_fd	*xfd,
 	struct fs_path	*fs_path)
 {
 	char		*filename;
@@ -95,7 +87,7 @@ addfile(
 	filename = strdup(name);
 	if (!filename) {
 		perror("strdup");
-		close(fd);
+		xfd_close(xfd);
 		return -1;
 	}
 
@@ -106,15 +98,14 @@ addfile(
 		perror("realloc");
 		filecount = 0;
 		free(filename);
-		close(fd);
+		xfd_close(xfd);
 		return -1;
 	}
 
 	/* Finally, make this the new active open file */
 	file = &filetable[filecount - 1];
-	file->fd = fd;
 	file->name = filename;
-	file->geom = *geometry;
+	memcpy(&file->xfd, xfd, sizeof(struct xfs_fd));
 	memcpy(&file->fs_path, fs_path, sizeof(file->fs_path));
 	return 0;
 }
diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index 527ecb52..f30171f0 100644
--- a/spaceman/freesp.c
+++ b/spaceman/freesp.c
@@ -8,6 +8,7 @@
 
 #include "libxfs.h"
 #include <linux/fiemap.h>
+#include "libfrog/fsgeom.h"
 #include "command.h"
 #include "init.h"
 #include "libfrog/paths.h"
@@ -149,7 +150,8 @@ scan_ag(
 	struct fsmap		*extent;
 	struct fsmap		*l, *h;
 	struct fsmap		*p;
-	off64_t			blocksize = file->geom.blocksize;
+	struct xfs_fsop_geom	*fsgeom = &file->xfd.fsgeom;
+	off64_t			blocksize = fsgeom->blocksize;
 	off64_t			bperag;
 	off64_t			aglen;
 	xfs_agblock_t		agbno;
@@ -158,7 +160,7 @@ scan_ag(
 	int			ret;
 	int			i;
 
-	bperag = (off64_t)file->geom.agblocks * blocksize;
+	bperag = (off64_t)fsgeom->agblocks * blocksize;
 
 	fsmap = malloc(fsmap_sizeof(NR_EXTENTS));
 	if (!fsmap) {
@@ -185,7 +187,7 @@ scan_ag(
 	h->fmr_offset = ULLONG_MAX;
 
 	while (true) {
-		ret = ioctl(file->fd, FS_IOC_GETFSMAP, fsmap);
+		ret = ioctl(file->xfd.fd, FS_IOC_GETFSMAP, fsmap);
 		if (ret < 0) {
 			fprintf(stderr, _("%s: FS_IOC_GETFSMAP [\"%s\"]: %s\n"),
 				progname, file->name, strerror(errno));
@@ -248,12 +250,13 @@ aglistadd(
 
 static int
 init(
-	int		argc,
-	char		**argv)
+	int			argc,
+	char			**argv)
 {
-	long long	x;
-	int		c;
-	int		speced = 0;	/* only one of -b -e -h or -m */
+	struct xfs_fsop_geom	*fsgeom = &file->xfd.fsgeom;
+	long long		x;
+	int			c;
+	int			speced = 0;	/* only one of -b -e -h or -m */
 
 	agcount = dumpflag = equalsize = multsize = optind = gflag = 0;
 	histcount = seen1 = summaryflag = 0;
@@ -321,7 +324,7 @@ init(
 		return 0;
 	if (!speced)
 		multsize = 2;
-	histinit(file->geom.agblocks);
+	histinit(fsgeom->agblocks);
 	return 1;
 many_spec:
 	return command_usage(&freesp_cmd);
@@ -332,10 +335,11 @@ init(
  */
 static int
 freesp_f(
-	int		argc,
-	char		**argv)
+	int			argc,
+	char			**argv)
 {
-	xfs_agnumber_t	agno;
+	struct xfs_fsop_geom	*fsgeom = &file->xfd.fsgeom;
+	xfs_agnumber_t		agno;
 
 	if (!init(argc, argv))
 		return 0;
@@ -343,7 +347,7 @@ freesp_f(
 		printf(_("        AG    extents     blocks\n"));
 	if (rtflag)
 		scan_ag(NULLAGNUMBER);
-	for (agno = 0; !rtflag && agno < file->geom.agcount; agno++)  {
+	for (agno = 0; !rtflag && agno < fsgeom->agcount; agno++) {
 		if (inaglist(agno))
 			scan_ag(agno);
 	}
diff --git a/spaceman/info.c b/spaceman/info.c
index f563cf1e..f6234c4c 100644
--- a/spaceman/info.c
+++ b/spaceman/info.c
@@ -7,8 +7,8 @@
 #include "command.h"
 #include "init.h"
 #include "libfrog/paths.h"
-#include "space.h"
 #include "libfrog/fsgeom.h"
+#include "space.h"
 
 static void
 info_help(void)
@@ -28,26 +28,13 @@ info_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_fsop_geom	geo;
-	int			error;
-
 	if (fs_table_lookup_mount(file->name) == NULL) {
 		fprintf(stderr, _("%s: Not a XFS mount point.\n"), file->name);
 		return 1;
 	}
 
-	/* get the current filesystem size & geometry */
-	error = xfrog_geometry(file->fd, &geo);
-	if (error) {
-		fprintf(stderr,
-	_("%s: cannot determine geometry of filesystem mounted at %s: %s\n"),
-			progname, file->name, strerror(error));
-		exitcode = 1;
-		return 0;
-	}
-
-	xfs_report_geom(&geo, file->fs_path.fs_name, file->fs_path.fs_log,
-			file->fs_path.fs_rt);
+	xfs_report_geom(&file->xfd.fsgeom, file->fs_path.fs_name,
+			file->fs_path.fs_log, file->fs_path.fs_rt);
 	return 0;
 }
 
diff --git a/spaceman/init.c b/spaceman/init.c
index fa0397ab..4afdb386 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -5,6 +5,7 @@
  */
 
 #include "libxfs.h"
+#include "libfrog/fsgeom.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
@@ -60,7 +61,7 @@ init(
 	char		**argv)
 {
 	int		c;
-	struct xfs_fsop_geom geometry = { 0 };
+	struct xfs_fd	xfd = XFS_FD_INIT_EMPTY;
 	struct fs_path	fsp;
 
 	progname = basename(argv[0]);
@@ -88,11 +89,13 @@ init(
 	if (optind != argc - 1)
 		usage();
 
-	if ((c = openfile(argv[optind], &geometry, &fsp)) < 0)
+	c = openfile(argv[optind], &xfd, &fsp);
+	if (c < 0)
 		exit(1);
-	if (!platform_test_xfs_fd(c))
+	if (!platform_test_xfs_fd(xfd.fd))
 		printf(_("Not an XFS filesystem!\n"));
-	if (addfile(argv[optind], c, &geometry, &fsp) < 0)
+	c = addfile(argv[optind], &xfd, &fsp);
+	if (c < 0)
 		exit(1);
 
 	init_commands();
diff --git a/spaceman/prealloc.c b/spaceman/prealloc.c
index b223010c..e5d857bd 100644
--- a/spaceman/prealloc.c
+++ b/spaceman/prealloc.c
@@ -5,6 +5,7 @@
  */
 
 #include "libxfs.h"
+#include "libfrog/fsgeom.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
@@ -18,11 +19,12 @@ static cmdinfo_t prealloc_cmd;
  */
 static int
 prealloc_f(
-	int	argc,
-	char	**argv)
+	int			argc,
+	char			**argv)
 {
 	struct xfs_fs_eofblocks eofb = {0};
-	int	c;
+	struct xfs_fsop_geom	*fsgeom = &file->xfd.fsgeom;
+	int			c;
 
 	eofb.eof_version = XFS_EOFBLOCKS_VERSION;
 
@@ -51,9 +53,8 @@ prealloc_f(
 			break;
 		case 'm':
 			eofb.eof_flags |= XFS_EOF_FLAGS_MINFILESIZE;
-			eofb.eof_min_file_size = cvtnum(file->geom.blocksize,
-							file->geom.sectsize,
-							optarg);
+			eofb.eof_min_file_size = cvtnum(fsgeom->blocksize,
+					fsgeom->sectsize, optarg);
 			break;
 		case '?':
 		default:
@@ -63,7 +64,7 @@ prealloc_f(
 	if (optind != argc)
 		return command_usage(&prealloc_cmd);
 
-	if (ioctl(file->fd, XFS_IOC_FREE_EOFBLOCKS, &eofb) < 0) {
+	if (ioctl(file->xfd.fd, XFS_IOC_FREE_EOFBLOCKS, &eofb) < 0) {
 		fprintf(stderr, _("%s: XFS_IOC_FREE_EOFBLOCKS on %s: %s\n"),
 			progname, file->name, strerror(errno));
 	}
diff --git a/spaceman/space.h b/spaceman/space.h
index 8b224aca..2c26884a 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -7,18 +7,19 @@
 #define XFS_SPACEMAN_SPACE_H_
 
 struct fileio {
-	struct xfs_fsop_geom geom;		/* XFS filesystem geometry */
+	struct xfs_fd	xfd;		/* XFS runtime support context */
 	struct fs_path	fs_path;	/* XFS path information */
 	char		*name;		/* file name at time of open */
-	int		fd;		/* open file descriptor */
 };
 
 extern struct fileio	*filetable;	/* open file table */
 extern int		filecount;	/* number of open files */
 extern struct fileio	*file;		/* active file in file table */
 
-extern int	openfile(char *, struct xfs_fsop_geom *, struct fs_path *);
-extern int	addfile(char *, int , struct xfs_fsop_geom *, struct fs_path *);
+extern int	openfile(char *path, struct xfs_fd *xfd,
+			 struct fs_path *fs_path);
+extern int	addfile(char *path, struct xfs_fd *xfd,
+			struct fs_path *fs_path);
 
 extern void	print_init(void);
 extern void	help_init(void);
diff --git a/spaceman/trim.c b/spaceman/trim.c
index b23e2bf9..daf4e427 100644
--- a/spaceman/trim.c
+++ b/spaceman/trim.c
@@ -5,6 +5,7 @@
  */
 
 #include "libxfs.h"
+#include "libfrog/fsgeom.h"
 #include "command.h"
 #include "init.h"
 #include "libfrog/paths.h"
@@ -18,18 +19,19 @@ static cmdinfo_t trim_cmd;
  */
 static int
 trim_f(
-	int		argc,
-	char		**argv)
+	int			argc,
+	char			**argv)
 {
-	struct fstrim_range trim = {0};
-	xfs_agnumber_t	agno = 0;
-	off64_t		offset = 0;
-	ssize_t		length = 0;
-	ssize_t		minlen = 0;
-	int		aflag = 0;
-	int		fflag = 0;
-	int		ret;
-	int		c;
+	struct fstrim_range	trim = {0};
+	struct xfs_fsop_geom	*fsgeom = &file->xfd.fsgeom;
+	xfs_agnumber_t		agno = 0;
+	off64_t			offset = 0;
+	ssize_t			length = 0;
+	ssize_t			minlen = 0;
+	int			aflag = 0;
+	int			fflag = 0;
+	int			ret;
+	int			c;
 
 	while ((c = getopt(argc, argv, "a:fm:")) != EOF) {
 		switch (c) {
@@ -45,8 +47,8 @@ trim_f(
 			fflag = 1;
 			break;
 		case 'm':
-			minlen = cvtnum(file->geom.blocksize,
-					file->geom.sectsize, optarg);
+			minlen = cvtnum(fsgeom->blocksize, fsgeom->sectsize,
+					optarg);
 			break;
 		default:
 			return command_usage(&trim_cmd);
@@ -59,23 +61,23 @@ trim_f(
 	if (optind != argc - 2 && !(aflag || fflag))
 		return command_usage(&trim_cmd);
 	if (optind != argc) {
-		offset = cvtnum(file->geom.blocksize, file->geom.sectsize,
+		offset = cvtnum(fsgeom->blocksize, fsgeom->sectsize,
 				argv[optind]);
-		length = cvtnum(file->geom.blocksize, file->geom.sectsize,
+		length = cvtnum(fsgeom->blocksize, fsgeom->sectsize,
 				argv[optind + 1]);
 	} else if (agno) {
-		offset = (off64_t)agno * file->geom.agblocks * file->geom.blocksize;
-		length = file->geom.agblocks * file->geom.blocksize;
+		offset = (off64_t)agno * fsgeom->agblocks * fsgeom->blocksize;
+		length = fsgeom->agblocks * fsgeom->blocksize;
 	} else {
 		offset = 0;
-		length = file->geom.datablocks * file->geom.blocksize;
+		length = fsgeom->datablocks * fsgeom->blocksize;
 	}
 
 	trim.start = offset;
 	trim.len = length;
 	trim.minlen = minlen;
 
-	ret = ioctl(file->fd, FITRIM, (unsigned long)&trim);
+	ret = ioctl(file->xfd.fd, FITRIM, (unsigned long)&trim);
 	if (ret < 0) {
 		fprintf(stderr, "%s: ioctl(FITRIM) [\"%s\"]: %s\n",
 			progname, file->name, strerror(errno));

