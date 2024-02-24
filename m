Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37AF2581;
	Sat, 24 Feb 2024 01:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737538; cv=none; b=SIMJN/qrbNtHtIRYuInv9u2WLtsUjJXEnPcuQYBtPqvj49MqrORYcFSzeGHFj34ogYae6fpU2juoLvpSPIJE3y/CBpPb485IKXwW988ms4H15WRQGQiM9rgBJYP5W72plRs3yLQj3lJ2uVsMwvypiX3kvJJS9ekZLOd8FvBGOSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737538; c=relaxed/simple;
	bh=DdrfS0o7ncdhrYF8Tq99CE9VgVRkqfrSK8VkNVMX4r0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mGDqLayH/4ljRyAJFN9GSQEkWZ29V7/L+9/LNObtPZuGosIIQ9+GiMnBCN7gA+2q4Gwpd0ZcTBxwT5gtiusr7euXlvNl0uHrx73CDzsz8rDcpvWsi1FpNv9Hl0RHsIoym69WXlgk9BwbC9lvKGP+3uLNzjw10A4ILOqyQ2sOeiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bRdcS6AJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bRdcS6AJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936D4C433F1;
	Sat, 24 Feb 2024 01:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708737537;
	bh=DdrfS0o7ncdhrYF8Tq99CE9VgVRkqfrSK8VkNVMX4r0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bRdcS6AJy3L/ZvIleYRXSthDAIlkQeFnqKU/SyKnWdgtQMwhIvmHeRhekRvOfW5V9
	 tu6DfEYyCYyrTgDU5U2R5gkdPACGisZaBVWRljQoq9dFybVsT7mZ8q/eVb/zb5jMzy
	 Nm4QLF1x+iKvkYiqGxehnoBr4+aBVkGrPC5/VNiawpYyYYS6oOy9EvTuXCJkue0YMs
	 pLub5oUt3sO6Wuklk69nPuahZZmsqiuRVYEO8Aq1psvISthRAMJ5yDWJVjP236EnyK
	 5SppZqgL5QGvtxmK3VSRw93J9bWZfbKqun1KG9y5LFf/0LRtQjm9jTVoQ5iBFNmEKv
	 R32yyaHsuKeHA==
Date: Fri, 23 Feb 2024 17:18:57 -0800
Subject: [PATCH 5/8] xfs: report metadata health events through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org
Message-ID: <170873669946.1861872.2642293959487034053.stgit@frogsfrogsfrogs>
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

Set up a metadata health event hook so that we can send events to
userspace as we collect information.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_healthmon.c |  403 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_healthmon.h |   31 ++++
 fs/xfs/xfs_trace.h     |  102 ++++++++++++
 3 files changed, 532 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index b215ded0fda8b..d3b548a63f0b9 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -19,6 +19,7 @@
 #include "xfs_quota_defs.h"
 #include "xfs_rtgroup.h"
 #include "xfs_fsops.h"
