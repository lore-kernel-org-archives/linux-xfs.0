Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E0C39AEB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 07:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718868139; cv=none; b=NRL37EyuORSKh6eyI+aewKXEgdXfTlUYL9svNeWApk2T0HFsxlUDgnSon0y3khlLcSH3UHG2zCeCnkS5CRakBygLbwno6DySIiNImP8Yws4irnRHTh/gpIM2cW9ZOQn/nx5AHctJj2nlM5UvRjs2elBmo/H9kDbNA7hVD2MeA9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718868139; c=relaxed/simple;
	bh=6f/ClMyIGiTyHAEn6J4ZMziitQJ0037pC+gtFwG2KUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oeDakTCn7mBa3ERx5cIYQlg+Qs7MNtySwuepynMfw/bf6jCRMjDBhijCoKpr6epIfwJO768S1714I5Icq3DthRCLYC1gdjm5OyNw/ru7jVcDBe0P+8GyiC2Kx4FBjDzRxV3lVSCRXUwvPMhyXc3YAUcntJf1mg54cLR5e+XkZCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y3ez5AHO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y3ez5AHO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hmPXPnYafwXrkDqhRPaztWm8Yxt0HLkTtQl33Gt2XfU=; b=Y3ez5AHODMkOwyGnhz8EF/l1so
	sY7qHrnMrTM0yEYsJ27CYFbnZEg8YU3spXMISiRBG2Ha1XawB0L8mYzDR8OD1XY6mFqO+DGmCj2Yh
	NxSgz+6/iKKzxMjvKQeAgG/leaDZFKZIHV+egkmrkRz1mlE2CBrRV3hKi95bJY1xO7PFlndfWa5DH
	BSo6esxc3+O3YUurxjHy+M0QhDD326wLO/KXHJ9UBCOP7q1gGoWvLMA0Klx4lzuniz2M6vaeBB9QS
	4FElK2uDs/xg/TCT8rv0LcD0QTCwWjOS0Sk3fJASozU/O0y2VcwJB2lF8vRNn1JPOowD9FyqgLTLC
	eNSNr1Ng==;
Received: from 2a02-8389-2341-5b80-3a9c-dc0d-9615-f1ed.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3a9c:dc0d:9615:f1ed] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKC7c-00000003xeO-3MUt;
	Thu, 20 Jun 2024 07:22:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 10/11] xfs: grant heads track byte counts, not LSNs
Date: Thu, 20 Jun 2024 09:21:27 +0200
Message-ID: <20240620072146.530267-11-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240620072146.530267-1-hch@lst.de>
References: <20240620072146.530267-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Dave Chinner <dchinner@redhat.com>

The grant heads in the log track the space reserved in the log for
running transactions. They do this by tracking how far ahead of the
tail that the reservation has reached, and the units for doing this
are {cycle,bytes} for the reserve head rather than {cycle,blocks}
which are normal used by LSNs.

This is annoyingly complex because we have to split, crack and
combined these tuples for any calculation we do to determine log
space and targets. This is computationally expensive as well as
difficult to do atomically and locklessly, as well as limiting the
size of the log to 2^32 bytes.

Really, though, all the grant heads are tracking is how much space
is currently available for use in the log. We can track this as a
simply byte count - we just don't care what the actual physical
location in the log the head and tail are at, just how much space we
have remaining before the head and tail overlap.

So, convert the grant heads to track the byte reservations that are
active rather than the current (cycle, offset) tuples. This means an
empty log has zero bytes consumed, and a full log is when the
reservations reach the size of the log minus the space consumed by
the AIL.

This greatly simplifies the accounting and checks for whether there
is space available. We no longer need to crack or combine LSNs to
determine how much space the log has left, nor do we need to look at
the head or tail of the log to determine how close to full we are.

