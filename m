Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEDC2C4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 04:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0CDA20874
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 04:21:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BlyR59Gu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgJBEVN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 00:21:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53438 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgJBEVN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 00:21:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0924Jjo7074382;
        Fri, 2 Oct 2020 04:21:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QwGMXG/4JvXvK5CO4FhBASOQ6z7uDFrJXHdm2qkBWtM=;
 b=BlyR59Gu8cQgcQGagz55Pf003NmBOxphCdvwV184UNyYGAuXYujP07aiREpogWOSBWAU
 rv+OObZuxaAgIllh1rZsZJHZz0Wnh6SaiuAquANCTobzqgHQ/fF+M6cowUrYzVo5BwUA
 zsmnixToyuQp+FbtniDgq3bq4gWrpOKlytiRsFI0iY/i/x81D1mz7Iap4wPUS7ug87ny
 3P6Heqoe8wQ5yQzlTuXrPVpMazlx5ATPhT+bm4AGJLLfy/BhOg0M/kKT4eqF1e0KN57L
 XP4Kv6kxdvKzxyHuurEbWGtTLu10iBReivx8MVYU1O+amLWba/fadHi5HBeJSA9g7F+J 8g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33sx9nh76h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 04:21:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0924Ks8v145840;
        Fri, 2 Oct 2020 04:21:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33tfdx0mbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 04:21:05 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0924L4f7027655;
        Fri, 2 Oct 2020 04:21:04 GMT
Received: from localhost (/10.159.236.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 21:21:04 -0700
Date:   Thu, 1 Oct 2020 21:21:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Subject: [PATCH v4.2 5/5] xfs: xfs_defer_capture should absorb remaining
 transaction reservation
Message-ID: <20201002042103.GU49547@magnolia>
References: <160140139198.830233.3093053332257853111.stgit@magnolia>
 <160140142459.830233.7194402837807253154.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160140142459.830233.7194402837807253154.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020030
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When xfs_defer_capture extracts the deferred ops and transaction state
from a transaction, it should record the transaction reservation type
from the old transaction so that when we continue the dfops chain, we
still use the same reservation parameters.

Doing this means that the log item recovery functions get to determine
the transaction reservation instead of abusing tr_itruncate in yet
another part of xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v4.2: save only the log reservation, and hardcode logcount and flags.
---
 fs/xfs/libxfs/xfs_defer.c |    3 +++
 fs/xfs/libxfs/xfs_defer.h |    3 +++
 fs/xfs/xfs_log_recover.c  |   17 ++++++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 10aeae7353ab..e19dc1ced7e6 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -579,6 +579,9 @@ xfs_defer_ops_capture(
 	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
 	dfc->dfc_rtxres = tp->t_rtx_res - tp->t_rtx_res_used;
 
+	/* Preserve the log reservation size. */
+	dfc->dfc_logres = tp->t_log_res;
+
 	return dfc;
 }
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 5c0e59b69ffa..6cde6f0713f7 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -79,6 +79,9 @@ struct xfs_defer_capture {
 	/* Block reservations for the data and rt devices. */
 	unsigned int		dfc_blkres;
 	unsigned int		dfc_rtxres;
+
+	/* Log reservation saved from the transaction. */
+	unsigned int		dfc_logres;
 };
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1be5208e2a2f..001e1585ddc6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2442,9 +2442,20 @@ xlog_finish_defer_ops(
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-				dfc->dfc_blkres, dfc->dfc_rtxres,
-				XFS_TRANS_RESERVE, &tp);
+		struct xfs_trans_res	resv;
+
+		/*
+		 * Create a new transaction reservation from the captured
+		 * information.  Set logcount to 1 to force the new transaction
+		 * to regrant every roll so that we can make forward progress
+		 * in recovery no matter how full the log might be.
+		 */
+		resv.tr_logres = dfc->dfc_logres;
+		resv.tr_logcount = 1;
+		resv.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+
+		error = xfs_trans_alloc(mp, &resv, dfc->dfc_blkres,
+				dfc->dfc_rtxres, XFS_TRANS_RESERVE, &tp);
 		if (error)
 			return error;
 
