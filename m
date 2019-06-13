Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57454 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfFMSDU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:20 -0400
Received: from [213.208.157.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbU4F-0002hf-A3
        for linux-xfs@vger.kernel.org; Thu, 13 Jun 2019 18:03:19 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/20] xfs: split iop_unlock
Date: Thu, 13 Jun 2019 20:02:47 +0200
Message-Id: <20190613180300.30447-8-hch@lst.de>
In-Reply-To: <20190613180300.30447-1-hch@lst.de>
References: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The iop_unlock method is called when comitting or cancelling a
transaction.  In the latter case, the transaction may or may not be
aborted.  While there is no known problem with the current code in
practice, this implementation is limited in that any log item
implementation that might want to differentiate between a commit and a
cancellation must rely on the aborted state.  The aborted bit is only
set when the cancelled transaction is dirty, however.  This means that
there is no way to distinguish between a commit and a clean transaction
cancellation.

For example, intent log items currently rely on this distinction.  The
log item is either transferred to the CIL on commit or released on
transaction cancel. There is currently no possibility for a clean intent
log item in a transaction, but if that state is ever introduced a cancel
of such a transaction will immediately result in memory leaks of the
associated log item(s).  This is an interface deficiency and landmine.

To clean this up, replace the iop_unlock method with an iop_release
method that is specific to transaction cancel.  The existing
iop_committing method occurs at the same time as iop_unlock in the
commit path and there is no need for two separate callbacks here.
Overload the iop_committing method with the current commit time
iop_unlock implementations to eliminate the need for the latter and
further simplify the interface.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_item.c     | 17 +++++++----------
 fs/xfs/xfs_buf_item.c      | 15 ++++++++++++---
 fs/xfs/xfs_dquot_item.c    | 19 +++++++++++--------
 fs/xfs/xfs_extfree_item.c  | 17 +++++++----------
 fs/xfs/xfs_icreate_item.c  | 10 +++-------
 fs/xfs/xfs_inode_item.c    | 11 ++++++-----
 fs/xfs/xfs_log_cil.c       |  2 --
 fs/xfs/xfs_refcount_item.c | 17 +++++++----------
 fs/xfs/xfs_rmap_item.c     | 17 +++++++----------
 fs/xfs/xfs_trace.h         |  2 +-
 fs/xfs/xfs_trans.c         |  7 +++----
 fs/xfs/xfs_trans.h         |  4 ++--
 fs/xfs/xfs_trans_buf.c     |  2 +-
 13 files changed, 67 insertions(+), 73 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 8e57df6d5581..56c1ab161f3b 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -119,11 +119,10 @@ xfs_bui_item_unpin(
  * constructed and thus we free the BUI here directly.
  */
 STATIC void
-xfs_bui_item_unlock(
+xfs_bui_item_release(
 	struct xfs_log_item	*lip)
 {
-	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
-		xfs_bui_release(BUI_ITEM(lip));
+	xfs_bui_release(BUI_ITEM(lip));
 }
 
 /*
@@ -133,7 +132,7 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
 	.iop_size	= xfs_bui_item_size,
 	.iop_format	= xfs_bui_item_format,
 	.iop_unpin	= xfs_bui_item_unpin,
-	.iop_unlock	= xfs_bui_item_unlock,
+	.iop_release	= xfs_bui_item_release,
 };
 
 /*
@@ -200,15 +199,13 @@ xfs_bud_item_format(
  * BUD.
  */
 STATIC void
-xfs_bud_item_unlock(
+xfs_bud_item_release(
 	struct xfs_log_item	*lip)
 {
 	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
 
-	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
-		xfs_bui_release(budp->bud_buip);
-		kmem_zone_free(xfs_bud_zone, budp);
-	}
+	xfs_bui_release(budp->bud_buip);
+	kmem_zone_free(xfs_bud_zone, budp);
 }
 
 /*
@@ -242,7 +239,7 @@ xfs_bud_item_committed(
 static const struct xfs_item_ops xfs_bud_item_ops = {
 	.iop_size	= xfs_bud_item_size,
 	.iop_format	= xfs_bud_item_format,
-	.iop_unlock	= xfs_bud_item_unlock,
+	.iop_release	= xfs_bud_item_release,
 	.iop_committed	= xfs_bud_item_committed,
 };
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 423f1a042ed8..dc98d669884e 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -594,7 +594,7 @@ xfs_buf_item_put(
  * free the item.
  */
 STATIC void
-xfs_buf_item_unlock(
+xfs_buf_item_release(
 	struct xfs_log_item	*lip)
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
@@ -609,7 +609,7 @@ xfs_buf_item_unlock(
 						   &lip->li_flags);
 #endif
 
-	trace_xfs_buf_item_unlock(bip);
+	trace_xfs_buf_item_release(bip);
 
 	/*
 	 * The bli dirty state should match whether the blf has logged segments
@@ -639,6 +639,14 @@ xfs_buf_item_unlock(
 	xfs_buf_relse(bp);
 }
 
+STATIC void
+xfs_buf_item_committing(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		commit_lsn)
+{
+	return xfs_buf_item_release(lip);
+}
+
 /*
  * This is called to find out where the oldest active copy of the
  * buf log item in the on disk log resides now that the last log
@@ -679,7 +687,8 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_format	= xfs_buf_item_format,
 	.iop_pin	= xfs_buf_item_pin,
 	.iop_unpin	= xfs_buf_item_unpin,
-	.iop_unlock	= xfs_buf_item_unlock,
+	.iop_release	= xfs_buf_item_release,
+	.iop_committing	= xfs_buf_item_committing,
 	.iop_committed	= xfs_buf_item_committed,
 	.iop_push	= xfs_buf_item_push,
 };
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index a61a8a770d7f..b8fd81641dfc 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -197,14 +197,8 @@ xfs_qm_dquot_logitem_push(
 	return rval;
 }
 
-/*
- * Unlock the dquot associated with the log item.
- * Clear the fields of the dquot and dquot log item that
- * are specific to the current transaction.  If the
- * hold flags is set, do not unlock the dquot.
- */
 STATIC void
-xfs_qm_dquot_logitem_unlock(
+xfs_qm_dquot_logitem_release(
 	struct xfs_log_item	*lip)
 {
 	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
@@ -220,6 +214,14 @@ xfs_qm_dquot_logitem_unlock(
 	xfs_dqunlock(dqp);
 }
 
+STATIC void
+xfs_qm_dquot_logitem_committing(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		commit_lsn)
+{
+	return xfs_qm_dquot_logitem_release(lip);
+}
+
 /*
  * This is the ops vector for dquots
  */
@@ -228,7 +230,8 @@ static const struct xfs_item_ops xfs_dquot_item_ops = {
 	.iop_format	= xfs_qm_dquot_logitem_format,
 	.iop_pin	= xfs_qm_dquot_logitem_pin,
 	.iop_unpin	= xfs_qm_dquot_logitem_unpin,
-	.iop_unlock	= xfs_qm_dquot_logitem_unlock,
+	.iop_release	= xfs_qm_dquot_logitem_release,
+	.iop_committing	= xfs_qm_dquot_logitem_committing,
 	.iop_push	= xfs_qm_dquot_logitem_push,
 	.iop_error	= xfs_dquot_item_error
 };
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 655ed0445750..a73a3cff8502 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -129,11 +129,10 @@ xfs_efi_item_unpin(
  * constructed and thus we free the EFI here directly.
  */
 STATIC void
-xfs_efi_item_unlock(
+xfs_efi_item_release(
 	struct xfs_log_item	*lip)
 {
-	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
-		xfs_efi_release(EFI_ITEM(lip));
+	xfs_efi_release(EFI_ITEM(lip));
 }
 
 /*
@@ -143,7 +142,7 @@ static const struct xfs_item_ops xfs_efi_item_ops = {
 	.iop_size	= xfs_efi_item_size,
 	.iop_format	= xfs_efi_item_format,
 	.iop_unpin	= xfs_efi_item_unpin,
-	.iop_unlock	= xfs_efi_item_unlock,
+	.iop_release	= xfs_efi_item_release,
 };
 
 
@@ -299,15 +298,13 @@ xfs_efd_item_format(
  * the transaction is cancelled, drop our reference to the EFI and free the EFD.
  */
 STATIC void
-xfs_efd_item_unlock(
+xfs_efd_item_release(
 	struct xfs_log_item	*lip)
 {
 	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
 
-	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
-		xfs_efi_release(efdp->efd_efip);
-		xfs_efd_item_free(efdp);
-	}
+	xfs_efi_release(efdp->efd_efip);
+	xfs_efd_item_free(efdp);
 }
 
 /*
@@ -341,7 +338,7 @@ xfs_efd_item_committed(
 static const struct xfs_item_ops xfs_efd_item_ops = {
 	.iop_size	= xfs_efd_item_size,
 	.iop_format	= xfs_efd_item_format,
-	.iop_unlock	= xfs_efd_item_unlock,
+	.iop_release	= xfs_efd_item_release,
 	.iop_committed	= xfs_efd_item_committed,
 };
 
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index cbaabc55f0c9..9aceb35dce24 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -57,14 +57,10 @@ xfs_icreate_item_format(
 }
 
 STATIC void
-xfs_icreate_item_unlock(
+xfs_icreate_item_release(
 	struct xfs_log_item	*lip)
 {
-	struct xfs_icreate_item	*icp = ICR_ITEM(lip);
-
-	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
-		kmem_zone_free(xfs_icreate_zone, icp);
-	return;
+	kmem_zone_free(xfs_icreate_zone, ICR_ITEM(lip));
 }
 
 /*
@@ -89,7 +85,7 @@ xfs_icreate_item_committed(
 static const struct xfs_item_ops xfs_icreate_item_ops = {
 	.iop_size	= xfs_icreate_item_size,
 	.iop_format	= xfs_icreate_item_format,
-	.iop_unlock	= xfs_icreate_item_unlock,
+	.iop_release	= xfs_icreate_item_release,
 	.iop_committed	= xfs_icreate_item_committed,
 };
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index fa1c4fe2ffbf..a00f0b6aecc7 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -565,7 +565,7 @@ xfs_inode_item_push(
  * Unlock the inode associated with the inode log item.
  */
 STATIC void
-xfs_inode_item_unlock(
+xfs_inode_item_release(
 	struct xfs_log_item	*lip)
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
@@ -621,9 +621,10 @@ xfs_inode_item_committed(
 STATIC void
 xfs_inode_item_committing(
 	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
+	xfs_lsn_t		commit_lsn)
 {
-	INODE_ITEM(lip)->ili_last_lsn = lsn;
+	INODE_ITEM(lip)->ili_last_lsn = commit_lsn;
+	return xfs_inode_item_release(lip);
 }
 
 /*
@@ -634,10 +635,10 @@ static const struct xfs_item_ops xfs_inode_item_ops = {
 	.iop_format	= xfs_inode_item_format,
 	.iop_pin	= xfs_inode_item_pin,
 	.iop_unpin	= xfs_inode_item_unpin,
-	.iop_unlock	= xfs_inode_item_unlock,
+	.iop_release	= xfs_inode_item_release,
 	.iop_committed	= xfs_inode_item_committed,
 	.iop_push	= xfs_inode_item_push,
-	.iop_committing = xfs_inode_item_committing,
+	.iop_committing	= xfs_inode_item_committing,
 	.iop_error	= xfs_inode_item_error
 };
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index c856bfce5bf2..4cb459f21ad4 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1024,8 +1024,6 @@ xfs_log_commit_cil(
 		xfs_trans_del_item(lip);
 		if (lip->li_ops->iop_committing)
 			lip->li_ops->iop_committing(lip, xc_commit_lsn);
-		if (lip->li_ops->iop_unlock)
-			lip->li_ops->iop_unlock(lip);
 	}
 	xlog_cil_push_background(log);
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 03a61886fe2a..9f8fb23dcc81 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -118,11 +118,10 @@ xfs_cui_item_unpin(
  * constructed and thus we free the CUI here directly.
  */
 STATIC void
-xfs_cui_item_unlock(
+xfs_cui_item_release(
 	struct xfs_log_item	*lip)
 {
-	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
-		xfs_cui_release(CUI_ITEM(lip));
+	xfs_cui_release(CUI_ITEM(lip));
 }
 
 /*
@@ -132,7 +131,7 @@ static const struct xfs_item_ops xfs_cui_item_ops = {
 	.iop_size	= xfs_cui_item_size,
 	.iop_format	= xfs_cui_item_format,
 	.iop_unpin	= xfs_cui_item_unpin,
-	.iop_unlock	= xfs_cui_item_unlock,
+	.iop_release	= xfs_cui_item_release,
 };
 
 /*
@@ -205,15 +204,13 @@ xfs_cud_item_format(
  * CUD.
  */
 STATIC void
-xfs_cud_item_unlock(
+xfs_cud_item_release(
 	struct xfs_log_item	*lip)
 {
 	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
 
-	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
-		xfs_cui_release(cudp->cud_cuip);
-		kmem_zone_free(xfs_cud_zone, cudp);
-	}
+	xfs_cui_release(cudp->cud_cuip);
+	kmem_zone_free(xfs_cud_zone, cudp);
 }
 
 /*
@@ -247,7 +244,7 @@ xfs_cud_item_committed(
 static const struct xfs_item_ops xfs_cud_item_ops = {
 	.iop_size	= xfs_cud_item_size,
 	.iop_format	= xfs_cud_item_format,
-	.iop_unlock	= xfs_cud_item_unlock,
+	.iop_release	= xfs_cud_item_release,
 	.iop_committed	= xfs_cud_item_committed,
 };
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index df9f2505c5f3..e907bd169de5 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -117,11 +117,10 @@ xfs_rui_item_unpin(
  * constructed and thus we free the RUI here directly.
  */
 STATIC void
-xfs_rui_item_unlock(
+xfs_rui_item_release(
 	struct xfs_log_item	*lip)
 {
-	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
-		xfs_rui_release(RUI_ITEM(lip));
+	xfs_rui_release(RUI_ITEM(lip));
 }
 
 /*
@@ -131,7 +130,7 @@ static const struct xfs_item_ops xfs_rui_item_ops = {
 	.iop_size	= xfs_rui_item_size,
 	.iop_format	= xfs_rui_item_format,
 	.iop_unpin	= xfs_rui_item_unpin,
-	.iop_unlock	= xfs_rui_item_unlock,
+	.iop_release	= xfs_rui_item_release,
 };
 
 /*
@@ -226,15 +225,13 @@ xfs_rud_item_format(
  * RUD.
  */
 STATIC void
-xfs_rud_item_unlock(
+xfs_rud_item_release(
 	struct xfs_log_item	*lip)
 {
 	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
 
-	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
-		xfs_rui_release(rudp->rud_ruip);
-		kmem_zone_free(xfs_rud_zone, rudp);
-	}
+	xfs_rui_release(rudp->rud_ruip);
+	kmem_zone_free(xfs_rud_zone, rudp);
 }
 
 /*
@@ -268,7 +265,7 @@ xfs_rud_item_committed(
 static const struct xfs_item_ops xfs_rud_item_ops = {
 	.iop_size	= xfs_rud_item_size,
 	.iop_format	= xfs_rud_item_format,
-	.iop_unlock	= xfs_rud_item_unlock,
+	.iop_release	= xfs_rud_item_release,
 	.iop_committed	= xfs_rud_item_committed,
 };
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 195a9cdb954e..65c920554b96 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -475,7 +475,7 @@ DEFINE_BUF_ITEM_EVENT(xfs_buf_item_ordered);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pin);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin_stale);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_release);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_committed);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_push);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index b0e77e4c1bfe..5fe69ea07367 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -780,9 +780,8 @@ xfs_trans_free_items(
 		xfs_trans_del_item(lip);
 		if (abort)
 			set_bit(XFS_LI_ABORTED, &lip->li_flags);
-
-		if (lip->li_ops->iop_unlock)
-			lip->li_ops->iop_unlock(lip);
+		if (lip->li_ops->iop_release)
+			lip->li_ops->iop_release(lip);
 	}
 }
 
@@ -815,7 +814,7 @@ xfs_log_item_batch_insert(
  *
  * If we are called with the aborted flag set, it is because a log write during
  * a CIL checkpoint commit has failed. In this case, all the items in the
- * checkpoint have already gone through iop_committed and iop_unlock, which
+ * checkpoint have already gone through iop_committed and iop_committing, which
  * means that checkpoint commit abort handling is treated exactly the same
  * as an iclog write error even though we haven't started any IO yet. Hence in
  * this case all we need to do is iop_committed processing, followed by an
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index c6e1c5704a8c..7bd1867613c2 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -72,9 +72,9 @@ struct xfs_item_ops {
 	void (*iop_pin)(xfs_log_item_t *);
 	void (*iop_unpin)(xfs_log_item_t *, int remove);
 	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
-	void (*iop_unlock)(xfs_log_item_t *);
+	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
+	void (*iop_release)(struct xfs_log_item *);
 	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
-	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
 	void (*iop_error)(xfs_log_item_t *, xfs_buf_t *);
 };
 
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 7d65ebf1e847..3dca9cf40a9f 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -428,7 +428,7 @@ xfs_trans_brelse(
 
 /*
  * Mark the buffer as not needing to be unlocked when the buf item's
- * iop_unlock() routine is called.  The buffer must already be locked
+ * iop_committing() routine is called.  The buffer must already be locked
  * and associated with the given transaction.
  */
 /* ARGSUSED */
-- 
2.20.1
