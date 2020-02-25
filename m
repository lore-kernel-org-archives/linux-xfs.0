Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9683BC35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B54121927
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:14:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MlZeNp2A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgBYAOW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:14:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50900 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAOV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:14:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08JOC050371;
        Tue, 25 Feb 2020 00:14:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=MHNEa4DOAbys+A/Yt1AFdgaNBXivyNzOXcICfrGRpsA=;
 b=MlZeNp2ArFKS+0IDBB9fpj5OxRswDcvOR6Y1PRW0RDNADeyagfDGrafGsPlarXQudH4I
 yexE971A/meAejQ5ySbXgZVv0moiVP8xPN11M+uCk7m/Q9rel2p1qJvIKgC5Y4LbcoNA
 HAZtPODTMTIMGSovnfRsqICnN98DIwScgy6YlxW+pmvnK2omCXFQFBQaH07k5NAgo+LM
 IH2VgrjAMbtdL6+GBZ48wmJ2pxGRlr+7IUsJWu8RMqvCTJ9Do3PVoKd3medt/MGBZTj6
 2wSw91qcjqMCnX4rToz1ZaVneojw6Tjxo/XuDJtNgj/wFJIKrp902bkBJD/Yo9FmLtVh Xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q3mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:14:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07vmK109207;
        Tue, 25 Feb 2020 00:14:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ybe12es92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:14:17 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0EGQl032329;
        Tue, 25 Feb 2020 00:14:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:14:16 -0800
Subject: [PATCH 01/14] libxfs: make __cache_lookup return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Mon, 24 Feb 2020 16:14:15 -0800
Message-ID: <158258965555.453666.5811586113744867179.stgit@magnolia>
In-Reply-To: <158258964941.453666.10913737544282124969.stgit@magnolia>
References: <158258964941.453666.10913737544282124969.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=816 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=873 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert __cache_lookup() to return numeric error codes like most
everywhere else in xfsprogs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/rdwr.c |   68 +++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 24 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index ce31e45d..955284d0 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -478,30 +478,40 @@ struct list_head	lock_buf_list = {&lock_buf_list, &lock_buf_list};
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
@@ -510,9 +520,8 @@ __cache_lookup(struct xfs_bufkey *key, unsigned int flags)
 		bp->b_holder = pthread_self();
 	}
 
-	cache_node_set_priority(libxfs_bcache, &bp->b_node,
-			cache_node_get_priority(&bp->b_node) -
-						CACHE_PREFETCH_PRIORITY);
+	cache_node_set_priority(libxfs_bcache, cn,
+			cache_node_get_priority(cn) - CACHE_PREFETCH_PRIORITY);
 #ifdef XFS_BUF_TRACING
 	pthread_mutex_lock(&libxfs_bcache->c_mutex);
 	lock_buf_count++;
@@ -525,10 +534,8 @@ __cache_lookup(struct xfs_bufkey *key, unsigned int flags)
 		bp, bp->b_bn, (long long)LIBXFS_BBTOOFF64(key->blkno));
 #endif
 
-	return bp;
-out_put:
-	cache_node_put(libxfs_bcache, &bp->b_node);
-	return NULL;
+	*bpp = bp;
+	return 0;
 }
 
 static struct xfs_buf *
@@ -538,13 +545,18 @@ libxfs_getbuf_flags(
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
@@ -568,11 +580,16 @@ reset_buf_state(
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
@@ -586,7 +603,10 @@ __libxfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
 	key.map = map;
 	key.nmaps = nmaps;
 
-	return __cache_lookup(&key, flags);
+	error = __cache_lookup(&key, flags, &bp);
+	if (error)
+		return NULL;
+	return bp;
 }
 
 struct xfs_buf *

