Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73842C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 598436113A
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhIRBao (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230044AbhIRBan (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:30:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24CA160FBF;
        Sat, 18 Sep 2021 01:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928561;
        bh=ecWs/yi+xC1fUgYM9NAv5DBhswEr1v4efojwYWVRV+c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GfrNF2Wo1mctFr1K5djwDn4pJzcmaAJh10b+Y6L/4HqacTfG63Bq0C9kl3RJkULlH
         5hqDwSxffjcIjZKQxLeEgrzV0fOtY+V5g2WK4bwPrz/U/n2L0EwRH5q3i9+WZpDcBM
         yHV3grI8sCnmLDgiXPIkDqXI42IrJg/+njkxUaivV0rey2V4FX/bQ7mp4lqy4/vWdN
         xLqTeDQn6GzlYsVSS9xfslZORcql6Lkr3s9REt41ALcc7vO9bS1EbpSI7D3b1evyA5
         ZADcIcusPAv/IBKg6+fA1U2oZjnXJmkxNHD4WEkc28OhVrhe0IoeTFfQID7G2RdZ4S
         JtQmLIeV1CDpA==
Subject: [PATCH 02/14] xfs: don't allocate scrub contexts on the stack
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:29:20 -0700
Message-ID: <163192856086.416199.10504751435007741959.stgit@magnolia>
In-Reply-To: <163192854958.416199.3396890438240296942.stgit@magnolia>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the on-stack scrub context, btree scrub context, and da btree
scrub context into a heap allocation so that we reduce stack usage and
gain the ability to handle tall btrees without issue.

Specifically, this saves us ~208 bytes for the dabtree scrub, ~464 bytes
for the btree scrub, and ~200 bytes for the main scrub context.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/btree.c   |   54 ++++++++++++++++++++++++------------------
 fs/xfs/scrub/btree.h   |    1 +
 fs/xfs/scrub/dabtree.c |   62 ++++++++++++++++++++++++++----------------------
 fs/xfs/scrub/scrub.c   |   60 ++++++++++++++++++++++++++--------------------
 4 files changed, 98 insertions(+), 79 deletions(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index eccb855dc904..26dcb4691e31 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -627,15 +627,8 @@ xchk_btree(
 	const struct xfs_owner_info	*oinfo,
 	void				*private)
 {
-	struct xchk_btree		bs = {
-		.cur			= cur,
-		.scrub_rec		= scrub_fn,
-		.oinfo			= oinfo,
-		.firstrec		= true,
-		.private		= private,
-		.sc			= sc,
-	};
 	union xfs_btree_ptr		ptr;
+	struct xchk_btree		*bs;
 	union xfs_btree_ptr		*pp;
 	union xfs_btree_rec		*recp;
 	struct xfs_btree_block		*block;
@@ -646,10 +639,24 @@ xchk_btree(
 	int				i;
 	int				error = 0;
 
+	/*
+	 * Allocate the btree scrub context from the heap, because this
+	 * structure can get rather large.
+	 */
+	bs = kmem_zalloc(sizeof(struct xchk_btree), KM_NOFS | KM_MAYFAIL);
+	if (!bs)
+		return -ENOMEM;
+	bs->cur = cur;
+	bs->scrub_rec = scrub_fn;
+	bs->oinfo = oinfo;
+	bs->firstrec = true;
+	bs->private = private;
+	bs->sc = sc;
+
 	/* Initialize scrub state */
 	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++)
-		bs.firstkey[i] = true;
-	INIT_LIST_HEAD(&bs.to_check);
+		bs->firstkey[i] = true;
+	INIT_LIST_HEAD(&bs->to_check);
 
 	/* Don't try to check a tree with a height we can't handle. */
 	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS) {
@@ -663,9 +670,9 @@ xchk_btree(
 	 */
 	level = cur->bc_nlevels - 1;
 	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
-	if (!xchk_btree_ptr_ok(&bs, cur->bc_nlevels, &ptr))
+	if (!xchk_btree_ptr_ok(bs, cur->bc_nlevels, &ptr))
 		goto out;
-	error = xchk_btree_get_block(&bs, level, &ptr, &block, &bp);
+	error = xchk_btree_get_block(bs, level, &ptr, &block, &bp);
 	if (error || !block)
 		goto out;
 
@@ -678,7 +685,7 @@ xchk_btree(
 			/* End of leaf, pop back towards the root. */
 			if (cur->bc_ptrs[level] >
 			    be16_to_cpu(block->bb_numrecs)) {
-				xchk_btree_block_keys(&bs, level, block);
+				xchk_btree_block_keys(bs, level, block);
 				if (level < cur->bc_nlevels - 1)
 					cur->bc_ptrs[level + 1]++;
 				level++;
@@ -686,11 +693,11 @@ xchk_btree(
 			}
 
 			/* Records in order for scrub? */
-			xchk_btree_rec(&bs);
+			xchk_btree_rec(bs);
 
 			/* Call out to the record checker. */
 			recp = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
-			error = bs.scrub_rec(&bs, recp);
+			error = bs->scrub_rec(bs, recp);
 			if (error)
 				break;
 			if (xchk_should_terminate(sc, &error) ||
@@ -703,7 +710,7 @@ xchk_btree(
 
 		/* End of node, pop back towards the root. */
 		if (cur->bc_ptrs[level] > be16_to_cpu(block->bb_numrecs)) {
-			xchk_btree_block_keys(&bs, level, block);
+			xchk_btree_block_keys(bs, level, block);
 			if (level < cur->bc_nlevels - 1)
 				cur->bc_ptrs[level + 1]++;
 			level++;
@@ -711,16 +718,16 @@ xchk_btree(
 		}
 
 		/* Keys in order for scrub? */
-		xchk_btree_key(&bs, level);
+		xchk_btree_key(bs, level);
 
 		/* Drill another level deeper. */
 		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
-		if (!xchk_btree_ptr_ok(&bs, level, pp)) {
+		if (!xchk_btree_ptr_ok(bs, level, pp)) {
 			cur->bc_ptrs[level]++;
 			continue;
 		}
 		level--;
-		error = xchk_btree_get_block(&bs, level, pp, &block, &bp);
+		error = xchk_btree_get_block(bs, level, pp, &block, &bp);
 		if (error || !block)
 			goto out;
 
@@ -729,13 +736,14 @@ xchk_btree(
 
 out:
 	/* Process deferred owner checks on btree blocks. */
-	list_for_each_entry_safe(co, n, &bs.to_check, list) {
-		if (!error && bs.cur)
-			error = xchk_btree_check_block_owner(&bs,
-					co->level, co->daddr);
+	list_for_each_entry_safe(co, n, &bs->to_check, list) {
+		if (!error && bs->cur)
+			error = xchk_btree_check_block_owner(bs, co->level,
+					co->daddr);
 		list_del(&co->list);
 		kmem_free(co);
 	}
+	kmem_free(bs);
 
 	return error;
 }
diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
index b7d2fc01fbf9..d5c0b0cbc505 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -44,6 +44,7 @@ struct xchk_btree {
 	bool				firstkey[XFS_BTREE_MAXLEVELS];
 	struct list_head		to_check;
 };
+
 int xchk_btree(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
 		xchk_btree_rec_fn scrub_fn, const struct xfs_owner_info *oinfo,
 		void *private);
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 8a52514bc1ff..b962cfbbd92b 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -473,7 +473,7 @@ xchk_da_btree(
 	xchk_da_btree_rec_fn		scrub_fn,
 	void				*private)
 {
-	struct xchk_da_btree		ds = {};
+	struct xchk_da_btree		*ds;
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_da_state_blk		*blks;
 	struct xfs_da_node_entry	*key;
@@ -486,32 +486,35 @@ xchk_da_btree(
 		return 0;
 
 	/* Set up initial da state. */
-	ds.dargs.dp = sc->ip;
-	ds.dargs.whichfork = whichfork;
-	ds.dargs.trans = sc->tp;
-	ds.dargs.op_flags = XFS_DA_OP_OKNOENT;
-	ds.state = xfs_da_state_alloc(&ds.dargs);
-	ds.sc = sc;
-	ds.private = private;
+	ds = kmem_zalloc(sizeof(struct xchk_da_btree), KM_NOFS | KM_MAYFAIL);
+	if (!ds)
+		return -ENOMEM;
+	ds->dargs.dp = sc->ip;
+	ds->dargs.whichfork = whichfork;
+	ds->dargs.trans = sc->tp;
+	ds->dargs.op_flags = XFS_DA_OP_OKNOENT;
+	ds->state = xfs_da_state_alloc(&ds->dargs);
+	ds->sc = sc;
+	ds->private = private;
 	if (whichfork == XFS_ATTR_FORK) {
-		ds.dargs.geo = mp->m_attr_geo;
-		ds.lowest = 0;
-		ds.highest = 0;
+		ds->dargs.geo = mp->m_attr_geo;
+		ds->lowest = 0;
+		ds->highest = 0;
 	} else {
-		ds.dargs.geo = mp->m_dir_geo;
-		ds.lowest = ds.dargs.geo->leafblk;
-		ds.highest = ds.dargs.geo->freeblk;
+		ds->dargs.geo = mp->m_dir_geo;
+		ds->lowest = ds->dargs.geo->leafblk;
+		ds->highest = ds->dargs.geo->freeblk;
 	}
-	blkno = ds.lowest;
+	blkno = ds->lowest;
 	level = 0;
 
 	/* Find the root of the da tree, if present. */
-	blks = ds.state->path.blk;
-	error = xchk_da_btree_block(&ds, level, blkno);
+	blks = ds->state->path.blk;
+	error = xchk_da_btree_block(ds, level, blkno);
 	if (error)
 		goto out_state;
 	/*
-	 * We didn't find a block at ds.lowest, which means that there's
+	 * We didn't find a block at ds->lowest, which means that there's
 	 * no LEAF1/LEAFN tree (at least not where it's supposed to be),
 	 * so jump out now.
 	 */
@@ -523,16 +526,16 @@ xchk_da_btree(
 		/* Handle leaf block. */
 		if (blks[level].magic != XFS_DA_NODE_MAGIC) {
 			/* End of leaf, pop back towards the root. */
-			if (blks[level].index >= ds.maxrecs[level]) {
+			if (blks[level].index >= ds->maxrecs[level]) {
 				if (level > 0)
 					blks[level - 1].index++;
-				ds.tree_level++;
+				ds->tree_level++;
 				level--;
 				continue;
 			}
 
 			/* Dispatch record scrubbing. */
-			error = scrub_fn(&ds, level);
+			error = scrub_fn(ds, level);
 			if (error)
 				break;
 			if (xchk_should_terminate(sc, &error) ||
@@ -545,17 +548,17 @@ xchk_da_btree(
 
 
 		/* End of node, pop back towards the root. */
-		if (blks[level].index >= ds.maxrecs[level]) {
+		if (blks[level].index >= ds->maxrecs[level]) {
 			if (level > 0)
 				blks[level - 1].index++;
-			ds.tree_level++;
+			ds->tree_level++;
 			level--;
 			continue;
 		}
 
 		/* Hashes in order for scrub? */
-		key = xchk_da_btree_node_entry(&ds, level);
-		error = xchk_da_btree_hash(&ds, level, &key->hashval);
+		key = xchk_da_btree_node_entry(ds, level);
+		error = xchk_da_btree_hash(ds, level, &key->hashval);
 		if (error)
 			goto out;
 
@@ -564,11 +567,11 @@ xchk_da_btree(
 		level++;
 		if (level >= XFS_DA_NODE_MAXDEPTH) {
 			/* Too deep! */
-			xchk_da_set_corrupt(&ds, level - 1);
+			xchk_da_set_corrupt(ds, level - 1);
 			break;
 		}
-		ds.tree_level--;
-		error = xchk_da_btree_block(&ds, level, blkno);
+		ds->tree_level--;
+		error = xchk_da_btree_block(ds, level, blkno);
 		if (error)
 			goto out;
 		if (blks[level].bp == NULL)
@@ -587,6 +590,7 @@ xchk_da_btree(
 	}
 
 out_state:
-	xfs_da_state_free(ds.state);
+	xfs_da_state_free(ds->state);
+	kmem_free(ds);
 	return error;
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 51e4c61916d2..0569b15526ea 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -461,15 +461,10 @@ xfs_scrub_metadata(
 	struct file			*file,
 	struct xfs_scrub_metadata	*sm)
 {
-	struct xfs_scrub		sc = {
-		.file			= file,
-		.sm			= sm,
-	};
+	struct xfs_scrub		*sc;
 	struct xfs_mount		*mp = XFS_I(file_inode(file))->i_mount;
 	int				error = 0;
 
-	sc.mp = mp;
-
 	BUILD_BUG_ON(sizeof(meta_scrub_ops) !=
 		(sizeof(struct xchk_meta_ops) * XFS_SCRUB_TYPE_NR));
 
@@ -489,59 +484,68 @@ xfs_scrub_metadata(
 
 	xchk_experimental_warning(mp);
 
-	sc.ops = &meta_scrub_ops[sm->sm_type];
-	sc.sick_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
+	sc = kmem_zalloc(sizeof(struct xfs_scrub), KM_NOFS | KM_MAYFAIL);
+	if (!sc) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	sc->mp = mp;
+	sc->file = file;
+	sc->sm = sm;
+	sc->ops = &meta_scrub_ops[sm->sm_type];
+	sc->sick_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
 retry_op:
 	/*
 	 * When repairs are allowed, prevent freezing or readonly remount while
 	 * scrub is running with a real transaction.
 	 */
 	if (sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
-		error = mnt_want_write_file(sc.file);
+		error = mnt_want_write_file(sc->file);
 		if (error)
 			goto out;
 	}
 
 	/* Set up for the operation. */
-	error = sc.ops->setup(&sc);
+	error = sc->ops->setup(sc);
 	if (error)
 		goto out_teardown;
 
 	/* Scrub for errors. */
-	error = sc.ops->scrub(&sc);
-	if (!(sc.flags & XCHK_TRY_HARDER) && error == -EDEADLOCK) {
+	error = sc->ops->scrub(sc);
+	if (!(sc->flags & XCHK_TRY_HARDER) && error == -EDEADLOCK) {
 		/*
 		 * Scrubbers return -EDEADLOCK to mean 'try harder'.
 		 * Tear down everything we hold, then set up again with
 		 * preparation for worst-case scenarios.
 		 */
-		error = xchk_teardown(&sc, 0);
+		error = xchk_teardown(sc, 0);
 		if (error)
 			goto out;
-		sc.flags |= XCHK_TRY_HARDER;
+		sc->flags |= XCHK_TRY_HARDER;
 		goto retry_op;
 	} else if (error || (sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE))
 		goto out_teardown;
 
-	xchk_update_health(&sc);
+	xchk_update_health(sc);
 
-	if ((sc.sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
-	    !(sc.flags & XREP_ALREADY_FIXED)) {
+	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
+	    !(sc->flags & XREP_ALREADY_FIXED)) {
 		bool needs_fix;
 
 		/* Let debug users force us into the repair routines. */
 		if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
-			sc.sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+			sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 
-		needs_fix = (sc.sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
-						XFS_SCRUB_OFLAG_XCORRUPT |
-						XFS_SCRUB_OFLAG_PREEN));
+		needs_fix = (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+						 XFS_SCRUB_OFLAG_XCORRUPT |
+						 XFS_SCRUB_OFLAG_PREEN));
 		/*
 		 * If userspace asked for a repair but it wasn't necessary,
 		 * report that back to userspace.
 		 */
 		if (!needs_fix) {
-			sc.sm->sm_flags |= XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED;
+			sc->sm->sm_flags |= XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED;
 			goto out_nofix;
 		}
 
@@ -549,26 +553,28 @@ xfs_scrub_metadata(
 		 * If it's broken, userspace wants us to fix it, and we haven't
 		 * already tried to fix it, then attempt a repair.
 		 */
-		error = xrep_attempt(&sc);
+		error = xrep_attempt(sc);
 		if (error == -EAGAIN) {
 			/*
 			 * Either the repair function succeeded or it couldn't
 			 * get all the resources it needs; either way, we go
 			 * back to the beginning and call the scrub function.
 			 */
-			error = xchk_teardown(&sc, 0);
+			error = xchk_teardown(sc, 0);
 			if (error) {
 				xrep_failure(mp);
-				goto out;
+				goto out_sc;
 			}
 			goto retry_op;
 		}
 	}
 
 out_nofix:
-	xchk_postmortem(&sc);
+	xchk_postmortem(sc);
 out_teardown:
-	error = xchk_teardown(&sc, error);
+	error = xchk_teardown(sc, error);
+out_sc:
+	kmem_free(sc);
 out:
 	trace_xchk_done(XFS_I(file_inode(file)), sm, error);
 	if (error == -EFSCORRUPTED || error == -EFSBADCRC) {

