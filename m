Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60290 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfDLG2V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Apr 2019 02:28:21 -0400
Subject: [PATCH 2/8] xfs: replace the BAD_SUMMARY mount flag with the
 equivalent health code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Apr 2019 23:28:15 -0700
Message-ID: <155505049549.1279757.7940793456135165070.stgit@magnolia>
In-Reply-To: <155505048097.1279757.13952335054480511366.stgit@magnolia>
References: <155505048097.1279757.13952335054480511366.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the BAD_SUMMARY mount flag with calls to the equivalent health
tracking code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c |    5 +++--
 fs/xfs/xfs_log.c       |    3 ++-
 fs/xfs/xfs_mount.c     |    9 ++++-----
 fs/xfs/xfs_mount.h     |    1 -
 4 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 77a3a4085de3..dc5be0c631c8 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -30,6 +30,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
+#include "xfs_health.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -905,7 +906,7 @@ xfs_initialize_perag_data(
 	/*
 	 * If the new summary counts are obviously incorrect, fail the
 	 * mount operation because that implies the AGFs are also corrupt.
-	 * Clear BAD_SUMMARY so that we don't unmount with a dirty log, which
+	 * Clear FS_COUNTERS so that we don't unmount with a dirty log, which
 	 * will prevent xfs_repair from fixing anything.
 	 */
 	if (fdblocks > sbp->sb_dblocks || ifree > ialloc) {
@@ -923,7 +924,7 @@ xfs_initialize_perag_data(
 
 	xfs_reinit_percpu_counters(mp);
 out:
-	mp->m_flags &= ~XFS_MOUNT_BAD_SUMMARY;
+	xfs_fs_mark_healthy(mp, XFS_SICK_FS_COUNTERS);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c3b610b687d1..457ced3ee3e1 100644
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
+	if (XFS_TEST_ERROR(xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS), mp,
 			XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
 		xfs_alert(mp, "%s: will fix summary counters at next mount",
 				__func__);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6581381c12be..14f454e09e6e 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -34,6 +34,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_reflink.h"
 #include "xfs_extent_busy.h"
+#include "xfs_health.h"
 
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -645,7 +646,7 @@ xfs_check_summary_counts(
 	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
 	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
 	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
-		mp->m_flags |= XFS_MOUNT_BAD_SUMMARY;
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
 
 	/*
 	 * We can safely re-initialise incore superblock counters from the
@@ -660,7 +661,7 @@ xfs_check_summary_counts(
 	 */
 	if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
 	     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
-	    !(mp->m_flags & XFS_MOUNT_BAD_SUMMARY))
+	    !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
 		return 0;
 
 	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
@@ -1446,7 +1447,5 @@ xfs_force_summary_recalc(
 	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
 		return;
 
-	spin_lock(&mp->m_sb_lock);
-	mp->m_flags |= XFS_MOUNT_BAD_SUMMARY;
-	spin_unlock(&mp->m_sb_lock);
+	xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index cf7facc36a5f..42b980862203 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -228,7 +228,6 @@ typedef struct xfs_mount {
 						   must be synchronous except
 						   for space allocations */
 #define XFS_MOUNT_UNMOUNTING	(1ULL << 1)	/* filesystem is unmounting */
-#define XFS_MOUNT_BAD_SUMMARY	(1ULL << 2)	/* summary counters are bad */
 #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
