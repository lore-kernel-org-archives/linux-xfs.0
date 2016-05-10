Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 103F77CC7
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 07:16:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B9B4B8F804B
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 05:16:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id P02TyMFd71Goyjeu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 May 2016 05:16:29 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 94B5EC05B1C7
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 12:16:29 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4ACGOul016940
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 08:16:28 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 5/7] xfs: add configuration of error failure speed
Date: Tue, 10 May 2016 14:16:19 +0200
Message-Id: <1462882581-30859-6-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1462882581-30859-1-git-send-email-cmaiolino@redhat.com>
References: <1462882581-30859-1-git-send-email-cmaiolino@redhat.com>
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

On reception of an error, we can fail immediately, perform some
bound amount of retries or retry indefinitely. The current behaviour
we have is to retry forever.

However, we'd like the ability to choose how long the filesystem should try
after an error, it can either fail immediately, retry a few times, or retry
forever. This is implemented by using max_retries sysfs attribute, to hold the
amount of times we allow the filesystem to retry after an error. Being -1 a
special case where the filesystem will retry indefinitely.

Add both a maximum retry count and a retry timeout so that we can bound by
time and/or physical IO attempts.

Finally, plumb these into xfs_buf_iodone error processing so that
the error behaviour follows the selected configuration.

Changelog:

V3:
	- In xfs_buf_iodone_callback_error, use max_retries to decide how long
	  the filesystem should retry on errors instead of XFS_ERR_FAIL enums
	  and fail_speed

	- Remove all code implementing fail_speed attribute from the original
	  patch
		-- failure_speed_show/store attributes function implementation
		-- max_retries_store() now accepts values from -1 up to INT_MAX

	- retry_timeout_seconds_show() print fixed:
		-- jiffies_to_msecs() should be divided by MSEC_PER_SEC
		-- trailing whitespace removed

