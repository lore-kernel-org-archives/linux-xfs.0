Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA26CC433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ACB16128B
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242005AbhDLNi6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 09:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241455AbhDLNi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Apr 2021 09:38:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9458CC061574
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 06:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=DPfeBYBGNqVot+oByiH2XtpdJpGc0HoMmTV0EJHka1I=; b=u+V3fkqArXpBxz0+q5kg8PmXzN
        9sAXU9o0FqsLC5m5os89dCHUqtPvwtlE1kJPx6RlXHJZthN1vWc7NJuz2XJQE7l0JiaZMtV5Lqte/
        bnB5J80OR2QLZOjK/17SfZxpkSdjz98sOlhpbYVGUKsIv7l1cci5NNz0FctaPBlG2E117gDqF/0xz
        qhbpwUHZTKN0yuB6lVKRbAnuGixKfWC6AStJ3t9xHuA3sGn+AN+n2DQs4TVA02j98brbIiMPXXSl+
        J4p8/Oy3dK10dOBZvf729t1ZhbbhXGPHwvFvlUGX3Fi6UH7Zt1WPerulTxgMZHSDoHJkSedpJzuNq
        oSLIIi6Q==;
Received: from [2001:4bb8:199:e2bd:3218:1918:85d1:2852] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lVwlz-006H0m-Te
        for linux-xfs@vger.kernel.org; Mon, 12 Apr 2021 13:38:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/7] xfs: remove XFS_IFEXTENTS
