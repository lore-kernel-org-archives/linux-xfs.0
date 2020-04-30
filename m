Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F98AC83000
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74C7220787
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ShrQlNQD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgD3AtW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:49:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49568 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgD3AtV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:49:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0nJiR165721
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RJVFaMrEtJeMo4phRIdz9pnb4PS+QRyIs4qCk3x6MD8=;
 b=ShrQlNQDu/8leUbIKCS8Rx/f8yd2OStE8E4/szV1afrYAFMCWa9/StDmKkqxyIW8dEcY
 KcM6BdcFj3zMmeoahGcYV4CM2LQnw0FR/uncLhAef/bIGVNIzcdotJU+RvViB13ncOi7
 cVBwzJR/Z2mDdS0ww9vwl8/0YnbD3krKRztW39fRVnzi7NPtm0iV9OuR63P1k26XiA7c
 s7zmw/0PQHNt3AAnQCRSyL7rI1tt4VSniBKBT4cEHyez1FvCTU077H3dLpvtnuoCOtHc
 XolL/QO8mgtu3byJppHJCpFP9Rxk/Cshlgv/336PaKMEINBnDdGzy7h+f8HknIgUqDPz Kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30p01ny8m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0m0BI099998
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30pvd28k0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:19 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03U0nIUI014912
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 17:49:18 -0700
Subject: [PATCH 16/21] xfs: refactor recovered BUI log item playback
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:49:17 -0700
Message-ID: <158820775739.467894.14045299940661171182.stgit@magnolia>
In-Reply-To: <158820765488.467894.15408191148091671053.stgit@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=3 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=3 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the code that processes the log items created from the recovered
log items into the per-item source code files and use dispatch functions
to call them.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_item.c   |   31 ++++++++++++++-
 fs/xfs/xfs_bmap_item.h   |    3 -
 fs/xfs/xfs_log_recover.c |   95 ++++++----------------------------------------
 3 files changed, 41 insertions(+), 88 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index f5c19ea4affb..a0fb79e1d09f 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -28,6 +28,8 @@
 kmem_zone_t	*xfs_bui_zone;
 kmem_zone_t	*xfs_bud_zone;
 
+STATIC int xfs_bui_recover(struct xfs_trans *tp, struct xfs_bui_log_item *buip);
+
 static inline struct xfs_bui_log_item *BUI_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_bui_log_item, bui_item);
