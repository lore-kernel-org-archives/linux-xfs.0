Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 143DEC35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE52321927
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:11:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RfzxS6nT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgBYALk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:11:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47334 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYALk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:11:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P087oa050231;
        Tue, 25 Feb 2020 00:11:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ijjv6OaQHZ6g+3mjU3dRtvnvjb4qD5rd90/m7lzZ1vQ=;
 b=RfzxS6nT7kn/ZapS2ZPP2wpbwHPRNMmjUpk98W29fYcOdoli7Xh4ipeYT+x9DHbshXvv
 Vp5JTP+XWQ3lJD8a34ETT0bQOex+nQ8fyBjFpPoaOm/asWf4YuWxRYLLC9e49pzHkGmS
 YC4oHHcTSGnAnjlFlQQ4Ll1RIktXog9AvPllhyc4JF4HIScnb/0f6sx2g5kYSchckD7s
 FwkLIWh4jO/sxMCduPVyqJTATyPn9yYNcOQQ0n+vFuhLWbQoOijhEuo6/q9X8yCeSeaW
 fcy4dSflHkbvLHCB3fHZz+sxlLHhY87NGAJubsgPv0gi/uI+06Sn791Zq7VuOVTNoAED Vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q38p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P06gYI099062;
        Tue, 25 Feb 2020 00:11:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ybduvfwkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:37 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0BbXO012790;
        Tue, 25 Feb 2020 00:11:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:11:37 -0800
Subject: [PATCH 01/25] libxfs: open-code "exit on buffer read failure" in
 upper level callers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:11:34 -0800
Message-ID: <158258949476.451378.9569854305232356529.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=906 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=949 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make all functions that use LIBXFS_EXIT_ON_FAILURE to abort on buffer
read errors implement that logic themselves.  This also removes places
where libxfs can abort the program with no warning.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/init.c   |   40 ++++++++++++++++++++--------------------
 libxfs/rdwr.c   |    4 ----
 mkfs/xfs_mkfs.c |   16 ++++++++++++----
 3 files changed, 32 insertions(+), 28 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 913f546f..485ab8f8 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -639,19 +639,20 @@ libxfs_buftarg_init(
  * such that the numerous XFS_* macros can be used.  If dev is zero,
  * no IO will be performed (no size checks, read root inodes).
  */
-xfs_mount_t *
+struct xfs_mount *
 libxfs_mount(
-	xfs_mount_t	*mp,
-	xfs_sb_t	*sb,
-	dev_t		dev,
-	dev_t		logdev,
-	dev_t		rtdev,
-	int		flags)
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sb,
+	dev_t			dev,
+	dev_t			logdev,
+	dev_t			rtdev,
+	int			flags)
 {
-	xfs_daddr_t	d;
-	xfs_buf_t	*bp;
-	xfs_sb_t	*sbp;
-	int		error;
+	struct xfs_buf		*bp;
+	struct xfs_sb		*sbp;
+	xfs_daddr_t		d;
+	bool			debugger = (flags & LIBXFS_MOUNT_DEBUGGER);
+	int			error;
 
 	libxfs_buftarg_init(mp, dev, logdev, rtdev);
 
@@ -728,12 +729,12 @@ libxfs_mount(
 	if (dev == 0)	/* maxtrres, we have no device so leave now */
 		return mp;
 
-	bp = libxfs_readbuf(mp->m_dev,
-			d - XFS_FSS_TO_BB(mp, 1), XFS_FSS_TO_BB(mp, 1),
-			!(flags & LIBXFS_MOUNT_DEBUGGER), NULL);
+	/* device size checks must pass unless we're a debugger. */
+	bp = libxfs_readbuf(mp->m_dev, d - XFS_FSS_TO_BB(mp, 1),
+			XFS_FSS_TO_BB(mp, 1), 0, NULL);
 	if (!bp) {
 		fprintf(stderr, _("%s: data size check failed\n"), progname);
-		if (!(flags & LIBXFS_MOUNT_DEBUGGER))
+		if (!debugger)
 			return NULL;
 	} else
 		libxfs_putbuf(bp);
@@ -744,11 +745,10 @@ libxfs_mount(
 		if ( (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) ||
 		     (!(bp = libxfs_readbuf(mp->m_logdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
-					XFS_FSB_TO_BB(mp, 1),
-					!(flags & LIBXFS_MOUNT_DEBUGGER), NULL))) ) {
+					XFS_FSB_TO_BB(mp, 1), 0, NULL)))) {
 			fprintf(stderr, _("%s: log size checks failed\n"),
 					progname);
-			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
+			if (!debugger)
 				return NULL;
 		}
 		if (bp)
@@ -772,11 +772,11 @@ libxfs_mount(
 	if (sbp->sb_agcount > 1000000) {
 		bp = libxfs_readbuf(mp->m_dev,
 				XFS_AG_DADDR(mp, sbp->sb_agcount - 1, 0), 1,
-				!(flags & LIBXFS_MOUNT_DEBUGGER), NULL);
+				0, NULL);
 		if (bp->b_error) {
 			fprintf(stderr, _("%s: read of AG %u failed\n"),
 						progname, sbp->sb_agcount);
-			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
+			if (!debugger)
 				return NULL;
 			fprintf(stderr, _("%s: limiting reads to AG 0\n"),
 								progname);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 4253b890..474fceb0 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -911,14 +911,10 @@ __read_buf(int fd, void *buf, int len, off64_t offset, int flags)
 		int error = errno;
 		fprintf(stderr, _("%s: read failed: %s\n"),
 			progname, strerror(error));
-		if (flags & LIBXFS_EXIT_ON_FAILURE)
-			exit(1);
 		return -error;
 	} else if (sts != len) {
 		fprintf(stderr, _("%s: error - read only %d of %d bytes\n"),
 			progname, sts, len);
-		if (flags & LIBXFS_EXIT_ON_FAILURE)
-			exit(1);
 		return -EIO;
 	}
 	return 0;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7f315d8a..3de73fc6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3576,8 +3576,12 @@ rewrite_secondary_superblocks(
 	buf = libxfs_readbuf(mp->m_dev,
 			XFS_AGB_TO_DADDR(mp, mp->m_sb.sb_agcount - 1,
 				XFS_SB_DADDR),
-			XFS_FSS_TO_BB(mp, 1),
-			LIBXFS_EXIT_ON_FAILURE, &xfs_sb_buf_ops);
+			XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
+	if (!buf) {
+		fprintf(stderr, _("%s: could not re-read AG %u superblock\n"),
+				progname, mp->m_sb.sb_agcount - 1);
+		exit(1);
+	}
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
@@ -3588,8 +3592,12 @@ rewrite_secondary_superblocks(
 	buf = libxfs_readbuf(mp->m_dev,
 			XFS_AGB_TO_DADDR(mp, (mp->m_sb.sb_agcount - 1) / 2,
 				XFS_SB_DADDR),
-			XFS_FSS_TO_BB(mp, 1),
-			LIBXFS_EXIT_ON_FAILURE, &xfs_sb_buf_ops);
+			XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
+	if (!buf) {
+		fprintf(stderr, _("%s: could not re-read AG %u superblock\n"),
+				progname, (mp->m_sb.sb_agcount - 1) / 2);
+		exit(1);
+	}
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 }

