Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58178 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938404AbdAIPjz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:39:55 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/32] xfs: Move AGI buffer type setting to xfs_read_agi
Date: Mon,  9 Jan 2017 16:38:48 +0100
Message-Id: <1483976343-661-18-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>

From: Eric Sandeen <sandeen@sandeen.net>

commit 200237d6746faaeaf7f4ff4abbf13f3917cee60a upstream.

We've missed properly setting the buffer type for
an AGI transaction in 3 spots now, so just move it
into xfs_read_agi() and set it if we are in a transaction
to avoid the problem in the future.

This is similar to how it is done in i.e. the dir3
and attr3 read functions.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 4 ++--
 fs/xfs/xfs_inode.c         | 2 --
 fs/xfs/xfs_log_recover.c   | 1 -
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 51b4e0d..c482b97 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2450,8 +2450,6 @@ xfs_ialloc_log_agi(
 	ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
 #endif
 
-	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_AGI_BUF);
-
 	/*
 	 * Compute byte offsets for the first and last fields in the first
 	 * region and log the agi buffer. This only logs up through
@@ -2592,6 +2590,8 @@ xfs_read_agi(
 			XFS_FSS_TO_BB(mp, 1), 0, bpp, &xfs_agi_buf_ops);
 	if (error)
 		return error;
+	if (tp)
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_AGI_BUF);
 
 	xfs_buf_set_ref(*bpp, XFS_AGI_REF);
 	return 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4e560e6..512ff13 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2041,7 +2041,6 @@ xfs_iunlink(
 	agi->agi_unlinked[bucket_index] = cpu_to_be32(agino);
 	offset = offsetof(xfs_agi_t, agi_unlinked) +
 		(sizeof(xfs_agino_t) * bucket_index);
-	xfs_trans_buf_set_type(tp, agibp, XFS_BLFT_AGI_BUF);
 	xfs_trans_log_buf(tp, agibp, offset,
 			  (offset + sizeof(xfs_agino_t) - 1));
 	return 0;
@@ -2133,7 +2132,6 @@ xfs_iunlink_remove(
 		agi->agi_unlinked[bucket_index] = cpu_to_be32(next_agino);
 		offset = offsetof(xfs_agi_t, agi_unlinked) +
 			(sizeof(xfs_agino_t) * bucket_index);
-		xfs_trans_buf_set_type(tp, agibp, XFS_BLFT_AGI_BUF);
 		xfs_trans_log_buf(tp, agibp, offset,
 				  (offset + sizeof(xfs_agino_t) - 1));
 	} else {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2d91f5a..9b3d7c7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4929,7 +4929,6 @@ xlog_recover_clear_agi_bucket(
 	agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
 	offset = offsetof(xfs_agi_t, agi_unlinked) +
 		 (sizeof(xfs_agino_t) * bucket);
-	xfs_trans_buf_set_type(tp, agibp, XFS_BLFT_AGI_BUF);
 	xfs_trans_log_buf(tp, agibp, offset,
 			  (offset + sizeof(xfs_agino_t) - 1));
 
-- 
2.1.4

