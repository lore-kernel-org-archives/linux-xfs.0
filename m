Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC3EDC33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E6DA206D4
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 07:44:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CDfjJFxk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgAWHoB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 02:44:01 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44732 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgAWHoB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 02:44:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7hZ9j148674;
        Thu, 23 Jan 2020 07:43:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=JBdUbakoPzdSrOgwKZEA1NZbleglUnWTva91wcBfoiA=;
 b=CDfjJFxkC7Y1rxAWdN5P6jrIZnnRDjJNjagbxHWpzAaocVQUiOPhtG4nSS6BznCHrFq3
 9W2ulH1ps07largkxhVt7ErWz8VLhRUXBs1GpKUphgSk0UdcbPS7lbCVWR6HodNEpCCi
 D9Lmhuib6v+s9JJKPryn2kjiJIIgBExEkfe3S5dq59AjZejmJUdOP+oJzqoo5TJwJhrm
 tlOeuiq75emDy1PoltK1S41CFTEhrXUlFeG+qnyemoyeUIEFoCZFjmlvnCqqNTDqykGk
 xMCMk98Gto6D+JY9youaXBmrUC15+A1dvtV8LusKAo8vazheTJY5deeK5XolgLKwOJxI Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnrga2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:43:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7hsQY073010;
        Thu, 23 Jan 2020 07:43:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xppq50nr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:43:53 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00N7gtFC031790;
        Thu, 23 Jan 2020 07:42:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 23:42:55 -0800
Subject: [PATCH 10/12] xfs: make xfs_*read_agf return EAGAIN to
 ALLOC_FLAG_TRYLOCK callers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Wed, 22 Jan 2020 23:42:54 -0800
Message-ID: <157976537480.2388944.15713995061702153624.stgit@magnolia>
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
 engine=8.0.1-1911140001 definitions=main-2001230066
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230066
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
 fs/xfs/libxfs/xfs_alloc.c |   34 +++++++++++++++-------------------
 fs/xfs/libxfs/xfs_bmap.c  |   11 ++++++-----
 fs/xfs/xfs_filestream.c   |   11 ++++++-----
 3 files changed, 27 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7be6c8fbfcf9..ed0172850400 100644
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
@@ -2961,8 +2958,6 @@ xfs_read_agf(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
-	if (error == -EAGAIN)
-		return 0;
 	if (error)
 		return error;
 
@@ -2992,10 +2987,11 @@ xfs_alloc_read_agf(
 	error = xfs_read_agf(mp, tp, agno,
 			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
 			bpp);
-	if (error)
+	if (error) {
+		/* We don't support trylock when freeing. */
+		ASSERT(error != -EAGAIN || !(flags & XFS_ALLOC_FLAG_FREEING));
 		return error;
-	if (!*bpp)
-		return 0;
+	}
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
index 5f12b5d8527a..3ccdab463359 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -159,16 +159,17 @@ xfs_filestream_pick_ag(
 
 		if (!pag->pagf_init) {
 			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
-			if (err && !trylock) {
+			if (err == -EAGAIN) {
+				/* Couldn't lock the AGF, skip this AG. */
+				xfs_perag_put(pag);
+				continue;
+			}
+			if (err) {
 				xfs_perag_put(pag);
 				return err;
 			}
 		}
 
-		/* Might fail sometimes during the 1st pass with trylock set. */
-		if (!pag->pagf_init)
-			goto next_ag;
-
 		/* Keep track of the AG with the most free blocks. */
 		if (pag->pagf_freeblks > maxfree) {
 			maxfree = pag->pagf_freeblks;

