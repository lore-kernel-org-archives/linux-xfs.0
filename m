Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5A9CC7CBF
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 14:21:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D427304043
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 12:21:19 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Dh6kYes00vTKUiAo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Nov 2015 12:21:18 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 2230AC0AEE57
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 20:21:18 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-67.bos.redhat.com [10.18.41.67])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tA9KLHGA031583
	for <xfs@oss.sgi.com>; Mon, 9 Nov 2015 15:21:17 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 8/8] xfs: debug mode log recovery crc error injection
Date: Mon,  9 Nov 2015 15:21:15 -0500
Message-Id: <1447100475-33465-9-git-send-email-bfoster@redhat.com>
In-Reply-To: <1447100475-33465-1-git-send-email-bfoster@redhat.com>
References: <1447100475-33465-1-git-send-email-bfoster@redhat.com>
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

XFS now uses CRC verification over a limited section of the log to
detect torn writes prior to a crash. This is difficult to test directly
due to the timing and hardware requirements to cause a short write.

Add a DEBUG mode error injection mechanism to facilitate testing torn
write detection. The mechanism injects CRC errors for random records in
the range of the log that is scanned for torn writes. Corruptions are
simulated in-core only and not generated on-disk. However, the
subsequent log head truncation and partial recovery can and will cause
permanent data loss. Further, error injection is global in nature and
will inject errors even when the log is clean to allow for test coverage
for torn writes of unmount records.

This option is dangerous and is for development and testing purposes
only. Error injection can be enabled and disabled via:

	/sys/fs/xfs/debug/log_recovery_crc_fail

