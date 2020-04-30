Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B825C83004
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03C6420575
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:48:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sCMsxG9z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgD3Asi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:48:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45768 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgD3Asi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:48:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0J89S151098
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PDQVm6gpIwnyrQ9lec0dk8LS1D3TNRZVrMXWLN06lzQ=;
 b=sCMsxG9z016QCwVUR+BhJvOEJC82l9rYGT4vuYu+x5ucBz7+N85iwEqrTtwqHw2frPF0
 lLE7SGIA536EpTa2f+aP1Zpg4Cp899Acl8HZwajedACYiDEf6MTke+v9TR/FhUExi6R8
 kvXF94oZsQXpPpGgAMfIbzNOaNyMlrniwOgJin3iAp8P3qlmO7qZ0analjywEqSXrRYM
 oEJYN8/dL7xzOY3H9UAo0+62CuhW/XsArknXjR9EZV5iOylo9sSIZ60EHE3bp4z9a+1E
 88kkVOc51PZd7nUpKHK1CdxXtUqNODxIt7PEZB495zRjQiJxMm/u35p8TKD9yUrHeshz /g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30nucg8q8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0m7VN070474
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30mxrw8jpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:36 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03U0mZbS013243
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 17:48:35 -0700
Subject: [PATCH 09/21] xfs: refactor log recovery EFI item dispatch for
 pass2 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:48:34 -0700
Message-ID: <158820771414.467894.16178249031828526203.stgit@magnolia>
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
 engine=8.12.0-2003020000 definitions=main-2004300000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the extent free intent and intent-done pass2 commit code into the
per-item source code files and use dispatch functions to call them.  We
do these one at a time because there's a lot of code to move.  No
functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_extfree_item.c |  108 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_extfree_item.h |    4 --
 fs/xfs/xfs_log_recover.c  |  100 ------------------------------------------
 3 files changed, 105 insertions(+), 107 deletions(-)


diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index c53e5f46ee26..53c1d3b9b957 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -22,6 +22,7 @@
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_efi_zone;
@@ -32,7 +33,7 @@ static inline struct xfs_efi_log_item *EFI_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_efi_log_item, efi_item);
 }
 
-void
+STATIC void
 xfs_efi_item_free(
 	struct xfs_efi_log_item	*efip)
 {
@@ -151,7 +152,7 @@ static const struct xfs_item_ops xfs_efi_item_ops = {
 /*
  * Allocate and initialize an efi item with the given number of extents.
  */
-struct xfs_efi_log_item *
+STATIC struct xfs_efi_log_item *
 xfs_efi_init(
 	struct xfs_mount	*mp,
 	uint			nextents)
@@ -185,7 +186,7 @@ xfs_efi_init(
  * one of which will be the native format for this kernel.
  * It will handle the conversion of formats if necessary.
  */
-int
+STATIC int
 xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
 {
 	xfs_efi_log_format_t *src_efi_fmt = buf->i_addr;
@@ -654,8 +655,109 @@ xfs_efi_recover(
 	return error;
 }
 
+/*
+ * This routine is called to create an in-core extent free intent
+ * item from the efi format structure which was logged on disk.
+ * It allocates an in-core efi, copies the extents from the format
+ * structure into it, and adds the efi to the AIL with the given
+ * LSN.
+ */
+STATIC int
+xlog_recover_extfree_intent_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
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
+xlog_recover_extfree_done_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
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
+			efip = (struct xfs_efi_log_item *)lip;
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
 const struct xlog_recover_item_type xlog_extfree_intent_item_type = {
+	.commit_pass2_fn	= xlog_recover_extfree_intent_commit_pass2,
 };
 
 const struct xlog_recover_item_type xlog_extfree_done_item_type = {
+	.commit_pass2_fn	= xlog_recover_extfree_done_commit_pass2,
 };
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 16aaab06d4ec..ecbe937952d8 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -78,10 +78,6 @@ typedef struct xfs_efd_log_item {
 extern struct kmem_zone	*xfs_efi_zone;
 extern struct kmem_zone	*xfs_efd_zone;
 
-xfs_efi_log_item_t	*xfs_efi_init(struct xfs_mount *, uint);
-int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
-					    xfs_efi_log_format_t *dst_efi_fmt);
-void			xfs_efi_item_free(xfs_efi_log_item_t *);
 void			xfs_efi_release(struct xfs_efi_log_item *);
 
 int			xfs_efi_recover(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index dba38fb99af7..2d34d2692b83 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2056,102 +2056,6 @@ xlog_buf_readahead(
 		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
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
@@ -2522,10 +2426,6 @@ xlog_recover_commit_pass2(
 				trans->r_lsn);
 
 	switch (ITEM_TYPE(item)) {
-	case XFS_LI_EFI:
-		return xlog_recover_efi_pass2(log, item, trans->r_lsn);
-	case XFS_LI_EFD:
-		return xlog_recover_efd_pass2(log, item);
 	case XFS_LI_RUI:
 		return xlog_recover_rui_pass2(log, item, trans->r_lsn);
 	case XFS_LI_RUD:

