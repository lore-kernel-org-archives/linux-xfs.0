Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7892CC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Dec 2021 23:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241099AbhLHXSw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Dec 2021 18:18:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41082 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbhLHXSv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Dec 2021 18:18:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1ADAB82325
        for <linux-xfs@vger.kernel.org>; Wed,  8 Dec 2021 23:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923E9C00446;
        Wed,  8 Dec 2021 23:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639005316;
        bh=8itlwooVJUB54RcM8AWOkfDWek3uhuUaJxv6B2Id+oU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=V57rPJU6ypeEhWk9Nz3fWAtu670HvRZ8xX9JK2/Q8h1vof9J6WZDUJKEI/MUiuXpU
         lc65qwwYR6LWPJyhaHvPhIjFM91DDdhjkVDQ8c+hs6AwoZKYwhVedLcnwJpKEIr9LS
         9HVS2Xw7zTilA9ZlIqrCgfivlMafCVFUsoaARV7yQBHrJrffVaObGJ26ECx92CvZOC
         a0m67X078kDTX/18FLe/H3tKFeznaM5xBSx8jnaaCM/0DaDVjWNb6uFR6J7Brn3968
         2XGCarqG+Mn7l+PRaSCATbMGYMIN9XjvOqEXRdUDzDbiWnlc2A6+0TH8nRABaS1aRI
         drJ2l+pefWbUg==
Subject: [PATCH 2/2] xfs: only run COW extent recovery when there are no live
 extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        wen.gang.wang@oracle.com
Date:   Wed, 08 Dec 2021 15:15:16 -0800
Message-ID: <163900531629.374528.14641806907962114873.stgit@magnolia>
In-Reply-To: <163900530491.374528.3847809977076817523.stgit@magnolia>
References: <163900530491.374528.3847809977076817523.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

As part of multiple customer escalations due to file data corruption
after copy on write operations, I wrote some fstests that use fsstress
to hammer on COW to shake things loose.  Regrettably, I caught some
filesystem shutdowns due to incorrect rmap operations with the following
loop:

mount <filesystem>				# (0)
fsstress <run only readonly ops> &		# (1)
while true; do
	fsstress <run all ops>
	mount -o remount,ro			# (2)
	fsstress <run only readonly ops>
	mount -o remount,rw			# (3)
done

When (2) happens, notice that (1) is still running.  xfs_remount_ro will
call xfs_blockgc_stop to walk the inode cache to free all the COW
extents, but the blockgc mechanism races with (1)'s reader threads to
take IOLOCKs and loses, which means that it doesn't clean them all out.
Call such a file (A).

When (3) happens, xfs_remount_rw calls xfs_reflink_recover_cow, which
walks the ondisk refcount btree and frees any COW extent that it finds.
This function does not check the inode cache, which means that incore
COW forks of inode (A) is now inconsistent with the ondisk metadata.  If
one of those former COW extents are allocated and mapped into another
file (B) and someone triggers a COW to the stale reservation in (A), A's
dirty data will be written into (B) and once that's done, those blocks
will be transferred to (A)'s data fork without bumping the refcount.

The results are catastrophic -- file (B) and the refcount btree are now
corrupt.  In the first patch, we fixed the race condition in (2) so that
(A) will always flush the COW fork.  In this second patch, we move the
_recover_cow call to the initial mount call in (0) for safety.

As mentioned previously, xfs_reflink_recover_cow walks the refcount
btree looking for COW staging extents, and frees them.  This was
intended to be run at mount time (when we know there are no live inodes)
to clean up any leftover staging events that may have been left behind
during an unclean shutdown.  As a time "optimization" for readonly
mounts, we deferred this to the ro->rw transition, not realizing that
any failure to clean all COW forks during a rw->ro transition would
result in catastrophic corruption.

