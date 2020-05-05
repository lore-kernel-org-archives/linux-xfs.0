Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F36C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7BEA206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dy13nOIr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgEEBMv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:12:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50526 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgEEBMv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:12:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04516Jmr145491
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=VGvR6YGnH0d9oAzYqRwYvx4hacy/Xb/IrnWuhknF7M4=;
 b=dy13nOIre19PMsaOLbiEviIsp82pio66brFakaHcapZdrPtBdU04W5r01V8T6FBjzzyx
 /2mW8TP6daAnHQLpeL86p/5QdfWbO/DI6FTH3OA9ZSZQGr5qoQs5CggUncbUsRJHIgt6
 KRX+/MlYgB/MUU6fSn+Qrs9N0p7SoB4qUtJMuvnSdFBTLbZj37J1WmEo6bxiQ5vrLmnJ
 6YUwhVZLA9ssHC79qj7k9yT9cpsfD23gCLWSBabZyDamdfznqjdPTQsINrUWHXj4vdIK
 7fhTquCkuwkl2fR9fj+V+ZUcrZC2Ia/sqb39P0tRnRqJ43oMRcGRWhnehdTdn7YeDaMN +w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30s09r235s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04516fet149364
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30sjjxas1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:49 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451CmnY016655
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:12:48 -0700
Subject: [PATCH 21/28] xfs: refactor releasing finished intents during log
 recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:12:47 -0700
Message-ID: <158864116741.182683.12547831138234795563.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the open-coded AIL item walking with a proper helper when we're
trying to release an intent item that has been finished.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |    3 +++
 fs/xfs/xfs_bmap_item.c          |   42 +++++++++------------------------------
 fs/xfs/xfs_extfree_item.c       |   42 +++++++++------------------------------
 fs/xfs/xfs_log_recover.c        |   35 ++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_refcount_item.c      |   42 +++++++++------------------------------
 fs/xfs/xfs_rmap_item.c          |   42 +++++++++------------------------------
 fs/xfs/xfs_trans.h              |    1 +
 7 files changed, 78 insertions(+), 129 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index d4d6d4f84fda..b875819a1c04 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -126,4 +126,7 @@ bool xlog_put_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 void xlog_recover_iodone(struct xfs_buf *bp);
 int xlog_recover_process_unlinked(struct xlog *log);
 
+void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
+		uint64_t intent_id);
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index f88ebf8634c4..96627ea800c8 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -578,12 +578,21 @@ xfs_bui_item_recover(
 	return error;
 }
 
