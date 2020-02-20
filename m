Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A8EC7619D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EA8B24671
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:45:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="so9FHxE/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgBTBpI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:45:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46524 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBTBpH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:45:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1hATt092876;
        Thu, 20 Feb 2020 01:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cY2xKTCyQ+SY2Ska22U2/GAscEnXm49dDYWKwZUhYzw=;
 b=so9FHxE/OaQ/CEZaD5FwOz3LwbqD2NuI+ErGAwU4FWIAmoY6YNIqqbat0kloVblhXYBQ
 JYxmJ5nfVwdgelz9DVxvJphhzDZDgAdGukQOfX8SxyUx1oRgmQhi77bBE3HA6Lf+U9L4
 n1uwfGWEmVsGlmx4yMhcPkrre1c1hUNPm80V3cxsWqQsp+ONEDrBtS7sKWhth6bNN18Y
 scJhmTKFJKSaa4HYAdX0MNkjpdWcNhTgrCKwoMUaDvEeHVJ9nEsnOkFhzAc+k8fVUhXj
 14FzZZ6QeSuuGKhxRHFKKO1AlMeQjj2uZiynlLQ53D1NBth66IirKyibyNpAP9QrIyWO Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2y8udd6thw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gFFm094525;
        Thu, 20 Feb 2020 01:45:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2y8udbmk6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:04 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01K1j4iX003826;
        Thu, 20 Feb 2020 01:45:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:45:04 -0800
Subject: [PATCH 05/14] libxfs: make libxfs_buf_read_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:45:01 -0800
Message-ID: <158216310149.603628.17465705830434897306.stgit@magnolia>
In-Reply-To: <158216306957.603628.16404096061228456718.stgit@magnolia>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=2 phishscore=0
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

Make libxfs_buf_read_map() and libxfs_readbuf() return an error code
instead of making callers guess what happened based on whether or not
they got a buffer back.

Add a new SALVAGE flag so that certain utilities (xfs_db and xfs_repair)
can attempt salvage operations even if the verifiers failed, which was
the behavior before this change.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/io.c            |    4 +--
 libxfs/libxfs_io.h |   25 ++++++++++++------
 libxfs/rdwr.c      |   72 ++++++++++++++++++++++++++++++++++++++++++----------
 libxfs/trans.c     |   24 ++++-------------
 repair/da_util.c   |    3 +-
 5 files changed, 84 insertions(+), 44 deletions(-)


diff --git a/db/io.c b/db/io.c
index b81e9969..5c9d72bb 100644
--- a/db/io.c
+++ b/db/io.c
@@ -542,8 +542,8 @@ set_cur(
 		if (!iocur_top->bbmap)
 			return;
 		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
-		bp = libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
-					bbmap->nmaps, 0, ops);
+		libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b, bbmap->nmaps,
+				LIBXFS_READBUF_SALVAGE, &bp, ops);
 	} else {
 		bp = libxfs_buf_read(mp->m_ddev_targp, blknum, len, 0, ops);
 		iocur_top->bbmap = NULL;
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 189db8d8..06847ad5 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -126,6 +126,8 @@ extern struct cache_operations	libxfs_bcache_operations;
 
 /* Exit on buffer read error */
 #define LIBXFS_READBUF_FAIL_EXIT	(1 << 0)
+/* Return the buffer even if the IO or verifier fail. */
+#define LIBXFS_READBUF_SALVAGE		(1 << 1)
 
 /* Exit on buffer write error */
 #define LIBXFS_WRITEBUF_FAIL_EXIT	(1 << 0)
@@ -135,9 +137,9 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_buf_read(dev, daddr, len, flags, ops) \
 	libxfs_trace_readbuf(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (daddr), (len), (flags), (ops))
-#define libxfs_buf_read_map(dev, map, nmaps, flags, ops) \
+#define libxfs_buf_read_map(dev, map, nmaps, flags, bpp, ops) \
 	libxfs_trace_readbuf_map(__FUNCTION__, __FILE__, __LINE__, \
-			    (dev), (map), (nmaps), (flags), (ops))
+			    (dev), (map), (nmaps), (flags), (bpp), (ops))
 #define libxfs_buf_dirty(buf, flags) \
 	libxfs_trace_dirtybuf(__FUNCTION__, __FILE__, __LINE__, \
 			      (buf), (flags))
