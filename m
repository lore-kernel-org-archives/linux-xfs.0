Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DD0C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8608321881
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:20:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b3wtM3/Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfHZVUu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:20:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41870 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbfHZVUt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:20:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDmlq188911;
        Mon, 26 Aug 2019 21:20:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=pK1jvAL/ijjPhn3AFAQAQdQZdxNJ38rMsR/Tpt/WxlY=;
 b=b3wtM3/ZQtwEX4ugfOSD6fh21JG3amzICnkoRisPOag0ZN1UV9GcuQ0zSbJ6Uw50QCRx
 xTU9H9FUcZ1KERHdOefYg44L2jGRwyS/Qb4NOdsNtc+MV9Lo9Hxl5Geh3P+gH8vGkz3F
 1DZzaStfURvMDxlEWYwhmwmxylTqfOZi7XXfbmolxF5ibah9RXCs/pEbf11LiHSK6vD8
 r40cC1qBF28+nKD36xANMyufexZw/RedAGqdTK/EOUBFFAUKZDmxCREH7R9ouzQxsMtU
 nEQmTOQ+j3vrJE/xvWmInd2bENaVYxmcAiWt6+6k7JmQEGs2zkm6qVkurHOR1tL3air7 Ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ujwvqc4em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:20:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIsSo184966;
        Mon, 26 Aug 2019 21:20:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2umj2xvqnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:20:46 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLKkc8001325;
        Mon, 26 Aug 2019 21:20:46 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:20:46 -0700
Subject: [PATCH 4/4] xfs_spaceman: convert open-coded unit conversions to
 helpers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:20:45 -0700
Message-ID: <156685444520.2839773.6764652190281485485.stgit@magnolia>
In-Reply-To: <156685442011.2839773.2684103942714886186.stgit@magnolia>
References: <156685442011.2839773.2684103942714886186.stgit@magnolia>
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

Create xfrog analogues of the libxfs byte/sector/block conversion
functions and convert spaceman to use them instead of open-coded
arithmatic we do now.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfrog.h   |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/fsgeom.c  |    1 +
 spaceman/freesp.c |   18 ++++++--------
 spaceman/trim.c   |    9 ++++---
 4 files changed, 80 insertions(+), 14 deletions(-)


diff --git a/include/xfrog.h b/include/xfrog.h
index 6b605dcf..5748e967 100644
--- a/include/xfrog.h
+++ b/include/xfrog.h
@@ -45,6 +45,9 @@ struct xfs_fd {
 
 	/* bits for agino in inum */
 	unsigned int		aginolog;
+
+	/* log2 of sb_blocksize / sb_sectsize */
+	unsigned int		blkbb_log;
 };
 
 /* Static initializers */
@@ -100,6 +103,69 @@ xfrog_b_to_fsbt(
 	return bytes >> xfd->blocklog;
 }
 
+/* Convert sector number to bytes. */
+static inline uint64_t
+xfrog_bbtob(
+	uint64_t		daddr)
+{
+	return daddr << BBSHIFT;
+}
+
+/* Convert bytes to sector number, rounding down. */
+static inline uint64_t
+xfrog_btobbt(
+	uint64_t		bytes)
+{
+	return bytes >> BBSHIFT;
+}
+
+/* Convert fs block number to sector number. */
+static inline uint64_t
+xfrog_fsb_to_bb(
+	struct xfs_fd		*xfd,
+	uint64_t		fsbno)
+{
+	return fsbno << xfd->blkbb_log;
+}
+
+/* Convert sector number to fs block number, rounded down. */
+static inline uint64_t
+xfrog_bb_to_fsbt(
+	struct xfs_fd		*xfd,
+	uint64_t		daddr)
+{
+	return daddr >> xfd->blkbb_log;
+}
+
+/* Convert AG number and AG block to fs block number */
+static inline uint64_t
+xfrog_agb_to_daddr(
+	struct xfs_fd		*xfd,
+	uint32_t		agno,
+	uint32_t		agbno)
+{
+	return xfrog_fsb_to_bb(xfd,
+			(uint64_t)agno * xfd->fsgeom.agblocks + agbno);
+}
+
+/* Convert sector number to AG number. */
+static inline uint32_t
+xfrog_daddr_to_agno(
+	struct xfs_fd		*xfd,
+	uint64_t		daddr)
+{
+	return xfrog_bb_to_fsbt(xfd, daddr) / xfd->fsgeom.agblocks;
+}
+
+/* Convert sector number to AG block number. */
+static inline uint32_t
+xfrog_daddr_to_agbno(
+	struct xfs_fd		*xfd,
+	uint64_t		daddr)
+{
+	return xfrog_bb_to_fsbt(xfd, daddr) % xfd->fsgeom.agblocks;
+}
+
 /* Bulkstat wrappers */
 struct xfs_bstat;
 int xfrog_bulkstat_single(struct xfs_fd *xfd, uint64_t ino,
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 159738c5..17479e4a 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -114,6 +114,7 @@ xfrog_prepare_geometry(
 	xfd->inodelog = highbit32(xfd->fsgeom.inodesize);
 	xfd->inopblog = xfd->blocklog - xfd->inodelog;
 	xfd->aginolog = xfd->agblklog + xfd->inopblog;
+	xfd->blkbb_log = xfd->blocklog - BBSHIFT;
 	return 0;
 }
 
diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index 83cbecbd..9e9f32a2 100644
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
@@ -174,8 +170,10 @@ scan_ag(
 	l = fsmap->fmh_keys;
 	h = fsmap->fmh_keys + 1;
 	if (agno != NULLAGNUMBER) {
-		l->fmr_physical = agno * bperag;
-		h->fmr_physical = ((agno + 1) * bperag) - 1;
+		l->fmr_physical = xfrog_bbtob(
+				xfrog_agb_to_daddr(xfd, agno, 0));
+		h->fmr_physical = xfrog_bbtob(
+				xfrog_agb_to_daddr(xfd, agno + 1, 0));
 		l->fmr_device = h->fmr_device = file->fs_path.fs_datadev;
 	} else {
 		l->fmr_physical = 0;
@@ -206,9 +204,9 @@ scan_ag(
 			if (!(extent->fmr_flags & FMR_OF_SPECIAL_OWNER) ||
 			    extent->fmr_owner != XFS_FMR_OWN_FREE)
 				continue;
-			agbno = (extent->fmr_physical - (bperag * agno)) /
-								blocksize;
-			aglen = extent->fmr_length / blocksize;
+			agbno = xfrog_daddr_to_agbno(xfd,
+					xfrog_btobbt(extent->fmr_physical));
+			aglen = xfrog_b_to_fsbt(xfd, extent->fmr_length);
 			freeblks += aglen;
 			freeexts++;
 
diff --git a/spaceman/trim.c b/spaceman/trim.c
index ea1308f7..8741bab2 100644
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
+		offset = xfrog_bbtob(xfrog_agb_to_daddr(xfd, agno, 0));
+		length = xfrog_fsb_to_b(xfd, fsgeom->agblocks);
 	} else {
 		offset = 0;
-		length = fsgeom->datablocks * fsgeom->blocksize;
+		length = xfrog_fsb_to_b(xfd, fsgeom->datablocks);
 	}
 
 	trim.start = offset;