+STATIC bool
+xfs_bui_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return BUI_ITEM(lip)->bui_format.bui_id == intent_id;
+}
+
 static const struct xfs_item_ops xfs_bui_item_ops = {
 	.iop_size	= xfs_bui_item_size,
 	.iop_format	= xfs_bui_item_format,
 	.iop_unpin	= xfs_bui_item_unpin,
 	.iop_release	= xfs_bui_item_release,
 	.iop_recover	= xfs_bui_item_recover,
+	.iop_match	= xfs_bui_item_match,
 };
 
 /*
@@ -675,45 +684,14 @@ xlog_recover_bmap_done_commit_pass2(
 	xfs_lsn_t			lsn)
 {
 	struct xfs_bud_log_format	*bud_formatp;
-	struct xfs_bui_log_item		*buip = NULL;
-	struct xfs_log_item		*lip;
-	uint64_t			bui_id;
-	struct xfs_ail_cursor		cur;
-	struct xfs_ail			*ailp = log->l_ailp;
 
 	bud_formatp = item->ri_buf[0].i_addr;
 	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
 	}
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
 
+	xlog_recover_release_intent(log, XFS_LI_BUI, bud_formatp->bud_bui_id);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3fc8a9864217..4e1b10ab17a5 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -665,12 +665,21 @@ xfs_efi_item_recover(
 	return error;
 }
 
+STATIC bool
+xfs_efi_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return EFI_ITEM(lip)->efi_format.efi_id == intent_id;
+}
+
 static const struct xfs_item_ops xfs_efi_item_ops = {
 	.iop_size	= xfs_efi_item_size,
 	.iop_format	= xfs_efi_item_format,
 	.iop_unpin	= xfs_efi_item_unpin,
 	.iop_release	= xfs_efi_item_release,
 	.iop_recover	= xfs_efi_item_recover,
+	.iop_match	= xfs_efi_item_match,
 };
 
 
@@ -734,46 +743,15 @@ xlog_recover_extfree_done_commit_pass2(
 	struct xlog_recover_item	*item,
 	xfs_lsn_t			lsn)
 {
-	struct xfs_ail_cursor		cur;
 	struct xfs_efd_log_format	*efd_formatp;
-	struct xfs_efi_log_item		*efip = NULL;
-	struct xfs_log_item		*lip;
-	struct xfs_ail			*ailp = log->l_ailp;
-	uint64_t			efi_id;
 
 	efd_formatp = item->ri_buf[0].i_addr;
 	ASSERT((item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_32_t) +
 		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_32_t)))) ||
 	       (item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_64_t) +
 		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_64_t)))));
-	efi_id = efd_formatp->efd_efi_id;
-
-	/*
-	 * Search for the EFI with the id in the EFD format structure in the
-	 * AIL.
-	 */
-	spin_lock(&ailp->ail_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	while (lip != NULL) {
-		if (lip->li_type == XFS_LI_EFI) {
-			efip = (struct xfs_efi_log_item *)lip;
-			if (efip->efi_format.efi_id == efi_id) {
-				/*
-				 * Drop the EFD reference to the EFI. This
-				 * removes the EFI from the AIL and frees it.
-				 */
-				spin_unlock(&ailp->ail_lock);
-				xfs_efi_release(efip);
-				spin_lock(&ailp->ail_lock);
-				break;
-			}
-		}
-		lip = xfs_trans_ail_cursor_next(ailp, &cur);
-	}
-
-	xfs_trans_ail_cursor_done(&cur);
-	spin_unlock(&ailp->ail_lock);
 
+	xlog_recover_release_intent(log, XFS_LI_EFI, efd_formatp->efd_efi_id);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0ccc09c004f1..55477b9b9311 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1779,6 +1779,38 @@ xlog_clear_stale_blocks(
 	return 0;
 }
 
+/*
+ * Release the recovered intent item in the AIL that matches the given intent
+ * type and intent id.
+ */
+void
+xlog_recover_release_intent(
+	struct xlog		*log,
+	unsigned short		intent_type,
+	uint64_t		intent_id)
+{
+	struct xfs_ail_cursor	cur;
+	struct xfs_log_item	*lip;
+	struct xfs_ail		*ailp = log->l_ailp;
+
+	spin_lock(&ailp->ail_lock);
+	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0); lip != NULL;
+	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
+		if (lip->li_type != intent_type)
+			continue;
+		if (!lip->li_ops->iop_match(lip, intent_id))
+			continue;
+
+		spin_unlock(&ailp->ail_lock);
+		lip->li_ops->iop_release(lip);
+		spin_lock(&ailp->ail_lock);
+		break;
+	}
+
+	xfs_trans_ail_cursor_done(&cur);
+	spin_unlock(&ailp->ail_lock);
+}
+
 /******************************************************************************
  *
  *		Log recover routines
@@ -2590,7 +2622,8 @@ xlog_finish_defer_ops(
 /* Is this log item a deferred action intent? */
 static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 {
-	return lip->li_ops->iop_recover != NULL;
+	return lip->li_ops->iop_recover != NULL &&
+	       lip->li_ops->iop_match != NULL;
 }
 
 /*
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 5b72eebd8764..27126b136b5a 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -591,12 +591,21 @@ xfs_cui_item_recover(
 	return error;
 }
 
+STATIC bool
+xfs_cui_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return CUI_ITEM(lip)->cui_format.cui_id == intent_id;
+}
+
 static const struct xfs_item_ops xfs_cui_item_ops = {
 	.iop_size	= xfs_cui_item_size,
 	.iop_format	= xfs_cui_item_format,
 	.iop_unpin	= xfs_cui_item_unpin,
 	.iop_release	= xfs_cui_item_release,
 	.iop_recover	= xfs_cui_item_recover,
+	.iop_match	= xfs_cui_item_match,
 };
 
 /*
@@ -684,45 +693,14 @@ xlog_recover_refcount_done_commit_pass2(
 	xfs_lsn_t			lsn)
 {
 	struct xfs_cud_log_format	*cud_formatp;
-	struct xfs_cui_log_item		*cuip = NULL;
-	struct xfs_log_item		*lip;
-	uint64_t			cui_id;
-	struct xfs_ail_cursor		cur;
-	struct xfs_ail			*ailp = log->l_ailp;
 
 	cud_formatp = item->ri_buf[0].i_addr;
 	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
 	}
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
 
+	xlog_recover_release_intent(log, XFS_LI_CUI, cud_formatp->cud_cui_id);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index e763dd8ed0a6..3987f217415c 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -606,12 +606,21 @@ xfs_rui_item_recover(
 	return error;
 }
 
+STATIC bool
+xfs_rui_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return RUI_ITEM(lip)->rui_format.rui_id == intent_id;
+}
+
 static const struct xfs_item_ops xfs_rui_item_ops = {
 	.iop_size	= xfs_rui_item_size,
 	.iop_format	= xfs_rui_item_format,
 	.iop_unpin	= xfs_rui_item_unpin,
 	.iop_release	= xfs_rui_item_release,
 	.iop_recover	= xfs_rui_item_recover,
+	.iop_match	= xfs_rui_item_match,
 };
 
 /*
@@ -675,42 +684,11 @@ xlog_recover_rmap_done_commit_pass2(
 	xfs_lsn_t			lsn)
 {
 	struct xfs_rud_log_format	*rud_formatp;
-	struct xfs_rui_log_item		*ruip = NULL;
-	struct xfs_log_item		*lip;
-	uint64_t			rui_id;
-	struct xfs_ail_cursor		cur;
-	struct xfs_ail			*ailp = log->l_ailp;
 
 	rud_formatp = item->ri_buf[0].i_addr;
 	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_rud_log_format));
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
 
+	xlog_recover_release_intent(log, XFS_LI_RUI, rud_formatp->rud_rui_id);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 3f6a79108991..3e8808bb07c5 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -78,6 +78,7 @@ struct xfs_item_ops {
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
 	void (*iop_error)(struct xfs_log_item *, xfs_buf_t *);
 	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
+	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
 };
 
 /*

