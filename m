Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F03C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 05:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C7EA64E31
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 05:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhBWFdG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 00:33:06 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57917 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230439AbhBWFdD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 00:33:03 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E14FA1041124
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 16:32:16 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEQIy-0009cV-3K
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 16:32:16 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lEQIx-00DnTv-RT
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 16:32:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: xfs_log_force_lsn isn't passed a LSN
Date:   Tue, 23 Feb 2021 16:32:10 +1100
Message-Id: <20210223053212.3287398-2-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210223053212.3287398-1-david@fromorbit.com>
References: <20210223053212.3287398-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=r68RYM1CTraGxGQ2onMA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

In doing an investigation into AIL push stalls, I was looking at the
log force code to see if an async CIL push could be done instead.
This lead me to xfs_log_force_lsn() and looking at how it works.

xfs_log_force_lsn() is only called from inode synchronisation
contexts such as fsync(), and it takes the ip->i_itemp->ili_last_lsn
value as the LSN to sync the log to. This gets passed to
xlog_cil_force_lsn() via xfs_log_force_lsn() to flush the CIL to the
journal, and then used by xfs_log_force_lsn() to flush the iclogs to
the journal.

The problem with is that ip->i_itemp->ili_last_lsn does not store a
log sequence number. What it stores is passed to it from the
->iop_committing method, which is called by xfs_log_commit_cil().
The value this passes to the iop_committing method is the CIL
context sequence number that the item was committed to.

As it turns out, xlog_cil_force_lsn() converts the sequence to an
actual commit LSN for the related context and returns that to
xfs_log_force_lsn(). xfs_log_force_lsn() overwrites it's "lsn"
variable that contained a sequence with an actual LSN and then uses
that to sync the iclogs.

This caused me some confusion for a while, even though I originally
wrote all this code a decade ago. ->iop_committing is only used by
a couple of log item types, and only inode items use the sequence
number it is passed.

Let's clean up the API, CIL structures and inode log item to call it
a sequence number, and make it clear that the high level code is
using CIL sequence numbers and not on-disk LSNs for integrity
synchronisation purposes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c   |  2 +-
 fs/xfs/xfs_dquot_item.c |  2 +-
 fs/xfs/xfs_file.c       | 14 +++++++-------
 fs/xfs/xfs_inode.c      | 10 +++++-----
 fs/xfs/xfs_inode_item.c |  4 ++--
 fs/xfs/xfs_inode_item.h |  2 +-
 fs/xfs/xfs_log.c        | 27 ++++++++++++++-------------
 fs/xfs/xfs_log.h        |  4 +---
 fs/xfs/xfs_log_cil.c    | 22 +++++++++-------------
 fs/xfs/xfs_log_priv.h   | 15 +++++++--------
 fs/xfs/xfs_trans.c      |  6 +++---
 fs/xfs/xfs_trans.h      |  4 ++--
 12 files changed, 53 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 14d1fefcbf4c..7affe1aa16da 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -713,7 +713,7 @@ xfs_buf_item_release(
 STATIC void
 xfs_buf_item_committing(
 	struct xfs_log_item	*lip,
-	xfs_lsn_t		commit_lsn)
+	uint64_t		seq)
 {
 	return xfs_buf_item_release(lip);
 }
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 8c1fdf37ee8f..74ca8fbbf1f3 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -188,7 +188,7 @@ xfs_qm_dquot_logitem_release(
 STATIC void
 xfs_qm_dquot_logitem_committing(
 	struct xfs_log_item	*lip,
-	xfs_lsn_t		commit_lsn)
+	uint64_t		seq)
 {
 	return xfs_qm_dquot_logitem_release(lip);
 }
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index dd33ef2d0e20..8b07408928a9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -118,8 +118,8 @@ xfs_dir_fsync(
 	return xfs_log_force_inode(ip);
 }
 
