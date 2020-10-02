Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E3DEC4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 04:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4086920874
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 04:22:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QqS81pdO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgJBEWc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 00:22:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54222 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgJBEWc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 00:22:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0924MPah075857;
        Fri, 2 Oct 2020 04:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=eQCWWy3rmGYw+RPKEYLbs2Htb0V8NieLTmdSnsKXGEo=;
 b=QqS81pdOdBIuD94GJ3NAFchZOTAqFWVtoHxZXmhuRgpWdMLwOmkDEMGiPMDbckFtM87f
 ww1aMO1EOM67w3zZvgI+NZKnYC1MUzSiYRhqn0UMOzgJ71rpMnJJvt6zDFhTHu5Ljfco
 QKVmhk7WOW3OcF9BDoLyjDnLpaMgBhOYFkQQXO5WM0HLMQM2uS7d8UJXFIqWKTpL0pt1
 uBtFtnngngZU+aGF0TbW/WPe1TOEZDlMa4MVeaoZbfI9cApvrWNSAk88eKskSVddH9N6
 Qrk02Y8bEk6itylS534AdeLbLZvzZh9SQkgpmAfHccVjUln+A80DV4dDOXrV3E42OIEQ HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33sx9nh78d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 04:22:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0924EwmY135956;
        Fri, 2 Oct 2020 04:20:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33tfdx0kwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 04:20:25 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0924KJUt002732;
        Fri, 2 Oct 2020 04:20:19 GMT
Received: from localhost (/10.159.236.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 21:20:19 -0700
Date:   Thu, 1 Oct 2020 21:20:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: [PATCH v4.2 4/5] xfs: xfs_defer_capture should absorb remaining
 block reservation
Message-ID: <20201002042015.GT49547@magnolia>
References: <160140139198.830233.3093053332257853111.stgit@magnolia>
 <160140141814.830233.6669476190490393801.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160140141814.830233.6669476190490393801.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=5
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020030
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When xfs_defer_capture extracts the deferred ops and transaction state
from a transaction, it should record the remaining block reservations so
that when we continue the dfops chain, we can reserve the same number of
blocks to use.  We capture the reservations for both data and realtime
volumes.

This adds the requirement that every log intent item recovery function
must be careful to reserve enough blocks to handle both itself and all
defer ops that it can queue.  On the other hand, this enables us to do
away with the handwaving block estimation nonsense that was going on in
xlog_finish_defer_ops.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v4.2: don't fiddle with transaction internals, and save the rt
reservation too
---
 fs/xfs/libxfs/xfs_defer.c |    4 ++++
 fs/xfs/libxfs/xfs_defer.h |    4 ++++
 fs/xfs/xfs_log_recover.c  |   21 +++------------------
 3 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 85c371d29e8d..10aeae7353ab 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -575,6 +575,10 @@ xfs_defer_ops_capture(
 	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
 	tp->t_flags &= ~XFS_TRANS_LOWMODE;
 
+	/* Capture the remaining block reservations along with the dfops. */
+	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
+	dfc->dfc_rtxres = tp->t_rtx_res - tp->t_rtx_res_used;
+
 	return dfc;
 }
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 3af82ebc1249..5c0e59b69ffa 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -75,6 +75,10 @@ struct xfs_defer_capture {
 	/* Deferred ops state saved from the transaction. */
 	struct list_head	dfc_dfops;
 	unsigned int		dfc_tpflags;
+
+	/* Block reservations for the data and rt devices. */
+	unsigned int		dfc_blkres;
+	unsigned int		dfc_rtxres;
 };
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7804906d145b..1be5208e2a2f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2439,27 +2439,12 @@ xlog_finish_defer_ops(
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
-				0, XFS_TRANS_RESERVE, &tp);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+				dfc->dfc_blkres, dfc->dfc_rtxres,
+				XFS_TRANS_RESERVE, &tp);
 		if (error)
 			return error;
 
