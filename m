Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ADE1292F3
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423752; cv=none; b=hnlgA0Rl/4Qmm9F42V5yZIZxxIOizsopcjl8qzfJR3w2DUQfuws4nhXV8TYcAREEyC94phPAljcNCF9jaSL5fbpSlxfIGowKcmFnQ62gTRcvq28qAqNzmoBalTiamr1cTV0u6mKDE2w8uWwC8ecRQjp1OMmUVsc0QuDAH1+nq3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423752; c=relaxed/simple;
	bh=a3jfB8fIfO0Xa5hHCNcHbhCq27f3vNxjB1wAj2w2YQY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=on9iH7riS1v/lVeeWucM5FzmVByotH1xOqLZ7V9SLxpXzA1lp6pFnlkfHq6uTMPZw/rF6O3Bg1kLJlZy1c0LxzFkkjivUALhhHGNU4QcBQxr+ZAw32OjInnY+5y0bXzeqeqtBKZbW34/0irQz3lWdT1gB0LOWOvUsec2BwD5Ec0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hh4fUg6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hh4fUg6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDEAC433C7;
	Tue, 26 Mar 2024 03:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423752;
	bh=a3jfB8fIfO0Xa5hHCNcHbhCq27f3vNxjB1wAj2w2YQY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Hh4fUg6bRNCd9zlbQBy7YgSWk99jzaL+Unf0I1uuX3wRO0B9GySbYiPAVpHU/V/88
	 eaVPL7tweqXsHfNQ433zaPemLgN25Z/u5w9BwT7M30GYvmpGy2I/QiERJMXA73Okb4
	 G+5zuA6PLsuvkbCtLGf0IspsjCcnjeThfqwhLkowbaYkJsbenzoP+LZyJIyH/JtOJz
	 27J/NrZJulZewdSIR7GZu5q5duqZzWS4+eLG5K7Dhxw649/pSDOD5qw+G95Nh4p1jE
	 mW3hb0kCINOxK6I5o09ikE7vQ9bTFFYephsi7vS2Hh255eR14KAvM7QIpFptRyyZ9I
	 v5Bw+on8OZtYw==
Date: Mon, 25 Mar 2024 20:29:11 -0700
Subject: [PATCH 003/110] xfs: convert remaining kmem_free() to kfree()
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171142131428.2215168.9319782448131767254.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: d4c75a1b40cd036a84d98e2711db9cf30eaaaf5f

The remaining callers of kmem_free() are freeing heap memory, so
we can convert them directly to kfree() and get rid of kmem_free()
altogether.

This conversion was done with:

$ for f in `git grep -l kmem_free fs/xfs`; do
> sed -i s/kmem_free/kfree/ $f
> done
$

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_ag.c            |    6 +++---
 libxfs/xfs_attr_leaf.c     |    8 ++++----
 libxfs/xfs_btree.c         |    2 +-
 libxfs/xfs_btree_staging.c |    4 ++--
 libxfs/xfs_da_btree.c      |   10 +++++-----
 libxfs/xfs_defer.c         |    4 ++--
 libxfs/xfs_dir2.c          |   18 +++++++++---------
 libxfs/xfs_dir2_block.c    |    4 ++--
 libxfs/xfs_dir2_sf.c       |    8 ++++----
 libxfs/xfs_iext_tree.c     |    8 ++++----
 libxfs/xfs_inode_fork.c    |    6 +++---
 11 files changed, 39 insertions(+), 39 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index b22be1477242..2ea8d06ca119 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -239,7 +239,7 @@ __xfs_free_perag(
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
 	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
-	kmem_free(pag);
+	kfree(pag);
 }
 
 /*
@@ -351,7 +351,7 @@ xfs_free_unused_perag_range(
 			break;
 		xfs_buf_hash_destroy(pag);
 		xfs_defer_drain_free(&pag->pag_intents_drain);
-		kmem_free(pag);
+		kfree(pag);
 	}
 }
 
@@ -451,7 +451,7 @@ xfs_initialize_perag(
 	radix_tree_delete(&mp->m_perag_tree, index);
 	spin_unlock(&mp->m_perag_lock);
 out_free_pag:
-	kmem_free(pag);
+	kfree(pag);
 out_unwind_new_pags:
 	/* unwind any prior newly initialized pags */
 	xfs_free_unused_perag_range(mp, first_initialised, agcount);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 0d7dc789ce48..fdc53451ce9c 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -920,7 +920,7 @@ xfs_attr_shortform_to_leaf(
 	}
 	error = 0;
 out:
-	kmem_free(tmpbuffer);
+	kfree(tmpbuffer);
 	return error;
 }
 
@@ -1121,7 +1121,7 @@ xfs_attr3_leaf_to_shortform(
 	error = 0;
 
 out:
-	kmem_free(tmpbuffer);
+	kfree(tmpbuffer);
 	return error;
 }
 
