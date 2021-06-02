Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4CDC4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79E27613CC
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhFBAyb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:54:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229654AbhFBAyb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 20:54:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74A9D613C5;
        Wed,  2 Jun 2021 00:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622595169;
        bh=i7Wfsp4ADXVCdvKY0yPah8dOZgiFVW669hxRV4dEjFk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c4DNDO2NPpqwFVgcXm6vKS5QArv0AOJ9V4157dpB6TWL3/L1F9sQDmYb7xlYlIXcf
         ltoJtY2DaYPAUtUKqgX4Qlq3A46LcOu1pTUusccq6CNN4TOAxxoCS07lLKWsfg4TrH
         TCA02xYLOBiJRMFbq1m1ssNPkwIPehF8Yg1gTkOMJZ6DBHPMFdvxVOoUVn5J6mRayA
         UEy9KjB+qRMfcHF5hPbg/ETOMZJey2QDqUCLMPDKUPbFyMypmNJrIARZ/1Dkry3BlV
         UdmLwMWE99Xi9XeCNh9r06h+DSWKFUfSfmwERKVyucRDE3S2sqFxuR30ZSRRgkdzgN
         9Ci6afP95M6VQ==
Subject: [PATCH 03/14] xfs: move the inode walk functions further down
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Tue, 01 Jun 2021 17:52:49 -0700
Message-ID: <162259516919.662681.15253025725321641773.stgit@locust>
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

Move the inode walk functions further down in the file to limit the
forward declarations to the two walk functions as we add new code that
uses the inode walks.  We'll clean them out later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |  400 ++++++++++++++++++++++++++-------------------------
 1 file changed, 206 insertions(+), 194 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1de5846b3c0a..e70ce7868444 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -26,6 +26,13 @@
 
 #include <linux/iversion.h>
 
+static int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
+		int (*execute)(struct xfs_inode *ip, void *args),
+		void *args, int tag);
+static int xfs_inode_walk_ag(struct xfs_perag *pag, int iter_flags,
+		int (*execute)(struct xfs_inode *ip, void *args),
+		void *args, int tag);
+
 /*
  * Allocate and initialise an xfs_inode.
  */
