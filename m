Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37712 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfBBRBK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Feb 2019 12:01:10 -0500
Date: Sat, 2 Feb 2019 09:01:10 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] xfs: cache unlinked pointers in an rhashtable
Message-ID: <20190202170110.GB18160@infradead.org>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897672012.26065.1375987197453969157.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154897672012.26065.1375987197453969157.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 03:18:40PM -0800, Darrick J. Wong wrote:
> +/*
> + * Faster In-Core Unlinked List Lookups
> + * ====================================

I'd drop the "Faster " here - the whole point of a separate in-core
lookup is generally that it is faster.

> +struct xfs_iunlink_key {
> +	xfs_agino_t		iu_next_unlinked;
> +};

I don't think we need this structure at all.  We can just directly
pass a pointer to the xfs_agino_t instead.

> +	.obj_cmpfn		= _xfs_iunlink_obj_cmp,

No real need for the _ prefix.  Also it would generally be nice
if the method implementation name is prefix + method name.

> +int
> +xfs_iunlink_lookup_backref(
> +	struct xfs_perag	*pag,
> +	xfs_agino_t		agino,
> +	xfs_agino_t		*prev_agino)
> +{
> +	struct xfs_iunlink_key	key = { .iu_next_unlinked = agino };
> +	struct xfs_iunlink	*iu;
> +
> +	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &key,
> +			xfs_iunlink_hash_params);
> +	if (!iu)
> +		return -ENOENT;
> +	*prev_agino = iu->iu_agino;
> +	return 0;

I think we can just retun the xfs_agino_t as the return value, with
NULLAGINO as the not found return value.

> +
> +/* Forget that X.next_unlinked = @agino. */
> +int
> +xfs_iunlink_forget_backref(
> +	struct xfs_perag	*pag,
> +	xfs_agino_t		agino)
> +{
> +	struct xfs_iunlink_key	key = { .iu_next_unlinked = agino };
> +	struct xfs_iunlink	*iu;
> +	int			error;
> +
> +	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &key,
> +			xfs_iunlink_hash_params);
> +	if (!iu)
> +		return -ENOENT;
> +
> +	error = rhashtable_remove_fast(&pag->pagi_unlinked_hash,
> +			&iu->iu_rhash_head, xfs_iunlink_hash_params);
> +	if (error)
> +		return error;
> +
> +	kmem_free(iu);
> +	return 0;

This mostly duplicates the change_backref help.  If we just free
the iu for a NULLAGINO next_unlinked there we can merge the two
functions easily.

> +int xfs_iunlink_init(struct xfs_perag *pag);
> +void xfs_iunlink_destroy(struct xfs_perag *pag);
> +int xfs_iunlink_lookup_backref(struct xfs_perag *pag, xfs_agino_t agino,
> +		xfs_agino_t *prev_agino);
> +int xfs_iunlink_add_backref(struct xfs_perag *pag, xfs_agino_t prev_agino,
> +		xfs_agino_t this_agino);
> +int xfs_iunlink_forget_backref(struct xfs_perag *pag, xfs_agino_t agino);
> +int xfs_iunlink_change_backref(struct xfs_perag *pag, xfs_agino_t prev_agino,
> +		xfs_agino_t this_agino);

Half of these aren't used outside xfs_inode.c.

> +		xfs_iunlink_destroy(pag);
>  		mutex_destroy(&pag->pagi_unlinked_lock);
>  		xfs_buf_hash_destroy(pag);
>  		mutex_destroy(&pag->pag_ici_reclaim_lock);
> @@ -231,6 +232,9 @@ xfs_initialize_perag(
>  		if (first_initialised == NULLAGNUMBER)
>  			first_initialised = index;
>  		mutex_init(&pag->pagi_unlinked_lock);
> +		error = xfs_iunlink_init(pag);
> +		if (error)
> +			goto out_iunlink_mutex;

Any good reason pagi_unlinked_lock isn't handled in
xfs_iunlink_init / xfs_iunlink_destroy?

Untested patch for most of my comments above:

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e797b11ad842..f8da8ce48348 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1907,7 +1907,7 @@ xfs_inactive(
 }
 
 /*
- * Faster In-Core Unlinked List Lookups
+ * In-Core Unlinked List Lookups
  * ====================================
  *
  * Every inode is supposed to be reachable from some other piece of metadata
@@ -1937,20 +1937,16 @@ struct xfs_iunlink {
 	xfs_agino_t		iu_next_unlinked;
 };
 
-struct xfs_iunlink_key {
-	xfs_agino_t		iu_next_unlinked;
-};
-
 /* Unlinked list predecessor lookup hashtable construction */
 static int
-xfs_iunlink_obj_cmp(
+xfs_iunlink_obj_cmpfn(
 	struct rhashtable_compare_arg	*arg,
 	const void			*obj)
 {
-	const struct xfs_iunlink_key	*key = arg->key;
+	const xfs_agino_t		*key = arg->key;
 	const struct xfs_iunlink	*iu = obj;
 
-	if (iu->iu_next_unlinked != key->iu_next_unlinked)
+	if (iu->iu_next_unlinked != *key)
 		return 1;
 	return 0;
 }
@@ -1962,28 +1958,25 @@ static const struct rhashtable_params xfs_iunlink_hash_params = {
 	.key_offset		= offsetof(struct xfs_iunlink, iu_next_unlinked),
 	.head_offset		= offsetof(struct xfs_iunlink, iu_rhash_head),
 	.automatic_shrinking	= true,
-	.obj_cmpfn		= xfs_iunlink_obj_cmp,
+	.obj_cmpfn		= xfs_iunlink_obj_cmpfn,
 };
 
 /*
- * Return X (in @prev_agino), where X.next_unlinked == @agino.  Returns -ENOENT
- * if no such relation is found.
+ * Return X, where X.next_unlinked == @agino.  Returns NULLAGINO if no such
+ * relation is found.
  */
-static int
+static xfs_agino_t
 xfs_iunlink_lookup_backref(
 	struct xfs_perag	*pag,
-	xfs_agino_t		agino,
-	xfs_agino_t		*prev_agino)
+	xfs_agino_t		agino)
 {
-	struct xfs_iunlink_key	key = { .iu_next_unlinked = agino };
 	struct xfs_iunlink	*iu;
 
-	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &key,
+	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &agino,
 			xfs_iunlink_hash_params);
 	if (!iu)
-		return -ENOENT;
-	*prev_agino = iu->iu_agino;
-	return 0;
+		return NULLAGINO;
+	return iu->iu_agino;
 }
 
 /* Remember that @prev_agino.next_unlinked = @this_agino. */
