Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C21C433F4
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D7FD20734
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgFAVnG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 17:43:06 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:40434 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728845AbgFAVnE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 17:43:04 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 82C9D5AAE74
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 07:42:55 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-0000X1-KK
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-00HU6A-BT
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 19/30] xfs: allow multiple reclaimers per AG
Date:   Tue,  2 Jun 2020 07:42:40 +1000
Message-Id: <20200601214251.4167140-20-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200601214251.4167140-1-david@fromorbit.com>
References: <20200601214251.4167140-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=vMY9R6GoBIkpaNy9teYA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Inode reclaim will still throttle direct reclaim on the per-ag
reclaim locks. This is no longer necessary as reclaim can run
non-blocking now. Hence we can remove these locks so that we don't
arbitrarily block reclaimers just because there are more direct
reclaimers than there are AGs.

This can result in multiple reclaimers working on the same range of
an AG, but this doesn't cause any apparent issues. Optimising the
spread of concurrent reclaimers for best efficiency can be done in a
future patchset.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c | 31 ++++++++++++-------------------
 fs/xfs/xfs_mount.c  |  4 ----
 fs/xfs/xfs_mount.h  |  1 -
 3 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 74032316ce5cc..c4ba8d7bc45bc 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1211,12 +1211,9 @@ xfs_reclaim_inodes_ag(
 	int			*nr_to_scan)
 {
 	struct xfs_perag	*pag;
-	xfs_agnumber_t		ag;
-	int			trylock = flags & SYNC_TRYLOCK;
-	int			skipped;
+	xfs_agnumber_t		ag = 0;
+	int			skipped = 0;
 
-	ag = 0;
-	skipped = 0;
 	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
 		unsigned long	first_index = 0;
 		int		done = 0;
@@ -1224,15 +1221,13 @@ xfs_reclaim_inodes_ag(
 
 		ag = pag->pag_agno + 1;
 
-		if (trylock) {
-			if (!mutex_trylock(&pag->pag_ici_reclaim_lock)) {
-				skipped++;
-				xfs_perag_put(pag);
-				continue;
-			}
-			first_index = pag->pag_ici_reclaim_cursor;
-		} else
-			mutex_lock(&pag->pag_ici_reclaim_lock);
+		/*
+		 * If the cursor is not zero, we haven't scanned the whole AG
+		 * so we might have skipped inodes here.
+		 */
+		first_index = READ_ONCE(pag->pag_ici_reclaim_cursor);
+		if (first_index)
+			skipped++;
 
 		do {
 			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
@@ -1298,11 +1293,9 @@ xfs_reclaim_inodes_ag(
 
 		} while (nr_found && !done && *nr_to_scan > 0);
 
-		if (trylock && !done)
-			pag->pag_ici_reclaim_cursor = first_index;
-		else
-			pag->pag_ici_reclaim_cursor = 0;
-		mutex_unlock(&pag->pag_ici_reclaim_lock);
+		if (done)
+			first_index = 0;
+		WRITE_ONCE(pag->pag_ici_reclaim_cursor, first_index);
 		xfs_perag_put(pag);
 	}
 	return skipped;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d5dcf98698600..03158b42a1943 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -148,7 +148,6 @@ xfs_free_perag(
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
 		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
-		mutex_destroy(&pag->pag_ici_reclaim_lock);
 		call_rcu(&pag->rcu_head, __xfs_free_perag);
 	}
 }
@@ -200,7 +199,6 @@ xfs_initialize_perag(
 		pag->pag_agno = index;
 		pag->pag_mount = mp;
 		spin_lock_init(&pag->pag_ici_lock);
-		mutex_init(&pag->pag_ici_reclaim_lock);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		if (xfs_buf_hash_init(pag))
 			goto out_free_pag;
@@ -242,7 +240,6 @@ xfs_initialize_perag(
 out_hash_destroy:
 	xfs_buf_hash_destroy(pag);
 out_free_pag:
-	mutex_destroy(&pag->pag_ici_reclaim_lock);
 	kmem_free(pag);
 out_unwind_new_pags:
 	/* unwind any prior newly initialized pags */
@@ -252,7 +249,6 @@ xfs_initialize_perag(
 			break;
 		xfs_buf_hash_destroy(pag);
 		xfs_iunlink_destroy(pag);
-		mutex_destroy(&pag->pag_ici_reclaim_lock);
 		kmem_free(pag);
 	}
 	return error;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 3725d25ad97e8..a72cfcaa4ad12 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -354,7 +354,6 @@ typedef struct xfs_perag {
 	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
 	int		pag_ici_reclaimable;	/* reclaimable inodes */
-	struct mutex	pag_ici_reclaim_lock;	/* serialisation point */
 	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
 
 	/* buffer cache index */
-- 
2.26.2.761.g0e0b3e54be