There is, however, a complexity that needs to be handled. We know
how much space is being tracked in the AIL now via log->l_tail_space
and the log tickets track active reservations and return the unused
portions to the grant heads when ungranted.  Unfortunately, we don't
track the used portion of the grant, so when we transfer log items
from the CIL to the AIL, the space accounted to the grant heads is
transferred to the log tail space.  Hence when we move the AIL head
forwards on item insert, we have to remove that space from the grant
heads.

We also remove the xlog_verify_grant_tail() debug function as it is
no longer useful. The check it performs has been racy since delayed
logging was introduced, but now it is clearly only detecting false
positives so remove it.

The result of this substantially simpler accounting algorithm is an
increase in sustained transaction rate from ~1.3 million
transactions/s to ~1.9 million transactions/s with no increase in
CPU usage. We also remove the 32 bit space limitation on the grant
heads, which will allow us to increase the journal size beyond 2GB
in future.

Note that this renames the sysfs files exposing the log grant space
now that the values are exported in bytes.  This allows xfstests
to auto-detect the old or new ABI.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[hch: move xlog_grant_sub_space out of line,
      update the xlog_grant_{add,sub}_space prototypes,
      rename the sysfs files to allow auto-detection in xfstests]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/ABI/testing/sysfs-fs-xfs |  18 +-
 fs/xfs/xfs_log.c                       | 246 +++++++++----------------
 fs/xfs/xfs_log_cil.c                   |  12 ++
 fs/xfs/xfs_log_priv.h                  |  33 +---
 fs/xfs/xfs_log_recover.c               |   4 -
 fs/xfs/xfs_sysfs.c                     |  29 +--
 fs/xfs/xfs_trace.h                     |  34 ++--
 7 files changed, 138 insertions(+), 238 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-xfs b/Documentation/ABI/testing/sysfs-fs-xfs
index 82d8e2f79834b5..7da4de948b46e7 100644
--- a/Documentation/ABI/testing/sysfs-fs-xfs
+++ b/Documentation/ABI/testing/sysfs-fs-xfs
@@ -15,25 +15,23 @@ Description:
 		The log sequence number (LSN) of the current tail of the
 		log. The LSN is exported in "cycle:basic block" format.
 
-What:		/sys/fs/xfs/<disk>/log/reserve_grant_head
-Date:		July 2014
-KernelVersion:	3.17
+What:		/sys/fs/xfs/<disk>/log/reserve_grant_head_bytes
+Date:		June 2024
+KernelVersion:	6.11
 Contact:	linux-xfs@vger.kernel.org
 Description:
 		The current state of the log reserve grant head. It
 		represents the total log reservation of all currently
-		outstanding transactions. The grant head is exported in
-		"cycle:bytes" format.
+		outstanding transactions in bytes.
 Users:		xfstests
 
-What:		/sys/fs/xfs/<disk>/log/write_grant_head
-Date:		July 2014
-KernelVersion:	3.17
+What:		/sys/fs/xfs/<disk>/log/write_grant_head_bytes
+Date:		June 2024
+KernelVersion:	6.11
 Contact:	linux-xfs@vger.kernel.org
 Description:
 		The current state of the log write grant head. It
 		represents the total log reservation of all currently
 		outstanding transactions, including regrants due to
-		rolling transactions. The grant head is exported in
-		"cycle:bytes" format.
+		rolling transactions in bytes.
 Users:		xfstests
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0e50b370f0e4c7..817ea7e0a8ab54 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -53,9 +53,6 @@ xlog_sync(
 	struct xlog_ticket	*ticket);
 #if defined(DEBUG)
 STATIC void
-xlog_verify_grant_tail(
-	struct xlog *log);
-STATIC void
 xlog_verify_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
@@ -65,7 +62,6 @@ xlog_verify_tail_lsn(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog);
 #else
-#define xlog_verify_grant_tail(a)
 #define xlog_verify_iclog(a,b,c)
 #define xlog_verify_tail_lsn(a,b)
 #endif
