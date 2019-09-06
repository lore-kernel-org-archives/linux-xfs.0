Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4015C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4F43206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:37:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HplzL4SX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392139AbfIFDhW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:37:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43062 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732799AbfIFDhW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:37:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XuXV074305;
        Fri, 6 Sep 2019 03:37:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kpdeyys3WjLYkOL5PqAR9+xePD/7eaROmfGo5eFFFHk=;
 b=HplzL4SXyeTICxOJPkI5UyBGybSjvJzQ6ZhmYe/hiIKza0PRnujq4h7xhtAv3tho6S/N
 fXDHxZip1XlDPOIQbyyndrAWAih/M+LcD5iv3wOWFkp9HBT0yhdcPKySe+Cr176R1scl
 CFYaRsWSyTm/4gN0SfbcPggoozIIcvLKqi5RtyTbd3koReA2aA7gMItBqLcSXLST0hZe
 3bwq1pxspH3nIuH1VL6Q2ZPUdG/I9QmFBTfwt7UVl5il1xFz06Rn2P5hLvdstxedcz9C
 VkyuhOm+QwvNszXSNZmY7GqCVhfKP3stJwt49Eina7QPGBqEzLxIAEMSz5QnJ62e1w/X VQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uuf51g372-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:37:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YVft103691;
        Fri, 6 Sep 2019 03:35:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2uud7p2qjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:35:17 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863ZGed004184;
        Fri, 6 Sep 2019 03:35:16 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:35:16 -0700
Subject: [PATCH 3/6] misc: convert XFS_IOC_FSBULKSTAT to XFS_IOC_BULKSTAT
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:35:15 -0700
Message-ID: <156774091553.2643497.13127754211857633238.stgit@magnolia>
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

