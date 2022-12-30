Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E05C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbiLaAEP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbiLaAEO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:04:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785A814D14
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:04:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C71DB81DB1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2751C433D2;
        Sat, 31 Dec 2022 00:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445049;
        bh=+5uDFZhCPHenQqnt5ooVQH+MmARbH3ZxxSIWJ+p2was=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hQcZIOcnh5mIp87MMOz0MDOrCGMlJW5ECZcA3yuRa0f5RCC4/6vvqWIDjB23iYEjc
         5FRphBVzxVI9D5GlA4BOVLKJQfj/5RABGe0KOFD3GmYrjJt3A44dvEPAbiE9xAfLzD
         W5OBmvegW+Frqjm5nygabjjftWb+cLh0l6VKMu8RBNz25eNGwSwUxJGnGJ1yUKAcgg
         MGPzpnTMzGP9cmSQEUHnXIUIW8d62sZ7bEe1SL4rbgM0da/X7U5GfUtJReaUtdS/QQ
         5rhFwD/CjMVXK8LOo0a4H389MU1BVwTrcxBQ9e8mMtDBywj4UtQsUgCivcid+uEL5g
         W3K+uzgG2K2bQ==
Subject: [PATCH 4/4] xfs: repair AGI unlinked inode bucket lists
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:29 -0800
Message-ID: <167243846966.701054.15614094156814738348.stgit@magnolia>
In-Reply-To: <167243846905.701054.601680294547998738.stgit@magnolia>
References: <167243846905.701054.601680294547998738.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the AGI repair code to rebuild the unlinked buckets and lists.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |  471 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h           |  128 +++++++++++
 2 files changed, 595 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 26ed60c24386..6170296b087f 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -22,12 +22,16 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_ag.h"
+#include "xfs_inode.h"
+#include "xfs_iunlink_item.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
 #include "scrub/repair.h"
 #include "scrub/bitmap.h"
 #include "scrub/reap.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
 
 /* Superblock */
 
@@ -803,6 +807,8 @@ enum {
 	XREP_AGI_MAX
 };
 