@@ -133,125 +129,64 @@ xlog_prepare_iovec(
 	return buf;
 }
 
-static void
+static inline void
 xlog_grant_sub_space(
-	struct xlog		*log,
 	struct xlog_grant_head	*head,
-	int			bytes)
+	int64_t			bytes)
 {
-	int64_t	head_val = atomic64_read(&head->grant);
-	int64_t new, old;
-
-	do {
-		int	cycle, space;
-
-		xlog_crack_grant_head_val(head_val, &cycle, &space);
-
-		space -= bytes;
-		if (space < 0) {
-			space += log->l_logsize;
-			cycle--;
-		}
-
-		old = head_val;
-		new = xlog_assign_grant_head_val(cycle, space);
-		head_val = atomic64_cmpxchg(&head->grant, old, new);
-	} while (head_val != old);
+	atomic64_sub(bytes, &head->grant);
 }
 
-static void
+static inline void
 xlog_grant_add_space(
-	struct xlog		*log,
 	struct xlog_grant_head	*head,
-	int			bytes)
+	int64_t			bytes)
 {
-	int64_t	head_val = atomic64_read(&head->grant);
-	int64_t new, old;
-
-	do {
-		int		tmp;
-		int		cycle, space;
-
-		xlog_crack_grant_head_val(head_val, &cycle, &space);
-
-		tmp = log->l_logsize - space;
-		if (tmp > bytes)
-			space += bytes;
-		else {
-			space = bytes - tmp;
-			cycle++;
-		}
-
-		old = head_val;
-		new = xlog_assign_grant_head_val(cycle, space);
-		head_val = atomic64_cmpxchg(&head->grant, old, new);
-	} while (head_val != old);
+	atomic64_add(bytes, &head->grant);
 }
 
-STATIC void
+static void
 xlog_grant_head_init(
 	struct xlog_grant_head	*head)
 {
-	xlog_assign_grant_head(&head->grant, 1, 0);
+	atomic64_set(&head->grant, 0);
 	INIT_LIST_HEAD(&head->waiters);
 	spin_lock_init(&head->lock);
 }
 
+void
+xlog_grant_return_space(
+	struct xlog	*log,
+	xfs_lsn_t	old_head,
+	xfs_lsn_t	new_head)
+{
+	int64_t		diff = xlog_lsn_sub(log, new_head, old_head);
+
+	xlog_grant_sub_space(&log->l_reserve_head, diff);
+	xlog_grant_sub_space(&log->l_write_head, diff);
+}
+
 /*
- * Return the space in the log between the tail and the head.  The head
- * is passed in the cycle/bytes formal parms.  In the special case where
- * the reserve head has wrapped passed the tail, this calculation is no
- * longer valid.  In this case, just return 0 which means there is no space
- * in the log.  This works for all places where this function is called
- * with the reserve head.  Of course, if the write head were to ever
- * wrap the tail, we should blow up.  Rather than catch this case here,
- * we depend on other ASSERTions in other parts of the code.   XXXmiken
- *
- * If reservation head is behind the tail, we have a problem. Warn about it,
- * but then treat it as if the log is empty.
- *
- * If the log is shut down, the head and tail may be invalid or out of whack, so
- * shortcut invalidity asserts in this case so that we don't trigger them
- * falsely.
+ * Return the space in the log between the tail and the head.  In the case where
+ * we have overrun available reservation space, return 0. The memory barrier
+ * pairs with the smp_wmb() in xlog_cil_ail_insert() to ensure that grant head
+ * vs tail space updates are seen in the correct order and hence avoid
+ * transients as space is transferred from the grant heads to the AIL on commit
+ * completion.
  */
