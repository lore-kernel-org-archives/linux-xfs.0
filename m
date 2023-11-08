Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6736C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 19:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjKHTUx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 14:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjKHTUw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 14:20:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48B6210E
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 11:20:49 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62938C433C7;
        Wed,  8 Nov 2023 19:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699471249;
        bh=jb/wIHuoYKpnR+mT0kZMrjy/zWMF5DRN/hTxx8H7gPE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YFOZd3fxhMGuq7hOsdZS6EgFc7v0p06o/+fZYIWkt+GWRRjtfn13g0N0NOZkPpEiq
         YccRqAes1/bZuuTOQ16DJjM3gSan5GiU/CgP3uRjH3F3MwIaitkQnO1Qdi3s/0T+8i
         HNOVwCwKmYwbS/1usYkEKHavE8vEFbYQfrDf1qgABuTUGi5zxh6oa0A0P07x7VChtI
         rOo7UnVVFVoc0o+fNtHsWQigU9/pYUdgWrFt05DUr4VpP3pSma4w7+BIGfcBBvRzGp
         L3pX7QyYy438HbaaQ9AVaWm2LjRPHZpdn5oFCy0BsAl0U+jyeGG49ik7a7Q5Z5OBN4
         /yXr4gPm4VKiA==
Date:   Wed, 8 Nov 2023 11:20:48 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] repair: fix process_rt_rec_dups
Message-ID: <20231108192048.GX1205143@frogsfrogsfrogs>
References: <20231108175320.500847-1-hch@lst.de>
 <20231108180827.GW1205143@frogsfrogsfrogs>
 <20231108182101.GA17121@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231108182101.GA17121@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2023 at 07:21:01PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 08, 2023 at 10:08:27AM -0800, Darrick J. Wong wrote:
> > On Wed, Nov 08, 2023 at 06:53:20PM +0100, Christoph Hellwig wrote:
> > > search_rt_dup_extent takes a xfs_rtblock_t, not an RT extent number.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > > 
> > > What scares me about this is that no test seems to hit this and report
> > > false duplicates.  I'll need to see if I can come up with an
> > > artifical reproducers of some kind.
> > 
> > I think you've misread the code -- phase 4 builds the rt_dup tree by
> > walks all the rtextents, and adding the duplicates:
> 
> Hmm.
> 
> So yes, add_rt_dup_extent seems to be called on an actual rtext, but
> scan_bmapbt calls search_rt_dup_extent with what is clearly
> a fsbno_t.   So something is fishy here for sure..

Yes, I just noticed that scam_bmapbt thing.  Yikes.

> > So I think the reason why you've never seen false duplicates is that the
> > rt_dup tree intervals measure rt extents, not rt blocks.  The units
> > conversion in process_rt_rec_dups is correct.
> 
> Note that I don't see error with the patch either, so either way the
> coverage isn't good enough..

Correct.  The scan_bmapbt query is in units of rtblocks.  For
rextsize==1 there's no error here; for rextsize > 2, the
search_rt_dup_extent queries probe well past the end of the rt_ext_tree
structure, so they never find the duplicate extents.

This /does/ explain why the one time I tried crosslinking rt extents I
was surprised that xfs_repair didn't seem to detect them consistently.

Hmm, let me go clean all that up in to a TOTALLY UNTESTED patch.

--D

From: Darrick J. Wong <djwong@kernel.org>
Subject: [PATCH] xfs_repair: fix confusing rt space units in the duplicate detection code

Christoph Hellwig stumbled over the crosslinked file data detection code
in xfs_repair.  While trying to make sense of his fixpatch, I realized
that the variable names and unit types are very misleading.

The rt dup tree builder inserts records in units of realtime extents.
One query of the rt dup tree passes in a realtime extent number, but one
of them does not.  Confusingly, all the variable names have "block" even
though they really mean "extent".  This makes a real difference for
rextsize > 1 filesystems, though given the lack of complaints I'm
guessing there aren't many users.

Clean up this whole mess by fixing the variable names of the duplicates
tree and the state array to reflect the units that are stored in the
data structure, and fix the buggy query code.  Later on in this patchset
we'll fix the variable types too.

This seems to have been broken since before the start of the git repo.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/incore.c     |   16 ++++++-----
 repair/incore.h     |   15 ++++------
 repair/incore_ext.c |   74 +++++++++++++++++++++++++++------------------------
 repair/phase4.c     |   12 ++++----
 repair/scan.c       |    6 +++-
 5 files changed, 63 insertions(+), 60 deletions(-)

