Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F65128387
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422060; cv=none; b=i8/TOYkjl0CZwJBiFgX94+lxb0FuUaUxHx2ygCoP6pZLRDV5pobXiALJo0izF5MqIbwYDjr3MTmQXN+kddrCtUMP9Piu6e4IYwiMhvTmA88ZICpXSaGDVqpO3ytTCGWgC2hyCcYRbfYP66VyagHtB49CdLS5EYY+VXytpkKm4fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422060; c=relaxed/simple;
	bh=0BKKaG6ERiCKDZEi5xwEF1DKWhF5rybjg6k/pxGu6go=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zl+mBqev4wzrPEDZIaj9PeqczwBCBRf6sbQ85ywgEx4OpWVjMX6LUfIjFOv7Yvj861GD3sZP91PKf6XqVeQ8tQ9pb6zU7CNhM4CNzdJIWR5WWSKQrySKa0EDNiymac6+eXo6jnRSmn0I2RSBDtoGjOzDsinW8nnGkb/jybcNVDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bS6LPrlB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bS6LPrlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53537C43394;
	Tue, 26 Mar 2024 03:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422060;
	bh=0BKKaG6ERiCKDZEi5xwEF1DKWhF5rybjg6k/pxGu6go=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bS6LPrlBJBCHFGxVd3jueRMR51SZ3mQZZlt1hySUfHYwHkDb+Jt86n9yaez3bg3Tx
	 G7Vm+BBtk5qxdHxssImFyF1aCzzF3EeveyXFO7yib8OrZ8gNw2JDB00My0SS9JnofP
	 xOsV+/EILNpB2qACDTOoB3JBDSopz8OVLVYj2YiAxDi7mEsv9pUcJSIxOR6zqFxKkV
	 UFOLsgvwn7aOn4mi8Rxfed3DDUP9Ie8uIcU1wNaQrKphVxIjVe8z9NAGLZACHJG6oQ
	 ERs6Ww0jbipHguL+EDJlKZxGDJh+7FjXK0F9aWSrMxLV/4RfLc+Bs2zymWQCgYC5ZI
	 x1sstJiuD5Egw==
Date: Mon, 25 Mar 2024 20:00:59 -0700
Subject: [PATCH 06/13] xfs_repair: convert utility to use new rt extent
 helpers and types
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142126395.2211955.9889919696328997788.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
References: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
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

Convert the repair program to use the new realtime extent types and
helper functions instead of open-coding them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 db/check.c          |    2 +-
 repair/agheader.h   |    2 +-
 repair/dinode.c     |   21 ++++++++++++---------
 repair/incore.c     |    4 ++--
 repair/incore.h     |   12 ++++++------
 repair/incore_ext.c |   14 +++++++-------
 repair/phase4.c     |    6 +++---
 repair/rt.c         |    4 ++--
 repair/scan.c       |    2 +-
 9 files changed, 35 insertions(+), 32 deletions(-)


