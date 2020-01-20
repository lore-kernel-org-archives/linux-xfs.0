Return-Path: <SRS0=roPR=3J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88364C32771
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 515FA22522
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="orZ95oXO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgATW5Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:57:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47468 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATW5X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jan 2020 17:57:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMuVLa038126;
        Mon, 20 Jan 2020 22:57:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=cZD4qw1WTmjtVK7rdI907dRRz+JECkv7BazfkPtnS0g=;
 b=orZ95oXOIzZ84x3mLL4AOB6XpYGgaxJtiu9uH54GSmjBcUkOdTCzVoPZaYBOyhdgWwTs
 O0EKhhnhErIM2FH4ORIXQZeVWUng+xjwJzE/V9OJlfI8o2vybOG5KQHKR9pO0zSOZPDC
 Z4iBPRGf0mowJl37yWJVWDB0QP5N2GSvK5Izq4Dtj2lQFDSesWOM21RW38xuqfC7Ix1D
 mpKgazNnBWqjEkVhYYILmCYOSU3nuCYJbmLnhfFykv3TfE3MRotyMEuuU/pYUyzYq9Ix
 CBadI7s9AT07LFK9OUItEGjOdMPhKusVaTyjtv9g3t37DB1YIMRbRdx14l3I4tXsMY// zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xksyq1nsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:57:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMnDOL060689;
        Mon, 20 Jan 2020 22:57:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xmc656p8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:57:16 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00KMvFFd014511;
        Mon, 20 Jan 2020 22:57:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 14:57:15 -0800
Subject: [PATCH 07/13] xfs: make xfs_trans_get_buf_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Christoph Hellwig <hch@lst.de>
Date:   Mon, 20 Jan 2020 14:57:14 -0800
Message-ID: <157956103433.1166689.12403901181473335472.stgit@magnolia>
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

Convert xfs_trans_get_buf_map() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index bf61e61b38c7..babbfddbe505 100644
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

