Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57448 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfFMSDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:17 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/20] xfs: don't use xfs_trans_free_items in the commit path
Date: Thu, 13 Jun 2019 20:02:46 +0200
Message-Id: <20190613180300.30447-7-hch@lst.de>
In-Reply-To: <20190613180300.30447-1-hch@lst.de>
References: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

While commiting items looks very similar to freeing them on error it is
a different operation, and they will diverge a bit soon.

Split out the commit case from xfs_trans_free_items, inline it into
xfs_log_commit_cil and give it a separate trace point.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_cil.c    | 13 ++++++++++---
 fs/xfs/xfs_trace.h      |  1 +
 fs/xfs/xfs_trans.c      | 10 +++-------
 fs/xfs/xfs_trans_priv.h |  2 --
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 49f37905c7a7..c856bfce5bf2 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -985,6 +985,7 @@ xfs_log_commit_cil(
 {
 	struct xlog		*log = mp->m_log;
 	struct xfs_cil		*cil = log->l_cilp;
+	struct xfs_log_item	*lip, *next;
 	xfs_lsn_t		xc_commit_lsn;
 
 	/*
@@ -1009,7 +1010,7 @@ xfs_log_commit_cil(
 
 	/*
 	 * Once all the items of the transaction have been copied to the CIL,
-	 * the items can be unlocked and freed.
+	 * the items can be unlocked and possibly freed.
 	 *
 	 * This needs to be done before we drop the CIL context lock because we
 	 * have to update state in the log items and unlock them before they go
@@ -1018,8 +1019,14 @@ xfs_log_commit_cil(
 	 * the log items. This affects (at least) processing of stale buffers,
 	 * inodes and EFIs.
 	 */
-	xfs_trans_free_items(tp, xc_commit_lsn, false);
-
+	trace_xfs_trans_commit_items(tp, _RET_IP_);
+	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
+		xfs_trans_del_item(lip);
+		if (lip->li_ops->iop_committing)
+			lip->li_ops->iop_committing(lip, xc_commit_lsn);
+		if (lip->li_ops->iop_unlock)
+			lip->li_ops->iop_unlock(lip);
+	}
 	xlog_cil_push_background(log);
 
 	up_read(&cil->xc_ctx_lock);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2464ea351f83..195a9cdb954e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3360,6 +3360,7 @@ DEFINE_TRANS_EVENT(xfs_trans_dup);
 DEFINE_TRANS_EVENT(xfs_trans_free);
 DEFINE_TRANS_EVENT(xfs_trans_roll);
 DEFINE_TRANS_EVENT(xfs_trans_add_item);
+DEFINE_TRANS_EVENT(xfs_trans_commit_items);
 DEFINE_TRANS_EVENT(xfs_trans_free_items);
 
 TRACE_EVENT(xfs_iunlink_update_bucket,
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index d4fbde493de8..b0e77e4c1bfe 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -767,10 +767,9 @@ xfs_trans_del_item(
 }
 
 /* Detach and unlock all of the items in a transaction */
-void
+static void
 xfs_trans_free_items(
 	struct xfs_trans	*tp,
-	xfs_lsn_t		commit_lsn,
 	bool			abort)
 {
 	struct xfs_log_item	*lip, *next;
@@ -779,9 +778,6 @@ xfs_trans_free_items(
 
 	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
 		xfs_trans_del_item(lip);
-		if (commit_lsn != NULLCOMMITLSN &&
-		    lip->li_ops->iop_committing)
-			lip->li_ops->iop_committing(lip, commit_lsn);
 		if (abort)
 			set_bit(XFS_LI_ABORTED, &lip->li_flags);
 
@@ -1007,7 +1003,7 @@ __xfs_trans_commit(
 		tp->t_ticket = NULL;
 	}
 	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
-	xfs_trans_free_items(tp, NULLCOMMITLSN, !!error);
+	xfs_trans_free_items(tp, !!error);
 	xfs_trans_free(tp);
 
 	XFS_STATS_INC(mp, xs_trans_empty);
@@ -1069,7 +1065,7 @@ xfs_trans_cancel(
 	/* mark this thread as no longer being in a transaction */
 	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 
-	xfs_trans_free_items(tp, NULLCOMMITLSN, dirty);
+	xfs_trans_free_items(tp, dirty);
 	xfs_trans_free(tp);
 }
 
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 571c065cf416..2e073c1c4614 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -16,8 +16,6 @@ struct xfs_log_vec;
 void	xfs_trans_init(struct xfs_mount *);
 void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
-void	xfs_trans_free_items(struct xfs_trans *tp, xfs_lsn_t commit_lsn,
-				bool abort);
 void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
 
 void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *lv,
-- 
2.20.1
