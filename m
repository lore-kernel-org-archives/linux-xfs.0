Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EA4C83004
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1E2720838
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tG5RSAmV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgD3AtO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:49:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46238 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgD3AtO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:49:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0nDxm193163
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sw6/tbUCtzY+s5OtJCMUCGpA4QcMAaNLHUCrUZBPc2k=;
 b=tG5RSAmVU8vBgY8JrMrLWCWz+/DiM0jAptzuku5UFpJyqTdMPhOM33xcMKbYnCOgEZyC
 +kIv0eJoFtpG3yGnXPcYmYIWZutm7WaL58+x/uBJMu7KwUsVr0b7Fobc+DqpEa7a7lyj
 sAYe0zlf2ai+M1JZoKFbJyNqsBJihpQuPBAgF6qV/e9cz2lvZhn2SpikuCXU2l4KDNr+
 L7/As+y9UTO5aq5xmG4aWdNwqklOZDQRdB7jCBwgv7Nx9VyW07QM53l161JVh6g8d85K
 y66vpuFukObo7bMVlaH0t0+3c53V3MIx1KuArMsnvFWkInzUCnr95MGWGx+vYXq8MYB6 5w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30nucg8q9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0m7Wn070421
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30mxrw8k9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:12 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03U0nCCS009806
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 17:49:12 -0700
Subject: [PATCH 15/21] xfs: refactor recovered CUI log item playback
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:49:11 -0700
Message-ID: <158820775127.467894.16671025004249487262.stgit@magnolia>
In-Reply-To: <158820765488.467894.15408191148091671053.stgit@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=3
 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=3 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300001
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
 fs/xfs/xfs_refcount_item.c |   31 +++++++++++++++++++++++++++-
 fs/xfs/xfs_refcount_item.h |    3 ---
 3 files changed, 31 insertions(+), 51 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index cf790d02ee92..9323bb5800d6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2599,46 +2599,6 @@ xlog_recover_process_data(
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
@@ -2804,10 +2764,8 @@ xlog_recover_process_intents(
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
@@ -2858,13 +2816,11 @@ xlog_recover_cancel_intents(
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
index a76a5e9b862e..d291a640ce31 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -24,6 +24,8 @@
 kmem_zone_t	*xfs_cui_zone;
 kmem_zone_t	*xfs_cud_zone;
 
+STATIC int xfs_cui_recover(struct xfs_trans *tp, struct xfs_cui_log_item *cuip);
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
@@ -125,11 +127,36 @@ xfs_cui_item_release(
 	xfs_cui_release(CUI_ITEM(lip));
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
 static const struct xfs_item_ops xfs_cui_item_ops = {
+	.flags		= XFS_ITEM_TYPE_IS_INTENT,
 	.iop_size	= xfs_cui_item_size,
 	.iop_format	= xfs_cui_item_format,
 	.iop_unpin	= xfs_cui_item_unpin,
 	.iop_release	= xfs_cui_item_release,
+	.iop_recover	= xfs_cui_item_recover,
 };
 
 /*
@@ -445,7 +472,7 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
  * Process a refcount update intent item that was recovered from the log.
  * We need to update the refcountbt.
  */
-int
+STATIC int
 xfs_cui_recover(
 	struct xfs_trans		*parent_tp,
 	struct xfs_cui_log_item		*cuip)
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

