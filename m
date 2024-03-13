Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D018C1E
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294674; cv=none; b=oy3ESJFZZ+UwDJm7NnyUZf7LGx8KH611bmhAmmKZ+jh/dQlnGscgDTtKSpzLvyQGkJUktEU2/kpPzunIKC0zT85vzMfVakUfiCSIRfS9/A1+PBKpZtYDKXDpdjg8C7lA4wcds5Q5pp+UTQQh5LiqY64/y8H2FPzY3E12X83T8Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294674; c=relaxed/simple;
	bh=LCl5/1f7C2PFYU6POIAiqVuk5d97eomOiJ3gxpOSpKw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YwVBG2Qql7KqnvppczLe5UQ5Ra/to4dRr2ZeD6kK9CUgmXzhtmd5/TLG8pvZsYS6/WJRgmq3CWk6e5lmmYqNxw8DuPpMasPpgmSIphYGE09M0gSuil3qDvwCsrX8ih7EUADTheO20aWw1SwV8gvmR+DASKFpsR+xClZuPkYRYiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xw7RFt/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xw7RFt/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024A7C433C7;
	Wed, 13 Mar 2024 01:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294674;
	bh=LCl5/1f7C2PFYU6POIAiqVuk5d97eomOiJ3gxpOSpKw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xw7RFt/SWDFpQ4m6cDjW8y3tfkDHRmse7P4L8rj6GD6qGnOlUkq+/PKGOp3S0oXyh
	 8Y3J+swrwNGYsdwkeJKBRsvbT5d0cY0vSvX838D7gw75YPJqd90JfblpTJskcdhj1i
	 czQROQnPraqZYH2/ctS/6c2EhLCTduwJE3zHtUMyKCTKUBmt3meI+qkpQVJAlDdidb
	 h9wkFMqINfzCDLEpuMoxsp7jiuTE5no8XR5G9bx9S6wm/1nEcwlIpI/XZZkPvFALkW
	 Xaf6NgWxwPGYpcUGZwKVVkuvrUg0ezyEFMhSjiwOcTMjDAX8qbpSdrkSTjj/hgNA9h
	 lHmSqOUAlImpQ==
Date: Tue, 12 Mar 2024 18:51:13 -0700
Subject: [PATCH 06/13] xfs_repair: convert utility to use new rt extent
 helpers and types
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029430643.2061422.11374848731173937406.stgit@frogsfrogsfrogs>
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

Convert the repair program to use the new realtime extent types and
helper functions instead of open-coding them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

