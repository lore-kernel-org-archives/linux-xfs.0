Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78753C2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49731206D5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:07:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nYLR95BI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgDVCHT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:07:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42632 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVCHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:07:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M22Sx6104818
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/lTta7HhZ5sNXAq9xckShJ9iVczQ3YQdyUfX/UJgpAU=;
 b=nYLR95BIpI/Epk4hPZXejIicTr3AI4JunsUy9sL6aJjkJPF9Fsx9StRshvnr1cGwNCNH
 Avo7VXV+5Bt2fplkGy3jW51U7b2OWbysTsKL/DdeKzx9s+Tgwh4LisIEA0MpvQqbAL98
 L9fxVxTe+2TH6KIBv/F6o7HJv2VD395JpvSjlvIyDle2Nckn2CuF4AmiXofWrBwo+Cyx
 6Q6y80N50V3QCiz+K5T6m/gboJQeOZgIT8ofBAA2AAMx/0by+T3+CoBb17Bp3v/vahvR
 jOeeug9XF2CdOgkDrT/8bLOD/Tbj6pivLLCW+4GTACg/FOUwEOX38pD1QcJ1AEjniIuT Vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30fsgm03fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M22Ypj053955
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30gbbfgfyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:15 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M27E8v017836
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:07:14 -0700
Subject: [PATCH 11/19] xfs: refactor EFI log item recovery dispatch
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:07:13 -0700
Message-ID: <158752123303.2140829.7801078756588477964.stgit@magnolia>
In-Reply-To: <158752116283.2140829.12265815455525398097.stgit@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=3 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=3 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the extent free intent and intent-done log recovery code into the
per-item source code files and use dispatch functions to call them.  We
do these one at a time because there's a lot of code to move.  No
functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |   42 +++++++++
 fs/xfs/xfs_extfree_item.c       |  153 +++++++++++++++++++++++++++++++-
 fs/xfs/xfs_extfree_item.h       |    9 --
 fs/xfs/xfs_log_recover.c        |  184 +++++++++------------------------------
 4 files changed, 232 insertions(+), 156 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 1eca24cc83a9..188f27ccf2ec 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -124,4 +124,46 @@ void xlog_recover_iodone(struct xfs_buf *bp);
 int xlog_check_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len,
 		unsigned short flags);
 
+/* Log intent item types */
+
+typedef int (*xlog_recover_intent_fn)(struct xlog *xlog,
+		struct xlog_recover_item *item, xfs_lsn_t lsn);
+typedef int (*xlog_recover_done_fn)(struct xlog *xlog,
+		struct xlog_recover_item *item);
+typedef int (*xlog_recover_process_intent_fn)(struct xlog *log,
+		struct xfs_trans *tp, struct xfs_log_item *lip);
+typedef void (*xlog_recover_cancel_intent_fn)(struct xlog *log,
+		struct xfs_log_item *lip);
+
+struct xlog_recover_intent_type {
+	/*
+	 * This function should parse the recovered log item (which will be an
+	 * intent log item) to construct an in-core log intent item and insert
+	 * it into the AIL.  The in-core log intent item should have 1 refcount
+	 * so that ->recover_done or ->cancel_intent can drop it.
+	 */
+	xlog_recover_intent_fn		recover_intent;
+
+	/*
+	 * This function should do the actual work of replaying an unfinished
+	 * log intent item.
+	 */
+	xlog_recover_process_intent_fn	process_intent;
+
+	/*
+	 * This function is called to release an incore log intent item if
+	 * recovery fails.
+	 */
+	xlog_recover_cancel_intent_fn	cancel_intent;
+
+	/*
+	 * This function should parse the recovered log item (which will be an
+	 * intent done log item) to find the id of the corresponding intent log
+	 * item.  Find the incore item in the AIL and release it.
+	 */
+	xlog_recover_done_fn		recover_done;
+};
+
+extern const struct xlog_recover_intent_type xlog_recover_extfree_type;
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6ea847f6e298..cd2beb581b40 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -22,6 +22,8 @@
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_efi_zone;
 kmem_zone_t	*xfs_efd_zone;
