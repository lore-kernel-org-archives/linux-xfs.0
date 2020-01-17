Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC30EC33CB1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABB4920748
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:24:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H7xT/NOM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgAQGYM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 01:24:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45400 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgAQGYM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 01:24:12 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H68Lsi150023;
        Fri, 17 Jan 2020 06:24:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=yB9Z6nEYvwqxrYX+AMDSojOFaQLitEMbL0rh5rTU6XE=;
 b=H7xT/NOMKR60tDAQeIh/87Bri5BIGDqi+e23mPtF5puEB3T6hqekp54fCbYuZDd5ppe2
 EMwyaXzIb3Hh9vsw26DaYT+ghZqEnThnefKxVsK8WFh7OLGTWohOWiBJkSS9tXIRm4W5
 3y6wzhp4HLBwBzZsyFINMw1dhLbAT7uSmifdEGxvM/Yy6Q2KLnGcD68Qrgf9p1P8OLfw
 XwsS0O25hqTa3orbIk8crDy9lpuuXMpy5aTW5CwXzT1x7sHTh7x/SnM/bOOzj7Ax1Dd+
 bPzLxDODUrK998tCJYM+ytGV+zFJ5BK85lf4u89c+ZS/TQ8U9kYTTDExQwFn3myYhUkm Pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xf73u6rd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:24:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H69HY0076148;
        Fri, 17 Jan 2020 06:24:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xk230ayee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:24:05 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00H6O4fh002581;
        Fri, 17 Jan 2020 06:24:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 22:24:04 -0800
Subject: [PATCH 04/11] xfs: make xfs_buf_get_uncached return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Date:   Thu, 16 Jan 2020 22:24:00 -0800
Message-ID: <157924224022.3029431.2705280258976638026.stgit@magnolia>
In-Reply-To: <157924221149.3029431.1461924548648810370.stgit@magnolia>
References: <157924221149.3029431.1461924548648810370.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170048
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
index 8c9cd1ab870b..8778c4b38af7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -916,12 +916,13 @@ xfs_buf_read_uncached(
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
@@ -932,7 +933,7 @@ xfs_buf_read_uncached(
 
 	xfs_buf_submit(bp);
 	if (bp->b_error) {
-		int	error = bp->b_error;
+		error = bp->b_error;
 		xfs_buf_relse(bp);
 		return error;
 	}
@@ -941,17 +942,20 @@ xfs_buf_read_uncached(
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
 	if (unlikely(error))
@@ -964,8 +968,10 @@ xfs_buf_get_uncached(
 
 	for (i = 0; i < page_count; i++) {
 		bp->b_pages[i] = alloc_page(xb_to_gfp(flags));
-		if (!bp->b_pages[i])
+		if (!bp->b_pages[i]) {
+			error = -ENOMEM;
 			goto fail_free_mem;
+		}
 	}
 	bp->b_flags |= _XBF_PAGES;
 
@@ -977,7 +983,8 @@ xfs_buf_get_uncached(
 	}
 
 	trace_xfs_buf_get_uncached(bp, _RET_IP_);
-	return bp;
+	*bpp = bp;
+	return 0;
 
  fail_free_mem:
 	while (--i >= 0)
@@ -987,7 +994,7 @@ xfs_buf_get_uncached(
 	xfs_buf_free_maps(bp);
 	kmem_cache_free(xfs_buf_zone, bp);
  fail:
-	return NULL;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index f957d734e4b6..1ee516ef2c66 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -237,8 +237,8 @@ xfs_buf_readahead(
 	return xfs_buf_readahead_map(target, &map, 1, ops);
 }
 
-struct xfs_buf *xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
-				int flags);
+int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks, int flags,
+		struct xfs_buf **bpp);
 int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
 			  size_t numblks, int flags, struct xfs_buf **bpp,
 			  const struct xfs_buf_ops *ops);

