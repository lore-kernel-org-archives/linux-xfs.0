Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5197CECE587
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 18:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3295D2067B
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 18:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732955AbfJNSNC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 14:13:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731926AbfJNSNC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Oct 2019 14:13:02 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EBA69315C020
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2019 18:13:01 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A927F5D6A3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2019 18:13:01 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH 3/3] xfs: recheck free reservation on grant head update contention
Date:   Mon, 14 Oct 2019 14:13:00 -0400
Message-Id: <20191014181300.15494-4-bfoster@redhat.com>
In-Reply-To: <20191014181300.15494-1-bfoster@redhat.com>
References: <20191014181300.15494-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 14 Oct 2019 18:13:01 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The lockless -> locking log grant head reservation algorithm is
somewhat racy. If multiple tasks check the grant head at the same
time, they use the same free space calculation and potentially
consume more reservation than is available based on the current log
tail. This leads to occasional warnings from
xlog_verify_grant_tail() on debug kernels. This is acceptable
because the algorithm is racy by design for performance reasons and
because an occasional tail overrun by the grant head(s) is not a
critical error.

However, grant tail overruns are not infrequent on certain systems
with capability of high concurrency and smaller logs. With the
oneshot nature of the grant tail warning disabled, grant overruns
are prevalent and nearly continuous. While this still may not be a
critical error in and of itself, it can be avoided with minimal cost
and fairly minor changes to the algorithm.

The lockless grant head update algorithm is already sensitive to
concurrency in that the function retries if another task has updated
the grant head between the time the current task sampled it, updated
the value and attempts an atomic cmpxchg. To mitigate excessive tail
overruns, repeat the free space check on each retry of the head
update and if it fails, retry the head check such that the task can
be queued.

This technically can reorder some transactions, but only with
respect to transactions that are already racing in the lockless
algorithm, which is already racy enough to not provide any kind of
predictable per-task ordering. This significantly reduces the
frequency of grant tail overruns on highly concurrent workloads
against filesystems with tiny logs without perturbation of the same
workload on default size logs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c   | 47 ++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_trace.h |  1 +
 2 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ce0aac89e675..19b1c2ab4661 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -41,6 +41,10 @@ STATIC int
 xlog_space_left(
 	struct xlog		*log,
 	atomic64_t		*head);
+STATIC int
+__xlog_space_left(
+	struct xlog		*log,
+	int64_t			head_val);
 STATIC void
 xlog_dealloc_log(
 	struct xlog		*log);
@@ -139,19 +143,24 @@ xlog_grant_sub_space(
 	} while (head_val != old);
 }
 
-static void
+static bool
 xlog_grant_add_space(
 	struct xlog		*log,
 	atomic64_t		*head,
-	int			bytes)
+	int			bytes,
+	bool			check_free)
 {
 	int64_t	head_val = atomic64_read(head);
-	int64_t new, old;
+	int64_t new, old, free_bytes;
 
 	do {
 		int		tmp;
 		int		cycle, space;
 
+		free_bytes = __xlog_space_left(log, head_val);
+		if (check_free && bytes > free_bytes)
+			return false;
+
 		xlog_crack_grant_head_val(head_val, &cycle, &space);
 
 		tmp = log->l_logsize - space;
@@ -166,6 +175,8 @@ xlog_grant_add_space(
 		new = xlog_assign_grant_head_val(cycle, space);
 		head_val = atomic64_cmpxchg(head, old, new);
 	} while (head_val != old);
+
+	return true;
 }
 
 STATIC void
@@ -326,6 +337,7 @@ xlog_grant_head_check(
 	 * up all the waiters then go to sleep waiting for more free space,
 	 * otherwise try to get some space for this transaction.
 	 */
+retry:
 	*need_bytes = xlog_ticket_reservation(log, head, tic);
 	free_bytes = xlog_space_left(log, &head->grant);
 	if (!list_empty_careful(&head->waiters)) {
@@ -342,8 +354,12 @@ xlog_grant_head_check(
 		spin_unlock(&head->lock);
 	}
 
-	if (!error)
-		xlog_grant_add_space(log, &head->grant, *need_bytes);
+	if (!error) {
+		if (!xlog_grant_add_space(log, &head->grant, *need_bytes, true)) {
+			trace_xfs_log_grant_retry(log, tic);
+			goto retry;
+		}
+	}
 
 	return error;
 }
@@ -470,7 +486,7 @@ xfs_log_reserve(
 	if (error)
 		goto out_error;
 
-	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
+	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes, false);
 	trace_xfs_log_reserve_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	return 0;
@@ -1186,9 +1202,9 @@ xlog_assign_tail_lsn(
  * result is that we return the size of the log as the amount of space left.
  */
 STATIC int
-xlog_space_left(
+__xlog_space_left(
 	struct xlog	*log,
-	atomic64_t	*head)
+	int64_t		head_val)
 {
 	int		free_bytes;
 	int		tail_bytes;
@@ -1196,7 +1212,7 @@ xlog_space_left(
 	int		head_cycle;
 	int		head_bytes;
 
-	xlog_crack_grant_head(head, &head_cycle, &head_bytes);
+	xlog_crack_grant_head_val(head_val, &head_cycle, &head_bytes);
 	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_bytes);
 	tail_bytes = BBTOB(tail_bytes);
 	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
@@ -1225,6 +1241,13 @@ xlog_space_left(
 	return free_bytes;
 }
 
+STATIC int
+xlog_space_left(
+	struct xlog	*log,
+	atomic64_t	*head)
+{
+	return __xlog_space_left(log, atomic64_read(head));
+}
 
 static void
 xlog_ioend_work(
@@ -1871,8 +1894,8 @@ xlog_sync(
 	count = xlog_calc_iclog_size(log, iclog, &roundoff);
 
 	/* move grant heads by roundoff in sync */
-	xlog_grant_add_space(log, &log->l_reserve_head.grant, roundoff);
-	xlog_grant_add_space(log, &log->l_write_head.grant, roundoff);
+	xlog_grant_add_space(log, &log->l_reserve_head.grant, roundoff, false);
+	xlog_grant_add_space(log, &log->l_write_head.grant, roundoff, false);
 
 	/* put cycle number in every block */
 	xlog_pack_data(log, iclog, roundoff); 
@@ -3107,7 +3130,7 @@ xlog_regrant_reserve_log_space(
 		return;
 
 	xlog_grant_add_space(log, &log->l_reserve_head.grant,
-					ticket->t_unit_res);
+				ticket->t_unit_res, false);
 
 	trace_xfs_log_regrant_reserve_exit(log, ticket);
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index eaae275ed430..5ff096325567 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1001,6 +1001,7 @@ DEFINE_LOGGRANT_EVENT(xfs_log_umount_write);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake_up);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_retry);
 DEFINE_LOGGRANT_EVENT(xfs_log_reserve);
 DEFINE_LOGGRANT_EVENT(xfs_log_reserve_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant);
-- 
2.20.1

