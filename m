Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D87C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C76E21881
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:22:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dfAmjDoO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfHZVWl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:22:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52938 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfHZVWl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:22:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDmi5000900;
        Mon, 26 Aug 2019 21:22:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=y8k5Xy6SceTHLm4VhyvUFgarSs+5t6D6HnLhaqDbp3M=;
 b=dfAmjDoOjDQ4WinH40vjntaiJOGRI00LcCs0eH1pk5ri/l5UCDPm5YRFAvA60KwBvrFf
 QeYwTNKHHa4kzokOJV/r4KrI00DxaZ64iV7yQ+C+6kfX3dmQbVYzdaSWiOaxZzR6EZvL
 4bajP1yvWdYSqdwqfFX0dnoId6B46z44po78Uo2W2j/Ta36UEJ5RioW5KemD1pXt+ZrC
 0uoctnhordr+Zdy2ZekdzWspyRHRysfQ77z16zE2389JyPsZA+1D20ou+jrAj55dmYqD
 yuDzqJfwVgS37sff4jZtkGmf7iE9qFLRbMneoaBp7GXzK8rveyeEBFn/oHwglB2i2Az9 ZA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2umpxx04d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:22:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIcCW169557;
        Mon, 26 Aug 2019 21:22:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2umhu7wtua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:22:38 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLMcgK002444;
        Mon, 26 Aug 2019 21:22:38 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:22:37 -0700
