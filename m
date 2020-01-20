Return-Path: <SRS0=roPR=3J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9643EC32771
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 672EB22522
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:57:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fdIrEdJ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgATW5A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:57:00 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35904 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATW47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jan 2020 17:56:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMuFDh077233;
        Mon, 20 Jan 2020 22:56:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=et8lW1JOka48oBbQTEjqgFBumDWhZMK+CkpRSJH6LO4=;
 b=fdIrEdJ6Q3UaV2svd2G9jDCUM36NXrlXdJO2gH+uYHBqBeU3MABXDhevj5psyjq+P7UL
 +1nQvVUDNGn7rTwSoUA/PUzq4KxlLYXmLKXBR1+1DL0As5rbuQjFJ57OgTrvR00T/oA/
 YQPovWXbXwoAJWBSLqVmbIqAQ50W10VJgZgU3DRExanONxW5kSbFvEyod2luqOOcbW9s
 7MuUt46DfTgMt+dWtVviE4J1kJza3rOoHLfq4+dulIzXyfK4N/N5HKee9wh8hFbRTYfr
 09SlfV9oe3p7pR3qecVYFc2LOadaoRztamS4TSgjJl7bEITkggG+qSloo1u/olpTtXvj 8g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xkseu9u3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:56:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMnD99060616;
        Mon, 20 Jan 2020 22:56:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xmc656nkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:56:51 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00KMunJi012131;
        Mon, 20 Jan 2020 22:56:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 14:56:49 -0800
Subject: [PATCH 03/13] xfs: make xfs_buf_get return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Christoph Hellwig <hch@lst.de>
Date:   Mon, 20 Jan 2020 14:56:48 -0800
Message-ID: <157956100845.1166689.16497310559317943877.stgit@magnolia>
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

Convert xfs_buf_get() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_remote.c |    6 +++---
 fs/xfs/libxfs/xfs_sb.c          |    8 ++++----
 fs/xfs/xfs_buf.h                |   15 ++++++++++++---
 3 files changed, 19 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index d82985571a5f..46f055804433 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -555,9 +555,9 @@ xfs_attr_rmtval_set(
 		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
 		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
-		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt);
-		if (!bp)
-			return -ENOMEM;
+		error = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt, &bp);
+		if (error)
+			return error;
 		bp->b_ops = &xfs_attr3_rmt_buf_ops;
 
 		xfs_attr_rmtval_copyin(mp, bp, args->dp->i_ino, &offset,
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 0ac69751fe85..6fdd007f81ab 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -985,9 +985,9 @@ xfs_update_secondary_sbs(
 	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
 		struct xfs_buf		*bp;
 
-		bp = xfs_buf_get(mp->m_ddev_targp,
+		error = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
-				 XFS_FSS_TO_BB(mp, 1));
+				 XFS_FSS_TO_BB(mp, 1), &bp);
 		/*
 		 * If we get an error reading or writing alternate superblocks,
 		 * continue.  xfs_repair chooses the "best" superblock based
@@ -995,12 +995,12 @@ xfs_update_secondary_sbs(
 		 * superblocks un-updated than updated, and xfs_repair may
 		 * pick them over the properly-updated primary.
 		 */
-		if (!bp) {
+		if (error) {
 			xfs_warn(mp,
 		"error allocating secondary superblock for ag %d",
 				agno);
 			if (!saved_error)
-				saved_error = -ENOMEM;
+				saved_error = error;
 			continue;
 		}
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index fb60c36a8a5b..fe9ad8ee4eea 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -203,14 +203,23 @@ void xfs_buf_readahead_map(struct xfs_buftarg *target,
 			       struct xfs_buf_map *map, int nmaps,
 			       const struct xfs_buf_ops *ops);
 
-static inline struct xfs_buf *
+static inline int
 xfs_buf_get(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		blkno,
-	size_t			numblks)
+	size_t			numblks,
+	struct xfs_buf		**bpp)
 {
+	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return xfs_buf_get_map(target, &map, 1, 0);
+
+	*bpp = NULL;
+	bp = xfs_buf_get_map(target, &map, 1, 0);
+	if (!bp)
+		return -ENOMEM;
+
+	*bpp = bp;
+	return 0;
 }
 
 static inline int

