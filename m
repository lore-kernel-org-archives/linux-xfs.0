Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12DA8C3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D196F2469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tfYffwtG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgB1Xk5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:40:57 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45666 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgB1Xk5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:40:57 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNcpqH032372;
        Fri, 28 Feb 2020 23:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7YK1kHMyWOcF699ClSWsKeI5oEDTcXUKnLZQBpW/gq0=;
 b=tfYffwtGk+3yqjyhjX81QYjJAxm6TejqEVU0bZ560OwRdi+1iIRDF6YNEGIbsUIACmaJ
 wnxLvIUfiHVu/39EG3HQvc7yMzIdDis9qiqgX00Fm2PuJRbJbtF4+9o9RX5fnk9ftD33
 bzSqy46diWtLeB4yTJRK+nalGuS4WPuCjoznORl69IUyd2Kp4qMBvoaiOKZORyBh+OyS
 IE1/S7CG8L2PZl/P8CumKyfx1tXhqFYPBBUWewrasYVDP0IM5mw9OuXoGJ0gx2QCLJfI
 sZcfdginkO9dCWckX/bTwJ+qcdhXdfrkSv+vz1haa+CmMhTAvjEXV/wBQBsnAZF02pXN aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ydct3nt6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNcPKI137582;
        Fri, 28 Feb 2020 23:38:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ydcs9vp5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:52 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01SNcqIM025550;
        Fri, 28 Feb 2020 23:38:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:38:51 -0800
Subject: [PATCH 24/26] libxfs: rename libxfs_readbuf_map to
 libxfs_buf_read_map
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:38:50 -0800
Message-ID: <158293313091.1549542.15860681533098334712.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=2 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=2 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rename this function to match the kernel function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/io.c            |    2 +-
 libxfs/libxfs_io.h |    9 +++++----
 libxfs/rdwr.c      |   11 ++++++-----
 libxfs/trans.c     |    4 ++--
 repair/da_util.c   |    2 +-
 5 files changed, 15 insertions(+), 13 deletions(-)


diff --git a/db/io.c b/db/io.c
index 7c7a4624..b81e9969 100644
--- a/db/io.c
+++ b/db/io.c
@@ -542,7 +542,7 @@ set_cur(
 		if (!iocur_top->bbmap)
 			return;
 		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
-		bp = libxfs_readbuf_map(mp->m_ddev_targp, bbmap->b,
+		bp = libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
 					bbmap->nmaps, 0, ops);
 	} else {
 		bp = libxfs_buf_read(mp->m_ddev_targp, blknum, len, 0, ops);
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 7f513d86..62b09205 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -132,7 +132,7 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_buf_read(dev, daddr, len, flags, ops) \
 	libxfs_trace_readbuf(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (daddr), (len), (flags), (ops))
-#define libxfs_readbuf_map(dev, map, nmaps, flags, ops) \
+#define libxfs_buf_read_map(dev, map, nmaps, flags, ops) \
 	libxfs_trace_readbuf_map(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (map), (nmaps), (flags), (ops))
 #define libxfs_buf_mark_dirty(buf) \
@@ -165,8 +165,9 @@ extern void	libxfs_trace_putbuf (const char *, const char *, int,
 
 #else
 
-extern xfs_buf_t *libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
-			int, int, const struct xfs_buf_ops *);
+struct xfs_buf *libxfs_buf_read_map(struct xfs_buftarg *btp,
+			struct xfs_buf_map *map, int nmaps, int flags,
+			const struct xfs_buf_ops *ops);
 void libxfs_buf_mark_dirty(struct xfs_buf *bp);
 extern xfs_buf_t *libxfs_getbuf_map(struct xfs_buftarg *,
 			struct xfs_buf_map *, int, int);
@@ -193,7 +194,7 @@ libxfs_buf_read(
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	return libxfs_readbuf_map(target, &map, 1, flags, ops);
+	return libxfs_buf_read_map(target, &map, 1, flags, ops);
 }
 
 #endif /* XFS_BUF_TRACING */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 549fe3c1..2a96646b 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -154,12 +154,13 @@ static char *next(
 
 #ifdef XFS_BUF_TRACING
 
-#undef libxfs_readbuf_map
+#undef libxfs_buf_read_map
 #undef libxfs_writebuf
 #undef libxfs_getbuf_map
 
-xfs_buf_t	*libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
-				int, int, const struct xfs_buf_ops *);
+struct xfs_buf	*libxfs_buf_read_map(struct xfs_buftarg *btp,
+			struct xfs_buf_map *map, int nmaps, int flags,
+			const struct xfs_buf_ops *ops);
 int		libxfs_writebuf(xfs_buf_t *, int);
 struct xfs_buf *libxfs_buf_get(struct xfs_buftarg *btp, xfs_daddr_t daddr,
 				size_t len);
@@ -190,7 +191,7 @@ libxfs_trace_readbuf(
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	bp = libxfs_readbuf_map(btp, &map, 1, flags, ops);
+	bp = libxfs_buf_read_map(btp, &map, 1, flags, ops);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
@@ -796,7 +797,7 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 }
 
 struct xfs_buf *
-libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
+libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 		int flags, const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf	*bp;
diff --git a/libxfs/trans.c b/libxfs/trans.c
index df1ec90b..ebdc73d5 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -507,7 +507,7 @@ libxfs_trans_read_buf_map(
 	*bpp = NULL;
 
 	if (tp == NULL) {
-		bp = libxfs_readbuf_map(target, map, nmaps, flags, ops);
+		bp = libxfs_buf_read_map(target, map, nmaps, flags, ops);
 		if (!bp) {
 			return (flags & XBF_TRYLOCK) ?  -EAGAIN : -ENOMEM;
 		}
@@ -526,7 +526,7 @@ libxfs_trans_read_buf_map(
 		goto done;
 	}
 
-	bp = libxfs_readbuf_map(target, map, nmaps, flags, ops);
+	bp = libxfs_buf_read_map(target, map, nmaps, flags, ops);
 	if (!bp) {
 		return (flags & XBF_TRYLOCK) ?  -EAGAIN : -ENOMEM;
 	}
diff --git a/repair/da_util.c b/repair/da_util.c
index dc1e5bfe..e639ecda 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -64,7 +64,7 @@ da_read_buf(
 		map[i].bm_bn = XFS_FSB_TO_DADDR(mp, bmp[i].startblock);
 		map[i].bm_len = XFS_FSB_TO_BB(mp, bmp[i].blockcount);
 	}
-	bp = libxfs_readbuf_map(mp->m_dev, map, nex, 0, ops);
+	bp = libxfs_buf_read_map(mp->m_dev, map, nex, 0, ops);
 	if (map != map_array)
 		free(map);
 	return bp;