V4:
	- Add XFS_ERR_RETRY_FOREVER flag, to avoid a -1 magic number
	- Reword xfs_buf comment according Brian's suggestion
	- Remove pointless check for val > INT_MAX


Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf.h      | 21 ++++++++++++-
 fs/xfs/xfs_buf_item.c | 13 +++++++--
 fs/xfs/xfs_mount.h    |  3 ++
 fs/xfs/xfs_sysfs.c    | 81 ++++++++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 111 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index adef116..8bfb974 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -183,7 +183,26 @@ typedef struct xfs_buf {
 	unsigned int		b_page_count;	/* size of page array */
 	unsigned int		b_offset;	/* page offset in first page */
 	int			b_error;	/* error code on I/O */
-	int			b_last_error;	/* previous async I/O error */
+
+	/*
+	 * async write failure retry count. Initialised to zero on the first
+	 * failure, then when it exceeds the maximum configured without a
+	 * success the write is considered to be failed permanently and the
+	 * iodone handler will take appropriate action.
+	 *
+	 * For retry timeouts, we record the jiffie of the first failure. This
+	 * means that we can change the retry timeout for buffers already under
+	 * I/O and thus avoid getting stuck in a retry loop with a long timeout.
+	 *
+	 * last_error is used to ensure that we are getting repeated errors, not
+	 * different errors. e.g. a block device might change ENOSPC to EIO when
+	 * a failure timeout occurs, so we want to re-initialise the error
+	 * retry behaviour appropriately when that happens.
+	 */
+	int			b_retries;
+	unsigned long		b_first_retry_time; /* in jiffies */
+	int			b_last_error;
+
 	const struct xfs_buf_ops	*b_ops;
 
 #ifdef XFS_BUF_LOCK_TRACKING
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index b8d0cd4..0d95c59 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1085,6 +1085,9 @@ xfs_buf_iodone_callback_error(
 		bp->b_flags |= (XBF_WRITE | XBF_ASYNC |
 			        XBF_DONE | XBF_WRITE_FAIL);
 		bp->b_last_error = bp->b_error;
+		bp->b_retries = 0;
+		bp->b_first_retry_time = jiffies;
+
 		xfs_buf_ioerror(bp, 0);
 		xfs_buf_submit(bp);
 		return true;
@@ -1095,8 +1098,13 @@ xfs_buf_iodone_callback_error(
 	 * error configuration we have been set up to use.
 	 */
 	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
-	if (!cfg->max_retries)
-		goto permanent_error;
+
+	if (cfg->max_retries != XFS_ERR_RETRY_FOREVER &&
+	    ++bp->b_retries > cfg->max_retries)
+			goto permanent_error;
+	if (cfg->retry_timeout &&
+	    time_after(jiffies, cfg->retry_timeout + bp->b_first_retry_time))
+			goto permanent_error;
 
 	/* still a transient error, higher layers will retry */
 	xfs_buf_ioerror(bp, 0);
@@ -1139,6 +1147,7 @@ xfs_buf_iodone_callbacks(
 	 * retry state here in preparation for the next error that may occur.
 	 */
 	bp->b_last_error = 0;
+	bp->b_retries = 0;
 
 	xfs_buf_do_callbacks(bp);
 	bp->b_fspriv = NULL;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 0c5a976..2fafa94 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -52,9 +52,12 @@ enum {
 	XFS_ERR_ERRNO_MAX,
 };
 
+#define XFS_ERR_RETRY_FOREVER	-1
+
 struct xfs_error_cfg {
 	struct xfs_kobj	kobj;
 	int		max_retries;
+	unsigned long	retry_timeout;	/* in jiffies, 0 = no timeout */
 };
 
 typedef struct xfs_mount {
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 71046d9..918d144 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -374,10 +374,6 @@ struct kobj_type xfs_log_ktype = {
  * and any other future type of IO (e.g. special inode or directory error
  * handling) we care to support.
  */
-static struct attribute *xfs_error_attrs[] = {
-	NULL,
-};
-
 static inline struct xfs_error_cfg *
 to_error_cfg(struct kobject *kobject)
 {
@@ -385,6 +381,79 @@ to_error_cfg(struct kobject *kobject)
 	return container_of(kobj, struct xfs_error_cfg, kobj);
 }
 
+static ssize_t
+max_retries_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", cfg->max_retries);
+}
+
+static ssize_t
+max_retries_store(
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
+	if (val < -1)
+		return -EINVAL;
+
+	cfg->max_retries = val;
+	return count;
+}
+XFS_SYSFS_ATTR_RW(max_retries);
+
+static ssize_t
+retry_timeout_seconds_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
+
+	return snprintf(buf, PAGE_SIZE, "%ld\n",
+			jiffies_to_msecs(cfg->retry_timeout) / MSEC_PER_SEC);
+}
+
+static ssize_t
+retry_timeout_seconds_store(
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
+	/* 1 day timeout maximum */
+	if (val < 0 || val > 86400)
+		return -EINVAL;
+
+	cfg->retry_timeout = msecs_to_jiffies(val * MSEC_PER_SEC);
+	return count;
+}
+XFS_SYSFS_ATTR_RW(retry_timeout_seconds);
+
+static struct attribute *xfs_error_attrs[] = {
+	ATTR_LIST(max_retries),
+	ATTR_LIST(retry_timeout_seconds),
+	NULL,
+};
+
+
 struct kobj_type xfs_error_cfg_ktype = {
 	.release = xfs_sysfs_release,
 	.sysfs_ops = &xfs_sysfs_ops,
@@ -404,11 +473,13 @@ struct kobj_type xfs_error_ktype = {
 struct xfs_error_init {
 	char		*name;
 	int		max_retries;
+	int		retry_timeout;	/* in seconds */
 };
 
 static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
 	{ .name = "default",
 	  .max_retries = -1,
+	  .retry_timeout = 0,
 	},
 };
 
@@ -439,6 +510,8 @@ xfs_error_sysfs_init_class(
 			goto out_error;
 
 		cfg->max_retries = init[i].max_retries;
+		cfg->retry_timeout = msecs_to_jiffies(
+					init[i].retry_timeout * MSEC_PER_SEC);
 	}
 	return 0;
 
-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
