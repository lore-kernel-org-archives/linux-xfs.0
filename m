Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10100C54FD0
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4E4120724
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:09:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZfrlzRIy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgDVCJc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:09:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40060 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgDVCJc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:09:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M28e4b084348
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:09:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5zYGYuceEVHw658cDV+ElKodeRGjjPbGfsUktGMQgq4=;
 b=ZfrlzRIyk659iOJDyKeASOfM/ysvf7JblCcS5Wf9x7P4tTWimh7JDxXu4kOWObxowdX4
 rchIoneehrLcblHQh13hFrsPAUF/yJT8HkbNSr98g2K86qZKnvUZlAOcZDAmmDujcNyE
 obbcQR5B0fi41EYAtx92psohl7vWA9IsRLF5ww5t7i6kfDGqLRqV3MEUF+Vbxrx0n4WY
 TA55Ip6KAckQ83SfjVxUJRrh1oUxyc0REddHTIU2TmGlIx2R8S3N6x1BujckpH1uA/xX
 EQzeLRzhs4aZBoAfoCRisrQrinB1EOIUf7SnvDj8qh6rj5j4eF6SQNv38jRZgnE8JhWh 4w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30ft6n81r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:09:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M21cQ2065041
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30gb3t4n9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:28 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M27Ra9014466
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:07:26 -0700
Subject: [PATCH 13/19] xfs: refactor CUI log item recovery dispatch
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:07:26 -0700
Message-ID: <158752124595.2140829.4459985307755446608.stgit@magnolia>
In-Reply-To: <158752116283.2140829.12265815455525398097.stgit@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=3 bulkscore=0 mlxscore=0
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

