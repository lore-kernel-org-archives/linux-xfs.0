Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643B6A923
	for <linux-xfs@vger.kernel.org>; Fri, 20 Jun 2025 07:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750403303; cv=none; b=Y45juFeXaeLcAPjp7BTb0m0l0AT0HX4rKtJNebvr8YEpNowq+MOmAvkvgiqDtHN0rEhfh8jfi2ut5TbZbIUq2irVDJNGuBgu1/KHbfv9A2fXSusngHWdouoDG26RSb99yaEkhI+mpPDKxwlYrV9hsO+UAthgCMG6G/J9b0jk6Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750403303; c=relaxed/simple;
	bh=vUHbD8HzUn+C200Qa2oNKS6Gq2E6FVFO61j+4y2MZ10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9EniTon8qiInmHoyWWZ1vVs8atSr3ThFlw5RzfCjXo5lm8IfsSyEO9U4CFivpjnzKpDgvi5tgPw382ro4UcWDUMIPXD7e8wGZwD47Rybz0rjslTsgzAi/YkVXy6KkullW2tZ4TSZg3hllJWqFpzRQsDj1LT7TJ5ash8fKdKIu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZChz03BE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZChz03BE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1788C4CEEE;
	Fri, 20 Jun 2025 07:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750403303;
	bh=vUHbD8HzUn+C200Qa2oNKS6Gq2E6FVFO61j+4y2MZ10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZChz03BEgAtSkaP9NLPeIEdKoz6oX/y6fXHwflWLTTHKRPkTY4bGz2AJyigkpmoIT
	 SdYWR8I3dE45XhxhubQQMZaYs58DfV92/M6cltUtlsLTr7+UDfB3JkEm22au9dFbc0
	 AqiC1XXXuhf8uYi8cxhfTEVqdrKN3eFDnVZI6W3HSYRSb1rtqdR9h3oRW7Fx1QoLAi
	 RVMmewS/b/Fwgq/ssc47G3DpGCtRppo4D2yYj2WmQPtv8vwoi8myqci5IYN7YQSgrL
	 yrmM0rDSEqFglcZGOhUrnAPLQVeXXzjy0FCpSaPtFQwRm8+xKctBbDgBJm91kBrHMH
	 XGp1qZsB0n4Gw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	david@fromorbit.com,
	djwong@kernel.org
Subject: [PATCH 1/2] xfs: replace iclogs circular list with a list_head
Date: Fri, 20 Jun 2025 09:07:59 +0200
Message-ID: <20250620070813.919516-2-cem@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620070813.919516-1-cem@kernel.org>
References: <20250620070813.919516-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Instead of using ic_{next,prev}, replace it with list_head framework
to simplify its use.

This has a small logic change:

So far log->l_iclog holds the current iclog pointer and moves this
pointer sequentially to the next iclog in the ring.

Instead of keeping a separated iclog pointer as the 'current' one, make
the first list element the current iclog.
Once we mark the iclog as WANT_SYNC, just move it to the list tail,
making the the next iclog as the 'current' one.

