Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282BD17CE;
	Sat, 24 Feb 2024 01:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737194; cv=none; b=nvuRVFENwynBioxByEPsmm/x3S+GUIzIUUsN6m2qxXt0CUiCNlMm3uurIR5FJI+kowWDZ0AUcr7I6BJFlxlpHRHBBAtZb8f9ZlC+TbpX24Ep2ML6WuDCxSCzhXFD/dwF03ZkuuiZIGB8i4znt/yHwYXGxM6L+iNOjHms/oJhA34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737194; c=relaxed/simple;
	bh=DBp8UjCLiJ/w+jkBbt8wi3JFjE3Zwtog4RPwwnZZAks=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qs5SMl6pvHQRdzQ69GlbcLaLzY+xgejyx4/BC52UnA006BX+MIa0yHWaw4L9BWBqzMYGt7xzYIyoeBoSlGa3rgPYfIXcvNvnSvuZGDQxX52XuoVLEWi2/I37lC/iObzdDsfmwHxBwALpYj7GzaSwHpx78XJapYq5LPKKVUiw+Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d7l4NwB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d7l4NwB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB83FC433C7;
	Sat, 24 Feb 2024 01:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708737194;
	bh=DBp8UjCLiJ/w+jkBbt8wi3JFjE3Zwtog4RPwwnZZAks=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d7l4NwB0b061UmmpmGvDsJQ/xk3iPlg6d6ZUmdJ+t3sIpTii/nsXuWHm6T5gv3fqU
	 Nv/ZRuYUgjvfq7VkwfgR2d3210nc1c5tpQjc/gxjtXyGx5+DSzf9QqgliicBsGYpWr
	 MBE50+WqGGfBxiwtQhlCgwde7nYO+4QPBnsW0u4tVZatcXEg0lhjVCPOrxugi0smsi
	 ZiYJ9EY+t34wmHoD+c41C7ON8lLBqJhAbDQmp99xhYxlUOr7yqfF0/AxycuWhu7Z98
	 bJt/WXaPAmAVO6/udN3z4wrlE042Xo+f5kGbTJFZFjv+FvYLV4G57ORyadcES/LFcZ
	 j1sLeCwk4KRpw==
