Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A74EC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F63320679
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbhAZXDF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:03:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:55550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731405AbhAZFFd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jan 2021 00:05:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2618221E7;
        Tue, 26 Jan 2021 05:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611637492;
        bh=2XCDiilTGYCm9oD11g4DuWR7sWgFHudXHdRynDx7sG0=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=ENv29U1Rga9EY9/e/ZSljmnrTio27OhSAjPq/jFucQVrwn0QhfvLJhNPoPfx10oH6
         S6hNOZOU3Rq4zbaQX9m+WQIgAj4+bpLfjZL2v77Rhb4IQB3DgaK3J5mlky/sMbSqp6
         zWtnVhmNKtortAn/j8kyJWvFBxu76NijU0xB1DfbtjWeU/54P49YsFGcwGgnyu2/xB
         EpDRlpBeI+BhPRYOvJMwtPkpVn1iigJm7vXTZQJbqhqP++4Z27XbmmVOMBXeWV3bEC
         ewuu9gopK5/hRmLNswXF78vVBp10iQIXps18vTrJnnLcGWV9HfF6C/i43qcomzs0vs
         s6JGqg+tDTjVA==
Date:   Mon, 25 Jan 2021 21:04:52 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: [PATCH v2.1 1/3] xfs: increase the default parallelism levels of
 pwork clients
Message-ID: <20210126050452.GS7698@magnolia>
References: <161142798284.2173328.11591192629841647898.stgit@magnolia>
 <161142798840.2173328.10025204233532508235.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142798840.2173328.10025204233532508235.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Increase the parallelism level for pwork clients to the workqueue
defaults so that we can take advantage of computers with a lot of CPUs
and a lot of hardware.  On fast systems this will speed up quotacheck by
a large factor, and the following posteof/cowblocks cleanup series will
use the functionality presented in this patch to run garbage collection
as quickly as possible.

We do this by switching the pwork workqueue to unbounded, since the
current user (quotacheck) runs lengthy scans for each work item and we
don't care about dispatching the work on a warm cpu cache or anything
like that.  Also set WQ_SYSFS so that we can monitor where the wq is
running.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2.1: document the workqueue knobs, kill the nr_threads argument to
pwork, and convert it to unbounded all in one patch
---
 Documentation/admin-guide/xfs.rst |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iwalk.c                |    5 +----
 fs/xfs/xfs_pwork.c                |   25 +++++--------------------
 fs/xfs/xfs_pwork.h                |    4 +---
 4 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index 86de8a1ad91c..5fd14556c6fe 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -495,3 +495,36 @@ the class and error context. For example, the default values for
 "metadata/ENODEV" are "0" rather than "-1" so that this error handler defaults
 to "fail immediately" behaviour. This is done because ENODEV is a fatal,
 unrecoverable error no matter how many times the metadata IO is retried.
+
+Workqueue Concurrency
+=====================
+
+XFS uses kernel workqueues to parallelize metadata update processes.  This
+enables it to take advantage of storage hardware that can service many IO
+operations simultaneously.
+
+The control knobs for a filesystem's workqueues are organized by task at hand
+and the short name of the data device.  They all can be found in:
+
+  /sys/bus/workqueue/devices/${task}!${device}
+
+================  ===========
+  Task            Description
+================  ===========
+  xfs_iwalk-$pid  Inode scans of the entire filesystem. Currently limited to
+                  mount time quotacheck.
+================  ===========
+
+For example, the knobs for the quotacheck workqueue for /dev/nvme0n1 would be
+found in /sys/bus/workqueue/devices/xfs_iwalk-1111!nvme0n1/.
+
+The interesting knobs for XFS workqueues are as follows:
+
+============     ===========
+  Knob           Description
+============     ===========
+  max_active     Maximum number of background threads that can be started to
+                 run the work.
+  cpumask        CPUs upon which the threads are allowed to run.
+  nice           Relative priority of scheduling the threads.  These are the
+                 same nice levels that can be applied to userspace processes.
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index eae3aff9bc97..c4a340f1f1e1 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -618,15 +618,12 @@ xfs_iwalk_threaded(
 {
 	struct xfs_pwork_ctl	pctl;
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
-	unsigned int		nr_threads;
 	int			error;
 
 	ASSERT(agno < mp->m_sb.sb_agcount);
 	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
 
-	nr_threads = xfs_pwork_guess_datadev_parallelism(mp);
-	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk",
-			nr_threads);
+	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk");
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
index b03333f1c84a..c283b801cc5d 100644
--- a/fs/xfs/xfs_pwork.c
+++ b/fs/xfs/xfs_pwork.c
@@ -61,16 +61,18 @@ xfs_pwork_init(
 	struct xfs_mount	*mp,
 	struct xfs_pwork_ctl	*pctl,
 	xfs_pwork_work_fn	work_fn,
-	const char		*tag,
-	unsigned int		nr_threads)
+	const char		*tag)
 {
+	unsigned int		nr_threads = 0;
+
 #ifdef DEBUG
 	if (xfs_globals.pwork_threads >= 0)
 		nr_threads = xfs_globals.pwork_threads;
 #endif
 	trace_xfs_pwork_init(mp, nr_threads, current->pid);
 
-	pctl->wq = alloc_workqueue("%s-%d", WQ_FREEZABLE, nr_threads, tag,
+	pctl->wq = alloc_workqueue("%s-%d",
+			WQ_UNBOUND | WQ_SYSFS | WQ_FREEZABLE, nr_threads, tag,
 			current->pid);
 	if (!pctl->wq)
 		return -ENOMEM;
@@ -117,20 +119,3 @@ xfs_pwork_poll(
 				atomic_read(&pctl->nr_work) == 0, HZ) == 0)
 		touch_softlockup_watchdog();
 }
-
-/*
- * Return the amount of parallelism that the data device can handle, or 0 for
- * no limit.
- */
-unsigned int
-xfs_pwork_guess_datadev_parallelism(
-	struct xfs_mount	*mp)
-{
-	struct xfs_buftarg	*btp = mp->m_ddev_targp;
-
-	/*
-	 * For now we'll go with the most conservative setting possible,
-	 * which is two threads for an SSD and 1 thread everywhere else.
-	 */
-	return blk_queue_nonrot(btp->bt_bdev->bd_disk->queue) ? 2 : 1;
-}
diff --git a/fs/xfs/xfs_pwork.h b/fs/xfs/xfs_pwork.h
index 8133124cf3bb..c0ef81fc85dd 100644
--- a/fs/xfs/xfs_pwork.h
+++ b/fs/xfs/xfs_pwork.h
@@ -51,11 +51,9 @@ xfs_pwork_want_abort(
 }
 
 int xfs_pwork_init(struct xfs_mount *mp, struct xfs_pwork_ctl *pctl,
-		xfs_pwork_work_fn work_fn, const char *tag,
-		unsigned int nr_threads);
+		xfs_pwork_work_fn work_fn, const char *tag);
 void xfs_pwork_queue(struct xfs_pwork_ctl *pctl, struct xfs_pwork *pwork);
 int xfs_pwork_destroy(struct xfs_pwork_ctl *pctl);
 void xfs_pwork_poll(struct xfs_pwork_ctl *pctl);
-unsigned int xfs_pwork_guess_datadev_parallelism(struct xfs_mount *mp);
 
 #endif /* __XFS_PWORK_H__ */
