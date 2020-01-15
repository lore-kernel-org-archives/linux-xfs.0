Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1DAAC32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CADE24656
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:04:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QKE/C45I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgAOREc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:04:32 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46404 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728904AbgAOREb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:04:31 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhOod012328;
        Wed, 15 Jan 2020 17:04:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gg+gkAXhHhac29ggaTrtigObC55S0b6XRt8RseSXOmM=;
 b=QKE/C45Ix6LUTtM4ypn5FWw3pgRTv73umCbBILOMUpo26mSK7oBjf9fQsKmAkE7rUAkX
 pe2kW6mFLUUoBpHCtCSdtU6ixwFaq4BLniTy2JVUinKvTjFrDq0KL439GnbcYOs5dh//
 +nvBAQ795B3jLI8AN6YTb+nXdz1QViDg49CrYK1XXoprXDXK4/RJ8G3mk7HQ3j4HKAR7
 k3TnuAmAZZsAeuOZenzNhF3CDKySVogM/5ed+tlLTDLrl9b2kH75KmY596PO/94pBbq4
 6E5tnkZMRi1mv5UXXPIAsPLh1JUjpvLINj5YkOat0qfrrgce6NIr4LqTWQHUt/2ZF07+ Sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xf73yne1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:04:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGiIA9056611;
        Wed, 15 Jan 2020 17:04:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xhy21r4pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:04:13 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00FH4Cjq001884;
        Wed, 15 Jan 2020 17:04:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:04:12 -0800
Subject: [PATCH 5/9] xfs: make xfs_buf_read_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 15 Jan 2020 09:04:11 -0800
Message-ID: <157910785108.2028217.14921731819456574224.stgit@magnolia>
In-Reply-To: <157910781961.2028217.1250106765923436515.stgit@magnolia>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert xfs_buf_read_map() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    4 ++++
 fs/xfs/xfs_buf.c          |   24 +++++++++++++++---------
 fs/xfs/xfs_buf.h          |   12 +++++-------
 fs/xfs/xfs_trans_buf.c    |    9 +++------
 4 files changed, 27 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index fc93fd88ec89..53410819691b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2960,6 +2960,10 @@ xfs_read_agf(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
+	if (error == -EAGAIN && (flags & XBF_TRYLOCK)) {
+		*bpp = NULL;
+		return 0;
+	}
 	if (error)
 		return error;
 	if (!*bpp)
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a7d538b89bb5..1a3dfecb93e0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -826,12 +826,13 @@ xfs_buf_reverify(
 	return bp->b_error;
 }
 
-xfs_buf_t *
+int
 xfs_buf_read_map(
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
 	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
@@ -840,7 +841,7 @@ xfs_buf_read_map(
 
 	bp = xfs_buf_get_map(target, map, nmaps, flags);
 	if (!bp)
-		return NULL;
+		return -ENOMEM;
 
 	trace_xfs_buf_read(bp, flags, _RET_IP_);
 
@@ -848,7 +849,8 @@ xfs_buf_read_map(
 		XFS_STATS_INC(target->bt_mount, xb_get_read);
 		bp->b_ops = ops;
 		_xfs_buf_read(bp, flags);
-		return bp;
+		*bpp = bp;
+		return 0;
 	}
 
 	xfs_buf_reverify(bp, ops);
@@ -859,13 +861,15 @@ xfs_buf_read_map(
 		 * drop the buffer
 		 */
 		xfs_buf_relse(bp);
-		return NULL;
+		*bpp = NULL;
+		return 0;
 	}
 
 	/* We do not want read in the flags */
 	bp->b_flags &= ~XBF_READ;
 	ASSERT(bp->b_ops != NULL || ops == NULL);
-	return bp;
+	*bpp = bp;
+	return 0;
 }
 
 int
@@ -881,9 +885,9 @@ xfs_buf_read(
 	int			error;
 
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	bp = xfs_buf_read_map(target, &map, 1, flags, ops);
-	if (!bp)
-		return -ENOMEM;
+	error = xfs_buf_read_map(target, &map, 1, flags, &bp, ops);
+	if (error)
+		return error;
 	error = bp->b_error;
 	if (error) {
 		xfs_buf_ioerror_alert(bp, __func__);
@@ -911,11 +915,13 @@ xfs_buf_readahead_map(
 	int			nmaps,
 	const struct xfs_buf_ops *ops)
 {
+	struct xfs_buf		*bp;
+
 	if (bdi_read_congested(target->bt_bdev->bd_bdi))
 		return;
 
 	xfs_buf_read_map(target, map, nmaps,
-		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD, ops);
+		     XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops);
 }
 
 /*
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index e0e8b0769758..7e01d168e437 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -195,13 +195,11 @@ struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
 struct xfs_buf *xfs_buf_get_map(struct xfs_buftarg *target,
 			       struct xfs_buf_map *map, int nmaps,
 			       xfs_buf_flags_t flags);
-struct xfs_buf *xfs_buf_read_map(struct xfs_buftarg *target,
-			       struct xfs_buf_map *map, int nmaps,
-			       xfs_buf_flags_t flags,
-			       const struct xfs_buf_ops *ops);
-void xfs_buf_readahead_map(struct xfs_buftarg *target,
-			       struct xfs_buf_map *map, int nmaps,
-			       const struct xfs_buf_ops *ops);
+int xfs_buf_read_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
+		int nmaps, xfs_buf_flags_t flags, struct xfs_buf **bpp,
+		const struct xfs_buf_ops *ops);
+void xfs_buf_readahead_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
+		int nmaps, const struct xfs_buf_ops *ops);
 
 int xfs_buf_get(struct xfs_buftarg *target, xfs_daddr_t blkno, size_t numblks,
 		struct xfs_buf **bpp);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index b5b3a78ef31c..a2af6dec310d 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -298,12 +298,9 @@ xfs_trans_read_buf_map(
 		return 0;
 	}
 
-	bp = xfs_buf_read_map(target, map, nmaps, flags, ops);
-	if (!bp) {
-		if (!(flags & XBF_TRYLOCK))
-			return -ENOMEM;
-		return tp ? 0 : -EAGAIN;
-	}
+	error = xfs_buf_read_map(target, map, nmaps, flags, &bp, ops);
+	if (error)
+		return error;
 
 	/*
 	 * If we've had a read error, then the contents of the buffer are

