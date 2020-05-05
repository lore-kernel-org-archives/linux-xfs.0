Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A708C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 127E1206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jHH5lXoc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgEEBMU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:12:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47276 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEBMU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:12:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04513o0e055583
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ppdIFug4Vnk7f8ylxF4phXpYKIxQzJa7KAFXIkct1aY=;
 b=jHH5lXocr81vRSwsSZKA4K8HZkUaRt8W1kCKNLBkHeNmqP9ESZSyVJV2OGy4WNq9sEaD
 BpIuS0AW1TlujtQEZDcgflaGY3G7OcKFJdXA8CZW72KLC39bh9Bn2PAiSbU9768M3uZz
 Gg309yLkuXnJI69F08kY0tn+RM1IP4f8r6uoGuVKSpgBkV3AeK2fC3YOr6pkJ56EQDa3
 TSe9tkvAu4bSzzSL9tMZF3laNVdaSWejKAf1MQQJWUgbdhCAqPavA50wJNsUkP6FcFtO
 Q3HC2iA3JxHPCUKuR8x7+FDvPSh/+7SWjoFE8/8pDMs/gP+PqhIjYH7f52mPN6uv5krj 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30s1gn1vkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04516m16149576
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30sjjxaqv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:18 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451CHZt014996
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:12:14 -0700
Subject: [PATCH 16/28] xfs: refactor recovered CUI log item playback
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:12:14 -0700
Message-ID: <158864113397.182683.5812513715201193839.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
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
 fs/xfs/xfs_log_recover.c   |   48 ++------------------------------------------
 fs/xfs/xfs_refcount_item.c |   44 ++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_refcount_item.h |    3 ---
 3 files changed, 37 insertions(+), 58 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index da66484acaa7..ad5ac97ed0c7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2553,46 +2553,6 @@ xlog_recover_process_data(
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
@@ -2758,10 +2718,8 @@ xlog_recover_process_intents(
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
 		case XFS_LI_RUI:
-			error = lip->li_ops->iop_recover(lip, parent_tp);
-			break;
 		case XFS_LI_CUI:
-			error = xlog_recover_process_cui(parent_tp, ailp, lip);
+			error = lip->li_ops->iop_recover(lip, parent_tp);
 			break;
 		case XFS_LI_BUI:
 			error = xlog_recover_process_bui(parent_tp, ailp, lip);
@@ -2812,13 +2770,11 @@ xlog_recover_cancel_intents(
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
 		case XFS_LI_RUI:
+		case XFS_LI_CUI:
 			spin_unlock(&ailp->ail_lock);
 			lip->li_ops->iop_release(lip);
 			spin_lock(&ailp->ail_lock);
 			break;
-		case XFS_LI_CUI:
-			xlog_recover_cancel_cui(log->l_mp, ailp, lip);
-			break;
 		case XFS_LI_BUI:
 			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
 			break;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 28b41f5dd6bc..5b72eebd8764 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -24,6 +24,8 @@
 kmem_zone_t	*xfs_cui_zone;
 kmem_zone_t	*xfs_cud_zone;
 
+static const struct xfs_item_ops xfs_cui_item_ops;
+
 static inline struct xfs_cui_log_item *CUI_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_cui_log_item, cui_item);
@@ -46,7 +48,7 @@ xfs_cui_item_free(
  * committed vs unpin operations in bulk insert operations. Hence the reference
  * count to ensure only the last caller frees the CUI.
  */
-void
+STATIC void
 xfs_cui_release(
 	struct xfs_cui_log_item	*cuip)
 {
@@ -125,13 +127,6 @@ xfs_cui_item_release(
 	xfs_cui_release(CUI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_cui_item_ops = {
-	.iop_size	= xfs_cui_item_size,
-	.iop_format	= xfs_cui_item_format,
-	.iop_unpin	= xfs_cui_item_unpin,
-	.iop_release	= xfs_cui_item_release,
-};
-
 /*
  * Allocate and initialize an cui item with the given number of extents.
  */
@@ -425,7 +420,7 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
  * Process a refcount update intent item that was recovered from the log.
  * We need to update the refcountbt.
  */
-int
+STATIC int
 xfs_cui_recover(
 	struct xfs_trans		*parent_tp,
 	struct xfs_cui_log_item		*cuip)
@@ -573,6 +568,37 @@ xfs_cui_recover(
 	return error;
 }
 
+/* Recover the CUI if necessary. */
+STATIC int
+xfs_cui_item_recover(
+	struct xfs_log_item		*lip,
+	struct xfs_trans		*tp)
+{
+	struct xfs_ail			*ailp = lip->li_ailp;
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
+	error = xfs_cui_recover(tp, cuip);
+	spin_lock(&ailp->ail_lock);
+
+	return error;
+}
+
+static const struct xfs_item_ops xfs_cui_item_ops = {
+	.iop_size	= xfs_cui_item_size,
+	.iop_format	= xfs_cui_item_format,
+	.iop_unpin	= xfs_cui_item_unpin,
+	.iop_release	= xfs_cui_item_release,
+	.iop_recover	= xfs_cui_item_recover,
+};
+
 /*
  * Copy an CUI format buffer from the given buf, and into the destination
  * CUI format structure.  The CUI/CUD items were designed not to need any
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index ebe12779eaac..cfaa857673a6 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -77,7 +77,4 @@ struct xfs_cud_log_item {
 extern struct kmem_zone	*xfs_cui_zone;
 extern struct kmem_zone	*xfs_cud_zone;
 
-void xfs_cui_release(struct xfs_cui_log_item *);
-int xfs_cui_recover(struct xfs_trans *parent_tp, struct xfs_cui_log_item *cuip);
-
 #endif	/* __XFS_REFCOUNT_ITEM_H__ */

