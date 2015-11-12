Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 770D57F6C
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 09:37:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6295A304043
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 07:37:32 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MZ2h4Tlt06ST25aP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Nov 2015 07:37:30 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id ECD473D1EA
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 15:37:29 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-36.bos.redhat.com [10.18.41.36])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tACFbTlh003343
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 10:37:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 8/8] xfs: debug mode log record crc error injection
Date: Thu, 12 Nov 2015 10:37:28 -0500
Message-Id: <1447342648-40012-9-git-send-email-bfoster@redhat.com>
In-Reply-To: <1447342648-40012-1-git-send-email-bfoster@redhat.com>
References: <1447342648-40012-1-git-send-email-bfoster@redhat.com>
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

Add a mechanism to inject CRC errors into log records to facilitate
testing torn write detection during log recovery. This mechanism is
dangerous and can result in filesystem corruption. Thus, it is only
available in DEBUG mode for testing/development purposes. Set a non-zero
value to the following sysfs entry to enable error injection:

	/sys/fs/xfs/<dev>/log/log_badcrc_factor

Once enabled, XFS intentionally writes an invalid CRC to a log record at
some random point in the future based on the provided frequency. The
filesystem immediately shuts down once the record has been written to
the physical log to prevent metadata writeback (e.g., AIL insertion)
once the log write completes. This helps reasonably simulate a torn
write to the log as the affected record must be safe to discard. The
next mount after the intentional shutdown requires log recovery and
should detect and recover from the torn write.

Note again that this _will_ result in data loss or worse. For testing
and development purposes only!

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c      | 45 ++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_log_priv.h |  3 +++
 fs/xfs/xfs_sysfs.c    | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f52c72a..887c443 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1188,10 +1188,16 @@ xlog_iodone(xfs_buf_t *bp)
 	int			aborted = 0;
 
 	/*
-	 * Race to shutdown the filesystem if we see an error.
+	 * Race to shutdown the filesystem if we see an error or the iclog is in
+	 * IOABORT state. The IOABORT state is only set in DEBUG mode to inject
+	 * CRC errors into log recovery.
 	 */
