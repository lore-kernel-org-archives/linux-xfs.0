Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A70C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F5FB208E4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:31:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rwryVQw2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbgIQDbT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 23:31:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51438 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgIQDbP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:31:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3Pw9J116628;
        Thu, 17 Sep 2020 03:31:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qD5L14VnaaPNDvCw3bwSFyK9q/xHFQ3aXB/jY/Eazos=;
 b=rwryVQw22V6HbZdjXh3AAv7zJ58WqtWxd2X1Ob7zXaEslUS+UrDVDyolO1VB57xehSdR
 3XZ5puWs4kwFSedQnGUwEBF/Uut5bUsYbkGlU/CL0mdr36tJzvkXbK5H7C765EtQtlzX
 P5AlZs9z4rzCgTFDquL9tLNqRjguf+yf2bBKLDrsxXzk/M5dbNKEFg5GaJCepfxNxJ6e
 9B4kGg9uDmcTx6gmmQEPMpInWDsexGrKNP8uG6HjMGm6plqlRfwepWBs6F4EQbLhUiAP
 b1ayqOF3MV52WL4pn1jGiAI3K2VDaDgRMabh1plvLuDrZMPV6GpxeKoN5bUNU2gjEl3B bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33j91dr5nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 03:31:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3Q2dC060920;
        Thu, 17 Sep 2020 03:29:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33khpmd1cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 03:29:08 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H3T8M0006937;
        Thu, 17 Sep 2020 03:29:08 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:29:08 +0000
Subject: [PATCH 1/3] xfs: proper replay of deferred ops queued during log
 recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 16 Sep 2020 20:29:07 -0700
