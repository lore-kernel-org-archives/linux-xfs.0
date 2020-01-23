Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D291C33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2979F206D4
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:42:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V5VtcV92"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgAWHmZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 02:42:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53586 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgAWHmZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 02:42:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7cxGB131865;
        Thu, 23 Jan 2020 07:42:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=qXeub4Zt7707KFPGLDtDUwefgBwUh8ROUBDg9enNbuo=;
 b=V5VtcV92CIRKwxP+4YJHcHHQj3hBXk+yH81wMn2sywV3FJgLKdpnywaghm32DfkGYXgq
 h61LL8q16uCVNdiT/CCygjUl9AWUiUMf1+GSLYGV+y7z0IILTMInWvrligDpLkKx+ug2
 WxkkAPto1GmGkSAi/QZiKngj02sudKj9mVQzElHn3Q2Jn79wIlKKVKX1tVWr94woZu5f
 hwwiOEbn8z+e3nhCQMHCeuQtX3NCQTo6299NhKaEKue6321S9f2ctVdf68GtSIzpSKhE
 9SGizmA2Ho/pdumF6zYFty+SZcTjQxa5TQsKKGHjFndJH4AGsiO9IO2Wo/uLeVYFovKX Bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xksyqgf3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:42:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7cWs2062234;
        Thu, 23 Jan 2020 07:42:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xppq50mqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:42:17 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00N7gGpP031356;
        Thu, 23 Jan 2020 07:42:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 23:42:16 -0800
Subject: [PATCH 04/12] xfs: make xfs_buf_get_uncached return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 22 Jan 2020 23:42:16 -0800
Message-ID: <157976533613.2388944.1351398727913366535.stgit@magnolia>
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

Convert xfs_buf_get_uncached() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c |   21 ++++++++++++---------
 fs/xfs/xfs_buf.c       |   25 ++++++++++++++++---------
 fs/xfs/xfs_buf.h       |    4 ++--
 3 files changed, 30 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 14fbdf22b7e7..08d6beb54f8c 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -23,25 +23,28 @@
 #include "xfs_ag_resv.h"
 #include "xfs_health.h"
 
-static struct xfs_buf *
+static int
 xfs_get_aghdr_buf(
 	struct xfs_mount	*mp,
 	xfs_daddr_t		blkno,
 	size_t			numblks,
+	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
+	int			error;
 
-	bp = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, 0);
-	if (!bp)
-		return NULL;
+	error = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, 0, &bp);
+	if (error)
+		return error;
 
 	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
 	bp->b_bn = blkno;
 	bp->b_maps[0].bm_bn = blkno;
 	bp->b_ops = ops;
 
-	return bp;
+	*bpp = bp;
+	return 0;
 }
 
 static inline bool is_log_ag(struct xfs_mount *mp, struct aghdr_init_data *id)
@@ -340,13 +343,13 @@ xfs_ag_init_hdr(
 	struct aghdr_init_data	*id,
 	aghdr_init_work_f	work,
 	const struct xfs_buf_ops *ops)
-
 {
 	struct xfs_buf		*bp;
+	int			error;
 
-	bp = xfs_get_aghdr_buf(mp, id->daddr, id->numblks, ops);
-	if (!bp)
-		return -ENOMEM;
+	error = xfs_get_aghdr_buf(mp, id->daddr, id->numblks, &bp, ops);
+	if (error)
+		return error;
 
 	(*work)(mp, bp, id);
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f9a6cf71f4ab..09b8f00d4182 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -883,12 +883,13 @@ xfs_buf_read_uncached(
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
+	int			error;
 
 	*bpp = NULL;
 
-	bp = xfs_buf_get_uncached(target, numblks, flags);
-	if (!bp)
-		return -ENOMEM;
+	error = xfs_buf_get_uncached(target, numblks, flags, &bp);
+	if (error)
+		return error;
 
 	/* set up the buffer for a read IO */
 	ASSERT(bp->b_map_count == 1);
@@ -899,7 +900,7 @@ xfs_buf_read_uncached(
 
 	xfs_buf_submit(bp);
 	if (bp->b_error) {
-		int	error = bp->b_error;
+		error = bp->b_error;
 		xfs_buf_relse(bp);
 		return error;
 	}
@@ -908,17 +909,20 @@ xfs_buf_read_uncached(
 	return 0;
 }
 
-xfs_buf_t *
+int
 xfs_buf_get_uncached(
 	struct xfs_buftarg	*target,
 	size_t			numblks,
-	int			flags)
+	int			flags,
+	struct xfs_buf		**bpp)
 {
 	unsigned long		page_count;
 	int			error, i;
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
 
+	*bpp = NULL;
+
 	/* flags might contain irrelevant bits, pass only what we care about */
 	error = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT, &bp);
 	if (error)
@@ -931,8 +935,10 @@ xfs_buf_get_uncached(
 
 	for (i = 0; i < page_count; i++) {
 		bp->b_pages[i] = alloc_page(xb_to_gfp(flags));
-		if (!bp->b_pages[i])
+		if (!bp->b_pages[i]) {
+			error = -ENOMEM;
 			goto fail_free_mem;
+		}
 	}
 	bp->b_flags |= _XBF_PAGES;
 
@@ -944,7 +950,8 @@ xfs_buf_get_uncached(
 	}
 
 	trace_xfs_buf_get_uncached(bp, _RET_IP_);
-	return bp;
+	*bpp = bp;
+	return 0;
 
  fail_free_mem:
 	while (--i >= 0)
@@ -954,7 +961,7 @@ xfs_buf_get_uncached(
 	xfs_buf_free_maps(bp);
 	kmem_cache_free(xfs_buf_zone, bp);
  fail:
-	return NULL;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index fe9ad8ee4eea..eace3e285157 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -254,8 +254,8 @@ xfs_buf_readahead(
 	return xfs_buf_readahead_map(target, &map, 1, ops);
 }
 
-struct xfs_buf *xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
-				int flags);
+int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks, int flags,
+		struct xfs_buf **bpp);
 int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
 			  size_t numblks, int flags, struct xfs_buf **bpp,
 			  const struct xfs_buf_ops *ops);

