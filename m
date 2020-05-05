Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D87FC47258
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30B1D20705
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:13:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FOZ0m6C2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgEEBNp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:13:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51012 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbgEEBNp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:13:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04513bZw143255
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+glJQrzAEx9J9KpXJ+KlhQhJuJ9BjZpP8XD9H44I/7I=;
 b=FOZ0m6C2Uk1bf1nJ+KmVcyoxY/ZwfnXpAj8YnIpbbq0KGPaKhQoujq691l2EN6BAikMA
 Ia2Ot6tbQ6ffzMz5axBp8+dNBeWbaHL/bZZ1KMX5np98orcP2xpRyAtZUtaqIICGiIYz
 4DLoix0NQW9qvWqPGDdHgGhnmehS21wHHGKLguuzJ71zEQ+ZX9LoeDKW3lXjUXOoEwNj
 6whfOiidDCjEDufKkIypkkrDLcBBkO1EbiOvkbHE7VDoYtBLzbO9xX7TO8aINsWjSZFu
 +7ocGuICsIKtIaObL2XbxRgFEM2cdQJh6UoSDYyh3pmrY5wOhyg/JSj67lSEkhnuWL4Q bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09r237e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:13:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04515S9g145423
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjncm3av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:13:41 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451Dewh017009
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:13:39 -0700
Subject: [PATCH 1/3] xfs: proper replay of deferred ops queued during log
 recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:13:39 -0700
Message-ID: <158864121900.184729.15751838615488460497.stgit@magnolia>
In-Reply-To: <158864121286.184729.5959003885146573075.stgit@magnolia>
References: <158864121286.184729.5959003885146573075.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=3
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
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
 fs/xfs/libxfs/xfs_defer.c       |   57 ++++++++++++++++++
 fs/xfs/libxfs/xfs_defer.h       |   21 +++++++
 fs/xfs/libxfs/xfs_log_recover.h |    4 +
 fs/xfs/xfs_bmap_item.c          |   16 +----
 fs/xfs/xfs_extfree_item.c       |    7 +-
 fs/xfs/xfs_log_recover.c        |  122 +++++++++++++++++++++++++--------------
 fs/xfs/xfs_refcount_item.c      |   16 +----
 fs/xfs/xfs_rmap_item.c          |    7 +-
 fs/xfs/xfs_trans.h              |    4 +
 9 files changed, 178 insertions(+), 76 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 1172fbf072d8..bbbd0141d4a6 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -544,3 +544,60 @@ xfs_defer_move(
 
 	xfs_defer_reset(stp);
 }
+
+/*
+ * Freeze a chain of deferred ops that are attached to a transaction.  The
+ * entire deferred ops state is transferred to the freezer, and each dfops
+ * item will be prepared for freezing.
+ */
+int
+xfs_defer_freeze(
+	struct xfs_trans		*tp,
+	struct xfs_defer_freezer	**dffp)
+{
+	struct xfs_defer_freezer	*dff;
+
+	*dffp = NULL;
+	if (list_empty(&tp->t_dfops))
+		return 0;
+
+	dff = kmem_zalloc(sizeof(*dff), KM_NOFS);
+	if (!dff)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&dff->dff_list);
+	INIT_LIST_HEAD(&dff->dff_dfops);
+
+	/* Move all the dfops items to the freezer. */
+	list_splice_init(&tp->t_dfops, &dff->dff_dfops);
+	dff->dff_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
+	xfs_defer_reset(tp);
+
+	*dffp = dff;
+	return 0;
+}
+
+/* Thaw a chain of deferred ops that are attached to a transaction. */
+int
+xfs_defer_thaw(
+	struct xfs_defer_freezer	*dff,
+	struct xfs_trans		*tp)
+{
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+
+	/* Add the dfops items to the transaction. */
+	list_splice_init(&dff->dff_dfops, &tp->t_dfops);
+	tp->t_flags |= dff->dff_tpflags;
+
+	return 0;
+}
+
+/* Release a deferred op freezer and all resources associated with it. */
+void
+xfs_defer_freeezer_finish(
+	struct xfs_mount		*mp,
+	struct xfs_defer_freezer	*dff)
+{
+	xfs_defer_cancel_list(mp, &dff->dff_dfops);
+	kmem_free(dff);
+}
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 3bf7c2c4d851..4789bf53dd96 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -8,6 +8,7 @@
 
 struct xfs_btree_cur;
 struct xfs_defer_op_type;
