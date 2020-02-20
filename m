Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E015FC761A1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8B0F21D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="v6ybztyQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgBTBmy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:42:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44430 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgBTBmy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:42:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gqRx092773;
        Thu, 20 Feb 2020 01:42:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Raedmf3cqOUyPXMftldQraaXm4KWCTPyMp8W9x/n9Hs=;
 b=v6ybztyQaobrTKhPtOOFiqZFhyky9mxYfcXe3Car5A2qoJEOatgenGKE6vzVBJ2phwpk
 TlBMglKFxyFFe5eRmdi8AY/NJbKBaJfKm1AvYJb3MSFvNZXBW1Rl7JNqBId2COaEeWr+
 1wgR9ChNHx40DXUf+U+LJM+7+IgrHJoRyy9LFVAMDqbO1g035Y+v+5phcQk3GRBC4gQp
 AmgCjlPsXebzzbdsVeD48wAnw3ang3/YZe/h2WXNdRbhLsUoQmMYuAZ96laE3hyl2XZY
 7g9dd7+a6Sed+vcoCZiUcjNbGU3R/5GOoV+KECh1VnuZ5YTd7RoxAvbsIbQJsXrVSdad Wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2y8udd6tct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1bqfe051095;
        Thu, 20 Feb 2020 01:42:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2y8ud2g2pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1gl2T006071;
        Thu, 20 Feb 2020 01:42:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:42:47 -0800
Subject: [PATCH 02/18] libxfs: clean up writebuf flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:42:46 -0800
Message-ID: <158216296640.602314.16919417617883884717.stgit@magnolia>
In-Reply-To: <158216295405.602314.2094526611933874427.stgit@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=802 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=845 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create an explicit namespace for writebuf flags so that we can keep the
flags namespaces separate.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h |    3 +++
 libxfs/rdwr.c      |   11 +++++++++--
 mkfs/proto.c       |    2 +-
 mkfs/xfs_mkfs.c    |   14 +++++++-------
 4 files changed, 20 insertions(+), 10 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index b294e659..bb6b689e 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -127,6 +127,9 @@ extern struct cache_operations	libxfs_bcache_operations;
 /* Exit on buffer read error */
 #define LIBXFS_READBUF_FAIL_EXIT	(1 << 0)
 
+/* Exit on buffer write error */
+#define LIBXFS_WRITEBUF_FAIL_EXIT	(1 << 0)
+
 #ifdef XFS_BUF_TRACING
 
 #define libxfs_readbuf(dev, daddr, len, flags, ops) \
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 32619a8d..f56303e2 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1177,21 +1177,28 @@ libxfs_writebuf_int(xfs_buf_t *bp, int flags)
 }
 
 int
-libxfs_writebuf(xfs_buf_t *bp, int flags)
+libxfs_writebuf(
+	struct xfs_buf	*bp,
+	int		flags)
 {
+	int		bflags = LIBXFS_B_DIRTY;
+
 #ifdef IO_DEBUG
 	printf("%lx: %s: dirty blkno=%llu(%llu)\n",
 			pthread_self(), __FUNCTION__,
 			(long long)LIBXFS_BBTOOFF64(bp->b_bn),
 			(long long)bp->b_bn);
 #endif
+	if (flags & LIBXFS_WRITEBUF_FAIL_EXIT)
+		bflags |= LIBXFS_B_EXIT;
+
 	/*
 	 * Clear any error hanging over from reading the buffer. This prevents
 	 * subsequent reads after this write from seeing stale errors.
 	 */
 	bp->b_error = 0;
 	bp->b_flags &= ~LIBXFS_B_STALE;
-	bp->b_flags |= (LIBXFS_B_DIRTY | flags);
+	bp->b_flags |= bflags;
 	libxfs_putbuf(bp);
 	return 0;
 }
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 2ece593e..0025fa08 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -262,7 +262,7 @@ newfile(
 		if (logit)
 			libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount - 1);
 		else
-			libxfs_writebuf(bp, LIBXFS_EXIT_ON_FAILURE);
+			libxfs_writebuf(bp, LIBXFS_WRITEBUF_FAIL_EXIT);
 	}
 	ip->i_d.di_size = len;
 	return flags;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a57046f1..db640a11 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3447,7 +3447,7 @@ prepare_devices(
 	buf = libxfs_getbuf(mp->m_ddev_targp, (xi->dsize - whack_blks),
 			    whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
 	libxfs_purgebuf(buf);
 
 	/*
@@ -3458,7 +3458,7 @@ prepare_devices(
 	 */
 	buf = libxfs_getbuf(mp->m_ddev_targp, 0, whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
 	libxfs_purgebuf(buf);
 
 	/* OK, now write the superblock... */
@@ -3466,7 +3466,7 @@ prepare_devices(
 	buf->b_ops = &xfs_sb_buf_ops;
 	memset(buf->b_addr, 0, cfg->sectorsize);
 	libxfs_sb_to_disk(buf->b_addr, sbp);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
 	libxfs_purgebuf(buf);
 
 	/* ...and zero the log.... */
@@ -3486,7 +3486,7 @@ prepare_devices(
 				    XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
 				    BTOBB(cfg->blocksize));
 		memset(buf->b_addr, 0, cfg->blocksize);
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+		libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
 		libxfs_purgebuf(buf);
 	}
 
@@ -3579,7 +3579,7 @@ rewrite_secondary_superblocks(
 			XFS_FSS_TO_BB(mp, 1),
 			LIBXFS_READBUF_FAIL_EXIT, &xfs_sb_buf_ops);
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
 
 	/* and one in the middle for luck if there's enough AGs for that */
 	if (mp->m_sb.sb_agcount <= 2)
@@ -3591,7 +3591,7 @@ rewrite_secondary_superblocks(
 			XFS_FSS_TO_BB(mp, 1),
 			LIBXFS_READBUF_FAIL_EXIT, &xfs_sb_buf_ops);
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
 }
 
 static void
@@ -3939,7 +3939,7 @@ main(
 	if (!buf || buf->b_error)
 		exit(1);
 	(XFS_BUF_TO_SBP(buf))->sb_inprogress = 0;
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
 
 	/* Make sure our new fs made it to stable storage. */
 	libxfs_flush_devices(mp, &d, &l, &r);

