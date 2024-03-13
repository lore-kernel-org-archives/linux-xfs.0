Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CD479C5
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294627; cv=none; b=TC8Rv7YliIkFVphaatlopMvLaHzZVtj3jS3ejE80YH6SyPd8KlPBkd7x3PYAAdHM9K65esYzkZosCy3zhNGzbDyI3vzKohxO6cD1hQ4jbEO3B/RczbCkD/KtJDIG6Sm0hvOaff4xjlEiD6q7R0eUFcyL6JcmURIm7KEehAUHb0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294627; c=relaxed/simple;
	bh=xbafNRKUjEKK7F7sS1wBML2gveAXtsu+IjZpE5J4jGo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lxF7ZG1tKsW8wDO7HzHD1UGCYQBxkhsv51wDZqMlAfY279bItBASmZsaBCw7Jj55VsWpMaDxmL6iDoYPQs/JbYa4phNT5zpNSgYkNsEopVbOZ/tfgdoP8AQCOhbvlBG799u16qoRokbNtEJd0Ml60A7IjDdtIEdmSjIcew+oZa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h7rTp0AG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h7rTp0AG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A86C433C7;
	Wed, 13 Mar 2024 01:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294627;
	bh=xbafNRKUjEKK7F7sS1wBML2gveAXtsu+IjZpE5J4jGo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h7rTp0AGDhEeBist/Hkj/wkQNCqynXOSrxExa7HAadooCg+Mxy5rLMJuQhdc+VEcp
	 p3wcDdXKZpA6iJ77hKHYh3wp+JHajnokyYjridgaQeJvlIiQjKHgTz/7OpZ1Lsoeho
	 hnjh85a4VA0e9TAR8jXOBkfGxhVITyMmS5+/S2INb0vHuoHcIGdBeaRE5+OcFOWpnK
	 lweWBDB6KixGfGXnD0sPfY+20djHM8So3HBD9ybFvumwZ8bPSz/s0YUrMzR5x0f0Zn
	 5/Qvj2rJJfuOq4taqLiqXLTuSE6QyVTSjZrV+iiNLfm2tUSFOX2rD0Vw9wvwkTQELA
	 B61N95hcs9VgA==
Date: Tue, 12 Mar 2024 18:50:26 -0700
Subject: [PATCH 03/13] xfs_repair: fix confusing rt space units in the
 duplicate detection code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029430600.2061422.15290444691248517445.stgit@frogsfrogsfrogs>
In-Reply-To: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

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
 4 files changed, 59 insertions(+), 58 deletions(-)


diff --git a/repair/incore.c b/repair/incore.c
index 10a8c2a8c9fe..bf6ef72fd5ff 100644
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
index 8a1a39ec60c2..02031dc17adb 100644
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
@@ -157,11 +157,8 @@ int		add_dup_extent(xfs_agnumber_t agno, xfs_agblock_t startblock,
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
index 7292f5dcc483..a8f5370bee1b 100644
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
index 61e5500631a5..7b9f20e32a55 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -250,7 +250,7 @@ void
 phase4(xfs_mount_t *mp)
 {
 	ino_tree_node_t		*irec;
-	xfs_rtblock_t		bno;
+	xfs_rtblock_t		rtx;
 	xfs_rtblock_t		rt_start;
 	xfs_extlen_t		rt_len;
 	xfs_agnumber_t		i;
@@ -331,14 +331,14 @@ phase4(xfs_mount_t *mp)
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
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
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

