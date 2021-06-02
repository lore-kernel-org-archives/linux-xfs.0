Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4029CC47080
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26D16613CC
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhFBAz1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhFBAz0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 20:55:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CD64613CA;
        Wed,  2 Jun 2021 00:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622595224;
        bh=Kr6Qe9N+01wx+w5o+s7ccRITwYnPr5A3nT/Ifdl3xUw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ikVlmz8BilRzjh68hwu49MzgG1JjAjmkD64pC8mbSm2umKquG8qOXo+0N/kSzfO2W
         5xTLYUQKXJfovBlG2aWFHwGz49PxZUn1nUQCLnuEjTieSW8v5cz1x7xXUyJ0IJ/56U
         4gi+CcoaTE59CcrnoY5ysyP5NkeNRofsfDFSOeR+oe+gNWy1e6pvYVtZHkBUg59rau
         Wcu3HK2N21c3L4HpFTzbX+gtNFY5SePt2WUvlokLbNL+rNQWhliB5jwZ86/XygqGZf
         Cpg5zxCdWCrwpEPYSQyN+AlXVebMGJ0K+xsuzrFxjR+zc2OIeBQ6mY63Xq4m4zzncU
         ym7/lgpx9AIeQ==
Subject: [PATCH 13/14] xfs: merge xfs_reclaim_inodes_ag into xfs_inode_walk_ag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Tue, 01 Jun 2021 17:53:44 -0700
Message-ID: <162259522416.662681.8769645421908758261.stgit@locust>
In-Reply-To: <162259515220.662681.6750744293005850812.stgit@locust>
References: <162259515220.662681.6750744293005850812.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Merge these two inode walk loops together, since they're pretty similar
now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |  151 +++++++++++++--------------------------------------
 fs/xfs/xfs_icache.h |    7 ++
 2 files changed, 45 insertions(+), 113 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index b17ac2f23909..f6e54e638cf4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -40,6 +40,7 @@
 enum xfs_icwalk_goal {
 	XFS_ICWALK_DQRELE	= -1,
 	XFS_ICWALK_BLOCKGC	= XFS_ICI_BLOCKGC_TAG,
+	XFS_ICWALK_RECLAIM	= XFS_ICI_RECLAIM_TAG,
 };
 
 /* Is there a radix tree tag for this goal? */
@@ -743,17 +744,6 @@ xfs_icache_inode_is_allocated(
 	return 0;
 }
 
-/*
- * The inode lookup is done in batches to keep the amount of lock traffic and
- * radix tree lookups to a minimum. The batch size is a trade off between
- * lookup reduction and stack usage. This is in the reclaim path, so we can't
- * be too greedy.
- *
- * XXX: This will be moved closer to xfs_inode_walk* once we get rid of the
- * separate reclaim walk functions.
- */
-#define XFS_LOOKUP_BATCH	32
-
 #ifdef CONFIG_XFS_QUOTA
 /* Decide if we want to grab this inode to drop its dquots. */
 static bool
