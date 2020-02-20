Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A9EC5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 576B221D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gM19Jn/r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgBTBmq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:42:46 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48590 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTBmp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:42:45 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1c5F1039404;
        Thu, 20 Feb 2020 01:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/EpHgLS7RqecaAx8f2BriDufl6jhoTbKwQnwmeZQQDk=;
 b=gM19Jn/r352OdJGzeXSt9/IXvVnqwefCxyBPK/cUKqjvFlBCpMDx5+xyhgodBwLdXI7l
 2RoDt6Vwn3jNmwG60Zjb49LGq2u467hXfDCjsuizOKI/ivSd3jcVDDH2LXQKJDHB9izp
 GoCE4SgtMrTSh3ptaOXQBL2po2SBJEoQqqtg84UO2sI35vbz+D039vJtHu5gzeIF6PnM
 kVMQfVWfkJkqLayxZtxk5CCA5lDknyd5RTdKbJRvMeHFBmcJq1h3YdHCNUAZdWzJ5Ui9
 i+6lciD+Ggsr+FRjAitlaJ2eg9YCOuOBLxQqjQr+GSivl2HMzSKYQgBbxlpR1VTt7Kf9 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y8ud16sa0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1ftpA188483;
        Thu, 20 Feb 2020 01:42:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y8ud96yjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:42 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1gfpc005971;
        Thu, 20 Feb 2020 01:42:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:42:41 -0800
Subject: [PATCH 01/18] libxfs: clean up readbuf flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:42:40 -0800
Message-ID: <158216296035.602314.7876331402312462299.stgit@magnolia>
In-Reply-To: <158216295405.602314.2094526611933874427.stgit@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=952
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a separate namespace for libxfs_readbuf() flags so that it's a
little more obvious when we're trying to use the "read or die" logic.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/init.c      |   11 ++++++++---
 libxfs/libxfs_io.h |    3 +++
 libxfs/rdwr.c      |    4 ++--
 mkfs/xfs_mkfs.c    |    4 ++--
 4 files changed, 15 insertions(+), 7 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index d1d3f4df..428497f0 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -640,6 +640,7 @@ libxfs_mount(
 	xfs_buf_t	*bp;
 	xfs_sb_t	*sbp;
 	int		error;
+	int		readflags = 0;
 
 	libxfs_buftarg_init(mp, dev, logdev, rtdev);
 
@@ -716,9 +717,13 @@ libxfs_mount(
 	if (dev == 0)	/* maxtrres, we have no device so leave now */
 		return mp;
 
+	/* device size checks must pass unless we're a debugger. */
+	if (!(flags & LIBXFS_MOUNT_DEBUGGER))
+		readflags |= LIBXFS_READBUF_FAIL_EXIT;
+
 	bp = libxfs_readbuf(mp->m_dev,
 			d - XFS_FSS_TO_BB(mp, 1), XFS_FSS_TO_BB(mp, 1),
-			!(flags & LIBXFS_MOUNT_DEBUGGER), NULL);
+			readflags, NULL);
 	if (!bp) {
 		fprintf(stderr, _("%s: data size check failed\n"), progname);
 		if (!(flags & LIBXFS_MOUNT_DEBUGGER))
@@ -733,7 +738,7 @@ libxfs_mount(
 		     (!(bp = libxfs_readbuf(mp->m_logdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
 					XFS_FSB_TO_BB(mp, 1),
-					!(flags & LIBXFS_MOUNT_DEBUGGER), NULL))) ) {
+					readflags, NULL))) ) {
 			fprintf(stderr, _("%s: log size checks failed\n"),
 					progname);
 			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
@@ -760,7 +765,7 @@ libxfs_mount(
 	if (sbp->sb_agcount > 1000000) {
 		bp = libxfs_readbuf(mp->m_dev,
 				XFS_AG_DADDR(mp, sbp->sb_agcount - 1, 0), 1,
-				!(flags & LIBXFS_MOUNT_DEBUGGER), NULL);
+				readflags, NULL);
 		if (bp->b_error) {
 			fprintf(stderr, _("%s: read of AG %u failed\n"),
 						progname, sbp->sb_agcount);
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index fc0fd060..b294e659 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -124,6 +124,9 @@ extern struct cache_operations	libxfs_bcache_operations;
 
 #define LIBXFS_GETBUF_TRYLOCK	(1 << 0)
 
+/* Exit on buffer read error */
+#define LIBXFS_READBUF_FAIL_EXIT	(1 << 0)
+
 #ifdef XFS_BUF_TRACING
 
 #define libxfs_readbuf(dev, daddr, len, flags, ops) \
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 92e497f9..32619a8d 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -911,13 +911,13 @@ __read_buf(int fd, void *buf, int len, off64_t offset, int flags)
 		int error = errno;
 		fprintf(stderr, _("%s: read failed: %s\n"),
 			progname, strerror(error));
-		if (flags & LIBXFS_EXIT_ON_FAILURE)
+		if (flags & LIBXFS_READBUF_FAIL_EXIT)
 			exit(1);
 		return -error;
 	} else if (sts != len) {
 		fprintf(stderr, _("%s: error - read only %d of %d bytes\n"),
 			progname, sts, len);
-		if (flags & LIBXFS_EXIT_ON_FAILURE)
+		if (flags & LIBXFS_READBUF_FAIL_EXIT)
 			exit(1);
 		return -EIO;
 	}
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6b182264..a57046f1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3577,7 +3577,7 @@ rewrite_secondary_superblocks(
 			XFS_AGB_TO_DADDR(mp, mp->m_sb.sb_agcount - 1,
 				XFS_SB_DADDR),
 			XFS_FSS_TO_BB(mp, 1),
-			LIBXFS_EXIT_ON_FAILURE, &xfs_sb_buf_ops);
+			LIBXFS_READBUF_FAIL_EXIT, &xfs_sb_buf_ops);
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
@@ -3589,7 +3589,7 @@ rewrite_secondary_superblocks(
 			XFS_AGB_TO_DADDR(mp, (mp->m_sb.sb_agcount - 1) / 2,
 				XFS_SB_DADDR),
 			XFS_FSS_TO_BB(mp, 1),
-			LIBXFS_EXIT_ON_FAILURE, &xfs_sb_buf_ops);
+			LIBXFS_READBUF_FAIL_EXIT, &xfs_sb_buf_ops);
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 }

