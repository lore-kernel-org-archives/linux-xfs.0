Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9CCAC33CB3
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 857B9214AF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:04:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S/d47Kgk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAOREh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:04:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36058 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728904AbgAOREg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:04:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhx02193447;
        Wed, 15 Jan 2020 17:04:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4KV6JUPU3EU3zx8ESixSehX+g8icXjnwvvT8csixccY=;
 b=S/d47KgkUCv419yevlJSD1n23i+5ejd3qYNnn+flhlIJH1ndoE4Z8pu8m7rnWWqFIzSt
 or7X0DCaboYExVw1DBlJ8wIhP3RTJOpPoO6L/D1iX6761KCnZOO61c6ZvP3gumupn+Yb
 TH2WeKRtuUZ+ArFKt/gTfTDxy1gmsx48z1dbilOOOiWM7J+qF6HEKVzDpLGeMRuZNY7h
 EDjGy/fjf5gsCMYJWSYzY+hj0R68XVnJLNEx7AXVTQuYivMPJKDvQOtVilJhMh3XxnK3
 A2mExKCODIRpdpxQojo3+n/JS9AU7v65i8eNOwVy59aTF29wewls34yfpjX7F3i5xK3G Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xf73twbjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:04:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGiMoF056773;
        Wed, 15 Jan 2020 17:04:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xhy21r4tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:04:19 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00FH4J5v012257;
        Wed, 15 Jan 2020 17:04:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:04:18 -0800
Subject: [PATCH 6/9] xfs: make xfs_buf_get_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 15 Jan 2020 09:04:17 -0800
Message-ID: <157910785745.2028217.13992797354402280050.stgit@magnolia>
In-Reply-To: <157910781961.2028217.1250106765923436515.stgit@magnolia>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=991
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert xfs_buf_get_map() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c       |   45 ++++++++++++++++++++++-----------------------
 fs/xfs/xfs_buf.h       |    5 ++---
 fs/xfs/xfs_trans_buf.c |   14 +++++++++-----
 3 files changed, 33 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1a3dfecb93e0..d974954b4fc9 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -684,53 +684,49 @@ xfs_buf_incore(
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
 
 	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
-
 	switch (error) {
 	case 0:
 		/* cache hit */
 		goto found;
-	case -EAGAIN:
-		/* cache hit, trylock failure, caller handles failure */
-		ASSERT(flags & XBF_TRYLOCK);
-		return NULL;
 	case -ENOENT:
 		/* cache miss, go for insert */
 		break;
+	case -EAGAIN:
+		/* cache hit, trylock failure, caller handles failure */
+		ASSERT(flags & XBF_TRYLOCK);
+		/* fall through */
 	case -EFSCORRUPTED:
 	default:
-		/*
-		 * None of the higher layers understand failure types
-		 * yet, so return NULL to signal a fatal lookup error.
-		 */
-		return NULL;
+		return error;
 	}
 
 	error = _xfs_buf_alloc(target, map, nmaps, flags, &new_bp);
 	if (unlikely(error))
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
@@ -743,7 +739,7 @@ xfs_buf_get_map(
 			xfs_warn(target->bt_mount,
 				"%s: failed to map pagesn", __func__);
 			xfs_buf_relse(bp);
-			return NULL;
+			return error;
 		}
 	}
 
@@ -756,7 +752,8 @@ xfs_buf_get_map(
 
 	XFS_STATS_INC(target->bt_mount, xb_get);
 	trace_xfs_buf_get(bp, flags, _RET_IP_);
-	return bp;
+	*bpp = bp;
+	return 0;
 }
 
 int
@@ -767,11 +764,12 @@ xfs_buf_get(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_buf		*bp;
+	int			error;
 
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	bp = xfs_buf_get_map(target, &map, 1, 0);
-	if (!bp)
-		return -ENOMEM;
+	error = xfs_buf_get_map(target, &map, 1, 0, &bp);
+	if (error)
+		return error;
 
 	*bpp = bp;
 	return 0;
@@ -836,12 +834,13 @@ xfs_buf_read_map(
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
+	int			error;
 
 	flags |= XBF_READ;
 
-	bp = xfs_buf_get_map(target, map, nmaps, flags);
-	if (!bp)
-		return -ENOMEM;
+	error = xfs_buf_get_map(target, map, nmaps, flags, &bp);
+	if (error)
+		return error;
 
 	trace_xfs_buf_read(bp, flags, _RET_IP_);
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 7e01d168e437..8702e9099468 100644
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
 

