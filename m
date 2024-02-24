Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723B54688;
	Sat, 24 Feb 2024 01:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737522; cv=none; b=NY27n4kbHgKY/MvIErXrgIUXGwTV0kLwYZCq/NLm1ODsnZAhmsGv5LnBZRMs1XM3TYR2TMVO6/svDltc2uqbciZt9A+RN6LRbP5ZIlrUad9f7psxpp4GUXGvime7mLBYJ7qBtbfhwU+19aQuArgz3T5Y8VP06Rqx86B5VjOoP7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737522; c=relaxed/simple;
	bh=dQyB1X6yllZAAo6hQP3CTaMNoi76YJI+rsi2xktQzYQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HQj1lBTqFVFFmO7YuvPm/ldg2121Md52CFVC9wDT0gOaF+FCKj9CCM14IMMlVzvKz7Vw+APISjepE7r2BCz0OuJiKDOwl9k7SeGkDnPH3BdATI1eEuu1ybZOrzkJCAoS321P6h4RDvMV+Q0G6huydMT+i1W6FEDQz2x0xWCF8OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tnLJLWbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tnLJLWbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04255C433F1;
	Sat, 24 Feb 2024 01:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708737522;
	bh=dQyB1X6yllZAAo6hQP3CTaMNoi76YJI+rsi2xktQzYQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tnLJLWbJqKFegMjAUV+4nD0p1zx3rZ+Z3S2C4SA+95WsbKwbcWfoTaGjUI1MJtqNq
	 o3Vl6H/qH0rElHsS243XSklfHpT/odQINeFUdbt0HQ8vtV3VDkTspsw5Q1LrpqdaOC
	 CSbZP1IhX6qx+X5CCMDSlVtmL8ZXDa0Cvcx//kU9EtqUgOL+Ui10PcuGgwTr2Hq2YN
	 /CNrbwrfWK0oRc28fF0h2fIYrH2mzNZm3UPFvmMVdLT0VINzHqPg9UqATWRrV8HJ2u
	 XtUj3awr8S3i2mhYsLr3QhV7ojpUf9imXZ29kUoqNttkrF2NNQmMu2XTSBe9X3QSTu
	 37VvFlYOmplrg==
Date: Fri, 23 Feb 2024 17:18:41 -0800
Subject: [PATCH 4/8] xfs: report shutdown events through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org
Message-ID: <170873669929.1861872.13258003723476531282.stgit@frogsfrogsfrogs>
In-Reply-To: <170873669843.1861872.1241932246549132485.stgit@frogsfrogsfrogs>
References: <170873669843.1861872.1241932246549132485.stgit@frogsfrogsfrogs>
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

Set up a shutdown hook so that we can send notifications to userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs_staging.h |    8 +
 fs/xfs/xfs_healthmon.c         |  458 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_healthmon.h         |   27 ++
 fs/xfs/xfs_trace.c             |    2 
 fs/xfs/xfs_trace.h             |  107 +++++++++
 5 files changed, 597 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs_staging.h b/fs/xfs/libxfs/xfs_fs_staging.h
index 84b99816eec2e..684d6d22cc8dd 100644
--- a/fs/xfs/libxfs/xfs_fs_staging.h
+++ b/fs/xfs/libxfs/xfs_fs_staging.h
@@ -310,6 +310,14 @@ struct xfs_health_monitor {
 	__u64	pad2[2];	/* zeroes */
 };
 
+/* Return all health status events, not just deltas */
+#define XFS_HEALTH_MONITOR_VERBOSE	(1ULL << 0)
+
+#define XFS_HEALTH_MONITOR_ALL		(XFS_HEALTH_MONITOR_VERBOSE)
+
+/* Return events in JSON format */
+#define XFS_HEALTH_MONITOR_FMT_JSON	(1)
+
 /* Monitor for health events. */
 #define XFS_IOC_HEALTH_MONITOR		_IOR ('X', 48, struct xfs_health_monitor)
 
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 9b4da8d1e5173..b215ded0fda8b 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -12,13 +12,13 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trace.h"
-#include "xfs_health.h"
 #include "xfs_ag.h"
 #include "xfs_btree.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_quota_defs.h"
 #include "xfs_rtgroup.h"
