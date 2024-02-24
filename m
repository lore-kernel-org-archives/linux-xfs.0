Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559C11FAA;
	Sat, 24 Feb 2024 01:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737553; cv=none; b=W9KW/CS9oDfyQS9gw6d3F1d08jdecHTYzepseXzwgVoBJhdPdg4fISPYLN3nOWo/Y6tYUnR/nl4TG6T2IE5fvc23zgtvNcBhfliSxZxrz0M23+FBtAJtLf2qUmaj8Am+SNzi2oTGS0MygY1x0Gf5DsUbk12O/tSTqydCwlGgpuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737553; c=relaxed/simple;
	bh=razc7N0g69qAFe7tQUMD8XcGdlPPa3mNBbDjzboXQxQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AJ59DjRXF3xjdUxxg7FaAWIvuS5h+iPsvWlTJ36JDqhWGdOD3KnTxosTSqC7CPH5Gw/ZO42+BOh4unk4IO69gcLDumBlhMu2pn4TRj02dRao6ibriV9iZ+x+m5FzLpIC6oReee7gcP69Pd20EDfHqLsYUnV4HVE5D0vOUrycBwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RJ03BOo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RJ03BOo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FC0C43601;
	Sat, 24 Feb 2024 01:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708737553;
	bh=razc7N0g69qAFe7tQUMD8XcGdlPPa3mNBbDjzboXQxQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RJ03BOo0/odJ3l/deen7Ro50h222V+Fw3yDxDodp7QPRmDO+UlEj1lRG4US267tX6
	 0WaMizZQyPHhYDNXr457CSgLkQM1HzpR0ZCuS1P2rWmcV+59G3jwsXnwGV/K3KVkEB
	 3V9WdWjTsFfED9Fwk9MZ8GACJDP7WicTFLGI4VM9mKjvE3/iADJspmRip475SI2Kih
	 c13nSzKvvvUc1s/QYUr2m2xRqqpQjY/r87UiFpvdHSmZpsu2gvWwrbppM/rPHSNtx6
	 kBWasJmD05yaFrAcfvuWFhyCJ7HKtQgRNLW6nq5MU4O6TSuD9oO45r8HUYmrc7Mzi1
	 qLRoMmeRS/GRQ==
Date: Fri, 23 Feb 2024 17:19:12 -0800
Subject: [PATCH 6/8] xfs: report media errors through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org
Message-ID: <170873669962.1861872.7286414320963544489.stgit@frogsfrogsfrogs>
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

Set up a media error event hook so that we can send events to userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c            |    1 
 fs/xfs/xfs_healthmon.c      |  107 ++++++++++++++++++++++++++++-
 fs/xfs/xfs_healthmon.h      |   13 +++
 fs/xfs/xfs_mount.h          |    3 +
 fs/xfs/xfs_notify_failure.c |  161 ++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_notify_failure.h |   42 +++++++++++
 fs/xfs/xfs_super.c          |    1 
 fs/xfs/xfs_super.h          |    1 
 fs/xfs/xfs_trace.c          |    1 
 fs/xfs/xfs_trace.h          |   35 +++++++++
 10 files changed, 330 insertions(+), 35 deletions(-)
 create mode 100644 fs/xfs/xfs_notify_failure.h


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b11515f7f270f..1e21c508e4982 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -23,6 +23,7 @@
 #include "xfs_ag.h"
 #include "xfs_buf_mem.h"
 #include "xfs_timestats.h"
+#include "xfs_notify_failure.h"
 
 struct kmem_cache *xfs_buf_cache;
 
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index d3b548a63f0b9..34efc5b5d85e3 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -21,6 +21,7 @@
 #include "xfs_fsops.h"
 #include "xfs_health.h"
 #include "xfs_healthmon.h"
+#include "xfs_notify_failure.h"
 
 /*
  * Live Health Monitoring
@@ -153,6 +154,21 @@
  *     "bitmap":     free space bitmap contents for this group
  *     "rmapbt":     reverse mapping btree
  *     "refcountbt": reference count btree
+ *
+ * Media Failures
+ * --------------
+ *
+ * {
+ *	"type": "media",
+ *	"domain": "datadev" | "logdev" | "rtdev",
+ *	"daddr": integer,
+ *	"bbcount": integer,
+ *	"time_ns": integer
+ * }
+ *
+ * The domain element tells us which device reported a media failure.  The
+ * daddr and bbcount elements tell us where inside that device the failure was
+ * observed.
  */
 
 #define XFS_HEALTHMON_MAX_EVENTS \
