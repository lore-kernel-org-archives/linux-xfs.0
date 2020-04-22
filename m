Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2472AC2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFCB1206D5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:07:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YjvgjkWx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgDVCHp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:07:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38606 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgDVCHp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:07:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M22r1b074469
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aTyyoNtIp2wtC037ugm1hQS+wK4J35WQr25ZVV5gpIk=;
 b=YjvgjkWxu1+5xmdbjhw5tcKyVxZhpFW5yXJbHLndYMh2H6ikda4ksmhZoyYIe1oarTJn
 GJofsCR6hxLsN16NCRnvOQLtC+pOZxLI1rXkTasrxmGFuS/rQF9jcnTR2KvODLT2G7ow
 eEgrp2Z70m5Yi3XRLiH6hdDmC/UESe9Wm7mPOpSbOs8i6YNvMwC3eHEVNjHjb88CjnmQ
 M4TVrLqIrDAvYotXc0JyvvhOhst87Yom+g3/jdAMkqCcqAHBASNjUqghJnA8GmJRRCAX
 h59PLelnwvaY3CbsJcyapQEnzr+RtDXXKhUEeaX+TPvcY1rV0r1IDDXTeuE5nW63wRVm 3w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30ft6n81kg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M22Xg7053843
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30gbbfggqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:41 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M27f2X017916
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:07:41 -0700
Subject: [PATCH 15/19] xfs: refactor releasing finished intents during log
 recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:07:38 -0700
Message-ID: <158752125867.2140829.718007064092831514.stgit@magnolia>
In-Reply-To: <158752116283.2140829.12265815455525398097.stgit@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=1 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the open-coded AIL item walking with a proper helper when we're
trying to release an intent item that has been finished.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |    5 +++
 fs/xfs/xfs_bmap_item.c          |   56 +++++++++++++++++----------------------
 fs/xfs/xfs_extfree_item.c       |   56 +++++++++++++++++----------------------
 fs/xfs/xfs_log_recover.c        |   27 +++++++++++++++++++
 fs/xfs/xfs_refcount_item.c      |   56 +++++++++++++++++----------------------
 fs/xfs/xfs_rmap_item.c          |   56 +++++++++++++++++----------------------
 6 files changed, 128 insertions(+), 128 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 5bdba7ee98c5..ac1adccc8451 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -169,4 +169,9 @@ extern const struct xlog_recover_intent_type xlog_recover_rmap_type;
 extern const struct xlog_recover_intent_type xlog_recover_refcount_type;
 extern const struct xlog_recover_intent_type xlog_recover_bmap_type;
 
+typedef bool (*xlog_recover_release_intent_fn)(struct xlog *log,
+		struct xfs_log_item *item, uint64_t intent_id);
+void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
+		uint64_t intent_id, xlog_recover_release_intent_fn fn);
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index b4fbc58b6906..cd593b98f102 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -634,6 +634,28 @@ xlog_recover_bui(
 	return 0;
 }
 
