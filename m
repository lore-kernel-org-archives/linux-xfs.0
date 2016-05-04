Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04E377CB8
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 10:43:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 953078F8037
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 08:43:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uAVeDo9Mi9V7poZi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 04 May 2016 08:43:34 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 227393B725
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 15:43:34 +0000 (UTC)
Received: from zion.usersys.redhat.com (unused [10.10.50.11] (may be forged))
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u44FhPoL012561
	for <xfs@oss.sgi.com>; Wed, 4 May 2016 11:43:33 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 7/7] xfs: add "fail at unmount" error handling configuration
Date: Wed,  4 May 2016 17:43:20 +0200
Message-Id: <1462376600-8617-8-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1462376600-8617-1-git-send-email-cmaiolino@redhat.com>
References: <1462376600-8617-1-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

If we take "retry forever" literally on metadata IO errors, we can
hang at unmount, once it retries those writes forever. This is the
default behavior, unfortunately.

Add an error configuration option for this behavior and default it to "fail" so
that an unmount will trigger actuall errors, a shutdown and allow the unmount to
succeed. It will be noisy, though, as it will log the errors and shutdown that
occurs.

To fix this, we need to mark the filesystem as being in the process of
unmounting. Do this with a mount flag that is added at the appropriate time
(i.e. before the blocking AIL sync). We also need to add this flag if mount
fails after the initial phase of log recovery has been run.

Changelog:

V3:
	- No major changes have been done to this patch, only the ones needed to
	  accomodate it on top of the remaining patches

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf_item.c |  4 ++++
 fs/xfs/xfs_mount.c    |  9 +++++++++
 fs/xfs/xfs_mount.h    |  2 ++
 fs/xfs/xfs_sysfs.c    | 38 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 53 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 6fe6852..c37f118 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1105,6 +1105,10 @@ xfs_buf_iodone_callback_error(
 	    time_after(jiffies, cfg->retry_timeout + bp->b_first_retry_time))
 			goto permanent_error;
 
+	/* At unmount we may treat errors differently */
+	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && cfg->fail_at_unmount)
+		goto permanent_error;
+
 	/* still a transient error, higher layers will retry */
 	xfs_buf_ioerror(bp, 0);
 	xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index eda3906..d89fba6 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -961,6 +961,7 @@ xfs_mountfs(
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	xfs_reclaim_inodes(mp, SYNC_WAIT);
  out_log_dealloc:
+	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 	xfs_log_mount_cancel(mp);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
@@ -1012,6 +1013,14 @@ xfs_unmountfs(
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
 	/*
+	 * We now need to tell the world we are unmounting. This will allow
+	 * us to detect that the filesystem is going away and we should error
+	 * out anything that we have been retrying in the background. This will
+	 * prevent neverending retries iin AIL pushing from hanging the unmount.
+	 */
+	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
+
+	/*
 	 * Flush all pending changes from the AIL.
 	 */
 	xfs_ail_push_all_sync(mp->m_ail);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e3b3267..86f4344 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -59,6 +59,7 @@ struct xfs_error_cfg {
 	struct xfs_kobj	kobj;
 	int		max_retries;	/* -1 = retry forever */
 	unsigned long	retry_timeout;	/* in jiffies, 0 = no timeout */
+	bool		fail_at_unmount;
 };
 
 typedef struct xfs_mount {
@@ -193,6 +194,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
 						   must be synchronous except
 						   for space allocations */
+#define XFS_MOUNT_UNMOUNTING	(1ULL << 1)	/* filesystem is unmounting */
 #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 1ed9033..ab27445 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -447,9 +447,42 @@ retry_timeout_seconds_store(
 }
 XFS_SYSFS_ATTR_RW(retry_timeout_seconds);
 
+static ssize_t
+fail_at_unmount_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+		struct xfs_error_cfg *cfg = to_error_cfg(kobject);
+
+		return snprintf(buf, PAGE_SIZE, "%d\n", cfg->fail_at_unmount);
+}
+
+static ssize_t
+fail_at_unmount_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
+	int		ret;
+	int		val;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val < 0 || val > 1)
+		return -EINVAL;
+
+	cfg->fail_at_unmount = val;
+	return count;
+}
+XFS_SYSFS_ATTR_RW(fail_at_unmount);
+
 static struct attribute *xfs_error_attrs[] = {
 	ATTR_LIST(max_retries),
 	ATTR_LIST(retry_timeout_seconds),
+	ATTR_LIST(fail_at_unmount),
 	NULL,
 };
 
@@ -474,20 +507,24 @@ struct xfs_error_init {
 	char		*name;
 	int		max_retries;
 	int		retry_timeout;	/* in seconds */
+	bool		fail_at_unmount;
 };
 
 static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
 	{ .name = "default",
 	  .max_retries = -1,
 	  .retry_timeout = 0,
+	  .fail_at_unmount = true,
 	},
 	{ .name = "EIO",
 	  .max_retries = -1,
 	  .retry_timeout = 0,
+	  .fail_at_unmount = true,
 	},
 	{ .name = "ENOSPC",
 	  .max_retries = -1,
 	  .retry_timeout = 0,
+	  .fail_at_unmount = true,
 	},
 	{ .name = "ENODEV",
 	  .max_retries = -1,
@@ -523,6 +560,7 @@ xfs_error_sysfs_init_class(
 		cfg->max_retries = init[i].max_retries;
 		cfg->retry_timeout = msecs_to_jiffies(
 					init[i].retry_timeout * MSEC_PER_SEC);
+		cfg->fail_at_unmount = init[i].fail_at_unmount;
 	}
 	return 0;
 
-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