@@ -720,203 +727,12 @@ xfs_icache_inode_is_allocated(
  * radix tree lookups to a minimum. The batch size is a trade off between
  * lookup reduction and stack usage. This is in the reclaim path, so we can't
  * be too greedy.
+ *
+ * XXX: This will be moved closer to xfs_inode_walk* once we get rid of the
+ * separate reclaim walk functions.
  */
 #define XFS_LOOKUP_BATCH	32
 
-/*
- * Decide if the given @ip is eligible to be a part of the inode walk, and
- * grab it if so.  Returns true if it's ready to go or false if we should just
- * ignore it.
- */
-STATIC bool
-xfs_inode_walk_ag_grab(
-	struct xfs_inode	*ip,
-	int			flags)
-{
-	struct inode		*inode = VFS_I(ip);
-	bool			newinos = !!(flags & XFS_INODE_WALK_INEW_WAIT);
-
-	ASSERT(rcu_read_lock_held());
-
-	/* Check for stale RCU freed inode */
-	spin_lock(&ip->i_flags_lock);
-	if (!ip->i_ino)
-		goto out_unlock_noent;
-
-	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
-	if ((!newinos && __xfs_iflags_test(ip, XFS_INEW)) ||
-	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM))
-		goto out_unlock_noent;
-	spin_unlock(&ip->i_flags_lock);
-
-	/* nothing to sync during shutdown */
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return false;
-
-	/* If we can't grab the inode, it must on it's way to reclaim. */
-	if (!igrab(inode))
-		return false;
-
-	/* inode is valid */
-	return true;
-
-out_unlock_noent:
-	spin_unlock(&ip->i_flags_lock);
-	return false;
-}
-
-/*
- * For a given per-AG structure @pag, grab, @execute, and rele all incore
- * inodes with the given radix tree @tag.
- */
-STATIC int
-xfs_inode_walk_ag(
-	struct xfs_perag	*pag,
-	int			iter_flags,
-	int			(*execute)(struct xfs_inode *ip, void *args),
-	void			*args,
-	int			tag)
-{
-	struct xfs_mount	*mp = pag->pag_mount;
-	uint32_t		first_index;
-	int			last_error = 0;
-	int			skipped;
-	bool			done;
-	int			nr_found;
-
-restart:
-	done = false;
-	skipped = 0;
-	first_index = 0;
-	nr_found = 0;
-	do {
-		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
-		int		error = 0;
-		int		i;
-
-		rcu_read_lock();
-
-		if (tag == XFS_ICI_NO_TAG)
-			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
-					(void **)batch, first_index,
-					XFS_LOOKUP_BATCH);
-		else
-			nr_found = radix_tree_gang_lookup_tag(
-					&pag->pag_ici_root,
-					(void **) batch, first_index,
-					XFS_LOOKUP_BATCH, tag);
-
-		if (!nr_found) {
-			rcu_read_unlock();
-			break;
-		}
-
-		/*
-		 * Grab the inodes before we drop the lock. if we found
-		 * nothing, nr == 0 and the loop will be skipped.
-		 */
-		for (i = 0; i < nr_found; i++) {
-			struct xfs_inode *ip = batch[i];
-
-			if (done || !xfs_inode_walk_ag_grab(ip, iter_flags))
-				batch[i] = NULL;
-
-			/*
-			 * Update the index for the next lookup. Catch
-			 * overflows into the next AG range which can occur if
-			 * we have inodes in the last block of the AG and we
-			 * are currently pointing to the last inode.
-			 *
-			 * Because we may see inodes that are from the wrong AG
-			 * due to RCU freeing and reallocation, only update the
-			 * index if it lies in this AG. It was a race that lead
-			 * us to see this inode, so another lookup from the
-			 * same index will not find it again.
-			 */
-			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
-				continue;
-			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
-			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
-				done = true;
-		}
-
-		/* unlock now we've grabbed the inodes. */
-		rcu_read_unlock();
-
-		for (i = 0; i < nr_found; i++) {
-			if (!batch[i])
-				continue;
-			if ((iter_flags & XFS_INODE_WALK_INEW_WAIT) &&
-			    xfs_iflags_test(batch[i], XFS_INEW))
-				xfs_inew_wait(batch[i]);
-			error = execute(batch[i], args);
-			xfs_irele(batch[i]);
-			if (error == -EAGAIN) {
-				skipped++;
-				continue;
-			}
-			if (error && last_error != -EFSCORRUPTED)
-				last_error = error;
-		}
-
-		/* bail out if the filesystem is corrupted.  */
-		if (error == -EFSCORRUPTED)
-			break;
-
-		cond_resched();
-
-	} while (nr_found && !done);
-
-	if (skipped) {
-		delay(1);
-		goto restart;
-	}
-	return last_error;
-}
-
-/* Fetch the next (possibly tagged) per-AG structure. */
-static inline struct xfs_perag *
-xfs_inode_walk_get_perag(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	int			tag)
-{
-	if (tag == XFS_ICI_NO_TAG)
-		return xfs_perag_get(mp, agno);
-	return xfs_perag_get_tag(mp, agno, tag);
-}
-
-/*
- * Call the @execute function on all incore inodes matching the radix tree
- * @tag.
- */
-static int
-xfs_inode_walk(
-	struct xfs_mount	*mp,
-	int			iter_flags,
-	int			(*execute)(struct xfs_inode *ip, void *args),
-	void			*args,
-	int			tag)
-{
-	struct xfs_perag	*pag;
-	int			error = 0;
-	int			last_error = 0;
-	xfs_agnumber_t		ag;
-
-	ag = 0;
-	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
-		ag = pag->pag_agno + 1;
-		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, tag);
-		xfs_perag_put(pag);
-		if (error) {
-			last_error = error;
-			if (error == -EFSCORRUPTED)
-				break;
-		}
-	}
-	return last_error;
-}
-
 #ifdef CONFIG_XFS_QUOTA
 /* Drop this inode's dquots. */
 static int
@@ -1638,6 +1454,48 @@ xfs_blockgc_start(
 		xfs_blockgc_queue(pag);
 }
 
+/*
+ * Decide if the given @ip is eligible to be a part of the inode walk, and
+ * grab it if so.  Returns true if it's ready to go or false if we should just
+ * ignore it.
+ */
+static bool
+xfs_inode_walk_ag_grab(
+	struct xfs_inode	*ip,
+	int			flags)
+{
+	struct inode		*inode = VFS_I(ip);
+	bool			newinos = !!(flags & XFS_INODE_WALK_INEW_WAIT);
+
+	ASSERT(rcu_read_lock_held());
+
+	/* Check for stale RCU freed inode */
+	spin_lock(&ip->i_flags_lock);
+	if (!ip->i_ino)
+		goto out_unlock_noent;
+
+	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
+	if ((!newinos && __xfs_iflags_test(ip, XFS_INEW)) ||
+	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM))
+		goto out_unlock_noent;
+	spin_unlock(&ip->i_flags_lock);
+
+	/* nothing to sync during shutdown */
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return false;
+
+	/* If we can't grab the inode, it must on it's way to reclaim. */
+	if (!igrab(inode))
+		return false;
+
+	/* inode is valid */
+	return true;
+
+out_unlock_noent:
+	spin_unlock(&ip->i_flags_lock);
+	return false;
+}
+
 /* Scan one incore inode for block preallocations that we can remove. */
 static int
 xfs_blockgc_scan_inode(
@@ -1758,3 +1616,157 @@ xfs_blockgc_free_quota(
 			xfs_inode_dquot(ip, XFS_DQTYPE_GROUP),
 			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), eof_flags);
 }
