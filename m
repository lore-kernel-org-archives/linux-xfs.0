Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A207C83004
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 547AA20787
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i+SOJsVs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgD3AtJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:49:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47190 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgD3AtI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:49:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0m1mj159838
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PFaGa9vN4cLAKCm0JQVQinVGaDJZkJOPCP1wDdyIV9w=;
 b=i+SOJsVsYWq3YlmK+QHuzC/ETGf6TsbIybc2KSA3CoPPEQHs/LYVnM143dewyIJex0BU
 5BRZ+fvqq2bOhYhXEp/nC5+iezisVApkRRQ+k3VwdUTZcESB6+xW2csZcjqEwAXHidoE
 m7QL3dYuml1GkoY4R4p4xsPQNBeKQnsX9kA3hDm7kN7XnN7NqkUxEOIyIcd9BxHop1Ty
 daqKiUTyj6LRdzddZjulwcAS6lfr6CENVc44p/wk0gONnP/IWqztPh1RmAJKkotd6X9v
 Z4tQsP2JrPpcanLrhyR49C8QXNTmQB71ckO8DBSslD3tV7euLgb1iUXEJO/R0uunpCVX OQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30p2p0e512-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0klhd087569
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30mxpma5f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:06 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03U0n6M0013502
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 17:49:06 -0700
Subject: [PATCH 14/21] xfs: refactor recovered RUI log item playback
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:49:05 -0700
Message-ID: <158820774516.467894.7117990562586451957.stgit@magnolia>
In-Reply-To: <158820765488.467894.15408191148091671053.stgit@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=3
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=3 mlxlogscore=999 priorityscore=1501
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
 fs/xfs/xfs_log_recover.c |   48 ++--------------------------------------------
 fs/xfs/xfs_rmap_item.c   |   31 ++++++++++++++++++++++++++++--
 fs/xfs/xfs_rmap_item.h   |    3 ---
 3 files changed, 31 insertions(+), 51 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 06f30ce1d02d..cf790d02ee92 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2599,46 +2599,6 @@ xlog_recover_process_data(
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
@@ -2843,10 +2803,8 @@ xlog_recover_process_intents(
 		 */
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
-			error = lip->li_ops->iop_recover(lip, parent_tp);
-			break;
 		case XFS_LI_RUI:
-			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
+			error = lip->li_ops->iop_recover(lip, parent_tp);
 			break;
 		case XFS_LI_CUI:
 			error = xlog_recover_process_cui(parent_tp, ailp, lip);
@@ -2899,13 +2857,11 @@ xlog_recover_cancel_intents(
 
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
+		case XFS_LI_RUI:
 			spin_unlock(&ailp->ail_lock);
 			lip->li_ops->iop_release(lip);
 			spin_lock(&ailp->ail_lock);
 			break;
-		case XFS_LI_RUI:
-			xlog_recover_cancel_rui(log->l_mp, ailp, lip);
-			break;
 		case XFS_LI_CUI:
 			xlog_recover_cancel_cui(log->l_mp, ailp, lip);
 			break;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 51d9226c043e..53348d48bf67 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -24,6 +24,8 @@
 kmem_zone_t	*xfs_rui_zone;
 kmem_zone_t	*xfs_rud_zone;
 
+STATIC int xfs_rui_recover(struct xfs_mount *mp, struct xfs_rui_log_item *ruip);
+
 static inline struct xfs_rui_log_item *RUI_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_rui_log_item, rui_item);
@@ -46,7 +48,7 @@ xfs_rui_item_free(
  * committed vs unpin operations in bulk insert operations. Hence the reference
  * count to ensure only the last caller frees the RUI.
  */
-void
+STATIC void
 xfs_rui_release(
 	struct xfs_rui_log_item	*ruip)
 {
@@ -124,11 +126,36 @@ xfs_rui_item_release(
 	xfs_rui_release(RUI_ITEM(lip));
 }
 
+/* Recover the RUI if necessary. */
+STATIC int
+xfs_rui_item_recover(
+	struct xfs_log_item		*lip,
+	struct xfs_trans		*tp)
+{
+	struct xfs_ail			*ailp = lip->li_ailp;
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
+	error = xfs_rui_recover(tp->t_mountp, ruip);
+	spin_lock(&ailp->ail_lock);
+
+	return error;
+}
+
 static const struct xfs_item_ops xfs_rui_item_ops = {
+	.flags		= XFS_ITEM_TYPE_IS_INTENT,
 	.iop_size	= xfs_rui_item_size,
 	.iop_format	= xfs_rui_item_format,
 	.iop_unpin	= xfs_rui_item_unpin,
 	.iop_release	= xfs_rui_item_release,
+	.iop_recover	= xfs_rui_item_recover,
 };
 
 /*
@@ -489,7 +516,7 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
  * Process an rmap update intent item that was recovered from the log.
  * We need to update the rmapbt.
  */
-int
+STATIC int
 xfs_rui_recover(
 	struct xfs_mount		*mp,
 	struct xfs_rui_log_item		*ruip)
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 89bd192779f8..48a77a6f5c94 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -77,7 +77,4 @@ struct xfs_rud_log_item {
 extern struct kmem_zone	*xfs_rui_zone;
 extern struct kmem_zone	*xfs_rud_zone;
 
-void xfs_rui_release(struct xfs_rui_log_item *);
-int xfs_rui_recover(struct xfs_mount *mp, struct xfs_rui_log_item *ruip);
-
 #endif	/* __XFS_RMAP_ITEM_H__ */

