Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D710C8300A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03BB020787
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 00:51:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xh63SyU7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgD3Av4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 20:51:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48794 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgD3Avz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:51:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0oQcL161445
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:51:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1PjW7KPqoeKtl3JDETYJMRPAuJ2u97YFDFHOnxtd9oU=;
 b=xh63SyU71OV2CEqvpiMp2XE222iDXdpcUIU6akn3XQmCP/iWlM3J3pyQLH1630R9coKG
 ebOtO69LJrGVKR1JZo3oJJ8T2MmSlUuDQLolLSDlqlCYyUxbMCDQgGzUpifcGsXDx+KC
 +Y6EVUnBCe/UXIOQj4jXMLNKOTsiKtDNxpY1xTtg3kJf+WTizHxjdNmxIFAnXscP/FQR
 9EFtadk4y/vPP8ClOlqu6noHnnLSyB+QDggdHKnzvaK3BaHuT4QSKT7ci+pytBs35u3c
 ayeRUseGJivPNWDcG5X0mQjay7hWMjWDJ6bSoEJ1bEAldcJgJHg8UsIWW2zxfgYisWIk wA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30p2p0e57h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:51:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0l6uQ119982
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30my0jr44x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:52 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03U0npc8010025
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:49:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 00:49:50 +0000
Subject: [PATCH 20/21] xfs: refactor intent item iop_recover calls
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:49:49 -0700
Message-ID: <158820778915.467894.576137338703293664.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=3 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've made the recovered item tests all the same, we can hoist
the test and the ail locking code to the ->iop_recover caller and call
the recovery function directly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_item.c     |   50 ++++++++++++--------------------------------
 fs/xfs/xfs_extfree_item.c  |   46 +++++++++++-----------------------------
 fs/xfs/xfs_log_recover.c   |    8 +++++--
 fs/xfs/xfs_refcount_item.c |   48 +++++++++++-------------------------------
 fs/xfs/xfs_rmap_item.c     |   47 +++++++++++------------------------------
 5 files changed, 58 insertions(+), 141 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 5b99ffb70659..58f0904e4504 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -28,7 +28,7 @@
 kmem_zone_t	*xfs_bui_zone;
 kmem_zone_t	*xfs_bud_zone;
 
