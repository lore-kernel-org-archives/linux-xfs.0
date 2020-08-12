Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6EFC433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A6AA207DE
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgHLJ0G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 05:26:06 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:44467 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727837AbgHLJ0F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Aug 2020 05:26:05 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id E93BED7CF64
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 19:25:58 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1B-0003QZ-7e
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:57 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1A-00Alt0-T4
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/13] xfs: replace iunlink backref lookups with list lookups
Date:   Wed, 12 Aug 2020 19:25:49 +1000
Message-Id: <20200812092556.2567285-7-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200812092556.2567285-1-david@fromorbit.com>
References: <20200812092556.2567285-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=Cg-UvHQeAx9AKa-64McA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now we have an in memory linked list of all the inodes on the
unlinked list, use that to look up inodes in the list that we need
to modify when adding or removing from the list.

This means we are no longer using the backref cache to maintain the
previous inode lookups, so we can remove all that infrastructure
now.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_error.c |   2 -
 fs/xfs/xfs_inode.c | 327 ++++++++-------------------------------------
 fs/xfs/xfs_inode.h |   3 -
 fs/xfs/xfs_mount.c |   5 -
 fs/xfs/xfs_trace.h |   1 -
 5 files changed, 54 insertions(+), 284 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 7f6e20899473..829a89418830 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -162,7 +162,6 @@ XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
 XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
 XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
 XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
-XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
 XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
 
 static struct attribute *xfs_errortag_attrs[] = {
@@ -200,7 +199,6 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(buf_lru_ref),
 	XFS_ERRORTAG_ATTR_LIST(force_repair),
 	XFS_ERRORTAG_ATTR_LIST(bad_summary),
-	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
 	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
 	NULL,
 };
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index dcf80ac51267..2c930de99561 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1893,196 +1893,29 @@ xfs_inactive(
  * because we must walk that list to find the inode that points to the inode
  * being removed from the unlinked hash bucket list.
  *
- * What if we modelled the unlinked list as a collection of records capturing
- * "X.next_unlinked = Y" relations?  If we indexed those records on Y, we'd
- * have a fast way to look up unlinked list predecessors, which avoids the
- * slow list walk.  That's exactly what we do here (in-core) with a per-AG
- * rhashtable.
+ * However, inodes that are on the unlinked list are also guaranteed to be in
+ * memory as they are loaded and then pinned in memory by whatever holds
+ * references to the inode to perform the unlink. Same goes for the O_TMPFILE
+ * usage of the unlinked list - those files are pinned in memory by an open file
+ * descriptor. Hence the inodes on the list are pinned in memory until they are
+ * removed from the list.
  *
- * Because this is a backref cache, we ignore operational failures since the
- * iunlink code can fall back to the slow bucket walk.  The only errors that
- * should bubble out are for obviously incorrect situations.
+ * That means we can simply use an in-memory double linked list to track inodes
+ * on the unlinked list. As we've removed the scalability problem resulting from
+ * removal on a single linked list requiring traversal, we also no longer use
+ * the on-disk hash to keep traversals short. We just use a single list on disk
+ * now, and track the previous inode in the list in memory.
  *
- * All users of the backref cache MUST hold the AGI buffer lock to serialize
- * access or have otherwise provided for concurrency control.
- */
-
-/* Capture a "X.next_unlinked = Y" relationship. */
-struct xfs_iunlink {
-	struct rhash_head	iu_rhash_head;
-	xfs_agino_t		iu_agino;		/* X */
-	xfs_agino_t		iu_next_unlinked;	/* Y */
-};
-
-/* Unlinked list predecessor lookup hashtable construction */
-static int
-xfs_iunlink_obj_cmpfn(
-	struct rhashtable_compare_arg	*arg,
-	const void			*obj)
-{
-	const xfs_agino_t		*key = arg->key;
-	const struct xfs_iunlink	*iu = obj;
-
-	if (iu->iu_next_unlinked != *key)
-		return 1;
-	return 0;
-}
-
-static const struct rhashtable_params xfs_iunlink_hash_params = {
-	.min_size		= XFS_AGI_UNLINKED_BUCKETS,
-	.key_len		= sizeof(xfs_agino_t),
-	.key_offset		= offsetof(struct xfs_iunlink,
-					   iu_next_unlinked),
-	.head_offset		= offsetof(struct xfs_iunlink, iu_rhash_head),
-	.automatic_shrinking	= true,
-	.obj_cmpfn		= xfs_iunlink_obj_cmpfn,
-};
-
-/*
- * Return X, where X.next_unlinked == @agino.  Returns NULLAGINO if no such
- * relation is found.
+ * To provide the guarantee that inodes are always on this in memory list, log
+ * recovery does what is necessary to populate the list sufficient to perform
+ * removal from the head of the list correctly. As such, we can now always rely
+ * on the in-memory list and if it differs from what we find on disk then we
+ * have a memory corruption problem or a software bug and so mismatches are now
+ * considered EFSCORRUPTION errors and are not recoverable.
+ *
+ * All users of the unlinked list MUST hold the AGI buffer lock to serialize
+ * access to the list.
  */
-static xfs_agino_t
-xfs_iunlink_lookup_backref(
-	struct xfs_perag	*pag,
-	xfs_agino_t		agino)
-{
-	struct xfs_iunlink	*iu;
-
-	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &agino,
-			xfs_iunlink_hash_params);
-	return iu ? iu->iu_agino : NULLAGINO;
-}
-
-/*
- * Take ownership of an iunlink cache entry and insert it into the hash table.
- * If successful, the entry will be owned by the cache; if not, it is freed.
- * Either way, the caller does not own @iu after this call.
- */
-static int
-xfs_iunlink_insert_backref(
-	struct xfs_perag	*pag,
-	struct xfs_iunlink	*iu)
-{
-	int			error;
-
-	error = rhashtable_insert_fast(&pag->pagi_unlinked_hash,
-			&iu->iu_rhash_head, xfs_iunlink_hash_params);
-	/*
-	 * Fail loudly if there already was an entry because that's a sign of
-	 * corruption of in-memory data.  Also fail loudly if we see an error
-	 * code we didn't anticipate from the rhashtable code.  Currently we
-	 * only anticipate ENOMEM.
-	 */
-	if (error) {
-		WARN(error != -ENOMEM, "iunlink cache insert error %d", error);
-		kmem_free(iu);
-	}
-	/*
-	 * Absorb any runtime errors that aren't a result of corruption because
-	 * this is a cache and we can always fall back to bucket list scanning.
-	 */
-	if (error != 0 && error != -EEXIST)
-		error = 0;
-	return error;
-}
-
-/* Remember that @prev_agino.next_unlinked = @this_agino. */
-static int
-xfs_iunlink_add_backref(
-	struct xfs_perag	*pag,
-	xfs_agino_t		prev_agino,
-	xfs_agino_t		this_agino)
-{
-	struct xfs_iunlink	*iu;
-
-	if (XFS_TEST_ERROR(false, pag->pag_mount, XFS_ERRTAG_IUNLINK_FALLBACK))
-		return 0;
-
-	iu = kmem_zalloc(sizeof(*iu), KM_NOFS);
-	iu->iu_agino = prev_agino;
-	iu->iu_next_unlinked = this_agino;
-
-	return xfs_iunlink_insert_backref(pag, iu);
-}
-
-/*
- * Replace X.next_unlinked = @agino with X.next_unlinked = @next_unlinked.
- * If @next_unlinked is NULLAGINO, we drop the backref and exit.  If there
- * wasn't any such entry then we don't bother.
- */
-static int
-xfs_iunlink_change_backref(
-	struct xfs_perag	*pag,
-	xfs_agino_t		agino,
-	xfs_agino_t		next_unlinked)
-{
-	struct xfs_iunlink	*iu;
-	int			error;
-
-	/* Look up the old entry; if there wasn't one then exit. */
-	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &agino,
-			xfs_iunlink_hash_params);
-	if (!iu)
-		return 0;
-
-	/*
-	 * Remove the entry.  This shouldn't ever return an error, but if we
-	 * couldn't remove the old entry we don't want to add it again to the
-	 * hash table, and if the entry disappeared on us then someone's
-	 * violated the locking rules and we need to fail loudly.  Either way
-	 * we cannot remove the inode because internal state is or would have
-	 * been corrupt.
-	 */
-	error = rhashtable_remove_fast(&pag->pagi_unlinked_hash,
-			&iu->iu_rhash_head, xfs_iunlink_hash_params);
-	if (error)
-		return error;
-
-	/* If there is no new next entry just free our item and return. */
-	if (next_unlinked == NULLAGINO) {
-		kmem_free(iu);
-		return 0;
-	}
-
-	/* Update the entry and re-add it to the hash table. */
-	iu->iu_next_unlinked = next_unlinked;
-	return xfs_iunlink_insert_backref(pag, iu);
-}
-
-/* Set up the in-core predecessor structures. */
-int
-xfs_iunlink_init(
-	struct xfs_perag	*pag)
-{
-	return rhashtable_init(&pag->pagi_unlinked_hash,
-			&xfs_iunlink_hash_params);
-}
-
-/* Free the in-core predecessor structures. */
-static void
-xfs_iunlink_free_item(
-	void			*ptr,
-	void			*arg)
-{
-	struct xfs_iunlink	*iu = ptr;
-	bool			*freed_anything = arg;
-
-	*freed_anything = true;
-	kmem_free(iu);
-}
-
-void
-xfs_iunlink_destroy(
-	struct xfs_perag	*pag)
-{
-	bool			freed_anything = false;
-
-	rhashtable_free_and_destroy(&pag->pagi_unlinked_hash,
-			xfs_iunlink_free_item, &freed_anything);
-
-	ASSERT(freed_anything == false || XFS_FORCED_SHUTDOWN(pag->pag_mount));
-}
 
 /*
  * Point the AGI unlinked bucket at an inode and log the results.  The caller
@@ -2221,6 +2054,7 @@ xfs_iunlink_insert_inode(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi;
+	struct xfs_inode	*nip;
 	xfs_agino_t		next_agino;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
@@ -2242,9 +2076,13 @@ xfs_iunlink_insert_inode(
 		return -EFSCORRUPTED;
 	}
 
-	if (next_agino != NULLAGINO) {
+	nip = list_first_entry_or_null(&agibp->b_pag->pag_ici_unlink_list,
+					struct xfs_inode, i_unlink);
+	if (nip) {
 		xfs_agino_t		old_agino;
 
+		ASSERT(next_agino == XFS_INO_TO_AGINO(mp, nip->i_ino));
+
 		/*
 		 * There is already another inode in the bucket, so point this
 		 * inode to the current head of the list.
@@ -2254,14 +2092,8 @@ xfs_iunlink_insert_inode(
 		if (error)
 			return error;
 		ASSERT(old_agino == NULLAGINO);
-
-		/*
-		 * agino has been unlinked, add a backref from the next inode
-		 * back to agino.
-		 */
-		error = xfs_iunlink_add_backref(agibp->b_pag, agino, next_agino);
-		if (error)
-			return error;
+	} else {
+		ASSERT(next_agino == NULLAGINO);
 	}
 
 	/* Point the head of the list to point to this inode. */
