Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC52D1B0414
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688503; cv=none; b=GFRS5nHFiHm5RC6Quyj834IPBT7NL9iOK9sJfvJF1lWMr+1tGGGaJ95QmUXoJVnp0+jrwt08yqaTa0soTIHYo/AYaW2rOgkBeMI1Qy9PA1esks9KToO/kimuaz50B9itpmj4OvPS+g1KcD65WsDYhx78/Bl7I1mGuphYzMEDTSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688503; c=relaxed/simple;
	bh=ELxk2YxRVoSW3pMuU+f3da524OYSN/ks0fgaJ7PN3os=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XjSoM31bbqWBBpj/xPLZFo+v+ajlFSflRZ7ouUfYkm/oTPqYzoeOQ0IFEnaVfqSONrCnrBC93wni3GK2G11dzUqhHxats8tBPpn/qk3m9DdNMAx0jn1h7OloagQDHcETykRcb1u/Bf7ZCJXVncCH2KAbHKuElsWQqXXJCCodOkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKzHyGLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKzHyGLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B170DC4CED2;
	Tue, 31 Dec 2024 23:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688503;
	bh=ELxk2YxRVoSW3pMuU+f3da524OYSN/ks0fgaJ7PN3os=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OKzHyGLntOKW1mZ09mfsCdkx8nYGvGt9KyQtZQNPczTO7yQLcs0YQbqM93Vrjw0Qp
	 47ngiz248juHkHRL6hvui7W4jddk30INZ9o2RWaxNZyt28Cesb8SokxFZuIam4Ij7Y
	 2Trq4zbKXgBPaA1GUb46EG0g9/yG1SVKPvAjwdSY22v5npY7CvQhK0xjBVLZIw9Rak
	 5O/N7jPe3Dvnzjr9HGgJ6VNRTlYfSMhSgAMTGT1sAZQ/I80sRFK6wcDyIumAg5QUPk
	 E+Asd6vxOjWCQr81sReia7S9BYveVd7+RECgiT4OWQ1KugTCiWg/SIFmTsAFJKXZtn
	 bgk63VniyvEuA==
Date: Tue, 31 Dec 2024 15:41:43 -0800
Subject: [PATCH 11/16] xfs: report shutdown events through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754933.2704911.15047923403601596285.stgit@frogsfrogsfrogs>
In-Reply-To: <173568754700.2704911.10879727466774074251.stgit@frogsfrogsfrogs>
References: <173568754700.2704911.10879727466774074251.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_healthmon.schema.json |   62 +++++++++++++++++++++++++
 fs/xfs/xfs_healthmon.c                  |   77 ++++++++++++++++++++++++++++++-
 fs/xfs/xfs_healthmon.h                  |    3 +
 fs/xfs/xfs_trace.h                      |   25 ++++++++++
 4 files changed, 165 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_healthmon.schema.json b/fs/xfs/libxfs/xfs_healthmon.schema.json
index 154ea0228a3615..a8bc75b0b8c4f9 100644
--- a/fs/xfs/libxfs/xfs_healthmon.schema.json
+++ b/fs/xfs/libxfs/xfs_healthmon.schema.json
@@ -30,6 +30,9 @@
 		},
 		{
 			"$ref": "#/$events/inode_metadata"
+		},
+		{
+			"$ref": "#/$events/shutdown"
 		}
 	],
 
@@ -205,6 +208,31 @@
 		}
 	},
 
