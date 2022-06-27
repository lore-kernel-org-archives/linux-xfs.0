Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FAE1CCA47C
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 00:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiF0Anq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 20:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiF0Anp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 20:43:45 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA68F2BE5
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 17:43:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B4B1F10E775B
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 10:43:39 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5cqo-00BTzt-GN
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 10:43:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5cqo-000uaO-ER
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 10:43:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/9] xfs: double link the unlinked inode list
Date:   Mon, 27 Jun 2022 10:43:32 +1000
Message-Id: <20220627004336.217366-6-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627004336.217366-1-david@fromorbit.com>
References: <20220627004336.217366-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62b8fd3c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=RTwSvmzXio7UWOK0YXIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now we have forwards traversal via the incore inode in place, we now
need to add back pointers to the incore inode to entirely replace
the back reference cache. We use the same lookup semantics and
constraints as for the forwards pointer lookups during unlinks, and
so we can look up any inode in the unlinked list directly and update
the list pointers, forwards or backwards, at any time.

The only wrinkle in converting the unlinked list manipulations to
use in-core previous pointers is that log recovery doesn't have the
incore inode state built up so it can't just read in an inode and
release it to finish off the unlink. Hence we need to modify the
traversal in recovery to read one inode ahead before we
release the inode at the head of the list. This populates the
next->prev relationship sufficient to be able to replay the unlinked
list and hence greatly simplify the runtime code.