@@ -2354,70 +2186,24 @@ xfs_iunlink_map_prev(
 	xfs_agnumber_t		agno,
 	xfs_agino_t		head_agino,
 	xfs_agino_t		target_agino,
-	xfs_agino_t		*agino,
+	xfs_agino_t		agino,
 	struct xfs_imap		*imap,
 	struct xfs_dinode	**dipp,
 	struct xfs_buf		**bpp,
 	struct xfs_perag	*pag)
 {
-	struct xfs_mount	*mp = tp->t_mountp;
-	xfs_agino_t		next_agino;
 	int			error;
 
 	ASSERT(head_agino != target_agino);
 	*bpp = NULL;
 
-	/* See if our backref cache can find it faster. */
-	*agino = xfs_iunlink_lookup_backref(pag, target_agino);
-	if (*agino != NULLAGINO) {
-		error = xfs_iunlink_map_ino(tp, agno, *agino, imap, dipp, bpp);
-		if (error)
-			return error;
-
-		if (be32_to_cpu((*dipp)->di_next_unlinked) == target_agino)
-			return 0;
-
-		/*
-		 * If we get here the cache contents were corrupt, so drop the
-		 * buffer and fall back to walking the bucket list.
-		 */
-		xfs_trans_brelse(tp, *bpp);
-		*bpp = NULL;
-		WARN_ON_ONCE(1);
-	}
-
-	trace_xfs_iunlink_map_prev_fallback(mp, agno);
-
-	/* Otherwise, walk the entire bucket until we find it. */
-	next_agino = head_agino;
-	while (next_agino != target_agino) {
-		xfs_agino_t	unlinked_agino;
-
-		if (*bpp)
-			xfs_trans_brelse(tp, *bpp);
-
-		*agino = next_agino;
-		error = xfs_iunlink_map_ino(tp, agno, next_agino, imap, dipp,
-				bpp);
-		if (error)
-			return error;
-
-		unlinked_agino = be32_to_cpu((*dipp)->di_next_unlinked);
-		/*
-		 * Make sure this pointer is valid and isn't an obvious
-		 * infinite loop.
-		 */
-		if (!xfs_verify_agino(mp, agno, unlinked_agino) ||
-		    next_agino == unlinked_agino) {
-			XFS_CORRUPTION_ERROR(__func__,
-					XFS_ERRLEVEL_LOW, mp,
-					*dipp, sizeof(**dipp));
-			error = -EFSCORRUPTED;
-			return error;
-		}
-		next_agino = unlinked_agino;
-	}
+	ASSERT(agino != NULLAGINO);
+	error = xfs_iunlink_map_ino(tp, agno, agino, imap, dipp, bpp);
+	if (error)
+		return error;
 
+	if (be32_to_cpu((*dipp)->di_next_unlinked) != target_agino)
+		return -EFSCORRUPTED;
 	return 0;
 }
 
