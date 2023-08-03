Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FF4C001DB
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Aug 2023 23:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjHCXad (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Aug 2023 19:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjHCXac (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2023 19:30:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DB61706
        for <linux-xfs@vger.kernel.org>; Thu,  3 Aug 2023 16:30:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09E1161EE4
        for <linux-xfs@vger.kernel.org>; Thu,  3 Aug 2023 23:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F020C433C8;
        Thu,  3 Aug 2023 23:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691105429;
        bh=+EPpeVIHEo05N2bjUIjWaRmaSpmvn8CpmpN06ZaOXCY=;
        h=Date:From:To:Subject:From;
        b=VWXA0zNkhY5cDOq7UskMSleyeMJd8mDrjMXKgWSvevZPwaeCbJQg0+q+vNdWDPZTf
         OtRTI3pCAw1IssDYYhqB9N5G1V2nLJm8QH4sPg7xOIEJwjIaTHhUdRo/zv9KAMJN5J
         0ytFJ1gcS1CaS2rLvCX8oUbmfLN9ILuZYl4+dD7Sk2pVcIUzoNitrgiylAD8f26BG5
         9IBucbVDE6zN5IdDKXmBzwO5stzBPVmK4kjJbfaCXGFYmjHNURhKDD9ETFsWLl8f5G
         bA+FJjNdEoAsTFx/QPV1jrkvUdldroXBu2m5xBBcP+r0WuJF/IyUj/NW2S91fxDMfw
         eGZWuvo+5TUOw==
Date:   Thu, 3 Aug 2023 16:30:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2] xfs: stabilize fs summary counters for online fsck
Message-ID: <20230803233028.GG11352@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
v2: remove fscounters.h
---
 fs/xfs/scrub/fscounters.c |  188 ++++++++++++++++++++++++++++++++++++---------
 fs/xfs/scrub/scrub.c      |    6 +
 fs/xfs/scrub/scrub.h      |    1 
 fs/xfs/scrub/trace.h      |   26 ++++++
 4 files changed, 183 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index e382a35e98d8..05be757668bb 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2019-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
@@ -8,6 +8,8 @@
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
 #include "xfs_mount.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
@@ -16,6 +18,7 @@
 #include "xfs_ag.h"
 #include "xfs_rtalloc.h"
 #include "xfs_inode.h"
+#include "xfs_icache.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -53,6 +56,7 @@ struct xchk_fscounters {
 	uint64_t		frextents;
 	unsigned long long	icount_min;
 	unsigned long long	icount_max;
+	bool			frozen;
 };
 
 /*
@@ -123,6 +127,82 @@ xchk_fscount_warmup(
 	return error;
 }
 
+static inline int
+xchk_fsfreeze(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	error = freeze_super(sc->mp->m_super, FREEZE_HOLDER_KERNEL);
+	trace_xchk_fsfreeze(sc, error);
+	return error;
+}
+
+static inline int
+xchk_fsthaw(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	/* This should always succeed, we have a kernel freeze */
+	error = thaw_super(sc->mp->m_super, FREEZE_HOLDER_KERNEL);
+	trace_xchk_fsthaw(sc, error);
+	return error;
+}
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
+	int			error = 0;
+
+	if (sc->flags & XCHK_HAVE_FREEZE_PROT) {
+		sc->flags &= ~XCHK_HAVE_FREEZE_PROT;
+		mnt_drop_write_file(sc->file);
+	}
+
+	/* Try to grab a kernel freeze. */
+	while ((error = xchk_fsfreeze(sc)) == -EBUSY) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		delay(HZ / 10);
+	}
+	if (error)
+		return error;
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
+	int			error;
+
+	if (!fsc->frozen)
+		return;
+
+	error = xchk_fsthaw(sc);
+	if (error)
+		xfs_emerg(sc->mp, "still frozen after scrub, err=%d", error);
+	else
+		fsc->frozen = false;
+}
+
 int
 xchk_setup_fscounters(
 	struct xfs_scrub	*sc)
