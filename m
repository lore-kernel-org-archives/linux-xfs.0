Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E1DC3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02A562469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:36:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o93iGyaR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgB1Xge (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:36:34 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50864 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB1Xge (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:36:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNXXew068889;
        Fri, 28 Feb 2020 23:36:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QVH40N2LU8qddPEcxh3GyYYkv9UZ+ThA105cJKVFGd8=;
 b=o93iGyaRRWrqRZXsYlP5Q2q/5Ch3TQb1Ysz50pE45lQu5cGZ0Qzpmx4U4MRt3sqyIaOK
 zIQVTMFWaEoTDiAgvmnTncyKidRqIKhvXsUU6hAR/rjDGn16taCz4lAAE0IE46ymsSZi
 ar0hTwRJ5qtnL+hfwkpErYVUrAy3yDyTvj+cVouI9SXFdxWH7YLnSKkEXx27mfD5XSdq
 hou793f7n11IFMOR1EY7DB6Scsk6iiOprmNXpuzHKHdBC0EXjdYL9jkWmZsEPJ9voj4O
 xaHlgdpL/CuYLjFsOdq/PAK8N/ZjGMg41sZfprI/hh8ujOXavFgLryEpnMHxflsyO+5i 0w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ydcsnwxf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:36:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWkQp156418;
        Fri, 28 Feb 2020 23:36:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ydcsgb50h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:36:29 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNaS7W024053;
        Fri, 28 Feb 2020 23:36:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:36:27 -0800
Subject: [PATCH 02/26] libxfs: remove LIBXFS_EXIT_ON_FAILURE
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:36:26 -0800
Message-ID: <158293298685.1549542.8285070031855494570.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that the read-side users of LIBXFS_EXIT_ON_FAILURE are gone and the
only write-side callers are in mkfs which now checks for buffer write
failures, get rid of LIBXFS_EXIT_ON_FAILURE.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h   |    1 -
 libxfs/libxfs_io.h |    2 +-
 libxfs/rdwr.c      |    2 +-
 mkfs/proto.c       |    2 +-
 mkfs/xfs_mkfs.c    |   14 +++++++-------
 5 files changed, 10 insertions(+), 11 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 504f6e9c..12447835 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -126,7 +126,6 @@ typedef struct libxfs_xinit {
 	int		bcache_flags;	/* cache init flags */
 } libxfs_init_t;
 
-#define LIBXFS_EXIT_ON_FAILURE	0x0001	/* exit the program if a call fails */
 #define LIBXFS_ISREADONLY	0x0002	/* disallow all mounted filesystems */
 #define LIBXFS_ISINACTIVE	0x0004	/* allow mounted only if mounted ro */
 #define LIBXFS_DANGEROUSLY	0x0008	/* repairing a device mounted ro    */
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 6bb75a67..87c6ea3e 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -91,7 +91,7 @@ bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
 bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
 
 /* b_flags bits */
-#define LIBXFS_B_EXIT		0x0001	/* ==LIBXFS_EXIT_ON_FAILURE */
+#define LIBXFS_B_EXIT		0x0001	/* exit if write fails */
 #define LIBXFS_B_DIRTY		0x0002	/* buffer has been modified */
 #define LIBXFS_B_STALE		0x0004	/* buffer marked as invalid */
 #define LIBXFS_B_UPTODATE	0x0008	/* buffer is sync'd to disk */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index effcc7f0..f775e67d 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -19,7 +19,7 @@
 #include "xfs_trans.h"
 #include "libfrog/platform.h"
 
-#include "libxfs.h"		/* for LIBXFS_EXIT_ON_FAILURE */
+#include "libxfs.h"
 
 /*
  * Important design/architecture note:
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 2ece593e..c3813ea2 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -262,7 +262,7 @@ newfile(
 		if (logit)
 			libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount - 1);
 		else
-			libxfs_writebuf(bp, LIBXFS_EXIT_ON_FAILURE);
+			libxfs_writebuf(bp, 0);
 	}
 	ip->i_d.di_size = len;
 	return flags;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5e412667..25bdf8df 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3447,7 +3447,7 @@ prepare_devices(
 	buf = libxfs_getbuf(mp->m_ddev_targp, (xi->dsize - whack_blks),
 			    whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_writebuf(buf, 0);
 	libxfs_purgebuf(buf);
 
 	/*
@@ -3458,7 +3458,7 @@ prepare_devices(
 	 */
 	buf = libxfs_getbuf(mp->m_ddev_targp, 0, whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_writebuf(buf, 0);
 	libxfs_purgebuf(buf);
 
 	/* OK, now write the superblock... */
@@ -3466,7 +3466,7 @@ prepare_devices(
 	buf->b_ops = &xfs_sb_buf_ops;
 	memset(buf->b_addr, 0, cfg->sectorsize);
 	libxfs_sb_to_disk(buf->b_addr, sbp);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_writebuf(buf, 0);
 	libxfs_purgebuf(buf);
 
 	/* ...and zero the log.... */
@@ -3486,7 +3486,7 @@ prepare_devices(
 				    XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
 				    BTOBB(cfg->blocksize));
 		memset(buf->b_addr, 0, cfg->blocksize);
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+		libxfs_writebuf(buf, 0);
 		libxfs_purgebuf(buf);
 	}
 
@@ -3583,7 +3583,7 @@ rewrite_secondary_superblocks(
 		exit(1);
 	}
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_writebuf(buf, 0);
 
 	/* and one in the middle for luck if there's enough AGs for that */
 	if (mp->m_sb.sb_agcount <= 2)
@@ -3599,7 +3599,7 @@ rewrite_secondary_superblocks(
 		exit(1);
 	}
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_writebuf(buf, 0);
 }
 
 static void
@@ -3946,7 +3946,7 @@ main(
 	if (!buf || buf->b_error)
 		exit(1);
 	(XFS_BUF_TO_SBP(buf))->sb_inprogress = 0;
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_writebuf(buf, 0);
 
 	/* Exit w/ failure if anything failed to get written to our new fs. */
 	error = -libxfs_umount(mp);