@@ -2461,27 +2247,31 @@ xfs_iunlink_remove_inode(
 	if (error)
 		return error;
 
-	/*
-	 * If there was a backref pointing from the next inode back to this
-	 * one, remove it because we've removed this inode from the list.
-	 *
-	 * Later, if this inode was in the middle of the list we'll update
-	 * this inode's backref to point from the next inode.
-	 */
-	if (next_agino != NULLAGINO) {
-		error = xfs_iunlink_change_backref(agibp->b_pag, next_agino,
-				NULLAGINO);
-		if (error)
-			return error;
+#ifdef DEBUG
+	{
+	struct xfs_inode *nip = list_next_entry(ip, i_unlink);
+	if (nip)
+		ASSERT(next_agino == XFS_INO_TO_AGINO(mp, nip->i_ino));
+	else
+		ASSERT(next_agino == NULLAGINO);
 	}
+#endif
+
+	if (ip != list_first_entry(&agibp->b_pag->pag_ici_unlink_list,
+					struct xfs_inode, i_unlink)) {
 
-	if (head_agino != agino) {
+		struct xfs_inode *pip;
 		struct xfs_imap	imap;
 		xfs_agino_t	prev_agino;
 
+		ASSERT(head_agino != agino);
+
+		pip = list_prev_entry(ip, i_unlink);
+		prev_agino = XFS_INO_TO_AGINO(mp, pip->i_ino);
+
 		/* We need to search the list for the inode being freed. */
 		error = xfs_iunlink_map_prev(tp, agno, head_agino, agino,
-				&prev_agino, &imap, &last_dip, &last_ibp,
+				prev_agino, &imap, &last_dip, &last_ibp,
 				agibp->b_pag);
 		if (error)
 			return error;
@@ -2490,16 +2280,7 @@ xfs_iunlink_remove_inode(
 		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
 				last_dip, &imap, next_agino);
 
-		/*
-		 * Now we deal with the backref for this inode.  If this inode
-		 * pointed at a real inode, change the backref that pointed to
-		 * us to point to our old next.  If this inode was the end of
-		 * the list, delete the backref that pointed to us.  Note that
-		 * change_backref takes care of deleting the backref if
-		 * next_agino is NULLAGINO.
-		 */
-		return xfs_iunlink_change_backref(agibp->b_pag, agino,
-				next_agino);
+		return 0;
 	}
 
 	/* Point the head of the list to the next unlinked inode. */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 73f36908a1ce..7f8fbb7c8594 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -464,9 +464,6 @@ extern struct kmem_zone	*xfs_inode_zone;
 /* The default CoW extent size hint. */
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
-int xfs_iunlink_init(struct xfs_perag *pag);
-void xfs_iunlink_destroy(struct xfs_perag *pag);
-
 void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2def15297a5f..f28c969af272 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -146,7 +146,6 @@ xfs_free_perag(
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
-		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
 		call_rcu(&pag->rcu_head, __xfs_free_perag);
 	}
@@ -224,9 +223,6 @@ xfs_initialize_perag(
 		/* first new pag is fully initialized */
 		if (first_initialised == NULLAGNUMBER)
 			first_initialised = index;
-		error = xfs_iunlink_init(pag);
-		if (error)
-			goto out_hash_destroy;
 		spin_lock_init(&pag->pag_state_lock);
 	}
 
@@ -249,7 +245,6 @@ xfs_initialize_perag(
 		if (!pag)
 			break;
 		xfs_buf_hash_destroy(pag);
-		xfs_iunlink_destroy(pag);
 		kmem_free(pag);
 	}
 	return error;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index abb1d859f226..acddc60f6d88 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3514,7 +3514,6 @@ DEFINE_EVENT(xfs_ag_inode_class, name, \
 	TP_ARGS(ip))
 DEFINE_AGINODE_EVENT(xfs_iunlink);
 DEFINE_AGINODE_EVENT(xfs_iunlink_remove);
-DEFINE_AG_EVENT(xfs_iunlink_map_prev_fallback);
 
 DECLARE_EVENT_CLASS(xfs_fs_corrupt_class,
 	TP_PROTO(struct xfs_mount *mp, unsigned int flags),
-- 
2.26.2.761.g0e0b3e54be

