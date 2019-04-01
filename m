Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45848 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbfDARKY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 13:10:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x31H9JWD134175
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:10:23 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2rhwyd0ghs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 01 Apr 2019 17:10:23 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x31HANZa011932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:10:23 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x31HANDj011499
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:10:23 GMT
Subject: [PATCH 02/10] xfs: replace the BAD_SUMMARY mount flag with the
 equivalent health code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Apr 2019 10:10:21 -0700
Message-ID: <155413862191.4966.10871732453060652442.stgit@magnolia>
In-Reply-To: <155413860964.4966.6087725033542837255.stgit@magnolia>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the BAD_SUMMARY mount flag with calls to the equivalent health
tracking code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c |    5 +++--
 fs/xfs/xfs_log.c       |    3 ++-
 fs/xfs/xfs_mount.c     |    9 ++++-----
 fs/xfs/xfs_mount.h     |    1 -
 4 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f96b1997938e..f0309b74e377 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -30,6 +30,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
+#include "xfs_health.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -907,7 +908,7 @@ xfs_initialize_perag_data(
 	/*
 	 * If the new summary counts are obviously incorrect, fail the
 	 * mount operation because that implies the AGFs are also corrupt.
-	 * Clear BAD_SUMMARY so that we don't unmount with a dirty log, which
+	 * Clear FS_COUNTERS so that we don't unmount with a dirty log, which
 	 * will prevent xfs_repair from fixing anything.
 	 */
 	if (fdblocks > sbp->sb_dblocks || ifree > ialloc) {
@@ -925,7 +926,7 @@ xfs_initialize_perag_data(
 
 	xfs_reinit_percpu_counters(mp);
 out:
-	mp->m_flags &= ~XFS_MOUNT_BAD_SUMMARY;
+	xfs_fs_mark_healthy(mp, XFS_HEALTH_FS_COUNTERS);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c3b610b687d1..0f418842a035 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -23,6 +23,7 @@
 #include "xfs_cksum.h"
 #include "xfs_sysfs.h"
 #include "xfs_sb.h"
+#include "xfs_health.h"
 
 kmem_zone_t	*xfs_log_ticket_zone;
 
@@ -861,7 +862,7 @@ xfs_log_write_unmount_record(
 	 * recalculated during log recovery at next mount.  Refer to
 	 * xlog_check_unmount_rec for more details.
 	 */
-	if (XFS_TEST_ERROR((mp->m_flags & XFS_MOUNT_BAD_SUMMARY), mp,
+	if (XFS_TEST_ERROR(xfs_fs_is_sick(mp, XFS_HEALTH_FS_COUNTERS), mp,
 			XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
 		xfs_alert(mp, "%s: will fix summary counters at next mount",
 				__func__);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fc1f24dd0386..a43ca655a431 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -34,6 +34,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_reflink.h"
 #include "xfs_extent_busy.h"
+#include "xfs_health.h"
 
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -647,7 +648,7 @@ xfs_check_summary_counts(
 	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
 	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
 	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
-		mp->m_flags |= XFS_MOUNT_BAD_SUMMARY;
+		xfs_fs_mark_sick(mp, XFS_HEALTH_FS_COUNTERS);
 
 	/*
 	 * We can safely re-initialise incore superblock counters from the
@@ -662,7 +663,7 @@ xfs_check_summary_counts(
 	 */
 	if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
 	     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
-	    !(mp->m_flags & XFS_MOUNT_BAD_SUMMARY))
+	    !xfs_fs_is_sick(mp, XFS_HEALTH_FS_COUNTERS))
 		return 0;
 
 	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
@@ -1451,7 +1452,5 @@ xfs_force_summary_recalc(
 	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
 		return;
 
-	spin_lock(&mp->m_sb_lock);
-	mp->m_flags |= XFS_MOUNT_BAD_SUMMARY;
-	spin_unlock(&mp->m_sb_lock);
+	xfs_fs_mark_sick(mp, XFS_HEALTH_FS_COUNTERS);
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 63bbafb01eb5..6e7728340ca7 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -211,7 +211,6 @@ typedef struct xfs_mount {
 						   must be synchronous except
 						   for space allocations */
 #define XFS_MOUNT_UNMOUNTING	(1ULL << 1)	/* filesystem is unmounting */
-#define XFS_MOUNT_BAD_SUMMARY	(1ULL << 2)	/* summary counters are bad */
 #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