+#include "xfs_fsops.h"
 #include "xfs_healthmon.h"
 
 /*
@@ -37,11 +37,79 @@
  * so that the queueing and processing of the events do not pin the mount and
  * cannot slow down the main filesystem.  The healthmon object can exist past
  * the end of the filesystem mount.
+ *
+ * The easily parseable event format is a stream of json objects as follows:
+ *
+ * Queue Management
+ * ----------------
+ *
+ * {
+ *	"type": "lost" or "shutdown",
+ *	"domain": "mount",
+ *	"time_ns": integer
+ * }
+ *
+ * "lost" indicates that the kthread dropped events due to memory allocation
+ * failures or queue limits.
+ *
+ * "mount" means that the event affects the entire filesystem mount.
+ *
+ * "time_ns" is the time stamp of when the event originated in the kernel,
+ * expressed in nanoseconds.
+ *
+ * Abnormal Shutdowns
+ * ------------------
+ *
+ * {
+ *	"type": "shutdown",
+ *	"domain": "mount",
+ *	"reasons": [reason_string list...],
+ *	"time_ns": integer
+ * }
+ *
+ * "shutdown" indicates that the filesystem shut down either due to errors or
+ * due to an explicit request from userspace.
+ *
+ * "reasons" are a list of strings describing why the filesystem went down.
+ * They correspond to the SHUTDOWN_* flags.
  */
 
+#define XFS_HEALTHMON_MAX_EVENTS \
+		(32768 / sizeof(struct xfs_healthmon_event))
+
+struct flag_string {
+	unsigned int	mask;
+	const char	*str;
+};
+
 struct xfs_healthmon {
 	/* thread with stdio redirection */
 	struct thread_with_stdio	thread;
+
+	/* lock for mp and eventlist */
+	struct mutex			lock;
+
+	/* waiter for signalling the arrival of events */
+	struct wait_queue_head		wait;
+
+	/* list of event objects */
+	struct xfs_healthmon_event	*first_event;
+	struct xfs_healthmon_event	*last_event;
+
+	/* live update hooks */
+	struct xfs_shutdown_hook	shook;
+
+	/* filesystem mount, or NULL if we've unmounted */
+	struct xfs_mount		*mp;
+
+	/* number of events */
+	unsigned int			events;
+
+	/* do we want all events? */
+	bool				verbose;
+
+	/* did we lose an event? */
+	bool				lost_prev_event;
 };
 
 static inline struct xfs_healthmon *
@@ -50,6 +118,23 @@ to_healthmon(struct thread_with_stdio	*thr)
 	return container_of(thr, struct xfs_healthmon, thread);
 }
 
