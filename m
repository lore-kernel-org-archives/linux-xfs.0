Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8FAC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F11621D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:32:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TXg4ou0V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfIYVc5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:32:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56806 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfIYVc5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:32:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTFuU050675;
        Wed, 25 Sep 2019 21:32:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=8s8Tf+MO3Wuz/t5V9ix08OUgw0+xyP1aqIOziCd+00E=;
 b=TXg4ou0VGlrpfC2j2C4o1rzehAcqf+WXiQ8D64Lq8pyPdTokCBADPpQqxEhFzPWcw6DZ
 I0y9gDDfjP5k5YyjEPxb4WmMFoZG2/U8B2F1x3+Z8rQIQ8altD4nMPjI2wG8LP94YNZi
 1b4q4C0F+uWE/aPPiprU7l1CJSmrf2u3aCLY8Iv8WbsKOv+qphwY9Pg7kuyUuhvxiyix
 VPC6dkYP83RKptpwVq6h9BGVY46ylBBXv3LohJKt7/N5GFKKnDGgnjTs55FegqJhAs0O
 JDnXaZWh7XSVJ438L9rvQn2V9liX+fzrfBJ8ffbgX+eaMf3uPTzqUE86y+14ozRCDLND lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v5cgr7emb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:32:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTDcM085223;
        Wed, 25 Sep 2019 21:32:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v82qakq3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:32:54 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLWrsj014160;
        Wed, 25 Sep 2019 21:32:53 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:32:52 -0700
Subject: [PATCH 4/4] misc: convert from XFS_IOC_FSINUMBERS to
 XFS_IOC_INUMBERS
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:32:51 -0700
Message-ID: <156944717162.297379.1042436133617221738.stgit@magnolia>
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
 engine=8.0.1-1908290000 definitions=main-1909250173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert all programs to use the v5 inumbers ioctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/imap.c          |   26 +++++-----
 io/open.c          |   34 ++++++++-----
 libfrog/bulkstat.c |  132 ++++++++++++++++++++++++++++++++++++++++++++++------
 libfrog/bulkstat.h |   10 +++-
 scrub/fscounters.c |   21 +++++---
 scrub/inodes.c     |   46 ++++++++++--------
 6 files changed, 198 insertions(+), 71 deletions(-)


