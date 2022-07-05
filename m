Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8BECCA47B
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 22:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbiGEWJq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 18:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGEWJp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 18:09:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C5B1AF23
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 15:09:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF960B819A8
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 22:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52265C341C7;
        Tue,  5 Jul 2022 22:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657058980;
        bh=Erk7sWIRdSAOZVXjSPnMkvVG5BfywLKsZ/c92Ff17yY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CfKzIiOT1tx5aIPQ2LSo0Z9G+UBkYuB70Nu0j9R2pm+zGW8EZsitw9TV+FK+sdvlc
         HzPaSHdsOcN5XXJczpMj4l6fIJbGMuRI5EQnfmLCRzGBARhYruho7uJZ65OBSmK29z
         w6EzhVF3VE9pb6Fpxr/t6FDwJSiJ5GVJu7uBOsN/LV/Qy2b46Sx4idPLj9Lx2vdwqy
         T/ngruQYid/A9ahDmHSDUm8xATx7eY6xm0ia8RBrfWCJP7uUqXx5bK/z0RcKM2TT/O
         aejKRTDbKM7erJAKZMKSRMb8C/jmzkAeJLeiqOIWTfjMCl9PxGPdKBxjXzARQvzJ5T
         FZLyvThENsz0Q==
Subject: [PATCH 1/3] xfs: convert XFS_IFORK_PTR to a static inline helper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Tue, 05 Jul 2022 15:09:39 -0700
Message-ID: <165705897986.2826746.460304038463142580.stgit@magnolia>
In-Reply-To: <165705897408.2826746.14673631830829415034.stgit@magnolia>
References: <165705897408.2826746.14673631830829415034.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We're about to make this logic do a bit more, so convert the macro to a
static inline function for better typechecking and fewer shouty macros.
No functional changes here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c      |    2 +
 fs/xfs/libxfs/xfs_bmap.c           |   68 ++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_bmap_btree.c     |    8 ++--
 fs/xfs/libxfs/xfs_btree.c          |    4 +-
 fs/xfs/libxfs/xfs_dir2_block.c     |    2 +
 fs/xfs/libxfs/xfs_dir2_sf.c        |    2 +
 fs/xfs/libxfs/xfs_inode_fork.c     |   16 ++++----
 fs/xfs/libxfs/xfs_inode_fork.h     |    6 ---
 fs/xfs/libxfs/xfs_symlink_remote.c |    2 +
 fs/xfs/scrub/bmap.c                |   14 ++++---
 fs/xfs/scrub/dabtree.c             |    2 +
 fs/xfs/scrub/dir.c                 |    2 +
 fs/xfs/scrub/quota.c               |    2 +
 fs/xfs/scrub/symlink.c             |    2 +
 fs/xfs/xfs_bmap_util.c             |    4 +-
 fs/xfs/xfs_dir2_readdir.c          |    2 +
 fs/xfs/xfs_icache.c                |    2 +
 fs/xfs/xfs_inode.c                 |    6 ++-
 fs/xfs/xfs_inode.h                 |   18 ++++++++++
 fs/xfs/xfs_ioctl.c                 |    2 +
 fs/xfs/xfs_iomap.c                 |    4 +-
 fs/xfs/xfs_qm.c                    |    2 +
 fs/xfs/xfs_reflink.c               |    6 ++-
 23 files changed, 95 insertions(+), 83 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 8f47396f8dd2..d3670877143f 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1056,7 +1056,7 @@ xfs_attr_shortform_verify(
 	int64_t				size;
 
 	ASSERT(ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL);
-	ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
+	ifp = xfs_ifork_ptr(ip, XFS_ATTR_FORK);
 	sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	size = ifp->if_bytes;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6833110d1bd4..50d48c3b8e4e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -128,7 +128,7 @@ xfs_bmbt_lookup_first(
  */
 static inline bool xfs_bmap_needs_btree(struct xfs_inode *ip, int whichfork)
 {
-	struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork *ifp = xfs_ifork_ptr(ip, whichfork);
 
 	return whichfork != XFS_COW_FORK &&
 		ifp->if_format == XFS_DINODE_FMT_EXTENTS &&
@@ -140,7 +140,7 @@ static inline bool xfs_bmap_needs_btree(struct xfs_inode *ip, int whichfork)
  */
 static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 {
-	struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork *ifp = xfs_ifork_ptr(ip, whichfork);
 
 	return whichfork != XFS_COW_FORK &&
 		ifp->if_format == XFS_DINODE_FMT_BTREE &&
@@ -319,7 +319,7 @@ xfs_bmap_check_leaf_extents(
 	int			whichfork)	/* data or attr fork */
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_block	*block;	/* current btree block */
 	xfs_fsblock_t		bno;	/* block # of "block" */
 	struct xfs_buf		*bp;	/* buffer for "block" */
@@ -538,7 +538,7 @@ xfs_bmap_btree_to_extents(
 	int			*logflagsp, /* inode logging flags */
 	int			whichfork)  /* data or attr fork */
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_btree_block	*rblock = ifp->if_broot;
 	struct xfs_btree_block	*cblock;/* child btree block */
@@ -616,7 +616,7 @@ xfs_bmap_extents_to_btree(
 
 	mp = ip->i_mount;
 	ASSERT(whichfork != XFS_COW_FORK);
-	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ifp = xfs_ifork_ptr(ip, whichfork);
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_EXTENTS);
 
 	/*
@@ -745,7 +745,7 @@ xfs_bmap_local_to_extents_empty(
 	struct xfs_inode	*ip,
 	int			whichfork)
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 
 	ASSERT(whichfork != XFS_COW_FORK);
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
@@ -785,7 +785,7 @@ xfs_bmap_local_to_extents(
 	 * So sending the data fork of a regular inode is invalid.
 	 */
 	ASSERT(!(S_ISREG(VFS_I(ip)->i_mode) && whichfork == XFS_DATA_FORK));
-	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ifp = xfs_ifork_ptr(ip, whichfork);
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 
 	if (!ifp->if_bytes) {
@@ -1116,7 +1116,7 @@ xfs_iread_bmbt_block(
 	xfs_extnum_t		num_recs;
 	xfs_extnum_t		j;
 	int			whichfork = cur->bc_ino.whichfork;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 
 	block = xfs_btree_get_block(cur, level, &bp);
 
@@ -1164,7 +1164,7 @@ xfs_iread_extents(
 	int			whichfork)
 {
 	struct xfs_iread_state	ir;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_btree_cur	*cur;
 	int			error;
@@ -1208,7 +1208,7 @@ xfs_bmap_first_unused(
 	xfs_fileoff_t		*first_unused,	/* unused block */
 	int			whichfork)	/* data or attr fork */
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_bmbt_irec	got;
 	struct xfs_iext_cursor	icur;
 	xfs_fileoff_t		lastaddr = 0;
@@ -1255,7 +1255,7 @@ xfs_bmap_last_before(
 	xfs_fileoff_t		*last_block,	/* last block */
 	int			whichfork)	/* data or attr fork */
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_bmbt_irec	got;
 	struct xfs_iext_cursor	icur;
 	int			error;
@@ -1289,7 +1289,7 @@ xfs_bmap_last_extent(
 	struct xfs_bmbt_irec	*rec,
 	int			*is_empty)
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_iext_cursor	icur;
 	int			error;
 
@@ -1355,7 +1355,7 @@ xfs_bmap_last_offset(
 	xfs_fileoff_t		*last_block,
 	int			whichfork)
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_bmbt_irec	rec;
 	int			is_empty;
 	int			error;
@@ -1389,7 +1389,7 @@ xfs_bmap_add_extent_delay_real(
 	int			whichfork)
 {
 	struct xfs_mount	*mp = bma->ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(bma->ip, whichfork);
 	struct xfs_bmbt_irec	*new = &bma->got;
 	int			error;	/* error return value */
 	int			i;	/* temp state */
@@ -1955,7 +1955,7 @@ xfs_bmap_add_extent_unwritten_real(
 	*logflagsp = 0;
 
 	cur = *curp;
-	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ifp = xfs_ifork_ptr(ip, whichfork);
 
 	ASSERT(!isnullstartblock(new->br_startblock));
 
@@ -2480,7 +2480,7 @@ xfs_bmap_add_extent_hole_delay(
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	xfs_filblks_t		temp;	 /* temp for indirect calculations */
 
-	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ifp = xfs_ifork_ptr(ip, whichfork);
 	ASSERT(isnullstartblock(new->br_startblock));
 
 	/*
@@ -2616,7 +2616,7 @@ xfs_bmap_add_extent_hole_real(
 	int			*logflagsp,
 	uint32_t		flags)
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_btree_cur	*cur = *curp;
 	int			error;	/* error return value */
@@ -3866,7 +3866,7 @@ xfs_bmapi_read(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	int			whichfork = xfs_bmapi_whichfork(flags);
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_bmbt_irec	got;
 	xfs_fileoff_t		obno;
 	xfs_fileoff_t		end;
@@ -3959,7 +3959,7 @@ xfs_bmapi_reserve_delalloc(
 	int			eof)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
 	int			error;
@@ -4086,7 +4086,7 @@ xfs_bmapi_allocate(
 {
 	struct xfs_mount	*mp = bma->ip->i_mount;
 	int			whichfork = xfs_bmapi_whichfork(bma->flags);
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(bma->ip, whichfork);
 	int			tmp_logflags = 0;
 	int			error;
 
@@ -4185,7 +4185,7 @@ xfs_bmapi_convert_unwritten(
 	uint32_t		flags)
 {
 	int			whichfork = xfs_bmapi_whichfork(flags);
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(bma->ip, whichfork);
 	int			tmp_logflags = 0;
 	int			error;
 
@@ -4262,7 +4262,7 @@ xfs_bmapi_minleft(
 	struct xfs_inode	*ip,
 	int			fork)
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, fork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, fork);
 
 	if (tp && tp->t_firstblock != NULLFSBLOCK)
 		return 0;
@@ -4283,7 +4283,7 @@ xfs_bmapi_finish(
 	int			whichfork,
 	int			error)
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(bma->ip, whichfork);
 
 	if ((bma->logflags & xfs_ilog_fext(whichfork)) &&
 	    ifp->if_format != XFS_DINODE_FMT_EXTENTS)
@@ -4322,7 +4322,7 @@ xfs_bmapi_write(
 	};
 	struct xfs_mount	*mp = ip->i_mount;
 	int			whichfork = xfs_bmapi_whichfork(flags);
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	xfs_fileoff_t		end;		/* end of mapped file region */
 	bool			eof = false;	/* after the end of extents */
 	int			error;		/* error return */
@@ -4503,7 +4503,7 @@ xfs_bmapi_convert_delalloc(
 	struct iomap		*iomap,
 	unsigned int		*seq)
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	struct xfs_bmalloca	bma = { NULL };
@@ -4640,7 +4640,7 @@ xfs_bmapi_remap(
 	int			whichfork = xfs_bmapi_whichfork(flags);
 	int			logflags = 0, error;
 
-	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ifp = xfs_ifork_ptr(ip, whichfork);
 	ASSERT(len > 0);
 	ASSERT(len <= (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -4797,7 +4797,7 @@ xfs_bmap_del_extent_delay(
 	struct xfs_bmbt_irec	*del)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_bmbt_irec	new;
 	int64_t			da_old, da_new, da_diff = 0;
 	xfs_fileoff_t		del_endoff, got_endoff;
@@ -4924,7 +4924,7 @@ xfs_bmap_del_extent_cow(
 	struct xfs_bmbt_irec	*del)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
 	struct xfs_bmbt_irec	new;
 	xfs_fileoff_t		del_endoff, got_endoff;
 	uint32_t		state = BMAP_COWFORK;
@@ -5022,7 +5022,7 @@ xfs_bmap_del_extent_real(
 	mp = ip->i_mount;
 	XFS_STATS_INC(mp, xs_del_exlist);
 
-	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ifp = xfs_ifork_ptr(ip, whichfork);
 	ASSERT(del->br_blockcount > 0);
 	xfs_iext_get_extent(ifp, icur, &got);
 	ASSERT(got.br_startoff <= del->br_startoff);
@@ -5288,7 +5288,7 @@ __xfs_bunmapi(
 
 	whichfork = xfs_bmapi_whichfork(flags);
 	ASSERT(whichfork != XFS_COW_FORK);
-	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ifp = xfs_ifork_ptr(ip, whichfork);
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)))
 		return -EFSCORRUPTED;
 	if (xfs_is_shutdown(mp))
@@ -5629,7 +5629,7 @@ xfs_bmse_merge(
 	struct xfs_btree_cur		*cur,
 	int				*logflags)	/* output */
 {
-	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_bmbt_irec		new;
 	xfs_filblks_t			blockcount;
 	int				error, i;
@@ -5750,7 +5750,7 @@ xfs_bmap_collapse_extents(
 {
 	int			whichfork = XFS_DATA_FORK;
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_cur	*cur = NULL;
 	struct xfs_bmbt_irec	got, prev;
 	struct xfs_iext_cursor	icur;
@@ -5865,7 +5865,7 @@ xfs_bmap_insert_extents(
 {
 	int			whichfork = XFS_DATA_FORK;
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_cur	*cur = NULL;
 	struct xfs_bmbt_irec	got, next;
 	struct xfs_iext_cursor	icur;
@@ -5965,7 +5965,7 @@ xfs_bmap_split_extent(
 	xfs_fileoff_t		split_fsb)
 {
 	int				whichfork = XFS_DATA_FORK;
-	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_cur		*cur = NULL;
 	struct xfs_bmbt_irec		got;
 	struct xfs_bmbt_irec		new; /* split extent */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 2b77d45c215f..986ffca7f74d 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -304,7 +304,7 @@ xfs_bmbt_get_minrecs(
 	if (level == cur->bc_nlevels - 1) {
 		struct xfs_ifork	*ifp;
 
-		ifp = XFS_IFORK_PTR(cur->bc_ino.ip,
+		ifp = xfs_ifork_ptr(cur->bc_ino.ip,
 				    cur->bc_ino.whichfork);
 
 		return xfs_bmbt_maxrecs(cur->bc_mp,
@@ -322,7 +322,7 @@ xfs_bmbt_get_maxrecs(
 	if (level == cur->bc_nlevels - 1) {
 		struct xfs_ifork	*ifp;
 
-		ifp = XFS_IFORK_PTR(cur->bc_ino.ip,
+		ifp = xfs_ifork_ptr(cur->bc_ino.ip,
 				    cur->bc_ino.whichfork);
 
 		return xfs_bmbt_maxrecs(cur->bc_mp,
@@ -550,7 +550,7 @@ xfs_bmbt_init_cursor(
 	struct xfs_inode	*ip,		/* inode owning the btree */
 	int			whichfork)	/* data or attr fork */
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_cur	*cur;
 	ASSERT(whichfork != XFS_COW_FORK);
 
@@ -664,7 +664,7 @@ xfs_bmbt_change_owner(
 
 	ASSERT(tp || buffer_list);
 	ASSERT(!(tp && buffer_list));
-	ASSERT(XFS_IFORK_PTR(ip, whichfork)->if_format == XFS_DINODE_FMT_BTREE);
+	ASSERT(xfs_ifork_ptr(ip, whichfork)->if_format == XFS_DINODE_FMT_BTREE);
 
 	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
 	cur->bc_ino.flags |= XFS_BTCUR_BMBT_INVALID_OWNER;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2eecc49fc1b2..8511800a515b 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -725,7 +725,7 @@ xfs_btree_ifork_ptr(
 
 	if (cur->bc_flags & XFS_BTREE_STAGING)
 		return cur->bc_ino.ifake->if_fork;
-	return XFS_IFORK_PTR(cur->bc_ino.ip, cur->bc_ino.whichfork);
+	return xfs_ifork_ptr(cur->bc_ino.ip, cur->bc_ino.whichfork);
 }
 
 /*
@@ -3559,7 +3559,7 @@ xfs_btree_kill_iroot(
 {
 	int			whichfork = cur->bc_ino.whichfork;
 	struct xfs_inode	*ip = cur->bc_ino.ip;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_block	*block;
 	struct xfs_btree_block	*cblock;
 	union xfs_btree_key	*kp;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index df0869bba275..f5e45aa28c91 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1071,7 +1071,7 @@ xfs_dir2_sf_to_block(
 	struct xfs_trans	*tp = args->trans;
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(dp, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(dp, XFS_DATA_FORK);
 	struct xfs_da_geometry	*geo = args->geo;
 	xfs_dir2_db_t		blkno;		/* dir-relative block # (0) */
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 5a97a87eaa20..a41e2624e115 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -710,7 +710,7 @@ xfs_dir2_sf_verify(
 	struct xfs_inode		*ip)
 {
 	struct xfs_mount		*mp = ip->i_mount;
-	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
 	struct xfs_dir2_sf_hdr		*sfp;
 	struct xfs_dir2_sf_entry	*sfep;
 	struct xfs_dir2_sf_entry	*next_sfep;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1a4cdf550f6d..40016b8b00ee 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -35,7 +35,7 @@ xfs_init_local_fork(
 	const void		*data,
 	int64_t			size)
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	int			mem_size = size;
 	bool			zero_terminate;
 
@@ -102,7 +102,7 @@ xfs_iformat_extents(
 	int			whichfork)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
 	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
@@ -173,7 +173,7 @@ xfs_iformat_btree(
 	int			size;
 	int			level;
 
-	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ifp = xfs_ifork_ptr(ip, whichfork);
 	dfp = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
 	size = XFS_BMAP_BROOT_SPACE(mp, dfp);
 	nrecs = be16_to_cpu(dfp->bb_numrecs);
@@ -370,7 +370,7 @@ xfs_iroot_realloc(
 		return;
 	}
 
-	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ifp = xfs_ifork_ptr(ip, whichfork);
 	if (rec_diff > 0) {
 		/*
 		 * If there wasn't any memory allocated before, just
@@ -480,7 +480,7 @@ xfs_idata_realloc(
 	int64_t			byte_diff,
 	int			whichfork)
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	int64_t			new_size = ifp->if_bytes + byte_diff;
 
 	ASSERT(new_size >= 0);
@@ -539,7 +539,7 @@ xfs_iextents_copy(
 	int			whichfork)
 {
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_irec	rec;
 	int64_t			copied = 0;
@@ -591,7 +591,7 @@ xfs_iflush_fork(
 
 	if (!iip)
 		return;
-	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ifp = xfs_ifork_ptr(ip, whichfork);
 	/*
 	 * This can happen if we gave up in iformat in an error path,
 	 * for the attribute fork.
@@ -731,7 +731,7 @@ xfs_iext_count_may_overflow(
 	int			whichfork,
 	int			nr_to_add)
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	uint64_t		max_exts;
 	uint64_t		nr_exts;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 4f68c1f20beb..50c5fae4e35d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -81,12 +81,6 @@ struct xfs_ifork {
 #define XFS_IFORK_Q(ip)			((ip)->i_forkoff != 0)
 #define XFS_IFORK_BOFF(ip)		((int)((ip)->i_forkoff << 3))
 
-#define XFS_IFORK_PTR(ip,w)		\
-	((w) == XFS_DATA_FORK ? \
-		&(ip)->i_df : \
-		((w) == XFS_ATTR_FORK ? \
-			(ip)->i_afp : \
-			(ip)->i_cowfp))
 #define XFS_IFORK_DSIZE(ip) \
 	(XFS_IFORK_Q(ip) ? XFS_IFORK_BOFF(ip) : XFS_LITINO((ip)->i_mount))
 #define XFS_IFORK_ASIZE(ip) \
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 8b9bd178a487..bdc777b9ec4a 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -204,7 +204,7 @@ xfs_failaddr_t
 xfs_symlink_shortform_verify(
 	struct xfs_inode	*ip)
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
 	char			*sfp = (char *)ifp->if_u1.if_data;
 	int			size = ifp->if_bytes;
 	char			*endp = sfp + size;
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 285995ba3947..9fdfb4efb03d 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -377,7 +377,7 @@ xchk_bmapbt_rec(
 	struct xfs_inode	*ip = bs->cur->bc_ino.ip;
 	struct xfs_buf		*bp = NULL;
 	struct xfs_btree_block	*block;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, info->whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, info->whichfork);
 	uint64_t		owner;
 	int			i;
 
@@ -426,7 +426,7 @@ xchk_bmap_btree(
 	struct xchk_bmap_info	*info)
 {
 	struct xfs_owner_info	oinfo;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(sc->ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, whichfork);
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_inode	*ip = sc->ip;
 	struct xfs_btree_cur	*cur;
@@ -478,7 +478,7 @@ xchk_bmap_check_rmap(
 		return 0;
 
 	/* Now look up the bmbt record. */
-	ifp = XFS_IFORK_PTR(sc->ip, sbcri->whichfork);
+	ifp = xfs_ifork_ptr(sc->ip, sbcri->whichfork);
 	if (!ifp) {
 		xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 				rec->rm_offset);
@@ -563,7 +563,7 @@ xchk_bmap_check_rmaps(
 	struct xfs_scrub	*sc,
 	int			whichfork)
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(sc->ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, whichfork);
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 	bool			zero_size;
@@ -578,7 +578,7 @@ xchk_bmap_check_rmaps(
 	if (XFS_IS_REALTIME_INODE(sc->ip) && whichfork == XFS_DATA_FORK)
 		return 0;
 
-	ASSERT(XFS_IFORK_PTR(sc->ip, whichfork) != NULL);
+	ASSERT(xfs_ifork_ptr(sc->ip, whichfork) != NULL);
 
 	/*
 	 * Only do this for complex maps that are in btree format, or for
@@ -624,7 +624,7 @@ xchk_bmap(
 	struct xchk_bmap_info	info = { NULL };
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_inode	*ip = sc->ip;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	xfs_fileoff_t		endoff;
 	struct xfs_iext_cursor	icur;
 	int			error = 0;
@@ -689,7 +689,7 @@ xchk_bmap(
 
 	/* Scrub extent records. */
 	info.lastoff = 0;
-	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ifp = xfs_ifork_ptr(ip, whichfork);
 	for_each_xfs_iext(ifp, &icur, &irec) {
 		if (xchk_should_terminate(sc, &error) ||
 		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index b962cfbbd92b..84fe3d33d699 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -482,7 +482,7 @@ xchk_da_btree(
 	int				error;
 
 	/* Skip short format data structures; no btree to scan. */
-	if (!xfs_ifork_has_extents(XFS_IFORK_PTR(sc->ip, whichfork)))
+	if (!xfs_ifork_has_extents(xfs_ifork_ptr(sc->ip, whichfork)))
 		return 0;
 
 	/* Set up initial da state. */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 38897adde7b5..5abb5fdb71d9 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -667,7 +667,7 @@ xchk_directory_blocks(
 {
 	struct xfs_bmbt_irec	got;
 	struct xfs_da_args	args;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
 	struct xfs_mount	*mp = sc->mp;
 	xfs_fileoff_t		leaf_lblk;
 	xfs_fileoff_t		free_lblk;
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 3c7506c7553c..21b4c9006859 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -185,7 +185,7 @@ xchk_quota_data_fork(
 
 	/* Check for data fork problems that apply only to quota files. */
 	max_dqid_off = ((xfs_dqid_t)-1) / qi->qi_dqperchunk;
-	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+	ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
 	for_each_xfs_iext(ifp, &icur, &irec) {
 		if (xchk_should_terminate(sc, &error))
 			break;
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 599ee277bba2..0215f014e164 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -41,7 +41,7 @@ xchk_symlink(
 
 	if (!S_ISLNK(VFS_I(ip)->i_mode))
 		return -ENOENT;
-	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
 	len = ip->i_disk_size;
 
 	/* Plausible size? */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 85e1a26c92e8..1ffd5a780182 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -256,7 +256,7 @@ xfs_bmap_count_blocks(
 	xfs_filblks_t		*count)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_cur	*cur;
 	xfs_extlen_t		btblocks = 0;
 	int			error;
@@ -439,7 +439,7 @@ xfs_getbmap(
 		whichfork = XFS_COW_FORK;
 	else
 		whichfork = XFS_DATA_FORK;
-	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ifp = xfs_ifork_ptr(ip, whichfork);
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	switch (whichfork) {
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index a7174a5b3203..e295fc8062d8 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -248,7 +248,7 @@ xfs_dir2_leaf_readbuf(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf		*bp = NULL;
 	struct xfs_da_geometry	*geo = args->geo;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(dp, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(dp, XFS_DATA_FORK);
 	struct xfs_bmbt_irec	map;
 	struct blk_plug		plug;
 	xfs_dir2_off_t		new_off;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2609825d53ee..0d74d8eaff91 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1774,7 +1774,7 @@ xfs_check_delalloc(
 	struct xfs_inode	*ip,
 	int			whichfork)
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_bmbt_irec	got;
 	struct xfs_iext_cursor	icur;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3e1c62ffa4f7..308973cb4d7e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1293,8 +1293,8 @@ xfs_itruncate_clear_reflink_flags(
 
 	if (!xfs_is_reflink_inode(ip))
 		return;
-	dfork = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	cfork = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	dfork = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	cfork = xfs_ifork_ptr(ip, XFS_COW_FORK);
 	if (dfork->if_bytes == 0 && cfork->if_bytes == 0)
 		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
 	if (cfork->if_bytes == 0)
@@ -1643,7 +1643,7 @@ xfs_inode_needs_inactive(
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*cow_ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	struct xfs_ifork	*cow_ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
 
 	/*
 	 * If the inode is already free, then there can be nothing
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7be6f8e705ab..c22b01859051 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -77,6 +77,24 @@ typedef struct xfs_inode {
 	struct list_head	i_ioend_list;
 } xfs_inode_t;
 
+static inline struct xfs_ifork *
+xfs_ifork_ptr(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		return &ip->i_df;
+	case XFS_ATTR_FORK:
+		return ip->i_afp;
+	case XFS_COW_FORK:
+		return ip->i_cowfp;
+	default:
+		ASSERT(0);
+		return NULL;
+	}
+}
+
 /* Convert from vfs inode to xfs inode */
 static inline struct xfs_inode *XFS_I(struct inode *inode)
 {
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0d67ff8a8961..1178a195011d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -985,7 +985,7 @@ xfs_fill_fsxattr(
 	struct fileattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 
 	fileattr_fill_xflags(fa, xfs_ip2xflags(ip));
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 5a393259a3a3..ccd97ccd74bf 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -159,7 +159,7 @@ xfs_iomap_eof_align_last_fsb(
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		end_fsb)
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
 	xfs_extlen_t		extsz = xfs_get_extsz_hint(ip);
 	xfs_extlen_t		align = xfs_eof_alignment(ip);
 	struct xfs_bmbt_irec	irec;
@@ -370,7 +370,7 @@ xfs_iomap_prealloc_size(
 	struct xfs_iext_cursor	ncur = *icur;
 	struct xfs_bmbt_irec	prev, got;
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	int64_t			freesp;
 	xfs_fsblock_t		qblocks;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index abf08bbf34a9..60eb2d4df144 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1154,7 +1154,7 @@ xfs_qm_dqusage_adjust(
 	ASSERT(ip->i_delayed_blks == 0);
 
 	if (XFS_IS_REALTIME_INODE(ip)) {
-		struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+		struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
 
 		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
 		if (error)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e7a7c00d93be..407b1d8c1147 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -452,7 +452,7 @@ xfs_reflink_cancel_cow_blocks(
 	xfs_fileoff_t			end_fsb,
 	bool				cancel_real)
 {
-	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
 	struct xfs_bmbt_irec		got, del;
 	struct xfs_iext_cursor		icur;
 	int				error = 0;
@@ -593,7 +593,7 @@ xfs_reflink_end_cow_extent(
 	struct xfs_bmbt_irec	got, del, data;
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
 	unsigned int		resblks;
 	int			nmaps;
 	int			error;
@@ -1429,7 +1429,7 @@ xfs_reflink_inode_has_shared_extents(
 	bool				found;
 	int				error;
 
-	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
 	error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
 	if (error)
 		return error;

