Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC9EC55181
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70F70206D5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:07:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VKkllGXe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgDVCH0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:07:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38280 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgDVCHZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:07:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M22eO5074066
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=XPlkkImOivyhE/2dyuhemtCI3JXVxn+SEn5KPo4reg8=;
 b=VKkllGXeRUeLUoLnNQz3xOzZ7aynLiEjdnJN/LYBvQheHrqUnPa1Hp5w16eMf+KNx4LY
 DDaUNHCAkNHFtmD42cGitOGhuxLwhKY+3SF2TS+m05nMQ7hZHwgJT/08Wa63Bcg3wAfy
 BfaRjID3pPF0HlkKWtlAbxFeBqXR/HMdOmdFgDAl9Qgdu+3cnwawMWIU0Mz8Dv+WCDN2
 Leo9QMUX/5z6wK9lT7zV/UV2G8rlEo1Nuca6jaZDt2sfKRu/iBH3iS4STW455w6Zyyy5
 Usdqk7Da9/yrulSsYtg0ln9MQqfXURrwWIM8aRjdiJCqAGjjkw6yUuIKpj6vmS4dgmKg tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30ft6n81jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M22EE7075372
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30gb1hbga3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:21 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03M27KBA031545
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:07:20 -0700
Subject: [PATCH 12/19] xfs: refactor RUI log item recovery dispatch
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:07:19 -0700
Message-ID: <158752123963.2140829.11785185891630195018.stgit@magnolia>
In-Reply-To: <158752116283.2140829.12265815455525398097.stgit@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=3 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the rmap update intent and intent-done log recovery code into the
per-item source code files and use dispatch functions to call them.  We
do these one at a time because there's a lot of code to move.  No
functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |    1 
 fs/xfs/xfs_log_recover.c        |  149 ++------------------------------------
 fs/xfs/xfs_rmap_item.c          |  153 +++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_rmap_item.h          |    7 --
 4 files changed, 154 insertions(+), 156 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 188f27ccf2ec..325f4907c563 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -165,5 +165,6 @@ struct xlog_recover_intent_type {
 };
 
 extern const struct xlog_recover_intent_type xlog_recover_extfree_type;
+extern const struct xlog_recover_intent_type xlog_recover_rmap_type;
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4d5eb81dadac..ce63660d29f6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2012,99 +2012,6 @@ xlog_check_buffer_cancelled(
 	return 1;
 }
 