Message-ID: <160031334683.3624461.7162765986332930241.stgit@magnolia>
In-Reply-To: <160031334050.3624461.17900718410309670962.stgit@magnolia>
References: <160031334050.3624461.17900718410309670962.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=3
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=3 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we replay unfinished intent items that have been recovered from the
log, it's possible that the replay will cause the creation of more
deferred work items.  As outlined in commit 509955823cc9c ("xfs: log
recovery should replay deferred ops in order"), later work items have an
implicit ordering dependency on earlier work items.  Therefore, recovery
must replay the items (both recovered and created) in the same order
that they would have been during normal operation.

For log recovery, we enforce this ordering by using an empty transaction
to collect deferred ops that get created in the process of recovering a
log intent item to prevent them from being committed before the rest of
the recovered intent items.  After we finish committing all the
recovered log items, we allocate a transaction with an enormous block
reservation, splice our huge list of created deferred ops into that
transaction, and commit it, thereby finishing all those ops.

This is /really/ hokey -- it's the one place in XFS where we allow
nested transactions; the splicing of the defer ops list is is inelegant
and has to be done twice per recovery function; and the broken way we
handle inode pointers and block reservations cause subtle use-after-free
and allocator problems that will be fixed by this patch and the two
patches after it.

Therefore, replace the hokey empty transaction with a structure designed
to capture each chain of deferred ops that are created as part of
recovering a single unfinished log intent.  Finally, refactor the loop
that replays those chains to do so using one transaction per chain.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c       |   59 +++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h       |   20 ++++++
 fs/xfs/libxfs/xfs_log_recover.h |    4 +
 fs/xfs/xfs_bmap_item.c          |   16 +----
 fs/xfs/xfs_extfree_item.c       |    7 +-
 fs/xfs/xfs_log_recover.c        |  121 ++++++++++++++++++++++++---------------
 fs/xfs/xfs_refcount_item.c      |   16 +----
 fs/xfs/xfs_rmap_item.c          |    7 +-
 fs/xfs/xfs_trans.h              |    4 +
 9 files changed, 168 insertions(+), 86 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 29e9762f3b77..e4a6928c8566 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -563,14 +563,59 @@ xfs_defer_move(
  *
  * Create and log intent items for all the work that we're capturing so that we
  * can be assured that the items will get replayed if the system goes down
- * before log recovery gets a chance to finish the work it put off.  Then we
- * move the chain from stp to dtp.
+ * before log recovery gets a chance to finish the work it put off.  The entire
+ * deferred ops state is transferred to the capture structure and the
+ * transaction is committed.
+ *
+ * Note that the capture state is passed up to the caller and must be freed
+ * even if the transaction commit returns error.
  */
-void
+int
 xfs_defer_capture(
-	struct xfs_trans	*dtp,
-	struct xfs_trans	*stp)
+	struct xfs_trans		*tp,
+	struct xfs_defer_capture	**dfcp)
 {
-	xfs_defer_create_intents(stp);
-	xfs_defer_move(dtp, stp);
+	struct xfs_defer_capture	*dfc = NULL;
+
+	if (!list_empty(&tp->t_dfops)) {
+		dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
+
+		xfs_defer_create_intents(tp);
+
+		INIT_LIST_HEAD(&dfc->dfc_list);
+		INIT_LIST_HEAD(&dfc->dfc_dfops);
+
+		/* Move the dfops chain and transaction state to the freezer. */
+		list_splice_init(&tp->t_dfops, &dfc->dfc_dfops);
+		dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
+		xfs_defer_reset(tp);
+	}
+
+	*dfcp = dfc;
+	return xfs_trans_commit(tp);
+}
+
+/* Attach a chain of captured deferred ops to a new transaction. */
+void
+xfs_defer_continue(
+	struct xfs_defer_capture	*dfc,
+	struct xfs_trans		*tp)
+{
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
+
+	/* Move captured dfops chain and state to the transaction. */
+	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
+	tp->t_flags |= dfc->dfc_tpflags;
+	dfc->dfc_tpflags = 0;
+}
+
+/* Release all resources that we used to capture deferred ops. */
+void
+xfs_defer_capture_free(
+	struct xfs_mount		*mp,
+	struct xfs_defer_capture	*dfc)
+{
+	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
+	kmem_free(dfc);
 }
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 3164199162b6..d61ef0a750ab 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -8,6 +8,7 @@
 
 struct xfs_btree_cur;
 struct xfs_defer_op_type;
+struct xfs_defer_capture;
 
 /*
  * Header for deferred operation list.
@@ -63,10 +64,27 @@ extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 
+/*
+ * Deferred operation freezer.  This structure enables a dfops user to detach
+ * the chain of deferred operations from a transaction so that they can be
+ * continued later.
+ */
+struct xfs_defer_capture {
+	/* List of other freezer heads. */
+	struct list_head	dfc_list;
+
+	/* Deferred ops state saved from the transaction. */
+	struct list_head	dfc_dfops;
+	unsigned int		dfc_tpflags;
+};
+
 /*
  * Functions to capture a chain of deferred operations and continue them later.
  * This doesn't normally happen except log recovery.
  */
-void xfs_defer_capture(struct xfs_trans *dtp, struct xfs_trans *stp);
+int xfs_defer_capture(struct xfs_trans *tp, struct xfs_defer_capture **dfcp);
+void xfs_defer_continue(struct xfs_defer_capture *dfc, struct xfs_trans *tp);
+void xfs_defer_capture_free(struct xfs_mount *mp,
+		struct xfs_defer_capture *dfc);
 
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 641132d0e39d..c3563c5c033c 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -6,6 +6,8 @@
 #ifndef	__XFS_LOG_RECOVER_H__
 #define __XFS_LOG_RECOVER_H__
 
+struct xfs_defer_capture;
+
 /*
  * Each log item type (XFS_LI_*) gets its own xlog_recover_item_ops to
  * define how recovery should work for that type of log item.
@@ -125,5 +127,7 @@ void xlog_recover_iodone(struct xfs_buf *bp);
 
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id);
+int xlog_recover_trans_commit(struct xfs_trans *tp,
+		struct xfs_defer_capture **dfcp);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 598f713831c9..0a0904a7650a 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -424,13 +424,13 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 STATIC int
 xfs_bui_item_recover(
 	struct xfs_log_item		*lip,
-	struct xfs_trans		*parent_tp)
+	struct xfs_defer_capture	**dfcp)
 {
 	struct xfs_bmbt_irec		irec;
 	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
-	struct xfs_mount		*mp = parent_tp->t_mountp;
+	struct xfs_mount		*mp = lip->li_mountp;
 	struct xfs_map_extent		*bmap;
 	struct xfs_bud_log_item		*budp;
 	xfs_fsblock_t			startblock_fsb;
@@ -486,12 +486,7 @@ xfs_bui_item_recover(
 			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
 	if (error)
 		return error;
-	/*
-	 * Recovery stashes all deferred ops during intent processing and
-	 * finishes them on completion. Transfer current dfops state to this
-	 * transaction and transfer the result back before we return.
-	 */
-	xfs_defer_move(tp, parent_tp);
+
 	budp = xfs_trans_get_bud(tp, buip);
 
 	/* Grab the inode. */
@@ -539,15 +534,12 @@ xfs_bui_item_recover(
 		xfs_bmap_unmap_extent(tp, ip, &irec);
 	}
 
-	xfs_defer_capture(parent_tp, tp);
-	error = xfs_trans_commit(tp);
+	error = xlog_recover_trans_commit(tp, dfcp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
-
 	return error;
 
 err_inode:
-	xfs_defer_move(parent_tp, tp);
 	xfs_trans_cancel(tp);
 	if (ip) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6cb8cd11072a..f544ec007c12 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -585,10 +585,10 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 STATIC int
 xfs_efi_item_recover(
 	struct xfs_log_item		*lip,
-	struct xfs_trans		*parent_tp)
+	struct xfs_defer_capture	**dfcp)
 {
 	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
-	struct xfs_mount		*mp = parent_tp->t_mountp;
+	struct xfs_mount		*mp = lip->li_mountp;
 	struct xfs_efd_log_item		*efdp;
 	struct xfs_trans		*tp;
 	struct xfs_extent		*extp;
@@ -633,8 +633,7 @@ xfs_efi_item_recover(
 
 	}
 
-	error = xfs_trans_commit(tp);
-	return error;
+	return xlog_recover_trans_commit(tp, dfcp);
 
 abort_error:
 	xfs_trans_cancel(tp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e2ec91b2d0f4..0c90c1326860 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1791,6 +1791,18 @@ xlog_recover_release_intent(
 	spin_unlock(&ailp->ail_lock);
 }
 
+/*
+ * Freeze any deferred ops and commit the transaction.  This is the last step
+ * needed to finish a log intent item that we recovered from the log.
+ */
+int
+xlog_recover_trans_commit(
+	struct xfs_trans		*tp,
+	struct xfs_defer_capture	**dfcp)
+{
+	return xfs_defer_capture(tp, dfcp);
+}
+
 /******************************************************************************
  *
  *		Log recover routines
@@ -2467,38 +2479,64 @@ xlog_recover_process_data(
 	return 0;
 }
 
+static void
+xlog_cancel_defer_ops(
+	struct xfs_mount	*mp,
+	struct list_head	*dfops_freezers)
+{
+	struct xfs_defer_capture *dfc, *next;
+
+	list_for_each_entry_safe(dfc, next, dfops_freezers, dfc_list) {
+		list_del_init(&dfc->dfc_list);
+		xfs_defer_capture_free(mp, dfc);
+	}
+}
+
 /* Take all the collected deferred ops and finish them in order. */
 static int
 xlog_finish_defer_ops(
-	struct xfs_trans	*parent_tp)
+	struct xfs_mount	*mp,
+	struct list_head	*dfops_freezers)
 {
-	struct xfs_mount	*mp = parent_tp->t_mountp;
+	struct xfs_defer_capture *dfc, *next;
 	struct xfs_trans	*tp;
 	int64_t			freeblks;
-	uint			resblks;
-	int			error;
+	uint64_t		resblks;
+	int			error = 0;
 
-	/*
-	 * We're finishing the defer_ops that accumulated as a result of
-	 * recovering unfinished intent items during log recovery.  We
-	 * reserve an itruncate transaction because it is the largest
-	 * permanent transaction type.  Since we're the only user of the fs
-	 * right now, take 93% (15/16) of the available free blocks.  Use
-	 * weird math to avoid a 64-bit division.
-	 */
-	freeblks = percpu_counter_sum(&mp->m_fdblocks);
-	if (freeblks <= 0)
-		return -ENOSPC;
-	resblks = min_t(int64_t, UINT_MAX, freeblks);
-	resblks = (resblks * 15) >> 4;
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
-			0, XFS_TRANS_RESERVE, &tp);
-	if (error)
-		return error;
-	/* transfer all collected dfops to this transaction */
-	xfs_defer_move(tp, parent_tp);
+	list_for_each_entry_safe(dfc, next, dfops_freezers, dfc_list) {
+		/*
+		 * We're finishing the defer_ops that accumulated as a result
+		 * of recovering unfinished intent items during log recovery.
+		 * We reserve an itruncate transaction because it is the
+		 * largest permanent transaction type.  Since we're the only
+		 * user of the fs right now, take 93% (15/16) of the available
+		 * free blocks.  Use weird math to avoid a 64-bit division.
+		 */
+		freeblks = percpu_counter_sum(&mp->m_fdblocks);
+		if (freeblks <= 0) {
+			error = -ENOSPC;
+			break;
+		}
 
-	return xfs_trans_commit(tp);
+		resblks = min_t(uint64_t, UINT_MAX, freeblks);
+		resblks = (resblks * 15) >> 4;
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
+				0, XFS_TRANS_RESERVE, &tp);
+		if (error)
+			break;
+
+		/* transfer all collected dfops to this transaction */
+		list_del_init(&dfc->dfc_list);
+		xfs_defer_continue(dfc, tp);
+
+		error = xfs_trans_commit(tp);
+		xfs_defer_capture_free(mp, dfc);
+		if (error)
+			break;
+	}
+
+	return error;
 }
 
 /* Is this log item a deferred action intent? */
