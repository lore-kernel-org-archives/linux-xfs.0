Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B22CFC4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AF20208B8
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:45:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YllELw4Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgI2Rpy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:45:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39554 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728775AbgI2Rpx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 13:45:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THdAlC189457;
        Tue, 29 Sep 2020 17:45:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YXvEFJpnAJ08fgbI2dYl/xB2e1B13WnweJqayUb4x8U=;
 b=YllELw4Yoganqyp5w9KGzaTfHwy2kBFJ0vSM6bjN8iJ2Bul0CTftBdXniU4Y7yR+VPIX
 a6sfoZIY4BscoEpaMtKrInIbokzxMrRBxECM4T26w5J5qw6ApYyJmnsNxStRYrTBv95m
 6KsG0lFyk2iMqMS3as6xiwB8FUqGj7B7RAmMMIMYDbGe3AFUJCr7x3LSSsYcpRYlb4d7
 pFipFUU1FxWCSmLL+l2CixVmH1DlZALYCKzRoRD567C4RWbjPbEz13ehs24TxcuuMRo7
 lcSUJyPyEOEk7XS2YPmNbA8+D1PkW/3PoSTApx9Kfmfl62w5bBvxhJJR9oGK+79wb4c2 /g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33sx9n482x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 17:45:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THekHP111512;
        Tue, 29 Sep 2020 17:43:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33tfdsg0f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 17:43:47 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08THhjTv018874;
        Tue, 29 Sep 2020 17:43:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 10:43:45 -0700
Subject: [PATCH 5/5] xfs: xfs_defer_capture should absorb remaining
 transaction reservation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Date:   Tue, 29 Sep 2020 10:43:44 -0700
Message-ID: <160140142459.830233.7194402837807253154.stgit@magnolia>
In-Reply-To: <160140139198.830233.3093053332257853111.stgit@magnolia>
References: <160140139198.830233.3093053332257853111.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
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
 fs/xfs/libxfs/xfs_defer.c |    9 +++++++++
 fs/xfs/libxfs/xfs_defer.h |    1 +
 fs/xfs/xfs_log_recover.c  |    4 ++--
 3 files changed, 12 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 0cceebb390c4..4caaf5527403 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -579,6 +579,15 @@ xfs_defer_ops_capture(
 	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
 	tp->t_blk_res = tp->t_blk_res_used;
 
+	/*
+	 * Preserve the transaction reservation type.  The logcount is
+	 * hardwired to 1 to so that we can make forward progress in recovery
+	 * no matter how full the log might be, at a cost of more regrants.
+	 */
+	dfc->dfc_tres.tr_logres = tp->t_log_res;
+	dfc->dfc_tres.tr_logcount = 1;
+	dfc->dfc_tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+
 	return dfc;
 }
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index b1c7b761afd5..c447c79bbe74 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -76,6 +76,7 @@ struct xfs_defer_capture {
 	struct list_head	dfc_dfops;
 	unsigned int		dfc_tpflags;
 	unsigned int		dfc_blkres;
+	struct xfs_trans_res	dfc_tres;
 };
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b06c9881a13d..46e750279634 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2442,8 +2442,8 @@ xlog_finish_defer_ops(
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0,
-				0, XFS_TRANS_RESERVE, &tp);
+		error = xfs_trans_alloc(mp, &dfc->dfc_tres, 0, 0,
+				XFS_TRANS_RESERVE, &tp);
 		if (error)
 			return error;
 

