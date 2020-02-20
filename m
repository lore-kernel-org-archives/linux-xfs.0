Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6484C5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2E2524671
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MANa0hRE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgBTBow (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:44:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46306 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbgBTBow (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:44:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gqS4092773;
        Thu, 20 Feb 2020 01:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=u2MApQRFzhLedPKb79in4TipXTwbK78MtwvG0BEsDAA=;
 b=MANa0hREDfYBbjWnjWi9bsFcNSdZSZR3KO0896Scwd/DfW0uaQvcr8aqa0rbBMapbEy2
 g2pSo/JSVg613ffVV3dJYG8+pX8o0A6HWWx+kwhr4QNLcuZGeIXH9V+dkvUhQ1M3HHN4
 v6OYRnrMLKOv4oz59oIplrSb4yPl5onqglYinM4R9ZxDYXhCvU5WkbDIg9//ENJC2dur
 EtSouAtPECay91xBxH8pvoWbEwBe/+0TqSV2CyevVrZ0Lo2HoE1LMYKFMdqqaAa718X4
 qNhN18M2y2YXD3GW0XQRmMlt2a9MDXEHRe8aZLJHJuRVy4tWriqB0TZ/EC8dRECLp20V aA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2y8udd6th0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1he0C114472;
        Thu, 20 Feb 2020 01:44:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2y8ud2g5ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:49 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01K1inpD028998;
        Thu, 20 Feb 2020 01:44:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:44:48 -0800
Subject: [PATCH 03/14] libxfs: make libxfs_buf_get_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:44:47 -0800
Message-ID: <158216308793.603628.12888791331568943049.stgit@magnolia>
In-Reply-To: <158216306957.603628.16404096061228456718.stgit@magnolia>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert libxfs_buf_get_map() to return numeric error codes like most
everywhere else in xfsprogs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h |   20 +++++++++----
 libxfs/rdwr.c      |   78 ++++++++++++++++++++++++++++------------------------
 libxfs/trans.c     |   16 +++++++----
 repair/prefetch.c  |    6 +++-
 4 files changed, 69 insertions(+), 51 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 2a451ab2..189db8d8 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -144,9 +144,9 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_buf_get(dev, daddr, len) \
 	libxfs_trace_getbuf(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (daddr), (len))
-#define libxfs_buf_get_map(dev, map, nmaps, flags) \
+#define libxfs_buf_get_map(dev, map, nmaps, flags, bpp) \
 	libxfs_trace_getbuf_map(__FUNCTION__, __FILE__, __LINE__, \
-			    (dev), (map), (nmaps), (flags))
+			    (dev), (map), (nmaps), (flags), (bpp))
 #define libxfs_buf_relse(buf) \
 	libxfs_trace_putbuf(__FUNCTION__, __FILE__, __LINE__, (buf))
 
@@ -161,8 +161,9 @@ void libxfs_trace_dirtybuf(const char *func, const char *file, int line,
 struct xfs_buf *libxfs_trace_getbuf(const char *func, const char *file,
 			int line, struct xfs_buftarg *btp, xfs_daddr_t daddr,
 			size_t len);
-extern xfs_buf_t *libxfs_trace_getbuf_map(const char *, const char *, int,
-			struct xfs_buftarg *, struct xfs_buf_map *, int, int);
+int libxfs_trace_getbuf_map(const char *func, const char *file, int line,
+			struct xfs_buftarg *btp, struct xfs_buf_map *map,
+			int nmaps, int flags, struct xfs_buf **bpp);
 extern void	libxfs_trace_putbuf (const char *, const char *, int,
 			xfs_buf_t *);
 
@@ -171,8 +172,8 @@ extern void	libxfs_trace_putbuf (const char *, const char *, int,
 extern xfs_buf_t *libxfs_buf_read_map(struct xfs_buftarg *, struct xfs_buf_map *,
 			int, int, const struct xfs_buf_ops *);
 void libxfs_buf_dirty(struct xfs_buf *bp, int flags);
-extern xfs_buf_t *libxfs_buf_get_map(struct xfs_buftarg *,
-			struct xfs_buf_map *, int, int);
+int libxfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *maps,
+			int nmaps, int flags, struct xfs_buf **bpp);
 void	libxfs_buf_relse(struct xfs_buf *);
 
 static inline struct xfs_buf*
@@ -181,9 +182,14 @@ libxfs_buf_get(
 	xfs_daddr_t		blkno,
 	size_t			numblks)
 {
+	struct xfs_buf		*bp;
+	int			error;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	return libxfs_buf_get_map(target, &map, 1, 0);
+	error = libxfs_buf_get_map(target, &map, 1, 0, &bp);
+	if (error)
+		return NULL;
+	return bp;
 }
 
 static inline struct xfs_buf*
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 6a7a66ae..4e1665c0 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -392,10 +392,9 @@ libxfs_log_header(
 xfs_buf_t	*libxfs_buf_read_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int, const struct xfs_buf_ops *);
 int		libxfs_writebuf(xfs_buf_t *, int);
-struct xfs_buf *libxfs_buf_get(struct xfs_buftarg *btp, xfs_daddr_t daddr,
-				size_t len);
-xfs_buf_t	*libxfs_buf_get_map(struct xfs_buftarg *, struct xfs_buf_map *,
-				int, int);
+int		libxfs_buf_get_map(struct xfs_buftarg *btp,
+				struct xfs_buf_map *maps, int nmaps, int flags,
+				struct xfs_buf **bpp);
 void		libxfs_buf_relse(struct xfs_buf *);
 
 #define	__add_trace(bp, func, file, line)	\
@@ -450,19 +449,27 @@ libxfs_trace_getbuf(
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	bp = libxfs_buf_get_map(target, &map, 1, 0);
+	libxfs_buf_get_map(target, &map, 1, 0, &bp);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
 
-xfs_buf_t *
-libxfs_trace_getbuf_map(const char *func, const char *file, int line,
-		struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
-		int flags)
+int
+libxfs_trace_getbuf_map(
+	const char		*func,
+	const char		*file,
+	int			line,
+	struct xfs_buftarg	*btp,
+	struct xfs_buf_map	*map,
+	int			nmaps,
+	int			flags,
+	struct xfs_buf		**bpp)
 {
-	xfs_buf_t	*bp = libxfs_buf_get_map(btp, map, nmaps, flags);
-	__add_trace(bp, func, file, line);
-	return bp;
+	int			error;
+
+	error = libxfs_buf_get_map(btp, map, nmaps, flags, bpp);
+	__add_trace(*bpp, func, file, line);
+	return error;
 }
 
 void
@@ -812,25 +819,20 @@ reset_buf_state(
 				LIBXFS_B_UPTODATE);
 }
 
-static struct xfs_buf *
+static int
 __libxfs_buf_get_map(
 	struct xfs_buftarg	*btp,
 	struct xfs_buf_map	*map,
 	int			nmaps,
-	int			flags)
+	int			flags,
+	struct xfs_buf		**bpp)
 {
 	struct xfs_bufkey	key = {NULL};
-	struct xfs_buf		*bp;
 	int			i;
-	int			error;
 
-	if (nmaps == 1) {
-		error = libxfs_getbuf_flags(btp, map[0].bm_bn, map[0].bm_len,
-				flags, &bp);
-		if (error)
-			return NULL;
-		return bp;
-	}
+	if (nmaps == 1)
+		return libxfs_getbuf_flags(btp, map[0].bm_bn, map[0].bm_len,
+				flags, bpp);
 
 	key.buftarg = btp;
 	key.blkno = map[0].bm_bn;
@@ -840,21 +842,25 @@ __libxfs_buf_get_map(
 	key.map = map;
 	key.nmaps = nmaps;
 
-	error = __cache_lookup(&key, flags, &bp);
-	if (error)
-		return NULL;
-	return bp;
+	return __cache_lookup(&key, flags, bpp);
 }
 
-struct xfs_buf *
-libxfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
-		  int nmaps, int flags)
+int
+libxfs_buf_get_map(
+	struct xfs_buftarg	*btp,
+	struct xfs_buf_map	*map,
+	int			nmaps,
+	int			flags,
+	struct xfs_buf		**bpp)
 {
-	struct xfs_buf	*bp;
+	int			error;
 
-	bp = __libxfs_buf_get_map(btp, map, nmaps, flags);
-	reset_buf_state(bp);
-	return bp;
+	error = __libxfs_buf_get_map(btp, map, nmaps, flags, bpp);
+	if (error)
+		return error;
+
+	reset_buf_state(*bpp);
+	return 0;
 }
 
 void
@@ -1056,8 +1062,8 @@ libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 		return libxfs_readbuf(btp, map[0].bm_bn, map[0].bm_len,
 					flags, ops);
 
-	bp = __libxfs_buf_get_map(btp, map, nmaps, 0);
-	if (!bp)
+	error = __libxfs_buf_get_map(btp, map, nmaps, 0, &bp);
+	if (error)
 		return NULL;
 
 	bp->b_error = 0;
diff --git a/libxfs/trans.c b/libxfs/trans.c
index f4ce23a7..a7407dc3 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -423,11 +423,16 @@ libxfs_trans_get_buf_map(
 	int			nmaps,
 	xfs_buf_flags_t		flags)
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	struct xfs_buf_log_item	*bip;
+	int			error;
 
-	if (!tp)
-		return libxfs_buf_get_map(target, map, nmaps, 0);
+	if (!tp) {
+		error = libxfs_buf_get_map(target, map, nmaps, 0, &bp);
+		if (error)
+			return NULL;
+		return bp;
+	}
 
 	/*
 	 * If we find the buffer in the cache with this transaction
@@ -445,10 +450,9 @@ libxfs_trans_get_buf_map(
 		return bp;
 	}
 
-	bp = libxfs_buf_get_map(target, map, nmaps, 0);
-	if (bp == NULL) {
+	error = libxfs_buf_get_map(target, map, nmaps, 0, &bp);
+	if (error)
 		return NULL;
-	}
 
 	ASSERT(!bp->b_error);
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 7f705cc0..587b3b1f 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -113,6 +113,7 @@ pf_queue_io(
 {
 	struct xfs_buf		*bp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, map[0].bm_bn);
+	int			error;
 
 	/*
 	 * Never block on a buffer lock here, given that the actual repair
@@ -120,8 +121,9 @@ pf_queue_io(
 	 * the lock holder is either reading it from disk himself or
 	 * completely overwriting it this behaviour is perfectly fine.
 	 */
-	bp = libxfs_buf_get_map(mp->m_dev, map, nmaps, LIBXFS_GETBUF_TRYLOCK);
-	if (!bp)
+	error = -libxfs_buf_get_map(mp->m_dev, map, nmaps, LIBXFS_GETBUF_TRYLOCK,
+			&bp);
+	if (error)
 		return;
 
 	if (bp->b_flags & LIBXFS_B_UPTODATE) {