+	"$comment": "Shutdown event data are defined here.",
+	"$shutdown": {
+		"reason": {
+			"description": [
+				"Reason for a filesystem to shut down.",
+				"Options include:",
+				"",
+				" * corrupt_incore: in-memory corruption",
+				" * corrupt_ondisk: on-disk corruption",
+				" * device_removed: device removed",
+				" * force_umount:   userspace asked for it",
+				" * log_ioerr:      log write IO error",
+				" * meta_ioerr:     metadata writeback IO error"
+			],
+			"enum": [
+				"corrupt_incore",
+				"corrupt_ondisk",
+				"device_removed",
+				"force_umount",
+				"log_ioerr",
+				"meta_ioerr"
+			]
+		}
+	},
+
 	"$comment": "Event types are defined here.",
 	"$events": {
 		"lost": {
@@ -386,6 +414,40 @@
 				"generation",
 				"structures"
 			]
+		},
+		"shutdown": {
+			"title": "Abnormal Shutdown Event",
+			"description": [
+				"The filesystem went offline due to",
+				"unrecoverable errors."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"const": "shutdown"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "mount"
+				},
+				"reasons": {
+					"type": "array",
+					"items": {
+						"$ref": "#/$shutdown/reason"
+					},
+					"minItems": 1
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"reasons"
+			]
 		}
 	}
 }
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 9d34a826726e3e..c7df6dad5612f8 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -20,6 +20,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_health.h"
 #include "xfs_healthmon.h"
+#include "xfs_fsops.h"
 
 #include <linux/anon_inodes.h>
 #include <linux/eventpoll.h>
