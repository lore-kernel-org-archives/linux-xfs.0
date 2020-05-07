Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9371C54E49
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C03BE208DB
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:05:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q+oLWgLb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgEGBFd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:05:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55162 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728507AbgEGBF3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:05:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470vqle130637;
        Thu, 7 May 2020 01:03:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=BQlBWQZkyi0/SAsjmqI0y6EA7zXMSFAxuldtruRKJS8=;
 b=Q+oLWgLbwfCvO411Hnf5dpBkvj0tl88vOSKOje0B1+LO5Hmch2SgBIJD2UMrb6/RnnPP
 Mwo3AXit6O2SnXT9Wij/LxarpHh/26gfrakBlNTJNKZTAdD4H0h2a4N6p8V66+9LJZ8Z
 nlnta0u3eeogDMoBnr1E5ugB11pkwPXNef3yQ5K7C+BBvIASaa37kmJ/H0ASquz9dqsN
 ngnxnAsOAyJ5xl5pEssAIl+eTQ6XEWhp6uzRxmFsN7jah9IILtxmIdhK5FvCyrHt0iHj
 oP84lvYHMLfQCcMf65XDghWIkbQwOUf0Pyl8y6KxI8XEG7wBKJN7P7vNdYnUC8ok2C7A 5Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30s1gnda5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:03:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470up4Z190113;
        Thu, 7 May 2020 01:03:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30sjdwsurr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:03:23 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04713MRM001087;
        Thu, 7 May 2020 01:03:22 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:03:21 -0700
Subject: [PATCH 15/25] xfs: refactor recovered RUI log item playback
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:03:18 -0700
Message-ID: <158881339811.189971.15870736505247237060.stgit@magnolia>
In-Reply-To: <158881329912.189971.14392758631836955942.stgit@magnolia>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=3 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the code that processes the log items created from the recovered
log items into the per-item source code files and use dispatch functions
to call them.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c |   46 ----------------------------------------------
 fs/xfs/xfs_rmap_item.c   |   44 +++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_rmap_item.h   |    3 ---
 3 files changed, 35 insertions(+), 58 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 055a9c0c20b0..4eb837476e44 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2546,46 +2546,6 @@ xlog_recover_process_data(
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
@@ -2789,9 +2749,6 @@ xlog_recover_process_intents(
 		 * replayed in the wrong order!
 		 */
 		switch (lip->li_type) {
-		case XFS_LI_RUI:
-			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
-			break;
 		case XFS_LI_CUI:
 			error = xlog_recover_process_cui(parent_tp, ailp, lip);
 			break;
@@ -2845,9 +2802,6 @@ xlog_recover_cancel_intents(
 		}
 
 		switch (lip->li_type) {
-		case XFS_LI_RUI:
-			xlog_recover_cancel_rui(log->l_mp, ailp, lip);
-			break;
 		case XFS_LI_CUI:
 			xlog_recover_cancel_cui(log->l_mp, ailp, lip);
 			break;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 44049dbdb161..1b7c7e3db872 100644
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

