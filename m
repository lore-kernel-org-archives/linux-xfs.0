Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49636 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726741AbeH0Ah0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 26 Aug 2018 20:37:26 -0400
From: Waiman Long <longman@redhat.com>
Subject: [PATCH v2 1/3] sched/core: Export wake_q functions to kernel modules
Date: Sun, 26 Aug 2018 16:53:13 -0400
Message-Id: <1535316795-21560-2-git-send-email-longman@redhat.com>
In-Reply-To: <1535316795-21560-1-git-send-email-longman@redhat.com>
References: <1535316795-21560-1-git-send-email-longman@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Waiman Long <longman@redhat.com>

The use of wake_q_add() and wake_up_q() functions help to do task wakeup
without holding lock can help to reduce lock hold time. They should be
available to kernel modules as well.

A new task_in_wake_q() inline function is also added to check if the
given task is in a wake_q.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/linux/sched/wake_q.h | 5 +++++
 kernel/sched/core.c          | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/sched/wake_q.h b/include/linux/sched/wake_q.h
index 10b19a192b2d..902bf1228d32 100644
--- a/include/linux/sched/wake_q.h
+++ b/include/linux/sched/wake_q.h
@@ -47,6 +47,11 @@ static inline void wake_q_init(struct wake_q_head *head)
 	head->lastp = &head->first;
 }
 
+static inline bool task_in_wake_q(struct task_struct *task)
+{
+	return READ_ONCE(task->wake_q.next) != NULL;
+}
+
 extern void wake_q_add(struct wake_q_head *head,
 		       struct task_struct *task);
 extern void wake_up_q(struct wake_q_head *head);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 625bc9897f62..d90a2930b8ce 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -420,6 +420,7 @@ void wake_q_add(struct wake_q_head *head, struct task_struct *task)
 	*head->lastp = node;
 	head->lastp = &node->next;
 }
+EXPORT_SYMBOL_GPL(wake_q_add);
 
 void wake_up_q(struct wake_q_head *head)
 {
@@ -442,6 +443,7 @@ void wake_up_q(struct wake_q_head *head)
 		put_task_struct(task);
 	}
 }
+EXPORT_SYMBOL_GPL(wake_up_q);
 
 /*
  * resched_curr - mark rq's current task 'to be rescheduled now'.
-- 
2.18.0