@@ -67,6 +68,7 @@ struct xfs_healthmon {
 	struct xfs_healthmon_event	*last_event;
 
 	/* live update hooks */
+	struct xfs_shutdown_hook	shook;
 	struct xfs_health_hook		hhook;
 
 	/* filesystem mount, or NULL if we've unmounted */
@@ -384,6 +386,43 @@ xfs_healthmon_metadata_hook(
 	goto out_unlock;
 }
 
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
+	event = xfs_healthmon_alloc(hm, XFS_HEALTHMON_SHUTDOWN,
+			XFS_HEALTHMON_MOUNT);
+	if (!event)
+		goto out_unlock;
+
+	event->flags = action;
+	error = xfs_healthmon_push(hm, event);
+	if (error)
+		kfree(event);
+
+out_unlock:
+	mutex_unlock(&hm->lock);
+	return NOTIFY_DONE;
+}
+
 /* Render the health update type as a string. */
 STATIC const char *
 xfs_healthmon_typestring(
@@ -391,6 +430,7 @@ xfs_healthmon_typestring(
 {
 	static const char *type_strings[] = {
 		[XFS_HEALTHMON_LOST]		= "lost",
+		[XFS_HEALTHMON_SHUTDOWN]	= "shutdown",
 		[XFS_HEALTHMON_UNMOUNT]		= "unmount",
 		[XFS_HEALTHMON_SICK]		= "sick",
 		[XFS_HEALTHMON_CORRUPT]		= "corrupt",
@@ -606,6 +646,25 @@ xfs_healthmon_format_inode(
 			event->gen);
 }
 
+/* Render shutdown mask as a string set */
+static int
+xfs_healthmon_format_shutdown(
+	struct seq_buf			*outbuf,
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
+	return xfs_healthmon_format_mask(outbuf, "reasons", mask_strings,
+			event->flags);
+}
+
 static inline void
 xfs_healthmon_reset_outbuf(
 	struct xfs_healthmon		*hm)
@@ -645,6 +704,9 @@ xfs_healthmon_format(
 		goto overrun;
 
 	switch (event->type) {
+	case XFS_HEALTHMON_SHUTDOWN:
+		ret = xfs_healthmon_format_shutdown(outbuf, event);
+		break;
 	case XFS_HEALTHMON_LOST:
 		/* empty */
 		break;
@@ -928,6 +990,7 @@ xfs_healthmon_detach_hooks(
 	 * through the health monitoring subsystem from xfs_fs_put_super, so
 	 * it is now time to detach the hooks.
 	 */
+	xfs_shutdown_hook_del(hm->mp, &hm->shook);
 	xfs_health_hook_del(hm->mp, &hm->hhook);
 	return;
 
@@ -948,6 +1011,7 @@ xfs_healthmon_release(
 	wake_up_all(&hm->wait);
 
 	iterate_supers_type(hm->fstyp, xfs_healthmon_detach_hooks, hm);
+	xfs_shutdown_hook_disable();
 	xfs_health_hook_disable();
 
 	mutex_destroy(&hm->lock);
@@ -1027,6 +1091,7 @@ xfs_ioc_health_monitor(
 
 	/* Enable hooks to receive events, generally. */
 	xfs_health_hook_enable();
+	xfs_shutdown_hook_enable();
 
 	/* Attach specific event hooks to this monitor. */
 	xfs_health_hook_setup(&hm->hhook, xfs_healthmon_metadata_hook);
@@ -1034,11 +1099,16 @@ xfs_ioc_health_monitor(
 	if (ret)
 		goto out_hooks;
 
+	xfs_shutdown_hook_setup(&hm->shook, xfs_healthmon_shutdown_hook);
+	ret = xfs_shutdown_hook_add(mp, &hm->shook);
+	if (ret)
+		goto out_healthhook;
+
 	/* Set up VFS file and file descriptor. */
 	name = kasprintf(GFP_KERNEL, "XFS (%s): healthmon", mp->m_super->s_id);
 	if (!name) {
 		ret = -ENOMEM;
-		goto out_healthhook;
+		goto out_shutdownhook;
 	}
 
 	fd = anon_inode_getfd(name, &xfs_healthmon_fops, hm,
@@ -1046,17 +1116,20 @@ xfs_ioc_health_monitor(
 	kvfree(name);
 	if (fd < 0) {
 		ret = fd;
-		goto out_healthhook;
+		goto out_shutdownhook;
 	}
 
 	trace_xfs_healthmon_create(mp, hmo.flags, hmo.format);
 
 	return fd;
 
+out_shutdownhook:
+	xfs_shutdown_hook_del(mp, &hm->shook);
 out_healthhook:
 	xfs_health_hook_del(mp, &hm->hhook);
 out_hooks:
 	xfs_health_hook_disable();
+	xfs_shutdown_hook_disable();
 	mutex_destroy(&hm->lock);
 	xfs_healthmon_free_events(hm);
 	kfree(hm);
diff --git a/fs/xfs/xfs_healthmon.h b/fs/xfs/xfs_healthmon.h
index 3ece61165837b2..a7b2eaf3dd64e1 100644
--- a/fs/xfs/xfs_healthmon.h
+++ b/fs/xfs/xfs_healthmon.h
@@ -9,6 +9,9 @@
 enum xfs_healthmon_type {
 	XFS_HEALTHMON_LOST,	/* message lost */
 
+	/* filesystem shutdown */
+	XFS_HEALTHMON_SHUTDOWN,
+
 	/* metadata health events */
 	XFS_HEALTHMON_SICK,	/* runtime corruption observed */
 	XFS_HEALTHMON_CORRUPT,	/* fsck reported corruption */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4a68d2ec8d0a34..404b857db39d0d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -6173,8 +6173,32 @@ DEFINE_HEALTHMON_EVENT(xfs_healthmon_read_finish);
 DEFINE_HEALTHMON_EVENT(xfs_healthmon_release);
 DEFINE_HEALTHMON_EVENT(xfs_healthmon_unmount);
 
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
 #define XFS_HEALTHMON_TYPE_STRINGS \
 	{ XFS_HEALTHMON_LOST,		"lost" }, \
+	{ XFS_HEALTHMON_SHUTDOWN,	"shutdown" }, \
 	{ XFS_HEALTHMON_UNMOUNT,	"unmount" }, \
 	{ XFS_HEALTHMON_SICK,		"sick" }, \
 	{ XFS_HEALTHMON_CORRUPT,	"corrupt" }, \
@@ -6188,6 +6212,7 @@ DEFINE_HEALTHMON_EVENT(xfs_healthmon_unmount);
 	{ XFS_HEALTHMON_RTGROUP,	"rtgroup" }
 
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_LOST);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_SHUTDOWN);
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_UNMOUNT);
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_SICK);
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_CORRUPT);

