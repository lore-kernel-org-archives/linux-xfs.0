Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46300 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726741AbeH0Ah2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 26 Aug 2018 20:37:28 -0400
From: Waiman Long <longman@redhat.com>
Subject: [PATCH v2 3/3] xfs: Use wake_q for waking up log space waiters
Date: Sun, 26 Aug 2018 16:53:15 -0400
Message-Id: <1535316795-21560-4-git-send-email-longman@redhat.com>
In-Reply-To: <1535316795-21560-1-git-send-email-longman@redhat.com>
References: <1535316795-21560-1-git-send-email-longman@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Waiman Long <longman@redhat.com>

In the current log space reservation slowpath code, the log space
waiters are waken up by an incoming waiter while holding the lock. As
the process of waking up a task can be time consuming, doing it while
holding the lock can make spinlock contention, if present, more severe.

This patch changes the slowpath code to use the wake_q for waking up
tasks without holding the lock, thus improving performance and reducing
spinlock contention level.

Running the AIM7 fserver workload on a 2-socket 24-core 48-thread
Broadwell system with a small xfs filesystem on ramfs, the performance
increased from 192,666 jobs/min to 285,221 with this change.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 fs/xfs/xfs_linux.h |  1 +
 fs/xfs/xfs_log.c   | 50 ++++++++++++++++++++++++++++++++++++----------
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index edbd5a210df2..1548a353da1e 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -60,6 +60,7 @@ typedef __u32			xfs_nlink_t;
 #include <linux/list_sort.h>
 #include <linux/ratelimit.h>
 #include <linux/rhashtable.h>
+#include <linux/sched/wake_q.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ac1dc8db7112..70d5f85ff059 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -221,7 +221,8 @@ STATIC bool
 xlog_grant_head_wake(
 	struct xlog		*log,
 	struct xlog_grant_head	*head,
-	int			*free_bytes)
+	int			*free_bytes,
+	struct wake_q_head	*wakeq)
 {
 	struct xlog_ticket	*tic;
 	int			need_bytes;
@@ -240,7 +241,7 @@ xlog_grant_head_wake(
 			continue;
 
 		trace_xfs_log_grant_wake_up(log, tic);
-		wake_up_process(tic->t_task);
+		wake_q_add(wakeq, tic->t_task);
 		tic->t_flags |= XLOG_TIC_WAKING;
 	}
 
@@ -252,8 +253,9 @@ xlog_grant_head_wait(
 	struct xlog		*log,
 	struct xlog_grant_head	*head,
 	struct xlog_ticket	*tic,
-	int			need_bytes) __releases(&head->lock)
-					    __acquires(&head->lock)
+	int			need_bytes,
+	struct wake_q_head	*wakeq) __releases(&head->lock)
+					__acquires(&head->lock)
 {
 	list_add_tail(&tic->t_queue, &head->waiters);
 
@@ -265,6 +267,11 @@ xlog_grant_head_wait(
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		spin_unlock(&head->lock);
 
+		if (wakeq) {
+			wake_up_q(wakeq);
+			wakeq = NULL;
+		}
+
 		XFS_STATS_INC(log->l_mp, xs_sleep_logspace);
 
 		trace_xfs_log_grant_sleep(log, tic);
@@ -272,7 +279,21 @@ xlog_grant_head_wait(
 		trace_xfs_log_grant_wake(log, tic);
 
 		spin_lock(&head->lock);
-		tic->t_flags &= ~XLOG_TIC_WAKING;
+		/*
+		 * The XLOG_TIC_WAKING flag should be set. However, it is
+		 * very unlikely that the current task is still in the
+		 * wake_q. If that happens (maybe anonymous wakeup), we
+		 * have to wait until the task is dequeued before proceeding
+		 * to avoid the possibility of having the task put into
+		 * another wake_q simultaneously.
+		 */
+		if (tic->t_flags & XLOG_TIC_WAKING) {
+			while (task_in_wake_q(current))
+				cpu_relax();
+
+			tic->t_flags &= ~XLOG_TIC_WAKING;
+		}
+
 		if (XLOG_FORCED_SHUTDOWN(log))
 			goto shutdown;
 	} while (xlog_space_left(log, &head->grant) < need_bytes);
@@ -310,6 +331,7 @@ xlog_grant_head_check(
 {
 	int			free_bytes;
 	int			error = 0;
+	DEFINE_WAKE_Q(wakeq);
 
 	ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
 
@@ -323,15 +345,17 @@ xlog_grant_head_check(
 	free_bytes = xlog_space_left(log, &head->grant);
 	if (!list_empty_careful(&head->waiters)) {
 		spin_lock(&head->lock);
-		if (!xlog_grant_head_wake(log, head, &free_bytes) ||
+		if (!xlog_grant_head_wake(log, head, &free_bytes, &wakeq) ||
 		    free_bytes < *need_bytes) {
 			error = xlog_grant_head_wait(log, head, tic,
-						     *need_bytes);
+						     *need_bytes, &wakeq);
+			wake_q_init(&wakeq);	/* Set wake_q to empty */
 		}
 		spin_unlock(&head->lock);
+		wake_up_q(&wakeq);
 	} else if (free_bytes < *need_bytes) {
 		spin_lock(&head->lock);
-		error = xlog_grant_head_wait(log, head, tic, *need_bytes);
+		error = xlog_grant_head_wait(log, head, tic, *need_bytes, NULL);
 		spin_unlock(&head->lock);
 	}
 
@@ -1077,6 +1101,7 @@ xfs_log_space_wake(
 {
 	struct xlog		*log = mp->m_log;
 	int			free_bytes;
+	DEFINE_WAKE_Q(wakeq);
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return;
@@ -1086,8 +1111,11 @@ xfs_log_space_wake(
 
 		spin_lock(&log->l_write_head.lock);
 		free_bytes = xlog_space_left(log, &log->l_write_head.grant);
-		xlog_grant_head_wake(log, &log->l_write_head, &free_bytes);
+		xlog_grant_head_wake(log, &log->l_write_head, &free_bytes,
+				     &wakeq);
 		spin_unlock(&log->l_write_head.lock);
+		wake_up_q(&wakeq);
+		wake_q_init(&wakeq); /* Re-init wake_q to be reused again */
 	}
 
 	if (!list_empty_careful(&log->l_reserve_head.waiters)) {
@@ -1095,8 +1123,10 @@ xfs_log_space_wake(
 
 		spin_lock(&log->l_reserve_head.lock);
 		free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
-		xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes);
+		xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes,
+				     &wakeq);
 		spin_unlock(&log->l_reserve_head.lock);
+		wake_up_q(&wakeq);
 	}
 }
 
-- 
2.18.0