Date:   Mon, 12 Apr 2021 15:38:19 +0200
Message-Id: <20210412133819.2618857-8-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210412133819.2618857-1-hch@lst.de>
References: <20210412133819.2618857-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The in-memory XFS_IFEXTENTS is now only used to check if an inode with
extents still needs the extents to be read into memory before doing
operations that need the extent map.  Add a new xfs_need_iread_extents
helper that returns true for btree format forks that do not have any
entries in the in-memory extent btree, and use that instead of checking
the XFS_IFEXTENTS flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  |  4 +---
 fs/xfs/libxfs/xfs_bmap.c       | 14 ++------------
 fs/xfs/libxfs/xfs_dir2_sf.c    |  1 -
 fs/xfs/libxfs/xfs_inode_fork.c |  6 ------
 fs/xfs/libxfs/xfs_inode_fork.h | 12 ++++++------
 fs/xfs/scrub/bmap.c            |  6 +-----
 fs/xfs/xfs_aops.c              |  3 +--
 fs/xfs/xfs_bmap_util.c         |  4 ++--
 fs/xfs/xfs_inode.c             | 10 ++--------
 fs/xfs/xfs_ioctl.c             |  2 +-
 fs/xfs/xfs_iomap.c             |  4 ++--
 fs/xfs/xfs_symlink.c           |  2 +-
 12 files changed, 19 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 1ab7a73b5a9a46..556184b6306105 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -651,10 +651,8 @@ xfs_attr_shortform_create(
 	trace_xfs_attr_sf_create(args);
 
 	ASSERT(ifp->if_bytes == 0);
-	if (ifp->if_format == XFS_DINODE_FMT_EXTENTS) {
-		ifp->if_flags &= ~XFS_IFEXTENTS;	/* just in case */
+	if (ifp->if_format == XFS_DINODE_FMT_EXTENTS)
 		ifp->if_format = XFS_DINODE_FMT_LOCAL;
-	}
 	xfs_idata_realloc(dp, sizeof(*hdr), XFS_ATTR_FORK);
 	hdr = (struct xfs_attr_sf_hdr *)ifp->if_u1.if_data;
 	memset(hdr, 0, sizeof(*hdr));
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0af3edf8443c73..7e3b9b01431e57 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -605,7 +605,7 @@ xfs_bmap_btree_to_extents(
 
 	ASSERT(cur);
 	ASSERT(whichfork != XFS_COW_FORK);
-	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
+	ASSERT(!xfs_need_iread_extents(ifp));
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
 	ASSERT(be16_to_cpu(rblock->bb_level) == 1);
 	ASSERT(be16_to_cpu(rblock->bb_numrecs) == 1);
@@ -805,7 +805,6 @@ xfs_bmap_local_to_extents_empty(
 	ASSERT(ifp->if_nextents == 0);
 
 	xfs_bmap_forkoff_reset(ip, whichfork);
-	ifp->if_flags |= XFS_IFEXTENTS;
 	ifp->if_u1.if_root = NULL;
 	ifp->if_height = 0;
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
@@ -849,7 +848,6 @@ xfs_bmap_local_to_extents(
 
 	flags = 0;
 	error = 0;
-	ASSERT(!(ifp->if_flags & XFS_IFEXTENTS));
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = ip->i_mount;
@@ -1098,7 +1096,6 @@ xfs_bmap_add_attrfork(
 	ASSERT(ip->i_afp == NULL);
 
 	ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
-	ip->i_afp->if_flags = XFS_IFEXTENTS;
 	logflags = 0;
 	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -1224,16 +1221,11 @@ xfs_iread_extents(
 	struct xfs_btree_cur	*cur;
 	int			error;
 
-	if (ifp->if_flags & XFS_IFEXTENTS)
+	if (!xfs_need_iread_extents(ifp))
 		return 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
-	if (XFS_IS_CORRUPT(mp, ifp->if_format != XFS_DINODE_FMT_BTREE)) {
-		error = -EFSCORRUPTED;
-		goto out;
-	}
-
 	ir.loaded = 0;
 	xfs_iext_first(ifp, &ir.icur);
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
@@ -1248,8 +1240,6 @@ xfs_iread_extents(
 		goto out;
 	}
 	ASSERT(ir.loaded == xfs_iext_count(ifp));
-
-	ifp->if_flags |= XFS_IFEXTENTS;
 	return 0;
 out:
 	xfs_iext_destroy(ifp);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index b031be033838f6..46d18bf9d5e158 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -827,7 +827,6 @@ xfs_dir2_sf_create(
 	 * convert it to local format.
 	 */
 	if (dp->i_df.if_format == XFS_DINODE_FMT_EXTENTS) {
-		dp->i_df.if_flags &= ~XFS_IFEXTENTS;	/* just in case */
 		dp->i_df.if_format = XFS_DINODE_FMT_LOCAL;
 		xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
 	}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 3f2c16bf82e8c6..1d174909f9bdf5 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -60,7 +60,6 @@ xfs_init_local_fork(
 	}
 
 	ifp->if_bytes = size;
-	ifp->if_flags &= ~XFS_IFEXTENTS;
 }
 
 /*
@@ -150,7 +149,6 @@ xfs_iformat_extents(
 			xfs_iext_next(ifp, &icur);
 		}
 	}
-	ifp->if_flags |= XFS_IFEXTENTS;
 	return 0;
 }
 
@@ -212,7 +210,6 @@ xfs_iformat_btree(
 	 */
 	xfs_bmdr_to_bmbt(ip, dfp, XFS_DFORK_SIZE(dip, ip->i_mount, whichfork),
 			 ifp->if_broot, size);
-	ifp->if_flags &= ~XFS_IFEXTENTS;
 
 	ifp->if_bytes = 0;
 	ifp->if_u1.if_root = NULL;
@@ -622,8 +619,6 @@ xfs_iflush_fork(
 		break;
 
 	case XFS_DINODE_FMT_EXTENTS:
-		ASSERT((ifp->if_flags & XFS_IFEXTENTS) ||
-		       !(iip->ili_fields & extflag[whichfork]));
 		if ((iip->ili_fields & extflag[whichfork]) &&
 		    (ifp->if_bytes > 0)) {
 			ASSERT(ifp->if_nextents > 0);
@@ -683,7 +678,6 @@ xfs_ifork_init_cow(
 
 	ip->i_cowfp = kmem_cache_zalloc(xfs_ifork_zone,
 				       GFP_NOFS | __GFP_NOFAIL);
-	ip->i_cowfp->if_flags = XFS_IFEXTENTS;
 	ip->i_cowfp->if_format = XFS_DINODE_FMT_EXTENTS;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index ac8b2182ce8c57..a6f7897b6887b1 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -22,16 +22,10 @@ struct xfs_ifork {
 		char		*if_data;	/* inline file data */
 	} if_u1;
 	short			if_broot_bytes;	/* bytes allocated for root */
-	unsigned char		if_flags;	/* per-fork flags */
 	int8_t			if_format;	/* format of this fork */
 	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 };
 
-/*
- * Per-fork incore inode flags.
- */
-#define	XFS_IFEXTENTS	0x02	/* All extent pointers are read in */
-
 /*
  * Worst-case increase in the fork extent count when we're adding a single
  * extent to a fork and there's no possibility of splitting an existing mapping.
@@ -236,4 +230,10 @@ int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
 int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
 		int nr_to_add);
 
+/* returns true if the fork has extents but they are not read in yet. */
+static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
+{
+	return ifp->if_format == XFS_DINODE_FMT_BTREE && ifp->if_height == 0;
+}
+
 #endif	/* __XFS_INODE_FORK_H__ */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 924d7e343731de..b5ebf1d1b4db45 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -447,7 +447,7 @@ xchk_bmap_btree(
 	int			error;
 
 	/* Load the incore bmap cache if it's not loaded. */
-	info->was_loaded = ifp->if_flags & XFS_IFEXTENTS;
+	info->was_loaded = !xfs_need_iread_extents(ifp);
 
 	error = xfs_iread_extents(sc->tp, ip, whichfork);
 	if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
@@ -673,10 +673,6 @@ xchk_bmap(
 		/* No mappings to check. */
 		goto out;
 	case XFS_DINODE_FMT_EXTENTS:
-		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-			xchk_fblock_set_corrupt(sc, whichfork, 0);
-			goto out;
-		}
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if (whichfork == XFS_COW_FORK) {
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index fb66c5d20d261b..9b08db45ce8549 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -291,8 +291,7 @@ xfs_map_blocks(
 	cow_fsb = NULLFILEOFF;
 	whichfork = XFS_DATA_FORK;
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
-	       (ip->i_df.if_flags & XFS_IFEXTENTS));
+	ASSERT(!xfs_need_iread_extents(&ip->i_df));
 
 	/*
 	 * Check if this is offset is covered by a COW extents, and if yes use
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 1c7116abff0d69..a5e9d7d34023f2 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -554,7 +554,7 @@ xfs_bmap_punch_delalloc_range(
 	struct xfs_iext_cursor	icur;
 	int			error = 0;
 
-	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
+	ASSERT(!xfs_need_iread_extents(ifp));
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
@@ -625,7 +625,7 @@ xfs_can_free_eofblocks(
 		return false;
 
 	/* If we haven't read in the extent list, then don't do it now. */
-	if (!(ip->i_df.if_flags & XFS_IFEXTENTS))
+	if (xfs_need_iread_extents(&ip->i_df))
 		return false;
 
 	/*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fa2d377e251415..17c2d8b18283c9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -111,8 +111,7 @@ xfs_ilock_data_map_shared(
 {
 	uint			lock_mode = XFS_ILOCK_SHARED;
 
-	if (ip->i_df.if_format == XFS_DINODE_FMT_BTREE &&
-	    (ip->i_df.if_flags & XFS_IFEXTENTS) == 0)
+	if (xfs_need_iread_extents(&ip->i_df))
 		lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lock_mode);
 	return lock_mode;
@@ -124,9 +123,7 @@ xfs_ilock_attr_map_shared(
 {
 	uint			lock_mode = XFS_ILOCK_SHARED;
 
-	if (ip->i_afp &&
-	    ip->i_afp->if_format == XFS_DINODE_FMT_BTREE &&
-	    (ip->i_afp->if_flags & XFS_IFEXTENTS) == 0)
+	if (ip->i_afp && xfs_need_iread_extents(ip->i_afp))
 		lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lock_mode);
 	return lock_mode;
@@ -843,7 +840,6 @@ xfs_init_new_inode(
 	case S_IFBLK:
 	case S_IFSOCK:
 		ip->i_df.if_format = XFS_DINODE_FMT_DEV;
-		ip->i_df.if_flags = 0;
 		flags |= XFS_ILOG_DEV;
 		break;
 	case S_IFREG:
@@ -855,7 +851,6 @@ xfs_init_new_inode(
 		/* FALLTHROUGH */
 	case S_IFLNK:
 		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
-		ip->i_df.if_flags = XFS_IFEXTENTS;
 		ip->i_df.if_bytes = 0;
 		ip->i_df.if_u1.if_root = NULL;
 		break;
@@ -875,7 +870,6 @@ xfs_init_new_inode(
 	if (init_xattrs && xfs_sb_version_hasattr(&mp->m_sb)) {
 		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
-		ip->i_afp->if_flags = XFS_IFEXTENTS;
 	}
 
 	/*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 708b77341a703f..bf490bfae6cbb1 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1126,7 +1126,7 @@ xfs_fill_fsxattr(
 	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		fa->fsx_cowextsize = XFS_FSB_TO_B(mp, ip->i_cowextsize);
 	fa->fsx_projid = ip->i_projid;
-	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
+	if (ifp && !xfs_need_iread_extents(ifp))
 		fa->fsx_nextents = xfs_iext_count(ifp);
 	else
 		fa->fsx_nextents = xfs_ifork_nextents(ifp);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d37d42e554a12b..d154f42e2dc684 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -159,7 +159,7 @@ xfs_iomap_eof_align_last_fsb(
 	struct xfs_bmbt_irec	irec;
 	struct xfs_iext_cursor	icur;
 
-	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
+	ASSERT(!xfs_need_iread_extents(ifp));
 
 	/*
 	 * Always round up the allocation request to the extent hint boundary.
@@ -667,7 +667,7 @@ xfs_ilock_for_iomap(
 	 * is an opencoded xfs_ilock_data_map_shared() call but with
 	 * non-blocking behaviour.
 	 */
-	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
+	if (xfs_need_iread_extents(&ip->i_df)) {
 		if (flags & IOMAP_NOWAIT)
 			return -EAGAIN;
 		mode = XFS_ILOCK_EXCL;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index d4b3567d87943f..b4fa702823834b 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -377,7 +377,7 @@ xfs_inactive_symlink_rmt(
 	xfs_trans_t	*tp;
 
 	mp = ip->i_mount;
-	ASSERT(ip->i_df.if_flags & XFS_IFEXTENTS);
+	ASSERT(!xfs_need_iread_extents(&ip->i_df));
 	/*
 	 * We're freeing a symlink that has some
 	 * blocks allocated to it.  Free the
-- 
2.30.1

