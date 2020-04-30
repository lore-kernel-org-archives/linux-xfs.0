Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125DAC83004
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE97620838
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:48:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sITuw+kp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgD3As5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:48:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45984 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgD3As5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:48:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0mtL6193011
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Zsqrlb/V00p0xbrn1cKwhFElBpOroTesi0/2DT7WBiI=;
 b=sITuw+kpSw5XO/8mx+sNnWxeAJE9YJ2mSrMr+Dx8jsDIc1GaRjl4cJ+L8uigFw9sxEF/
 fl2RlsnwptEqHKilEoSKGzjGI9+ZzUrfvNVXh1Vn8epVbxPLEVksQkXL3U0cX2KHJWiu
 rUUw3Dbpcx9XFlJ+IZdd+dzEoXLDPgV3zk2bkYatPLljEoRyCRNEMw7pOHlnGd90tA6L
 48FYUz9nVRTtKhQJGuEAFrkPyyeks9LpgbFoBKOXuOILDWLKNHls/bgT5/g+DVBqjP51
 3NjWDF1RKZgst/MCtPXVuPrJeZmpSZQ1FJdQYznkIjwd0GTds0CHqwERs4I8U5M9gqLI gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30nucg8q8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0l6E0119968
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30my0jr28d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:48 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03U0ml70013275
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 17:48:47 -0700
Subject: [PATCH 11/21] xfs: refactor log recovery CUI item dispatch for
 pass2 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:48:46 -0700
Message-ID: <158820772645.467894.2726575435557937133.stgit@magnolia>
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

Move the refcount update intent and intent-done pass2 commit code into
the per-item source code files and use dispatch functions to call them.
We do these one at a time because there's a lot of code to move.  No
functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c   |  124 ------------------------------------------
 fs/xfs/xfs_refcount_item.c |  130 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_refcount_item.h |    2 -
 3 files changed, 128 insertions(+), 128 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 31f8449f2866..9292623bbdb4 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2056,126 +2056,6 @@ xlog_buf_readahead(
 		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
 }
 
