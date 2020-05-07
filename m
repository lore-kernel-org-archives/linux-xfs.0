Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E05EC28CBC
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0261C20747
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:07:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OoLVyku6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgEGBHV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:07:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55702 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbgEGBHV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:07:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470xDUC123068;
        Thu, 7 May 2020 01:05:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=smyhjk1d8i9yKRBy2SSSlRIU+9UfKWavY1kepkrJxLM=;
 b=OoLVyku6hE31tXoTJio6gCyIZRYXm11ePDlHqYAsYdy6hLj/f3hwdm168Aii2oS34g+8
 yOlVwXn+/Ob0/w6QJ01i6UjtT2nKx/UnOujVabqgBNbK2U69kMAvo2Xz4SJ6vBUPQTxg
 qo9lKm9qRNOeRqXOx+l/DZ3N5ilni4frvS+WnPEPG52D+kaMpV6kIVfvvoWp+3XYaLhw
 lt6gwfIrrF8jfKo3X9AToR8MpBRJnw9wqf22/xC8b3v8Y2LC4LYmUSxclB7m0zcqMff9
 ffbjum2C7+iGAJ4MKyUzAua2uUdhK963p0su2FALjF2zvNCsgztqpVlUBLQxMyWU3v+x dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30usgq4jk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:05:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470wcAv051938;
        Thu, 7 May 2020 01:03:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30us7p3ku2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:03:16 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04713For004535;
        Thu, 7 May 2020 01:03:15 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:03:15 -0700
Subject: [PATCH 14/25] xfs: refactor recovered EFI log item playback
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:03:11 -0700
Message-ID: <158881339182.189971.2407567494522557936.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070004
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
 fs/xfs/xfs_extfree_item.c |   46 ++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_extfree_item.h |    5 ----
 fs/xfs/xfs_log_recover.c  |   54 +++++++--------------------------------------
 fs/xfs/xfs_trans.h        |    1 +
 4 files changed, 45 insertions(+), 61 deletions(-)


diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 69f7e75a747e..307f71bdd398 100644
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
@@ -647,6 +641,38 @@ xfs_efi_recover(
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
index 02148e341760..055a9c0c20b0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2546,46 +2546,6 @@ xlog_recover_process_data(
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
@@ -2829,9 +2789,6 @@ xlog_recover_process_intents(
 		 * replayed in the wrong order!
 		 */
 		switch (lip->li_type) {
-		case XFS_LI_EFI:
-			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
-			break;
 		case XFS_LI_RUI:
 			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
 			break;
@@ -2841,6 +2798,9 @@ xlog_recover_process_intents(
 		case XFS_LI_BUI:
 			error = xlog_recover_process_bui(parent_tp, ailp, lip);
 			break;
+		default:
+			error = lip->li_ops->iop_recover(lip, parent_tp);
+			break;
 		}
 		if (error)
 			goto out;
@@ -2885,9 +2845,6 @@ xlog_recover_cancel_intents(
 		}
 
 		switch (lip->li_type) {
-		case XFS_LI_EFI:
-			xlog_recover_cancel_efi(log->l_mp, ailp, lip);
-			break;
 		case XFS_LI_RUI:
 			xlog_recover_cancel_rui(log->l_mp, ailp, lip);
 			break;
@@ -2897,6 +2854,11 @@ xlog_recover_cancel_intents(
 		case XFS_LI_BUI:
 			xlog_recover_cancel_bui(log->l_mp, ailp, lip);
 			break;
+		default:
+			spin_unlock(&ailp->ail_lock);
+			lip->li_ops->iop_release(lip);
+			spin_lock(&ailp->ail_lock);
+			break;
 		}
 
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
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

