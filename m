Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F4CC32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57435214AF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:04:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T7bkdgRO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgAOREJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:04:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41744 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728925AbgAOREI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:04:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhwiR037393;
        Wed, 15 Jan 2020 17:04:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Kxdd6xXZ73sX3sGSd3EyZ8myVuk734DLWqYMjl/IuaU=;
 b=T7bkdgROgbC3QicA/aFhHExVGHvpx+xHhfz8RxJGFLKY+Jjmzo5eRZOZesWUHavEitXL
 5jydsoj5L66FO5BKnMuoDWGhODvktES4b+PYfq2c4C0YMukrw1haisEmAhMQ7k/l80hk
 7fTJGiUaiWCUmODxKlJO2pzJWadg9/hukLDrajz/cjnOoN7ChjkFsdAB0Sk69w9fCG+y
 IGvrAWf88zt/92U9LCluDtyO+5GWZnYD5OFpoE35DQlnlah2vA+CSEFP1zubHMTVFFUK
 PPXnGZ01B8QNWOUE+jK/Jrzs33t9qlKSyIAe7wczakcZ97cRmcA9PGpl44TrAurnTD6D Qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xf74sdeen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:04:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhwgY021597;
        Wed, 15 Jan 2020 17:04:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xj1prgp21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:04:00 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00FH3xCI012065;
        Wed, 15 Jan 2020 17:04:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:03:59 -0800
Subject: [PATCH 3/9] xfs: make xfs_buf_get return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 15 Jan 2020 09:03:58 -0800
Message-ID: <157910783855.2028217.9100808565121356587.stgit@magnolia>
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

Convert xfs_buf_get() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c |    6 +++---
 fs/xfs/libxfs/xfs_sb.c          |    9 +++++----
 fs/xfs/xfs_buf.c                |   18 ++++++++++++++++++
 fs/xfs/xfs_buf.h                |   11 ++---------
 4 files changed, 28 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 46c516809086..8b7f74b3bea2 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -545,9 +545,9 @@ xfs_attr_rmtval_set(
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
index 0ac69751fe85..28763c283851 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -985,9 +985,10 @@ xfs_update_secondary_sbs(
 	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
 		struct xfs_buf		*bp;
 
-		bp = xfs_buf_get(mp->m_ddev_targp,
+		error = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
-				 XFS_FSS_TO_BB(mp, 1));
+				 XFS_FSS_TO_BB(mp, 1),
+				 &bp);
 		/*
 		 * If we get an error reading or writing alternate superblocks,
 		 * continue.  xfs_repair chooses the "best" superblock based
@@ -995,12 +996,12 @@ xfs_update_secondary_sbs(
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
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e11fc43c52de..643173cc58f6 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -759,6 +759,24 @@ xfs_buf_get_map(
 	return bp;
 }
 
+int
+xfs_buf_get(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_buf		*bp;
+
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+	bp = xfs_buf_get_map(target, &map, 1, 0);
+	if (!bp)
+		return -ENOMEM;
+
+	*bpp = bp;
+	return 0;
+}
+
 STATIC int
 _xfs_buf_read(
 	xfs_buf_t		*bp,
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index f04722554f63..267b35daf662 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -203,15 +203,8 @@ void xfs_buf_readahead_map(struct xfs_buftarg *target,
 			       struct xfs_buf_map *map, int nmaps,
 			       const struct xfs_buf_ops *ops);
 
-static inline struct xfs_buf *
-xfs_buf_get(
-	struct xfs_buftarg	*target,
-	xfs_daddr_t		blkno,
-	size_t			numblks)
-{
-	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return xfs_buf_get_map(target, &map, 1, 0);
-}
+int xfs_buf_get(struct xfs_buftarg *target, xfs_daddr_t blkno, size_t numblks,
+		struct xfs_buf **bpp);
 
 int xfs_buf_read(struct xfs_buftarg *target, xfs_daddr_t blkno, size_t numblks,
 		xfs_buf_flags_t flags, struct xfs_buf **bpp,

