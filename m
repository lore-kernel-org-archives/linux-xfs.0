Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C140DC28CBC
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:04:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9793320747
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:04:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KWkWYT7+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgEGBE4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:04:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54808 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728199AbgEGBEz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:04:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470vnWa130580;
        Thu, 7 May 2020 01:02:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yJgypV4buUclhFzaHHYHb+gk+Wp6NBl1F6rdqV+JD2k=;
 b=KWkWYT7+dbfsGkMmilx4YL8K5kwO5c17ab8wNWbsZ3Z0Qpc66o3Oe10I10U5c09PRGBx
 e6v9yhkL84pvw+qQnnAFxuH/eFQjNPZXL1/Zv1jLFHc1bfv1S1Laa8H+bz93kQaXh2Ao
 hZrZNxZdHFFWBp4r8gGsU92olSBMxcqGYpG1zsbAQNFqMpxBT1mxax3458FSi25FngXW
 7UeS+GaD65fjXrsRLfUMpPgcPdU4CCBN31vw2u0/liNaY6//dGQwSNpO9W/LLaEpe7xW
 jjLEzZLfFypvgJSjDGei4iZV05zJCU1OpA5Gx4WOOVZPIj2czT8I0UW2TUJprRftYfeq 9Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30s1gnda3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:02:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470wdVn052106;
        Thu, 7 May 2020 01:02:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30us7p3k7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:02:51 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04712oOW028366;
        Thu, 7 May 2020 01:02:50 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:02:49 -0700
Subject: [PATCH 10/25] xfs: refactor log recovery RUI item dispatch for pass2
 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:02:46 -0700
Message-ID: <158881336613.189971.18086586536895108564.stgit@magnolia>
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

Move the rmap update intent and intent-done pass2 commit code into the
per-item source code files and use dispatch functions to call them.  We
do these one at a time because there's a lot of code to move.  No
functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c |   97 -------------------------------------------
 fs/xfs/xfs_rmap_item.c   |  104 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_rmap_item.h   |    4 --
 3 files changed, 101 insertions(+), 104 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 26f0f84f2528..875d79d88018 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2034,99 +2034,6 @@ xlog_buf_readahead(
 		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
 }
 