@@ -153,9 +155,10 @@ extern struct cache_operations	libxfs_bcache_operations;
 struct xfs_buf *libxfs_trace_readbuf(const char *func, const char *file,
 			int line, struct xfs_buftarg *btp, xfs_daddr_t daddr,
 			size_t len, int flags, const struct xfs_buf_ops *ops);
-extern xfs_buf_t *libxfs_trace_readbuf_map(const char *, const char *, int,
-			struct xfs_buftarg *, struct xfs_buf_map *, int, int,
-			const struct xfs_buf_ops *);
+int libxfs_trace_readbuf_map(const char *func, const char *file, int line,
+			struct xfs_buftarg *btp, struct xfs_buf_map *maps,
+			int nmaps, int flags, struct xfs_buf **bpp,
+			const struct xfs_buf_ops *ops);
 void libxfs_trace_dirtybuf(const char *func, const char *file, int line,
 			struct xfs_buf *bp, int flags);
 struct xfs_buf *libxfs_trace_getbuf(const char *func, const char *file,
@@ -169,8 +172,9 @@ extern void	libxfs_trace_putbuf (const char *, const char *, int,
 
 #else
 
-extern xfs_buf_t *libxfs_buf_read_map(struct xfs_buftarg *, struct xfs_buf_map *,
-			int, int, const struct xfs_buf_ops *);
+int libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *maps,
+			int nmaps, int flags, struct xfs_buf **bpp,
+			const struct xfs_buf_ops *ops);
 void libxfs_buf_dirty(struct xfs_buf *bp, int flags);
 int libxfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *maps,
 			int nmaps, int flags, struct xfs_buf **bpp);
@@ -200,9 +204,14 @@ libxfs_buf_read(
 	xfs_buf_flags_t		flags,
 	const struct xfs_buf_ops *ops)
 {
+	struct xfs_buf		*bp;
+	int			error;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	return libxfs_buf_read_map(target, &map, 1, flags, ops);
+	error = libxfs_buf_read_map(target, &map, 1, flags, &bp, ops);
+	if (error)
+		return NULL;
+	return bp;
 }
 
 #endif /* XFS_BUF_TRACING */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 6eaa3e69..222ef441 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -389,8 +389,10 @@ libxfs_log_header(
 #undef libxfs_writebuf
 #undef libxfs_buf_get_map
 
