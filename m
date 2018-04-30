Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33014 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754645AbeD3Pc7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 11:32:59 -0400
Received: by mail-io0-f195.google.com with SMTP id e78-v6so10639249iod.0
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 08:32:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] xfs: add 'discard_sync' mount flag
Date: Mon, 30 Apr 2018 09:32:52 -0600
Message-Id: <1525102372-8430-3-git-send-email-axboe@kernel.dk>
In-Reply-To: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: hch@lst.de, Jens Axboe <axboe@kernel.dk>

XFS recently added support for async discards. While this can be
a win for some workloads and devices, there are also cases where
async bursty discard will severly harm the latencies of reads
and writes.

Add a 'discard_sync' mount flag to revert to using sync discard,
issuing them one at the time and waiting for each one. This fixes
a big performance regression we had moving to kernels that include
the XFS async discard support.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/xfs/xfs_log_cil.c | 18 ++++++++++++++----
 fs/xfs/xfs_mount.h   |  1 +
 fs/xfs/xfs_super.c   |  7 ++++++-
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 4668403b1741..4eced3eceea5 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -552,10 +552,16 @@ xlog_discard_busy_extents(
 	struct bio		*bio = NULL;
 	struct blk_plug		plug;
 	int			error = 0;
+	int			discard_flags = 0;
+	bool			sync_discard = mp->m_flags & XFS_MOUNT_DISCARD_SYNC;
 
 	ASSERT(mp->m_flags & XFS_MOUNT_DISCARD);
 
-	blk_start_plug(&plug);
+	if (!sync_discard)
+		blk_start_plug(&plug);
+	else
+		discard_flags = BLKDEV_DISCARD_SYNC;
+
 	list_for_each_entry(busyp, list, list) {
 		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
 					 busyp->length);
@@ -563,7 +569,7 @@ xlog_discard_busy_extents(
 		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
 				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
 				XFS_FSB_TO_BB(mp, busyp->length),
-				GFP_NOFS, 0, &bio);
+				GFP_NOFS, discard_flags, &bio);
 		if (error && error != -EOPNOTSUPP) {
 			xfs_info(mp,
 	 "discard failed for extent [0x%llx,%u], error %d",
@@ -574,14 +580,18 @@ xlog_discard_busy_extents(
 		}
 	}
 
-	if (bio) {
+	if (sync_discard) {
+		xfs_extent_busy_clear(mp, &ctx->busy_extents, false);
+		kmem_free(ctx);
+	} else if (bio) {
 		bio->bi_private = ctx;
 		bio->bi_end_io = xlog_discard_endio;
 		submit_bio(bio);
+		blk_finish_plug(&plug);
 	} else {
 		xlog_discard_endio_work(&ctx->discard_endio_work);
+		blk_finish_plug(&plug);
 	}
-	blk_finish_plug(&plug);
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 10b90bbc5162..3f0b7b9106c7 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -219,6 +219,7 @@ typedef struct xfs_mount {
 						   operations, typically for
 						   disk errors in metadata */
 #define XFS_MOUNT_DISCARD	(1ULL << 5)	/* discard unused blocks */
+#define XFS_MOUNT_DISCARD_SYNC	(1ULL << 6)	/* discard unused blocks sync */
 #define XFS_MOUNT_NOALIGN	(1ULL << 7)	/* turn off stripe alignment
 						   allocations */
 #define XFS_MOUNT_ATTR2		(1ULL << 8)	/* allow use of attr2 format */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d71424052917..6d960bb4725f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -83,7 +83,7 @@ enum {
 	Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota, Opt_prjquota,
 	Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
+	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err, Opt_discard_sync,
 };
 
 static const match_table_t tokens = {
@@ -129,6 +129,7 @@ static const match_table_t tokens = {
 	{Opt_pqnoenforce,"pqnoenforce"},/* project quota limit enforcement */
 	{Opt_qnoenforce, "qnoenforce"},	/* same as uqnoenforce */
 	{Opt_discard,	"discard"},	/* Discard unused blocks */
+	{Opt_discard_sync,"discard_sync"},/* Discard unused blocks sync */
 	{Opt_nodiscard,	"nodiscard"},	/* Do not discard unused blocks */
 
 	{Opt_dax,	"dax"},		/* Enable direct access to bdev pages */
@@ -363,11 +364,15 @@ xfs_parseargs(
 			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
 			mp->m_qflags &= ~XFS_GQUOTA_ENFD;
 			break;
+		case Opt_discard_sync:
+			mp->m_flags |= XFS_MOUNT_DISCARD_SYNC;
+			/* fall through and set XFS_MOUNT_DISCARD too */
 		case Opt_discard:
 			mp->m_flags |= XFS_MOUNT_DISCARD;
 			break;
 		case Opt_nodiscard:
 			mp->m_flags &= ~XFS_MOUNT_DISCARD;
+			mp->m_flags &= ~XFS_MOUNT_DISCARD_SYNC;
 			break;
 #ifdef CONFIG_FS_DAX
 		case Opt_dax:
-- 
2.7.4

