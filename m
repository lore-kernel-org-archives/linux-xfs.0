Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5553AC5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DE4C24670
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:45:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LMfx/iTS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgBTBpx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:45:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36454 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbgBTBpx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:45:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1hdxV064550;
        Thu, 20 Feb 2020 01:45:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=UVz2XuvqfkprsYTuxQrX9ud6p+JZbjoMdREPrzLF5pA=;
 b=LMfx/iTSeOFkEceB8XzhZn4pouqIv15TmBQLYKS/k/JZ2zdjtuVcCjNVBOb+q9pXaSq+
 1vGzF1m7/z7i5Im5PchXHF/oK0t2uJt/8aDiWw3wtBov7sJovx679eC3NAcUQlOEBDFv
 F5LXmDJoHa4np3SUeCl8hKNMMc53bbJjjkvpgb3SuzquUu7UX9vyksjPW3Rp03POk9+4
 Z1IuQsq1k4NWfRma2/heCxKM56lqiBCWa+pFXwzZn5LnsjiUYlGYpuvUDK935cStvF4t
 jKtpUbZQ6J8O7tXl7mFRij7tAhIdfuHCrYfKaOokYdFYEB+ha/AWcUTbajZ9NsvytCsQ rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2y8udket7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gELJ094360;
        Thu, 20 Feb 2020 01:43:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y8udbmh32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:43:51 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1ho5T002412;
        Thu, 20 Feb 2020 01:43:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:43:50 -0800
Subject: [PATCH 12/18] libxfs: use uncached buffers for initial mkfs writes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:43:49 -0800
Message-ID: <158216302984.602314.15196666031325406487.stgit@magnolia>
In-Reply-To: <158216295405.602314.2094526611933874427.stgit@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=25
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=2 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=2
 spamscore=0 priorityscore=1501 adultscore=8 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach mkfs to use uncached buffers to write the start and end of the
data device, the initial superblock, and the end of the realtime device
instead of open-coding uncached buffers.  This means we can get rid of
libxfs_purgebuf since we handle the state from the start now.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h |    1 -
 libxfs/rdwr.c      |   12 ------------
 mkfs/xfs_mkfs.c    |   34 +++++++++++++++++++++++-----------
 3 files changed, 23 insertions(+), 24 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 546b7710..6598dba7 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -213,7 +213,6 @@ struct xfs_buf *libxfs_getsb(struct xfs_mount *);
 extern void	libxfs_bcache_purge(void);
 extern void	libxfs_bcache_free(void);
 extern void	libxfs_bcache_flush(void);
-extern void	libxfs_purgebuf(xfs_buf_t *);
 extern int	libxfs_bcache_overflowed(void);
 
 /* Buffer (Raw) Interfaces */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index ada20dd9..20a8b0ce 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -869,18 +869,6 @@ libxfs_buf_relse(
 		libxfs_putbufr(bp);
 }
 
-void
-libxfs_purgebuf(xfs_buf_t *bp)
-{
-	struct xfs_bufkey key = {NULL};
-
-	key.buftarg = bp->b_target;
-	key.blkno = bp->b_bn;
-	key.bblen = bp->b_length;
-
-	cache_node_purge(libxfs_bcache, &key, (struct cache_node *)bp);
-}
-
 static struct cache_node *
 libxfs_balloc(cache_key_t key)
 {
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9ca4cb1a..f58f235d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3396,6 +3396,21 @@ finish_superblock_setup(
 
 }
 
+/* Prepare an uncached buffer, ready to write something out. */
+static inline struct xfs_buf *
+get_write_buf(
+	struct xfs_buftarg	*btp,
+	xfs_daddr_t		daddr,
+	int			bblen)
+{
+	struct xfs_buf		*bp;
+
+	bp = libxfs_buf_get_uncached(btp, bblen, 0);
+	bp->b_bn = daddr;
+	bp->b_maps[0].bm_bn = daddr;
+	return bp;
+}
+
 /*
  * Sanitise the data and log devices and prepare them so libxfs can mount the
  * device successfully. Also check we can access the rt device if configured.
@@ -3444,11 +3459,10 @@ prepare_devices(
 	 * the end of the device.  (MD sb is ~64k from the end, take out a wider
 	 * swath to be sure)
 	 */
-	buf = libxfs_buf_get(mp->m_ddev_targp, (xi->dsize - whack_blks),
-			    whack_blks);
+	buf = get_write_buf(mp->m_ddev_targp, (xi->dsize - whack_blks),
+			whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
 	libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
-	libxfs_purgebuf(buf);
 
 	/*
 	 * Now zero out the beginning of the device, to obliterate any old
@@ -3456,18 +3470,17 @@ prepare_devices(
 	 * swap (somewhere around the page size), jfs (32k),
 	 * ext[2,3] and reiserfs (64k) - and hopefully all else.
 	 */
-	buf = libxfs_buf_get(mp->m_ddev_targp, 0, whack_blks);
+	buf = get_write_buf(mp->m_ddev_targp, 0, whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
 	libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
-	libxfs_purgebuf(buf);
 
 	/* OK, now write the superblock... */
-	buf = libxfs_buf_get(mp->m_ddev_targp, XFS_SB_DADDR, XFS_FSS_TO_BB(mp, 1));
+	buf = get_write_buf(mp->m_ddev_targp, XFS_SB_DADDR,
+			XFS_FSS_TO_BB(mp, 1));
 	buf->b_ops = &xfs_sb_buf_ops;
 	memset(buf->b_addr, 0, cfg->sectorsize);
 	libxfs_sb_to_disk(buf->b_addr, sbp);
 	libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
-	libxfs_purgebuf(buf);
 
 	/* ...and zero the log.... */
 	lsunit = sbp->sb_logsunit;
@@ -3482,12 +3495,11 @@ prepare_devices(
 
 	/* finally, check we can write the last block in the realtime area */
 	if (mp->m_rtdev_targp->dev && cfg->rtblocks > 0) {
-		buf = libxfs_buf_get(mp->m_rtdev_targp,
-				    XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
-				    BTOBB(cfg->blocksize));
+		buf = get_write_buf(mp->m_rtdev_targp,
+				XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
+				BTOBB(cfg->blocksize));
 		memset(buf->b_addr, 0, cfg->blocksize);
 		libxfs_writebuf(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
-		libxfs_purgebuf(buf);
 	}
 
 }

