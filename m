Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:55788 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfHAL2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 07:28:43 -0400
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH] fs: xfs: Remove KM_NOSLEEP and KM_SLEEP.
Date: Thu,  1 Aug 2019 20:28:07 +0900
Message-Id: <1564658887-12654-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <62ec978e-c045-80ad-24a6-41da07d1b37d@i-love.sakura.ne.jp>
References: <62ec978e-c045-80ad-24a6-41da07d1b37d@i-love.sakura.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Since no caller is using KM_NOSLEEP and no callee branches on KM_SLEEP,
we can remove KM_NOSLEEP and replace KM_SLEEP with 0.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/xfs/kmem.c                  |  6 +++---
 fs/xfs/kmem.h                  | 14 ++++----------
 fs/xfs/libxfs/xfs_alloc.c      |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c  |  8 ++++----
 fs/xfs/libxfs/xfs_bmap.c       |  6 +++---
 fs/xfs/libxfs/xfs_da_btree.c   |  6 +++---
 fs/xfs/libxfs/xfs_defer.c      |  2 +-
 fs/xfs/libxfs/xfs_dir2.c       | 14 +++++++-------
 fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    |  8 ++++----
 fs/xfs/libxfs/xfs_inode_fork.c | 16 ++++++++--------
 fs/xfs/libxfs/xfs_refcount.c   |  4 ++--
 fs/xfs/libxfs/xfs_rmap.c       |  2 +-
 fs/xfs/scrub/attr.c            |  2 +-
 fs/xfs/scrub/fscounters.c      |  2 +-
 fs/xfs/scrub/symlink.c         |  2 +-
 fs/xfs/xfs_acl.c               |  4 ++--
 fs/xfs/xfs_attr_inactive.c     |  2 +-
 fs/xfs/xfs_attr_list.c         |  2 +-
 fs/xfs/xfs_bmap_item.c         |  4 ++--
 fs/xfs/xfs_buf.c               |  2 +-
 fs/xfs/xfs_buf_item.c          |  4 ++--
 fs/xfs/xfs_dquot.c             |  2 +-
 fs/xfs/xfs_dquot_item.c        |  2 +-
 fs/xfs/xfs_error.c             |  2 +-
 fs/xfs/xfs_extent_busy.c       |  2 +-
 fs/xfs/xfs_extfree_item.c      |  8 ++++----
 fs/xfs/xfs_icache.c            |  2 +-
 fs/xfs/xfs_icreate_item.c      |  2 +-
 fs/xfs/xfs_inode.c             |  2 +-
 fs/xfs/xfs_inode_item.c        |  2 +-
 fs/xfs/xfs_ioctl.c             |  4 ++--
 fs/xfs/xfs_ioctl32.c           |  2 +-
 fs/xfs/xfs_itable.c            |  4 ++--
 fs/xfs/xfs_iwalk.c             |  2 +-
 fs/xfs/xfs_log.c               |  2 +-
 fs/xfs/xfs_log_cil.c           | 10 +++++-----
 fs/xfs/xfs_log_recover.c       | 16 ++++++++--------
 fs/xfs/xfs_mount.c             |  2 +-
 fs/xfs/xfs_mru_cache.c         |  4 ++--
 fs/xfs/xfs_qm.c                |  4 ++--
 fs/xfs/xfs_refcount_item.c     |  6 +++---
 fs/xfs/xfs_rmap_item.c         |  6 +++---
 fs/xfs/xfs_rtalloc.c           |  4 ++--
 fs/xfs/xfs_trans.c             |  4 ++--
 fs/xfs/xfs_trans_dquot.c       |  2 +-
 46 files changed, 102 insertions(+), 108 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 16bb9a3..7cd315a 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -17,7 +17,7 @@
 
 	do {
 		ptr = kmalloc(size, lflags);
-		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
+		if (ptr || (flags & KM_MAYFAIL))
 			return ptr;
 		if (!(++retries % 100))
 			xfs_err(NULL,
@@ -67,7 +67,7 @@
 
 	do {
 		ptr = krealloc(old, newsize, lflags);
-		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
+		if (ptr || (flags & KM_MAYFAIL))
 			return ptr;
 		if (!(++retries % 100))
 			xfs_err(NULL,
@@ -87,7 +87,7 @@
 
 	do {
 		ptr = kmem_cache_alloc(zone, lflags);
-		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
+		if (ptr || (flags & KM_MAYFAIL))
 			return ptr;
 		if (!(++retries % 100))
 			xfs_err(NULL,
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 267655a..cb6fa79 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -16,8 +16,6 @@
  */
 
 typedef unsigned __bitwise xfs_km_flags_t;
-#define KM_SLEEP	((__force xfs_km_flags_t)0x0001u)
-#define KM_NOSLEEP	((__force xfs_km_flags_t)0x0002u)
 #define KM_NOFS		((__force xfs_km_flags_t)0x0004u)
 #define KM_MAYFAIL	((__force xfs_km_flags_t)0x0008u)
 #define KM_ZERO		((__force xfs_km_flags_t)0x0010u)
@@ -32,15 +30,11 @@
 {
 	gfp_t	lflags;
 
-	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL|KM_ZERO));
+	BUG_ON(flags & ~(KM_NOFS|KM_MAYFAIL|KM_ZERO));
 
-	if (flags & KM_NOSLEEP) {
-		lflags = GFP_ATOMIC | __GFP_NOWARN;
-	} else {
-		lflags = GFP_KERNEL | __GFP_NOWARN;
-		if (flags & KM_NOFS)
-			lflags &= ~__GFP_FS;
-	}
+	lflags = GFP_KERNEL | __GFP_NOWARN;
+	if (flags & KM_NOFS)
+		lflags &= ~__GFP_FS;
 
 	/*
 	 * Default page/slab allocator behavior is to retry for ever
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 372ad55..533b04a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2205,7 +2205,7 @@
 	ASSERT(xfs_bmap_free_item_zone != NULL);
 	ASSERT(oinfo != NULL);
 
-	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
+	new = kmem_zone_alloc(xfs_bmap_free_item_zone, 0);
 	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
 	new->xefi_blockcount = 1;
 	new->xefi_oinfo = *oinfo;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 70eb941..1408638 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -782,7 +782,7 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
 	ifp = dp->i_afp;
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
 	size = be16_to_cpu(sf->hdr.totsize);
-	tmpbuffer = kmem_alloc(size, KM_SLEEP);
+	tmpbuffer = kmem_alloc(size, 0);
 	ASSERT(tmpbuffer != NULL);
 	memcpy(tmpbuffer, ifp->if_u1.if_data, size);
 	sf = (xfs_attr_shortform_t *)tmpbuffer;
@@ -985,7 +985,7 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
 
 	trace_xfs_attr_leaf_to_sf(args);
 
-	tmpbuffer = kmem_alloc(args->geo->blksize, KM_SLEEP);
+	tmpbuffer = kmem_alloc(args->geo->blksize, 0);
 	if (!tmpbuffer)
 		return -ENOMEM;
 
@@ -1448,7 +1448,7 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
 
 	trace_xfs_attr_leaf_compact(args);
 
-	tmpbuffer = kmem_alloc(args->geo->blksize, KM_SLEEP);
+	tmpbuffer = kmem_alloc(args->geo->blksize, 0);
 	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
 	memset(bp->b_addr, 0, args->geo->blksize);
 	leaf_src = (xfs_attr_leafblock_t *)tmpbuffer;
@@ -2167,7 +2167,7 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
 		struct xfs_attr_leafblock *tmp_leaf;
 		struct xfs_attr3_icleaf_hdr tmphdr;
 
-		tmp_leaf = kmem_zalloc(state->args->geo->blksize, KM_SLEEP);
+		tmp_leaf = kmem_zalloc(state->args->geo->blksize, 0);
 
 		/*
 		 * Copy the header into the temp leaf so that all the stuff
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index baf0b72..6da9ce7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -553,7 +553,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 #endif
 	ASSERT(xfs_bmap_free_item_zone != NULL);
 
-	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
+	new = kmem_zone_alloc(xfs_bmap_free_item_zone, 0);
 	new->xefi_startblock = bno;
 	new->xefi_blockcount = (xfs_extlen_t)len;
 	if (oinfo)
@@ -1099,7 +1099,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	if (error)
 		goto trans_cancel;
 	ASSERT(ip->i_afp == NULL);
-	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
+	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, 0);
 	ip->i_afp->if_flags = XFS_IFEXTENTS;
 	logflags = 0;
 	switch (ip->i_d.di_format) {
@@ -6081,7 +6081,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 			bmap->br_blockcount,
 			bmap->br_state);
 
-	bi = kmem_alloc(sizeof(struct xfs_bmap_intent), KM_SLEEP | KM_NOFS);
+	bi = kmem_alloc(sizeof(struct xfs_bmap_intent), KM_NOFS);
 	INIT_LIST_HEAD(&bi->bi_list);
 	bi->bi_type = type;
 	bi->bi_owner = ip;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index d1c77fd..d7afbe6 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2093,7 +2093,7 @@ enum xfs_dacmp
 		 * If we didn't get it and the block might work if fragmented,
 		 * try without the CONTIG flag.  Loop until we get it all.
 		 */
-		mapp = kmem_alloc(sizeof(*mapp) * count, KM_SLEEP);
+		mapp = kmem_alloc(sizeof(*mapp) * count, 0);
 		for (b = *bno, mapi = 0; b < *bno + count; ) {
 			nmap = min(XFS_BMAP_MAX_NMAP, count);
 			c = (int)(*bno + count - b);
@@ -2475,7 +2475,7 @@ enum xfs_dacmp
 
 	if (nirecs > 1) {
 		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map),
-				  KM_SLEEP | KM_NOFS);
+				  KM_NOFS);
 		if (!map)
 			return -ENOMEM;
 		*mapp = map;
@@ -2534,7 +2534,7 @@ enum xfs_dacmp
 		 */
 		if (nfsb != 1)
 			irecs = kmem_zalloc(sizeof(irec) * nfsb,
-					    KM_SLEEP | KM_NOFS);
+					    KM_NOFS);
 
 		nirecs = nfsb;
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb, irecs,
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index eb2be2a..2255752 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -517,7 +517,7 @@
 	}
 	if (!dfp) {
 		dfp = kmem_alloc(sizeof(struct xfs_defer_pending),
-				KM_SLEEP | KM_NOFS);
+				KM_NOFS);
 		dfp->dfp_type = type;
 		dfp->dfp_intent = NULL;
 		dfp->dfp_done = NULL;
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 6784072..867c5de 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -110,9 +110,9 @@
 
 	nodehdr_size = mp->m_dir_inode_ops->node_hdr_size;
 	mp->m_dir_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
-				    KM_SLEEP | KM_MAYFAIL);
+				    KM_MAYFAIL);
 	mp->m_attr_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