... on CONFIG_XFS_DEBUG enabled kernels only.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_globals.c     |  1 +
 fs/xfs/xfs_log_recover.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_sysctl.h      |  1 +
 fs/xfs/xfs_sysfs.c       | 31 ++++++++++++++++
 4 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 4d41b24..0f5a242 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -46,4 +46,5 @@ xfs_param_t xfs_params = {
 
 struct xfs_globals xfs_globals = {
 	.log_recovery_delay	=	0,	/* no delay by default */
+	.log_recovery_crc_fail	=	0,	/* error injection default */
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 83fd7ca..eb088d2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1078,6 +1078,82 @@ out:
 }
 
 /*
+ * Inject log record CRC failures during recovery. This facilitates testing of
+ * the recovery mechanism for short writes to the log in the event of a crash.
+ *
+ * Note that this is dangerous and for development and testing purposes only.
+ * This can only be enabled via the DEBUG mode log_recovery_crc_fail sysfs
+ * option.
+ */
+STATIC int
+xlog_debug_crc_failure(
+	struct xlog		*log,
+	xfs_daddr_t		head_blk,
+	xfs_daddr_t		tail_blk,
+	int			total,
+	xfs_daddr_t		*first_bad)
+{
+	struct xlog_rec_header	*tmp_rhead;
+	struct xfs_buf		*tmp_bp;
+	xfs_daddr_t		tmp_rhead_blk;
+	int			found;
+	int			badcnt;
+	bool			tmp_wrapped;
+
+	ASSERT(xfs_globals.log_recovery_crc_fail);
+
+	/*
+	 * In practice, a clean log ends with an unmount record with a tail_lsn
+	 * that points to the previous record. The reverse scan from the head
+	 * block thus finds two record headers (e.g., total == 2). This means
+	 * that errors are injected even after clean unmounts in order to
+	 * simulate torn writes of unmount records.
+	 *
+	 * Note: increase this value to 3 or larger to prevent error injection
+	 * on clean mounts.
+	 */
+	if (total < 2)
+		return 0;
+
+	/*
+	 * Randomly determine which record to flag as corrupt.
+	 */
+	badcnt = prandom_u32() % total;
+	if (!badcnt)
+		return 0;
+
+	tmp_bp = xlog_get_bp(log, 1);
+	if (!tmp_bp)
+		return -ENOMEM;
+
+	/*
+	 * Locate the Nth record header block back from the head block. Set
+	 * first_bad to point to this record and return a CRC error to flag it
+	 * as corrupt.
+	 *
+	 * For example, suppose 8 records are written at the head of the log and
+	 * badcnt is set to 3. This locates the 3rd record back from the current
+	 * head block and calls it corrupt. In response, the log recovery CRC
+	 * error handling code truncates these last 3 records from the head,
+	 * verifies the new tail based on the truncated head and attempts
+	 * recovery up through the first 5 records.
+	 */
+	found = xlog_rseek_logrec_hdr(log, head_blk, tail_blk, badcnt, tmp_bp,
+				      &tmp_rhead_blk, &tmp_rhead, &tmp_wrapped);
+	xlog_put_bp(tmp_bp);
+	if (found < 0)
+		return found;
+	if (found != badcnt)
+		return 0;
+
+	xfs_warn(log->l_mp, "Generated CRC error at log block 0x%llx "
+		 "(%d bad records out of %d)", tmp_rhead_blk, badcnt, total);
+
+	*first_bad = tmp_rhead_blk;
+	return -EFSBADCRC;
+}
+
+/*
  * Detect and trim torn writes from the head of the log.
  *
  * Storage without sector atomicity guarantees can result in torn writes in the
@@ -1134,12 +1210,12 @@ xlog_verify_head(
 	tmp_bp = xlog_get_bp(log, 1);
 	if (!tmp_bp)
 		return -ENOMEM;
-	error = xlog_rseek_logrec_hdr(log, *head_blk, *tail_blk,
+	found = xlog_rseek_logrec_hdr(log, *head_blk, *tail_blk,
 				      XLOG_MAX_ICLOGS, tmp_bp, &tmp_rhead_blk,
 				      &tmp_rhead, &tmp_wrapped);
 	xlog_put_bp(tmp_bp);
-	if (error < 0)
-		return error;
+	if (found < 0)
+		return found;
 
 	/*
 	 * Now run a CRC verification pass over the records starting at the
@@ -1148,6 +1224,16 @@ xlog_verify_head(
 	 */
 	error = xlog_do_recovery_pass(log, *head_blk, tmp_rhead_blk,
 				      XLOG_RECOVER_CRCPASS, &first_bad);
+
+	/*
+	 * Run DEBUG mode CRC error injection if it is enabled and we haven't
+	 * legitimately failed. XXX: This is dangerous! For testing purposes
+	 * only!
+	 */
+	if (!error && xfs_globals.log_recovery_crc_fail)
+		error = xlog_debug_crc_failure(log, *head_blk, tmp_rhead_blk,
+					       found, &first_bad);
+
 	if (error == -EFSBADCRC && first_bad != *tail_blk) {
 		/*
 		 * We've hit a potential torn write. Reset the error and warn
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index ffef453..54a6f53 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -94,6 +94,7 @@ extern xfs_param_t	xfs_params;
 
 struct xfs_globals {
 	int	log_recovery_delay;	/* log recovery delay (secs) */
+	int	log_recovery_crc_fail;	/* generate log crc errors */
 };
 extern struct xfs_globals	xfs_globals;
 
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index ee70f5d..ab0c01b 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -116,8 +116,39 @@ log_recovery_delay_show(
 }
 XFS_SYSFS_ATTR_RW(log_recovery_delay);
 
+STATIC ssize_t
+log_recovery_crc_fail_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
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
+	xfs_globals.log_recovery_crc_fail = val;
+
+	return count;
+}
+
+STATIC ssize_t
+log_recovery_crc_fail_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.log_recovery_crc_fail);
+}
+XFS_SYSFS_ATTR_RW(log_recovery_crc_fail);
+
 static struct attribute *xfs_dbg_attrs[] = {
 	ATTR_LIST(log_recovery_delay),
+	ATTR_LIST(log_recovery_crc_fail),
 	NULL,
 };
 
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
