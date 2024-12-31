Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2734A13FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688535; cv=none; b=LzlyMpbcbta08v47aGVpnVOKLnKF+7CW5Ic3BBxHDz6Q+Zy/fKAkfwbW2rgFaz8MQQiTE0p2EmY82wP75b1Bh0NaeJHuDzB+ZnjcJanlxtBqiIZIj7Pk8sZalKUEahdglaUC3XCIVjLOQTPS1y10rK51JtPrBzcHeZKdb/4+msg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688535; c=relaxed/simple;
	bh=nM15EzjsAKd5kXUDRM6rnZA9kF/ukzVhVsX08LGnn8s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PkwEVogie97/wnrBas2hIJUYIunRK7WP/I3tdOJFMjalJGqWWbojDj40Ed7jkOeK8o3xtFju4PFkQddj8viZyJFtnlrhQh2czCmQCcDY3dg07Gy91Srxpj7YS7ph/4rhEUjFdQT8YaEaq0n91xavkMiY73yJAHgdPfJD7Re131E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PFZgAfYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PFZgAfYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1490C4CED2;
	Tue, 31 Dec 2024 23:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688535;
	bh=nM15EzjsAKd5kXUDRM6rnZA9kF/ukzVhVsX08LGnn8s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PFZgAfYGd/ottiePp4a5lFvNVXttRv9/0n6UyBvbAFaAiAR7zdD1tpGxfOyBM/92H
	 PB003FdlL6Um7D1rng8ySY7u8/vrAImNykj9bnhXWVRHab5soKRjb/5zrEt8S7Vunm
	 oJYGvUVeJdmyDCB4kJejRpvtpuhfCrSn+b+Y4xTdFlNDF/LG5m536/a9z9JqORGMRe
	 wmXJNeya5Wnjys+6kwe4JIMNkVhc4H61JnkrLV3udlCWI4t25BGhsMhR9FoIDsCSIz
	 d6PRZT6Uv83lzcK6pkNC2FKCNLfLrXTAt79pkGXLOsfmzGd9/5/CpazVbOXPRN/d9F
	 xypUX4ryHCvYQ==
Date: Tue, 31 Dec 2024 15:42:14 -0800
Subject: [PATCH 13/16] xfs: report file io errors through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754968.2704911.4424040488364281164.stgit@frogsfrogsfrogs>
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

Set up a file io error event hook so that we can send events about read
errors, writeback errors, and directio errors to userspace.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_healthmon.schema.json |   77 ++++++++++++++++++++
 fs/xfs/xfs_healthmon.c                  |  120 ++++++++++++++++++++++++++++++-
 fs/xfs/xfs_healthmon.h                  |   16 ++++
 fs/xfs/xfs_trace.c                      |    1 
 fs/xfs/xfs_trace.h                      |   50 +++++++++++++
 5 files changed, 262 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_healthmon.schema.json b/fs/xfs/libxfs/xfs_healthmon.schema.json
index 006f4145faa9f5..9c1070a629997c 100644
--- a/fs/xfs/libxfs/xfs_healthmon.schema.json
+++ b/fs/xfs/libxfs/xfs_healthmon.schema.json
@@ -36,6 +36,9 @@
 		},
 		{
 			"$ref": "#/$events/media_error"
+		},
+		{
+			"$ref": "#/$events/file_ioerror"
 		}
 	],
 
@@ -67,6 +70,16 @@
 			"description": "Inode generation number",
 			"type": "integer"
 		},
+		"off_t": {
+			"description": "File position, in bytes",
+			"type": "integer",
+			"minimum": 0
+		},
+		"size_t": {
+			"description": "File operation length, in bytes",
+			"type": "integer",
+			"minimum": 1
+		},
 		"storage_devs": {
 			"description": "Storage devices in a filesystem",
 			"_comment": [
@@ -261,6 +274,26 @@
 		}
 	},
 