-				     KM_SLEEP | KM_MAYFAIL);
+				     KM_MAYFAIL);
 	if (!mp->m_dir_geo || !mp->m_attr_geo) {
 		kmem_free(mp->m_dir_geo);
 		kmem_free(mp->m_attr_geo);
@@ -217,7 +217,7 @@
 	if (error)
 		return error;
 
-	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
+	args = kmem_zalloc(sizeof(*args), KM_NOFS);
 	if (!args)
 		return -ENOMEM;
 
@@ -254,7 +254,7 @@
 		XFS_STATS_INC(dp->i_mount, xs_dir_create);
 	}
 
-	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
+	args = kmem_zalloc(sizeof(*args), KM_NOFS);
 	if (!args)
 		return -ENOMEM;
 
@@ -353,7 +353,7 @@
 	 * lockdep Doing this avoids having to add a bunch of lockdep class
 	 * annotations into the reclaim path for the ilock.
 	 */
-	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
+	args = kmem_zalloc(sizeof(*args), KM_NOFS);
 	args->geo = dp->i_mount->m_dir_geo;
 	args->name = name->name;
 	args->namelen = name->len;
@@ -422,7 +422,7 @@
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
 
-	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
+	args = kmem_zalloc(sizeof(*args), KM_NOFS);
 	if (!args)
 		return -ENOMEM;
 
