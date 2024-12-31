Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBAC1B0418
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688519; cv=none; b=hFECdn/V1rZ45Ri5kYFuw+B9a4hWRdYDfuBfwL/8NfV0t+pzpZRp7NW2Gcz0X3P/yVelQ8uJTeL3791D7CGjOlJ0l+utzUOmlyjSdzBWB12DeCvdz4/8T4CDbZ7NjJbOeXmA9L2eMmPvrX0TunENRhThdbPaWKLe1nEN/jkb1b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688519; c=relaxed/simple;
	bh=EUsI5fZIh3c6v5EqOCiKBObcmuzZco/lZo2b+LSNX4A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kN7GXGOHRshGGuWGHfLY//Mim7esd1wzXzVn34+akX1ojRhK6vZmsSwH0/0gbe+hol2j9E6sbUiIb2cGnRwt4UaQxNetaieKSRrosRjPPSZTWCb2i5ixqFZ64W/qhzRrRuk8Nxb2FIhWL5AUZOUGxCNBco5/LukXPGVaP6GJV0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TUR3ONvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TUR3ONvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C91CC4CED2;
	Tue, 31 Dec 2024 23:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688519;
	bh=EUsI5fZIh3c6v5EqOCiKBObcmuzZco/lZo2b+LSNX4A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TUR3ONvgT/Xi9QMOjzqRsGH4h8pXSZIl/sSq6Wqp5fhpSBQs++r3KzxS//K1SFC3b
	 OkeZZ0da8mItEKhcZ7KFYHi/NfqpihdXELOlnYmOTlwdoqhICOB2L+15qmf8LymCJU
	 /z1i7kWjn52u7HBmcCKg4PaE7VHaXVkdLbR9qvbqWC1TlmMQEMLSA+nceYn4jo2aVH
	 dkjH7urkLGrM+KK6FXj+g+ROuH4Xfs5CAYOJ2ioCiIOcuY5TsETVSdHAt8MzrNxeWJ
	 kSCHHPaWfUxvHHNxLNPxX+6hk20d6fpd/56HAPck43K31MRMW6HO2og3xlPAVW4PDN
	 EwxFW4yPnGIGw==
Date: Tue, 31 Dec 2024 15:41:58 -0800
Subject: [PATCH 12/16] xfs: report media errors through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754951.2704911.7356371794064990039.stgit@frogsfrogsfrogs>
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

Now that we have hooks to report media errors, connect this to the
health monitor as well.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_healthmon.schema.json |   65 +++++++++++++++++++++
 fs/xfs/xfs_healthmon.c                  |   96 ++++++++++++++++++++++++++++++-
 fs/xfs/xfs_healthmon.h                  |   13 ++++
 fs/xfs/xfs_trace.c                      |    1 
 fs/xfs/xfs_trace.h                      |   51 ++++++++++++++++
 5 files changed, 224 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_healthmon.schema.json b/fs/xfs/libxfs/xfs_healthmon.schema.json
index a8bc75b0b8c4f9..006f4145faa9f5 100644
--- a/fs/xfs/libxfs/xfs_healthmon.schema.json
+++ b/fs/xfs/libxfs/xfs_healthmon.schema.json
@@ -33,6 +33,9 @@
 		},
 		{
 			"$ref": "#/$events/shutdown"
+		},
+		{
+			"$ref": "#/$events/media_error"
 		}
 	],
 
@@ -63,6 +66,31 @@
 		"i_generation": {
 			"description": "Inode generation number",
 			"type": "integer"
+		},
+		"storage_devs": {
+			"description": "Storage devices in a filesystem",
+			"_comment": [
+				"One of:",
+				"",
+				" * datadev: filesystem device",
+				" * logdev:  external log device",
+				" * rtdev:   realtime volume"
+			],
+			"enum": [
+				"datadev",
+				"logdev",
+				"rtdev"
+			]
+		},
+		"xfs_daddr_t": {
+			"description": "Storage device address, in units of 512-byte blocks",
+			"type": "integer",
+			"minimum": 0
+		},
+		"bbcount": {
+			"description": "Storage space length, in units of 512-byte blocks",
+			"type": "integer",
+			"minimum": 1
 		}
 	},
 
@@ -448,6 +476,43 @@
 				"domain",
 				"reasons"
 			]
+		},
+		"media_error": {
+			"title": "Media Error",
+			"description": [
+				"A storage device reported a media error.",
+				"The domain element tells us which storage",
+				"device reported the media failure.  The",
+				"daddr and bbcount elements tell us where",
+				"inside that device the failure was observed."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"const": "media"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"$ref": "#/$defs/storage_devs"
+				},
+				"daddr": {
+					"$ref": "#/$defs/xfs_daddr_t"
+				},
+				"bbcount": {
+					"$ref": "#/$defs/bbcount"
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"daddr",
+				"bbcount"
+			]
 		}
 	}
 }
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index c7df6dad5612f8..c828ea7442e932 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -21,6 +21,7 @@
 #include "xfs_health.h"
 #include "xfs_healthmon.h"
 #include "xfs_fsops.h"
