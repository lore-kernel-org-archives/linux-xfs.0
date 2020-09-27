Return-Path: <SRS0=IMq7=DE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCB8C4346E
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C385A23A32
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:41:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L+yIJF5I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgI0Xlb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Sep 2020 19:41:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46996 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI0Xlb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Sep 2020 19:41:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNfNr2052032;
        Sun, 27 Sep 2020 23:41:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=arirh1jQeL+Z8R0FO8TNDUP5nLPW3P7RW796lRrUAz0=;
 b=L+yIJF5IoSBv+skRzQ5SZIzmJhlRZFE3tzxlpBZ+nikz50KtXXx2b8E+1SOf9Rs+QNAL
 P8FkD9lWBM43mjwYlbLfsb9CiYLOooYPMpsNY/1D+27O1OLEhsqa4mBHJiZ5sXZ+ESBf
 ThCyl1W27vTRYzdkxkEPSZ4X2U6k7gQ6mN9x77/4+Uyv9X9/IlbDew2yuoHGk0W2qDdm
 8SW5se3UU1cWRZ2f6SRmEgkXpd9y64lkFfK2lKiATfVORV18S7/CGyNn/5DEuvkBDMcS
 R4HmMgNfAFODTRYpWjavUZqI40I/YDBMHsaC5tzzfWWk5OCgyEcB8e5Tfp74eKohUFQi dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33sx9mtg1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 27 Sep 2020 23:41:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNdeH9167846;
        Sun, 27 Sep 2020 23:41:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33tfju3nj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Sep 2020 23:41:23 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08RNfM7L009935;
        Sun, 27 Sep 2020 23:41:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 27 Sep 2020 16:41:21 -0700
Subject: [PATCH 2/4] xfs: proper replay of deferred ops queued during log
 recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Date:   Sun, 27 Sep 2020 16:41:20 -0700
