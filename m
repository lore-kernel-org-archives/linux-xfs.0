Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35574 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751697AbcLARnH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Dec 2016 12:43:07 -0500
Subject: [PATCH 2/2 V2] xfs: Move AGI buffer type setting to xfs_read_agi
References: <203e6e5c-7663-b49b-36af-5885aa1f461a@redhat.com>
 <0df5fea5-2658-f2ac-a465-09d0ada4cccf@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f536723f-93ea-2524-636e-f09bfb2b6ff8@sandeen.net>
Date: Thu, 1 Dec 2016 11:43:05 -0600
MIME-Version: 1.0
In-Reply-To: <0df5fea5-2658-f2ac-a465-09d0ada4cccf@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

We've missed properly setting the buffer type for
an AGI transaction in 3 spots now, so just move it
into xfs_read_agi() and set it if we are in a transaction
to avoid the problem in the future.

This is similar to how it is done in i.e. the dir3
and attr3 read functions.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---

V2: oops, get all of them into the helper, thanks Brian.

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 51b4e0d..c482b97 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2450,8 +2450,6 @@
 	ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
 #endif
 
-	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_AGI_BUF);
-
 	/*
 	 * Compute byte offsets for the first and last fields in the first
 	 * region and log the agi buffer. This only logs up through
@@ -2592,6 +2590,8 @@
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
@@ -2041,7 +2041,6 @@
 	agi->agi_unlinked[bucket_index] = cpu_to_be32(agino);
 	offset = offsetof(xfs_agi_t, agi_unlinked) +
 		(sizeof(xfs_agino_t) * bucket_index);
-	xfs_trans_buf_set_type(tp, agibp, XFS_BLFT_AGI_BUF);
 	xfs_trans_log_buf(tp, agibp, offset,
 			  (offset + sizeof(xfs_agino_t) - 1));
 	return 0;
@@ -2133,7 +2132,6 @@
 		agi->agi_unlinked[bucket_index] = cpu_to_be32(next_agino);
 		offset = offsetof(xfs_agi_t, agi_unlinked) +
 			(sizeof(xfs_agino_t) * bucket_index);
-		xfs_trans_buf_set_type(tp, agibp, XFS_BLFT_AGI_BUF);
 		xfs_trans_log_buf(tp, agibp, offset,
 				  (offset + sizeof(xfs_agino_t) - 1));
 	} else {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2d91f5a..7cdef80 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4929,7 +4931,6 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 	agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
 	offset = offsetof(xfs_agi_t, agi_unlinked) +
 		 (sizeof(xfs_agino_t) * bucket);
-	xfs_trans_buf_set_type(tp, agibp, XFS_BLFT_AGI_BUF);
 	xfs_trans_log_buf(tp, agibp, offset,
 			  (offset + sizeof(xfs_agino_t) - 1));
 