@@ -865,7 +855,7 @@ xfs_dqrele_all_inodes(
  * Return true if we grabbed it, false otherwise.
  */
 static bool
-xfs_reclaim_inode_grab(
+xfs_reclaim_igrab(
 	struct xfs_inode	*ip)
 {
 	ASSERT(rcu_read_lock_held());
@@ -975,108 +965,13 @@ xfs_reclaim_inode(
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
+		xfs_inode_walk(mp, XFS_ICWALK_RECLAIM, NULL);
 	}
 }
 
@@ -1092,11 +987,16 @@ xfs_reclaim_inodes_nr(
 	struct xfs_mount	*mp,
 	int			nr_to_scan)
 {
+	struct xfs_eofblocks	eofb = {
+		.eof_flags	= XFS_EOFB_SCAN_LIMIT,
+		.nr_to_scan	= nr_to_scan,
+	};
+
 	/* kick background reclaimer and push the AIL */
 	xfs_reclaim_work_queue(mp);
 	xfs_ail_push_all(mp->m_ail);
 
-	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
+	xfs_inode_walk(mp, XFS_ICWALK_RECLAIM, &eofb);
 	return 0;
 }
 
@@ -1206,9 +1106,8 @@ xfs_reclaim_worker(
 {
 	struct xfs_mount *mp = container_of(to_delayed_work(work),
 					struct xfs_mount, m_reclaim_work);
-	int		nr_to_scan = INT_MAX;
 
-	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
+	xfs_inode_walk(mp, XFS_ICWALK_RECLAIM, NULL);
 	xfs_reclaim_work_queue(mp);
 }
 
@@ -1678,6 +1577,14 @@ xfs_blockgc_free_quota(
 
 /* XFS Incore Inode Walking Code */
 
+/*
+ * The inode lookup is done in batches to keep the amount of lock traffic and
+ * radix tree lookups to a minimum. The batch size is a trade off between
+ * lookup reduction and stack usage. This is in the reclaim path, so we can't
+ * be too greedy.
+ */
+#define XFS_LOOKUP_BATCH	32
+
 static inline bool
 xfs_grabbed_for_walk(
 	enum xfs_icwalk_goal	goal,
@@ -1688,6 +1595,8 @@ xfs_grabbed_for_walk(
 		return xfs_blockgc_igrab(ip);
 	case XFS_ICWALK_DQRELE:
 		return xfs_dqrele_igrab(ip);
+	case XFS_ICWALK_RECLAIM:
+		return xfs_reclaim_igrab(ip);
 	default:
 		return false;
 	}
@@ -1713,7 +1622,10 @@ xfs_inode_walk_ag(
 restart:
 	done = false;
 	skipped = 0;
-	first_index = 0;
+	if (goal == XFS_ICWALK_RECLAIM)
+		first_index = READ_ONCE(pag->pag_ici_reclaim_cursor);
+	else
+		first_index = 0;
 	nr_found = 0;
 	do {
 		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
@@ -1733,6 +1645,7 @@ xfs_inode_walk_ag(
 					XFS_LOOKUP_BATCH, goal);
 
 		if (!nr_found) {
+			done = true;
 			rcu_read_unlock();
 			break;
 		}
@@ -1779,6 +1692,9 @@ xfs_inode_walk_ag(
 			case XFS_ICWALK_BLOCKGC:
 				error = xfs_blockgc_scan_inode(batch[i], eofb);
 				break;
+			case XFS_ICWALK_RECLAIM:
+				xfs_reclaim_inode(batch[i], pag);
+				break;
 			}
 			if (error == -EAGAIN) {
 				skipped++;
@@ -1794,8 +1710,19 @@ xfs_inode_walk_ag(
 
 		cond_resched();
 
+		if (eofb && (eofb->eof_flags & XFS_EOFB_SCAN_LIMIT)) {
+			eofb->nr_to_scan -= XFS_LOOKUP_BATCH;
+			if (eofb->nr_to_scan <= 0)
+				break;
+		}
 	} while (nr_found && !done);
 
+	if (goal == XFS_ICWALK_RECLAIM) {
+		if (done)
+			first_index = 0;
+		WRITE_ONCE(pag->pag_ici_reclaim_cursor, first_index);
+	}
+
 	if (skipped) {
 		delay(1);
 		goto restart;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 6f6260c91ba0..63e116c339a8 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -15,6 +15,7 @@ struct xfs_eofblocks {
 	kgid_t		eof_gid;
 	prid_t		eof_prid;
 	__u64		eof_min_file_size;
+	int		nr_to_scan;
 };
 
 /* Special eof_flags for dropping dquots. */
@@ -22,9 +23,13 @@ struct xfs_eofblocks {
 #define XFS_EOFB_DROP_GDQUOT	(1U << 30)
 #define XFS_EOFB_DROP_PDQUOT	(1U << 29)
 
+/* Stop scanning after nr_to_scan inodes. */
+#define XFS_EOFB_SCAN_LIMIT	(1U << 28)
+
 #define XFS_EOFB_PRIVATE_FLAGS	(XFS_EOFB_DROP_UDQUOT | \
 				 XFS_EOFB_DROP_GDQUOT | \
-				 XFS_EOFB_DROP_PDQUOT)
+				 XFS_EOFB_DROP_PDQUOT | \
+				 XFS_EOFB_SCAN_LIMIT)
 
 /*
  * Flags for xfs_iget()