+#include "xfs_health.h"
 #include "xfs_healthmon.h"
 
 /*
@@ -72,6 +73,86 @@
  *
  * "reasons" are a list of strings describing why the filesystem went down.
  * They correspond to the SHUTDOWN_* flags.
+ *
+ * Metadata Health Events
+ * ----------------------
+ *
+ * {
+ *	"type": "sick" | "corrupt" | "healthy",
+ *	"domain": "fs" | "realtime" | "ag" | "inode" | "rtgroup",
+ *	"structures": [structure string list...],
+ *
+ *	"group": integer,      (if domain is "ag" or "rtgroup")
+ *
+ *	"inode": integer,      (if domain is "inode")
+ *	"generation": integer, (if domain is "inode")
+ *
+ *	"time_ns": integer
+ * }
+ *
+ * "sick" means that metadata corruption was discovered during a runtime
+ * operation.
+ *
+ * "corrupt" means that corruption was discovered during an xfs_scrub run.
+ *
+ * "healthy" means that a metadata object was found to be ok by xfs_scrub.
+ *
+ * The domain item indicates where in the filesystem to find the metadata
+ * object(s) that are the target of the event.
+ *
+ * "fs" means whole-filesystem metadata.  Structures are as follows:
+ *
+ *     "fscounters": summary counters
+ *     "usrquota":   user quota records
+ *     "grpquota":   group quota records
+ *     "prjquota":   project quota records
+ *     "quotacheck": quota counters
+ *     "nlinks":     file link counts
+ *     "metadir":    metadata directory
+ *     "metapath":   metadata inode paths
+ *
+ * "realtime" means realtime volume metadata:
+ *
+ *     "bitmap":     realtime bitmap file
+ *     "summary":    realtime free space summary file
+ *
+ * "ag" means allocation group metadata on the data device:
+ *
+ *     "super":      superblock
+ *     "agf":        group space header
+ *     "agfl":       per-group free block list
+ *     "agi":        group inode header
+ *     "bnobt":      free space by position btree
+ *     "cntbt":      free space by length btree
+ *     "inobt":      inode btree
+ *     "finobt":     free inode btree
+ *     "rmapbt":     reverse mapping btree
+ *     "refcountbt": reference count btree
+ *     "inodes":     problems were recorded for this group's inodes, but the
+ *                   inodes themselves had to be reclaimed
+ *
+ * "inode" means inode metadata:
+ *
+ *     "core":       inode record
+ *     "bmapbtd":    data fork
+ *     "bmapbta":    attr fork
+ *     "bmapbtc":    cow fork
+ *     "directory":  directory entries and index
+ *     "xattr":      extended attributes and index
+ *     "symlink":    symbolic link target
+ *     "parent":     directory parent pointer
+ *     "bmapbtd_zapped":  these are set when an inode record repair had to drop
+ *     "bmapbtd_zapped"   the corresponding data structure to get the inode
+ *     "directory_zapped" back to a consistent state
+ *     "symlink_zapped"
+ *     "dirtree":    directory tree problems detected
+ *
+ * "rtgroup" means realtime group metadata for the realtime volume:
+ *
+ *     "super":      group superblock
+ *     "bitmap":     free space bitmap contents for this group
+ *     "rmapbt":     reverse mapping btree
+ *     "refcountbt": reference count btree
  */
 
 #define XFS_HEALTHMON_MAX_EVENTS \
