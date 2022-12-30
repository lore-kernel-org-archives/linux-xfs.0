Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241ECC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbiL3Xkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3Xki (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:40:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DF91DF16
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:40:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CD03B81DCA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0F9C433D2;
        Fri, 30 Dec 2022 23:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443633;
        bh=rBTFWYVbiACk2lQZlOpLBcXkkOj5drJTKlz0h3DTkAM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tVj7/rpRvaeCcqL//E1hZTzW+zLIVbHAI1PdMeUKT3O+Ap7un4FUMmeQrWqDcZC2M
         I0MH4kE7yErSW4l9+4uv6lYtEOqXBtq39SVP01UddAOkar+jqdlaS29pz8bRWedzXv
         hYUSjx4TU7wwq4/Rlla2kpHjTHCuiN1L8HMExG1FsYCsoF0fL4gXcmBSzr7ECfmEKh
         ZQ8QeP6ZTQywagfB7OOUJ9DyC5jVByNkW5PtW/k/5/Ie96+DxhE7VwA2UXwTx0Ua1/
         WyHgyxWC8BSdNp5VdjYiJvOyQMnSOy54qxOer43I4VbncHJEgANAfY1/J7X3o4zfeZ
         M3lrJ1euUx8gQ==
Subject: [PATCH 1/3] xfs: stabilize fs summary counters for online fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:22 -0800
Message-ID: <167243840263.696415.3724214468111049949.stgit@magnolia>
In-Reply-To: <167243840246.696415.12006477739455537131.stgit@magnolia>
References: <167243840246.696415.12006477739455537131.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the fscounters scrubber notices incorrect summary counters, it's
entirely possible that scrub is simply racing with other threads that
are updating the incore counters.  There isn't a good way to stabilize
percpu counters or set ourselves up to observe live updates with hooks
like we do for the quotacheck or nlinks scanners, so we instead choose
to freeze the filesystem long enough to walk the incore per-AG
structures.

Past me thought that it was going to be commonplace to have to freeze
the filesystem to perform some kind of repair and set up a whole
separate infrastructure to freeze the filesystem in such a way that
userspace could not unfreeze while we were running.  This involved
adding a mutex and freeze_super/thaw_super functions and dealing with
the fact that the VFS freeze/thaw functions can free the VFS superblock
references on return.

This was all very overwrought, since fscounters turned out to be the
only user of scrub freezes, and it doesn't require the log to quiesce,
only the incore superblock counters.  We prevent other threads from
changing the freeze level by adding a new SB_FREEZE_EXCLUSIVE level.

The end result is that fscounters should be much more efficient.  When
we're checking a busy system and we can't stabilize the counters, the
custom freeze will do less work, which should result in less downtime.
Repair should be similarly speedy, but that's in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/fscounters.c |  251 +++++++++++++++++++++++++++++++++++++--------
 fs/xfs/scrub/fscounters.h |   20 ++++
 fs/xfs/scrub/scrub.c      |    6 +
 fs/xfs/scrub/scrub.h      |    1 
 fs/xfs/scrub/trace.h      |    1 
 5 files changed, 233 insertions(+), 46 deletions(-)
 create mode 100644 fs/xfs/scrub/fscounters.h


diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 63755ba4fc0e..e90e59c2e565 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2019 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
@@ -16,9 +16,11 @@
 #include "xfs_ag.h"
 #include "xfs_rtalloc.h"
 #include "xfs_inode.h"
+#include "xfs_icache.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
+#include "scrub/fscounters.h"
 
 /*
  * FS Summary Counters
@@ -45,16 +47,6 @@
  * our tolerance for mismatch between expected and actual counter values.
  */
 
-struct xchk_fscounters {
-	struct xfs_scrub	*sc;
-	uint64_t		icount;
-	uint64_t		ifree;
-	uint64_t		fdblocks;
-	uint64_t		frextents;
-	unsigned long long	icount_min;
-	unsigned long long	icount_max;
-};
-
 /*
  * Since the expected value computation is lockless but only browses incore
  * values, the percpu counters should be fairly close to each other.  However,
@@ -121,6 +113,142 @@ xchk_fscount_warmup(
 	return error;
 }
 
+#define SB_FREEZE_EXCLUSIVE	(SB_FREEZE_COMPLETE + 1)
+
+/*
+ * We couldn't stabilize the filesystem long enough to sample all the variables
+ * that comprise the summary counters and compare them to the percpu counters.
+ * We need to disable all writer threads, which means taking the first two
+ * freeze levels to put userspace to sleep, and the third freeze level to
+ * prevent background threads from starting new transactions.  Take one level
+ * more to prevent other callers from unfreezing the filesystem while we run.
+ */
+STATIC int
+xchk_fscounters_freeze(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_fscounters	*fsc = sc->buf;
+	struct xfs_mount	*mp = sc->mp;
+	struct super_block	*sb = mp->m_super;
+	int			level;
+	int			error = 0;
+
+	if (sc->flags & XCHK_HAVE_FREEZE_PROT) {
+		sc->flags &= ~XCHK_HAVE_FREEZE_PROT;
+		mnt_drop_write_file(sc->file);
+	}
+
+	/* Wait until we're ready to freeze or give up. */
+	down_write(&sb->s_umount);
+	while (sb->s_writers.frozen != SB_UNFROZEN) {
+		up_write(&sb->s_umount);
+
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		delay(HZ / 10);
+		down_write(&sb->s_umount);
+	}
+
+	if (sb_rdonly(sb)) {
+		sb->s_writers.frozen = SB_FREEZE_EXCLUSIVE;
+		goto done;
+	}
+
+	sb->s_writers.frozen = SB_FREEZE_WRITE;
+	/* Release s_umount to preserve sb_start_write -> s_umount ordering */
+	up_write(&sb->s_umount);
+	percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_WRITE - 1);
+	down_write(&sb->s_umount);
+
+	/* Now we go and block page faults... */
+	sb->s_writers.frozen = SB_FREEZE_PAGEFAULT;
+	percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_PAGEFAULT - 1);
+
+	/*
+	 * All writers are done so after syncing there won't be dirty data.
+	 * Let xfs_fs_sync_fs flush dirty data so the VFS won't start writeback
+	 * and to disable the background gc workers.
+	 */
+	error = sync_filesystem(sb);
+	if (error) {
+		sb->s_writers.frozen = SB_UNFROZEN;
+		for (level = SB_FREEZE_PAGEFAULT - 1; level >= 0; level--)
+			percpu_up_write(sb->s_writers.rw_sem + level);
+		wake_up(&sb->s_writers.wait_unfrozen);
+		up_write(&sb->s_umount);
+		return error;
+	}
+
+	/* Now wait for internal filesystem counter */
+	sb->s_writers.frozen = SB_FREEZE_FS;
+	percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_FS - 1);
+
+	/*
+	 * We do not need to quiesce the log to check the summary counters, so
+	 * skip the call to xfs_fs_freeze here.  To prevent anyone else from
+	 * unfreezing us, set the VFS freeze level to one higher than
+	 * FREEZE_COMPLETE.
+	 */
+	sb->s_writers.frozen = SB_FREEZE_EXCLUSIVE;
+	for (level = SB_FREEZE_LEVELS - 1; level >= 0; level--)
+		percpu_rwsem_release(sb->s_writers.rw_sem + level, 0,
+				_THIS_IP_);
+done:
+	fsc->frozen = true;
+	up_write(&sb->s_umount);
+	return 0;
+}
+
+/* Thaw the filesystem after checking or repairing fscounters. */
+STATIC void
+xchk_fscounters_cleanup(
+	void			*buf)
+{
+	struct xchk_fscounters	*fsc = buf;
+	struct xfs_scrub	*sc = fsc->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct super_block	*sb = mp->m_super;
+	int			level;
+
+	if (!fsc->frozen)
+		return;
+
+	down_write(&sb->s_umount);
+	if (sb->s_writers.frozen != SB_FREEZE_EXCLUSIVE) {
+		/* somebody snuck in and unfroze us? */
+		ASSERT(0);
+		up_write(&sb->s_umount);
+		return;
+	}
+
+	if (sb_rdonly(sb)) {
+		sb->s_writers.frozen = SB_UNFROZEN;
+		goto out;
+	}
+
+	for (level = 0; level < SB_FREEZE_LEVELS; ++level)
+		percpu_rwsem_acquire(sb->s_writers.rw_sem + level, 0,
+				_THIS_IP_);
+
+	/*
+	 * We didn't call xfs_fs_freeze, so we can't call xfs_fs_thaw.  Start
+	 * the background gc workers that were shut down by xfs_fs_sync_fs
+	 * when we froze.
+	 */
+	xfs_blockgc_start(mp);
+	xfs_inodegc_start(mp);
+
+	sb->s_writers.frozen = SB_UNFROZEN;
+	for (level = SB_FREEZE_LEVELS - 1; level >= 0; level--)
+		percpu_up_write(sb->s_writers.rw_sem + level);
+out:
+	wake_up(&sb->s_writers.wait_unfrozen);
+	fsc->frozen = false;
+	up_write(&sb->s_umount);
+	return;
+}
+
 int
 xchk_setup_fscounters(
 	struct xfs_scrub	*sc)