+STATIC bool
+xlog_release_bui(
+	struct xlog		*log,
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	struct xfs_bui_log_item	*buip = BUI_ITEM(lip);
+	struct xfs_ail		*ailp = log->l_ailp;
+
+	if (buip->bui_format.bui_id == intent_id) {
+		/*
+		 * Drop the BUD reference to the BUI. This
+		 * removes the BUI from the AIL and frees it.
+		 */
+		spin_unlock(&ailp->ail_lock);
+		xfs_bui_release(buip);
+		spin_lock(&ailp->ail_lock);
+		return true;
+	}
+
+	return false;
+}
 
 /*
  * This routine is called when an BUD format structure is found in a committed
@@ -648,45 +670,15 @@ xlog_recover_bud(
 	struct xlog_recover_item	*item)
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
+			 xlog_release_bui);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index cd2beb581b40..6a873309f3bc 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -695,6 +695,28 @@ xlog_recover_efi(
 	return 0;
 }
 
+STATIC bool
+xlog_release_efi(
+	struct xlog		*log,
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
+	struct xfs_ail		*ailp = log->l_ailp;
+
+	if (efip->efi_format.efi_id == intent_id) {
+		/*
+		 * Drop the EFD reference to the EFI. This
+		 * removes the EFI from the AIL and frees it.
+		 */
+		spin_unlock(&ailp->ail_lock);
+		xfs_efi_release(efip);
+		spin_lock(&ailp->ail_lock);
+		return true;
+	}
+
+	return false;
+}
 
 /*
  * This routine is called when an EFD format structure is found in a committed
@@ -708,46 +730,16 @@ xlog_recover_efd(
 	struct xlog			*log,
 	struct xlog_recover_item	*item)
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
-			efip = (xfs_efi_log_item_t *)lip;
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
+			 xlog_release_efi);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 08066fa32b80..460f836de963 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1770,6 +1770,33 @@ xlog_clear_stale_blocks(
 
 /* Log intent item dispatching. */
 
+/*
+ * Release the recovered intent item in the AIL that matches the given intent
+ * type and intent id.
+ */
+void
+xlog_recover_release_intent(
+	struct xlog		*log,
+	unsigned short		intent_type,
+	uint64_t		intent_id,
+	xlog_recover_release_intent_fn	fn)
+{
+	struct xfs_ail_cursor	cur;
+	struct xfs_log_item	*lip;
+	struct xfs_ail		*ailp = log->l_ailp;
+
+	spin_lock(&ailp->ail_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		if (lip->li_type == intent_type && fn(log, lip, intent_id))
+			break;
+		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+	}
+
+	xfs_trans_ail_cursor_done(&cur);
+	spin_unlock(&ailp->ail_lock);
+}
+
 STATIC int xlog_recover_intent_pass2(struct xlog *log,
 		struct list_head *buffer_list, struct xlog_recover_item *item,
 		xfs_lsn_t current_lsn);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index a1dac3d60a2a..6eef1523078c 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -657,6 +657,28 @@ xlog_recover_cui(
 	return 0;
 }
 
+STATIC bool
+xlog_release_cui(
+	struct xlog		*log,
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	struct xfs_cui_log_item	*cuip = CUI_ITEM(lip);
+	struct xfs_ail		*ailp = log->l_ailp;
+
+	if (cuip->cui_format.cui_id == intent_id) {
+		/*
+		 * Drop the CUD reference to the CUI. This
+		 * removes the CUI from the AIL and frees it.
+		 */
+		spin_unlock(&ailp->ail_lock);
+		xfs_cui_release(cuip);
+		spin_lock(&ailp->ail_lock);
+		return true;
+	}
+
+	return false;
+}
 
 /*
  * This routine is called when an CUD format structure is found in a committed
@@ -671,45 +693,15 @@ xlog_recover_cud(
 	struct xlog_recover_item	*item)
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
+			 xlog_release_cui);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 1ef752563f37..b60fb141c22e 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -650,6 +650,28 @@ xlog_recover_rui(
 	return 0;
 }
 
+STATIC bool
+xlog_release_rui(
+	struct xlog		*log,
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	struct xfs_rui_log_item	*ruip = RUI_ITEM(lip);
+	struct xfs_ail		*ailp = log->l_ailp;
+
+	if (ruip->rui_format.rui_id == intent_id) {
+		/*
+		 * Drop the RUD reference to the RUI. This
+		 * removes the RUI from the AIL and frees it.
+		 */
+		spin_unlock(&ailp->ail_lock);
+		xfs_rui_release(ruip);
+		spin_lock(&ailp->ail_lock);
+		return true;
+	}
+
+	return false;
+}
 
 /*
  * This routine is called when an RUD format structure is found in a committed
@@ -664,42 +686,12 @@ xlog_recover_rud(
 	struct xlog_recover_item	*item)
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
+			 xlog_release_rui);
 	return 0;
 }
 

