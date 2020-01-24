Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B5EC2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5398C2072C
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:20:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fvCh18As"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgAXFUO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 00:20:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57356 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbgAXFUN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 00:20:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5IJ1p059348;
        Fri, 24 Jan 2020 05:20:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=HX1j6Vip7oZ0PqQRROF11+jSi12reQMCtjLaIrmNJqE=;
 b=fvCh18AsEIfibWFGmRuIuBO/E7RHLzW/dhdNuUdvRCZRTL9kpSDu1JogsTL0yPCTBJ+0
 y2GI2ksY0Rq5SKg0Bp69BBPyhUEwlTAQpkyyKzjoYk/sct4LWieZ05h1fKcebR9iH16O
 NwzY3xCNfbUHTCaoBfl86wzSiQUgDD6vqP4l6MuAl8bpMJO3FFj1Y+WVxi9cBGSqbY34
 W3pGcSWvnRoaFTkgAQRGpAShV6cxU3UPpAocIDQpZMtzzmimydyoQJXDxb6Q836mZQkv
 Y0fWDuiQ0XmQL8BFhp/zMO72wrGp3kc3HFulh7Bgt1ZZncXccwLlgKMbj28FndGJ2YpP 8g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xkseuy2th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:20:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5ILUf118591;
        Fri, 24 Jan 2020 05:20:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xqmue4ej5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:20:06 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O5K2EB003037;
        Fri, 24 Jan 2020 05:20:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 21:20:02 -0800
Subject: [PATCH 10/12] xfs: make xfs_*read_agf return EAGAIN to
 ALLOC_FLAG_TRYLOCK callers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Thu, 23 Jan 2020 21:20:01 -0800
Message-ID: <157984320125.3139258.966527323692871610.stgit@magnolia>
In-Reply-To: <157984313582.3139258.1136501362141645797.stgit@magnolia>
References: <157984313582.3139258.1136501362141645797.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor xfs_read_agf and xfs_alloc_read_agf to return EAGAIN if the
caller passed TRYLOCK and we weren't able to get the lock; and change
the callers to recognize this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   36 ++++++++++++++----------------------
 fs/xfs/libxfs/xfs_bmap.c  |   11 ++++++-----
 fs/xfs/xfs_filestream.c   |   11 +++++------
 3 files changed, 25 insertions(+), 33 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 34b65635ee34..d8053bc96c4d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2502,12 +2502,11 @@ xfs_alloc_fix_freelist(
 
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
 
@@ -2533,11 +2532,10 @@ xfs_alloc_fix_freelist(
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
@@ -2768,11 +2766,10 @@ xfs_alloc_pagf_init(
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
@@ -2961,12 +2958,6 @@ xfs_read_agf(
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
 
@@ -2992,14 +2983,15 @@ xfs_alloc_read_agf(
 
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
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cfcef076c72f..9a6d7a84689a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3311,11 +3311,12 @@ xfs_bmap_longest_free_extent(
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
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 5f12b5d8527a..1a88025e68a3 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -159,16 +159,15 @@ xfs_filestream_pick_ag(
 
 		if (!pag->pagf_init) {
 			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
-			if (err && !trylock) {
+			if (err) {
 				xfs_perag_put(pag);
-				return err;
+				if (err != -EAGAIN)
+					return err;
+				/* Couldn't lock the AGF, skip this AG. */
+				continue;
 			}
 		}
 
-		/* Might fail sometimes during the 1st pass with trylock set. */
-		if (!pag->pagf_init)
-			goto next_ag;
-
 		/* Keep track of the AG with the most free blocks. */
 		if (pag->pagf_freeblks > maxfree) {
 			maxfree = pag->pagf_freeblks;