@@ -31,7 +33,7 @@ static inline struct xfs_efi_log_item *EFI_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_efi_log_item, efi_item);
 }
 
-void
+STATIC void
 xfs_efi_item_free(
 	struct xfs_efi_log_item	*efip)
 {
@@ -49,7 +51,7 @@ xfs_efi_item_free(
  * committed vs unpin operations in bulk insert operations. Hence the reference
  * count to ensure only the last caller frees the EFI.
  */
-void
+STATIC void
 xfs_efi_release(
 	struct xfs_efi_log_item	*efip)
 {
@@ -150,7 +152,7 @@ static const struct xfs_item_ops xfs_efi_item_ops = {
 /*
  * Allocate and initialize an efi item with the given number of extents.
  */
-struct xfs_efi_log_item *
+STATIC struct xfs_efi_log_item *
 xfs_efi_init(
 	struct xfs_mount	*mp,
 	uint			nextents)
@@ -184,7 +186,7 @@ xfs_efi_init(
  * one of which will be the native format for this kernel.
  * It will handle the conversion of formats if necessary.
  */
-int
+STATIC int
 xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
 {
 	xfs_efi_log_format_t *src_efi_fmt = buf->i_addr;
@@ -592,7 +594,7 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
  * Process an extent free intent item that was recovered from
  * the log.  We need to free the extents that it describes.
  */
-int
+STATIC int
 xfs_efi_recover(
 	struct xfs_mount	*mp,
 	struct xfs_efi_log_item	*efip)
@@ -652,3 +654,144 @@ xfs_efi_recover(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/*
+ * This routine is called to create an in-core extent free intent
+ * item from the efi format structure which was logged on disk.
+ * It allocates an in-core efi, copies the extents from the format
+ * structure into it, and adds the efi to the AIL with the given
+ * LSN.
+ */
+STATIC int
+xlog_recover_efi(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_efi_log_item		*efip;
+	struct xfs_efi_log_format	*efi_formatp;
+	int				error;
+
+	efi_formatp = item->ri_buf[0].i_addr;
+
+	efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
+	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
+	if (error) {
+		xfs_efi_item_free(efip);
+		return error;
+	}
+	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
+
+	spin_lock(&log->l_ailp->ail_lock);
+	/*
+	 * The EFI has two references. One for the EFD and one for EFI to ensure
+	 * it makes it into the AIL. Insert the EFI into the AIL directly and
+	 * drop the EFI reference. Note that xfs_trans_ail_update() drops the
+	 * AIL lock.
+	 */
+	xfs_trans_ail_update(log->l_ailp, &efip->efi_item, lsn);
+	xfs_efi_release(efip);
+	return 0;
+}
+
+
+/*
+ * This routine is called when an EFD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding EFI if it
+ * was still in the log. To do this it searches the AIL for the EFI with an id
+ * equal to that in the EFD format structure. If we find it we drop the EFD
+ * reference, which removes the EFI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_efd(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_ail_cursor		cur;
+	struct xfs_efd_log_format	*efd_formatp;
+	struct xfs_efi_log_item		*efip = NULL;
+	struct xfs_log_item		*lip;
+	struct xfs_ail			*ailp = log->l_ailp;
+	uint64_t			efi_id;
+
+	efd_formatp = item->ri_buf[0].i_addr;
+	ASSERT((item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_32_t) +
+		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_32_t)))) ||
+	       (item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_64_t) +
+		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_64_t)))));
+	efi_id = efd_formatp->efd_efi_id;
+
+	/*
+	 * Search for the EFI with the id in the EFD format structure in the
+	 * AIL.
+	 */
+	spin_lock(&ailp->ail_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		if (lip->li_type == XFS_LI_EFI) {
+			efip = (xfs_efi_log_item_t *)lip;
+			if (efip->efi_format.efi_id == efi_id) {
+				/*
+				 * Drop the EFD reference to the EFI. This
+				 * removes the EFI from the AIL and frees it.
+				 */
+				spin_unlock(&ailp->ail_lock);
+				xfs_efi_release(efip);
+				spin_lock(&ailp->ail_lock);
+				break;
+			}
+		}
+		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+	}
+
+	xfs_trans_ail_cursor_done(&cur);
+	spin_unlock(&ailp->ail_lock);
+
+	return 0;
+}
+
+/* Recover the EFI if necessary. */
+STATIC int
+xlog_recover_process_efi(
+	struct xlog			*log,
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*lip)
+{
+	struct xfs_ail			*ailp = log->l_ailp;
+	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
+	int				error;
+
+	/*
+	 * Skip EFIs that we've already processed.
+	 */
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
+/* Release the EFI since we're cancelling everything. */
+STATIC void
+xlog_recover_cancel_efi(
+	struct xlog			*log,
+	struct xfs_log_item		*lip)
+{
+	struct xfs_ail			*ailp = log->l_ailp;
+	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
+
+	spin_unlock(&ailp->ail_lock);
+	xfs_efi_release(efip);
+	spin_lock(&ailp->ail_lock);
+}
+
+const struct xlog_recover_intent_type xlog_recover_extfree_type = {
+	.recover_intent		= xlog_recover_efi,
+	.recover_done		= xlog_recover_efd,
+	.process_intent		= xlog_recover_process_efi,
+	.cancel_intent		= xlog_recover_cancel_efi,
+};
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 16aaab06d4ec..23e3758b5dbb 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -78,13 +78,4 @@ typedef struct xfs_efd_log_item {
 extern struct kmem_zone	*xfs_efi_zone;
 extern struct kmem_zone	*xfs_efd_zone;
 
-xfs_efi_log_item_t	*xfs_efi_init(struct xfs_mount *, uint);
-int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
-					    xfs_efi_log_format_t *dst_efi_fmt);
-void			xfs_efi_item_free(xfs_efi_log_item_t *);
-void			xfs_efi_release(struct xfs_efi_log_item *);
-
-int			xfs_efi_recover(struct xfs_mount *mp,
-					struct xfs_efi_log_item *efip);
-
 #endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5e7e5c66327e..4d5eb81dadac 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2012,102 +2012,6 @@ xlog_check_buffer_cancelled(
 	return 1;
 }
 
-/*
- * This routine is called to create an in-core extent free intent
- * item from the efi format structure which was logged on disk.
- * It allocates an in-core efi, copies the extents from the format
- * structure into it, and adds the efi to the AIL with the given
- * LSN.
- */
-STATIC int
-xlog_recover_efi_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item,
-	xfs_lsn_t			lsn)
-{
-	int				error;
-	struct xfs_mount		*mp = log->l_mp;
-	struct xfs_efi_log_item		*efip;
-	struct xfs_efi_log_format	*efi_formatp;
-
-	efi_formatp = item->ri_buf[0].i_addr;
-
-	efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
-	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
-	if (error) {
-		xfs_efi_item_free(efip);
-		return error;
-	}
-	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
-
-	spin_lock(&log->l_ailp->ail_lock);
-	/*
-	 * The EFI has two references. One for the EFD and one for EFI to ensure
-	 * it makes it into the AIL. Insert the EFI into the AIL directly and
-	 * drop the EFI reference. Note that xfs_trans_ail_update() drops the
-	 * AIL lock.
-	 */
-	xfs_trans_ail_update(log->l_ailp, &efip->efi_item, lsn);
-	xfs_efi_release(efip);
-	return 0;
-}
-
-
-/*
- * This routine is called when an EFD format structure is found in a committed
- * transaction in the log. Its purpose is to cancel the corresponding EFI if it
- * was still in the log. To do this it searches the AIL for the EFI with an id
- * equal to that in the EFD format structure. If we find it we drop the EFD
- * reference, which removes the EFI from the AIL and frees it.
- */
-STATIC int
-xlog_recover_efd_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item)
-{
-	xfs_efd_log_format_t	*efd_formatp;
-	xfs_efi_log_item_t	*efip = NULL;
-	struct xfs_log_item	*lip;
-	uint64_t		efi_id;
-	struct xfs_ail_cursor	cur;
-	struct xfs_ail		*ailp = log->l_ailp;
-
-	efd_formatp = item->ri_buf[0].i_addr;
-	ASSERT((item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_32_t) +
-		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_32_t)))) ||
-	       (item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_64_t) +
-		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_64_t)))));
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
-
-	return 0;
-}
-
 /*
  * This routine is called to create an in-core extent rmap update
  * item from the rui format structure which was logged on disk.
@@ -2464,6 +2368,31 @@ xlog_recover_commit_pass1(
 	return item->ri_type->commit_pass1_fn(log, item);
 }
 
+static inline const struct xlog_recover_intent_type *
+xlog_intent_for_type(
+	unsigned short			type)
+{
+	switch (type) {
+	case XFS_LI_EFD:
+	case XFS_LI_EFI:
+		return &xlog_recover_extfree_type;
+	default:
+		return NULL;
+	}
+}
+
+static inline bool
+xlog_is_intent_done_item(
+	struct xlog_recover_item	*item)
+{
+	switch (ITEM_TYPE(item)) {
+	case XFS_LI_EFD:
+		return true;
+	default:
+		return false;
+	}
+}
+
 STATIC int
 xlog_recover_intent_pass2(
 	struct xlog			*log,
@@ -2471,11 +2400,16 @@ xlog_recover_intent_pass2(
 	struct xlog_recover_item	*item,
 	xfs_lsn_t			current_lsn)
 {
+	const struct xlog_recover_intent_type *type;
+
+	type = xlog_intent_for_type(ITEM_TYPE(item));
+	if (type) {
+		if (xlog_is_intent_done_item(item))
+			return type->recover_done(log, item);
+		return type->recover_intent(log, item, current_lsn);
+	}
+
 	switch (ITEM_TYPE(item)) {
-	case XFS_LI_EFI:
-		return xlog_recover_efi_pass2(log, item, current_lsn);
-	case XFS_LI_EFD:
-		return xlog_recover_efd_pass2(log, item);
 	case XFS_LI_RUI:
 		return xlog_recover_rui_pass2(log, item, current_lsn);
 	case XFS_LI_RUD:
@@ -3017,46 +2951,6 @@ xlog_recover_process_data(
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
@@ -3274,6 +3168,8 @@ xlog_recover_process_intents(
 	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
 #endif
 	while (lip != NULL) {
+		const struct xlog_recover_intent_type	*type;
+
 		/*
 		 * We're done when we see something other than an intent.
 		 * There should be no intents left in the AIL now.
@@ -3301,7 +3197,8 @@ xlog_recover_process_intents(
 		 */
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
-			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
+			type = xlog_intent_for_type(lip->li_type);
+			error = type->process_intent(log, parent_tp, lip);
 			break;
 		case XFS_LI_RUI:
 			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
@@ -3343,6 +3240,8 @@ xlog_recover_cancel_intents(
 	spin_lock(&ailp->ail_lock);
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 	while (lip != NULL) {
+		const struct xlog_recover_intent_type	*type;
+
 		/*
 		 * We're done when we see something other than an intent.
 		 * There should be no intents left in the AIL now.
@@ -3357,7 +3256,8 @@ xlog_recover_cancel_intents(
 
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
-			xlog_recover_cancel_efi(log->l_mp, ailp, lip);
+			type = xlog_intent_for_type(lip->li_type);
+			type->cancel_intent(log, lip);
 			break;
 		case XFS_LI_RUI:
 			xlog_recover_cancel_rui(log->l_mp, ailp, lip);

