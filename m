Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F2A1C2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43AAD2071A
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:19:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ci5sVZfx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgAXFTU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 00:19:20 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39056 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgAXFTU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 00:19:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5IIip033695;
        Fri, 24 Jan 2020 05:19:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=KRLRAn1aDUN54Qjdleg4TtP45YTTGxhVyqFXcbCVl2Q=;
 b=ci5sVZfxvMAGSHG/HZdt37LFrzoXXMoKcUCdhDRiOUThDgXv+oyF/yiL+ThmUkptov/a
 uuHFBKO7f9CvV/OHAvJ0fGs02PBrjTIkfiFIvArEk9noaNGq0YTBDKkMs206rfz4cM6w
 ioNOPzufpNxzGMP6G40Dna/2Q7Awy0hWKr6EIFiCcv713MraKDA9TMfoC2+mSg3syEad
 vLR32aHcf9Qyln4d9vaEatcez/kumb2fL27jEymujrVYmvIWl7xQ8mFnaDi2yXYYvpq5
 L+VV6r4vfvZkQ5An8ot61BkHTqVm3YSPjhj27hAxQ2jpwKxbpNLVhIuQfpPxG4buTKGl IA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnrps2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:19:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5IIV8031262;
        Fri, 24 Jan 2020 05:19:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xqmwckt1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:19:10 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O5JAWL020546;
        Fri, 24 Jan 2020 05:19:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 21:19:10 -0800
Subject: [PATCH 02/12] xfs: make xfs_buf_get_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Thu, 23 Jan 2020 21:19:08 -0800
Message-ID: <157984314875.3139258.14065126701620712857.stgit@magnolia>
In-Reply-To: <157984313582.3139258.1136501362141645797.stgit@magnolia>
References: <157984313582.3139258.1136501362141645797.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert xfs_buf_get_map() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c       |   44 ++++++++++++++++----------------------------
 fs/xfs/xfs_buf.h       |   13 +++++++++----
 fs/xfs/xfs_trans_buf.c |   14 +++++++++-----
 3 files changed, 34 insertions(+), 37 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f9a6cf71f4ab..5c07b4a70026 100644
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
@@ -818,11 +805,12 @@ xfs_buf_read_map(
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
+	int			error;
 
 	flags |= XBF_READ;
 
-	bp = xfs_buf_get_map(target, map, nmaps, flags);
-	if (!bp)
+	error = xfs_buf_get_map(target, map, nmaps, flags, &bp);
+	if (error)
 		return NULL;
 
 	trace_xfs_buf_read(bp, flags, _RET_IP_);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 56e081dd1d96..25dd2aa4322b 100644
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
 struct xfs_buf *xfs_buf_read_map(struct xfs_buftarg *target,
 			       struct xfs_buf_map *map, int nmaps,
 			       xfs_buf_flags_t flags,
@@ -209,8 +208,14 @@ xfs_buf_get(
 	xfs_daddr_t		blkno,
 	size_t			numblks)
 {
+	struct xfs_buf		*bp;
+	int			error;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return xfs_buf_get_map(target, &map, 1, 0);
+
+	error = xfs_buf_get_map(target, &map, 1, 0, &bp);
+	if (error)
+		return NULL;
+	return bp;
 }
 
 static inline struct xfs_buf *
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index b5b3a78ef31c..288333fef13a 100644
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
 

