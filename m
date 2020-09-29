Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97364C4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A1C4208B8
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:45:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CMa69exd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgI2Rpf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:45:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39306 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728386AbgI2Rpe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 13:45:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THd3BY189278;
        Tue, 29 Sep 2020 17:45:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6pQ34UlvcfmgtXdQFd4C5pf8fimecJUPKJnQJEjQlAU=;
 b=CMa69exdz/QePNI3ok2gKfWo008I5PiI+OkTbaoR2+NR4EkBNokbuY8yqi69LAtOBMQy
 Fg6kBU0BrbSDpA0bbG5gBLjPp1ic/qCEeWHSAWlczKWy8Y7jsLTbb/cMLwEcKT178G1N
 DGHod3aM3jqBKrCYL2Cunr7K9E5Mhi6ehwEoJcUEWftqBf0B0UwvteiWa7b/gpElsr/m
 L+xVeUuQdBRF1x6sGW/OnBBgd0J+Jvhxiuj7O9r1r4nPS/S+1P6Se4voNxAFOUdTcXE4
 QmSfC7a1oJHNK/OhZ5tbJUZYrP3TNqPHqgFkIv2YWtjRGqXmrYPkqBa161jcU0ypOctM Sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33sx9n481d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 17:45:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THeQdJ167285;
        Tue, 29 Sep 2020 17:43:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33tfhxywfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 17:43:27 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08THhQPJ006196;
        Tue, 29 Sep 2020 17:43:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 10:43:26 -0700
Subject: [PATCH 2/5] xfs: remove XFS_LI_RECOVERED
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Date:   Tue, 29 Sep 2020 10:43:25 -0700
Message-ID: <160140140527.830233.8494766872686671838.stgit@magnolia>
In-Reply-To: <160140139198.830233.3093053332257853111.stgit@magnolia>
References: <160140139198.830233.3093053332257853111.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=1 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
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

The ->iop_recover method of a log intent item removes the recovered
intent item from the AIL by logging an intent done item and committing
the transaction, so it's superfluous to have this flag check.  Nothing
else uses it, so get rid of the flag entirely.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |    8 +++-----
 fs/xfs/xfs_trans.h       |    4 +---
 2 files changed, 4 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e0675071b39e..84f876c6d498 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2539,11 +2539,9 @@ xlog_recover_process_intents(
 		 * this routine or else those subsequent intents will get
 		 * replayed in the wrong order!
 		 */
-		if (!test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags)) {
-			spin_unlock(&ailp->ail_lock);
-			error = lip->li_ops->iop_recover(lip, parent_tp);
-			spin_lock(&ailp->ail_lock);
-		}
+		spin_unlock(&ailp->ail_lock);
+		error = lip->li_ops->iop_recover(lip, parent_tp);
+		spin_lock(&ailp->ail_lock);
 		if (error)
 			goto out;
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a71b4f443e39..ced62a35a62b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -55,14 +55,12 @@ struct xfs_log_item {
 #define	XFS_LI_ABORTED	1
 #define	XFS_LI_FAILED	2
 #define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
-#define	XFS_LI_RECOVERED 4	/* log intent item has been recovered */
 
 #define XFS_LI_FLAGS \
 	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
 	{ (1 << XFS_LI_ABORTED),	"ABORTED" }, \
 	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
-	{ (1 << XFS_LI_DIRTY),		"DIRTY" }, \
-	{ (1 << XFS_LI_RECOVERED),	"RECOVERED" }
+	{ (1 << XFS_LI_DIRTY),		"DIRTY" }
 
 struct xfs_item_ops {
 	unsigned flags;