diff --git a/repair/incore.c b/repair/incore.c
index f7a89e70d91..7f4a52bf7de 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -178,21 +178,21 @@ static size_t		rt_bmap_size;
  */
 int
 get_rtbmap(
-	xfs_rtblock_t	bno)
+	xfs_rtblock_t	rtx)
 {
-	return (*(rt_bmap + bno /  XR_BB_NUM) >>
-		((bno % XR_BB_NUM) * XR_BB)) & XR_BB_MASK;
+	return (*(rt_bmap + rtx /  XR_BB_NUM) >>
+		((rtx % XR_BB_NUM) * XR_BB)) & XR_BB_MASK;
 }
 
 void
 set_rtbmap(
-	xfs_rtblock_t	bno,
+	xfs_rtblock_t	rtx,
 	int		state)
 {
-	*(rt_bmap + bno / XR_BB_NUM) =
-	 ((*(rt_bmap + bno / XR_BB_NUM) &
-	  (~((uint64_t) XR_BB_MASK << ((bno % XR_BB_NUM) * XR_BB)))) |
-	 (((uint64_t) state) << ((bno % XR_BB_NUM) * XR_BB)));
+	*(rt_bmap + rtx / XR_BB_NUM) =
+	 ((*(rt_bmap + rtx / XR_BB_NUM) &
+	  (~((uint64_t) XR_BB_MASK << ((rtx % XR_BB_NUM) * XR_BB)))) |
+	 (((uint64_t) state) << ((rtx % XR_BB_NUM) * XR_BB)));
 }
 
 static void
