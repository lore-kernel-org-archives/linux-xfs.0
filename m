Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7FAC433E8
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A38B2083B
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgHLJ0E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 05:26:04 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:59799 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727858AbgHLJ0D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Aug 2020 05:26:03 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 79EFC760A78
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 19:25:57 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1B-0003QS-2h
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:57 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1A-00Alsp-OJ
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/13] xfs: arrange all unlinked inodes into one list
Date:   Wed, 12 Aug 2020 19:25:47 +1000
Message-Id: <20200812092556.2567285-5-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200812092556.2567285-1-david@fromorbit.com>
References: <20200812092556.2567285-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=f0rWBM-Tsbf7WVgQqeQA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

We currently keep unlinked lists short on disk by hashing the inodes
across multiple buckets. We don't need to ikeep them short anymore
as we no longer need to traverse the entire to remove an inode from
it. The in-memory back reference index provides the previous inode
in the list for us instead.

Log recovery still has to handle existing filesystems that use all
64 on-disk buckets so we detect and handle this case specially so
that so inode eviction can still work properly in recovery.

[dchinner: imported into parent patch series early on and modified
to fit cleanly. ]

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 49 +++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f2f502b65691..fa92bdf6e0da 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -33,6 +33,7 @@
 #include "xfs_symlink.h"
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
 
@@ -2092,25 +2093,32 @@ xfs_iunlink_update_bucket(
 	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
 	struct xfs_buf		*agibp,
-	unsigned int		bucket_index,
+	xfs_agino_t		old_agino,
 	xfs_agino_t		new_agino)
 {
+	struct xlog		*log = tp->t_mountp->m_log;
 	struct xfs_agi		*agi = agibp->b_addr;
 	xfs_agino_t		old_value;
-	int			offset;
+	unsigned int		bucket_index;
+	int                     offset;
 
 	ASSERT(xfs_verify_agino_or_null(tp->t_mountp, agno, new_agino));
 
+	bucket_index = 0;
+	/* During recovery, the old multiple bucket index can be applied */
+	if (!log || log->l_flags & XLOG_RECOVERY_NEEDED) {
+		ASSERT(old_agino != NULLAGINO);
+
+		if (be32_to_cpu(agi->agi_unlinked[0]) != old_agino)
+			bucket_index = old_agino % XFS_AGI_UNLINKED_BUCKETS;
+	}
+
 	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
 	trace_xfs_iunlink_update_bucket(tp->t_mountp, agno, bucket_index,
 			old_value, new_agino);
 
-	/*
-	 * We should never find the head of the list already set to the value
-	 * passed in because either we're adding or removing ourselves from the
-	 * head of the list.
-	 */
-	if (old_value == new_agino) {
+	/* check if the old agi_unlinked head is as expected */
+	if (old_value != old_agino) {
 		xfs_buf_mark_corrupt(agibp);
 		return -EFSCORRUPTED;
 	}
@@ -2216,17 +2224,18 @@ xfs_iunlink_insert_inode(
 	xfs_agino_t		next_agino;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
-	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
 
 	agi = agibp->b_addr;
 
 	/*
-	 * Get the index into the agi hash table for the list this inode will
-	 * go on.  Make sure the pointer isn't garbage and that this inode
-	 * isn't already on the list.
+	 * We don't need to traverse the on disk unlinked list to find the
+	 * previous inode in the list when removing inodes anymore, so we don't
+	 * need multiple on-disk lists anymore. Hence we always use bucket 0.
+	 * Make sure the pointer isn't garbage and that this inode isn't already
+	 * on the list.
 	 */
-	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	next_agino = be32_to_cpu(agi->agi_unlinked[0]);
 	if (next_agino == agino ||
 	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
 		xfs_buf_mark_corrupt(agibp);
@@ -2256,7 +2265,7 @@ xfs_iunlink_insert_inode(
 	}
 
 	/* Point the head of the list to point to this inode. */
-	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index, agino);
+	return xfs_iunlink_update_bucket(tp, agno, agibp, next_agino, agino);
 }
 
 /*
@@ -2416,16 +2425,17 @@ xfs_iunlink_remove_inode(
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		next_agino;
 	xfs_agino_t		head_agino;
-	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
 
 	agi = agibp->b_addr;
 
 	/*
-	 * Get the index into the agi hash table for the list this inode will
-	 * go on.  Make sure the head pointer isn't garbage.
+	 * We don't need to traverse the on disk unlinked list to find the
+	 * previous inode in the list when removing inodes anymore, so we don't
+	 * need multiple on-disk lists anymore. Hence we always use bucket 0.
+	 * Make sure the head pointer isn't garbage.
 	 */
-	head_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	head_agino = be32_to_cpu(agi->agi_unlinked[0]);
 	if (!xfs_verify_agino(mp, agno, head_agino)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				agi, sizeof(*agi));
@@ -2483,8 +2493,7 @@ xfs_iunlink_remove_inode(
 	}
 
 	/* Point the head of the list to the next unlinked inode. */
-	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
-			next_agino);
+	return xfs_iunlink_update_bucket(tp, agno, agibp, agino, next_agino);
 }
 
 /*
-- 
2.26.2.761.g0e0b3e54be