Subject: [PATCH 4/5] misc: convert to v5 bulkstat_single call
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:22:36 -0700
Message-ID: <156685455669.2840332.9371973449817694904.stgit@magnolia>
In-Reply-To: <156685453125.2840332.15645173323964762232.stgit@magnolia>
References: <156685453125.2840332.15645173323964762232.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fsr/xfs_fsr.c      |    8 +++-
 include/xfrog.h    |    4 +-
 io/open.c          |    6 ++-
 io/swapext.c       |    4 ++
 libfrog/bulkstat.c |  104 ++++++++++++++++++++++++++++++++++++++++++++++------
 scrub/inodes.c     |    8 +---
 spaceman/health.c  |    4 +-
 7 files changed, 109 insertions(+), 29 deletions(-)


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 207dafc2..9238f93c 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -731,6 +731,7 @@ fsrfile(
 	xfs_ino_t		ino)
 {
 	struct xfs_fd		fsxfd = XFS_FD_INIT_EMPTY;
+	struct xfs_bulkstat	bulkstat;
 	struct xfs_bstat	statbuf;
 	jdm_fshandle_t		*fshandlep;
 	int			fd = -1;
@@ -761,12 +762,13 @@ fsrfile(
 		goto out;
 	}
 
-	error = xfrog_bulkstat_single(&fsxfd, ino, &statbuf);
+	error = xfrog_bulkstat_single(&fsxfd, ino, 0, &bulkstat);
 	if (error < 0) {
 		fsrprintf(_("unable to get bstat on %s: %s\n"),
 			fname, strerror(errno));
 		goto out;
 	}
+	xfrog_bulkstat_to_bstat(&fsxfd, &statbuf, &bulkstat);
 
 	fd = jdm_open(fshandlep, &statbuf, O_RDWR|O_DIRECT);
 	if (fd < 0) {
@@ -987,7 +989,7 @@ fsr_setup_attr_fork(
 
 	i = 0;
 	do {
-		struct xfs_bstat tbstat;
+		struct xfs_bulkstat	tbstat;
 		char		name[64];
 		int		ret;
 
@@ -996,7 +998,7 @@ fsr_setup_attr_fork(
 		 * this to compare against the target and determine what we
 		 * need to do.
 		 */
-		ret = xfrog_bulkstat_single(&txfd, tstatbuf.st_ino, &tbstat);
+		ret = xfrog_bulkstat_single(&txfd, tstatbuf.st_ino, 0, &tbstat);
 		if (ret < 0) {
 			fsrprintf(_("unable to get bstat on temp file: %s\n"),
 						strerror(errno));
diff --git a/include/xfrog.h b/include/xfrog.h
index f71a7786..de87f97c 100644
--- a/include/xfrog.h
+++ b/include/xfrog.h
@@ -177,8 +177,8 @@ xfrog_daddr_to_agbno(
 
 /* Bulkstat wrappers */
 struct xfs_bstat;
-int xfrog_bulkstat_single(struct xfs_fd *xfd, uint64_t ino,
-		struct xfs_bstat *ubuffer);
+int xfrog_bulkstat_single(struct xfs_fd *xfd, uint64_t ino, unsigned int flags,
+		struct xfs_bulkstat *bulkstat);
 int xfrog_bulkstat(struct xfs_fd *xfd, struct xfs_bulkstat_req *req);
 
 struct xfs_bulkstat_req *xfrog_bulkstat_alloc_req(uint32_t nr,
diff --git a/io/open.c b/io/open.c
index 6cbce594..015f88ec 100644
--- a/io/open.c
+++ b/io/open.c
@@ -712,7 +712,7 @@ inode_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_bstat	bstat;
+	struct xfs_bulkstat	bulkstat;
 	uint64_t		result_ino = 0;
 	uint64_t		userino = NULLFSINO;
 	char			*p;
@@ -791,7 +791,7 @@ inode_f(
 		struct xfs_fd	xfd = XFS_FD_INIT(file->fd);
 
 		/* get this inode */
-		ret = xfrog_bulkstat_single(&xfd, userino, &bstat);
+		ret = xfrog_bulkstat_single(&xfd, userino, 0, &bulkstat);
 		if (ret && errno == EINVAL) {
 			/* Not in use */
 			result_ino = 0;
@@ -800,7 +800,7 @@ inode_f(
 			exitcode = 1;
 			return 0;
 		} else {
-			result_ino = bstat.bs_ino;
+			result_ino = bulkstat.bs_ino;
 		}
 	}
 
diff --git a/io/swapext.c b/io/swapext.c
index e8432e7d..196d4744 100644
--- a/io/swapext.c
+++ b/io/swapext.c
@@ -27,6 +27,7 @@ swapext_f(
 	char			**argv)
 {
 	struct xfs_fd		fxfd = XFS_FD_INIT(file->fd);
+	struct xfs_bulkstat	bulkstat;
 	int			fd;
 	int			error;
 	struct xfs_swapext	sx;
@@ -47,11 +48,12 @@ swapext_f(
 		goto out;
 	}
 
-	error = xfrog_bulkstat_single(&fxfd, stat.st_ino, &sx.sx_stat);
+	error = xfrog_bulkstat_single(&fxfd, stat.st_ino, 0, &bulkstat);
 	if (error) {
 		perror("bulkstat");
 		goto out;
 	}
+	xfrog_bulkstat_to_bstat(&fxfd, &sx.sx_stat, &bulkstat);
 	sx.sx_version = XFS_SX_VERSION;
 	sx.sx_fdtarget = file->fd;
 	sx.sx_fdtmp = fd;
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index ab27607c..70d9c42a 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -20,22 +20,102 @@ xfrog_bulkstat_prep_v1_emulation(
 	return 0;
 }
 
-/* Bulkstat a single inode. */
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
+	if (flags & ~(XFS_BULK_IREQ_SPECIAL)) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	req = xfrog_bulkstat_alloc_req(1, ino);
+	if (!req)
+		return -1;
+
+	req->hdr.flags = flags;
+	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
+	if (ret)
+		goto free;
+
+	if (req->hdr.ocount == 0) {
+		errno = ENOENT;
+		ret = -1;
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
+	if (flags) {
+		errno = EINVAL;
+		return -1;
+	}
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
+		return error;
+
+	xfrog_bstat_to_bulkstat(xfd, bulkstat, &bstat);
+	return 0;
+}
+
+/* Bulkstat a single inode using v1 ioctl. */
 int
 xfrog_bulkstat_single(
-	struct xfs_fd		*xfd,
-	uint64_t		ino,
-	struct xfs_bstat	*ubuffer)
+	struct xfs_fd			*xfd,
+	uint64_t			ino,
+	unsigned int			flags,
+	struct xfs_bulkstat		*bulkstat)
 {
-	__u64			i = ino;
-	struct xfs_fsop_bulkreq	bulkreq = {
-		.lastip		= &i,
-		.icount		= 1,
-		.ubuffer	= ubuffer,
-		.ocount		= NULL,
-	};
+	int				error;
+
+	if (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V1)
+		goto try_v1;
+
+	error = xfrog_bulkstat_single5(xfd, ino, flags, bulkstat);
+	if (error == 0 || (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V5))
+		return 0;
 
-	return ioctl(xfd->fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
+	/* If the v5 ioctl wasn't found, we punt to v1. */
+	switch (errno) {
+	case EOPNOTSUPP:
+	case ENOTTY:
+		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
+		break;
+	}
+
+try_v1:
+	return xfrog_bulkstat_single1(xfd, ino, flags, bulkstat);
 }
 
 /*
diff --git a/scrub/inodes.c b/scrub/inodes.c
index da3bd82b..49ab74e3 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -56,8 +56,6 @@ xfs_iterate_inodes_range_check(
 	int			error;
 
 	for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
-		struct xfs_bstat bs1;
-
 		if (!(inogrp->xi_allocmask & (1ULL << i)))
 			continue;
 		if (bs->bs_ino == inogrp->xi_startino + i) {
@@ -67,13 +65,11 @@ xfs_iterate_inodes_range_check(
 
 		/* Load the one inode. */
 		error = xfrog_bulkstat_single(&ctx->mnt,
-				inogrp->xi_startino + i, &bs1);
-		if (error || bs1.bs_ino != inogrp->xi_startino + i) {
+				inogrp->xi_startino + i, 0, bs);
+		if (error || bs->bs_ino != inogrp->xi_startino + i) {
 			memset(bs, 0, sizeof(struct xfs_bulkstat));
 			bs->bs_ino = inogrp->xi_startino + i;
 			bs->bs_blksize = ctx->mnt_sv.f_frsize;
-		} else {
-			xfrog_bstat_to_bulkstat(&ctx->mnt, bs, &bs1);
 		}
 		bs++;
 	}
diff --git a/spaceman/health.c b/spaceman/health.c
index e71c1e45..ff03d074 100644
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
 		perror(descr);
 		return 1;