-static int
+static uint64_t
 xlog_grant_space_left(
 	struct xlog		*log,
 	struct xlog_grant_head	*head)
 {
-	int			tail_bytes;
-	int			tail_cycle;
-	int			head_cycle;
-	int			head_bytes;
-
-	xlog_crack_grant_head(&head->grant, &head_cycle, &head_bytes);
-	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_bytes);
-	tail_bytes = BBTOB(tail_bytes);
-	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
-		return log->l_logsize - (head_bytes - tail_bytes);
-	if (tail_cycle + 1 < head_cycle)
-		return 0;
-
-	/* Ignore potential inconsistency when shutdown. */
-	if (xlog_is_shutdown(log))
-		return log->l_logsize;
-
-	if (tail_cycle < head_cycle) {
-		ASSERT(tail_cycle == (head_cycle - 1));
-		return tail_bytes - head_bytes;
-	}
+	int64_t			free_bytes;
 
-	/*
-	 * The reservation head is behind the tail. In this case we just want to
-	 * return the size of the log as the amount of space left.
-	 */
-	xfs_alert(log->l_mp, "xlog_grant_space_left: head behind tail");
-	xfs_alert(log->l_mp, "  tail_cycle = %d, tail_bytes = %d",
-		  tail_cycle, tail_bytes);
-	xfs_alert(log->l_mp, "  GH   cycle = %d, GH   bytes = %d",
-		  head_cycle, head_bytes);
-	ASSERT(0);
-	return log->l_logsize;
+	smp_rmb();	/* paired with smp_wmb in xlog_cil_ail_insert() */
+	free_bytes = log->l_logsize - READ_ONCE(log->l_tail_space) -
+			atomic64_read(&head->grant);
+	if (free_bytes > 0)
+		return free_bytes;
+	return 0;
 }
 
 STATIC void
