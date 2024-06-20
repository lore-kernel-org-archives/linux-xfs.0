Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C566E39AEB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 07:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718868136; cv=none; b=BAEtiGYXCm8SCS3qVPJFBQdntLUw81RRSHVD3LBwXZUjNscelMTi9qjz4TLslK6k1kFxk+VIe+kLCT/tKK2WxxnSS4AjdG7xP6bj50wZlg8MUfurrpUhcIrcGO4VA+W8eHzQO8DnQr8QWm8iUwGDv1TupcQZ4XBLobMy0ALTWhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718868136; c=relaxed/simple;
	bh=73OsiYO+fLOxGGwf3O+zXJekSzHT0+uyOCWw0+WlE1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Da0EMyzofqI3DCZbylmxfIB2/vMq7Z5P8eN3rxTG7NYXfnlCabqEhL4X1VVPWhTdFbVKRMeIIyb61Z6CZGFeKWuZLT30nYO1h1ClUkPOjJXdv9wunKxPbTpjJAEUszSi3VnIfKBwCsUi68ozYFgx1lan2ZuY8Xl/yWKe4tOLv2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JQ0Wl5NX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JQ0Wl5NX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kG9xvd3EqrdqfzDRMXOf0gtiUfZyDhFbTGgbbI3p3FE=; b=JQ0Wl5NXqxIGc/YNySkNHy4DxT
	cNHmN1sg//gwlPhhG3GDDv8vNbObm6JNYMixaMc3H4UJTfcDF6diT7TVF68kD3/fYINFfMf8wFijJ
	/5shEga5993khFEdQZujjgtffNoRv3rzw0qQDiu+8Rp7GUHrb3s+KDOk2VmTXKZsPrVjMpZd+L63s
	rhL1RJ30M1LQEG0zVZ8kQmHJ3280EZ1IJSmMr+O9f/Ajl335vg9iiPmTle0FZRD94DdMr+F5hvSPx
	nbdvQLquFNdGC4wvt2lMirkySZb0V65hEgge0nApobWc4C/mHEV+puFv2qWuf7KKLGTZJ1TxntQb2
	aByXOsLA==;
Received: from 2a02-8389-2341-5b80-3a9c-dc0d-9615-f1ed.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3a9c:dc0d:9615:f1ed] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKC7Z-00000003xdU-3T4p;
	Thu, 20 Jun 2024 07:22:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 09/11] xfs: pass the full grant head to accounting functions
Date: Thu, 20 Jun 2024 09:21:26 +0200
Message-ID: <20240620072146.530267-10-hch@lst.de>
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

