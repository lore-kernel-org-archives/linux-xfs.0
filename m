Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89861C35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52E2F222C2
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:17:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rpspB36d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgBYARY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:17:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55164 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBYARX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:17:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07aM2050068;
        Tue, 25 Feb 2020 00:15:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4tpnc836mj8i7m1B8KnLxj3hLP6mEnODvU2/pc+gb8U=;
 b=rpspB36dkW8HDSljx+cPF3xhSmVzfCT5oCaP8eFTHimSUBQjtJ511qaLjRc4/ySlpNcn
 0Umf1aznKv/hqhuea0nPZtIKf1icxwTbvXnabKLx3DA6tsPWGBLAplJi/NkFGbyyiNcD
 0t5ZKuHyGldp1Xdl7i4P7Ayh0QzSjF2BSAvB/v5i4woC5D50VV3/xO8QqRN1j+XKflyj
 dp7EWf0WRdF9YqLgq5/hDhMuZw8BEnKTT3EREx5QwRO69dNcT9hexYcZ4UwylMKTrDXQ
 m2Xl4TGa8MtPS2sBLV8sDUMT6UX7SXmo1NdAQTCyqwHDMZR8TSXusl0U/ZgWG/u2jjVU SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q3sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:15:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P06Yam098297;
        Tue, 25 Feb 2020 00:15:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ybduvg31h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:15:18 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0FHHx001612;
        Tue, 25 Feb 2020 00:15:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:15:16 -0800
Subject: [PATCH 10/14] xfs: make xfs_trans_get_buf_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Date:   Mon, 24 Feb 2020 16:15:15 -0800
Message-ID: <158258971593.453666.11262347286048594622.stgit@magnolia>
In-Reply-To: <158258964941.453666.10913737544282124969.stgit@magnolia>
References: <158258964941.453666.10913737544282124969.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=2 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 9676b54e6e28689af1b4247569f14466bdfc5390

Convert xfs_trans_get_buf_map() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trans.h   |   15 ++++++++++-----
 libxfs/trans.c        |   22 +++++++++++-----------
 libxfs/xfs_da_btree.c |    8 ++------
 3 files changed, 23 insertions(+), 22 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index cff27546..33ab5d73 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -105,10 +105,9 @@ void	libxfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *,
 				uint, uint);
 bool	libxfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
 
-struct xfs_buf	*libxfs_trans_get_buf_map(struct xfs_trans *tp,
-					struct xfs_buftarg *btp,
-					struct xfs_buf_map *map, int nmaps,
-					xfs_buf_flags_t flags);
+int	libxfs_trans_get_buf_map(struct xfs_trans *tp, struct xfs_buftarg *btp,
+		struct xfs_buf_map *map, int nmaps, xfs_buf_flags_t flags,
+		struct xfs_buf **bpp);
 
 int	libxfs_trans_read_buf_map(struct xfs_mount *mp, struct xfs_trans *tp,
 				  struct xfs_buftarg *btp,
@@ -123,8 +122,14 @@ libxfs_trans_get_buf(
 	int			numblks,
 	uint			flags)
 {
+	struct xfs_buf		*bp;
+	int			error;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return libxfs_trans_get_buf_map(tp, btp, &map, 1, flags);
+
+	error = libxfs_trans_get_buf_map(tp, btp, &map, 1, flags, &bp);
+	if (error)
+		return NULL;
+	return bp;
 }
 
 static inline int
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 73f69bce..ddd07cff 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -415,24 +415,22 @@ libxfs_trans_bhold_release(
  * If the transaction pointer is NULL, make this just a normal
  * get_buf() call.
  */
-struct xfs_buf *
+int
 libxfs_trans_get_buf_map(
 	struct xfs_trans	*tp,
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
-	xfs_buf_flags_t		flags)
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp)
 {
 	struct xfs_buf		*bp;
 	struct xfs_buf_log_item	*bip;
 	int			error;
 
-	if (!tp) {
-		error = libxfs_buf_get_map(target, map, nmaps, 0, &bp);
-		if (error)
-			return NULL;
-		return bp;
-	}
+	*bpp = NULL;
+	if (!tp)
+		return libxfs_buf_get_map(target, map, nmaps, 0, bpp);
 
 	/*
 	 * If we find the buffer in the cache with this transaction
@@ -447,18 +445,20 @@ libxfs_trans_get_buf_map(
 		ASSERT(bip != NULL);
 		bip->bli_recur++;
 		trace_xfs_trans_get_buf_recur(bip);
-		return bp;
+		*bpp = bp;
+		return 0;
 	}
 
 	error = libxfs_buf_get_map(target, map, nmaps, 0, &bp);
 	if (error)
-		return NULL;
+		return error;
 
 	ASSERT(!bp->b_error);
 
 	_libxfs_trans_bjoin(tp, bp, 1);
 	trace_xfs_trans_get_buf(bp->b_log_item);
-	return bp;
+	*bpp = bp;
+	return 0;
 }
 
 xfs_buf_t *
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 5102c6e0..3f40e99e 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2588,13 +2588,9 @@ xfs_da_get_buf(
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
 

