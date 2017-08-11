Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50864 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751932AbdHKHL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 03:11:56 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7B7Bsrs032343
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7Bsdx010843
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:54 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7BscW027394
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:54 GMT
Subject: [PATCH 16/16] xfs: shut off scrub-related error and corruption
 messages
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 11 Aug 2017 00:11:53 -0700
Message-ID: <150243551310.29473.14099640784799039293.stgit@magnolia>
In-Reply-To: <150243541274.29473.1227559008347544526.stgit@magnolia>
References: <150243541274.29473.1227559008347544526.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

While we're scrubbing and repairing, silence errors and corruption
messages to avoid flooding the logs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/scrub.c |    6 +++++-
 fs/xfs/xfs_buf.c     |    3 +++
 fs/xfs/xfs_error.c   |    9 +++++++++
 fs/xfs/xfs_message.c |    3 +++
 fs/xfs/xfs_mount.h   |    1 +
 fs/xfs/xfs_super.c   |    1 +
 6 files changed, 22 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b59e004..5f2c71d 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -352,6 +352,8 @@ xfs_scrub_metadata(
 		warned = true;
 	}
 
+	atomic_inc(&mp->m_scrubbers);
+
 retry_op:
 	/* Set up for the operation. */
 	memset(&sc, 0, sizeof(sc));
@@ -374,7 +376,7 @@ xfs_scrub_metadata(
 		 */
 		error = xfs_scrub_teardown(&sc, ip, 0);
 		if (error)
-			goto out;
+			goto out_dec;
 		try_harder = true;
 		goto retry_op;
 	} else if (error)
@@ -386,6 +388,8 @@ xfs_scrub_metadata(
 
 out_teardown:
 	error = xfs_scrub_teardown(&sc, ip, error);
+out_dec:
+	atomic_dec(&mp->m_scrubbers);
 out:
 	trace_xfs_scrub_done(ip, sm, error);
 	return error;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 72f0384..0a45e93 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -42,6 +42,7 @@
 #include "xfs_mount.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_error.h"
 
 static kmem_zone_t *xfs_buf_zone;
 
@@ -577,6 +578,8 @@ _xfs_buf_find(
 	 */
 	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
 	if (cmap.bm_bn < 0 || cmap.bm_bn >= eofs) {
+		if (atomic_read(&btp->bt_mount->m_scrubbers) > 0)
+			return NULL;
 		/*
 		 * XXX (dgc): we should really be returning -EFSCORRUPTED here,
 		 * but none of the higher level infrastructure supports
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 2f4feb9..8cebbaa 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -309,6 +309,9 @@ xfs_error_report(
 	int			linenum,
 	void			*ra)
 {
+	if (atomic_read(&mp->m_scrubbers) > 0)
+		return;
+
 	if (level <= xfs_error_level) {
 		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
 		"Internal error %s at line %d of file %s.  Caller %pS",
@@ -328,6 +331,9 @@ xfs_corruption_error(
 	int			linenum,
 	void			*ra)
 {
+	if (atomic_read(&mp->m_scrubbers) > 0)
+		return;
+
 	if (level <= xfs_error_level)
 		xfs_hex_dump(p, 64);
 	xfs_error_report(tag, level, mp, filename, linenum, ra);
@@ -344,6 +350,9 @@ xfs_verifier_error(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 
+	if (atomic_read(&mp->m_scrubbers) > 0)
+		return;
+
 	xfs_alert(mp, "Metadata %s detected at %pF, %s block 0x%llx",
 		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
 		  __return_address, bp->b_ops->name, bp->b_bn);
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index e68bd10..a4ede17 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -46,6 +46,9 @@ void func(const struct xfs_mount *mp, const char *fmt, ...)	\
 	va_list			args;				\
 	int			level;				\
 								\
+	if (mp && atomic_read(&mp->m_scrubbers) > 0)		\
+		return;						\
+								\
 	va_start(args, fmt);					\
 								\
 	vaf.fmt = fmt;						\
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e0792d0..37a6c97 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -206,6 +206,7 @@ typedef struct xfs_mount {
 	unsigned int		*m_errortag;
 	struct xfs_kobj		m_errortag_kobj;
 #endif
+	atomic_t		m_scrubbers;	/* # of active scrub processes */
 } xfs_mount_t;
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 38aaacd..664db70 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1547,6 +1547,7 @@ xfs_fs_fill_super(
 	spin_lock_init(&mp->m_sb_lock);
 	mutex_init(&mp->m_growlock);
 	atomic_set(&mp->m_active_trans, 0);
+	atomic_set(&mp->m_scrubbers, 0);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
 	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);