+struct xfs_defer_freezer;
 
 /*
  * Header for deferred operation list.
@@ -63,4 +64,24 @@ extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 
+/*
+ * Deferred operation freezer.  This structure enables a dfops user to detach
+ * the chain of deferred operations from a transaction so that they can be
+ * run later.
+ */
+struct xfs_defer_freezer {
+	/* List of other freezer heads. */
+	struct list_head	dff_list;
+
+	/* Deferred ops state saved from the transaction. */
+	struct list_head	dff_dfops;
+	unsigned int		dff_tpflags;
+};
+
+/* Functions to freeze a chain of deferred operations for later. */
+int xfs_defer_freeze(struct xfs_trans *tp, struct xfs_defer_freezer **dffp);
+int xfs_defer_thaw(struct xfs_defer_freezer *dff, struct xfs_trans *tp);
+void xfs_defer_freeezer_finish(struct xfs_mount *mp,
+		struct xfs_defer_freezer *dff);
+
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index d8c0eae87179..6092a02b2d2a 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -6,6 +6,8 @@
 #ifndef	__XFS_LOG_RECOVER_H__
 #define __XFS_LOG_RECOVER_H__
 
+struct xfs_defer_freezer;
+
 /*
  * Each log item type (XFS_LI_*) gets its own xlog_recover_item_ops to
  * define how recovery should work for that type of log item.
@@ -130,5 +132,7 @@ void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id);
 void xlog_recover_insert_ail(struct xlog *log, struct xfs_log_item *lip,
 		xfs_lsn_t lsn);
+int xlog_recover_trans_commit(struct xfs_trans *tp,
+		struct xfs_defer_freezer **dffp);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 0793c317defb..c733bdeeeb9b 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -423,13 +423,13 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 STATIC int
 xfs_bui_item_recover(
 	struct xfs_log_item		*lip,
-	struct xfs_trans		*parent_tp)
+	struct xfs_defer_freezer	**dffp)
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
@@ -485,12 +485,7 @@ xfs_bui_item_recover(
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
@@ -534,15 +529,12 @@ xfs_bui_item_recover(
 		xfs_bmap_unmap_extent(tp, ip, &irec);
 	}
 
-	xfs_defer_move(parent_tp, tp);
-	error = xfs_trans_commit(tp);
+	error = xlog_recover_trans_commit(tp, dffp);
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
index b92678bede24..262acddd2e1b 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -583,10 +583,10 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 STATIC int
 xfs_efi_item_recover(
 	struct xfs_log_item		*lip,
-	struct xfs_trans		*parent_tp)
+	struct xfs_defer_freezer	**dffp)
 {
 	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
-	struct xfs_mount		*mp = parent_tp->t_mountp;
+	struct xfs_mount		*mp = lip->li_mountp;
 	struct xfs_efd_log_item		*efdp;
 	struct xfs_trans		*tp;
 	struct xfs_extent		*extp;
@@ -631,8 +631,7 @@ xfs_efi_item_recover(
 
 	}
 
-	error = xfs_trans_commit(tp);
-	return error;
+	return xlog_recover_trans_commit(tp, dffp);
 
 abort_error:
 	xfs_trans_cancel(tp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a9cc546535e0..908bfb284a9a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1809,6 +1809,26 @@ xlog_recover_insert_ail(
 	xfs_trans_ail_update(log->l_ailp, lip, lsn);
 }
 
+/*
+ * Freeze any deferred ops and commit the transaction.  This is the last step
+ * needed to finish a log intent item that we recovered from the log.
+ */
+int
+xlog_recover_trans_commit(
+	struct xfs_trans		*tp,
+	struct xfs_defer_freezer	**dffp)
+{
+	int				error;
+
+	error = xfs_defer_freeze(tp, dffp);
+	if (error) {
+		xfs_trans_cancel(tp);
+		return error;
+	}
+
+	return xfs_trans_commit(tp);
+}
+
 /******************************************************************************
  *
  *		Log recover routines
@@ -2495,35 +2515,59 @@ xlog_recover_process_data(
 /* Take all the collected deferred ops and finish them in order. */
 static int
 xlog_finish_defer_ops(
-	struct xfs_trans	*parent_tp)
+	struct xfs_mount	*mp,
+	struct list_head	*dfops_freezers)
 {
-	struct xfs_mount	*mp = parent_tp->t_mountp;
+	struct xfs_defer_freezer *dff, *next;
 	struct xfs_trans	*tp;
 	int64_t			freeblks;
 	uint			resblks;
-	int			error;
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
+	list_for_each_entry_safe(dff, next, dfops_freezers, dff_list) {
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
+		resblks = min_t(int64_t, UINT_MAX, freeblks);
+		resblks = (resblks * 15) >> 4;
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
+				0, XFS_TRANS_RESERVE, &tp);
+		if (error)
+			break;
+
+		/* transfer all collected dfops to this transaction */
+		list_del_init(&dff->dff_list);
+		error = xfs_defer_thaw(dff, tp);
+		if (error) {
+			xfs_trans_cancel(tp);
+			xfs_defer_freeezer_finish(mp, dff);
+			break;
+		}
+
+		error = xfs_trans_commit(tp);
+		xfs_defer_freeezer_finish(mp, dff);
+		if (error)
+			break;
+	}
+
+	/* Kill any remaining freezers. */
+	list_for_each_entry_safe(dff, next, dfops_freezers, dff_list) {
+		list_del_init(&dff->dff_list);
+		xfs_defer_freeezer_finish(mp, dff);
+	}
+
+	return error;
 }
 
 /* Is this log item a deferred action intent? */