+	"$comment": "File IO event data are defined here.",
+	"$fileio": {
+		"types": {
+			"description": [
+				"File I/O operations.  One of:",
+				"",
+				" * readahead: reads into the page cache.",
+				" * writeback: writeback of dirty page cache.",
+				" * dioread:   O_DIRECT reads.",
+				" * diowrite:  O_DIRECT writes."
+			],
+			"enum": [
+				"readahead",
+				"writeback",
+				"dioread",
+				"diowrite"
+			]
+		}
+	},
+
 	"$comment": "Event types are defined here.",
 	"$events": {
 		"lost": {
@@ -513,6 +546,50 @@
 				"daddr",
 				"bbcount"
 			]
+		},
+		"file_ioerror": {
+			"title": "File I/O error",
+			"description": [
+				"A read or a write to a file failed.  The",
+				"inode, generation, pos, and len fields",
+				"describe the range of the file that is",
+				"affected."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"$ref": "#/$fileio/types"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "filerange"
+				},
+				"inumber": {
+					"$ref": "#/$defs/xfs_ino_t"
+				},
+				"generation": {
+					"$ref": "#/$defs/i_generation"
+				},
+				"pos": {
+					"$ref": "#/$defs/off_t"
+				},
+				"len": {
+					"$ref": "#/$defs/size_t"
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"inumber",
+				"generation",
+				"pos",
+				"len"
+			]
 		}
 	}
 }
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index c828ea7442e932..9320f12b60ade9 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -22,6 +22,7 @@
 #include "xfs_healthmon.h"
 #include "xfs_fsops.h"
 #include "xfs_notify_failure.h"
+#include "xfs_file.h"
 
 #include <linux/anon_inodes.h>
 #include <linux/eventpoll.h>
