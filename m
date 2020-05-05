Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C1AC3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07645206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B+XCzdJu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgEEBM2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:12:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50328 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEBM2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:12:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04514DSE143385
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dr6f4x0UpyMpZ55UGqE4u3DyUxa0dSEiL+ezV2PJJcU=;
 b=B+XCzdJuya0OHJ6y9ix1iKijTVCIW198iaKimvEZMs6KlJrYd+rRgnD+KRAT+ttWGe6w
 jqak96cWUA47DeDea6UYVWgfc/0ZTqmsu1Fdt2LECjgRhhb3oGGH2RUZ/rcQuozvPZsf
 mgILhRhr6JaynMLEmGhq/24loYCOAKNXDV42IRIr8eeWWvEQibQCjIcRciWqPqzhZp4s
 Rtc+dkBI3SGhzyMMDrHdVYjQ9ylaTLG5avN7S+mhan94GvY/egVkQSosMQ74xafoUDdC
 hRYmbuF/YKifL8jrvcVW1BgAgGPAp6QndX0zEonMeXDQuSo9q1zj53BPP83lzvJdQPEI Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09r2358-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04515SRT145335
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30sjnckxen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:25 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0451COPQ015144
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:12:23 -0700
Subject: [PATCH 17/28] xfs: refactor recovered BUI log item playback
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:12:22 -0700
Message-ID: <158864114272.182683.11138860973756666002.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=3
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050005
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
 fs/xfs/xfs_bmap_item.c   |   44 ++++++++++++++++++----
 fs/xfs/xfs_bmap_item.h   |    3 --
 fs/xfs/xfs_log_recover.c |   91 ++++++----------------------------------------
 3 files changed, 47 insertions(+), 91 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 0fbebef69e26..f88ebf8634c4 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -28,6 +28,8 @@
 kmem_zone_t	*xfs_bui_zone;
 kmem_zone_t	*xfs_bud_zone;
 
+static const struct xfs_item_ops xfs_bui_item_ops;
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
@@ -126,13 +128,6 @@ xfs_bui_item_release(
 	xfs_bui_release(BUI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_bui_item_ops = {
-	.iop_size	= xfs_bui_item_size,
-	.iop_format	= xfs_bui_item_format,
-	.iop_unpin	= xfs_bui_item_unpin,
-	.iop_release	= xfs_bui_item_release,
-};
-
 /*
  * Allocate and initialize an bui item with the given number of extents.
  */
@@ -425,7 +420,7 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
  * Process a bmap update intent item that was recovered from the log.
  * We need to update some inode's bmbt.
  */
-int
+STATIC int
 xfs_bui_recover(
 	struct xfs_trans		*parent_tp,
 	struct xfs_bui_log_item		*buip)
@@ -560,6 +555,37 @@ xfs_bui_recover(
 	return error;
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
+static const struct xfs_item_ops xfs_bui_item_ops = {
+	.iop_size	= xfs_bui_item_size,
+	.iop_format	= xfs_bui_item_format,
+	.iop_unpin	= xfs_bui_item_unpin,
+	.iop_release	= xfs_bui_item_release,
+	.iop_recover	= xfs_bui_item_recover,
+};
+
 /*
  * Copy an BUI format buffer from the given buf, and into the destination
  * BUI format structure.  The BUI/BUD items were designed not to need any
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
index ad5ac97ed0c7..20ee32c2652d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2553,60 +2553,6 @@ xlog_recover_process_data(
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
@@ -2641,6 +2587,12 @@ xlog_finish_defer_ops(
 	return xfs_trans_commit(tp);
 }
 
+/* Is this log item a deferred action intent? */
+static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
+{
+	return lip->li_ops->iop_recover != NULL;
+}
+
 /*
  * When this is called, all of the log intent items which did not have
  * corresponding log done items should be in the AIL.  What we do now
@@ -2711,20 +2663,11 @@ xlog_recover_process_intents(
 
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
@@ -2767,19 +2710,9 @@ xlog_recover_cancel_intents(
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
 

