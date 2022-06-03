Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54ACFC43334
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jun 2022 18:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347688AbiFCS6B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348477AbiFCS6B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 14:58:01 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FFF29833
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jun 2022 11:58:00 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q123so7881387pgq.6
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jun 2022 11:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wTlWpfXfAxQYNQYEDwfa9Wr0ugnfomGul3z3MRRGO7c=;
        b=jTif5rQMXAj5joF+PHQck4EJE9koTdefnyibeLR2gK/3mvtwcSug3tYxsqQ3lD3FAF
         lAzAwSjOg+v3CA3mqcBNXdczQx7eq9JBOGCL9X9BcpxgA9Jg7MK6bSO+tyicIEp6gGoL
         3LzBE9NU984VLGDfur3RGr7DHH+fDVk+wWN9vWTaLlWcgBiF3CbGjZGG7S7dYpXX0/3/
         YoXxi071JrZmDZ/oBTq9sHdfVOEubNNk/lCDTtmDSPTuMtv6QwGmteGULvwvtVFQS/WU
         xanD44yELKiMg0YWjNHZTV1RCSiS++eV46++DQSgfDume+WfcD34hevKNpq6wxZAbeyD
         QfbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wTlWpfXfAxQYNQYEDwfa9Wr0ugnfomGul3z3MRRGO7c=;
        b=dtpcEVHBQ0FKM1VjvdR92GDsYMt1peKiKPufh7rtB9mL7lRkaXOCeqs8loK1lXFw2O
         ZqxV9zjm/k5ZyBkA2SlMS7d4iKt9PpWHcxYI2ueFmIEYrfIJHBHmG/Zro1pRSAMwv8Sl
         BwjbuWvq/N09gUf8FvRKWIII7CnTu23rSQsChHuv/G4UgVDrIG14v1VZ2c5lUcU5mI0+
         P6Zsr4mA/eL+i6U6n186ST2bHZ4M1KV6/UUqOZXQ9cs3SIvhhzt+qhVEDTBZwg3mJ7ch
         2TUfotA6Ko/RqUlS5tMiFimgV7ZQowr42b96VbDv+H85ya6I/yjerHH/qrYWxzp/W2M2
         kw/Q==
X-Gm-Message-State: AOAM533KbpJcZoCKdDJjBT+QrgBw+jfH87pkgmmnF7cVIHmdu6nRNrdz
        Msbby3R8VfnG72PX6wq3uSOBc2+NELZlQQ==
X-Google-Smtp-Source: ABdhPJw/dNfNbFA0kVPc5iMVyMyktqmn0uYBXHtxjQXtdiZ+uwfleMIF7B8WPcFleaomzEXcMxewGQ==
X-Received: by 2002:a65:6d08:0:b0:3c6:8a08:3b9f with SMTP id bf8-20020a656d08000000b003c68a083b9fmr10202573pgb.147.1654282679343;
        Fri, 03 Jun 2022 11:57:59 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:e74e:a023:a0be:b6a8])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902650e00b001621ce92196sm4480969plk.86.2022.06.03.11.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:57:58 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 06/15] xfs: only run COW extent recovery when there are no live extents
Date:   Fri,  3 Jun 2022 11:57:12 -0700
Message-Id: <20220603185721.3121645-6-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220603185721.3121645-1-leah.rumancik@gmail.com>
References: <20220603185721.3121645-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 7993f1a431bc5271369d359941485a9340658ac3 ]

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
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_log_recover.c | 24 +++++++++++++++++++++++-
 fs/xfs/xfs_mount.c       | 10 ----------
 fs/xfs/xfs_reflink.c     |  5 ++++-
 fs/xfs/xfs_super.c       |  9 ---------
 4 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 10562ecbd9ea..581aeb288b32 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -27,7 +27,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_ag.h"
 #include "xfs_quota.h"
-
+#include "xfs_reflink.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -3502,6 +3502,28 @@ xlog_recover_finish(
 
 	xlog_recover_process_iunlinks(log);
 	xlog_recover_check_summary(log);
+
+	/*
+	 * Recover any CoW staging blocks that are still referenced by the
+	 * ondisk refcount metadata.  During mount there cannot be any live
+	 * staging extents as we have not permitted any user modifications.
+	 * Therefore, it is safe to free them all right now, even on a
+	 * read-only mount.
+	 */
+	error = xfs_reflink_recover_cow(log->l_mp);
+	if (error) {
+		xfs_alert(log->l_mp,
+	"Failed to recover leftover CoW staging extents, err %d.",
+				error);
+		/*
+		 * If we get an error here, make sure the log is shut down
+		 * but return zero so that any log items committed since the
+		 * end of intents processing can be pushed through the CIL
+		 * and AIL.
+		 */
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+	}
+
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 06dac09eddbd..62f3c153d4b2 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -922,15 +922,6 @@ xfs_mountfs(
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
@@ -941,7 +932,6 @@ xfs_mountfs(
 
  out_agresv:
 	xfs_fs_unreserve_ag_blocks(mp);
- out_quota:
 	xfs_qm_unmount_quotas(mp);
  out_rtunmount:
 	xfs_rtunmount_inodes(mp);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 76355f293488..36832e4bc803 100644
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
index 23673703618a..8d85114ea047 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1742,15 +1742,6 @@ xfs_remount_rw(
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
-- 
2.36.1.255.ge46751e96f-goog