@@ -453,9 +388,8 @@ xfs_log_regrant(
 	if (error)
 		goto out_error;
 
-	xlog_grant_add_space(log, &log->l_write_head, need_bytes);
+	xlog_grant_add_space(&log->l_write_head, need_bytes);
 	trace_xfs_log_regrant_exit(log, tic);
-	xlog_verify_grant_tail(log);
 	return 0;
 
 out_error:
@@ -504,10 +438,9 @@ xfs_log_reserve(
 	if (error)
 		goto out_error;
 
-	xlog_grant_add_space(log, &log->l_reserve_head, need_bytes);
-	xlog_grant_add_space(log, &log->l_write_head, need_bytes);
+	xlog_grant_add_space(&log->l_reserve_head, need_bytes);
+	xlog_grant_add_space(&log->l_write_head, need_bytes);
 	trace_xfs_log_reserve_exit(log, tic);
-	xlog_verify_grant_tail(log);
 	return 0;
 
 out_error:
@@ -1880,8 +1813,8 @@ xlog_sync(
 	if (ticket) {
 		ticket->t_curr_res -= roundoff;
 	} else {
-		xlog_grant_add_space(log, &log->l_reserve_head, roundoff);
-		xlog_grant_add_space(log, &log->l_write_head, roundoff);
+		xlog_grant_add_space(&log->l_reserve_head, roundoff);
+		xlog_grant_add_space(&log->l_write_head, roundoff);
 	}
 
 	/* put cycle number in every block */
@@ -2801,16 +2734,15 @@ xfs_log_ticket_regrant(
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
 
-	xlog_grant_sub_space(log, &log->l_reserve_head, ticket->t_curr_res);
-	xlog_grant_sub_space(log, &log->l_write_head, ticket->t_curr_res);
+	xlog_grant_sub_space(&log->l_reserve_head, ticket->t_curr_res);
+	xlog_grant_sub_space(&log->l_write_head, ticket->t_curr_res);
 	ticket->t_curr_res = ticket->t_unit_res;
 
 	trace_xfs_log_ticket_regrant_sub(log, ticket);
 
 	/* just return if we still have some of the pre-reserved space */
 	if (!ticket->t_cnt) {
-		xlog_grant_add_space(log, &log->l_reserve_head,
-				     ticket->t_unit_res);
+		xlog_grant_add_space(&log->l_reserve_head, ticket->t_unit_res);
 		trace_xfs_log_ticket_regrant_exit(log, ticket);
 
 		ticket->t_curr_res = ticket->t_unit_res;
@@ -2857,8 +2789,8 @@ xfs_log_ticket_ungrant(
 		bytes += ticket->t_unit_res*ticket->t_cnt;
 	}
 
-	xlog_grant_sub_space(log, &log->l_reserve_head, bytes);
-	xlog_grant_sub_space(log, &log->l_write_head, bytes);
+	xlog_grant_sub_space(&log->l_reserve_head, bytes);
+	xlog_grant_sub_space(&log->l_write_head, bytes);
 
 	trace_xfs_log_ticket_ungrant_exit(log, ticket);
 
@@ -3331,42 +3263,27 @@ xlog_ticket_alloc(
 }
 
 #if defined(DEBUG)
-/*
- * Check to make sure the grant write head didn't just over lap the tail.  If
- * the cycles are the same, we can't be overlapping.  Otherwise, make sure that
- * the cycles differ by exactly one and check the byte count.
- *
- * This check is run unlocked, so can give false positives. Rather than assert
- * on failures, use a warn-once flag and a panic tag to allow the admin to
- * determine if they want to panic the machine when such an error occurs. For
- * debug kernels this will have the same effect as using an assert but, unlinke
- * an assert, it can be turned off at runtime.
- */
-STATIC void
-xlog_verify_grant_tail(
-	struct xlog	*log)
+static void
+xlog_verify_dump_tail(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog)
 {
-	int		tail_cycle, tail_blocks;
-	int		cycle, space;
-
-	xlog_crack_grant_head(&log->l_write_head.grant, &cycle, &space);
-	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_blocks);
-	if (tail_cycle != cycle) {
-		if (cycle - 1 != tail_cycle &&
-		    !test_and_set_bit(XLOG_TAIL_WARN, &log->l_opstate)) {
-			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
-				"%s: cycle - 1 != tail_cycle", __func__);
-		}
-
-		if (space > BBTOB(tail_blocks) &&
-		    !test_and_set_bit(XLOG_TAIL_WARN, &log->l_opstate)) {
-			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
-				"%s: space > BBTOB(tail_blocks)", __func__);
-		}
-	}
-}
-
-/* check if it will fit */
+	xfs_alert(log->l_mp,
+"ran out of log space tail 0x%llx/0x%llx, head lsn 0x%llx, head 0x%x/0x%x, prev head 0x%x/0x%x",
+			iclog ? be64_to_cpu(iclog->ic_header.h_tail_lsn) : -1,
+			atomic64_read(&log->l_tail_lsn),
+			log->l_ailp->ail_head_lsn,
+			log->l_curr_cycle, log->l_curr_block,
+			log->l_prev_cycle, log->l_prev_block);
+	xfs_alert(log->l_mp,
+"write grant 0x%llx, reserve grant 0x%llx, tail_space 0x%llx, size 0x%x, iclog flags 0x%x",
+			atomic64_read(&log->l_write_head.grant),
+			atomic64_read(&log->l_reserve_head.grant),
+			log->l_tail_space, log->l_logsize,
+			iclog ? iclog->ic_flags : -1);
+}
+
+/* Check if the new iclog will fit in the log. */
 STATIC void
 xlog_verify_tail_lsn(
 	struct xlog		*log,
@@ -3375,21 +3292,34 @@ xlog_verify_tail_lsn(
 	xfs_lsn_t	tail_lsn = be64_to_cpu(iclog->ic_header.h_tail_lsn);
 	int		blocks;
 
-    if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
-	blocks =
-	    log->l_logBBsize - (log->l_prev_block - BLOCK_LSN(tail_lsn));
-	if (blocks < BTOBB(iclog->ic_offset)+BTOBB(log->l_iclog_hsize))
-		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
-    } else {
-	ASSERT(CYCLE_LSN(tail_lsn)+1 == log->l_prev_cycle);
+	if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
+		blocks = log->l_logBBsize -
+				(log->l_prev_block - BLOCK_LSN(tail_lsn));
+		if (blocks < BTOBB(iclog->ic_offset) +
+					BTOBB(log->l_iclog_hsize)) {
+			xfs_emerg(log->l_mp,
+					"%s: ran out of log space", __func__);
+			xlog_verify_dump_tail(log, iclog);
+		}
+		return;
+	}
 
-	if (BLOCK_LSN(tail_lsn) == log->l_prev_block)
+	if (CYCLE_LSN(tail_lsn) + 1 != log->l_prev_cycle) {
+		xfs_emerg(log->l_mp, "%s: head has wrapped tail.", __func__);
+		xlog_verify_dump_tail(log, iclog);
+		return;
+	}
+	if (BLOCK_LSN(tail_lsn) == log->l_prev_block) {
 		xfs_emerg(log->l_mp, "%s: tail wrapped", __func__);
+		xlog_verify_dump_tail(log, iclog);
+		return;
+	}
 
 	blocks = BLOCK_LSN(tail_lsn) - log->l_prev_block;
-	if (blocks < BTOBB(iclog->ic_offset) + 1)
-		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
-    }
+	if (blocks < BTOBB(iclog->ic_offset) + 1) {
+		xfs_emerg(log->l_mp, "%s: ran out of iclog space", __func__);
+		xlog_verify_dump_tail(log, iclog);
+	}
 }
 
 /*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 92ccac7f905448..391a938d690c59 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -764,6 +764,7 @@ xlog_cil_ail_insert(
 	struct xfs_log_item	*log_items[LOG_ITEM_BATCH_SIZE];
 	struct xfs_log_vec	*lv;
 	struct xfs_ail_cursor	cur;
+	xfs_lsn_t		old_head;
 	int			i = 0;
 
 	/*
@@ -780,10 +781,21 @@ xlog_cil_ail_insert(
 			aborted);
 	spin_lock(&ailp->ail_lock);
 	xfs_trans_ail_cursor_last(ailp, &cur, ctx->start_lsn);
+	old_head = ailp->ail_head_lsn;
 	ailp->ail_head_lsn = ctx->commit_lsn;
 	/* xfs_ail_update_finish() drops the ail_lock */
 	xfs_ail_update_finish(ailp, NULLCOMMITLSN);
 
