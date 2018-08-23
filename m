Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727544AbeHWT4s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Aug 2018 15:56:48 -0400
From: Waiman Long <longman@redhat.com>
Subject: [PATCH 1/2] sched/core: Export wake_q functions to kernel modules
Date: Thu, 23 Aug 2018 12:26:09 -0400
Message-Id: <1535041570-24102-2-git-send-email-longman@redhat.com>
In-Reply-To: <1535041570-24102-1-git-send-email-longman@redhat.com>
References: <1535041570-24102-1-git-send-email-longman@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, Waiman Long <longman@redhat.com>

The use of wake_q_add() and wake_up_q() functions help to do task wakeup
without holding lock can help to reduce lock hold time. They should be
available to kernel modules as well.

A new wake_q_empty() inline function is also added.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/linux/sched/wake_q.h | 5 +++++
 kernel/sched/core.c          | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/sched/wake_q.h b/include/linux/sched/wake_q.h
index 10b19a1..b1895a7 100644
--- a/include/linux/sched/wake_q.h
+++ b/include/linux/sched/wake_q.h
@@ -47,6 +47,11 @@ static inline void wake_q_init(struct wake_q_head *head)
 	head->lastp = &head->first;
 }
 
+static inline bool wake_q_empty(struct wake_q_head *head)
+{
+	return head->first == WAKE_Q_TAIL;
+}
+
 extern void wake_q_add(struct wake_q_head *head,
 		       struct task_struct *task);
 extern void wake_up_q(struct wake_q_head *head);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 63a6462..4b3c8e5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -456,6 +456,7 @@ void wake_q_add(struct wake_q_head *head, struct task_struct *task)
 	*head->lastp = node;
 	head->lastp = &node->next;
 }
+EXPORT_SYMBOL_GPL(wake_q_add);
 
 void wake_up_q(struct wake_q_head *head)
 {
@@ -478,6 +479,7 @@ void wake_up_q(struct wake_q_head *head)
 		put_task_struct(task);
 	}
 }
+EXPORT_SYMBOL_GPL(wake_up_q);
 
 /*
  * resched_curr - mark rq's current task 'to be rescheduled now'.
-- 
1.8.3.1
