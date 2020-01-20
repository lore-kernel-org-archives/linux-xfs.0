Return-Path: <SRS0=roPR=3J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69BFBC32771
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B4EE22522
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:56:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BmJB+kRZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgATW4r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:56:47 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35710 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATW4q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jan 2020 17:56:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMtrw8076927;
        Mon, 20 Jan 2020 22:56:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=llIRl8tZTowKgmw5ZvgL7JrgRHq6f9yqlU8ixG4oAV4=;
 b=BmJB+kRZ8q6pmldkXMgeeWz5H9luxlfu7NswuUwnjcYFBfJh6Eojmcvj8Y8Ic9lNmKvU
 zsFLTIR2UqsKRehG2tqfLHyWHenw/6LIurjjwoO4Xq62s6tk+65hOu14c6STHbEfbQQ/
 zgIQ+lnJatzuwGZvM3zTjJhDihodAucyuqW9sAnHqC0n49qer2fbvC2+eAt/+/nLxFVu
 nGjzcI6TLDxbPoxloVhOsJS5LakncUIk9EZIRfH4lgFhatiYJ/OE4EKjIBCraVBiRCAR
 YPNolfhNvMAC+i++VDyDM/JN/PbF3JqcPFSM96tBbIBp7qBKtjm0AgpJU9xiSL/O+Wjm sA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xkseu9u36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:56:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMn3YO037042;
        Mon, 20 Jan 2020 22:56:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xmc5mc4mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:56:37 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00KMubij010155;
        Mon, 20 Jan 2020 22:56:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 14:56:36 -0800
Subject: [PATCH 01/13] xfs: make xfs_buf_alloc return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Christoph Hellwig <hch@lst.de>
Date:   Mon, 20 Jan 2020 14:56:35 -0800
Message-ID: <157956099569.1166689.10013865738301648123.stgit@magnolia>
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

Convert _xfs_buf_alloc() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a0229c368e78..f9a6cf71f4ab 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -198,20 +198,22 @@ xfs_buf_free_maps(
 	}
 }
 
-static struct xfs_buf *
+static int
 _xfs_buf_alloc(
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
-	xfs_buf_flags_t		flags)
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp)
 {
 	struct xfs_buf		*bp;
 	int			error;
 	int			i;
 
+	*bpp = NULL;
 	bp = kmem_zone_zalloc(xfs_buf_zone, KM_NOFS);
 	if (unlikely(!bp))
-		return NULL;
+		return -ENOMEM;
 
 	/*
 	 * We don't want certain flags to appear in b_flags unless they are
@@ -239,7 +241,7 @@ _xfs_buf_alloc(
 	error = xfs_buf_get_maps(bp, nmaps);
 	if (error)  {
 		kmem_cache_free(xfs_buf_zone, bp);
-		return NULL;
+		return error;
 	}
 
 	bp->b_bn = map[0].bm_bn;
@@ -256,7 +258,8 @@ _xfs_buf_alloc(
 	XFS_STATS_INC(bp->b_mount, xb_create);
 	trace_xfs_buf_init(bp, _RET_IP_);
 
-	return bp;
+	*bpp = bp;
+	return 0;
 }
 
 /*
@@ -715,8 +718,8 @@ xfs_buf_get_map(
 		return NULL;
 	}
 
-	new_bp = _xfs_buf_alloc(target, map, nmaps, flags);
-	if (unlikely(!new_bp))
+	error = _xfs_buf_alloc(target, map, nmaps, flags, &new_bp);
+	if (error)
 		return NULL;
 
 	error = xfs_buf_allocate_memory(new_bp, flags);
@@ -917,8 +920,8 @@ xfs_buf_get_uncached(
 	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
 
 	/* flags might contain irrelevant bits, pass only what we care about */
-	bp = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT);
-	if (unlikely(bp == NULL))
+	error = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT, &bp);
+	if (error)
 		goto fail;
 
 	page_count = PAGE_ALIGN(numblks << BBSHIFT) >> PAGE_SHIFT;