diff --git a/io/imap.c b/io/imap.c
index 472c1fda..fa69676e 100644
--- a/io/imap.c
+++ b/io/imap.c
@@ -17,9 +17,7 @@ static int
 imap_f(int argc, char **argv)
 {
 	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
-	struct xfs_inogrp	*t;
-	uint64_t		last = 0;
-	uint32_t		count;
+	struct xfs_inumbers_req	*ireq;
 	uint32_t		nent;
 	int			i;
 	int			error;
@@ -29,17 +27,19 @@ imap_f(int argc, char **argv)
 	else
 		nent = atoi(argv[1]);
 
-	t = malloc(nent * sizeof(*t));
-	if (!t)
+	ireq = xfrog_inumbers_alloc_req(nent, 0);
+	if (!ireq) {
+		perror("alloc req");
 		return 0;
+	}
 
-	while ((error = xfrog_inumbers(&xfd, &last, nent, t, &count)) == 0 &&
-	       count > 0) {
-		for (i = 0; i < count; i++) {
-			printf(_("ino %10llu count %2d mask %016llx\n"),
-				(unsigned long long)t[i].xi_startino,
-				t[i].xi_alloccount,
-				(unsigned long long)t[i].xi_allocmask);
+	while ((error = xfrog_inumbers(&xfd, ireq)) == 0 &&
+	       ireq->hdr.ocount > 0) {
+		for (i = 0; i < ireq->hdr.ocount; i++) {
+			printf(_("ino %10"PRIu64" count %2d mask %016"PRIx64"\n"),
+				ireq->inumbers[i].xi_startino,
+				ireq->inumbers[i].xi_alloccount,
+				ireq->inumbers[i].xi_allocmask);
 		}
 	}
 
@@ -48,7 +48,7 @@ imap_f(int argc, char **argv)
 		perror("xfsctl(XFS_IOC_FSINUMBERS)");
 		exitcode = 1;
 	}
-	free(t);
+	free(ireq);
 	return 0;
 }
 
diff --git a/io/open.c b/io/open.c
index e0e7fb3e..3c6113a1 100644
--- a/io/open.c
+++ b/io/open.c
@@ -681,39 +681,47 @@ static __u64
 get_last_inode(void)
 {
 	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
-	uint64_t		lastip = 0;
+	struct xfs_inumbers_req	*ireq;
 	uint32_t		lastgrp = 0;
-	uint32_t		ocount = 0;
-	__u64			last_ino;
-	struct xfs_inogrp	igroup[IGROUP_NR];
+	__u64			last_ino = 0;
+
+	ireq = xfrog_inumbers_alloc_req(IGROUP_NR, 0);
+	if (!ireq) {
+		perror("alloc req");
+		return 0;
+	}
 
 	for (;;) {
 		int		ret;
 
-		ret = xfrog_inumbers(&xfd, &lastip, IGROUP_NR, igroup,
-				&ocount);
+		ret = xfrog_inumbers(&xfd, ireq);
 		if (ret) {
 			errno = ret;
 			perror("XFS_IOC_FSINUMBERS");
-			return 0;
+			free(ireq);
+			goto out;
 		}
 
 		/* Did we reach the last inode? */
-		if (ocount == 0)
+		if (ireq->hdr.ocount == 0)
 			break;
 
 		/* last inode in igroup table */
-		lastgrp = ocount;
+		lastgrp = ireq->hdr.ocount;
 	}
 
-	if (lastgrp == 0)
-		return 0;
+	if (lastgrp == 0) {
+		free(ireq);
+		goto out;
+	}
 
 	lastgrp--;
 
 	/* The last inode number in use */
-	last_ino = igroup[lastgrp].xi_startino +
-		  libxfs_highbit64(igroup[lastgrp].xi_allocmask);
+	last_ino = ireq->inumbers[lastgrp].xi_startino +
+		  libxfs_highbit64(ireq->inumbers[lastgrp].xi_allocmask);
+out:
+	free(ireq);
 
 	return last_ino;
 }
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 300963f1..85594e5e 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -435,6 +435,86 @@ xfrog_bulkstat_alloc_req(
 	return breq;
 }
 
+/* Convert a inumbers data from v5 format to v1 format. */
+void
+xfrog_inumbers_v5_to_v1(
+	struct xfs_inogrp		*ig1,
+	const struct xfs_inumbers	*ig5)
+{
+	ig1->xi_startino = ig5->xi_startino;
+	ig1->xi_alloccount = ig5->xi_alloccount;
+	ig1->xi_allocmask = ig5->xi_allocmask;
+}
+
+/* Convert a inumbers data from v1 format to v5 format. */
+void
+xfrog_inumbers_v1_to_v5(
+	struct xfs_inumbers		*ig5,
+	const struct xfs_inogrp		*ig1)
+{
+	memset(ig5, 0, sizeof(*ig5));
+	ig5->xi_version = XFS_INUMBERS_VERSION_V1;
+
+	ig5->xi_startino = ig1->xi_startino;
+	ig5->xi_alloccount = ig1->xi_alloccount;
+	ig5->xi_allocmask = ig1->xi_allocmask;
+}
+
+static uint64_t xfrog_inum_ino(void *v1_rec)
+{
+	return ((struct xfs_inogrp *)v1_rec)->xi_startino;
+}
+
+static void xfrog_inum_cvt(struct xfs_fd *xfd, void *v5, void *v1)
+{
+	xfrog_inumbers_v1_to_v5(v5, v1);
+}
+
+/* Query inode allocation bitmask information using v5 ioctl. */
+static int
+xfrog_inumbers5(
+	struct xfs_fd		*xfd,
+	struct xfs_inumbers_req	*req)
+{
+	int			ret;
+
+	ret = ioctl(xfd->fd, XFS_IOC_INUMBERS, req);
+	if (ret)
+		return errno;
+	return 0;
+}
+
+/* Query inode allocation bitmask information using v1 ioctl. */
+static int
+xfrog_inumbers1(
+	struct xfs_fd		*xfd,
+	struct xfs_inumbers_req	*req)
+{
+	struct xfs_fsop_bulkreq	bulkreq = { 0 };
+	int			error;
+
+	error = xfrog_bulkstat_prep_v1_emulation(xfd);
+	if (error)
+		return error;
+
+	error = xfrog_bulk_req_v1_setup(xfd, &req->hdr, &bulkreq,
+			sizeof(struct xfs_inogrp));
+	if (error == ECANCELED)
+		goto out_teardown;
+	if (error)
+		return error;
+
+	error = ioctl(xfd->fd, XFS_IOC_FSINUMBERS, &bulkreq);
+	if (error)
+		error = errno;
+
+out_teardown:
+	return xfrog_bulk_req_v1_cleanup(xfd, &req->hdr, &bulkreq,
+			sizeof(struct xfs_inogrp), xfrog_inum_ino,
+			&req->inumbers, sizeof(struct xfs_inumbers),
+			xfrog_inum_cvt, 64, error);
+}
+
 /*
  * Query inode allocation bitmask information.  Returns zero or a positive
  * error code.
@@ -442,21 +522,43 @@ xfrog_bulkstat_alloc_req(
 int
 xfrog_inumbers(
 	struct xfs_fd		*xfd,
-	uint64_t		*lastino,
-	uint32_t		icount,
-	struct xfs_inogrp	*ubuffer,
-	uint32_t		*ocount)
+	struct xfs_inumbers_req	*req)
 {
-	struct xfs_fsop_bulkreq	bulkreq = {
-		.lastip		= (__u64 *)lastino,
-		.icount		= icount,
-		.ubuffer	= ubuffer,
-		.ocount		= (__s32 *)ocount,
-	};
-	int			ret;
+	int			error;
 
-	ret = ioctl(xfd->fd, XFS_IOC_FSINUMBERS, &bulkreq);
-	if (ret)
-		return errno;
-	return 0;
+	if (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V1)
+		goto try_v1;
+
+	error = xfrog_inumbers5(xfd, req);
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
+	return xfrog_inumbers1(xfd, req);
+}
+
+/* Allocate a inumbers request.  On error returns NULL and sets errno. */
+struct xfs_inumbers_req *
+xfrog_inumbers_alloc_req(
+	uint32_t		nr,
+	uint64_t		startino)
+{
+	struct xfs_inumbers_req	*ireq;
+
+	ireq = calloc(1, XFS_INUMBERS_REQ_SIZE(nr));
+	if (!ireq)
+		return NULL;
+
+	ireq->hdr.icount = nr;
+	ireq->hdr.ino = startino;
+
+	return ireq;
 }
diff --git a/libfrog/bulkstat.h b/libfrog/bulkstat.h
index bbbc69a2..a085da3d 100644
--- a/libfrog/bulkstat.h
+++ b/libfrog/bulkstat.h
@@ -20,7 +20,13 @@ void xfrog_bulkstat_v1_to_v5(struct xfs_fd *xfd, struct xfs_bulkstat *bstat,
 		const struct xfs_bstat *bs1);
 
 struct xfs_inogrp;
-int xfrog_inumbers(struct xfs_fd *xfd, uint64_t *lastino, uint32_t icount,
-		struct xfs_inogrp *ubuffer, uint32_t *ocount);
+int xfrog_inumbers(struct xfs_fd *xfd, struct xfs_inumbers_req *req);
+
+struct xfs_inumbers_req *xfrog_inumbers_alloc_req(uint32_t nr,
+		uint64_t startino);
+void xfrog_inumbers_v5_to_v1(struct xfs_inogrp *ig1,
+		const struct xfs_inumbers *ig);
+void xfrog_inumbers_v1_to_v5(struct xfs_inumbers *ig,
+		const struct xfs_inogrp *ig1);
 
 #endif	/* __LIBFROG_BULKSTAT_H__ */
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 8e4b3467..2fdf658a 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -42,23 +42,28 @@ xfs_count_inodes_range(
 	uint64_t		last_ino,
 	uint64_t		*count)
 {
-	struct xfs_inogrp	inogrp;
-	uint64_t		igrp_ino;
+	struct xfs_inumbers_req	*ireq;
 	uint64_t		nr = 0;
-	uint32_t		igrplen = 0;
 	int			error;
 
 	ASSERT(!(first_ino & (XFS_INODES_PER_CHUNK - 1)));
 	ASSERT((last_ino & (XFS_INODES_PER_CHUNK - 1)));
 
-	igrp_ino = first_ino;
-	while (!(error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp,
-			&igrplen))) {
-		if (igrplen == 0 || inogrp.xi_startino >= last_ino)
+	ireq = xfrog_inumbers_alloc_req(1, first_ino);
+	if (!ireq) {
+		str_info(ctx, descr, _("Insufficient memory; giving up."));
+		return false;
+	}
+
+	while (!(error = xfrog_inumbers(&ctx->mnt, ireq))) {
+		if (ireq->hdr.ocount == 0 ||
+		    ireq->inumbers[0].xi_startino >= last_ino)
 			break;
-		nr += inogrp.xi_alloccount;
+		nr += ireq->inumbers[0].xi_alloccount;
 	}
 
+	free(ireq);
+
 	if (error) {
 		str_liberror(ctx, error, descr);
 		return false;
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 2112c9d1..964647ce 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -49,7 +49,7 @@
 static void
 xfs_iterate_inodes_range_check(
 	struct scrub_ctx	*ctx,
-	struct xfs_inogrp	*inogrp,
+	struct xfs_inumbers	*inumbers,
 	struct xfs_bulkstat	*bstat)
 {
 	struct xfs_bulkstat	*bs;
@@ -57,19 +57,19 @@ xfs_iterate_inodes_range_check(
 	int			error;
 
 	for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
-		if (!(inogrp->xi_allocmask & (1ULL << i)))
+		if (!(inumbers->xi_allocmask & (1ULL << i)))
 			continue;
-		if (bs->bs_ino == inogrp->xi_startino + i) {
+		if (bs->bs_ino == inumbers->xi_startino + i) {
 			bs++;
 			continue;
 		}
 
 		/* Load the one inode. */
 		error = xfrog_bulkstat_single(&ctx->mnt,
-				inogrp->xi_startino + i, 0, bs);
-		if (error || bs->bs_ino != inogrp->xi_startino + i) {
+				inumbers->xi_startino + i, 0, bs);
+		if (error || bs->bs_ino != inumbers->xi_startino + i) {
 			memset(bs, 0, sizeof(struct xfs_bulkstat));
-			bs->bs_ino = inogrp->xi_startino + i;
+			bs->bs_ino = inumbers->xi_startino + i;
 			bs->bs_blksize = ctx->mnt_sv.f_frsize;
 		}
 		bs++;
@@ -92,12 +92,11 @@ xfs_iterate_inodes_range(
 	void			*arg)
 {
 	struct xfs_handle	handle;
-	struct xfs_inogrp	inogrp;
+	struct xfs_inumbers_req	*ireq;
 	struct xfs_bulkstat_req	*breq;
 	char			idescr[DESCR_BUFSZ];
 	struct xfs_bulkstat	*bs;
-	uint64_t		igrp_ino;
-	uint32_t		igrplen = 0;
+	struct xfs_inumbers	*inumbers;
 	bool			moveon = true;
 	int			i;
 	int			error;
@@ -114,19 +113,26 @@ xfs_iterate_inodes_range(
 		return false;
 	}
 
+	ireq = xfrog_inumbers_alloc_req(1, first_ino);
+	if (!ireq) {
+		str_info(ctx, descr, _("Insufficient memory; giving up."));
+		free(breq);
+		return false;
+	}
+	inumbers = &ireq->inumbers[0];
+
 	/* Find the inode chunk & alloc mask */
-	igrp_ino = first_ino;
-	error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp, &igrplen);
-	while (!error && igrplen) {
+	error = xfrog_inumbers(&ctx->mnt, ireq);
+	while (!error && ireq->hdr.ocount > 0) {
 		/*
 		 * We can have totally empty inode chunks on filesystems where
 		 * there are more than 64 inodes per block.  Skip these.
 		 */
-		if (inogrp.xi_alloccount == 0)
+		if (inumbers->xi_alloccount == 0)
 			goto igrp_retry;
 
-		breq->hdr.ino = inogrp.xi_startino;
-		breq->hdr.icount = inogrp.xi_alloccount;
+		breq->hdr.ino = inumbers->xi_startino;
+		breq->hdr.icount = inumbers->xi_alloccount;
 		error = xfrog_bulkstat(&ctx->mnt, breq);
 		if (error) {
 			char	errbuf[DESCR_BUFSZ];
@@ -135,11 +141,11 @@ xfs_iterate_inodes_range(
 						errbuf, DESCR_BUFSZ));
 		}
 
-		xfs_iterate_inodes_range_check(ctx, &inogrp, breq->bulkstat);
+		xfs_iterate_inodes_range_check(ctx, inumbers, breq->bulkstat);
 
 		/* Iterate all the inodes. */
 		for (i = 0, bs = breq->bulkstat;
-		     i < inogrp.xi_alloccount;
+		     i < inumbers->xi_alloccount;
 		     i++, bs++) {
 			if (bs->bs_ino > last_ino)
 				goto out;
@@ -153,7 +159,7 @@ xfs_iterate_inodes_range(
 			case ESTALE:
 				stale_count++;
 				if (stale_count < 30) {
-					igrp_ino = inogrp.xi_startino;
+					ireq->hdr.ino = inumbers->xi_startino;
 					goto igrp_retry;
 				}
 				snprintf(idescr, DESCR_BUFSZ, "inode %"PRIu64,
@@ -177,8 +183,7 @@ _("Changed too many times during scan; giving up."));
 
 		stale_count = 0;
 igrp_retry:
-		error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp,
-				&igrplen);
+		error = xfrog_inumbers(&ctx->mnt, ireq);
 	}
 
 err:
@@ -186,6 +191,7 @@ _("Changed too many times during scan; giving up."));
 		str_liberror(ctx, error, descr);
 		moveon = false;
 	}
+	free(ireq);
 	free(breq);
 out:
 	return moveon;