-/*
- * This routine is called to create an in-core extent rmap update
- * item from the rui format structure which was logged on disk.
- * It allocates an in-core rui, copies the extents from the format
- * structure into it, and adds the rui to the AIL with the given
- * LSN.
- */
-STATIC int
-xlog_recover_rui_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item,
-	xfs_lsn_t			lsn)
-{
-	int				error;
-	struct xfs_mount		*mp = log->l_mp;
-	struct xfs_rui_log_item		*ruip;
-	struct xfs_rui_log_format	*rui_formatp;
-
-	rui_formatp = item->ri_buf[0].i_addr;
-
-	ruip = xfs_rui_init(mp, rui_formatp->rui_nextents);
-	error = xfs_rui_copy_format(&item->ri_buf[0], &ruip->rui_format);
-	if (error) {
-		xfs_rui_item_free(ruip);
-		return error;
-	}
-	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
-
-	spin_lock(&log->l_ailp->ail_lock);
-	/*
-	 * The RUI has two references. One for the RUD and one for RUI to ensure
-	 * it makes it into the AIL. Insert the RUI into the AIL directly and
-	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
-	 * AIL lock.
-	 */
-	xfs_trans_ail_update(log->l_ailp, &ruip->rui_item, lsn);
-	xfs_rui_release(ruip);
-	return 0;
-}
-
-
-/*
- * This routine is called when an RUD format structure is found in a committed
- * transaction in the log. Its purpose is to cancel the corresponding RUI if it
- * was still in the log. To do this it searches the AIL for the RUI with an id
- * equal to that in the RUD format structure. If we find it we drop the RUD
- * reference, which removes the RUI from the AIL and frees it.
- */
-STATIC int
-xlog_recover_rud_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item)
-{
-	struct xfs_rud_log_format	*rud_formatp;
-	struct xfs_rui_log_item		*ruip = NULL;
-	struct xfs_log_item		*lip;
-	uint64_t			rui_id;
-	struct xfs_ail_cursor		cur;
-	struct xfs_ail			*ailp = log->l_ailp;
-
-	rud_formatp = item->ri_buf[0].i_addr;
-	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_rud_log_format));
-	rui_id = rud_formatp->rud_rui_id;
-
-	/*
-	 * Search for the RUI with the id in the RUD format structure in the
-	 * AIL.
-	 */
-	spin_lock(&ailp->ail_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	while (lip != NULL) {
-		if (lip->li_type == XFS_LI_RUI) {
-			ruip = (struct xfs_rui_log_item *)lip;
-			if (ruip->rui_format.rui_id == rui_id) {
-				/*
-				 * Drop the RUD reference to the RUI. This
-				 * removes the RUI from the AIL and frees it.
-				 */
-				spin_unlock(&ailp->ail_lock);
-				xfs_rui_release(ruip);
-				spin_lock(&ailp->ail_lock);
-				break;
-			}
-		}
-		lip = xfs_trans_ail_cursor_next(ailp, &cur);
-	}
-
-	xfs_trans_ail_cursor_done(&cur);
-	spin_unlock(&ailp->ail_lock);
-
-	return 0;
-}
-
 /*
  * Copy an CUI format buffer from the given buf, and into the destination
  * CUI format structure.  The CUI/CUD items were designed not to need any
@@ -2376,6 +2283,9 @@ xlog_intent_for_type(
 	case XFS_LI_EFD:
 	case XFS_LI_EFI:
 		return &xlog_recover_extfree_type;
+	case XFS_LI_RUD:
+	case XFS_LI_RUI:
+		return &xlog_recover_rmap_type;
 	default:
 		return NULL;
 	}
@@ -2387,6 +2297,7 @@ xlog_is_intent_done_item(
 {
 	switch (ITEM_TYPE(item)) {
 	case XFS_LI_EFD:
+	case XFS_LI_RUD:
 		return true;
 	default:
 		return false;
@@ -2410,10 +2321,6 @@ xlog_recover_intent_pass2(
 	}
 
 	switch (ITEM_TYPE(item)) {
-	case XFS_LI_RUI:
-		return xlog_recover_rui_pass2(log, item, current_lsn);
-	case XFS_LI_RUD:
-		return xlog_recover_rud_pass2(log, item);
 	case XFS_LI_CUI:
 		return xlog_recover_cui_pass2(log, item, current_lsn);
 	case XFS_LI_CUD:
@@ -2951,46 +2858,6 @@ xlog_recover_process_data(
 	return 0;
 }
 
-/* Recover the RUI if necessary. */
-STATIC int
-xlog_recover_process_rui(
-	struct xfs_mount		*mp,
-	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
-{
-	struct xfs_rui_log_item		*ruip;
-	int				error;
-
-	/*
-	 * Skip RUIs that we've already processed.
-	 */
-	ruip = container_of(lip, struct xfs_rui_log_item, rui_item);
-	if (test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags))
-		return 0;
-
-	spin_unlock(&ailp->ail_lock);
-	error = xfs_rui_recover(mp, ruip);
-	spin_lock(&ailp->ail_lock);
-
-	return error;
-}
-
-/* Release the RUI since we're cancelling everything. */
-STATIC void
-xlog_recover_cancel_rui(
-	struct xfs_mount		*mp,
-	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
-{
-	struct xfs_rui_log_item		*ruip;
-
-	ruip = container_of(lip, struct xfs_rui_log_item, rui_item);
-
-	spin_unlock(&ailp->ail_lock);
-	xfs_rui_release(ruip);
-	spin_lock(&ailp->ail_lock);
-}
-
 /* Recover the CUI if necessary. */
 STATIC int
 xlog_recover_process_cui(
@@ -3197,12 +3064,10 @@ xlog_recover_process_intents(
 		 */
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
+		case XFS_LI_RUI:
 			type = xlog_intent_for_type(lip->li_type);
 			error = type->process_intent(log, parent_tp, lip);
 			break;
-		case XFS_LI_RUI:
-			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
-			break;
 		case XFS_LI_CUI:
 			error = xlog_recover_process_cui(parent_tp, ailp, lip);
 			break;
@@ -3256,12 +3121,10 @@ xlog_recover_cancel_intents(
 
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
+		case XFS_LI_RUI:
 			type = xlog_intent_for_type(lip->li_type);
 			type->cancel_intent(log, lip);
 			break;
-		case XFS_LI_RUI:
-			xlog_recover_cancel_rui(log->l_mp, ailp, lip);
-			break;
 		case XFS_LI_CUI:
 			xlog_recover_cancel_cui(log->l_mp, ailp, lip);
 			break;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 4911b68f95dd..1ef752563f37 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -18,6 +18,8 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_error.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_rui_zone;
 kmem_zone_t	*xfs_rud_zone;
@@ -27,7 +29,7 @@ static inline struct xfs_rui_log_item *RUI_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_rui_log_item, rui_item);
 }
 
-void
+STATIC void
 xfs_rui_item_free(
 	struct xfs_rui_log_item	*ruip)
 {
@@ -44,7 +46,7 @@ xfs_rui_item_free(
  * committed vs unpin operations in bulk insert operations. Hence the reference
  * count to ensure only the last caller frees the RUI.
  */
-void
+STATIC void
 xfs_rui_release(
 	struct xfs_rui_log_item	*ruip)
 {
@@ -132,7 +134,7 @@ static const struct xfs_item_ops xfs_rui_item_ops = {
 /*
  * Allocate and initialize an rui item with the given number of extents.
  */
-struct xfs_rui_log_item *
+STATIC struct xfs_rui_log_item *
 xfs_rui_init(
 	struct xfs_mount		*mp,
 	uint				nextents)
@@ -160,7 +162,7 @@ xfs_rui_init(
  * RUI format structure.  The RUI/RUD items were designed not to need any
  * special alignment handling.
  */
-int
+STATIC int
 xfs_rui_copy_format(
 	struct xfs_log_iovec		*buf,
 	struct xfs_rui_log_format	*dst_rui_fmt)
@@ -487,9 +489,9 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
  * Process an rmap update intent item that was recovered from the log.
  * We need to update the rmapbt.
  */
-int
+STATIC int
 xfs_rui_recover(
-	struct xfs_mount		*mp,
+	struct xfs_trans		*parent_tp,
 	struct xfs_rui_log_item		*ruip)
 {
 	int				i;
@@ -503,6 +505,7 @@ xfs_rui_recover(
 	xfs_exntst_t			state;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
+	struct xfs_mount		*mp = parent_tp->t_mountp;
 
 	ASSERT(!test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags));
 
@@ -606,3 +609,141 @@ xfs_rui_recover(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/*
+ * This routine is called to create an in-core extent rmap update
+ * item from the rui format structure which was logged on disk.
+ * It allocates an in-core rui, copies the extents from the format
+ * structure into it, and adds the rui to the AIL with the given
+ * LSN.
+ */
+STATIC int
+xlog_recover_rui(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	int				error;
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_rui_log_item		*ruip;
+	struct xfs_rui_log_format	*rui_formatp;
+
+	rui_formatp = item->ri_buf[0].i_addr;
+
+	ruip = xfs_rui_init(mp, rui_formatp->rui_nextents);
+	error = xfs_rui_copy_format(&item->ri_buf[0], &ruip->rui_format);
+	if (error) {
+		xfs_rui_item_free(ruip);
+		return error;
+	}
+	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
+
+	spin_lock(&log->l_ailp->ail_lock);
+	/*
+	 * The RUI has two references. One for the RUD and one for RUI to ensure
+	 * it makes it into the AIL. Insert the RUI into the AIL directly and
+	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
+	 * AIL lock.
+	 */
+	xfs_trans_ail_update(log->l_ailp, &ruip->rui_item, lsn);
+	xfs_rui_release(ruip);
+	return 0;
+}
+
+
+/*
+ * This routine is called when an RUD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding RUI if it
+ * was still in the log. To do this it searches the AIL for the RUI with an id
+ * equal to that in the RUD format structure. If we find it we drop the RUD
+ * reference, which removes the RUI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_rud(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_rud_log_format	*rud_formatp;
+	struct xfs_rui_log_item		*ruip = NULL;
+	struct xfs_log_item		*lip;
+	uint64_t			rui_id;
+	struct xfs_ail_cursor		cur;
+	struct xfs_ail			*ailp = log->l_ailp;
+
+	rud_formatp = item->ri_buf[0].i_addr;
+	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_rud_log_format));
+	rui_id = rud_formatp->rud_rui_id;
+
+	/*
+	 * Search for the RUI with the id in the RUD format structure in the
+	 * AIL.
+	 */
+	spin_lock(&ailp->ail_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		if (lip->li_type == XFS_LI_RUI) {
+			ruip = (struct xfs_rui_log_item *)lip;
+			if (ruip->rui_format.rui_id == rui_id) {
+				/*
+				 * Drop the RUD reference to the RUI. This
+				 * removes the RUI from the AIL and frees it.
+				 */
+				spin_unlock(&ailp->ail_lock);
+				xfs_rui_release(ruip);
+				spin_lock(&ailp->ail_lock);
+				break;
+			}
+		}
+		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+	}
+
+	xfs_trans_ail_cursor_done(&cur);
+	spin_unlock(&ailp->ail_lock);
+
+	return 0;
+}
+
+/* Recover the RUI if necessary. */
+STATIC int
+xlog_recover_process_rui(
+	struct xlog			*log,
+	struct xfs_trans		*parent_tp,
+	struct xfs_log_item		*lip)
+{
+	struct xfs_ail			*ailp = log->l_ailp;
+	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
+	int				error;
+
+	/*
+	 * Skip RUIs that we've already processed.
+	 */
+	if (test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags))
+		return 0;
+
+	spin_unlock(&ailp->ail_lock);
+	error = xfs_rui_recover(parent_tp, ruip);
+	spin_lock(&ailp->ail_lock);
+
+	return error;
+}
+
+/* Release the RUI since we're cancelling everything. */
+STATIC void
+xlog_recover_cancel_rui(
+	struct xlog			*log,
+	struct xfs_log_item		*lip)
+{
+	struct xfs_ail			*ailp = log->l_ailp;
+	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
+
+	spin_unlock(&ailp->ail_lock);
+	xfs_rui_release(ruip);
+	spin_lock(&ailp->ail_lock);
+}
+
+const struct xlog_recover_intent_type xlog_recover_rmap_type = {
+	.recover_intent		= xlog_recover_rui,
+	.recover_done		= xlog_recover_rud,
+	.process_intent		= xlog_recover_process_rui,
+	.cancel_intent		= xlog_recover_cancel_rui,
+};
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 8708e4a5aa5c..48a77a6f5c94 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -77,11 +77,4 @@ struct xfs_rud_log_item {
 extern struct kmem_zone	*xfs_rui_zone;
 extern struct kmem_zone	*xfs_rud_zone;
 
-struct xfs_rui_log_item *xfs_rui_init(struct xfs_mount *, uint);
-int xfs_rui_copy_format(struct xfs_log_iovec *buf,
-		struct xfs_rui_log_format *dst_rui_fmt);
-void xfs_rui_item_free(struct xfs_rui_log_item *);
-void xfs_rui_release(struct xfs_rui_log_item *);
-int xfs_rui_recover(struct xfs_mount *mp, struct xfs_rui_log_item *ruip);
-
 #endif	/* __XFS_RMAP_ITEM_H__ */