@@ -2528,28 +2566,16 @@ STATIC int
 xlog_recover_process_intents(
 	struct xlog		*log)
 {
-	struct xfs_trans	*parent_tp;
+	LIST_HEAD(dfops_freezers);
 	struct xfs_ail_cursor	cur;
+	struct xfs_defer_capture *freezer = NULL;
 	struct xfs_log_item	*lip;
 	struct xfs_ail		*ailp;
-	int			error;
+	int			error = 0;
 #if defined(DEBUG) || defined(XFS_WARN)
 	xfs_lsn_t		last_lsn;
 #endif
 
-	/*
-	 * The intent recovery handlers commit transactions to complete recovery
-	 * for individual intents, but any new deferred operations that are
-	 * queued during that process are held off until the very end. The
-	 * purpose of this transaction is to serve as a container for deferred
-	 * operations. Each intent recovery handler must transfer dfops here
-	 * before its local transaction commits, and we'll finish the entire
-	 * list below.
-	 */
-	error = xfs_trans_alloc_empty(log->l_mp, &parent_tp);
-	if (error)
-		return error;
-
 	ailp = log->l_ailp;
 	spin_lock(&ailp->ail_lock);
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
@@ -2578,26 +2604,31 @@ xlog_recover_process_intents(
 
 		/*
 		 * NOTE: If your intent processing routine can create more
-		 * deferred ops, you /must/ attach them to the transaction in
+		 * deferred ops, you /must/ attach them to the freezer in
 		 * this routine or else those subsequent intents will get
 		 * replayed in the wrong order!
 		 */
 		if (!test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags)) {
 			spin_unlock(&ailp->ail_lock);
-			error = lip->li_ops->iop_recover(lip, parent_tp);
+			error = lip->li_ops->iop_recover(lip, &freezer);
 			spin_lock(&ailp->ail_lock);
 		}
+		if (freezer) {
+			list_add_tail(&freezer->dfc_list, &dfops_freezers);
+			freezer = NULL;
+		}
 		if (error)
-			goto out;
+			break;
+
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 	}
-out:
+
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
 	if (!error)
