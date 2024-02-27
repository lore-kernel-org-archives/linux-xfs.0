Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30793746E
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709001219; cv=none; b=a+dArGwBQ+0kEVZfY1+hfZvu54a6k1S/+TScyTVSYEYz8QJkBJ9suP8AiybCCk4G+20ANTrRBr0dPIuCnxWu2Wn7xxME3YESJ/LtOCKh4Itat70Mk6dUiXhPmyH1bteCq37cNNXJ4O/1Ng2iWZpZYwl1bUqyAAbiACsI02p0ajE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709001219; c=relaxed/simple;
	bh=WoaeEJIrT1brb69X7my4NRtSFROCCouV7n3t8zNvArY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bNti2Ma45k7kPMh6SXPxP6V6YsSsw44n8UOr1HFw0uMngfJhqJ/NzgHXkiNkvKwuofuV/QF4jXl6SuhDXBVtwL2Fe1SUByy5922ZGGKrT3f24CXzf7s8FaFl65YrZnImX+lypvh3F1EoEs3n9WgPXU96sU1FMHE5b5t0ZYnNrg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aeIqCFxp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aeIqCFxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E60EC433C7;
	Tue, 27 Feb 2024 02:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709001218;
	bh=WoaeEJIrT1brb69X7my4NRtSFROCCouV7n3t8zNvArY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aeIqCFxpA3EIfB/+xKUPe48E/ndbV6vVAkTOq4mcqVfgl71TH2wCDEEdh5gcz6VRo
	 tjH9OAKRfB2DFBde7WGzU9j6G/vIV4Q0G1gd4G+xH+Bz/K/JWZxWZIxdwNH4AsvyPv
	 uJ6Xh04FrLySrPJLu4twSG9n1orLJA8Dasanm1q2E+TVdwpyDT5d2RPj009RIQ0VnV
	 aJu3lpOiYNRIGn8Uk2MCSBp4sQYMqwDQdqLtqrmtMLMjB6j5QCLDc9n1yO8rklTIr/
	 +77sFzivlumUQaHRF1CsX5dmsax3epHYrfK5vpKhveGv0cXeYzY6rtLNaVrdkKdviI
	 Qjz1XsZ/du1gg==
Date: Mon, 26 Feb 2024 18:33:38 -0800
Subject: [PATCH 3/3] xfs: repair AGI unlinked inode bucket lists
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900015681.939876.818149743308450270.stgit@frogsfrogsfrogs>
In-Reply-To: <170900015625.939876.13962340231526041298.stgit@frogsfrogsfrogs>
References: <170900015625.939876.13962340231526041298.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Teach the AGI repair code to rebuild the unlinked buckets and lists.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |  774 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/agino_bitmap.h    |   49 +++
 fs/xfs/scrub/trace.h           |  255 +++++++++++++
 3 files changed, 1074 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/agino_bitmap.h


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index d210bd7d5eb13..0dbc484b182f9 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -21,13 +21,18 @@
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
 #include "scrub/agb_bitmap.h"
+#include "scrub/agino_bitmap.h"
 #include "scrub/reap.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
 
 /* Superblock */
 
@@ -796,6 +801,8 @@ enum {
 	XREP_AGI_MAX
 };
 
