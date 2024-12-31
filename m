Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B7E13FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688488; cv=none; b=EJwkxW62vWOKsrHHLNaoyH/5vc4DqeAuc7K4+l6Yq6Vb7TwuN4/+xJpt8DiNjKauNYfDNCdNPMR3R0uAftvIO3diCzt4G7mzNv2JMH/iVeLLqtMyeRwDWdSb3izNH7HndV1r4J7mz57w0KAWHN5fVcsQsCW4yTOvkeDWL9IrszM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688488; c=relaxed/simple;
	bh=jWRoo4YJPb9GQjPYb2d7eogKn+t7azdTmdKq4uwoc4o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MiiA/tBMLQrleh7u6AKl4TlaKMmzK0ob8+yh8XyEICefKyMrVWG8s2YbcXt7j52H33ILABS0RguEEio2CS7eKiA1vgFhXhaZ+pZ6KtA1z4gRD/c29KEy49OfbZz2KJFrt6wwt+tybA/rJ6r/IkyOJ0KYuGDoeTY+M6tibExtBaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q/3CCcVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q/3CCcVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13234C4CED2;
	Tue, 31 Dec 2024 23:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688488;
	bh=jWRoo4YJPb9GQjPYb2d7eogKn+t7azdTmdKq4uwoc4o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q/3CCcVm8UolLFq4ysSwHSPGVScoQ3eYzQSvOvaztkXO2jKZdQXtOqT0Ys+X3mSmH
	 N7eUn6vTaA+ORsIal4hil5+uHJhIFfDpcMJagH49IsqMaBSVMohVmRBOsLDbEmqflf
	 pzabBo64rRm1G4P+CUpTr4bbia1qddaEKesklEhHFwW/2QObEqZ1s7yOuf/fzOHUOb
	 4UMxAowTUzYm39fjeVvjH1FvlXiER6GtB2oMrJw4z+pUs6m0Hw2rpefaSKd7/P/N6U
	 1Seie1qLW5QubTc1ftp0xH+2/SrGhsfXwt+QkoskpuHGggZ7tXr5II+RoDptcTf/Ik
	 MIOMOaxU9no9A==
Date: Tue, 31 Dec 2024 15:41:27 -0800
Subject: [PATCH 10/16] xfs: report metadata health events through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754916.2704911.15467242100626942628.stgit@frogsfrogsfrogs>
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

Set up a metadata health event hook so that we can send events to
userspace as we collect information.  The unmount hook severs the weak
reference between the health monitor and the filesystem it's monitoring;
when this happens, we stop reporting events because there's no longer
any point.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_healthmon.schema.json |  328 ++++++++++++++++++++++++++
 fs/xfs/xfs_healthmon.c                  |  397 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_healthmon.h                  |   30 ++
 fs/xfs/xfs_trace.h                      |   97 +++++++-
 4 files changed, 846 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_healthmon.schema.json b/fs/xfs/libxfs/xfs_healthmon.schema.json
index 9772efe25f193d..154ea0228a3615 100644
--- a/fs/xfs/libxfs/xfs_healthmon.schema.json
+++ b/fs/xfs/libxfs/xfs_healthmon.schema.json
@@ -18,6 +18,18 @@
 	"oneOf": [
 		{
 			"$ref": "#/$events/lost"
+		},
+		{
+			"$ref": "#/$events/fs_metadata"
+		},
+		{
+			"$ref": "#/$events/rtgroup_metadata"
+		},
+		{
+			"$ref": "#/$events/perag_metadata"
+		},
+		{
+			"$ref": "#/$events/inode_metadata"
 		}
 	],
 
@@ -27,6 +39,169 @@
 			"title": "Time of Event",
 			"description": "Timestamp of the event, in nanoseconds since the Unix epoch.",
 			"type": "integer"
