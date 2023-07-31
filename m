Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8852C001DE
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jul 2023 12:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbjGaMuW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jul 2023 08:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbjGaMuV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jul 2023 08:50:21 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCFC10DF
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jul 2023 05:50:19 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RDygr3qY1zLnyR;
        Mon, 31 Jul 2023 20:47:36 +0800 (CST)
Received: from localhost.localdomain (10.175.127.227) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 20:50:16 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>, <david@fromorbit.com>
CC:     <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <leo.lilong@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH v3 1/3] xfs: factor out xfs_defer_pending_abort
Date:   Mon, 31 Jul 2023 20:46:17 +0800
Message-ID: <20230731124619.3925403-2-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230731124619.3925403-1-leo.lilong@huawei.com>
References: <20230731124619.3925403-1-leo.lilong@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Factor out xfs_defer_pending_abort() from xfs_defer_trans_abort(), which
not use transaction parameter, so it can be used after the transaction
life cycle.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index bcfb6a4203cd..88388e12f8e7 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -245,21 +245,18 @@ xfs_defer_create_intents(
 	return ret;
 }
 
-/* Abort all the intents that were committed. */
 STATIC void
-xfs_defer_trans_abort(
-	struct xfs_trans		*tp,
-	struct list_head		*dop_pending)
+xfs_defer_pending_abort(
+	struct xfs_mount		*mp,
+	struct list_head		*dop_list)
 {
 	struct xfs_defer_pending	*dfp;
 	const struct xfs_defer_op_type	*ops;
 
-	trace_xfs_defer_trans_abort(tp, _RET_IP_);
-
 	/* Abort intent items that don't have a done item. */
-	list_for_each_entry(dfp, dop_pending, dfp_list) {
+	list_for_each_entry(dfp, dop_list, dfp_list) {
 		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
+		trace_xfs_defer_pending_abort(mp, dfp);
 		if (dfp->dfp_intent && !dfp->dfp_done) {
 			ops->abort_intent(dfp->dfp_intent);
 			dfp->dfp_intent = NULL;
@@ -267,6 +264,16 @@ xfs_defer_trans_abort(
 	}
 }
 
+/* Abort all the intents that were committed. */
+STATIC void
+xfs_defer_trans_abort(
+	struct xfs_trans		*tp,
+	struct list_head		*dop_pending)
+{
+	trace_xfs_defer_trans_abort(tp, _RET_IP_);
+	xfs_defer_pending_abort(tp->t_mountp, dop_pending);
+}
+
 /*
  * Capture resources that the caller said not to release ("held") when the
  * transaction commits.  Caller is responsible for zero-initializing @dres.
-- 
2.31.1