-		error = xlog_finish_defer_ops(parent_tp);
-	xfs_trans_cancel(parent_tp);
+		error = xlog_finish_defer_ops(log->l_mp, &dfops_freezers);
 
+	xlog_cancel_defer_ops(log->l_mp, &dfops_freezers);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 492d80a0b406..30e579b5857d 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -424,7 +424,7 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 STATIC int
 xfs_cui_item_recover(
 	struct xfs_log_item		*lip,
-	struct xfs_trans		*parent_tp)
+	struct xfs_defer_capture	**dfcp)
 {
 	struct xfs_bmbt_irec		irec;
 	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
@@ -432,7 +432,7 @@ xfs_cui_item_recover(
 	struct xfs_cud_log_item		*cudp;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
-	struct xfs_mount		*mp = parent_tp->t_mountp;
+	struct xfs_mount		*mp = lip->li_mountp;
 	xfs_fsblock_t			startblock_fsb;
 	xfs_fsblock_t			new_fsb;
 	xfs_extlen_t			new_len;
@@ -493,12 +493,7 @@ xfs_cui_item_recover(
 			mp->m_refc_maxlevels * 2, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
-	/*
-	 * Recovery stashes all deferred ops during intent processing and
-	 * finishes them on completion. Transfer current dfops state to this
-	 * transaction and transfer the result back before we return.
-	 */
-	xfs_defer_move(tp, parent_tp);
+
 	cudp = xfs_trans_get_cud(tp, cuip);
 
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
@@ -555,13 +550,10 @@ xfs_cui_item_recover(
 	}
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	xfs_defer_capture(parent_tp, tp);
-	error = xfs_trans_commit(tp);
-	return error;
+	return xlog_recover_trans_commit(tp, dfcp);
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	xfs_defer_move(parent_tp, tp);
 	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index dc5b0753cd51..34dd6b02bdc8 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -467,14 +467,14 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 STATIC int
 xfs_rui_item_recover(
 	struct xfs_log_item		*lip,
-	struct xfs_trans		*parent_tp)
+	struct xfs_defer_capture	**dfcp)
 {
 	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
 	struct xfs_map_extent		*rmap;
 	struct xfs_rud_log_item		*rudp;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
-	struct xfs_mount		*mp = parent_tp->t_mountp;
+	struct xfs_mount		*mp = lip->li_mountp;
 	xfs_fsblock_t			startblock_fsb;
 	enum xfs_rmap_intent_type	type;
 	xfs_exntst_t			state;
@@ -573,8 +573,7 @@ xfs_rui_item_recover(
 	}
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
-	error = xfs_trans_commit(tp);
-	return error;
+	return xlog_recover_trans_commit(tp, dfcp);
 
 abort_error:
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index b752501818d2..c88240961aa1 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -26,6 +26,7 @@ struct xfs_cui_log_item;
 struct xfs_cud_log_item;
 struct xfs_bui_log_item;
 struct xfs_bud_log_item;
+struct xfs_defer_capture;
 
 struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
@@ -74,7 +75,8 @@ struct xfs_item_ops {
 	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
 	void (*iop_release)(struct xfs_log_item *);
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
-	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
+	int (*iop_recover)(struct xfs_log_item *lip,
+			   struct xfs_defer_capture **dfcp);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
 };
 

