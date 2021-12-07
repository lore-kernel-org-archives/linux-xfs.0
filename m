Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B16C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Dec 2021 18:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbhLGSjZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Dec 2021 13:39:25 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41206 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240582AbhLGSjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Dec 2021 13:39:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 42F04CE1D63
        for <linux-xfs@vger.kernel.org>; Tue,  7 Dec 2021 18:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DB2C341C3;
        Tue,  7 Dec 2021 18:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638902151;
        bh=XkBF4xci+omLAhRkqYRa10raSwYaILXS5qb9aEUfoIs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pl9RZ8yksplpwd8uHyFsez40vuQkTBMeF3rpbGBU5SKL78zjM22gS9HMcbC7O8Yct
         9TXyJ2O33sdtYMypcBMvXKwMwoLr3Sxg4MdJcqg1gS4NRs9SDm02/NFtP00rXHZkVi
         kzIi+Ts4zfDGRJtFNRTY1aC86qQSL9nIaRX/M/jQQOnwVDMDJ03m2YqpIurGzq1DPd
         Tl8T/M3Pun6nBMnDESAEZ0jgPa38FdC8VU80rw6c1ukNDpetf3NdzUYiimLJVJJwy5
         ROz5J4l6erwnDzPnUDxGcQUPgRKQdS0A7/nuZDhaFYkfP5XXpbTQwxkyo42yMuumcf
         ACnfV2AyhGdpw==
Subject: [PATCH 2/2] xfs: only run COW extent recovery when there are no live
 extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        wen.gang.wang@oracle.com
Date:   Tue, 07 Dec 2021 10:35:51 -0800
Message-ID: <163890215109.3375879.3278003521122932642.stgit@magnolia>
In-Reply-To: <163890213974.3375879.451653865403812137.stgit@magnolia>
References: <163890213974.3375879.451653865403812137.stgit@magnolia>
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
which means we always run this at mount time.

Fixes: 174edb0e46e5 ("xfs: store in-progress CoW allocations in the refcount btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c   |   37 ++++++++++++++++++++++++++++---------
 fs/xfs/xfs_reflink.c |    4 +++-
 fs/xfs/xfs_super.c   |    9 ---------
 3 files changed, 31 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 359109b6f0d3..064ff89a4557 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -918,6 +918,34 @@ xfs_mountfs(
 		xfs_qm_mount_quotas(mp);
 	}
 
+	/*
+	 * Recover any CoW staging blocks that are still referenced by the
+	 * ondisk refcount metadata.  The ondisk metadata does not track which
+	 * inode created the staging extent, which means that we don't have an
+	 * easy means to figure out if a given staging extent is referenced by
+	 * a cached inode or is a leftover from a previous unclean shutdown,
+	 * short of scanning the entire inode cache to construct a bitmap of
+	 * actually stale extents.
+	 *
+	 * During mount, we know that zero files have been exposed to user
+	 * modifications, which means that there cannot possibly be any live
+	 * staging extents.  Therefore, it is safe to free them all right now,
+	 * even if we're performing a readonly mount.
+	 *
+	 * This cannot be deferred this to rw remount time if we're performing
+	 * a readonly mount (as XFS once did) until there's an interlock with
+	 * cached inodes.
+	 */
+	if (!xfs_has_norecovery(mp)) {
+		error = xfs_reflink_recover_cow(mp);
+		if (error) {
+			xfs_err(mp,
+	"Error %d recovering leftover CoW allocations.", error);
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			goto out_quota;
+		}
+	}
+
 	/*
 	 * Now we are mounted, reserve a small amount of unused space for
 	 * privileged transactions. This is needed so that transaction
@@ -936,15 +964,6 @@ xfs_mountfs(
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
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cb0edb1d68ef..a571489ef0bd 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -749,7 +749,9 @@ xfs_reflink_end_cow(
 }
 
 /*
- * Free leftover CoW reservations that didn't get cleaned out.
+ * Free leftover CoW reservations that didn't get cleaned out.  This function
+ * does not coordinate with cached inode COW forks, which means that callers
+ * must ensure there are no COW staging extents attached to any cached inodes.
  */
 int
 xfs_reflink_recover_cow(
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0c07a4aef3b9..4649e7429264 100644
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

