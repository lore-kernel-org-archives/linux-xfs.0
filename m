Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37036 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730161AbeGSATx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jul 2018 20:19:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6INd5w3114919
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 23:39:37 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2k9ykc3nc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 23:39:37 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6INdajx002857
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 23:39:37 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6INdaJO011643
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 23:39:36 GMT
Subject: [PATCH 3/3] xfs: force summary counter recalc at next mount
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 18 Jul 2018 16:39:35 -0700
Message-ID: <153195717556.16758.14300971459515094159.stgit@magnolia>
In-Reply-To: <153195715716.16758.18150859087945516040.stgit@magnolia>
References: <153195715716.16758.18150859087945516040.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the "bad summary count" mount flag from the previous patch to skip
writing the unmount record to force log recovery at the next mount,
which will recalculate the summary counters for us.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_errortag.h |    4 +++-
 fs/xfs/xfs_error.c           |    3 +++
 fs/xfs/xfs_log.c             |   16 +++++++++++++++-
 fs/xfs/xfs_mount.c           |   13 +++++++++++++
 fs/xfs/xfs_mount.h           |    1 +
 5 files changed, 35 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index b9974e7a8e6e..66077a105cbb 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -53,7 +53,8 @@
 #define XFS_ERRTAG_LOG_ITEM_PIN				30
 #define XFS_ERRTAG_BUF_LRU_REF				31
 #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
-#define XFS_ERRTAG_MAX					33
+#define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
+#define XFS_ERRTAG_MAX					34
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -91,5 +92,6 @@
 #define XFS_RANDOM_LOG_ITEM_PIN				1
 #define XFS_RANDOM_BUF_LRU_REF				2
 #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
+#define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 0470114a8d80..9866f542e77b 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -50,6 +50,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_LOG_ITEM_PIN,
 	XFS_RANDOM_BUF_LRU_REF,
 	XFS_RANDOM_FORCE_SCRUB_REPAIR,
+	XFS_RANDOM_FORCE_SUMMARY_RECALC,
 };
 
 struct xfs_errortag_attr {
@@ -157,6 +158,7 @@ XFS_ERRORTAG_ATTR_RW(log_bad_crc,	XFS_ERRTAG_LOG_BAD_CRC);
 XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
 XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
 XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
+XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -192,6 +194,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(log_item_pin),
 	XFS_ERRORTAG_ATTR_LIST(buf_lru_ref),
 	XFS_ERRORTAG_ATTR_LIST(force_repair),
+	XFS_ERRORTAG_ATTR_LIST(bad_summary),
 	NULL,
 };
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f114e9031af8..dc805f2973a0 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -852,16 +852,30 @@ xfs_log_write_unmount_record(
 	struct xlog_in_core	*iclog;
 	struct xlog_ticket	*tic = NULL;
 	xfs_lsn_t		lsn;
+	uint			flags = XLOG_UNMOUNT_TRANS;
 	int			error;
 
 	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
 	if (error)
 		goto out_err;
 
+	/*
+	 * If we think the summary counters are bad, clear the unmount header
+	 * flag in the unmount record so that the summary counters will be
+	 * recalculated during log recovery at next mount.  Refer to
+	 * xlog_check_unmount_rec for more details.
+	 */
+	if (XFS_TEST_ERROR((mp->m_flags & XFS_MOUNT_BAD_SUMMARY), mp,
+			XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
+		xfs_alert(mp, "%s: will fix summary counters at next mount",
+				__func__);
+		flags &= ~XLOG_UNMOUNT_TRANS;
+	}
+
 	/* remove inited flag, and account for space used */
 	tic->t_flags = 0;
 	tic->t_curr_res -= sizeof(magic);
-	error = xlog_write(log, &vec, tic, &lsn, NULL, XLOG_UNMOUNT_TRANS);
+	error = xlog_write(log, &vec, tic, &lsn, NULL, flags);
 	/*
 	 * At this point, we're umounting anyway,
 	 * so there's no point in transitioning log state
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 60462c35ad4b..4fb361cde32a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1423,3 +1423,16 @@ xfs_dev_is_read_only(
 	}
 	return 0;
 }
+
+/* Force the summary counters to be recalculated at next mount. */
+void
+xfs_force_summary_recalc(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
+		return;
+
+	spin_lock(&mp->m_sb_lock);
+	mp->m_flags |= XFS_MOUNT_BAD_SUMMARY;
+	spin_unlock(&mp->m_sb_lock);
+}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f08907db9c61..540353a51478 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -435,5 +435,6 @@ int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 
 struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
 		int error_class, int error);
+void xfs_force_summary_recalc(struct xfs_mount *mp);
 
 #endif	/* __XFS_MOUNT_H__ */

