Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7007CC33CB1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41F9A20748
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:24:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UwsK4HGm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgAQGYt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 01:24:49 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34680 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgAQGYt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 01:24:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H68Nvc186711;
        Fri, 17 Jan 2020 06:24:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=C9fPbpnzozdNVl0IiXjVVOgaElKWb1gjepTxmBr8sLQ=;
 b=UwsK4HGmORoqkLDGCHz8/6ycgqlIQpMFNg8nAVoDBYSkvkJa/pdjMsLDjtddqiQ+iOXi
 9akHkgYVwFz9yh9w1yav+IkQArPB7JGVmhv6rAD62nJn9vHRtIQ7Xj/G9nHPA+qZEf8x
 twiX5uNBrhfJD8xBVjbIoJ6rC2/Yc5dfGiNm90tGu/NWhjk+SkYlpHdS9l3nWxb3lcMN
 ZDhCGnrLAKJWMuz/b5pMYBjlCNjuQmtTVjz1F6P2WMDUasQLMHW06hE9QweFx3MjPwtr
 5yn/Sm3LcFJGybF2W+6/7u5YoFl8dEKg+8t7PyFgvNBprGVTkUQVdz6j2QdfnGMXGHbn dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xf74spt7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:24:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H68U6s129423;
        Fri, 17 Jan 2020 06:24:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xjxp4hj3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:24:44 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00H6OhWi005386;
        Fri, 17 Jan 2020 06:24:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 22:24:43 -0800
Subject: [PATCH 10/11] xfs: make xfs_*read_agf return EAGAIN to
 ALLOC_FLAG_TRYLOCK callers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 16 Jan 2020 22:24:41 -0800
Message-ID: <157924228165.3029431.1835481566077971155.stgit@magnolia>
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

Refactor xfs_read_agf and xfs_alloc_read_agf to return EAGAIN if the
caller passed TRYLOCK and we weren't able to get the lock; and change
the callers to recognize this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   31 +++++++++++++++----------------
 fs/xfs/libxfs/xfs_bmap.c  |    9 +++++----
 fs/xfs/xfs_filestream.c   |   11 ++++++-----
 3 files changed, 26 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 83273975df77..26f3e4db84e0 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2502,13 +2502,15 @@ xfs_alloc_fix_freelist(
 
 	if (!pag->pagf_init) {
 		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
-		if (error)
-			goto out_no_agbp;
-		if (!pag->pagf_init) {
+		if (error == -EAGAIN) {
+			/* Couldn't lock the AGF so skip this AG. */
 			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
 			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
-			goto out_agbp_relse;
+			error = 0;
+			goto out_no_agbp;
 		}
+		if (error)
+			goto out_no_agbp;
 	}
 
 	/*
@@ -2533,13 +2535,15 @@ xfs_alloc_fix_freelist(
 	 */
 	if (!agbp) {
 		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
-		if (error)
-			goto out_no_agbp;
-		if (!agbp) {
+		if (error == -EAGAIN) {
+			/* Couldn't lock the AGF so skip this AG. */
 			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
 			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
+			error = 0;
 			goto out_no_agbp;
 		}
+		if (error)
+			goto out_no_agbp;
 	}
 
 	/* reset a padding mismatched agfl before final free space check */
@@ -2768,10 +2772,10 @@ xfs_alloc_pagf_init(
 	xfs_buf_t		*bp;
 	int			error;
 
-	if ((error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp)))
+	error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp);
+	if (error)
 		return error;
-	if (bp)
-		xfs_trans_brelse(tp, bp);
+	xfs_trans_brelse(tp, bp);
 	return 0;
 }
 
@@ -2958,12 +2962,9 @@ xfs_read_agf(
 	trace_xfs_read_agf(mp, agno);
 
 	ASSERT(agno != NULLAGNUMBER);
-	error = xfs_trans_read_buf(
-			mp, tp, mp->m_ddev_targp,
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
-	if (error == -EAGAIN)
-		return 0;
 	if (error)
 		return error;
 
@@ -2995,8 +2996,6 @@ xfs_alloc_read_agf(
 			bpp);
 	if (error)
 		return error;
-	if (!*bpp)
-		return 0;
 	ASSERT(!(*bpp)->b_error);
 
 	agf = XFS_BUF_TO_AGF(*bpp);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cfcef076c72f..10b7284cac35 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3311,13 +3311,14 @@ xfs_bmap_longest_free_extent(
 	pag = xfs_perag_get(mp, ag);
 	if (!pag->pagf_init) {
 		error = xfs_alloc_pagf_init(mp, tp, ag, XFS_ALLOC_FLAG_TRYLOCK);
-		if (error)
-			goto out;
-
-		if (!pag->pagf_init) {
+		if (error == -EAGAIN) {
+			/* Couldn't lock the AGF, so skip this AG. */
 			*notinit = 1;
+			error = 0;
 			goto out;
 		}
+		if (error)
+			goto out;
 	}
 
 	longest = xfs_alloc_longest_free_extent(pag,
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

