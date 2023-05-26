Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B5BC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjEZBEY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZBEX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:04:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D46198
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:04:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93D52647D0
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A86C433EF;
        Fri, 26 May 2023 01:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063060;
        bh=PEravxgEVibCoBl0ea3dTIDWON7Sb7el+N5RqyX2YzM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=CU1XwW2IAxzv3agCSzdIUZbYdK4JsrHcmrUd19YrM3cqlOMyEPFzWsTo58+BbsImi
         LPOEJv3hCcZPVqq/AFyHvYbaCbV+uJj1Xa949WvBozWH9/kqAlyJPoEfKGwcTXZMDF
         L/PvavcLaRbnDh2TeQgUWrQlAkB2+tmNCCZyJis+IEIwl3pRnb9+z1jvR/9t9uUYLZ
         DUY/LHTE5Q0uqgvdjZuLxWV68QqidCIYBZah4bNVr/pHyJdAdsdLhrENbgk9Ci3klb
         QtDtYvD+9tyf7UamXAdpWPc6EBBcW8r7nK2EdBevXMsC/TOfBHYhiOctcaZ2fAYSli
         n7rGx55PVSROw==
Date:   Thu, 25 May 2023 18:04:19 -0700
Subject: [PATCH 2/3] xfs: stabilize fs summary counters for online fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506061516.3732954.7337809739895421067.stgit@frogsfrogsfrogs>
In-Reply-To: <168506061483.3732954.5178462816967376906.stgit@frogsfrogsfrogs>
References: <168506061483.3732954.5178462816967376906.stgit@frogsfrogsfrogs>
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
changing the freeze level by calling freeze_super_excl with a custom
freeze cookie to keep everyone else out of the filesystem.

The end result is that fscounters should be much more efficient.  When
we're checking a busy system and we can't stabilize the counters, the
custom freeze will do less work, which should result in less downtime.
Repair should be similarly speedy, but that's in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/fscounters.c |  172 +++++++++++++++++++++++++++++++++------------
 fs/xfs/scrub/fscounters.h |   20 +++++
 fs/xfs/scrub/scrub.c      |    6 +-
 fs/xfs/scrub/scrub.h      |    1 
 fs/xfs/scrub/trace.h      |    1 
 5 files changed, 152 insertions(+), 48 deletions(-)
 create mode 100644 fs/xfs/scrub/fscounters.h


diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index e382a35e98d8..d9f51fa66a0e 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2019-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
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
@@ -123,6 +115,58 @@ xchk_fscount_warmup(
 	return error;
 }
 
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
+	int			error = 0;
+
+	if (sc->flags & XCHK_HAVE_FREEZE_PROT) {
+		sc->flags &= ~XCHK_HAVE_FREEZE_PROT;
+		mnt_drop_write_file(sc->file);
+	}
+
+	/* Wait until we're ready to freeze or give up. */
+	while (freeze_super_kernel(mp->m_super) != 0) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		delay(HZ / 10);
+	}
+
+	fsc->frozen = true;
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
+	int			error;
+
+	if (!fsc->frozen)
+		return;
+
+	/* This should always succeed, we froze the fs exclusively. */
+	error = thaw_super_kernel(mp->m_super);
+	if (error)
+		xfs_emerg(mp, "still frozen after scrub, err=%d", error);
+}
+
 int
 xchk_setup_fscounters(
 	struct xfs_scrub	*sc)
