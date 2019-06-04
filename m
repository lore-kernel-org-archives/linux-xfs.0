Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59034 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfFDVub (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:50:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LnuaD053576
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:50:30 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2sugstfpan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:50:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LmmTQ172010
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:50:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2swngkkj6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:50:28 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x54LoS6K025239
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:50:28 GMT
Subject: [PATCH 09/10] xfs: poll waiting for quotacheck
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 04 Jun 2019 14:50:27 -0700
Message-ID: <155968502703.1657646.17911228005649046316.stgit@magnolia>
In-Reply-To: <155968496814.1657646.13743491598480818627.stgit@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a pwork destroy function that uses polling instead of
uninterruptible sleep to wait for work items to finish so that we can
touch the softlockup watchdog.  IOWs, gross hack.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iwalk.c |    3 +++
 fs/xfs/xfs_iwalk.h |    3 ++-
 fs/xfs/xfs_pwork.c |   21 +++++++++++++++++++++
 fs/xfs/xfs_pwork.h |    2 ++
 fs/xfs/xfs_qm.c    |    2 +-
 5 files changed, 29 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 71ee1628aa70..c4a9c4c246b7 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -526,6 +526,7 @@ xfs_iwalk_threaded(
 	xfs_ino_t		startino,
 	xfs_iwalk_fn		iwalk_fn,
 	unsigned int		max_prefetch,
+	bool			polled,
 	void			*data)
 {
 	struct xfs_pwork_ctl	pctl;
@@ -556,5 +557,7 @@ xfs_iwalk_threaded(
 		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
 	}
 
+	if (polled)
+		return xfs_pwork_destroy_poll(&pctl);
 	return xfs_pwork_destroy(&pctl);
 }
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 40233a05a766..76d8f87a39ef 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -15,6 +15,7 @@ typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
 		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
 int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
-		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
+		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, bool poll,
+		void *data);
 
 #endif /* __XFS_IWALK_H__ */
diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
index 19605a3a2482..3b885e0b52ac 100644
--- a/fs/xfs/xfs_pwork.c
+++ b/fs/xfs/xfs_pwork.c
@@ -13,6 +13,7 @@
 #include "xfs_trace.h"
 #include "xfs_sysctl.h"
 #include "xfs_pwork.h"
+#include <linux/nmi.h>
 
 /*
  * Parallel Work Queue
@@ -44,6 +45,7 @@ xfs_pwork_work(
 	error = pctl->work_fn(pctl->mp, pwork);
 	if (error && !pctl->error)
 		pctl->error = error;
+	atomic_dec(&pctl->nr_work);
 }
 
 /*
@@ -72,6 +74,7 @@ xfs_pwork_init(
 	pctl->work_fn = work_fn;
 	pctl->error = 0;
 	pctl->mp = mp;
+	atomic_set(&pctl->nr_work, 0);
 
 	return 0;
 }
@@ -84,6 +87,7 @@ xfs_pwork_queue(
 {
 	INIT_WORK(&pwork->work, xfs_pwork_work);
 	pwork->pctl = pctl;
+	atomic_inc(&pctl->nr_work);
 	queue_work(pctl->wq, &pwork->work);
 }
 
@@ -97,6 +101,23 @@ xfs_pwork_destroy(
 	return pctl->error;
 }
 
+/*
+ * Wait for the work to finish and tear down the control structure.
+ * Continually poll completion status and touch the soft lockup watchdog.
+ * This is for things like mount that hold locks.
+ */
+int
+xfs_pwork_destroy_poll(
+	struct xfs_pwork_ctl	*pctl)
+{
+	while (atomic_read(&pctl->nr_work) > 0) {
+		msleep(1);
+		touch_softlockup_watchdog();
+	}
+
+	return xfs_pwork_destroy(pctl);
+}
+
 /*
  * Return the amount of parallelism that the data device can handle, or 0 for
  * no limit.
diff --git a/fs/xfs/xfs_pwork.h b/fs/xfs/xfs_pwork.h
index e0c1354a2d8c..08da723a8dc9 100644
--- a/fs/xfs/xfs_pwork.h
+++ b/fs/xfs/xfs_pwork.h
@@ -18,6 +18,7 @@ struct xfs_pwork_ctl {
 	struct workqueue_struct	*wq;
 	struct xfs_mount	*mp;
 	xfs_pwork_work_fn	work_fn;
+	atomic_t		nr_work;
 	int			error;
 };
 
@@ -45,6 +46,7 @@ int xfs_pwork_init(struct xfs_mount *mp, struct xfs_pwork_ctl *pctl,
 		unsigned int nr_threads);
 void xfs_pwork_queue(struct xfs_pwork_ctl *pctl, struct xfs_pwork *pwork);
 int xfs_pwork_destroy(struct xfs_pwork_ctl *pctl);
+int xfs_pwork_destroy_poll(struct xfs_pwork_ctl *pctl);
 unsigned int xfs_pwork_guess_datadev_parallelism(struct xfs_mount *mp);
 
 #endif /* __XFS_PWORK_H__ */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e4f3785f7a64..de6a623ada02 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1305,7 +1305,7 @@ xfs_qm_quotacheck(
 		flags |= XFS_PQUOTA_CHKD;
 	}
 
-	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, NULL);
+	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, true, NULL);
 	if (error)
 		goto error_return;
 