This recovery algorithm also requires that we actually remove inodes
from the unlinked list one at a time as background inode
inactivation will result in unlinked list removal racing with the
building of the in-memory unlinked list state. We could serialise
this by holding the AGI buffer lock when constructing the in memory
state, but all that does is lockstep background processing with list
building. It is much simpler to flush the inodegc immediately after
releasing the inode so that it is unlinked immediately and there is
no races present at all.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c   |   8 -
 fs/xfs/libxfs/xfs_ag.h   |   6 -
 fs/xfs/xfs_icache.c      |   2 +
 fs/xfs/xfs_inode.c       | 348 +++++++--------------------------------
 fs/xfs/xfs_inode.h       |   4 +-
 fs/xfs/xfs_log_recover.c |  34 +++-
 6 files changed, 90 insertions(+), 312 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 3e920cf1b454..2de67389fe60 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -194,7 +194,6 @@ xfs_free_perag(
 		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
 
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
-		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
 
 		call_rcu(&pag->rcu_head, __xfs_free_perag);
@@ -263,10 +262,6 @@ xfs_initialize_perag(
 		if (error)
 			goto out_remove_pag;
 
-		error = xfs_iunlink_init(pag);
-		if (error)
-			goto out_hash_destroy;
-
 		/* first new pag is fully initialized */
 		if (first_initialised == NULLAGNUMBER)
 			first_initialised = index;
@@ -280,8 +275,6 @@ xfs_initialize_perag(
 	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
 	return 0;
 
-out_hash_destroy:
-	xfs_buf_hash_destroy(pag);
 out_remove_pag:
 	radix_tree_delete(&mp->m_perag_tree, index);
 out_free_pag:
@@ -293,7 +286,6 @@ xfs_initialize_perag(
 		if (!pag)
 			break;
 		xfs_buf_hash_destroy(pag);
-		xfs_iunlink_destroy(pag);
 		kmem_free(pag);
 	}
 	return error;
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index e411d51c2589..bd5f715d116d 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -97,12 +97,6 @@ struct xfs_perag {
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
 
-	/*
-	 * Unlinked inode information.  This incore information reflects
-	 * data stored in the AGI, so callers must hold the AGI buffer lock
-	 * or have some other means to control concurrency.
-	 */
-	struct rhashtable	pagi_unlinked_hash;
 #endif /* __KERNEL__ */
 };
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5269354b1b69..9fc324a29535 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -111,6 +111,8 @@ xfs_inode_alloc(
 	INIT_WORK(&ip->i_ioend_work, xfs_end_io);
 	INIT_LIST_HEAD(&ip->i_ioend_list);
 	spin_lock_init(&ip->i_ioend_lock);
+	ip->i_next_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = NULLAGINO;
 
 	return ip;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e6ac13174062..f390a91243bf 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1815,196 +1815,21 @@ xfs_inactive(
  * because we must walk that list to find the inode that points to the inode
  * being removed from the unlinked hash bucket list.
  *
- * What if we modelled the unlinked list as a collection of records capturing
- * "X.next_unlinked = Y" relations?  If we indexed those records on Y, we'd
- * have a fast way to look up unlinked list predecessors, which avoids the
- * slow list walk.  That's exactly what we do here (in-core) with a per-AG
- * rhashtable.
+ * Hence we keep an in-memory double linked list to link each inode on an
+ * unlinked list. Because there are 64 unlinked lists per AGI, keeping pointer
+ * based lists qould require having 64 list heads in the perag, one for each
+ * list. This is expensive in terms of memory (think millions of AGs) and cache
+ * misses on lookups. Instead, use the fact that inodes on the unlinked list
+ * must be referenced at the VFS level to keep them on the list and hence we
+ * have an existence guarantee for inodes on the unlinked list.
  *
- * Because this is a backref cache, we ignore operational failures since the
- * iunlink code can fall back to the slow bucket walk.  The only errors that
- * should bubble out are for obviously incorrect situations.
- *
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
- */
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
+ * Given we have an existence guarantee, we can use lockless inode cache lookups
+ * to resolve aginos to xfs inodes. This means we only need 8 bytes per inode
+ * for the double linked unlinked list, and we don't need any extra locking to
+ * keep the list safe as all manipulations are done under the AGI buffer lock.
+ * Keeping the list up to date does not require memory allocation, just finding
+ * the XFS inode and updating the next/prev unlinked list aginos.
  */
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
-	ASSERT(freed_anything == false || xfs_is_shutdown(pag->pag_mount));
-}
 
 /*
  * Find an inode on the unlinked list. This does not take references to the
@@ -2039,6 +1864,26 @@ xfs_iunlink_lookup(
 	return ip;
 }
 
+/* Update the prev pointer of the next agino. */
+static int
+xfs_iunlink_update_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		prev_agino,
+	xfs_agino_t		next_agino)
+{
+	struct xfs_inode	*ip;
+
+	/* No update necessary if we are at the end of the list. */
+	if (next_agino == NULLAGINO)
+		return 0;
+
+	ip = xfs_iunlink_lookup(pag, next_agino);
+	if (!ip)
+		return -EFSCORRUPTED;
+	ip->i_prev_unlinked = prev_agino;
+	return 0;
+}
+
 /*
  * Point the AGI unlinked bucket at an inode and log the results.  The caller
  * is responsible for validating the old value.
@@ -2170,7 +2015,7 @@ xfs_iunlink_insert_inode(
 	struct xfs_perag	*pag,
 	struct xfs_buf		*agibp,
 	struct xfs_inode	*ip)
- {
+{
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi = agibp->b_addr;
 	xfs_agino_t		next_agino;
@@ -2190,6 +2035,14 @@ xfs_iunlink_insert_inode(
 		return -EFSCORRUPTED;
 	}
 
+	/*
+	 * Update the prev pointer in the next inode to point back to this
+	 * inode.
+	 */
+	error = xfs_iunlink_update_backref(pag, agino, next_agino);
+	if (error)
+		return error;
+
 	if (next_agino != NULLAGINO) {
 		xfs_agino_t		old_agino;
 
@@ -2203,14 +2056,6 @@ xfs_iunlink_insert_inode(
 			return error;
 		ASSERT(old_agino == NULLAGINO);
 		ip->i_next_unlinked = next_agino;
-
-		/*
-		 * agino has been unlinked, add a backref from the next inode
-		 * back to agino.
-		 */
-		error = xfs_iunlink_add_backref(pag, agino, next_agino);
-		if (error)
-			return error;
 	}
 
 	/* Point the head of the list to point to this inode. */
@@ -2251,63 +2096,6 @@ xfs_iunlink(
 	return error;
 }
 
-/*
- * Walk the unlinked chain from @head_agino until we find the inode that
- * points to @target_agino.  Return the inode number, map, dinode pointer,
- * and inode cluster buffer of that inode as @agino, @imap, @dipp, and @bpp.
- *
- * @tp, @pag, @head_agino, and @target_agino are input parameters.
- * @agino, @imap, @dipp, and @bpp are all output parameters.
- *
- * Do not call this function if @target_agino is the head of the list.
- */
-static int
-xfs_iunlink_lookup_prev(
-	struct xfs_perag	*pag,
-	xfs_agino_t		head_agino,
-	xfs_agino_t		target_agino,
-	struct xfs_inode	**ipp)
-{
-	struct xfs_mount	*mp = pag->pag_mount;
-	struct xfs_inode	*ip;
-	xfs_agino_t		next_agino;
-
-	*ipp = NULL;
-
-	/* See if our backref cache can find it faster. */
-	next_agino = xfs_iunlink_lookup_backref(pag, target_agino);
-	if (next_agino != NULLAGINO) {
-		ip = xfs_iunlink_lookup(pag, next_agino);
-		if (ip && ip->i_next_unlinked == target_agino) {
-			*ipp = ip;
-			return 0;
-		}
-	}
-
-	/* Otherwise, walk the entire bucket until we find it. */
-	next_agino = head_agino;
-	while (next_agino != NULLAGINO) {
-		ip = xfs_iunlink_lookup(pag, next_agino);
-		if (!ip)
-			return -EFSCORRUPTED;
-
-		/*
-		 * Make sure this pointer is valid and isn't an obvious
-		 * infinite loop.
-		 */
-		if (!xfs_verify_agino(mp, pag->pag_agno, ip->i_next_unlinked) ||
-		    next_agino == ip->i_next_unlinked)
-			return -EFSCORRUPTED;
-
-		if (ip->i_next_unlinked == target_agino) {
-			*ipp = ip;
-			return 0;
-		}
-		next_agino = ip->i_next_unlinked;
-	}
-	return -EFSCORRUPTED;
-}
-
 static int
 xfs_iunlink_remove_inode(
 	struct xfs_trans	*tp,
@@ -2344,51 +2132,33 @@ xfs_iunlink_remove_inode(
 		return error;
 
 	/*
-	 * If there was a backref pointing from the next inode back to this
-	 * one, remove it because we've removed this inode from the list.
-	 *
-	 * Later, if this inode was in the middle of the list we'll update
-	 * this inode's backref to point from the next inode.
+	 * Update the prev pointer in the next inode to point back to previous
+	 * inode in the chain.
 	 */
-	if (next_agino != NULLAGINO) {
-		error = xfs_iunlink_change_backref(pag, next_agino, NULLAGINO);
-		if (error)
-			return error;
-	}
+	error = xfs_iunlink_update_backref(pag, ip->i_prev_unlinked,
+			ip->i_next_unlinked);
+	if (error)
+		return error;
 
 	if (head_agino != agino) {
 		struct xfs_inode	*prev_ip;
 
-		error = xfs_iunlink_lookup_prev(pag, head_agino, agino,
-				&prev_ip);
-		if (error)
-			return error;
-
-		/* Point the previous inode on the list to the next inode. */
-		error = xfs_iunlink_update_inode(tp, prev_ip, pag, next_agino,
-				NULL);
-		if (error)
-			return error;
+		prev_ip = xfs_iunlink_lookup(pag, ip->i_prev_unlinked);
+		if (!prev_ip)
+			return -EFSCORRUPTED;
 
+		error = xfs_iunlink_update_inode(tp, prev_ip, pag,
+				ip->i_next_unlinked, NULL);
 		prev_ip->i_next_unlinked = ip->i_next_unlinked;
-		ip->i_next_unlinked = NULLAGINO;
-
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
+	} else {
+		/* Point the head of the list to the next unlinked inode. */
+		error = xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index,
+				ip->i_next_unlinked);
 	}
 
-	/* Point the head of the list to the next unlinked inode. */
 	ip->i_next_unlinked = NULLAGINO;
-	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index,
-			next_agino);
+	ip->i_prev_unlinked = NULLAGINO;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 8e2a33c6cbe2..8d8cce61e5ba 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -70,6 +70,7 @@ typedef struct xfs_inode {
 
 	/* unlinked list pointers */
 	xfs_agino_t		i_next_unlinked;
+	xfs_agino_t		i_prev_unlinked;
 
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */
@@ -508,9 +509,6 @@ extern struct kmem_cache	*xfs_inode_cache;
 
 bool xfs_inode_needs_inactive(struct xfs_inode *ip);
 
-int xfs_iunlink_init(struct xfs_perag *pag);
-void xfs_iunlink_destroy(struct xfs_perag *pag);
-
 void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7d0f530d7e3c..8e97f4240b93 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2674,28 +2674,50 @@ xlog_recover_iunlink_bucket(
 	struct xfs_agi		*agi,
 	int			bucket)
 {
+	struct xfs_inode	*prev_ip = NULL;
 	struct xfs_inode	*ip;
-	xfs_agino_t		agino;
+	xfs_agino_t		prev_agino, agino;
+	int			error = 0;
 
 	agino = be32_to_cpu(agi->agi_unlinked[bucket]);
 	while (agino != NULLAGINO) {
-		int	error;
 
 		error = xfs_iget(mp, NULL,
 				XFS_AGINO_TO_INO(mp, pag->pag_agno, agino),
 				0, 0, &ip);
 		if (error)
-			return error;;
+			break;
 
 		ASSERT(VFS_I(ip)->i_nlink == 0);
 		ASSERT(VFS_I(ip)->i_mode != 0);
 		xfs_iflags_clear(ip, XFS_IRECOVERY);
 		agino = ip->i_next_unlinked;
 
-		xfs_irele(ip);
-		cond_resched();
+		if (prev_ip) {
+			ip->i_prev_unlinked = prev_agino;
+			xfs_irele(prev_ip);
+
+			/*
+			 * Ensure the inode is removed from the unlinked list
+			 * before we continue so that it race with building the
+			 * in-memory list here. THis could be serialised with
+			 * the agibp lock, but that just serialises via
+			 * lockstepping and it's much simpler just to flush the
+			 * inodegc queue and wait for it to complete.
+			 */
+			xfs_inodegc_flush(mp);
+		}
+
+		prev_agino = agino;
+		prev_ip = ip;
 	}
-	return 0;
+
+	if (prev_ip) {
+		ip->i_prev_unlinked = prev_agino;
+		xfs_irele(prev_ip);
+	}
+	xfs_inodegc_flush(mp);
+	return error;
 }
 
 /*
-- 
2.36.1