Message-ID: <160125008079.174438.4841984502957067911.stgit@magnolia>
In-Reply-To: <160125006793.174438.10683462598722457550.stgit@magnolia>
References: <160125006793.174438.10683462598722457550.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009270227
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=3
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009270227
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
 fs/xfs/libxfs/xfs_defer.c       |   56 +++++++++++++--
 fs/xfs/libxfs/xfs_defer.h       |   20 +++++
 fs/xfs/libxfs/xfs_log_recover.h |    2 +
 fs/xfs/xfs_bmap_item.c          |   16 +---
 fs/xfs/xfs_extfree_item.c       |    7 +-
 fs/xfs/xfs_log_recover.c        |  150 +++++++++++++++++++++++++--------------
 fs/xfs/xfs_refcount_item.c      |   16 +---
 fs/xfs/xfs_rmap_item.c          |    7 +-
 fs/xfs/xfs_trans.h              |    3 +
 9 files changed, 183 insertions(+), 94 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 36c103c14bc9..0de7672fe63d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -549,14 +549,56 @@ xfs_defer_move(
  *
  * Create and log intent items for all the work that we're capturing so that we
  * can be assured that the items will get replayed if the system goes down
- * before log recovery gets a chance to finish the work it put off.  Then we
- * move the chain from stp to dtp.
+ * before log recovery gets a chance to finish the work it put off.  The entire
+ * deferred ops state is transferred to the capture structure and the
+ * transaction is then ready for the caller to commit it.  If there are no
+ * intent items to capture, this function returns NULL.
  */
-void
+struct xfs_defer_capture *
 xfs_defer_capture(
-	struct xfs_trans	*dtp,
-	struct xfs_trans	*stp)
+	struct xfs_trans		*tp)
 {
-	xfs_defer_create_intents(stp);
-	xfs_defer_move(dtp, stp);
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
index 3164199162b6..bc7493bf4542 100644
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
+struct xfs_defer_capture *xfs_defer_capture(struct xfs_trans *tp);
+void xfs_defer_continue(struct xfs_defer_capture *dfc, struct xfs_trans *tp);
+void xfs_defer_capture_free(struct xfs_mount *mp,
+		struct xfs_defer_capture *dfc);
 
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 3cca2bfe714c..8ad44b4195e8 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -124,5 +124,7 @@ bool xlog_is_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id);
+int xlog_recover_trans_commit(struct xfs_trans *tp,
+		struct list_head *capture_list);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index b04ebcd78316..b73f0a0890a2 100644
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
+	error = xlog_recover_trans_commit(tp, capture_list);
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
index 9093d2e7afdf..be0186875566 100644
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
+	return xlog_recover_trans_commit(tp, capture_list);
 
 abort_error:
 	xfs_trans_cancel(tp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e0675071b39e..107965acc57e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1755,6 +1755,38 @@ xlog_recover_release_intent(
 	spin_unlock(&ailp->ail_lock);
 }
 
+/*
+ * Capture any deferred ops and commit the transaction.  This is the last step
+ * needed to finish a log intent item that we recovered from the log, and will
+ * take care of releasing all the relevant resources.
+ */
+int
+xlog_recover_trans_commit(
+	struct xfs_trans		*tp,
+	struct list_head		*capture_list)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_defer_capture	*dfc = xfs_defer_capture(tp);
+	int				error;
+
+	/* If we don't capture anything, commit tp and exit. */
+	if (!dfc)
+		return xfs_trans_commit(tp);
+
+	/*
+	 * Commit the transaction.  If that fails, clean up the defer ops and
+	 * the dfc that we just created.  Otherwise, add the dfc to the list.
+	 */
+	error = xfs_trans_commit(tp);
+	if (error) {
+		xfs_defer_capture_free(mp, dfc);
+		return error;
+	}
+
+	list_add_tail(&dfc->dfc_list, capture_list);
+	return 0;
+}
+
 /******************************************************************************
  *
  *		Log recover routines
@@ -2431,38 +2463,62 @@ xlog_recover_process_data(
 	return 0;
 }
 
+static void
+xlog_cancel_defer_ops(
+	struct xfs_mount	*mp,
+	struct list_head	*capture_list)
+{
+	struct xfs_defer_capture *dfc, *next;
+
+	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
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
+		/* transfer all collected dfops to this transaction */
+		list_del_init(&dfc->dfc_list);
+		xfs_defer_continue(dfc, tp);
+
+		error = xfs_trans_commit(tp);
+		xfs_defer_capture_free(mp, dfc);
+		if (error)
+			return error;
+	}
+
+	return 0;
 }
 
 /*
@@ -2485,35 +2541,23 @@ STATIC int
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
@@ -2533,28 +2577,28 @@ xlog_recover_process_intents(
 		 */
 		ASSERT(XFS_LSN_CMP(last_lsn, lip->li_lsn) >= 0);
 
+		if (test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags))
+			continue;
+
 		/*
 		 * NOTE: If your intent processing routine can create more
-		 * deferred ops, you /must/ attach them to the transaction in
-		 * this routine or else those subsequent intents will get
+		 * deferred ops, you /must/ attach them to the capture list in
+		 * the recover routine or else those subsequent intents will be
 		 * replayed in the wrong order!
 		 */
-		if (!test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags)) {
-			spin_unlock(&ailp->ail_lock);
-			error = lip->li_ops->iop_recover(lip, parent_tp);
-			spin_lock(&ailp->ail_lock);
-		}
+		spin_unlock(&ailp->ail_lock);
+		error = lip->li_ops->iop_recover(lip, &capture_list);
+		spin_lock(&ailp->ail_lock);
 		if (error)
-			goto out;
-		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+			break;
 	}
-out:
+
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
 	if (!error)
-		error = xlog_finish_defer_ops(parent_tp);
-	xfs_trans_cancel(parent_tp);
+		error = xlog_finish_defer_ops(log->l_mp, &capture_list);
 
+	xlog_cancel_defer_ops(log->l_mp, &capture_list);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 3e34b7662361..7a57b4de9ee7 100644
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
+	return xlog_recover_trans_commit(tp, capture_list);
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	xfs_defer_move(parent_tp, tp);
 	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index e38ec5d736be..16c7a6385c3f 100644
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
+	return xlog_recover_trans_commit(tp, capture_list);
 
 abort_error:
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a71b4f443e39..e3875a92a541 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -74,7 +74,8 @@ struct xfs_item_ops {
 	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
 	void (*iop_release)(struct xfs_log_item *);
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
-	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
+	int (*iop_recover)(struct xfs_log_item *lip,
+			   struct list_head *capture_list);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
 };
 