@@ -138,6 +266,7 @@ xchk_setup_fscounters(
 	sc->buf = kzalloc(sizeof(struct xchk_fscounters), XCHK_GFP_FLAGS);
 	if (!sc->buf)
 		return -ENOMEM;
+	sc->buf_cleanup = xchk_fscounters_cleanup;
 	fsc = sc->buf;
 	fsc->sc = sc;
 
@@ -149,13 +278,17 @@ xchk_setup_fscounters(
 		return error;
 
 	/*
-	 * Pause background reclaim while we're scrubbing to reduce the
-	 * likelihood of background perturbations to the counters throwing off
-	 * our calculations.
+	 * Pause all writer activity in the filesystem while we're scrubbing to
+	 * reduce the likelihood of background perturbations to the counters
+	 * throwing off our calculations.
 	 */
-	xchk_stop_reaping(sc);
+	if (sc->flags & XCHK_TRY_HARDER) {
+		error = xchk_fscounters_freeze(sc);
+		if (error)
+			return error;
+	}
 
-	return xchk_trans_alloc(sc, 0);
+	return xchk_trans_alloc_empty(sc);
 }
 
 /*
@@ -294,8 +427,7 @@ xchk_fscount_aggregate_agcounts(
 	if (fsc->ifree > fsc->icount) {
 		if (tries--)
 			goto retry;
-		xchk_set_incomplete(sc);
-		return 0;
+		return -EDEADLOCK;
 	}
 
 	return 0;
@@ -371,6 +503,8 @@ xchk_fscount_count_frextents(
  * Otherwise, we /might/ have a problem.  If the change in the summations is
  * more than we want to tolerate, the filesystem is probably busy and we should
  * just send back INCOMPLETE and see if userspace will try again.
+ *
+ * If we're repairing then we require an exact match.
  */
 static inline bool
 xchk_fscount_within_range(
@@ -400,21 +534,7 @@ xchk_fscount_within_range(
 	if (expected >= min_value && expected <= max_value)
 		return true;
 
-	/*
-	 * If the difference between the two summations is too large, the fs
-	 * might just be busy and so we'll mark the scrub incomplete.  Return
-	 * true here so that we don't mark the counter corrupt.
-	 *
-	 * XXX: In the future when userspace can grant scrub permission to
-	 * quiesce the filesystem to solve the outsized variance problem, this
-	 * check should be moved up and the return code changed to signal to
-	 * userspace that we need quiesce permission.
-	 */
-	if (max_value - min_value >= XCHK_FSCOUNT_MIN_VARIANCE) {
-		xchk_set_incomplete(sc);
-		return true;
-	}
-
+	/* Everything else is bad. */
 	return false;
 }
 
@@ -426,6 +546,7 @@ xchk_fscounters(
 	struct xfs_mount	*mp = sc->mp;
 	struct xchk_fscounters	*fsc = sc->buf;
 	int64_t			icount, ifree, fdblocks, frextents;
+	bool			try_again = false;
 	int			error;
 
 	/* Snapshot the percpu counters. */
@@ -435,9 +556,26 @@ xchk_fscounters(
 	frextents = percpu_counter_sum(&mp->m_frextents);
 
 	/* No negative values, please! */
-	if (icount < 0 || ifree < 0 || fdblocks < 0 || frextents < 0)
+	if (icount < 0 || ifree < 0)
 		xchk_set_corrupt(sc);
 
+	/*
+	 * If the filesystem is not frozen, the counter summation calls above
+	 * can race with xfs_mod_freecounter, which subtracts a requested space
+	 * reservation from the counter and undoes the subtraction if that made
+	 * the counter go negative.  Therefore, it's possible to see negative
+	 * values here, and we should only flag that as a corruption if we
+	 * froze the fs.  This is much more likely to happen with frextents
+	 * since there are no reserved pools.
+	 */
+	if (fdblocks < 0 || frextents < 0) {
+		if (!fsc->frozen)
+			return -EDEADLOCK;
+
+		xchk_set_corrupt(sc);
+		return 0;
+	}
+
 	/* See if icount is obviously wrong. */
 	if (icount < fsc->icount_min || icount > fsc->icount_max)
 		xchk_set_corrupt(sc);
@@ -461,8 +599,6 @@ xchk_fscounters(
 	error = xchk_fscount_aggregate_agcounts(sc, fsc);
 	if (!xchk_process_error(sc, 0, XFS_SB_BLOCK(mp), &error))
 		return error;
-	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
-		return 0;
 
 	/* Count the free extents counter for rt volumes. */
 	error = xchk_fscount_count_frextents(sc, fsc);
@@ -471,20 +607,45 @@ xchk_fscounters(
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
 		return 0;
 
-	/* Compare the in-core counters with whatever we counted. */
-	if (!xchk_fscount_within_range(sc, icount, &mp->m_icount, fsc->icount))
-		xchk_set_corrupt(sc);
+	/*
+	 * Compare the in-core counters with whatever we counted.  If the fs is
+	 * frozen, we treat the discrepancy as a corruption because the freeze
+	 * should have stabilized the counter values.  Otherwise, we need
+	 * userspace to call us back having granted us freeze permission.
+	 */
+	if (!xchk_fscount_within_range(sc, icount, &mp->m_icount,
+				fsc->icount)) {
+		if (fsc->frozen)
+			xchk_set_corrupt(sc);
+		else
+			try_again = true;
+	}
 
-	if (!xchk_fscount_within_range(sc, ifree, &mp->m_ifree, fsc->ifree))
-		xchk_set_corrupt(sc);
+	if (!xchk_fscount_within_range(sc, ifree, &mp->m_ifree, fsc->ifree)) {
+		if (fsc->frozen)
+			xchk_set_corrupt(sc);
+		else
+			try_again = true;
+	}
 
 	if (!xchk_fscount_within_range(sc, fdblocks, &mp->m_fdblocks,
-			fsc->fdblocks))
-		xchk_set_corrupt(sc);
+			fsc->fdblocks)) {
+		if (fsc->frozen)
+			xchk_set_corrupt(sc);
+		else
+			try_again = true;
+	}
 
 	if (!xchk_fscount_within_range(sc, frextents, &mp->m_frextents,
-			fsc->frextents))
-		xchk_set_corrupt(sc);
+			fsc->frextents)) {
+		if (fsc->frozen)
+			xchk_set_corrupt(sc);
+		else
+			try_again = true;
+	}
+
+	if (try_again)
+		return -EDEADLOCK;
 
 	return 0;
 }
diff --git a/fs/xfs/scrub/fscounters.h b/fs/xfs/scrub/fscounters.h
new file mode 100644
index 000000000000..8c8af4ff3c91
--- /dev/null
+++ b/fs/xfs/scrub/fscounters.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_FSCOUNTERS_H__
+#define __XFS_SCRUB_FSCOUNTERS_H__
+
+struct xchk_fscounters {
+	struct xfs_scrub	*sc;
+	uint64_t		icount;
+	uint64_t		ifree;
+	uint64_t		fdblocks;
+	uint64_t		frextents;
+	unsigned long long	icount_min;
+	unsigned long long	icount_max;
+	bool			frozen;
+};
+
+#endif /* __XFS_SCRUB_FSCOUNTERS_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index a9d3f344f8af..6728b1409fea 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -187,8 +187,10 @@ xchk_teardown(
 		xchk_irele(sc, sc->ip);
 		sc->ip = NULL;
 	}
