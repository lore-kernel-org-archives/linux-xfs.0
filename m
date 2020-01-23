Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C5FC33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 918B92467B
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dMaVE0K2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgAWHmk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 02:42:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53760 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgAWHmk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 02:42:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7cAwR131351;
        Thu, 23 Jan 2020 07:42:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/pUN5DFKNAiq6DWlTYIUd8Qq/ORwqelMWo2fBjjNWy4=;
 b=dMaVE0K2iFnftFpxl89IOpwmJ1u+l0r3LHmr6gQS5dl8kNrqbkNb07SaALJjFClhMuTY
 DJ8ochfToA1LUIG8j1MVnZxoX+P75P/folKvkHVFZqTpKIXLnk6//0A3pbefwe5xFQZh
 Wd5dCultoVLMyISPqIW91uWXfXNCyGx4e87IE7K12l5rIr15XZVVcBsnNl25OaIl82e6
 nUz/g0mhKkvbFkeLT5pVH8Cd1K4rtfIxgvKULn5dc9XKbrdaIJnGc8ienhOhUoAhmsly
 lPLKVtDlRrXnNUvh+T8zwOm+U3wR6FrcsyScUd5I23jyn/HaZPoMgTg+djlTiyNebvKe MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xksyqgf4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:42:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7c47b061087;
        Thu, 23 Jan 2020 07:42:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xpt6npr9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:42:30 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00N7gTHd031582;
        Thu, 23 Jan 2020 07:42:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 23:42:29 -0800
Subject: [PATCH 06/12] xfs: make xfs_buf_get_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 22 Jan 2020 23:42:28 -0800
Message-ID: <157976534890.2388944.14969629266800731586.stgit@magnolia>
In-Reply-To: <157976531016.2388944.3654360225810285604.stgit@magnolia>
References: <157976531016.2388944.3654360225810285604.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230065
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
 fs/xfs/xfs_buf.c       |   45 ++++++++++++++++-----------------------------
 fs/xfs/xfs_buf.h       |   14 +++-----------
 fs/xfs/xfs_trans_buf.c |   14 +++++++++-----
 3 files changed, 28 insertions(+), 45 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8a1c5c705b29..b420e865b32e 100644
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
@@ -824,9 +811,9 @@ xfs_buf_read_map(
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
index 56e7f8126cd7..6b7ef9dc167d 100644
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
 