diff --git a/repair/incore.h b/repair/incore.h
index 53609f683af..7e9bc127f45 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -28,8 +28,8 @@ void		set_bmap_ext(xfs_agnumber_t agno, xfs_agblock_t agbno,
 int		get_bmap_ext(xfs_agnumber_t agno, xfs_agblock_t agbno,
 			     xfs_agblock_t maxbno, xfs_extlen_t *blen);
 
-void		set_rtbmap(xfs_rtblock_t bno, int state);
-int		get_rtbmap(xfs_rtblock_t bno);
+void		set_rtbmap(xfs_rtblock_t rtx, int state);
+int		get_rtbmap(xfs_rtblock_t rtx);
 
 static inline void
 set_bmap(xfs_agnumber_t agno, xfs_agblock_t agbno, int state)
@@ -70,8 +70,8 @@ typedef struct extent_tree_node  {
 
 typedef struct rt_extent_tree_node  {
 	avlnode_t		avl_node;
-	xfs_rtblock_t		rt_startblock;	/* starting realtime block */
-	xfs_extlen_t		rt_blockcount;	/* number of blocks in extent */
+	xfs_rtblock_t		rt_startrtx;	/* starting rt extent number */
+	xfs_extlen_t		rt_rtxlen;	/* number of rt extents */
 	extent_state_t		rt_state;	/* see state flags below */
 
 #if 0
@@ -164,11 +164,8 @@ int		add_dup_extent(xfs_agnumber_t agno, xfs_agblock_t startblock,
 			xfs_extlen_t blockcount);
 int		search_dup_extent(xfs_agnumber_t agno,
 			xfs_agblock_t start_agbno, xfs_agblock_t end_agbno);
-void		add_rt_dup_extent(xfs_rtblock_t	startblock,
-				xfs_extlen_t	blockcount);
-
-int		search_rt_dup_extent(xfs_mount_t	*mp,
-					xfs_rtblock_t	bno);
+void		add_rt_dup_extent(xfs_rtblock_t startrtx, xfs_extlen_t rtxlen);
+int		search_rt_dup_extent(struct xfs_mount *mp, xfs_rtblock_t rtx);
 
 /*
  * extent/tree recyling and deletion routines
diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index 7292f5dcc48..a8f5370bee1 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -532,18 +532,20 @@ static avlops_t avl_extent_tree_ops = {
  * startblocks can be 64-bit values.
  */
 static rt_extent_tree_node_t *
-mk_rt_extent_tree_nodes(xfs_rtblock_t new_startblock,
-	xfs_extlen_t new_blockcount, extent_state_t new_state)
+mk_rt_extent_tree_nodes(
+	xfs_rtblock_t			new_startrtx,
+	xfs_extlen_t			new_rtxlen,
+	extent_state_t			new_state)
 {
-	rt_extent_tree_node_t *new;
+	struct rt_extent_tree_node	*new;
 
 	new = malloc(sizeof(*new));
 	if (!new)
 		do_error(_("couldn't allocate new extent descriptor.\n"));
 
 	new->avl_node.avl_nextino = NULL;
-	new->rt_startblock = new_startblock;
-	new->rt_blockcount = new_blockcount;
+	new->rt_startrtx = new_startrtx;
+	new->rt_rtxlen = new_rtxlen;
 	new->rt_state = new_state;
 	return new;
 }
@@ -600,24 +602,25 @@ free_rt_dup_extent_tree(xfs_mount_t *mp)
  * add a duplicate real-time extent
  */
 void
-add_rt_dup_extent(xfs_rtblock_t startblock, xfs_extlen_t blockcount)
+add_rt_dup_extent(
+	xfs_rtblock_t			startrtx,
+	xfs_extlen_t			rtxlen)
 {
-	rt_extent_tree_node_t *first, *last, *ext, *next_ext;
-	xfs_rtblock_t new_startblock;
-	xfs_extlen_t new_blockcount;
+	struct rt_extent_tree_node	*first, *last, *ext, *next_ext;
+	xfs_rtblock_t			new_startrtx;
+	xfs_extlen_t			new_rtxlen;
 
 	pthread_mutex_lock(&rt_ext_tree_lock);
-	avl64_findranges(rt_ext_tree_ptr, startblock - 1,
-		startblock + blockcount + 1,
-		(avl64node_t **) &first, (avl64node_t **) &last);
+	avl64_findranges(rt_ext_tree_ptr, startrtx - 1,
+			startrtx + rtxlen + 1,
+			(avl64node_t **) &first, (avl64node_t **) &last);
 	/*
 	 * find adjacent and overlapping extent blocks
 	 */
 	if (first == NULL && last == NULL)  {
 		/* nothing, just make and insert new extent */
 
-		ext = mk_rt_extent_tree_nodes(startblock,
-				blockcount, XR_E_MULT);
+		ext = mk_rt_extent_tree_nodes(startrtx, rtxlen, XR_E_MULT);
 
 		if (avl64_insert(rt_ext_tree_ptr,
 				(avl64node_t *) ext) == NULL)  {
@@ -634,8 +637,8 @@ add_rt_dup_extent(xfs_rtblock_t startblock, xfs_extlen_t blockcount)
 	 * find the new composite range, delete old extent nodes
 	 * as we go
 	 */
-	new_startblock = startblock;
-	new_blockcount = blockcount;
+	new_startrtx = startrtx;
+	new_rtxlen = rtxlen;
 
 	for (ext = first;
 		ext != (rt_extent_tree_node_t *) last->avl_node.avl_nextino;
@@ -647,33 +650,32 @@ add_rt_dup_extent(xfs_rtblock_t startblock, xfs_extlen_t blockcount)
 		/*
 		 * just bail if the new extent is contained within an old one
 		 */
-		if (ext->rt_startblock <= startblock &&
-				ext->rt_blockcount >= blockcount) {
+		if (ext->rt_startrtx <= startrtx &&
+		    ext->rt_rtxlen >= rtxlen) {
 			pthread_mutex_unlock(&rt_ext_tree_lock);
 			return;
 		}
 		/*
 		 * now check for overlaps and adjacent extents
 		 */
-		if (ext->rt_startblock + ext->rt_blockcount >= startblock
-			|| ext->rt_startblock <= startblock + blockcount)  {
+		if (ext->rt_startrtx + ext->rt_rtxlen >= startrtx ||
+		    ext->rt_startrtx <= startrtx + rtxlen)  {
 
-			if (ext->rt_startblock < new_startblock)
-				new_startblock = ext->rt_startblock;
+			if (ext->rt_startrtx < new_startrtx)
+				new_startrtx = ext->rt_startrtx;
 
-			if (ext->rt_startblock + ext->rt_blockcount >
-					new_startblock + new_blockcount)
-				new_blockcount = ext->rt_startblock +
-							ext->rt_blockcount -
-							new_startblock;
+			if (ext->rt_startrtx + ext->rt_rtxlen >
+					new_startrtx + new_rtxlen)
+				new_rtxlen = ext->rt_startrtx +
+							ext->rt_rtxlen -
+							new_startrtx;
 
 			avl64_delete(rt_ext_tree_ptr, (avl64node_t *) ext);
 			continue;
 		}
 	}
 
-	ext = mk_rt_extent_tree_nodes(new_startblock,
-				new_blockcount, XR_E_MULT);
+	ext = mk_rt_extent_tree_nodes(new_startrtx, new_rtxlen, XR_E_MULT);
 
 	if (avl64_insert(rt_ext_tree_ptr, (avl64node_t *) ext) == NULL)  {
 		do_error(_("duplicate extent range\n"));
@@ -688,12 +690,14 @@ add_rt_dup_extent(xfs_rtblock_t startblock, xfs_extlen_t blockcount)
  */
 /* ARGSUSED */
 int
-search_rt_dup_extent(xfs_mount_t *mp, xfs_rtblock_t bno)
+search_rt_dup_extent(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtx)
 {
-	int ret;
+	int			ret;
 
 	pthread_mutex_lock(&rt_ext_tree_lock);
-	if (avl64_findrange(rt_ext_tree_ptr, bno) != NULL)
+	if (avl64_findrange(rt_ext_tree_ptr, rtx) != NULL)
 		ret = 1;
 	else
 		ret = 0;
@@ -704,14 +708,14 @@ search_rt_dup_extent(xfs_mount_t *mp, xfs_rtblock_t bno)
 static uint64_t
 avl64_rt_ext_start(avl64node_t *node)
 {
-	return(((rt_extent_tree_node_t *) node)->rt_startblock);
+	return(((rt_extent_tree_node_t *) node)->rt_startrtx);
 }
 
 static uint64_t
 avl64_ext_end(avl64node_t *node)
 {
-	return(((rt_extent_tree_node_t *) node)->rt_startblock +
-		((rt_extent_tree_node_t *) node)->rt_blockcount);
+	return(((rt_extent_tree_node_t *) node)->rt_startrtx +
+		((rt_extent_tree_node_t *) node)->rt_rtxlen);
 }
 
 static avl64ops_t avl64_extent_tree_ops = {
diff --git a/repair/phase4.c b/repair/phase4.c
index 28ecf56f45b..93adff1786f 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -229,7 +229,7 @@ void
 phase4(xfs_mount_t *mp)
 {
 	ino_tree_node_t		*irec;
-	xfs_rtblock_t		bno;
+	xfs_rtblock_t		rtx;
 	xfs_rtblock_t		rt_start;
 	xfs_extlen_t		rt_len;
 	xfs_agnumber_t		i;
@@ -330,14 +330,14 @@ phase4(xfs_mount_t *mp)
 	rt_start = 0;
 	rt_len = 0;
 
-	for (bno = 0; bno < mp->m_sb.sb_rextents; bno++)  {
-		bstate = get_rtbmap(bno);
+	for (rtx = 0; rtx < mp->m_sb.sb_rextents; rtx++)  {
+		bstate = get_rtbmap(rtx);
 		switch (bstate)  {
 		case XR_E_BAD_STATE:
 		default:
 			do_warn(
 	_("unknown rt extent state, extent %" PRIu64 "\n"),
-				bno);
+				rtx);
 			fallthrough;
 		case XR_E_METADATA:
 		case XR_E_UNKNOWN:
@@ -360,14 +360,14 @@ phase4(xfs_mount_t *mp)
 			break;
 		case XR_E_MULT:
 			if (rt_start == 0)  {
-				rt_start = bno;
+				rt_start = rtx;
 				rt_len = 1;
 			} else if (rt_len == XFS_MAX_BMBT_EXTLEN)  {
 				/*
 				 * large extent case
 				 */
 				add_rt_dup_extent(rt_start, rt_len);
-				rt_start = bno;
+				rt_start = rtx;
 				rt_len = 1;
 			} else
 				rt_len++;
diff --git a/repair/scan.c b/repair/scan.c
index 9a5edb40c25..c91f4c3fe71 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -418,8 +418,10 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 					XFS_FSB_TO_AGBNO(mp, bno),
 					XFS_FSB_TO_AGBNO(mp, bno) + 1))
 				return(1);
-		} else  {
-			if (search_rt_dup_extent(mp, bno))
+		} else {
+			xfs_rtblock_t	rtx = bno / mp->m_sb.sb_rextsize;
+
+			if (search_rt_dup_extent(mp, rtx))
 				return(1);
 		}
 	}
