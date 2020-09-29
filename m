Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992A8C4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D7E220848
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:45:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D2ErQIMB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgI2Rpq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:45:46 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56520 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728386AbgI2Rpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 13:45:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THdmqU060872;
        Tue, 29 Sep 2020 17:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ck4Nn068BKBIaTekhw8NaFEozShKbFzapDfxa1X27lU=;
 b=D2ErQIMBOaGpC8XyebVyhjvu08aEzEZfZrFjOTm5tq8CNVr3Y3+zHS4u3B+aITYjAydI
 AzGXBFq1q7obAby/kvo69rzhpGlA7Flp0SxrAqIHqVTQaUHXEcU3zUxLWf9HK4psiVlS
 sQPEwk3IJGRpD3yXIjS8TU41u9nlx7/MOxKWOQ7vZM5x+TZt7iRh6IrEluTPnCzZbIY7
 xi2WOVauHapT+trjzTO2XF+sC9IjeCmH8Ns4B4D/24MS4sOq0bSnErFaolLTYi/XfOPz
 QrcjEpjzGtIF3pqUDCxi3D28aTdIO4Zwda5UZ2H8adyT4kKngniywhiMUi4p/dbYK9dF qA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33su5avcm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 17:45:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THerSN147096;
        Tue, 29 Sep 2020 17:43:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33uv2e7vma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 17:43:40 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08THhdbP028051;
        Tue, 29 Sep 2020 17:43:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 10:43:39 -0700
Subject: [PATCH 4/5] xfs: xfs_defer_capture should absorb remaining block
 reservation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Date:   Tue, 29 Sep 2020 10:43:38 -0700
Message-ID: <160140141814.830233.6669476190490393801.stgit@magnolia>
In-Reply-To: <160140139198.830233.3093053332257853111.stgit@magnolia>
References: <160140139198.830233.3093053332257853111.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=3 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=3
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c |    5 +++++
 fs/xfs/libxfs/xfs_defer.h |    1 +
 fs/xfs/xfs_log_recover.c  |   18 +-----------------
 3 files changed, 7 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 85c371d29e8d..0cceebb390c4 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -575,6 +575,10 @@ xfs_defer_ops_capture(
 	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
 	tp->t_flags &= ~XFS_TRANS_LOWMODE;
 
+	/* Capture the block reservation along with the dfops. */
+	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
+	tp->t_blk_res = tp->t_blk_res_used;
+
 	return dfc;
 }
 
@@ -632,6 +636,7 @@ xfs_defer_ops_continue(
 	/* Move captured dfops chain and state to the transaction. */
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
 	tp->t_flags |= dfc->dfc_tpflags;
+	tp->t_blk_res += dfc->dfc_blkres;
 
 	kmem_free(dfc);
 }
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 3af82ebc1249..b1c7b761afd5 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -75,6 +75,7 @@ struct xfs_defer_capture {
 	/* Deferred ops state saved from the transaction. */
 	struct list_head	dfc_dfops;
 	unsigned int		dfc_tpflags;
+	unsigned int		dfc_blkres;
 };
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 550d0fa8057a..b06c9881a13d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2439,26 +2439,10 @@ xlog_finish_defer_ops(
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

