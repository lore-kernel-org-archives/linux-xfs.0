Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8175C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0E0721D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:40:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tr6+m+RE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbfIYVk0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:40:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36544 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfIYVk0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:40:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdPgs058319;
        Wed, 25 Sep 2019 21:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Uoi7oZbqF3DrZxLhi5Zt4KRiuZL0M8E+DjF2vxkoCGU=;
 b=Tr6+m+RE10Fx59zUX5uLLZvntFO6HKoupsy6V6zg4PUKcvWCr2XYB3QnnTWY9X1FIsOv
 hhP9TAoagSxQGESXE5G0GphzykQvU784oeWL9hBwVPK4c9N9FQ7xjGyJX4xBLFFV4T/Z
 3zQEDLuW6AG/LdrX3B4fv43WVVsvPf9lIwuUzTVG6lkHrNqUst+S0PcQBC45R23gG6Fz
 DMFT/Q2ZXtwxa4dCx5M2x8HVChz0p2WntnSXWv2uiBUrLyBkhroIlsrVlqJJLtdB4wcv
 ONpoIFo3blcG+bnJ5DgQnIQaF6+fV+/1b55rbumyJclunsEEzut9Manr5aG/AxJwbV2Q Lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v5cgr7fk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:40:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdH21021219;
        Wed, 25 Sep 2019 21:40:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2v829w577n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:40:22 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLeLsG019655;
        Wed, 25 Sep 2019 21:40:21 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:40:21 -0700
Subject: [PATCH 3/7] libfrog: convert fsgeom.c functions to negative error
 codes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:40:20 -0700
Message-ID: <156944761997.302827.16411723774344852077.stgit@magnolia>
In-Reply-To: <156944760161.302827.4342305147521200999.stgit@magnolia>
References: <156944760161.302827.4342305147521200999.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert libfrog functions to return negative error codes like libxfs
does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fsr/xfs_fsr.c       |    4 ++--
 growfs/xfs_growfs.c |    4 ++--
 io/bmap.c           |    2 +-
 io/bulkstat.c       |    6 +++---
 io/fsmap.c          |    4 ++--
 io/open.c           |    2 +-
 io/stat.c           |    2 +-
 libfrog/bulkstat.c  |    2 +-
 libfrog/fsgeom.c    |   18 +++++++++---------
 quota/free.c        |    2 +-
 quota/quot.c        |    2 +-
 repair/xfs_repair.c |    2 +-
 rtcp/xfs_rtcp.c     |    2 +-
 scrub/phase1.c      |    4 ++--
 spaceman/file.c     |    2 +-
 spaceman/health.c   |    2 +-
 16 files changed, 30 insertions(+), 30 deletions(-)


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index af5d6169..3e9ba27c 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -602,7 +602,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		return -1;
 	}
 
