Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3DBC001DC
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbjG0W1p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbjG0W1o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:27:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA77D2696
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:27:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BEB361EBC
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FEDC433C8;
        Thu, 27 Jul 2023 22:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496860;
        bh=A0AtaZ1tqkmcY+8RpB/79VP3dR/AchuTh5yN4L6fQ1w=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=H4Gljcyy0Kea9eFzDu2OPxSJQQj7vS/y+/qEJqI4PrpYHqff4rdSy1nU9DN2PxZhi
         lMnOl5BQyp5u+vPRFv6kVbrufMvK1OQo/Ux1lGAhbtRzxZ2kQqiv0nmTrqA70dcdGq
         pWNNT7+n951KvJ5/+WXYmMgCVGFBknRTBn8CB0Dvr5mZIzu88Rrw1bWboN894/tPSN
         ifEnLNjvvkfBSHAn3/Ym3dNaWU/OsEprzsb+yWrtH3VM7Emyo7B1qHUyyEXrvR4Fld
         7wZD6F3KxHOR/0qjUhvPDxwAlM6/CW3iGO8XpP8Zyx4Wms/QCBEWwPW3OoGjWj0ZMs
         5GFwuicm7bBFg==
Date:   Thu, 27 Jul 2023 15:27:40 -0700
Subject: [PATCH 2/2] xfs: track usage statistics of online fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049623998.921701.9699070296828285039.stgit@frogsfrogsfrogs>
In-Reply-To: <169049623967.921701.643201943864960800.stgit@frogsfrogsfrogs>
References: <169049623967.921701.643201943864960800.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Track the usage, outcomes, and run times of the online fsck code, and
report these values via debugfs.  The columns in the file are:

 * scrubber name

 * number of scrub invocations
 * clean objects found
 * corruptions found
 * optimizations found
 * cross referencing failures
 * inconsistencies found during cross referencing
 * incomplete scrubs
 * warnings
 * number of time scrub had to retry
 * cumulative amount of time spent scrubbing (microseconds)

 * number of repair inovcations
 * successfully repaired objects
 * cumuluative amount of time spent repairing (microseconds)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig        |   17 ++
 fs/xfs/Makefile       |    1 
 fs/xfs/scrub/repair.c |   11 +
 fs/xfs/scrub/repair.h |    7 +
 fs/xfs/scrub/scrub.c  |   11 +
 fs/xfs/scrub/stats.c  |  405 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/stats.h  |   59 +++++++
 fs/xfs/xfs_mount.c    |    9 +
 fs/xfs/xfs_mount.h    |    3 
 fs/xfs/xfs_super.c    |   21 ++-
 10 files changed, 535 insertions(+), 9 deletions(-)
 create mode 100644 fs/xfs/scrub/stats.c
 create mode 100644 fs/xfs/scrub/stats.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 152348b4dece2..c9d653168ad03 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -143,6 +143,23 @@ config XFS_ONLINE_SCRUB
 
 	  If unsure, say N.
 
+config XFS_ONLINE_SCRUB_STATS
+	bool "XFS online metadata check usage data collection"
+	default y
+	depends on XFS_ONLINE_SCRUB
+	select FS_DEBUG
+	help
+	  If you say Y here, the kernel will gather usage data about
+	  the online metadata check subsystem.  This includes the number
+	  of invocations, the outcomes, and the results of repairs, if any.
+	  This may slow down scrub slightly due to the use of high precision
+	  timers and the need to merge per-invocation information into the
+	  filesystem counters.
+
+	  Usage data are collected in /sys/kernel/debug/xfs/scrub.
+
+	  If unsure, say N.
+
 config XFS_ONLINE_REPAIR
 	bool "XFS online metadata repair support"
 	default n
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7a5fa47a30936..87f2756df3708 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -168,6 +168,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   xfile.o \
 				   )
 
+xfs-$(CONFIG_XFS_ONLINE_SCRUB_STATS) += scrub/stats.o
 xfs-$(CONFIG_XFS_RT)		+= scrub/rtbitmap.o
 xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index c2474cc40d04c..83efe015fab77 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -32,6 +32,7 @@
 #include "scrub/trace.h"
 #include "scrub/repair.h"
 #include "scrub/bitmap.h"