@@ -483,7 +483,7 @@
 	if (rval)
 		return rval;
 
-	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
+	args = kmem_zalloc(sizeof(*args), KM_NOFS);
 	if (!args)
 		return -ENOMEM;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index a6fb0cc..9595ced 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1092,7 +1092,7 @@ static int xfs_dir2_block_lookup_int(xfs_da_args_t *args, struct xfs_buf **bpp,
 	 * Copy the directory into a temporary buffer.
 	 * Then pitch the incore inode data so we can make extents.
 	 */
-	sfp = kmem_alloc(ifp->if_bytes, KM_SLEEP);
+	sfp = kmem_alloc(ifp->if_bytes, 0);
 	memcpy(sfp, oldsfp, ifp->if_bytes);
 
 	xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 0335892..85f14fc 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -164,7 +164,7 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_t *args, int objchange,
 	 * can free the block and copy the formatted data into the inode literal
 	 * area.
 	 */
-	dst = kmem_alloc(mp->m_sb.sb_inodesize, KM_SLEEP);
+	dst = kmem_alloc(mp->m_sb.sb_inodesize, 0);
 	hdr = bp->b_addr;
 
 	/*
@@ -436,7 +436,7 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_t *args, int objchange,
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	old_isize = (int)dp->i_d.di_size;
-	buf = kmem_alloc(old_isize, KM_SLEEP);
+	buf = kmem_alloc(old_isize, 0);
 	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
 	memcpy(oldsfp, sfp, old_isize);
 	/*
@@ -1096,7 +1096,7 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_t *args, int objchange,
 	 * Don't want xfs_idata_realloc copying the data here.
 	 */
 	oldsize = dp->i_df.if_bytes;
-	buf = kmem_alloc(oldsize, KM_SLEEP);
+	buf = kmem_alloc(oldsize, 0);
 	oldsfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	ASSERT(oldsfp->i8count == 1);
 	memcpy(buf, oldsfp, oldsize);
@@ -1169,7 +1169,7 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_t *args, int objchange,
 	 * Don't want xfs_idata_realloc copying the data here.
 	 */
 	oldsize = dp->i_df.if_bytes;
-	buf = kmem_alloc(oldsize, KM_SLEEP);
+	buf = kmem_alloc(oldsize, 0);
 	oldsfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	ASSERT(oldsfp->i8count == 0);
 	memcpy(buf, oldsfp, oldsize);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index bf3e040..c643bee 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -94,7 +94,7 @@
 		return 0;
 
 	ASSERT(ip->i_afp == NULL);
-	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP | KM_NOFS);
+	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
 
 	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -147,7 +147,7 @@
 
 	if (size) {
 		real_size = roundup(mem_size, 4);
-		ifp->if_u1.if_data = kmem_alloc(real_size, KM_SLEEP | KM_NOFS);
+		ifp->if_u1.if_data = kmem_alloc(real_size, KM_NOFS);
 		memcpy(ifp->if_u1.if_data, data, size);
 		if (zero_terminate)
 			ifp->if_u1.if_data[size] = '\0';
@@ -302,7 +302,7 @@
 	}
 
 	ifp->if_broot_bytes = size;
-	ifp->if_broot = kmem_alloc(size, KM_SLEEP | KM_NOFS);
+	ifp->if_broot = kmem_alloc(size, KM_NOFS);
 	ASSERT(ifp->if_broot != NULL);
 	/*
 	 * Copy and convert from the on-disk structure
@@ -367,7 +367,7 @@
 		 */
 		if (ifp->if_broot_bytes == 0) {
 			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
-			ifp->if_broot = kmem_alloc(new_size, KM_SLEEP | KM_NOFS);
+			ifp->if_broot = kmem_alloc(new_size, KM_NOFS);
 			ifp->if_broot_bytes = (int)new_size;
 			return;
 		}