Because we are going to need them soon. API change only, no logic
changes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 157 +++++++++++++++++++++---------------------
 fs/xfs/xfs_log_priv.h |   2 -
 2 files changed, 77 insertions(+), 82 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 381d6143a78777..0e50b370f0e4c7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -136,10 +136,10 @@ xlog_prepare_iovec(
 static void
 xlog_grant_sub_space(
 	struct xlog		*log,
-	atomic64_t		*head,
+	struct xlog_grant_head	*head,
 	int			bytes)
 {
-	int64_t	head_val = atomic64_read(head);
+	int64_t	head_val = atomic64_read(&head->grant);
 	int64_t new, old;
 
 	do {
@@ -155,17 +155,17 @@ xlog_grant_sub_space(
 
 		old = head_val;
 		new = xlog_assign_grant_head_val(cycle, space);
-		head_val = atomic64_cmpxchg(head, old, new);
+		head_val = atomic64_cmpxchg(&head->grant, old, new);
 	} while (head_val != old);
 }
 
 static void
 xlog_grant_add_space(
 	struct xlog		*log,
-	atomic64_t		*head,
+	struct xlog_grant_head	*head,
 	int			bytes)
 {
-	int64_t	head_val = atomic64_read(head);
+	int64_t	head_val = atomic64_read(&head->grant);
 	int64_t new, old;
 
 	do {
@@ -184,7 +184,7 @@ xlog_grant_add_space(
 
 		old = head_val;
 		new = xlog_assign_grant_head_val(cycle, space);
-		head_val = atomic64_cmpxchg(head, old, new);
+		head_val = atomic64_cmpxchg(&head->grant, old, new);
 	} while (head_val != old);
 }
 
@@ -197,6 +197,63 @@ xlog_grant_head_init(
 	spin_lock_init(&head->lock);
 }
 
+/*
+ * Return the space in the log between the tail and the head.  The head
+ * is passed in the cycle/bytes formal parms.  In the special case where
+ * the reserve head has wrapped passed the tail, this calculation is no
+ * longer valid.  In this case, just return 0 which means there is no space
+ * in the log.  This works for all places where this function is called
+ * with the reserve head.  Of course, if the write head were to ever
+ * wrap the tail, we should blow up.  Rather than catch this case here,
+ * we depend on other ASSERTions in other parts of the code.   XXXmiken
+ *
+ * If reservation head is behind the tail, we have a problem. Warn about it,
+ * but then treat it as if the log is empty.
+ *
+ * If the log is shut down, the head and tail may be invalid or out of whack, so
+ * shortcut invalidity asserts in this case so that we don't trigger them
+ * falsely.
+ */
+static int
+xlog_grant_space_left(
+	struct xlog		*log,
+	struct xlog_grant_head	*head)
+{
+	int			tail_bytes;
+	int			tail_cycle;
+	int			head_cycle;
+	int			head_bytes;
+
+	xlog_crack_grant_head(&head->grant, &head_cycle, &head_bytes);
+	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_bytes);
+	tail_bytes = BBTOB(tail_bytes);
+	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
+		return log->l_logsize - (head_bytes - tail_bytes);
+	if (tail_cycle + 1 < head_cycle)
+		return 0;
+
+	/* Ignore potential inconsistency when shutdown. */
+	if (xlog_is_shutdown(log))
+		return log->l_logsize;
+
+	if (tail_cycle < head_cycle) {
+		ASSERT(tail_cycle == (head_cycle - 1));
+		return tail_bytes - head_bytes;
+	}
+
+	/*
+	 * The reservation head is behind the tail. In this case we just want to
+	 * return the size of the log as the amount of space left.
+	 */
+	xfs_alert(log->l_mp, "xlog_grant_space_left: head behind tail");
+	xfs_alert(log->l_mp, "  tail_cycle = %d, tail_bytes = %d",
+		  tail_cycle, tail_bytes);
+	xfs_alert(log->l_mp, "  GH   cycle = %d, GH   bytes = %d",
+		  head_cycle, head_bytes);
+	ASSERT(0);
+	return log->l_logsize;
+}
+
 STATIC void
 xlog_grant_head_wake_all(
 	struct xlog_grant_head	*head)
@@ -277,7 +334,7 @@ xlog_grant_head_wait(
 		spin_lock(&head->lock);
 		if (xlog_is_shutdown(log))
 			goto shutdown;
-	} while (xlog_space_left(log, &head->grant) < need_bytes);
+	} while (xlog_grant_space_left(log, head) < need_bytes);
 
 	list_del_init(&tic->t_queue);
 	return 0;
@@ -322,7 +379,7 @@ xlog_grant_head_check(
 	 * otherwise try to get some space for this transaction.
 	 */
 	*need_bytes = xlog_ticket_reservation(log, head, tic);
-	free_bytes = xlog_space_left(log, &head->grant);
+	free_bytes = xlog_grant_space_left(log, head);
 	if (!list_empty_careful(&head->waiters)) {
 		spin_lock(&head->lock);
 		if (!xlog_grant_head_wake(log, head, &free_bytes) ||
@@ -396,7 +453,7 @@ xfs_log_regrant(
 	if (error)
 		goto out_error;
 
-	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
+	xlog_grant_add_space(log, &log->l_write_head, need_bytes);
 	trace_xfs_log_regrant_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	return 0;
@@ -447,8 +504,8 @@ xfs_log_reserve(
 	if (error)
 		goto out_error;
 
-	xlog_grant_add_space(log, &log->l_reserve_head.grant, need_bytes);
-	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
+	xlog_grant_add_space(log, &log->l_reserve_head, need_bytes);
+	xlog_grant_add_space(log, &log->l_write_head, need_bytes);
 	trace_xfs_log_reserve_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	return 0;
@@ -1107,7 +1164,7 @@ xfs_log_space_wake(
 		ASSERT(!xlog_in_recovery(log));
 
 		spin_lock(&log->l_write_head.lock);
-		free_bytes = xlog_space_left(log, &log->l_write_head.grant);
+		free_bytes = xlog_grant_space_left(log, &log->l_write_head);
 		xlog_grant_head_wake(log, &log->l_write_head, &free_bytes);
 		spin_unlock(&log->l_write_head.lock);
 	}
@@ -1116,7 +1173,7 @@ xfs_log_space_wake(
 		ASSERT(!xlog_in_recovery(log));
 
 		spin_lock(&log->l_reserve_head.lock);
-		free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
+		free_bytes = xlog_grant_space_left(log, &log->l_reserve_head);
 		xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes);
 		spin_unlock(&log->l_reserve_head.lock);
 	}
@@ -1230,64 +1287,6 @@ xfs_log_cover(
 	return error;
 }
 
-/*
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
- */
-int
-xlog_space_left(
-	struct xlog	*log,
-	atomic64_t	*head)
-{
-	int		tail_bytes;
-	int		tail_cycle;
-	int		head_cycle;
-	int		head_bytes;
-
-	xlog_crack_grant_head(head, &head_cycle, &head_bytes);
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
-
-	/*
-	 * The reservation head is behind the tail. In this case we just want to
-	 * return the size of the log as the amount of space left.
-	 */
-	xfs_alert(log->l_mp, "xlog_space_left: head behind tail");
-	xfs_alert(log->l_mp, "  tail_cycle = %d, tail_bytes = %d",
-		  tail_cycle, tail_bytes);
-	xfs_alert(log->l_mp, "  GH   cycle = %d, GH   bytes = %d",
-		  head_cycle, head_bytes);
-	ASSERT(0);
-	return log->l_logsize;
-}
-
-
 static void
 xlog_ioend_work(
 	struct work_struct	*work)
@@ -1881,8 +1880,8 @@ xlog_sync(
 	if (ticket) {
 		ticket->t_curr_res -= roundoff;
 	} else {
-		xlog_grant_add_space(log, &log->l_reserve_head.grant, roundoff);
-		xlog_grant_add_space(log, &log->l_write_head.grant, roundoff);
+		xlog_grant_add_space(log, &log->l_reserve_head, roundoff);
+		xlog_grant_add_space(log, &log->l_write_head, roundoff);
 	}
 
 	/* put cycle number in every block */
@@ -2802,17 +2801,15 @@ xfs_log_ticket_regrant(
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
 
-	xlog_grant_sub_space(log, &log->l_reserve_head.grant,
-					ticket->t_curr_res);
-	xlog_grant_sub_space(log, &log->l_write_head.grant,
-					ticket->t_curr_res);
+	xlog_grant_sub_space(log, &log->l_reserve_head, ticket->t_curr_res);
+	xlog_grant_sub_space(log, &log->l_write_head, ticket->t_curr_res);
 	ticket->t_curr_res = ticket->t_unit_res;
 
 	trace_xfs_log_ticket_regrant_sub(log, ticket);
 
 	/* just return if we still have some of the pre-reserved space */
 	if (!ticket->t_cnt) {
-		xlog_grant_add_space(log, &log->l_reserve_head.grant,
+		xlog_grant_add_space(log, &log->l_reserve_head,
 				     ticket->t_unit_res);
 		trace_xfs_log_ticket_regrant_exit(log, ticket);
 
@@ -2860,8 +2857,8 @@ xfs_log_ticket_ungrant(
 		bytes += ticket->t_unit_res*ticket->t_cnt;
 	}
 
-	xlog_grant_sub_space(log, &log->l_reserve_head.grant, bytes);
-	xlog_grant_sub_space(log, &log->l_write_head.grant, bytes);
+	xlog_grant_sub_space(log, &log->l_reserve_head, bytes);
+	xlog_grant_sub_space(log, &log->l_write_head, bytes);
 
 	trace_xfs_log_ticket_ungrant_exit(log, ticket);
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 2896745989795d..0838c57ca8ac22 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -573,8 +573,6 @@ xlog_assign_grant_head(atomic64_t *head, int cycle, int space)
 	atomic64_set(head, xlog_assign_grant_head_val(cycle, space));
 }
 
-int xlog_space_left(struct xlog *log, atomic64_t *head);
-
 /*
  * Committed Item List interfaces
  */
-- 
2.43.0