+	/*
+	 * We move the AIL head forwards to account for the space used in the
+	 * log before we remove that space from the grant heads. This prevents a
+	 * transient condition where reservation space appears to become
+	 * available on return, only for it to disappear again immediately as
+	 * the AIL head update accounts in the log tail space.
+	 */
+	smp_wmb();	/* paired with smp_rmb in xlog_grant_space_left */
+	xlog_grant_return_space(ailp->ail_log, old_head, ailp->ail_head_lsn);
+
 	/* unpin all the log items */
 	list_for_each_entry(lv, &ctx->lv_chain, lv_list) {
 		struct xfs_log_item	*lip = lv->lv_item;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 0838c57ca8ac22..b8778a4fd6b64e 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -543,36 +543,6 @@ xlog_assign_atomic_lsn(atomic64_t *lsn, uint cycle, uint block)
 	atomic64_set(lsn, xlog_assign_lsn(cycle, block));
 }
 
-/*
- * When we crack the grant head, we sample it first so that the value will not
- * change while we are cracking it into the component values. This means we
- * will always get consistent component values to work from.
- */
-static inline void
-xlog_crack_grant_head_val(int64_t val, int *cycle, int *space)
-{
-	*cycle = val >> 32;
-	*space = val & 0xffffffff;
-}
-
-static inline void
-xlog_crack_grant_head(atomic64_t *head, int *cycle, int *space)
-{
-	xlog_crack_grant_head_val(atomic64_read(head), cycle, space);
-}
-
-static inline int64_t
-xlog_assign_grant_head_val(int cycle, int space)
-{
-	return ((int64_t)cycle << 32) | space;
-}
-
-static inline void
-xlog_assign_grant_head(atomic64_t *head, int cycle, int space)
-{
-	atomic64_set(head, xlog_assign_grant_head_val(cycle, space));
-}
-
 /*
  * Committed Item List interfaces
  */
