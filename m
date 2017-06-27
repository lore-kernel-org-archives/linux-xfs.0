Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58252 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751453AbdF0MfH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jun 2017 08:35:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: replace log_badcrc_factor knob with error injection tag
Date: Tue, 27 Jun 2017 08:35:05 -0400
Message-Id: <1498566905-51311-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <149823570899.31786.10730517727349185585.stgit@birch.djwong.org>
References: <149823570899.31786.10730517727349185585.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

Now that error injection tags support dynamic frequency adjustment,
replace the debug mode sysfs knob that controls log record CRC error
injection with an error injection tag.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Darrick,

Care to tack something like this onto this series? We might as well fix
this one too before I create another test that relies on it. I'll follow
up with an update to xfs/141 to support either knob.

Brian

 fs/xfs/xfs_error.c |  3 +++
 fs/xfs/xfs_error.h |  4 +++-
 fs/xfs/xfs_log.c   |  5 +----
 fs/xfs/xfs_sysfs.c | 36 ------------------------------------
 4 files changed, 7 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index a2f23d2..26c32bc 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -56,6 +56,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_BMAP_FINISH_ONE,
 	XFS_RANDOM_AG_RESV_CRITICAL,
 	XFS_RANDOM_DROP_WRITES,
+	XFS_RANDOM_LOG_BAD_CRC,
 };
 
 struct xfs_errortag_attr {
@@ -159,6 +160,7 @@ XFS_ERRORTAG_ATTR_RW(refcount_finish_one,	XFS_ERRTAG_REFCOUNT_FINISH_ONE);
 XFS_ERRORTAG_ATTR_RW(bmap_finish_one,	XFS_ERRTAG_BMAP_FINISH_ONE);
 XFS_ERRORTAG_ATTR_RW(ag_resv_critical,	XFS_ERRTAG_AG_RESV_CRITICAL);
 XFS_ERRORTAG_ATTR_RW(drop_writes,	XFS_ERRTAG_DROP_WRITES);
+XFS_ERRORTAG_ATTR_RW(log_bad_crc,	XFS_ERRTAG_LOG_BAD_CRC);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -190,6 +192,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(bmap_finish_one),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_critical),
 	XFS_ERRORTAG_ATTR_LIST(drop_writes),
+	XFS_ERRORTAG_ATTR_LIST(log_bad_crc),
 	NULL,
 };
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index ad9b24a..0874d6b 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -106,8 +106,9 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
  * handling sequence.
  */
 #define XFS_ERRTAG_DROP_WRITES				28
+#define XFS_ERRTAG_LOG_BAD_CRC				29
 
-#define XFS_ERRTAG_MAX					29
+#define XFS_ERRTAG_MAX					30
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -141,6 +142,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_RANDOM_BMAP_FINISH_ONE			1
 #define XFS_RANDOM_AG_RESV_CRITICAL			4
 #define XFS_RANDOM_DROP_WRITES				1
+#define XFS_RANDOM_LOG_BAD_CRC				1
 
 #ifdef DEBUG
 extern int xfs_errortag_init(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2d1112e..31f11be 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1841,7 +1841,6 @@ xlog_sync(
 	/* calculcate the checksum */
 	iclog->ic_header.h_crc = xlog_cksum(log, &iclog->ic_header,
 					    iclog->ic_datap, size);
-#ifdef DEBUG
 	/*
 	 * Intentionally corrupt the log record CRC based on the error injection
 	 * frequency, if defined. This facilitates testing log recovery in the
@@ -1849,15 +1848,13 @@ xlog_sync(
 	 * write on I/O completion and shutdown the fs. The subsequent mount
 	 * detects the bad CRC and attempts to recover.
 	 */
-	if (log->l_badcrc_factor &&
-	    (prandom_u32() % log->l_badcrc_factor == 0)) {
+	if (XFS_TEST_ERROR(false, log->l_mp, XFS_ERRTAG_LOG_BAD_CRC)) {
 		iclog->ic_header.h_crc &= cpu_to_le32(0xAAAAAAAA);
 		iclog->ic_state |= XLOG_STATE_IOABORT;
 		xfs_warn(log->l_mp,
 	"Intentionally corrupted log record at LSN 0x%llx. Shutdown imminent.",
 			 be64_to_cpu(iclog->ic_header.h_lsn));
 	}
-#endif
 
 	bp->b_io_length = BTOBB(count);
 	bp->b_fspriv = iclog;
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 56610a9..8b2ccc2 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -305,47 +305,11 @@ write_grant_head_show(
 }
 XFS_SYSFS_ATTR_RO(write_grant_head);
 
-#ifdef DEBUG
-STATIC ssize_t
-log_badcrc_factor_store(
-	struct kobject	*kobject,
-	const char	*buf,
-	size_t		count)
-{
-	struct xlog	*log = to_xlog(kobject);
-	int		ret;
-	uint32_t	val;
-
-	ret = kstrtouint(buf, 0, &val);
-	if (ret)
-		return ret;
-
-	log->l_badcrc_factor = val;
-
-	return count;
-}
-
-STATIC ssize_t
-log_badcrc_factor_show(
-	struct kobject	*kobject,
-	char		*buf)
-{
-	struct xlog	*log = to_xlog(kobject);
-
-	return snprintf(buf, PAGE_SIZE, "%d\n", log->l_badcrc_factor);
-}
-
-XFS_SYSFS_ATTR_RW(log_badcrc_factor);
-#endif	/* DEBUG */
-
 static struct attribute *xfs_log_attrs[] = {
 	ATTR_LIST(log_head_lsn),
 	ATTR_LIST(log_tail_lsn),
 	ATTR_LIST(reserve_grant_head),
 	ATTR_LIST(write_grant_head),
-#ifdef DEBUG
-	ATTR_LIST(log_badcrc_factor),
-#endif
 	NULL,
 };
 
-- 
2.7.5

