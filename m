Return-Path: <SRS0=roPR=3J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0105C32771
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8D6022522
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:59:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b7RXwNqe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgATW7X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:59:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37918 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATW7X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jan 2020 17:59:23 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMulnm077338;
        Mon, 20 Jan 2020 22:57:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=z0gVKdr7lcMhYLe0ch/spfb+NOGry8a935zYrezuCQ0=;
 b=b7RXwNqetTvIAuCsSIjaadlerrYNCg7/3OQ7+//po6sSEBGznE6ITkU4zrRlRWHYdAqx
 jYWWF9BMUVYg6KM7Gk8bL3F5m+P741ZYT5CSoo8sW5iMzKASwGQCtVCkfoecGYT2pPnD
 9O+/XUJfTsvz1Q1cIKuLbWBtJ9hSeMOJdh8VY7Bd+vklJqWoO23Z3eWoZ3bhoKPzBQHi
 WDm+BqgSDUmL+up3OJ8zgV/sBK/HTK2w0ncDBuev7DleLEIn9zfjw2VaKWevZicgF2ji
 ujdWed3mGgKJGOwaSDXZ1p2iO60fEXzLo/mkRmikI+5Al6KnMdpySvDtfMd3uYf7u4vy HA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseu9u42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:57:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMnBtE169354;
        Mon, 20 Jan 2020 22:57:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xmbj4m439-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:57:09 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00KMv9kj014488;
        Mon, 20 Jan 2020 22:57:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 14:57:09 -0800
Subject: [PATCH 06/13] xfs: make xfs_buf_get_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Christoph Hellwig <hch@lst.de>
Date:   Mon, 20 Jan 2020 14:57:07 -0800
Message-ID: <157956102788.1166689.16675641705986843081.stgit@magnolia>
In-Reply-To: <157956098906.1166689.13651975861399490259.stgit@magnolia>
References: <157956098906.1166689.13651975861399490259.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001200192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001200192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert xfs_buf_get_map() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c       |   46 +++++++++++++++++-----------------------------
 fs/xfs/xfs_buf.h       |   14 +++-----------
 fs/xfs/xfs_trans_buf.c |   14 +++++++++-----
 3 files changed, 29 insertions(+), 45 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 460821844ee5..306394300863 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -685,53 +685,39 @@ xfs_buf_incore(
  * cache hits, as metadata intensive workloads will see 3 orders of magnitude
  * more hits than misses.
  */
-struct xfs_buf *
+int
 xfs_buf_get_map(
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
-	xfs_buf_flags_t		flags)
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp)
 {
 	struct xfs_buf		*bp;
 	struct xfs_buf		*new_bp;
 	int			error = 0;
 
+	*bpp = NULL;
 	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
-
-	switch (error) {
-	case 0:
-		/* cache hit */
+	if (!error)
 		goto found;
-	case -EAGAIN:
-		/* cache hit, trylock failure, caller handles failure */
-		ASSERT(flags & XBF_TRYLOCK);
-		return NULL;
-	case -ENOENT:
-		/* cache miss, go for insert */
-		break;
-	case -EFSCORRUPTED:
-	default:
-		/*
-		 * None of the higher layers understand failure types
-		 * yet, so return NULL to signal a fatal lookup error.
-		 */
-		return NULL;
-	}
+	if (error != -ENOENT)
+		return error;
 
 	error = _xfs_buf_alloc(target, map, nmaps, flags, &new_bp);
 	if (error)
-		return NULL;
+		return error;
 
 	error = xfs_buf_allocate_memory(new_bp, flags);
 	if (error) {
 		xfs_buf_free(new_bp);
-		return NULL;
+		return error;
 	}
 
 	error = xfs_buf_find(target, map, nmaps, flags, new_bp, &bp);
 	if (error) {
 		xfs_buf_free(new_bp);
-		return NULL;
+		return error;
 	}
 
 	if (bp != new_bp)
@@ -744,7 +730,7 @@ xfs_buf_get_map(
 			xfs_warn(target->bt_mount,
 				"%s: failed to map pagesn", __func__);
 			xfs_buf_relse(bp);
-			return NULL;
+			return error;
 		}
 	}
 
@@ -757,7 +743,8 @@ xfs_buf_get_map(
 
 	XFS_STATS_INC(target->bt_mount, xb_get);
 	trace_xfs_buf_get(bp, flags, _RET_IP_);
-	return bp;
+	*bpp = bp;
+	return 0;
 }
 
 STATIC int
@@ -819,13 +806,14 @@ xfs_buf_read_map(
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
+	int			error;
 
 	flags |= XBF_READ;
 	*bpp = NULL;
 
-	bp = xfs_buf_get_map(target, map, nmaps, flags);
-	if (!bp)
-		return -ENOMEM;
+	error = xfs_buf_get_map(target, map, nmaps, flags, &bp);
+	if (error)
+		return error;
 
 	trace_xfs_buf_read(bp, flags, _RET_IP_);
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 14209db07684..d1908a5038a2 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -192,9 +192,8 @@ struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
 			   xfs_daddr_t blkno, size_t numblks,
 			   xfs_buf_flags_t flags);
 
-struct xfs_buf *xfs_buf_get_map(struct xfs_buftarg *target,
-			       struct xfs_buf_map *map, int nmaps,
-			       xfs_buf_flags_t flags);
+int xfs_buf_get_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
+		int nmaps, xfs_buf_flags_t flags, struct xfs_buf **bpp);
 int xfs_buf_read_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
 		int nmaps, xfs_buf_flags_t flags, struct xfs_buf **bpp,
 		const struct xfs_buf_ops *ops);
@@ -208,16 +207,9 @@ xfs_buf_get(
 	size_t			numblks,
 	struct xfs_buf		**bpp)
 {
-	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	*bpp = NULL;
-	bp = xfs_buf_get_map(target, &map, 1, 0);
-	if (!bp)
-		return -ENOMEM;
-
-	*bpp = bp;
-	return 0;
+	return xfs_buf_get_map(target, &map, 1, 0, bpp);
 }
 
 static inline int
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index a2af6dec310d..bf61e61b38c7 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -122,9 +122,14 @@ xfs_trans_get_buf_map(
 {
 	xfs_buf_t		*bp;
 	struct xfs_buf_log_item	*bip;
+	int			error;
 
-	if (!tp)
-		return xfs_buf_get_map(target, map, nmaps, flags);
+	if (!tp) {
+		error = xfs_buf_get_map(target, map, nmaps, flags, &bp);
+		if (error)
+			return NULL;
+		return bp;
+	}
 
 	/*
 	 * If we find the buffer in the cache with this transaction
@@ -149,10 +154,9 @@ xfs_trans_get_buf_map(
 		return bp;
 	}
 
-	bp = xfs_buf_get_map(target, map, nmaps, flags);
-	if (bp == NULL) {
+	error = xfs_buf_get_map(target, map, nmaps, flags, &bp);
+	if (error)
 		return NULL;
-	}
 
 	ASSERT(!bp->b_error);
 

