Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00945C38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB2CB20747
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:05:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R/yNxHUu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgEGBFe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:05:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55222 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728463AbgEGBFe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:05:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04710UlF132149;
        Thu, 7 May 2020 01:03:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ja4L4CqIK6z27qlKL1FF44QxNUr1rRLWT4yeD5XiZEA=;
 b=R/yNxHUuE0nRXhSzgY8avyLGxwwiq15lC9IxiGF5nrmEw1RL+1dsKWMw4u0eAxBV1dis
 kNlF4Ta80S9jOEPEkzliM2Sz26PlXYQJcOrIVhVnl2IVCBvv2KkiXvd4Nql8Xuq7FQAO
 sTFeaby+u5Hi97saJLTkabamOq+Q16P2yKrqYiVqqvjiYpiqJk2G9OtRt820xdwR0N8c
 i9mgmXBUK0lZMPCw9wYiEyakp53HrYEKPuoVzhzxzsRwHe6H9aTACbK5da/MoPrhLzpf
 p4bdrxwdDqWy46DYhpDoyDPU9LDCgcb0wZU41cxXW1TIZi5CusWO5xfXfNR2/sHyE2Wb sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30s1gnda5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:03:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470wcv6052054;
        Thu, 7 May 2020 01:03:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30us7p3m6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:03:29 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04713SSV028633;
        Thu, 7 May 2020 01:03:28 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:03:28 -0700
Subject: [PATCH 16/25] xfs: refactor recovered CUI log item playback
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:03:24 -0700
Message-ID: <158881340439.189971.1628240097810639573.stgit@magnolia>
In-Reply-To: <158881329912.189971.14392758631836955942.stgit@magnolia>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=3
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
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
 fs/xfs/xfs_log_recover.c   |   46 --------------------------------------------
 fs/xfs/xfs_refcount_item.c |   44 +++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_refcount_item.h |    3 ---
 3 files changed, 35 insertions(+), 58 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4eb837476e44..7d3f7be05395 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2546,46 +2546,6 @@ xlog_recover_process_data(
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
@@ -2749,9 +2709,6 @@ xlog_recover_process_intents(
 		 * replayed in the wrong order!
 		 */
 		switch (lip->li_type) {
-		case XFS_LI_CUI:
-			error = xlog_recover_process_cui(parent_tp, ailp, lip);
-			break;
 		case XFS_LI_BUI:
 			error = xlog_recover_process_bui(parent_tp, ailp, lip);
 			break;
@@ -2802,9 +2759,6 @@ xlog_recover_cancel_intents(
 		}
 
 		switch (lip->li_type) {
-		case XFS_LI_CUI:
-			xlog_recover_cancel_cui(log->l_mp, ailp, lip);
-			break;
 		case XFS_LI_BUI:
 			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
 			break;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 7ccdeafdb7e7..4eee8add4cd5 100644
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