@@ -180,6 +196,7 @@ struct xfs_healthmon {
 	/* live update hooks */
 	struct xfs_shutdown_hook	shook;
 	struct xfs_health_hook		hhook;
+	struct xfs_media_error_hook	mhook;
 
 	/* filesystem mount, or NULL if we've unmounted */
 	struct xfs_mount		*mp;
@@ -227,9 +244,11 @@ xfs_healthmon_exit(
 	trace_xfs_healthmon_exit(hm->mp, hm->events, hm->lost_prev_event);
 
 	if (hm->mp) {
+		xfs_media_error_hook_del(hm->mp, &hm->mhook);
 		xfs_health_hook_del(hm->mp, &hm->hhook);
 		xfs_shutdown_hook_del(hm->mp, &hm->shook);
 	}
+	xfs_media_error_hook_disable();
 	xfs_health_hook_disable();
 	xfs_shutdown_hook_disable();
 	mutex_destroy(&hm->lock);
@@ -526,6 +545,55 @@ xfs_healthmon_metadata_hook(
 	return NOTIFY_DONE;
 }
 
+#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_FS_DAX)
+/* Add a media error event to the reporting queue. */
+STATIC int
+xfs_healthmon_media_error_hook(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_healthmon		*hm;
+	struct xfs_healthmon_event	*event;
+	struct xfs_media_error_params	*p = data;
+	struct xfs_mount		*mp = p->btp->bt_mount;
+	enum xfs_healthmon_domain	domain;
+	int				error;
+
+	hm = container_of(nb, struct xfs_healthmon, mhook.error_hook.nb);
+
+	mutex_lock(&hm->lock);
+
+	trace_xfs_healthmon_media_error_hook(hm->mp, p, hm->events,
+			hm->lost_prev_event);
+
+	error = xfs_healthmon_start_live_update(hm);
+	if (error)
+		goto out_unlock;
+
+	if (mp->m_logdev_targp != mp->m_ddev_targp &&
+	    mp->m_logdev_targp == p->btp) {
+		domain = XFS_HEALTHMON_LOGDEV;
+	} else if (mp->m_rtdev_targp == p->btp) {
+		domain = XFS_HEALTHMON_RTDEV;
+	} else {
+		domain = XFS_HEALTHMON_DATADEV;
+	}
+
+	event = new_event(hm, XFS_HEALTHMON_MEDIA_ERROR, domain);
+	if (!event)
+		goto out_unlock;
+
+	event->daddr = p->daddr;
+	event->bbcount = p->bbcount;
+	xfs_healthmon_push(hm, event);
+
+out_unlock:
+	mutex_unlock(&hm->lock);
+	return NOTIFY_DONE;
+}
+#endif
+
 /* Render the health update type as a string. */
 STATIC const char *
 xfs_healthmon_typestring(
@@ -538,6 +606,7 @@ xfs_healthmon_typestring(
 		[XFS_HEALTHMON_SICK]		= "sick",
 		[XFS_HEALTHMON_CORRUPT]		= "corrupt",
 		[XFS_HEALTHMON_HEALTHY]		= "healthy",
+		[XFS_HEALTHMON_MEDIA_ERROR]	= "media",
 	};
 
 	if (event->type >= ARRAY_SIZE(type_strings))
@@ -558,6 +627,9 @@ xfs_healthmon_domstring(
 		[XFS_HEALTHMON_AG]		= "ag",
 		[XFS_HEALTHMON_INODE]		= "inode",
 		[XFS_HEALTHMON_RTGROUP]		= "rtgroup",
+		[XFS_HEALTHMON_DATADEV]		= "datadev",
+		[XFS_HEALTHMON_LOGDEV]		= "logdev",
+		[XFS_HEALTHMON_RTDEV]		= "rtdev",
 	};
 
 	if (event->domain >= ARRAY_SIZE(dom_strings))
@@ -783,6 +855,23 @@ xfs_healthmon_format_inode(
 			event->gen);
 }
 
+/* Render media error as a string set */
+static ssize_t
+xfs_healthmon_format_media_error(
+	struct stdio_redirect		*out,
+	const struct xfs_healthmon_event *event)
+{
+	ssize_t				ret;
+
+	ret = stdio_redirect_printf(out, false, "  \"daddr\":      %llu,\n",
+			event->daddr);
+	if (ret < 0)
+		return ret;
+
+	return stdio_redirect_printf(out, false, "  \"bbcount\":    %llu,\n",
+			event->bbcount);
+}
+
 /* Format an event into json. */
 STATIC int
 xfs_healthmon_format(
@@ -836,6 +925,11 @@ xfs_healthmon_format(
 	case XFS_HEALTHMON_INODE:
 		ret = xfs_healthmon_format_inode(out, event);
 		break;
+	case XFS_HEALTHMON_DATADEV:
+	case XFS_HEALTHMON_LOGDEV:
+	case XFS_HEALTHMON_RTDEV:
+		ret = xfs_healthmon_format_media_error(out, event);
+		break;
 	}
 	if (ret < 0)
 		return ret;
@@ -942,6 +1036,7 @@ xfs_healthmon_create(
 
 	xfs_shutdown_hook_enable();
 	xfs_health_hook_enable();
+	xfs_media_error_hook_enable();
 
 	xfs_shutdown_hook_setup(&hm->shook, xfs_healthmon_shutdown_hook);
 	ret = xfs_shutdown_hook_add(mp, &hm->shook);
@@ -953,18 +1048,26 @@ xfs_healthmon_create(
 	if (ret)
 		goto out_shutdown;
 
-	ret = run_thread_with_stdout(&hm->thread, &xfs_healthmon_ops);
-	if (ret < 0)
+	xfs_media_error_hook_setup(&hm->mhook, xfs_healthmon_media_error_hook);
+	ret = xfs_media_error_hook_add(mp, &hm->mhook);
+	if (ret)
 		goto out_health;
 
+	ret = run_thread_with_stdout(&hm->thread, &xfs_healthmon_ops);
+	if (ret < 0)
+		goto out_media;
+
 	trace_xfs_healthmon_create(mp, hmo->flags, hmo->format);
 
 	return ret;
+out_media:
+	xfs_media_error_hook_del(mp, &hm->mhook);
 out_health:
 	xfs_health_hook_del(mp, &hm->hhook);
 out_shutdown:
 	xfs_shutdown_hook_del(mp, &hm->shook);
 out_hooks:
+	xfs_media_error_hook_disable();
 	xfs_health_hook_disable();
 	xfs_shutdown_hook_disable();
 	mutex_destroy(&hm->lock);
diff --git a/fs/xfs/xfs_healthmon.h b/fs/xfs/xfs_healthmon.h
index e445a89decc57..97d77ea9285f6 100644
--- a/fs/xfs/xfs_healthmon.h
+++ b/fs/xfs/xfs_healthmon.h
@@ -17,6 +17,9 @@ enum xfs_healthmon_type {
 	XFS_HEALTHMON_CORRUPT,	/* fsck reported corruption */
 	XFS_HEALTHMON_HEALTHY,	/* fsck reported healthy structure */
 	XFS_HEALTHMON_UNMOUNT,	/* filesystem is unmounting */
+
+	/* media errors */
+	XFS_HEALTHMON_MEDIA_ERROR,
 };
 
 enum xfs_healthmon_domain {
@@ -28,6 +31,11 @@ enum xfs_healthmon_domain {
 	XFS_HEALTHMON_AG,	/* allocation group metadata */
 	XFS_HEALTHMON_INODE,	/* inode metadata */
 	XFS_HEALTHMON_RTGROUP,	/* realtime group metadata */
+
+	/* media errors */
+	XFS_HEALTHMON_DATADEV,
+	XFS_HEALTHMON_RTDEV,
+	XFS_HEALTHMON_LOGDEV,
 };
 
 struct xfs_healthmon_event {
@@ -61,6 +69,11 @@ struct xfs_healthmon_event {
 			uint32_t	gen;
 			xfs_ino_t	ino;
 		};
+		/* media errors */
+		struct {
+			xfs_daddr_t	daddr;
+			uint64_t	bbcount;
+		};
 	};
 };
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f1db647b94871..4bfe9c80d8abd 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -290,6 +290,9 @@ typedef struct xfs_mount {
 	/* Hook to feed shutdown events to a daemon. */
 	struct xfs_hooks	m_shutdown_hooks;
 
+	/* Hook to feed media error events to a daemon. */
+	struct xfs_hooks	m_media_error_hooks;
+
 	struct xfs_timestats	m_timestats;
 } xfs_mount_t;
 
diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index fa50e5308292d..db15db7650c26 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -19,6 +19,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_trans.h"
 #include "xfs_ag.h"
+#include "xfs_notify_failure.h"
 
 #include <linux/mm.h>
 #include <linux/dax.h>
@@ -255,6 +256,112 @@ xfs_dax_notify_ddev_failure(
 	return error;
 }
 
+static int
+xfs_dax_translate_range(
+	struct xfs_buftarg	*btp,
+	u64			offset,
+	u64			len,
+	xfs_daddr_t		*daddr,
+	uint64_t		*bbcount)
+{
+	u64			ddev_start;
+	u64			ddev_end;
+
+	ddev_start = btp->bt_dax_part_off;
+	ddev_end = ddev_start + bdev_nr_bytes(btp->bt_bdev) - 1;
+
+	/* Notify failure on the whole device. */
+	if (offset == 0 && len == U64_MAX) {
+		offset = ddev_start;
+		len = bdev_nr_bytes(btp->bt_bdev);
+	}
+
+	/* Ignore the range out of filesystem area */
+	if (offset + len - 1 < ddev_start)
+		return -ENXIO;
+	if (offset > ddev_end)
+		return -ENXIO;
+
+	/* Calculate the real range when it touches the boundary */
+	if (offset > ddev_start)
+		offset -= ddev_start;
+	else {
+		len -= ddev_start - offset;
+		offset = 0;
+	}
+	if (offset + len - 1 > ddev_end)
+		len = ddev_end - offset + 1;
+
+	*daddr = BTOBB(offset);
+	*bbcount = BTOBB(len);
+	return 0;
+}
+
+#ifdef CONFIG_XFS_LIVE_HOOKS
+DEFINE_STATIC_XFS_HOOK_SWITCH(xfs_media_error_hooks_switch);
+
+void
+xfs_media_error_hook_disable(void)
+{
+	xfs_hooks_switch_off(&xfs_media_error_hooks_switch);
+}
+
+void
+xfs_media_error_hook_enable(void)
+{
+	xfs_hooks_switch_on(&xfs_media_error_hooks_switch);
+}
+
+/* Call downstream hooks for a media error. */
+static inline void
+xfs_media_error_hook(
+	struct xfs_mount		*mp,
+	struct xfs_buftarg		*btp,
+	xfs_daddr_t			daddr,
+	uint64_t			bbcount,
+	int				mf_flags)
+{
+	if (xfs_hooks_switched_on(&xfs_media_error_hooks_switch)) {
+		struct xfs_media_error_params p = {
+			.btp		= btp,
+			.daddr		= daddr,
+			.bbcount	= bbcount,
+		};
+
+		xfs_hooks_call(&mp->m_media_error_hooks, 0, &p);
+	}
+}
+
+/* Call the specified function during a media error. */
+int
+xfs_media_error_hook_add(
+	struct xfs_mount		*mp,
+	struct xfs_media_error_hook	*hook)
+{
+	return xfs_hooks_add(&mp->m_media_error_hooks, &hook->error_hook);
+}
+
+/* Stop calling the specified function during a media error. */
+void
+xfs_media_error_hook_del(
+	struct xfs_mount		*mp,
+	struct xfs_media_error_hook	*hook)
+{
+	xfs_hooks_del(&mp->m_media_error_hooks, &hook->error_hook);
+}
+
+/* Configure media error hook functions. */
+void
+xfs_media_error_hook_setup(
+	struct xfs_media_error_hook	*hook,
+	notifier_fn_t			mod_fn)
+{
+	xfs_hook_setup(&hook->error_hook, mod_fn);
+}
+#else
+# define xfs_media_error_hook(...)		((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 static int
 xfs_dax_notify_failure(
 	struct dax_device	*dax_dev,
@@ -263,22 +370,38 @@ xfs_dax_notify_failure(
 	int			mf_flags)
 {
 	struct xfs_mount	*mp = dax_holder(dax_dev);
-	u64			ddev_start;
-	u64			ddev_end;
+	struct xfs_buftarg	*btp;
+	xfs_daddr_t		daddr;
+	uint64_t		bbcount;
+	int			error;
 
 	if (!(mp->m_super->s_flags & SB_BORN)) {
 		xfs_warn(mp, "filesystem is not ready for notify_failure()!");
 		return -EIO;
 	}
 
-	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_daxdev == dax_dev) {
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_daxdev == dax_dev)
+		btp = mp->m_rtdev_targp;
+	else if (mp->m_logdev_targp != mp->m_ddev_targp &&
+		 mp->m_logdev_targp->bt_daxdev == dax_dev)
+		btp = mp->m_logdev_targp;
+	else
+		btp = mp->m_ddev_targp;
+
+	error = xfs_dax_translate_range(btp, offset, len, &daddr, &bbcount);
+	if (error)
+		return error;
+
+	xfs_media_error_hook(mp, btp, daddr, bbcount, mf_flags);
+
+	if (mp->m_rtdev_targp == btp) {
 		xfs_debug(mp,
 			 "notify_failure() not supported on realtime device!");
 		return -EOPNOTSUPP;
 	}
 
-	if (mp->m_logdev_targp && mp->m_logdev_targp->bt_daxdev == dax_dev &&
-	    mp->m_logdev_targp != mp->m_ddev_targp) {
+	if (mp->m_logdev_targp != mp->m_ddev_targp &&
+	    mp->m_logdev_targp == btp) {
 		/*
 		 * In the pre-remove case the failure notification is attempting
 		 * to trigger a force unmount.  The expectation is that the
@@ -297,33 +420,7 @@ xfs_dax_notify_failure(
 		return -EOPNOTSUPP;
 	}
 
-	ddev_start = mp->m_ddev_targp->bt_dax_part_off;
-	ddev_end = ddev_start + bdev_nr_bytes(mp->m_ddev_targp->bt_bdev) - 1;
-
-	/* Notify failure on the whole device. */
-	if (offset == 0 && len == U64_MAX) {
-		offset = ddev_start;
-		len = bdev_nr_bytes(mp->m_ddev_targp->bt_bdev);
-	}
-
-	/* Ignore the range out of filesystem area */
-	if (offset + len - 1 < ddev_start)
-		return -ENXIO;
-	if (offset > ddev_end)
-		return -ENXIO;
-
-	/* Calculate the real range when it touches the boundary */
-	if (offset > ddev_start)
-		offset -= ddev_start;
-	else {
-		len -= ddev_start - offset;
-		offset = 0;
-	}
-	if (offset + len - 1 > ddev_end)
-		len = ddev_end - offset + 1;
-
-	return xfs_dax_notify_ddev_failure(mp, BTOBB(offset), BTOBB(len),
-			mf_flags);
+	return xfs_dax_notify_ddev_failure(mp, daddr, bbcount, mf_flags);
 }
 
 const struct dax_holder_operations xfs_dax_holder_operations = {
diff --git a/fs/xfs/xfs_notify_failure.h b/fs/xfs/xfs_notify_failure.h
new file mode 100644
index 0000000000000..71dc6e4766c57
--- /dev/null
+++ b/fs/xfs/xfs_notify_failure.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_NOTIFY_FAILURE_H__
+#define __XFS_NOTIFY_FAILURE_H__
+
+extern const struct dax_holder_operations xfs_dax_holder_operations;
+
+#if defined(CONFIG_XFS_LIVE_HOOKS) && defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_FS_DAX)
+struct xfs_media_error_params {
+	struct xfs_buftarg		*btp;
+	xfs_daddr_t			daddr;
+	uint64_t			bbcount;
+	int				mf_flags;
+};
+
+struct xfs_media_error_hook {
+	struct xfs_hook			error_hook;
+};
+
+void xfs_media_error_hook_disable(void);
+void xfs_media_error_hook_enable(void);
+
+int xfs_media_error_hook_add(struct xfs_mount *mp,
+		struct xfs_media_error_hook *hook);
+void xfs_media_error_hook_del(struct xfs_mount *mp,
+		struct xfs_media_error_hook *hook);
+void xfs_media_error_hook_setup(struct xfs_media_error_hook *hook,
+		notifier_fn_t mod_fn);
+#else
+struct xfs_media_error_params { };
+struct xfs_media_error_hook { };
+# define xfs_media_error_hook_disable()		((void)0)
+# define xfs_media_error_hook_enable()		((void)0)
+# define xfs_media_error_hook_add(...)		(0)
+# define xfs_media_error_hook_del(...)		((void)0)
+# define xfs_media_error_hook_setup(...)	((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
+#endif /* __XFS_NOTIFY_FAILURE_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1ed848a3706be..5aa51d5402809 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2083,6 +2083,7 @@ static int xfs_init_fs_context(
 	xfs_hooks_init(&mp->m_dir_update_hooks);
 	xfs_hooks_init(&mp->m_shutdown_hooks);
 	xfs_hooks_init(&mp->m_health_update_hooks);
+	xfs_hooks_init(&mp->m_media_error_hooks);
 	xfs_timestats_init(mp);
 
 	fc->s_fs_info = mp;
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 302e6e5d6c7e2..c0e85c1e42f27 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -92,7 +92,6 @@ extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
 
 extern const struct export_operations xfs_export_operations;
 extern const struct quotactl_ops xfs_quotactl_operations;
-extern const struct dax_holder_operations xfs_dax_holder_operations;
 
 extern void xfs_reinit_percpu_counters(struct xfs_mount *mp);
 
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 14bc3f8cf306d..8e0bddaa2df2c 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -49,6 +49,7 @@
 #include "xfs_fsrefs.h"
 #include "xfs_health.h"
 #include "xfs_healthmon.h"
+#include "xfs_notify_failure.h"
 
 static inline void
 xfs_rmapbt_crack_agno_opdev(
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2f296ba1db822..f5be973be5433 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -104,6 +104,7 @@ struct xfs_refcount_intent;
 struct xfs_fsrefs;
 struct xfs_healthmon_event;
 struct xfs_health_update_params;
+struct xfs_media_error_params;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -6015,6 +6016,40 @@ TRACE_EVENT(xfs_healthmon_metadata_hook,
 		  __entry->lost_prev)
 );
 
+#if defined(CONFIG_XFS_LIVE_HOOKS) && defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_FS_DAX)
+TRACE_EVENT(xfs_healthmon_media_error_hook,
+	TP_PROTO(const struct xfs_mount *mp,
+		 const struct xfs_media_error_params *p,
+		 unsigned int events, bool lost_prev),
+	TP_ARGS(mp, p, events, lost_prev),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, error_dev)
+		__field(uint64_t, daddr)
+		__field(uint64_t, bbcount)
+		__field(unsigned int, events)
+		__field(bool, lost_prev)
+	),
+	TP_fast_assign(
+		if (mp) {
+			__entry->dev = mp->m_super->s_dev;
+			__entry->error_dev = p->btp->bt_dev;
+		}
+		__entry->daddr = p->daddr;
+		__entry->bbcount = p->bbcount;
+		__entry->events = events;
+		__entry->lost_prev = lost_prev;
+	),
+	TP_printk("dev %d:%d error_dev %d:%d daddr 0x%llx bbcount 0x%llx events %u lost_prev? %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->error_dev), MINOR(__entry->error_dev),
+		  __entry->daddr,
+		  __entry->bbcount,
+		  __entry->events,
+		  __entry->lost_prev)
+);
+#endif
+
 DECLARE_EVENT_CLASS(xfs_healthmon_class,
 	TP_PROTO(const struct xfs_mount *mp, unsigned int events, bool lost_prev),
 	TP_ARGS(mp, events, lost_prev),