@@ -1567,7 +1567,7 @@ xfs_attr3_leaf_compact(
 	 */
 	xfs_trans_log_buf(trans, bp, 0, args->geo->blksize - 1);
 
-	kmem_free(tmpbuffer);
+	kfree(tmpbuffer);
 }
 
 /*
@@ -2287,7 +2287,7 @@ xfs_attr3_leaf_unbalance(
 		}
 		memcpy(save_leaf, tmp_leaf, state->args->geo->blksize);
 		savehdr = tmphdr; /* struct copy */
-		kmem_free(tmp_leaf);
+		kfree(tmp_leaf);
 	}
 
 	xfs_attr3_leaf_hdr_to_disk(state->args->geo, save_leaf, &savehdr);
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 0022bb641bee..663439ec3e3f 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -448,7 +448,7 @@ xfs_btree_del_cursor(
 	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 ||
 	       xfs_is_shutdown(cur->bc_mp) || error != 0);
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
-		kmem_free(cur->bc_ops);
+		kfree(cur->bc_ops);
 	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
 		xfs_perag_put(cur->bc_ag.pag);
 	kmem_cache_free(cur->bc_cache, cur);
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index da6e9fa8e8aa..0828cc7e38a7 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -171,7 +171,7 @@ xfs_btree_commit_afakeroot(
 
 	trace_xfs_btree_commit_afakeroot(cur);
 
-	kmem_free((void *)cur->bc_ops);
+	kfree((void *)cur->bc_ops);
 	cur->bc_ag.agbp = agbp;
 	cur->bc_ops = ops;
 	cur->bc_flags &= ~XFS_BTREE_STAGING;
@@ -254,7 +254,7 @@ xfs_btree_commit_ifakeroot(
 
 	trace_xfs_btree_commit_ifakeroot(cur);
 
-	kmem_free((void *)cur->bc_ops);
+	kfree((void *)cur->bc_ops);
 	cur->bc_ino.ifake = NULL;
 	cur->bc_ino.whichfork = whichfork;
 	cur->bc_ops = ops;
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 33ac8d13c0c5..91009944922f 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2216,7 +2216,7 @@ xfs_da_grow_inode_int(
 
 out_free_map:
 	if (mapp != &map)
-		kmem_free(mapp);
+		kfree(mapp);
 	return error;
 }
 
@@ -2555,7 +2555,7 @@ xfs_dabuf_map(
 	*nmaps = nirecs;
 out_free_irecs:
 	if (irecs != &irec)
-		kmem_free(irecs);
+		kfree(irecs);
 	return error;
 
 invalid_mapping:
@@ -2611,7 +2611,7 @@ xfs_da_get_buf(
 
 out_free:
 	if (mapp != &map)
-		kmem_free(mapp);
+		kfree(mapp);
 
 	return error;
 }
@@ -2652,7 +2652,7 @@ xfs_da_read_buf(
 	*bpp = bp;
 out_free:
 	if (mapp != &map)
-		kmem_free(mapp);
+		kfree(mapp);
 
 	return error;
 }
@@ -2683,7 +2683,7 @@ xfs_da_reada_buf(
 
 out_free:
 	if (mapp != &map)
-		kmem_free(mapp);
+		kfree(mapp);
 
 	return error;
 }
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 70489b09760f..1de3faf5ed2d 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -1032,7 +1032,7 @@ xfs_defer_ops_capture_abort(
 	for (i = 0; i < dfc->dfc_held.dr_inos; i++)
 		xfs_irele(dfc->dfc_held.dr_ip[i]);
 
-	kmem_free(dfc);
+	kfree(dfc);
 }
 
 /*
@@ -1108,7 +1108,7 @@ xfs_defer_ops_continue(
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
 	tp->t_flags |= dfc->dfc_tpflags;
 
-	kmem_free(dfc);
+	kfree(dfc);
 }
 
 /* Release the resources captured and continued during recovery. */
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 52f0461ef07f..c2f0efa06393 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -108,8 +108,8 @@ xfs_da_mount(
 	mp->m_attr_geo = kzalloc(sizeof(struct xfs_da_geometry),
 				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!mp->m_dir_geo || !mp->m_attr_geo) {
-		kmem_free(mp->m_dir_geo);
-		kmem_free(mp->m_attr_geo);
+		kfree(mp->m_dir_geo);
+		kfree(mp->m_attr_geo);
 		return -ENOMEM;
 	}
 
@@ -177,8 +177,8 @@ void
 xfs_da_unmount(
 	struct xfs_mount	*mp)
 {
-	kmem_free(mp->m_dir_geo);
-	kmem_free(mp->m_attr_geo);
+	kfree(mp->m_dir_geo);
+	kfree(mp->m_attr_geo);
 }
 
 /*
@@ -243,7 +243,7 @@ xfs_dir_init(
 	args->dp = dp;
 	args->trans = tp;
 	error = xfs_dir2_sf_create(args, pdp->i_ino);
-	kmem_free(args);
+	kfree(args);
 	return error;
 }
 
@@ -312,7 +312,7 @@ xfs_dir_createname(
 		rval = xfs_dir2_node_addname(args);
 
 out_free:
-	kmem_free(args);
+	kfree(args);
 	return rval;
 }
 
@@ -418,7 +418,7 @@ xfs_dir_lookup(
 	}
 out_free:
 	xfs_iunlock(dp, lock_mode);
-	kmem_free(args);
+	kfree(args);
 	return rval;
 }
 
@@ -476,7 +476,7 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
-	kmem_free(args);
+	kfree(args);
 	return rval;
 }
 
@@ -537,7 +537,7 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
-	kmem_free(args);
+	kfree(args);
 	return rval;
 }
 
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index b694e62198b5..aed3c14a86b9 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -1250,7 +1250,7 @@ xfs_dir2_sf_to_block(
 			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
 	}
 	/* Done with the temporary buffer */
-	kmem_free(sfp);
+	kfree(sfp);
 	/*
 	 * Sort the leaf entries by hash value.
 	 */
@@ -1265,6 +1265,6 @@ xfs_dir2_sf_to_block(
 	xfs_dir3_data_check(dp, bp);
 	return 0;
 out_free:
-	kmem_free(sfp);
+	kfree(sfp);
 	return error;
 }
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 9e0c15f9993e..aaf73cd35ca7 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -350,7 +350,7 @@ xfs_dir2_block_to_sf(
 	xfs_dir2_sf_check(args);
 out:
 	xfs_trans_log_inode(args->trans, dp, logflags);
-	kmem_free(sfp);
+	kfree(sfp);
 	return error;
 }
 
@@ -576,7 +576,7 @@ xfs_dir2_sf_addname_hard(
 		sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
 		memcpy(sfep, oldsfep, old_isize - nbytes);
 	}
-	kmem_free(buf);
+	kfree(buf);
 	dp->i_disk_size = new_isize;
 	xfs_dir2_sf_check(args);
 }
@@ -1190,7 +1190,7 @@ xfs_dir2_sf_toino4(
 	/*
 	 * Clean up the inode.
 	 */
-	kmem_free(buf);
+	kfree(buf);
 	dp->i_disk_size = newsize;
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
 }
@@ -1262,7 +1262,7 @@ xfs_dir2_sf_toino8(
 	/*
 	 * Clean up the inode.
 	 */
-	kmem_free(buf);
+	kfree(buf);
 	dp->i_disk_size = newsize;
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
 }
diff --git a/libxfs/xfs_iext_tree.c b/libxfs/xfs_iext_tree.c
index 641b53f4e034..a3bbd9157be3 100644
--- a/libxfs/xfs_iext_tree.c
+++ b/libxfs/xfs_iext_tree.c
@@ -747,7 +747,7 @@ xfs_iext_remove_node(
 again:
 	ASSERT(node->ptrs[pos]);
 	ASSERT(node->ptrs[pos] == victim);
-	kmem_free(victim);
+	kfree(victim);
 
 	nr_entries = xfs_iext_node_nr_entries(node, pos) - 1;
 	offset = node->keys[0];
@@ -793,7 +793,7 @@ xfs_iext_remove_node(
 		ASSERT(node == ifp->if_data);
 		ifp->if_data = node->ptrs[0];
 		ifp->if_height--;
-		kmem_free(node);
+		kfree(node);
 	}
 }
 
@@ -867,7 +867,7 @@ xfs_iext_free_last_leaf(
 	struct xfs_ifork	*ifp)
 {
 	ifp->if_height--;
-	kmem_free(ifp->if_data);
+	kfree(ifp->if_data);
 	ifp->if_data = NULL;
 }
 
@@ -1048,7 +1048,7 @@ xfs_iext_destroy_node(
 		}
 	}
 
-	kmem_free(node);
+	kfree(node);
 }
 
 void
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 7de346e87c10..5e0cb488635c 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -469,7 +469,7 @@ xfs_iroot_realloc(
 						     (int)new_size);
 		memcpy(np, op, new_max * (uint)sizeof(xfs_fsblock_t));
 	}
-	kmem_free(ifp->if_broot);
+	kfree(ifp->if_broot);
 	ifp->if_broot = new_broot;
 	ifp->if_broot_bytes = (int)new_size;
 	if (ifp->if_broot)
@@ -523,13 +523,13 @@ xfs_idestroy_fork(
 	struct xfs_ifork	*ifp)
 {
 	if (ifp->if_broot != NULL) {
-		kmem_free(ifp->if_broot);
+		kfree(ifp->if_broot);
 		ifp->if_broot = NULL;
 	}
 
 	switch (ifp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
-		kmem_free(ifp->if_data);
+		kfree(ifp->if_data);
 		ifp->if_data = NULL;
 		break;
 	case XFS_DINODE_FMT_EXTENTS:

