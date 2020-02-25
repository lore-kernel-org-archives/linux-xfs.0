Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BA3C35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 19:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F37F20CC7
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 19:27:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wM09XYEK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgBYT1G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 14:27:06 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49732 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731270AbgBYT1G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 14:27:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PJMddj174223;
        Tue, 25 Feb 2020 19:27:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=tNkPJnWyYn2PHOwj+f1JGh6vOjQCfgDD7dm6xEbqq3I=;
 b=wM09XYEKsGkfHFAiG84Cb6ealqCG5Sw/mJjfSnPHiUc5FNbBxAbB0TTi63jvvYANSFF6
 4pUm6ErEnG9J19kmWwQjiL5N3qV9Yaqw7fkd1Wt9a6HuhZkCuZhxlh5oSYx9AWBWD3C7
 CAA/USh6+Z6a1ekWOuQvhqttkZon3PZULgCtb/ECDHntgkKWvwUEVqRzkF3wDvE799VH
 96MGTv2f8xYYUOpE62wy67MSWaDLeYREV2KkEEr8acLz8zXEJTR7DAHjdy9H70BFFXta
 5AluzOysf5ygIfnWIEB02vRERE8Tcj62o15Yjz1I3W/QQ07Y5k3zEMtNEp7ExODWt5EP 1w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yd0m1uktt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 19:27:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PJMxgY167294;
        Tue, 25 Feb 2020 19:27:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ybduxffh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 19:27:01 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01PJR0iT015817;
        Tue, 25 Feb 2020 19:27:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 11:27:00 -0800
Date:   Tue, 25 Feb 2020 11:26:59 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 01/25] libxfs: open-code "exit on buffer read failure" in
 upper level callers
Message-ID: <20200225192659.GT6740@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258949476.451378.9569854305232356529.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258949476.451378.9569854305232356529.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=1 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250136
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
v2: improve commit message
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