@@ -72,6 +73,7 @@ struct xfs_healthmon {
 	struct xfs_shutdown_hook	shook;
 	struct xfs_health_hook		hhook;
 	struct xfs_media_error_hook	mhook;
+	struct xfs_file_ioerror_hook	fhook;
 
 	/* filesystem mount, or NULL if we've unmounted */
 	struct xfs_mount		*mp;
@@ -478,6 +480,73 @@ xfs_healthmon_media_error_hook(
 }
 #endif
 
+/* Add a file io error event to the reporting queue. */
+STATIC int
+xfs_healthmon_file_ioerror_hook(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_healthmon		*hm;
+	struct xfs_healthmon_event	*event;
+	struct xfs_file_ioerror_params	*p = data;
+	enum xfs_healthmon_type		type = 0;
+	int				error;
+
+	hm = container_of(nb, struct xfs_healthmon, fhook.ioerror_hook.nb);
+
+	switch (action) {
+	case XFS_FILE_IOERROR_BUFFERED_READ:
+	case XFS_FILE_IOERROR_BUFFERED_WRITE:
+	case XFS_FILE_IOERROR_DIRECT_READ:
+	case XFS_FILE_IOERROR_DIRECT_WRITE:
+		break;
+	default:
+		ASSERT(0);
+		return NOTIFY_DONE;
+	}
+
+	mutex_lock(&hm->lock);
+
+	trace_xfs_healthmon_file_ioerror_hook(hm->mp, action, p, hm->events,
+			hm->lost_prev_event);
+
+	error = xfs_healthmon_start_live_update(hm);
+	if (error)
+		goto out_unlock;
+
+	switch (action) {
+	case XFS_FILE_IOERROR_BUFFERED_READ:
+		type = XFS_HEALTHMON_BUFREAD;
+		break;
+	case XFS_FILE_IOERROR_BUFFERED_WRITE:
+		type = XFS_HEALTHMON_BUFWRITE;
+		break;
+	case XFS_FILE_IOERROR_DIRECT_READ:
+		type = XFS_HEALTHMON_DIOREAD;
+		break;
+	case XFS_FILE_IOERROR_DIRECT_WRITE:
+		type = XFS_HEALTHMON_DIOWRITE;
+		break;
+	}
+
+	event = xfs_healthmon_alloc(hm, type, XFS_HEALTHMON_FILERANGE);
+	if (!event)
+		goto out_unlock;
+
+	event->fino = p->ino;
+	event->fgen = p->gen;
+	event->fpos = p->pos;
+	event->flen = p->len;
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
@@ -491,6 +560,10 @@ xfs_healthmon_typestring(
 		[XFS_HEALTHMON_CORRUPT]		= "corrupt",
 		[XFS_HEALTHMON_HEALTHY]		= "healthy",
 		[XFS_HEALTHMON_MEDIA_ERROR]	= "media",
+		[XFS_HEALTHMON_BUFREAD]		= "readahead",
+		[XFS_HEALTHMON_BUFWRITE]	= "writeback",
+		[XFS_HEALTHMON_DIOREAD]		= "dioread",
+		[XFS_HEALTHMON_DIOWRITE]	= "diowrite",
 	};
 
 	if (event->type >= ARRAY_SIZE(type_strings))
@@ -513,6 +586,7 @@ xfs_healthmon_domstring(
 		[XFS_HEALTHMON_DATADEV]		= "datadev",
 		[XFS_HEALTHMON_LOGDEV]		= "logdev",
 		[XFS_HEALTHMON_RTDEV]		= "rtdev",
+		[XFS_HEALTHMON_FILERANGE]	= "filerange",
 	};
 
 	if (event->domain >= ARRAY_SIZE(dom_strings))
@@ -741,6 +815,33 @@ xfs_healthmon_format_media_error(
 			event->bbcount);
 }
 
+/* Render file range events as a string set */
+static int
+xfs_healthmon_format_filerange(
+	struct seq_buf			*outbuf,
+	const struct xfs_healthmon_event *event)
+{
+	ssize_t				ret;
+
+	ret = seq_buf_printf(outbuf, "  \"inumber\":    %llu,\n",
+			event->fino);
+	if (ret < 0)
+		return ret;
+
+	ret = seq_buf_printf(outbuf, "  \"generation\": %u,\n",
+			event->fgen);
+	if (ret < 0)
+		return ret;
+
+	ret = seq_buf_printf(outbuf, "  \"pos\":        %llu,\n",
+			event->fpos);
+	if (ret < 0)
+		return ret;
+
+	return seq_buf_printf(outbuf, "  \"length\":     %llu,\n",
+			event->flen);
+}
+
 static inline void
 xfs_healthmon_reset_outbuf(
 	struct xfs_healthmon		*hm)
@@ -811,6 +912,9 @@ xfs_healthmon_format(
 	case XFS_HEALTHMON_RTDEV:
 		ret = xfs_healthmon_format_media_error(outbuf, event);
 		break;
+	case XFS_HEALTHMON_FILERANGE:
+		ret = xfs_healthmon_format_filerange(outbuf, event);
+		break;
 	}
 	if (ret < 0)
 		goto overrun;
@@ -1071,6 +1175,7 @@ xfs_healthmon_detach_hooks(
 	 * through the health monitoring subsystem from xfs_fs_put_super, so
 	 * it is now time to detach the hooks.
 	 */
+	xfs_file_ioerror_hook_del(hm->mp, &hm->fhook);
 	xfs_media_error_hook_del(hm->mp, &hm->mhook);
 	xfs_shutdown_hook_del(hm->mp, &hm->shook);
 	xfs_health_hook_del(hm->mp, &hm->hhook);
@@ -1093,6 +1198,7 @@ xfs_healthmon_release(
 	wake_up_all(&hm->wait);
 
 	iterate_supers_type(hm->fstyp, xfs_healthmon_detach_hooks, hm);
+	xfs_file_ioerror_hook_disable();
 	xfs_media_error_hook_disable();
 	xfs_shutdown_hook_disable();
 	xfs_health_hook_disable();
@@ -1176,6 +1282,7 @@ xfs_ioc_health_monitor(
 	xfs_health_hook_enable();
 	xfs_shutdown_hook_enable();
 	xfs_media_error_hook_enable();
+	xfs_file_ioerror_hook_enable();
 
 	/* Attach specific event hooks to this monitor. */
 	xfs_health_hook_setup(&hm->hhook, xfs_healthmon_metadata_hook);
@@ -1193,11 +1300,17 @@ xfs_ioc_health_monitor(
 	if (ret)
 		goto out_shutdownhook;
 
+	xfs_file_ioerror_hook_setup(&hm->fhook,
+			xfs_healthmon_file_ioerror_hook);
+	ret = xfs_file_ioerror_hook_add(mp, &hm->fhook);
+	if (ret)
+		goto out_mediahook;
+
 	/* Set up VFS file and file descriptor. */
 	name = kasprintf(GFP_KERNEL, "XFS (%s): healthmon", mp->m_super->s_id);
 	if (!name) {
 		ret = -ENOMEM;
-		goto out_mediahook;
+		goto out_ioerrhook;
 	}
 
 	fd = anon_inode_getfd(name, &xfs_healthmon_fops, hm,
@@ -1205,13 +1318,15 @@ xfs_ioc_health_monitor(
 	kvfree(name);
 	if (fd < 0) {
 		ret = fd;
-		goto out_mediahook;
+		goto out_ioerrhook;
 	}
 
 	trace_xfs_healthmon_create(mp, hmo.flags, hmo.format);
 
 	return fd;
 
+out_ioerrhook:
+	xfs_file_ioerror_hook_del(mp, &hm->fhook);
 out_mediahook:
 	xfs_media_error_hook_del(mp, &hm->mhook);
 out_shutdownhook:
@@ -1219,6 +1334,7 @@ xfs_ioc_health_monitor(
 out_healthhook:
 	xfs_health_hook_del(mp, &hm->hhook);
 out_hooks:
+	xfs_file_ioerror_hook_disable();
 	xfs_media_error_hook_disable();
 	xfs_health_hook_disable();
 	xfs_shutdown_hook_disable();
diff --git a/fs/xfs/xfs_healthmon.h b/fs/xfs/xfs_healthmon.h
index 23ce320f4b086b..748173eed79660 100644
--- a/fs/xfs/xfs_healthmon.h
+++ b/fs/xfs/xfs_healthmon.h
@@ -20,6 +20,12 @@ enum xfs_healthmon_type {
 
 	/* media errors */
 	XFS_HEALTHMON_MEDIA_ERROR,
+
+	/* file range events */
+	XFS_HEALTHMON_BUFREAD,
+	XFS_HEALTHMON_BUFWRITE,
+	XFS_HEALTHMON_DIOREAD,
+	XFS_HEALTHMON_DIOWRITE,
 };
 
 enum xfs_healthmon_domain {
@@ -35,6 +41,9 @@ enum xfs_healthmon_domain {
 	XFS_HEALTHMON_DATADEV,
 	XFS_HEALTHMON_RTDEV,
 	XFS_HEALTHMON_LOGDEV,
+
+	/* file range events */
+	XFS_HEALTHMON_FILERANGE,
 };
 
 struct xfs_healthmon_event {
@@ -73,6 +82,13 @@ struct xfs_healthmon_event {
 			xfs_daddr_t	daddr;
 			uint64_t	bbcount;
 		};
+		/* file range events */
+		struct {
+			xfs_ino_t	fino;
+			loff_t		fpos;
+			uint64_t	flen;
+			uint32_t	fgen;
+		};
 	};
 };
 
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 23741ff36a2e14..d8e5d607b0dc6a 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -55,6 +55,7 @@
 #include "xfs_health.h"
 #include "xfs_healthmon.h"
 #include "xfs_notify_failure.h"
+#include "xfs_file.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 47293206400d6e..aba32f5ccc1a3b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -109,6 +109,7 @@ struct xfs_rtgroup;
 struct xfs_healthmon_event;
 struct xfs_health_update_params;
 struct xfs_media_error_params;
+struct xfs_file_ioerror_params;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -6396,6 +6397,55 @@ TRACE_EVENT(xfs_healthmon_media_error_hook,
 		  __entry->lost_prev)
 );
 #endif
+
+#define XFS_FILE_IOERROR_STRINGS \
+	{ XFS_FILE_IOERROR_BUFFERED_READ,	"readahead" }, \
+	{ XFS_FILE_IOERROR_BUFFERED_WRITE,	"writeback" }, \
+	{ XFS_FILE_IOERROR_DIRECT_READ,		"dioread" }, \
+	{ XFS_FILE_IOERROR_DIRECT_WRITE,	"diowrite" }
+
+TRACE_DEFINE_ENUM(XFS_FILE_IOERROR_BUFFERED_READ);
+TRACE_DEFINE_ENUM(XFS_FILE_IOERROR_BUFFERED_WRITE);
+TRACE_DEFINE_ENUM(XFS_FILE_IOERROR_DIRECT_READ);
+TRACE_DEFINE_ENUM(XFS_FILE_IOERROR_DIRECT_WRITE);
+
+TRACE_EVENT(xfs_healthmon_file_ioerror_hook,
+	TP_PROTO(const struct xfs_mount *mp,
+		 unsigned long action,
+		 const struct xfs_file_ioerror_params *p,
+		 unsigned int events, bool lost_prev),
+	TP_ARGS(mp, action, p, events, lost_prev),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, error_dev)
+		__field(unsigned long, action)
+		__field(unsigned long long, ino)
+		__field(unsigned int, gen)
+		__field(long long, pos)
+		__field(unsigned long long, len)
+		__field(unsigned int, events)
+		__field(bool, lost_prev)
+	),
+	TP_fast_assign(
+		__entry->dev = mp ? mp->m_super->s_dev : 0;
+		__entry->action = action;
+		__entry->ino = p->ino;
+		__entry->gen = p->gen;
+		__entry->pos = p->pos;
+		__entry->len = p->len;
+		__entry->events = events;
+		__entry->lost_prev = lost_prev;
+	),
+	TP_printk("dev %d:%d ino 0x%llx gen 0x%x op %s pos 0x%llx bytecount 0x%llx events %u lost_prev? %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->gen,
+		  __print_symbolic(__entry->action, XFS_FILE_IOERROR_STRINGS),
+		  __entry->pos,
+		  __entry->len,
+		  __entry->events,
+		  __entry->lost_prev)
+);
 #endif /* CONFIG_XFS_HEALTH_MONITOR */
 
 #endif /* _TRACE_XFS_H */