@@ -639,6 +609,9 @@ xlog_lsn_sub(
 	return (uint64_t)log->l_logsize - BBTOB(lo_block - hi_block);
 }
 
+void xlog_grant_return_space(struct xlog *log, xfs_lsn_t old_head,
+		xfs_lsn_t new_head);
+
 /*
  * The LSN is valid so long as it is behind the current LSN. If it isn't, this
  * means that the next log record that includes this metadata could have a
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 63f667f92c322e..32c6d7070871dc 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1213,10 +1213,6 @@ xlog_set_state(
 		log->l_curr_cycle++;
 	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
 	log->l_ailp->ail_head_lsn = be64_to_cpu(rhead->h_lsn);
-	xlog_assign_grant_head(&log->l_reserve_head.grant, log->l_curr_cycle,
-					BBTOB(log->l_curr_block));
-	xlog_assign_grant_head(&log->l_write_head.grant, log->l_curr_cycle,
-					BBTOB(log->l_curr_block));
 }
 
 /*
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index d2391eec37fe9d..60cb5318fdae3c 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -432,39 +432,30 @@ log_tail_lsn_show(
 XFS_SYSFS_ATTR_RO(log_tail_lsn);
 
 STATIC ssize_t
-reserve_grant_head_show(
+reserve_grant_head_bytes_show(
 	struct kobject	*kobject,
 	char		*buf)
-
 {
-	int cycle;
-	int bytes;
-	struct xlog *log = to_xlog(kobject);
-
-	xlog_crack_grant_head(&log->l_reserve_head.grant, &cycle, &bytes);
-	return sysfs_emit(buf, "%d:%d\n", cycle, bytes);
+	return sysfs_emit(buf, "%lld\n",
+			atomic64_read(&to_xlog(kobject)->l_reserve_head.grant));
 }
-XFS_SYSFS_ATTR_RO(reserve_grant_head);
+XFS_SYSFS_ATTR_RO(reserve_grant_head_bytes);
 
 STATIC ssize_t
-write_grant_head_show(
+write_grant_head_bytes_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
-	int cycle;
-	int bytes;
-	struct xlog *log = to_xlog(kobject);
-
-	xlog_crack_grant_head(&log->l_write_head.grant, &cycle, &bytes);
-	return sysfs_emit(buf, "%d:%d\n", cycle, bytes);
+	return sysfs_emit(buf, "%lld\n",
+			atomic64_read(&to_xlog(kobject)->l_write_head.grant));
 }
-XFS_SYSFS_ATTR_RO(write_grant_head);
+XFS_SYSFS_ATTR_RO(write_grant_head_bytes);
 
 static struct attribute *xfs_log_attrs[] = {
 	ATTR_LIST(log_head_lsn),
 	ATTR_LIST(log_tail_lsn),
-	ATTR_LIST(reserve_grant_head),
-	ATTR_LIST(write_grant_head),
+	ATTR_LIST(reserve_grant_head_bytes),
+	ATTR_LIST(write_grant_head_bytes),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_log);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 13f6e6cab572ae..a7ff0c7f6800a0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1227,6 +1227,7 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 	TP_ARGS(log, tic),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(unsigned long, tic)
 		__field(char, ocnt)
 		__field(char, cnt)
 		__field(int, curr_res)
@@ -1234,16 +1235,16 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__field(unsigned int, flags)
 		__field(int, reserveq)
 		__field(int, writeq)
-		__field(int, grant_reserve_cycle)
-		__field(int, grant_reserve_bytes)
-		__field(int, grant_write_cycle)
-		__field(int, grant_write_bytes)
+		__field(uint64_t, grant_reserve_bytes)
+		__field(uint64_t, grant_write_bytes)
+		__field(uint64_t, tail_space)
 		__field(int, curr_cycle)
 		__field(int, curr_block)
 		__field(xfs_lsn_t, tail_lsn)
 	),
 	TP_fast_assign(
 		__entry->dev = log->l_mp->m_super->s_dev;
+		__entry->tic = (unsigned long)tic;
 		__entry->ocnt = tic->t_ocnt;
 		__entry->cnt = tic->t_cnt;
 		__entry->curr_res = tic->t_curr_res;
@@ -1251,23 +1252,22 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__entry->flags = tic->t_flags;
 		__entry->reserveq = list_empty(&log->l_reserve_head.waiters);
 		__entry->writeq = list_empty(&log->l_write_head.waiters);
-		xlog_crack_grant_head(&log->l_reserve_head.grant,
-				&__entry->grant_reserve_cycle,
-				&__entry->grant_reserve_bytes);
-		xlog_crack_grant_head(&log->l_write_head.grant,
-				&__entry->grant_write_cycle,
-				&__entry->grant_write_bytes);
+		__entry->tail_space = READ_ONCE(log->l_tail_space);
+		__entry->grant_reserve_bytes = __entry->tail_space +
+			atomic64_read(&log->l_reserve_head.grant);
+		__entry->grant_write_bytes = __entry->tail_space +
+			atomic64_read(&log->l_write_head.grant);
 		__entry->curr_cycle = log->l_curr_cycle;
 		__entry->curr_block = log->l_curr_block;
 		__entry->tail_lsn = atomic64_read(&log->l_tail_lsn);
 	),
-	TP_printk("dev %d:%d t_ocnt %u t_cnt %u t_curr_res %u "
-		  "t_unit_res %u t_flags %s reserveq %s "
-		  "writeq %s grant_reserve_cycle %d "
-		  "grant_reserve_bytes %d grant_write_cycle %d "
-		  "grant_write_bytes %d curr_cycle %d curr_block %d "
+	TP_printk("dev %d:%d tic 0x%lx t_ocnt %u t_cnt %u t_curr_res %u "
+		  "t_unit_res %u t_flags %s reserveq %s writeq %s "
+		  "tail space %llu grant_reserve_bytes %llu "
+		  "grant_write_bytes %llu curr_cycle %d curr_block %d "
 		  "tail_cycle %d tail_block %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->tic,
 		  __entry->ocnt,
 		  __entry->cnt,
 		  __entry->curr_res,
@@ -1275,9 +1275,8 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		  __print_flags(__entry->flags, "|", XLOG_TIC_FLAGS),
 		  __entry->reserveq ? "empty" : "active",
 		  __entry->writeq ? "empty" : "active",
-		  __entry->grant_reserve_cycle,
+		  __entry->tail_space,
 		  __entry->grant_reserve_bytes,
-		  __entry->grant_write_cycle,
 		  __entry->grant_write_bytes,
 		  __entry->curr_cycle,
 		  __entry->curr_block,
@@ -1305,6 +1304,7 @@ DEFINE_LOGGRANT_EVENT(xfs_log_ticket_ungrant);
 DEFINE_LOGGRANT_EVENT(xfs_log_ticket_ungrant_sub);
 DEFINE_LOGGRANT_EVENT(xfs_log_ticket_ungrant_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_cil_wait);
+DEFINE_LOGGRANT_EVENT(xfs_log_cil_return);
 
 DECLARE_EVENT_CLASS(xfs_log_item_class,
 	TP_PROTO(struct xfs_log_item *lip),
-- 
2.43.0