@@ -382,7 +382,7 @@
 		new_max = cur_max + rec_diff;
 		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
 		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
-				KM_SLEEP | KM_NOFS);
+				KM_NOFS);
 		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
 		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
@@ -408,7 +408,7 @@
 	else
 		new_size = 0;
 	if (new_size > 0) {
-		new_broot = kmem_alloc(new_size, KM_SLEEP | KM_NOFS);
+		new_broot = kmem_alloc(new_size, KM_NOFS);
 		/*
 		 * First copy over the btree block header.
 		 */
@@ -492,7 +492,7 @@
 	 * We enforce that here.
 	 */
 	ifp->if_u1.if_data = kmem_realloc(ifp->if_u1.if_data,
-			roundup(new_size, 4), KM_SLEEP | KM_NOFS);
+			roundup(new_size, 4), KM_NOFS);
 	ifp->if_bytes = new_size;
 }
 
@@ -683,7 +683,7 @@ struct xfs_ifork *
 		return;
 
 	ip->i_cowfp = kmem_zone_zalloc(xfs_ifork_zone,
-				       KM_SLEEP | KM_NOFS);
+				       KM_NOFS);
 	ip->i_cowfp->if_flags = XFS_IFEXTENTS;
 	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;
 	ip->i_cnextents = 0;
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 51bb9bd..14b9e3e 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1189,7 +1189,7 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
 			blockcount);
 
 	ri = kmem_alloc(sizeof(struct xfs_refcount_intent),
-			KM_SLEEP | KM_NOFS);
+			KM_NOFS);
 	INIT_LIST_HEAD(&ri->ri_list);
 	ri->ri_type = type;
 	ri->ri_startblock = startblock;
@@ -1602,7 +1602,7 @@ struct xfs_refcount_recovery {
 	if (be32_to_cpu(rec->refc.rc_refcount) != 1)
 		return -EFSCORRUPTED;
 
-	rr = kmem_alloc(sizeof(struct xfs_refcount_recovery), KM_SLEEP);
+	rr = kmem_alloc(sizeof(struct xfs_refcount_recovery), 0);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
 	list_add_tail(&rr->rr_list, debris);
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index e6aeb39..12a61f0 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2287,7 +2287,7 @@ struct xfs_rmap_query_range_info {
 			bmap->br_blockcount,
 			bmap->br_state);
 
-	ri = kmem_alloc(sizeof(struct xfs_rmap_intent), KM_SLEEP | KM_NOFS);
+	ri = kmem_alloc(sizeof(struct xfs_rmap_intent), KM_NOFS);
 	INIT_LIST_HEAD(&ri->ri_list);
 	ri->ri_type = type;
 	ri->ri_owner = owner;
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 1afc58b..922a515 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -80,7 +80,7 @@
 	 * without the inode lock held, which means we can sleep.
 	 */
 	if (sc->flags & XCHK_TRY_HARDER) {
-		error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX, KM_SLEEP);
+		error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX, 0);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index fc3f510..98f82d7 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -125,7 +125,7 @@
 	struct xchk_fscounters	*fsc;
 	int			error;
 
