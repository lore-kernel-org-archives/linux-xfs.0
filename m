Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7AD9C5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9193021D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:46:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zejESlZs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgBTBqB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:46:01 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51592 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTBqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:46:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1iaN4169622;
        Thu, 20 Feb 2020 01:45:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=O+rcU40vIUyxNQbTRbnq3nlt6V5CwDERo47/XBCTBPE=;
 b=zejESlZsl2IkzhujPo5v/nYmD+MlAxrRItD2mPV+vTcHVzGhSjoKL3K83h9h+ZQ/e5rG
 vjQlXbMv1i7fJoTJ+LRwKT0qzpHU+uG9OmhuZ0XXZH0w3F2HXrrxvHn8xBaihrEXp1Ym
 dStodT139Gq7NMS4PSSiC0sVer7KmSqRYDfqHU8oI1K4YZZUvpmQ3p1viosgOq0yYf4G
 6lfhm0Ojc44LAqqs36PoBHx2LOWbFse0IkTBuptfyVC4SshQmvC/Indp/O5Ef88LZRf2
 4r1H+oA+TFo1TWpfqRxAAEaNzWYG4iPht7nCM9/hiQ2hXVJiNMtOom8jVG1qJ2QR+i5B 3A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2y8ud16sjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gE42094350;
        Thu, 20 Feb 2020 01:45:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y8udbmmkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:54 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1jskL003390;
        Thu, 20 Feb 2020 01:45:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:45:54 -0800
Subject: [PATCH 13/14] xfs: make xfs_*read_agf return EAGAIN to
 ALLOC_FLAG_TRYLOCK callers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Date:   Wed, 19 Feb 2020 17:45:53 -0800
Message-ID: <158216315333.603628.14406687557422195635.stgit@magnolia>
In-Reply-To: <158216306957.603628.16404096061228456718.stgit@magnolia>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=2 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=2 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: f48e2df8a877ca1c19d92cfd7e74cc5956fa84cb

Refactor xfs_read_agf and xfs_alloc_read_agf to return EAGAIN if the
caller passed TRYLOCK and we weren't able to get the lock; and change
the callers to recognize this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc.c |   36 ++++++++++++++----------------------
 libxfs/xfs_bmap.c  |   11 ++++++-----
 2 files changed, 20 insertions(+), 27 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index be1bf736..a92ca524 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2498,12 +2498,11 @@ xfs_alloc_fix_freelist(
 
 	if (!pag->pagf_init) {
 		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
-		if (error)
+		if (error) {
+			/* Couldn't lock the AGF so skip this AG. */
+			if (error == -EAGAIN)
+				error = 0;
 			goto out_no_agbp;
-		if (!pag->pagf_init) {
-			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
-			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
-			goto out_agbp_relse;
 		}
 	}
 
@@ -2529,11 +2528,10 @@ xfs_alloc_fix_freelist(
 	 */
 	if (!agbp) {
 		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
-		if (error)
-			goto out_no_agbp;
-		if (!agbp) {
-			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
-			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
+		if (error) {
+			/* Couldn't lock the AGF so skip this AG. */
+			if (error == -EAGAIN)
+				error = 0;
 			goto out_no_agbp;
 		}
 	}
@@ -2764,11 +2762,10 @@ xfs_alloc_pagf_init(
 	xfs_buf_t		*bp;
 	int			error;
 
-	if ((error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp)))
-		return error;
-	if (bp)
+	error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp);
+	if (!error)
 		xfs_trans_brelse(tp, bp);
-	return 0;
+	return error;
 }
 
 /*
@@ -2957,12 +2954,6 @@ xfs_read_agf(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
-	/*
-	 * Callers of xfs_read_agf() currently interpret a NULL bpp as EAGAIN
-	 * and need to be converted to check for EAGAIN specifically.
-	 */
-	if (error == -EAGAIN)
-		return 0;
 	if (error)
 		return error;
 
@@ -2988,14 +2979,15 @@ xfs_alloc_read_agf(
 
 	trace_xfs_alloc_read_agf(mp, agno);
 
+	/* We don't support trylock when freeing. */
+	ASSERT((flags & (XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK)) !=
+			(XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK));
 	ASSERT(agno != NULLAGNUMBER);
 	error = xfs_read_agf(mp, tp, agno,
 			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
 			bpp);
 	if (error)
 		return error;
-	if (!*bpp)
-		return 0;
 	ASSERT(!(*bpp)->b_error);
 
 	agf = XFS_BUF_TO_AGF(*bpp);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index f917a6eb..d43155d0 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3304,11 +3304,12 @@ xfs_bmap_longest_free_extent(
 	pag = xfs_perag_get(mp, ag);
 	if (!pag->pagf_init) {
 		error = xfs_alloc_pagf_init(mp, tp, ag, XFS_ALLOC_FLAG_TRYLOCK);
-		if (error)
-			goto out;
-
-		if (!pag->pagf_init) {
-			*notinit = 1;
+		if (error) {
+			/* Couldn't lock the AGF, so skip this AG. */
+			if (error == -EAGAIN) {
+				*notinit = 1;
+				error = 0;
+			}
 			goto out;
 		}
 	}

