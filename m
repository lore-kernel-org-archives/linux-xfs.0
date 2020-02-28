Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FF3C3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 472F32469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:41:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fel+eFH7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgB1XlD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:41:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56348 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgB1XlD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:41:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNXdRi069495;
        Fri, 28 Feb 2020 23:38:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+hbeoZGBXi4iZt+KPqp+3LkpW6xRI4G5xF+xWyvt35s=;
 b=fel+eFH7GtU/Xv3l/YUQkn7DBPjD9R5gnXLEZjUGCwVlj8IlhIcHWPSpXeI8fhiHsymC
 NKg25Cllp2G8z/OKQ8zytlB3SEphJZbt1HsIpPzWbWd1Dq0IeIABtQFxB1wT89Yg1/R+
 AsZVZoU5wIynZZeXTMRvWdtiVjDQ7/kXsr6WH/JiP/MXW5CZnMtWcKenMXu3Gi8XX7Fy
 F4h+EnMUrVhsHPrGPPTxEg6nsMO2IdHoe8AyVN1TvfBL+OPX+OCPw6RpEhYF3+k127mM
 IkKZq9HRiC+bHNbIbfDvFNKINcRgjHh0yyCxJUQAFncIvwxBEoIG0gNqEXcMdUxipsgq tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ydcsnwxma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNcQBa137621;
        Fri, 28 Feb 2020 23:38:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ydcs9vpkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:59 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01SNcw1u025654;
        Fri, 28 Feb 2020 23:38:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:38:58 -0800
Subject: [PATCH 25/26] libxfs: rename libxfs_getbuf_map to libxfs_buf_get_map
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:38:57 -0800
Message-ID: <158293313709.1549542.17829043819672414218.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
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

Rename this function to match the kernel function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_io.h |    8 ++++----
 libxfs/rdwr.c      |   18 +++++++++---------
 libxfs/trans.c     |    4 ++--
 repair/prefetch.c  |    2 +-
 4 files changed, 16 insertions(+), 16 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 62b09205..957f0396 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -141,7 +141,7 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_buf_get(dev, daddr, len) \
 	libxfs_trace_getbuf(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (daddr), (len))
-#define libxfs_getbuf_map(dev, map, nmaps, flags) \
+#define libxfs_buf_get_map(dev, map, nmaps, flags) \
 	libxfs_trace_getbuf_map(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (map), (nmaps), (flags))
 #define libxfs_buf_relse(buf) \
@@ -169,8 +169,8 @@ struct xfs_buf *libxfs_buf_read_map(struct xfs_buftarg *btp,
 			struct xfs_buf_map *map, int nmaps, int flags,
 			const struct xfs_buf_ops *ops);
 void libxfs_buf_mark_dirty(struct xfs_buf *bp);
-extern xfs_buf_t *libxfs_getbuf_map(struct xfs_buftarg *,
-			struct xfs_buf_map *, int, int);
+struct xfs_buf *libxfs_buf_get_map(struct xfs_buftarg *btp,
+			struct xfs_buf_map *map, int nmaps, int flags);
 void	libxfs_buf_relse(struct xfs_buf *bp);
 
 static inline struct xfs_buf*
@@ -181,7 +181,7 @@ libxfs_buf_get(
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	return libxfs_getbuf_map(target, &map, 1, 0);
+	return libxfs_buf_get_map(target, &map, 1, 0);
 }
 
 static inline struct xfs_buf*
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 2a96646b..79d74583 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -156,7 +156,7 @@ static char *next(
 
 #undef libxfs_buf_read_map
 #undef libxfs_writebuf
-#undef libxfs_getbuf_map
+#undef libxfs_buf_get_map
 
 struct xfs_buf	*libxfs_buf_read_map(struct xfs_buftarg *btp,
 			struct xfs_buf_map *map, int nmaps, int flags,
@@ -164,8 +164,8 @@ struct xfs_buf	*libxfs_buf_read_map(struct xfs_buftarg *btp,
 int		libxfs_writebuf(xfs_buf_t *, int);
 struct xfs_buf *libxfs_buf_get(struct xfs_buftarg *btp, xfs_daddr_t daddr,
 				size_t len);
-xfs_buf_t	*libxfs_getbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
-				int, int);
+struct xfs_buf	*libxfs_buf_get_map(struct xfs_buftarg *btp,
+			struct xfs_buf_map *map, int nmaps, int flags);
 void		libxfs_buf_relse(struct xfs_buf *bp);
 
 #define	__add_trace(bp, func, file, line)	\
@@ -219,7 +219,7 @@ libxfs_trace_getbuf(
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	bp = libxfs_getbuf_map(target, &map, 1, 0);
+	bp = libxfs_buf_get_map(target, &map, 1, 0);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
@@ -229,7 +229,7 @@ libxfs_trace_getbuf_map(const char *func, const char *file, int line,
 		struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 		int flags)
 {
-	xfs_buf_t	*bp = libxfs_getbuf_map(btp, map, nmaps, flags);
+	xfs_buf_t	*bp = libxfs_buf_get_map(btp, map, nmaps, flags);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
@@ -575,7 +575,7 @@ reset_buf_state(
 }
 
 static struct xfs_buf *
-__libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
+__libxfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
 		    int nmaps, int flags)
 {
 	struct xfs_bufkey key = {NULL};
@@ -597,12 +597,12 @@ __libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
 }
 
 struct xfs_buf *
-libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
+libxfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
 		  int nmaps, int flags)
 {
 	struct xfs_buf	*bp;
 
-	bp = __libxfs_getbuf_map(btp, map, nmaps, flags);
+	bp = __libxfs_buf_get_map(btp, map, nmaps, flags);
 	reset_buf_state(bp);
 	return bp;
 }
@@ -807,7 +807,7 @@ libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 		return libxfs_readbuf(btp, map[0].bm_bn, map[0].bm_len,
 					flags, ops);
 
-	bp = __libxfs_getbuf_map(btp, map, nmaps, 0);
+	bp = __libxfs_buf_get_map(btp, map, nmaps, 0);
 	if (!bp)
 		return NULL;
 
diff --git a/libxfs/trans.c b/libxfs/trans.c
index ebdc73d5..b78bca86 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -427,7 +427,7 @@ libxfs_trans_get_buf_map(
 	struct xfs_buf_log_item	*bip;
 
 	if (!tp)
-		return libxfs_getbuf_map(target, map, nmaps, 0);
+		return libxfs_buf_get_map(target, map, nmaps, 0);
 
 	/*
 	 * If we find the buffer in the cache with this transaction
@@ -445,7 +445,7 @@ libxfs_trans_get_buf_map(
 		return bp;
 	}
 
-	bp = libxfs_getbuf_map(target, map, nmaps, 0);
+	bp = libxfs_buf_get_map(target, map, nmaps, 0);
 	if (bp == NULL) {
 		return NULL;
 	}
diff --git a/repair/prefetch.c b/repair/prefetch.c
index a3858f9a..7f705cc0 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -120,7 +120,7 @@ pf_queue_io(
 	 * the lock holder is either reading it from disk himself or
 	 * completely overwriting it this behaviour is perfectly fine.
 	 */
-	bp = libxfs_getbuf_map(mp->m_dev, map, nmaps, LIBXFS_GETBUF_TRYLOCK);
+	bp = libxfs_buf_get_map(mp->m_dev, map, nmaps, LIBXFS_GETBUF_TRYLOCK);
 	if (!bp)
 		return;
 