+#define XREP_AGI_LOOKUP_BATCH		32
+
 struct xrep_agi {
 	struct xfs_scrub		*sc;
 
@@ -807,8 +814,34 @@ struct xrep_agi {
 
 	/* old AGI contents in case we have to revert */
 	struct xfs_agi			old_agi;
+
+	/* bitmap of which inodes are unlinked */
+	struct xagino_bitmap		iunlink_bmp;
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
+	xagino_bitmap_destroy(&ragi->iunlink_bmp);
+}
+
 /*
  * Given the inode btree roots described by *fab, find the roots, check them
  * for sanity, and pass the root data back out via *fab.
@@ -871,10 +904,6 @@ xrep_agi_init_header(
 	if (xfs_has_crc(mp))
 		uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
 
-	/* We don't know how to fix the unlinked list yet. */
-	memcpy(&agi->agi_unlinked, &old_agi->agi_unlinked,
-			sizeof(agi->agi_unlinked));
-
 	/* Mark the incore AGF data stale until we're done fixing things. */
 	ASSERT(xfs_perag_initialised_agi(pag));
 	clear_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
@@ -946,6 +975,714 @@ xrep_agi_calc_from_btrees(
 	return error;
 }
 
+/*
+ * Record a forwards unlinked chain pointer from agino -> next_agino in our
+ * staging information.
+ */
+static inline int
+xrep_iunlink_store_next(
+	struct xrep_agi		*ragi,
+	xfs_agino_t		agino,
+	xfs_agino_t		next_agino)
+{
+	ASSERT(next_agino != 0);
+
+	return xfarray_store(ragi->iunlink_next, agino, &next_agino);
+}
+
+/*
+ * Record a backwards unlinked chain pointer from prev_ino <- agino in our
+ * staging information.
+ */
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
+/*
+ * Given an @agino, look up the next inode in the iunlink bucket.  Returns
+ * NULLAGINO if we're at the end of the chain, 0 if @agino is not in memory
+ * like it should be, or a per-AG inode number.
+ */
+static inline xfs_agino_t
+xrep_iunlink_next(
+	struct xfs_scrub	*sc,
+	xfs_agino_t		agino)
+{
+	struct xfs_inode	*ip;
+
+	ip = xfs_iunlink_lookup(sc->sa.pag, agino);
+	if (!ip)
+		return 0;
+
+	return ip->i_next_unlinked;
+}
+
+/*
+ * Load the inode @agino into memory, set its i_prev_unlinked, and drop the
+ * inode so it can be inactivated.  Returns NULLAGINO if we're at the end of
+ * the chain or if we should stop walking the chain due to corruption; or a
+ * per-AG inode number.
+ */
+STATIC xfs_agino_t
+xrep_iunlink_reload_next(
+	struct xrep_agi		*ragi,
+	xfs_agino_t		prev_agino,
+	xfs_agino_t		agino)
+{
+	struct xfs_scrub	*sc = ragi->sc;
+	struct xfs_inode	*ip;
+	xfs_ino_t		ino;
+	xfs_agino_t		ret = NULLAGINO;
+	int			error;
+
+	ino = XFS_AGINO_TO_INO(sc->mp, sc->sa.pag->pag_agno, agino);
+	error = xchk_iget(ragi->sc, ino, &ip);
+	if (error)
+		return ret;
+
+	trace_xrep_iunlink_reload_next(ip, prev_agino);
+
+	/* If this is a linked inode, stop processing the chain. */
+	if (VFS_I(ip)->i_nlink != 0) {
+		xrep_iunlink_store_next(ragi, agino, NULLAGINO);
+		goto rele;
+	}
+
+	ip->i_prev_unlinked = prev_agino;
+	ret = ip->i_next_unlinked;
+
+	/*
+	 * Drop the inode reference that we just took.  We hold the AGI, so
+	 * this inode cannot move off the unlinked list and hence cannot be
+	 * reclaimed.
+	 */
+rele:
+	xchk_irele(sc, ip);
+	return ret;
+}
+
+/*
+ * Walk an AGI unlinked bucket's list to load incore any unlinked inodes that
+ * still existed at mount time.  This can happen if iunlink processing fails
+ * during log recovery.
+ */
+STATIC int
+xrep_iunlink_walk_ondisk_bucket(
+	struct xrep_agi		*ragi,
+	unsigned int		bucket)
+{
+	struct xfs_scrub	*sc = ragi->sc;
+	struct xfs_agi		*agi = sc->sa.agi_bp->b_addr;
+	xfs_agino_t		prev_agino = NULLAGINO;
+	xfs_agino_t		next_agino;
+	int			error = 0;
+
+	next_agino = be32_to_cpu(agi->agi_unlinked[bucket]);
+	while (next_agino != NULLAGINO) {
+		xfs_agino_t	agino = next_agino;
+
+		if (xchk_should_terminate(ragi->sc, &error))
+			return error;
+
+		trace_xrep_iunlink_walk_ondisk_bucket(sc->sa.pag, bucket,
+				prev_agino, agino);
+
+		if (bucket != agino % XFS_AGI_UNLINKED_BUCKETS)
+			break;
+
+		next_agino = xrep_iunlink_next(sc, agino);
+		if (!next_agino)
+			next_agino = xrep_iunlink_reload_next(ragi, prev_agino,
+					agino);
+
+		prev_agino = agino;
+	}
+
+	return 0;
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
+	if (!xfs_inode_on_unlinked_list(ip))
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
+	ASSERT(xfs_inode_on_unlinked_list(ip));
+
+	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	bucket = agino % XFS_AGI_UNLINKED_BUCKETS;
+
+	trace_xrep_iunlink_visit(ragi->sc->sa.pag, bucket,
+			ragi->iunlink_heads[bucket], ip);
+
+	error = xagino_bitmap_set(&ragi->iunlink_bmp, agino, 1);
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
+xrep_iunlink_mark_incore(
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
+/* Mark all the unlinked ondisk inodes in this inobt record in iunlink_bmp. */
+STATIC int
+xrep_iunlink_mark_ondisk_rec(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*rec,
+	void				*priv)
+{
+	struct xfs_inobt_rec_incore	irec;
+	struct xrep_agi			*ragi = priv;
+	struct xfs_scrub		*sc = ragi->sc;
+	struct xfs_mount		*mp = cur->bc_mp;
+	xfs_agino_t			agino;
+	unsigned int			i;
+	int				error = 0;
+
+	xfs_inobt_btrec_to_irec(mp, rec, &irec);
+
+	for (i = 0, agino = irec.ir_startino;
+	     i < XFS_INODES_PER_CHUNK;
+	     i++, agino++) {
+		struct xfs_inode	*ip;
+		unsigned int		len = 1;
+
+		/* Skip free inodes */
+		if (XFS_INOBT_MASK(i) & irec.ir_free)
+			continue;
+		/* Skip inodes we've seen before */
+		if (xagino_bitmap_test(&ragi->iunlink_bmp, agino, &len))
+			continue;
+
+		/*
+		 * Skip incore inodes; these were already picked up by
+		 * the _mark_incore step.
+		 */
+		rcu_read_lock();
+		ip = radix_tree_lookup(&sc->sa.pag->pag_ici_root, agino);
+		rcu_read_unlock();
+		if (ip)
+			continue;
+
+		/*
+		 * Try to look up this inode.  If we can't get it, just move
+		 * on because we haven't actually scrubbed the inobt or the
+		 * inodes yet.
+		 */
+		error = xchk_iget(ragi->sc,
+				XFS_AGINO_TO_INO(mp, sc->sa.pag->pag_agno,
+						 agino),
+				&ip);
+		if (error)
+			continue;
+
+		trace_xrep_iunlink_reload_ondisk(ip);
+
+		if (VFS_I(ip)->i_nlink == 0)
+			error = xagino_bitmap_set(&ragi->iunlink_bmp, agino, 1);
+		xchk_irele(sc, ip);
+		if (error)
+			break;
+	}
+
+	return error;
+}
+
+/*
+ * Find ondisk inodes that are unlinked and not in cache, and mark them in
+ * iunlink_bmp.   We haven't checked the inobt yet, so we don't error out if
+ * the btree is corrupt.
+ */
+STATIC void
+xrep_iunlink_mark_ondisk(
+	struct xrep_agi		*ragi)
+{
+	struct xfs_scrub	*sc = ragi->sc;
+	struct xfs_buf		*agi_bp = ragi->agi_bp;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	cur = xfs_inobt_init_cursor(sc->sa.pag, sc->tp, agi_bp);
+	error = xfs_btree_query_all(cur, xrep_iunlink_mark_ondisk_rec, ragi);
+	xfs_btree_del_cursor(cur, error);
+}
+
+/*
+ * Walk an iunlink bucket's inode list.  For each inode that should be on this
+ * chain, clear its entry in in iunlink_bmp because it's ok and we don't need
+ * to touch it further.
+ */
+STATIC int
+xrep_iunlink_resolve_bucket(
+	struct xrep_agi		*ragi,
+	unsigned int		bucket)
+{
+	struct xfs_scrub	*sc = ragi->sc;
+	struct xfs_inode	*ip;
+	xfs_agino_t		prev_agino = NULLAGINO;
+	xfs_agino_t		next_agino = ragi->iunlink_heads[bucket];
+	int			error = 0;
+
+	while (next_agino != NULLAGINO) {
+		if (xchk_should_terminate(ragi->sc, &error))
+			return error;
+
+		/* Find the next inode in the chain. */
+		ip = xfs_iunlink_lookup(sc->sa.pag, next_agino);
+		if (!ip) {
+			/* Inode not incore?  Terminate the chain. */
+			trace_xrep_iunlink_resolve_uncached(sc->sa.pag,
+					bucket, prev_agino, next_agino);
+
+			next_agino = NULLAGINO;
+			break;
+		}
+
+		if (next_agino % XFS_AGI_UNLINKED_BUCKETS != bucket) {
+			/*
+			 * Inode is in the wrong bucket.  Advance the list,
+			 * but pretend we didn't see this inode.
+			 */
+			trace_xrep_iunlink_resolve_wronglist(sc->sa.pag,
+					bucket, prev_agino, next_agino);
+
+			next_agino = ip->i_next_unlinked;
+			continue;
+		}
+
+		if (!xfs_inode_on_unlinked_list(ip)) {
+			/*
+			 * Incore inode doesn't think this inode is on an
+			 * unlinked list.  This is probably because we reloaded
+			 * it from disk.  Advance the list, but pretend we
+			 * didn't see this inode; we'll fix that later.
+			 */
+			trace_xrep_iunlink_resolve_nolist(sc->sa.pag,
+					bucket, prev_agino, next_agino);
+			next_agino = ip->i_next_unlinked;
+			continue;
+		}
+
+		trace_xrep_iunlink_resolve_ok(sc->sa.pag, bucket, prev_agino,
+				next_agino);
+
+		/*
+		 * Otherwise, this inode's unlinked pointers are ok.  Clear it
+		 * from the unlinked bitmap since we're done with it, and make
+		 * sure the chain is still correct.
+		 */
+		error = xagino_bitmap_clear(&ragi->iunlink_bmp, next_agino, 1);
+		if (error)
+			return error;
+
+		/* Remember the previous inode's next pointer. */
+		if (prev_agino != NULLAGINO) {
+			error = xrep_iunlink_store_next(ragi, prev_agino,
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
+	}
+
+	/* Update the previous inode's next pointer. */
+	if (prev_agino != NULLAGINO) {
+		error = xrep_iunlink_store_next(ragi, prev_agino, next_agino);
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
+	xfs_agino_t		current_head;
+	unsigned int		bucket;
+	int			error;
+
+	bucket = agino % XFS_AGI_UNLINKED_BUCKETS;
+
+	/* Point this inode at the current head of the bucket list. */
+	current_head = ragi->iunlink_heads[bucket];
+
+	trace_xrep_iunlink_add_to_bucket(ragi->sc->sa.pag, bucket, agino,
+			current_head);
+
+	error = xrep_iunlink_store_next(ragi, agino, current_head);
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
+	uint32_t		start,
+	uint32_t		len,
+	void			*priv)
+{
+	struct xrep_agi		*ragi = priv;
+	int			error;
+
+	for (; len > 0; start++, len--) {
+		error = xrep_iunlink_add_to_bucket(ragi, start);
+		if (error)
+			return error;
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
+xrep_iunlink_rebuild_buckets(
+	struct xrep_agi		*ragi)
+{
+	unsigned int		i;
+	int			error;
+
+	/*
+	 * Walk the ondisk AGI unlinked list to find inodes that are on the
+	 * list but aren't in memory.  This can happen if a past log recovery
+	 * tried to clear the iunlinked list but failed.  Our scan rebuilds the
+	 * unlinked list using incore inodes, so we must load and link them
+	 * properly.
+	 */
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
+		error = xrep_iunlink_walk_ondisk_bucket(ragi, i);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Record all the incore unlinked inodes in iunlink_bmp that we didn't
+	 * find by walking the ondisk iunlink buckets.  This shouldn't happen,
+	 * but we can't risk forgetting an inode somewhere.
+	 */
+	error = xrep_iunlink_mark_incore(ragi);
+	if (error)
+		return error;
+
+	/*
+	 * If there are ondisk inodes that are unlinked and are not been loaded
+	 * into cache, record them in iunlink_bmp.
+	 */
+	xrep_iunlink_mark_ondisk(ragi);
+
+	/*
+	 * Walk each iunlink bucket to (re)construct as much of the incore list
+	 * as would be correct.  For each inode that survives this step, mark
+	 * it clear in iunlink_bmp; we're done with those inodes.
+	 */
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
+		error = xrep_iunlink_resolve_bucket(ragi, i);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Any unlinked inodes that we didn't find through the bucket list
+	 * walk (or was ignored by the walk) must be inserted into the bucket
+	 * list.  Stage this in memory for now.
+	 */
+	return xagino_bitmap_walk(&ragi->iunlink_bmp,
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
+	struct xfs_scrub	*sc = ragi->sc;
+	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_inode	*ip;
+	xfarray_idx_t		agino = idx - 1;
+	bool			want_rele = false;
+	int			error = 0;
+
+	ip = xfs_iunlink_lookup(pag, agino);
+	if (!ip) {
+		xfs_ino_t	ino;
+		xfs_agino_t	prev_agino;
+
+		/*
+		 * No inode exists in cache.  Load it off the disk so that we
+		 * can reinsert it into the incore unlinked list.
+		 */
+		ino = XFS_AGINO_TO_INO(sc->mp, pag->pag_agno, agino);
+		error = xchk_iget(sc, ino, &ip);
+		if (error)
+			return -EFSCORRUPTED;
+
+		want_rele = true;
+
+		/* Set the backward pointer since this just came off disk. */
+		error = xfarray_load(ragi->iunlink_prev, agino, &prev_agino);
+		if (error)
+			goto out_rele;
+
+		trace_xrep_iunlink_relink_prev(ip, prev_agino);
+		ip->i_prev_unlinked = prev_agino;
+	}
+
+	/* Update the forward pointer. */
+	if (ip->i_next_unlinked != next_agino) {
+		error = xfs_iunlink_log_inode(sc->tp, ip, pag, next_agino);
+		if (error)
+			goto out_rele;
+
+		trace_xrep_iunlink_relink_next(ip, next_agino);
+		ip->i_next_unlinked = next_agino;
+	}
+
+out_rele:
+	/*
+	 * The iunlink lookup doesn't igrab because we hold the AGI buffer lock
+	 * and the inode cannot be reclaimed.  However, if we used iget to load
+	 * a missing inode, we must irele it here.
+	 */
+	if (want_rele)
+		xchk_irele(sc, ip);
+	return error;
+}
+
+/* Update i_prev_iunlinked for the inode @agino. */
+STATIC int
+xrep_iunlink_relink_prev(
+	struct xrep_agi		*ragi,
+	xfarray_idx_t		idx,
+	xfs_agino_t		prev_agino)
+{
+	struct xfs_scrub	*sc = ragi->sc;
+	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_inode	*ip;
+	xfarray_idx_t		agino = idx - 1;
+	bool			want_rele = false;
+	int			error = 0;
+
+	ASSERT(prev_agino != 0);
+
+	ip = xfs_iunlink_lookup(pag, agino);
+	if (!ip) {
+		xfs_ino_t	ino;
+		xfs_agino_t	next_agino;
+
+		/*
+		 * No inode exists in cache.  Load it off the disk so that we
+		 * can reinsert it into the incore unlinked list.
+		 */
+		ino = XFS_AGINO_TO_INO(sc->mp, pag->pag_agno, agino);
+		error = xchk_iget(sc, ino, &ip);
+		if (error)
+			return -EFSCORRUPTED;
+
+		want_rele = true;
+
+		/* Set the forward pointer since this just came off disk. */
+		error = xfarray_load(ragi->iunlink_prev, agino, &next_agino);
+		if (error)
+			goto out_rele;
+
+		error = xfs_iunlink_log_inode(sc->tp, ip, pag, next_agino);
+		if (error)
+			goto out_rele;
+
+		trace_xrep_iunlink_relink_next(ip, next_agino);
+		ip->i_next_unlinked = next_agino;
+	}
+
+	/* Update the backward pointer. */
+	if (ip->i_prev_unlinked != prev_agino) {
+		trace_xrep_iunlink_relink_prev(ip, prev_agino);
+		ip->i_prev_unlinked = prev_agino;
+	}
+
+out_rele:
+	/*
+	 * The iunlink lookup doesn't igrab because we hold the AGI buffer lock
+	 * and the inode cannot be reclaimed.  However, if we used iget to load
+	 * a missing inode, we must irele it here.
+	 */
+	if (want_rele)
+		xchk_irele(sc, ip);
+	return error;
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
+			return error;
+	}
+
+	/* Fix all the back links */
+	idx = XFARRAY_CURSOR_INIT;
+	while ((error = xfarray_iter(ragi->iunlink_prev, &idx, &agino)) == 1) {
+		error = xrep_iunlink_relink_prev(ragi, idx, agino);
+		if (error)
+			return error;
+	}
+
+	/* Copy the staged iunlink buckets to the new AGI. */
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
+		trace_xrep_iunlink_commit_bucket(ragi->sc->sa.pag, i,
+				be32_to_cpu(ragi->old_agi.agi_unlinked[i]),
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
@@ -979,6 +1716,8 @@ xrep_agi(
 {
 	struct xrep_agi		*ragi;
 	struct xfs_mount	*mp = sc->mp;
+	char			*descr;
+	unsigned int		i;
 	int			error;
 
 	/* We require the rmapbt to rebuild anything. */
@@ -1005,6 +1744,26 @@ xrep_agi(
 		.buf_ops	= NULL,
 	};
 
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
+		ragi->iunlink_heads[i] = NULLAGINO;
+
+	xagino_bitmap_init(&ragi->iunlink_bmp);
+	sc->buf_cleanup = xrep_agi_buf_cleanup;
+
+	descr = xchk_xfile_ag_descr(sc, "iunlinked next pointers");
+	error = xfarray_create(descr, 0, sizeof(xfs_agino_t),
+			&ragi->iunlink_next);
+	kfree(descr);
+	if (error)
+		return error;
+
+	descr = xchk_xfile_ag_descr(sc, "iunlinked prev pointers");
+	error = xfarray_create(descr, 0, sizeof(xfs_agino_t),
+			&ragi->iunlink_prev);
+	kfree(descr);
+	if (error)
+		return error;
+
 	/*
 	 * Make sure we have the AGI buffer, as scrub might have decided it
 	 * was corrupt after xfs_ialloc_read_agi failed with -EFSCORRUPTED.
@@ -1022,6 +1781,10 @@ xrep_agi(
 	if (error)
 		return error;
 
+	error = xrep_iunlink_rebuild_buckets(ragi);
+	if (error)
+		return error;
+
 	/* Last chance to abort before we start committing fixes. */
 	if (xchk_should_terminate(sc, &error))
 		return error;
@@ -1030,6 +1793,9 @@ xrep_agi(
 	xrep_agi_init_header(ragi);
 	xrep_agi_set_roots(ragi);
 	error = xrep_agi_calc_from_btrees(ragi);
+	if (error)
+		goto out_revert;
+	error = xrep_iunlink_commit(ragi);
 	if (error)
 		goto out_revert;
 
diff --git a/fs/xfs/scrub/agino_bitmap.h b/fs/xfs/scrub/agino_bitmap.h
new file mode 100644
index 0000000000000..56d7db5f16999
--- /dev/null
+++ b/fs/xfs/scrub/agino_bitmap.h
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_AGINO_BITMAP_H__
+#define __XFS_SCRUB_AGINO_BITMAP_H__
+
+/* Bitmaps, but for type-checked for xfs_agino_t */
+
+struct xagino_bitmap {
+	struct xbitmap32	aginobitmap;
+};
+
+static inline void xagino_bitmap_init(struct xagino_bitmap *bitmap)
+{
+	xbitmap32_init(&bitmap->aginobitmap);
+}
+
+static inline void xagino_bitmap_destroy(struct xagino_bitmap *bitmap)
+{
+	xbitmap32_destroy(&bitmap->aginobitmap);
+}
+
+static inline int xagino_bitmap_clear(struct xagino_bitmap *bitmap,
+		xfs_agino_t agino, unsigned int len)
+{
+	return xbitmap32_clear(&bitmap->aginobitmap, agino, len);
+}
+
+static inline int xagino_bitmap_set(struct xagino_bitmap *bitmap,
+		xfs_agino_t agino, unsigned int len)
+{
+	return xbitmap32_set(&bitmap->aginobitmap, agino, len);
+}
+
+static inline bool xagino_bitmap_test(struct xagino_bitmap *bitmap,
+		xfs_agino_t agino, unsigned int *len)
+{
+	return xbitmap32_test(&bitmap->aginobitmap, agino, len);
+}
+
+static inline int xagino_bitmap_walk(struct xagino_bitmap *bitmap,
+		xbitmap32_walk_fn fn, void *priv)
+{
+	return xbitmap32_walk(&bitmap->aginobitmap, fn, priv);
+}
+
+#endif	/* __XFS_SCRUB_AGINO_BITMAP_H__ */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 4e9c9922a4140..0bc63b67a39d4 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2751,6 +2751,261 @@ DEFINE_EVENT(xrep_symlink_class, name, \
 DEFINE_XREP_SYMLINK_EVENT(xrep_symlink_rebuild);
 DEFINE_XREP_SYMLINK_EVENT(xrep_symlink_reset_fork);
 
+TRACE_EVENT(xrep_iunlink_visit,
+	TP_PROTO(struct xfs_perag *pag, unsigned int bucket,
+		 xfs_agino_t bucket_agino, struct xfs_inode *ip),
+	TP_ARGS(pag, bucket, bucket_agino, ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+		__field(unsigned int, bucket)
+		__field(xfs_agino_t, bucket_agino)
+		__field(xfs_agino_t, prev_agino)
+		__field(xfs_agino_t, next_agino)
+	),
+	TP_fast_assign(
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->agino = XFS_INO_TO_AGINO(pag->pag_mount, ip->i_ino);
+		__entry->bucket = bucket;
+		__entry->bucket_agino = bucket_agino;
+		__entry->prev_agino = ip->i_prev_unlinked;
+		__entry->next_agino = ip->i_next_unlinked;
+	),
+	TP_printk("dev %d:%d agno 0x%x bucket %u agino 0x%x bucket_agino 0x%x prev_agino 0x%x next_agino 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->bucket,
+		  __entry->agino,
+		  __entry->bucket_agino,
+		  __entry->prev_agino,
+		  __entry->next_agino)
+);
+
+TRACE_EVENT(xrep_iunlink_reload_next,
+	TP_PROTO(struct xfs_inode *ip, xfs_agino_t prev_agino),
+	TP_ARGS(ip, prev_agino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+		__field(xfs_agino_t, old_prev_agino)
+		__field(xfs_agino_t, prev_agino)
+		__field(xfs_agino_t, next_agino)
+		__field(unsigned int, nlink)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
+		__entry->old_prev_agino = ip->i_prev_unlinked;
+		__entry->prev_agino = prev_agino;
+		__entry->next_agino = ip->i_next_unlinked;
+		__entry->nlink = VFS_I(ip)->i_nlink;
+	),
+	TP_printk("dev %d:%d agno 0x%x bucket %u agino 0x%x nlink %u old_prev_agino %u prev_agino 0x%x next_agino 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agino % XFS_AGI_UNLINKED_BUCKETS,
+		  __entry->agino,
+		  __entry->nlink,
+		  __entry->old_prev_agino,
+		  __entry->prev_agino,
+		  __entry->next_agino)
+);
+
+TRACE_EVENT(xrep_iunlink_reload_ondisk,
+	TP_PROTO(struct xfs_inode *ip),
+	TP_ARGS(ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+		__field(unsigned int, nlink)
+		__field(xfs_agino_t, next_agino)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
+		__entry->nlink = VFS_I(ip)->i_nlink;
+		__entry->next_agino = ip->i_next_unlinked;
+	),
+	TP_printk("dev %d:%d agno 0x%x bucket %u agino 0x%x nlink %u next_agino 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agino % XFS_AGI_UNLINKED_BUCKETS,
+		  __entry->agino,
+		  __entry->nlink,
+		  __entry->next_agino)
+);
+
+TRACE_EVENT(xrep_iunlink_walk_ondisk_bucket,
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
+DECLARE_EVENT_CLASS(xrep_iunlink_resolve_class,
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
+#define DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(name) \
+DEFINE_EVENT(xrep_iunlink_resolve_class, name, \
+	TP_PROTO(struct xfs_perag *pag, unsigned int bucket, \
+		 xfs_agino_t prev_agino, xfs_agino_t next_agino), \
+	TP_ARGS(pag, bucket, prev_agino, next_agino))
+DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_uncached);
+DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_wronglist);
+DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_nolist);
+DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_ok);
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
+		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
+		__entry->next_agino = ip->i_next_unlinked;
+		__entry->new_next_agino = next_agino;
+	),
+	TP_printk("dev %d:%d agno 0x%x bucket %u agino 0x%x next_agino 0x%x -> 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agino % XFS_AGI_UNLINKED_BUCKETS,
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
+		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
+		__entry->prev_agino = ip->i_prev_unlinked;
+		__entry->new_prev_agino = prev_agino;
+	),
+	TP_printk("dev %d:%d agno 0x%x bucket %u agino 0x%x prev_agino 0x%x -> 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agino % XFS_AGI_UNLINKED_BUCKETS,
+		  __entry->agino,
+		  __entry->prev_agino,
+		  __entry->new_prev_agino)
+);
+
+TRACE_EVENT(xrep_iunlink_add_to_bucket,
+	TP_PROTO(struct xfs_perag *pag, unsigned int bucket,
+		 xfs_agino_t agino, xfs_agino_t curr_head),
+	TP_ARGS(pag, bucket, agino, curr_head),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(unsigned int, bucket)
+		__field(xfs_agino_t, agino)
+		__field(xfs_agino_t, next_agino)
+	),
+	TP_fast_assign(
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->bucket = bucket;
+		__entry->agino = agino;
+		__entry->next_agino = curr_head;
+	),
+	TP_printk("dev %d:%d agno 0x%x bucket %u agino 0x%x next_agino 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->bucket,
+		  __entry->agino,
+		  __entry->next_agino)
+);
+
+TRACE_EVENT(xrep_iunlink_commit_bucket,
+	TP_PROTO(struct xfs_perag *pag, unsigned int bucket,
+		 xfs_agino_t old_agino, xfs_agino_t agino),
+	TP_ARGS(pag, bucket, old_agino, agino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(unsigned int, bucket)
+		__field(xfs_agino_t, old_agino)
+		__field(xfs_agino_t, agino)
+	),
+	TP_fast_assign(
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->bucket = bucket;
+		__entry->old_agino = old_agino;
+		__entry->agino = agino;
+	),
+	TP_printk("dev %d:%d agno 0x%x bucket %u agino 0x%x -> 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->bucket,
+		  __entry->old_agino,
+		  __entry->agino)
+);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

