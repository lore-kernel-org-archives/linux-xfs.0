Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918DBC83000
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C43A20575
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:48:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aWEZEKZc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgD3As6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:48:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49302 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgD3As5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:48:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0lMIt164621
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Binw4eqAO6fSLrK9vE8PHhGIA9XXCyTAuXBhMaB7zyc=;
 b=aWEZEKZcBwowQBasQU0smnCPN/ymL09erFdMkC6V6MHpp5wkyyAEqMm0V52trOC38goO
 jdoMg4l4aTon7gGg9Xi58qfAd0TrusTW7m8vt0GumpVA7p7BT2ZpGcNmvDzycq+8eQZb
 zxSnTma5XLmxe8cLyNLiEODQuTDXgrED0iqiyTYJukBEGfplVerueErnD0bmoKzlT/5Y
 qG7mfeZkQpFTDmB8kLLjfOIl6fQNA9jwZfWspZqCv8rpbBMoOg+ixEH5kqtCKJEWHoq7
 iK5QlZ8rYIg/HiJb7VAlUyd0wPhcDaM0/0ZgamCsKZLqtiGvdcJJc37/Hq5/67LI55lt dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30p01ny8k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0l6fh119990
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30my0jr2dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:54 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03U0msT1009596
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 00:48:53 +0000
Subject: [PATCH 12/21] xfs: refactor log recovery BUI item dispatch for
 pass2 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:48:52 -0700
Message-ID: <158820773272.467894.9763070232498118105.stgit@magnolia>
In-Reply-To: <158820765488.467894.15408191148091671053.stgit@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=3 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=3 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300000
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
 fs/xfs/xfs_bmap_item.c   |  134 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_item.h   |    2 -
 fs/xfs/xfs_log_recover.c |  139 ++--------------------------------------------
 3 files changed, 137 insertions(+), 138 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index a2824013e2cb..f5c19ea4affb 100644
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
 
@@ -565,8 +566,137 @@ xfs_bui_recover(
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
+
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
 const struct xlog_recover_item_type xlog_bmap_intent_item_type = {
+	.commit_pass2_fn	= xlog_recover_bmap_intent_commit_pass2,
 };
 
 const struct xlog_recover_item_type xlog_bmap_done_item_type = {
+	.commit_pass2_fn	= xlog_recover_bmap_done_commit_pass2,
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
index 9292623bbdb4..d28a46888efb 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2056,130 +2056,6 @@ xlog_buf_readahead(
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
 xlog_recover_commit_pass1(
 	struct xlog			*log,
@@ -2208,21 +2084,16 @@ xlog_recover_commit_pass2(
 {
 	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS2);
 
-	if (item->ri_type && item->ri_type->commit_pass2_fn)
-		return item->ri_type->commit_pass2_fn(log, buffer_list, item,
-				trans->r_lsn);
-
-	switch (ITEM_TYPE(item)) {
-	case XFS_LI_BUI:
-		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
-	case XFS_LI_BUD:
-		return xlog_recover_bud_pass2(log, item);
-	default:
+	if (!item->ri_type) {
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
 		return -EFSCORRUPTED;
 	}
+	if (!item->ri_type->commit_pass2_fn)
+		return 0;
+	return item->ri_type->commit_pass2_fn(log, buffer_list, item,
+			trans->r_lsn);
 }
 
 STATIC int

