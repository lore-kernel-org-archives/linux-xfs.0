Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56272C38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30BF020747
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:04:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pd7jmwCq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgEGBEw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:04:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54772 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728199AbgEGBEw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:04:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470w4AV130682;
        Thu, 7 May 2020 01:02:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=MVjENhfijVERd3jhSeCGCQR7gOPsKTCP2ENb5Mlk1/E=;
 b=pd7jmwCq/pwJALbK3oXOBKOQfDjb6mHZUaQ4rxGb4JjcTAYVa3XnV05ln4zRmMO1OCLI
 DFgHKNP/npBkFPdS5h7hi9kvj+ns3Tamrof19L4BKq3y5mQfADPfTq1Jdz1N1SNnwHam
 QdIGrybz4ZPUlQp5sCRl4ECcxGc8/EMXyKG0qF34SXNayE/SQOL2skOzDuQDdhYeYwor
 1cZZdtu85XQ6Bw9CiA2CpmZMyA/HI1JrUHNcuujv2KG7ytIYDB0XuWouCmKdY2QD6393
 vOGI+Jni4aMnYKSe4IEFGTVXrI2SrkIwlI0poIV+rn+vEzKgup0KhXTImBV7foyJ4z84 FQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30s1gnda3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:02:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470vnoL010030;
        Thu, 7 May 2020 01:02:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30t1r96ehh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:02:44 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04712hd0000843;
        Thu, 7 May 2020 01:02:43 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:02:43 -0700
Subject: [PATCH 09/25] xfs: refactor log recovery EFI item dispatch for pass2
 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:02:39 -0700
Message-ID: <158881335982.189971.1961358239459049089.stgit@magnolia>
In-Reply-To: <158881329912.189971.14392758631836955942.stgit@magnolia>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=3
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
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

Move the extent free intent and intent-done pass2 commit code into the
per-item source code files and use dispatch functions to call them.  We
do these one at a time because there's a lot of code to move.  No
functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extfree_item.c |  107 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_extfree_item.h |    4 --
 fs/xfs/xfs_log_recover.c  |  100 ------------------------------------------
 3 files changed, 104 insertions(+), 107 deletions(-)


diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 163d01cb9f9f..69f7e75a747e 100644
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
@@ -646,10 +647,110 @@ xfs_efi_recover(
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
+xlog_recover_efi_commit_pass2(
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
 const struct xlog_recover_item_ops xlog_efi_item_ops = {
 	.item_type		= XFS_LI_EFI,
+	.commit_pass2		= xlog_recover_efi_commit_pass2,
 };
 
+/*
+ * This routine is called when an EFD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding EFI if it
+ * was still in the log. To do this it searches the AIL for the EFI with an id
+ * equal to that in the EFD format structure. If we find it we drop the EFD
+ * reference, which removes the EFI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_efd_commit_pass2(
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
 const struct xlog_recover_item_ops xlog_efd_item_ops = {
 	.item_type		= XFS_LI_EFD,
+	.commit_pass2		= xlog_recover_efd_commit_pass2,
 };
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index a2a736a77fa9..876e3d237f48 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -78,10 +78,6 @@ struct xfs_efd_log_item {
 extern struct kmem_zone	*xfs_efi_zone;
 extern struct kmem_zone	*xfs_efd_zone;
 
-struct xfs_efi_log_item	*xfs_efi_init(struct xfs_mount *, uint);
-int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
-					    xfs_efi_log_format_t *dst_efi_fmt);
-void			xfs_efi_item_free(struct xfs_efi_log_item *);
 void			xfs_efi_release(struct xfs_efi_log_item *);
 
 int			xfs_efi_recover(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0a90ec9d0ca6..26f0f84f2528 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2034,102 +2034,6 @@ xlog_buf_readahead(
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
-	struct xfs_efi_log_item	*efip = NULL;
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
-			efip = (struct xfs_efi_log_item *)lip;
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
@@ -2481,10 +2385,6 @@ xlog_recover_commit_pass2(
 				trans->r_lsn);
 
 	switch (ITEM_TYPE(item)) {
-	case XFS_LI_EFI:
-		return xlog_recover_efi_pass2(log, item, trans->r_lsn);
-	case XFS_LI_EFD:
-		return xlog_recover_efd_pass2(log, item);
 	case XFS_LI_RUI:
 		return xlog_recover_rui_pass2(log, item, trans->r_lsn);
 	case XFS_LI_RUD:

