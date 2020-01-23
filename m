Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A63A2C33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78885206D4
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:44:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZWlOZWhS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgAWHos (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 02:44:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55736 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgAWHos (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 02:44:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7cHJs131410;
        Thu, 23 Jan 2020 07:42:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/bDOLOlMBXjAmuqkmFP4Gymf/brKJEQ8X3d8Wj7fP8s=;
 b=ZWlOZWhSC+oOXukKGJzKI//rwnZky48Di5LfRPGswEYgQSwarXz9GMbRNHsF8OYYzFtY
 4PM3N74tcU4Zgx5cySxO1QgGJ8oslieYyHF0DkLs6b2mkPzXl2yV4TMNkYsyHdJE3X4F
 /CtQAGh5epaeggbpe9yqeI4qsMls7b82w/blVXr4mwaoOBR5/2cNP8PtVlJ09WY9y1Hj
 /1trAt9oQAVoOE3j3LRVHuln/uynhvmw2tzCJb9A5ssl/+3xo5E0gzV05Dz237KrMZPw
 Oe5mH4RmeWjYFROAoZfPHY/r0xZSNBFNiog1kaSa1GSweIY0eYeEt+idk6vql991eAWy zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xksyqgf4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:42:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7d7xi036019;
        Thu, 23 Jan 2020 07:42:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xpq0vv1sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:42:36 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00N7gadj031598;
        Thu, 23 Jan 2020 07:42:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 23:42:36 -0800
Subject: [PATCH 07/12] xfs: make xfs_trans_get_buf_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 22 Jan 2020 23:42:35 -0800
Message-ID: <157976535530.2388944.2188310126880057324.stgit@magnolia>
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
index 6b7ef9dc167d..449be0f8c10f 100644
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

