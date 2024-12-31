Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C2613FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688566; cv=none; b=M5PxPAycBBcycWWA36h7AWHRXmKPKvO1UPzhcdTkglpQ25RnkwefM9kYjlkEFI0m7c7LfX2ZEA/1Sv+srso7TS+GBwWJqMZQBpKkGwhsFujhDpbJQ4rxFhD2iTi3361GXTDgj6BB3Cp3fBj7PUO66VQdqpTNtSAXPcIvuXNkwwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688566; c=relaxed/simple;
	bh=OjrjrXMYMsSZjyJYAkD53PG0S+L3rwTy4p1KqEFeO5k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IW5NVBsizk2HHXjwBCAZLYlr6KWfAZwjD1klniq9Wayu4PVxdmP7WNn+wFqlSPwll6ol3swwrZEjBy+W2oc+ZeFdb0GwhPgXZNOg43yrslgJjvlMbp3BJbss0mI3yK9gXsKaCgXk9Bt+mKCrpDSgzH2HcAx5ZOfyahzoJI2onIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BVHeXgkK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BVHeXgkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40500C4CED2;
	Tue, 31 Dec 2024 23:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688566;
	bh=OjrjrXMYMsSZjyJYAkD53PG0S+L3rwTy4p1KqEFeO5k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BVHeXgkKVaBe8EFkCug4SMtEItESpimCu1Q3uhEPohZvQdgM3vP+TglAnkfQ9/4vK
	 uOKa39a0EMrDjRlN96+f1z1pANrrxylO/rhe8rCRf+fQ0Tyu7warX43WmqLK5jxKi9
	 fd0xy3bfolhlsiW5lRaypkkiVFuWtX8QUN4vyzqoxG1ZH1mMr2Y6gAZqkoBmmlojwr
	 lwvjtm2KIlG18vzGRL1R580xGbF4UOMLqwNmAEW/HPkO8BZc4+X0uTU5UG5SQcnZyO
	 YM+nw0k5zvYil+kpdH3VtK/zmxe2p8BjrhfmxghkqufkqT787lgMEaXCWo0Tgicx00
	 iNtktIKFHgCYg==
Date: Tue, 31 Dec 2024 15:42:45 -0800
Subject: [PATCH 15/16] xfs: add media error reporting ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568755003.2704911.1058228100772058099.stgit@frogsfrogsfrogs>
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

Add a new privileged ioctl so that xfs_scrub can report media errors to
the kernel for further processing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/Makefile             |    6 +----
 fs/xfs/libxfs/xfs_fs.h      |   15 ++++++++++++
 fs/xfs/xfs_healthmon.c      |    2 --
 fs/xfs/xfs_ioctl.c          |    3 ++
 fs/xfs/xfs_notify_failure.c |   53 ++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_notify_failure.h |    8 ++++++
 fs/xfs/xfs_trace.h          |    2 --
 7 files changed, 78 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 94a9dc7aa7a1d5..71e6512899da3a 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -99,6 +99,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_message.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
+				   xfs_notify_failure.o \
 				   xfs_pwork.o \
 				   xfs_reflink.o \
 				   xfs_stats.o \
@@ -149,11 +150,6 @@ xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
 xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
 xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
 
