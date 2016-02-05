Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2A82E7CAB
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 19:23:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C0679AC004
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 17:23:39 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	QGrA5EFb8WRjrATb for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 17:23:36 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRV7T-0000Wt-3m
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 12:23:31 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRV7T-0005tZ-2v
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 12:23:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/9] xfs: add configuration of error failure speed
Date: Fri,  5 Feb 2016 12:23:23 +1100
Message-Id: <1454635407-22276-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1454635407-22276-1-git-send-email-david@fromorbit.com>
References: <1454635407-22276-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

On reception of an error, we can fail immediately, perform some
bound amount of retries or retry indefinitely. The current behaviour
we have is to retry forever.

However, we'd like the ability to choose what behaviour we have, and
that requires the ability to configure the behaviour through the new
sysfs interfaces. Add configuration options for fail fast, slow or
never to reflect the three choices above. Fail fast or fail never
don't require any other options, but "fail slow" needs configuration
to bound the retry behaviour. Add both a maximum retry count and a
retry timeout so that we can bound by time and/or physical IO
attempts.

Finally, plumb these into xfs_buf_iodone error processing so that
the error behaviour follows the selected configuration.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.h      |  23 ++++++++-
 fs/xfs/xfs_buf_item.c |  22 ++++++++-
 fs/xfs/xfs_mount.h    |   2 +
 fs/xfs/xfs_sysfs.c    | 128 ++++++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 169 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index ad16a1e..1edbe3c 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -183,7 +183,28 @@ typedef struct xfs_buf {
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
+	 * means that we can change the retry timeout and it on the next error
+	 * it will be checked against the newly configured timeout. This
+	 * prevents buffers getting stuck in retry loops with a really long
+	 * timeout.
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
index 68e34d1..7afd4d5 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -970,6 +970,9 @@ xfs_buf_iodone_callback_error(
 		bp->b_flags |= (XBF_WRITE | XBF_ASYNC |
 			        XBF_DONE | XBF_WRITE_FAIL);
 		bp->b_last_error = bp->b_error;
+		bp->b_retries = 0;
+		bp->b_first_retry_time = jiffies;
+
 		xfs_buf_ioerror(bp, 0);
 		xfs_buf_submit(bp);
 		return true;
@@ -979,9 +982,25 @@ xfs_buf_iodone_callback_error(
 	 * Repeated failure on an async write. Take action according to the
 	 * error configuration we have been set up to use.
 	 */
-	if (cfg->fail_speed == XFS_ERR_FAIL_FAST)
+	switch (cfg->fail_speed) {
+	case XFS_ERR_FAIL_FAST:
 		goto permanent_error;
 
+	case XFS_ERR_FAIL_SLOW:
+		if (++bp->b_retries > cfg->max_retries)
+			goto permanent_error;
+		if (!cfg->retry_timeout)
+			break;
+		if (time_after(jiffies,
+			       cfg->retry_timeout + bp->b_first_retry_time))
+			goto permanent_error;
+		break;
+
+	case XFS_ERR_FAIL_NEVER:
+	default:
+		break;
+	}
+
 	/* still a transient error, higher layers will retry */
 	xfs_buf_ioerror(bp, 0);
 	xfs_buf_relse(bp);
@@ -1023,6 +1042,7 @@ xfs_buf_iodone_callbacks(
 	 * retry state here in preparation for the next error that may occur.
 	 */
 	bp->b_last_error = 0;
+	bp->b_retries = 0;
 
 	xfs_buf_do_callbacks(bp);
 	bp->b_fspriv = NULL;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 9a61f39..2a3d178 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -62,6 +62,8 @@ enum {
 struct xfs_error_cfg {
 	struct xfs_kobj	kobj;
 	int		fail_speed;
+	int		max_retries;	/* INT_MAX = retry forever */
+	unsigned long	retry_timeout;	/* in jiffies, 0 = no timeout */
 };
 
 typedef struct xfs_mount {
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 27487ce..51d9fa7 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -319,10 +319,6 @@ struct kobj_type xfs_log_ktype = {
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
@@ -330,6 +326,123 @@ to_error_cfg(struct kobject *kobject)
 	return container_of(kobj, struct xfs_error_cfg, kobj);
 }
 
+static ssize_t
+failure_speed_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
+
+	if (cfg->fail_speed == XFS_ERR_FAIL_FAST)
+		return snprintf(buf, PAGE_SIZE, "[fast] slow never\n");
+	if (cfg->fail_speed == XFS_ERR_FAIL_SLOW)
+		return snprintf(buf, PAGE_SIZE, "fast [slow] never\n");
+	return snprintf(buf, PAGE_SIZE, "fast slow [never]\n");
+}
+
+static ssize_t
+failure_speed_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
+	char		*str = kstrdup(buf, GFP_KERNEL);
+	char		*sp;
+	int		len;
+
+	if (!str)
+		return -ENOMEM;
+
+	sp = strstrip(str);
+	len = strlen(sp);
+	if (strncmp(sp, "fast", len) == 0)
+		cfg->fail_speed = XFS_ERR_FAIL_FAST;
+	else if (strncmp(sp, "slow", len) == 0)
+		cfg->fail_speed = XFS_ERR_FAIL_SLOW;
+	else if (strncmp(sp, "never", len) == 0)
+		cfg->fail_speed = XFS_ERR_FAIL_NEVER;
+	else
+		count = -EINVAL;
+	kfree(str);
+	return count;
+}
+XFS_SYSFS_ATTR_RW(failure_speed);
+
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
+	if (val < 0 || val > INT_MAX)
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
+			jiffies_to_msecs(cfg->retry_timeout) * MSEC_PER_SEC);
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
+	ATTR_LIST(failure_speed),
+	ATTR_LIST(max_retries),
+	ATTR_LIST(retry_timeout_seconds),
+	NULL,
+};
+
+
 struct kobj_type xfs_error_cfg_ktype = {
 	.release = xfs_sysfs_release,
 	.sysfs_ops = &xfs_sysfs_ops,
@@ -349,11 +462,15 @@ struct kobj_type xfs_error_ktype = {
 struct xfs_error_init {
 	char		*name;
 	int		fail_speed;
+	int		max_retries;
+	int		retry_timeout;	/* in seconds */
 };
 
 static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
 	{ .name = "Default",
 	  .fail_speed = XFS_ERR_FAIL_NEVER,
+	  .max_retries = INT_MAX,
+	  .retry_timeout = 0,
 	},
 };
 
@@ -384,6 +501,9 @@ xfs_error_sysfs_init_class(
 			goto out_error;
 
 		cfg->fail_speed = init[i].fail_speed;
+		cfg->max_retries = init[i].max_retries;
+		cfg->retry_timeout = msecs_to_jiffies(
+					init[i].retry_timeout * MSEC_PER_SEC);
 	}
 	return 0;
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