-	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+	if (sc->flags & XCHK_HAVE_FREEZE_PROT) {
+		sc->flags &= ~XCHK_HAVE_FREEZE_PROT;
 		mnt_drop_write_file(sc->file);
+	}
 	if (sc->flags & XCHK_REAPING_DISABLED)
 		xchk_start_reaping(sc);
 	if (sc->xfile) {
@@ -541,6 +543,8 @@ xfs_scrub_metadata(
 		error = mnt_want_write_file(sc->file);
 		if (error)
 			goto out_sc;
+
+		sc->flags |= XCHK_HAVE_FREEZE_PROT;
 	}
 
 	/* Set up for the operation. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index da9da6245475..12d1ba2aa83b 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -123,6 +123,7 @@ struct xfs_scrub {
 #define XCHK_NEED_DRAIN		(1 << 3)  /* scrub needs to use intent drain */
 #define XCHK_FSHOOKS_QUOTA	(1 << 4)  /* quota live update enabled */
 #define XCHK_FSHOOKS_NLINKS	(1 << 5)  /* link count live update enabled */
+#define XCHK_HAVE_FREEZE_PROT	(1 << 6)  /* do we have freeze protection? */
 #define XREP_RESET_PERAG_RESV	(1 << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index c723b6302bd6..19b2d569d0c8 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -113,6 +113,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 
 #define XFS_SCRUB_STATE_STRINGS \
 	{ XCHK_TRY_HARDER,			"try_harder" }, \
+	{ XCHK_HAVE_FREEZE_PROT,		"nofreeze" }, \
 	{ XCHK_REAPING_DISABLED,		"reaping_disabled" }, \
 	{ XCHK_FSHOOKS_DRAIN,			"fshooks_drain" }, \
 	{ XCHK_NEED_DRAIN,			"need_drain" }, \