+		},
+		"xfs_agnumber_t": {
+			"description": "Allocation group number",
+			"type": "integer",
+			"minimum": 0,
+			"maximum": 2147483647
+		},
+		"xfs_rgnumber_t": {
+			"description": "Realtime allocation group number",
+			"type": "integer",
+			"minimum": 0,
+			"maximum": 2147483647
+		},
+		"xfs_ino_t": {
+			"description": "Inode number",
+			"type": "integer",
+			"minimum": 1
+		},
+		"i_generation": {
+			"description": "Inode generation number",
+			"type": "integer"
+		}
+	},
+
+	"$comment": "Filesystem metadata event data are defined here.",
+	"$metadata": {
+		"status": {
+			"description": "Metadata health status",
+			"$comment": [
+				"One of:",
+				"",
+				" * sick:    metadata corruption discovered",
+				"            during a runtime operation.",
+				" * corrupt: corruption discovered during",
+				"            an xfs_scrub run.",
+				" * healthy: metadata object was found to be",
+				"            ok by xfs_scrub."
+			],
+			"enum": [
+				"sick",
+				"corrupt",
+				"healthy"
+			]
+		},
+		"fs": {
+			"description": [
+				"Metadata structures that affect the entire",
+				"filesystem.  Options include:",
+				"",
+				" * fscounters: summary counters",
+				" * usrquota:   user quota records",
+				" * grpquota:   group quota records",
+				" * prjquota:   project quota records",
+				" * quotacheck: quota counters",
+				" * nlinks:     file link counts",
+				" * metadir:    metadata directory",
+				" * metapath:   metadata inode paths"
+			],
+			"enum": [
+				"fscounters",
+				"grpquota",
+				"metadir",
+				"metapath",
+				"nlinks",
+				"prjquota",
+				"quotacheck",
+				"usrquota"
+			]
+		},
+		"perag": {
+			"description": [
+				"Metadata structures owned by allocation",
+				"groups on the data device.  Options include:",
+				"",
+				" * agf:        group space header",
+				" * agfl:       per-group free block list",
+				" * agi:        group inode header",
+				" * bnobt:      free space by position btree",
+				" * cntbt:      free space by length btree",
+				" * finobt:     free inode btree",
+				" * inobt:      inode btree",
+				" * rmapbt:     reverse mapping btree",
+				" * refcountbt: reference count btree",
+				" * inodes:     problems were recorded for",
+				"               this group's inodes, but the",
+				"               inodes themselves had to be",
+				"               reclaimed.",
+				" * super:      superblock"
+			],
+			"enum": [
+				"agf",
+				"agfl",
+				"agi",
+				"bnobt",
+				"cntbt",
+				"finobt",
+				"inobt",
+				"inodes",
+				"refcountbt",
+				"rmapbt",
+				"super"
+			]
+		},
+		"rtgroup": {
+			"description": [
+				"Metadata structures owned by allocation",
+				"groups on the realtime volume.  Options",
+				"include:",
+				"",
+				" * bitmap:     free space bitmap contents",
+				"               for this group",
+				" * summary:    realtime free space summary file",
+				" * rmapbt:     reverse mapping btree",
+				" * refcountbt: reference count btree",
+				" * super:      group superblock"
+			],
+			"enum": [
+				"bitmap",
+				"summary",
+				"refcountbt",
+				"rmapbt",
+				"super"
+			]
+		},
+		"inode": {
+			"description": [
+				"Metadata structures owned by file inodes.",
+				"Options include:",
+				"",
+				" * bmapbta:    attr fork",
+				" * bmapbtc:    cow fork",
+				" * bmapbtd:    data fork",
+				" * core:       inode record",
+				" * directory:  directory entries",
+				" * dirtree:    directory tree problems detected",
+				" * parent:     directory parent pointer",
+				" * symlink:    symbolic link target",
+				" * xattr:      extended attributes",
+				"",
+				"These are set when an inode record repair had",
+				"to drop the corresponding data structure to",
+				"get the inode back to a consistent state.",
+				"",
+				" * bmapbtd_zapped",
+				" * bmapbta_zapped",
+				" * directory_zapped",
+				" * symlink_zapped"
+			],
+			"enum": [
+				"bmapbta",
+				"bmapbta_zapped",
+				"bmapbtc",
+				"bmapbtd",
+				"bmapbtd_zapped",
+				"core",
+				"directory",
+				"directory_zapped",
+				"dirtree",
+				"parent",
+				"symlink",
+				"symlink_zapped",
+				"xattr"
+			]
 		}
 	},
 
@@ -58,6 +233,159 @@
 				"time_ns",
 				"domain"
 			]
+		},
+		"fs_metadata": {
+			"title": "Filesystem-wide metadata event",
+			"description": [
+				"Health status updates for filesystem-wide",
+				"metadata objects."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"$ref": "#/$metadata/status"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "fs"
+				},
+				"structures": {
+					"type": "array",
+					"items": {
+						"$ref": "#/$metadata/fs"
+					},
+					"minItems": 1
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"structures"
+			]
+		},
+		"perag_metadata": {
+			"title": "Data device allocation group metadata event",
+			"description": [
+				"Health status updates for data device ",
+				"allocation group metadata."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"$ref": "#/$metadata/status"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "perag"
+				},
+				"group": {
+					"$ref": "#/$defs/xfs_agnumber_t"
+				},
+				"structures": {
+					"type": "array",
+					"items": {
+						"$ref": "#/$metadata/perag"
+					},
+					"minItems": 1
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"group",
+				"structures"
+			]
+		},
+		"rtgroup_metadata": {
+			"title": "Realtime allocation group metadata event",
+			"description": [
+				"Health status updates for realtime allocation",
+				"group metadata."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"$ref": "#/$metadata/status"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "rtgroup"
+				},
+				"group": {
+					"$ref": "#/$defs/xfs_rgnumber_t"
+				},
+				"structures": {
+					"type": "array",
+					"items": {
+						"$ref": "#/$metadata/rtgroup"
+					},
+					"minItems": 1
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"group",
+				"structures"
+			]
+		},
+		"inode_metadata": {
+			"title": "Inode metadata event",
+			"description": [
+				"Health status updates for inode metadata.",
+				"The inode and generation number describe the",
+				"file that is affected by the change."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"$ref": "#/$metadata/status"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "inode"
+				},
+				"inumber": {
+					"$ref": "#/$defs/xfs_ino_t"
+				},
+				"generation": {
+					"$ref": "#/$defs/i_generation"
+				},
+				"structures": {
+					"type": "array",
+					"items": {
+						"$ref": "#/$metadata/inode"
+					},
+					"minItems": 1
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"inumber",
+				"generation",
+				"structures"
+			]
 		}
 	}
 }
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 499f6aab9bdbf3..9d34a826726e3e 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -18,6 +18,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_quota_defs.h"
 #include "xfs_rtgroup.h"
