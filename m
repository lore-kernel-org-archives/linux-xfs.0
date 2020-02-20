Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6991C5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B2FE24671
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:44:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eWxxAmf9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgBTBol (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:44:41 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46074 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBTBol (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:44:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1h0sH092840;
        Thu, 20 Feb 2020 01:44:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7w+mgv8q1L5EgjIVLownRH9uVa8CVoDydx8nXFjCH8k=;
 b=eWxxAmf9l/kHz7KZrKxyQlXsOwhW6hwMDE1l+efjwltDQvoDr2qVOQYE7xRsPZe80z4t
 ShRZd76wrExUTWAHg/TewdRHgG8SDWrUnPaiqQAFVvlo4lhPpKjRUk0m3SMrQbgwDkB3
 xX9u5sjfw8aHTgd29CIKeKG/yV89iPH2MxXukVHq0G0Cyr68oxsv+TdzcLVxqAseKp7r
 8T7JNseT1TP8WsCeKroYDOYQvGPRnS5KO5uv/S0KdHlt3GH54DxK+4SMGCmlzyQL1bff
 RfvRbNP5ql2iw9X4gO/i90KFMKsaDWVAOH0EnZw2gDzaYtdRDd3HfypaMZ6Fga/Vn/lR Qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2y8udd6tgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1h3mA190565;
        Thu, 20 Feb 2020 01:44:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y8ud974pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:44:37 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1iaTY006766;
        Thu, 20 Feb 2020 01:44:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:44:36 -0800
Subject: [PATCH 01/14] libxfs: make __cache_lookup return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:44:35 -0800
Message-ID: <158216307576.603628.2104009841729823514.stgit@magnolia>
In-Reply-To: <158216306957.603628.16404096061228456718.stgit@magnolia>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=820
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=874 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert __cache_lookup() to return numeric error codes like most
everywhere else in xfsprogs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/rdwr.c |   68 +++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 24 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 52674559..b686d1d5 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -715,30 +715,40 @@ struct list_head	lock_buf_list = {&lock_buf_list, &lock_buf_list};
 int			lock_buf_count = 0;
 #endif
 
-static struct xfs_buf *
-__cache_lookup(struct xfs_bufkey *key, unsigned int flags)
+static int
+__cache_lookup(
+	struct xfs_bufkey	*key,
+	unsigned int		flags,
+	struct xfs_buf		**bpp)
 {
-	struct xfs_buf	*bp;
+	struct cache_node	*cn = NULL;
+	struct xfs_buf		*bp;
 
-	cache_node_get(libxfs_bcache, key, (struct cache_node **)&bp);
-	if (!bp)
-		return NULL;
+	*bpp = NULL;
+
+	cache_node_get(libxfs_bcache, key, &cn);
+	if (!cn)
+		return -ENOMEM;
+	bp = container_of(cn, struct xfs_buf, b_node);
 
 	if (use_xfs_buf_lock) {
-		int ret;
+		int		ret;
 
 		ret = pthread_mutex_trylock(&bp->b_lock);
 		if (ret) {
 			ASSERT(ret == EAGAIN);
-			if (flags & LIBXFS_GETBUF_TRYLOCK)
-				goto out_put;
+			if (flags & LIBXFS_GETBUF_TRYLOCK) {
+				cache_node_put(libxfs_bcache, cn);
+				return -EAGAIN;
+			}
 
 			if (pthread_equal(bp->b_holder, pthread_self())) {
 				fprintf(stderr,
 	_("Warning: recursive buffer locking at block %" PRIu64 " detected\n"),
 					key->blkno);
 				bp->b_recur++;
-				return bp;
+				*bpp = bp;
+				return 0;
 			} else {
 				pthread_mutex_lock(&bp->b_lock);
 			}
@@ -747,9 +757,8 @@ __cache_lookup(struct xfs_bufkey *key, unsigned int flags)
 		bp->b_holder = pthread_self();
 	}
 
-	cache_node_set_priority(libxfs_bcache, (struct cache_node *)bp,
-		cache_node_get_priority((struct cache_node *)bp) -
-						CACHE_PREFETCH_PRIORITY);
+	cache_node_set_priority(libxfs_bcache, cn,
+			cache_node_get_priority(cn) - CACHE_PREFETCH_PRIORITY);
 #ifdef XFS_BUF_TRACING
 	pthread_mutex_lock(&libxfs_bcache->c_mutex);
 	lock_buf_count++;
@@ -762,10 +771,8 @@ __cache_lookup(struct xfs_bufkey *key, unsigned int flags)
 		bp, bp->b_bn, (long long)LIBXFS_BBTOOFF64(key->blkno));
 #endif
 
-	return bp;
-out_put:
-	cache_node_put(libxfs_bcache, (struct cache_node *)bp);
-	return NULL;
+	*bpp = bp;
+	return 0;
 }
 
 static struct xfs_buf *
@@ -775,13 +782,18 @@ libxfs_getbuf_flags(
 	int			len,
 	unsigned int		flags)
 {
-	struct xfs_bufkey key = {NULL};
+	struct xfs_bufkey	key = {NULL};
+	struct xfs_buf		*bp;
+	int			error;
 
 	key.buftarg = btp;
 	key.blkno = blkno;
 	key.bblen = len;
 
-	return __cache_lookup(&key, flags);
+	error = __cache_lookup(&key, flags, &bp);
+	if (error)
+		return NULL;
+	return bp;
 }
 
 /*
@@ -805,11 +817,16 @@ reset_buf_state(
 }
 
 static struct xfs_buf *
-__libxfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
-		    int nmaps, int flags)
+__libxfs_buf_get_map(
+	struct xfs_buftarg	*btp,
+	struct xfs_buf_map	*map,
+	int			nmaps,
+	int			flags)
 {
-	struct xfs_bufkey key = {NULL};
-	int i;
+	struct xfs_bufkey	key = {NULL};
+	struct xfs_buf		*bp;
+	int			i;
+	int			error;
 
 	if (nmaps == 1)
 		return libxfs_getbuf_flags(btp, map[0].bm_bn, map[0].bm_len,
@@ -823,7 +840,10 @@ __libxfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
 	key.map = map;
 	key.nmaps = nmaps;
 
-	return __cache_lookup(&key, flags);
+	error = __cache_lookup(&key, flags, &bp);
+	if (error)
+		return NULL;
+	return bp;
 }
 
 struct xfs_buf *