+#include "scrub/stats.h"
 
 /*
  * Attempt to repair some metadata, if the metadata is corrupt and userspace
@@ -40,8 +41,10 @@
  */
 int
 xrep_attempt(
-	struct xfs_scrub	*sc)
+	struct xfs_scrub	*sc,
+	struct xchk_stats_run	*run)
 {
+	u64			repair_start;
 	int			error = 0;
 
 	trace_xrep_attempt(XFS_I(file_inode(sc->file)), sc->sm, error);
@@ -50,8 +53,11 @@ xrep_attempt(
 
 	/* Repair whatever's broken. */
 	ASSERT(sc->ops->repair);
+	run->repair_attempted = true;
+	repair_start = xchk_stats_now();
 	error = sc->ops->repair(sc);
 	trace_xrep_done(XFS_I(file_inode(sc->file)), sc->sm, error);
+	run->repair_ns += xchk_stats_elapsed_ns(repair_start);
 	switch (error) {
 	case 0:
 		/*
@@ -60,14 +66,17 @@ xrep_attempt(
 		 */
 		sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
 		sc->flags |= XREP_ALREADY_FIXED;
+		run->repair_succeeded = true;
 		return -EAGAIN;
 	case -ECHRNG:
 		sc->flags |= XCHK_NEED_DRAIN;
+		run->retries++;
 		return -EAGAIN;
 	case -EDEADLOCK:
 		/* Tell the caller to try again having grabbed all the locks. */
 		if (!(sc->flags & XCHK_TRY_HARDER)) {
 			sc->flags |= XCHK_TRY_HARDER;
+			run->retries++;
 			return -EAGAIN;
 		}
 		/*
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 9ea1eb0aae49d..6eeb113c98a46 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -8,6 +8,8 @@
 
 #include "xfs_quota_defs.h"
 
+struct xchk_stats_run;
+
 static inline int xrep_notsupported(struct xfs_scrub *sc)
 {
 	return -EOPNOTSUPP;
@@ -17,7 +19,7 @@ static inline int xrep_notsupported(struct xfs_scrub *sc)
 
 /* Repair helpers */
 
-int xrep_attempt(struct xfs_scrub *sc);
+int xrep_attempt(struct xfs_scrub *sc, struct xchk_stats_run *run);
 void xrep_failure(struct xfs_mount *mp);
 int xrep_roll_ag_trans(struct xfs_scrub *sc);
 int xrep_roll_trans(struct xfs_scrub *sc);
@@ -63,7 +65,8 @@ int xrep_agi(struct xfs_scrub *sc);
 
 static inline int
 xrep_attempt(
-	struct xfs_scrub	*sc)
+	struct xfs_scrub	*sc,
+	struct xchk_stats_run	*run)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index d603efa2a9af3..6864e3fdd5f5a 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -24,6 +24,7 @@
 #include "scrub/trace.h"
 #include "scrub/repair.h"
 #include "scrub/health.h"
+#include "scrub/stats.h"
 
 /*
  * Online Scrub and Repair
@@ -463,8 +464,10 @@ xfs_scrub_metadata(
 	struct file			*file,
 	struct xfs_scrub_metadata	*sm)
 {
+	struct xchk_stats_run		run = { };
 	struct xfs_scrub		*sc;
 	struct xfs_mount		*mp = XFS_I(file_inode(file))->i_mount;
+	u64				check_start;
 	int				error = 0;
 
 	BUILD_BUG_ON(sizeof(meta_scrub_ops) !=
@@ -519,7 +522,9 @@ xfs_scrub_metadata(
 		goto out_teardown;
 
 	/* Scrub for errors. */
+	check_start = xchk_stats_now();
 	error = sc->ops->scrub(sc);
+	run.scrub_ns += xchk_stats_elapsed_ns(check_start);
 	if (error == -EDEADLOCK && !(sc->flags & XCHK_TRY_HARDER))
 		goto try_harder;
 	if (error == -ECHRNG && !(sc->flags & XCHK_NEED_DRAIN))
@@ -553,7 +558,7 @@ xfs_scrub_metadata(
 		 * If it's broken, userspace wants us to fix it, and we haven't
 		 * already tried to fix it, then attempt a repair.
 		 */
-		error = xrep_attempt(sc);
+		error = xrep_attempt(sc, &run);
 		if (error == -EAGAIN) {
 			/*
 			 * Either the repair function succeeded or it couldn't
@@ -581,12 +586,15 @@ xfs_scrub_metadata(
 		sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		error = 0;
 	}
+	if (error != -ENOENT)
+		xchk_stats_merge(mp, sm, &run);
 	return error;
 need_drain:
 	error = xchk_teardown(sc, 0);
 	if (error)
 		goto out_sc;
 	sc->flags |= XCHK_NEED_DRAIN;
+	run.retries++;
 	goto retry_op;
 try_harder:
 	/*
@@ -598,5 +606,6 @@ xfs_scrub_metadata(
 	if (error)
 		goto out_sc;
 	sc->flags |= XCHK_TRY_HARDER;
+	run.retries++;
 	goto retry_op;
 }
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
new file mode 100644
index 0000000000000..aeb92624176b9
--- /dev/null
+++ b/fs/xfs/scrub/stats.c
@@ -0,0 +1,405 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_sysfs.h"
+#include "xfs_btree.h"
+#include "xfs_super.h"
+#include "scrub/scrub.h"
+#include "scrub/stats.h"
+#include "scrub/trace.h"
+
+struct xchk_scrub_stats {
+	/* all 32-bit counters here */
+
+	/* checking stats */
+	uint32_t		invocations;
+	uint32_t		clean;
+	uint32_t		corrupt;
+	uint32_t		preen;
+	uint32_t		xfail;
+	uint32_t		xcorrupt;
+	uint32_t		incomplete;
+	uint32_t		warning;
+	uint32_t		retries;
+
+	/* repair stats */
+	uint32_t		repair_invocations;
+	uint32_t		repair_success;
+
+	/* all 64-bit items here */
+
+	/* runtimes */
+	uint64_t		checktime_us;
+	uint64_t		repairtime_us;
+
+	/* non-counter state must go at the end for clearall */
+	spinlock_t		css_lock;
+};
+
+struct xchk_stats {
+	struct dentry		*cs_debugfs;
+	struct xchk_scrub_stats	cs_stats[XFS_SCRUB_TYPE_NR];
+};
+
+
+static struct xchk_stats	global_stats;
+
+static const char *name_map[XFS_SCRUB_TYPE_NR] = {
+	[XFS_SCRUB_TYPE_SB]		= "sb",
+	[XFS_SCRUB_TYPE_AGF]		= "agf",
+	[XFS_SCRUB_TYPE_AGFL]		= "agfl",
+	[XFS_SCRUB_TYPE_AGI]		= "agi",
+	[XFS_SCRUB_TYPE_BNOBT]		= "bnobt",
+	[XFS_SCRUB_TYPE_CNTBT]		= "cntbt",
+	[XFS_SCRUB_TYPE_INOBT]		= "inobt",
+	[XFS_SCRUB_TYPE_FINOBT]		= "finobt",
+	[XFS_SCRUB_TYPE_RMAPBT]		= "rmapbt",
+	[XFS_SCRUB_TYPE_REFCNTBT]	= "refcountbt",
+	[XFS_SCRUB_TYPE_INODE]		= "inode",
+	[XFS_SCRUB_TYPE_BMBTD]		= "bmapbtd",
+	[XFS_SCRUB_TYPE_BMBTA]		= "bmapbta",
+	[XFS_SCRUB_TYPE_BMBTC]		= "bmapbtc",
+	[XFS_SCRUB_TYPE_DIR]		= "directory",
+	[XFS_SCRUB_TYPE_XATTR]		= "xattr",
+	[XFS_SCRUB_TYPE_SYMLINK]	= "symlink",
+	[XFS_SCRUB_TYPE_PARENT]		= "parent",
+	[XFS_SCRUB_TYPE_RTBITMAP]	= "rtbitmap",
+	[XFS_SCRUB_TYPE_RTSUM]		= "rtsummary",
+	[XFS_SCRUB_TYPE_UQUOTA]		= "usrquota",
+	[XFS_SCRUB_TYPE_GQUOTA]		= "grpquota",
+	[XFS_SCRUB_TYPE_PQUOTA]		= "prjquota",
+	[XFS_SCRUB_TYPE_FSCOUNTERS]	= "fscounters",
+};
+
+/* Format the scrub stats into a text buffer, similar to pcp style. */
+STATIC ssize_t
+xchk_stats_format(
+	struct xchk_stats	*cs,
+	char			*buf,
+	size_t			remaining)
+{
+	struct xchk_scrub_stats	*css = &cs->cs_stats[0];
+	unsigned int		i;
+	ssize_t			copied = 0;
+	int			ret = 0;
+
+	for (i = 0; i < XFS_SCRUB_TYPE_NR; i++, css++) {
+		if (!name_map[i])
+			continue;
+
+		ret = scnprintf(buf, remaining,
+ "%s %u %u %u %u %u %u %u %u %u %llu %u %u %llu\n",
+				name_map[i],
+				(unsigned int)css->invocations,
+				(unsigned int)css->clean,
+				(unsigned int)css->corrupt,
+				(unsigned int)css->preen,
+				(unsigned int)css->xfail,
+				(unsigned int)css->xcorrupt,
+				(unsigned int)css->incomplete,
+				(unsigned int)css->warning,
+				(unsigned int)css->retries,
+				(unsigned long long)css->checktime_us,
+				(unsigned int)css->repair_invocations,
+				(unsigned int)css->repair_success,
+				(unsigned long long)css->repairtime_us);
+		if (ret <= 0)
+			break;
+
+		remaining -= ret;
+		copied += ret;
+		buf +=  ret;
+	}
+
+	return copied > 0 ? copied : ret;
+}
+
+/* Estimate the worst case buffer size required to hold the whole report. */
+STATIC size_t
+xchk_stats_estimate_bufsize(
+	struct xchk_stats	*cs)
+{
+	struct xchk_scrub_stats	*css = &cs->cs_stats[0];
+	unsigned int		i;
+	size_t			field_width;
+	size_t			ret = 0;
+
+	/* 4294967296 plus one space for each u32 field */
+	field_width = 11 * (offsetof(struct xchk_scrub_stats, checktime_us) /
+			    sizeof(uint32_t));
+
+	/* 18446744073709551615 plus one space for each u64 field */
+	field_width += 21 * ((offsetof(struct xchk_scrub_stats, css_lock) -
+			      offsetof(struct xchk_scrub_stats, checktime_us)) /
+			     sizeof(uint64_t));
+
+	for (i = 0; i < XFS_SCRUB_TYPE_NR; i++, css++) {
+		if (!name_map[i])
+			continue;
+
+		/* name plus one space */
+		ret += 1 + strlen(name_map[i]);
+
+		/* all fields, plus newline */
+		ret += field_width + 1;
+	}
+
+	return ret;
+}
+
+/* Clear all counters. */
+STATIC void
+xchk_stats_clearall(
+	struct xchk_stats	*cs)
+{
+	struct xchk_scrub_stats	*css = &cs->cs_stats[0];
+	unsigned int		i;
+
+	for (i = 0; i < XFS_SCRUB_TYPE_NR; i++, css++) {
+		spin_lock(&css->css_lock);
+		memset(css, 0, offsetof(struct xchk_scrub_stats, css_lock));
+		spin_unlock(&css->css_lock);
+	}
+}
+
+#define XFS_SCRUB_OFLAG_UNCLEAN	(XFS_SCRUB_OFLAG_CORRUPT | \
+				 XFS_SCRUB_OFLAG_PREEN | \
+				 XFS_SCRUB_OFLAG_XFAIL | \
+				 XFS_SCRUB_OFLAG_XCORRUPT | \
+				 XFS_SCRUB_OFLAG_INCOMPLETE | \
+				 XFS_SCRUB_OFLAG_WARNING)
+
+STATIC void
+xchk_stats_merge_one(
+	struct xchk_stats		*cs,
+	const struct xfs_scrub_metadata	*sm,
+	const struct xchk_stats_run	*run)
+{
+	struct xchk_scrub_stats		*css;
+
+	ASSERT(sm->sm_type < XFS_SCRUB_TYPE_NR);
+
+	css = &cs->cs_stats[sm->sm_type];
+	spin_lock(&css->css_lock);
+	css->invocations++;
+	if (!(sm->sm_flags & XFS_SCRUB_OFLAG_UNCLEAN))
+		css->clean++;
+	if (sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		css->corrupt++;
+	if (sm->sm_flags & XFS_SCRUB_OFLAG_PREEN)
+		css->preen++;
+	if (sm->sm_flags & XFS_SCRUB_OFLAG_XFAIL)
+		css->xfail++;
+	if (sm->sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)
+		css->xcorrupt++;
+	if (sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
+		css->incomplete++;
+	if (sm->sm_flags & XFS_SCRUB_OFLAG_WARNING)
+		css->warning++;
+	css->retries += run->retries;
+	css->checktime_us += howmany_64(run->scrub_ns, NSEC_PER_USEC);
+
+	if (run->repair_attempted)
+		css->repair_invocations++;
+	if (run->repair_succeeded)
+		css->repair_success++;
+	css->repairtime_us += howmany_64(run->repair_ns, NSEC_PER_USEC);
+	spin_unlock(&css->css_lock);
+}
+
+/* Merge these scrub-run stats into the global and mount stat data. */
+void
+xchk_stats_merge(
+	struct xfs_mount		*mp,
+	const struct xfs_scrub_metadata	*sm,
+	const struct xchk_stats_run	*run)
+{
+	xchk_stats_merge_one(&global_stats, sm, run);
+	xchk_stats_merge_one(mp->m_scrub_stats, sm, run);
+}
+
+/* debugfs boilerplate */
+
+static ssize_t
+xchk_scrub_stats_read(
+	struct file		*file,
+	char __user		*ubuf,
+	size_t			count,
+	loff_t			*ppos)
+{
+	struct xchk_stats	*cs = file->private_data;
+	char			*buf;
+	size_t			bufsize;
+	ssize_t			avail, ret;
+
+	/*
+	 * This generates stringly snapshot of all the scrub counters, so we
+	 * do not want userspace to receive garbled text from multiple calls.
+	 * If the file position is greater than 0, return a short read.
+	 */
+	if (*ppos > 0)
+		return 0;
+
+	bufsize = xchk_stats_estimate_bufsize(cs);
+
+	buf = kvmalloc(bufsize, XCHK_GFP_FLAGS);
+	if (!buf)
+		return -ENOMEM;
+
+	avail = xchk_stats_format(cs, buf, bufsize);
+	if (avail < 0) {
+		ret = avail;
+		goto out;
+	}
+
+	ret = simple_read_from_buffer(ubuf, count, ppos, buf, avail);
+out:
+	kvfree(buf);
+	return ret;
+}
+
+static const struct file_operations scrub_stats_fops = {
+	.open			= simple_open,
+	.read			= xchk_scrub_stats_read,
+};
+
+static ssize_t
+xchk_clear_scrub_stats_write(
+	struct file		*file,
+	const char __user	*ubuf,
+	size_t			count,
+	loff_t			*ppos)
+{
+	struct xchk_stats	*cs = file->private_data;
+	unsigned int		val;
+	int			ret;
+
+	ret = kstrtouint_from_user(ubuf, count, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val != 1)
+		return -EINVAL;
+
+	xchk_stats_clearall(cs);
+	return count;
+}
+
+static const struct file_operations clear_scrub_stats_fops = {
+	.open			= simple_open,
+	.write			= xchk_clear_scrub_stats_write,
+};
+
+/* Initialize the stats object. */
+STATIC int
+xchk_stats_init(
+	struct xchk_stats	*cs,
+	struct xfs_mount	*mp)
+{
+	struct xchk_scrub_stats	*css = &cs->cs_stats[0];
+	unsigned int		i;
+
+	for (i = 0; i < XFS_SCRUB_TYPE_NR; i++, css++)
+		spin_lock_init(&css->css_lock);
+
+	return 0;
+}
+
+/* Connect the stats object to debugfs. */
+void
+xchk_stats_register(
+	struct xchk_stats	*cs,
+	struct dentry		*parent)
+{
+	if (!parent)
+		return;
+
+	cs->cs_debugfs = xfs_debugfs_mkdir("scrub", parent);
+	if (!cs->cs_debugfs)
+		return;
+
+	debugfs_create_file("stats", 0644, cs->cs_debugfs, cs,
+			&scrub_stats_fops);
+	debugfs_create_file("clear_stats", 0400, cs->cs_debugfs, cs,
+			&clear_scrub_stats_fops);
+}
+
+/* Free all resources related to the stats object. */
+STATIC int
+xchk_stats_teardown(
+	struct xchk_stats	*cs)
+{
+	return 0;
+}
+
+/* Disconnect the stats object from debugfs. */
+void
+xchk_stats_unregister(
+	struct xchk_stats	*cs)
+{
+	debugfs_remove(cs->cs_debugfs);
+}
+
+/* Initialize global stats and register them */
+int __init
+xchk_global_stats_setup(
+	struct dentry		*parent)
+{
+	int			error;
+
+	error = xchk_stats_init(&global_stats, NULL);
+	if (error)
+		return error;
+
+	xchk_stats_register(&global_stats, parent);
+	return 0;
+}
+
+/* Unregister global stats and tear them down */
+void
+xchk_global_stats_teardown(void)
+{
+	xchk_stats_unregister(&global_stats);
+	xchk_stats_teardown(&global_stats);
+}
+
+/* Allocate per-mount stats */
+int
+xchk_mount_stats_alloc(
+	struct xfs_mount	*mp)
+{
+	struct xchk_stats	*cs;
+	int			error;
+
+	cs = kvzalloc(sizeof(struct xchk_stats), GFP_KERNEL);
+	if (!cs)
+		return -ENOMEM;
+
+	error = xchk_stats_init(cs, mp);
+	if (error)
+		goto out_free;
+
+	mp->m_scrub_stats = cs;
+	return 0;
+out_free:
+	kvfree(cs);
+	return error;
+}
+
+/* Free per-mount stats */
+void
+xchk_mount_stats_free(
+	struct xfs_mount	*mp)
+{
+	xchk_stats_teardown(mp->m_scrub_stats);
+	kvfree(mp->m_scrub_stats);
+	mp->m_scrub_stats = NULL;
+}
diff --git a/fs/xfs/scrub/stats.h b/fs/xfs/scrub/stats.h
new file mode 100644
index 0000000000000..b358ad8d8b90a
--- /dev/null
+++ b/fs/xfs/scrub/stats.h
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_STATS_H__
+#define __XFS_SCRUB_STATS_H__
+
+struct xchk_stats_run {
+	u64			scrub_ns;
+	u64			repair_ns;
+	unsigned int		retries;
+	bool			repair_attempted;
+	bool			repair_succeeded;
+};
+
+#ifdef CONFIG_XFS_ONLINE_SCRUB_STATS
+struct xchk_stats;
+
+int __init xchk_global_stats_setup(struct dentry *parent);
+void xchk_global_stats_teardown(void);
+
+int xchk_mount_stats_alloc(struct xfs_mount *mp);
+void xchk_mount_stats_free(struct xfs_mount *mp);
+
+void xchk_stats_register(struct xchk_stats *cs, struct dentry *parent);
+void xchk_stats_unregister(struct xchk_stats *cs);
+
+void xchk_stats_merge(struct xfs_mount *mp, const struct xfs_scrub_metadata *sm,
+		const struct xchk_stats_run *run);
+
+static inline u64 xchk_stats_now(void) { return ktime_get_ns(); }
+static inline u64 xchk_stats_elapsed_ns(u64 since)
+{
+	u64 now = xchk_stats_now();
+
+	/*
+	 * If the system doesn't have a high enough resolution clock, charge at
+	 * least one nanosecond so that our stats don't report instantaneous
+	 * runtimes.
+	 */
+	if (now == since)
+		return 1;
+
+	return now - since;
+}
+#else
+# define xchk_global_stats_setup(parent)	(0)
+# define xchk_global_stats_teardown()		((void)0)
+# define xchk_mount_stats_alloc(mp)		(0)
+# define xchk_mount_stats_free(mp)		((void)0)
+# define xchk_stats_register(cs, parent)	((void)0)
+# define xchk_stats_unregister(cs)		((void)0)
+# define xchk_stats_now()			(0)
+# define xchk_stats_elapsed_ns(x)		(0 * (x))
+# define xchk_stats_merge(mp, sm, run)		((void)0)
+#endif /* CONFIG_XFS_ONLINE_SCRUB_STATS */
+
+#endif /* __XFS_SCRUB_STATS_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fb87ffb48f7fe..0a0fd19573d8c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -34,6 +34,7 @@
 #include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_ag.h"
+#include "scrub/stats.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
@@ -716,9 +717,11 @@ xfs_mountfs(
 	if (error)
 		goto out_remove_sysfs;
 
+	xchk_stats_register(mp->m_scrub_stats, mp->m_debugfs);
+
 	error = xfs_error_sysfs_init(mp);
 	if (error)
-		goto out_del_stats;
+		goto out_remove_scrub_stats;
 
 	error = xfs_errortag_init(mp);
 	if (error)
@@ -1033,7 +1036,8 @@ xfs_mountfs(
 	xfs_errortag_del(mp);
  out_remove_error_sysfs:
 	xfs_error_sysfs_del(mp);
- out_del_stats:
+ out_remove_scrub_stats:
+	xchk_stats_unregister(mp->m_scrub_stats);
 	xfs_sysfs_del(&mp->m_stats.xs_kobj);
  out_remove_sysfs:
 	xfs_sysfs_del(&mp->m_kobj);
@@ -1105,6 +1109,7 @@ xfs_unmountfs(
 
 	xfs_errortag_del(mp);
 	xfs_error_sysfs_del(mp);
+	xchk_stats_unregister(mp->m_scrub_stats);
 	xfs_sysfs_del(&mp->m_stats.xs_kobj);
 	xfs_sysfs_del(&mp->m_kobj);
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 0b86bf10a4cc3..a25eece3be2b9 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -214,6 +214,9 @@ typedef struct xfs_mount {
 	struct xfs_kobj		m_error_meta_kobj;
 	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
 	struct xstats		m_stats;	/* per-fs stats */
+#ifdef CONFIG_XFS_ONLINE_SCRUB_STATS
+	struct xchk_stats	*m_scrub_stats;
+#endif
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
 	atomic_t		m_agirotor;	/* last ag dir inode alloced */
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 31ac4744fdbec..09638e8fb4eef 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -42,6 +42,7 @@
 #include "xfs_xattr.h"
 #include "xfs_iunlink_item.h"
 #include "xfs_dahash_test.h"
+#include "scrub/stats.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -1144,6 +1145,7 @@ xfs_fs_put_super(
 	xfs_unmountfs(mp);
 
 	xfs_freesb(mp);
+	xchk_mount_stats_free(mp);
 	free_percpu(mp->m_stats.xs_stats);
 	xfs_mount_list_del(mp);
 	xfs_inodegc_free_percpu(mp);
@@ -1571,9 +1573,13 @@ xfs_fs_fill_super(
 		goto out_destroy_inodegc;
 	}
 
+	error = xchk_mount_stats_alloc(mp);
+	if (error)
+		goto out_free_stats;
+
 	error = xfs_readsb(mp, flags);
 	if (error)
-		goto out_free_stats;
+		goto out_free_scrub_stats;
 
 	error = xfs_finish_flags(mp);
 	if (error)
@@ -1752,6 +1758,8 @@ xfs_fs_fill_super(
 	xfs_filestream_unmount(mp);
  out_free_sb:
 	xfs_freesb(mp);
+ out_free_scrub_stats:
+	xchk_mount_stats_free(mp);
  out_free_stats:
 	free_percpu(mp->m_stats.xs_stats);
  out_destroy_inodegc:
@@ -2398,11 +2406,15 @@ init_xfs_fs(void)
 	if (error)
 		goto out_free_stats;
 
+	error = xchk_global_stats_setup(xfs_debugfs);
+	if (error)
+		goto out_remove_stats_kobj;
+
 #ifdef DEBUG
 	xfs_dbg_kobj.kobject.kset = xfs_kset;
 	error = xfs_sysfs_init(&xfs_dbg_kobj, &xfs_dbg_ktype, NULL, "debug");
 	if (error)
-		goto out_remove_stats_kobj;
+		goto out_remove_scrub_stats;
 #endif
 
 	error = xfs_qm_init();
@@ -2419,8 +2431,10 @@ init_xfs_fs(void)
  out_remove_dbg_kobj:
 #ifdef DEBUG
 	xfs_sysfs_del(&xfs_dbg_kobj);
+ out_remove_scrub_stats:
+#endif
+	xchk_global_stats_teardown();
  out_remove_stats_kobj:
-#endif
 	xfs_sysfs_del(&xfsstats.xs_kobj);
  out_free_stats:
 	free_percpu(xfsstats.xs_stats);
@@ -2451,6 +2465,7 @@ exit_xfs_fs(void)
 #ifdef DEBUG
 	xfs_sysfs_del(&xfs_dbg_kobj);
 #endif
+	xchk_global_stats_teardown();
 	xfs_sysfs_del(&xfsstats.xs_kobj);
 	free_percpu(xfsstats.xs_stats);
 	kset_unregister(xfs_kset);