@@ -2003,31 +1996,6 @@ xfs_iunlink_add_backref(
 			&iu->iu_rhash_head, xfs_iunlink_hash_params);
 }
 
-/* Forget that X.next_unlinked = @agino. */
-static int
-xfs_iunlink_forget_backref(
-	struct xfs_perag	*pag,
-	xfs_agino_t		agino)
-{
-	struct xfs_iunlink_key	key = { .iu_next_unlinked = agino };
-	struct xfs_iunlink	*iu;
-	int			error;
-
-	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &key,
-			xfs_iunlink_hash_params);
-	if (!iu)
-		return -ENOENT;
-
-	error = rhashtable_remove_fast(&pag->pagi_unlinked_hash,
-			&iu->iu_rhash_head, xfs_iunlink_hash_params);
-	if (error)
-		return error;
-
-	kmem_free(iu);
-	return 0;
-}
-
-
 /* Replace X.next_unlinked = @agino with X.next_unlinked = @next_unlinked. */
 static int
 xfs_iunlink_change_backref(
@@ -2035,11 +2003,10 @@ xfs_iunlink_change_backref(
 	xfs_agino_t		agino,
 	xfs_agino_t		next_unlinked)
 {
-	struct xfs_iunlink_key	key = { .iu_next_unlinked = agino };
 	struct xfs_iunlink	*iu;
 	int			error;
 
-	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &key,
+	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &agino,
 			xfs_iunlink_hash_params);
 	if (!iu)
 		return -ENOENT;
@@ -2049,8 +2016,18 @@ xfs_iunlink_change_backref(
 	if (error)
 		return error;
 
-	iu->iu_next_unlinked = next_unlinked;
+	/*
+	 * If there is no new next entry just free our item and return.
+	 */
+	if (next_unlinked == NULLAGINO) {
+		kmem_free(iu);
+		return 0;
+	}
 
+	/*
+	 * Else update the hash table to the new entry.
+	 */
+	iu->iu_next_unlinked = next_unlinked;
 	return rhashtable_insert_fast(&pag->pagi_unlinked_hash,
 			&iu->iu_rhash_head, xfs_iunlink_hash_params);
 }
@@ -2357,8 +2334,8 @@ xfs_iunlink_map_prev(
 	ASSERT(head_agino != target_agino);
 
 	/* See if our backref cache can find it faster. */
-	error = xfs_iunlink_lookup_backref(pag, target_agino, &next_agino);
-	if (error == 0) {
+	next_agino = xfs_iunlink_lookup_backref(pag, target_agino);
+	if (next_agino != NULLAGINO) {
 		next_ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
 		error = xfs_iunlink_map_ino(tp, next_ino, &last_imap,
 				&last_dip, &last_ibp);
@@ -2468,7 +2445,8 @@ xfs_iunlink_remove(
 			goto out_unlock;
 
 		if (next_agino != NULLAGINO) {
-			error = xfs_iunlink_forget_backref(pag, next_agino);
+			error = xfs_iunlink_change_backref(pag, next_agino,
+					NULLAGINO);
 			if (error)
 				goto out_unlock;
 		}
@@ -2496,7 +2474,8 @@ xfs_iunlink_remove(
 		if (error)
 			goto out_unlock;
 		if (next_agino != NULLAGINO) {
-			error = xfs_iunlink_forget_backref(pag, next_agino);
+			error = xfs_iunlink_change_backref(pag, next_agino,
+					NULLAGINO);
 			if (error)
 				goto out_unlock;
 		}
@@ -2504,11 +2483,7 @@ xfs_iunlink_remove(
 		/* Point the previous inode on the list to the next inode. */
 		xfs_iunlink_update_dinode(tp, last_ibp, last_dip, &imap,
 				next_ino, next_agino);
-		if (next_agino == NULLAGINO)
-			error = xfs_iunlink_forget_backref(pag, agino);
-		else
-			error = xfs_iunlink_change_backref(pag, agino,
-					next_agino);
+		error = xfs_iunlink_change_backref(pag, agino, next_agino);
 		if (error)
 			goto out_unlock;
 	}