+#include "xfs_notify_failure.h"
 
 #include <linux/anon_inodes.h>
 #include <linux/eventpoll.h>
@@ -70,6 +71,7 @@ struct xfs_healthmon {
 	/* live update hooks */
 	struct xfs_shutdown_hook	shook;
 	struct xfs_health_hook		hhook;
+	struct xfs_media_error_hook	mhook;
 
 	/* filesystem mount, or NULL if we've unmounted */
 	struct xfs_mount		*mp;
@@ -423,6 +425,59 @@ xfs_healthmon_shutdown_hook(
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
+	enum xfs_healthmon_domain	domain = 0; /* shut up gcc */
+	int				error;
+
+	hm = container_of(nb, struct xfs_healthmon, mhook.error_hook.nb);
+
+	mutex_lock(&hm->lock);
+
+	trace_xfs_healthmon_media_error_hook(p, hm->events,
+			hm->lost_prev_event);
+
+	error = xfs_healthmon_start_live_update(hm);
+	if (error)
+		goto out_unlock;
+
+	switch (p->fdev) {
+	case XFS_FAILED_LOGDEV:
+		domain = XFS_HEALTHMON_LOGDEV;
+		break;
+	case XFS_FAILED_RTDEV:
+		domain = XFS_HEALTHMON_RTDEV;
+		break;
+	case XFS_FAILED_DATADEV:
+		domain = XFS_HEALTHMON_DATADEV;
+		break;
+	}
+
+	event = xfs_healthmon_alloc(hm, XFS_HEALTHMON_MEDIA_ERROR, domain);
+	if (!event)
+		goto out_unlock;
+
+	event->daddr = p->daddr;
+	event->bbcount = p->bbcount;
+	error = xfs_healthmon_push(hm, event);
+	if (error)
+		kfree(event);
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
@@ -435,6 +490,7 @@ xfs_healthmon_typestring(
 		[XFS_HEALTHMON_SICK]		= "sick",
 		[XFS_HEALTHMON_CORRUPT]		= "corrupt",
 		[XFS_HEALTHMON_HEALTHY]		= "healthy",
+		[XFS_HEALTHMON_MEDIA_ERROR]	= "media",
 	};
 
 	if (event->type >= ARRAY_SIZE(type_strings))
@@ -454,6 +510,9 @@ xfs_healthmon_domstring(
 		[XFS_HEALTHMON_AG]		= "perag",
 		[XFS_HEALTHMON_INODE]		= "inode",
 		[XFS_HEALTHMON_RTGROUP]		= "rtgroup",
+		[XFS_HEALTHMON_DATADEV]		= "datadev",
+		[XFS_HEALTHMON_LOGDEV]		= "logdev",
+		[XFS_HEALTHMON_RTDEV]		= "rtdev",
 	};
 
 	if (event->domain >= ARRAY_SIZE(dom_strings))
@@ -665,6 +724,23 @@ xfs_healthmon_format_shutdown(
 			event->flags);
 }
 
+/* Render media error as a string set */
+static int
+xfs_healthmon_format_media_error(
+	struct seq_buf			*outbuf,
+	const struct xfs_healthmon_event *event)
+{
+	ssize_t				ret;
+
+	ret = seq_buf_printf(outbuf, "  \"daddr\":      %llu,\n",
+			event->daddr);
+	if (ret < 0)
+		return ret;
+
+	return seq_buf_printf(outbuf, "  \"bbcount\":    %llu,\n",
+			event->bbcount);
+}
+
 static inline void
 xfs_healthmon_reset_outbuf(
 	struct xfs_healthmon		*hm)
@@ -730,6 +806,11 @@ xfs_healthmon_format(
 	case XFS_HEALTHMON_INODE:
 		ret = xfs_healthmon_format_inode(outbuf, event);
 		break;
+	case XFS_HEALTHMON_DATADEV:
+	case XFS_HEALTHMON_LOGDEV:
+	case XFS_HEALTHMON_RTDEV:
+		ret = xfs_healthmon_format_media_error(outbuf, event);
+		break;
 	}
 	if (ret < 0)
 		goto overrun;
@@ -990,6 +1071,7 @@ xfs_healthmon_detach_hooks(
 	 * through the health monitoring subsystem from xfs_fs_put_super, so
 	 * it is now time to detach the hooks.
 	 */
+	xfs_media_error_hook_del(hm->mp, &hm->mhook);
 	xfs_shutdown_hook_del(hm->mp, &hm->shook);
 	xfs_health_hook_del(hm->mp, &hm->hhook);
 	return;
@@ -1011,6 +1093,7 @@ xfs_healthmon_release(
 	wake_up_all(&hm->wait);
 
 	iterate_supers_type(hm->fstyp, xfs_healthmon_detach_hooks, hm);
+	xfs_media_error_hook_disable();
 	xfs_shutdown_hook_disable();
 	xfs_health_hook_disable();
 
@@ -1092,6 +1175,7 @@ xfs_ioc_health_monitor(
 	/* Enable hooks to receive events, generally. */
 	xfs_health_hook_enable();
 	xfs_shutdown_hook_enable();
+	xfs_media_error_hook_enable();
 
 	/* Attach specific event hooks to this monitor. */
 	xfs_health_hook_setup(&hm->hhook, xfs_healthmon_metadata_hook);
@@ -1104,11 +1188,16 @@ xfs_ioc_health_monitor(
 	if (ret)
 		goto out_healthhook;
 
+	xfs_media_error_hook_setup(&hm->mhook, xfs_healthmon_media_error_hook);
+	ret = xfs_media_error_hook_add(mp, &hm->mhook);
+	if (ret)
+		goto out_shutdownhook;
+
 	/* Set up VFS file and file descriptor. */
 	name = kasprintf(GFP_KERNEL, "XFS (%s): healthmon", mp->m_super->s_id);
 	if (!name) {
 		ret = -ENOMEM;
-		goto out_shutdownhook;
+		goto out_mediahook;
 	}
 
 	fd = anon_inode_getfd(name, &xfs_healthmon_fops, hm,
@@ -1116,18 +1205,21 @@ xfs_ioc_health_monitor(
 	kvfree(name);
 	if (fd < 0) {
 		ret = fd;
-		goto out_shutdownhook;
+		goto out_mediahook;
 	}
 
 	trace_xfs_healthmon_create(mp, hmo.flags, hmo.format);
 
 	return fd;
 
+out_mediahook:
+	xfs_media_error_hook_del(mp, &hm->mhook);
 out_shutdownhook:
 	xfs_shutdown_hook_del(mp, &hm->shook);
 out_healthhook:
 	xfs_health_hook_del(mp, &hm->hhook);
 out_hooks:
+	xfs_media_error_hook_disable();
 	xfs_health_hook_disable();
 	xfs_shutdown_hook_disable();
 	mutex_destroy(&hm->lock);
diff --git a/fs/xfs/xfs_healthmon.h b/fs/xfs/xfs_healthmon.h
index a7b2eaf3dd64e1..23ce320f4b086b 100644
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
@@ -27,6 +30,11 @@ enum xfs_healthmon_domain {
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
@@ -60,6 +68,11 @@ struct xfs_healthmon_event {
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
 
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 41a2ac85dc5fdf..23741ff36a2e14 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -54,6 +54,7 @@
 #include "xfs_fsrefs.h"
 #include "xfs_health.h"
 #include "xfs_healthmon.h"
+#include "xfs_notify_failure.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 404b857db39d0d..47293206400d6e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -108,6 +108,7 @@ struct xfs_fsrefs_irec;
 struct xfs_rtgroup;
 struct xfs_healthmon_event;
 struct xfs_health_update_params;
+struct xfs_media_error_params;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -6345,6 +6346,56 @@ TRACE_EVENT(xfs_healthmon_metadata_hook,
 		  __entry->events,
 		  __entry->lost_prev)
 );
+
+#if defined(CONFIG_XFS_LIVE_HOOKS) && defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_FS_DAX)
+TRACE_EVENT(xfs_healthmon_media_error_hook,
+	TP_PROTO(const struct xfs_media_error_params *p,
+		 unsigned int events, bool lost_prev),
+	TP_ARGS(p, events, lost_prev),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, error_dev)
+		__field(uint64_t, daddr)
+		__field(uint64_t, bbcount)
+		__field(int, pre_remove)
+		__field(unsigned int, events)
+		__field(bool, lost_prev)
+	),
+	TP_fast_assign(
+		struct xfs_mount	*mp = p->mp;
+		struct xfs_buftarg	*btp = NULL;
+
+		switch (p->fdev) {
+		case XFS_FAILED_DATADEV:
+			btp = mp->m_ddev_targp;
+			break;
+		case XFS_FAILED_LOGDEV:
+			btp = mp->m_logdev_targp;
+			break;
+		case XFS_FAILED_RTDEV:
+			btp = mp->m_rtdev_targp;
+			break;
+		}
+
+		__entry->dev = mp->m_super->s_dev;
+		if (btp)
+			__entry->error_dev = btp->bt_dev;
+		__entry->daddr = p->daddr;
+		__entry->bbcount = p->bbcount;
+		__entry->pre_remove = p->pre_remove;
+		__entry->events = events;
+		__entry->lost_prev = lost_prev;
+	),
+	TP_printk("dev %d:%d error_dev %d:%d daddr 0x%llx bbcount 0x%llx pre_remove? %d events %u lost_prev? %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->error_dev), MINOR(__entry->error_dev),
+		  __entry->daddr,
+		  __entry->bbcount,
+		  __entry->pre_remove,
+		  __entry->events,
+		  __entry->lost_prev)
+);
+#endif
 #endif /* CONFIG_XFS_HEALTH_MONITOR */
 
 #endif /* _TRACE_XFS_H */

