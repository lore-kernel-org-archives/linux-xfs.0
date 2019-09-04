Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C679C3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7D912339E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:39:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KhPDd2+a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfIDEjR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:39:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54694 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfIDEjR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:39:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844cSLk028124;
        Wed, 4 Sep 2019 04:39:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4oZPO6/jxQvB8/yNw5t/JiS4Xh9Eb7BwwX/mb5JIQ20=;
 b=KhPDd2+aApPscQYd6rrPcCmKdO74I1arIdgU80a923wRkTREqVoHedko1zDnD+zsbQSC
 /tm99GvCgYdrS+hm6JNwZ1kGv84uF/g+bVfr8gRDKd9m8WT0CsvybxWpL5HSn9vw8i6x
 QQvdyhTifCJkzgv4IWJkCGxjRB1f+eRiqXApX9psgyPHnm9IjjLbuZ666ImJlB6BQgPd
 Gl/Kleoo0fziWTS0Kr62IOEF65plS12gLpOqXEpl78FeadQOFJZFiPttuOIurjMRale6
 1ZH5TKqXtLgB8FrbpoWlkDl/GCqoF328SMCnFXryZUcNFrjK3Hy6LVvYxi5k/G2xu0b8 Qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ut6ds006y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:39:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844cbNR035923;
        Wed, 4 Sep 2019 04:39:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2usu51c6fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:39:14 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x844cmMt031780;
        Wed, 4 Sep 2019 04:38:48 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:38:48 -0700
Subject: [PATCH 4/4] xfs_spaceman: convert open-coded unit conversions to
 helpers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:38:47 -0700
Message-ID: <156757192700.1838733.16850596931923084140.stgit@magnolia>
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
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create xfrog analogues of the libxfs byte/sector/block conversion
functions and convert spaceman to use them instead of open-coded
arithmatic we do now.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/fsgeom.c  |    1 +
 libfrog/fsgeom.h  |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/freesp.c |   15 +++------
 spaceman/trim.c   |    9 +++---
 4 files changed, 96 insertions(+), 14 deletions(-)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index bc872834..631286cd 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -113,6 +113,7 @@ xfd_prepare_geometry(
 	xfd->inodelog = highbit32(xfd->fsgeom.inodesize);
 	xfd->inopblog = xfd->blocklog - xfd->inodelog;
 	xfd->aginolog = xfd->agblklog + xfd->inopblog;
+	xfd->blkbb_log = xfd->blocklog - BBSHIFT;
 	return 0;
 }
 
diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index 6993dafb..5dcfc1bb 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -35,6 +35,9 @@ struct xfs_fd {
 
 	/* bits for agino in inum */
 	unsigned int		aginolog;
+
+	/* log2 of sb_blocksize / sb_sectsize */
+	unsigned int		blkbb_log;
 };
 
 /* Static initializers */
@@ -99,4 +102,86 @@ cvt_b_to_off_fsbt(
 	return bytes >> xfd->blocklog;
 }
 
+/* Convert sector number to bytes. */
+static inline uint64_t
+cvt_bbtob(
+	uint64_t		daddr)
+{
+	return daddr << BBSHIFT;
+}
+
+/* Convert bytes to sector number, rounding down. */
+static inline uint64_t
+cvt_btobbt(
+	uint64_t		bytes)
+{
+	return bytes >> BBSHIFT;
+}
+
+/* Convert fs block number to sector number. */
+static inline uint64_t
+cvt_off_fsb_to_bb(
+	struct xfs_fd		*xfd,
+	uint64_t		fsbno)
+{
+	return fsbno << xfd->blkbb_log;
+}
+
+/* Convert sector number to fs block number, rounded down. */
+static inline uint64_t
+cvt_bb_to_off_fsbt(
+	struct xfs_fd		*xfd,
+	uint64_t		daddr)
+{
+	return daddr >> xfd->blkbb_log;
+}
+
+/* Convert AG number and AG block to fs block number */
+static inline uint64_t
+cvt_agb_to_daddr(
+	struct xfs_fd		*xfd,
+	uint32_t		agno,
+	uint32_t		agbno)
+{
+	return cvt_off_fsb_to_bb(xfd,
+			(uint64_t)agno * xfd->fsgeom.agblocks + agbno);
+}
+
+/* Convert sector number to AG number. */
+static inline uint32_t
+cvt_daddr_to_agno(
+	struct xfs_fd		*xfd,
+	uint64_t		daddr)
+{
+	return cvt_bb_to_off_fsbt(xfd, daddr) / xfd->fsgeom.agblocks;
+}
+
+/* Convert sector number to AG block number. */
+static inline uint32_t
+cvt_daddr_to_agbno(
+	struct xfs_fd		*xfd,
+	uint64_t		daddr)
+{
+	return cvt_bb_to_off_fsbt(xfd, daddr) % xfd->fsgeom.agblocks;
+}
+
+/* Convert AG number and AG block to a byte location on disk. */
+static inline uint64_t
+cvt_agbno_to_b(
+	struct xfs_fd		*xfd,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno)
+{
+	return cvt_bbtob(cvt_agb_to_daddr(xfd, agno, agbno));
+}
+
+/* Convert byte location on disk to AG block. */
+static inline xfs_agblock_t
+cvt_b_to_agbno(
+	struct xfs_fd		*xfd,
+	uint64_t		byteno)
+{
+	return cvt_daddr_to_agbno(xfd, cvt_btobbt(byteno));
+}
+
 #endif /* __LIBFROG_FSGEOM_H__ */
diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index f30171f0..92cdb743 100644
--- a/spaceman/freesp.c
+++ b/spaceman/freesp.c
@@ -150,9 +150,7 @@ scan_ag(
 	struct fsmap		*extent;
 	struct fsmap		*l, *h;
 	struct fsmap		*p;
-	struct xfs_fsop_geom	*fsgeom = &file->xfd.fsgeom;
-	off64_t			blocksize = fsgeom->blocksize;
-	off64_t			bperag;
+	struct xfs_fd		*xfd = &file->xfd;
 	off64_t			aglen;
 	xfs_agblock_t		agbno;
 	unsigned long long	freeblks = 0;
@@ -160,8 +158,6 @@ scan_ag(
 	int			ret;
 	int			i;
 
-	bperag = (off64_t)fsgeom->agblocks * blocksize;
-
 	fsmap = malloc(fsmap_sizeof(NR_EXTENTS));
 	if (!fsmap) {
 		fprintf(stderr, _("%s: fsmap malloc failed.\n"), progname);
@@ -174,8 +170,8 @@ scan_ag(
 	l = fsmap->fmh_keys;
 	h = fsmap->fmh_keys + 1;
 	if (agno != NULLAGNUMBER) {
-		l->fmr_physical = agno * bperag;
-		h->fmr_physical = ((agno + 1) * bperag) - 1;
+		l->fmr_physical = cvt_agbno_to_b(xfd, agno, 0);
+		h->fmr_physical = cvt_agbno_to_b(xfd, agno + 1, 0);
 		l->fmr_device = h->fmr_device = file->fs_path.fs_datadev;
 	} else {
 		l->fmr_physical = 0;
@@ -206,9 +202,8 @@ scan_ag(
 			if (!(extent->fmr_flags & FMR_OF_SPECIAL_OWNER) ||
 			    extent->fmr_owner != XFS_FMR_OWN_FREE)
 				continue;
-			agbno = (extent->fmr_physical - (bperag * agno)) /
-								blocksize;
-			aglen = extent->fmr_length / blocksize;
+			agbno = cvt_b_to_agbno(xfd, extent->fmr_physical);
+			aglen = cvt_b_to_off_fsbt(xfd, extent->fmr_length);
 			freeblks += aglen;
 			freeexts++;
 
diff --git a/spaceman/trim.c b/spaceman/trim.c
index daf4e427..e9ed47e4 100644
--- a/spaceman/trim.c
+++ b/spaceman/trim.c
@@ -23,7 +23,8 @@ trim_f(
 	char			**argv)
 {
 	struct fstrim_range	trim = {0};
-	struct xfs_fsop_geom	*fsgeom = &file->xfd.fsgeom;
+	struct xfs_fd		*xfd = &file->xfd;
+	struct xfs_fsop_geom	*fsgeom = &xfd->fsgeom;
 	xfs_agnumber_t		agno = 0;
 	off64_t			offset = 0;
 	ssize_t			length = 0;
@@ -66,11 +67,11 @@ trim_f(
 		length = cvtnum(fsgeom->blocksize, fsgeom->sectsize,
 				argv[optind + 1]);
 	} else if (agno) {
-		offset = (off64_t)agno * fsgeom->agblocks * fsgeom->blocksize;
-		length = fsgeom->agblocks * fsgeom->blocksize;
+		offset = cvt_agbno_to_b(xfd, agno, 0);
+		length = cvt_off_fsb_to_b(xfd, fsgeom->agblocks);
 	} else {
 		offset = 0;
-		length = fsgeom->datablocks * fsgeom->blocksize;
+		length = cvt_off_fsb_to_b(xfd, fsgeom->datablocks);
 	}
 
 	trim.start = offset;