+
+/* XFS Incore Inode Walking Code */
+
+/*
+ * For a given per-AG structure @pag, grab, @execute, and rele all incore
+ * inodes with the given radix tree @tag.
+ */
+static int
+xfs_inode_walk_ag(
+	struct xfs_perag	*pag,
+	int			iter_flags,
+	int			(*execute)(struct xfs_inode *ip, void *args),
+	void			*args,
+	int			tag)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	uint32_t		first_index;
+	int			last_error = 0;
+	int			skipped;
+	bool			done;
+	int			nr_found;
+
+restart:
+	done = false;
+	skipped = 0;
+	first_index = 0;
+	nr_found = 0;
+	do {
+		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
+		int		error = 0;
+		int		i;
+
+		rcu_read_lock();
+
+		if (tag == XFS_ICI_NO_TAG)
+			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
+					(void **)batch, first_index,
+					XFS_LOOKUP_BATCH);
+		else
+			nr_found = radix_tree_gang_lookup_tag(
+					&pag->pag_ici_root,
+					(void **) batch, first_index,
+					XFS_LOOKUP_BATCH, tag);
+
+		if (!nr_found) {
+			rcu_read_unlock();
+			break;
+		}
+
+		/*
+		 * Grab the inodes before we drop the lock. if we found
+		 * nothing, nr == 0 and the loop will be skipped.
+		 */
+		for (i = 0; i < nr_found; i++) {
+			struct xfs_inode *ip = batch[i];
+
+			if (done || !xfs_inode_walk_ag_grab(ip, iter_flags))
+				batch[i] = NULL;
+
+			/*
+			 * Update the index for the next lookup. Catch
+			 * overflows into the next AG range which can occur if
+			 * we have inodes in the last block of the AG and we
+			 * are currently pointing to the last inode.
+			 *
+			 * Because we may see inodes that are from the wrong AG
+			 * due to RCU freeing and reallocation, only update the
+			 * index if it lies in this AG. It was a race that lead
+			 * us to see this inode, so another lookup from the
+			 * same index will not find it again.
+			 */
+			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
+				continue;
+			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
+				done = true;
+		}
+
+		/* unlock now we've grabbed the inodes. */
+		rcu_read_unlock();
+
+		for (i = 0; i < nr_found; i++) {
+			if (!batch[i])
+				continue;
+			if ((iter_flags & XFS_INODE_WALK_INEW_WAIT) &&
+			    xfs_iflags_test(batch[i], XFS_INEW))
+				xfs_inew_wait(batch[i]);
+			error = execute(batch[i], args);
+			xfs_irele(batch[i]);
+			if (error == -EAGAIN) {
+				skipped++;
+				continue;
+			}
+			if (error && last_error != -EFSCORRUPTED)
+				last_error = error;
+		}
+
+		/* bail out if the filesystem is corrupted.  */
+		if (error == -EFSCORRUPTED)
+			break;
+
+		cond_resched();
+
+	} while (nr_found && !done);
+
+	if (skipped) {
+		delay(1);
+		goto restart;
+	}
+	return last_error;
+}
+
+/* Fetch the next (possibly tagged) per-AG structure. */
+static inline struct xfs_perag *
+xfs_inode_walk_get_perag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	int			tag)
+{
+	if (tag == XFS_ICI_NO_TAG)
+		return xfs_perag_get(mp, agno);
+	return xfs_perag_get_tag(mp, agno, tag);
+}
+
+/*
+ * Call the @execute function on all incore inodes matching the radix tree
+ * @tag.
+ */
+static int
+xfs_inode_walk(
+	struct xfs_mount	*mp,
+	int			iter_flags,
+	int			(*execute)(struct xfs_inode *ip, void *args),
+	void			*args,
+	int			tag)
+{
+	struct xfs_perag	*pag;
+	int			error = 0;
+	int			last_error = 0;
+	xfs_agnumber_t		ag;
+
+	ag = 0;
+	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
+		ag = pag->pag_agno + 1;
+		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, tag);
+		xfs_perag_put(pag);
+		if (error) {
+			last_error = error;
+			if (error == -EFSCORRUPTED)
+				break;
+		}
+	}
+	return last_error;
+}

