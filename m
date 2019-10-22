Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207C5CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB56021872
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AyQTR9WY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbfJVSwx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:52:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50426 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387791AbfJVSwx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:52:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiBNX109498;
        Tue, 22 Oct 2019 18:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rOg4YgTJ9LByqmjIArFhd5qm5Y82faDbI7MA5URoFDs=;
 b=AyQTR9WYy4laPsxCTUs1El85Q1CBEvLf87wObQ3A+cZO30vryWoXMt5M7rJy5Boax9G3
 cKjzHaWrTwehf5I8Dr3f9mNv+/aCvs3krAigoJ/mFL+IX90yKRyxPqfnv4OAfcu8kKyv
 KzwsOZztyzqA+/7Mw1/MN8h9TfzhkEzD3X2LPibAA2Y1+I0rZe2NgjYZIS6WIY4gs+Hm
 yle8ppS+koLpRV1Tl4KB3eBERQCMaZJSG/1fNh7YD9GN/jJ1NnacydylEDOS7jCfM/vR
 XVkIbA++ntBTbsmM548RDLtHuZlHwNRFZajm6IfcPN1VWfGDButkeje0VUpCGu1oWQEO AQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vqswtgvmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhNqL125160;
        Tue, 22 Oct 2019 18:52:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vsx23a0rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:47 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MIqkTT000710;
        Tue, 22 Oct 2019 18:52:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:52:46 -0700
Subject: [PATCH 3/7] libfrog: convert fsgeom.c functions to negative error
 codes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Tue, 22 Oct 2019 11:52:44 -0700
Message-ID: <157177036487.1462916.10945521391603714187.stgit@magnolia>
In-Reply-To: <157177034582.1462916.12588287391821422188.stgit@magnolia>
References: <157177034582.1462916.12588287391821422188.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert libfrog functions to return negative error codes like libxfs
does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 9641370b..b081567f 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -163,7 +163,7 @@ bulkstat_f(
 		return 0;
 	}
 
-	ret = xfd_prepare_geometry(&xfd);
+	ret = -xfd_prepare_geometry(&xfd);
 	if (ret) {
 		xfrog_perror(ret, "xfd_prepare_geometry");
 		exitcode = 1;
@@ -271,7 +271,7 @@ bulkstat_single_f(
 		}
 	}
 
-	ret = xfd_prepare_geometry(&xfd);
+	ret = -xfd_prepare_geometry(&xfd);
 	if (ret) {
 		xfrog_perror(ret, "xfd_prepare_geometry");
 		exitcode = 1;
@@ -419,7 +419,7 @@ inumbers_f(
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
index a5192e87..464bcad9 100644
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
index 3338a7b8..9295673d 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -642,7 +642,7 @@ check_fs_vs_host_sectsize(
 
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
index e0382b04..6125d324 100644
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
index a0079bd7..c6d936fb 100644
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