Therefore, remove this optimization and only run the recovery routine
when we're guaranteed not to have any COW staging extents anywhere,
which means we always run this at mount time.  While we're at it, move
the callsite to xfs_log_mount_finish because any refcount btree
expansion (however unlikely given that we're removing records from the
right side of the index) must be fed by a per-AG reservation, which
doesn't exist in its current location.

Fixes: 174edb0e46e5 ("xfs: store in-progress CoW allocations in the refcount btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c     |   23 ++++++++++++++++++++++-
 fs/xfs/xfs_mount.c   |   10 ----------
 fs/xfs/xfs_reflink.c |    5 ++++-
 fs/xfs/xfs_super.c   |    9 ---------
 4 files changed, 26 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 89fec9a18c34..c17344fc1275 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -10,6 +10,7 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_inode.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_trans.h"
@@ -20,6 +21,7 @@
 #include "xfs_sysfs.h"
 #include "xfs_sb.h"
 #include "xfs_health.h"
+#include "xfs_reflink.h"
 
 struct kmem_cache	*xfs_log_ticket_cache;
 
@@ -847,9 +849,28 @@ xfs_log_mount_finish(
 	/* Make sure the log is dead if we're returning failure. */
 	ASSERT(!error || xlog_is_shutdown(log));
 
-	return error;
+	if (error)
+		return error;
+
+	/*
+	 * Recover any CoW staging blocks that are still referenced by the
+	 * ondisk refcount metadata.  During mount there cannot be any live
+	 * staging extents as we have not permitted any user modifications.
+	 * Therefore, it is safe to free them all right now, even on a
+	 * read-only mount.
+	 */
+	error = xfs_reflink_recover_cow(mp);
+	if (error) {
+		xfs_err(mp, "Error %d recovering leftover CoW allocations.",
+				error);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		return error;
+	}
+
+	return 0;
 }
 
+
 /*
  * The mount has failed. Cancel the recovery if it hasn't completed and destroy
  * the log.
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 359109b6f0d3..bed73e8002a5 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -936,15 +936,6 @@ xfs_mountfs(
 			xfs_warn(mp,
 	"Unable to allocate reserve blocks. Continuing without reserve pool.");
 
-		/* Recover any CoW blocks that never got remapped. */
-		error = xfs_reflink_recover_cow(mp);
-		if (error) {
-			xfs_err(mp,
-	"Error %d recovering leftover CoW allocations.", error);
-			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-			goto out_quota;
-		}
-
 		/* Reserve AG blocks for future btree expansion. */
 		error = xfs_fs_reserve_ag_blocks(mp);
 		if (error && error != -ENOSPC)
@@ -955,7 +946,6 @@ xfs_mountfs(
 
  out_agresv:
 	xfs_fs_unreserve_ag_blocks(mp);
- out_quota:
 	xfs_qm_unmount_quotas(mp);
  out_rtunmount:
 	xfs_rtunmount_inodes(mp);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cb0edb1d68ef..8b6c7163f684 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -749,7 +749,10 @@ xfs_reflink_end_cow(
 }
 
 /*
- * Free leftover CoW reservations that didn't get cleaned out.
+ * Free all CoW staging blocks that are still referenced by the ondisk refcount
+ * metadata.  The ondisk metadata does not track which inode created the
+ * staging extent, so callers must ensure that there are no cached inodes with
+ * live CoW staging extents.
  */
 int
 xfs_reflink_recover_cow(
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 778b57b1f020..c7ac486ca5d3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1739,15 +1739,6 @@ xfs_remount_rw(
 	 */
 	xfs_restore_resvblks(mp);
 	xfs_log_work_queue(mp);
-
-	/* Recover any CoW blocks that never got remapped. */
-	error = xfs_reflink_recover_cow(mp);
-	if (error) {
-		xfs_err(mp,
-			"Error %d recovering leftover CoW allocations.", error);
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		return error;
-	}
 	xfs_blockgc_start(mp);
 
 	/* Create the per-AG metadata reservation pool .*/

