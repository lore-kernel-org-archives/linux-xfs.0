Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729D0EAF1
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610109; cv=none; b=VFfOYaGF38rC+K3/6yVJ7y1SaOw7nwgm5WXfxl0SXKwe6mv3Mr1ZIvlaCoBU54V4GJDO5wMORuKBrVaq8X5yWj9WcvnxbQwfbrgRC5ngdskp6P43/peYJPgNb/FEOJZHZpvLLOcL97I0ufZRRvVWXxxbh5/XJWZkvwY2uHDT/BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610109; c=relaxed/simple;
	bh=8oawtkRLAJEoehkDRz0BxopGs8Jz1Xb+gdyjOmhrvsg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sEtOnmXs6detzeJ5QgDfnUHq6d4Uy95jrZJfq2Ct6u/Zut7j1RbHuyEZSYobzOnhpgJJjgT6NnpP1Yi2HBaMmJKtjVZra1hPQKHG5fDe2i70y4xPDkidahJV4gmNsbCuB5yNyWR5E5s+NYhi2eo88ek/yn8wB9rwouEyCIkmt44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpK+unNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpK+unNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF68C4CEC5;
	Fri, 11 Oct 2024 01:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610109;
	bh=8oawtkRLAJEoehkDRz0BxopGs8Jz1Xb+gdyjOmhrvsg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dpK+unNYKxUnaNLoBIACBsvbuSlRr5F04XDc2xzVvtOZSFFizvu4Qs6EIiFabHyYb
	 r2N5YUPlN4J+A0r2rqOTOW4lPBcAuPZbgjqKPqe4tBcuPjNX5UC2RNoqhTvCQ2rhd4
	 /uB9Pz6J6pj0OvVKjLVv0qQomnwG5HhsH/W0ywnm7mjPUUohpCrAaLqhYQOaH5a8e6
	 FUG0XMd2ClFXKRX9wmjI8s+Dh1gleSzsUzcFqWStVWooWfcN3keLVQ0ECRl/dN6W2z
	 llR6ZU3yGPATv6GU2LzS1/7dxBVGFXUaBP6NE3j/S0dgIjcOTDcufUwfAtQsAumTpg
	 2+rUPsPlLtGfQ==
Date: Thu, 10 Oct 2024 18:28:28 -0700
Subject: [PATCH 15/43] repair: use a separate bmaps array for real time groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655597.4184637.2997555318248558854.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Stop pretending RTGs are high numbered AGs and just use separate
structures instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 
 repair/dino_chunks.c     |   12 +++--
 repair/dinode.c          |   26 ++++------
 repair/incore.c          |  117 +++++++++++++++++++++++++++++-----------------
 repair/incore.h          |   35 ++++++++++----
 repair/phase2.c          |    2 -
 repair/phase4.c          |   16 ++++--
 repair/phase5.c          |    2 -
 repair/rt.c              |    5 +-
 repair/scan.c            |   28 ++++++-----
 10 files changed, 148 insertions(+), 96 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 0675324cfaf6d2..f44ab84236eb75 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -290,6 +290,7 @@
 #define xfs_rtsummary_create		libxfs_rtsummary_create
 
 #define xfs_rtgroup_alloc		libxfs_rtgroup_alloc
