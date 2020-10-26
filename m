Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD52C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6E0C20872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:40:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dfmchtib"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407431AbgJZXkE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:40:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46936 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407427AbgJZXkD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:40:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPwgW177218;
        Mon, 26 Oct 2020 23:39:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=eZ1A/B9xQINSeZk2hjrYYzHbZKkvehtyqw/6dOvo1RQ=;
 b=DfmchtibCJGTCW1bk5nUGnMEe7VUxT0KYNxzW1+IHhVDJltbaTQW7MoB5PXBz6lq2mTq
 fHneyBUyOjYSMBVakZF9Dv7xL242reeogXWmAQhmImrHZflKFvD3bNACu0VwRNxhO5/8
 W8Y3PyTjttf+DlerXzD+GKpG5ErYsFUCd7xFTfwqfyA2WYzyPWXwswO84Dezq26tt55M
 cJmsl0EAiohhJlIZ7aDSjO59plDj1KY/IEGVmI7CpW6758vAMbtTwZNpDq1HUdsV3EvD
 Jo79CBkW1ppwBEewy5yLeBslMRlbRMcgZPg8G4vp+7sd0HWt5Kz77xgvvbOPcnmD94kS dA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9saqddq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:39:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQEat032476;
        Mon, 26 Oct 2020 23:37:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34cx1q2cxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:37:37 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNba6a006795;
        Mon, 26 Oct 2020 23:37:36 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:37:36 -0700
Subject: [PATCH 06/21] xfs: log new intent items created as part of finishing
 recovered intent items
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:37:35 -0700
Message-ID: <160375545548.882906.16722362023139887455.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=2 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 93293bcbde93567efaf4e6bcd58cad270e1fcbf5

During a code inspection, I found a serious bug in the log intent item
recovery code when an intent item cannot complete all the work and
decides to requeue itself to get that done.  When this happens, the
item recovery creates a new incore deferred op representing the
remaining work and attaches it to the transaction that it allocated.  At
the end of _item_recover, it moves the entire chain of deferred ops to
the dummy parent_tp that xlog_recover_process_intents passed to it, but
fail to log a new intent item for the remaining work before committing
the transaction for the single unit of work.

xlog_finish_defer_ops logs those new intent items once recovery has
finished dealing with the intent items that it recovered, but this isn't
sufficient.  If the log is forced to disk after a recovered log item
decides to requeue itself and the system goes down before we call
xlog_finish_defer_ops, the second log recovery will never see the new
intent item and therefore has no idea that there was more work to do.
It will finish recovery leaving the filesystem in a corrupted state.

The same logic applies to /any/ deferred ops added during intent item
recovery, not just the one handling the remaining work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_defer.c |   26 ++++++++++++++++++++++++--
 libxfs/xfs_defer.h |    6 ++++++
 2 files changed, 30 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 34c10199dbac..1d1eac62d9cf 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -184,8 +184,9 @@ xfs_defer_create_intent(
 {
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 
-	dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
-			dfp->dfp_count, sort);
+	if (!dfp->dfp_intent)
+		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
+						     dfp->dfp_count, sort);
 }
 
 /*
@@ -388,6 +389,7 @@ xfs_defer_finish_one(
 			list_add(li, &dfp->dfp_work);
 			dfp->dfp_count++;
 			dfp->dfp_done = NULL;
+			dfp->dfp_intent = NULL;
 			xfs_defer_create_intent(tp, dfp, false);
 		}
 
@@ -550,3 +552,23 @@ xfs_defer_move(
 
 	xfs_defer_reset(stp);
 }
+
+/*
+ * Prepare a chain of fresh deferred ops work items to be completed later.  Log
+ * recovery requires the ability to put off until later the actual finishing
+ * work so that it can process unfinished items recovered from the log in
+ * correct order.
+ *
+ * Create and log intent items for all the work that we're capturing so that we
+ * can be assured that the items will get replayed if the system goes down
+ * before log recovery gets a chance to finish the work it put off.  Then we
+ * move the chain from stp to dtp.
+ */
+void
+xfs_defer_capture(
+	struct xfs_trans	*dtp,
+	struct xfs_trans	*stp)
+{
+	xfs_defer_create_intents(stp);
+	xfs_defer_move(dtp, stp);
+}
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 6b2ca580f2b0..3164199162b6 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -63,4 +63,10 @@ extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 
+/*
+ * Functions to capture a chain of deferred operations and continue them later.
+ * This doesn't normally happen except log recovery.
+ */
+void xfs_defer_capture(struct xfs_trans *dtp, struct xfs_trans *stp);
+
 #endif /* __XFS_DEFER_H__ */