-/*
- * This routine is called to create an in-core extent rmap update
- * item from the rui format structure which was logged on disk.
- * It allocates an in-core rui, copies the extents from the format
- * structure into it, and adds the rui to the AIL with the given
- * LSN.
- */
-STATIC int
-xlog_recover_rui_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item,
-	xfs_lsn_t			lsn)
-{
-	int				error;
-	struct xfs_mount		*mp = log->l_mp;
-	struct xfs_rui_log_item		*ruip;
-	struct xfs_rui_log_format	*rui_formatp;
-
-	rui_formatp = item->ri_buf[0].i_addr;
-
-	ruip = xfs_rui_init(mp, rui_formatp->rui_nextents);
-	error = xfs_rui_copy_format(&item->ri_buf[0], &ruip->rui_format);
-	if (error) {
-		xfs_rui_item_free(ruip);
-		return error;
-	}
-	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
-
-	spin_lock(&log->l_ailp->ail_lock);
-	/*
-	 * The RUI has two references. One for the RUD and one for RUI to ensure
-	 * it makes it into the AIL. Insert the RUI into the AIL directly and
-	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
-	 * AIL lock.
-	 */
-	xfs_trans_ail_update(log->l_ailp, &ruip->rui_item, lsn);
-	xfs_rui_release(ruip);
-	return 0;
-}
-
-
-/*
- * This routine is called when an RUD format structure is found in a committed
- * transaction in the log. Its purpose is to cancel the corresponding RUI if it
- * was still in the log. To do this it searches the AIL for the RUI with an id
- * equal to that in the RUD format structure. If we find it we drop the RUD
- * reference, which removes the RUI from the AIL and frees it.
- */
-STATIC int
-xlog_recover_rud_pass2(
-	struct xlog			*log,
-	struct xlog_recover_item	*item)
-{
-	struct xfs_rud_log_format	*rud_formatp;
-	struct xfs_rui_log_item		*ruip = NULL;
-	struct xfs_log_item		*lip;
-	uint64_t			rui_id;
-	struct xfs_ail_cursor		cur;
-	struct xfs_ail			*ailp = log->l_ailp;
-
-	rud_formatp = item->ri_buf[0].i_addr;
-	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_rud_log_format));
-	rui_id = rud_formatp->rud_rui_id;
-
-	/*
-	 * Search for the RUI with the id in the RUD format structure in the
-	 * AIL.
-	 */
-	spin_lock(&ailp->ail_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	while (lip != NULL) {
-		if (lip->li_type == XFS_LI_RUI) {
-			ruip = (struct xfs_rui_log_item *)lip;
-			if (ruip->rui_format.rui_id == rui_id) {
-				/*
-				 * Drop the RUD reference to the RUI. This
-				 * removes the RUI from the AIL and frees it.
-				 */
-				spin_unlock(&ailp->ail_lock);
-				xfs_rui_release(ruip);
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
  * Copy an CUI format buffer from the given buf, and into the destination
  * CUI format structure.  The CUI/CUD items were designed not to need any
@@ -2385,10 +2292,6 @@ xlog_recover_commit_pass2(
 				trans->r_lsn);
 
 	switch (ITEM_TYPE(item)) {
-	case XFS_LI_RUI:
-		return xlog_recover_rui_pass2(log, item, trans->r_lsn);
-	case XFS_LI_RUD:
-		return xlog_recover_rud_pass2(log, item);
 	case XFS_LI_CUI:
 		return xlog_recover_cui_pass2(log, item, trans->r_lsn);
 	case XFS_LI_CUD:
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 0f3af9f05764..44049dbdb161 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -18,6 +18,7 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_error.h"
+#include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 
 kmem_zone_t	*xfs_rui_zone;
@@ -28,7 +29,7 @@ static inline struct xfs_rui_log_item *RUI_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_rui_log_item, rui_item);
 }
 
-void
+STATIC void
 xfs_rui_item_free(
 	struct xfs_rui_log_item	*ruip)
 {
@@ -133,7 +134,7 @@ static const struct xfs_item_ops xfs_rui_item_ops = {
 /*
  * Allocate and initialize an rui item with the given number of extents.
  */
-struct xfs_rui_log_item *
+STATIC struct xfs_rui_log_item *
 xfs_rui_init(
 	struct xfs_mount		*mp,
 	uint				nextents)
@@ -161,7 +162,7 @@ xfs_rui_init(
  * RUI format structure.  The RUI/RUD items were designed not to need any
  * special alignment handling.
  */
-int
+STATIC int
 xfs_rui_copy_format(
 	struct xfs_log_iovec		*buf,
 	struct xfs_rui_log_format	*dst_rui_fmt)
@@ -587,10 +588,107 @@ xfs_rui_recover(
 	return error;
 }
 
+/*
+ * This routine is called to create an in-core extent rmap update
+ * item from the rui format structure which was logged on disk.
+ * It allocates an in-core rui, copies the extents from the format
+ * structure into it, and adds the rui to the AIL with the given
+ * LSN.
+ */
+STATIC int
+xlog_recover_rui_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	int				error;
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_rui_log_item		*ruip;
+	struct xfs_rui_log_format	*rui_formatp;
+
+	rui_formatp = item->ri_buf[0].i_addr;
+
+	ruip = xfs_rui_init(mp, rui_formatp->rui_nextents);
+	error = xfs_rui_copy_format(&item->ri_buf[0], &ruip->rui_format);
+	if (error) {
+		xfs_rui_item_free(ruip);
+		return error;
+	}
+	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
+
+	spin_lock(&log->l_ailp->ail_lock);
+	/*
+	 * The RUI has two references. One for the RUD and one for RUI to ensure
+	 * it makes it into the AIL. Insert the RUI into the AIL directly and
+	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
+	 * AIL lock.
+	 */
+	xfs_trans_ail_update(log->l_ailp, &ruip->rui_item, lsn);
+	xfs_rui_release(ruip);
+	return 0;
+}
+
 const struct xlog_recover_item_ops xlog_rui_item_ops = {
 	.item_type		= XFS_LI_RUI,
+	.commit_pass2		= xlog_recover_rui_commit_pass2,
 };
 
+/*
+ * This routine is called when an RUD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding RUI if it
+ * was still in the log. To do this it searches the AIL for the RUI with an id
+ * equal to that in the RUD format structure. If we find it we drop the RUD
+ * reference, which removes the RUI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_rud_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_rud_log_format	*rud_formatp;
+	struct xfs_rui_log_item		*ruip = NULL;
+	struct xfs_log_item		*lip;
+	uint64_t			rui_id;
+	struct xfs_ail_cursor		cur;
+	struct xfs_ail			*ailp = log->l_ailp;
+
+	rud_formatp = item->ri_buf[0].i_addr;
+	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_rud_log_format));
+	rui_id = rud_formatp->rud_rui_id;
+
+	/*
+	 * Search for the RUI with the id in the RUD format structure in the
+	 * AIL.
+	 */
+	spin_lock(&ailp->ail_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		if (lip->li_type == XFS_LI_RUI) {
+			ruip = (struct xfs_rui_log_item *)lip;
+			if (ruip->rui_format.rui_id == rui_id) {
+				/*
+				 * Drop the RUD reference to the RUI. This
+				 * removes the RUI from the AIL and frees it.
+				 */
+				spin_unlock(&ailp->ail_lock);
+				xfs_rui_release(ruip);
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
 const struct xlog_recover_item_ops xlog_rud_item_ops = {
 	.item_type		= XFS_LI_RUD,
+	.commit_pass2		= xlog_recover_rud_commit_pass2,
 };
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 8708e4a5aa5c..89bd192779f8 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -77,10 +77,6 @@ struct xfs_rud_log_item {
 extern struct kmem_zone	*xfs_rui_zone;
 extern struct kmem_zone	*xfs_rud_zone;
 
-struct xfs_rui_log_item *xfs_rui_init(struct xfs_mount *, uint);
-int xfs_rui_copy_format(struct xfs_log_iovec *buf,
-		struct xfs_rui_log_format *dst_rui_fmt);
-void xfs_rui_item_free(struct xfs_rui_log_item *);
 void xfs_rui_release(struct xfs_rui_log_item *);
 int xfs_rui_recover(struct xfs_mount *mp, struct xfs_rui_log_item *ruip);
 

