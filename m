Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8C9C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0199C206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:35:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XbL56YBW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732615AbfIFDf1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:35:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49136 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732613AbfIFDf1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:35:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YecF110274;
        Fri, 6 Sep 2019 03:35:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=GuHkAeorD7iO79c32LK6hZ6rsANnbQobdHRSqAZi2S4=;
 b=XbL56YBWhS3bGWKQ4KX4nkjBnP4ZiZAXSD/udVss45sAltduju6fgjHJEo6vQVSzfQ06
 gW9oVUnJBD1vZ8YPmtAKMQ6dNvckq0c15wOU7mSl4SW5J8+fo9QZrOUaJXh6mhJ5Pn4t
 5TbBUDl2o2buSXcGZ1vjeBUo5g2/EEaHLWHBaviy8aVa4sYCcUk4cRynLyXVJe7MP9Yc
 d4ttHNQ/J+03aIgPFpLZcMMBM6kIZNRK48vXe23+445/6+rldfj7XiOkSrZbGaO1iK22
 fZynH1CFH+gqg8iMFUarpqV3vsy6gg6Q8bnJSGjFNGyzAD4p19eqPBGSSRKluTWnezrz 1g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uuf4n037c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:35:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YOuU088444;
        Fri, 6 Sep 2019 03:35:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uu1b99r8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:35:23 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863ZMub014582;
        Fri, 6 Sep 2019 03:35:23 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:35:22 -0700
