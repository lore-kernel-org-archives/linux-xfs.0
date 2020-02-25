Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D35C35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB7FA20838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:15:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="urc8houK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgBYAPS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:15:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60526 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAPS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:15:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P09PJI033773;
        Tue, 25 Feb 2020 00:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZjjiQPQMOaLFSZgOhi4KNRcBKvUXMHjCzbP/TmOLvdo=;
 b=urc8houKPvVmDResrZYoJJiwmFbLP84JjPFBCSzCizc9zvoKs9HfYvvk2zMQ3r2VM8Sv
 nLQZ/AVDOLb+qZoPLY4XkuBrp0rsaXpp7OFX7iJ62zpActOj4l1HXo+Y79RmyopJsq3+
 8Hf97U8djImFIXONGSrwqJ+lm3o42Ey1rfeLCOtxRCq5kIzyshxcphh0m/bmRWbNRUmq
 2f/OEJlEaRiFeirkEy8pqAh1dWEKQpvDg+h+l1MKl3Gyvk7OvyI5OkMNG5ttpP9sY3li
 QJ3MbpIzuBD0NX5vW5+7r4eK0E3G9y4bJNjYtcqWvCwfPag/n3mpJItturyaGPwXJOsL OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ycppr8gru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:13:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P0878c014287;
        Tue, 25 Feb 2020 00:13:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ybdshy053-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:13:12 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0DBQR000404;
        Tue, 25 Feb 2020 00:13:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:13:11 -0800
Subject: [PATCH 16/25] libxfs: use uncached buffers for initial mkfs writes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Mon, 24 Feb 2020 16:13:10 -0800
Message-ID: <158258959059.451378.6458672895934429150.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=2 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=21
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=2 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=6
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_io.h |    1 -
 libxfs/rdwr.c      |   12 ------------
 mkfs/xfs_mkfs.c    |   33 ++++++++++++++++++++++-----------
 3 files changed, 22 insertions(+), 24 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 21afc99c..1d30039a 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -211,7 +211,6 @@ struct xfs_buf *libxfs_getsb(struct xfs_mount *mp);
 extern void	libxfs_bcache_purge(void);
 extern void	libxfs_bcache_free(void);
 extern void	libxfs_bcache_flush(void);
-extern void	libxfs_purgebuf(xfs_buf_t *);
 extern int	libxfs_bcache_overflowed(void);
 
 /* Buffer (Raw) Interfaces */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 739f4aed..e19b4c51 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -633,18 +633,6 @@ libxfs_buf_relse(
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
index 3827b410..b80bbd75 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3396,6 +3396,21 @@ finish_superblock_setup(
 
 }
 
+/* Prepare an uncached buffer, ready to write something out. */
+static inline struct xfs_buf *
+alloc_write_buf(
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
+	buf = alloc_write_buf(mp->m_ddev_targp, (xi->dsize - whack_blks),
+			whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
 	libxfs_writebuf(buf, 0);
-	libxfs_purgebuf(buf);
 
 	/*
 	 * Now zero out the beginning of the device, to obliterate any old
@@ -3456,19 +3470,17 @@ prepare_devices(
 	 * swap (somewhere around the page size), jfs (32k),
 	 * ext[2,3] and reiserfs (64k) - and hopefully all else.
 	 */
-	buf = libxfs_buf_get(mp->m_ddev_targp, 0, whack_blks);
+	buf = alloc_write_buf(mp->m_ddev_targp, 0, whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
 	libxfs_writebuf(buf, 0);
-	libxfs_purgebuf(buf);
 
 	/* OK, now write the superblock... */
-	buf = libxfs_buf_get(mp->m_ddev_targp, XFS_SB_DADDR,
+	buf = alloc_write_buf(mp->m_ddev_targp, XFS_SB_DADDR,
 			XFS_FSS_TO_BB(mp, 1));
 	buf->b_ops = &xfs_sb_buf_ops;
 	memset(buf->b_addr, 0, cfg->sectorsize);
 	libxfs_sb_to_disk(buf->b_addr, sbp);
 	libxfs_writebuf(buf, 0);
-	libxfs_purgebuf(buf);
 
 	/* ...and zero the log.... */
 	lsunit = sbp->sb_logsunit;
@@ -3483,12 +3495,11 @@ prepare_devices(
 
 	/* finally, check we can write the last block in the realtime area */
 	if (mp->m_rtdev_targp->dev && cfg->rtblocks > 0) {
-		buf = libxfs_buf_get(mp->m_rtdev_targp,
-				    XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
-				    BTOBB(cfg->blocksize));
+		buf = alloc_write_buf(mp->m_rtdev_targp,
+				XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
+				BTOBB(cfg->blocksize));
 		memset(buf->b_addr, 0, cfg->blocksize);
 		libxfs_writebuf(buf, 0);
-		libxfs_purgebuf(buf);
 	}
 
 }

