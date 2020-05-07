Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A8AEC38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F68820735
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:04:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YeUxwwip"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgEGBEP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:04:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35376 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgEGBEO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:04:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470vnD0100942;
        Thu, 7 May 2020 01:04:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=o8q6U2yFvhy6xasgDgyY+tWNG0588i/o/LTKF5H7T5w=;
 b=YeUxwwipKTut2wck3BS3nlTtKHkFvx4VjMODNKiCuFfa6eqh7VtlsGLYOuhDozQkVp0z
 F0LLhYzv8P02jedcXZ6AiJQ+YCI3VWJ7n9FrnrXvaPgBKVVt8wzsW7Uq4PpXXTQJLg2R
 +RQiz8wuzy1Zhaw8873dz/urEKdlqFHzww11iN4cyVc/NaSP2Ubdi3sIYI88b39FKh1E
 E+jy4PSEeKQFmKwkC6oSWMua0vIAoYFYyyFm7TWXcT6+LuEk1+eGiGW4BfpJ0Q9d8EvB
 eJB0bUOGXNH/AST47IKtd653LqzW6zytRFfmlYzTJlsDTvtL2P4s8qN+3zYIlSxAObJz Mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09rdgtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:04:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470vW9h150820;
        Thu, 7 May 2020 01:04:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30sjnmbp1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:04:08 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 047148sl028821;
        Thu, 7 May 2020 01:04:08 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:04:07 -0700
Subject: [PATCH 22/25] xfs: refactor intent item iop_recover calls
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:04:02 -0700
Message-ID: <158881344212.189971.8760000893335699128.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=3
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've made the recovered item tests all the same, we can hoist
the test and the ail locking code to the ->iop_recover caller and call
the recovery function directly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_item.c     |   48 ++++++++++++--------------------------------
 fs/xfs/xfs_extfree_item.c  |   44 ++++++++++------------------------------
 fs/xfs/xfs_log_recover.c   |    8 ++++++-
 fs/xfs/xfs_refcount_item.c |   46 +++++++++++-------------------------------
 fs/xfs/xfs_rmap_item.c     |   45 +++++++++++------------------------------
 5 files changed, 54 insertions(+), 137 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 8a5ac8cfd5f2..3b8ca4409aa5 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -421,25 +421,26 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
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
 
@@ -555,29 +556,6 @@ xfs_bui_recover(
 	return error;
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
 STATIC bool
 xfs_bui_item_match(
 	struct xfs_log_item	*lip,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index ffa15bcaea33..a8ee9aaef50d 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -581,16 +581,18 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
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
 
@@ -641,30 +643,6 @@ xfs_efi_recover(
 	return error;
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
 STATIC bool
 xfs_efi_item_match(
 	struct xfs_log_item	*lip,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8a397566b7bb..60e98e48d04b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2643,7 +2643,7 @@ xlog_recover_process_intents(
 	struct xfs_ail_cursor	cur;
 	struct xfs_log_item	*lip;
 	struct xfs_ail		*ailp;
-	int			error;
+	int			error = 0;
 #if defined(DEBUG) || defined(XFS_WARN)
 	xfs_lsn_t		last_lsn;
 #endif
@@ -2693,7 +2693,11 @@ xlog_recover_process_intents(
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
index c7d584b99508..b256eafd30d3 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -421,25 +421,26 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
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
 
@@ -568,29 +569,6 @@ xfs_cui_recover(
 	return error;
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
 STATIC bool
 xfs_cui_item_match(
 	struct xfs_log_item	*lip,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 45cc7bfe82b4..d190060729a3 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -464,21 +464,23 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
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
 
@@ -583,29 +585,6 @@ xfs_rui_recover(
 	return error;
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
 STATIC bool
 xfs_rui_item_match(
 	struct xfs_log_item	*lip,

