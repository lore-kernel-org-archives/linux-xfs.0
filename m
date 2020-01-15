Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27ADC32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7A07214AF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:04:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="do6mcd1q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgAORE1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:04:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35854 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728904AbgAORE1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:04:27 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhO4s193062;
        Wed, 15 Jan 2020 17:04:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=m3iPv/JT0U1ktP7yhv/RWPoKNpOkfhulf8EY8XfTc3g=;
 b=do6mcd1q8CsgwkYPtQ0G+WzSgbYMGnKTY/XQv3Hi0rSgRgYpQLCN8Uv2orEcTVc7VDV8
 brEAeufrbsdw3eLojMaicSGhemExrE99zGKszixSIGG0dculMmVBb3ahsO5jqrvxDF+z
 tzGAPF5dQs67ctGceac3MvpwXFzS7VTxnEMqJaHKe5tSxUqTxVWLLPzJuuq9D9pHNvAH
 6Nc7vghvEh7UrZgBnqPEk72RN7hOostkPaeQJksvvBkRlOb3bidJl1BnKDdJIy1PzNKe
 XpqTb4cf2IJXEjp6C3GPEtc9Re50678Q/x1weYUHFaUW+uX8SC154SZjQGJTX1h7qYvA eQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xf73twbh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:04:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGiPws085017;
        Wed, 15 Jan 2020 17:04:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xj61k3gwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:04:07 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00FH46M9001764;
        Wed, 15 Jan 2020 17:04:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:04:05 -0800
Subject: [PATCH 4/9] xfs: make xfs_buf_get_uncached return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 15 Jan 2020 09:04:04 -0800
Message-ID: <157910784485.2028217.10962836272956021894.stgit@magnolia>
In-Reply-To: <157910781961.2028217.1250106765923436515.stgit@magnolia>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
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

Convert xfs_buf_get_uncached() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ag.c |   21 ++++++++++++---------
 fs/xfs/xfs_buf.c       |   23 ++++++++++++++---------
 fs/xfs/xfs_buf.h       |    4 ++--
 3 files changed, 28 insertions(+), 20 deletions(-)


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
index 643173cc58f6..a7d538b89bb5 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -932,12 +932,13 @@ xfs_buf_read_uncached(
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
@@ -948,7 +949,7 @@ xfs_buf_read_uncached(
 
 	xfs_buf_submit(bp);
 	if (bp->b_error) {
-		int	error = bp->b_error;
+		error = bp->b_error;
 		xfs_buf_relse(bp);
 		return error;
 	}
@@ -957,11 +958,12 @@ xfs_buf_read_uncached(
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
@@ -980,8 +982,10 @@ xfs_buf_get_uncached(
 
 	for (i = 0; i < page_count; i++) {
 		bp->b_pages[i] = alloc_page(xb_to_gfp(flags));
-		if (!bp->b_pages[i])
+		if (!bp->b_pages[i]) {
+			error = -ENOMEM;
 			goto fail_free_mem;
+		}
 	}
 	bp->b_flags |= _XBF_PAGES;
 
@@ -993,7 +997,8 @@ xfs_buf_get_uncached(
 	}
 
 	trace_xfs_buf_get_uncached(bp, _RET_IP_);
-	return bp;
+	*bpp = bp;
+	return 0;
 
  fail_free_mem:
 	while (--i >= 0)
@@ -1003,7 +1008,7 @@ xfs_buf_get_uncached(
 	xfs_buf_free_maps(bp);
 	kmem_cache_free(xfs_buf_zone, bp);
  fail:
-	return NULL;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 267b35daf662..e0e8b0769758 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -221,8 +221,8 @@ xfs_buf_readahead(
 	return xfs_buf_readahead_map(target, &map, 1, ops);
 }
 
-struct xfs_buf *xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
-				int flags);
+int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks, int flags,
+		struct xfs_buf **bpp);
 int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
 			  size_t numblks, int flags, struct xfs_buf **bpp,
 			  const struct xfs_buf_ops *ops);

