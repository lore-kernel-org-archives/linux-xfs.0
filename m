Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE8F1C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93DFE21E6F
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dkjUT1Oy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfIYVe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:34:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58394 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727384AbfIYVe2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:34:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYOL8054812;
        Wed, 25 Sep 2019 21:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=G6i5uyOS6rRC8C31ID6O/Q+F3E4gpGv4gHWGl7NiKaQ=;
 b=dkjUT1OyD1ldSSoKUbzOIL8wY7ekIfxvcG1hgwHoQA2l7pNjKECVnP7WtEsVl+J1HKRI
 t5+3JXPiVBtRA+C59wq/K3WWAqB8w+U/cIOil4IoXeM1sDp390yssTJbOz4oCCAeTvXv
 OI93H1xbJDtoRt5ZIur7MJgHM6gcBkqp5cmZC4lB+p/lbBGb7/fAEUEIJHBnHwZfg8ar
 cPtco9K6uqcBgeCBSpTP4B+LC7XgUFpxHbiifRQ4XJHMf0+G3HEutDW8p7PsGEmw/Fj1
 ajUKAhPkwalT17xd47h99hU7cRgDAstm8B72mns+TOG3jm3yB+jcmu5MhLUa1a6HsDN4 Jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgr7es0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYMeA023571;
        Wed, 25 Sep 2019 21:34:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2v7vnyukur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:32:48 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLWl0T013559;
        Wed, 25 Sep 2019 21:32:47 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:32:46 -0700
Subject: [PATCH 3/4] misc: convert xfrog_bulkstat functions to have v5
 semantics
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:32:45 -0700
Message-ID: <156944716532.297379.18153066949287059883.stgit@magnolia>
In-Reply-To: <156944714720.297379.5532805895370082740.stgit@magnolia>
References: <156944714720.297379.5532805895370082740.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert xfrog_bulkstat() and xfrog_bulkstat_single() to take arguments
using v5 bulkstat semantics and return bulkstat information in v5
structures.  If the v5 ioctl is not available, the xfrog wrapper should
use the v1 ioctl to emulate v5 behaviors.  Add flags to the xfs_fd
structure to constrain emulation for debugging purposes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fsr/xfs_fsr.c      |   64 ++++++--
 io/open.c          |   27 ++-
 io/swapext.c       |    9 +
 libfrog/bulkstat.c |  431 +++++++++++++++++++++++++++++++++++++++++++++++++---
 libfrog/bulkstat.h |   14 +-
 libfrog/fsgeom.h   |    9 +
 quota/quot.c       |   29 ++-
 scrub/inodes.c     |   39 +++--
 scrub/inodes.h     |    2 
 scrub/phase3.c     |    6 -
 scrub/phase5.c     |    8 -
 scrub/phase6.c     |    2 
 scrub/unicrash.c   |    6 -
 scrub/unicrash.h   |    4 
 spaceman/health.c  |   33 ++--
 15 files changed, 572 insertions(+), 111 deletions(-)


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index a53eb924..af5d6169 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -466,6 +466,17 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
 				ptr = strchr(ptr, ' ');
 				if (ptr) {
 					startino = strtoull(++ptr, NULL, 10);
+					/*
+					 * NOTE: The inode number read in from
+					 * the leftoff file is the last inode
+					 * to have been fsr'd.  Since the v5
+					 * xfrog_bulkstat function wants to be
+					 * passed the first inode that we want
+					 * to examine, increment the value that
+					 * we read in.  The debug message below
+					 * prints the lastoff value.
+					 */
+					startino++;
 				}
 			}
 			if (startpass < 0)
@@ -484,7 +495,7 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
 
 	if (vflag) {
 		fsrprintf(_("START: pass=%d ino=%llu %s %s\n"),
-			  fs->npass, (unsigned long long)startino,
+			  fs->npass, (unsigned long long)startino - 1,
 			  fs->dev, fs->mnt);
 	}
 
@@ -576,12 +587,10 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 	int	fd;
 	int	count = 0;
 	int	ret;
-	uint32_t buflenout;
-	struct xfs_bstat buf[GRABSZ];
 	char	fname[64];
 	char	*tname;
 	jdm_fshandle_t	*fshandlep;
-	xfs_ino_t	lastino = startino;
+	struct xfs_bulkstat_req	*breq;
 
 	fsrprintf(_("%s start inode=%llu\n"), mntdir,
 		(unsigned long long)startino);
@@ -604,10 +613,21 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 
 	tmp_init(mntdir);
 
