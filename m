Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726238AbeHWT4r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Aug 2018 15:56:47 -0400
From: Waiman Long <longman@redhat.com>
Subject: [PATCH 0/2] xfs: Use wake_q for waking up log space waiters
Date: Thu, 23 Aug 2018 12:26:08 -0400
Message-Id: <1535041570-24102-1-git-send-email-longman@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, Waiman Long <longman@redhat.com>

While running the AIM7 microbenchmark, it was found that there was
a severe spinlock contention problem in the current XFS log space
reservation code. To alleviate the problem, the log space waiter
waiting and waking functions are modified to use the wake_q for waking
up waiters without holding the lock so as to reduce the lock hold time.

The result was a 4X performance improvement in that microbenchmark
which is worth persuing.

Patch 1 is an enablement patch to make wake_q service available to
kernel modules.

Patch 2 changes the XFS log space reservation code to use wake_q for
task wakeup.

Waiman Long (2):
  sched/core: Export wake_q functions to kernel modules
  xfs: Use wake_q for waking up log space waiters

 fs/xfs/xfs_log.c             | 48 ++++++++++++++++++++++++++++++++++----------
 include/linux/sched/wake_q.h |  5 +++++
 kernel/sched/core.c          |  2 ++
 3 files changed, 44 insertions(+), 11 deletions(-)

-- 
1.8.3.1
