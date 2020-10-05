Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A71EC4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D8A820853
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:20:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nqchbhvP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgJESUQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 14:20:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37942 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgJESUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 14:20:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095I9rAW190073;
        Mon, 5 Oct 2020 18:20:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1xFSf79JrBq93DVlI+TLMCQRUh2f7gxP8W2d5QsPciM=;
 b=nqchbhvPOwu1G6rBuldRVeJvf33mKWSBg0XABEV6EF5TxLNufqYP7szHBdmdXq6eey5+
 OxUfpLdfukavnpzBjt2vyxK5X/kgJQnG0gAj95CfvcFPDGk2W9x1enn1cMbg0H3PGtkC
 e8lI3efHiPZJliwd4eBns/JqXPdmZa1NYVRSsZGwEQ/3BjRJJWAyWr2rSqGw4D5GJa8W
 5Xdw3X8gesm5jXKFAYx0Jyiw8Xl7nSpaaEtPrVcSbWceUYo+d3ZvKtkDSwq/xEyQFW1R
 Bos+cCPvc2rEy/EqUpLT/7aR88rYkHrmogXi2AKjrfPpOu24j5YDJeFstjsWHthJ9dRh bQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33ym34c4e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 18:20:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IA6AC019125;
        Mon, 5 Oct 2020 18:20:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33y37vn3bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 18:20:10 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 095IK9mU016274;
        Mon, 5 Oct 2020 18:20:09 GMT
Received: from localhost (/10.159.154.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 11:20:08 -0700
Subject: [PATCH 2/5] xfs: remove XFS_LI_RECOVERED
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Date:   Mon, 05 Oct 2020 11:20:07 -0700
Message-ID: <160192200762.2568681.12736534049337561259.stgit@magnolia>
In-Reply-To: <160192199449.2568681.679506644186725342.stgit@magnolia>
References: <160192199449.2568681.679506644186725342.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=1 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The ->iop_recover method of a log intent item removes the recovered
intent item from the AIL by logging an intent done item and committing
the transaction, so it's superfluous to have this flag check.  Nothing
else uses it, so get rid of the flag entirely.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

