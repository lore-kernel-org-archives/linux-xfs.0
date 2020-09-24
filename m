Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888D3C4346E
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 06:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 383E523741
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 06:04:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gO9yYXcy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgIXGED (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 02:04:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59798 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgIXGED (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 02:04:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08O5wpJf062221;
        Thu, 24 Sep 2020 06:04:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=y3amAQpkDNCmeJ5BSwSRsuKMSx7BCiDGqDcYIUJCJ3U=;
 b=gO9yYXcyo7SMeEj7HvAQ2Jz4ORy3wI0LdyV1gTsZR4whwbpzVM0QBCdURMCw6jWJEY1h
 KoONTVojX4pSVMeCGgS+R1zakYsjxjzRdljnggqopuaJ5CSLjC8kKIjILSzUybi8wsrh
 HJz3+dThiLBV5jJM0lRuDR57Dxh29fb6d5XlLk7Q25LCCI/MbUs31bjS5UjWL2VmZk+E
 obMC0hkxatpO/15jhLREmivCBGpDyIubKwA/GOHfBcXNCpxjyMQWrXFXWbRToACWPVAu
 aysnIYbgtSZW/ZzQCHnmlzbl7j9emmuZaCqyTpvrOkwZxuCKYBTQhZuVrA64sN7j/0Yv wA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33ndnup6sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 06:04:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08O5tRSp018176;
        Thu, 24 Sep 2020 06:04:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33nux28t2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Sep 2020 06:04:01 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08O640P9027993;
        Thu, 24 Sep 2020 06:04:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 23:04:00 -0700
Date:   Wed, 23 Sep 2020 23:04:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: [PATCH v2 2/3] xfs: xfs_defer_capture should absorb remaining block
 reservation
Message-ID: <20200924060400.GC7955@magnolia>
References: <160031334050.3624461.17900718410309670962.stgit@magnolia>
 <160031335340.3624461.9858183522513375436.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031335340.3624461.9858183522513375436.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=5 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009240048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=5 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009240048
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v2: trivial rebase of patch 1
---
 fs/xfs/libxfs/xfs_defer.c |    4 ++++
 fs/xfs/libxfs/xfs_defer.h |    1 +
 fs/xfs/xfs_log_recover.c  |   18 +-----------------
 3 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 0cb4af0c5c10..8bd01952c955 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -593,6 +593,8 @@ xfs_defer_capture(
 	/* Move the dfops chain and transaction state to the freezer. */
 	list_splice_init(&tp->t_dfops, &dfc->dfc_dfops);
 	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
+	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
+	tp->t_blk_res = tp->t_blk_res_used;
 	xfs_defer_reset(tp);
 
 	/*
@@ -622,6 +624,8 @@ xfs_defer_continue(
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
 	tp->t_flags |= dfc->dfc_tpflags;
 	dfc->dfc_tpflags = 0;
+	tp->t_blk_res += dfc->dfc_blkres;
+	dfc->dfc_blkres = 0;
 }
 
 /* Release all resources that we used to capture deferred ops. */
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 366d08d99e11..59d126aeb31c 100644
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
index 79be1f02d1b4..777b60073ff7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2501,26 +2501,10 @@ xlog_finish_defer_ops(
 {
 	struct xfs_defer_capture *dfc, *next;
 	struct xfs_trans	*tp;
-	int64_t			freeblks;
-	uint64_t		resblks;
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
-		/*
-		 * We're finishing the defer_ops that accumulated as a result
-		 * of recovering unfinished intent items during log recovery.
-		 * We reserve an itruncate transaction because it is the
-		 * largest permanent transaction type.  Since we're the only
-		 * user of the fs right now, take 93% (15/16) of the available
-		 * free blocks.  Use weird math to avoid a 64-bit division.
-		 */
-		freeblks = percpu_counter_sum(&mp->m_fdblocks);
-		if (freeblks <= 0)
-			return -ENOSPC;
-
-		resblks = min_t(uint64_t, UINT_MAX, freeblks);
-		resblks = (resblks * 15) >> 4;
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0,
 				0, XFS_TRANS_RESERVE, &tp);
 		if (error)
 			return error;
