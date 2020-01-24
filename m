Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA48FC2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 793E72071A
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:19:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="evFKquWo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgAXFT6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 00:19:58 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54824 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729253AbgAXFT6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 00:19:58 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5INZB021946;
        Fri, 24 Jan 2020 05:19:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ViMzKXqFbBHa8d3XNdyj+IMAE2VndRQmQu6VCZZ76Q0=;
 b=evFKquWovqZ8yoBuxbfAuKV0tTjRh3zo0VCWqRFHRqX1QlYD7BQRmUIB0v6u5Ba2lHai
 qYkQcpkmpsx5wvT6kRuNmvNU6Wvbnuuq0xz2q4KPuSCDiHx/ewvBYrCfWJYQY4SEcSk4
 7XP7PIRjDJGwVa3DW6nsQynoV85J7B1raRUBJphUzhrax5nDW8QVDcuDs5NfaMufZLUe
 GEomAz9y+vI0S7qk0xzaI2oNM0zyKngG2tox/OTPtJdIECc/mR34kHRiEHcc+zUC3sCO
 X3xunp9FBmE5eSSjBGLGgbbKO0pgGuGrP6HOnOWfU5pTxaR9H1rG+Z37xzTJut9E0MK7 uQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xksyqpxpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:19:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5IL8G118685;
        Fri, 24 Jan 2020 05:19:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xqmue4duj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:19:44 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O5JhZd002564;
        Fri, 24 Jan 2020 05:19:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 21:19:42 -0800
Subject: [PATCH 07/12] xfs: make xfs_trans_get_buf_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Date:   Thu, 23 Jan 2020 21:19:41 -0800
Message-ID: <157984318148.3139258.8020548003607836921.stgit@magnolia>
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

Convert xfs_trans_get_buf_map() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_da_btree.c |    8 ++------
 fs/xfs/xfs_trans.h           |   15 ++++++++++-----
 fs/xfs/xfs_trans_buf.c       |   22 +++++++++++-----------
 3 files changed, 23 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 8c3eafe280ed..875e04f82541 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2591,13 +2591,9 @@ xfs_da_get_buf(
 	if (error || nmap == 0)
 		goto out_free;
 
-	bp = xfs_trans_get_buf_map(tp, mp->m_ddev_targp, mapp, nmap, 0);
-	error = bp ? bp->b_error : -EIO;
-	if (error) {
-		if (bp)
-			xfs_trans_brelse(tp, bp);
+	error = xfs_trans_get_buf_map(tp, mp->m_ddev_targp, mapp, nmap, 0, &bp);
+	if (error)
 		goto out_free;
-	}
 
 	*bpp = bp;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 64d7f171ebd3..a0be934ec811 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -169,10 +169,9 @@ int		xfs_trans_alloc_empty(struct xfs_mount *mp,
 			struct xfs_trans **tpp);
 void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
 
-struct xfs_buf	*xfs_trans_get_buf_map(struct xfs_trans *tp,
-				       struct xfs_buftarg *target,
-				       struct xfs_buf_map *map, int nmaps,
-				       uint flags);
+int xfs_trans_get_buf_map(struct xfs_trans *tp, struct xfs_buftarg *target,
+		struct xfs_buf_map *map, int nmaps, xfs_buf_flags_t flags,
+		struct xfs_buf **bpp);
 
 static inline struct xfs_buf *
 xfs_trans_get_buf(
@@ -182,8 +181,14 @@ xfs_trans_get_buf(
 	int			numblks,
 	uint			flags)
 {
+	struct xfs_buf		*bp;
+	int			error;
+
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return xfs_trans_get_buf_map(tp, target, &map, 1, flags);
+	error = xfs_trans_get_buf_map(tp, target, &map, 1, flags, &bp);
+	if (error)
+		return NULL;
+	return bp;
 }
 
 int		xfs_trans_read_buf_map(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index cdb66c661425..83470998f87b 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -112,24 +112,22 @@ xfs_trans_bjoin(
  * If the transaction pointer is NULL, make this just a normal
  * get_buf() call.
  */
-struct xfs_buf *
+int
 xfs_trans_get_buf_map(
 	struct xfs_trans	*tp,
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
-	xfs_buf_flags_t		flags)
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp)
 {
 	xfs_buf_t		*bp;
 	struct xfs_buf_log_item	*bip;
 	int			error;
 
-	if (!tp) {
-		error = xfs_buf_get_map(target, map, nmaps, flags, &bp);
-		if (error)
-			return NULL;
-		return bp;
-	}
+	*bpp = NULL;
+	if (!tp)
+		return xfs_buf_get_map(target, map, nmaps, flags, bpp);
 
 	/*
 	 * If we find the buffer in the cache with this transaction
@@ -151,18 +149,20 @@ xfs_trans_get_buf_map(
 		ASSERT(atomic_read(&bip->bli_refcount) > 0);
 		bip->bli_recur++;
 		trace_xfs_trans_get_buf_recur(bip);
-		return bp;
+		*bpp = bp;
+		return 0;
 	}
 
 	error = xfs_buf_get_map(target, map, nmaps, flags, &bp);
 	if (error)
-		return NULL;
+		return error;
 
 	ASSERT(!bp->b_error);
 
 	_xfs_trans_bjoin(tp, bp, 1);
 	trace_xfs_trans_get_buf(bp->b_log_item);
-	return bp;
+	*bpp = bp;
+	return 0;
 }
 
 /*

