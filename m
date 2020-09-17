Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D40C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73B4F2137B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:29:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ai3JTgzh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgIQD27 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 23:28:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49240 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIQD25 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:28:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3O7DM162334;
        Thu, 17 Sep 2020 03:28:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=nwos2l9XFZ0yB6xMYjN6ySgZQElBO3M2i7wL1JUybjU=;
 b=ai3JTgzhpNfaewtTDELtZlTDfEUmBYQx5z4cPx/MFMOWQz9ynqbxThJOP/JTVESuwulK
 y0O4eJyMe8p+omCYO1USTrNkRB56KuLR+S8d1M2ksDdQz3gCyG31e9wDQfFZBz883qJm
 gjPjBS3rLaFfqbK+v+2WhDN5ZEz33SxbK182qjA7X3vGF9u8Lr3yhdnNaXZ+RK61owxQ
 KKnNFo6D7L2zhKoKxdPS7rH7z83rzfwwnAfeAqIpwMrnEgvnilt1X9TU5Ztq5kQhctlv
 0aI07PV/OXO1SsMOSJjn+etoGBcxRkfctAu0TtzZFcBYKqBJv6m/RlNCzf1AjoChTi6C gA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33gnrr6j76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 03:28:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3Q80K181992;
        Thu, 17 Sep 2020 03:28:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33hm340rgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 03:28:51 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H3Sp8w029891;
        Thu, 17 Sep 2020 03:28:51 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:28:50 +0000
Subject: [PATCH 1/2] xfs: log new intent items created as part of finishing
 recovered intent items
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 16 Sep 2020 20:28:49 -0700
Message-ID: <160031332982.3624373.6230830770363563010.stgit@magnolia>
In-Reply-To: <160031332353.3624373.16349101558356065522.stgit@magnolia>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=3
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

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
---
 fs/xfs/libxfs/xfs_defer.c  |   26 ++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h  |    6 ++++++
 fs/xfs/xfs_bmap_item.c     |    2 +-
 fs/xfs/xfs_refcount_item.c |    2 +-
 4 files changed, 32 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index d8f586256add..29e9762f3b77 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -186,8 +186,9 @@ xfs_defer_create_intent(
 {
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 
-	dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
-			dfp->dfp_count, sort);
+	if (!dfp->dfp_intent)
+		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
+						     dfp->dfp_count, sort);
 }
 
 /*
@@ -390,6 +391,7 @@ xfs_defer_finish_one(
 			list_add(li, &dfp->dfp_work);
 			dfp->dfp_count++;
 			dfp->dfp_done = NULL;
+			dfp->dfp_intent = NULL;
 			xfs_defer_create_intent(tp, dfp, false);
 		}
 
@@ -552,3 +554,23 @@ xfs_defer_move(
 
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
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 6b2ca580f2b0..3164199162b6 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
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
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ec3691372e7c..815a0563288f 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -534,7 +534,7 @@ xfs_bui_item_recover(
 		xfs_bmap_unmap_extent(tp, ip, &irec);
 	}
 
-	xfs_defer_move(parent_tp, tp);
+	xfs_defer_capture(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index ca93b6488377..492d80a0b406 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -555,7 +555,7 @@ xfs_cui_item_recover(
 	}
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	xfs_defer_move(parent_tp, tp);
+	xfs_defer_capture(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	return error;
 

