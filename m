Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53736 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfFLGtR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:49:17 -0400
Subject: [PATCH 14/14] xfs: poll waiting for quotacheck
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 11 Jun 2019 23:49:02 -0700
Message-ID: <156032214200.3774243.5594376006892480443.stgit@magnolia>
In-Reply-To: <156032205136.3774243.15725828509940520561.stgit@magnolia>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a pwork destroy function that uses polling instead of
uninterruptible sleep to wait for work items to finish so that we can
touch the softlockup watchdog.  IOWs, gross hack.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iwalk.c |    3 +++
 fs/xfs/xfs_iwalk.h |    3 ++-
 fs/xfs/xfs_pwork.c |   19 +++++++++++++++++++
 fs/xfs/xfs_pwork.h |    3 +++
 fs/xfs/xfs_qm.c    |    2 +-
 5 files changed, 28 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 0fe740298981..f10688cfb917 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -575,6 +575,7 @@ xfs_iwalk_threaded(
 	xfs_ino_t		startino,
 	xfs_iwalk_fn		iwalk_fn,
 	unsigned int		max_prefetch,
+	bool			polled,
 	void			*data)
 {
 	struct xfs_pwork_ctl	pctl;
@@ -606,6 +607,8 @@ xfs_iwalk_threaded(
 		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
 	}
 
+	if (polled)
+		xfs_pwork_poll(&pctl);
 	return xfs_pwork_destroy(&pctl);
 }
 
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 56e0dfe1b2ce..202bca4c9c02 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -16,7 +16,8 @@ typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
 		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
 int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
-		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
+		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, bool poll,
+		void *data);
 
 /* Walk all inode btree records in the filesystem starting from @startino. */
 typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
index 8d0d5f130252..c2f02b710b8c 100644
--- a/fs/xfs/xfs_pwork.c
+++ b/fs/xfs/xfs_pwork.c
@@ -13,6 +13,7 @@
 #include "xfs_trace.h"
 #include "xfs_sysctl.h"
 #include "xfs_pwork.h"
+#include <linux/nmi.h>
 
 /*
  * Parallel Work Queue
@@ -46,6 +47,8 @@ xfs_pwork_work(
 	error = pctl->work_fn(pctl->mp, pwork);
 	if (error && !pctl->error)
 		pctl->error = error;
+	atomic_dec(&pctl->nr_work);
+	wake_up(&pctl->poll_wait);
 }
 
 /*
@@ -76,6 +79,8 @@ xfs_pwork_init(
 	pctl->work_fn = work_fn;
 	pctl->error = 0;
 	pctl->mp = mp;
+	atomic_set(&pctl->nr_work, 0);
+	init_waitqueue_head(&pctl->poll_wait);
 
 	return 0;
 }
@@ -88,6 +93,7 @@ xfs_pwork_queue(
 {
 	INIT_WORK(&pwork->work, xfs_pwork_work);
 	pwork->pctl = pctl;
+	atomic_inc(&pctl->nr_work);
 	queue_work(pctl->wq, &pwork->work);
 }
 
@@ -101,6 +107,19 @@ xfs_pwork_destroy(
 	return pctl->error;
 }
 
+/*
+ * Wait for the work to finish by polling completion status and touch the soft
+ * lockup watchdog.  This is for callers such as mount which hold locks.
+ */
+void
+xfs_pwork_poll(
+	struct xfs_pwork_ctl	*pctl)
+{
+	while (wait_event_timeout(pctl->poll_wait,
+				atomic_read(&pctl->nr_work) == 0, HZ) == 0)
+		touch_softlockup_watchdog();
+}
+
 /*
  * Return the amount of parallelism that the data device can handle, or 0 for
  * no limit.
diff --git a/fs/xfs/xfs_pwork.h b/fs/xfs/xfs_pwork.h
index 4cf1a6f48237..ff93873df8d3 100644
--- a/fs/xfs/xfs_pwork.h
+++ b/fs/xfs/xfs_pwork.h
@@ -18,6 +18,8 @@ struct xfs_pwork_ctl {
 	struct workqueue_struct	*wq;
 	struct xfs_mount	*mp;
 	xfs_pwork_work_fn	work_fn;
+	struct wait_queue_head	poll_wait;
+	atomic_t		nr_work;
 	int			error;
 };
 
@@ -53,6 +55,7 @@ int xfs_pwork_init(struct xfs_mount *mp, struct xfs_pwork_ctl *pctl,
 		unsigned int nr_threads);
 void xfs_pwork_queue(struct xfs_pwork_ctl *pctl, struct xfs_pwork *pwork);
 int xfs_pwork_destroy(struct xfs_pwork_ctl *pctl);
+void xfs_pwork_poll(struct xfs_pwork_ctl *pctl);
 unsigned int xfs_pwork_guess_datadev_parallelism(struct xfs_mount *mp);
 
 #endif /* __XFS_PWORK_H__ */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 8004c931c86e..8bb902125403 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1304,7 +1304,7 @@ xfs_qm_quotacheck(
 		flags |= XFS_PQUOTA_CHKD;
 	}
 
-	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, NULL);
+	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, true, NULL);
 	if (error)
 		goto error_return;
 