-STATIC int xfs_bui_recover(struct xfs_trans *tp, struct xfs_bui_log_item *buip);
+STATIC int xfs_bui_item_recover(struct xfs_log_item *lip, struct xfs_trans *tp);
 
 static inline struct xfs_bui_log_item *BUI_ITEM(struct xfs_log_item *lip)
 {
@@ -128,29 +128,6 @@ xfs_bui_item_release(
 	xfs_bui_release(BUI_ITEM(lip));
 }
 
-/* Recover the BUI if necessary. */
-STATIC int
-xfs_bui_item_recover(
-	struct xfs_log_item		*lip,
-	struct xfs_trans		*tp)
-{
-	struct xfs_ail			*ailp = lip->li_ailp;
-	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
-	int				error;
-
-	/*
-	 * Skip BUIs that we've already processed.
-	 */
-	if (test_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags))
-		return 0;
-
-	spin_unlock(&ailp->ail_lock);
-	error = xfs_bui_recover(tp, buip);
-	spin_lock(&ailp->ail_lock);
-
-	return error;
-}
-
 static const struct xfs_item_ops xfs_bui_item_ops = {
 	.flags		= XFS_ITEM_TYPE_IS_INTENT,
 	.iop_size	= xfs_bui_item_size,
@@ -459,25 +436,26 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
  * We need to update some inode's bmbt.
  */
 STATIC int
-xfs_bui_recover(
-	struct xfs_trans		*parent_tp,
-	struct xfs_bui_log_item		*buip)
+xfs_bui_item_recover(
+	struct xfs_log_item		*lip,
+	struct xfs_trans		*parent_tp)
 {
-	int				error = 0;
-	unsigned int			bui_type;
+	struct xfs_bmbt_irec		irec;
+	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
+	struct xfs_trans		*tp;
+	struct xfs_inode		*ip = NULL;
+	struct xfs_mount		*mp = parent_tp->t_mountp;
 	struct xfs_map_extent		*bmap;
+	struct xfs_bud_log_item		*budp;
 	xfs_fsblock_t			startblock_fsb;
 	xfs_fsblock_t			inode_fsb;
 	xfs_filblks_t			count;
-	bool				op_ok;
-	struct xfs_bud_log_item		*budp;
+	xfs_exntst_t			state;
 	enum xfs_bmap_intent_type	type;
+	bool				op_ok;
+	unsigned int			bui_type;
 	int				whichfork;
-	xfs_exntst_t			state;
-	struct xfs_trans		*tp;
-	struct xfs_inode		*ip = NULL;
-	struct xfs_bmbt_irec		irec;
-	struct xfs_mount		*mp = parent_tp->t_mountp;
+	int				error = 0;
 
 	ASSERT(!test_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags));
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6b5c2b263e5b..d6f2c88570de 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -28,7 +28,7 @@
 kmem_zone_t	*xfs_efi_zone;
 kmem_zone_t	*xfs_efd_zone;
 
-STATIC int xfs_efi_recover(struct xfs_mount *mp, struct xfs_efi_log_item *efip);
+STATIC int xfs_efi_item_recover(struct xfs_log_item *lip, struct xfs_trans *tp);
 
 static inline struct xfs_efi_log_item *EFI_ITEM(struct xfs_log_item *lip)
 {
@@ -143,30 +143,6 @@ xfs_efi_item_release(
 	xfs_efi_release(EFI_ITEM(lip));
 }
 
-/* Recover the EFI if necessary. */
-STATIC int
-xfs_efi_item_recover(
-	struct xfs_log_item		*lip,
-	struct xfs_trans		*tp)
-{
-	struct xfs_ail			*ailp = lip->li_ailp;
-	struct xfs_efi_log_item		*efip;
-	int				error;
-
-	/*
-	 * Skip EFIs that we've already processed.
-	 */
-	efip = container_of(lip, struct xfs_efi_log_item, efi_item);
-	if (test_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags))
-		return 0;
-
-	spin_unlock(&ailp->ail_lock);
-	error = xfs_efi_recover(tp->t_mountp, efip);
-	spin_lock(&ailp->ail_lock);
-
-	return error;
-}
-
 static const struct xfs_item_ops xfs_efi_item_ops = {
 	.flags		= XFS_ITEM_TYPE_IS_INTENT,
 	.iop_size	= xfs_efi_item_size,
@@ -623,16 +599,18 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
  * the log.  We need to free the extents that it describes.
  */
 STATIC int
-xfs_efi_recover(
-	struct xfs_mount	*mp,
-	struct xfs_efi_log_item	*efip)
+xfs_efi_item_recover(
+	struct xfs_log_item		*lip,
+	struct xfs_trans		*parent_tp)
 {
-	struct xfs_efd_log_item	*efdp;
-	struct xfs_trans	*tp;
-	int			i;
-	int			error = 0;
-	xfs_extent_t		*extp;
-	xfs_fsblock_t		startblock_fsb;
+	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
+	struct xfs_mount		*mp = parent_tp->t_mountp;
+	struct xfs_efd_log_item		*efdp;
+	struct xfs_trans		*tp;
+	struct xfs_extent		*extp;
+	xfs_fsblock_t			startblock_fsb;
+	int				i;
+	int				error = 0;
 
 	ASSERT(!test_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags));
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 527c74fa5cc3..277e83e74344 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2707,7 +2707,7 @@ xlog_recover_process_intents(
 	struct xfs_ail_cursor	cur;
 	struct xfs_log_item	*lip;
 	struct xfs_ail		*ailp;
-	int			error;
+	int			error = 0;
 #if defined(DEBUG) || defined(XFS_WARN)
 	xfs_lsn_t		last_lsn;
 #endif
@@ -2758,7 +2758,11 @@ xlog_recover_process_intents(
 		 * this routine or else those subsequent intents will get
 		 * replayed in the wrong order!
 		 */
-		error = lip->li_ops->iop_recover(lip, parent_tp);
+		if (!test_bit(XFS_LI_RECOVERED, &lip->li_flags)) {
+			spin_unlock(&ailp->ail_lock);
+			error = lip->li_ops->iop_recover(lip, parent_tp);
+			spin_lock(&ailp->ail_lock);
+		}
 		if (error)
 			goto out;
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 493f1d16a6ce..53a79dc618f7 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -24,7 +24,7 @@
 kmem_zone_t	*xfs_cui_zone;
 kmem_zone_t	*xfs_cud_zone;
 
-STATIC int xfs_cui_recover(struct xfs_trans *tp, struct xfs_cui_log_item *cuip);
+STATIC int xfs_cui_item_recover(struct xfs_log_item *lip, struct xfs_trans *tp);
 
 static inline struct xfs_cui_log_item *CUI_ITEM(struct xfs_log_item *lip)
 {
@@ -127,29 +127,6 @@ xfs_cui_item_release(
 	xfs_cui_release(CUI_ITEM(lip));
 }
 
-/* Recover the CUI if necessary. */
-STATIC int
-xfs_cui_item_recover(
-	struct xfs_log_item		*lip,
-	struct xfs_trans		*tp)
-{
-	struct xfs_ail			*ailp = lip->li_ailp;
-	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
-	int				error;
-
-	/*
-	 * Skip CUIs that we've already processed.
-	 */
-	if (test_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags))
-		return 0;
-
-	spin_unlock(&ailp->ail_lock);
-	error = xfs_cui_recover(tp, cuip);
-	spin_lock(&ailp->ail_lock);
-
-	return error;
-}
-
 static const struct xfs_item_ops xfs_cui_item_ops = {
 	.flags		= XFS_ITEM_TYPE_IS_INTENT,
 	.iop_size	= xfs_cui_item_size,
@@ -473,25 +450,26 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
  * We need to update the refcountbt.
  */
 STATIC int
-xfs_cui_recover(
-	struct xfs_trans		*parent_tp,
-	struct xfs_cui_log_item		*cuip)
+xfs_cui_item_recover(
+	struct xfs_log_item		*lip,
+	struct xfs_trans		*parent_tp)
 {
-	int				i;
-	int				error = 0;
-	unsigned int			refc_type;
+	struct xfs_bmbt_irec		irec;
+	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
 	struct xfs_phys_extent		*refc;
-	xfs_fsblock_t			startblock_fsb;
-	bool				op_ok;
 	struct xfs_cud_log_item		*cudp;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
-	enum xfs_refcount_intent_type	type;
+	struct xfs_mount		*mp = parent_tp->t_mountp;
+	xfs_fsblock_t			startblock_fsb;
 	xfs_fsblock_t			new_fsb;
 	xfs_extlen_t			new_len;
-	struct xfs_bmbt_irec		irec;
+	unsigned int			refc_type;
+	bool				op_ok;
 	bool				requeue_only = false;
-	struct xfs_mount		*mp = parent_tp->t_mountp;
+	enum xfs_refcount_intent_type	type;
+	int				i;
+	int				error = 0;
 
 	ASSERT(!test_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags));
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 69be891e85e8..cee5c6155032 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -24,7 +24,7 @@
 kmem_zone_t	*xfs_rui_zone;
 kmem_zone_t	*xfs_rud_zone;
 
-STATIC int xfs_rui_recover(struct xfs_mount *mp, struct xfs_rui_log_item *ruip);
+STATIC int xfs_rui_item_recover(struct xfs_log_item *lip, struct xfs_trans *tp);
 
 static inline struct xfs_rui_log_item *RUI_ITEM(struct xfs_log_item *lip)
 {
@@ -126,29 +126,6 @@ xfs_rui_item_release(
 	xfs_rui_release(RUI_ITEM(lip));
 }
 
-/* Recover the RUI if necessary. */
-STATIC int
-xfs_rui_item_recover(
-	struct xfs_log_item		*lip,
-	struct xfs_trans		*tp)
-{
-	struct xfs_ail			*ailp = lip->li_ailp;
-	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
-	int				error;
-
-	/*
-	 * Skip RUIs that we've already processed.
-	 */
-	if (test_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags))
-		return 0;
-
-	spin_unlock(&ailp->ail_lock);
-	error = xfs_rui_recover(tp->t_mountp, ruip);
-	spin_lock(&ailp->ail_lock);
-
-	return error;
-}
-
 static const struct xfs_item_ops xfs_rui_item_ops = {
 	.flags		= XFS_ITEM_TYPE_IS_INTENT,
 	.iop_size	= xfs_rui_item_size,
@@ -517,21 +494,23 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
  * We need to update the rmapbt.
  */
 STATIC int
-xfs_rui_recover(
-	struct xfs_mount		*mp,
-	struct xfs_rui_log_item		*ruip)
+xfs_rui_item_recover(
+	struct xfs_log_item		*lip,
+	struct xfs_trans		*parent_tp)
 {
-	int				i;
-	int				error = 0;
+	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
 	struct xfs_map_extent		*rmap;
-	xfs_fsblock_t			startblock_fsb;
-	bool				op_ok;
 	struct xfs_rud_log_item		*rudp;
-	enum xfs_rmap_intent_type	type;
-	int				whichfork;
-	xfs_exntst_t			state;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
+	struct xfs_mount		*mp = parent_tp->t_mountp;
+	xfs_fsblock_t			startblock_fsb;
+	enum xfs_rmap_intent_type	type;
+	xfs_exntst_t			state;
+	bool				op_ok;
+	int				i;
+	int				whichfork;
+	int				error = 0;
 
 	ASSERT(!test_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags));
 

