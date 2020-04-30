Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD64BC83004
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB13420787
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:49:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TqtJ3cGy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgD3AtD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:49:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46132 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgD3AtD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:49:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0muf4193052
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Z6mDe8/mhSy/KuZiFTLVi49zaQr/0cwrBSMhAJplGv0=;
 b=TqtJ3cGyL68hIbvPbIog8fwtZbM12s88FaT1dy0Odoy7QmjhhYIesrcjepIz6VFrPeQX
 wey7dPeYJjWQP3r9sDHpQoz6Mc/gmm6nKkVOjI9Z3L+zVMUPIICFYW1rbYOpAkF3bZ7h
 +B42F4z+SK8la9YkZipI67dXLemxN6cELgtYFnuVsto5SrsUcevxcpcluJgmce5PWTtP
 OGC5lEHK5WBF2JjGQ+H0+Sn+JotclhQ2jV2+5HqIrQhN5Pvxo3A1n3pI05yNU5Po38Oc
 6knjv35P2vwQFt6iq2udEgdXgfEpJ3a1VPeParj2AZ2C6O42s9CcD8O+p4qfW3peh09U 2w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30nucg8q9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0m6ul070397
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30mxrw8k3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:01 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03U0n0tm024731
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 17:48:59 -0700
Subject: [PATCH 13/21] xfs: refactor recovered EFI log item playback
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:48:59 -0700
Message-ID: <158820773902.467894.5745757511104582380.stgit@magnolia>
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
 fs/xfs/xfs_extfree_item.c |   32 +++++++++++++++++++++++++++++--
 fs/xfs/xfs_extfree_item.h |    5 -----
 fs/xfs/xfs_log_recover.c  |   46 ++++-----------------------------------------
 fs/xfs/xfs_trans.h        |    4 ++++
 4 files changed, 38 insertions(+), 49 deletions(-)


diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 53c1d3b9b957..229c6dee0f85 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -28,6 +28,8 @@
 kmem_zone_t	*xfs_efi_zone;
 kmem_zone_t	*xfs_efd_zone;
 
+STATIC int xfs_efi_recover(struct xfs_mount *mp, struct xfs_efi_log_item *efip);
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
@@ -141,11 +143,37 @@ xfs_efi_item_release(
 	xfs_efi_release(EFI_ITEM(lip));
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
 static const struct xfs_item_ops xfs_efi_item_ops = {
+	.flags		= XFS_ITEM_TYPE_IS_INTENT,
 	.iop_size	= xfs_efi_item_size,
 	.iop_format	= xfs_efi_item_format,
 	.iop_unpin	= xfs_efi_item_unpin,
 	.iop_release	= xfs_efi_item_release,
+	.iop_recover	= xfs_efi_item_recover,
 };
 
 
@@ -594,7 +622,7 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
  * Process an extent free intent item that was recovered from
  * the log.  We need to free the extents that it describes.
  */
-int
+STATIC int
 xfs_efi_recover(
 	struct xfs_mount	*mp,
 	struct xfs_efi_log_item	*efip)
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index ecbe937952d8..23e3758b5dbb 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -78,9 +78,4 @@ typedef struct xfs_efd_log_item {
 extern struct kmem_zone	*xfs_efi_zone;
 extern struct kmem_zone	*xfs_efd_zone;
 
-void			xfs_efi_release(struct xfs_efi_log_item *);
-
-int			xfs_efi_recover(struct xfs_mount *mp,
-					struct xfs_efi_log_item *efip);
-
 #endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d28a46888efb..06f30ce1d02d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2599,46 +2599,6 @@ xlog_recover_process_data(
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
@@ -2883,7 +2843,7 @@ xlog_recover_process_intents(
 		 */
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
-			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
+			error = lip->li_ops->iop_recover(lip, parent_tp);
 			break;
 		case XFS_LI_RUI:
 			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
@@ -2939,7 +2899,9 @@ xlog_recover_cancel_intents(
 
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
index 752c7fef9de7..9ac5483d2187 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -77,6 +77,7 @@ struct xfs_item_ops {
 	void (*iop_release)(struct xfs_log_item *);
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
 	void (*iop_error)(struct xfs_log_item *, xfs_buf_t *);
+	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
 };
 
 /*
@@ -85,6 +86,9 @@ struct xfs_item_ops {
  */
 #define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
 
+/* This log item type is an intent log item. */
+#define XFS_ITEM_TYPE_IS_INTENT		(1 << 1)
+
 void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
 			  int type, const struct xfs_item_ops *ops);
 

