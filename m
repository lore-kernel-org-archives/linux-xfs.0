Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1414C2BBD1
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF7E2221EB
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:29:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EjygNvLE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgIQD3W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 23:29:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49802 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgIQD3T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:29:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3OrpG041026;
        Thu, 17 Sep 2020 03:29:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hoicmTyOTLW/RWpcHa01IBBPFYjNGvz23eqji9ciPog=;
 b=EjygNvLEkZErrmSn2a81ADAYydy1i83W/8BnCiqYvOR8UC2WdkV4yQZjxbQ/+dzGUbfI
 w1ZpEvC7ccf+4kFfpmTQ/UH3hjn3kccuixAaWhx5LQrAO7cdUzh6WjmoULXBO7MgNNUf
 QDdGYzMoLzean6ABOcGcGhsDCr/aKJnAk/UsDj9WpBn9C/TUSZK6zwyKV5gpho1YWDBR
 HrkaQhxr+Xt7a4d+d7scIzBvCfqIFb3fDMa0EHkHrkFp/TJCUvSWmRkS/CWl0jHjHAjL
 chl2gBfg3VsAej0NGZi0+eimrVeQFv9oLE7Vb3g0eCQZpK4sRBPNgKZrqEOXXF/CvXZ4 QQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33gp9meg6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 03:29:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3Q1EX181878;
        Thu, 17 Sep 2020 03:29:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33hm340rt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 03:29:15 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H3TEGT030063;
        Thu, 17 Sep 2020 03:29:14 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:29:14 +0000
Subject: [PATCH 2/3] xfs: xfs_defer_capture should absorb remaining block
 reservation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 16 Sep 2020 20:29:13 -0700
Message-ID: <160031335340.3624461.9858183522513375436.stgit@magnolia>
In-Reply-To: <160031334050.3624461.17900718410309670962.stgit@magnolia>
References: <160031334050.3624461.17900718410309670962.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=3 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When xfs_defer_capture extracts the deferred ops and transaction state
from a transaction, it should absorb the remaining block reservation so
that when we continue the dfops chain, we still have those blocks to
use.

This adds the requirement that every log intent item recovery function
must be careful to reserve enough blocks to handle both itself and all
defer ops that it can queue.  On the other hand, this enables us to do
away with the handwaving block estimation nonsense that was going on in
xlog_finish_defer_ops.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c |    4 ++++
 fs/xfs/libxfs/xfs_defer.h |    1 +
 fs/xfs/xfs_log_recover.c  |   20 +-------------------
 3 files changed, 6 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index e4a6928c8566..d1db97ccad51 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -588,6 +588,8 @@ xfs_defer_capture(
 		/* Move the dfops chain and transaction state to the freezer. */
 		list_splice_init(&tp->t_dfops, &dfc->dfc_dfops);
 		dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
+		dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
+		tp->t_blk_res = tp->t_blk_res_used;
 		xfs_defer_reset(tp);
 	}
 
@@ -608,6 +610,8 @@ xfs_defer_continue(
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
 	tp->t_flags |= dfc->dfc_tpflags;
 	dfc->dfc_tpflags = 0;
+	tp->t_blk_res += dfc->dfc_blkres;
+	dfc->dfc_blkres = 0;
 }
 
 /* Release all resources that we used to capture deferred ops. */
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index d61ef0a750ab..fea610f5d3e1 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -76,6 +76,7 @@ struct xfs_defer_capture {
 	/* Deferred ops state saved from the transaction. */
 	struct list_head	dfc_dfops;
 	unsigned int		dfc_tpflags;
+	unsigned int		dfc_blkres;
 };
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0c90c1326860..5f664e52c542 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2500,28 +2500,10 @@ xlog_finish_defer_ops(
 {
 	struct xfs_defer_capture *dfc, *next;
 	struct xfs_trans	*tp;
-	int64_t			freeblks;
-	uint64_t		resblks;
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, dfops_freezers, dfc_list) {
-		/*
-		 * We're finishing the defer_ops that accumulated as a result
-		 * of recovering unfinished intent items during log recovery.
-		 * We reserve an itruncate transaction because it is the
-		 * largest permanent transaction type.  Since we're the only
-		 * user of the fs right now, take 93% (15/16) of the available
-		 * free blocks.  Use weird math to avoid a 64-bit division.
-		 */
-		freeblks = percpu_counter_sum(&mp->m_fdblocks);
-		if (freeblks <= 0) {
-			error = -ENOSPC;
-			break;
-		}
-
-		resblks = min_t(uint64_t, UINT_MAX, freeblks);
-		resblks = (resblks * 15) >> 4;
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0,
 				0, XFS_TRANS_RESERVE, &tp);
 		if (error)
 			break;

