Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8D9C35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA6F821927
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:16:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EQPvCGTg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgBYAQO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:16:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33892 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAQO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:16:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P09Lr2033747;
        Tue, 25 Feb 2020 00:14:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=FJWOAZ5NZE0+890qFTZ7Pfvm6Il+pv5fZrvq86l/xfk=;
 b=EQPvCGTg1LW6dTffIwZigUhX/RJOi7OvTmZSJcTHufUGs6K532/2suatDCUaci2K1ndF
 JpxpKrDey6k7aGYbopamRYDxWPewNo2SpI88eoN62uutyKDfTvg8zHNv1bNL9uAekYA1
 q1DO+xe/aV09zRqVXmKxcNSwyfxxC2HFBMh1t7j8U3R3ow22TWzow39b+KrrkxslJbCw
 wycjbbVbP35+ZdGry/dU5+ybJG/Zris4XI4hN8WUCqAyTcNS//UXyA+9xMCZSxgkJ1UU
 aKqzSRfyJ4/ThcbuZhSxbXKhd3K3p1ySuCMCI7mBKB2eL1ShfU/TzH4TtjKuZ2dhCc9d 7A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ycppr8gv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:14:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07tVF108964;
        Tue, 25 Feb 2020 00:14:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ybe12es03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:14:09 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0E8gc014337;
        Tue, 25 Feb 2020 00:14:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:14:08 -0800
Subject: [PATCH 25/25] libxfs: rename libxfs_getbuf_map to libxfs_buf_get_map
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Mon, 24 Feb 2020 16:14:07 -0800
Message-ID: <158258964735.451378.6467464967522239021.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
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
index 7fc43743..ce31e45d 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -149,7 +149,7 @@ static char *next(
 
 #undef libxfs_buf_read_map
 #undef libxfs_writebuf
-#undef libxfs_getbuf_map
+#undef libxfs_buf_get_map
 
 struct xfs_buf	*libxfs_buf_read_map(struct xfs_buftarg *btp,
 			struct xfs_buf_map *map, int nmaps, int flags,
@@ -157,8 +157,8 @@ struct xfs_buf	*libxfs_buf_read_map(struct xfs_buftarg *btp,
 int		libxfs_writebuf(xfs_buf_t *, int);
 struct xfs_buf *libxfs_buf_get(struct xfs_buftarg *btp, xfs_daddr_t daddr,
 				size_t len);
-xfs_buf_t	*libxfs_getbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
-				int, int);
+struct xfs_buf	*libxfs_buf_get_map(struct xfs_buftarg *btp,
+			struct xfs_buf_map *map, int nmaps, int flags);
 void		libxfs_buf_relse(struct xfs_buf *bp);
 
 #define	__add_trace(bp, func, file, line)	\
@@ -212,7 +212,7 @@ libxfs_trace_getbuf(
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	bp = libxfs_getbuf_map(target, &map, 1, 0);
+	bp = libxfs_buf_get_map(target, &map, 1, 0);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
@@ -222,7 +222,7 @@ libxfs_trace_getbuf_map(const char *func, const char *file, int line,
 		struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 		int flags)
 {
-	xfs_buf_t	*bp = libxfs_getbuf_map(btp, map, nmaps, flags);
+	xfs_buf_t	*bp = libxfs_buf_get_map(btp, map, nmaps, flags);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
@@ -568,7 +568,7 @@ reset_buf_state(
 }
 
 static struct xfs_buf *
-__libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
+__libxfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
 		    int nmaps, int flags)
 {
 	struct xfs_bufkey key = {NULL};
@@ -590,12 +590,12 @@ __libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
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
@@ -800,7 +800,7 @@ libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
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
 

