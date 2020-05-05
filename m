Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2C5C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B174206D7
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jV5VArVE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgEEBMM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:12:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37178 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEBML (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:12:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04515Kbx056190
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JR4Zk8HWxV5UvWQbIoLn45oQ0D5ppRu2obvJI+KBJA0=;
 b=jV5VArVEjWXbn6/uMPkYHUKl1tt7JC7GcfSFWH33g71CvJ1W0Ds9u1vY7rBA4kf0R87E
 mcYER3qF2yVmZSG2wIheCUXIhDtn38o03Gaq1viVmcsWdnSHhVT7Fb+wFYyXaY3ZnIRN
 WYnYthR9tpTYL8imy1GDOz4MGRIW/Q22PX8A1OGeitFhyT2YO3vmgGbOSp2y1dY2SCZy
 rVCKFe4cGxDARyQ7jCH14zHm26fDBN+oDZfUSMPAyiG2UcFHobc0E7SEYUJ1V4+2uq3Y
 TR7Na0EcUR6VWEHZD/2CVTY/gciproUsRhSr9z04mQv37FLgM8+bF7HY3OTAE3QOOAeS YQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30s0tma18p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04515l9w057428
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30t1r3qn1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:09 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451C9K5016330
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:12:08 -0700
Subject: [PATCH 15/28] xfs: refactor recovered RUI log item playback
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:12:07 -0700
Message-ID: <158864112778.182683.3049865779495487697.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=3
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=3
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
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
 fs/xfs/xfs_log_recover.c |   48 ++--------------------------------------------
 fs/xfs/xfs_rmap_item.c   |   44 ++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_rmap_item.h   |    3 ---
 3 files changed, 37 insertions(+), 58 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index f12e14719202..da66484acaa7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2553,46 +2553,6 @@ xlog_recover_process_data(
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
@@ -2797,10 +2757,8 @@ xlog_recover_process_intents(
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
@@ -2853,13 +2811,11 @@ xlog_recover_cancel_intents(
 
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
index c87f4e429c12..e763dd8ed0a6 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -24,6 +24,8 @@
 kmem_zone_t	*xfs_rui_zone;
 kmem_zone_t	*xfs_rud_zone;
 
+static const struct xfs_item_ops xfs_rui_item_ops;
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
@@ -124,13 +126,6 @@ xfs_rui_item_release(
 	xfs_rui_release(RUI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_rui_item_ops = {
-	.iop_size	= xfs_rui_item_size,
-	.iop_format	= xfs_rui_item_format,
-	.iop_unpin	= xfs_rui_item_unpin,
-	.iop_release	= xfs_rui_item_release,
-};
-
 /*
  * Allocate and initialize an rui item with the given number of extents.
  */
@@ -468,7 +463,7 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
  * Process an rmap update intent item that was recovered from the log.
  * We need to update the rmapbt.
  */
-int
+STATIC int
 xfs_rui_recover(
 	struct xfs_mount		*mp,
 	struct xfs_rui_log_item		*ruip)
@@ -588,6 +583,37 @@ xfs_rui_recover(
 	return error;
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
+static const struct xfs_item_ops xfs_rui_item_ops = {
+	.iop_size	= xfs_rui_item_size,
+	.iop_format	= xfs_rui_item_format,
+	.iop_unpin	= xfs_rui_item_unpin,
+	.iop_release	= xfs_rui_item_release,
+	.iop_recover	= xfs_rui_item_recover,
+};
+
 /*
  * This routine is called to create an in-core extent rmap update
  * item from the rui format structure which was logged on disk.
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

