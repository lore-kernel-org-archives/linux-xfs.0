Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE4DC83000
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E663F20838
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DvDhW1+v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgD3Ate (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:49:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49696 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgD3Ate (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:49:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0nVbk165781
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GHRCRHc379TfhyE49GICI563yX6+FluZro07a+jFZGk=;
 b=DvDhW1+vJ0N2brJgHz5qJxDPWDuAffp4GdUyeekzqwdKoAlyVS2mK5uh/utXCpNaEloE
 g3KcRCjEXa8R4GChawZ/+6/mRn2SN4o1/VDxhJ8XBHpON71+HW+mUYC22l+lnLG0Qgd3
 FKtxf9R6VCDYlrVmBLr3OjCSFVJoBrySDo63ayum6M0giAXmX4eM869EULPZAu2vgUaA
 uJSWFYEURCTTfwMZydt7/NOp4QESFwAFYW+9Gv5rDBl0pb2wiPLiJDOmZaClIHAjVuPC
 CY0SEv3KjLn1pp9j9D+Uh5SGpMpE0rHkPsS0SeaMW3D4+c6e/D/xYuWknM21YduErPcy fA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30p01ny8mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0kllI087559
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30mxpma5rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:31 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03U0nUSI009879
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 17:49:24 -0700
Subject: [PATCH 17/21] xfs: refactor releasing finished intents during log
 recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:49:23 -0700
Message-ID: <158820776379.467894.2880135719884933490.stgit@magnolia>
In-Reply-To: <158820765488.467894.15408191148091671053.stgit@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=1 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the open-coded AIL item walking with a proper helper when we're
trying to release an intent item that has been finished.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |    4 ++++
 fs/xfs/xfs_bmap_item.c          |   41 +++++++++------------------------------
 fs/xfs/xfs_extfree_item.c       |   41 +++++++++------------------------------
 fs/xfs/xfs_log_recover.c        |   33 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_refcount_item.c      |   41 +++++++++------------------------------
 fs/xfs/xfs_rmap_item.c          |   41 +++++++++------------------------------
 6 files changed, 73 insertions(+), 128 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 5017d80c0f4b..bb21d512a824 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -124,4 +124,8 @@ bool xlog_is_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 bool xlog_put_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 void xlog_recover_iodone(struct xfs_buf *bp);
 
+typedef bool (*xlog_item_match_fn)(struct xfs_log_item *item, uint64_t id);
+void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
+		uint64_t intent_id, xlog_item_match_fn fn);
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index a0fb79e1d09f..bf5997f616a4 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -662,6 +662,13 @@ xlog_recover_bmap_intent_commit_pass2(
 	return 0;
 }
 
+STATIC bool
+xfs_bui_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return BUI_ITEM(lip)->bui_format.bui_id == intent_id;
+}
 
 /*
  * This routine is called when an BUD format structure is found in a committed
@@ -678,45 +685,15 @@ xlog_recover_bmap_done_commit_pass2(
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
 
+	xlog_recover_release_intent(log, XFS_LI_BUI, bud_formatp->bud_bui_id,
+			 xfs_bui_item_match);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 229c6dee0f85..57d33a5a42c5 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -724,6 +724,13 @@ xlog_recover_extfree_intent_commit_pass2(
 	return 0;
 }
 
+STATIC bool
+xfs_efi_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return EFI_ITEM(lip)->efi_format.efi_id == intent_id;
+}
 
 /*
  * This routine is called when an EFD format structure is found in a committed
@@ -739,46 +746,16 @@ xlog_recover_extfree_done_commit_pass2(
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
 
+	xlog_recover_release_intent(log, XFS_LI_EFI, efd_formatp->efd_efi_id,
+			 xfs_efi_item_match);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index db4535cd74c1..853500a51762 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1779,6 +1779,39 @@ xlog_clear_stale_blocks(
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
+	uint64_t		intent_id,
+	xlog_item_match_fn	fn)
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
+		if (!fn(lip, intent_id))
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
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index d291a640ce31..3c469a49e620 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -685,6 +685,13 @@ xlog_recover_refcount_intent_commit_pass2(
 	return 0;
 }
 
+STATIC bool
+xfs_cui_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return CUI_ITEM(lip)->cui_format.cui_id == intent_id;
+}
 
 /*
  * This routine is called when an CUD format structure is found in a committed
@@ -701,45 +708,15 @@ xlog_recover_refcount_done_commit_pass2(
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
 
+	xlog_recover_release_intent(log, XFS_LI_CUI, cud_formatp->cud_cui_id,
+			 xfs_cui_item_match);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 53348d48bf67..1de5c20cb624 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -677,6 +677,13 @@ xlog_recover_rmap_intent_commit_pass2(
 	return 0;
 }
 
+STATIC bool
+xfs_rui_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return RUI_ITEM(lip)->rui_format.rui_id == intent_id;
+}
 
 /*
  * This routine is called when an RUD format structure is found in a committed
@@ -693,42 +700,12 @@ xlog_recover_rmap_done_commit_pass2(
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
 
+	xlog_recover_release_intent(log, XFS_LI_RUI, rud_formatp->rud_rui_id,
+			 xfs_rui_item_match);
 	return 0;
 }
 