This also kills xlog_in_core_t typedef.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_log.c      | 132 ++++++++++++++++++------------------------
 fs/xfs/xfs_log_cil.c  |  13 +++--
 fs/xfs/xfs_log_priv.h |  11 ++--
 3 files changed, 70 insertions(+), 86 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 793468b4d30d..dbd8c50d01fd 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -476,8 +476,7 @@ xlog_state_shutdown_callbacks(
 	struct xlog_in_core	*iclog;
 	LIST_HEAD(cb_list);
 
-	iclog = log->l_iclog;
-	do {
+	list_for_each_entry(iclog, &log->l_iclogs, ic_list) {
 		if (atomic_read(&iclog->ic_refcnt)) {
 			/* Reference holder will re-run iclog callbacks. */
 			continue;
@@ -490,7 +489,7 @@ xlog_state_shutdown_callbacks(
 		spin_lock(&log->l_icloglock);
 		wake_up_all(&iclog->ic_write_wait);
 		wake_up_all(&iclog->ic_force_wait);
-	} while ((iclog = iclog->ic_next) != log->l_iclog);
+	}
 
 	wake_up_all(&log->l_flush_wait);
 }
@@ -810,13 +809,11 @@ xlog_force_iclog(
 static void
 xlog_wait_iclog_completion(struct xlog *log)
 {
-	int		i;
-	struct xlog_in_core	*iclog = log->l_iclog;
+	struct xlog_in_core	*iclog;
 
-	for (i = 0; i < log->l_iclog_bufs; i++) {
+	list_for_each_entry(iclog, &log->l_iclogs, ic_list) {
 		down(&iclog->ic_sema);
 		up(&iclog->ic_sema);
-		iclog = iclog->ic_next;
 	}
 }
 
@@ -920,7 +917,7 @@ xlog_unmount_write(
 		xfs_alert(mp, "%s: unmount record failed", __func__);
 
 	spin_lock(&log->l_icloglock);
-	iclog = log->l_iclog;
+	iclog = list_first_entry(&log->l_iclogs, struct xlog_in_core, ic_list);
 	error = xlog_force_iclog(iclog);
 	xlog_wait_on_iclog(iclog);
 
@@ -934,12 +931,12 @@ static void
 xfs_log_unmount_verify_iclog(
 	struct xlog		*log)
 {
-	struct xlog_in_core	*iclog = log->l_iclog;
+	struct xlog_in_core	*iclog;
 
-	do {
+	list_for_each_entry(iclog, &log->l_iclogs, ic_list) {
 		ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
 		ASSERT(iclog->ic_offset == 0);
-	} while ((iclog = iclog->ic_next) != log->l_iclog);
+	}
 }
 
 /*
@@ -1368,8 +1365,7 @@ xlog_alloc_log(
 {
 	struct xlog		*log;
 	xlog_rec_header_t	*head;
-	xlog_in_core_t		**iclogp;
-	xlog_in_core_t		*iclog, *prev_iclog=NULL;
+	struct xlog_in_core	*iclog, *tmp;
 	int			i;
 	int			error = -ENOMEM;
 	uint			log2_size = 0;
@@ -1435,13 +1431,13 @@ xlog_alloc_log(
 	spin_lock_init(&log->l_icloglock);
 	init_waitqueue_head(&log->l_flush_wait);
 
-	iclogp = &log->l_iclog;
+	INIT_LIST_HEAD(&log->l_iclogs);
 	/*
 	 * The amount of memory to allocate for the iclog structure is
 	 * rather funky due to the way the structure is defined.  It is
 	 * done this way so that we can use different sizes for machines
 	 * with different amounts of memory.  See the definition of
-	 * xlog_in_core_t in xfs_log_priv.h for details.
+	 * xlog_in_core in xfs_log_priv.h for details.
 	 */
 	ASSERT(log->l_iclog_size >= 4096);
 	for (i = 0; i < log->l_iclog_bufs; i++) {
@@ -1453,10 +1449,6 @@ xlog_alloc_log(
 		if (!iclog)
 			goto out_free_iclog;
 
-		*iclogp = iclog;
-		iclog->ic_prev = prev_iclog;
-		prev_iclog = iclog;
-
 		iclog->ic_data = kvzalloc(log->l_iclog_size,
 				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 		if (!iclog->ic_data)
@@ -1483,10 +1475,8 @@ xlog_alloc_log(
 		INIT_WORK(&iclog->ic_end_io_work, xlog_ioend_work);
 		sema_init(&iclog->ic_sema, 1);
 
-		iclogp = &iclog->ic_next;
+		list_add(&iclog->ic_list, &log->l_iclogs);
 	}
-	*iclogp = log->l_iclog;			/* complete ring */
-	log->l_iclog->ic_prev = prev_iclog;	/* re-write 1st prev ptr */
 
 	log->l_ioend_workqueue = alloc_workqueue("xfs-log/%s",
 			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM |
@@ -1503,12 +1493,10 @@ xlog_alloc_log(
 out_destroy_workqueue:
 	destroy_workqueue(log->l_ioend_workqueue);
 out_free_iclog:
-	for (iclog = log->l_iclog; iclog; iclog = prev_iclog) {
-		prev_iclog = iclog->ic_next;
+	list_for_each_entry_safe(iclog, tmp, &log->l_iclogs, ic_list) {
+		list_del(&iclog->ic_list);
 		kvfree(iclog->ic_data);
 		kfree(iclog);
-		if (prev_iclog == log->l_iclog)
-			break;
 	}
 out_free_log:
 	kfree(log);
@@ -1844,10 +1832,9 @@ xlog_sync(
  */
 STATIC void
 xlog_dealloc_log(
-	struct xlog	*log)
+	struct xlog		*log)
 {
-	xlog_in_core_t	*iclog, *next_iclog;
-	int		i;
+	struct xlog_in_core	*iclog, *tmp;
 
 	/*
 	 * Destroy the CIL after waiting for iclog IO completion because an
@@ -1856,12 +1843,10 @@ xlog_dealloc_log(
 	 */
 	xlog_cil_destroy(log);
 
-	iclog = log->l_iclog;
-	for (i = 0; i < log->l_iclog_bufs; i++) {
-		next_iclog = iclog->ic_next;
+	list_for_each_entry_safe(iclog, tmp, &log->l_iclogs, ic_list) {
+		list_del(&iclog->ic_list);
 		kvfree(iclog->ic_data);
 		kfree(iclog);
-		iclog = next_iclog;
 	}
 
 	log->l_mp->m_log = NULL;
@@ -2332,9 +2317,9 @@ xlog_state_activate_iclogs(
 	struct xlog		*log,
 	int			*iclogs_changed)
 {
-	struct xlog_in_core	*iclog = log->l_iclog;
+	struct xlog_in_core	*iclog;
 
-	do {
+	list_for_each_entry(iclog, &log->l_iclogs, ic_list) {
 		if (iclog->ic_state == XLOG_STATE_DIRTY)
 			xlog_state_activate_iclog(iclog, iclogs_changed);
 		/*
@@ -2343,7 +2328,7 @@ xlog_state_activate_iclogs(
 		 */
 		else if (iclog->ic_state != XLOG_STATE_ACTIVE)
 			break;
-	} while ((iclog = iclog->ic_next) != log->l_iclog);
+	}
 }
 
 static int
@@ -2404,10 +2389,10 @@ STATIC xfs_lsn_t
 xlog_get_lowest_lsn(
 	struct xlog		*log)
 {
-	struct xlog_in_core	*iclog = log->l_iclog;
+	struct xlog_in_core	*iclog;
 	xfs_lsn_t		lowest_lsn = 0, lsn;
 
-	do {
+	list_for_each_entry(iclog, &log->l_iclogs, ic_list) {
 		if (iclog->ic_state == XLOG_STATE_ACTIVE ||
 		    iclog->ic_state == XLOG_STATE_DIRTY)
 			continue;
@@ -2415,7 +2400,7 @@ xlog_get_lowest_lsn(
 		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 		if ((lsn && !lowest_lsn) || XFS_LSN_CMP(lsn, lowest_lsn) < 0)
 			lowest_lsn = lsn;
-	} while ((iclog = iclog->ic_next) != log->l_iclog);
+	}
 
 	return lowest_lsn;
 }
@@ -2486,19 +2471,17 @@ xlog_state_do_iclog_callbacks(
 		__releases(&log->l_icloglock)
 		__acquires(&log->l_icloglock)
 {
-	struct xlog_in_core	*first_iclog = log->l_iclog;
-	struct xlog_in_core	*iclog = first_iclog;
+	struct xlog_in_core	*iclog;
 	bool			ran_callback = false;
 
-	do {
+	list_for_each_entry(iclog, &log->l_iclogs, ic_list) {
 		LIST_HEAD(cb_list);
 
 		if (xlog_state_iodone_process_iclog(log, iclog))
 			break;
-		if (iclog->ic_state != XLOG_STATE_CALLBACK) {
-			iclog = iclog->ic_next;
+		if (iclog->ic_state != XLOG_STATE_CALLBACK)
 			continue;
-		}
+
 		list_splice_init(&iclog->ic_callbacks, &cb_list);
 		spin_unlock(&log->l_icloglock);
 
@@ -2509,8 +2492,7 @@ xlog_state_do_iclog_callbacks(
 
 		spin_lock(&log->l_icloglock);
 		xlog_state_clean_iclog(log, iclog);
-		iclog = iclog->ic_next;
-	} while (iclog != first_iclog);
+	}
 
 	return ran_callback;
 }
@@ -2526,6 +2508,7 @@ xlog_state_do_callback(
 {
 	int			flushcnt = 0;
 	int			repeats = 0;
+	struct xlog_in_core	*iclog;
 
 	spin_lock(&log->l_icloglock);
 	while (xlog_state_do_iclog_callbacks(log)) {
@@ -2541,7 +2524,8 @@ xlog_state_do_callback(
 		}
 	}
 
-	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE)
+	iclog = list_first_entry(&log->l_iclogs, struct xlog_in_core, ic_list);
+	if (iclog->ic_state == XLOG_STATE_ACTIVE)
 		wake_up_all(&log->l_flush_wait);
 
 	spin_unlock(&log->l_icloglock);
@@ -2610,9 +2594,9 @@ xlog_state_get_iclog_space(
 	struct xlog_ticket	*ticket,
 	int			*logoffsetp)
 {
-	int		  log_offset;
-	xlog_rec_header_t *head;
-	xlog_in_core_t	  *iclog;
+	int			log_offset;
+	xlog_rec_header_t	*head;
+	struct xlog_in_core	*iclog;
 
 restart:
 	spin_lock(&log->l_icloglock);
@@ -2621,7 +2605,7 @@ xlog_state_get_iclog_space(
 		return -EIO;
 	}
 
-	iclog = log->l_iclog;
+	iclog = list_first_entry(&log->l_iclogs, struct xlog_in_core, ic_list);
 	if (iclog->ic_state != XLOG_STATE_ACTIVE) {
 		XFS_STATS_INC(log->l_mp, xs_log_noiclogs);
 
@@ -2778,8 +2762,9 @@ xfs_log_ticket_ungrant(
 }
 
 /*
- * This routine will mark the current iclog in the ring as WANT_SYNC and move
- * the current iclog pointer to the next iclog in the ring.
+ * The current iclog is always the first one in the ring.
+ * This routine will mark the current iclog as WANT_SYNC and move it to
+ * the tail of the ring, making the next iclog the current active.
  */
 void
 xlog_state_switch_iclogs(
@@ -2822,8 +2807,8 @@ xlog_state_switch_iclogs(
 		if (log->l_curr_cycle == XLOG_HEADER_MAGIC_NUM)
 			log->l_curr_cycle++;
 	}
-	ASSERT(iclog == log->l_iclog);
-	log->l_iclog = iclog->ic_next;
+	ASSERT(list_is_first(&iclog->ic_list, &log->l_iclogs));
+	list_move_tail(&iclog->ic_list, &log->l_iclogs);
 }
 
 /*
@@ -2899,7 +2884,7 @@ xfs_log_force(
 	if (xlog_is_shutdown(log))
 		goto out_error;
 
-	iclog = log->l_iclog;
+	iclog = list_first_entry(&log->l_iclogs, struct xlog_in_core, ic_list);
 	trace_xlog_iclog_force(iclog, _RET_IP_);
 
 	if (iclog->ic_state == XLOG_STATE_DIRTY ||
@@ -2913,7 +2898,7 @@ xfs_log_force(
 		 * is nothing to sync out. Otherwise, we attach ourselves to the
 		 * previous iclog and go to sleep.
 		 */
-		iclog = iclog->ic_prev;
+		iclog = list_prev_entry_circular(iclog, &log->l_iclogs, ic_list);
 	} else if (iclog->ic_state == XLOG_STATE_ACTIVE) {
 		if (atomic_read(&iclog->ic_refcnt) == 0) {
 			/* We have exclusive access to this iclog. */
@@ -2975,21 +2960,22 @@ xlog_force_lsn(
 	int			*log_flushed,
 	bool			already_slept)
 {
-	struct xlog_in_core	*iclog;
+	struct xlog_in_core	*iclog, *icprev;
 	bool			completed;
 
 	spin_lock(&log->l_icloglock);
 	if (xlog_is_shutdown(log))
 		goto out_error;
 
-	iclog = log->l_iclog;
+	iclog = list_first_entry(&log->l_iclogs, struct xlog_in_core, ic_list);
 	while (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
 		trace_xlog_iclog_force_lsn(iclog, _RET_IP_);
-		iclog = iclog->ic_next;
-		if (iclog == log->l_iclog)
+		iclog = list_next_entry(iclog, ic_list);
+		if (list_entry_is_head(iclog, &log->l_iclogs, ic_list))
 			goto out_unlock;
 	}
 
+	icprev = list_prev_entry_circular(iclog, &log->l_iclogs, ic_list);
 	switch (iclog->ic_state) {
 	case XLOG_STATE_ACTIVE:
 		/*
@@ -3008,9 +2994,9 @@ xlog_force_lsn(
 		 * will go out then.
 		 */
 		if (!already_slept &&
-		    (iclog->ic_prev->ic_state == XLOG_STATE_WANT_SYNC ||
-		     iclog->ic_prev->ic_state == XLOG_STATE_SYNCING)) {
-			xlog_wait(&iclog->ic_prev->ic_write_wait,
+		    (icprev->ic_state == XLOG_STATE_WANT_SYNC ||
+		     icprev->ic_state == XLOG_STATE_SYNCING)) {
+			xlog_wait(&icprev->ic_write_wait,
 					&log->l_icloglock);
 			return -EAGAIN;
 		}
@@ -3323,7 +3309,7 @@ xlog_verify_iclog(
 	int			count)
 {
 	xlog_op_header_t	*ophead;
-	xlog_in_core_t		*icptr;
+	struct xlog_in_core	*icptr;
 	xlog_in_core_2_t	*xhdr;
 	void			*base_ptr, *ptr, *p;
 	ptrdiff_t		field_offset;
@@ -3333,12 +3319,8 @@ xlog_verify_iclog(
 
 	/* check validity of iclog pointers */
 	spin_lock(&log->l_icloglock);
-	icptr = log->l_iclog;
-	for (i = 0; i < log->l_iclog_bufs; i++, icptr = icptr->ic_next)
+	list_for_each_entry(icptr, &log->l_iclogs, ic_list)
 		ASSERT(icptr);
-
-	if (icptr != log->l_iclog)
-		xfs_emerg(log->l_mp, "%s: corrupt iclog ring", __func__);
 	spin_unlock(&log->l_icloglock);
 
 	/* check log magic numbers */
@@ -3531,17 +3513,15 @@ STATIC int
 xlog_iclogs_empty(
 	struct xlog	*log)
 {
-	xlog_in_core_t	*iclog;
+	struct xlog_in_core	*iclog;
 
-	iclog = log->l_iclog;
-	do {
+	list_for_each_entry(iclog, &log->l_iclogs, ic_list) {
 		/* endianness does not matter here, zero is zero in
 		 * any language.
 		 */
 		if (iclog->ic_header.h_num_logops)
 			return 0;
-		iclog = iclog->ic_next;
-	} while (iclog != log->l_iclog);
+	}
 	return 1;
 }
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f66d2d430e4f..0edf3f466764 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1463,16 +1463,21 @@ xlog_cil_push_work(
 	 */
 	spin_lock(&log->l_icloglock);
 	if (ctx->start_lsn != ctx->commit_lsn) {
-		xfs_lsn_t	plsn;
+		xfs_lsn_t		plsn;
+		struct xlog_in_core	*icprev;
 
-		plsn = be64_to_cpu(ctx->commit_iclog->ic_prev->ic_header.h_lsn);
+		icprev = list_prev_entry_circular(ctx->commit_iclog,
+						  &log->l_iclogs,
+						  ic_list);
+
+		plsn = be64_to_cpu(icprev->ic_header.h_lsn);
 		if (plsn && XFS_LSN_CMP(plsn, ctx->commit_lsn) < 0) {
 			/*
 			 * Waiting on ic_force_wait orders the completion of
-			 * iclogs older than ic_prev. Hence we only need to wait
+			 * iclogs older than icprev. Hence we only need to wait
 			 * on the most recent older iclog here.
 			 */
-			xlog_wait_on_iclog(ctx->commit_iclog->ic_prev);
+			xlog_wait_on_iclog(icprev);
 			spin_lock(&log->l_icloglock);
 		}
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 39a102cc1b43..27912a9b7340 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -163,7 +163,7 @@ typedef struct xlog_ticket {
  * - ic_data follows, so a write to disk can start at the beginning of
  *	the iclog.
  * - ic_forcewait is used to implement synchronous forcing of the iclog to disk.
- * - ic_next is the pointer to the next iclog in the ring.
+ * - ic_list is the list member of iclog ring, headed by log->l_iclogs.
  * - ic_log is a pointer back to the global log structure.
  * - ic_size is the full size of the log buffer, minus the cycle headers.
  * - ic_offset is the current number of bytes written to in this iclog.
@@ -183,11 +183,10 @@ typedef struct xlog_ticket {
  * We'll put all the read-only and l_icloglock fields in the first cacheline,
  * and move everything else out to subsequent cachelines.
  */
-typedef struct xlog_in_core {
+struct xlog_in_core {
 	wait_queue_head_t	ic_force_wait;
 	wait_queue_head_t	ic_write_wait;
-	struct xlog_in_core	*ic_next;
-	struct xlog_in_core	*ic_prev;
+	struct list_head	ic_list;
 	struct xlog		*ic_log;
 	u32			ic_size;
 	u32			ic_offset;
@@ -207,7 +206,7 @@ typedef struct xlog_in_core {
 	struct work_struct	ic_end_io_work;
 	struct bio		ic_bio;
 	struct bio_vec		ic_bvec[];
-} xlog_in_core_t;
+};
 
 /*
  * The CIL context is used to aggregate per-transaction details as well be
@@ -422,7 +421,7 @@ struct xlog {
 						/* waiting for iclog flush */
 	int			l_covered_state;/* state of "covering disk
 						 * log entries" */
-	xlog_in_core_t		*l_iclog;       /* head log queue	*/
+	struct list_head	l_iclogs;       /* head log queue */
 	spinlock_t		l_icloglock;    /* grab to change iclog state */
 	int			l_curr_cycle;   /* Cycle number of log writes */
 	int			l_prev_cycle;   /* Cycle number before last
-- 
2.49.0