@@ -2553,8 +2597,9 @@ STATIC int
 xlog_recover_process_intents(
 	struct xlog		*log)
 {
-	struct xfs_trans	*parent_tp;
+	LIST_HEAD(dfops_freezers);
 	struct xfs_ail_cursor	cur;
+	struct xfs_defer_freezer *freezer = NULL;
 	struct xfs_log_item	*lip;
 	struct xfs_ail		*ailp;
 	int			error = 0;
@@ -2562,19 +2607,6 @@ xlog_recover_process_intents(
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
@@ -2603,27 +2635,31 @@ xlog_recover_process_intents(
 
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
 		if (error)
 			goto out;
+		if (freezer) {
+			list_add_tail(&freezer->dff_list, &dfops_freezers);
+			freezer = NULL;
+		}
+
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 	}
 out:
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
-	if (!error)
-		error = xlog_finish_defer_ops(parent_tp);
-	xfs_trans_cancel(parent_tp);
+	if (error)
+		return error;
 
-	return error;
+	return xlog_finish_defer_ops(log->l_mp, &dfops_freezers);
 }
 
 /*
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index e6d355a09bb3..dcdb975dbb86 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -423,7 +423,7 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 STATIC int
 xfs_cui_item_recover(
 	struct xfs_log_item		*lip,
-	struct xfs_trans		*parent_tp)
+	struct xfs_defer_freezer	**dffp)
 {
 	struct xfs_bmbt_irec		irec;
 	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
@@ -431,7 +431,7 @@ xfs_cui_item_recover(
 	struct xfs_cud_log_item		*cudp;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
-	struct xfs_mount		*mp = parent_tp->t_mountp;
+	struct xfs_mount		*mp = lip->li_mountp;
 	xfs_fsblock_t			startblock_fsb;
 	xfs_fsblock_t			new_fsb;
 	xfs_extlen_t			new_len;
@@ -492,12 +492,7 @@ xfs_cui_item_recover(
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
@@ -554,13 +549,10 @@ xfs_cui_item_recover(
 	}
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	xfs_defer_move(parent_tp, tp);
-	error = xfs_trans_commit(tp);
-	return error;
+	return xlog_recover_trans_commit(tp, dffp);
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	xfs_defer_move(parent_tp, tp);
 	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 4a5e2b1cf75a..c751487740df 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -466,14 +466,14 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 STATIC int
 xfs_rui_item_recover(
 	struct xfs_log_item		*lip,
-	struct xfs_trans		*parent_tp)
+	struct xfs_defer_freezer	**dffp)
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
@@ -572,8 +572,7 @@ xfs_rui_item_recover(
 	}
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
-	error = xfs_trans_commit(tp);
-	return error;
+	return xlog_recover_trans_commit(tp, dffp);
 
 abort_error:
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 8308bf6d7e40..48db4510b9d9 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -26,6 +26,7 @@ struct xfs_cui_log_item;
 struct xfs_cud_log_item;
 struct xfs_bui_log_item;
 struct xfs_bud_log_item;
+struct xfs_defer_freezer;
 
 struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
@@ -79,7 +80,8 @@ struct xfs_item_ops {
 	void (*iop_release)(struct xfs_log_item *);
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
 	void (*iop_error)(struct xfs_log_item *, xfs_buf_t *);
-	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
+	int (*iop_recover)(struct xfs_log_item *lip,
+			   struct xfs_defer_freezer **dffp);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
 };
 