@@ -98,6 +179,7 @@ struct xfs_healthmon {
 
 	/* live update hooks */
 	struct xfs_shutdown_hook	shook;
+	struct xfs_health_hook		hhook;
 
 	/* filesystem mount, or NULL if we've unmounted */
 	struct xfs_mount		*mp;
@@ -145,8 +227,10 @@ xfs_healthmon_exit(
 	trace_xfs_healthmon_exit(hm->mp, hm->events, hm->lost_prev_event);
 
 	if (hm->mp) {
+		xfs_health_hook_del(hm->mp, &hm->hhook);
 		xfs_shutdown_hook_del(hm->mp, &hm->shook);
 	}
+	xfs_health_hook_disable();
 	xfs_shutdown_hook_disable();
 	mutex_destroy(&hm->lock);
 	xfs_healthmon_free_events(hm);
@@ -291,6 +375,157 @@ xfs_healthmon_shutdown_hook(
 	return NOTIFY_DONE;
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
+	case XFS_HEALTHUP_RT:
+		return XFS_HEALTHMON_RT;
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
+	event = new_event(hm, health_update_to_type(type),
+			  health_update_to_domain(hup->domain));
+	if (!event)
+		goto out_unlock;
+
+	switch (event->domain) {
+	case XFS_HEALTHMON_FS:
+	case XFS_HEALTHMON_RT:
+		event->fsmask = mask;
+		break;
+	case XFS_HEALTHMON_AG:
+	case XFS_HEALTHMON_RTGROUP:
+		event->grpmask = mask;
+		event->group = hup->group;
+		break;
+	case XFS_HEALTHMON_INODE:
+		event->imask = mask;
+		event->ino = hup->ino;
+		event->gen = hup->gen;
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+	xfs_healthmon_push(hm, event);
+
+out_unlock:
+	mutex_unlock(&hm->lock);
+	return NOTIFY_DONE;
+}
+
 /* Render the health update type as a string. */
 STATIC const char *
 xfs_healthmon_typestring(
@@ -299,6 +534,10 @@ xfs_healthmon_typestring(
 	static const char *type_strings[] = {
 		[XFS_HEALTHMON_LOST]		= "lost",
 		[XFS_HEALTHMON_SHUTDOWN]	= "shutdown",
+		[XFS_HEALTHMON_UNMOUNT]		= "unmount",
+		[XFS_HEALTHMON_SICK]		= "sick",
+		[XFS_HEALTHMON_CORRUPT]		= "corrupt",
+		[XFS_HEALTHMON_HEALTHY]		= "healthy",
 	};
 
 	if (event->type >= ARRAY_SIZE(type_strings))
@@ -314,6 +553,11 @@ xfs_healthmon_domstring(
 {
 	static const char *dom_strings[] = {
 		[XFS_HEALTHMON_MOUNT]		= "mount",
+		[XFS_HEALTHMON_FS]		= "fs",
+		[XFS_HEALTHMON_RT]		= "realtime",
+		[XFS_HEALTHMON_AG]		= "ag",
+		[XFS_HEALTHMON_INODE]		= "inode",
+		[XFS_HEALTHMON_RTGROUP]		= "rtgroup",
 	};
 
 	if (event->domain >= ARRAY_SIZE(dom_strings))
@@ -339,6 +583,11 @@ xfs_healthmon_format_flags(
 		if (!(p->mask & flags))
 			continue;
 
+		if (!p->str) {
+			flags &= ~p->mask;
+			continue;
+		}
+
 		ret = stdio_redirect_printf(out, false, "%s\"%s\"",
 				first ? "" : ", ", p->str);
 		if (ret < 0)
@@ -408,6 +657,132 @@ xfs_healthmon_format_shutdown(
 			event->flags);
 }
 
+/* Render fs sickness mask as a string set */
+static ssize_t
+xfs_healthmon_format_fs(
+	struct stdio_redirect		*out,
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
+	return xfs_healthmon_format_mask(out, "structures", mask_strings,
+			event->fsmask);
+}
+
+/* Render rt sickness mask as a string set */
+static ssize_t
+xfs_healthmon_format_rt(
+	struct stdio_redirect		*out,
+	const struct xfs_healthmon_event *event)
+{
+	static const struct flag_string	mask_strings[] = {
+		{ XFS_SICK_RT_BITMAP,		"bitmap" },
+		{ XFS_SICK_RT_SUMMARY,		"summary" },
+	};
+
+	return xfs_healthmon_format_mask(out, "structures", mask_strings,
+			event->fsmask);
+}
+
+/* Render rtgroup sickness mask as a string set */
+static ssize_t
+xfs_healthmon_format_rtgroup(
+	struct stdio_redirect		*out,
+	const struct xfs_healthmon_event *event)
+{
+	static const struct flag_string	mask_strings[] = {
+		{ XFS_SICK_RG_SUPER,		"super" },
+		{ XFS_SICK_RG_BITMAP,		"bitmap" },
+		{ XFS_SICK_RG_RMAPBT,		"rmapbt" },
+		{ XFS_SICK_RG_REFCNTBT,		"refcountbt" },
+	};
+	ssize_t				ret;
+
+	ret = xfs_healthmon_format_mask(out, "structures", mask_strings,
+			event->grpmask);
+	if (ret < 0)
+		return ret;
+
+	return stdio_redirect_printf(out, false, "  \"group\":      %u,\n",
+			event->group);
+}
+
+/* Render perag sickness mask as a string set */
+static ssize_t
+xfs_healthmon_format_ag(
+	struct stdio_redirect		*out,
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
+	ret = xfs_healthmon_format_mask(out, "structures", mask_strings,
+			event->grpmask);
+	if (ret < 0)
+		return ret;
+
+	return stdio_redirect_printf(out, false, "  \"group\":      %u,\n",
+			event->group);
+}
+
+/* Render inode sickness mask as a string set */
+static ssize_t
+xfs_healthmon_format_inode(
+	struct stdio_redirect		*out,
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
+		{ XFS_SICK_INO_BMBTA_ZAPPED,	"bmapbtd_zapped" },
+		{ XFS_SICK_INO_DIR_ZAPPED,	"directory_zapped" },
+		{ XFS_SICK_INO_SYMLINK_ZAPPED,	"symlink_zapped" },
+		{ XFS_SICK_INO_FORGET,		NULL, },
+		{ XFS_SICK_INO_DIRTREE,		"dirtree" },
+	};
+	ssize_t				ret;
+
+	ret = xfs_healthmon_format_mask(out, "structures", mask_strings,
+			event->imask);
+	if (ret < 0)
+		return ret;
+
+	ret = stdio_redirect_printf(out, false, "  \"inode\":      %llu,\n",
+			event->ino);
+	if (ret < 0)
+		return ret;
+	return stdio_redirect_printf(out, false, "  \"generation\": %u,\n",
+			event->gen);
+}
+
 /* Format an event into json. */
 STATIC int
 xfs_healthmon_format(
@@ -446,6 +821,21 @@ xfs_healthmon_format(
 	case XFS_HEALTHMON_MOUNT:
 		/* empty */
 		break;
+	case XFS_HEALTHMON_FS:
+		ret = xfs_healthmon_format_fs(out, event);
+		break;
+	case XFS_HEALTHMON_RT:
+		ret = xfs_healthmon_format_rt(out, event);
+		break;
+	case XFS_HEALTHMON_RTGROUP:
+		ret = xfs_healthmon_format_rtgroup(out, event);
+		break;
+	case XFS_HEALTHMON_AG:
+		ret = xfs_healthmon_format_ag(out, event);
+		break;
+	case XFS_HEALTHMON_INODE:
+		ret = xfs_healthmon_format_inode(out, event);
+		break;
 	}
 	if (ret < 0)
 		return ret;
@@ -551,22 +941,31 @@ xfs_healthmon_create(
 		hm->verbose = true;
 
 	xfs_shutdown_hook_enable();
+	xfs_health_hook_enable();
 
 	xfs_shutdown_hook_setup(&hm->shook, xfs_healthmon_shutdown_hook);
 	ret = xfs_shutdown_hook_add(mp, &hm->shook);
 	if (ret)
 		goto out_hooks;
 
-	ret = run_thread_with_stdout(&hm->thread, &xfs_healthmon_ops);
-	if (ret < 0)
+	xfs_health_hook_setup(&hm->hhook, xfs_healthmon_metadata_hook);
+	ret = xfs_health_hook_add(mp, &hm->hhook);
+	if (ret)
 		goto out_shutdown;
 
+	ret = run_thread_with_stdout(&hm->thread, &xfs_healthmon_ops);
+	if (ret < 0)
+		goto out_health;
+
 	trace_xfs_healthmon_create(mp, hmo->flags, hmo->format);
 
 	return ret;
+out_health:
+	xfs_health_hook_del(mp, &hm->hhook);
 out_shutdown:
 	xfs_shutdown_hook_del(mp, &hm->shook);
 out_hooks:
+	xfs_health_hook_disable();
 	xfs_shutdown_hook_disable();
 	mutex_destroy(&hm->lock);
 	xfs_healthmon_free_events(hm);
diff --git a/fs/xfs/xfs_healthmon.h b/fs/xfs/xfs_healthmon.h
index f67e2f1b8f947..e445a89decc57 100644
--- a/fs/xfs/xfs_healthmon.h
+++ b/fs/xfs/xfs_healthmon.h
@@ -11,10 +11,23 @@ enum xfs_healthmon_type {
 
 	/* filesystem shutdown */
 	XFS_HEALTHMON_SHUTDOWN,
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
+	XFS_HEALTHMON_RT,	/* realtime metadata */
+	XFS_HEALTHMON_AG,	/* allocation group metadata */
+	XFS_HEALTHMON_INODE,	/* inode metadata */
+	XFS_HEALTHMON_RTGROUP,	/* realtime group metadata */
 };
 
 struct xfs_healthmon_event {
@@ -30,6 +43,24 @@ struct xfs_healthmon_event {
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
index 54e3d6d549ec1..2f296ba1db822 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5949,6 +5949,72 @@ TRACE_EVENT(xfs_healthmon_shutdown_hook,
 		  __entry->lost_prev)
 );
 
+#define XFS_HEALTHUP_TYPE_STRINGS \
+	{ XFS_HEALTHUP_UNMOUNT,		"unmount" }, \
+	{ XFS_HEALTHUP_SICK,		"sick" }, \
+	{ XFS_HEALTHUP_CORRUPT,		"corrupt" }, \
+	{ XFS_HEALTHUP_HEALTHY,		"healthy" }
+
+#define XFS_HEALTHUP_DOMAIN_STRINGS \
+	{ XFS_HEALTHUP_FS,		"fs" }, \
+	{ XFS_HEALTHUP_RT,		"realtime" }, \
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
+TRACE_DEFINE_ENUM(XFS_HEALTHUP_RT);
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
+
 DECLARE_EVENT_CLASS(xfs_healthmon_class,
 	TP_PROTO(const struct xfs_mount *mp, unsigned int events, bool lost_prev),
 	TP_ARGS(mp, events, lost_prev),
@@ -5979,15 +6045,33 @@ DEFINE_HEALTHMON_EVENT(xfs_healthmon_unmount);
 
 #define XFS_HEALTHMON_TYPE_STRINGS \
 	{ XFS_HEALTHMON_LOST,		"lost" }, \
-	{ XFS_HEALTHMON_SHUTDOWN,	"shutdown" }
+	{ XFS_HEALTHMON_SHUTDOWN,	"shutdown" }, \
+	{ XFS_HEALTHMON_UNMOUNT,	"unmount" }, \
+	{ XFS_HEALTHMON_SICK,		"sick" }, \
+	{ XFS_HEALTHMON_CORRUPT,	"corrupt" }, \
+	{ XFS_HEALTHMON_HEALTHY,	"healthy" }
 
 #define XFS_HEALTHMON_DOMAIN_STRINGS \
-	{ XFS_HEALTHMON_MOUNT,		"mount" }
+	{ XFS_HEALTHMON_MOUNT,		"mount" }, \
+	{ XFS_HEALTHMON_FS,		"fs" }, \
+	{ XFS_HEALTHMON_RT,		"realtime" }, \
+	{ XFS_HEALTHMON_AG,		"ag" }, \
+	{ XFS_HEALTHMON_INODE,		"inode" }, \
+	{ XFS_HEALTHMON_RTGROUP,	"rtgroup" }
 
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_LOST);
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_SHUTDOWN);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_UNMOUNT);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_SICK);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_CORRUPT);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_HEALTHY);
 
 TRACE_DEFINE_ENUM(XFS_HEALTHMON_MOUNT);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_FS);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_RT);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_AG);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_INODE);
+TRACE_DEFINE_ENUM(XFS_HEALTHMON_RTGROUP);
 
 DECLARE_EVENT_CLASS(xfs_healthmon_event_class,
 	TP_PROTO(const struct xfs_mount *mp, const struct xfs_healthmon_event *event),
@@ -6009,6 +6093,20 @@ DECLARE_EVENT_CLASS(xfs_healthmon_event_class,
 		case XFS_HEALTHMON_MOUNT:
 			__entry->mask = event->flags;
 			break;
+		case XFS_HEALTHMON_FS:
+		case XFS_HEALTHMON_RT:
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

