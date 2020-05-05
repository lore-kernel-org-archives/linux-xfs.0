Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5B4C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35DB7206D7
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="s/B8Vurz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgEEBMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:12:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47104 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEBMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:12:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04513gXw055578
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=O9fLLWtVMZoZnCrPDuIkqfjG4D6rRfXPwA/Fl+dO0pI=;
 b=s/B8Vurz7DG382JQMIPZxA91JxJhGEmIEd/SJzx/SPMxN4/n9vnkk/8A2jLFhB465DrC
 blW7PwNJ/TlrUVy0D2J8I0vPpOdKuI6HiMV6BbEW1Y/del9N8mEZNM4vcWEP1MmzI5lE
 mfvr4Lw4kTx+xPmK4oEXQNIdFg6dTCL+UOaPdn/rYxrEajbyMOwLb9TWftJdWL2s0gWb
 +3PJET1e96IEM8jpJn2yS/7/09nn/uRXrbLnb7z4PEWuCeFjUkxQ7JHvVh9hj5n+Pi7B
 xdoLnsJqrzjIstRc8PMhF5bIwt1SpS+Ocw7uNfPeGz4SJ4vK0gyyVaas69Qzefvj0Y3S GA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30s1gn1vk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04515kFL057359
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30t1r3qmq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:03 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0451C2Zv027883
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:12:02 -0700
Subject: [PATCH 14/28] xfs: refactor recovered EFI log item playback
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:12:01 -0700
Message-ID: <158864112169.182683.14030031632354525711.stgit@magnolia>
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
 fs/xfs/xfs_extfree_item.c |   47 +++++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_extfree_item.h |    5 -----
 fs/xfs/xfs_log_recover.c  |   46 ++++----------------------------------------
 fs/xfs/xfs_trans.h        |    1 +
 4 files changed, 42 insertions(+), 57 deletions(-)


diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index dca098660753..3fc8a9864217 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -28,6 +28,8 @@
 kmem_zone_t	*xfs_efi_zone;
 kmem_zone_t	*xfs_efd_zone;
 
+static const struct xfs_item_ops xfs_efi_item_ops;
+
 static inline struct xfs_efi_log_item *EFI_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_efi_log_item, efi_item);
@@ -51,7 +53,7 @@ xfs_efi_item_free(
  * committed vs unpin operations in bulk insert operations. Hence the reference
  * count to ensure only the last caller frees the EFI.
  */
-void
+STATIC void
 xfs_efi_release(
 	struct xfs_efi_log_item	*efip)
 {
@@ -141,14 +143,6 @@ xfs_efi_item_release(
 	xfs_efi_release(EFI_ITEM(lip));
 }
 
-static const struct xfs_item_ops xfs_efi_item_ops = {
-	.iop_size	= xfs_efi_item_size,
-	.iop_format	= xfs_efi_item_format,
-	.iop_unpin	= xfs_efi_item_unpin,
-	.iop_release	= xfs_efi_item_release,
-};
-
-
 /*
  * Allocate and initialize an efi item with the given number of extents.
  */
@@ -586,7 +580,7 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
  * Process an extent free intent item that was recovered from
  * the log.  We need to free the extents that it describes.
  */
-int
+STATIC int
 xfs_efi_recover(
 	struct xfs_mount	*mp,
 	struct xfs_efi_log_item	*efip)
@@ -647,6 +641,39 @@ xfs_efi_recover(
 	return error;
 }
 
+/* Recover the EFI if necessary. */
+STATIC int
+xfs_efi_item_recover(
+	struct xfs_log_item		*lip,
+	struct xfs_trans		*tp)
+{
+	struct xfs_ail			*ailp = lip->li_ailp;
+	struct xfs_efi_log_item		*efip;
+	int				error;
+
+	/*
+	 * Skip EFIs that we've already processed.
+	 */
+	efip = container_of(lip, struct xfs_efi_log_item, efi_item);
+	if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
+		return 0;
+
+	spin_unlock(&ailp->ail_lock);
+	error = xfs_efi_recover(tp->t_mountp, efip);
+	spin_lock(&ailp->ail_lock);
+
+	return error;
+}
+
+static const struct xfs_item_ops xfs_efi_item_ops = {
+	.iop_size	= xfs_efi_item_size,
+	.iop_format	= xfs_efi_item_format,
+	.iop_unpin	= xfs_efi_item_unpin,
+	.iop_release	= xfs_efi_item_release,
+	.iop_recover	= xfs_efi_item_recover,
+};
+
+
 /*
  * This routine is called to create an in-core extent free intent
  * item from the efi format structure which was logged on disk.
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 876e3d237f48..4b2c2c5c5985 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -78,9 +78,4 @@ struct xfs_efd_log_item {
 extern struct kmem_zone	*xfs_efi_zone;
 extern struct kmem_zone	*xfs_efd_zone;
 
-void			xfs_efi_release(struct xfs_efi_log_item *);
-
-int			xfs_efi_recover(struct xfs_mount *mp,
-					struct xfs_efi_log_item *efip);
-
 #endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 929e2caeeb42..f12e14719202 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2553,46 +2553,6 @@ xlog_recover_process_data(
 	return 0;
 }
 
-/* Recover the EFI if necessary. */
-STATIC int
-xlog_recover_process_efi(
-	struct xfs_mount		*mp,
-	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
-{
-	struct xfs_efi_log_item		*efip;
-	int				error;
-
-	/*
-	 * Skip EFIs that we've already processed.
-	 */
-	efip = container_of(lip, struct xfs_efi_log_item, efi_item);
-	if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
-		return 0;
-
-	spin_unlock(&ailp->ail_lock);
-	error = xfs_efi_recover(mp, efip);
-	spin_lock(&ailp->ail_lock);
-
-	return error;
-}
-
-/* Release the EFI since we're cancelling everything. */
-STATIC void
-xlog_recover_cancel_efi(
-	struct xfs_mount		*mp,
-	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
-{
-	struct xfs_efi_log_item		*efip;
-
-	efip = container_of(lip, struct xfs_efi_log_item, efi_item);
-
-	spin_unlock(&ailp->ail_lock);
-	xfs_efi_release(efip);
-	spin_lock(&ailp->ail_lock);
-}
-
 /* Recover the RUI if necessary. */
 STATIC int
 xlog_recover_process_rui(
@@ -2837,7 +2797,7 @@ xlog_recover_process_intents(
 		 */
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
-			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
+			error = lip->li_ops->iop_recover(lip, parent_tp);
 			break;
 		case XFS_LI_RUI:
 			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
@@ -2893,7 +2853,9 @@ xlog_recover_cancel_intents(
 
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
-			xlog_recover_cancel_efi(log->l_mp, ailp, lip);
+			spin_unlock(&ailp->ail_lock);
+			lip->li_ops->iop_release(lip);
+			spin_lock(&ailp->ail_lock);
 			break;
 		case XFS_LI_RUI:
 			xlog_recover_cancel_rui(log->l_mp, ailp, lip);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 752c7fef9de7..3f6a79108991 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -77,6 +77,7 @@ struct xfs_item_ops {
 	void (*iop_release)(struct xfs_log_item *);
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
 	void (*iop_error)(struct xfs_log_item *, xfs_buf_t *);
+	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
 };
 
 /*

