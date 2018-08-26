Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726714AbeH0Ah0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 26 Aug 2018 20:37:26 -0400
From: Waiman Long <longman@redhat.com>
Subject: [PATCH v2 0/3] xfs: Reduce spinlock contention in log space slowpath code
Date: Sun, 26 Aug 2018 16:53:12 -0400
Message-Id: <1535316795-21560-1-git-send-email-longman@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Waiman Long <longman@redhat.com>

v1->v2:
 - For patch 1, remove wake_q_empty() & add task_in_wake_q().
 - Rewrite patch 2 after comments from Dave Chinner and break it down
   to 2 separate patches. Now the original xfs logic was kept. The
   patches just try to move the task wakeup calls to outside the
   spinlock.

While running the AIM7 microbenchmark on a small xfs filesystem, it
was found that there was a severe spinlock contention problem in the
current XFS log space reservation code. To alleviate the problem, the
patches try to move as much task wakeup code to outside the spinlock
using the wake_q mechanism so as to reduce the lock hold time as much
as possible.

Patch 1 exports the wake_up_q() and wake_q_add() functions and adds
the task_in_wake_q() inline function.

Patch 2 adds a new flag XLOG_TIC_WAKING to mark a task that is being
waken up and skip the wake_up_process() if a previous wakeup has
been issued.

Patch 3 modifies the xlog_grant_head_wait() and xlog_grant_head_wake()
functions to use wake_q for waking up tasks outside the lock critical
section instead of calling wake_up_process() directly.

The following table shows the performance improvement in the AIM7
fserver workload after applying patches 2 and 3:

  Patches	Jobs/min	% Change
  -------	--------	--------
     -		 91,486		   -
     2		192,666		 +111%
    2+3		285,221 	 +212%

So the final patched kernel performed more than 3X better than the
unpatched one.

Waiman Long (3):
  sched/core: Export wake_q functions to kernel modules
  xfs: Prevent multiple wakeups of the same log space waiter
  xfs: Use wake_q for waking up log space waiters

 fs/xfs/xfs_linux.h           |  1 +
 fs/xfs/xfs_log.c             | 57 ++++++++++++++++++++++++++++++------
 fs/xfs/xfs_log_priv.h        |  1 +
 include/linux/sched/wake_q.h |  5 ++++
 kernel/sched/core.c          |  2 ++
 5 files changed, 57 insertions(+), 9 deletions(-)

-- 
2.18.0
