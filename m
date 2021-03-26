Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F47C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA4FA619F3
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhCZAWN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230100AbhCZAVl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:21:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23A5661A48;
        Fri, 26 Mar 2021 00:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718101;
        bh=VlYJoA+BcNA8nhDNwLrEAMiF6GglFppZFDn3VtHVDxY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DJbe3d5/TeDZjo2zjhpKn/jZK3nLsRuCvqJEIcmzDWTpItKbPNQj4k89ZoP2hrXam
         e4PJHmrk2kpXteK27K/nSi8LDjnLHcZv1Ubyy+hTJ564g5x0JOvNrr3X9eSAjMAxX4
         zyyZNB8vO8bmw8y/+sA5PljsiHZ1IrtPfy+wMFXNlLu6Y05JP2YQsxMg5Hs6jT+e+7
         fJR1a5pvsjjOKrDRkNX8Nlt9hv8capALg1y3rqXvKeMuyab52kJQ0uNKNNRXyrolLm
         29vEe1YYcnIl2tL4aTf+fJYfyalHrUxShV9HuwitsFwKYvURbELBo56C6sI0Ienucn
         tLcUQVFwjf8Mw==
Subject: [PATCH 5/6] xfs: merge xfs_reclaim_inodes_ag into xfs_inode_walk_ag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:21:40 -0700
Message-ID: <161671810078.621936.339407186528826628.stgit@magnolia>
In-Reply-To: <161671807287.621936.13471099564526590235.stgit@magnolia>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Merge these two inode walk loops together, since they're pretty similar
now.  Get rid of XFS_ICI_NO_TAG since nobody uses it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |  154 ++++++++++++++++-----------------------------------
 fs/xfs/xfs_icache.h |    5 +-
 2 files changed, 52 insertions(+), 107 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index b02b4b349ee9..2b25fe679b0e 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -29,6 +29,8 @@
 /* Forward declarations to reduce indirect calls */
 static int xfs_blockgc_scan_inode(struct xfs_inode *ip,
 		struct xfs_eofblocks *eofb);