+#define XREP_AGI_LOOKUP_BATCH		32
+
 struct xrep_agi {
 	struct xfs_scrub		*sc;
 
@@ -814,8 +820,34 @@ struct xrep_agi {
 
 	/* old AGI contents in case we have to revert */
 	struct xfs_agi			old_agi;
+
+	/* bitmap of which inodes are unlinked */
+	struct xbitmap			iunlink_bmp;
+
+	/* heads of the unlinked inode bucket lists */
+	xfs_agino_t			iunlink_heads[XFS_AGI_UNLINKED_BUCKETS];
+
+	/* scratchpad for batched lookups of the radix tree */
+	struct xfs_inode		*lookup_batch[XREP_AGI_LOOKUP_BATCH];
+
+	/* Map of ino -> next_ino for unlinked inode processing. */
+	struct xfarray			*iunlink_next;
+
+	/* Map of ino -> prev_ino for unlinked inode processing. */
+	struct xfarray			*iunlink_prev;
 };
 
+static void
+xrep_agi_buf_cleanup(
+	void		*buf)
+{
+	struct xrep_agi	*ragi = buf;
+
+	xfarray_destroy(ragi->iunlink_prev);
+	xfarray_destroy(ragi->iunlink_next);
+	xbitmap_destroy(&ragi->iunlink_bmp);
+}
+
 /*
  * Given the inode btree roots described by *fab, find the roots, check them
  * for sanity, and pass the root data back out via *fab.
@@ -877,10 +909,6 @@ xrep_agi_init_header(
 	if (xfs_has_crc(mp))
 		uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
 
-	/* We don't know how to fix the unlinked list yet. */
-	memcpy(&agi->agi_unlinked, &old_agi->agi_unlinked,
-			sizeof(agi->agi_unlinked));
-
 	/* Mark the incore AGF data stale until we're done fixing things. */
 	ASSERT(sc->sa.pag->pagi_init);
 	sc->sa.pag->pagi_init = 0;
@@ -954,6 +982,417 @@ xrep_agi_calc_from_btrees(
 	return error;
 }
 
+/* Stage @ip->i_next_unlinked = next_agino */
+static inline int
+xrep_iunlink_store_next(
+	struct xrep_agi		*ragi,
+	struct xfs_inode	*ip,
+	xfs_agino_t		next_agino)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+
+	return xfarray_store(ragi->iunlink_next, agino, &next_agino);
+}
+
+/* Stage @xfs_iget(agino)->i_prev_unlinked = prev_agino */
+static inline int
+xrep_iunlink_store_prev(
+	struct xrep_agi		*ragi,
+	xfs_agino_t		agino,
+	xfs_agino_t		prev_agino)
+{
+	ASSERT(prev_agino != 0);
+
+	return xfarray_store(ragi->iunlink_prev, agino, &prev_agino);
+}
+
+/* Decide if this is an unlinked inode in this AG. */
+STATIC bool
+xrep_iunlink_igrab(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
+		return false;
+
+	/* Not on the unlinked list yet. */
+	if (ip->i_prev_unlinked == 0)
+		return false;
+
+	return true;
+}
+
+/*
+ * Mark the given inode in the lookup batch in our unlinked inode bitmap, and
+ * remember if this inode is the start of the unlinked chain.
+ */
+STATIC int
+xrep_iunlink_visit(
+	struct xrep_agi		*ragi,
+	unsigned int		batch_idx)
+{
+	struct xfs_mount	*mp = ragi->sc->mp;
+	struct xfs_inode	*ip = ragi->lookup_batch[batch_idx];
+	xfs_agino_t		agino;
+	unsigned int		bucket;
+	int			error;
+
+	ASSERT(XFS_INO_TO_AGNO(mp, ip->i_ino) == ragi->sc->sa.pag->pag_agno);
+	ASSERT(ip->i_prev_unlinked != 0);
+
+	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	bucket = agino % XFS_AGI_UNLINKED_BUCKETS;
+
+	trace_xrep_iunlink_visit(ragi->sc->sa.pag, ragi->iunlink_heads[bucket],
+			ip);
+
+	error = xbitmap_set(&ragi->iunlink_bmp, agino, 1);
+	if (error)
+		return error;
+
+	if (ip->i_prev_unlinked == NULLAGINO) {
+		if (ragi->iunlink_heads[bucket] == NULLAGINO)
+			ragi->iunlink_heads[bucket] = agino;
+	}
+
+	return 0;
+}
+
+/*
+ * Find all incore unlinked inodes so that we can rebuild the unlinked buckets.
+ * We hold the AGI so there should not be any modifications to the unlinked
+ * list.
+ */
+STATIC int
+xrep_iunlink_find(
+	struct xrep_agi		*ragi)
+{
+	struct xfs_perag	*pag = ragi->sc->sa.pag;
+	struct xfs_mount	*mp = pag->pag_mount;
+	uint32_t		first_index = 0;
+	bool			done = false;
+	unsigned int		nr_found = 0;
+
+	do {
+		unsigned int	i;
+		int		error = 0;
+
+		if (xchk_should_terminate(ragi->sc, &error))
+			return error;
+
+		rcu_read_lock();
+
+		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
+				(void **)&ragi->lookup_batch, first_index,
+				XREP_AGI_LOOKUP_BATCH);
+		if (!nr_found) {
+			rcu_read_unlock();
+			return 0;
+		}
+
+		for (i = 0; i < nr_found; i++) {
+			struct xfs_inode *ip = ragi->lookup_batch[i];
+
+			if (done || !xrep_iunlink_igrab(pag, ip))
+				ragi->lookup_batch[i] = NULL;
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
+			if (!ragi->lookup_batch[i])
+				continue;
+			error = xrep_iunlink_visit(ragi, i);
+			if (error)
+				return error;
+		}
+	} while (!done);
+
+	return 0;
+}
+
+/* Walk an iunlink bucket's list, remembering all the good inodes. */
+STATIC int
+xrep_iunlink_walk_bucket(
+	struct xrep_agi		*ragi,
+	unsigned int		bucket)
+{
+	struct xfs_scrub	*sc = ragi->sc;
+	struct xfs_inode	*prev_ip = NULL;
+	struct xfs_inode	*ip;
+	xfs_agino_t		prev_agino = NULLAGINO;
+	xfs_agino_t		next_agino = ragi->iunlink_heads[bucket];
+	int			error = 0;
+
+	while (next_agino != NULLAGINO) {
+		if (xchk_should_terminate(ragi->sc, &error))
+			return error;
+
+		trace_xrep_iunlink_walk_bucket(sc->sa.pag, bucket, prev_agino,
+				next_agino);
+
+		/* Find the next inode in the chain. */
+		ip = xfs_iunlink_lookup(sc->sa.pag, next_agino);
+		if (!ip) {
+			/* Inode not incore?  Terminate the chain. */
+			next_agino = NULLAGINO;
+			break;
+		}
+
+		if (next_agino % XFS_AGI_UNLINKED_BUCKETS != bucket ||
+		    ip->i_prev_unlinked == 0) {
+			/*
+			 * Inode is in the wrong bucket or isn't unlinked.
+			 * Advance the list, but pretend we didn't see this
+			 * inode.
+			 */
+			next_agino = ip->i_next_unlinked;
+			continue;
+		}
+
+		/*
+		 * Otherwise, this inode's unlinked pointers are ok.  Clear it
+		 * from the unlinked bitmap since we're done with it, and make
+		 * sure the chain is still correct.
+		 */
+		error = xbitmap_clear(&ragi->iunlink_bmp, next_agino, 1);
+		if (error)
+			return error;
+
+		/* Remember the previous inode's next pointer. */
+		if (prev_ip) {
+			error = xrep_iunlink_store_next(ragi, prev_ip,
+					next_agino);
+			if (error)
+				return error;
+		}
+
+		/* Remember this inode's previous pointer. */
+		error = xrep_iunlink_store_prev(ragi, next_agino, prev_agino);
+		if (error)
+			return error;
+
+		/* Advance the list and remember this inode. */
+		prev_agino = next_agino;
+		next_agino = ip->i_next_unlinked;
+		prev_ip = ip;
+	}
+
+	/* Update the previous inode's next pointer. */
+	if (prev_ip) {
+		error = xrep_iunlink_store_next(ragi, prev_ip, next_agino);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Reinsert this unlinked inode into the head of the staged bucket list. */
+STATIC int
+xrep_iunlink_add_to_bucket(
+	struct xrep_agi		*ragi,
+	xfs_agino_t		agino)
+{
+	struct xfs_inode	*ip;
+	xfs_agino_t		current_head;
+	unsigned int		bucket;
+	int			error;
+
+	bucket = agino % XFS_AGI_UNLINKED_BUCKETS;
+
+	ip = xfs_iunlink_lookup(ragi->sc->sa.pag, agino);
+	if (!ip)
+		return -EFSCORRUPTED;
+
+	/* Point this inode at the current head of the bucket list. */
+	current_head = ragi->iunlink_heads[bucket];
+	error = xrep_iunlink_store_next(ragi, ip, current_head);
+	if (error)
+		return error;
+
+	/* Remember the head inode's previous pointer. */
+	if (current_head != NULLAGINO) {
+		error = xrep_iunlink_store_prev(ragi, current_head, agino);
+		if (error)
+			return error;
+	}
+
+	ragi->iunlink_heads[bucket] = agino;
+	return 0;
+}
+
+/* Reinsert unlinked inodes into the staged iunlink buckets. */
+STATIC int
+xrep_iunlink_add_lost_inodes(
+	uint64_t		start,
+	uint64_t		len,
+	void			*priv)
+{
+	struct xrep_agi		*ragi = priv;
+	int			error;
+
+	while (len > 0) {
+		error = xrep_iunlink_add_to_bucket(ragi, start);
+		if (error)
+			return error;
+
+		start++;
+		len--;
+	}
+
+	return 0;
+}
+
+/*
+ * Figure out the iunlink bucket values and find inodes that need to be
+ * reinserted into the list.
+ */
+STATIC int
+xrep_iunlink_find_all(
+	struct xrep_agi		*ragi)
+{
+	unsigned int		i;
+	int			error;
+
+	/* Record all the incore unlinked inodes. */
+	error = xrep_iunlink_find(ragi);
+	if (error)
+		return error;
+
+	/*
+	 * Clear all the unlinked inodes that are correctly linked into their
+	 * incore inode bucket lists.  After this call, iunlink_bmp will
+	 * contain unlinked inodes that are not in the correct list.
+	 */
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
+		error = xrep_iunlink_walk_bucket(ragi, i);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Any unlinked inodes that we didn't find through the bucket list
+	 * walk (or was ignored by the walk) must be inserted into the bucket
+	 * list.  Stage this in memory for now.
+	 */
+	return xbitmap_walk(&ragi->iunlink_bmp,
+			xrep_iunlink_add_lost_inodes, ragi);
+}
+
+/* Update i_next_iunlinked for the inode @agino. */
+STATIC int
+xrep_iunlink_relink_next(
+	struct xrep_agi		*ragi,
+	xfarray_idx_t		idx,
+	xfs_agino_t		next_agino)
+{
+	struct xfs_inode	*ip;
+	xfarray_idx_t		agino = idx - 1;
+	int			error;
+
+	ip = xfs_iunlink_lookup(ragi->sc->sa.pag, agino);
+	if (!ip)
+		return -EFSCORRUPTED;
+
+	if (ip->i_next_unlinked == next_agino)
+		return 0;
+
+	trace_xrep_iunlink_relink_next(ip, next_agino);
+
+	error = xfs_iunlink_log_inode(ragi->sc->tp, ip, ragi->sc->sa.pag,
+			next_agino);
+	if (error)
+		return error;
+
+	ip->i_next_unlinked = next_agino;
+	return 0;
+}
+
+/* Update i_prev_iunlinked for the inode @agino. */
+STATIC int
+xrep_iunlink_relink_prev(
+	struct xrep_agi		*ragi,
+	xfarray_idx_t		idx,
+	xfs_agino_t		prev_agino)
+{
+	struct xfs_inode	*ip;
+	xfarray_idx_t		agino = idx - 1;
+
+	ASSERT(prev_agino != 0);
+
+	ip = xfs_iunlink_lookup(ragi->sc->sa.pag, agino);
+	if (!ip)
+		return -EFSCORRUPTED;
+
+	if (ip->i_prev_unlinked == prev_agino)
+		return 0;
+
+	trace_xrep_iunlink_relink_prev(ip, prev_agino);
+
+	ip->i_prev_unlinked = prev_agino;
+	return 0;
+}
+
+/* Log all the iunlink updates we need to finish regenerating the AGI. */
+STATIC int
+xrep_iunlink_commit(
+	struct xrep_agi		*ragi)
+{
+	struct xfs_agi		*agi = ragi->agi_bp->b_addr;
+	xfarray_idx_t		idx = XFARRAY_CURSOR_INIT;
+	xfs_agino_t		agino;
+	unsigned int		i;
+	int			error;
+
+	/* Fix all the forward links */
+	while ((error = xfarray_iter(ragi->iunlink_next, &idx, &agino)) == 1) {
+		error = xrep_iunlink_relink_next(ragi, idx, agino);
+		if (error)
+			break;
+	}
+
+	/* Fix all the back links */
+	idx = XFARRAY_CURSOR_INIT;
+	while ((error = xfarray_iter(ragi->iunlink_prev, &idx, &agino)) == 1) {
+		error = xrep_iunlink_relink_prev(ragi, idx, agino);
+		if (error)
+			break;
+	}
+
+	/* Copy the staged iunlink buckets to the new AGI. */
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
+		trace_xrep_iunlink_commit_bucket(ragi->sc->sa.pag, i,
+				ragi->iunlink_heads[i]);
+
+		agi->agi_unlinked[i] = cpu_to_be32(ragi->iunlink_heads[i]);
+	}
+
+	return 0;
+}
+
 /* Trigger reinitialization of the in-core data. */
 STATIC int
 xrep_agi_commit_new(
@@ -987,6 +1426,7 @@ xrep_agi(
 {
 	struct xrep_agi		*ragi;
 	struct xfs_mount	*mp = sc->mp;
+	unsigned int		i;
 	int			error;
 
 	/* We require the rmapbt to rebuild anything. */
@@ -1013,6 +1453,22 @@ xrep_agi(
 		.buf_ops	= NULL,
 	};
 
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
+		ragi->iunlink_heads[i] = NULLAGINO;
+
+	xbitmap_init(&ragi->iunlink_bmp);
+	sc->buf_cleanup = xrep_agi_buf_cleanup;
+
+	error = xfarray_create(sc->mp, "iunlinked next", 0,
+			sizeof(xfs_agino_t), &ragi->iunlink_next);
+	if (error)
+		return error;
+
+	error = xfarray_create(sc->mp, "iunlinked prev", 0,
+			sizeof(xfs_agino_t), &ragi->iunlink_prev);
+	if (error)
+		return error;
+
 	/*
 	 * Make sure we have the AGI buffer, as scrub might have decided it
 	 * was corrupt after xfs_ialloc_read_agi failed with -EFSCORRUPTED.
@@ -1030,6 +1486,10 @@ xrep_agi(
 	if (error)
 		return error;
 
+	error = xrep_iunlink_find_all(ragi);
+	if (error)
+		return error;
+
 	/* Last chance to abort before we start committing fixes. */
 	if (xchk_should_terminate(sc, &error))
 		return error;
@@ -1038,6 +1498,9 @@ xrep_agi(
 	xrep_agi_init_header(ragi);
 	xrep_agi_set_roots(ragi);
 	error = xrep_agi_calc_from_btrees(ragi);
+	if (error)
+		goto out_revert;
+	error = xrep_iunlink_commit(ragi);
 	if (error)
 		goto out_revert;
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 1cacea2ba195..f7e30c6eb1d1 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2642,6 +2642,134 @@ DEFINE_EVENT(xrep_symlink_class, name, \
 DEFINE_XREP_SYMLINK_EVENT(xrep_symlink_rebuild);
 DEFINE_XREP_SYMLINK_EVENT(xrep_symlink_reset_fork);
 
+TRACE_EVENT(xrep_iunlink_visit,
+	TP_PROTO(struct xfs_perag *pag, xfs_agino_t bucket_agino,
+		 struct xfs_inode *ip),
+	TP_ARGS(pag, bucket_agino, ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+		__field(xfs_agino_t, bucket_agino)
+		__field(xfs_agino_t, prev_agino)
+		__field(xfs_agino_t, next_agino)
+	),
+	TP_fast_assign(
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->agino = XFS_INO_TO_AGINO(pag->pag_mount, ip->i_ino);
+		__entry->bucket_agino = bucket_agino;
+		__entry->prev_agino = ip->i_prev_unlinked;
+		__entry->next_agino = ip->i_next_unlinked;
+	),
+	TP_printk("dev %d:%d agno 0x%x agino 0x%x bucket_agino %u prev_agino 0x%x next_agino 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agino,
+		  __entry->bucket_agino,
+		  __entry->prev_agino,
+		  __entry->next_agino)
+);
+
+TRACE_EVENT(xrep_iunlink_walk_bucket,
+	TP_PROTO(struct xfs_perag *pag, unsigned int bucket,
+		 xfs_agino_t prev_agino, xfs_agino_t next_agino),
+	TP_ARGS(pag, bucket, prev_agino, next_agino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(unsigned int, bucket)
+		__field(xfs_agino_t, prev_agino)
+		__field(xfs_agino_t, next_agino)
+	),
+	TP_fast_assign(
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->bucket = bucket;
+		__entry->prev_agino = prev_agino;
+		__entry->next_agino = next_agino;
+	),
+	TP_printk("dev %d:%d agno 0x%x bucket %u prev_agino 0x%x next_agino 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->bucket,
+		  __entry->prev_agino,
+		  __entry->next_agino)
+);
+
+TRACE_EVENT(xrep_iunlink_relink_next,
+	TP_PROTO(struct xfs_inode *ip, xfs_agino_t next_agino),
+	TP_ARGS(ip, next_agino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+		__field(xfs_agino_t, next_agino)
+		__field(xfs_agino_t, new_next_agino)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agino = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->next_agino = ip->i_next_unlinked;
+		__entry->new_next_agino = next_agino;
+	),
+	TP_printk("dev %d:%d agno 0x%x agino 0x%x next_agino 0x%x -> 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agino,
+		  __entry->next_agino,
+		  __entry->new_next_agino)
+);
+
+TRACE_EVENT(xrep_iunlink_relink_prev,
+	TP_PROTO(struct xfs_inode *ip, xfs_agino_t prev_agino),
+	TP_ARGS(ip, prev_agino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+		__field(xfs_agino_t, prev_agino)
+		__field(xfs_agino_t, new_prev_agino)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agino = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->prev_agino = ip->i_prev_unlinked;
+		__entry->new_prev_agino = prev_agino;
+	),
+	TP_printk("dev %d:%d agno 0x%x agino 0x%x prev_agino 0x%x -> 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agino,
+		  __entry->prev_agino,
+		  __entry->new_prev_agino)
+);
+
+TRACE_EVENT(xrep_iunlink_commit_bucket,
+	TP_PROTO(struct xfs_perag *pag, unsigned int bucket,
+		 xfs_agino_t agino),
+	TP_ARGS(pag, bucket, agino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(unsigned int, bucket)
+		__field(xfs_agino_t, agino)
+	),
+	TP_fast_assign(
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->bucket = bucket;
+		__entry->agino = agino;
+	),
+	TP_printk("dev %d:%d agno 0x%x bucket %u agino 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->bucket,
+		  __entry->agino)
+);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 