-	sc->buf = kmem_zalloc(sizeof(struct xchk_fscounters), KM_SLEEP);
+	sc->buf = kmem_zalloc(sizeof(struct xchk_fscounters), 0);
 	if (!sc->buf)
 		return -ENOMEM;
 	fsc = sc->buf;
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 99c0b12..5641ae5 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -22,7 +22,7 @@
 	struct xfs_inode	*ip)
 {
 	/* Allocate the buffer without the inode lock held. */
-	sc->buf = kmem_zalloc_large(XFS_SYMLINK_MAXLEN + 1, KM_SLEEP);
+	sc->buf = kmem_zalloc_large(XFS_SYMLINK_MAXLEN + 1, 0);
 	if (!sc->buf)
 		return -ENOMEM;
 
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index cbda40d..86c0697 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -135,7 +135,7 @@ struct posix_acl *
 	 * go out to the disk.
 	 */
 	len = XFS_ACL_MAX_SIZE(ip->i_mount);
-	xfs_acl = kmem_zalloc_large(len, KM_SLEEP);
+	xfs_acl = kmem_zalloc_large(len, 0);
 	if (!xfs_acl)
 		return ERR_PTR(-ENOMEM);
 
@@ -180,7 +180,7 @@ struct posix_acl *
 		struct xfs_acl *xfs_acl;
 		int len = XFS_ACL_MAX_SIZE(ip->i_mount);
 
-		xfs_acl = kmem_zalloc_large(len, KM_SLEEP);
+		xfs_acl = kmem_zalloc_large(len, 0);
 		if (!xfs_acl)
 			return -ENOMEM;
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index dc93c51..a640a28 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -147,7 +147,7 @@
 	 * Allocate storage for a list of all the "remote" value extents.
 	 */
 	size = count * sizeof(xfs_attr_inactive_list_t);
-	list = kmem_alloc(size, KM_SLEEP);
+	list = kmem_alloc(size, 0);
 
 	/*
 	 * Identify each of the "remote" value extents.
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 58fc820..00758fd 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -109,7 +109,7 @@
 	 * It didn't all fit, so we have to sort everything on hashval.
 	 */
 	sbsize = sf->hdr.count * sizeof(*sbuf);
-	sbp = sbuf = kmem_alloc(sbsize, KM_SLEEP | KM_NOFS);
+	sbp = sbuf = kmem_alloc(sbsize, KM_NOFS);
 
 	/*
 	 * Scan the attribute list for the rest of the entries, storing
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 9fa4a7e..989163e 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -141,7 +141,7 @@ struct xfs_bui_log_item *
 {
 	struct xfs_bui_log_item		*buip;
 
-	buip = kmem_zone_zalloc(xfs_bui_zone, KM_SLEEP);
+	buip = kmem_zone_zalloc(xfs_bui_zone, 0);
 
 	xfs_log_item_init(mp, &buip->bui_item, XFS_LI_BUI, &xfs_bui_item_ops);
 	buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
@@ -218,7 +218,7 @@ static inline struct xfs_bud_log_item *BUD_ITEM(struct xfs_log_item *lip)
 {
 	struct xfs_bud_log_item		*budp;
 
-	budp = kmem_zone_zalloc(xfs_bud_zone, KM_SLEEP);
+	budp = kmem_zone_zalloc(xfs_bud_zone, 0);
 	xfs_log_item_init(tp->t_mountp, &budp->bud_item, XFS_LI_BUD,
 			  &xfs_bud_item_ops);
 	budp->bud_buip = buip;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ca08490..d3be9ab 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1741,7 +1741,7 @@ struct xfs_buf *
 {
 	xfs_buftarg_t		*btp;
 
-	btp = kmem_zalloc(sizeof(*btp), KM_SLEEP | KM_NOFS);
+	btp = kmem_zalloc(sizeof(*btp), KM_NOFS);
 
 	btp->bt_mount = mp;
 	btp->bt_dev =  bdev->bd_dev;
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 7dcaec5..d74fbd1 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -702,7 +702,7 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 	}
 
 	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
-				KM_SLEEP);
+				0);
 	if (!bip->bli_formats)
 		return -ENOMEM;
 	return 0;
@@ -747,7 +747,7 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 		return 0;
 	}
 
-	bip = kmem_zone_zalloc(xfs_buf_item_zone, KM_SLEEP);
+	bip = kmem_zone_zalloc(xfs_buf_item_zone, 0);
 	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF, &xfs_buf_item_ops);
 	bip->bli_buf = bp;
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index fb1ad44..7ce770e 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -440,7 +440,7 @@
 {
 	struct xfs_dquot	*dqp;
 
-	dqp = kmem_zone_zalloc(xfs_qm_dqzone, KM_SLEEP);
+	dqp = kmem_zone_zalloc(xfs_qm_dqzone, 0);
 
 	dqp->dq_flags = type;
 	dqp->q_core.d_id = cpu_to_be32(id);
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 282ec5a..d60647d 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -347,7 +347,7 @@ struct xfs_qoff_logitem *
 {
 	struct xfs_qoff_logitem	*qf;
 
-	qf = kmem_zalloc(sizeof(struct xfs_qoff_logitem), KM_SLEEP);
+	qf = kmem_zalloc(sizeof(struct xfs_qoff_logitem), 0);
 
 	xfs_log_item_init(mp, &qf->qql_item, XFS_LI_QUOTAOFF, start ?
 			&xfs_qm_qoffend_logitem_ops : &xfs_qm_qoff_logitem_ops);
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 544c948..849fd44 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -213,7 +213,7 @@ struct xfs_errortag_attr {
 	struct xfs_mount	*mp)
 {
 	mp->m_errortag = kmem_zalloc(sizeof(unsigned int) * XFS_ERRTAG_MAX,
-			KM_SLEEP | KM_MAYFAIL);
+			KM_MAYFAIL);
 	if (!mp->m_errortag)
 		return -ENOMEM;
 
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 0ed6837..2183d87 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -33,7 +33,7 @@
 	struct rb_node		**rbp;
 	struct rb_node		*parent = NULL;
 
-	new = kmem_zalloc(sizeof(struct xfs_extent_busy), KM_SLEEP);
+	new = kmem_zalloc(sizeof(struct xfs_extent_busy), 0);
 	new->agno = agno;
 	new->bno = bno;
 	new->length = len;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 86f6512..e44efc4 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -163,9 +163,9 @@ struct xfs_efi_log_item *
 	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
 		size = (uint)(sizeof(xfs_efi_log_item_t) +
 			((nextents - 1) * sizeof(xfs_extent_t)));
-		efip = kmem_zalloc(size, KM_SLEEP);
+		efip = kmem_zalloc(size, 0);
 	} else {
-		efip = kmem_zone_zalloc(xfs_efi_zone, KM_SLEEP);
+		efip = kmem_zone_zalloc(xfs_efi_zone, 0);
 	}
 
 	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
@@ -333,9 +333,9 @@ static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
 	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
 		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
 				(nextents - 1) * sizeof(struct xfs_extent),
-				KM_SLEEP);
+				0);
 	} else {
-		efdp = kmem_zone_zalloc(xfs_efd_zone, KM_SLEEP);
+		efdp = kmem_zone_zalloc(xfs_efd_zone, 0);
 	}
 
 	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0b0fd10..944add5 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -40,7 +40,7 @@ struct xfs_inode *
 	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
 	 * code up to do this anyway.
 	 */
-	ip = kmem_zone_alloc(xfs_inode_zone, KM_SLEEP);
+	ip = kmem_zone_alloc(xfs_inode_zone, 0);
 	if (!ip)
 		return NULL;
 	if (inode_init_always(mp->m_super, VFS_I(ip))) {
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index d99a0a3..3ebd1b7 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -89,7 +89,7 @@ static inline struct xfs_icreate_item *ICR_ITEM(struct xfs_log_item *lip)
 {
 	struct xfs_icreate_item	*icp;
 
-	icp = kmem_zone_zalloc(xfs_icreate_zone, KM_SLEEP);
+	icp = kmem_zone_zalloc(xfs_icreate_zone, 0);
 
 	xfs_log_item_init(tp->t_mountp, &icp->ic_item, XFS_LI_ICREATE,
 			  &xfs_icreate_item_ops);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6467d5e..cdb97fa 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2018,7 +2018,7 @@ struct xfs_iunlink {
 	if (XFS_TEST_ERROR(false, pag->pag_mount, XFS_ERRTAG_IUNLINK_FALLBACK))
 		return 0;
 
-	iu = kmem_zalloc(sizeof(*iu), KM_SLEEP | KM_NOFS);
+	iu = kmem_zalloc(sizeof(*iu), KM_NOFS);
 	iu->iu_agino = prev_agino;
 	iu->iu_next_unlinked = this_agino;
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index c9a502e..bb8f076 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -651,7 +651,7 @@ static inline struct xfs_inode_log_item *INODE_ITEM(struct xfs_log_item *lip)
 	struct xfs_inode_log_item *iip;
 
 	ASSERT(ip->i_itemp == NULL);
-	iip = ip->i_itemp = kmem_zone_zalloc(xfs_ili_zone, KM_SLEEP);
+	iip = ip->i_itemp = kmem_zone_zalloc(xfs_ili_zone, 0);
 
 	iip->ili_inode = ip;
 	xfs_log_item_init(mp, &iip->ili_item, XFS_LI_INODE,
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6f7848c..9ea5166 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -396,7 +396,7 @@ struct dentry *
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	kbuf = kmem_zalloc_large(al_hreq.buflen, KM_SLEEP);
+	kbuf = kmem_zalloc_large(al_hreq.buflen, 0);
 	if (!kbuf)
 		goto out_dput;
 
@@ -434,7 +434,7 @@ struct dentry *
 
 	if (*len > XFS_XATTR_SIZE_MAX)
 		return -EINVAL;
-	kbuf = kmem_zalloc_large(*len, KM_SLEEP);
+	kbuf = kmem_zalloc_large(*len, 0);
 	if (!kbuf)
 		return -ENOMEM;
 
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 7fcf756..c3bf7eb 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -381,7 +381,7 @@
 		return PTR_ERR(dentry);
 
 	error = -ENOMEM;
-	kbuf = kmem_zalloc_large(al_hreq.buflen, KM_SLEEP);
+	kbuf = kmem_zalloc_large(al_hreq.buflen, 0);
 	if (!kbuf)
 		goto out_dput;
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index a8a06bb..01dd45b 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -169,7 +169,7 @@ struct xfs_bstat_chunk {
 	ASSERT(breq->icount == 1);
 
 	bc.buf = kmem_zalloc(sizeof(struct xfs_bulkstat),
-			KM_SLEEP | KM_MAYFAIL);
+			KM_MAYFAIL);
 	if (!bc.buf)
 		return -ENOMEM;
 
@@ -243,7 +243,7 @@ struct xfs_bstat_chunk {
 		return 0;
 
 	bc.buf = kmem_zalloc(sizeof(struct xfs_bulkstat),
-			KM_SLEEP | KM_MAYFAIL);
+			KM_MAYFAIL);
 	if (!bc.buf)
 		return -ENOMEM;
 
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 8c7d7271..86ce52c 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -616,7 +616,7 @@ struct xfs_iwalk_ag {
 		if (xfs_pwork_ctl_want_abort(&pctl))
 			break;
 
-		iwag = kmem_zalloc(sizeof(struct xfs_iwalk_ag), KM_SLEEP);
+		iwag = kmem_zalloc(sizeof(struct xfs_iwalk_ag), 0);
 		iwag->mp = mp;
 		iwag->iwalk_fn = iwalk_fn;
 		iwag->data = data;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 00e9f5c..4790771 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -429,7 +429,7 @@ STATIC void xlog_state_done_syncing(
 
 	ASSERT(*ticp == NULL);
 	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent,
-				KM_SLEEP | KM_MAYFAIL);
+				KM_MAYFAIL);
 	if (!tic)
 		return -ENOMEM;
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index fa5602d..ef652abd 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -38,7 +38,7 @@
 	struct xlog_ticket *tic;
 
 	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0,
-				KM_SLEEP|KM_NOFS);
+				KM_NOFS);
 
 	/*
 	 * set the current reservation to zero so we know to steal the basic
@@ -186,7 +186,7 @@
 			 */
 			kmem_free(lip->li_lv_shadow);
 
-			lv = kmem_alloc_large(buf_size, KM_SLEEP | KM_NOFS);
+			lv = kmem_alloc_large(buf_size, KM_NOFS);
 			memset(lv, 0, xlog_cil_iovec_space(niovecs));
 
 			lv->lv_item = lip;
@@ -660,7 +660,7 @@
 	if (!cil)
 		return 0;
 
-	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_SLEEP|KM_NOFS);
+	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_NOFS);
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
 
 	down_write(&cil->xc_ctx_lock);
@@ -1179,11 +1179,11 @@
 	struct xfs_cil	*cil;
 	struct xfs_cil_ctx *ctx;
 
-	cil = kmem_zalloc(sizeof(*cil), KM_SLEEP|KM_MAYFAIL);
+	cil = kmem_zalloc(sizeof(*cil), KM_MAYFAIL);
 	if (!cil)
 		return -ENOMEM;
 
-	ctx = kmem_zalloc(sizeof(*ctx), KM_SLEEP|KM_MAYFAIL);
+	ctx = kmem_zalloc(sizeof(*ctx), KM_MAYFAIL);
 	if (!ctx) {
 		kmem_free(cil);
 		return -ENOMEM;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 13d1d3e..eafb36c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1960,7 +1960,7 @@ struct xfs_buf_cancel {
 		}
 	}
 
-	bcp = kmem_alloc(sizeof(struct xfs_buf_cancel), KM_SLEEP);
+	bcp = kmem_alloc(sizeof(struct xfs_buf_cancel), 0);
 	bcp->bc_blkno = buf_f->blf_blkno;
 	bcp->bc_len = buf_f->blf_len;
 	bcp->bc_refcount = 1;
@@ -2930,7 +2930,7 @@ struct xfs_buf_cancel {
 	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
 		in_f = item->ri_buf[0].i_addr;
 	} else {
-		in_f = kmem_alloc(sizeof(struct xfs_inode_log_format), KM_SLEEP);
+		in_f = kmem_alloc(sizeof(struct xfs_inode_log_format), 0);
 		need_free = 1;
 		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
 		if (error)
@@ -4161,7 +4161,7 @@ struct xfs_buf_cancel {
 {
 	xlog_recover_item_t	*item;
 
-	item = kmem_zalloc(sizeof(xlog_recover_item_t), KM_SLEEP);
+	item = kmem_zalloc(sizeof(xlog_recover_item_t), 0);
 	INIT_LIST_HEAD(&item->ri_list);
 	list_add_tail(&item->ri_list, head);
 }
@@ -4201,7 +4201,7 @@ struct xfs_buf_cancel {
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
 
-	ptr = kmem_realloc(old_ptr, len + old_len, KM_SLEEP);
+	ptr = kmem_realloc(old_ptr, len + old_len, 0);
 	memcpy(&ptr[old_len], dp, len);
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
@@ -4261,7 +4261,7 @@ struct xfs_buf_cancel {
 		return 0;
 	}
 
-	ptr = kmem_alloc(len, KM_SLEEP);
+	ptr = kmem_alloc(len, 0);
 	memcpy(ptr, dp, len);
 	in_f = (struct xfs_inode_log_format *)ptr;
 
@@ -4289,7 +4289,7 @@ struct xfs_buf_cancel {
 		item->ri_total = in_f->ilf_size;
 		item->ri_buf =
 			kmem_zalloc(item->ri_total * sizeof(xfs_log_iovec_t),
-				    KM_SLEEP);
+				    0);
 	}
 	ASSERT(item->ri_total > item->ri_cnt);
 	/* Description region is ri_buf[0] */
@@ -4423,7 +4423,7 @@ struct xfs_buf_cancel {
 	 * This is a new transaction so allocate a new recovery container to
 	 * hold the recovery ops that will follow.
 	 */
-	trans = kmem_zalloc(sizeof(struct xlog_recover), KM_SLEEP);
+	trans = kmem_zalloc(sizeof(struct xlog_recover), 0);
 	trans->r_log_tid = tid;
 	trans->r_lsn = be64_to_cpu(rhead->h_lsn);
 	INIT_LIST_HEAD(&trans->r_itemq);
@@ -5527,7 +5527,7 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 	 */
 	log->l_buf_cancel_table = kmem_zalloc(XLOG_BC_TABLE_SIZE *
 						 sizeof(struct list_head),
-						 KM_SLEEP);
+						 0);
 	for (i = 0; i < XLOG_BC_TABLE_SIZE; i++)
 		INIT_LIST_HEAD(&log->l_buf_cancel_table[i]);
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 322da69..da50b12 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -82,7 +82,7 @@
 	if (hole < 0) {
 		xfs_uuid_table = kmem_realloc(xfs_uuid_table,
 			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
-			KM_SLEEP);
+			0);
 		hole = xfs_uuid_table_size++;
 	}
 	xfs_uuid_table[hole] = *uuid;
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 7473881..a06661d 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -333,12 +333,12 @@ struct xfs_mru_cache {
 	if (!(grp_time = msecs_to_jiffies(lifetime_ms) / grp_count))
 		return -EINVAL;
 
-	if (!(mru = kmem_zalloc(sizeof(*mru), KM_SLEEP)))
+	if (!(mru = kmem_zalloc(sizeof(*mru), 0)))
 		return -ENOMEM;
 
 	/* An extra list is needed to avoid reaping up to a grp_time early. */
 	mru->grp_count = grp_count + 1;
-	mru->lists = kmem_zalloc(mru->grp_count * sizeof(*mru->lists), KM_SLEEP);
+	mru->lists = kmem_zalloc(mru->grp_count * sizeof(*mru->lists), 0);
 
 	if (!mru->lists) {
 		err = -ENOMEM;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 5e7a37f..ecd8ce1 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -642,7 +642,7 @@ struct xfs_qm_isolate {
 
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
-	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(xfs_quotainfo_t), KM_SLEEP);
+	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(xfs_quotainfo_t), 0);
 
 	error = list_lru_init(&qinf->qi_lru);
 	if (error)
@@ -978,7 +978,7 @@ struct xfs_qm_isolate {
 	if (qip->i_d.di_nblocks == 0)
 		return 0;
 
-	map = kmem_alloc(XFS_DQITER_MAP_SIZE * sizeof(*map), KM_SLEEP);
+	map = kmem_alloc(XFS_DQITER_MAP_SIZE * sizeof(*map), 0);
 
 	lblkno = 0;
 	maxlblkcnt = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index d8288aa..db0e0d7 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -144,9 +144,9 @@ struct xfs_cui_log_item *
 	ASSERT(nextents > 0);
 	if (nextents > XFS_CUI_MAX_FAST_EXTENTS)
 		cuip = kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
-				KM_SLEEP);
+				0);
 	else
-		cuip = kmem_zone_zalloc(xfs_cui_zone, KM_SLEEP);
+		cuip = kmem_zone_zalloc(xfs_cui_zone, 0);
 
 	xfs_log_item_init(mp, &cuip->cui_item, XFS_LI_CUI, &xfs_cui_item_ops);
 	cuip->cui_format.cui_nextents = nextents;
@@ -223,7 +223,7 @@ static inline struct xfs_cud_log_item *CUD_ITEM(struct xfs_log_item *lip)
 {
 	struct xfs_cud_log_item		*cudp;
 
-	cudp = kmem_zone_zalloc(xfs_cud_zone, KM_SLEEP);
+	cudp = kmem_zone_zalloc(xfs_cud_zone, 0);
 	xfs_log_item_init(tp->t_mountp, &cudp->cud_item, XFS_LI_CUD,
 			  &xfs_cud_item_ops);
 	cudp->cud_cuip = cuip;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 77ed557..8939e0e 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -142,9 +142,9 @@ struct xfs_rui_log_item *
 
 	ASSERT(nextents > 0);
 	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
-		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), KM_SLEEP);
+		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
 	else
-		ruip = kmem_zone_zalloc(xfs_rui_zone, KM_SLEEP);
+		ruip = kmem_zone_zalloc(xfs_rui_zone, 0);
 
 	xfs_log_item_init(mp, &ruip->rui_item, XFS_LI_RUI, &xfs_rui_item_ops);
 	ruip->rui_format.rui_nextents = nextents;
@@ -244,7 +244,7 @@ static inline struct xfs_rud_log_item *RUD_ITEM(struct xfs_log_item *lip)
 {
 	struct xfs_rud_log_item		*rudp;
 
-	rudp = kmem_zone_zalloc(xfs_rud_zone, KM_SLEEP);
+	rudp = kmem_zone_zalloc(xfs_rud_zone, 0);
 	xfs_log_item_init(tp->t_mountp, &rudp->rud_item, XFS_LI_RUD,
 			  &xfs_rud_item_ops);
 	rudp->rud_ruip = ruip;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 5fa4db3..4a48a8c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -865,7 +865,7 @@
 	 * lower bound on the minimum level with any free extents. We can
 	 * continue without the cache if it couldn't be allocated.
 	 */
-	mp->m_rsum_cache = kmem_zalloc_large(rbmblocks, KM_SLEEP);
+	mp->m_rsum_cache = kmem_zalloc_large(rbmblocks, 0);
 	if (!mp->m_rsum_cache)
 		xfs_warn(mp, "could not allocate realtime summary cache");
 }
@@ -963,7 +963,7 @@
 	/*
 	 * Allocate a new (fake) mount/sb.
 	 */
-	nmp = kmem_alloc(sizeof(*nmp), KM_SLEEP);
+	nmp = kmem_alloc(sizeof(*nmp), 0);
 	/*
 	 * Loop over the bitmap blocks.
 	 * We will do everything one bitmap block at a time.
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index d42a68d..f4795fd 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -90,7 +90,7 @@
 
 	trace_xfs_trans_dup(tp, _RET_IP_);
 
-	ntp = kmem_zone_zalloc(xfs_trans_zone, KM_SLEEP);
+	ntp = kmem_zone_zalloc(xfs_trans_zone, 0);
 
 	/*
 	 * Initialize the new transaction structure.
@@ -263,7 +263,7 @@
 	 * GFP_NOFS allocation context so that we avoid lockdep false positives
 	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
 	 */
-	tp = kmem_zone_zalloc(xfs_trans_zone, KM_SLEEP);
+	tp = kmem_zone_zalloc(xfs_trans_zone, 0);
 	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_start_intwrite(mp->m_super);
 
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 1027c9c..1645746 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -863,7 +863,7 @@
 xfs_trans_alloc_dqinfo(
 	xfs_trans_t	*tp)
 {
-	tp->t_dqinfo = kmem_zone_zalloc(xfs_qm_dqtrxzone, KM_SLEEP);
+	tp->t_dqinfo = kmem_zone_zalloc(xfs_qm_dqtrxzone, 0);
 }
 
 void
-- 
1.8.3.1