-	if (XFS_TEST_ERROR(bp->b_error, l->l_mp,
-			XFS_ERRTAG_IODONE_IOERR, XFS_RANDOM_IODONE_IOERR)) {
+	if (XFS_TEST_ERROR(bp->b_error, l->l_mp, XFS_ERRTAG_IODONE_IOERR,
+			   XFS_RANDOM_IODONE_IOERR) ||
+	    iclog->ic_state & XLOG_STATE_IOABORT) {
+		if (iclog->ic_state & XLOG_STATE_IOABORT)
+			iclog->ic_state &= ~XLOG_STATE_IOABORT;
+
 		xfs_buf_ioerror_alert(bp, __func__);
 		xfs_buf_stale(bp);
 		xfs_force_shutdown(l->l_mp, SHUTDOWN_LOG_IO_ERROR);
@@ -1838,6 +1844,23 @@ xlog_sync(
 	/* calculcate the checksum */
 	iclog->ic_header.h_crc = xlog_cksum(log, &iclog->ic_header,
 					    iclog->ic_datap, size);
+#ifdef DEBUG
+	/*
+	 * Intentionally corrupt the log record CRC based on the error injection
+	 * frequency, if defined. This facilitates testing log recovery in the
+	 * event of torn writes. Hence, set the IOABORT state to abort the log
+	 * write on I/O completion and shutdown the fs. The subsequent mount
+	 * detects the bad CRC and attempts to recover.
+	 */
+	if (log->l_badcrc_factor &&
+	    (prandom_u32() % log->l_badcrc_factor == 0)) {
+		iclog->ic_header.h_crc &= 0xAAAAAAAA;
+		iclog->ic_state |= XLOG_STATE_IOABORT;
+		xfs_warn(log->l_mp,
+	"Intentionally corrupted log record at LSN 0x%llx. Shutdown imminent.",
+			 be64_to_cpu(iclog->ic_header.h_lsn));
+	}
+#endif
 
 	bp->b_io_length = BTOBB(count);
 	bp->b_fspriv = iclog;
@@ -2791,11 +2814,19 @@ xlog_state_do_callback(
 		}
 	} while (!ioerrors && loopdidcallbacks);
 
+#ifdef DEBUG
 	/*
-	 * make one last gasp attempt to see if iclogs are being left in
-	 * limbo..
+	 * Make one last gasp attempt to see if iclogs are being left in limbo.
+	 * If the above loop finds an iclog earlier than the current iclog and
+	 * in one of the syncing states, the current iclog is put into
+	 * DO_CALLBACK and the callbacks are deferred to the completion of the
+	 * earlier iclog. Walk the iclogs in order and make sure that no iclog
+	 * is in DO_CALLBACK unless an earlier iclog is in one of the syncing
+	 * states.
+	 *
+	 * Note that SYNCING|IOABORT is a valid state so we cannot just check
+	 * for ic_state == SYNCING.
 	 */
-#ifdef DEBUG
 	if (funcdidcallbacks) {
 		first_iclog = iclog = log->l_iclog;
 		do {
@@ -2810,7 +2841,7 @@ xlog_state_do_callback(
 			 * IOERROR - give up hope all ye who enter here
 			 */
 			if (iclog->ic_state == XLOG_STATE_WANT_SYNC ||
-			    iclog->ic_state == XLOG_STATE_SYNCING ||
+			    iclog->ic_state & XLOG_STATE_SYNCING ||
 			    iclog->ic_state == XLOG_STATE_DONE_SYNC ||
 			    iclog->ic_state == XLOG_STATE_IOERROR )
 				break;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 8daba74..ed88963 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -62,6 +62,7 @@ static inline uint xlog_get_client_id(__be32 i)
 #define XLOG_STATE_CALLBACK  0x0020 /* Callback functions now */
 #define XLOG_STATE_DIRTY     0x0040 /* Dirty IC log, not ready for ACTIVE status*/
 #define XLOG_STATE_IOERROR   0x0080 /* IO error happened in sync'ing log */
+#define XLOG_STATE_IOABORT   0x0100 /* force abort on I/O completion (debug) */
 #define XLOG_STATE_ALL	     0x7FFF /* All possible valid flags */
 #define XLOG_STATE_NOTUSED   0x8000 /* This IC log not being used */
 
@@ -410,6 +411,8 @@ struct xlog {
 	/* The following field are used for debugging; need to hold icloglock */
 #ifdef DEBUG
 	void			*l_iclog_bak[XLOG_MAX_ICLOGS];
+	/* log record crc error injection factor */
+	uint32_t		l_badcrc_factor;
 #endif
 
 };
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index ee70f5d..641d625 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -255,11 +255,47 @@ write_grant_head_show(
 }
 XFS_SYSFS_ATTR_RO(write_grant_head);
 
+#ifdef DEBUG
+STATIC ssize_t
+log_badcrc_factor_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	struct xlog	*log = to_xlog(kobject);
+	int		ret;
+	uint32_t	val;
+
+	ret = kstrtouint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	log->l_badcrc_factor = val;
+
+	return count;
+}
+
+STATIC ssize_t
+log_badcrc_factor_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	struct xlog	*log = to_xlog(kobject);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", log->l_badcrc_factor);
+}
+
+XFS_SYSFS_ATTR_RW(log_badcrc_factor);
+#endif	/* DEBUG */
+
 static struct attribute *xfs_log_attrs[] = {
 	ATTR_LIST(log_head_lsn),
 	ATTR_LIST(log_tail_lsn),
 	ATTR_LIST(reserve_grant_head),
 	ATTR_LIST(write_grant_head),
+#ifdef DEBUG
+	ATTR_LIST(log_badcrc_factor),
+#endif
 	NULL,
 };
 
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
