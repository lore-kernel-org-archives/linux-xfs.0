Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5347C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CB59206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:11:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fk2m7Qbr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgEEBLx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:11:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46996 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEBLx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:11:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04514B0S056144
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DOvDiEFoFZCBbWzJytLxUVja2NvebyVGAsll0psfjaY=;
 b=fk2m7QbrI8B6gSa6AlVeC/CU8YMDuaP3Ba1a8oEn5dm6c1BypQm4YyakOEFRNOCHYdlU
 3+AXE/oxoIIAGTaU58uccsnH2osHrUJk7LpyXQ6d4wF47dffZWde/OoALsaamF4ta6gr
 KejtBb+0eH9Ms8AJcvxV8GFQy9539s93mOi8Sh/a8fR6D5x7qaszkiiltDv69AXX30HC
 BGbI6RK4KGaLEMzZFt76nqFYY4/hC4noX0Hw9LrTDPuyYIxJWEgYW/jujFASqoGJU+yC
 fHNtLeI8JThzztod3C5QZtDNAK90vJjvKlqOBPu4gwTAaN/D1ZTKzt0VxLgrR9BPtuHU PA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30s1gn1vjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:11:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04516q0l004582
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:11:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30sjdrtvth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:11:49 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0451BmHj014971
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:11:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:11:48 -0700
Subject: [PATCH 12/28] xfs: refactor log recovery BUI item dispatch for pass2
 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:11:47 -0700
Message-ID: <158864110754.182683.16207546218311436217.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=3 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
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

Move the bmap update intent and intent-done pass2 commit code into the
per-item source code files and use dispatch functions to call them.  We
do these one at a time because there's a lot of code to move.  No
functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_item.c   |  133 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_bmap_item.h   |    2 -
 fs/xfs/xfs_log_recover.c |  128 --------------------------------------------
 3 files changed, 131 insertions(+), 132 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 42354403fec7..0fbebef69e26 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -22,6 +22,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_error.h"
+#include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_bui_zone;
@@ -32,7 +33,7 @@ static inline struct xfs_bui_log_item *BUI_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_bui_log_item, bui_item);
 }
 
-void
+STATIC void
 xfs_bui_item_free(
 	struct xfs_bui_log_item	*buip)
 {
@@ -135,7 +136,7 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
 /*
  * Allocate and initialize an bui item with the given number of extents.
  */
-struct xfs_bui_log_item *
+STATIC struct xfs_bui_log_item *
 xfs_bui_init(
 	struct xfs_mount		*mp)
 
@@ -559,10 +560,138 @@ xfs_bui_recover(
 	return error;
 }
 
+/*
+ * Copy an BUI format buffer from the given buf, and into the destination
+ * BUI format structure.  The BUI/BUD items were designed not to need any
+ * special alignment handling.
+ */
+static int
+xfs_bui_copy_format(
+	struct xfs_log_iovec		*buf,
+	struct xfs_bui_log_format	*dst_bui_fmt)
+{
+	struct xfs_bui_log_format	*src_bui_fmt;
+	uint				len;
+
+	src_bui_fmt = buf->i_addr;
+	len = xfs_bui_log_format_sizeof(src_bui_fmt->bui_nextents);
+
+	if (buf->i_len == len) {
+		memcpy(dst_bui_fmt, src_bui_fmt, len);
+		return 0;
+	}
+	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
+	return -EFSCORRUPTED;
+}
+
+/*
+ * This routine is called to create an in-core extent bmap update
+ * item from the bui format structure which was logged on disk.
+ * It allocates an in-core bui, copies the extents from the format
+ * structure into it, and adds the bui to the AIL with the given
+ * LSN.
+ */
+STATIC int
+xlog_recover_bmap_intent_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	int				error;
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_bui_log_item		*buip;
+	struct xfs_bui_log_format	*bui_formatp;
+
+	bui_formatp = item->ri_buf[0].i_addr;
+
+	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+	buip = xfs_bui_init(mp);
+	error = xfs_bui_copy_format(&item->ri_buf[0], &buip->bui_format);
+	if (error) {
+		xfs_bui_item_free(buip);
+		return error;
+	}
+	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
+
+	spin_lock(&log->l_ailp->ail_lock);
+	/*
+	 * The RUI has two references. One for the RUD and one for RUI to ensure
+	 * it makes it into the AIL. Insert the RUI into the AIL directly and
+	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
+	 * AIL lock.
+	 */
+	xfs_trans_ail_update(log->l_ailp, &buip->bui_item, lsn);
+	xfs_bui_release(buip);
+	return 0;
+}
+
 const struct xlog_recover_item_ops xlog_bmap_intent_item_ops = {
 	.item_type		= XFS_LI_BUI,
+	.commit_pass2		= xlog_recover_bmap_intent_commit_pass2,
 };
 