-xfs_buf_t	*libxfs_buf_read_map(struct xfs_buftarg *, struct xfs_buf_map *,
-				int, int, const struct xfs_buf_ops *);
+int		libxfs_buf_read_map(struct xfs_buftarg *btp,
+				struct xfs_buf_map *maps, int nmaps, int flags,
+				struct xfs_buf **bpp,
+				const struct xfs_buf_ops *ops);
 int		libxfs_writebuf(xfs_buf_t *, int);
 int		libxfs_buf_get_map(struct xfs_buftarg *btp,
 				struct xfs_buf_map *maps, int nmaps, int flags,
@@ -420,11 +422,30 @@ libxfs_trace_readbuf(
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	bp = libxfs_buf_read_map(btp, &map, 1, flags, ops);
+	libxfs_buf_read_map(btp, &map, 1, flags, &bp, ops);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
 
+int
+libxfs_trace_readbuf_map(
+	const char		*func,
+	const char		*file,
+	int			line,
+	struct xfs_buftarg	*btp,
+	struct xfs_buf_map	*map,
+	int			nmaps,
+	int			flags,
+	struct xfs_buf		**bpp,
+	const struct xfs_buf_ops *ops)
+{
+	int			error;
+
+	error = libxfs_buf_read_map(btp, map, nmaps, flags, bpp, ops);
+	__add_trace(*bpp, func, file, line);
+	return error;
+}
+
 void
 libxfs_trace_dirtybuf(
 	const char		*func,
@@ -1004,20 +1025,27 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 	return error;
 }
 
-struct xfs_buf *
-libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
-		int flags, const struct xfs_buf_ops *ops)
+int
+libxfs_buf_read_map(
+	struct xfs_buftarg	*btp,
+	struct xfs_buf_map	*map,
+	int			nmaps,
+	int			flags,
+	struct xfs_buf		**bpp,
+	const struct xfs_buf_ops *ops)
 {
-	struct xfs_buf	*bp;
-	int		error = 0;
+	struct xfs_buf		*bp;
+	bool			salvage = flags & LIBXFS_READBUF_SALVAGE;
+	int			error = 0;
 
+	*bpp = NULL;
 	if (nmaps == 1)
 		error = libxfs_getbuf_flags(btp, map[0].bm_bn, map[0].bm_len,
 				0, &bp);
 	else
 		error = __libxfs_buf_get_map(btp, map, nmaps, 0, &bp);
 	if (error)
-		return NULL;
+		return error;
 
 	/*
 	 * if the buffer was prefetched, it is likely that it was not validated.
@@ -1030,12 +1058,17 @@ libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 	 * should not be dirtying unchecked buffers and therefore failing it
 	 * here because it's dirty and unchecked indicates we've screwed up
 	 * somewhere else.
+	 *
+	 * Note that if the caller passes in LIBXFS_READBUF_SALVAGE, that means
+	 * they want the buffer even if it contains error status.
 	 */
 	bp->b_error = 0;
 	if (bp->b_flags & (LIBXFS_B_UPTODATE | LIBXFS_B_DIRTY)) {
 		if (bp->b_flags & LIBXFS_B_UNCHECKED)
-			libxfs_readbuf_verify(bp, ops);
-		return bp;
+			error = libxfs_readbuf_verify(bp, ops);
+		if (error && !salvage)
+			goto err;
+		goto ok;
 	}
 
 	/*
@@ -1050,15 +1083,26 @@ libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 				flags);
 	else
 		error = libxfs_readbufr_map(btp, bp, flags);
-	if (!error)
-		libxfs_readbuf_verify(bp, ops);
+	if (error == -EIO && salvage)
+		goto ok;
+	if (error)
+		goto err;
+
+	error = libxfs_readbuf_verify(bp, ops);
+	if (error && !salvage)
+		goto err;
 
+ok:
 #ifdef IO_DEBUGX
 	printf("%lx: %s: read %lu bytes, error %d, blkno=%llu(%llu), %p\n",
 		pthread_self(), __FUNCTION__, buf - (char *)bp->b_addr, error,
 		(long long)LIBXFS_BBTOOFF64(bp->b_bn), (long long)bp->b_bn, bp);
 #endif
-	return bp;
+	*bpp = bp;
+	return 0;
+err:
+	libxfs_buf_relse(bp);
+	return error;
 }
 
 /* Allocate a raw uncached buffer. */
diff --git a/libxfs/trans.c b/libxfs/trans.c
index a7407dc3..b833e369 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -510,15 +510,8 @@ libxfs_trans_read_buf_map(
 
 	*bpp = NULL;
 
-	if (tp == NULL) {
-		bp = libxfs_buf_read_map(target, map, nmaps, flags, ops);
-		if (!bp) {
-			return (flags & XBF_TRYLOCK) ?  -EAGAIN : -ENOMEM;
-		}
-		if (bp->b_error)
-			goto out_relse;
-		goto done;
-	}
+	if (tp == NULL)
+		return libxfs_buf_read_map(target, map, nmaps, flags, bpp, ops);
 
 	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
 	if (bp) {
@@ -530,22 +523,15 @@ libxfs_trans_read_buf_map(
 		goto done;
 	}
 
-	bp = libxfs_buf_read_map(target, map, nmaps, flags, ops);
-	if (!bp) {
-		return (flags & XBF_TRYLOCK) ?  -EAGAIN : -ENOMEM;
-	}
-	if (bp->b_error)
-		goto out_relse;
+	error = libxfs_buf_read_map(target, map, nmaps, flags, &bp, ops);
+	if (error)
+		return error;
 
 	_libxfs_trans_bjoin(tp, bp, 1);
 done:
 	trace_xfs_trans_read_buf(bp->b_log_item);
 	*bpp = bp;
 	return 0;
-out_relse:
-	error = bp->b_error;
-	xfs_buf_relse(bp);
-	return error;
 }
 
 /*
diff --git a/repair/da_util.c b/repair/da_util.c
index ed2ec3ba..add93ad8 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -64,7 +64,8 @@ da_read_buf(
 		map[i].bm_bn = XFS_FSB_TO_DADDR(mp, bmp[i].startblock);
 		map[i].bm_len = XFS_FSB_TO_BB(mp, bmp[i].blockcount);
 	}
-	bp = libxfs_buf_read_map(mp->m_dev, map, nex, 0, ops);
+	libxfs_buf_read_map(mp->m_dev, map, nex, LIBXFS_READBUF_SALVAGE,
+			&bp, ops);
 	if (map != map_array)
 		free(map);
 	return bp;