+#include "xfs_health.h"
 #include "xfs_healthmon.h"
 
 #include <linux/anon_inodes.h>
@@ -65,8 +66,15 @@ struct xfs_healthmon {
 	struct xfs_healthmon_event	*first_event;
 	struct xfs_healthmon_event	*last_event;
 
+	/* live update hooks */
+	struct xfs_health_hook		hhook;
+
+	/* filesystem mount, or NULL if we've unmounted */
 	struct xfs_mount		*mp;
 
+	/* filesystem type for safe cleanup of hooks; requires module_get */
+	struct file_system_type		*fstyp;
+
 	/* number of events */
 	unsigned int			events;
 
@@ -178,6 +186,10 @@ xfs_healthmon_start_live_update(
 {
 	struct xfs_healthmon_event	*event;
 
+	/* Already unmounted filesystem, do nothing. */
+	if (!hm->mp)
+		return -ESHUTDOWN;
+
 	/*
 	 * If we previously lost an event or the queue is full, try to queue
 	 * a notification about lost events.
@@ -207,6 +219,171 @@ xfs_healthmon_start_live_update(
 	return 0;
 }
 
+/* Compute the reporting mask. */
+static inline bool
+xfs_healthmon_event_mask(
+	struct xfs_healthmon			*hm,
+	enum xfs_health_update_type		type,
+	const struct xfs_health_update_params	*hup,
+	unsigned int				*mask)
+{
+	/* Always report unmounts. */
+	if (type == XFS_HEALTHUP_UNMOUNT)
+		return true;
+
+	/* If we want all events, return all events. */
+	if (hm->verbose) {
+		*mask = hup->new_mask;
+		return true;
+	}
+
+	switch (type) {
+	case XFS_HEALTHUP_SICK:
+		/* Always report runtime corruptions */
+		*mask = hup->new_mask;
+		break;
+	case XFS_HEALTHUP_CORRUPT:
+		/* Only report new fsck errors */
+		*mask = hup->new_mask & ~hup->old_mask;
+		break;
+	case XFS_HEALTHUP_HEALTHY:
+		/* Only report healthy metadata that got fixed */
+		*mask = hup->new_mask & hup->old_mask;
+		break;
+	case XFS_HEALTHUP_UNMOUNT:
+		/* This is here for static enum checking */
+		break;
+	}
+
+	/* If not in verbose mode, mask state has to change. */
+	return *mask != 0;
+}
+
+static inline enum xfs_healthmon_type
+health_update_to_type(
+	enum xfs_health_update_type	type)
+{
+	switch (type) {
+	case XFS_HEALTHUP_SICK:
+		return XFS_HEALTHMON_SICK;
+	case XFS_HEALTHUP_CORRUPT:
+		return XFS_HEALTHMON_CORRUPT;
+	case XFS_HEALTHUP_HEALTHY:
+		return XFS_HEALTHMON_HEALTHY;
+	case XFS_HEALTHUP_UNMOUNT:
+		/* static checking */
+		break;
+	}
+	return XFS_HEALTHMON_UNMOUNT;
+}
+
+static inline enum xfs_healthmon_domain
+health_update_to_domain(
+	enum xfs_health_update_domain	domain)
+{
+	switch (domain) {
+	case XFS_HEALTHUP_FS:
+		return XFS_HEALTHMON_FS;
+	case XFS_HEALTHUP_AG:
+		return XFS_HEALTHMON_AG;
+	case XFS_HEALTHUP_RTGROUP:
+		return XFS_HEALTHMON_RTGROUP;
+	case XFS_HEALTHUP_INODE:
+		/* static checking */
+		break;
+	}
+	return XFS_HEALTHMON_INODE;
+}
+
+/* Add a health event to the reporting queue. */
+STATIC int
+xfs_healthmon_metadata_hook(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_health_update_params	*hup = data;
+	struct xfs_healthmon		*hm;
+	struct xfs_healthmon_event	*event;
+	enum xfs_health_update_type	type = action;
+	unsigned int			mask = 0;
+	int				error;
+
+	hm = container_of(nb, struct xfs_healthmon, hhook.health_hook.nb);
+
+	/* Decode event mask and skip events we don't care about. */
+	if (!xfs_healthmon_event_mask(hm, type, hup, &mask))
+		return NOTIFY_DONE;
+
+	mutex_lock(&hm->lock);
+
+	trace_xfs_healthmon_metadata_hook(hm->mp, action, hup, hm->events,
+			hm->lost_prev_event);
+
+	error = xfs_healthmon_start_live_update(hm);
+	if (error)
+		goto out_unlock;
+
+	if (type == XFS_HEALTHUP_UNMOUNT) {
+		/*
+		 * The filesystem is unmounting, so we must detach from the
+		 * mount.  After this point, the healthmon thread has no
+		 * connection to the mounted filesystem.
+		 */
+		trace_xfs_healthmon_unmount(hm->mp, hm->events,
+				hm->lost_prev_event);
+		hm->mp = NULL;
+		wake_up(&hm->wait);
+		goto out_unlock;
+	}
+
+	event = xfs_healthmon_alloc(hm, health_update_to_type(type),
+			  health_update_to_domain(hup->domain));
+	if (!event)
+		goto out_unlock;
+
+	/* Ignore the event if it's only reporting a secondary health state. */
+	switch (event->domain) {
+	case XFS_HEALTHMON_FS:
+		event->fsmask = mask & ~XFS_SICK_FS_SECONDARY;
+		if (!event->fsmask)
+			goto out_event;
+		break;
+	case XFS_HEALTHMON_AG:
+		event->grpmask = mask & ~XFS_SICK_AG_SECONDARY;
+		if (!event->grpmask)
+			goto out_event;
+		event->group = hup->group;
+		break;
+	case XFS_HEALTHMON_RTGROUP:
+		event->grpmask = mask & ~XFS_SICK_RG_SECONDARY;
+		if (!event->grpmask)
+			goto out_event;
+		event->group = hup->group;
+		break;
+	case XFS_HEALTHMON_INODE:
+		event->imask = mask & ~XFS_SICK_INO_SECONDARY;
+		if (!event->imask)
+			goto out_event;
+		event->ino = hup->ino;
+		event->gen = hup->gen;
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+	error = xfs_healthmon_push(hm, event);
+	if (error)
+		goto out_event;
+
+out_unlock:
+	mutex_unlock(&hm->lock);
+	return NOTIFY_DONE;
+out_event:
+	kfree(event);
+	goto out_unlock;
+}
+
 /* Render the health update type as a string. */
 STATIC const char *
 xfs_healthmon_typestring(
@@ -214,6 +391,10 @@ xfs_healthmon_typestring(
 {
 	static const char *type_strings[] = {
 		[XFS_HEALTHMON_LOST]		= "lost",
+		[XFS_HEALTHMON_UNMOUNT]		= "unmount",
+		[XFS_HEALTHMON_SICK]		= "sick",
+		[XFS_HEALTHMON_CORRUPT]		= "corrupt",
+		[XFS_HEALTHMON_HEALTHY]		= "healthy",
 	};
 
 	if (event->type >= ARRAY_SIZE(type_strings))
@@ -229,6 +410,10 @@ xfs_healthmon_domstring(
 {
 	static const char *dom_strings[] = {
 		[XFS_HEALTHMON_MOUNT]		= "mount",
+		[XFS_HEALTHMON_FS]		= "fs",
+		[XFS_HEALTHMON_AG]		= "perag",
+		[XFS_HEALTHMON_INODE]		= "inode",
+		[XFS_HEALTHMON_RTGROUP]		= "rtgroup",
 	};
 
 	if (event->domain >= ARRAY_SIZE(dom_strings))
@@ -254,6 +439,11 @@ xfs_healthmon_format_flags(
 		if (!(p->mask & flags))
 			continue;
 
+		if (!p->str) {
+			flags &= ~p->mask;
+			continue;
+		}
+
 		ret = seq_buf_printf(outbuf, "%s\"%s\"",
 				first ? "" : ", ", p->str);
 		if (ret < 0)
@@ -304,6 +494,118 @@ __xfs_healthmon_format_mask(
 #define xfs_healthmon_format_mask(o, d, s, m) \
 	__xfs_healthmon_format_mask((o), (d), (s), ARRAY_SIZE(s), (m))
 
+/* Render fs sickness mask as a string set */
+static int
+xfs_healthmon_format_fs(
+	struct seq_buf			*outbuf,
+	const struct xfs_healthmon_event *event)
+{
+	static const struct flag_string	mask_strings[] = {
+		{ XFS_SICK_FS_COUNTERS,		"fscounters" },
+		{ XFS_SICK_FS_UQUOTA,		"usrquota" },
+		{ XFS_SICK_FS_GQUOTA,		"grpquota" },
+		{ XFS_SICK_FS_PQUOTA,		"prjquota" },
+		{ XFS_SICK_FS_QUOTACHECK,	"quotacheck" },
+		{ XFS_SICK_FS_NLINKS,		"nlinks" },
+		{ XFS_SICK_FS_METADIR,		"metadir" },
+		{ XFS_SICK_FS_METAPATH,		"metapath" },
+	};
+
+	return xfs_healthmon_format_mask(outbuf, "structures", mask_strings,
+			event->fsmask);
+}
+
+/* Render rtgroup sickness mask as a string set */
+static int
+xfs_healthmon_format_rtgroup(
+	struct seq_buf			*outbuf,
+	const struct xfs_healthmon_event *event)
+{
+	static const struct flag_string	mask_strings[] = {
+		{ XFS_SICK_RG_SUPER,		"super" },
+		{ XFS_SICK_RG_BITMAP,		"bitmap" },
+		{ XFS_SICK_RG_SUMMARY,		"summary" },
+		{ XFS_SICK_RG_RMAPBT,		"rmapbt" },
+		{ XFS_SICK_RG_REFCNTBT,		"refcountbt" },
+	};
+	ssize_t				ret;
+
+	ret = xfs_healthmon_format_mask(outbuf, "structures", mask_strings,
+			event->grpmask);
+	if (ret < 0)
+		return ret;
+
+	return seq_buf_printf(outbuf, "  \"group\":      %u,\n",
+			event->group);
+}
+
+/* Render perag sickness mask as a string set */
+static int
+xfs_healthmon_format_ag(
+	struct seq_buf			*outbuf,
+	const struct xfs_healthmon_event *event)
+{
+	static const struct flag_string	mask_strings[] = {
+		{ XFS_SICK_AG_SB,		"super" },
+		{ XFS_SICK_AG_AGF,		"agf" },
+		{ XFS_SICK_AG_AGFL,		"agfl" },
+		{ XFS_SICK_AG_AGI,		"agi" },
+		{ XFS_SICK_AG_BNOBT,		"bnobt" },
+		{ XFS_SICK_AG_CNTBT,		"cntbt" },
+		{ XFS_SICK_AG_INOBT,		"inobt" },
+		{ XFS_SICK_AG_FINOBT,		"finobt" },
+		{ XFS_SICK_AG_RMAPBT,		"rmapbt" },
+		{ XFS_SICK_AG_REFCNTBT,		"refcountbt" },
+		{ XFS_SICK_AG_INODES,		"inodes" },
+	};
+	ssize_t				ret;
+
+	ret = xfs_healthmon_format_mask(outbuf, "structures", mask_strings,
+			event->grpmask);
+	if (ret < 0)
+		return ret;
+
+	return seq_buf_printf(outbuf, "  \"group\":      %u,\n",
+			event->group);
+}
+
+/* Render inode sickness mask as a string set */
+static int
+xfs_healthmon_format_inode(
+	struct seq_buf			*outbuf,
+	const struct xfs_healthmon_event *event)
+{
+	static const struct flag_string	mask_strings[] = {
+		{ XFS_SICK_INO_CORE,		"core" },
+		{ XFS_SICK_INO_BMBTD,		"bmapbtd" },
+		{ XFS_SICK_INO_BMBTA,		"bmapbta" },
+		{ XFS_SICK_INO_BMBTC,		"bmapbtc" },
+		{ XFS_SICK_INO_DIR,		"directory" },
+		{ XFS_SICK_INO_XATTR,		"xattr" },
+		{ XFS_SICK_INO_SYMLINK,		"symlink" },
+		{ XFS_SICK_INO_PARENT,		"parent" },
+		{ XFS_SICK_INO_BMBTD_ZAPPED,	"bmapbtd_zapped" },
+		{ XFS_SICK_INO_BMBTA_ZAPPED,	"bmapbta_zapped" },
+		{ XFS_SICK_INO_DIR_ZAPPED,	"directory_zapped" },
+		{ XFS_SICK_INO_SYMLINK_ZAPPED,	"symlink_zapped" },
+		{ XFS_SICK_INO_FORGET,		NULL, },
+		{ XFS_SICK_INO_DIRTREE,		"dirtree" },
+	};
+	ssize_t				ret;
+
+	ret = xfs_healthmon_format_mask(outbuf, "structures", mask_strings,
+			event->imask);
+	if (ret < 0)
+		return ret;
+
+	ret = seq_buf_printf(outbuf, "  \"inumber\":    %llu,\n",
+			event->ino);
+	if (ret < 0)
+		return ret;
+	return seq_buf_printf(outbuf, "  \"generation\": %u,\n",
+			event->gen);
+}
+
 static inline void
 xfs_healthmon_reset_outbuf(
 	struct xfs_healthmon		*hm)
@@ -354,6 +656,18 @@ xfs_healthmon_format(
 	case XFS_HEALTHMON_MOUNT:
 		/* empty */
 		break;
+	case XFS_HEALTHMON_FS:
+		ret = xfs_healthmon_format_fs(outbuf, event);
+		break;
+	case XFS_HEALTHMON_RTGROUP:
+		ret = xfs_healthmon_format_rtgroup(outbuf, event);
+		break;
+	case XFS_HEALTHMON_AG:
+		ret = xfs_healthmon_format_ag(outbuf, event);
+		break;
+	case XFS_HEALTHMON_INODE:
+		ret = xfs_healthmon_format_inode(outbuf, event);
+		break;
 	}
 	if (ret < 0)
 		goto overrun;
@@ -400,7 +714,7 @@ static inline bool
 xfs_healthmon_has_eventdata(
 	struct xfs_healthmon	*hm)
 {
-	return hm->events > 0 || xfs_healthmon_outbuf_bytes(hm) > 0;
+	return !hm->mp || hm->events > 0 || xfs_healthmon_outbuf_bytes(hm) > 0;
 }
 
 /* Try to copy the rest of the outbuf to the iov iter. */
@@ -521,6 +835,7 @@ xfs_healthmon_read_iter(
 				break;
 			xfs_healthmon_free_head(hm, event);
 		}
+
 		/* Copy it to userspace */
 		ret = xfs_healthmon_copybuf(hm, to);
 		if (ret <= 0)
@@ -568,6 +883,58 @@ xfs_healthmon_free_events(
 	hm->first_event = hm->last_event = NULL;
 }
 
+/*
+ * Detach all filesystem hooks that were set up for a health monitor.  Only
+ * call this from iterate_super*.
+ */
+STATIC void
+xfs_healthmon_detach_hooks(
+	struct super_block	*sb,
+	void			*arg)
+{
+	struct xfs_healthmon	*hm = arg;
+
+	mutex_lock(&hm->lock);
+
+	/*
+	 * Because health monitors have a weak reference to the filesystem
+	 * they're monitoring, the hook deletions below must not race against
+	 * that filesystem being unmounted because that could lead to UAF
+	 * errors.
+	 *
+	 * If hm->mp is NULL, the health unmount hook already ran and the hook
+	 * chain head (contained within the xfs_mount structure) is gone.  Do
+	 * not detach any hooks; just let them get freed when the healthmon
+	 * object is torn down.
+	 */
+	if (!hm->mp)
+		goto out_unlock;
+
+	/*
+	 * Otherwise, the caller gave us a non-dying @sb with s_umount held in
+	 * shared mode, which means that @sb cannot be running through
+	 * deactivate_locked_super and cannot be freed.  It's safe to compare
+	 * @sb against the super that we snapshotted when we set up the health
+	 * monitor.
+	 */
+	if (hm->mp->m_super != sb)
+		goto out_unlock;
+
+	mutex_unlock(&hm->lock);
+
+	/*
+	 * Now we know that the filesystem @hm->mp is active and cannot be
+	 * deactivated until this function returns.  Unmount events are sent
+	 * through the health monitoring subsystem from xfs_fs_put_super, so
+	 * it is now time to detach the hooks.
+	 */
+	xfs_health_hook_del(hm->mp, &hm->hhook);
+	return;
+
+out_unlock:
+	mutex_unlock(&hm->lock);
+}
+
 /* Free the health monitoring information. */
 STATIC int
 xfs_healthmon_release(
@@ -580,6 +947,9 @@ xfs_healthmon_release(
 
 	wake_up_all(&hm->wait);
 
+	iterate_supers_type(hm->fstyp, xfs_healthmon_detach_hooks, hm);
+	xfs_health_hook_disable();
+
 	mutex_destroy(&hm->lock);
 	xfs_healthmon_free_events(hm);
 	if (hm->outbuf.size)
@@ -641,6 +1011,13 @@ xfs_ioc_health_monitor(
 		return -ENOMEM;
 	hm->mp = mp;
 
+	/*
+	 * Since we already got a ref to the module, take a reference to the
+	 * fstype to make it easier to detach the hooks when we tear things
+	 * down later.
+	 */
+	hm->fstyp = mp->m_super->s_type;
+
 	seq_buf_init(&hm->outbuf, NULL, 0);
 	mutex_init(&hm->lock);
 	init_waitqueue_head(&hm->wait);
@@ -648,11 +1025,20 @@ xfs_ioc_health_monitor(
 	if (hmo.flags & XFS_HEALTH_MONITOR_VERBOSE)
 		hm->verbose = true;
 
+	/* Enable hooks to receive events, generally. */
+	xfs_health_hook_enable();
+
+	/* Attach specific event hooks to this monitor. */
+	xfs_health_hook_setup(&hm->hhook, xfs_healthmon_metadata_hook);
+	ret = xfs_health_hook_add(mp, &hm->hhook);
+	if (ret)
+		goto out_hooks;
+
 	/* Set up VFS file and file descriptor. */
 	name = kasprintf(GFP_KERNEL, "XFS (%s): healthmon", mp->m_super->s_id);
 	if (!name) {
 		ret = -ENOMEM;
-		goto out_mutex;
+		goto out_healthhook;
 	}
 
 	fd = anon_inode_getfd(name, &xfs_healthmon_fops, hm,
@@ -660,14 +1046,17 @@ xfs_ioc_health_monitor(
 	kvfree(name);
 	if (fd < 0) {
 		ret = fd;
-		goto out_mutex;
+		goto out_healthhook;
 	}
 
 	trace_xfs_healthmon_create(mp, hmo.flags, hmo.format);
 
 	return fd;
 
-out_mutex:
+out_healthhook:
+	xfs_health_hook_del(mp, &hm->hhook);
+out_hooks:
+	xfs_health_hook_disable();
 	mutex_destroy(&hm->lock);
 	xfs_healthmon_free_events(hm);
 	kfree(hm);
diff --git a/fs/xfs/xfs_healthmon.h b/fs/xfs/xfs_healthmon.h
index 606f205074495c..3ece61165837b2 100644
--- a/fs/xfs/xfs_healthmon.h
+++ b/fs/xfs/xfs_healthmon.h
@@ -8,10 +8,22 @@
 
 enum xfs_healthmon_type {
 	XFS_HEALTHMON_LOST,	/* message lost */
+
+	/* metadata health events */
+	XFS_HEALTHMON_SICK,	/* runtime corruption observed */
+	XFS_HEALTHMON_CORRUPT,	/* fsck reported corruption */
+	XFS_HEALTHMON_HEALTHY,	/* fsck reported healthy structure */
+	XFS_HEALTHMON_UNMOUNT,	/* filesystem is unmounting */
 };
 
 enum xfs_healthmon_domain {
 	XFS_HEALTHMON_MOUNT,	/* affects the whole fs */
+
+	/* metadata health events */
+	XFS_HEALTHMON_FS,	/* main filesystem metadata */
+	XFS_HEALTHMON_AG,	/* allocation group metadata */
+	XFS_HEALTHMON_INODE,	/* inode metadata */
+	XFS_HEALTHMON_RTGROUP,	/* realtime group metadata */
 };
 
 struct xfs_healthmon_event {
@@ -27,6 +39,24 @@ struct xfs_healthmon_event {
 		struct {
 			unsigned int	flags;
 		};
+		/* fs/rt metadata */
+		struct {
+			/* XFS_SICK_* flags */
+			unsigned int	fsmask;
+		};
+		/* ag/rtgroup metadata */
+		struct {
+			/* XFS_SICK_* flags */
+			unsigned int	grpmask;
+			unsigned int	group;
+		};
+		/* inode metadata */
+		struct {
+			/* XFS_SICK_INO_* flags */
+			unsigned int	imask;
+			uint32_t	gen;
+			xfs_ino_t	ino;
+		};
 	};
 };
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index bd3b007d213fc6..4a68d2ec8d0a34 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -6174,14 +6174,30 @@ DEFINE_HEALTHMON_EVENT(xfs_healthmon_release);
 DEFINE_HEALTHMON_EVENT(xfs_healthmon_unmount);
 
 #define XFS_HEALTHMON_TYPE_STRINGS \
-	{ XFS_HEALTHMON_LOST,		"lost" }
+	{ XFS_HEALTHMON_LOST,		"lost" }, \
+	{ XFS_HEALTHMON_UNMOUNT,	"unmount" }, \
+	{ XFS_HEALTHMON_SICK,		"sick" }, \
+	{ XFS_HEALTHMON_CORRUPT,	"corrupt" }, \
+	{ XFS_HEALTHMON_HEALTHY,	"healthy" }
 
 #define XFS_HEALTHMON_DOMAIN_STRINGS \
-	{ XFS_HEALTHMON_MOUNT,		"mount" }
+	{ XFS_HEALTHMON_MOUNT,		"mount" }, \
+	{ XFS_HEALTHMON_FS,		"fs" }, \
+	{ XFS_HEALTHMON_AG,		"ag" }, \
+	{ XFS_HEALTHMON_INODE,		"inode" }, \
+	{ XFS_HEALTHMON_RTGROUP,	"rtgroup" }
 
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_LOST);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_UNMOUNT);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_SICK);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_CORRUPT);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_HEALTHY);
 
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_MOUNT);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_FS);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_AG);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_INODE);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_RTGROUP);
 
 DECLARE_EVENT_CLASS(xfs_healthmon_event_class,
 	TP_PROTO(const struct xfs_mount *mp, const struct xfs_healthmon_event *event),
@@ -6207,6 +6223,19 @@ DECLARE_EVENT_CLASS(xfs_healthmon_event_class,
 		case XFS_HEALTHMON_MOUNT:
 			__entry->mask = event->flags;
 			break;
+		case XFS_HEALTHMON_FS:
+			__entry->mask = event->fsmask;
+			break;
+		case XFS_HEALTHMON_AG:
+		case XFS_HEALTHMON_RTGROUP:
+			__entry->mask = event->grpmask;
+			__entry->group = event->group;
+			break;
+		case XFS_HEALTHMON_INODE:
+			__entry->mask = event->imask;
+			__entry->ino = event->ino;
+			__entry->gen = event->gen;
+			break;
 		}
 	),
 	TP_printk("dev %d:%d type %s domain %s mask 0x%x ino 0x%llx gen 0x%x group 0x%x",
@@ -6227,6 +6256,70 @@ DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_pop);
 DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_format);
 DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_format_overflow);
 DEFINE_HEALTHMONEVENT_EVENT(xfs_healthmon_drop);
+
+#define XFS_HEALTHUP_TYPE_STRINGS \
+	{ XFS_HEALTHUP_UNMOUNT,		"unmount" }, \
+	{ XFS_HEALTHUP_SICK,		"sick" }, \
+	{ XFS_HEALTHUP_CORRUPT,		"corrupt" }, \
+	{ XFS_HEALTHUP_HEALTHY,		"healthy" }
+
+#define XFS_HEALTHUP_DOMAIN_STRINGS \
+	{ XFS_HEALTHUP_FS,		"fs" }, \
+	{ XFS_HEALTHUP_AG,		"ag" }, \
+	{ XFS_HEALTHUP_INODE,		"inode" }, \
+	{ XFS_HEALTHUP_RTGROUP,		"rtgroup" }
+
+TRACE_DEFINE_ENUM(XFS_HEALTHUP_UNMOUNT);
+TRACE_DEFINE_ENUM(XFS_HEALTHUP_SICK);
+TRACE_DEFINE_ENUM(XFS_HEALTHUP_CORRUPT);
+TRACE_DEFINE_ENUM(XFS_HEALTHUP_HEALTHY);
+
+TRACE_DEFINE_ENUM(XFS_HEALTHUP_FS);
+TRACE_DEFINE_ENUM(XFS_HEALTHUP_AG);
+TRACE_DEFINE_ENUM(XFS_HEALTHUP_INODE);
+TRACE_DEFINE_ENUM(XFS_HEALTHUP_RTGROUP);
+
+TRACE_EVENT(xfs_healthmon_metadata_hook,
+	TP_PROTO(const struct xfs_mount *mp, unsigned long type,
+		 const struct xfs_health_update_params *update,
+		 unsigned int events, bool lost_prev),
+	TP_ARGS(mp, type, update, events, lost_prev),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, type)
+		__field(unsigned int, domain)
+		__field(unsigned int, old_mask)
+		__field(unsigned int, new_mask)
+		__field(unsigned long long, ino)
+		__field(unsigned int, gen)
+		__field(unsigned int, group)
+		__field(unsigned int, events)
+		__field(bool, lost_prev)
+	),
+	TP_fast_assign(
+		__entry->dev = mp ? mp->m_super->s_dev : 0;
+		__entry->type = type;
+		__entry->domain = update->domain;
+		__entry->old_mask = update->old_mask;
+		__entry->new_mask = update->new_mask;
+		__entry->ino = update->ino;
+		__entry->gen = update->gen;
+		__entry->group = update->group;
+		__entry->events = events;
+		__entry->lost_prev = lost_prev;
+	),
+	TP_printk("dev %d:%d type %s domain %s oldmask 0x%x newmask 0x%x ino 0x%llx gen 0x%x group 0x%x events %u lost_prev? %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XFS_HEALTHUP_TYPE_STRINGS),
+		  __print_symbolic(__entry->domain, XFS_HEALTHUP_DOMAIN_STRINGS),
+		  __entry->old_mask,
+		  __entry->new_mask,
+		  __entry->ino,
+		  __entry->gen,
+		  __entry->group,
+		  __entry->events,
+		  __entry->lost_prev)
+);
 #endif /* CONFIG_XFS_HEALTH_MONITOR */
 
 #endif /* _TRACE_XFS_H */

