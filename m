Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:55831 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932255AbdJZIda (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 04:33:30 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0003CX-G7
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0005MF-Ez
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/14] xfs: convert growfs AG header init to use buffer lists
Date: Thu, 26 Oct 2017 19:33:10 +1100
Message-Id: <20171026083322.20428-3-david@fromorbit.com>
In-Reply-To: <20171026083322.20428-1-david@fromorbit.com>
References: <20171026083322.20428-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We currently write all new AG headers synchronously, which can be
slow for large grow operations. All we really need to do is ensure
all the headers are on disk before we run the growfs transaction, so
convert this to a buffer list and a delayed write operation. We
block waiting for the delayed write buffer submission to complete,
so this will fulfill the requirement to have all the buffers written
correctly before proceeding.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c | 74 ++++++++++++++++++++++++------------------------------
 1 file changed, 33 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 487a9dca1170..d21181d938dd 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -158,7 +158,8 @@ xfs_grow_ag_headers(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	xfs_extlen_t		agsize,
-	xfs_rfsblock_t		*nfree)
+	xfs_rfsblock_t		*nfree,
+	struct list_head	*buffer_list)
 {
 	struct xfs_agf		*agf;
 	struct xfs_agi		*agi;
@@ -212,11 +213,8 @@ xfs_grow_ag_headers(
 		agf->agf_refcount_level = cpu_to_be32(1);
 		agf->agf_refcount_blocks = cpu_to_be32(1);
 	}
-
-	error = xfs_bwrite(bp);
+	xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
-	if (error)
-		goto out_error;
 
 	/*
 	 * AG freelist header block
@@ -241,10 +239,8 @@ xfs_grow_ag_headers(
 	for (bucket = 0; bucket < XFS_AGFL_SIZE(mp); bucket++)
 		agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
 
-	error = xfs_bwrite(bp);
+	xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
-	if (error)
-		goto out_error;
 
 	/*
 	 * AG inode header block
@@ -278,10 +274,8 @@ xfs_grow_ag_headers(
 	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
 		agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
 
-	error = xfs_bwrite(bp);
+	xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
-	if (error)
-		goto out_error;
 
 	/*
 	 * BNO btree root block
@@ -303,10 +297,8 @@ xfs_grow_ag_headers(
 	arec->ar_blockcount = cpu_to_be32(
 		agsize - be32_to_cpu(arec->ar_startblock));
 
-	error = xfs_bwrite(bp);
+	xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
-	if (error)
-		goto out_error;
 
 	/*
 	 * CNT btree root block
@@ -328,10 +320,8 @@ xfs_grow_ag_headers(
 		agsize - be32_to_cpu(arec->ar_startblock));
 	*nfree += be32_to_cpu(arec->ar_blockcount);
 
-	error = xfs_bwrite(bp);
+	xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
-	if (error)
-		goto out_error;
 
 	/* RMAP btree root block */
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
@@ -403,10 +393,8 @@ xfs_grow_ag_headers(
 			be16_add_cpu(&block->bb_numrecs, 1);
 		}
 
-		error = xfs_bwrite(bp);
+		xfs_buf_delwri_queue(bp, buffer_list);
 		xfs_buf_relse(bp);
-		if (error)
-			goto out_error;
 	}
 
 	/*
@@ -422,11 +410,8 @@ xfs_grow_ag_headers(
 	}
 
 	xfs_btree_init_block(mp, bp, XFS_BTNUM_INO , 0, 0, agno, 0);
-
-	error = xfs_bwrite(bp);
+	xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
-	if (error)
-		goto out_error;
 
 	/*
 	 * FINO btree root block
@@ -441,13 +426,9 @@ xfs_grow_ag_headers(
 			goto out_error;
 		}
 
-		xfs_btree_init_block(mp, bp, XFS_BTNUM_FINO,
-					     0, 0, agno, 0);
-
-		error = xfs_bwrite(bp);
+		xfs_btree_init_block(mp, bp, XFS_BTNUM_FINO, 0, 0, agno, 0);
+		xfs_buf_delwri_queue(bp, buffer_list);
 		xfs_buf_relse(bp);
-		if (error)
-			goto out_error;
 	}
 
 	/*
@@ -463,13 +444,9 @@ xfs_grow_ag_headers(
 			goto out_error;
 		}
 
-		xfs_btree_init_block(mp, bp, XFS_BTNUM_REFC,
-				     0, 0, agno, 0);
-
-		error = xfs_bwrite(bp);
+		xfs_btree_init_block(mp, bp, XFS_BTNUM_REFC, 0, 0, agno, 0);
+		xfs_buf_delwri_queue(bp, buffer_list);
 		xfs_buf_relse(bp);
-		if (error)
-			goto out_error;
 	}
 
 out_error:
@@ -496,6 +473,7 @@ xfs_growfs_data_private(
 	xfs_agnumber_t		oagcount;
 	int			pct;
 	xfs_trans_t		*tp;
+	LIST_HEAD		(buffer_list);
 
 	nb = in->newblocks;
 	pct = in->imaxpct;
@@ -536,9 +514,16 @@ xfs_growfs_data_private(
 		return error;
 
 	/*
-	 * Write new AG headers to disk. Non-transactional, but written
-	 * synchronously so they are completed prior to the growfs transaction
-	 * being logged.
+	 * Write new AG headers to disk. Non-transactional, but need to be
+	 * written and completed prior to the growfs transaction being logged.
+	 * To do this, we use a delayed write buffer list and wait for
+	 * submission and IO completion of the list as a whole. This allows the
+	 * IO subsystem to merge all the AG headers in a single AG into a single
+	 * IO and hide most of the latency of the IO from us.
+	 *
+	 * This also means that if we get an error whilst building the buffer
+	 * list to write, we can cancel the entire list without having written
+	 * anything.
 	 */
 	nfree = 0;
 	for (agno = nagcount - 1; agno >= oagcount; agno--, new -= agsize) {
@@ -549,10 +534,17 @@ xfs_growfs_data_private(
 		else
 			agsize = mp->m_sb.sb_agblocks;
 
-		error = xfs_grow_ag_headers(mp, agno, agsize, &nfree);
-		if (error)
+		error = xfs_grow_ag_headers(mp, agno, agsize, &nfree,
+					    &buffer_list);
+		if (error) {
+			xfs_buf_delwri_cancel(&buffer_list);
 			goto error0;
+		}
 	}
+	error = xfs_buf_delwri_submit(&buffer_list);
+	if (error)
+		goto error0;
+
 	xfs_trans_agblocks_delta(tp, nfree);
 
 	/*
-- 
2.15.0.rc0

