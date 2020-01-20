Return-Path: <SRS0=roPR=3J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A1CC32771
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED96222522
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:57:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o24g7yhH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgATW5J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:57:09 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52162 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATW5J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jan 2020 17:57:09 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMtaBl054348;
        Mon, 20 Jan 2020 22:57:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=FgVYbh5UgxCv8zai45MYb/bEsXfxSqMjX6SHURWTRzM=;
 b=o24g7yhHLHgWl1kDeT3tPGqUPvEMx7oiskTOq2pu+m4Yz3d3063tqp6NswgHE7jltp3T
 GI8us3rPR3cm6Oofw0bvM5NO8KMaq8jhuLJguerpTkg6hHCfNfoWj+hFUSTx4cfeRDwo
 tOgEZMKU3zyUTUePcWCDuQQLEf0Rs2zR8aQJmGi332ns3pm2LtiQ9mCOsYfb0oeG8scp
 ywGZChTSdSiG0i2XOtFjXLrvHeVUWLEXT8E4D1WHwHU5dn7YbnPhpkL6VzcaE6jeuNm3
 sUarUg5+Bdeou390Iub4B5OmALfMqJ3VTRgeDs13tSs04dtWRdi73enX4eU6yZ/GpsH6 JQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xktnr1jpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:57:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMn49D037099;
        Mon, 20 Jan 2020 22:57:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xmc5mc550-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:57:03 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00KMv2iK012258;
        Mon, 20 Jan 2020 22:57:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 14:57:02 -0800
Subject: [PATCH 05/13] xfs: make xfs_buf_read_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Mon, 20 Jan 2020 14:57:01 -0800
Message-ID: <157956102137.1166689.2159908930036102057.stgit@magnolia>
In-Reply-To: <157956098906.1166689.13651975861399490259.stgit@magnolia>
References: <157956098906.1166689.13651975861399490259.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001200192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001200192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert xfs_buf_read_map() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    7 +++----
 fs/xfs/xfs_buf.c          |   18 ++++++++++++------
 fs/xfs/xfs_buf.h          |   21 ++++++---------------
 fs/xfs/xfs_trans_buf.c    |    9 +++------
 4 files changed, 24 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index fc93fd88ec89..df25024275a1 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2956,14 +2956,13 @@ xfs_read_agf(
 	trace_xfs_read_agf(mp, agno);
 
 	ASSERT(agno != NULLAGNUMBER);
-	error = xfs_trans_read_buf(
-			mp, tp, mp->m_ddev_targp,
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
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
index 09b8f00d4182..460821844ee5 100644
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
@@ -842,13 +845,14 @@ xfs_buf_read_map(
 		 * drop the buffer
 		 */
 		xfs_buf_relse(bp);
-		return NULL;
+		return 0;
 	}
 
 	/* We do not want read in the flags */
 	bp->b_flags &= ~XBF_READ;
 	ASSERT(bp->b_ops != NULL || ops == NULL);
-	return bp;
+	*bpp = bp;
+	return 0;
 }
 
 /*
@@ -862,11 +866,13 @@ xfs_buf_readahead_map(
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
index eace3e285157..14209db07684 100644
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
@@ -231,16 +229,9 @@ xfs_buf_read(
 	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
-	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	*bpp = NULL;
-	bp = xfs_buf_read_map(target, &map, 1, flags, ops);
-	if (!bp)
-		return -ENOMEM;
-
-	*bpp = bp;
-	return 0;
+	return xfs_buf_read_map(target, &map, 1, flags, bpp, ops);
 }
 
 static inline void
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