Move the refcount update intent and intent-done log recovery code into
the per-item source code files and use dispatch functions to call them.
We do these one at a time because there's a lot of code to move.  No
functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |    1 
 fs/xfs/xfs_log_recover.c        |  176 +--------------------------------------
 fs/xfs/xfs_refcount_item.c      |  175 ++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_refcount_item.h      |    5 -
 4 files changed, 178 insertions(+), 179 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 325f4907c563..936da98ff370 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -166,5 +166,6 @@ struct xlog_recover_intent_type {
 
 extern const struct xlog_recover_intent_type xlog_recover_extfree_type;
 extern const struct xlog_recover_intent_type xlog_recover_rmap_type;
+extern const struct xlog_recover_intent_type xlog_recover_refcount_type;
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ce63660d29f6..8a112f22583b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2012,126 +2012,6 @@ xlog_check_buffer_cancelled(
 	return 1;
 }
 
-/*
- * Copy an CUI format buffer from the given buf, and into the destination
- * CUI format structure.  The CUI/CUD items were designed not to need any
- * special alignment handling.
- */
-static int
-xfs_cui_copy_format(
-	struct xfs_log_iovec		*buf,
-	struct xfs_cui_log_format	*dst_cui_fmt)
-{
-	struct xfs_cui_log_format	*src_cui_fmt;
-	uint				len;
-
-	src_cui_fmt = buf->i_addr;
-	len = xfs_cui_log_format_sizeof(src_cui_fmt->cui_nextents);
-
-	if (buf->i_len == len) {
-		memcpy(dst_cui_fmt, src_cui_fmt, len);
-		return 0;
-	}
-	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
-	return -EFSCORRUPTED;
-}
-
-/*
- * This routine is called to create an in-core extent refcount update
- * item from the cui format structure which was logged on disk.
- * It allocates an in-core cui, copies the extents from the format
- * structure into it, and adds the cui to the AIL with the given
- * LSN.
- */
-STATIC int
-xlog_recover_cui_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item,
-	xfs_lsn_t			lsn)
-{
-	int				error;
-	struct xfs_mount		*mp = log->l_mp;
-	struct xfs_cui_log_item		*cuip;
-	struct xfs_cui_log_format	*cui_formatp;
-
-	cui_formatp = item->ri_buf[0].i_addr;
-
-	cuip = xfs_cui_init(mp, cui_formatp->cui_nextents);
-	error = xfs_cui_copy_format(&item->ri_buf[0], &cuip->cui_format);
-	if (error) {
-		xfs_cui_item_free(cuip);
-		return error;
-	}
-	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
-
-	spin_lock(&log->l_ailp->ail_lock);
-	/*
-	 * The CUI has two references. One for the CUD and one for CUI to ensure
-	 * it makes it into the AIL. Insert the CUI into the AIL directly and
-	 * drop the CUI reference. Note that xfs_trans_ail_update() drops the
-	 * AIL lock.
-	 */
-	xfs_trans_ail_update(log->l_ailp, &cuip->cui_item, lsn);
-	xfs_cui_release(cuip);
-	return 0;
-}
-
-
-/*
- * This routine is called when an CUD format structure is found in a committed
- * transaction in the log. Its purpose is to cancel the corresponding CUI if it
- * was still in the log. To do this it searches the AIL for the CUI with an id
- * equal to that in the CUD format structure. If we find it we drop the CUD
- * reference, which removes the CUI from the AIL and frees it.
- */
-STATIC int
-xlog_recover_cud_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item)
-{
-	struct xfs_cud_log_format	*cud_formatp;
-	struct xfs_cui_log_item		*cuip = NULL;
-	struct xfs_log_item		*lip;
-	uint64_t			cui_id;
-	struct xfs_ail_cursor		cur;
-	struct xfs_ail			*ailp = log->l_ailp;
-
-	cud_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
-		return -EFSCORRUPTED;
-	}
-	cui_id = cud_formatp->cud_cui_id;
-
-	/*
-	 * Search for the CUI with the id in the CUD format structure in the
-	 * AIL.
-	 */
-	spin_lock(&ailp->ail_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	while (lip != NULL) {
-		if (lip->li_type == XFS_LI_CUI) {
-			cuip = (struct xfs_cui_log_item *)lip;
-			if (cuip->cui_format.cui_id == cui_id) {
-				/*
-				 * Drop the CUD reference to the CUI. This
-				 * removes the CUI from the AIL and frees it.
-				 */
-				spin_unlock(&ailp->ail_lock);
-				xfs_cui_release(cuip);
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
  * Copy an BUI format buffer from the given buf, and into the destination
  * BUI format structure.  The BUI/BUD items were designed not to need any
@@ -2286,6 +2166,9 @@ xlog_intent_for_type(
 	case XFS_LI_RUD:
 	case XFS_LI_RUI:
 		return &xlog_recover_rmap_type;
+	case XFS_LI_CUI:
+	case XFS_LI_CUD:
+		return &xlog_recover_refcount_type;
 	default:
 		return NULL;
 	}
@@ -2298,6 +2181,7 @@ xlog_is_intent_done_item(
 	switch (ITEM_TYPE(item)) {
 	case XFS_LI_EFD:
 	case XFS_LI_RUD:
+	case XFS_LI_CUD:
 		return true;
 	default:
 		return false;
@@ -2321,10 +2205,6 @@ xlog_recover_intent_pass2(
 	}
 
 	switch (ITEM_TYPE(item)) {
-	case XFS_LI_CUI:
-		return xlog_recover_cui_pass2(log, item, current_lsn);
-	case XFS_LI_CUD:
-		return xlog_recover_cud_pass2(log, item);
 	case XFS_LI_BUI:
 		return xlog_recover_bui_pass2(log, item, current_lsn);
 	case XFS_LI_BUD:
@@ -2858,46 +2738,6 @@ xlog_recover_process_data(
 	return 0;
 }
 
-/* Recover the CUI if necessary. */
-STATIC int
-xlog_recover_process_cui(
-	struct xfs_trans		*parent_tp,
-	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
-{
-	struct xfs_cui_log_item		*cuip;
-	int				error;
-
-	/*
-	 * Skip CUIs that we've already processed.
-	 */
-	cuip = container_of(lip, struct xfs_cui_log_item, cui_item);
-	if (test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags))
-		return 0;
-
-	spin_unlock(&ailp->ail_lock);
-	error = xfs_cui_recover(parent_tp, cuip);
-	spin_lock(&ailp->ail_lock);
-
-	return error;
-}
-
-/* Release the CUI since we're cancelling everything. */
-STATIC void
-xlog_recover_cancel_cui(
-	struct xfs_mount		*mp,
-	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
-{
-	struct xfs_cui_log_item		*cuip;
-
-	cuip = container_of(lip, struct xfs_cui_log_item, cui_item);
-
-	spin_unlock(&ailp->ail_lock);
-	xfs_cui_release(cuip);
-	spin_lock(&ailp->ail_lock);
-}
-
 /* Recover the BUI if necessary. */
 STATIC int
 xlog_recover_process_bui(
@@ -3065,12 +2905,10 @@ xlog_recover_process_intents(
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
 		case XFS_LI_RUI:
+		case XFS_LI_CUI:
 			type = xlog_intent_for_type(lip->li_type);
 			error = type->process_intent(log, parent_tp, lip);
 			break;
-		case XFS_LI_CUI:
-			error = xlog_recover_process_cui(parent_tp, ailp, lip);
-			break;
 		case XFS_LI_BUI:
 			error = xlog_recover_process_bui(parent_tp, ailp, lip);
 			break;
@@ -3122,12 +2960,10 @@ xlog_recover_cancel_intents(
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
 		case XFS_LI_RUI:
+		case XFS_LI_CUI:
 			type = xlog_intent_for_type(lip->li_type);
 			type->cancel_intent(log, lip);
 			break;
-		case XFS_LI_CUI:
-			xlog_recover_cancel_cui(log->l_mp, ailp, lip);
-			break;
 		case XFS_LI_BUI:
 			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
 			break;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 8eeed73928cd..a1dac3d60a2a 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -18,6 +18,8 @@
 #include "xfs_log.h"
 #include "xfs_refcount.h"
 #include "xfs_error.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_cui_zone;
 kmem_zone_t	*xfs_cud_zone;
@@ -27,7 +29,7 @@ static inline struct xfs_cui_log_item *CUI_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_cui_log_item, cui_item);
 }
 
-void
+STATIC void
 xfs_cui_item_free(
 	struct xfs_cui_log_item	*cuip)
 {
@@ -44,7 +46,7 @@ xfs_cui_item_free(
  * committed vs unpin operations in bulk insert operations. Hence the reference
  * count to ensure only the last caller frees the CUI.
  */
-void
+STATIC void
 xfs_cui_release(
 	struct xfs_cui_log_item	*cuip)
 {
@@ -133,7 +135,7 @@ static const struct xfs_item_ops xfs_cui_item_ops = {
 /*
  * Allocate and initialize an cui item with the given number of extents.
  */
-struct xfs_cui_log_item *
+STATIC struct xfs_cui_log_item *
 xfs_cui_init(
 	struct xfs_mount		*mp,
 	uint				nextents)
@@ -443,7 +445,7 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
  * Process a refcount update intent item that was recovered from the log.
  * We need to update the refcountbt.
  */
-int
+STATIC int
 xfs_cui_recover(
 	struct xfs_trans		*parent_tp,
 	struct xfs_cui_log_item		*cuip)
@@ -590,3 +592,168 @@ xfs_cui_recover(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/*
+ * Copy an CUI format buffer from the given buf, and into the destination
+ * CUI format structure.  The CUI/CUD items were designed not to need any
+ * special alignment handling.
+ */
+static int
+xfs_cui_copy_format(
+	struct xfs_log_iovec		*buf,
+	struct xfs_cui_log_format	*dst_cui_fmt)
+{
+	struct xfs_cui_log_format	*src_cui_fmt;
+	uint				len;
+
+	src_cui_fmt = buf->i_addr;
+	len = xfs_cui_log_format_sizeof(src_cui_fmt->cui_nextents);
+
+	if (buf->i_len == len) {
+		memcpy(dst_cui_fmt, src_cui_fmt, len);
+		return 0;
+	}
+	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
+	return -EFSCORRUPTED;
+}
+
+/*
+ * This routine is called to create an in-core extent refcount update
+ * item from the cui format structure which was logged on disk.
+ * It allocates an in-core cui, copies the extents from the format
+ * structure into it, and adds the cui to the AIL with the given
+ * LSN.
+ */
+STATIC int
+xlog_recover_cui(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	int				error;
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_cui_log_item		*cuip;
+	struct xfs_cui_log_format	*cui_formatp;
+
+	cui_formatp = item->ri_buf[0].i_addr;
+
+	cuip = xfs_cui_init(mp, cui_formatp->cui_nextents);
+	error = xfs_cui_copy_format(&item->ri_buf[0], &cuip->cui_format);
+	if (error) {
+		xfs_cui_item_free(cuip);
+		return error;
+	}
+	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
+
+	spin_lock(&log->l_ailp->ail_lock);
+	/*
+	 * The CUI has two references. One for the CUD and one for CUI to ensure
+	 * it makes it into the AIL. Insert the CUI into the AIL directly and
+	 * drop the CUI reference. Note that xfs_trans_ail_update() drops the
+	 * AIL lock.
+	 */
+	xfs_trans_ail_update(log->l_ailp, &cuip->cui_item, lsn);
+	xfs_cui_release(cuip);
+	return 0;
+}
+
+
+/*
+ * This routine is called when an CUD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding CUI if it
+ * was still in the log. To do this it searches the AIL for the CUI with an id
+ * equal to that in the CUD format structure. If we find it we drop the CUD
+ * reference, which removes the CUI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_cud(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_cud_log_format	*cud_formatp;
+	struct xfs_cui_log_item		*cuip = NULL;
+	struct xfs_log_item		*lip;
+	uint64_t			cui_id;
+	struct xfs_ail_cursor		cur;
+	struct xfs_ail			*ailp = log->l_ailp;
+
+	cud_formatp = item->ri_buf[0].i_addr;
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+	cui_id = cud_formatp->cud_cui_id;
+
+	/*
+	 * Search for the CUI with the id in the CUD format structure in the
+	 * AIL.
+	 */
+	spin_lock(&ailp->ail_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		if (lip->li_type == XFS_LI_CUI) {
+			cuip = (struct xfs_cui_log_item *)lip;
+			if (cuip->cui_format.cui_id == cui_id) {
+				/*
+				 * Drop the CUD reference to the CUI. This
+				 * removes the CUI from the AIL and frees it.
+				 */
+				spin_unlock(&ailp->ail_lock);
+				xfs_cui_release(cuip);
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
+/* Recover the CUI if necessary. */
+STATIC int
+xlog_recover_process_cui(
+	struct xlog			*log,
+	struct xfs_trans		*parent_tp,
+	struct xfs_log_item		*lip)
+{
+	struct xfs_ail			*ailp = log->l_ailp;
+	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
+	int				error;
+
+	/*
+	 * Skip CUIs that we've already processed.
+	 */
+	if (test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags))
+		return 0;
+
+	spin_unlock(&ailp->ail_lock);
+	error = xfs_cui_recover(parent_tp, cuip);
+	spin_lock(&ailp->ail_lock);
+
+	return error;
+}
+
+/* Release the CUI since we're cancelling everything. */
+STATIC void
+xlog_recover_cancel_cui(
+	struct xlog			*log,
+	struct xfs_log_item		*lip)
+{
+	struct xfs_ail			*ailp = log->l_ailp;
+	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
+
+	spin_unlock(&ailp->ail_lock);
+	xfs_cui_release(cuip);
+	spin_lock(&ailp->ail_lock);
+}
+
+const struct xlog_recover_intent_type xlog_recover_refcount_type = {
+	.recover_intent		= xlog_recover_cui,
+	.recover_done		= xlog_recover_cud,
+	.process_intent		= xlog_recover_process_cui,
+	.cancel_intent		= xlog_recover_cancel_cui,
+};
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index e47530f30489..cfaa857673a6 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -77,9 +77,4 @@ struct xfs_cud_log_item {
 extern struct kmem_zone	*xfs_cui_zone;
 extern struct kmem_zone	*xfs_cud_zone;
 
-struct xfs_cui_log_item *xfs_cui_init(struct xfs_mount *, uint);
-void xfs_cui_item_free(struct xfs_cui_log_item *);
-void xfs_cui_release(struct xfs_cui_log_item *);
-int xfs_cui_recover(struct xfs_trans *parent_tp, struct xfs_cui_log_item *cuip);
-
 #endif	/* __XFS_REFCOUNT_ITEM_H__ */