Date: Fri, 23 Feb 2024 17:13:13 -0800
Subject: [PATCH 2/4] xfs: present time stats for scrubbers
From: "Darrick J. Wong" <djwong@kernel.org>
To: kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org
Message-ID: <170873668481.1861246.1280832426356255159.stgit@frogsfrogsfrogs>
In-Reply-To: <170873668436.1861246.6578314737824782019.stgit@frogsfrogsfrogs>
References: <170873668436.1861246.6578314737824782019.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Use the timestats code to report statistical information about how much
time we spend in scrub and repair.  This augments the existing raw scrub
counters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c  |    6 +-
 fs/xfs/scrub/scrub.c   |    6 +-
 fs/xfs/scrub/stats.c   |  128 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/stats.h   |   21 +-------
 fs/xfs/xfs_linux.h     |    1 
 fs/xfs/xfs_timestats.h |    2 +
 6 files changed, 137 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 77db28830ce9e..81955d0a188cf 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -42,6 +42,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_imeta.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_timestats.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -61,7 +62,6 @@ xrep_attempt(
 	struct xfs_scrub	*sc,
 	struct xchk_stats_run	*run)
 {
-	u64			repair_start;
 	int			error = 0;
 
 	trace_xrep_attempt(XFS_I(file_inode(sc->file)), sc->sm, error);
@@ -72,10 +72,10 @@ xrep_attempt(
 	/* Repair whatever's broken. */
 	ASSERT(sc->ops->repair);
 	run->repair_attempted = true;
-	repair_start = xchk_stats_now();
+	run->repair_start = xchk_stats_now();
 	error = sc->ops->repair(sc);
+	run->repair_stop = xchk_stats_now();
 	trace_xrep_done(XFS_I(file_inode(sc->file)), sc->sm, error);
-	run->repair_ns += xchk_stats_elapsed_ns(repair_start);
 	switch (error) {
 	case 0:
 		/*
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 4322743aa5578..fc4a71fab51e6 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -22,6 +22,7 @@
 #include "xfs_dir2.h"
 #include "xfs_parent.h"
 #include "xfs_icache.h"
+#include "xfs_timestats.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -677,7 +678,6 @@ xfs_scrub_metadata(
 	struct xchk_stats_run		run = { };
 	struct xfs_scrub		*sc;
 	struct xfs_mount		*mp = XFS_I(file_inode(file))->i_mount;
-	u64				check_start;
 	int				error = 0;
 
 	BUILD_BUG_ON(sizeof(meta_scrub_ops) !=
@@ -735,12 +735,12 @@ xfs_scrub_metadata(
 		goto out_teardown;
 
 	/* Scrub for errors. */
-	check_start = xchk_stats_now();
+	run.scrub_start = xchk_stats_now();
 	if ((sc->flags & XREP_ALREADY_FIXED) && sc->ops->repair_eval != NULL)
 		error = sc->ops->repair_eval(sc);
 	else
 		error = sc->ops->scrub(sc);
-	run.scrub_ns += xchk_stats_elapsed_ns(check_start);
+	run.scrub_stop = xchk_stats_now();
 	if (error == -EDEADLOCK && !(sc->flags & XCHK_TRY_HARDER))
 		goto try_harder;
 	if (error == -ECHRNG && !(sc->flags & XCHK_NEED_DRAIN))
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index 0e0be23adfcb4..b9e6ace59e572 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -12,6 +12,7 @@
 #include "xfs_sysfs.h"
 #include "xfs_btree.h"
 #include "xfs_super.h"
+#include "xfs_timestats.h"
 #include "scrub/scrub.h"
 #include "scrub/stats.h"
 #include "scrub/trace.h"
@@ -44,12 +45,24 @@ struct xchk_scrub_stats {
 	spinlock_t		css_lock;
 };
 
+struct xchk_timestats {
+#ifdef CONFIG_XFS_TIME_STATS
+	struct dentry		*parent;
+	struct {
+		struct time_stats	scrub;
+		struct time_stats	repair;
+	} scrub[XFS_SCRUB_TYPE_NR];
+#endif
+};
+
 struct xchk_stats {
 	struct dentry		*cs_debugfs;
+#ifdef CONFIG_XFS_TIME_STATS
+	struct xchk_timestats	*cs_timestats;
+#endif
 	struct xchk_scrub_stats	cs_stats[XFS_SCRUB_TYPE_NR];
 };
 
-
 static struct xchk_stats	global_stats;
 
 static const char *name_map[XFS_SCRUB_TYPE_NR] = {
@@ -86,6 +99,107 @@ static const char *name_map[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_RTRMAPBT]	= "rtrmapbt",
 	[XFS_SCRUB_TYPE_RTREFCBT]	= "rtrefcountbt",
 };
+#ifdef CONFIG_XFS_TIME_STATS
+static inline void
+xchk_timestats_init(
+	struct xchk_stats	*cs,
+	struct xfs_mount	*mp)
+{
+	struct xchk_timestats	*ts;
+	unsigned int		i;
+
+	/* Only individual mounts have timestats so far */
+	if (!mp) {
+		cs->cs_timestats = NULL;
+		return;
+	}
+
+	/* timestats are optional */
+	ts = kmalloc(sizeof(struct xchk_timestats), GFP_KERNEL);
+	if (!ts) {
+		cs->cs_timestats = NULL;
+		return;
+	}
+
+	for (i = 0; i < XFS_SCRUB_TYPE_NR; i++) {
+		time_stats_init(&ts->scrub[i].scrub);
+		time_stats_init(&ts->scrub[i].repair);
+	}
+
+	ts->parent = mp->m_timestats.ts_debugfs;
+	cs->cs_timestats = ts;
+}
+
+static inline void
+xchk_timestats_teardown(
+	struct xchk_stats	*cs)
+{
+	struct xchk_timestats	*ts = cs->cs_timestats;
+	unsigned int		i;
+
+	if (!ts)
+		return;
+
+	for (i = 0; i < XFS_SCRUB_TYPE_NR; i++) {
+		time_stats_exit(&ts->scrub[i].scrub);
+		time_stats_exit(&ts->scrub[i].repair);
+	}
+	kfree(ts);
+	cs->cs_timestats = NULL;
+}
+
+static inline void
+xchk_timestats_register(
+	struct xchk_stats	*cs)
+{
+	char			name[32];
+	struct xchk_timestats	*ts = cs->cs_timestats;
+	unsigned int		i;
+
+	if (!ts)
+		return;
+
+	for (i = 0; i < XFS_SCRUB_TYPE_NR; i++) {
+		if (!name_map[i])
+			continue;
+
+		snprintf(name, 32, "scrub::%s", name_map[i]);
+		debugfs_create_file(name, 0444, ts->parent,
+				&ts->scrub[i].scrub, &xfs_timestats_fops);
+
+		snprintf(name, 32, "repair::%s", name_map[i]);
+		debugfs_create_file(name, 0444, ts->parent,
+				&ts->scrub[i].repair, &xfs_timestats_fops);
+	}
+}
+
+STATIC void
+xchk_timestats_merge_one(
+	struct xchk_stats		*cs,
+	const struct xfs_scrub_metadata	*sm,
+	const struct xchk_stats_run	*run)
+{
+	struct xchk_timestats		*ts = cs->cs_timestats;
+
+	if (sm->sm_type >= XFS_SCRUB_TYPE_NR) {
+		ASSERT(sm->sm_type < XFS_SCRUB_TYPE_NR);
+		return;
+	}
+	if (!ts)
+		return;
+
+	xfs_timestats_interval(&ts->scrub[sm->sm_type].scrub,
+			run->scrub_start, run->scrub_stop);
+	xfs_timestats_interval(&ts->scrub[sm->sm_type].repair,
+			run->repair_start, run->repair_stop);
+}
+
+#else
+# define xchk_timestats_init(cs, mp)	((void)0)
+# define xchk_timestats_teardown(cs)	((void)0)
+# define xchk_timestats_register(cs)	((void)0)
+# define xchk_timestats_merge_one(...)	((void)0)
+#endif
 
 /* Format the scrub stats into a text buffer, similar to pcp style. */
 STATIC ssize_t
@@ -192,6 +306,7 @@ xchk_stats_merge_one(
 	const struct xchk_stats_run	*run)
 {
 	struct xchk_scrub_stats		*css;
+	u64				delta;
 
 	if (sm->sm_type >= XFS_SCRUB_TYPE_NR) {
 		ASSERT(sm->sm_type < XFS_SCRUB_TYPE_NR);
@@ -216,13 +331,15 @@ xchk_stats_merge_one(
 	if (sm->sm_flags & XFS_SCRUB_OFLAG_WARNING)
 		css->warning++;
 	css->retries += run->retries;
-	css->checktime_us += howmany_64(run->scrub_ns, NSEC_PER_USEC);
+	delta = max(1, run->scrub_stop - run->scrub_start);
+	css->checktime_us += howmany_64(delta, NSEC_PER_USEC);
 
 	if (run->repair_attempted)
 		css->repair_invocations++;
 	if (run->repair_succeeded)
 		css->repair_success++;
-	css->repairtime_us += howmany_64(run->repair_ns, NSEC_PER_USEC);
+	delta = max(1, run->repair_stop - run->repair_start);
+	css->repairtime_us += howmany_64(delta, NSEC_PER_USEC);
 	spin_unlock(&css->css_lock);
 }
 
@@ -235,6 +352,7 @@ xchk_stats_merge(
 {
 	xchk_stats_merge_one(&global_stats, sm, run);
 	xchk_stats_merge_one(mp->m_scrub_stats, sm, run);
+	xchk_timestats_merge_one(mp->m_scrub_stats, sm, run);
 }
 
 /* debugfs boilerplate */
@@ -321,6 +439,7 @@ xchk_stats_init(
 	for (i = 0; i < XFS_SCRUB_TYPE_NR; i++, css++)
 		spin_lock_init(&css->css_lock);
 
+	xchk_timestats_init(cs, mp);
 	return 0;
 }
 
@@ -341,6 +460,8 @@ xchk_stats_register(
 			&scrub_stats_fops);
 	debugfs_create_file("clear_stats", 0400, cs->cs_debugfs, cs,
 			&clear_scrub_stats_fops);
+
+	xchk_timestats_register(cs);
 }
 
 /* Free all resources related to the stats object. */
@@ -348,6 +469,7 @@ STATIC int
 xchk_stats_teardown(
 	struct xchk_stats	*cs)
 {
+	xchk_timestats_teardown(cs);
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/stats.h b/fs/xfs/scrub/stats.h
index b358ad8d8b90a..f615bff22dd22 100644
--- a/fs/xfs/scrub/stats.h
+++ b/fs/xfs/scrub/stats.h
@@ -7,8 +7,8 @@
 #define __XFS_SCRUB_STATS_H__
 
 struct xchk_stats_run {
-	u64			scrub_ns;
-	u64			repair_ns;
+	u64			scrub_start, scrub_stop;
+	u64			repair_start, repair_stop;
 	unsigned int		retries;
 	bool			repair_attempted;
 	bool			repair_succeeded;
@@ -29,21 +29,7 @@ void xchk_stats_unregister(struct xchk_stats *cs);
 void xchk_stats_merge(struct xfs_mount *mp, const struct xfs_scrub_metadata *sm,
 		const struct xchk_stats_run *run);
 
-static inline u64 xchk_stats_now(void) { return ktime_get_ns(); }
-static inline u64 xchk_stats_elapsed_ns(u64 since)
-{
-	u64 now = xchk_stats_now();
-
-	/*
-	 * If the system doesn't have a high enough resolution clock, charge at
-	 * least one nanosecond so that our stats don't report instantaneous
-	 * runtimes.
-	 */
-	if (now == since)
-		return 1;
-
-	return now - since;
-}
+static inline u64 xchk_stats_now(void) { return local_clock(); }
 #else
 # define xchk_global_stats_setup(parent)	(0)
 # define xchk_global_stats_teardown()		((void)0)
@@ -52,7 +38,6 @@ static inline u64 xchk_stats_elapsed_ns(u64 since)
 # define xchk_stats_register(cs, parent)	((void)0)
 # define xchk_stats_unregister(cs)		((void)0)
 # define xchk_stats_now()			(0)
-# define xchk_stats_elapsed_ns(x)		(0 * (x))
 # define xchk_stats_merge(mp, sm, run)		((void)0)
 #endif /* CONFIG_XFS_ONLINE_SCRUB_STATS */
 
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 27f9ec7721a93..8598294514aa3 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -68,6 +68,7 @@ typedef __u32			xfs_nlink_t;
 # include <linux/seq_buf.h>
 # include <linux/time_stats.h>
 #endif
+#include <linux/sched/clock.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_timestats.h b/fs/xfs/xfs_timestats.h
index e53dbb40c8fff..418e5abf2cf12 100644
--- a/fs/xfs/xfs_timestats.h
+++ b/fs/xfs/xfs_timestats.h
@@ -18,6 +18,7 @@ void xfs_timestats_destroy(struct xfs_mount *mp);
 # define DEFINE_XFS_TIMESTAT(name)	u64 name = local_clock()
 # define xfs_timestats_start(b)		do { *(b) = local_clock(); } while (0)
 # define xfs_timestats_end(a, b)	time_stats_update((a), (b))
+# define xfs_timestats_interval(a,b,c)	__time_stats_update((a), (b), (c))
 #else
 # define xfs_timestats_init(mp)		((void)0)
 # define xfs_timestats_export(mp)	((void)0)
@@ -28,6 +29,7 @@ void xfs_timestats_destroy(struct xfs_mount *mp);
 # define DEFINE_XFS_TIMESTAT(name)
 # define xfs_timestats_start(t)		((void)0)
 # define xfs_timestats_end(s, t)	((void)0)
+# define xfs_timestats_interval(...)	((void)0)
 #endif /* CONFIG_XFS_TIME_STATS */
 
 #endif /* __XFS_TIMESTATS_H__ */

