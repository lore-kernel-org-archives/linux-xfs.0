Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31666C54FD0
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0296E20724
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:09:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HqVIfIFk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgDVCJi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:09:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40096 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgDVCJi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:09:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M28fpp085089
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:09:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+XRBsSLBUYAbPtx3snFou/4dwbIBVKoY9ZxaNmGNm8A=;
 b=HqVIfIFkqZgFQLbICwR5RjOK//3HKqE6QQWLa8bbzBGXmmCwW+d5PpkDUQZGeCQ9MIPN
 f8uS7YXZcV4MqJF+lfCn2z3LsMJnhUm6KMSo24Waz8gtnGJcaNR+keJ0W9FRWqndGhGH
 HJr/nsbfdQ0B/S9Z4zbXMCU9Ek0bnCVoq/5g3ZXpTZ3DN9uYWLvXe5t7ojsW8I6Rzow5
 GYHQvBUnS3VX/2Cbahrn5HMHS68jlPL1jEVn+Igv3vNzTuJkRdX2M6/8IjaLVqIaL1gz
 m/nlbHcRDLXUx4yRJSN3toKM/LwS4hMUEkQS3GR7wxmTlSXBTFEeAXrPFsxQw5f9+teD rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30ft6n81r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:09:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M22EtG075310
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30gb1hbgjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:34 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M27XqP014553
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:07:33 -0700
Subject: [PATCH 14/19] xfs: refactor BUI log item recovery dispatch
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:07:32 -0700
Message-ID: <158752125227.2140829.1899415848183364028.stgit@magnolia>
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
 engine=8.12.0-2003020000 definitions=main-2004220015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the bmap update intent and intent-done log recovery code into the
per-item source code files and use dispatch functions to call them.  We
do these one at a time because there's a lot of code to move.  No
functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |    1 
 fs/xfs/xfs_bmap_item.c          |  179 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_item.h          |    5 -
 fs/xfs/xfs_log_recover.c        |  222 +++------------------------------------
 4 files changed, 193 insertions(+), 214 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 936da98ff370..5bdba7ee98c5 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -167,5 +167,6 @@ struct xlog_recover_intent_type {
 extern const struct xlog_recover_intent_type xlog_recover_extfree_type;
 extern const struct xlog_recover_intent_type xlog_recover_rmap_type;
 extern const struct xlog_recover_intent_type xlog_recover_refcount_type;
+extern const struct xlog_recover_intent_type xlog_recover_bmap_type;
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ee6f4229cebc..b4fbc58b6906 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -22,6 +22,8 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_error.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_bui_zone;
 kmem_zone_t	*xfs_bud_zone;
@@ -31,7 +33,7 @@ static inline struct xfs_bui_log_item *BUI_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_bui_log_item, bui_item);
 }
 
