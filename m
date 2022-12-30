Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BC0C3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbiL3XlK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235602AbiL3XlK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:41:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66921DF1A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:41:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5231961C31
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C0DC433EF;
        Fri, 30 Dec 2022 23:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443664;
        bh=f8bhhNsXkZwvQpYNB6KBdtuq1bV+vNX2AG+YEQPmMrs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mTI8to19em3rU9TERR4jHflHC+JsQ6RrS0+o54uhSNjJXyJGtTQa+WDirYtNc5Sbc
         BV/09t7IN9IaQwx72cqpqZq4Rao3p1E1JSlofPxj8nwmJR1nu6sa44CNiGAPGzkdHl
         Xx62cPqphKLR5KQUlQUNWQxb4zR8ilgHN2D8Oc6bOh922ubvQUCjxcvQN4IWXL+OIw
         V9IZbOowS7wmccDw7HEY/fVGd6MtIeXTpzjPvJJORsVHehOJq8LppDwsTkrBZcmSpH
         X5vvi3sDWZV4fRyz+XjKKliqUxxZukprW6gCzMn4pYG2FmZDJaBCVcHgapH7I9IgoF
         l1DW1WfBy2KQg==
Subject: [PATCH 3/3] xfs: repair summary counters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:22 -0800
Message-ID: <167243840293.696415.3584558383285965358.stgit@magnolia>
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

Use the same summary counter calculation infrastructure to generate new
values for the in-core summary counters.   The difference between the
scrubber and the repairer is that the repairer will freeze the fs during
setup, which means that the values should match exactly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                  |    1 +
 fs/xfs/scrub/fscounters.c        |   15 +++++++-
 fs/xfs/scrub/fscounters_repair.c |   72 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h            |    2 +
 fs/xfs/scrub/scrub.c             |    2 +
 fs/xfs/scrub/trace.c             |    1 +
 fs/xfs/scrub/trace.h             |   21 +++++++++--
 7 files changed, 107 insertions(+), 7 deletions(-)
 create mode 100644 fs/xfs/scrub/fscounters_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a69c5585e41c..2d756e13d441 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -187,6 +187,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   alloc_repair.o \
 				   bmap_repair.o \
 				   cow_repair.o \