-	while ((ret = xfrog_bulkstat(&fsxfd, &lastino, GRABSZ, &buf[0],
-				&buflenout)) == 0) {
-		struct xfs_bstat *p;
-		struct xfs_bstat *endp;
+	breq = xfrog_bulkstat_alloc_req(GRABSZ, startino);
+	if (!breq) {
+		fsrprintf(_("Skipping %s: not enough memory\n"),
+			  mntdir);
+		xfd_close(&fsxfd);
+		free(fshandlep);
+		return -1;
+	}
+
+	while ((ret = xfrog_bulkstat(&fsxfd, breq) == 0)) {
+		struct xfs_bstat	bs1;
+		struct xfs_bulkstat	*buf = breq->bulkstat;
+		struct xfs_bulkstat	*p;
+		struct xfs_bulkstat	*endp;
+		uint32_t		buflenout = breq->hdr.ocount;
 
 		if (buflenout == 0)
 			goto out0;
@@ -615,7 +635,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		/* Each loop through, defrag targetrange percent of the files */
 		count = (buflenout * targetrange) / 100;
 
-		qsort((char *)buf, buflenout, sizeof(struct xfs_bstat), cmp);
+		qsort((char *)buf, buflenout, sizeof(struct xfs_bulkstat), cmp);
 
 		for (p = buf, endp = (buf + buflenout); p < endp ; p++) {
 			/* Do some obvious checks now */
@@ -623,7 +643,14 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 			     (p->bs_extents < 2))
 				continue;
 
-			fd = jdm_open(fshandlep, p, O_RDWR|O_DIRECT);
+			ret = xfrog_bulkstat_v5_to_v1(&fsxfd, &bs1, p);
+			if (ret) {
+				fsrprintf(_("bstat conversion error: %s\n"),
+						strerror(ret));
+				continue;
+			}
+
+			fd = jdm_open(fshandlep, &bs1, O_RDWR | O_DIRECT);
 			if (fd < 0) {
 				/* This probably means the file was
 				 * removed while in progress of handling
@@ -641,7 +668,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 			/* Get a tmp file name */
 			tname = tmp_next(mntdir);
 
-			ret = fsrfile_common(fname, tname, mntdir, fd, p);
+			ret = fsrfile_common(fname, tname, mntdir, fd, &bs1);
 
 			leftoffino = p->bs_ino;
 
@@ -653,6 +680,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 			}
 		}
 		if (endtime && endtime < time(NULL)) {
+			free(breq);
 			tmp_close(mntdir);
 			xfd_close(&fsxfd);
 			fsrall_cleanup(1);
@@ -662,6 +690,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 	if (ret)
 		fsrprintf(_("%s: bulkstat: %s\n"), progname, strerror(ret));
 out0:
+	free(breq);
 	tmp_close(mntdir);
 	xfd_close(&fsxfd);
 	free(fshandlep);
@@ -701,6 +730,7 @@ fsrfile(
 	xfs_ino_t		ino)
 {
 	struct xfs_fd		fsxfd = XFS_FD_INIT_EMPTY;
+	struct xfs_bulkstat	bulkstat;
 	struct xfs_bstat	statbuf;
 	jdm_fshandle_t		*fshandlep;
 	int			fd = -1;
@@ -725,12 +755,18 @@ fsrfile(
 		goto out;
 	}
 
-	error = xfrog_bulkstat_single(&fsxfd, ino, &statbuf);
+	error = xfrog_bulkstat_single(&fsxfd, ino, 0, &bulkstat);
 	if (error) {
 		fsrprintf(_("unable to get bstat on %s: %s\n"),
 			fname, strerror(error));
 		goto out;
 	}
+	error = xfrog_bulkstat_v5_to_v1(&fsxfd, &statbuf, &bulkstat);
+	if (error) {
+		fsrprintf(_("bstat conversion error on %s: %s\n"),
+			fname, strerror(error));
+		goto out;
+	}
 
 	fd = jdm_open(fshandlep, &statbuf, O_RDWR|O_DIRECT);
 	if (fd < 0) {
@@ -951,7 +987,7 @@ fsr_setup_attr_fork(
 
 	i = 0;
 	do {
-		struct xfs_bstat tbstat;
+		struct xfs_bulkstat	tbstat;
 		char		name[64];
 		int		ret;
 
@@ -960,7 +996,7 @@ fsr_setup_attr_fork(
 		 * this to compare against the target and determine what we
 		 * need to do.
 		 */
-		ret = xfrog_bulkstat_single(&txfd, tstatbuf.st_ino, &tbstat);
+		ret = xfrog_bulkstat_single(&txfd, tstatbuf.st_ino, 0, &tbstat);
 		if (ret) {
 			fsrprintf(_("unable to get bstat on temp file: %s\n"),
 						strerror(ret));
diff --git a/io/open.c b/io/open.c
index 99ca0dd3..e0e7fb3e 100644
--- a/io/open.c
+++ b/io/open.c
@@ -723,8 +723,7 @@ inode_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_bstat	bstat;
-	uint32_t		count = 0;
+	struct xfs_bulkstat	bulkstat;
 	uint64_t		result_ino = 0;
 	uint64_t		userino = NULLFSINO;
 	char			*p;
@@ -775,26 +774,40 @@ inode_f(
 		}
 	} else if (ret_next) {
 		struct xfs_fd	xfd = XFS_FD_INIT(file->fd);
+		struct xfs_bulkstat_req	*breq;
+
+		/*
+		 * The -n option means that the caller wants to know the number
+		 * of the next allocated inode, so we need to increment here.
+		 */
+		breq = xfrog_bulkstat_alloc_req(1, userino + 1);
+		if (!breq) {
+			perror("alloc bulkstat");
+			exitcode = 1;
+			return 0;
+		}
 
 		/* get next inode */
-		ret = xfrog_bulkstat(&xfd, &userino, 1, &bstat, &count);
+		ret = xfrog_bulkstat(&xfd, breq);
 		if (ret) {
 			errno = ret;
 			perror("bulkstat");
+			free(breq);
 			exitcode = 1;
 			return 0;
 		}
 
 		/* The next inode in use, or 0 if none */
-		if (count)
-			result_ino = bstat.bs_ino;
+		if (breq->hdr.ocount)
+			result_ino = breq->bulkstat[0].bs_ino;
 		else
 			result_ino = 0;
+		free(breq);
 	} else {
 		struct xfs_fd	xfd = XFS_FD_INIT(file->fd);
 
 		/* get this inode */
-		ret = xfrog_bulkstat_single(&xfd, userino, &bstat);
+		ret = xfrog_bulkstat_single(&xfd, userino, 0, &bulkstat);
 		if (ret == EINVAL) {
 			/* Not in use */
 			result_ino = 0;
@@ -804,7 +817,7 @@ inode_f(
 			exitcode = 1;
 			return 0;
 		} else {
-			result_ino = bstat.bs_ino;
+			result_ino = bulkstat.bs_ino;
 		}
 	}
 
diff --git a/io/swapext.c b/io/swapext.c
index 2b4918f8..1139cf21 100644
--- a/io/swapext.c
+++ b/io/swapext.c
@@ -28,6 +28,7 @@ swapext_f(
 	char			**argv)
 {
 	struct xfs_fd		fxfd = XFS_FD_INIT(file->fd);
+	struct xfs_bulkstat	bulkstat;
 	int			fd;
 	int			error;
 	struct xfs_swapext	sx;
@@ -48,12 +49,18 @@ swapext_f(
 		goto out;
 	}
 
-	error = xfrog_bulkstat_single(&fxfd, stat.st_ino, &sx.sx_stat);
+	error = xfrog_bulkstat_single(&fxfd, stat.st_ino, 0, &bulkstat);
 	if (error) {
 		errno = error;
 		perror("bulkstat");
 		goto out;
 	}
+	error = xfrog_bulkstat_v5_to_v1(&fxfd, &sx.sx_stat, &bulkstat);
+	if (error) {
+		errno = error;
+		perror("bulkstat conversion");
+		goto out;
+	}
 	sx.sx_version = XFS_SX_VERSION;
 	sx.sx_fdtarget = file->fd;
 	sx.sx_fdtmp = fd;
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index fa10f298..300963f1 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -3,55 +3,438 @@
  * Copyright (C) 2019 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
+#include <string.h>
+#include <strings.h>
 #include "xfs.h"
 #include "fsgeom.h"
 #include "bulkstat.h"
 
+/*
+ * Wrapper functions for BULKSTAT and INUMBERS
+ * ===========================================
+ *
+ * The functions in this file are thin wrappers around the most recent version
+ * of the BULKSTAT and INUMBERS ioctls.  BULKSTAT is used to query XFS-specific
+ * stat information about a group of inodes.  INUMBERS is used to query
+ * allocation information about batches of XFS inodes.
+ *
+ * At the moment, the public xfrog_* functions provide all functionality of the
+ * V5 interface.  If the V5 interface is not available on the running kernel,
+ * the functions will emulate them as best they can with previous versions of
+ * the interface (currently V1).  If emulation is not possible, EINVAL will be
+ * returned.
+ *
+ * The XFROG_FLAG_BULKSTAT_FORCE_V[15] flags can be used to force use of a
+ * particular version of the kernel interface for testing.
+ */
+
+/*
+ * Grab the fs geometry information that is needed to needed to emulate v5 with
+ * v1 interfaces.
+ */
+static inline int
+xfrog_bulkstat_prep_v1_emulation(
+	struct xfs_fd		*xfd)
+{
+	if (xfd->fsgeom.blocksize > 0)
+		return 0;
+
+	return xfd_prepare_geometry(xfd);
+}
+
+/* Bulkstat a single inode using v5 ioctl. */
+static int
+xfrog_bulkstat_single5(
+	struct xfs_fd			*xfd,
+	uint64_t			ino,
+	unsigned int			flags,
+	struct xfs_bulkstat		*bulkstat)
+{
+	struct xfs_bulkstat_req		*req;
+	int				ret;
+
+	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
+		return EINVAL;
+
+	req = xfrog_bulkstat_alloc_req(1, ino);
+	if (!req)
+		return ENOMEM;
+
+	req->hdr.flags = flags;
+	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
+	if (ret) {
+		ret = errno;
+		goto free;
+	}
+
+	if (req->hdr.ocount == 0) {
+		ret = ENOENT;
+		goto free;
+	}
+
+	memcpy(bulkstat, req->bulkstat, sizeof(struct xfs_bulkstat));
+free:
+	free(req);
+	return ret;
+}
+
+/* Bulkstat a single inode using v1 ioctl. */
+static int
+xfrog_bulkstat_single1(
+	struct xfs_fd			*xfd,
+	uint64_t			ino,
+	unsigned int			flags,
+	struct xfs_bulkstat		*bulkstat)
+{
+	struct xfs_bstat		bstat;
+	struct xfs_fsop_bulkreq		bulkreq = { 0 };
+	int				error;
+
+	if (flags)
+		return EINVAL;
+
+	error = xfrog_bulkstat_prep_v1_emulation(xfd);
+	if (error)
+		return error;
+
+	bulkreq.lastip = (__u64 *)&ino;
+	bulkreq.icount = 1;
+	bulkreq.ubuffer = &bstat;
+	error = ioctl(xfd->fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
+	if (error)
+		return errno;
+
+	xfrog_bulkstat_v1_to_v5(xfd, bulkstat, &bstat);
+	return 0;
+}
+
 /* Bulkstat a single inode.  Returns zero or a positive error code. */
 int
 xfrog_bulkstat_single(
+	struct xfs_fd			*xfd,
+	uint64_t			ino,
+	unsigned int			flags,
+	struct xfs_bulkstat		*bulkstat)
+{
+	int				error;
+
+	if (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V1)
+		goto try_v1;
+
+	error = xfrog_bulkstat_single5(xfd, ino, flags, bulkstat);
+	if (error == 0 || (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V5))
+		return error;
+
+	/* If the v5 ioctl wasn't found, we punt to v1. */
+	switch (error) {
+	case EOPNOTSUPP:
+	case ENOTTY:
+		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
+		break;
+	}
+
+try_v1:
+	return xfrog_bulkstat_single1(xfd, ino, flags, bulkstat);
+}
+
+/*
+ * Set up the necessary control structures to emulate a V5 bulk request ioctl
+ * by calling a V1 bulk request ioctl.  This enables callers to run on older
+ * kernels.
+ *
+ * Returns 0 if the emulation should proceed; ECANCELED if there are no
+ * records; or a positive error code.
+ */
+static int
+xfrog_bulk_req_v1_setup(
 	struct xfs_fd		*xfd,
-	uint64_t		ino,
-	struct xfs_bstat	*ubuffer)
+	struct xfs_bulk_ireq	*hdr,
+	struct xfs_fsop_bulkreq	*bulkreq,
+	size_t			rec_size)
+{
+	void			*buf;
+
+	if (hdr->flags & XFS_BULK_IREQ_AGNO) {
+		uint32_t	agno = cvt_ino_to_agno(xfd, hdr->ino);
+
+		if (hdr->ino == 0)
+			hdr->ino = cvt_agino_to_ino(xfd, hdr->agno, 0);
+		else if (agno < hdr->agno)
+			return EINVAL;
+		else if (agno > hdr->agno)
+			goto no_results;
+	}
+
+	if (cvt_ino_to_agno(xfd, hdr->ino) > xfd->fsgeom.agcount)
+		goto no_results;
+
+	buf = malloc(hdr->icount * rec_size);
+	if (!buf)
+		return errno;
+
+	if (hdr->ino)
+		hdr->ino--;
+	bulkreq->lastip = (__u64 *)&hdr->ino,
+	bulkreq->icount = hdr->icount,
+	bulkreq->ocount = (__s32 *)&hdr->ocount,
+	bulkreq->ubuffer = buf;
+	return 0;
+
+no_results:
+	hdr->ocount = 0;
+	return ECANCELED;
+}
+
+/*
+ * Clean up after using a V1 bulk request to emulate a V5 bulk request call.
+ *
+ * If the ioctl was successful, we need to convert the returned V1-format bulk
+ * request data into the V5-format bulk request data and copy it into the
+ * caller's buffer.  We also need to free all resources allocated during the
+ * setup setup.
+ */
+static int
+xfrog_bulk_req_v1_cleanup(
+	struct xfs_fd		*xfd,
+	struct xfs_bulk_ireq	*hdr,
+	struct xfs_fsop_bulkreq	*bulkreq,
+	size_t			v1_rec_size,
+	uint64_t		(*v1_ino)(void *v1_rec),
+	void			*v5_records,
+	size_t			v5_rec_size,
+	void			(*cvt)(struct xfs_fd *xfd, void *v5, void *v1),
+	unsigned int		startino_adj,
+	int			error)
+{
+	void			*v1_rec = bulkreq->ubuffer;
+	void			*v5_rec = v5_records;
+	unsigned int		i;
+
+	if (error == ECANCELED) {
+		error = 0;
+		goto free;
+	}
+	if (error)
+		goto free;
+
+	/*
+	 * Convert each record from v1 to v5 format, keeping the startino
+	 * value up to date and (if desired) stopping at the end of the
+	 * AG.
+	 */
+	for (i = 0;
+	     i < hdr->ocount;
+	     i++, v1_rec += v1_rec_size, v5_rec += v5_rec_size) {
+		uint64_t	ino = v1_ino(v1_rec);
+
+		/* Stop if we hit a different AG. */
+		if ((hdr->flags & XFS_BULK_IREQ_AGNO) &&
+		    cvt_ino_to_agno(xfd, ino) != hdr->agno) {
+			hdr->ocount = i;
+			break;
+		}
+		cvt(xfd, v5_rec, v1_rec);
+		hdr->ino = ino + startino_adj;
+	}
+
+free:
+	free(bulkreq->ubuffer);
+	return error;
+}
+
+static uint64_t xfrog_bstat_ino(void *v1_rec)
+{
+	return ((struct xfs_bstat *)v1_rec)->bs_ino;
+}
+
+static void xfrog_bstat_cvt(struct xfs_fd *xfd, void *v5, void *v1)
+{
+	xfrog_bulkstat_v1_to_v5(xfd, v5, v1);
+}
+
+/* Bulkstat a bunch of inodes using the v5 interface. */
+static int
+xfrog_bulkstat5(
+	struct xfs_fd		*xfd,
+	struct xfs_bulkstat_req	*req)
 {
-	__u64			i = ino;
-	struct xfs_fsop_bulkreq	bulkreq = {
-		.lastip		= &i,
-		.icount		= 1,
-		.ubuffer	= ubuffer,
-		.ocount		= NULL,
-	};
 	int			ret;
 
-	ret = ioctl(xfd->fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
+	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
 	if (ret)
 		return errno;
 	return 0;
 }
 
+/* Bulkstat a bunch of inodes using the v1 interface. */
+static int
+xfrog_bulkstat1(
+	struct xfs_fd		*xfd,
+	struct xfs_bulkstat_req	*req)
+{
+	struct xfs_fsop_bulkreq	bulkreq = { 0 };
+	int			error;
+
+	error = xfrog_bulkstat_prep_v1_emulation(xfd);
+	if (error)
+		return error;
+
+	error = xfrog_bulk_req_v1_setup(xfd, &req->hdr, &bulkreq,
+			sizeof(struct xfs_bstat));
+	if (error == ECANCELED)
+		goto out_teardown;
+	if (error)
+		return error;
+
+	error = ioctl(xfd->fd, XFS_IOC_FSBULKSTAT, &bulkreq);
+	if (error)
+		error = errno;
+
+out_teardown:
+	return xfrog_bulk_req_v1_cleanup(xfd, &req->hdr, &bulkreq,
+			sizeof(struct xfs_bstat), xfrog_bstat_ino,
+			&req->bulkstat, sizeof(struct xfs_bulkstat),
+			xfrog_bstat_cvt, 1, error);
+}
+
 /* Bulkstat a bunch of inodes.  Returns zero or a positive error code. */
 int
 xfrog_bulkstat(
 	struct xfs_fd		*xfd,
-	uint64_t		*lastino,
-	uint32_t		icount,
-	struct xfs_bstat	*ubuffer,
-	uint32_t		*ocount)
+	struct xfs_bulkstat_req	*req)
 {
-	struct xfs_fsop_bulkreq	bulkreq = {
-		.lastip		= (__u64 *)lastino,
-		.icount		= icount,
-		.ubuffer	= ubuffer,
-		.ocount		= (__s32 *)ocount,
-	};
-	int			ret;
+	int			error;
 
-	ret = ioctl(xfd->fd, XFS_IOC_FSBULKSTAT, &bulkreq);
-	if (ret)
-		return errno;
+	if (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V1)
+		goto try_v1;
+
+	error = xfrog_bulkstat5(xfd, req);
+	if (error == 0 || (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V5))
+		return error;
+
+	/* If the v5 ioctl wasn't found, we punt to v1. */
+	switch (error) {
+	case EOPNOTSUPP:
+	case ENOTTY:
+		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
+		break;
+	}
+
+try_v1:
+	return xfrog_bulkstat1(xfd, req);
+}
+
+static bool
+time_too_big(
+	uint64_t	time)
+{
+	time_t		TIME_MAX;
+
+	memset(&TIME_MAX, 0xFF, sizeof(TIME_MAX));
+	return time > TIME_MAX;
+}
+
+/* Convert bulkstat data from v5 format to v1 format. */
+int
+xfrog_bulkstat_v5_to_v1(
+	struct xfs_fd			*xfd,
+	struct xfs_bstat		*bs1,
+	const struct xfs_bulkstat	*bs5)
+{
+	if (bs5->bs_aextents > UINT16_MAX ||
+	    cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks) > UINT32_MAX ||
+	    cvt_off_fsb_to_b(xfd, bs5->bs_cowextsize_blks) > UINT32_MAX ||
+	    time_too_big(bs5->bs_atime) ||
+	    time_too_big(bs5->bs_ctime) ||
+	    time_too_big(bs5->bs_mtime))
+		return ERANGE;
+
+	bs1->bs_ino = bs5->bs_ino;
+	bs1->bs_mode = bs5->bs_mode;
+	bs1->bs_nlink = bs5->bs_nlink;
+	bs1->bs_uid = bs5->bs_uid;
+	bs1->bs_gid = bs5->bs_gid;
+	bs1->bs_rdev = bs5->bs_rdev;
+	bs1->bs_blksize = bs5->bs_blksize;
+	bs1->bs_size = bs5->bs_size;
+	bs1->bs_atime.tv_sec = bs5->bs_atime;
+	bs1->bs_mtime.tv_sec = bs5->bs_mtime;
+	bs1->bs_ctime.tv_sec = bs5->bs_ctime;
+	bs1->bs_atime.tv_nsec = bs5->bs_atime_nsec;
+	bs1->bs_mtime.tv_nsec = bs5->bs_mtime_nsec;
+	bs1->bs_ctime.tv_nsec = bs5->bs_ctime_nsec;
+	bs1->bs_blocks = bs5->bs_blocks;
+	bs1->bs_xflags = bs5->bs_xflags;
+	bs1->bs_extsize = cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks);
+	bs1->bs_extents = bs5->bs_extents;
+	bs1->bs_gen = bs5->bs_gen;
+	bs1->bs_projid_lo = bs5->bs_projectid & 0xFFFF;
+	bs1->bs_forkoff = bs5->bs_forkoff;
+	bs1->bs_projid_hi = bs5->bs_projectid >> 16;
+	bs1->bs_sick = bs5->bs_sick;
+	bs1->bs_checked = bs5->bs_checked;
+	bs1->bs_cowextsize = cvt_off_fsb_to_b(xfd, bs5->bs_cowextsize_blks);
+	bs1->bs_dmevmask = 0;
+	bs1->bs_dmstate = 0;
+	bs1->bs_aextents = bs5->bs_aextents;
 	return 0;
 }
 
+/* Convert bulkstat data from v1 format to v5 format. */
+void
+xfrog_bulkstat_v1_to_v5(
+	struct xfs_fd			*xfd,
+	struct xfs_bulkstat		*bs5,
+	const struct xfs_bstat		*bs1)
+{
+	memset(bs5, 0, sizeof(*bs5));
+	bs5->bs_version = XFS_BULKSTAT_VERSION_V1;
+
+	bs5->bs_ino = bs1->bs_ino;
+	bs5->bs_mode = bs1->bs_mode;
+	bs5->bs_nlink = bs1->bs_nlink;
+	bs5->bs_uid = bs1->bs_uid;
+	bs5->bs_gid = bs1->bs_gid;
+	bs5->bs_rdev = bs1->bs_rdev;
+	bs5->bs_blksize = bs1->bs_blksize;
+	bs5->bs_size = bs1->bs_size;
+	bs5->bs_atime = bs1->bs_atime.tv_sec;
+	bs5->bs_mtime = bs1->bs_mtime.tv_sec;
+	bs5->bs_ctime = bs1->bs_ctime.tv_sec;
+	bs5->bs_atime_nsec = bs1->bs_atime.tv_nsec;
+	bs5->bs_mtime_nsec = bs1->bs_mtime.tv_nsec;
+	bs5->bs_ctime_nsec = bs1->bs_ctime.tv_nsec;
+	bs5->bs_blocks = bs1->bs_blocks;
+	bs5->bs_xflags = bs1->bs_xflags;
+	bs5->bs_extsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_extsize);
+	bs5->bs_extents = bs1->bs_extents;
+	bs5->bs_gen = bs1->bs_gen;
+	bs5->bs_projectid = bstat_get_projid(bs1);
+	bs5->bs_forkoff = bs1->bs_forkoff;
+	bs5->bs_sick = bs1->bs_sick;
+	bs5->bs_checked = bs1->bs_checked;
+	bs5->bs_cowextsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_cowextsize);
+	bs5->bs_aextents = bs1->bs_aextents;
+}
+
+/* Allocate a bulkstat request.  On error returns NULL and sets errno. */
+struct xfs_bulkstat_req *
+xfrog_bulkstat_alloc_req(
+	uint32_t		nr,
+	uint64_t		startino)
+{
+	struct xfs_bulkstat_req	*breq;
+
+	breq = calloc(1, XFS_BULKSTAT_REQ_SIZE(nr));
+	if (!breq)
+		return NULL;
+
+	breq->hdr.icount = nr;
+	breq->hdr.ino = startino;
+
+	return breq;
+}
+
 /*
  * Query inode allocation bitmask information.  Returns zero or a positive
  * error code.
diff --git a/libfrog/bulkstat.h b/libfrog/bulkstat.h
index 83ac0e37..bbbc69a2 100644
--- a/libfrog/bulkstat.h
+++ b/libfrog/bulkstat.h
@@ -8,10 +8,16 @@
 
 /* Bulkstat wrappers */
 struct xfs_bstat;
-int xfrog_bulkstat_single(struct xfs_fd *xfd, uint64_t ino,
-		struct xfs_bstat *ubuffer);
-int xfrog_bulkstat(struct xfs_fd *xfd, uint64_t *lastino, uint32_t icount,
-		struct xfs_bstat *ubuffer, uint32_t *ocount);
+int xfrog_bulkstat_single(struct xfs_fd *xfd, uint64_t ino, unsigned int flags,
+		struct xfs_bulkstat *bulkstat);
+int xfrog_bulkstat(struct xfs_fd *xfd, struct xfs_bulkstat_req *req);
+
+struct xfs_bulkstat_req *xfrog_bulkstat_alloc_req(uint32_t nr,
+		uint64_t startino);
+int xfrog_bulkstat_v5_to_v1(struct xfs_fd *xfd, struct xfs_bstat *bs1,
+		const struct xfs_bulkstat *bstat);
+void xfrog_bulkstat_v1_to_v5(struct xfs_fd *xfd, struct xfs_bulkstat *bstat,
+		const struct xfs_bstat *bs1);
 
 struct xfs_inogrp;
 int xfrog_inumbers(struct xfs_fd *xfd, uint64_t *lastino, uint32_t icount,
diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index 55b14c2b..ca38324e 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -39,8 +39,17 @@ struct xfs_fd {
 
 	/* log2 of sb_blocksize / sb_sectsize */
 	unsigned int		blkbb_log;
+
+	/* XFROG_FLAG_* state flags */
+	unsigned int		flags;
 };
 
+/* Only use v1 bulkstat/inumbers ioctls. */
+#define XFROG_FLAG_BULKSTAT_FORCE_V1	(1 << 0)
+
+/* Only use v5 bulkstat/inumbers ioctls. */
+#define XFROG_FLAG_BULKSTAT_FORCE_V5	(1 << 1)
+
 /* Static initializers */
 #define XFS_FD_INIT(_fd)	{ .fd = (_fd), }
 #define XFS_FD_INIT_EMPTY	XFS_FD_INIT(-1)
diff --git a/quota/quot.c b/quota/quot.c
index 686b2726..7edfad16 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -69,7 +69,7 @@ quot_help(void)
 
 static void
 quot_bulkstat_add(
-	struct xfs_bstat *p,
+	struct xfs_bulkstat	*p,
 	uint		flags)
 {
 	du_t		*dp;
@@ -93,7 +93,7 @@ quot_bulkstat_add(
 	}
 	for (i = 0; i < 3; i++) {
 		id = (i == 0) ? p->bs_uid : ((i == 1) ?
-			p->bs_gid : bstat_get_projid(p));
+			p->bs_gid : p->bs_projectid);
 		hp = &duhash[i][id % DUHASH];
 		for (dp = *hp; dp; dp = dp->next)
 			if (dp->id == id)
@@ -113,11 +113,11 @@ quot_bulkstat_add(
 		}
 		dp->blocks += size;
 
-		if (now - p->bs_atime.tv_sec > 30 * (60*60*24))
+		if (now - p->bs_atime > 30 * (60*60*24))
 			dp->blocks30 += size;
-		if (now - p->bs_atime.tv_sec > 60 * (60*60*24))
+		if (now - p->bs_atime > 60 * (60*60*24))
 			dp->blocks60 += size;
-		if (now - p->bs_atime.tv_sec > 90 * (60*60*24))
+		if (now - p->bs_atime > 90 * (60*60*24))
 			dp->blocks90 += size;
 		dp->nfiles++;
 	}
@@ -129,9 +129,7 @@ quot_bulkstat_mount(
 	unsigned int		flags)
 {
 	struct xfs_fd		fsxfd = XFS_FD_INIT_EMPTY;
-	struct xfs_bstat	*buf;
-	uint64_t		last = 0;
-	uint32_t		count;
+	struct xfs_bulkstat_req	*breq;
 	int			i, sts, ret;
 	du_t			**dp;
 
@@ -154,25 +152,24 @@ quot_bulkstat_mount(
 		return;
 	}
 
-	buf = (struct xfs_bstat *)calloc(NBSTAT, sizeof(struct xfs_bstat));
-	if (!buf) {
+	breq = xfrog_bulkstat_alloc_req(NBSTAT, 0);
+	if (!breq) {
 		perror("calloc");
 		xfd_close(&fsxfd);
 		return;
 	}
 
-	while ((sts = xfrog_bulkstat(&fsxfd, &last, NBSTAT, buf,
-				&count)) == 0) {
-		if (count == 0)
+	while ((sts = xfrog_bulkstat(&fsxfd, breq)) == 0) {
+		if (breq->hdr.ocount == 0)
 			break;
-		for (i = 0; i < count; i++)
-			quot_bulkstat_add(&buf[i], flags);
+		for (i = 0; i < breq->hdr.ocount; i++)
+			quot_bulkstat_add(&breq->bulkstat[i], flags);
 	}
 	if (sts < 0) {
 		errno = sts;
 		perror("XFS_IOC_FSBULKSTAT");
 	}
-	free(buf);
+	free(breq);
 	xfd_close(&fsxfd);
 }
 
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 580a845e..2112c9d1 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -50,9 +50,9 @@ static void
 xfs_iterate_inodes_range_check(
 	struct scrub_ctx	*ctx,
 	struct xfs_inogrp	*inogrp,
-	struct xfs_bstat	*bstat)
+	struct xfs_bulkstat	*bstat)
 {
-	struct xfs_bstat	*bs;
+	struct xfs_bulkstat	*bs;
 	int			i;
 	int			error;
 
@@ -66,9 +66,9 @@ xfs_iterate_inodes_range_check(
 
 		/* Load the one inode. */
 		error = xfrog_bulkstat_single(&ctx->mnt,
-				inogrp->xi_startino + i, bs);
+				inogrp->xi_startino + i, 0, bs);
 		if (error || bs->bs_ino != inogrp->xi_startino + i) {
-			memset(bs, 0, sizeof(struct xfs_bstat));
+			memset(bs, 0, sizeof(struct xfs_bulkstat));
 			bs->bs_ino = inogrp->xi_startino + i;
 			bs->bs_blksize = ctx->mnt_sv.f_frsize;
 		}
@@ -93,41 +93,41 @@ xfs_iterate_inodes_range(
 {
 	struct xfs_handle	handle;
 	struct xfs_inogrp	inogrp;
-	struct xfs_bstat	bstat[XFS_INODES_PER_CHUNK];
+	struct xfs_bulkstat_req	*breq;
 	char			idescr[DESCR_BUFSZ];
-	struct xfs_bstat	*bs;
+	struct xfs_bulkstat	*bs;
 	uint64_t		igrp_ino;
-	uint64_t		ino;
-	uint32_t		bulklen = 0;
 	uint32_t		igrplen = 0;
 	bool			moveon = true;
 	int			i;
 	int			error;
 	int			stale_count = 0;
 
-
-	memset(bstat, 0, XFS_INODES_PER_CHUNK * sizeof(struct xfs_bstat));
-
 	memcpy(&handle.ha_fsid, fshandle, sizeof(handle.ha_fsid));
 	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
 			sizeof(handle.ha_fid.fid_len);
 	handle.ha_fid.fid_pad = 0;
 
+	breq = xfrog_bulkstat_alloc_req(XFS_INODES_PER_CHUNK, 0);
+	if (!breq) {
+		str_info(ctx, descr, _("Insufficient memory; giving up."));
+		return false;
+	}
+
 	/* Find the inode chunk & alloc mask */
 	igrp_ino = first_ino;
 	error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp, &igrplen);
 	while (!error && igrplen) {
-		/* Load the inodes. */
-		ino = inogrp.xi_startino - 1;
-
 		/*
 		 * We can have totally empty inode chunks on filesystems where
 		 * there are more than 64 inodes per block.  Skip these.
 		 */
 		if (inogrp.xi_alloccount == 0)
 			goto igrp_retry;
-		error = xfrog_bulkstat(&ctx->mnt, &ino, inogrp.xi_alloccount,
-				bstat, &bulklen);
+
+		breq->hdr.ino = inogrp.xi_startino;
+		breq->hdr.icount = inogrp.xi_alloccount;
+		error = xfrog_bulkstat(&ctx->mnt, breq);
 		if (error) {
 			char	errbuf[DESCR_BUFSZ];
 
@@ -135,10 +135,12 @@ xfs_iterate_inodes_range(
 						errbuf, DESCR_BUFSZ));
 		}
 
-		xfs_iterate_inodes_range_check(ctx, &inogrp, bstat);
+		xfs_iterate_inodes_range_check(ctx, &inogrp, breq->bulkstat);
 
 		/* Iterate all the inodes. */
-		for (i = 0, bs = bstat; i < inogrp.xi_alloccount; i++, bs++) {
+		for (i = 0, bs = breq->bulkstat;
+		     i < inogrp.xi_alloccount;
+		     i++, bs++) {
 			if (bs->bs_ino > last_ino)
 				goto out;
 
@@ -184,6 +186,7 @@ _("Changed too many times during scan; giving up."));
 		str_liberror(ctx, error, descr);
 		moveon = false;
 	}
+	free(breq);
 out:
 	return moveon;
 }
diff --git a/scrub/inodes.h b/scrub/inodes.h
index 631848c3..3341c6d9 100644
--- a/scrub/inodes.h
+++ b/scrub/inodes.h
@@ -7,7 +7,7 @@
 #define XFS_SCRUB_INODES_H_
 
 typedef int (*xfs_inode_iter_fn)(struct scrub_ctx *ctx,
-		struct xfs_handle *handle, struct xfs_bstat *bs, void *arg);
+		struct xfs_handle *handle, struct xfs_bulkstat *bs, void *arg);
 
 #define XFS_ITERATE_INODES_ABORT	(-1)
 bool xfs_scan_all_inodes(struct scrub_ctx *ctx, xfs_inode_iter_fn fn,
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 81c64cd1..a32d1ced 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -30,7 +30,7 @@ xfs_scrub_fd(
 	struct scrub_ctx	*ctx,
 	bool			(*fn)(struct scrub_ctx *ctx, uint64_t ino,
 				      uint32_t gen, struct xfs_action_list *a),
-	struct xfs_bstat	*bs,
+	struct xfs_bulkstat	*bs,
 	struct xfs_action_list	*alist)
 {
 	return fn(ctx, bs->bs_ino, bs->bs_gen, alist);
@@ -45,7 +45,7 @@ struct scrub_inode_ctx {
 static void
 xfs_scrub_inode_vfs_error(
 	struct scrub_ctx	*ctx,
-	struct xfs_bstat	*bstat)
+	struct xfs_bulkstat	*bstat)
 {
 	char			descr[DESCR_BUFSZ];
 	xfs_agnumber_t		agno;
@@ -65,7 +65,7 @@ static int
 xfs_scrub_inode(
 	struct scrub_ctx	*ctx,
 	struct xfs_handle	*handle,
-	struct xfs_bstat	*bstat,
+	struct xfs_bulkstat	*bstat,
 	void			*arg)
 {
 	struct xfs_action_list	alist;
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 3ff34251..99cd51b2 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -80,7 +80,7 @@ xfs_scrub_scan_dirents(
 	struct scrub_ctx	*ctx,
 	const char		*descr,
 	int			*fd,
-	struct xfs_bstat	*bstat)
+	struct xfs_bulkstat	*bstat)
 {
 	struct unicrash		*uc = NULL;
 	DIR			*dir;
@@ -140,7 +140,7 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 	struct scrub_ctx		*ctx,
 	const char			*descr,
 	struct xfs_handle		*handle,
-	struct xfs_bstat		*bstat,
+	struct xfs_bulkstat		*bstat,
 	const struct attrns_decode	*attr_ns)
 {
 	struct attrlist_cursor		cur;
@@ -200,7 +200,7 @@ xfs_scrub_scan_fhandle_xattrs(
 	struct scrub_ctx		*ctx,
 	const char			*descr,
 	struct xfs_handle		*handle,
-	struct xfs_bstat		*bstat)
+	struct xfs_bulkstat		*bstat)
 {
 	const struct attrns_decode	*ns;
 	bool				moveon = true;
@@ -228,7 +228,7 @@ static int
 xfs_scrub_connections(
 	struct scrub_ctx	*ctx,
 	struct xfs_handle	*handle,
-	struct xfs_bstat	*bstat,
+	struct xfs_bulkstat	*bstat,
 	void			*arg)
 {
 	bool			*pmoveon = arg;
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 506e75d2..b41f90e0 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -172,7 +172,7 @@ static int
 xfs_report_verify_inode(
 	struct scrub_ctx		*ctx,
 	struct xfs_handle		*handle,
-	struct xfs_bstat		*bstat,
+	struct xfs_bulkstat		*bstat,
 	void				*arg)
 {
 	char				descr[DESCR_BUFSZ];
diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 17e8f34f..b02c5658 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -432,7 +432,7 @@ unicrash_init(
  */
 static bool
 is_only_root_writable(
-	struct xfs_bstat	*bstat)
+	struct xfs_bulkstat	*bstat)
 {
 	if (bstat->bs_uid != 0 || bstat->bs_gid != 0)
 		return false;
@@ -444,7 +444,7 @@ bool
 unicrash_dir_init(
 	struct unicrash		**ucp,
 	struct scrub_ctx	*ctx,
-	struct xfs_bstat	*bstat)
+	struct xfs_bulkstat	*bstat)
 {
 	/*
 	 * Assume 64 bytes per dentry, clamp buckets between 16 and 64k.
@@ -459,7 +459,7 @@ bool
 unicrash_xattr_init(
 	struct unicrash		**ucp,
 	struct scrub_ctx	*ctx,
-	struct xfs_bstat	*bstat)
+	struct xfs_bulkstat	*bstat)
 {
 	/* Assume 16 attributes per extent for lack of a better idea. */
 	return unicrash_init(ucp, ctx, false, 16 * (1 + bstat->bs_aextents),
diff --git a/scrub/unicrash.h b/scrub/unicrash.h
index fb8f5f72..feb9cc86 100644
--- a/scrub/unicrash.h
+++ b/scrub/unicrash.h
@@ -14,9 +14,9 @@ struct unicrash;
 struct dirent;
 
 bool unicrash_dir_init(struct unicrash **ucp, struct scrub_ctx *ctx,
-		struct xfs_bstat *bstat);
+		struct xfs_bulkstat *bstat);
 bool unicrash_xattr_init(struct unicrash **ucp, struct scrub_ctx *ctx,
-		struct xfs_bstat *bstat);
+		struct xfs_bulkstat *bstat);
 bool unicrash_fs_label_init(struct unicrash **ucp, struct scrub_ctx *ctx);
 void unicrash_free(struct unicrash *uc);
 bool unicrash_check_dir_name(struct unicrash *uc, const char *descr,
diff --git a/spaceman/health.c b/spaceman/health.c
index a8bd3f3e..b195a229 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -208,7 +208,7 @@ report_inode_health(
 	unsigned long long	ino,
 	const char		*descr)
 {
-	struct xfs_bstat	bs;
+	struct xfs_bulkstat	bs;
 	char			d[256];
 	int			ret;
 
@@ -217,7 +217,7 @@ report_inode_health(
 		descr = d;
 	}
 
-	ret = xfrog_bulkstat_single(&file->xfd, ino, &bs);
+	ret = xfrog_bulkstat_single(&file->xfd, ino, 0, &bs);
 	if (ret) {
 		errno = ret;
 		perror(descr);
@@ -266,11 +266,10 @@ static int
 report_bulkstat_health(
 	xfs_agnumber_t		agno)
 {
-	struct xfs_bstat	bstat[BULKSTAT_NR];
+	struct xfs_bulkstat_req	*breq;
 	char			descr[256];
 	uint64_t		startino = 0;
 	uint64_t		lastino = -1ULL;
-	uint32_t		ocount;
 	uint32_t		i;
 	int			error;
 
@@ -279,26 +278,34 @@ report_bulkstat_health(
 		lastino = cvt_agino_to_ino(&file->xfd, agno + 1, 0) - 1;
 	}
 
+	breq = xfrog_bulkstat_alloc_req(BULKSTAT_NR, startino);
+	if (!breq) {
+		perror("bulk alloc req");
+		exitcode = 1;
+		return 1;
+	}
+
 	do {
-		error = xfrog_bulkstat(&file->xfd, &startino, BULKSTAT_NR,
-				bstat, &ocount);
+		error = xfrog_bulkstat(&file->xfd, breq);
 		if (error)
 			break;
-		for (i = 0; i < ocount; i++) {
-			if (bstat[i].bs_ino > lastino)
+		for (i = 0; i < breq->hdr.ocount; i++) {
+			if (breq->bulkstat[i].bs_ino > lastino)
 				goto out;
-			snprintf(descr, sizeof(descr) - 1, _("inode %llu"),
-					bstat[i].bs_ino);
-			report_sick(descr, inode_flags, bstat[i].bs_sick,
-					bstat[i].bs_checked);
+			snprintf(descr, sizeof(descr) - 1, _("inode %"PRIu64),
+					breq->bulkstat[i].bs_ino);
+			report_sick(descr, inode_flags,
+					breq->bulkstat[i].bs_sick,
+					breq->bulkstat[i].bs_checked);
 		}
-	} while (ocount > 0);
+	} while (breq->hdr.ocount > 0);
 
 	if (error) {
 		errno = error;
 		perror("bulkstat");
 	}
 out:
+	free(breq);
 	return error;
 }
 