Subject: [PATCH 4/6] misc: convert to v5 bulkstat_single call
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:35:22 -0700
Message-ID: <156774092210.2643497.7118033849671297049.stgit@magnolia>
In-Reply-To: <156774089024.2643497.2754524603021685770.stgit@magnolia>
References: <156774089024.2643497.2754524603021685770.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fsr/xfs_fsr.c      |    8 +++-
 io/open.c          |    6 ++-
 io/swapext.c       |    4 ++
 libfrog/bulkstat.c |  103 ++++++++++++++++++++++++++++++++++++++++++++--------
 libfrog/bulkstat.h |    4 +-
 scrub/inodes.c     |    8 +---
 spaceman/health.c  |    4 +-
 7 files changed, 105 insertions(+), 32 deletions(-)


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index cc3cc93a..e8fa39ab 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -724,6 +724,7 @@ fsrfile(
 	xfs_ino_t		ino)
 {
 	struct xfs_fd		fsxfd = XFS_FD_INIT_EMPTY;
+	struct xfs_bulkstat	bulkstat;
 	struct xfs_bstat	statbuf;
 	jdm_fshandle_t		*fshandlep;
 	int			fd = -1;
@@ -748,12 +749,13 @@ fsrfile(
 		goto out;
 	}
 
-	error = xfrog_bulkstat_single(&fsxfd, ino, &statbuf);
+	error = xfrog_bulkstat_single(&fsxfd, ino, 0, &bulkstat);
 	if (error) {
 		fsrprintf(_("unable to get bstat on %s: %s\n"),
 			fname, strerror(error));
 		goto out;
 	}
+	xfrog_bulkstat_to_bstat(&fsxfd, &statbuf, &bulkstat);
 
 	fd = jdm_open(fshandlep, &statbuf, O_RDWR|O_DIRECT);
 	if (fd < 0) {
@@ -974,7 +976,7 @@ fsr_setup_attr_fork(
 
 	i = 0;
 	do {
-		struct xfs_bstat tbstat;
+		struct xfs_bulkstat	tbstat;
 		char		name[64];
 		int		ret;
 
@@ -983,7 +985,7 @@ fsr_setup_attr_fork(
 		 * this to compare against the target and determine what we
 		 * need to do.
 		 */
-		ret = xfrog_bulkstat_single(&txfd, tstatbuf.st_ino, &tbstat);
+		ret = xfrog_bulkstat_single(&txfd, tstatbuf.st_ino, 0, &tbstat);
 		if (ret) {
 			fsrprintf(_("unable to get bstat on temp file: %s\n"),
 						strerror(ret));
diff --git a/io/open.c b/io/open.c
index e1aac7d1..e1979501 100644
--- a/io/open.c
+++ b/io/open.c
@@ -723,7 +723,7 @@ inode_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_bstat	bstat;
+	struct xfs_bulkstat	bulkstat;
 	uint64_t		result_ino = 0;
 	uint64_t		userino = NULLFSINO;
 	char			*p;
@@ -803,7 +803,7 @@ inode_f(
 		struct xfs_fd	xfd = XFS_FD_INIT(file->fd);
 
 		/* get this inode */
-		ret = xfrog_bulkstat_single(&xfd, userino, &bstat);
+		ret = xfrog_bulkstat_single(&xfd, userino, 0, &bulkstat);
 		if (ret == EINVAL) {
 			/* Not in use */
 			result_ino = 0;
@@ -813,7 +813,7 @@ inode_f(
 			exitcode = 1;
 			return 0;
 		} else {
-			result_ino = bstat.bs_ino;
+			result_ino = bulkstat.bs_ino;
 		}
 	}
 
diff --git a/io/swapext.c b/io/swapext.c
index 2b4918f8..ca024b93 100644
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
@@ -48,12 +49,13 @@ swapext_f(
 		goto out;
 	}
 
-	error = xfrog_bulkstat_single(&fxfd, stat.st_ino, &sx.sx_stat);
+	error = xfrog_bulkstat_single(&fxfd, stat.st_ino, 0, &bulkstat);
 	if (error) {
 		errno = error;
 		perror("bulkstat");
 		goto out;
 	}
+	xfrog_bulkstat_to_bstat(&fxfd, &sx.sx_stat, &bulkstat);
 	sx.sx_version = XFS_SX_VERSION;
 	sx.sx_fdtarget = file->fd;
 	sx.sx_fdtmp = fd;
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index b4468243..2a70824e 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -20,26 +20,99 @@ xfrog_bulkstat_prep_v1_emulation(
 	return xfd_prepare_geometry(xfd);
 }
 
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
+	xfrog_bstat_to_bulkstat(xfd, bulkstat, &bstat);
+	return 0;
+}
+
 /* Bulkstat a single inode.  Returns zero or a positive error code. */
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
-	int			ret;
+	int				error;
 
-	ret = ioctl(xfd->fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
-	if (ret)
-		return errno;
-	return 0;
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
 }
 
 /*
diff --git a/libfrog/bulkstat.h b/libfrog/bulkstat.h
index 6f51c167..3135e752 100644
--- a/libfrog/bulkstat.h
+++ b/libfrog/bulkstat.h
@@ -8,8 +8,8 @@
 
 /* Bulkstat wrappers */
 struct xfs_bstat;
-int xfrog_bulkstat_single(struct xfs_fd *xfd, uint64_t ino,
-		struct xfs_bstat *ubuffer);
+int xfrog_bulkstat_single(struct xfs_fd *xfd, uint64_t ino, unsigned int flags,
+		struct xfs_bulkstat *bulkstat);
 int xfrog_bulkstat(struct xfs_fd *xfd, struct xfs_bulkstat_req *req);
 
 struct xfs_bulkstat_req *xfrog_bulkstat_alloc_req(uint32_t nr,
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 851c24bd..2112c9d1 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -57,8 +57,6 @@ xfs_iterate_inodes_range_check(
 	int			error;
 
 	for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
-		struct xfs_bstat bs1;
-
 		if (!(inogrp->xi_allocmask & (1ULL << i)))
 			continue;
 		if (bs->bs_ino == inogrp->xi_startino + i) {
@@ -68,13 +66,11 @@ xfs_iterate_inodes_range_check(
 
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
index 9bed7fdf..b6e1fcd9 100644
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