-# notify failure
-ifeq ($(CONFIG_MEMORY_FAILURE),y)
-xfs-$(CONFIG_FS_DAX)		+= xfs_notify_failure.o
-endif
-
 xfs-$(CONFIG_XFS_DRAIN_INTENTS)	+= xfs_drain.o
 xfs-$(CONFIG_XFS_LIVE_HOOKS)	+= xfs_hooks.o
 xfs-$(CONFIG_XFS_MEMORY_BUFS)	+= xfs_buf_mem.o
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d7404e6efd866d..32e552d40b1bf5 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -1115,6 +1115,20 @@ struct xfs_health_monitor {
 /* Return events in JSON format */
 #define XFS_HEALTH_MONITOR_FMT_JSON	(1)
 
+struct xfs_media_error {
+	__u64	flags;		/* flags */
+	__u64	daddr;		/* disk address of range */
+	__u64	bbcount;	/* length, in 512b blocks */
+	__u64	pad;		/* zero */
+};
+
+#define XFS_MEDIA_ERROR_DATADEV	(1)	/* data device */
+#define XFS_MEDIA_ERROR_LOGDEV	(2)	/* external log device */
+#define XFS_MEDIA_ERROR_RTDEV	(3)	/* realtime device */
+
+/* bottom byte of flags is the device code */
+#define XFS_MEDIA_ERROR_DEVMASK	(0xFF)
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -1157,6 +1171,7 @@ struct xfs_health_monitor {
 #define XFS_IOC_GETFSREFCOUNTS	_IOWR('X', 66, struct xfs_getfsrefs_head)
 #define XFS_IOC_MAP_FREESP	_IOW ('X', 67, struct xfs_map_freesp)
 #define XFS_IOC_HEALTH_MONITOR	_IOW ('X', 68, struct xfs_health_monitor)
+#define XFS_IOC_MEDIA_ERROR	_IOW ('X', 69, struct xfs_media_error)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 67f7d4a8cc7f58..b6fdad798fae89 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -429,7 +429,6 @@ xfs_healthmon_shutdown_hook(
 	return NOTIFY_DONE;
 }
 
-#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_FS_DAX)
 /* Add a media error event to the reporting queue. */
 STATIC int
 xfs_healthmon_media_error_hook(
@@ -480,7 +479,6 @@ xfs_healthmon_media_error_hook(
 	mutex_unlock(&hm->lock);
 	return NOTIFY_DONE;
 }
-#endif
 
 /* Add a file io error event to the reporting queue. */
 STATIC int
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6c7a30128c7bf6..c253538c48f3b3 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -43,6 +43,7 @@
 #include "xfs_handle.h"
 #include "xfs_rtgroup.h"
 #include "xfs_healthmon.h"
+#include "xfs_notify_failure.h"
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
@@ -1437,6 +1438,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_HEALTH_MONITOR:
 		return xfs_ioc_health_monitor(mp, arg);
+	case XFS_IOC_MEDIA_ERROR:
+		return xfs_ioc_media_error(mp, arg);
 
 	default:
 		return -ENOTTY;
diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index ea68c7e61bb585..fcf9f0139d673c 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -91,9 +91,19 @@ xfs_media_error_hook_setup(
 	xfs_hook_setup(&hook->error_hook, mod_fn);
 }
 #else
-# define xfs_media_error_hook(...)		((void)0)
+static inline void
+xfs_media_error_hook(
+	struct xfs_mount		*mp,
+	enum xfs_failed_device		fdev,
+	xfs_daddr_t			daddr,
+	uint64_t			bbcount,
+	bool				pre_remove)
+{
+	/* empty */
+}
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
+#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_FS_DAX)
 struct xfs_failure_info {
 	xfs_agblock_t		startblock;
 	xfs_extlen_t		blockcount;
@@ -463,3 +473,44 @@ xfs_dax_notify_failure(
 const struct dax_holder_operations xfs_dax_holder_operations = {
 	.notify_failure		= xfs_dax_notify_failure,
 };
+#endif /* CONFIG_MEMORY_FAILURE && CONFIG_FS_DAX */
+
+#define XFS_VALID_MEDIA_ERROR_FLAGS	(XFS_MEDIA_ERROR_DATADEV | \
+					 XFS_MEDIA_ERROR_LOGDEV | \
+					 XFS_MEDIA_ERROR_RTDEV)
+int
+xfs_ioc_media_error(
+	struct xfs_mount		*mp,
+	struct xfs_media_error __user	*arg)
+{
+	struct xfs_media_error		me;
+	enum xfs_failed_device		fdev;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&me, arg, sizeof(me)))
+		return -EFAULT;
+
+	if (me.pad)
+		return -EINVAL;
+	if (me.flags & ~XFS_VALID_MEDIA_ERROR_FLAGS)
+		return -EINVAL;
+
+	switch (me.flags & XFS_MEDIA_ERROR_DEVMASK) {
+	case XFS_MEDIA_ERROR_DATADEV:
+		fdev = XFS_FAILED_DATADEV;
+		break;
+	case XFS_MEDIA_ERROR_LOGDEV:
+		fdev = XFS_FAILED_LOGDEV;
+		break;
+	case XFS_MEDIA_ERROR_RTDEV:
+		fdev = XFS_FAILED_RTDEV;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	xfs_media_error_hook(mp, fdev, me.daddr, me.bbcount, false);
+	return 0;
+}
diff --git a/fs/xfs/xfs_notify_failure.h b/fs/xfs/xfs_notify_failure.h
index 835d4af504d832..c23034891d99fd 100644
--- a/fs/xfs/xfs_notify_failure.h
+++ b/fs/xfs/xfs_notify_failure.h
@@ -6,7 +6,9 @@
 #ifndef __XFS_NOTIFY_FAILURE_H__
 #define __XFS_NOTIFY_FAILURE_H__
 
+#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_FS_DAX)
 extern const struct dax_holder_operations xfs_dax_holder_operations;
+#endif
 
 enum xfs_failed_device {
 	XFS_FAILED_DATADEV,
@@ -14,7 +16,7 @@ enum xfs_failed_device {
 	XFS_FAILED_RTDEV,
 };
 
-#if defined(CONFIG_XFS_LIVE_HOOKS) && defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_FS_DAX)
+#if defined(CONFIG_XFS_LIVE_HOOKS)
 struct xfs_media_error_params {
 	struct xfs_mount		*mp;
 	enum xfs_failed_device		fdev;
@@ -46,4 +48,8 @@ struct xfs_media_error_hook { };
 # define xfs_media_error_hook_setup(...)	((void)0)
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
+struct xfs_media_error;
+int xfs_ioc_media_error(struct xfs_mount *mp,
+		struct xfs_media_error __user *arg);
+
 #endif /* __XFS_NOTIFY_FAILURE_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index aba32f5ccc1a3b..3baa39a2b0a8b8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -6348,7 +6348,6 @@ TRACE_EVENT(xfs_healthmon_metadata_hook,
 		  __entry->lost_prev)
 );
 
-#if defined(CONFIG_XFS_LIVE_HOOKS) && defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_FS_DAX)
 TRACE_EVENT(xfs_healthmon_media_error_hook,
 	TP_PROTO(const struct xfs_media_error_params *p,
 		 unsigned int events, bool lost_prev),
@@ -6396,7 +6395,6 @@ TRACE_EVENT(xfs_healthmon_media_error_hook,
 		  __entry->events,
 		  __entry->lost_prev)
 );
-#endif
 
 #define XFS_FILE_IOERROR_STRINGS \
 	{ XFS_FILE_IOERROR_BUFFERED_READ,	"readahead" }, \

