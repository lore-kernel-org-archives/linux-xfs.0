Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB62C33CB1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E99020748
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:24:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NGTS2ZHM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgAQGYe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 01:24:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54094 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgAQGYe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 01:24:34 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H68xlP167004;
        Fri, 17 Jan 2020 06:24:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=cZD4qw1WTmjtVK7rdI907dRRz+JECkv7BazfkPtnS0g=;
 b=NGTS2ZHM6gjVZ2HL69O4tixEvODQzcE6lx8V2Al0MpBQurHK8wsPoRQ53V6VFUJczZoT
 /+fr3hM63LD4f7y6+14pX80KSgllFhzje5nCdh46OXP6TwU9CB2KHaNOPj3YsEDmdEic
 NikZRcuOFPysPfu/k+FSbg5/+ly1aQVxbjaURzwshBBv617JfBal2YZxOcdvTSNOgW9M
 3mKzvn4x/L6xBfLU+lE4JTEleqOnAzLFq8zi5EC07fZ11+rhyo3Wb/ufPb3os2iLJb0g
 eDpI+JQHr1PUyw8HIakvsIoDnctbXuTM7XE7SMFk3Hpzkiore1YH6ZqK1/dio62FsmM2 YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xf73yxu86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:24:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H69Gug076114;
        Fri, 17 Jan 2020 06:24:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xk230b28s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:24:25 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00H6OOWs002742;
        Fri, 17 Jan 2020 06:24:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 22:24:24 -0800
Subject: [PATCH 07/11] xfs: make xfs_trans_get_buf_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Date:   Thu, 16 Jan 2020 22:24:22 -0800
Message-ID: <157924226249.3029431.16233612286866694997.stgit@magnolia>
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