-/*
- * Copy an CUI format buffer from the given buf, and into the destination
- * CUI format structure.  The CUI/CUD items were designed not to need any
- * special alignment handling.
- */
-static int
-xfs_cui_copy_format(
-	struct xfs_log_iovec		*buf,
-	struct xfs_cui_log_format	*dst_cui_fmt)
-{
-	struct xfs_cui_log_format	*src_cui_fmt;
-	uint				len;
-
-	src_cui_fmt = buf->i_addr;
-	len = xfs_cui_log_format_sizeof(src_cui_fmt->cui_nextents);
-
-	if (buf->i_len == len) {
-		memcpy(dst_cui_fmt, src_cui_fmt, len);
-		return 0;
-	}
-	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
-	return -EFSCORRUPTED;
-}
-
-/*
- * This routine is called to create an in-core extent refcount update
- * item from the cui format structure which was logged on disk.
- * It allocates an in-core cui, copies the extents from the format
- * structure into it, and adds the cui to the AIL with the given
- * LSN.
- */
-STATIC int
-xlog_recover_cui_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item,
-	xfs_lsn_t			lsn)
-{
-	int				error;
-	struct xfs_mount		*mp = log->l_mp;
-	struct xfs_cui_log_item		*cuip;
-	struct xfs_cui_log_format	*cui_formatp;
-
-	cui_formatp = item->ri_buf[0].i_addr;
-
-	cuip = xfs_cui_init(mp, cui_formatp->cui_nextents);
-	error = xfs_cui_copy_format(&item->ri_buf[0], &cuip->cui_format);
-	if (error) {
-		xfs_cui_item_free(cuip);
-		return error;
-	}
-	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
-
-	spin_lock(&log->l_ailp->ail_lock);
-	/*
-	 * The CUI has two references. One for the CUD and one for CUI to ensure
-	 * it makes it into the AIL. Insert the CUI into the AIL directly and
-	 * drop the CUI reference. Note that xfs_trans_ail_update() drops the
-	 * AIL lock.
-	 */
-	xfs_trans_ail_update(log->l_ailp, &cuip->cui_item, lsn);
-	xfs_cui_release(cuip);
-	return 0;
-}
-
-
-/*
- * This routine is called when an CUD format structure is found in a committed
- * transaction in the log. Its purpose is to cancel the corresponding CUI if it
- * was still in the log. To do this it searches the AIL for the CUI with an id
- * equal to that in the CUD format structure. If we find it we drop the CUD
- * reference, which removes the CUI from the AIL and frees it.
- */
-STATIC int
-xlog_recover_cud_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item)
-{
-	struct xfs_cud_log_format	*cud_formatp;
-	struct xfs_cui_log_item		*cuip = NULL;
-	struct xfs_log_item		*lip;
-	uint64_t			cui_id;
-	struct xfs_ail_cursor		cur;
-	struct xfs_ail			*ailp = log->l_ailp;
-
-	cud_formatp = item->ri_buf[0].i_addr;
-	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
-		return -EFSCORRUPTED;
-	}
-	cui_id = cud_formatp->cud_cui_id;
-
-	/*
-	 * Search for the CUI with the id in the CUD format structure in the
-	 * AIL.
-	 */
-	spin_lock(&ailp->ail_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	while (lip != NULL) {
-		if (lip->li_type == XFS_LI_CUI) {
-			cuip = (struct xfs_cui_log_item *)lip;
-			if (cuip->cui_format.cui_id == cui_id) {
-				/*
-				 * Drop the CUD reference to the CUI. This
-				 * removes the CUI from the AIL and frees it.
-				 */
-				spin_unlock(&ailp->ail_lock);
-				xfs_cui_release(cuip);
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
  * Copy an BUI format buffer from the given buf, and into the destination
  * BUI format structure.  The BUI/BUD items were designed not to need any
@@ -2333,10 +2213,6 @@ xlog_recover_commit_pass2(
 				trans->r_lsn);
 
 	switch (ITEM_TYPE(item)) {
-	case XFS_LI_CUI:
-		return xlog_recover_cui_pass2(log, item, trans->r_lsn);
-	case XFS_LI_CUD:
-		return xlog_recover_cud_pass2(log, item);
 	case XFS_LI_BUI:
 		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
 	case XFS_LI_BUD:
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index ddab09385bfb..a76a5e9b862e 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -18,6 +18,7 @@
 #include "xfs_log.h"
 #include "xfs_refcount.h"
 #include "xfs_error.h"
+#include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_cui_zone;
@@ -28,7 +29,7 @@ static inline struct xfs_cui_log_item *CUI_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_cui_log_item, cui_item);
 }
 
-void
+STATIC void
 xfs_cui_item_free(
 	struct xfs_cui_log_item	*cuip)
 {
@@ -134,7 +135,7 @@ static const struct xfs_item_ops xfs_cui_item_ops = {
 /*
  * Allocate and initialize an cui item with the given number of extents.
  */
-struct xfs_cui_log_item *
+STATIC struct xfs_cui_log_item *
 xfs_cui_init(
 	struct xfs_mount		*mp,
 	uint				nextents)
@@ -592,8 +593,133 @@ xfs_cui_recover(
 	return error;
 }
 
+/*
+ * Copy an CUI format buffer from the given buf, and into the destination
+ * CUI format structure.  The CUI/CUD items were designed not to need any
+ * special alignment handling.
+ */
+static int
+xfs_cui_copy_format(
+	struct xfs_log_iovec		*buf,
+	struct xfs_cui_log_format	*dst_cui_fmt)
+{
+	struct xfs_cui_log_format	*src_cui_fmt;
+	uint				len;
+
+	src_cui_fmt = buf->i_addr;
+	len = xfs_cui_log_format_sizeof(src_cui_fmt->cui_nextents);
+
+	if (buf->i_len == len) {
+		memcpy(dst_cui_fmt, src_cui_fmt, len);
+		return 0;
+	}
+	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
+	return -EFSCORRUPTED;
+}
+
+/*
+ * This routine is called to create an in-core extent refcount update
+ * item from the cui format structure which was logged on disk.
+ * It allocates an in-core cui, copies the extents from the format
+ * structure into it, and adds the cui to the AIL with the given
+ * LSN.
+ */
+STATIC int
+xlog_recover_refcount_intent_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	int				error;
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_cui_log_item		*cuip;
+	struct xfs_cui_log_format	*cui_formatp;
+
+	cui_formatp = item->ri_buf[0].i_addr;
+
+	cuip = xfs_cui_init(mp, cui_formatp->cui_nextents);
+	error = xfs_cui_copy_format(&item->ri_buf[0], &cuip->cui_format);
+	if (error) {
+		xfs_cui_item_free(cuip);
+		return error;
+	}
+	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
+
+	spin_lock(&log->l_ailp->ail_lock);
+	/*
+	 * The CUI has two references. One for the CUD and one for CUI to ensure
+	 * it makes it into the AIL. Insert the CUI into the AIL directly and
+	 * drop the CUI reference. Note that xfs_trans_ail_update() drops the
+	 * AIL lock.
+	 */
+	xfs_trans_ail_update(log->l_ailp, &cuip->cui_item, lsn);
+	xfs_cui_release(cuip);
+	return 0;
+}
+
+
+/*
+ * This routine is called when an CUD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding CUI if it
+ * was still in the log. To do this it searches the AIL for the CUI with an id
+ * equal to that in the CUD format structure. If we find it we drop the CUD
+ * reference, which removes the CUI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_refcount_done_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_cud_log_format	*cud_formatp;
+	struct xfs_cui_log_item		*cuip = NULL;
+	struct xfs_log_item		*lip;
+	uint64_t			cui_id;
+	struct xfs_ail_cursor		cur;
+	struct xfs_ail			*ailp = log->l_ailp;
+
+	cud_formatp = item->ri_buf[0].i_addr;
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+	cui_id = cud_formatp->cud_cui_id;
+
+	/*
+	 * Search for the CUI with the id in the CUD format structure in the
+	 * AIL.
+	 */
+	spin_lock(&ailp->ail_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		if (lip->li_type == XFS_LI_CUI) {
+			cuip = (struct xfs_cui_log_item *)lip;
+			if (cuip->cui_format.cui_id == cui_id) {
+				/*
+				 * Drop the CUD reference to the CUI. This
+				 * removes the CUI from the AIL and frees it.
+				 */
+				spin_unlock(&ailp->ail_lock);
+				xfs_cui_release(cuip);
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
 const struct xlog_recover_item_type xlog_refcount_intent_item_type = {
+	.commit_pass2_fn	= xlog_recover_refcount_intent_commit_pass2,
 };
 
 const struct xlog_recover_item_type xlog_refcount_done_item_type = {
+	.commit_pass2_fn	= xlog_recover_refcount_done_commit_pass2,
 };
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index e47530f30489..ebe12779eaac 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -77,8 +77,6 @@ struct xfs_cud_log_item {
 extern struct kmem_zone	*xfs_cui_zone;
 extern struct kmem_zone	*xfs_cud_zone;
 
-struct xfs_cui_log_item *xfs_cui_init(struct xfs_mount *, uint);
-void xfs_cui_item_free(struct xfs_cui_log_item *);
 void xfs_cui_release(struct xfs_cui_log_item *);
 int xfs_cui_recover(struct xfs_trans *parent_tp, struct xfs_cui_log_item *cuip);
 