+				   fscounters_repair.o \
 				   ialloc_repair.o \
 				   inode_repair.o \
 				   newbt.o \
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index e90e59c2e565..ae12da1be95c 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -281,8 +281,13 @@ xchk_setup_fscounters(
 	 * Pause all writer activity in the filesystem while we're scrubbing to
 	 * reduce the likelihood of background perturbations to the counters
 	 * throwing off our calculations.
+	 *
+	 * If we're repairing, we need to prevent any other thread from
+	 * changing the global fs summary counters while we're repairing them.
+	 * This requires the fs to be frozen, which will disable background
+	 * reclaim and purge all inactive inodes.
 	 */
-	if (sc->flags & XCHK_TRY_HARDER) {
+	if ((sc->flags & XCHK_TRY_HARDER) || xchk_could_repair(sc)) {
 		error = xchk_fscounters_freeze(sc);
 		if (error)
 			return error;
@@ -300,7 +305,9 @@ xchk_setup_fscounters(
  * set the INCOMPLETE flag even when a negative errno is returned.  This care
  * must be taken with certain errno values (i.e. EFSBADCRC, EFSCORRUPTED,
  * ECANCELED) that are absorbed into a scrub state flag update by
- * xchk_*_process_error.
+ * xchk_*_process_error.  Scrub and repair share the same incore data
+ * structures, so the INCOMPLETE flag is critical to prevent a repair based on
+ * insufficient information.
  */
 
 /* Count free space btree blocks manually for pre-lazysbcount filesystems. */
@@ -527,6 +534,10 @@ xchk_fscount_within_range(
 	if (curr_value == expected)
 		return true;
 
+	/* We require exact matches when repair is running. */
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+		return false;
+
 	min_value = min(old_value, curr_value);
 	max_value = max(old_value, curr_value);
 
diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
new file mode 100644
index 000000000000..1c38870736d9
--- /dev/null
+++ b/fs/xfs/scrub/fscounters_repair.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_rmap.h"
+#include "xfs_health.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/fscounters.h"
+
+/*
+ * FS Summary Counters
+ * ===================
+ *
+ * We correct errors in the filesystem summary counters by setting them to the
+ * values computed during the obligatory scrub phase.  However, we must be
+ * careful not to allow any other thread to change the counters while we're
+ * computing and setting new values.  To achieve this, we freeze the
+ * filesystem for the whole operation if the REPAIR flag is set.  The checking
+ * function is stricter when we've frozen the fs.
+ */
+
+/*
+ * Reset the superblock counters.  Caller is responsible for freezing the
+ * filesystem during the calculation and reset phases.
+ */
+int
+xrep_fscounters(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xchk_fscounters	*fsc = sc->buf;
+
+	/*
+	 * Reinitialize the in-core counters from what we computed.  We froze
+	 * the filesystem, so there shouldn't be anyone else trying to modify
+	 * these counters.
+	 */
+	if (!fsc->frozen) {
+		ASSERT(fsc->frozen);
+		return -EFSCORRUPTED;
+	}
+
+	trace_xrep_reset_counters(mp, fsc);
+
+	percpu_counter_set(&mp->m_icount, fsc->icount);
+	percpu_counter_set(&mp->m_ifree, fsc->ifree);
+	percpu_counter_set(&mp->m_fdblocks, fsc->fdblocks);
+	percpu_counter_set(&mp->m_frextents, fsc->frextents);
+	mp->m_sb.sb_frextents = fsc->frextents;
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 6c19f0d7f335..5e3e6cfe3332 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -108,6 +108,7 @@ int xrep_bmap_data(struct xfs_scrub *sc);
 int xrep_bmap_attr(struct xfs_scrub *sc);
 int xrep_bmap_cow(struct xfs_scrub *sc);
 int xrep_nlinks(struct xfs_scrub *sc);
+int xrep_fscounters(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
@@ -193,6 +194,7 @@ static inline int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_quota			xrep_notsupported
 #define xrep_quotacheck			xrep_notsupported
 #define xrep_nlinks			xrep_notsupported
+#define xrep_fscounters			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 4ec9ff259c5e..fd116531a0d9 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -367,7 +367,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_fscounters,
 		.scrub	= xchk_fscounters,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_fscounters,
 	},
 	[XFS_SCRUB_TYPE_QUOTACHECK] = {	/* quota counters */
 		.type	= ST_FS,
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 82edcc830fb8..08e05d49e7c0 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -20,6 +20,7 @@
 #include "scrub/xfarray.h"
 #include "scrub/iscan.h"
 #include "scrub/nlinks.h"
+#include "scrub/fscounters.h"
 
 /* Figure out which block the btree cursor was pointing to. */
 static inline xfs_fsblock_t
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index e0de12c4fcf4..14569068b6ee 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -23,6 +23,7 @@ struct xfarray;
 struct xfarray_sortinfo;
 struct xchk_iscan;
 struct xchk_nlink;
+struct xchk_fscounters;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -1623,16 +1624,28 @@ TRACE_EVENT(xrep_calc_ag_resblks_btsize,
 		  __entry->refcbt_sz)
 )
 TRACE_EVENT(xrep_reset_counters,
-	TP_PROTO(struct xfs_mount *mp),
-	TP_ARGS(mp),
+	TP_PROTO(struct xfs_mount *mp, struct xchk_fscounters *fsc),
+	TP_ARGS(mp, fsc),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(uint64_t, icount)
+		__field(uint64_t, ifree)
+		__field(uint64_t, fdblocks)
+		__field(uint64_t, frextents)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
+		__entry->icount = fsc->icount;
+		__entry->ifree = fsc->ifree;
+		__entry->fdblocks = fsc->fdblocks;
+		__entry->frextents = fsc->frextents;
 	),
-	TP_printk("dev %d:%d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev))
+	TP_printk("dev %d:%d icount %llu ifree %llu fdblocks %llu frextents %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->icount,
+		  __entry->ifree,
+		  __entry->fdblocks,
+		  __entry->frextents)
 )
 
 DECLARE_EVENT_CLASS(xrep_newbt_extent_class,

