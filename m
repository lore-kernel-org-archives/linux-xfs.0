Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AA5C5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1E7821D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iYOls1HM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgBTBoZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:44:25 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45852 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBTBoZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:44:25 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gp8x092701;
        Thu, 20 Feb 2020 01:44:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=f1VDn8fvbJ2Q45T+U7WRfUS2ZGa6xia+A3TXDvCp9Jo=;
 b=iYOls1HMqCEHOdFJ5gI10XAQ43ySuQ7n9PgxKxXDUXDLnaXDvwBycBMoUJcrDZKrhxy+
 lM+Pn5LtThejv4duYL7JFz1QnouDn1DRLtEmiSoX/B2y1LNVkxckf1L/7bXO3+8V2sz8
 dYmbwK6u5VlCGx6W6Lf61bfYJEioEFeRNn7Yus6iROqDbwABJJaVP2oPlHy+VbICNW7N
 Fsa4j80DU21nVRGOaTGIcPn7AxQVikS+JRbSxRQ12CtzLe8HxKnkcDW+YJuGiXBYcBRK
 jheA7VnuQrziBBamdriMJB5WbKDtuJW3RaUvFDmwZp4bk3LmxuNLjRJyj2UdAFUr8Y5R 9w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2y8udd6tg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gMje146790;
        Thu, 20 Feb 2020 01:44:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2y8ud4pyvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:23 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1iMPV006690;
        Thu, 20 Feb 2020 01:44:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:44:22 -0800
Subject: [PATCH 17/18] libxfs: rename libxfs_readbuf_map to
 libxfs_buf_read_map
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:44:21 -0800
Message-ID: <158216306157.602314.3988177354387047296.stgit@magnolia>
In-Reply-To: <158216295405.602314.2094526611933874427.stgit@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=2 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=2
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rename this function to match the kernel function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/io.c            |    2 +-
 libxfs/libxfs_io.h |    6 +++---
 libxfs/rdwr.c      |    8 ++++----
 libxfs/trans.c     |    4 ++--
 repair/da_util.c   |    2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)


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
index 32f8fde7..8e9af208 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -135,7 +135,7 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_buf_read(dev, daddr, len, flags, ops) \
 	libxfs_trace_readbuf(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (daddr), (len), (flags), (ops))
-#define libxfs_readbuf_map(dev, map, nmaps, flags, ops) \
+#define libxfs_buf_read_map(dev, map, nmaps, flags, ops) \
 	libxfs_trace_readbuf_map(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (map), (nmaps), (flags), (ops))
 #define libxfs_buf_dirty(buf, flags) \
@@ -168,7 +168,7 @@ extern void	libxfs_trace_putbuf (const char *, const char *, int,
 
 #else
 
-extern xfs_buf_t *libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
+extern xfs_buf_t *libxfs_buf_read_map(struct xfs_buftarg *, struct xfs_buf_map *,
 			int, int, const struct xfs_buf_ops *);
 void libxfs_buf_dirty(struct xfs_buf *bp, int flags);
 extern xfs_buf_t *libxfs_getbuf_map(struct xfs_buftarg *,
@@ -196,7 +196,7 @@ libxfs_buf_read(
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	return libxfs_readbuf_map(target, &map, 1, flags, ops);
+	return libxfs_buf_read_map(target, &map, 1, flags, ops);
 }
 
 #endif /* XFS_BUF_TRACING */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index f46787a6..531f24e3 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -385,11 +385,11 @@ libxfs_log_header(
 
 #ifdef XFS_BUF_TRACING
 
-#undef libxfs_readbuf_map
+#undef libxfs_buf_read_map
 #undef libxfs_writebuf
 #undef libxfs_getbuf_map
 
-xfs_buf_t	*libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
+xfs_buf_t	*libxfs_buf_read_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int, const struct xfs_buf_ops *);
 int		libxfs_writebuf(xfs_buf_t *, int);
 struct xfs_buf *libxfs_buf_get(struct xfs_buftarg *btp, xfs_daddr_t daddr,
@@ -421,7 +421,7 @@ libxfs_trace_readbuf(
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	bp = libxfs_readbuf_map(btp, &map, 1, flags, ops);
+	bp = libxfs_buf_read_map(btp, &map, 1, flags, ops);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
@@ -1026,7 +1026,7 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 }
 
 struct xfs_buf *
-libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
+libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 		int flags, const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf	*bp;
diff --git a/libxfs/trans.c b/libxfs/trans.c
index e23ae598..f532e3d6 100644
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
index d1e17ec3..ed2ec3ba 100644
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

