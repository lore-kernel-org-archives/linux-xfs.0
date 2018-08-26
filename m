Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726908AbeH0Ah1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 26 Aug 2018 20:37:27 -0400
From: Waiman Long <longman@redhat.com>
Subject: [PATCH v2 2/3] xfs: Prevent multiple wakeups of the same log space waiter
Date: Sun, 26 Aug 2018 16:53:14 -0400
Message-Id: <1535316795-21560-3-git-send-email-longman@redhat.com>
In-Reply-To: <1535316795-21560-1-git-send-email-longman@redhat.com>
References: <1535316795-21560-1-git-send-email-longman@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Waiman Long <longman@redhat.com>

The current log space reservation code allows multiple wakeups of the
same sleeping waiter to happen. This is a just a waste of cpu time as
well as increasing spin lock hold time. So a new XLOG_TIC_WAKING flag is
added to track if a task is being waken up and skip the wake_up_process()
call if the flag is set.

Running the AIM7 fserver workload on a 2-socket 24-core 48-thread
Broadwell system with a small xfs filesystem on ramfs, the performance
increased from 91,486 jobs/min to 192,666 jobs/min with this change.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 fs/xfs/xfs_log.c      | 9 +++++++++
 fs/xfs/xfs_log_priv.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c3b610b687d1..ac1dc8db7112 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -232,8 +232,16 @@ xlog_grant_head_wake(
 			return false;
 
 		*free_bytes -= need_bytes;
+
+		/*
+		 * Skip task that is being waken up already.
+		 */
+		if (tic->t_flags & XLOG_TIC_WAKING)
+			continue;
+
 		trace_xfs_log_grant_wake_up(log, tic);
 		wake_up_process(tic->t_task);
+		tic->t_flags |= XLOG_TIC_WAKING;
 	}
 
 	return true;
@@ -264,6 +272,7 @@ xlog_grant_head_wait(
 		trace_xfs_log_grant_wake(log, tic);
 
 		spin_lock(&head->lock);
+		tic->t_flags &= ~XLOG_TIC_WAKING;
 		if (XLOG_FORCED_SHUTDOWN(log))
 			goto shutdown;
 	} while (xlog_space_left(log, &head->grant) < need_bytes);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b5f82cb36202..738df09bf352 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -59,6 +59,7 @@ static inline uint xlog_get_client_id(__be32 i)
  */
 #define XLOG_TIC_INITED		0x1	/* has been initialized */
 #define XLOG_TIC_PERM_RESERV	0x2	/* permanent reservation */
+#define XLOG_TIC_WAKING		0x4	/* task is being waken up */
 
 #define XLOG_TIC_FLAGS \
 	{ XLOG_TIC_INITED,	"XLOG_TIC_INITED" }, \
-- 
2.18.0