-static xfs_lsn_t
-xfs_fsync_lsn(
+static uint64_t
+xfs_fsync_seq(
 	struct xfs_inode	*ip,
 	bool			datasync)
 {
@@ -127,7 +127,7 @@ xfs_fsync_lsn(
 		return 0;
 	if (datasync && !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
 		return 0;
-	return ip->i_itemp->ili_last_lsn;
+	return ip->i_itemp->ili_commit_seq;
 }
 
 /*
@@ -150,12 +150,12 @@ xfs_fsync_flush_log(
 	int			*log_flushed)
 {
 	int			error = 0;
-	xfs_lsn_t		lsn;
+	uint64_t		seq;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	lsn = xfs_fsync_lsn(ip, datasync);
-	if (lsn) {
-		error = xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC,
+	seq = xfs_fsync_seq(ip, datasync);
+	if (seq) {
+		error = xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
 					  log_flushed);
 
 		spin_lock(&ip->i_itemp->ili_lock);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 95e3a5e6e5e2..bc3e27f9c7f2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2636,7 +2636,7 @@ xfs_iunpin(
 	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
 
 	/* Give the log a push to start the unpinning I/O */
-	xfs_log_force_lsn(ip->i_mount, ip->i_itemp->ili_last_lsn, 0, NULL);
+	xfs_log_force_seq(ip->i_mount, ip->i_itemp->ili_commit_seq, 0, NULL);
 
 }
 
@@ -3641,16 +3641,16 @@ int
 xfs_log_force_inode(
 	struct xfs_inode	*ip)
 {
-	xfs_lsn_t		lsn = 0;
+	uint64_t		seq = 0;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	if (xfs_ipincount(ip))
-		lsn = ip->i_itemp->ili_last_lsn;
+		seq = ip->i_itemp->ili_commit_seq;
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
-	if (!lsn)
+	if (!seq)
 		return 0;
-	return xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC, NULL);
+	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC, NULL);
 }
 
 /*
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6ff91e5bf3cd..7270a80f21dc 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -617,9 +617,9 @@ xfs_inode_item_committed(
 STATIC void
 xfs_inode_item_committing(
 	struct xfs_log_item	*lip,
-	xfs_lsn_t		commit_lsn)
+	uint64_t		seq)
 {
-	INODE_ITEM(lip)->ili_last_lsn = commit_lsn;
+	INODE_ITEM(lip)->ili_commit_seq = seq;
 	return xfs_inode_item_release(lip);
 }
 
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 4b926e32831c..e60125b88292 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -33,7 +33,7 @@ struct xfs_inode_log_item {
 	unsigned int		ili_fields;	   /* fields to be logged */
 	unsigned int		ili_fsync_fields;  /* logged since last fsync */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
-	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
+	uint64_t		ili_commit_seq;	   /* last transaction commit */
 };
 
 static inline int xfs_inode_clean(struct xfs_inode *ip)
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 08d68a6161ae..84cd9b6c6d1f 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3336,14 +3336,13 @@ xfs_log_force(
 }
 
 static int