-void
+STATIC void
 xfs_bui_item_free(
 	struct xfs_bui_log_item	*buip)
 {
@@ -45,7 +47,7 @@ xfs_bui_item_free(
  * committed vs unpin operations in bulk insert operations. Hence the reference
  * count to ensure only the last caller frees the BUI.
  */
-void
+STATIC void
 xfs_bui_release(
 	struct xfs_bui_log_item	*buip)
 {
@@ -134,7 +136,7 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
 /*
  * Allocate and initialize an bui item with the given number of extents.
  */
-struct xfs_bui_log_item *
+STATIC struct xfs_bui_log_item *
 xfs_bui_init(
 	struct xfs_mount		*mp)
 
@@ -429,7 +431,7 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
  * Process a bmap update intent item that was recovered from the log.
  * We need to update some inode's bmbt.
  */
-int
+STATIC int
 xfs_bui_recover(
 	struct xfs_trans		*parent_tp,
 	struct xfs_bui_log_item		*buip)
@@ -563,3 +565,172 @@ xfs_bui_recover(
 	}
 	return error;
 }
+
+/*
+ * Copy an BUI format buffer from the given buf, and into the destination
+ * BUI format structure.  The BUI/BUD items were designed not to need any
+ * special alignment handling.
+ */
+static int
+xfs_bui_copy_format(
+	struct xfs_log_iovec		*buf,
+	struct xfs_bui_log_format	*dst_bui_fmt)
+{
+	struct xfs_bui_log_format	*src_bui_fmt;
+	uint				len;
+
+	src_bui_fmt = buf->i_addr;
+	len = xfs_bui_log_format_sizeof(src_bui_fmt->bui_nextents);
+
+	if (buf->i_len == len) {
+		memcpy(dst_bui_fmt, src_bui_fmt, len);
+		return 0;
+	}
+	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
+	return -EFSCORRUPTED;
+}
+
+/*
+ * This routine is called to create an in-core extent bmap update
+ * item from the bui format structure which was logged on disk.
+ * It allocates an in-core bui, copies the extents from the format
+ * structure into it, and adds the bui to the AIL with the given
+ * LSN.
+ */
+STATIC int
+xlog_recover_bui(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	int				error;
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_bui_log_item		*buip;
+	struct xfs_bui_log_format	*bui_formatp;
+
+	bui_formatp = item->ri_buf[0].i_addr;
+
+	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+	buip = xfs_bui_init(mp);
+	error = xfs_bui_copy_format(&item->ri_buf[0], &buip->bui_format);
+	if (error) {
+		xfs_bui_item_free(buip);
+		return error;
+	}
+	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
+
+	spin_lock(&log->l_ailp->ail_lock);
+	/*
+	 * The RUI has two references. One for the RUD and one for RUI to ensure
+	 * it makes it into the AIL. Insert the RUI into the AIL directly and
+	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
+	 * AIL lock.
+	 */
+	xfs_trans_ail_update(log->l_ailp, &buip->bui_item, lsn);
+	xfs_bui_release(buip);
+	return 0;
+}
+
+
+/*
+ * This routine is called when an BUD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding BUI if it
+ * was still in the log. To do this it searches the AIL for the BUI with an id
+ * equal to that in the BUD format structure. If we find it we drop the BUD
+ * reference, which removes the BUI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_bud(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_bud_log_format	*bud_formatp;
+	struct xfs_bui_log_item		*buip = NULL;
+	struct xfs_log_item		*lip;
+	uint64_t			bui_id;
+	struct xfs_ail_cursor		cur;
+	struct xfs_ail			*ailp = log->l_ailp;
+
+	bud_formatp = item->ri_buf[0].i_addr;
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+	bui_id = bud_formatp->bud_bui_id;
+
+	/*
+	 * Search for the BUI with the id in the BUD format structure in the
+	 * AIL.
+	 */
+	spin_lock(&ailp->ail_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		if (lip->li_type == XFS_LI_BUI) {
+			buip = (struct xfs_bui_log_item *)lip;
+			if (buip->bui_format.bui_id == bui_id) {
+				/*
+				 * Drop the BUD reference to the BUI. This
+				 * removes the BUI from the AIL and frees it.
+				 */
+				spin_unlock(&ailp->ail_lock);
+				xfs_bui_release(buip);
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
+/* Recover the BUI if necessary. */
+STATIC int
+xlog_recover_process_bui(
+	struct xlog			*log,
+	struct xfs_trans		*parent_tp,
+	struct xfs_log_item		*lip)
+{
+	struct xfs_ail			*ailp = log->l_ailp;
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
+	error = xfs_bui_recover(parent_tp, buip);
+	spin_lock(&ailp->ail_lock);
+
+	return error;
+}
+
+/* Release the BUI since we're cancelling everything. */
+STATIC void
+xlog_recover_cancel_bui(
+	struct xlog			*log,
+	struct xfs_log_item		*lip)
+{
+	struct xfs_ail			*ailp = log->l_ailp;
+	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
+
+	spin_unlock(&ailp->ail_lock);
+	xfs_bui_release(buip);
+	spin_lock(&ailp->ail_lock);
+}
+
+const struct xlog_recover_intent_type xlog_recover_bmap_type = {
+	.recover_intent		= xlog_recover_bui,
+	.recover_done		= xlog_recover_bud,
+	.process_intent		= xlog_recover_process_bui,
+	.cancel_intent		= xlog_recover_cancel_bui,
+};
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index ad479cc73de8..44d06e62f8f9 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -74,9 +74,4 @@ struct xfs_bud_log_item {
 extern struct kmem_zone	*xfs_bui_zone;
 extern struct kmem_zone	*xfs_bud_zone;
 
-struct xfs_bui_log_item *xfs_bui_init(struct xfs_mount *);
-void xfs_bui_item_free(struct xfs_bui_log_item *);
-void xfs_bui_release(struct xfs_bui_log_item *);
-int xfs_bui_recover(struct xfs_trans *parent_tp, struct xfs_bui_log_item *buip);
-
 #endif	/* __XFS_BMAP_ITEM_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8a112f22583b..08066fa32b80 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2012,130 +2012,6 @@ xlog_check_buffer_cancelled(
 	return 1;
 }
 
-/*
- * Copy an BUI format buffer from the given buf, and into the destination
- * BUI format structure.  The BUI/BUD items were designed not to need any
- * special alignment handling.
- */
-static int
-xfs_bui_copy_format(
-	struct xfs_log_iovec		*buf,
-	struct xfs_bui_log_format	*dst_bui_fmt)
-{
-	struct xfs_bui_log_format	*src_bui_fmt;
-	uint				len;
-
-	src_bui_fmt = buf->i_addr;
-	len = xfs_bui_log_format_sizeof(src_bui_fmt->bui_nextents);
-
-	if (buf->i_len == len) {
-		memcpy(dst_bui_fmt, src_bui_fmt, len);
-		return 0;
-	}
-	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
-	return -EFSCORRUPTED;
-}
-
-/*
- * This routine is called to create an in-core extent bmap update
- * item from the bui format structure which was logged on disk.
- * It allocates an in-core bui, copies the extents from the format
- * structure into it, and adds the bui to the AIL with the given
- * LSN.
- */
-STATIC int
-xlog_recover_bui_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item,
-	xfs_lsn_t			lsn)
-{
-	int				error;
-	struct xfs_mount		*mp = log->l_mp;
-	struct xfs_bui_log_item		*buip;
-	struct xfs_bui_log_format	*bui_formatp;
-
-	bui_formatp = item->ri_buf[0].i_addr;
-
-	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
-		return -EFSCORRUPTED;
-	}
-	buip = xfs_bui_init(mp);
-	error = xfs_bui_copy_format(&item->ri_buf[0], &buip->bui_format);
-	if (error) {
-		xfs_bui_item_free(buip);
-		return error;
-	}
-	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
-
-	spin_lock(&log->l_ailp->ail_lock);
-	/*
-	 * The RUI has two references. One for the RUD and one for RUI to ensure
-	 * it makes it into the AIL. Insert the RUI into the AIL directly and
-	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
-	 * AIL lock.
-	 */
-	xfs_trans_ail_update(log->l_ailp, &buip->bui_item, lsn);
-	xfs_bui_release(buip);
-	return 0;
-}
-
-
-/*
- * This routine is called when an BUD format structure is found in a committed
- * transaction in the log. Its purpose is to cancel the corresponding BUI if it
- * was still in the log. To do this it searches the AIL for the BUI with an id
- * equal to that in the BUD format structure. If we find it we drop the BUD
- * reference, which removes the BUI from the AIL and frees it.
- */
-STATIC int
-xlog_recover_bud_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item)
-{
-	struct xfs_bud_log_format	*bud_formatp;
-	struct xfs_bui_log_item		*buip = NULL;
-	struct xfs_log_item		*lip;
-	uint64_t			bui_id;
-	struct xfs_ail_cursor		cur;
-	struct xfs_ail			*ailp = log->l_ailp;
-
-	bud_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
-		return -EFSCORRUPTED;
-	}
-	bui_id = bud_formatp->bud_bui_id;
-
-	/*
-	 * Search for the BUI with the id in the BUD format structure in the
-	 * AIL.
-	 */
-	spin_lock(&ailp->ail_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	while (lip != NULL) {
-		if (lip->li_type == XFS_LI_BUI) {
-			buip = (struct xfs_bui_log_item *)lip;
-			if (buip->bui_format.bui_id == bui_id) {
-				/*
-				 * Drop the BUD reference to the BUI. This
-				 * removes the BUI from the AIL and frees it.
-				 */
-				spin_unlock(&ailp->ail_lock);
-				xfs_bui_release(buip);
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
 STATIC int
 xlog_recover_commit_pass1(
 	struct xlog			*log,
@@ -2169,6 +2045,9 @@ xlog_intent_for_type(
 	case XFS_LI_CUI:
 	case XFS_LI_CUD:
 		return &xlog_recover_refcount_type;
+	case XFS_LI_BUI:
+	case XFS_LI_BUD:
+		return &xlog_recover_bmap_type;
 	default:
 		return NULL;
 	}
@@ -2182,6 +2061,7 @@ xlog_is_intent_done_item(
 	case XFS_LI_EFD:
 	case XFS_LI_RUD:
 	case XFS_LI_CUD:
+	case XFS_LI_BUD:
 		return true;
 	default:
 		return false;
@@ -2198,20 +2078,11 @@ xlog_recover_intent_pass2(
 	const struct xlog_recover_intent_type *type;
 
 	type = xlog_intent_for_type(ITEM_TYPE(item));
-	if (type) {
-		if (xlog_is_intent_done_item(item))
-			return type->recover_done(log, item);
-		return type->recover_intent(log, item, current_lsn);
-	}
-
-	switch (ITEM_TYPE(item)) {
-	case XFS_LI_BUI:
-		return xlog_recover_bui_pass2(log, item, current_lsn);
-	case XFS_LI_BUD:
-		return xlog_recover_bud_pass2(log, item);
-	}
-
-	return -EFSCORRUPTED;
+	if (!type)
+		return -EFSCORRUPTED;
+	if (xlog_is_intent_done_item(item))
+		return type->recover_done(log, item);
+	return type->recover_intent(log, item, current_lsn);
 }
 
 STATIC int
@@ -2738,46 +2609,6 @@ xlog_recover_process_data(
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
 /* Is this log item a deferred action intent? */
 static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 {
@@ -2881,7 +2712,8 @@ xlog_recover_process_intents(
 		 * We're done when we see something other than an intent.
 		 * There should be no intents left in the AIL now.
 		 */
-		if (!xlog_item_is_intent(lip)) {
+		type = xlog_intent_for_type(lip->li_type);
+		if (!type) {
 #ifdef DEBUG
 			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
 				ASSERT(!xlog_item_is_intent(lip));
@@ -2898,21 +2730,11 @@ xlog_recover_process_intents(
 
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
-			type = xlog_intent_for_type(lip->li_type);
-			error = type->process_intent(log, parent_tp, lip);
-			break;
-		case XFS_LI_BUI:
-			error = xlog_recover_process_bui(parent_tp, ailp, lip);
-			break;
-		}
+		error = type->process_intent(log, parent_tp, lip);
 		if (error)
 			goto out;
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
@@ -2949,7 +2771,8 @@ xlog_recover_cancel_intents(
 		 * We're done when we see something other than an intent.
 		 * There should be no intents left in the AIL now.
 		 */
-		if (!xlog_item_is_intent(lip)) {
+		type = xlog_intent_for_type(lip->li_type);
+		if (!type) {
 #ifdef DEBUG
 			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
 				ASSERT(!xlog_item_is_intent(lip));
@@ -2957,18 +2780,7 @@ xlog_recover_cancel_intents(
 			break;
 		}
 
-		switch (lip->li_type) {
-		case XFS_LI_EFI:
-		case XFS_LI_RUI:
-		case XFS_LI_CUI:
-			type = xlog_intent_for_type(lip->li_type);
-			type->cancel_intent(log, lip);
-			break;
-		case XFS_LI_BUI:
-			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
-			break;
-		}
-
+		type->cancel_intent(log, lip);
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 	}
 

