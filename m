Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88121C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6118F64DE0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhA1GER (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:04:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:38432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231205AbhA1GEP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:04:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D58E664DDB;
        Thu, 28 Jan 2021 06:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813815;
        bh=0GDnvuQovl3y47G3zLkmJbA/n0tyir7PybFmEKEiWJ0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MtK6Ht9QPyI3ANN0Sgsq3uK5izJApJxhFPZSroC1hFl2lr6POhWibltcu6xXLDDSE
         WOKrRMWwIlro+VhTiw3WQH9vlDgyhCoAUZ6KDjhvk3gXR2EY0PaR+dMH5TnoGQDwV+
         BLyE9l+XYMAf+Xlhk6A2QZtMNI2Cr48kq4qi5zMl8y1KT3/Kfw9OpQQWOzTCE/gLvF
         69wyvfDa9jP5AKlvlgO1yKJFTC3Pv9HTzHx9q+7ZTbtIkQQDnO7knpin1C5cnnKPpH
         9E6Nqc+5Xwk20C6Th8Z1zNxaB1nfvvJb/tJe99ZQVb3ROgVScVnDiUko2sCL5/vK5b
         bePHkl/00+ygw==
Subject: [PATCH 1/2] xfs: increase the default parallelism levels of pwork
 clients
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:03:31 -0800
Message-ID: <161181381108.1525344.3612916862426784356.stgit@magnolia>
In-Reply-To: <161181380539.1525344.442839530784024643.stgit@magnolia>
References: <161181380539.1525344.442839530784024643.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
 Documentation/admin-guide/xfs.rst |   38 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iwalk.c                |    5 +----
 fs/xfs/xfs_pwork.c                |   25 +++++-------------------
 fs/xfs/xfs_pwork.h                |    4 +---
 4 files changed, 45 insertions(+), 27 deletions(-)


diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index 86de8a1ad91c..b00b1eece9de 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -495,3 +495,41 @@ the class and error context. For example, the default values for
 "metadata/ENODEV" are "0" rather than "-1" so that this error handler defaults
 to "fail immediately" behaviour. This is done because ENODEV is a fatal,
 unrecoverable error no matter how many times the metadata IO is retried.
+
+Workqueue Concurrency
+=====================
+
+XFS uses kernel workqueues to parallelize metadata update processes.  This
+enables it to take advantage of storage hardware that can service many IO
+operations simultaneously.  This interface exposes internal implementation
+details of XFS, and as such is explicitly not part of any userspace API/ABI
+guarantee the kernel may give userspace.  These are undocumented features of
+the generic workqueue implementation XFS uses for concurrency, and they are
+provided here purely for diagnostic and tuning purposes and may change at any
+time in the future.
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

