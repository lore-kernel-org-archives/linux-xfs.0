Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE87C33CB1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 739D820748
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:24:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bvM2WTSx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgAQGYT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 01:24:19 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45504 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgAQGYS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 01:24:18 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H68Y79150067;
        Fri, 17 Jan 2020 06:24:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=bZ9XBzk9blXv84AArD1CbmBBoyov2heqh2TFSCE61GA=;
 b=bvM2WTSxHwQJKpnB3GemMZ8P/oxC+duIgDIuHe8zbGt8pDjc6PB7lWiVcsLuC4bLhkrd
 wnW1KT3Y+zW5CU/tu29jvfoUUCy6CPK0Q268wWbK/Zisqru3VwCG1hgj63+8lHoTVLOV
 QGnEIvLPB5ofCJjxNWxhXgzCzxAPEf/ntOos3cxJiCbF1rzAkiKoaTos+UhDVmgkPjmH
 acqzG5njNI3F1SPk5zOxDBcIexAuagxQ1cMb4N6G6gtZd1DN1Jcaq7zHVOtpTv2j4QZY
 ODvIxef7E7gEdkHAUQH+J1pNvx8kSBvUS0H3qWkJ54xbuSwobXjW5Da1LSKPI34Cmd8i UA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xf73u6rdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:24:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H696wr039190;
        Fri, 17 Jan 2020 06:24:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xjxm8a4k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:24:12 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00H6OBit005205;
        Fri, 17 Jan 2020 06:24:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 22:24:11 -0800
Subject: [PATCH 05/11] xfs: make xfs_buf_read_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 16 Jan 2020 22:24:08 -0800
Message-ID: <157924224846.3029431.3421957295562306193.stgit@magnolia>
In-Reply-To: <157924221149.3029431.1461924548648810370.stgit@magnolia>
References: <157924221149.3029431.1461924548648810370.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170048
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert xfs_buf_read_map() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    4 ++--
 fs/xfs/xfs_buf.c          |   37 +++++++++++++++++++++----------------
 fs/xfs/xfs_buf.h          |   12 +++++-------
 fs/xfs/xfs_trans_buf.c    |    9 +++------
 4 files changed, 31 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index fc93fd88ec89..51818245eae2 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2960,10 +2960,10 @@ xfs_read_agf(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
+	if (error == -EAGAIN)
+		return 0;
 	if (error)
 		return error;
-	if (!*bpp)
-		return 0;
 
 	ASSERT(!(*bpp)->b_error);
 	xfs_buf_set_ref(*bpp, XFS_AGF_REF);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8778c4b38af7..f95c999b3343 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -809,21 +809,23 @@ xfs_buf_reverify(
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
 
 	flags |= XBF_READ;
+	*bpp = NULL;
 
 	bp = xfs_buf_get_map(target, map, nmaps, flags);
 	if (!bp)
-		return NULL;
+		return -ENOMEM;
 
 	trace_xfs_buf_read(bp, flags, _RET_IP_);
 
@@ -831,7 +833,8 @@ xfs_buf_read_map(
 		XFS_STATS_INC(target->bt_mount, xb_get_read);
 		bp->b_ops = ops;
 		_xfs_buf_read(bp, flags);
-		return bp;
+		*bpp = bp;
+		return 0;
 	}
 
 	xfs_buf_reverify(bp, ops);
@@ -842,13 +845,15 @@ xfs_buf_read_map(
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
@@ -860,19 +865,18 @@ xfs_buf_read(
 	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
-	struct xfs_buf		*bp;
 	int			error;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	*bpp = NULL;
-	bp = xfs_buf_read_map(target, &map, 1, flags, ops);
-	if (!bp)
-		return -ENOMEM;
-	error = bp->b_error;
+	error = xfs_buf_read_map(target, &map, 1, flags, bpp, ops);
+	if (error)
+		return error;
+	error = (*bpp)->b_error;
 	if (error) {
-		xfs_buf_ioerror_alert(bp, __func__);
-		xfs_buf_stale(bp);
-		xfs_buf_relse(bp);
+		xfs_buf_ioerror_alert(*bpp, __func__);
+		xfs_buf_stale(*bpp);
+		xfs_buf_relse(*bpp);
+		*bpp = NULL;
 
 		/* bad CRC means corrupted metadata */
 		if (error == -EFSBADCRC)
@@ -880,7 +884,6 @@ xfs_buf_read(
 		return error;
 	}
 
-	*bpp = bp;
 	return 0;
 }
 
@@ -895,11 +898,13 @@ xfs_buf_readahead_map(
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
index 1ee516ef2c66..36d43bead158 100644
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
 
 static inline int
 xfs_buf_get(
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