+#define xfs_rtgroup_extents		libxfs_rtgroup_extents
 #define xfs_rtgroup_grab		libxfs_rtgroup_grab
 #define xfs_rtgroup_rele		libxfs_rtgroup_rele
 
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index c29cbc0874f833..1c3512d00fbe6b 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -428,7 +428,8 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	for (cur_agbno = chunk_start_agbno;
 	     cur_agbno < chunk_stop_agbno;
 	     cur_agbno += blen)  {
-		state = get_bmap_ext(agno, cur_agbno, chunk_stop_agbno, &blen);
+		state = get_bmap_ext(agno, cur_agbno, chunk_stop_agbno, &blen,
+				false);
 		switch (state) {
 		case XR_E_MULT:
 		case XR_E_INUSE:
@@ -437,7 +438,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 			do_warn(
 	_("inode block %d/%d multiply claimed, (state %d)\n"),
 				agno, cur_agbno, state);
-			set_bmap_ext(agno, cur_agbno, blen, XR_E_MULT);
+			set_bmap_ext(agno, cur_agbno, blen, XR_E_MULT, false);
 			unlock_ag(agno);
 			return 0;
 		case XR_E_METADATA:
@@ -477,7 +478,8 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	for (cur_agbno = chunk_start_agbno;
 	     cur_agbno < chunk_stop_agbno;
 	     cur_agbno += blen)  {
-		state = get_bmap_ext(agno, cur_agbno, chunk_stop_agbno, &blen);
+		state = get_bmap_ext(agno, cur_agbno, chunk_stop_agbno, &blen,
+				false);
 		switch (state) {
 		case XR_E_INO:
 			do_error(
@@ -497,7 +499,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
-			set_bmap_ext(agno, cur_agbno, blen, XR_E_INO);
+			set_bmap_ext(agno, cur_agbno, blen, XR_E_INO, false);
 			break;
 		case XR_E_MULT:
 		case XR_E_INUSE:
@@ -511,7 +513,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 			do_warn(
 		_("inode block %d/%d bad state, (state %d)\n"),
 				agno, cur_agbno, state);
-			set_bmap_ext(agno, cur_agbno, blen, XR_E_INO);
+			set_bmap_ext(agno, cur_agbno, blen, XR_E_INO, false);
 			break;
 		}
 	}
diff --git a/repair/dinode.c b/repair/dinode.c
index 4dbe0305c9e88e..1f4a7e4d7da365 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -548,15 +548,8 @@ _("Fatal error: inode %" PRIu64 " - blkmap_set_ext(): %s\n"
 			}
 		}
 
-		/*
-		 * XXX: For rtgroup enabled file systems we treat the RTGs as
-		 * basically another set of AGs tacked on at the end, but
-		 * otherwise reuse all the existing code.  That's why we'll
-		 * see odd "agno" value here.
-		 */
 		if (isrt) {
-			agno = mp->m_sb.sb_agcount +
-				xfs_rtb_to_rgno(mp, irec.br_startblock);
+			agno = xfs_rtb_to_rgno(mp, irec.br_startblock);
 			first_agbno = xfs_rtb_to_rgbno(mp, irec.br_startblock);
 		} else {
 			agno = XFS_FSB_TO_AGNO(mp, irec.br_startblock);
@@ -566,9 +559,9 @@ _("Fatal error: inode %" PRIu64 " - blkmap_set_ext(): %s\n"
 		ebno = first_agbno + irec.br_blockcount;
 		if (agno != locked_agno) {
 			if (locked_agno != -1)
-				unlock_ag(locked_agno);
+				unlock_group(locked_agno, isrt);
 			locked_agno = agno;
-			lock_ag(locked_agno);
+			lock_group(locked_agno, isrt);
 		}
 
 		/*
@@ -578,7 +571,7 @@ _("Fatal error: inode %" PRIu64 " - blkmap_set_ext(): %s\n"
 		for (b = irec.br_startblock;
 		     agbno < ebno;
 		     b += blen, agbno += blen) {
-			state = get_bmap_ext(agno, agbno, ebno, &blen);
+			state = get_bmap_ext(agno, agbno, ebno, &blen, isrt);
 			switch (state)  {
 			case XR_E_FREE:
 				/*
@@ -664,7 +657,7 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 		agbno = first_agbno;
 		ebno = first_agbno + irec.br_blockcount;
 		for (; agbno < ebno; agbno += blen) {
-			state = get_bmap_ext(agno, agbno, ebno, &blen);
+			state = get_bmap_ext(agno, agbno, ebno, &blen, isrt);
 			switch (state)  {
 			case XR_E_METADATA:
 				/*
@@ -679,15 +672,16 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 			case XR_E_FREE1:
 			case XR_E_INUSE1:
 			case XR_E_UNKNOWN:
-				set_bmap_ext(agno, agbno, blen, zap_metadata ?
-						XR_E_METADATA : XR_E_INUSE);
+				set_bmap_ext(agno, agbno, blen,
+					zap_metadata ?
+					XR_E_METADATA : XR_E_INUSE, isrt);
 				break;
 
 			case XR_E_INUSE:
 			case XR_E_MULT:
 				if (!zap_metadata)
 					set_bmap_ext(agno, agbno, blen,
-							XR_E_MULT);
+							XR_E_MULT, isrt);
 				break;
 			default:
 				break;
@@ -700,7 +694,7 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 	error = 0;
 done:
 	if (locked_agno != -1)
-		unlock_ag(locked_agno);
+		unlock_group(locked_agno, isrt);
 
 	if (i != *numrecs) {
 		ASSERT(i < *numrecs);
diff --git a/repair/incore.c b/repair/incore.c
index bab9b74bf922c8..2339d49a95773d 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -29,28 +29,42 @@ struct bmap {
 	struct btree_root	*root;
 };
 static struct bmap	*ag_bmaps;
+static struct bmap	*rtg_bmaps;
+
+static inline struct bmap *bmap_for_group(xfs_agnumber_t gno, bool isrt)
+{
+	if (isrt)
+		return &rtg_bmaps[gno];
+	return &ag_bmaps[gno];
+}
 
 void
-lock_ag(
-	xfs_agnumber_t		agno)
+lock_group(
+	xfs_agnumber_t		gno,
+	bool			isrt)
 {
-	pthread_mutex_lock(&ag_bmaps[agno].lock);
+	pthread_mutex_lock(&bmap_for_group(gno, isrt)->lock);
 }
 
 void
-unlock_ag(
-	xfs_agnumber_t		agno)
+unlock_group(
+	xfs_agnumber_t		gno,
+	bool			isrt)
 {
-	pthread_mutex_unlock(&ag_bmaps[agno].lock);
+	pthread_mutex_unlock(&bmap_for_group(gno, isrt)->lock);
 }
 
-static void
-update_bmap(
-	struct btree_root	*bmap,
-	unsigned long		offset,
+
+void
+set_bmap_ext(
+	xfs_agnumber_t		gno,
+	xfs_agblock_t		offset,
 	xfs_extlen_t		blen,
-	void			*new_state)
+	int			state,
+	bool			isrt)
 {
+	struct btree_root	*bmap = bmap_for_group(gno, isrt)->root;
+	void			*new_state = &states[state];
 	unsigned long		end = offset + blen;
 	int			*cur_state;
 	unsigned long		cur_key;
@@ -140,24 +154,15 @@ update_bmap(
 	btree_insert(bmap, end, prev_state);
 }
 
-void
-set_bmap_ext(
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		agbno,
-	xfs_extlen_t		blen,
-	int			state)
-{
-	update_bmap(ag_bmaps[agno].root, agbno, blen, &states[state]);
-}
-
 int
 get_bmap_ext(
-	xfs_agnumber_t		agno,
+	xfs_agnumber_t		gno,
 	xfs_agblock_t		agbno,
 	xfs_agblock_t		maxbno,
-	xfs_extlen_t		*blen)
+	xfs_extlen_t		*blen,
+	bool			isrt)
 {
-	struct btree_root	*bmap = ag_bmaps[agno].root;
+	struct btree_root	*bmap = bmap_for_group(gno, isrt)->root;
 	int			*statep;
 	unsigned long		key;
 
@@ -248,16 +253,15 @@ free_rt_bmap(xfs_mount_t *mp)
 	free(rt_bmap);
 	rt_bmap = NULL;
 	pthread_mutex_destroy(&rt_lock);
-
 }
 
-void
-reset_bmaps(xfs_mount_t *mp)
+static void
+reset_ag_bmaps(
+	struct xfs_mount	*mp)
 {
-	unsigned int	nr_groups = mp->m_sb.sb_agcount + mp->m_sb.sb_rgcount;
-	unsigned int	agno;
-	xfs_agblock_t	ag_size;
-	int		ag_hdr_block;
+	int			ag_hdr_block;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		ag_size;
 
 	ag_hdr_block = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
 	ag_size = mp->m_sb.sb_agblocks;
@@ -287,13 +291,20 @@ reset_bmaps(xfs_mount_t *mp)
 		btree_insert(bmap, ag_hdr_block, &states[XR_E_UNKNOWN]);
 		btree_insert(bmap, ag_size, &states[XR_E_BAD_STATE]);
 	}
+}
 
-	for ( ; agno < nr_groups; agno++) {
-		struct btree_root	*bmap = ag_bmaps[agno].root;
+static void
+reset_rtg_bmaps(
+	struct xfs_mount	*mp)
+{
+	xfs_rgnumber_t		rgno;
+
+	for (rgno = 0 ; rgno < mp->m_sb.sb_rgcount; rgno++) {
+		struct btree_root	*bmap = rtg_bmaps[rgno].root;
 		uint64_t		rblocks;
 
 		btree_clear(bmap);
-		if (agno == mp->m_sb.sb_agcount && xfs_has_rtsb(mp)) {
+		if (rgno == 0 && xfs_has_rtsb(mp)) {
 			btree_insert(bmap, 0, &states[XR_E_INUSE_FS]);
 			btree_insert(bmap, mp->m_sb.sb_rextsize,
 					&states[XR_E_FREE]);
@@ -302,18 +313,28 @@ reset_bmaps(xfs_mount_t *mp)
 		}
 
 		rblocks = xfs_rtbxlen_to_blen(mp,
-				xfs_rtgroup_extents(mp,
-					(agno - mp->m_sb.sb_agcount)));
+				libxfs_rtgroup_extents(mp, rgno));
 		btree_insert(bmap, rblocks, &states[XR_E_BAD_STATE]);
 	}
+}
+
+void
+reset_bmaps(
+	struct xfs_mount	*mp)
+{
+	reset_ag_bmaps(mp);
 
 	if (mp->m_sb.sb_logstart != 0) {
 		set_bmap_ext(XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart),
 			     XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart),
-			     mp->m_sb.sb_logblocks, XR_E_INUSE_FS);
+			     mp->m_sb.sb_logblocks, XR_E_INUSE_FS, false);
 	}
 
-	reset_rt_bmap();
+	if (xfs_has_rtgroups(mp)) {
+		reset_rtg_bmaps(mp);
+	} else {
+		reset_rt_bmap();
+	}
 }
 
 static struct bmap *
@@ -354,11 +375,18 @@ void
 init_bmaps(
 	struct xfs_mount	*mp)
 {
-	ag_bmaps = alloc_bmaps(mp->m_sb.sb_agcount + mp->m_sb.sb_rgcount);
+	ag_bmaps = alloc_bmaps(mp->m_sb.sb_agcount);
 	if (!ag_bmaps)
 		do_error(_("couldn't allocate block map btree roots\n"));
 
-	init_rt_bmap(mp);
+	if (xfs_has_rtgroups(mp)) {
+		rtg_bmaps = alloc_bmaps(mp->m_sb.sb_rgcount);
+		if (!rtg_bmaps)
+			do_error(_("couldn't allocate block map btree roots\n"));
+	} else {
+		init_rt_bmap(mp);
+	}
+
 	reset_bmaps(mp);
 }
 
@@ -366,8 +394,13 @@ void
 free_bmaps(
 	struct xfs_mount	*mp)
 {
-	destroy_bmaps(ag_bmaps, mp->m_sb.sb_agcount + mp->m_sb.sb_rgcount);
+	destroy_bmaps(ag_bmaps, mp->m_sb.sb_agcount);
 	ag_bmaps = NULL;
 
-	free_rt_bmap(mp);
+	if (xfs_has_rtgroups(mp)) {
+		destroy_bmaps(rtg_bmaps, mp->m_sb.sb_rgcount);
+		rtg_bmaps = NULL;
+	} else {
+		free_rt_bmap(mp);
+	}
 }
diff --git a/repair/incore.h b/repair/incore.h
index ea55c25087dc1a..61730c330911f7 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -23,29 +23,46 @@ void		init_bmaps(xfs_mount_t *mp);
 void		reset_bmaps(xfs_mount_t *mp);
 void		free_bmaps(xfs_mount_t *mp);
 
-void		lock_ag(xfs_agnumber_t agno);
-void		unlock_ag(xfs_agnumber_t agno);
+void		lock_group(xfs_agnumber_t agno, bool isrt);
+void		unlock_group(xfs_agnumber_t agno, bool isrt);
+
+static inline void lock_ag(xfs_agnumber_t agno)
+{
+	lock_group(agno, false);
+}
+
+static inline void unlock_ag(xfs_agnumber_t agno)
+{
+	unlock_group(agno, false);
+}
 
 void		set_bmap_ext(xfs_agnumber_t agno, xfs_agblock_t agbno,
-			     xfs_extlen_t blen, int state);
+			     xfs_extlen_t blen, int state, bool isrt);
 int		get_bmap_ext(xfs_agnumber_t agno, xfs_agblock_t agbno,
-			     xfs_agblock_t maxbno, xfs_extlen_t *blen);
-
-void		set_rtbmap(xfs_rtxnum_t rtx, int state);
-int		get_rtbmap(xfs_rtxnum_t rtx);
+			     xfs_agblock_t maxbno, xfs_extlen_t *blen,
+			     bool isrt);
 
 static inline void
 set_bmap(xfs_agnumber_t agno, xfs_agblock_t agbno, int state)
 {
-	set_bmap_ext(agno, agbno, 1, state);
+	set_bmap_ext(agno, agbno, 1, state, false);
 }
 
 static inline int
 get_bmap(xfs_agnumber_t agno, xfs_agblock_t agbno)
 {
-	return get_bmap_ext(agno, agbno, agbno + 1, NULL);
+	return get_bmap_ext(agno, agbno, agbno + 1, NULL, false);
 }
 
+static inline int
+get_rgbmap(xfs_rgnumber_t rgno, xfs_rgblock_t rgbno)
+{
+	return get_bmap_ext(rgno, rgbno, rgbno + 1, NULL, true);
+}
+
+void		set_rtbmap(xfs_rtxnum_t rtx, int state);
+int		get_rtbmap(xfs_rtxnum_t rtx);
+
 /*
  * extent tree definitions
  * right now, there are 3 trees per AG, a bno tree, a bcnt tree
diff --git a/repair/phase2.c b/repair/phase2.c
index d2f7f544d0e579..27c873fca76747 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -568,7 +568,7 @@ phase2(
 		 * also mark blocks
 		 */
 		set_bmap_ext(0, XFS_INO_TO_AGBNO(mp, sb->sb_rootino),
-			     M_IGEO(mp)->ialloc_blks, XR_E_INO);
+			     M_IGEO(mp)->ialloc_blks, XR_E_INO, false);
 	} else  {
 		do_log(_("        - found root inode chunk\n"));
 		j = 0;
diff --git a/repair/phase4.c b/repair/phase4.c
index e93178465991c2..3a627d8aeea85a 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -295,15 +295,17 @@ process_dup_rt_extents(
  */
 static void
 process_dup_extents(
+	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
-	xfs_agblock_t		ag_end)
+	xfs_agblock_t		ag_end,
+	bool			isrt)
 {
 	do {
 		int		bstate;
 		xfs_extlen_t	blen;
 
-		bstate = get_bmap_ext(agno, agbno, ag_end, &blen);
+		bstate = get_bmap_ext(agno, agbno, ag_end, &blen, isrt);
 		switch (bstate) {
 		case XR_E_FREE1:
 			if (no_modify)
@@ -320,7 +322,8 @@ _("free space (%u,%u-%u) only seen by one free space btree\n"),
 		case XR_E_FS_MAP:
 			break;
 		case XR_E_MULT:
-			add_dup_extent(agno, agbno, blen);
+			add_dup_extent(agno + isrt ? mp->m_sb.sb_agcount : 0,
+					agbno, blen);
 			break;
 		case XR_E_BAD_STATE:
 		default:
@@ -389,7 +392,7 @@ phase4(xfs_mount_t *mp)
 			mp->m_sb.sb_dblocks -
 				(xfs_rfsblock_t) mp->m_sb.sb_agblocks * i;
 
-		process_dup_extents(i, ag_hdr_block, ag_end);
+		process_dup_extents(mp, i, ag_hdr_block, ag_end, false);
 
 		PROG_RPT_INC(prog_rpt_done[i], 1);
 	}
@@ -400,9 +403,8 @@ phase4(xfs_mount_t *mp)
 			uint64_t	rblocks;
 
 			rblocks = xfs_rtbxlen_to_blen(mp,
-					xfs_rtgroup_extents(mp, i));
-			process_dup_extents(mp->m_sb.sb_agcount + i, 0,
-					rblocks);
+					libxfs_rtgroup_extents(mp, i));
+			process_dup_extents(mp, i, 0, rblocks, true);
 		}
 	} else {
 		process_dup_rt_extents(mp);
diff --git a/repair/phase5.c b/repair/phase5.c
index 91c4a8662a69f2..ac5f04697b7110 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -72,7 +72,7 @@ mk_incore_fstree(
 	 * largest extent.
 	 */
 	for (agbno = 0; agbno < ag_end; agbno += blen) {
-		bstate = get_bmap_ext(agno, agbno, ag_end, &blen);
+		bstate = get_bmap_ext(agno, agbno, ag_end, &blen, false);
 		if (bstate < XR_E_INUSE)  {
 			free_blocks += blen;
 			if (in_extent == 0)  {
diff --git a/repair/rt.c b/repair/rt.c
index f034e925965f75..2de6830c931e86 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -58,7 +58,6 @@ generate_rtgroup_rtinfo(
 {
 	struct rtg_computed	*comp = &rt_computed[rtg_rgno(rtg)];
 	struct xfs_mount	*mp = rtg_mount(rtg);
-	unsigned int		idx = mp->m_sb.sb_agcount + rtg_rgno(rtg);
 	unsigned int		bitsperblock =
 		mp->m_blockwsize << XFS_NBWORDLOG;
 	xfs_rtxnum_t		extno = 0;
@@ -100,11 +99,11 @@ _("couldn't allocate memory for incore realtime summary info.\n"));
 
 			/*
 			 * Note: for the RTG case it might make sense to use
-			 * get_bmap_ext here and generate multiple bitmap
+			 * get_rgbmap_ext here and generate multiple bitmap
 			 * entries per lookup.
 			 */
 			if (xfs_has_rtgroups(mp))
-				state = get_bmap(idx,
+				state = get_rgbmap(rtg_rgno(rtg),
 					extno * mp->m_sb.sb_rextsize);
 			else
 				state = get_rtbmap(extno);
diff --git a/repair/scan.c b/repair/scan.c
index 8b118423ce0457..221d660e81fdb4 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -724,10 +724,11 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 			}
 
 			for ( ; b < end; b += blen)  {
-				state = get_bmap_ext(agno, b, end, &blen);
+				state = get_bmap_ext(agno, b, end, &blen, false);
 				switch (state) {
 				case XR_E_UNKNOWN:
-					set_bmap_ext(agno, b, blen, XR_E_FREE1);
+					set_bmap_ext(agno, b, blen, XR_E_FREE1,
+							false);
 					break;
 				case XR_E_FREE1:
 					/*
@@ -737,7 +738,7 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 					if (magic == XFS_ABTC_MAGIC ||
 					    magic == XFS_ABTC_CRC_MAGIC) {
 						set_bmap_ext(agno, b, blen,
-							     XR_E_FREE);
+							     XR_E_FREE, false);
 						break;
 					}
 					fallthrough;
@@ -841,27 +842,27 @@ process_rmap_rec(
 		switch (owner) {
 		case XFS_RMAP_OWN_FS:
 		case XFS_RMAP_OWN_LOG:
-			set_bmap_ext(agno, b, blen, XR_E_INUSE_FS1);
+			set_bmap_ext(agno, b, blen, XR_E_INUSE_FS1, false);
 			break;
 		case XFS_RMAP_OWN_AG:
 		case XFS_RMAP_OWN_INOBT:
-			set_bmap_ext(agno, b, blen, XR_E_FS_MAP1);
+			set_bmap_ext(agno, b, blen, XR_E_FS_MAP1, false);
 			break;
 		case XFS_RMAP_OWN_INODES:
-			set_bmap_ext(agno, b, blen, XR_E_INO1);
+			set_bmap_ext(agno, b, blen, XR_E_INO1, false);
 			break;
 		case XFS_RMAP_OWN_REFC:
-			set_bmap_ext(agno, b, blen, XR_E_REFC);
+			set_bmap_ext(agno, b, blen, XR_E_REFC, false);
 			break;
 		case XFS_RMAP_OWN_COW:
-			set_bmap_ext(agno, b, blen, XR_E_COW);
+			set_bmap_ext(agno, b, blen, XR_E_COW, false);
 			break;
 		case XFS_RMAP_OWN_NULL:
 			/* still unknown */
 			break;
 		default:
 			/* file data */
-			set_bmap_ext(agno, b, blen, XR_E_INUSE1);
+			set_bmap_ext(agno, b, blen, XR_E_INUSE1, false);
 			break;
 		}
 		break;
@@ -1207,7 +1208,8 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 
 			/* Check for block owner collisions. */
 			for ( ; b < end; b += blen)  {
-				state = get_bmap_ext(agno, b, end, &blen);
+				state = get_bmap_ext(agno, b, end, &blen,
+						false);
 				process_rmap_rec(mp, agno, b, end, blen, owner,
 						state, name);
 			}
@@ -1483,14 +1485,16 @@ _("leftover CoW extent has invalid startblock in record %u of %s btree block %u/
 				xfs_extlen_t	cnr;
 
 				for (c = agb; c < end; c += cnr) {
-					state = get_bmap_ext(agno, c, end, &cnr);
+					state = get_bmap_ext(agno, c, end, &cnr,
+							false);
 					switch (state) {
 					case XR_E_UNKNOWN:
 					case XR_E_COW:
 						do_warn(
 _("leftover CoW extent (%u/%u) len %u\n"),
 						agno, c, cnr);
-						set_bmap_ext(agno, c, cnr, XR_E_FREE);
+						set_bmap_ext(agno, c, cnr,
+							XR_E_FREE, false);
 						break;
 					default:
 						do_warn(