+/* Free all events */
+STATIC void
+xfs_healthmon_free_events(
+	struct xfs_healthmon		*hm)
+{
+	struct xfs_healthmon_event	*event, *next;
+
+	event = hm->first_event;
+	while (event != NULL) {
+		trace_xfs_healthmon_drop(hm->mp, event);
+		next = event->next;
+		kfree(event);
+		event = next;
+	}
+	hm->first_event = hm->last_event = NULL;
+}
+
 /* Free the health monitoring information. */
 STATIC void
 xfs_healthmon_exit(
@@ -57,15 +142,357 @@ xfs_healthmon_exit(
 {
 	struct xfs_healthmon		*hm = to_healthmon(thr);
 
+	trace_xfs_healthmon_exit(hm->mp, hm->events, hm->lost_prev_event);
+
+	if (hm->mp) {
+		xfs_shutdown_hook_del(hm->mp, &hm->shook);
+	}
+	xfs_shutdown_hook_disable();
+	mutex_destroy(&hm->lock);
+	xfs_healthmon_free_events(hm);
 	kfree(hm);
 	module_put(THIS_MODULE);
 }
 
+/* Remove an event from the head of the list. */
+static inline struct xfs_healthmon_event *
+xfs_healthmon_pop(
+	struct xfs_healthmon		*hm)
+{
+	struct xfs_healthmon_event	*ret = hm->first_event;
+
+	if (!ret)
+		return NULL;
+
+	if (hm->last_event == ret)
+		hm->last_event = NULL;
+	hm->first_event = ret->next;
+	hm->events--;
+
+	trace_xfs_healthmon_pop(hm->mp, ret);
+	return ret;
+}
+
+/* Push an event onto the end of the list. */
+static inline void
+xfs_healthmon_push(
+	struct xfs_healthmon		*hm,
+	struct xfs_healthmon_event	*event)
+{
+	if (!hm->first_event)
+		hm->first_event = event;
+	if (hm->last_event)
+		hm->last_event->next = event;
+	hm->last_event = event;
+	event->next = NULL;
+	hm->events++;
+	wake_up(&hm->wait);
+
+	trace_xfs_healthmon_push(hm->mp, event);
+}
+
+/* Create a new event or record that we failed. */
+static struct xfs_healthmon_event *
+new_event(
+	struct xfs_healthmon		*hm,
+	enum xfs_healthmon_type		type,
+	enum xfs_healthmon_domain	domain)
+{
+	struct timespec64		now;
+	struct xfs_healthmon_event	*event;
+
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event) {
+		hm->lost_prev_event = true;
+		return NULL;
+	}
+
+	event->type = type;
+	event->domain = domain;
+	ktime_get_coarse_real_ts64(&now);
+	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
+
+	return event;
+}
+
+/*
+ * Before we accept an event notification from a live update hook, we need to
+ * clear out any previously lost events.
+ */
+STATIC int
+xfs_healthmon_start_live_update(
+	struct xfs_healthmon		*hm)
+{
+	struct xfs_healthmon_event	*event;
+
+	/* Already unmounted filesystem, do nothing. */
+	if (!hm->mp)
+		return -ESHUTDOWN;
+
+	/*
+	 * If we previously lost an event or the queue is full, try to queue
+	 * a notification about lost events.
+	 */
+	if (!hm->lost_prev_event && hm->events != XFS_HEALTHMON_MAX_EVENTS)
+		return 0;
+
+	/*
+	 * A previous invocation of the live update hook could not allocate
+	 * any memory at all.  If the last event on the list is already a
+	 * notification of lost events, we're done.
+	 */
+	if (hm->last_event && hm->last_event->type == XFS_HEALTHMON_LOST)
+		return 0;
+
+	/*
+	 * There are no events or the last one wasn't about lost events.  Try
+	 * to allocate a new one to note the lost events.
+	 */
+	event = new_event(hm, XFS_HEALTHMON_LOST, XFS_HEALTHMON_MOUNT);
+	if (!event)
+		return -ENOMEM;
+
+	hm->lost_prev_event = false;
+	xfs_healthmon_push(hm, event);
+	return 0;
+}
+
+/* Add a shutdown event to the reporting queue. */
+STATIC int
+xfs_healthmon_shutdown_hook(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_healthmon		*hm;
+	struct xfs_healthmon_event	*event;
+	int				error;
+
+	hm = container_of(nb, struct xfs_healthmon, shook.shutdown_hook.nb);
+
+	mutex_lock(&hm->lock);
+
+	trace_xfs_healthmon_shutdown_hook(hm->mp, action, hm->events,
+			hm->lost_prev_event);
+
+	error = xfs_healthmon_start_live_update(hm);
+	if (error)
+		goto out_unlock;
+
+	event = new_event(hm, XFS_HEALTHMON_SHUTDOWN, XFS_HEALTHMON_MOUNT);
+	if (!event)
+		goto out_unlock;
+
+	event->flags = action;
+	xfs_healthmon_push(hm, event);
+
+out_unlock:
+	mutex_unlock(&hm->lock);
+	return NOTIFY_DONE;
+}
+
+/* Render the health update type as a string. */
+STATIC const char *
+xfs_healthmon_typestring(
+	const struct xfs_healthmon_event	*event)
+{
+	static const char *type_strings[] = {
+		[XFS_HEALTHMON_LOST]		= "lost",
+		[XFS_HEALTHMON_SHUTDOWN]	= "shutdown",
+	};
+
+	if (event->type >= ARRAY_SIZE(type_strings))
+		return "?";
+
+	return type_strings[event->type];
+}
+
+/* Render the health domain as a string. */
+STATIC const char *
+xfs_healthmon_domstring(
+	const struct xfs_healthmon_event	*event)
+{
+	static const char *dom_strings[] = {
+		[XFS_HEALTHMON_MOUNT]		= "mount",
+	};
+
+	if (event->domain >= ARRAY_SIZE(dom_strings))
+		return "?";
+
+	return dom_strings[event->domain];
+}
+
+/* Convert a flags bitmap into a jsonable string. */
+static inline int
+xfs_healthmon_format_flags(
+	struct stdio_redirect		*out,
+	const struct flag_string	*strings,
+	size_t				nr_strings,
+	unsigned int			flags)
+{
+	const struct flag_string	*p;
+	ssize_t				ret;
+	unsigned int			i;
+	bool				first = true;
+
+	for (i = 0, p = strings; i < nr_strings; i++, p++) {
+		if (!(p->mask & flags))
+			continue;
+
+		ret = stdio_redirect_printf(out, false, "%s\"%s\"",
+				first ? "" : ", ", p->str);
+		if (ret < 0)
+			return ret;
+
+		first = false;
+		flags &= ~p->mask;
+	}
+
+	for (i = 0; flags != 0 && i < sizeof(flags) * NBBY; i++) {
+		if (!(flags & (1U << i)))
+			continue;
+
+		/* json doesn't support hexadecimal notation */
+		ret = stdio_redirect_printf(out, false, "%s%u",
+				first ? "" : ", ", (1U << i));
+		if (ret < 0)
+			return ret;
+
+		first = false;
+	}
+
+	return 0;
+}
+
+/* Convert the event mask into a jsonable string. */
+static inline int
+__xfs_healthmon_format_mask(
+	struct stdio_redirect		*out,
+	const char			*descr,
+	const struct flag_string	*strings,
+	size_t				nr_strings,
+	unsigned int			mask)
+{
+	ssize_t				ret;
+
+	ret = stdio_redirect_printf(out, false, "  \"%s\":  [", descr);
+	if (ret < 0)
+		return ret;
+
+	ret = xfs_healthmon_format_flags(out, strings, nr_strings, mask);
+	if (ret < 0)
+		return ret;
+
+	return stdio_redirect_printf(out, false, "],\n");
+}
+
+#define xfs_healthmon_format_mask(o, d, s, m) \
+	__xfs_healthmon_format_mask((o), (d), (s), ARRAY_SIZE(s), (m))
+
+/* Render shutdown mask as a string set */
+static ssize_t
+xfs_healthmon_format_shutdown(
+	struct stdio_redirect		*out,
+	const struct xfs_healthmon_event *event)
+{
+	static const struct flag_string	mask_strings[] = {
+		{ SHUTDOWN_META_IO_ERROR,	"meta_ioerr" },
+		{ SHUTDOWN_LOG_IO_ERROR,	"log_ioerr" },
+		{ SHUTDOWN_FORCE_UMOUNT,	"force_umount" },
+		{ SHUTDOWN_CORRUPT_INCORE,	"corrupt_incore" },
+		{ SHUTDOWN_CORRUPT_ONDISK,	"corrupt_ondisk" },
+		{ SHUTDOWN_DEVICE_REMOVED,	"device_removed" },
+	};
+
+	return xfs_healthmon_format_mask(out, "reasons", mask_strings,
+			event->flags);
+}
+
+/* Format an event into json. */
+STATIC int
+xfs_healthmon_format(
+	struct xfs_healthmon		*hm,
+	const struct xfs_healthmon_event *event)
+{
+	struct stdio_redirect		*out = &hm->thread.stdio;
+	ssize_t				ret;
+
+	ret = stdio_redirect_printf(out, false, "{\n");
+	if (ret < 0)
+		return ret;
+
+	ret = stdio_redirect_printf(out, false, "  \"type\":       \"%s\",\n",
+			xfs_healthmon_typestring(event));
+	if (ret < 0)
+		return ret;
+
+	ret = stdio_redirect_printf(out, false, "  \"domain\":     \"%s\",\n",
+			xfs_healthmon_domstring(event));
+	if (ret < 0)
+		return ret;
+
+	switch (event->type) {
+	case XFS_HEALTHMON_SHUTDOWN:
+		ret = xfs_healthmon_format_shutdown(out, event);
+		break;
+	case XFS_HEALTHMON_LOST:
+		/* empty */
+		break;
+	default:
+		break;
+	}
+
+	switch (event->domain) {
+	case XFS_HEALTHMON_MOUNT:
+		/* empty */
+		break;
+	}
+	if (ret < 0)
+		return ret;
+
+	trace_xfs_healthmon_format(hm->mp, event);
+
+	/* The last element in the json must not have a trailing comma. */
+	ret = stdio_redirect_printf(out, false, "  \"time_ns\":    %llu\n",
+			event->time_ns);
+	if (ret < 0)
+		return ret;
+
+	return stdio_redirect_printf(out, false, "}\n");
+}
+
 /* Pipe health monitoring information to userspace. */
 STATIC void
 xfs_healthmon_run(
 	struct thread_with_stdio	*thr)
 {
+	struct xfs_healthmon		*hm = to_healthmon(thr);
+	struct xfs_healthmon_event	*event;
+	bool				unmounted = false;
+
+	while (!kthread_should_stop() && !unmounted &&
+	       wait_event_interruptible(hm->wait,
+				hm->events > 0 || hm->mp == NULL) == 0) {
+
+		trace_xfs_healthmon_run(hm->mp, hm->events, hm->lost_prev_event);
+
+		mutex_lock(&hm->lock);
+		while (!kthread_should_stop() &&
+		       (event = xfs_healthmon_pop(hm)) != NULL) {
+			mutex_unlock(&hm->lock);
+
+			xfs_healthmon_format(hm, event);
+			kfree(event);
+			cond_resched();
+
+			mutex_lock(&hm->lock);
+		}
+		if (!hm->mp)
+			unmounted = true;
+		mutex_unlock(&hm->lock);
+	}
+
+	trace_xfs_healthmon_stop(hm->mp, hm->events, hm->lost_prev_event);
 }
 
 /* Validate ioctl parameters. */
@@ -73,9 +500,9 @@ static inline bool
 xfs_healthmon_validate(
 	const struct xfs_health_monitor	*hmo)
 {
-	if (hmo->flags)
+	if (hmo->flags & ~XFS_HEALTH_MONITOR_ALL)
 		return false;
-	if (hmo->format)
+	if (hmo->format != XFS_HEALTH_MONITOR_FMT_JSON)
 		return false;
 	if (memchr_inv(&hmo->pad1, 0, sizeof(hmo->pad1)))
 		return false;
@@ -116,12 +543,33 @@ xfs_healthmon_create(
 		goto out_mod;
 	}
 
+	hm->mp = mp;
+	mutex_init(&hm->lock);
+	init_waitqueue_head(&hm->wait);
+
+	if (hmo->flags & XFS_HEALTH_MONITOR_VERBOSE)
+		hm->verbose = true;
+
+	xfs_shutdown_hook_enable();
+
+	xfs_shutdown_hook_setup(&hm->shook, xfs_healthmon_shutdown_hook);
+	ret = xfs_shutdown_hook_add(mp, &hm->shook);
+	if (ret)
+		goto out_hooks;
+
 	ret = run_thread_with_stdout(&hm->thread, &xfs_healthmon_ops);
 	if (ret < 0)
-		goto out_hm;
+		goto out_shutdown;
+
+	trace_xfs_healthmon_create(mp, hmo->flags, hmo->format);
 
 	return ret;
-out_hm:
+out_shutdown:
+	xfs_shutdown_hook_del(mp, &hm->shook);
+out_hooks:
+	xfs_shutdown_hook_disable();
+	mutex_destroy(&hm->lock);
+	xfs_healthmon_free_events(hm);
 	kfree(hm);
 out_mod:
 	module_put(THIS_MODULE);
diff --git a/fs/xfs/xfs_healthmon.h b/fs/xfs/xfs_healthmon.h
index a9a8115ec770b..f67e2f1b8f947 100644
--- a/fs/xfs/xfs_healthmon.h
+++ b/fs/xfs/xfs_healthmon.h
@@ -6,6 +6,33 @@
 #ifndef __XFS_HEALTHMON_H__
 #define __XFS_HEALTHMON_H__
 
+enum xfs_healthmon_type {
+	XFS_HEALTHMON_LOST,	/* message lost */
+
+	/* filesystem shutdown */
+	XFS_HEALTHMON_SHUTDOWN,
+};
+
+enum xfs_healthmon_domain {
+	XFS_HEALTHMON_MOUNT,	/* affects the whole fs */
+};
+
+struct xfs_healthmon_event {
+	struct xfs_healthmon_event	*next;
+
+	enum xfs_healthmon_type		type;
+	enum xfs_healthmon_domain	domain;
+
+	uint64_t			time_ns;
+
+	union {
+		/* mount */
+		struct {
+			unsigned int	flags;
+		};
+	};
+};
+
 #ifdef CONFIG_XFS_HEALTH_MONITOR
 int xfs_healthmon_create(struct xfs_mount *mp, struct xfs_health_monitor *hmo);
 #else
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index b40f01cb0fe8d..14bc3f8cf306d 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -47,6 +47,8 @@
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
 #include "xfs_fsrefs.h"
+#include "xfs_health.h"
+#include "xfs_healthmon.h"
 
 static inline void
 xfs_rmapbt_crack_agno_opdev(
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3c2a2410b17d2..54e3d6d549ec1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -102,6 +102,8 @@ struct xfs_extent_free_item;
 struct xfs_rmap_intent;
 struct xfs_refcount_intent;
 struct xfs_fsrefs;
+struct xfs_healthmon_event;
+struct xfs_health_update_params;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -5923,6 +5925,111 @@ TRACE_EVENT(xfs_growfs_check_rtgeom,
 );
 #endif /* CONFIG_XFS_RT */
 
+#ifdef CONFIG_XFS_HEALTH_MONITOR
+TRACE_EVENT(xfs_healthmon_shutdown_hook,
+	TP_PROTO(const struct xfs_mount *mp, uint32_t shutdown_flags,
+		 unsigned int events, bool lost_prev),
+	TP_ARGS(mp, shutdown_flags, events, lost_prev),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(uint32_t, shutdown_flags)
+		__field(unsigned int, events)
+		__field(bool, lost_prev)
+	),
+	TP_fast_assign(
+		__entry->dev = mp ? mp->m_super->s_dev : 0;
+		__entry->shutdown_flags = shutdown_flags;
+		__entry->events = events;
+		__entry->lost_prev = lost_prev;
+	),
+	TP_printk("dev %d:%d shutdown_flags %s events %u lost_prev? %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_flags(__entry->shutdown_flags, "|", XFS_SHUTDOWN_STRINGS),
+		  __entry->events,
+		  __entry->lost_prev)
+);
+
+DECLARE_EVENT_CLASS(xfs_healthmon_class,
+	TP_PROTO(const struct xfs_mount *mp, unsigned int events, bool lost_prev),
+	TP_ARGS(mp, events, lost_prev),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, events)
+		__field(bool, lost_prev)
+	),
+	TP_fast_assign(
+		__entry->dev = mp ? mp->m_super->s_dev : 0;
+		__entry->events = events;
+		__entry->lost_prev = lost_prev;
+	),
+	TP_printk("dev %d:%d events %u lost_prev? %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->events,
+		  __entry->lost_prev)
+);
+#define DEFINE_HEALTHMON_EVENT(name) \
+DEFINE_EVENT(xfs_healthmon_class, name, \
+	TP_PROTO(const struct xfs_mount *mp, unsigned int events, bool lost_prev), \
+	TP_ARGS(mp, events, lost_prev))
+DEFINE_HEALTHMON_EVENT(xfs_healthmon_create);
+DEFINE_HEALTHMON_EVENT(xfs_healthmon_run);
+DEFINE_HEALTHMON_EVENT(xfs_healthmon_stop);
+DEFINE_HEALTHMON_EVENT(xfs_healthmon_exit);
+DEFINE_HEALTHMON_EVENT(xfs_healthmon_unmount);
+
+#define XFS_HEALTHMON_TYPE_STRINGS \
+	{ XFS_HEALTHMON_LOST,		"lost" }, \
+	{ XFS_HEALTHMON_SHUTDOWN,	"shutdown" }
+
+#define XFS_HEALTHMON_DOMAIN_STRINGS \
+	{ XFS_HEALTHMON_MOUNT,		"mount" }
+
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_LOST);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_SHUTDOWN);
+
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_MOUNT);
+
+DECLARE_EVENT_CLASS(xfs_healthmon_event_class,
+	TP_PROTO(const struct xfs_mount *mp, const struct xfs_healthmon_event *event),
+	TP_ARGS(mp, event),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, type)
+		__field(unsigned int, domain)
+		__field(unsigned int, mask)
+		__field(unsigned long long, ino)
+		__field(unsigned int, gen)
+		__field(unsigned int, group)
+	),
+	TP_fast_assign(
+		__entry->dev = mp ? mp->m_super->s_dev : 0;
+		__entry->type = event->type;
+		__entry->domain = event->domain;
+		switch (__entry->domain) {
+		case XFS_HEALTHMON_MOUNT:
+			__entry->mask = event->flags;
+			break;
+		}
+	),
+	TP_printk("dev %d:%d type %s domain %s mask 0x%x ino 0x%llx gen 0x%x group 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XFS_HEALTHMON_TYPE_STRINGS),
+		  __print_symbolic(__entry->domain, XFS_HEALTHMON_DOMAIN_STRINGS),
+		  __entry->mask,
+		  __entry->ino,
+		  __entry->gen,
+		  __entry->group)
+);
+#define DEFINE_HEALTHMONEVENT_EVENT(name) \
+DEFINE_EVENT(xfs_healthmon_event_class, name, \
+	TP_PROTO(const struct xfs_mount *mp, const struct xfs_healthmon_event *event), \
+	TP_ARGS(mp, event))
+DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_push);
+DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_pop);
+DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_format);
+DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_drop);
+#endif /* CONFIG_XFS_HEALTH_MONITOR */
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