@@ -140,6 +220,7 @@ xchk_setup_fscounters(
 	sc->buf = kzalloc(sizeof(struct xchk_fscounters), XCHK_GFP_FLAGS);
 	if (!sc->buf)
 		return -ENOMEM;
+	sc->buf_cleanup = xchk_fscounters_cleanup;
 	fsc = sc->buf;
 	fsc->sc = sc;
 
@@ -150,7 +231,18 @@ xchk_setup_fscounters(
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
+	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
 }
 
 /*
@@ -290,8 +382,7 @@ xchk_fscount_aggregate_agcounts(
 	if (fsc->ifree > fsc->icount) {
 		if (tries--)
 			goto retry;
-		xchk_set_incomplete(sc);
-		return 0;
+		return -EDEADLOCK;
 	}
 
 	return 0;
@@ -367,6 +458,8 @@ xchk_fscount_count_frextents(
  * Otherwise, we /might/ have a problem.  If the change in the summations is
  * more than we want to tolerate, the filesystem is probably busy and we should
  * just send back INCOMPLETE and see if userspace will try again.
+ *
+ * If we're repairing then we require an exact match.
  */
 static inline bool
 xchk_fscount_within_range(
@@ -396,21 +489,7 @@ xchk_fscount_within_range(
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
 
@@ -422,6 +501,7 @@ xchk_fscounters(
 	struct xfs_mount	*mp = sc->mp;
 	struct xchk_fscounters	*fsc = sc->buf;
 	int64_t			icount, ifree, fdblocks, frextents;
+	bool			try_again = false;
 	int			error;
 
 	/* Snapshot the percpu counters. */
@@ -431,9 +511,26 @@ xchk_fscounters(
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
@@ -446,12 +543,6 @@ xchk_fscounters(
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
@@ -463,8 +554,6 @@ xchk_fscounters(
 	error = xchk_fscount_aggregate_agcounts(sc, fsc);
 	if (!xchk_process_error(sc, 0, XFS_SB_BLOCK(mp), &error))
 		return error;
-	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
-		return 0;
 
 	/* Count the free extents counter for rt volumes. */
 	error = xchk_fscount_count_frextents(sc, fsc);
@@ -473,20 +562,45 @@ xchk_fscounters(
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
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 3d98f604765e..a0fffbcd022b 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -184,8 +184,10 @@ xchk_teardown(
 			xchk_irele(sc, sc->ip);
 		sc->ip = NULL;
 	}
-	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+	if (sc->flags & XCHK_HAVE_FREEZE_PROT) {
+		sc->flags &= ~XCHK_HAVE_FREEZE_PROT;
 		mnt_drop_write_file(sc->file);
+	}
 	if (sc->buf) {
 		if (sc->buf_cleanup)
 			sc->buf_cleanup(sc->buf);
@@ -505,6 +507,8 @@ xfs_scrub_metadata(
 		error = mnt_want_write_file(sc->file);
 		if (error)
 			goto out_sc;
+
+		sc->flags |= XCHK_HAVE_FREEZE_PROT;
 	}
 
 	/* Set up for the operation. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index e113f2f5c254..f8ba00e51ca9 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -106,6 +106,7 @@ struct xfs_scrub {
 
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */
 #define XCHK_TRY_HARDER		(1U << 0)  /* can't get resources, try again */
+#define XCHK_HAVE_FREEZE_PROT	(1U << 1)  /* do we have freeze protection? */
 #define XCHK_FSGATES_DRAIN	(1U << 2)  /* defer ops draining enabled */
 #define XCHK_NEED_DRAIN		(1U << 3)  /* scrub needs to drain defer ops */
 #define XREP_ALREADY_FIXED	(1U << 31) /* checking our repair work */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index b3894daeb86a..0b54f1a1cf0c 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -98,6 +98,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 
 #define XFS_SCRUB_STATE_STRINGS \
 	{ XCHK_TRY_HARDER,			"try_harder" }, \
+	{ XCHK_HAVE_FREEZE_PROT,		"nofreeze" }, \
 	{ XCHK_FSGATES_DRAIN,			"fsgates_drain" }, \
 	{ XCHK_NEED_DRAIN,			"need_drain" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
@@ -693,6 +694,31 @@ TRACE_EVENT(xchk_fscounters_within_range,
 		  __entry->old_value)
 )
 
+DECLARE_EVENT_CLASS(xchk_fsfreeze_class,
+	TP_PROTO(struct xfs_scrub *sc, int error),
+	TP_ARGS(sc, error),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, type)
+		__field(int, error)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->type = sc->sm->sm_type;
+		__entry->error = error;
+	),
+	TP_printk("dev %d:%d type %s error %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
+		  __entry->error)
+);
+#define DEFINE_XCHK_FSFREEZE_EVENT(name) \
+DEFINE_EVENT(xchk_fsfreeze_class, name, \
+	TP_PROTO(struct xfs_scrub *sc, int error), \
+	TP_ARGS(sc, error))
+DEFINE_XCHK_FSFREEZE_EVENT(xchk_fsfreeze);
+DEFINE_XCHK_FSFREEZE_EVENT(xchk_fsthaw);
+
 TRACE_EVENT(xchk_refcount_incorrect,
 	TP_PROTO(struct xfs_perag *pag, const struct xfs_refcount_irec *irec,
 		 xfs_nlink_t seen),
