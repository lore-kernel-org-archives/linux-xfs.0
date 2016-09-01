Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C639D7CA2
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 10:50:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1FB9DAC001
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 08:50:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7cTDDNcYw3dq0OKD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 01 Sep 2016 08:50:06 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 2062B7F767
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 15:50:06 +0000 (UTC)
Received: from [IPv6:::1] (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u81Fo5eo015771
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 1 Sep 2016 11:50:05 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: normalize "infinite" retries in error configs
Message-ID: <7d66af18-c861-54e3-d671-ef94a37ba7b7@redhat.com>
Date: Thu, 1 Sep 2016 10:50:05 -0500
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

As it stands today, the "fail immediately" vs. "retry forever"
values for max_retries and retry_timeout_seconds in the
xfs metadata error configurations are not consistent.

A retry_timeout_seconds of 0 means "retry forever," but a
max_retries of 0 means "fail immediately."

retry_timeout_seconds < 0 is disallowed, while
max_retries == -1 means "retry forever."

Make this consistent across the error configs, such that
a value of 0 means "fail immediately" (i.e. wait 0 seconds,
or retry 0 times), and a value of -1 always means "retry forever."

This makes retry_timeout a signed long to accommodate the -1,
even though it stores jiffies.  Given our limit of a 1 day
maximum timeout, this should be sufficient even at much
higher HZ values than we have available today.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I'm not super happy about making retry_timeout a signed long
to accommodate the -1, but it has to accept some special number.
Given our limit on a 1-day maximum retry, this should be enough
for a HZ value much higher than we have today, even on 32-bit
machines.  I threw an ASSERT in just to be sure.  But I'm open
to options if this seems nasty.

I've also explicitly made clear that a "-1" from the user-facing
interfaces in sysfs is special, and explicitly assign
XFS_ERR_RETRY_FOREVER if "-1" is received in the _store function,
rather than just assigning "val," to make things a bit more
obvious, and hopefuly future-proof if the internal 
XFS_ERR_RETRY_FOREVER number ever changes...


diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index e455f90..c58c952 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1095,7 +1095,8 @@ xfs_buf_iodone_callback_error(
 	     bp->b_last_error != bp->b_error) {
 		bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
 		bp->b_last_error = bp->b_error;
-		if (cfg->retry_timeout && !bp->b_first_retry_time)
+		if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
+		    !bp->b_first_retry_time)
 			bp->b_first_retry_time = jiffies;
 
 		xfs_buf_ioerror(bp, 0);
@@ -1111,7 +1112,7 @@ xfs_buf_iodone_callback_error(
 	if (cfg->max_retries != XFS_ERR_RETRY_FOREVER &&
 	    ++bp->b_retries > cfg->max_retries)
 			goto permanent_error;
-	if (cfg->retry_timeout &&
+	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
 	    time_after(jiffies, cfg->retry_timeout + bp->b_first_retry_time))
 			goto permanent_error;
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b36676c..e0d6f70 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -57,10 +57,16 @@ enum {
 
 #define XFS_ERR_RETRY_FOREVER	-1
 
+/*
+ * Although retry_timeout is in jiffies which is normally an unsigned long,
+ * we limit the retry timeout to 86400 seconds, or one day.  So even a
+ * signed 32-bit long is sufficient for a HZ value up to 24855.  Making it
+ * signed lets us store the special "-1" value, meaning retry forever.
+ */
 struct xfs_error_cfg {
 	struct xfs_kobj	kobj;
 	int		max_retries;
-	unsigned long	retry_timeout;	/* in jiffies, 0 = no timeout */
+	long		retry_timeout;	/* in jiffies, -1 = infinite */
 };
 
 typedef struct xfs_mount {
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 79cfd3f..5f8d55d 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -393,9 +393,15 @@ max_retries_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
+	int		retries;
 	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", cfg->max_retries);
+	if (cfg->retry_timeout == XFS_ERR_RETRY_FOREVER)
+		retries = -1;
+	else
+		retries = cfg->max_retries;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", retries);
 }
 
 static ssize_t
@@ -415,7 +421,10 @@ max_retries_store(
 	if (val < -1)
 		return -EINVAL;
 
-	cfg->max_retries = val;
+	if (val == -1)
+		cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
+	else
+		cfg->max_retries = val;
 	return count;
 }
 XFS_SYSFS_ATTR_RW(max_retries);
@@ -425,10 +434,15 @@ retry_timeout_seconds_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
+	int		timeout;
 	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
 
-	return snprintf(buf, PAGE_SIZE, "%ld\n",
-			jiffies_to_msecs(cfg->retry_timeout) / MSEC_PER_SEC);
+	if (cfg->retry_timeout == XFS_ERR_RETRY_FOREVER)
+		timeout = -1;
+	else
+		timeout = jiffies_to_msecs(cfg->retry_timeout) / MSEC_PER_SEC;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", timeout);
 }
 
 static ssize_t
@@ -445,11 +459,16 @@ retry_timeout_seconds_store(
 	if (ret)
 		return ret;
 
-	/* 1 day timeout maximum */
-	if (val < 0 || val > 86400)
+	/* 1 day timeout maximum, -1 means infinite */
+	if (val < -1 || val > 86400)
 		return -EINVAL;
 
-	cfg->retry_timeout = msecs_to_jiffies(val * MSEC_PER_SEC);
+	if (val == -1)
+		cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
+	else {
+		cfg->retry_timeout = msecs_to_jiffies(val * MSEC_PER_SEC);
+		ASSERT(msecs_to_jiffies(val * MSEC_PER_SEC) < LONG_MAX);
+	}
 	return count;
 }
 XFS_SYSFS_ATTR_RW(retry_timeout_seconds);
@@ -519,18 +538,19 @@ struct xfs_error_init {
 static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
 	{ .name = "default",
 	  .max_retries = XFS_ERR_RETRY_FOREVER,
-	  .retry_timeout = 0,
+	  .retry_timeout = XFS_ERR_RETRY_FOREVER,
 	},
 	{ .name = "EIO",
 	  .max_retries = XFS_ERR_RETRY_FOREVER,
-	  .retry_timeout = 0,
+	  .retry_timeout = XFS_ERR_RETRY_FOREVER,
 	},
 	{ .name = "ENOSPC",
 	  .max_retries = XFS_ERR_RETRY_FOREVER,
-	  .retry_timeout = 0,
+	  .retry_timeout = XFS_ERR_RETRY_FOREVER,
 	},
 	{ .name = "ENODEV",
-	  .max_retries = 0,
+	  .max_retries = 0,	/* We can't recover from devices disappearing */
+	  .retry_timeout = 0,
 	},
 };
 
@@ -561,7 +581,10 @@ xfs_error_sysfs_init_class(
 			goto out_error;
 
 		cfg->max_retries = init[i].max_retries;
-		cfg->retry_timeout = msecs_to_jiffies(
+		if (init[i].retry_timeout == XFS_ERR_RETRY_FOREVER)
+			cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
+		else
+			cfg->retry_timeout = msecs_to_jiffies(
 					init[i].retry_timeout * MSEC_PER_SEC);
 	}
 	return 0;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