-__xfs_log_force_lsn(
-	struct xfs_mount	*mp,
+xlog_force_lsn(
+	struct xlog		*log,
 	xfs_lsn_t		lsn,
 	uint			flags,
 	int			*log_flushed,
 	bool			already_slept)
 {
-	struct xlog		*log = mp->m_log;
 	struct xlog_in_core	*iclog;
 
 	spin_lock(&log->l_icloglock);
@@ -3376,8 +3375,6 @@ __xfs_log_force_lsn(
 		if (!already_slept &&
 		    (iclog->ic_prev->ic_state == XLOG_STATE_WANT_SYNC ||
 		     iclog->ic_prev->ic_state == XLOG_STATE_SYNCING)) {
-			XFS_STATS_INC(mp, xs_log_force_sleep);
-
 			xlog_wait(&iclog->ic_prev->ic_write_wait,
 					&log->l_icloglock);
 			return -EAGAIN;
@@ -3415,25 +3412,29 @@ __xfs_log_force_lsn(
  * to disk, that thread will wake up all threads waiting on the queue.
  */
 int
-xfs_log_force_lsn(
+xfs_log_force_seq(
 	struct xfs_mount	*mp,
-	xfs_lsn_t		lsn,
+	uint64_t		seq,
 	uint			flags,
 	int			*log_flushed)
 {
+	struct xlog		*log = mp->m_log;
+	xfs_lsn_t		lsn;
 	int			ret;
-	ASSERT(lsn != 0);
+	ASSERT(seq != 0);
 
 	XFS_STATS_INC(mp, xs_log_force);
-	trace_xfs_log_force(mp, lsn, _RET_IP_);
+	trace_xfs_log_force(mp, seq, _RET_IP_);
 
-	lsn = xlog_cil_force_lsn(mp->m_log, lsn);
+	lsn = xlog_cil_force_seq(log, seq);
 	if (lsn == NULLCOMMITLSN)
 		return 0;
 
-	ret = __xfs_log_force_lsn(mp, lsn, flags, log_flushed, false);
-	if (ret == -EAGAIN)
-		ret = __xfs_log_force_lsn(mp, lsn, flags, log_flushed, true);
+	ret = xlog_force_lsn(log, lsn, flags, log_flushed, false);
+	if (ret == -EAGAIN) {
+		XFS_STATS_INC(mp, xs_log_force_sleep);
+		ret = xlog_force_lsn(log, lsn, flags, log_flushed, true);
+	}
 	return ret;
 }
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 044e02cb8921..33ae53401060 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -106,7 +106,7 @@ struct xfs_item_ops;
 struct xfs_trans;
 
 int	  xfs_log_force(struct xfs_mount *mp, uint flags);
-int	  xfs_log_force_lsn(struct xfs_mount *mp, xfs_lsn_t lsn, uint flags,
+int	  xfs_log_force_seq(struct xfs_mount *mp, uint64_t seq, uint flags,
 		int *log_forced);
 int	  xfs_log_mount(struct xfs_mount	*mp,
 			struct xfs_buftarg	*log_target,
@@ -132,8 +132,6 @@ bool	xfs_log_writable(struct xfs_mount *mp);
 struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
 
-void	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
-				xfs_lsn_t *commit_lsn, bool regrant);
 void	xlog_cil_process_committed(struct list_head *list);
 bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 0a00c3c9610c..2fda8c4513b2 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -792,7 +792,7 @@ xlog_cil_push_work(
 	 * that higher sequences will wait for us to write out a commit record
 	 * before they do.
 	 *
-	 * xfs_log_force_lsn requires us to mirror the new sequence into the cil
+	 * xfs_log_force_seq requires us to mirror the new sequence into the cil
 	 * structure atomically with the addition of this sequence to the
 	 * committing list. This also ensures that we can do unlocked checks
 	 * against the current sequence in log forces without risking
@@ -1054,16 +1054,14 @@ xlog_cil_empty(
  * allowed again.
  */
 void
-xfs_log_commit_cil(
-	struct xfs_mount	*mp,
+xlog_cil_commit(
+	struct xlog		*log,
 	struct xfs_trans	*tp,
-	xfs_lsn_t		*commit_lsn,
+	uint64_t		*commit_seq,
 	bool			regrant)
 {
-	struct xlog		*log = mp->m_log;
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_log_item	*lip, *next;
-	xfs_lsn_t		xc_commit_lsn;
 
 	/*
 	 * Do all necessary memory allocation before we lock the CIL.
@@ -1077,10 +1075,6 @@ xfs_log_commit_cil(
 
 	xlog_cil_insert_items(log, tp);
 
-	xc_commit_lsn = cil->xc_ctx->sequence;
-	if (commit_lsn)
-		*commit_lsn = xc_commit_lsn;
-
 	if (regrant && !XLOG_FORCED_SHUTDOWN(log))
 		xfs_log_ticket_regrant(log, tp->t_ticket);
 	else
@@ -1103,8 +1097,10 @@ xfs_log_commit_cil(
 	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
 		xfs_trans_del_item(lip);
 		if (lip->li_ops->iop_committing)
-			lip->li_ops->iop_committing(lip, xc_commit_lsn);
+			lip->li_ops->iop_committing(lip, cil->xc_ctx->sequence);
 	}
+	if (commit_seq)
+		*commit_seq = cil->xc_ctx->sequence;
 
 	/* xlog_cil_push_background() releases cil->xc_ctx_lock */
 	xlog_cil_push_background(log);
@@ -1121,9 +1117,9 @@ xfs_log_commit_cil(
  * iclog flush is necessary following this call.
  */
 xfs_lsn_t
-xlog_cil_force_lsn(
+xlog_cil_force_seq(
 	struct xlog	*log,
-	xfs_lsn_t	sequence)
+	uint64_t	sequence)
 {
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_cil_ctx	*ctx;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 24acdc54e44e..59778cd5ecdd 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -234,7 +234,7 @@ struct xfs_cil;
 
 struct xfs_cil_ctx {
 	struct xfs_cil		*cil;
-	xfs_lsn_t		sequence;	/* chkpt sequence # */
+	uint64_t		sequence;	/* chkpt sequence # */
 	xfs_lsn_t		start_lsn;	/* first LSN of chkpt commit */
 	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
 	struct xlog_ticket	*ticket;	/* chkpt ticket */
@@ -272,10 +272,10 @@ struct xfs_cil {
 	struct xfs_cil_ctx	*xc_ctx;
 
 	spinlock_t		xc_push_lock ____cacheline_aligned_in_smp;
-	xfs_lsn_t		xc_push_seq;
+	uint64_t		xc_push_seq;
 	struct list_head	xc_committing;
 	wait_queue_head_t	xc_commit_wait;
-	xfs_lsn_t		xc_current_sequence;
+	uint64_t		xc_current_sequence;
 	struct work_struct	xc_push_work;
 	wait_queue_head_t	xc_push_wait;	/* background push throttle */
 } ____cacheline_aligned_in_smp;
@@ -552,19 +552,18 @@ int	xlog_cil_init(struct xlog *log);
 void	xlog_cil_init_post_recovery(struct xlog *log);
 void	xlog_cil_destroy(struct xlog *log);
 bool	xlog_cil_empty(struct xlog *log);
+void	xlog_cil_commit(struct xlog *log, struct xfs_trans *tp,
+			uint64_t *commit_seq, bool regrant);
 
 /*
  * CIL force routines
  */
-xfs_lsn_t
-xlog_cil_force_lsn(
-	struct xlog *log,
-	xfs_lsn_t sequence);
+xfs_lsn_t xlog_cil_force_seq(struct xlog *log, uint64_t sequence);
 
 static inline void
 xlog_cil_force(struct xlog *log)
 {
-	xlog_cil_force_lsn(log, log->l_cilp->xc_current_sequence);
+	xlog_cil_force_seq(log, log->l_cilp->xc_current_sequence);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 44f72c09c203..697703f3be48 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -849,7 +849,7 @@ __xfs_trans_commit(
 	bool			regrant)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	xfs_lsn_t		commit_lsn = -1;
+	uint64_t		commit_seq = 0;
 	int			error = 0;
 	int			sync = tp->t_flags & XFS_TRANS_SYNC;
 
@@ -891,7 +891,7 @@ __xfs_trans_commit(
 		xfs_trans_apply_sb_deltas(tp);
 	xfs_trans_apply_dquot_deltas(tp);
 
-	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
+	xlog_cil_commit(mp->m_log, tp, &commit_seq, regrant);
 
 	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	xfs_trans_free(tp);
@@ -901,7 +901,7 @@ __xfs_trans_commit(
 	 * log out now and wait for it.
 	 */
 	if (sync) {
-		error = xfs_log_force_lsn(mp, commit_lsn, XFS_LOG_SYNC, NULL);
+		error = xfs_log_force_seq(mp, commit_seq, XFS_LOG_SYNC, NULL);
 		XFS_STATS_INC(mp, xs_trans_sync);
 	} else {
 		XFS_STATS_INC(mp, xs_trans_async);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 8b03fbfe9a1b..d223d4f4e429 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -43,7 +43,7 @@ struct xfs_log_item {
 	struct list_head		li_cil;		/* CIL pointers */
 	struct xfs_log_vec		*li_lv;		/* active log vector */
 	struct xfs_log_vec		*li_lv_shadow;	/* standby vector */
-	xfs_lsn_t			li_seq;		/* CIL commit seq */
+	uint64_t			li_seq;		/* CIL commit seq */
 };
 
 /*
@@ -69,7 +69,7 @@ struct xfs_item_ops {
 	void (*iop_pin)(struct xfs_log_item *);
 	void (*iop_unpin)(struct xfs_log_item *, int remove);
 	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
-	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
+	void (*iop_committing)(struct xfs_log_item *lip, uint64_t seq);
 	void (*iop_release)(struct xfs_log_item *);
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
 	int (*iop_recover)(struct xfs_log_item *lip,
-- 
2.28.0

