Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E5FC28CBC
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3810320708
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:03:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lQIxgnDW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgEGBDC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:03:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52404 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgEGBDC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:03:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470xPQZ123199;
        Thu, 7 May 2020 01:02:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=WSf8QVKpCOloQyHwmcJWGJIs4Pq591e8Hby0+z2H0SQ=;
 b=lQIxgnDWmUxDfVlXZ36Wv0DU56R2ktK7MTblPihIBE/wpquMvCPuDFtVFB8o/VVnxRxd
 sdBkeCJR3Xri1VZe9SzMmS9bVjwL6pJXChU3H2L2Q3pwTEiY5pOnHOuMLJR8EhfFradB
 sOQVcdQE8GR8DFUCEHk0x2ue7Dv1F35IN2i14UlUa8BNZ40TyCAQFRKgf5pX7LhAcsw1
 UoNfgHTWNviJWreeEndHSsTn1uWb/ah04ZagLD9NQRaoEFkXncsiLWkZ28VDaZsBOlgK
 YSo1esAIn3Gl5GmtP+tKD6d6SHQCLCJBeGrvsh1iM/VYG0f1AZBTtR239Kw5aL04/8+E FQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30usgq4jed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:02:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470vWZj150937;
        Thu, 7 May 2020 01:02:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30sjnmbk8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:02:56 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04712u3K004317;
        Thu, 7 May 2020 01:02:56 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:02:56 -0700
Subject: [PATCH 11/25] xfs: refactor log recovery CUI item dispatch for pass2
 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:02:52 -0700
Message-ID: <158881337243.189971.8705314240407916941.stgit@magnolia>
In-Reply-To: <158881329912.189971.14392758631836955942.stgit@magnolia>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=3
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

Move the refcount update intent and intent-done pass2 commit code into
the per-item source code files and use dispatch functions to call them.
We do these one at a time because there's a lot of code to move.  No
functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c   |  124 ------------------------------------------
 fs/xfs/xfs_refcount_item.c |  129 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_refcount_item.h |    2 -
 3 files changed, 127 insertions(+), 128 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 875d79d88018..0bce57088693 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2034,126 +2034,6 @@ xlog_buf_readahead(
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
@@ -2292,10 +2172,6 @@ xlog_recover_commit_pass2(
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
index 2a9465d9a77f..7ccdeafdb7e7 100644
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
@@ -572,10 +573,134 @@ xfs_cui_recover(
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
+xlog_recover_cui_commit_pass2(
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
 const struct xlog_recover_item_ops xlog_cui_item_ops = {
 	.item_type		= XFS_LI_CUI,
+	.commit_pass2		= xlog_recover_cui_commit_pass2,
 };
 
+/*
+ * This routine is called when an CUD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding CUI if it
+ * was still in the log. To do this it searches the AIL for the CUI with an id
+ * equal to that in the CUD format structure. If we find it we drop the CUD
+ * reference, which removes the CUI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_cud_commit_pass2(
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
 const struct xlog_recover_item_ops xlog_cud_item_ops = {
 	.item_type		= XFS_LI_CUD,
+	.commit_pass2		= xlog_recover_cud_commit_pass2,
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
 

