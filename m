Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9807DC04E69
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbjG0WfK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbjG0Wet (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:34:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53D03ABC
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:34:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2630661F3E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4ABC433C8;
        Thu, 27 Jul 2023 22:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690497252;
        bh=687LbGfbDretm+0EJHx4wlAxX83vSTLvNCF+qjaNB2s=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ldsitq+KLHRWAioGWCOHFYRQ6dyLrKfCrZm9lmA9ex5DCqS9IcphBJw2/l/daY+oo
         QCwJTtJlMliD3F/7sP8/1ZPEkPyjWyTZ/YcIcQWDdXjbG+j/4XKeYD5RM+FUH5anaY
         KAHqkOj8Efn2S0YmfcYP7EfT7oilwkyGdJs4bL8fm0WE3ps0nG7yAminXXWQEhlOlO
         FFvWUHpImsqv5d5LylY3FftHpRIEmBSS3+F1P7R5d3MO7KwOHMN9L6EfAxZYf3gcpf
         m9icj2NRJkYdnazrDL+kDN//VdGtf0Qwb9gKB0yosLrVixzReMPXDscetFm40URIG9
         HUattfmQ1vLcA==
Date:   Thu, 27 Jul 2023 15:34:12 -0700
Subject: [PATCH 2/5] xfs: repair inode fork block mapping data structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049626890.922742.1597460562698185085.stgit@frogsfrogsfrogs>
In-Reply-To: <169049626854.922742.12128926563525648849.stgit@frogsfrogsfrogs>
References: <169049626854.922742.12128926563525648849.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the reverse-mapping btree information to rebuild an inode block map.
Update the btree bulk loading code as necessary to support inode rooted
btrees and fix some bitrot problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                   |    1 
 fs/xfs/libxfs/xfs_bmap_btree.c    |  112 ++++-
 fs/xfs/libxfs/xfs_bmap_btree.h    |    5 
 fs/xfs/libxfs/xfs_btree_staging.c |   11 
 fs/xfs/libxfs/xfs_btree_staging.h |    2 
 fs/xfs/libxfs/xfs_iext_tree.c     |   23 +
 fs/xfs/libxfs/xfs_inode_fork.c    |    1 
 fs/xfs/libxfs/xfs_inode_fork.h    |    3 
 fs/xfs/scrub/bmap.c               |   18 +
 fs/xfs/scrub/bmap_repair.c        |  849 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h             |    6 
 fs/xfs/scrub/repair.c             |   28 +
 fs/xfs/scrub/repair.h             |    6 
 fs/xfs/scrub/scrub.c              |    4 
 fs/xfs/scrub/trace.h              |   34 +
 fs/xfs/xfs_trans.c                |   95 ++++
 fs/xfs/xfs_trans.h                |    4 
 17 files changed, 1174 insertions(+), 28 deletions(-)
 create mode 100644 fs/xfs/scrub/bmap_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0d86d75422f60..f62351d63b147 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -182,6 +182,7 @@ ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   alloc_repair.o \
+				   bmap_repair.o \
 				   ialloc_repair.o \
 				   inode_repair.o \
 				   newbt.o \
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index bf3f1b36fdd23..04e202878a9fc 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -15,6 +15,7 @@
 #include "xfs_trans.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
+#include "xfs_btree_staging.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
@@ -288,10 +289,7 @@ xfs_bmbt_get_minrecs(
 	int			level)
 {
 	if (level == cur->bc_nlevels - 1) {
-		struct xfs_ifork	*ifp;
-
-		ifp = xfs_ifork_ptr(cur->bc_ino.ip,
-				    cur->bc_ino.whichfork);
+		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
 
 		return xfs_bmbt_maxrecs(cur->bc_mp,
 					ifp->if_broot_bytes, level == 0) / 2;
@@ -306,10 +304,7 @@ xfs_bmbt_get_maxrecs(
 	int			level)
 {
 	if (level == cur->bc_nlevels - 1) {
-		struct xfs_ifork	*ifp;
-
-		ifp = xfs_ifork_ptr(cur->bc_ino.ip,
-				    cur->bc_ino.whichfork);
+		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
 
 		return xfs_bmbt_maxrecs(cur->bc_mp,
 					ifp->if_broot_bytes, level == 0);
@@ -546,20 +541,19 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 /*
  * Allocate a new bmap btree cursor.
  */
-struct xfs_btree_cur *				/* new bmap btree cursor */
-xfs_bmbt_init_cursor(
+static struct xfs_btree_cur *			/* new bmap btree cursor */
+xfs_bmbt_init_common(
 	struct xfs_mount	*mp,		/* file system mount point */
 	struct xfs_trans	*tp,		/* transaction pointer */
 	struct xfs_inode	*ip,		/* inode owning the btree */
-	int			whichfork)	/* data or attr fork */
+	int			whichfork)
 {
-	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_cur	*cur;
+
 	ASSERT(whichfork != XFS_COW_FORK);
 
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP,
 			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
-	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
 	cur->bc_ops = &xfs_bmbt_ops;
@@ -567,10 +561,30 @@ xfs_bmbt_init_cursor(
 	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	cur->bc_ino.forksize = xfs_inode_fork_size(ip, whichfork);
 	cur->bc_ino.ip = ip;
 	cur->bc_ino.allocated = 0;
 	cur->bc_ino.flags = 0;
+
+	return cur;
+}
+
+/*
+ * Allocate a new bmap btree cursor.
+ */
+struct xfs_btree_cur *				/* new bmap btree cursor */
+xfs_bmbt_init_cursor(
+	struct xfs_mount	*mp,		/* file system mount point */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_inode	*ip,		/* inode owning the btree */
+	int			whichfork)	/* data or attr fork */
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_bmbt_init_common(mp, tp, ip, whichfork);
+
+	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
+	cur->bc_ino.forksize = xfs_inode_fork_size(ip, whichfork);
 	cur->bc_ino.whichfork = whichfork;
 
 	return cur;
@@ -587,6 +601,76 @@ xfs_bmbt_block_maxrecs(
 	return blocklen / (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t));
 }
 
+/*
+ * Allocate a new bmap btree cursor for reloading an inode block mapping data
+ * structure.  Note that callers can use the staged cursor to reload extents
+ * format inode forks if they rebuild the iext tree and commit the staged
+ * cursor immediately.
+ */
+struct xfs_btree_cur *
+xfs_bmbt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
+	struct xbtree_ifakeroot	*ifake)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_btree_ops	*ops;
+
+	cur = xfs_bmbt_init_common(mp, NULL, ip, ifake->if_whichfork);
+	cur->bc_nlevels = ifake->if_levels;
+	cur->bc_ino.forksize = ifake->if_fork_size;
+	/* Don't let anyone think we're attached to the real fork yet. */
+	cur->bc_ino.whichfork = -1;
+	xfs_btree_stage_ifakeroot(cur, ifake, &ops);
+	ops->update_cursor = NULL;
+	return cur;
+}
+
+/*
+ * Swap in the new inode fork root.  Once we pass this point the newly rebuilt
+ * mappings are in place and we have to kill off any old btree blocks.
+ */
+void
+xfs_bmbt_commit_staged_btree(
+	struct xfs_btree_cur	*cur,
+	struct xfs_trans	*tp,
+	int			whichfork)
+{
+	struct xbtree_ifakeroot	*ifake = cur->bc_ino.ifake;
+	struct xfs_ifork	*ifp;
+	static const short	brootflag[2] =
+		{ XFS_ILOG_DBROOT, XFS_ILOG_ABROOT };
+	static const short	extflag[2] =
+		{ XFS_ILOG_DEXT, XFS_ILOG_AEXT };
+	int			flags = XFS_ILOG_CORE;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(whichfork != XFS_COW_FORK);
+
+	/*
+	 * Free any resources hanging off the real fork, then shallow-copy the
+	 * staging fork's contents into the real fork to transfer everything
+	 * we just built.
+	 */
+	ifp = xfs_ifork_ptr(cur->bc_ino.ip, whichfork);
+	xfs_idestroy_fork(ifp);
+	memcpy(ifp, ifake->if_fork, sizeof(struct xfs_ifork));
+
+	switch (ifp->if_format) {
+	case XFS_DINODE_FMT_EXTENTS:
+		flags |= extflag[whichfork];
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		flags |= brootflag[whichfork];
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+	xfs_trans_log_inode(tp, cur->bc_ino.ip, flags);
+	xfs_btree_commit_ifakeroot(cur, tp, whichfork, &xfs_bmbt_ops);
+}
+
 /*
  * Calculate number of records in a bmap btree block.
  */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 3e7a40a83835c..151b8491f60ee 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -11,6 +11,7 @@ struct xfs_btree_block;
 struct xfs_mount;
 struct xfs_inode;
 struct xfs_trans;
+struct xbtree_ifakeroot;
 
 /*
  * Btree block header size depends on a superblock flag.
@@ -106,6 +107,10 @@ extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
 
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
+struct xfs_btree_cur *xfs_bmbt_stage_cursor(struct xfs_mount *mp,
+		struct xfs_inode *ip, struct xbtree_ifakeroot *ifake);
+void xfs_bmbt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_trans *tp, int whichfork);
 
 extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 6fd6ea8e6fbd7..4cdf7976b7bf5 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -399,7 +399,7 @@ xfs_btree_bload_prep_block(
 		ASSERT(*bpp == NULL);
 
 		/* Allocate a new incore btree root block. */
-		new_size = bbl->iroot_size(cur, nr_this_block, priv);
+		new_size = bbl->iroot_size(cur, level, nr_this_block, priv);
 		ifp->if_broot = kmem_zalloc(new_size, 0);
 		ifp->if_broot_bytes = (int)new_size;
 
@@ -585,7 +585,14 @@ xfs_btree_bload_level_geometry(
 	unsigned int		desired_npb;
 	unsigned int		maxnr;
 
-	maxnr = cur->bc_ops->get_maxrecs(cur, level);
+	/*
+	 * Compute the absolute maximum number of records that we can store in
+	 * the ondisk block or inode root.
+	 */
+	if (cur->bc_ops->get_dmaxrecs)
+		maxnr = cur->bc_ops->get_dmaxrecs(cur, level);
+	else
+		maxnr = cur->bc_ops->get_maxrecs(cur, level);
 
 	/*
 	 * Compute the number of blocks we need to fill each block with the
diff --git a/fs/xfs/libxfs/xfs_btree_staging.h b/fs/xfs/libxfs/xfs_btree_staging.h
index d2eaf4fdc6032..439d3490c878a 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.h
+++ b/fs/xfs/libxfs/xfs_btree_staging.h
@@ -56,7 +56,7 @@ typedef int (*xfs_btree_bload_get_records_fn)(struct xfs_btree_cur *cur,
 typedef int (*xfs_btree_bload_claim_block_fn)(struct xfs_btree_cur *cur,
 		union xfs_btree_ptr *ptr, void *priv);
 typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
-		unsigned int nr_this_level, void *priv);
+		unsigned int level, unsigned int nr_this_level, void *priv);
 
 struct xfs_btree_bload {
 	/*
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 773cf43494286..d062794cc7957 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -622,13 +622,11 @@ static inline void xfs_iext_inc_seq(struct xfs_ifork *ifp)
 }
 
 void
-xfs_iext_insert(
-	struct xfs_inode	*ip,
+xfs_iext_insert_raw(
+	struct xfs_ifork	*ifp,
 	struct xfs_iext_cursor	*cur,
-	struct xfs_bmbt_irec	*irec,
-	int			state)
+	struct xfs_bmbt_irec	*irec)
 {
-	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
 	xfs_fileoff_t		offset = irec->br_startoff;
 	struct xfs_iext_leaf	*new = NULL;
 	int			nr_entries, i;
@@ -662,12 +660,23 @@ xfs_iext_insert(
 	xfs_iext_set(cur_rec(cur), irec);
 	ifp->if_bytes += sizeof(struct xfs_iext_rec);
 
-	trace_xfs_iext_insert(ip, cur, state, _RET_IP_);
-
 	if (new)
 		xfs_iext_insert_node(ifp, xfs_iext_leaf_key(new, 0), new, 2);
 }
 
+void
+xfs_iext_insert(
+	struct xfs_inode	*ip,
+	struct xfs_iext_cursor	*cur,
+	struct xfs_bmbt_irec	*irec,
+	int			state)
+{
+	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
+
+	xfs_iext_insert_raw(ifp, cur, irec);
+	trace_xfs_iext_insert(ip, cur, state, _RET_IP_);
+}
+
 static struct xfs_iext_node *
 xfs_iext_rebalance_node(
 	struct xfs_iext_node	*parent,
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 5a2e7ddfa76d6..2390884e0075b 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -520,6 +520,7 @@ xfs_idata_realloc(
 	ifp->if_bytes = new_size;
 }
 
+/* Free all memory and reset a fork back to its initial state. */
 void
 xfs_idestroy_fork(
 	struct xfs_ifork	*ifp)
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 96d307784c85b..535be5c036899 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -180,6 +180,9 @@ void		xfs_init_local_fork(struct xfs_inode *ip, int whichfork,
 				const void *data, int64_t size);
 
 xfs_extnum_t	xfs_iext_count(struct xfs_ifork *ifp);
+void		xfs_iext_insert_raw(struct xfs_ifork *ifp,
+			struct xfs_iext_cursor *cur,
+			struct xfs_bmbt_irec *irec);
 void		xfs_iext_insert(struct xfs_inode *, struct xfs_iext_cursor *cur,
 			struct xfs_bmbt_irec *, int);
 void		xfs_iext_remove(struct xfs_inode *, struct xfs_iext_cursor *,
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 76aa40fef84ad..db94a5353e8f3 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -48,9 +48,18 @@ xchk_setup_inode_bmap(
 	if (S_ISREG(VFS_I(sc->ip)->i_mode) &&
 	    sc->sm->sm_type != XFS_SCRUB_TYPE_BMBTA) {
 		struct address_space	*mapping = VFS_I(sc->ip)->i_mapping;
+		bool			is_repair = xchk_could_repair(sc);
 
 		xchk_ilock(sc, XFS_MMAPLOCK_EXCL);
 
+		/* Break all our leases, we're going to mess with things. */
+		if (is_repair) {
+			error = xfs_break_layouts(VFS_I(sc->ip),
+					&sc->ilock_flags, BREAK_WRITE);
+			if (error)
+				goto out;
+		}
+
 		inode_dio_wait(VFS_I(sc->ip));
 
 		/*
@@ -71,6 +80,15 @@ xchk_setup_inode_bmap(
 			error = filemap_fdatawait_keep_errors(mapping);
 		if (error && (error != -ENOSPC && error != -EIO))
 			goto out;
+
+		/* Drop the page cache if we're repairing block mappings. */
+		if (is_repair) {
+			error = invalidate_inode_pages2(
+					VFS_I(sc->ip)->i_mapping);
+			if (error)
+				goto out;
+		}
+
 	}
 
 	/* Got the inode, lock it and we're ready to go. */
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
new file mode 100644
index 0000000000000..52c90a9d09f6a
--- /dev/null
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -0,0 +1,849 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_btree_staging.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_inode_fork.h"
+#include "xfs_alloc.h"
+#include "xfs_rtalloc.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_quota.h"
+#include "xfs_ialloc.h"
+#include "xfs_ag.h"
+#include "xfs_reflink.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/newbt.h"
+#include "scrub/reap.h"
+
+/*
+ * Inode Fork Block Mapping (BMBT) Repair
+ * ======================================
+ *
+ * Gather all the rmap records for the inode and fork we're fixing, reset the
+ * incore fork, then recreate the btree.
+ */
+struct xrep_bmap {
+	/* Old bmbt blocks */
+	struct xfsb_bitmap	old_bmbt_blocks;
+
+	/* New fork. */
+	struct xrep_newbt	new_bmapbt;
+
+	/* List of new bmap records. */
+	struct xfarray		*bmap_records;
+
+	struct xfs_scrub	*sc;
+
+	/* How many blocks did we find allocated to this file? */
+	xfs_rfsblock_t		nblocks;
+
+	/* How many bmbt blocks did we find for this fork? */
+	xfs_rfsblock_t		old_bmbt_block_count;
+
+	/* get_records()'s position in the free space record array. */
+	xfarray_idx_t		array_cur;
+
+	/* How many real (non-hole, non-delalloc) mappings do we have? */
+	uint64_t		real_mappings;
+
+	/* Which fork are we fixing? */
+	int			whichfork;
+
+	/* Are there shared extents? */
+	bool			shared_extents;
+};
+
+/* Is this space extent shared?  Flag the inode if it is. */
+STATIC int
+xrep_bmap_discover_shared(
+	struct xrep_bmap	*rb,
+	xfs_fsblock_t		startblock,
+	xfs_filblks_t		blockcount,
+	bool			unwritten)
+{
+	struct xfs_scrub	*sc = rb->sc;
+	xfs_agblock_t		agbno;
+	xfs_agblock_t		fbno;
+	xfs_extlen_t		flen;
+	int			error;
+
+	/*
+	 * Only investigate if we need to set the shared extents flag if we are
+	 * adding a written extent mapping to the data fork of a regular file
+	 * on reflink filesystem.
+	 */
+	if (rb->shared_extents)
+		return 0;
+	if (unwritten)
+		return 0;
+	if (rb->whichfork != XFS_DATA_FORK)
+		return 0;
+	if (!S_ISREG(VFS_I(sc->ip)->i_mode))
+		return 0;
+	if (!xfs_has_reflink(sc->mp))
+		return 0;
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		return 0;
+
+	agbno = XFS_FSB_TO_AGBNO(sc->mp, startblock);
+	error = xfs_refcount_find_shared(sc->sa.refc_cur, agbno, blockcount,
+			&fbno, &flen, false);
+	if (error)
+		return error;
+
+	if (fbno != NULLAGBLOCK)
+		rb->shared_extents = true;
+
+	return 0;
+}
+
+/* Remember this reverse-mapping as a series of bmap records. */
+STATIC int
+xrep_bmap_from_rmap(
+	struct xrep_bmap	*rb,
+	xfs_fileoff_t		startoff,
+	xfs_fsblock_t		startblock,
+	xfs_filblks_t		blockcount,
+	bool			unwritten)
+{
+	struct xfs_bmbt_irec	irec = {
+		.br_startoff	= startoff,
+		.br_startblock	= startblock,
+		.br_state	= unwritten ? XFS_EXT_UNWRITTEN : XFS_EXT_NORM,
+	};
+	struct xfs_bmbt_rec	rbe;
+	struct xfs_scrub	*sc = rb->sc;
+	int			error = 0;
+
+	/*
+	 * If we're repairing the data fork of a non-reflinked regular file on
+	 * a reflink filesystem, we need to figure out if this space extent is
+	 * shared.
+	 */
+	error = xrep_bmap_discover_shared(rb, startblock, blockcount,
+			unwritten);
+	if (error)
+		return error;
+
+	do {
+		xfs_failaddr_t	fa;
+
+		irec.br_blockcount = min_t(xfs_filblks_t, blockcount,
+				XFS_MAX_BMBT_EXTLEN);
+
+		fa = xfs_bmap_validate_extent(sc->ip, rb->whichfork, &irec);
+		if (fa)
+			return -EFSCORRUPTED;
+
+		xfs_bmbt_disk_set_all(&rbe, &irec);
+
+		trace_xrep_bmap_found(sc->ip, rb->whichfork, &irec);
+
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		error = xfarray_append(rb->bmap_records, &rbe);
+		if (error)
+			return error;
+
+		rb->real_mappings++;
+
+		irec.br_startblock += irec.br_blockcount;
+		irec.br_startoff += irec.br_blockcount;
+		blockcount -= irec.br_blockcount;
+	} while (blockcount > 0);
+
+	return 0;
+}
+
+/* Check for any obvious errors or conflicts in the file mapping. */
+STATIC int
+xrep_bmap_check_fork_rmap(
+	struct xrep_bmap		*rb,
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec)
+{
+	struct xfs_scrub		*sc = rb->sc;
+	enum xbtree_recpacking		outcome;
+	int				error;
+
+	/*
+	 * Data extents for rt files are never stored on the data device, but
+	 * everything else (xattrs, bmbt blocks) can be.
+	 */
+	if (XFS_IS_REALTIME_INODE(sc->ip) &&
+	    !(rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK)))
+		return -EFSCORRUPTED;
+
+	/* Check that this is within the AG. */
+	if (!xfs_verify_agbext(cur->bc_ag.pag, rec->rm_startblock,
+				rec->rm_blockcount))
+		return -EFSCORRUPTED;
+
+	/* Check the file offset range. */
+	if (!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK) &&
+	    !xfs_verify_fileext(sc->mp, rec->rm_offset, rec->rm_blockcount))
+		return -EFSCORRUPTED;
+
+	/* No contradictory flags. */
+	if ((rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK)) &&
+	    (rec->rm_flags & XFS_RMAP_UNWRITTEN))
+		return -EFSCORRUPTED;
+
+	/* Make sure this isn't free space. */
+	error = xfs_alloc_has_records(sc->sa.bno_cur, rec->rm_startblock,
+			rec->rm_blockcount, &outcome);
+	if (error)
+		return error;
+	if (outcome != XBTREE_RECPACKING_EMPTY)
+		return -EFSCORRUPTED;
+
+	/* Must not be an inode chunk. */
+	error = xfs_ialloc_has_inodes_at_extent(sc->sa.ino_cur,
+			rec->rm_startblock, rec->rm_blockcount, &outcome);
+	if (error)
+		return error;
+	if (outcome != XBTREE_RECPACKING_EMPTY)
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
+/* Record extents that belong to this inode's fork. */
+STATIC int
+xrep_bmap_walk_rmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_bmap		*rb = priv;
+	struct xfs_mount		*mp = cur->bc_mp;
+	xfs_fsblock_t			fsbno;
+	int				error = 0;
+
+	if (xchk_should_terminate(rb->sc, &error))
+		return error;
+
+	if (rec->rm_owner != rb->sc->ip->i_ino)
+		return 0;
+
+	error = xrep_bmap_check_fork_rmap(rb, cur, rec);
+	if (error)
+		return error;
+
+	/*
+	 * Record all blocks allocated to this file even if the extent isn't
+	 * for the fork we're rebuilding so that we can reset di_nblocks later.
+	 */
+	rb->nblocks += rec->rm_blockcount;
+
+	/* If this rmap isn't for the fork we want, we're done. */
+	if (rb->whichfork == XFS_DATA_FORK &&
+	    (rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+	if (rb->whichfork == XFS_ATTR_FORK &&
+	    !(rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+
+	fsbno = XFS_AGB_TO_FSB(mp, cur->bc_ag.pag->pag_agno,
+			rec->rm_startblock);
+
+	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK) {
+		rb->old_bmbt_block_count += rec->rm_blockcount;
+		return xfsb_bitmap_set(&rb->old_bmbt_blocks, fsbno,
+				rec->rm_blockcount);
+	}
+
+	return xrep_bmap_from_rmap(rb, rec->rm_offset, fsbno,
+			rec->rm_blockcount,
+			rec->rm_flags & XFS_RMAP_UNWRITTEN);
+}
+
+/*
+ * Compare two block mapping records.  We want to sort in order of increasing
+ * file offset.
+ */
+static int
+xrep_bmap_extent_cmp(
+	const void			*a,
+	const void			*b)
+{
+	xfs_fileoff_t			ao;
+	xfs_fileoff_t			bo;
+
+	ao = xfs_bmbt_disk_get_startoff((struct xfs_bmbt_rec *)a);
+	bo = xfs_bmbt_disk_get_startoff((struct xfs_bmbt_rec *)b);
+
+	if (ao > bo)
+		return 1;
+	else if (ao < bo)
+		return -1;
+	return 0;
+}
+
+/*
+ * Sort the bmap extents by fork offset or else the records will be in the
+ * wrong order.  Ensure there are no overlaps in the file offset ranges.
+ */
+STATIC int
+xrep_bmap_sort_records(
+	struct xrep_bmap	*rb)
+{
+	struct xfs_bmbt_irec	irec;
+	xfs_fileoff_t		next_off = 0;
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	error = xfarray_sort(rb->bmap_records, xrep_bmap_extent_cmp,
+			XFARRAY_SORT_KILLABLE);
+	if (error)
+		return error;
+
+	foreach_xfarray_idx(rb->bmap_records, array_cur) {
+		struct xfs_bmbt_rec	rec;
+
+		if (xchk_should_terminate(rb->sc, &error))
+			return error;
+
+		error = xfarray_load(rb->bmap_records, array_cur, &rec);
+		if (error)
+			return error;
+
+		xfs_bmbt_disk_get_all(&rec, &irec);
+
+		if (irec.br_startoff < next_off)
+			return -EFSCORRUPTED;
+
+		next_off = irec.br_startoff + irec.br_blockcount;
+	}
+
+	return 0;
+}
+
+/* Scan one AG for reverse mappings that we can turn into extent maps. */
+STATIC int
+xrep_bmap_scan_ag(
+	struct xrep_bmap	*rb,
+	struct xfs_perag	*pag)
+{
+	struct xfs_scrub	*sc = rb->sc;
+	int			error;
+
+	error = xrep_ag_init(sc, pag, &sc->sa);
+	if (error)
+		return error;
+
+	error = xfs_rmap_query_all(sc->sa.rmap_cur, xrep_bmap_walk_rmap, rb);
+	xchk_ag_free(sc, &sc->sa);
+	return error;
+}
+
+/* Find the delalloc extents from the old incore extent tree. */
+STATIC int
+xrep_bmap_find_delalloc(
+	struct xrep_bmap	*rb)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_rec	rbe;
+	struct xfs_inode	*ip = rb->sc->ip;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, rb->whichfork);
+	int			error = 0;
+
+	/*
+	 * Skip this scan if we don't expect to find delayed allocation
+	 * reservations in this fork.
+	 */
+	if (rb->whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0)
+		return 0;
+
+	for_each_xfs_iext(ifp, &icur, &irec) {
+		if (!isnullstartblock(irec.br_startblock))
+			continue;
+
+		xfs_bmbt_disk_set_all(&rbe, &irec);
+
+		trace_xrep_bmap_found(ip, rb->whichfork, &irec);
+
+		if (xchk_should_terminate(rb->sc, &error))
+			return error;
+
+		error = xfarray_append(rb->bmap_records, &rbe);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/*
+ * Collect block mappings for this fork of this inode and decide if we have
+ * enough space to rebuild.  Caller is responsible for cleaning up the list if
+ * anything goes wrong.
+ */
+STATIC int
+xrep_bmap_find_mappings(
+	struct xrep_bmap	*rb)
+{
+	struct xfs_scrub	*sc = rb->sc;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	int			error = 0;
+
+	/* Iterate the rmaps for extents. */
+	for_each_perag(sc->mp, agno, pag) {
+		error = xrep_bmap_scan_ag(rb, pag);
+		if (error) {
+			xfs_perag_rele(pag);
+			return error;
+		}
+	}
+
+	return xrep_bmap_find_delalloc(rb);
+}
+
+/* Retrieve real extent mappings for bulk loading the bmap btree. */
+STATIC int
+xrep_bmap_get_records(
+	struct xfs_btree_cur	*cur,
+	unsigned int		idx,
+	struct xfs_btree_block	*block,
+	unsigned int		nr_wanted,
+	void			*priv)
+{
+	struct xfs_bmbt_rec	rec;
+	struct xfs_bmbt_irec	*irec = &cur->bc_rec.b;
+	struct xrep_bmap	*rb = priv;
+	union xfs_btree_rec	*block_rec;
+	unsigned int		loaded;
+	int			error;
+
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		do {
+			error = xfarray_load(rb->bmap_records, rb->array_cur++,
+					&rec);
+			if (error)
+				return error;
+
+			xfs_bmbt_disk_get_all(&rec, irec);
+		} while (isnullstartblock(irec->br_startblock));
+
+		block_rec = xfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	}
+
+	return loaded;
+}
+
+/* Feed one of the new btree blocks to the bulk loader. */
+STATIC int
+xrep_bmap_claim_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_bmap        *rb = priv;
+	int			error;
+
+	error = xrep_newbt_relog_autoreap(&rb->new_bmapbt);
+	if (error)
+		return error;
+
+	return xrep_newbt_claim_block(cur, &rb->new_bmapbt, ptr);
+}
+
+/* Figure out how much space we need to create the incore btree root block. */
+STATIC size_t
+xrep_bmap_iroot_size(
+	struct xfs_btree_cur	*cur,
+	unsigned int		level,
+	unsigned int		nr_this_level,
+	void			*priv)
+{
+	ASSERT(level > 0);
+
+	return XFS_BMAP_BROOT_SPACE_CALC(cur->bc_mp, nr_this_level);
+}
+
+/* Update the inode counters. */
+STATIC int
+xrep_bmap_reset_counters(
+	struct xrep_bmap	*rb)
+{
+	struct xfs_scrub	*sc = rb->sc;
+	struct xbtree_ifakeroot	*ifake = &rb->new_bmapbt.ifake;
+	int64_t			delta;
+
+	if (rb->shared_extents)
+		sc->ip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
+
+	/*
+	 * Update the inode block counts to reflect the extents we found in the
+	 * rmapbt.
+	 */
+	delta = ifake->if_blocks - rb->old_bmbt_block_count;
+	sc->ip->i_nblocks = rb->nblocks + delta;
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+
+	/*
+	 * Adjust the quota counts by the difference in size between the old
+	 * and new bmbt.
+	 */
+	xfs_trans_mod_dquot_byino(sc->tp, sc->ip, XFS_TRANS_DQ_BCOUNT, delta);
+	return 0;
+}
+
+/*
+ * Create a new iext tree and load it with block mappings.  If the inode is
+ * in extents format, that's all we need to do to commit the new mappings.
+ * If it is in btree format, this takes care of preloading the incore tree.
+ */
+STATIC int
+xrep_bmap_extents_load(
+	struct xrep_bmap	*rb)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	irec;
+	struct xfs_ifork	*ifp = rb->new_bmapbt.ifake.if_fork;
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	ASSERT(ifp->if_bytes == 0);
+
+	/* Add all the mappings (incl. delalloc) to the incore extent tree. */
+	xfs_iext_first(ifp, &icur);
+	foreach_xfarray_idx(rb->bmap_records, array_cur) {
+		struct xfs_bmbt_rec	rec;
+
+		error = xfarray_load(rb->bmap_records, array_cur, &rec);
+		if (error)
+			return error;
+
+		xfs_bmbt_disk_get_all(&rec, &irec);
+
+		xfs_iext_insert_raw(ifp, &icur, &irec);
+		if (!isnullstartblock(irec.br_startblock))
+			ifp->if_nextents++;
+
+		xfs_iext_next(ifp, &icur);
+	}
+
+	return xrep_ino_ensure_extent_count(rb->sc, rb->whichfork,
+			ifp->if_nextents);
+}
+
+/*
+ * Reserve new btree blocks, bulk load the bmap records into the ondisk btree,
+ * and load the incore extent tree.
+ */
+STATIC int
+xrep_bmap_btree_load(
+	struct xrep_bmap	*rb,
+	struct xfs_btree_cur	*bmap_cur)
+{
+	struct xfs_scrub	*sc = rb->sc;
+	int			error;
+
+	/* Compute how many blocks we'll need. */
+	error = xfs_btree_bload_compute_geometry(bmap_cur,
+			&rb->new_bmapbt.bload, rb->real_mappings);
+	if (error)
+		return error;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	/*
+	 * Guess how many blocks we're going to need to rebuild an entire bmap
+	 * from the number of extents we found, and pump up our transaction to
+	 * have sufficient block reservation.  We're allowed to exceed file
+	 * quota to repair inconsistent metadata.
+	 */
+	error = xfs_trans_reserve_more_inode(sc->tp, sc->ip,
+			rb->new_bmapbt.bload.nr_blocks, 0, true);
+	if (error)
+		return error;
+
+	/* Reserve the space we'll need for the new btree. */
+	error = xrep_newbt_alloc_blocks(&rb->new_bmapbt,
+			rb->new_bmapbt.bload.nr_blocks);
+	if (error)
+		return error;
+
+	/* Add all observed bmap records. */
+	rb->array_cur = XFARRAY_CURSOR_INIT;
+	error = xfs_btree_bload(bmap_cur, &rb->new_bmapbt.bload, rb);
+	if (error)
+		return error;
+
+	/*
+	 * Load the new bmap records into the new incore extent tree to
+	 * preserve delalloc reservations for regular files.  The directory
+	 * code loads the extent tree during xfs_dir_open and assumes
+	 * thereafter that it remains loaded, so we must not violate that
+	 * assumption.
+	 */
+	return xrep_bmap_extents_load(rb);
+}
+
+/*
+ * Use the collected bmap information to stage a new bmap fork.  If this is
+ * successful we'll return with the new fork information logged to the repair
+ * transaction but not yet committed.  The caller must ensure that the inode
+ * is joined to the transaction; the inode will be joined to a clean
+ * transaction when the function returns.
+ */
+STATIC int
+xrep_bmap_build_new_fork(
+	struct xrep_bmap	*rb)
+{
+	struct xfs_owner_info	oinfo;
+	struct xfs_scrub	*sc = rb->sc;
+	struct xfs_btree_cur	*bmap_cur;
+	struct xbtree_ifakeroot	*ifake = &rb->new_bmapbt.ifake;
+	int			error;
+
+	error = xrep_bmap_sort_records(rb);
+	if (error)
+		return error;
+
+	/*
+	 * Prepare to construct the new fork by initializing the new btree
+	 * structure and creating a fake ifork in the ifakeroot structure.
+	 */
+	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, rb->whichfork);
+	error = xrep_newbt_init_inode(&rb->new_bmapbt, sc, rb->whichfork,
+			&oinfo);
+	if (error)
+		return error;
+
+	rb->new_bmapbt.bload.get_records = xrep_bmap_get_records;
+	rb->new_bmapbt.bload.claim_block = xrep_bmap_claim_block;
+	rb->new_bmapbt.bload.iroot_size = xrep_bmap_iroot_size;
+	bmap_cur = xfs_bmbt_stage_cursor(sc->mp, sc->ip, ifake);
+
+	/*
+	 * Figure out the size and format of the new fork, then fill it with
+	 * all the bmap records we've found.  Join the inode to the transaction
+	 * so that we can roll the transaction while holding the inode locked.
+	 */
+	if (rb->real_mappings <= XFS_IFORK_MAXEXT(sc->ip, rb->whichfork)) {
+		ifake->if_fork->if_format = XFS_DINODE_FMT_EXTENTS;
+		error = xrep_bmap_extents_load(rb);
+	} else {
+		ifake->if_fork->if_format = XFS_DINODE_FMT_BTREE;
+		error = xrep_bmap_btree_load(rb, bmap_cur);
+	}
+	if (error)
+		goto err_cur;
+
+	/*
+	 * Install the new fork in the inode.  After this point the old mapping
+	 * data are no longer accessible and the new tree is live.  We delete
+	 * the cursor immediately after committing the staged root because the
+	 * staged fork might be in extents format.
+	 */
+	xfs_bmbt_commit_staged_btree(bmap_cur, sc->tp, rb->whichfork);
+	xfs_btree_del_cursor(bmap_cur, 0);
+
+	/* Reset the inode counters now that we've changed the fork. */
+	error = xrep_bmap_reset_counters(rb);
+	if (error)
+		goto err_newbt;
+
+	/* Dispose of any unused blocks and the accounting information. */
+	error = xrep_newbt_commit(&rb->new_bmapbt);
+	if (error)
+		return error;
+
+	return xrep_roll_trans(sc);
+
+err_cur:
+	if (bmap_cur)
+		xfs_btree_del_cursor(bmap_cur, error);
+err_newbt:
+	xrep_newbt_cancel(&rb->new_bmapbt);
+	return error;
+}
+
+/*
+ * Now that we've logged the new inode btree, invalidate all of the old blocks
+ * and free them, if there were any.
+ */
+STATIC int
+xrep_bmap_remove_old_tree(
+	struct xrep_bmap	*rb)
+{
+	struct xfs_scrub	*sc = rb->sc;
+	struct xfs_owner_info	oinfo;
+
+	/* Free the old bmbt blocks if they're not in use. */
+	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, rb->whichfork);
+	return xrep_reap_fsblocks(sc, &rb->old_bmbt_blocks, &oinfo);
+}
+
+/* Check for garbage inputs.  Returns -ECANCELED if there's nothing to do. */
+STATIC int
+xrep_bmap_check_inputs(
+	struct xfs_scrub	*sc,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, whichfork);
+
+	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
+
+	if (!xfs_has_rmapbt(sc->mp))
+		return -EOPNOTSUPP;
+
+	/* No fork means nothing to rebuild. */
+	if (!ifp)
+		return -ECANCELED;
+
+	/*
+	 * We only know how to repair extent mappings, which is to say that we
+	 * only support extents and btree fork format.  Repairs to a local
+	 * format fork require a higher level repair function, so we do not
+	 * have any work to do here.
+	 */
+	switch (ifp->if_format) {
+	case XFS_DINODE_FMT_DEV:
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_UUID:
+		return -ECANCELED;
+	case XFS_DINODE_FMT_EXTENTS:
+	case XFS_DINODE_FMT_BTREE:
+		break;
+	default:
+		return -EFSCORRUPTED;
+	}
+
+	if (whichfork == XFS_ATTR_FORK)
+		return 0;
+
+	/* Only files, symlinks, and directories get to have data forks. */
+	switch (VFS_I(sc->ip)->i_mode & S_IFMT) {
+	case S_IFREG:
+	case S_IFDIR:
+	case S_IFLNK:
+		/* ok */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Don't know how to rebuild realtime data forks. */
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+/* Repair an inode fork. */
+STATIC int
+xrep_bmap(
+	struct xfs_scrub	*sc,
+	int			whichfork)
+{
+	struct xrep_bmap	*rb;
+	char			*descr;
+	unsigned int		max_bmbt_recs;
+	bool			large_extcount;
+	int			error = 0;
+
+	error = xrep_bmap_check_inputs(sc, whichfork);
+	if (error == -ECANCELED)
+		return 0;
+	if (error)
+		return error;
+
+	rb = kzalloc(sizeof(struct xrep_bmap), XCHK_GFP_FLAGS);
+	if (!rb)
+		return -ENOMEM;
+	rb->sc = sc;
+	rb->whichfork = whichfork;
+
+	/*
+	 * No need to waste time scanning for shared extents if the inode is
+	 * already marked.
+	 */
+	if (whichfork == XFS_DATA_FORK && xfs_is_reflink_inode(sc->ip))
+		rb->shared_extents = true;
+
+	/* Set up enough storage to handle the max records for this fork. */
+	large_extcount = xfs_has_large_extent_counts(sc->mp);
+	max_bmbt_recs = xfs_iext_max_nextents(large_extcount, whichfork);
+	descr = xchk_xfile_ino_descr(sc, "%s fork mapping records",
+			whichfork == XFS_DATA_FORK ? "data" : "attr");
+	error = xfarray_create(descr, max_bmbt_recs,
+			sizeof(struct xfs_bmbt_rec), &rb->bmap_records);
+	kfree(descr);
+	if (error)
+		goto out_rb;
+
+	/* Collect all reverse mappings for this fork's extents. */
+	xfsb_bitmap_init(&rb->old_bmbt_blocks);
+	error = xrep_bmap_find_mappings(rb);
+	if (error)
+		goto out_bitmap;
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/* Rebuild the bmap information. */
+	error = xrep_bmap_build_new_fork(rb);
+	if (error)
+		goto out_bitmap;
+
+	/* Kill the old tree. */
+	error = xrep_bmap_remove_old_tree(rb);
+
+out_bitmap:
+	xfsb_bitmap_destroy(&rb->old_bmbt_blocks);
+	xfarray_destroy(rb->bmap_records);
+out_rb:
+	kfree(rb);
+	return error;
+}
+
+/* Repair an inode's data fork. */
+int
+xrep_bmap_data(
+	struct xfs_scrub	*sc)
+{
+	return xrep_bmap(sc, XFS_DATA_FORK);
+}
+
+/* Repair an inode's attr fork. */
+int
+xrep_bmap_attr(
+	struct xfs_scrub	*sc)
+{
+	return xrep_bmap(sc, XFS_ATTR_FORK);
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 1f04e85be7a9b..26bc385682c6f 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -214,7 +214,11 @@ int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 			(sc)->mp->m_super->s_id, \
 			(sc)->sa.pag ? (sc)->sa.pag->pag_agno : (sc)->sm->sm_agno, \
 			##__VA_ARGS__)
-
+#define xchk_xfile_ino_descr(sc, fmt, ...) \
+	kasprintf(XCHK_GFP_FLAGS, "XFS (%s): inode 0x%llx " fmt, \
+			(sc)->mp->m_super->s_id, \
+			(sc)->ip ? (sc)->ip->i_ino : (sc)->sm->sm_ino, \
+			##__VA_ARGS__)
 
 /*
  * Setting up a hook to wait for intents to drain is costly -- we have to take
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index e2b90cabed6dd..9cb5ee0b1bd66 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -880,6 +880,34 @@ xrep_reinit_pagi(
 	return 0;
 }
 
+/*
+ * Given an active reference to a perag structure, load AG headers and cursors.
+ * This should only be called to scan an AG while repairing file-based metadata.
+ */
+int
+xrep_ag_init(
+	struct xfs_scrub	*sc,
+	struct xfs_perag	*pag,
+	struct xchk_ag		*sa)
+{
+	int			error;
+
+	ASSERT(!sa->pag);
+
+	error = xfs_ialloc_read_agi(pag, sc->tp, &sa->agi_bp);
+	if (error)
+		return error;
+
+	error = xfs_alloc_read_agf(pag, sc->tp, 0, &sa->agf_bp);
+	if (error)
+		return error;
+
+	/* Grab our own passive reference from the caller's ref. */
+	sa->pag = xfs_perag_hold(pag);
+	xrep_ag_btcur_init(sc, sa);
+	return 0;
+}
+
 /* Reinitialize the per-AG block reservation for the AG we just fixed. */
 int
 xrep_reset_perag_resv(
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 9f0b69f22bd2b..6a960adcbf705 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -81,6 +81,8 @@ struct xfs_imap;
 int xrep_setup_inode(struct xfs_scrub *sc, struct xfs_imap *imap);
 
 void xrep_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
+int xrep_ag_init(struct xfs_scrub *sc, struct xfs_perag *pag,
+		struct xchk_ag *sa);
 
 /* Metadata revalidators */
 
@@ -98,6 +100,8 @@ int xrep_allocbt(struct xfs_scrub *sc);
 int xrep_iallocbt(struct xfs_scrub *sc);
 int xrep_refcountbt(struct xfs_scrub *sc);
 int xrep_inode(struct xfs_scrub *sc);
+int xrep_bmap_data(struct xfs_scrub *sc);
+int xrep_bmap_attr(struct xfs_scrub *sc);
 
 int xrep_reinit_pagf(struct xfs_scrub *sc);
 int xrep_reinit_pagi(struct xfs_scrub *sc);
@@ -157,6 +161,8 @@ xrep_setup_nothing(
 #define xrep_iallocbt			xrep_notsupported
 #define xrep_refcountbt			xrep_notsupported
 #define xrep_inode			xrep_notsupported
+#define xrep_bmap_data			xrep_notsupported
+#define xrep_bmap_attr			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index e502174202fba..d01f59706ad79 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -288,13 +288,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_inode_bmap,
 		.scrub	= xchk_bmap_data,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_bmap_data,
 	},
 	[XFS_SCRUB_TYPE_BMBTA] = {	/* inode attr fork */
 		.type	= ST_INODE,
 		.setup	= xchk_setup_inode_bmap,
 		.scrub	= xchk_bmap_attr,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_bmap_attr,
 	},
 	[XFS_SCRUB_TYPE_BMBTC] = {	/* inode CoW fork */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index e427b7fd2a27d..b9f497385f700 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1148,7 +1148,7 @@ DEFINE_EVENT(xrep_rmap_class, name, \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
 DEFINE_REPAIR_RMAP_EVENT(xrep_ibt_walk_rmap);
 DEFINE_REPAIR_RMAP_EVENT(xrep_rmap_extent_fn);
-DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_extent_fn);
+DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_walk_rmap);
 
 TRACE_EVENT(xrep_abt_found,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
@@ -1233,6 +1233,38 @@ TRACE_EVENT(xrep_refc_found,
 		  __entry->refcount)
 )
 
+TRACE_EVENT(xrep_bmap_found,
+	TP_PROTO(struct xfs_inode *ip, int whichfork,
+		 struct xfs_bmbt_irec *irec),
+	TP_ARGS(ip, whichfork, irec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, whichfork)
+		__field(xfs_fileoff_t, lblk)
+		__field(xfs_filblks_t, len)
+		__field(xfs_fsblock_t, pblk)
+		__field(int, state)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->whichfork = whichfork;
+		__entry->lblk = irec->br_startoff;
+		__entry->len = irec->br_blockcount;
+		__entry->pblk = irec->br_startblock;
+		__entry->state = irec->br_state;
+	),
+	TP_printk("dev %d:%d ino 0x%llx whichfork %s fileoff 0x%llx fsbcount 0x%llx startblock 0x%llx state %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
+		  __entry->lblk,
+		  __entry->len,
+		  __entry->pblk,
+		  __entry->state)
+);
+
 TRACE_EVENT(xrep_findroot_block,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
 		 uint32_t magic, uint16_t level),
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8c0bfc9a33b11..8153307797822 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -131,6 +131,62 @@ xfs_trans_dup(
 	return ntp;
 }
 
+/*
+ * Try to reserve more blocks for a transaction.
+ *
+ * This is for callers that need to attach resources to a transaction, scan
+ * those resources to determine the space reservation requirements, and then
+ * modify the attached resources.  In other words, online repair.  This can
+ * fail due to ENOSPC, so the caller must be able to cancel the transaction
+ * without shutting down the fs.
+ */
+int
+xfs_trans_reserve_more(
+	struct xfs_trans	*tp,
+	unsigned int		blocks,
+	unsigned int		rtextents)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
+	int			error = 0;
+
+	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
+
+	/*
+	 * Attempt to reserve the needed disk blocks by decrementing
+	 * the number needed from the number available.  This will
+	 * fail if the count would go below zero.
+	 */
+	if (blocks > 0) {
+		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
+		if (error)
+			return -ENOSPC;
+		tp->t_blk_res += blocks;
+	}
+
+	/*
+	 * Attempt to reserve the needed realtime extents by decrementing
+	 * the number needed from the number available.  This will
+	 * fail if the count would go below zero.
+	 */
+	if (rtextents > 0) {
+		error = xfs_mod_frextents(mp, -((int64_t)rtextents));
+		if (error) {
+			error = -ENOSPC;
+			goto out_blocks;
+		}
+		tp->t_rtx_res += rtextents;
+	}
+
+	return 0;
+out_blocks:
+	if (blocks > 0) {
+		xfs_mod_fdblocks(mp, (int64_t)blocks, rsvd);
+		tp->t_blk_res -= blocks;
+	}
+	return error;
+}
+
 /*
  * This is called to reserve free disk blocks and log space for the
  * given transaction.  This must be done before allocating any resources
@@ -1231,6 +1287,45 @@ xfs_trans_alloc_inode(
 	return error;
 }
 
+
+/* Try to reserve more blocks and file quota for a transaction. */
+int
+xfs_trans_reserve_more_inode(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	unsigned int		dblocks,
+	unsigned int		rblocks,
+	bool			force_quota)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		rtx = rblocks / mp->m_sb.sb_rextsize;
+	int			error;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	error = xfs_trans_reserve_more(tp, dblocks, rtx);
+	if (error)
+		return error;
+
+	if (!XFS_IS_QUOTA_ON(mp) || xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
+		return 0;
+
+	if (tp->t_flags & XFS_TRANS_RESERVE)
+		force_quota = true;
+
+	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks,
+			force_quota);
+	if (!error)
+		return 0;
+
+	/* Quota failed, give back the new reservation. */
+	xfs_mod_fdblocks(mp, dblocks, tp->t_flags & XFS_TRANS_RESERVE);
+	tp->t_blk_res -= dblocks;
+	xfs_mod_frextents(mp, rtx);
+	tp->t_rtx_res -= rtx;
+	return error;
+}
+
 /*
  * Allocate an transaction in preparation for inode creation by reserving quota
  * against the given dquots.  Callers are not required to hold any inode locks.
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 6e3646d524ceb..d32abdd1e0149 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -168,6 +168,8 @@ typedef struct xfs_trans {
 int		xfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
 			uint blocks, uint rtextents, uint flags,
 			struct xfs_trans **tpp);
+int		xfs_trans_reserve_more(struct xfs_trans *tp,
+			unsigned int blocks, unsigned int rtextents);
 int		xfs_trans_alloc_empty(struct xfs_mount *mp,
 			struct xfs_trans **tpp);
 void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
@@ -260,6 +262,8 @@ struct xfs_dquot;
 int xfs_trans_alloc_inode(struct xfs_inode *ip, struct xfs_trans_res *resv,
 		unsigned int dblocks, unsigned int rblocks, bool force,
 		struct xfs_trans **tpp);
+int xfs_trans_reserve_more_inode(struct xfs_trans *tp, struct xfs_inode *ip,
+		unsigned int dblocks, unsigned int rblocks, bool force_quota);
 int xfs_trans_alloc_icreate(struct xfs_mount *mp, struct xfs_trans_res *resv,
 		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
 		struct xfs_dquot *pdqp, unsigned int dblocks,

