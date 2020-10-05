Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1417C4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58BB220B80
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:20:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="krrXp7Ai"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgJESU1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 14:20:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51646 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgJESU0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 14:20:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095I9RIu101502;
        Mon, 5 Oct 2020 18:20:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0LIu20fh1tLWjh9+QQdHdrZL4lMRRqKa/6CmtUU1ubw=;
 b=krrXp7AikPp/WeEQ9/EauHPadZAcWj82HdZIvnQAAMQtGnbmuaZE2W9TqMs6tk4Q9x7k
 CaMfKYwb3XcNBLVkfxicpO9saAN2oaHfBBIZ1bY2eZp6EIpABb7GReF9oC5GAHr/jIeQ
 F1yAB9cfliI8+SngUkStXKXVUn7OTUmMaikDOP8mOnwW1cTVbwasBkAv/FvIk9HXP3Kn
 3Ud7hTn6urdty7crZQj6VWjMgK8gkXYSOz57PNrHriSvY3yyTdq4zIcNEMIzLtZTHwa6
 8Uq3gtVU9fiEwmLHogXT0ifcVxPGFm/dQ/aHE1fSz7aiDwzl7QaD4T7cYW5l7iGIAPlp rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33xhxmpys6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 18:20:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IAltI014789;
        Mon, 5 Oct 2020 18:20:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33y36wths0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 18:20:16 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 095IKFgN018660;
        Mon, 5 Oct 2020 18:20:15 GMT
Received: from localhost (/10.159.154.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 11:20:15 -0700
Subject: [PATCH 3/5] xfs: proper replay of deferred ops queued during log
 recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Date:   Mon, 05 Oct 2020 11:20:14 -0700
Message-ID: <160192201410.2568681.7925635094366471660.stgit@magnolia>
In-Reply-To: <160192199449.2568681.679506644186725342.stgit@magnolia>
References: <160192199449.2568681.679506644186725342.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=3 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=3 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c  |   89 ++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h  |   19 +++++++
 fs/xfs/xfs_bmap_item.c     |   16 +-----
 fs/xfs/xfs_extfree_item.c  |    7 +--
 fs/xfs/xfs_log_recover.c   |  121 ++++++++++++++++++++++++++------------------
 fs/xfs/xfs_refcount_item.c |   16 +-----
 fs/xfs/xfs_rmap_item.c     |    7 +--
 fs/xfs/xfs_trans.h         |    3 +
 8 files changed, 187 insertions(+), 91 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 36c103c14bc9..85c371d29e8d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -549,14 +549,89 @@ xfs_defer_move(
  *
  * Create and log intent items for all the work that we're capturing so that we
  * can be assured that the items will get replayed if the system goes down
- * before log recovery gets a chance to finish the work it put off.  Then we
- * move the chain from stp to dtp.
+ * before log recovery gets a chance to finish the work it put off.  The entire
+ * deferred ops state is transferred to the capture structure and the
+ * transaction is then ready for the caller to commit it.  If there are no
+ * intent items to capture, this function returns NULL.
+ */
+static struct xfs_defer_capture *
+xfs_defer_ops_capture(
+	struct xfs_trans		*tp)
+{
+	struct xfs_defer_capture	*dfc;
+
+	if (list_empty(&tp->t_dfops))
+		return NULL;
+
+	/* Create an object to capture the defer ops. */
+	dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
+	INIT_LIST_HEAD(&dfc->dfc_list);
+	INIT_LIST_HEAD(&dfc->dfc_dfops);
+
+	xfs_defer_create_intents(tp);
+
+	/* Move the dfops chain and transaction state to the capture struct. */
+	list_splice_init(&tp->t_dfops, &dfc->dfc_dfops);
+	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
+	tp->t_flags &= ~XFS_TRANS_LOWMODE;
+
+	return dfc;
+}
+
+/* Release all resources that we used to capture deferred ops. */
+void
+xfs_defer_ops_release(
+	struct xfs_mount		*mp,
+	struct xfs_defer_capture	*dfc)
+{
+	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
+	kmem_free(dfc);
+}
+
+/*
+ * Capture any deferred ops and commit the transaction.  This is the last step
+ * needed to finish a log intent item that we recovered from the log.
+ */
+int
+xfs_defer_ops_capture_and_commit(
+	struct xfs_trans		*tp,
+	struct list_head		*capture_list)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_defer_capture	*dfc;
+	int				error;
+
+	/* If we don't capture anything, commit transaction and exit. */
+	dfc = xfs_defer_ops_capture(tp);
+	if (!dfc)
+		return xfs_trans_commit(tp);
+
+	/* Commit the transaction and add the capture structure to the list. */
+	error = xfs_trans_commit(tp);
+	if (error) {
+		xfs_defer_ops_release(mp, dfc);
+		return error;
+	}
+
+	list_add_tail(&dfc->dfc_list, capture_list);
+	return 0;
+}
+
+/*
+ * Attach a chain of captured deferred ops to a new transaction and free the
+ * capture structure.
  */
 void
-xfs_defer_capture(
-	struct xfs_trans	*dtp,
-	struct xfs_trans	*stp)
+xfs_defer_ops_continue(
+	struct xfs_defer_capture	*dfc,
+	struct xfs_trans		*tp)
 {
-	xfs_defer_create_intents(stp);
-	xfs_defer_move(dtp, stp);
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
+
+	/* Move captured dfops chain and state to the transaction. */
+	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
+	tp->t_flags |= dfc->dfc_tpflags;
+
+	kmem_free(dfc);
 }
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 3164199162b6..3af82ebc1249 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -8,6 +8,7 @@
 
 struct xfs_btree_cur;
 struct xfs_defer_op_type;
+struct xfs_defer_capture;
 
 /*
  * Header for deferred operation list.
@@ -63,10 +64,26 @@ extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 
+/*
+ * This structure enables a dfops user to detach the chain of deferred
+ * operations from a transaction so that they can be continued later.
+ */
+struct xfs_defer_capture {
+	/* List of other capture structures. */
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
+int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
+		struct list_head *capture_list);
+void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp);
+void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
 
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index b04ebcd78316..126df48dae5f 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -424,13 +424,13 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 STATIC int
 xfs_bui_item_recover(
 	struct xfs_log_item		*lip,
-	struct xfs_trans		*parent_tp)
+	struct list_head		*capture_list)
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
@@ -478,12 +478,7 @@ xfs_bui_item_recover(
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
@@ -531,15 +526,12 @@ xfs_bui_item_recover(
 		xfs_bmap_unmap_extent(tp, ip, &irec);
 	}
 
-	xfs_defer_capture(parent_tp, tp);
-	error = xfs_trans_commit(tp);
+	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
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
index 9093d2e7afdf..17d36fe5cfd0 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -585,10 +585,10 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 STATIC int
 xfs_efi_item_recover(
 	struct xfs_log_item		*lip,
-	struct xfs_trans		*parent_tp)
+	struct list_head		*capture_list)
 {
 	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
-	struct xfs_mount		*mp = parent_tp->t_mountp;
+	struct xfs_mount		*mp = lip->li_mountp;
 	struct xfs_efd_log_item		*efdp;
 	struct xfs_trans		*tp;
 	struct xfs_extent		*extp;
@@ -627,8 +627,7 @@ xfs_efi_item_recover(
 
 	}
 
-	error = xfs_trans_commit(tp);
-	return error;
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
 	xfs_trans_cancel(tp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 84f876c6d498..7804906d145b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2434,37 +2434,65 @@ xlog_recover_process_data(
 /* Take all the collected deferred ops and finish them in order. */
 static int
 xlog_finish_defer_ops(
-	struct xfs_trans	*parent_tp)
+	struct xfs_mount	*mp,
+	struct list_head	*capture_list)
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
+	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
+		/*
+		 * We're finishing the defer_ops that accumulated as a result
+		 * of recovering unfinished intent items during log recovery.
+		 * We reserve an itruncate transaction because it is the
+		 * largest permanent transaction type.  Since we're the only
+		 * user of the fs right now, take 93% (15/16) of the available
+		 * free blocks.  Use weird math to avoid a 64-bit division.
+		 */
+		freeblks = percpu_counter_sum(&mp->m_fdblocks);
+		if (freeblks <= 0)
+			return -ENOSPC;
 
-	return xfs_trans_commit(tp);
+		resblks = min_t(uint64_t, UINT_MAX, freeblks);
+		resblks = (resblks * 15) >> 4;
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
+				0, XFS_TRANS_RESERVE, &tp);
+		if (error)
+			return error;
+
+		/*
+		 * Transfer to this new transaction all the dfops we captured
+		 * from recovering a single intent item.
+		 */
+		list_del_init(&dfc->dfc_list);
+		xfs_defer_ops_continue(dfc, tp);
+
+		error = xfs_trans_commit(tp);
+		if (error)
+			return error;
+	}
+
+	ASSERT(list_empty(capture_list));
+	return 0;
 }
 
+/* Release all the captured defer ops and capture structures in this list. */
+static void
+xlog_abort_defer_ops(
+	struct xfs_mount		*mp,
+	struct list_head		*capture_list)
+{
+	struct xfs_defer_capture	*dfc;
+	struct xfs_defer_capture	*next;
+
+	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
+		list_del_init(&dfc->dfc_list);
+		xfs_defer_ops_release(mp, dfc);
+	}
+}
 /*
  * When this is called, all of the log intent items which did not have
  * corresponding log done items should be in the AIL.  What we do now
@@ -2485,35 +2513,23 @@ STATIC int
 xlog_recover_process_intents(
 	struct xlog		*log)
 {
-	struct xfs_trans	*parent_tp;
+	LIST_HEAD(capture_list);
 	struct xfs_ail_cursor	cur;
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
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 #if defined(DEBUG) || defined(XFS_WARN)
 	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
 #endif
-	while (lip != NULL) {
+	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	     lip != NULL;
+	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
 		/*
 		 * We're done when we see something other than an intent.
 		 * There should be no intents left in the AIL now.
@@ -2535,24 +2551,29 @@ xlog_recover_process_intents(
 
 		/*
 		 * NOTE: If your intent processing routine can create more
-		 * deferred ops, you /must/ attach them to the transaction in
-		 * this routine or else those subsequent intents will get
+		 * deferred ops, you /must/ attach them to the capture list in
+		 * the recover routine or else those subsequent intents will be
 		 * replayed in the wrong order!
 		 */
 		spin_unlock(&ailp->ail_lock);
-		error = lip->li_ops->iop_recover(lip, parent_tp);
+		error = lip->li_ops->iop_recover(lip, &capture_list);
 		spin_lock(&ailp->ail_lock);
 		if (error)
-			goto out;
-		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+			break;
 	}
-out:
+
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
-	if (!error)
-		error = xlog_finish_defer_ops(parent_tp);
-	xfs_trans_cancel(parent_tp);
+	if (error)
+		goto err;
 
+	error = xlog_finish_defer_ops(log->l_mp, &capture_list);
+	if (error)
+		goto err;
+
+	return 0;
+err:
+	xlog_abort_defer_ops(log->l_mp, &capture_list);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 3e34b7662361..0478374add64 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -424,7 +424,7 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 STATIC int
 xfs_cui_item_recover(
 	struct xfs_log_item		*lip,
-	struct xfs_trans		*parent_tp)
+	struct list_head		*capture_list)
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
@@ -487,12 +487,7 @@ xfs_cui_item_recover(
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
@@ -549,13 +544,10 @@ xfs_cui_item_recover(
 	}
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	xfs_defer_capture(parent_tp, tp);
-	error = xfs_trans_commit(tp);
-	return error;
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	xfs_defer_move(parent_tp, tp);
 	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index e38ec5d736be..0d8fa707f079 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -467,14 +467,14 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 STATIC int
 xfs_rui_item_recover(
 	struct xfs_log_item		*lip,
-	struct xfs_trans		*parent_tp)
+	struct list_head		*capture_list)
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
@@ -567,8 +567,7 @@ xfs_rui_item_recover(
 	}
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
-	error = xfs_trans_commit(tp);
-	return error;
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index ced62a35a62b..186e77d08cc1 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -72,7 +72,8 @@ struct xfs_item_ops {
 	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
 	void (*iop_release)(struct xfs_log_item *);
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
-	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
+	int (*iop_recover)(struct xfs_log_item *lip,
+			   struct list_head *capture_list);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
 };
 