diff --git a/db/check.c b/db/check.c
index a47a5d9cb5b4..6e06499b9eb3 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3594,7 +3594,7 @@ process_rtbitmap(
 	int		bitsperblock;
 	xfs_fileoff_t	bmbno;
 	xfs_fsblock_t	bno;
-	xfs_rtblock_t	extno;
+	xfs_rtxnum_t	extno;
 	int		len;
 	int		log;
 	int		offs;
diff --git a/repair/agheader.h b/repair/agheader.h
index a63827c87259..b4f81d553790 100644
--- a/repair/agheader.h
+++ b/repair/agheader.h
@@ -11,7 +11,7 @@ typedef struct fs_geometry  {
 	uint32_t	sb_blocksize;	/* blocksize (bytes) */
 	xfs_rfsblock_t	sb_dblocks;	/* # data blocks */
 	xfs_rfsblock_t	sb_rblocks;	/* # realtime blocks */
-	xfs_rtblock_t	sb_rextents;	/* # realtime extents */
+	xfs_rtxnum_t	sb_rextents;	/* # realtime extents */
 	xfs_fsblock_t	sb_logstart;	/* starting log block # */
 	xfs_agblock_t	sb_rextsize;	/* realtime extent size (blocks )*/
 	xfs_agblock_t	sb_agblocks;	/* # of blocks per ag */
diff --git a/repair/dinode.c b/repair/dinode.c
index c10dd1fa3225..c1cfadc8833e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -193,13 +193,13 @@ process_rt_rec_dups(
 	xfs_ino_t		ino,
 	struct xfs_bmbt_irec	*irec)
 {
-	xfs_fsblock_t		b;
-	xfs_rtblock_t		ext;
+	xfs_rtblock_t		b;
+	xfs_rtxnum_t		ext;
 
-	for (b = rounddown(irec->br_startblock, mp->m_sb.sb_rextsize);
+	for (b = xfs_rtb_rounddown_rtx(mp, irec->br_startblock);
 	     b < irec->br_startblock + irec->br_blockcount;
 	     b += mp->m_sb.sb_rextsize) {
-		ext = (xfs_rtblock_t) b / mp->m_sb.sb_rextsize;
+		ext = xfs_rtb_to_rtx(mp, b);
 		if (search_rt_dup_extent(mp, ext))  {
 			do_warn(
 _("data fork in rt ino %" PRIu64 " claims dup rt extent,"
@@ -222,14 +222,17 @@ process_rt_rec_state(
 	struct xfs_bmbt_irec	*irec)
 {
 	xfs_fsblock_t		b = irec->br_startblock;
-	xfs_rtblock_t		ext;
+	xfs_rtxnum_t		ext;
 	int			state;
 
 	do {
-		ext = (xfs_rtblock_t)b / mp->m_sb.sb_rextsize;
+		xfs_extlen_t	mod;
+
+		ext = xfs_rtb_to_rtx(mp, b);
 		state = get_rtbmap(ext);
 
-		if ((b % mp->m_sb.sb_rextsize) != 0) {
+		mod = xfs_rtb_to_rtxoff(mp, b);
+		if (mod) {
 			/*
 			 * We are midway through a partially written extent.
 			 * If we don't find the state that gets set in the
@@ -240,7 +243,7 @@ process_rt_rec_state(
 				do_error(
 _("data fork in rt inode %" PRIu64 " found invalid rt extent %"PRIu64" state %d at rt block %"PRIu64"\n"),
 					ino, ext, state, b);
-			b = roundup(b, mp->m_sb.sb_rextsize);
+			b = xfs_rtb_roundup_rtx(mp, b);
 			continue;
 		}
 
@@ -2232,7 +2235,7 @@ validate_extsize(
 	 */
 	if ((flags & XFS_DIFLAG_EXTSZINHERIT) &&
 	    (flags & XFS_DIFLAG_RTINHERIT) &&
-	    value % mp->m_sb.sb_rextsize > 0)
+	    xfs_extlen_to_rtxmod(mp, value) > 0)
 		misaligned = true;
 
 	/*
diff --git a/repair/incore.c b/repair/incore.c
index bf6ef72fd5ff..2ed37a105ca7 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -178,7 +178,7 @@ static size_t		rt_bmap_size;
  */
 int
 get_rtbmap(
-	xfs_rtblock_t	rtx)
+	xfs_rtxnum_t	rtx)
 {
 	return (*(rt_bmap + rtx /  XR_BB_NUM) >>
 		((rtx % XR_BB_NUM) * XR_BB)) & XR_BB_MASK;
@@ -186,7 +186,7 @@ get_rtbmap(
 
 void
 set_rtbmap(
-	xfs_rtblock_t	rtx,
+	xfs_rtxnum_t	rtx,
 	int		state)
 {
 	*(rt_bmap + rtx / XR_BB_NUM) =
diff --git a/repair/incore.h b/repair/incore.h
index 02031dc17adb..9ad5f1972d3d 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -28,8 +28,8 @@ void		set_bmap_ext(xfs_agnumber_t agno, xfs_agblock_t agbno,
 int		get_bmap_ext(xfs_agnumber_t agno, xfs_agblock_t agbno,
 			     xfs_agblock_t maxbno, xfs_extlen_t *blen);
 
-void		set_rtbmap(xfs_rtblock_t rtx, int state);
-int		get_rtbmap(xfs_rtblock_t rtx);
+void		set_rtbmap(xfs_rtxnum_t rtx, int state);
+int		get_rtbmap(xfs_rtxnum_t rtx);
 
 static inline void
 set_bmap(xfs_agnumber_t agno, xfs_agblock_t agbno, int state)
@@ -70,8 +70,8 @@ typedef struct extent_tree_node  {
 
 typedef struct rt_extent_tree_node  {
 	avlnode_t		avl_node;
-	xfs_rtblock_t		rt_startrtx;	/* starting rt extent number */
-	xfs_extlen_t		rt_rtxlen;	/* number of rt extents */
+	xfs_rtxnum_t		rt_startrtx;	/* starting rt extent number */
+	xfs_rtxlen_t		rt_rtxlen;	/* number of rt extents */
 	extent_state_t		rt_state;	/* see state flags below */
 
 #if 0
@@ -157,8 +157,8 @@ int		add_dup_extent(xfs_agnumber_t agno, xfs_agblock_t startblock,
 			xfs_extlen_t blockcount);
 int		search_dup_extent(xfs_agnumber_t agno,
 			xfs_agblock_t start_agbno, xfs_agblock_t end_agbno);
-void		add_rt_dup_extent(xfs_rtblock_t startrtx, xfs_extlen_t rtxlen);
-int		search_rt_dup_extent(struct xfs_mount *mp, xfs_rtblock_t rtx);
+void		add_rt_dup_extent(xfs_rtxnum_t startrtx, xfs_rtxlen_t rtxlen);
+int		search_rt_dup_extent(struct xfs_mount *mp, xfs_rtxnum_t rtx);
 
 /*
  * extent/tree recyling and deletion routines
diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index a8f5370bee1b..59c5d6f502c3 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -533,8 +533,8 @@ static avlops_t avl_extent_tree_ops = {
  */
 static rt_extent_tree_node_t *
 mk_rt_extent_tree_nodes(
-	xfs_rtblock_t			new_startrtx,
-	xfs_extlen_t			new_rtxlen,
+	xfs_rtxnum_t			new_startrtx,
+	xfs_rtxlen_t			new_rtxlen,
 	extent_state_t			new_state)
 {
 	struct rt_extent_tree_node	*new;
@@ -603,12 +603,12 @@ free_rt_dup_extent_tree(xfs_mount_t *mp)
  */
 void
 add_rt_dup_extent(
-	xfs_rtblock_t			startrtx,
-	xfs_extlen_t			rtxlen)
+	xfs_rtxnum_t			startrtx,
+	xfs_rtxlen_t			rtxlen)
 {
 	struct rt_extent_tree_node	*first, *last, *ext, *next_ext;
-	xfs_rtblock_t			new_startrtx;
-	xfs_extlen_t			new_rtxlen;
+	xfs_rtxnum_t			new_startrtx;
+	xfs_rtxlen_t			new_rtxlen;
 
 	pthread_mutex_lock(&rt_ext_tree_lock);
 	avl64_findranges(rt_ext_tree_ptr, startrtx - 1,
@@ -692,7 +692,7 @@ add_rt_dup_extent(
 int
 search_rt_dup_extent(
 	struct xfs_mount	*mp,
-	xfs_rtblock_t		rtx)
+	xfs_rtxnum_t		rtx)
 {
 	int			ret;
 
diff --git a/repair/phase4.c b/repair/phase4.c
index 7b9f20e32a55..e4c0e616ffd0 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -250,9 +250,9 @@ void
 phase4(xfs_mount_t *mp)
 {
 	ino_tree_node_t		*irec;
-	xfs_rtblock_t		rtx;
-	xfs_rtblock_t		rt_start;
-	xfs_extlen_t		rt_len;
+	xfs_rtxnum_t		rtx;
+	xfs_rtxnum_t		rt_start;
+	xfs_rtxlen_t		rt_len;
 	xfs_agnumber_t		i;
 	xfs_agblock_t		j;
 	xfs_agblock_t		ag_end;
diff --git a/repair/rt.c b/repair/rt.c
index 9f3bc8d53ec6..8f3b9082a9b8 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -48,8 +48,8 @@ generate_rtinfo(xfs_mount_t	*mp,
 		xfs_rtword_t	*words,
 		xfs_suminfo_t	*sumcompute)
 {
-	xfs_rtblock_t	extno;
-	xfs_rtblock_t	start_ext;
+	xfs_rtxnum_t	extno;
+	xfs_rtxnum_t	start_ext;
 	int		bitsperblock;
 	int		bmbno;
 	xfs_rtword_t	freebit;
diff --git a/repair/scan.c b/repair/scan.c
index 7a0587615cb9..0a77dd67913b 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -402,7 +402,7 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 					XFS_FSB_TO_AGBNO(mp, bno) + 1))
 				return(1);
 		} else  {
-			xfs_rtblock_t	ext = bno / mp->m_sb.sb_rextsize;
+			xfs_rtxnum_t	ext = xfs_rtb_to_rtx(mp, bno);
 
 			if (search_rt_dup_extent(mp, ext))
 				return 1;