@@ -47,7 +49,7 @@ xfs_bui_item_free(
  * committed vs unpin operations in bulk insert operations. Hence the reference
  * count to ensure only the last caller frees the BUI.
  */
-void
+STATIC void
 xfs_bui_release(
 	struct xfs_bui_log_item	*buip)
 {
@@ -126,11 +128,36 @@ xfs_bui_item_release(
 	xfs_bui_release(BUI_ITEM(lip));
 }
 
+/* Recover the BUI if necessary. */
+STATIC int
+xfs_bui_item_recover(
+	struct xfs_log_item		*lip,
+	struct xfs_trans		*tp)
+{
+	struct xfs_ail			*ailp = lip->li_ailp;
+	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
+	int				error;
+
+	/*
+	 * Skip BUIs that we've already processed.
+	 */
+	if (test_bit(XFS_BUI_RECOVERED, &buip->bui_flags))
+		return 0;
+
+	spin_unlock(&ailp->ail_lock);
+	error = xfs_bui_recover(tp, buip);
+	spin_lock(&ailp->ail_lock);
+
+	return error;
+}
+
 static const struct xfs_item_ops xfs_bui_item_ops = {
+	.flags		= XFS_ITEM_TYPE_IS_INTENT,
 	.iop_size	= xfs_bui_item_size,
 	.iop_format	= xfs_bui_item_format,
 	.iop_unpin	= xfs_bui_item_unpin,
 	.iop_release	= xfs_bui_item_release,
+	.iop_recover	= xfs_bui_item_recover,
 };
 
 /*
@@ -431,7 +458,7 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
  * Process a bmap update intent item that was recovered from the log.
  * We need to update some inode's bmbt.
  */
-int
+STATIC int
 xfs_bui_recover(
 	struct xfs_trans		*parent_tp,
 	struct xfs_bui_log_item		*buip)
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index 515b1d5d6ab7..44d06e62f8f9 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -74,7 +74,4 @@ struct xfs_bud_log_item {
 extern struct kmem_zone	*xfs_bui_zone;
 extern struct kmem_zone	*xfs_bud_zone;
 
-void xfs_bui_release(struct xfs_bui_log_item *);
-int xfs_bui_recover(struct xfs_trans *parent_tp, struct xfs_bui_log_item *buip);
-
 #endif	/* __XFS_BMAP_ITEM_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9323bb5800d6..db4535cd74c1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2599,60 +2599,6 @@ xlog_recover_process_data(
 	return 0;
 }
 
-/* Recover the BUI if necessary. */
-STATIC int
-xlog_recover_process_bui(
-	struct xfs_trans		*parent_tp,
-	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
-{
-	struct xfs_bui_log_item		*buip;
-	int				error;
-
-	/*
-	 * Skip BUIs that we've already processed.
-	 */
-	buip = container_of(lip, struct xfs_bui_log_item, bui_item);
-	if (test_bit(XFS_BUI_RECOVERED, &buip->bui_flags))
-		return 0;
-
-	spin_unlock(&ailp->ail_lock);
-	error = xfs_bui_recover(parent_tp, buip);
-	spin_lock(&ailp->ail_lock);
-
-	return error;
-}
-
-/* Release the BUI since we're cancelling everything. */
-STATIC void
-xlog_recover_cancel_bui(
-	struct xfs_mount		*mp,
-	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
-{
-	struct xfs_bui_log_item		*buip;
-
-	buip = container_of(lip, struct xfs_bui_log_item, bui_item);
-
-	spin_unlock(&ailp->ail_lock);
-	xfs_bui_release(buip);
-	spin_lock(&ailp->ail_lock);
-}
-
-/* Is this log item a deferred action intent? */
-static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
-{
-	switch (lip->li_type) {
-	case XFS_LI_EFI:
-	case XFS_LI_RUI:
-	case XFS_LI_CUI:
-	case XFS_LI_BUI:
-		return true;
-	default:
-		return false;
-	}
-}
-
 /* Take all the collected deferred ops and finish them in order. */
 static int
 xlog_finish_defer_ops(
@@ -2740,10 +2686,11 @@ xlog_recover_process_intents(
 		 * We're done when we see something other than an intent.
 		 * There should be no intents left in the AIL now.
 		 */
-		if (!xlog_item_is_intent(lip)) {
+		if (!(lip->li_ops->flags & XFS_ITEM_TYPE_IS_INTENT)) {
 #ifdef DEBUG
 			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
-				ASSERT(!xlog_item_is_intent(lip));
+				ASSERT(lip->li_ops->flags &
+						XFS_ITEM_TYPE_IS_INTENT);
 #endif
 			break;
 		}
@@ -2757,20 +2704,11 @@ xlog_recover_process_intents(
 
 		/*
 		 * NOTE: If your intent processing routine can create more
-		 * deferred ops, you /must/ attach them to the dfops in this
-		 * routine or else those subsequent intents will get
+		 * deferred ops, you /must/ attach them to the transaction in
+		 * this routine or else those subsequent intents will get
 		 * replayed in the wrong order!
 		 */
-		switch (lip->li_type) {
-		case XFS_LI_EFI:
-		case XFS_LI_RUI:
-		case XFS_LI_CUI:
-			error = lip->li_ops->iop_recover(lip, parent_tp);
-			break;
-		case XFS_LI_BUI:
-			error = xlog_recover_process_bui(parent_tp, ailp, lip);
-			break;
-		}
+		error = lip->li_ops->iop_recover(lip, parent_tp);
 		if (error)
 			goto out;
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
@@ -2805,27 +2743,18 @@ xlog_recover_cancel_intents(
 		 * We're done when we see something other than an intent.
 		 * There should be no intents left in the AIL now.
 		 */
-		if (!xlog_item_is_intent(lip)) {
+		if (!(lip->li_ops->flags & XFS_ITEM_TYPE_IS_INTENT)) {
 #ifdef DEBUG
 			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
-				ASSERT(!xlog_item_is_intent(lip));
+				ASSERT(lip->li_ops->flags &
+						XFS_ITEM_TYPE_IS_INTENT);
 #endif
 			break;
 		}
 
-		switch (lip->li_type) {
-		case XFS_LI_EFI:
-		case XFS_LI_RUI:
-		case XFS_LI_CUI:
-			spin_unlock(&ailp->ail_lock);
-			lip->li_ops->iop_release(lip);
-			spin_lock(&ailp->ail_lock);
-			break;
-		case XFS_LI_BUI:
-			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
-			break;
-		}
-
+		spin_unlock(&ailp->ail_lock);
+		lip->li_ops->iop_release(lip);
+		spin_lock(&ailp->ail_lock);
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 	}
 