+static bool xfs_reclaim_inode_grab(struct xfs_inode *ip);
+static void xfs_reclaim_inode(struct xfs_inode *ip, struct xfs_perag *pag);
 
 /*
  * Allocate and initialise an xfs_inode.
@@ -769,6 +771,21 @@ xfs_blockgc_grab(
 	return false;
 }
 
+static inline bool
+selected_for_walk(
+	unsigned int		tag,
+	struct xfs_inode	*ip)
+{
+	switch (tag) {
+	case XFS_ICI_BLOCKGC_TAG:
+		return xfs_blockgc_grab(ip);
+	case XFS_ICI_RECLAIM_TAG:
+		return xfs_reclaim_inode_grab(ip);
+	default:
+		return false;
+	}
+}
+
 /*
  * For a given per-AG structure @pag, grab, execute a tag specific function,
  * and release all incore inodes with the given radix tree @tag.
@@ -786,12 +803,14 @@ xfs_inode_walk_ag(
 	bool			done;
 	int			nr_found;
 
-	ASSERT(tag == XFS_ICI_BLOCKGC_TAG);
+	ASSERT(tag < RADIX_TREE_MAX_TAGS);
 
 restart:
 	done = false;
 	skipped = 0;
 	first_index = 0;
+	if (tag == XFS_ICI_RECLAIM_TAG)
+		first_index = READ_ONCE(pag->pag_ici_reclaim_cursor);
 	nr_found = 0;
 	do {
 		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
@@ -804,6 +823,7 @@ xfs_inode_walk_ag(
 				(void **)batch, first_index, XFS_LOOKUP_BATCH,
 				tag);
 		if (!nr_found) {
+			done = true;
 			rcu_read_unlock();
 			break;
 		}
@@ -815,7 +835,7 @@ xfs_inode_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_blockgc_grab(ip))
+			if (done || !selected_for_walk(tag, ip))
 				batch[i] = NULL;
 
 			/*
@@ -843,8 +863,16 @@ xfs_inode_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			error = xfs_blockgc_scan_inode(batch[i], eofb);
-			xfs_irele(batch[i]);
+			switch (tag) {
+			case XFS_ICI_BLOCKGC_TAG:
+				error = xfs_blockgc_scan_inode(batch[i], eofb);
+				xfs_irele(batch[i]);
+				break;
+			case XFS_ICI_RECLAIM_TAG:
+				xfs_reclaim_inode(batch[i], pag);
+				error = 0;
+				break;
+			}
 			if (error == -EAGAIN) {
 				skipped++;
 				continue;
@@ -858,9 +886,19 @@ xfs_inode_walk_ag(
 			break;
 
 		cond_resched();
-
+		if (tag == XFS_ICI_RECLAIM_TAG && eofb) {
+			eofb->nr_to_scan -= XFS_LOOKUP_BATCH;
+			if (eofb->nr_to_scan < 0)
+				break;
+		}
 	} while (nr_found && !done);
 
+	if (tag == XFS_ICI_RECLAIM_TAG) {
+		if (done)
+			first_index = 0;
+		WRITE_ONCE(pag->pag_ici_reclaim_cursor, first_index);
+	}
+
 	if (skipped) {
 		delay(1);
 		goto restart;
@@ -883,7 +921,7 @@ xfs_inode_walk(
 	int			last_error = 0;
 	xfs_agnumber_t		ag;
 
-	ASSERT(tag == XFS_ICI_BLOCKGC_TAG);
+	ASSERT(tag < RADIX_TREE_MAX_TAGS);
 
 	ag = 0;
 	while ((pag = xfs_perag_get_tag(mp, ag, tag))) {
@@ -1027,108 +1065,13 @@ xfs_reclaim_inode(
 	xfs_iflags_clear(ip, XFS_IRECLAIM);
 }
 
-/*
- * Walk the AGs and reclaim the inodes in them. Even if the filesystem is
- * corrupted, we still want to try to reclaim all the inodes. If we don't,
- * then a shut down during filesystem unmount reclaim walk leak all the
- * unreclaimed inodes.
- *
- * Returns non-zero if any AGs or inodes were skipped in the reclaim pass
- * so that callers that want to block until all dirty inodes are written back
- * and reclaimed can sanely loop.
- */
-static void
-xfs_reclaim_inodes_ag(
-	struct xfs_mount	*mp,
-	int			*nr_to_scan)
-{
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		ag = 0;
-
-	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
-		unsigned long	first_index = 0;
-		int		done = 0;
-		int		nr_found = 0;
-
-		ag = pag->pag_agno + 1;
-
-		first_index = READ_ONCE(pag->pag_ici_reclaim_cursor);
-		do {
-			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
-			int	i;
-
-			rcu_read_lock();
-			nr_found = radix_tree_gang_lookup_tag(
-					&pag->pag_ici_root,
-					(void **)batch, first_index,
-					XFS_LOOKUP_BATCH,
-					XFS_ICI_RECLAIM_TAG);
-			if (!nr_found) {
-				done = 1;
-				rcu_read_unlock();
-				break;
-			}
-
-			/*
-			 * Grab the inodes before we drop the lock. if we found
-			 * nothing, nr == 0 and the loop will be skipped.
-			 */
-			for (i = 0; i < nr_found; i++) {
-				struct xfs_inode *ip = batch[i];
-
-				if (done || !xfs_reclaim_inode_grab(ip))
-					batch[i] = NULL;
-
-				/*
-				 * Update the index for the next lookup. Catch
-				 * overflows into the next AG range which can
-				 * occur if we have inodes in the last block of
-				 * the AG and we are currently pointing to the
-				 * last inode.
-				 *
-				 * Because we may see inodes that are from the
-				 * wrong AG due to RCU freeing and
-				 * reallocation, only update the index if it
-				 * lies in this AG. It was a race that lead us
-				 * to see this inode, so another lookup from
-				 * the same index will not find it again.
-				 */
-				if (XFS_INO_TO_AGNO(mp, ip->i_ino) !=
-								pag->pag_agno)
-					continue;
-				first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
-				if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
-					done = 1;
-			}
-
-			/* unlock now we've grabbed the inodes. */
-			rcu_read_unlock();
-
-			for (i = 0; i < nr_found; i++) {
-				if (batch[i])
-					xfs_reclaim_inode(batch[i], pag);
-			}
-
-			*nr_to_scan -= XFS_LOOKUP_BATCH;
-			cond_resched();
-		} while (nr_found && !done && *nr_to_scan > 0);
-
-		if (done)
-			first_index = 0;
-		WRITE_ONCE(pag->pag_ici_reclaim_cursor, first_index);
-		xfs_perag_put(pag);
-	}
-}
-
 void
 xfs_reclaim_inodes(
 	struct xfs_mount	*mp)
 {
-	int		nr_to_scan = INT_MAX;
-
 	while (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
 		xfs_ail_push_all_sync(mp->m_ail);
-		xfs_reclaim_inodes_ag(mp, &nr_to_scan);
+		xfs_inode_walk(mp, XFS_ICI_RECLAIM_TAG, NULL);
 	}
 }
 
@@ -1144,11 +1087,13 @@ xfs_reclaim_inodes_nr(
 	struct xfs_mount	*mp,
 	int			nr_to_scan)
 {
+	struct xfs_eofblocks	eofb = { .nr_to_scan = nr_to_scan };
+
 	/* kick background reclaimer and push the AIL */
 	xfs_reclaim_work_queue(mp);
 	xfs_ail_push_all(mp->m_ail);
 
-	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
+	xfs_inode_walk(mp, XFS_ICI_RECLAIM_TAG, &eofb);
 	return 0;
 }
 
@@ -1258,9 +1203,8 @@ xfs_reclaim_worker(
 {
 	struct xfs_mount *mp = container_of(to_delayed_work(work),
 					struct xfs_mount, m_reclaim_work);
-	int		nr_to_scan = INT_MAX;
 
-	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
+	xfs_inode_walk(mp, XFS_ICI_RECLAIM_TAG, NULL);
 	xfs_reclaim_work_queue(mp);
 }
 
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d52c041093a3..bde7bab84230 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -15,13 +15,14 @@ struct xfs_eofblocks {
 	kgid_t		eof_gid;
 	prid_t		eof_prid;
 	__u64		eof_min_file_size;
+
+	/* Number of inodes to scan, currently limited to reclaim */
+	int		nr_to_scan;
 };
 
 /*
  * tags for inode radix tree
  */
-#define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
-					   in xfs_inode_walk */
 #define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
 /* Inode has speculative preallocations (posteof or cow) to clean. */
 #define XFS_ICI_BLOCKGC_TAG	1