@@ -140,6 +184,7 @@ xchk_setup_fscounters(
 	sc->buf = kzalloc(sizeof(struct xchk_fscounters), XCHK_GFP_FLAGS);
 	if (!sc->buf)
 		return -ENOMEM;
+	sc->buf_cleanup = xchk_fscounters_cleanup;
 	fsc = sc->buf;
 	fsc->sc = sc;
 
@@ -150,7 +195,18 @@ xchk_setup_fscounters(
 	if (error)
 		return error;
 
-	return xchk_trans_alloc(sc, 0);
+	/*
+	 * Pause all writer activity in the filesystem while we're scrubbing to
+	 * reduce the likelihood of background perturbations to the counters
+	 * throwing off our calculations.
+	 */
+	if (sc->flags & XCHK_TRY_HARDER) {
+		error = xchk_fscounters_freeze(sc);
+		if (error)
+			return error;
+	}
+
+	return xchk_trans_alloc_empty(sc);
 }
 
 /*
@@ -290,8 +346,7 @@ xchk_fscount_aggregate_agcounts(
 	if (fsc->ifree > fsc->icount) {
 		if (tries--)
 			goto retry;
-		xchk_set_incomplete(sc);
-		return 0;
+		return -EDEADLOCK;
 	}
 
 	return 0;
@@ -367,6 +422,8 @@ xchk_fscount_count_frextents(
  * Otherwise, we /might/ have a problem.  If the change in the summations is
  * more than we want to tolerate, the filesystem is probably busy and we should
  * just send back INCOMPLETE and see if userspace will try again.
+ *
+ * If we're repairing then we require an exact match.
  */
 static inline bool
 xchk_fscount_within_range(
@@ -396,21 +453,7 @@ xchk_fscount_within_range(
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
 
@@ -422,6 +465,7 @@ xchk_fscounters(
 	struct xfs_mount	*mp = sc->mp;
 	struct xchk_fscounters	*fsc = sc->buf;
 	int64_t			icount, ifree, fdblocks, frextents;
+	bool			try_again = false;
 	int			error;
 
 	/* Snapshot the percpu counters. */
@@ -431,9 +475,26 @@ xchk_fscounters(
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
@@ -446,12 +507,6 @@ xchk_fscounters(
 	if (frextents > mp->m_sb.sb_rextents)
 		xchk_set_corrupt(sc);
 
-	/*
-	 * XXX: We can't quiesce percpu counter updates, so exit early.
-	 * This can be re-enabled when we gain exclusive freeze functionality.
-	 */
-	return 0;
-
 	/*
 	 * If ifree exceeds icount by more than the minimum variance then
 	 * something's probably wrong with the counters.
@@ -463,8 +518,6 @@ xchk_fscounters(
 	error = xchk_fscount_aggregate_agcounts(sc, fsc);
 	if (!xchk_process_error(sc, 0, XFS_SB_BLOCK(mp), &error))
 		return error;
-	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
-		return 0;
 
 	/* Count the free extents counter for rt volumes. */
 	error = xchk_fscount_count_frextents(sc, fsc);
@@ -473,20 +526,45 @@ xchk_fscounters(
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
index 000000000000..b36f7157986f
--- /dev/null
+++ b/fs/xfs/scrub/fscounters.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2021-2023 Oracle.  All Rights Reserved.
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
index d4396c351373..e487b424b12b 100644
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
 	if (sc->xfile) {
 		xfile_destroy(sc->xfile);
 		sc->xfile = NULL;
@@ -539,6 +541,8 @@ xfs_scrub_metadata(
 		error = mnt_want_write_file(sc->file);
 		if (error)
 			goto out_sc;
+
+		sc->flags |= XCHK_HAVE_FREEZE_PROT;
 	}
 
 	/* Set up for the operation. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 99b48e996d51..a41ba8d319b6 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -118,6 +118,7 @@ struct xfs_scrub {
 
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */
 #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
+#define XCHK_HAVE_FREEZE_PROT	(1 << 1)  /* do we have freeze protection? */
 #define XCHK_FSGATES_DRAIN	(1 << 2)  /* defer ops draining enabled */
 #define XCHK_NEED_DRAIN		(1 << 3)  /* scrub needs to drain defer ops */
 #define XCHK_FSGATES_QUOTA	(1 << 4)  /* quota live update enabled */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d4f142929518..6a50e6c89195 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -113,6 +113,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 
 #define XFS_SCRUB_STATE_STRINGS \
 	{ XCHK_TRY_HARDER,			"try_harder" }, \
+	{ XCHK_HAVE_FREEZE_PROT,		"nofreeze" }, \
 	{ XCHK_FSGATES_DRAIN,			"fsgates_drain" }, \
 	{ XCHK_NEED_DRAIN,			"need_drain" }, \
 	{ XCHK_FSGATES_QUOTA,			"fsgates_quota" }, \