-	ret = xfd_open(&fsxfd, mntdir, O_RDONLY);
+	ret = -xfd_open(&fsxfd, mntdir, O_RDONLY);
 	if (ret) {
 		fsrprintf(_("unable to open XFS file: %s: %s\n"),
 		          mntdir, strerror(ret));
@@ -748,7 +748,7 @@ fsrfile(
 	 * Need to open something on the same filesystem as the
 	 * file.  Open the parent.
 	 */
-	error = xfd_open(&fsxfd, getparent(fname), O_RDONLY);
+	error = -xfd_open(&fsxfd, getparent(fname), O_RDONLY);
 	if (error) {
 		fsrprintf(_("unable to open sys handle for XFS file %s: %s\n"),
 			fname, strerror(error));
diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index eab15984..d1908046 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -166,7 +166,7 @@ main(int argc, char **argv)
 	}
 
 	/* get the current filesystem size & geometry */
-	ret = xfrog_geometry(ffd, &geo);
+	ret = -xfrog_geometry(ffd, &geo);
 	if (ret) {
 		fprintf(stderr,
 	_("%s: cannot determine geometry of filesystem mounted at %s: %s\n"),
@@ -352,7 +352,7 @@ main(int argc, char **argv)
 		}
 	}
 
-	ret = xfrog_geometry(ffd, &ngeo);
+	ret = -xfrog_geometry(ffd, &ngeo);
 	if (ret) {
 		fprintf(stderr, _("%s: XFS_IOC_FSGEOMETRY xfsctl failed: %s\n"),
 			progname, strerror(ret));
diff --git a/io/bmap.c b/io/bmap.c
index cf4ea12b..f838840e 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -106,7 +106,7 @@ bmap_f(
 		bmv_iflags &= ~(BMV_IF_PREALLOC|BMV_IF_NO_DMAPI_READ);
 
 	if (vflag) {
-		c = xfrog_geometry(file->fd, &fsgeo);
+		c = -xfrog_geometry(file->fd, &fsgeo);
 		if (c) {
 			fprintf(stderr,
 				_("%s: can't get geometry [\"%s\"]: %s\n"),
diff --git a/io/bulkstat.c b/io/bulkstat.c
index 0ea21584..e5ee4296 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -164,7 +164,7 @@ bulkstat_f(
 		return 0;
 	}
 
-	ret = xfd_prepare_geometry(&xfd);
+	ret = -xfd_prepare_geometry(&xfd);
 	if (ret) {
 		xfrog_perror(ret, "xfd_prepare_geometry");
 		exitcode = 1;
@@ -266,7 +266,7 @@ bulkstat_single_f(
 		}
 	}
 
-	ret = xfd_prepare_geometry(&xfd);
+	ret = -xfd_prepare_geometry(&xfd);
 	if (ret) {
 		xfrog_perror(ret, "xfd_prepare_geometry");
 		exitcode = 1;
@@ -422,7 +422,7 @@ inumbers_f(
 		return 0;
 	}
 
-	ret = xfd_prepare_geometry(&xfd);
+	ret = -xfd_prepare_geometry(&xfd);
 	if (ret) {
 		xfrog_perror(ret, "xfd_prepare_geometry");
 		exitcode = 1;
diff --git a/io/fsmap.c b/io/fsmap.c
index 12ec1e44..feacb264 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -448,11 +448,11 @@ fsmap_f(
 	}
 
 	if (vflag) {
-		c = xfrog_geometry(file->fd, &fsgeo);
+		c = -xfrog_geometry(file->fd, &fsgeo);
 		if (c) {
 			fprintf(stderr,
 				_("%s: can't get geometry [\"%s\"]: %s\n"),
-				progname, file->name, strerror(errno));
+				progname, file->name, strerror(c));
 			exitcode = 1;
 			return 0;
 		}
diff --git a/io/open.c b/io/open.c
index c07ecb04..3bbc5d0a 100644
--- a/io/open.c
+++ b/io/open.c
@@ -124,7 +124,7 @@ openfile(
 	} else {
 		int	ret;
 
-		ret = xfrog_geometry(fd, geom);
+		ret = -xfrog_geometry(fd, geom);
 		if (ret) {
 			xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
 			close(fd);
diff --git a/io/stat.c b/io/stat.c
index db335780..d125a0f7 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -197,7 +197,7 @@ statfs_f(
 	}
 	if (file->flags & IO_FOREIGN)
 		return 0;
-	ret = xfrog_geometry(file->fd, &fsgeo);
+	ret = -xfrog_geometry(file->fd, &fsgeo);
 	if (ret) {
 		xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
 	} else {
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 538b5197..38d634f7 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -39,7 +39,7 @@ xfrog_bulkstat_prep_v1_emulation(
 	if (xfd->fsgeom.blocksize > 0)
 		return 0;
 
-	return xfd_prepare_geometry(xfd);
+	return -xfd_prepare_geometry(xfd);
 }
 
 /* Bulkstat a single inode using v5 ioctl. */
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 3ea91e3f..19a4911f 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -69,7 +69,7 @@ xfs_report_geom(
 			(unsigned long long)geo->rtextents);
 }
 
-/* Try to obtain the xfs geometry.  On error returns a positive error code. */
+/* Try to obtain the xfs geometry.  On error returns a negative error code. */
 int
 xfrog_geometry(
 	int			fd,
@@ -91,12 +91,12 @@ xfrog_geometry(
 	if (!ret)
 		return 0;
 
-	return errno;
+	return -errno;
 }
 
 /*
  * Prepare xfs_fd structure for future ioctl operations by computing the xfs
- * geometry for @xfd->fd.  Returns zero or a positive error code.
+ * geometry for @xfd->fd.  Returns zero or a negative error code.
  */
 int
 xfd_prepare_geometry(
@@ -117,7 +117,7 @@ xfd_prepare_geometry(
 	return 0;
 }
 
-/* Open a file on an XFS filesystem.  Returns zero or a positive error code. */
+/* Open a file on an XFS filesystem.  Returns zero or a negative error code. */
 int
 xfd_open(
 	struct xfs_fd		*xfd,
@@ -128,7 +128,7 @@ xfd_open(
 
 	xfd->fd = open(pathname, flags);
 	if (xfd->fd < 0)
-		return errno;
+		return -errno;
 
 	ret = xfd_prepare_geometry(xfd);
 	if (ret) {
@@ -141,7 +141,7 @@ xfd_open(
 
 /*
  * Release any resources associated with this xfs_fd structure.  Returns zero
- * or a positive error code.
+ * or a negative error code.
  */
 int
 xfd_close(
@@ -155,12 +155,12 @@ xfd_close(
 	ret = close(xfd->fd);
 	xfd->fd = -1;
 	if (ret < 0)
-		return errno;
+		return -errno;
 
 	return 0;
 }
 
-/* Try to obtain an AG's geometry.  Returns zero or a positive error code. */
+/* Try to obtain an AG's geometry.  Returns zero or a negative error code. */
 int
 xfrog_ag_geometry(
 	int			fd,
@@ -172,6 +172,6 @@ xfrog_ag_geometry(
 	ageo->ag_number = agno;
 	ret = ioctl(fd, XFS_IOC_AG_GEOMETRY, ageo);
 	if (ret)
-		return errno;
+		return -errno;
 	return 0;
 }
diff --git a/quota/free.c b/quota/free.c
index 45ce2ceb..ea9c112f 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -69,7 +69,7 @@ mount_free_space_data(
 	}
 
 	if (!(mount->fs_flags & FS_FOREIGN)) {
-		ret = xfrog_geometry(fd, &fsgeo);
+		ret = -xfrog_geometry(fd, &fsgeo);
 		if (ret) {
 			xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
 			close(fd);
diff --git a/quota/quot.c b/quota/quot.c
index 0f69fabd..df3825f2 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -146,7 +146,7 @@ quot_bulkstat_mount(
 			*dp = NULL;
 	ndu[0] = ndu[1] = ndu[2] = 0;
 
-	ret = xfd_open(&fsxfd, fsdir, O_RDONLY);
+	ret = -xfd_open(&fsxfd, fsdir, O_RDONLY);
 	if (ret) {
 		xfrog_perror(ret, fsdir);
 		return;
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 7e810ef4..61ea3b11 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -641,7 +641,7 @@ check_fs_vs_host_sectsize(
 
 	fd = libxfs_device_to_fd(x.ddev);
 
-	ret = xfrog_geometry(fd, &geom);
+	ret = -xfrog_geometry(fd, &geom);
 	if (ret) {
 		do_log(_("Cannot get host filesystem geometry.\n"
 	"Repair may fail if there is a sector size mismatch between\n"
diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
index a5737699..7c4197b1 100644
--- a/rtcp/xfs_rtcp.c
+++ b/rtcp/xfs_rtcp.c
@@ -378,7 +378,7 @@ xfsrtextsize( char *path)
 			progname, path, strerror(errno));
 		return -1;
 	}
-	rval = xfrog_geometry(fd, &geo);
+	rval = -xfrog_geometry(fd, &geo);
 	close(fd);
 	if (rval)
 		return -1;
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 0d343b03..eabcaecf 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -60,7 +60,7 @@ scrub_cleanup(
 	if (ctx->datadev)
 		disk_close(ctx->datadev);
 	fshandle_destroy();
-	error = xfd_close(&ctx->mnt);
+	error = -xfd_close(&ctx->mnt);
 	if (error)
 		str_liberror(ctx, error, _("closing mountpoint fd"));
 	fs_table_destroy();
@@ -84,7 +84,7 @@ phase1_func(
 	 * CAP_SYS_ADMIN, which we probably need to do anything fancy
 	 * with the (XFS driver) kernel.
 	 */
-	error = xfd_open(&ctx->mnt, ctx->mntpoint,
+	error = -xfd_open(&ctx->mnt, ctx->mntpoint,
 			O_RDONLY | O_NOATIME | O_DIRECTORY);
 	if (error) {
 		if (error == EPERM)
diff --git a/spaceman/file.c b/spaceman/file.c
index b7794328..eec7ee9f 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -52,7 +52,7 @@ openfile(
 	struct fs_path	*fsp;
 	int		ret;
 
-	ret = xfd_open(xfd, path, O_RDONLY);
+	ret = -xfd_open(xfd, path, O_RDONLY);
 	if (ret) {
 		if (ret == ENOTTY)
 			fprintf(stderr,
diff --git a/spaceman/health.c b/spaceman/health.c
index c3b89e8f..a10d2d4a 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -192,7 +192,7 @@ report_ag_sick(
 	char			descr[256];
 	int			ret;
 
-	ret = xfrog_ag_geometry(file->xfd.fd, agno, &ageo);
+	ret = -xfrog_ag_geometry(file->xfd.fd, agno, &ageo);
 	if (ret) {
 		xfrog_perror(ret, "ag_geometry");
 		return 1;

