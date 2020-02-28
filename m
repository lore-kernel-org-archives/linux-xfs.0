Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E91C3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AB052469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:36:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J/y2asde"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgB1Xg1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:36:27 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40542 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB1Xg1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:36:27 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWmN8027890;
        Fri, 28 Feb 2020 23:36:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DUpryLdZ/w3R41wIat3qhqTKktpnKb8pf650fh7EzSQ=;
 b=J/y2asdeJ5orf4UZhvaPXNZ4iG1vw+bt4h7deYqfMbbUO27yHMK7OCurkyL/dBg97guy
 X9UNsQ67nvM/vA+BAdjxoxzZOlIhw7wTRDmk48Jl+xFfT4nI6apQ6pEXuQMJwfCQQWcX
 Xe34JTo9yhjkjDRZn7klskpyS1XOhXwfvlIEIwdL74ZiZYe+l0Fb1SBE3oZWaa/iEsGl
 85GOPbU5+pTNbSR7OY1BKDhQXJNI0ndXA4ixWzPJva4zJNrpM+3Ey9U60qj+FluzRH1S
 nVH3WyxMsMzppgmMRbl4qDiauN02uEldYs99XuXZ5Ikmuyli/XtWbsLYxvxlqQ+tkoIc RA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ydct3nt1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:36:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNXWGi099244;
        Fri, 28 Feb 2020 23:36:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2ydcsgegdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:36:23 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01SNaLLe024657;
        Fri, 28 Feb 2020 23:36:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:36:21 -0800
Subject: [PATCH 01/26] libxfs: open-code "exit on buffer read failure" in
 upper level callers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:36:20 -0800
Message-ID: <158293298067.1549542.14973725681777697372.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make all functions that use LIBXFS_EXIT_ON_FAILURE to abort on buffer
read errors implement that logic themselves.  This also removes places
where libxfs can abort the program with no warning.

Note that in libxfs_mount, the "!(flags & DEBUGGER)" code would
indirectly select LIBXFS_EXIT_ON_FAILURE, so we're replacing the hidden
library exit(1) with a null xfs_mount return, which should cause the
utilities to exit with an error.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c   |   40 ++++++++++++++++++++--------------------
 libxfs/rdwr.c   |    4 ----
 mkfs/xfs_mkfs.c |   16 ++++++++++++----
 3 files changed, 32 insertions(+), 28 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 42d4c8e4..5eeb58c8 100644
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
index 737e51d1..effcc7f0 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -918,14 +918,10 @@ __read_buf(int fd, void *buf, int len, off64_t offset, int flags)
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
index bbc2da83..5e412667 100644
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

