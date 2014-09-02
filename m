Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 55BAD7F5A
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 09:08:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 28EBD8F804C
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 07:08:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4b3Vflei9BiN6Rsa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Sep 2014 07:08:17 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s82E8Hw5024860
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 2 Sep 2014 10:08:17 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s82E8GQS024865
	for <xfs@oss.sgi.com>; Tue, 2 Sep 2014 10:08:16 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 2/2] xfs: export log_recovery_delay to delay mount time log
	recovery
Date: Tue,  2 Sep 2014 10:08:15 -0400
Message-Id: <1409666895-49799-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1409666895-49799-1-git-send-email-bfoster@redhat.com>
References: <1409666895-49799-1-git-send-email-bfoster@redhat.com>
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

XFS log recovery has been discovered to have race conditions with
buffers when I/O errors occur. External tools are available to simulate
I/O errors to XFS, but this alone is not sufficient for testing log
recovery. XFS unconditionally resets the inactive region of the log
prior to log recovery to avoid confusion over processing any partially
written log records that might have been written before an unclean
shutdown. Therefore, unconditional write I/O failures at mount time are
caught by the reset sequence rather than log recovery and hinder the
ability to test the latter.

The device-mapper dm-flakey module uses an up/down timer to define a
cycle for when to fail I/Os. Create a pre log recovery delay tunable
that can be used to coordinate XFS log recovery with I/O errors
simulated by dm-flakey. This facilitates coordination in userspace that
allows the reset of stale log blocks to succeed and writes due to log
recovery to fail. For example, define a dm-flakey instance with an
uptime long enough to allow log reset to succeed and a log recovery
delay long enough to allow the dm-flakey uptime to expire.

The 'log_recovery_delay' sysfs tunable is exported under
/sys/fs/xfs/debug and is only enabled for kernels compiled in XFS debug
mode. The value is exported in units of seconds and allows for a delay
of up to 60 seconds. Note that this is for XFS debug and test
instrumentation purposes only and should not be used by applications. No
delay is enabled by default.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_globals.c     |  4 ++++
 fs/xfs/xfs_log_recover.c | 12 ++++++++++++
 fs/xfs/xfs_sysctl.h      |  5 +++++
 fs/xfs/xfs_sysfs.c       | 31 +++++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+)

diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 5399ef2..4d41b24 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -43,3 +43,7 @@ xfs_param_t xfs_params = {
 	.fstrm_timer	= {	1,		30*100,		3600*100},
 	.eofb_timer	= {	1,		300,		3600*24},
 };
+
+struct xfs_globals xfs_globals = {
+	.log_recovery_delay	=	0,	/* no delay by default */
+};
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1fd5787..176c4b3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4509,6 +4509,18 @@ xlog_recover(
 			return -EINVAL;
 		}
 
+		/*
+		 * Delay log recovery if the debug hook is set. This is debug
+		 * instrumention to coordinate simulation of I/O failures with
+		 * log recovery.
+		 */
+		if (xfs_globals.log_recovery_delay) {
+			xfs_notice(log->l_mp,
+				"Delaying log recovery for %d seconds.",
+				xfs_globals.log_recovery_delay);
+			msleep(xfs_globals.log_recovery_delay * 1000);
+		}
+
 		xfs_notice(log->l_mp, "Starting recovery (logdev: %s)",
 				log->l_mp->m_logname ? log->l_mp->m_logname
 						     : "internal");
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index bd8e157..ffef453 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -92,6 +92,11 @@ enum {
 
 extern xfs_param_t	xfs_params;
 
+struct xfs_globals {
+	int	log_recovery_delay;	/* log recovery delay (secs) */
+};
+extern struct xfs_globals	xfs_globals;
+
 #ifdef CONFIG_SYSCTL
 extern int xfs_sysctl_register(void);
 extern void xfs_sysctl_unregister(void);
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 32ddf0c..aa03670 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -54,7 +54,38 @@ struct kobj_type xfs_mp_ktype = {
 #ifdef DEBUG
 /* debug */
 
+STATIC ssize_t
+log_recovery_delay_store(
+	const char	*buf,
+	size_t		count,
+	void		*data)
+{
+	int		ret;
+	int		val;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val < 0 || val > 60)
+		return -EINVAL;
+
+	xfs_globals.log_recovery_delay = val;
+
+	return count;
+}
+
+STATIC ssize_t
+log_recovery_delay_show(
+	char	*buf,
+	void	*data)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.log_recovery_delay);
+}
+XFS_SYSFS_ATTR_RW(log_recovery_delay);
+
 static struct attribute *xfs_dbg_attrs[] = {
+	ATTR_LIST(log_recovery_delay),
 	NULL,
 };
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