+/*
+ * This routine is called when an BUD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding BUI if it
+ * was still in the log. To do this it searches the AIL for the BUI with an id
+ * equal to that in the BUD format structure. If we find it we drop the BUD
+ * reference, which removes the BUI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_bmap_done_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_bud_log_format	*bud_formatp;
+	struct xfs_bui_log_item		*buip = NULL;
+	struct xfs_log_item		*lip;
+	uint64_t			bui_id;
+	struct xfs_ail_cursor		cur;
+	struct xfs_ail			*ailp = log->l_ailp;
+
+	bud_formatp = item->ri_buf[0].i_addr;
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+	bui_id = bud_formatp->bud_bui_id;
+
+	/*
+	 * Search for the BUI with the id in the BUD format structure in the
+	 * AIL.
+	 */
+	spin_lock(&ailp->ail_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		if (lip->li_type == XFS_LI_BUI) {
+			buip = (struct xfs_bui_log_item *)lip;
+			if (buip->bui_format.bui_id == bui_id) {
+				/*
+				 * Drop the BUD reference to the BUI. This
+				 * removes the BUI from the AIL and frees it.
+				 */
+				spin_unlock(&ailp->ail_lock);
+				xfs_bui_release(buip);
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
 const struct xlog_recover_item_ops xlog_bmap_done_item_ops = {
 	.item_type		= XFS_LI_BUD,
+	.commit_pass2		= xlog_recover_bmap_done_commit_pass2,
 };
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index ad479cc73de8..515b1d5d6ab7 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -74,8 +74,6 @@ struct xfs_bud_log_item {
 extern struct kmem_zone	*xfs_bui_zone;
 extern struct kmem_zone	*xfs_bud_zone;
 
-struct xfs_bui_log_item *xfs_bui_init(struct xfs_mount *);
-void xfs_bui_item_free(struct xfs_bui_log_item *);
 void xfs_bui_release(struct xfs_bui_log_item *);
 int xfs_bui_recover(struct xfs_trans *parent_tp, struct xfs_bui_log_item *buip);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 23008b7cf93c..a5158e9e0662 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2034,130 +2034,6 @@ xlog_buf_readahead(
 		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
 }
 
-/*
- * Copy an BUI format buffer from the given buf, and into the destination
- * BUI format structure.  The BUI/BUD items were designed not to need any
- * special alignment handling.
- */
-static int
-xfs_bui_copy_format(
-	struct xfs_log_iovec		*buf,
-	struct xfs_bui_log_format	*dst_bui_fmt)
-{
-	struct xfs_bui_log_format	*src_bui_fmt;
-	uint				len;
-
-	src_bui_fmt = buf->i_addr;
-	len = xfs_bui_log_format_sizeof(src_bui_fmt->bui_nextents);
-
-	if (buf->i_len == len) {
-		memcpy(dst_bui_fmt, src_bui_fmt, len);
-		return 0;
-	}
-	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
-	return -EFSCORRUPTED;
-}
-
-/*
- * This routine is called to create an in-core extent bmap update
- * item from the bui format structure which was logged on disk.
- * It allocates an in-core bui, copies the extents from the format
- * structure into it, and adds the bui to the AIL with the given
- * LSN.
- */
-STATIC int
-xlog_recover_bui_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item,
-	xfs_lsn_t			lsn)
-{
-	int				error;
-	struct xfs_mount		*mp = log->l_mp;
-	struct xfs_bui_log_item		*buip;
-	struct xfs_bui_log_format	*bui_formatp;
-
-	bui_formatp = item->ri_buf[0].i_addr;
-
-	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
-		return -EFSCORRUPTED;
-	}
-	buip = xfs_bui_init(mp);
-	error = xfs_bui_copy_format(&item->ri_buf[0], &buip->bui_format);
-	if (error) {
-		xfs_bui_item_free(buip);
-		return error;
-	}
-	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
-
-	spin_lock(&log->l_ailp->ail_lock);
-	/*
-	 * The RUI has two references. One for the RUD and one for RUI to ensure
-	 * it makes it into the AIL. Insert the RUI into the AIL directly and
-	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
-	 * AIL lock.
-	 */
-	xfs_trans_ail_update(log->l_ailp, &buip->bui_item, lsn);
-	xfs_bui_release(buip);
-	return 0;
-}
-
-
-/*
- * This routine is called when an BUD format structure is found in a committed
- * transaction in the log. Its purpose is to cancel the corresponding BUI if it
- * was still in the log. To do this it searches the AIL for the BUI with an id
- * equal to that in the BUD format structure. If we find it we drop the BUD
- * reference, which removes the BUI from the AIL and frees it.
- */
-STATIC int
-xlog_recover_bud_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item)
-{
-	struct xfs_bud_log_format	*bud_formatp;
-	struct xfs_bui_log_item		*buip = NULL;
-	struct xfs_log_item		*lip;
-	uint64_t			bui_id;
-	struct xfs_ail_cursor		cur;
-	struct xfs_ail			*ailp = log->l_ailp;
-
-	bud_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
-		return -EFSCORRUPTED;
-	}
-	bui_id = bud_formatp->bud_bui_id;
-
-	/*
-	 * Search for the BUI with the id in the BUD format structure in the
-	 * AIL.
-	 */
-	spin_lock(&ailp->ail_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	while (lip != NULL) {
-		if (lip->li_type == XFS_LI_BUI) {
-			buip = (struct xfs_bui_log_item *)lip;
-			if (buip->bui_format.bui_id == bui_id) {
-				/*
-				 * Drop the BUD reference to the BUI. This
-				 * removes the BUI from the AIL and frees it.
-				 */
-				spin_unlock(&ailp->ail_lock);
-				xfs_bui_release(buip);
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
 STATIC int
 xlog_recover_commit_pass2(
 	struct xlog			*log,
@@ -2172,10 +2048,6 @@ xlog_recover_commit_pass2(
 				trans->r_lsn);
 
 	switch (ITEM_TYPE(item)) {
-	case XFS_LI_BUI:
-		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
-	case XFS_LI_BUD:
-		return xlog_recover_bud_pass2(log, item);
 	case XFS_LI_QUOTAOFF:
 		/* nothing to do in pass2 */
 		return 0;