Convert the v1 calls to v5 calls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fsr/xfs_fsr.c      |   45 ++++++--
 io/open.c          |   17 ++-
 libfrog/bulkstat.c |  290 +++++++++++++++++++++++++++++++++++++++++++++++++---
 libfrog/bulkstat.h |   10 +-
 libfrog/fsgeom.h   |    9 ++
 quota/quot.c       |   29 ++---
 scrub/inodes.c     |   45 +++++---
 scrub/inodes.h     |    2 
 scrub/phase3.c     |    6 +
 scrub/phase5.c     |    8 +
 scrub/phase6.c     |    2 
 scrub/unicrash.c   |    6 +
 scrub/unicrash.h   |    4 -
 spaceman/health.c  |   28 +++--
 14 files changed, 411 insertions(+), 90 deletions(-)


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index a53eb924..cc3cc93a 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -466,6 +466,17 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
 				ptr = strchr(ptr, ' ');
 				if (ptr) {
 					startino = strtoull(++ptr, NULL, 10);
+					/*
+					 * NOTE: The inode number read in from
+					 * the leftoff file is the last inode
+					 * to have been fsr'd.  Since the new
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
@@ -623,7 +643,8 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 			     (p->bs_extents < 2))
 				continue;
 
-			fd = jdm_open(fshandlep, p, O_RDWR|O_DIRECT);
+			xfrog_bulkstat_to_bstat(&fsxfd, &bs1, p);
+			fd = jdm_open(fshandlep, &bs1, O_RDWR | O_DIRECT);
 			if (fd < 0) {
 				/* This probably means the file was
 				 * removed while in progress of handling
@@ -641,7 +662,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 			/* Get a tmp file name */
 			tname = tmp_next(mntdir);
 
-			ret = fsrfile_common(fname, tname, mntdir, fd, p);
+			ret = fsrfile_common(fname, tname, mntdir, fd, &bs1);
 
 			leftoffino = p->bs_ino;
 
@@ -653,6 +674,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 			}
 		}
 		if (endtime && endtime < time(NULL)) {
+			free(breq);
 			tmp_close(mntdir);
 			xfd_close(&fsxfd);
 			fsrall_cleanup(1);
@@ -662,6 +684,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 	if (ret)
 		fsrprintf(_("%s: bulkstat: %s\n"), progname, strerror(ret));
 out0:
+	free(breq);
 	tmp_close(mntdir);
 	xfd_close(&fsxfd);
 	free(fshandlep);
diff --git a/io/open.c b/io/open.c
index 99ca0dd3..e1aac7d1 100644
--- a/io/open.c
+++ b/io/open.c
@@ -724,7 +724,6 @@ inode_f(
 	char			**argv)
 {
 	struct xfs_bstat	bstat;
-	uint32_t		count = 0;
 	uint64_t		result_ino = 0;
 	uint64_t		userino = NULLFSINO;
 	char			*p;
@@ -775,21 +774,31 @@ inode_f(
 		}
 	} else if (ret_next) {
 		struct xfs_fd	xfd = XFS_FD_INIT(file->fd);
+		struct xfs_bulkstat_req	*breq;
+
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
 
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index fa10f298..b4468243 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -3,10 +3,23 @@
  * Copyright (C) 2019 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
+#include <string.h>
+#include <strings.h>
 #include "xfs.h"
 #include "fsgeom.h"
 #include "bulkstat.h"
 
+/* Grab fs geometry needed to degrade to v1 bulkstat/inumbers ioctls. */
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
 /* Bulkstat a single inode.  Returns zero or a positive error code. */
 int
 xfrog_bulkstat_single(
@@ -29,29 +42,278 @@ xfrog_bulkstat_single(
 	return 0;
 }
 
-/* Bulkstat a bunch of inodes.  Returns zero or a positive error code. */
-int
-xfrog_bulkstat(
+/*
+ * Set up emulation of a v5 bulk request ioctl with a v1 bulk request ioctl.
+ * Returns 0 if the emulation should proceed; ECANCELED if there are no
+ * records; or a positive error code.
+ */
+static int
+xfrog_bulk_req_setup(
 	struct xfs_fd		*xfd,
-	uint64_t		*lastino,
-	uint32_t		icount,
-	struct xfs_bstat	*ubuffer,
-	uint32_t		*ocount)
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
+ * Convert records and free resources used to do a v1 emulation of v5 bulk
+ * request.
+ */
+static int
+xfrog_bulk_req_teardown(
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
+	xfrog_bstat_to_bulkstat(xfd, v5, v1);
+}
+
+/* Bulkstat a bunch of inodes using the v5 interface. */
+static int
+xfrog_bulkstat5(
+	struct xfs_fd		*xfd,
+	struct xfs_bulkstat_req	*req)
 {
-	struct xfs_fsop_bulkreq	bulkreq = {
-		.lastip		= (__u64 *)lastino,
-		.icount		= icount,
-		.ubuffer	= ubuffer,
-		.ocount		= (__s32 *)ocount,
-	};
 	int			ret;
 
-	ret = ioctl(xfd->fd, XFS_IOC_FSBULKSTAT, &bulkreq);
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
+	error = xfrog_bulk_req_setup(xfd, &req->hdr, &bulkreq,
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
+	return xfrog_bulk_req_teardown(xfd, &req->hdr, &bulkreq,
+			sizeof(struct xfs_bstat), xfrog_bstat_ino,
+			&req->bulkstat, sizeof(struct xfs_bulkstat),
+			xfrog_bstat_cvt, 1, error);
+}
+
+/* Bulkstat a bunch of inodes.  Returns zero or a positive error code. */
+int
+xfrog_bulkstat(
+	struct xfs_fd		*xfd,
+	struct xfs_bulkstat_req	*req)
+{
+	int			error;
+
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
+/* Convert bulkstat (v5) to bstat (v1). */
+void
+xfrog_bulkstat_to_bstat(
+	struct xfs_fd			*xfd,
+	struct xfs_bstat		*bs1,
+	const struct xfs_bulkstat	*bstat)
+{
+	bs1->bs_ino = bstat->bs_ino;
+	bs1->bs_mode = bstat->bs_mode;
+	bs1->bs_nlink = bstat->bs_nlink;
+	bs1->bs_uid = bstat->bs_uid;
+	bs1->bs_gid = bstat->bs_gid;
+	bs1->bs_rdev = bstat->bs_rdev;
+	bs1->bs_blksize = bstat->bs_blksize;
+	bs1->bs_size = bstat->bs_size;
+	bs1->bs_atime.tv_sec = bstat->bs_atime;
+	bs1->bs_mtime.tv_sec = bstat->bs_mtime;
+	bs1->bs_ctime.tv_sec = bstat->bs_ctime;
+	bs1->bs_atime.tv_nsec = bstat->bs_atime_nsec;
+	bs1->bs_mtime.tv_nsec = bstat->bs_mtime_nsec;
+	bs1->bs_ctime.tv_nsec = bstat->bs_ctime_nsec;
+	bs1->bs_blocks = bstat->bs_blocks;
+	bs1->bs_xflags = bstat->bs_xflags;
+	bs1->bs_extsize = cvt_off_fsb_to_b(xfd, bstat->bs_extsize_blks);
+	bs1->bs_extents = bstat->bs_extents;
+	bs1->bs_gen = bstat->bs_gen;
+	bs1->bs_projid_lo = bstat->bs_projectid & 0xFFFF;
+	bs1->bs_forkoff = bstat->bs_forkoff;
+	bs1->bs_projid_hi = bstat->bs_projectid >> 16;
+	bs1->bs_sick = bstat->bs_sick;
+	bs1->bs_checked = bstat->bs_checked;
+	bs1->bs_cowextsize = cvt_off_fsb_to_b(xfd, bstat->bs_cowextsize_blks);
+	bs1->bs_dmevmask = 0;
+	bs1->bs_dmstate = 0;
+	bs1->bs_aextents = bstat->bs_aextents;
+}
+
+/* Convert bstat (v1) to bulkstat (v5). */
+void
+xfrog_bstat_to_bulkstat(
+	struct xfs_fd			*xfd,
+	struct xfs_bulkstat		*bstat,
+	const struct xfs_bstat		*bs1)
+{
+	memset(bstat, 0, sizeof(*bstat));
+	bstat->bs_version = XFS_BULKSTAT_VERSION_V1;
+
+	bstat->bs_ino = bs1->bs_ino;
+	bstat->bs_mode = bs1->bs_mode;
+	bstat->bs_nlink = bs1->bs_nlink;
+	bstat->bs_uid = bs1->bs_uid;
+	bstat->bs_gid = bs1->bs_gid;
+	bstat->bs_rdev = bs1->bs_rdev;
+	bstat->bs_blksize = bs1->bs_blksize;
+	bstat->bs_size = bs1->bs_size;
+	bstat->bs_atime = bs1->bs_atime.tv_sec;
+	bstat->bs_mtime = bs1->bs_mtime.tv_sec;
+	bstat->bs_ctime = bs1->bs_ctime.tv_sec;
+	bstat->bs_atime_nsec = bs1->bs_atime.tv_nsec;
+	bstat->bs_mtime_nsec = bs1->bs_mtime.tv_nsec;
+	bstat->bs_ctime_nsec = bs1->bs_ctime.tv_nsec;
+	bstat->bs_blocks = bs1->bs_blocks;
+	bstat->bs_xflags = bs1->bs_xflags;
+	bstat->bs_extsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_extsize);
+	bstat->bs_extents = bs1->bs_extents;
+	bstat->bs_gen = bs1->bs_gen;
+	bstat->bs_projectid = bstat_get_projid(bs1);
+	bstat->bs_forkoff = bs1->bs_forkoff;
+	bstat->bs_sick = bs1->bs_sick;
+	bstat->bs_checked = bs1->bs_checked;
+	bstat->bs_cowextsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_cowextsize);
+	bstat->bs_aextents = bs1->bs_aextents;
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
index 83ac0e37..6f51c167 100644
--- a/libfrog/bulkstat.h
+++ b/libfrog/bulkstat.h
@@ -10,8 +10,14 @@
 struct xfs_bstat;
 int xfrog_bulkstat_single(struct xfs_fd *xfd, uint64_t ino,
 		struct xfs_bstat *ubuffer);
-int xfrog_bulkstat(struct xfs_fd *xfd, uint64_t *lastino, uint32_t icount,
-		struct xfs_bstat *ubuffer, uint32_t *ocount);
+int xfrog_bulkstat(struct xfs_fd *xfd, struct xfs_bulkstat_req *req);
+
+struct xfs_bulkstat_req *xfrog_bulkstat_alloc_req(uint32_t nr,
+		uint64_t startino);
+void xfrog_bulkstat_to_bstat(struct xfs_fd *xfd, struct xfs_bstat *bs1,
+		const struct xfs_bulkstat *bstat);
+void xfrog_bstat_to_bulkstat(struct xfs_fd *xfd, struct xfs_bulkstat *bstat,
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
index 580a845e..851c24bd 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -50,13 +50,15 @@ static void
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
 
 	for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
+		struct xfs_bstat bs1;
+
 		if (!(inogrp->xi_allocmask & (1ULL << i)))
 			continue;
 		if (bs->bs_ino == inogrp->xi_startino + i) {
@@ -66,11 +68,13 @@ xfs_iterate_inodes_range_check(
 
 		/* Load the one inode. */
 		error = xfrog_bulkstat_single(&ctx->mnt,
-				inogrp->xi_startino + i, bs);
-		if (error || bs->bs_ino != inogrp->xi_startino + i) {
-			memset(bs, 0, sizeof(struct xfs_bstat));
+				inogrp->xi_startino + i, &bs1);
+		if (error || bs1.bs_ino != inogrp->xi_startino + i) {
+			memset(bs, 0, sizeof(struct xfs_bulkstat));
 			bs->bs_ino = inogrp->xi_startino + i;
 			bs->bs_blksize = ctx->mnt_sv.f_frsize;
+		} else {
+			xfrog_bstat_to_bulkstat(&ctx->mnt, bs, &bs1);
 		}
 		bs++;
 	}
@@ -93,41 +97,41 @@ xfs_iterate_inodes_range(
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
 
@@ -135,10 +139,12 @@ xfs_iterate_inodes_range(
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
 
@@ -184,6 +190,7 @@ _("Changed too many times during scan; giving up."));
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
index c3575b8e..9bed7fdf 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
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
 
@@ -279,15 +278,23 @@ report_bulkstat_health(
 		lastino = cvt_agino_to_ino(&file->xfd, agno + 1, 0) - 1;
 	}
 
-	while ((error = xfrog_bulkstat(&file->xfd, &startino, BULKSTAT_NR,
-			bstat, &ocount) == 0) && ocount > 0) {
-		for (i = 0; i < ocount; i++) {
-			if (bstat[i].bs_ino > lastino)
+	breq = xfrog_bulkstat_alloc_req(BULKSTAT_NR, startino);
+	if (!breq) {
+		perror("bulk alloc req");
+		exitcode = 1;
+		return 1;
+	}
+
+	while ((error = xfrog_bulkstat(&file->xfd, breq) == 0) &&
+			breq->hdr.ocount > 0) {
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
 	}
 	if (error) {
@@ -295,6 +302,7 @@ report_bulkstat_health(
 		perror("bulkstat");
 	}
 out:
+	free(breq);
 	return error;
 }
 

