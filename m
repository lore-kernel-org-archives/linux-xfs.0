Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB1CD517
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610078; cv=none; b=FlBjR6wBoHGf8d0UXcXeWB0RW0g0p+Qoy9shmf7M0wwFi6Ve3wMJdoFPum1/fb//lUoJUtsldTVr02/RVKwldZ226qKriWrp0Y8FYWyUSmN5MRfp1O980dlqK/WikFOI2evMMoYVeQgi1fb3MKKwd4Tm/QGMITrVbXwfYTNpgiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610078; c=relaxed/simple;
	bh=ZmL+lmzNsk6RQDChp/h2xcGbOcScyRJlQRcBcr+CsrU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L8p3tG8NveJul8OwdoGZYAss04dsDdKPO4f6iz6QXEitLRB1CUm+yAbNk5CTvGz/Q0rS1v26iQ2yHEdjbL86L420FRbJCmFol8aBNrf2isARQ7l+a2zxYfNnmglkR2r+L/AumJfPUnVrFhcsablzMacNPGktWkzZf9DZNGvetTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K+FZlmx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K+FZlmx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16F2C4CEC5;
	Fri, 11 Oct 2024 01:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610077;
	bh=ZmL+lmzNsk6RQDChp/h2xcGbOcScyRJlQRcBcr+CsrU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K+FZlmx9xMN8suVCc48s8xi9tiSnZuDM5w2nOMZ/+N55kBnT3tXgb15S+otj8D9OE
	 TrteCVBdFEByJA1qugWwDj20y9aSyUQj6DzLJbA14NsNSp06GFyJUoO8W11H6HfyKs
	 HZc+KgogMyhUJHEaVruCQiuLADlPrbhVghlgrZ7tS7/72uD1+hHA7pCawivvTrd3Hv
	 DBqJ9pUXQXhPMS3LcCh0rNNgvj+aiYHtnpr+zOApgsdelY6BoCE6Ybiskks1cPO2IZ
	 cmIHwulwuIw95QDWzvkIo8EHlLBDSOKgXhzr4y/YfVR1EBBQBgBF/PEq0FPLth89/K
	 iuevK+vs0u9IA==
Date: Thu, 10 Oct 2024 18:27:57 -0700
Subject: [PATCH 13/43] xfs_repair: add a real per-AG bitmap abstraction
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655565.4184637.17454186794309756711.stgit@frogsfrogsfrogs>
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

Add a struct bmap that contains the btree root and the lock, and provide
helpers for loking instead of directly poking into the data structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dino_chunks.c |   23 +++++-----
 repair/dinode.c      |    6 +--
 repair/globals.c     |    2 -
 repair/globals.h     |    4 --
 repair/incore.c      |  114 ++++++++++++++++++++++++++++++++------------------
 repair/incore.h      |    3 +
 repair/rmap.c        |    4 +-
 repair/scan.c        |    8 ++--
 8 files changed, 97 insertions(+), 67 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 7e18991a3d527c..c29cbc0874f833 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -132,7 +132,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		if (check_aginode_block(mp, agno, agino) == 0)
 			return 0;
 
-		pthread_mutex_lock(&ag_locks[agno].lock);
+		lock_ag(agno);
 
 		state = get_bmap(agno, agbno);
 		switch (state) {
@@ -167,8 +167,8 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		_("inode block %d/%d multiply claimed, (state %d)\n"),
 				agno, agbno, state);
 			set_bmap(agno, agbno, XR_E_MULT);
-			pthread_mutex_unlock(&ag_locks[agno].lock);
-			return(0);
+			unlock_ag(agno);
+			return 0;
 		default:
 			do_warn(
 		_("inode block %d/%d bad state, (state %d)\n"),
@@ -177,7 +177,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 			break;
 		}
 
-		pthread_mutex_unlock(&ag_locks[agno].lock);
+		unlock_ag(agno);
 
 		start_agino = XFS_AGB_TO_AGINO(mp, agbno);
 		*start_ino = XFS_AGINO_TO_INO(mp, agno, start_agino);
@@ -424,7 +424,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	 * user data -- we're probably here as a result of a directory
 	 * entry or an iunlinked pointer
 	 */
-	pthread_mutex_lock(&ag_locks[agno].lock);
+	lock_ag(agno);
 	for (cur_agbno = chunk_start_agbno;
 	     cur_agbno < chunk_stop_agbno;
 	     cur_agbno += blen)  {
@@ -438,7 +438,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	_("inode block %d/%d multiply claimed, (state %d)\n"),
 				agno, cur_agbno, state);
 			set_bmap_ext(agno, cur_agbno, blen, XR_E_MULT);
-			pthread_mutex_unlock(&ag_locks[agno].lock);
+			unlock_ag(agno);
 			return 0;
 		case XR_E_METADATA:
 		case XR_E_INO:
@@ -450,7 +450,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 			break;
 		}
 	}
-	pthread_mutex_unlock(&ag_locks[agno].lock);
+	unlock_ag(agno);
 
 	/*
 	 * ok, chunk is good.  put the record into the tree if required,
@@ -473,8 +473,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 
 	set_inode_used(irec_p, agino - start_agino);
 
-	pthread_mutex_lock(&ag_locks[agno].lock);
-
+	lock_ag(agno);
 	for (cur_agbno = chunk_start_agbno;
 	     cur_agbno < chunk_stop_agbno;
 	     cur_agbno += blen)  {
@@ -516,7 +515,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 			break;
 		}
 	}
-	pthread_mutex_unlock(&ag_locks[agno].lock);
+	unlock_ag(agno);
 
 	return(ino_cnt);
 }
@@ -575,7 +574,7 @@ process_inode_agbno_state(
 {
 	int state;
 
-	pthread_mutex_lock(&ag_locks[agno].lock);
+	lock_ag(agno);
 	state = get_bmap(agno, agbno);
 	switch (state) {
 	case XR_E_INO:	/* already marked */
@@ -605,7 +604,7 @@ process_inode_agbno_state(
 			XFS_AGB_TO_FSB(mp, agno, agbno), state);
 		break;
 	}
-	pthread_mutex_unlock(&ag_locks[agno].lock);
+	unlock_ag(agno);
 }
 
 /*
diff --git a/repair/dinode.c b/repair/dinode.c
index 5046a5ed6dcc31..7c613ed8d8668b 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -540,9 +540,9 @@ _("Fatal error: inode %" PRIu64 " - blkmap_set_ext(): %s\n"
 		ebno = agbno + irec.br_blockcount;
 		if (agno != locked_agno) {
 			if (locked_agno != -1)
-				pthread_mutex_unlock(&ag_locks[locked_agno].lock);
-			pthread_mutex_lock(&ag_locks[agno].lock);
+				unlock_ag(locked_agno);
 			locked_agno = agno;
+			lock_ag(locked_agno);
 		}
 
 		for (b = irec.br_startblock;
@@ -663,7 +663,7 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 	error = 0;
 done:
 	if (locked_agno != -1)
-		pthread_mutex_unlock(&ag_locks[locked_agno].lock);
+		unlock_ag(locked_agno);
 
 	if (i != *numrecs) {
 		ASSERT(i < *numrecs);
diff --git a/repair/globals.c b/repair/globals.c
index d97e2a8d2d6d9b..30995f5298d5a1 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -111,8 +111,6 @@ xfs_extlen_t	sb_inoalignmt;
 uint32_t	sb_unit;
 uint32_t	sb_width;
 
-struct aglock	*ag_locks;
-
 time_t		report_interval;
 uint64_t	*prog_rpt_done;
 
diff --git a/repair/globals.h b/repair/globals.h
index db8afabd9f0fc9..7c2d9c56c8f8a7 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -152,10 +152,6 @@ extern xfs_extlen_t	sb_inoalignmt;
 extern uint32_t	sb_unit;
 extern uint32_t	sb_width;
 
-struct aglock {
-	pthread_mutex_t	lock __attribute__((__aligned__(64)));
-};
-extern struct aglock	*ag_locks;
 extern pthread_mutex_t	rt_lock;
 
 extern time_t		report_interval;
diff --git a/repair/incore.c b/repair/incore.c
index 21f5b05d3e93e4..fb9ebee1671d4f 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -24,7 +24,25 @@
 static int states[16] =
 	{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
 
-static struct btree_root	**ag_bmap;
+struct bmap {
+	pthread_mutex_t		lock __attribute__((__aligned__(64)));
+	struct btree_root	*root;
+};
+static struct bmap	*ag_bmaps;
+
+void
+lock_ag(
+	xfs_agnumber_t		agno)
+{
+	pthread_mutex_lock(&ag_bmaps[agno].lock);
+}
+
+void
+unlock_ag(
+	xfs_agnumber_t		agno)
+{
+	pthread_mutex_unlock(&ag_bmaps[agno].lock);
+}
 
 static void
 update_bmap(
@@ -129,7 +147,7 @@ set_bmap_ext(
 	xfs_extlen_t		blen,
 	int			state)
 {
-	update_bmap(ag_bmap[agno], agbno, blen, &states[state]);
+	update_bmap(ag_bmaps[agno].root, agbno, blen, &states[state]);
 }
 
 int
@@ -139,23 +157,24 @@ get_bmap_ext(
 	xfs_agblock_t		maxbno,
 	xfs_extlen_t		*blen)
 {
+	struct btree_root	*bmap = ag_bmaps[agno].root;
 	int			*statep;
 	unsigned long		key;
 
-	statep = btree_find(ag_bmap[agno], agbno, &key);
+	statep = btree_find(bmap, agbno, &key);
 	if (!statep)
 		return -1;
 
 	if (key == agbno) {
 		if (blen) {
-			if (!btree_peek_next(ag_bmap[agno], &key))
+			if (!btree_peek_next(bmap, &key))
 				return -1;
 			*blen = min(maxbno, key) - agbno;
 		}
 		return *statep;
 	}
 
-	statep = btree_peek_prev(ag_bmap[agno], NULL);
+	statep = btree_peek_prev(bmap, NULL);
 	if (!statep)
 		return -1;
 	if (blen)
@@ -243,13 +262,15 @@ reset_bmaps(xfs_mount_t *mp)
 	ag_size = mp->m_sb.sb_agblocks;
 
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		struct btree_root	*bmap = ag_bmaps[agno].root;
+
 		if (agno == mp->m_sb.sb_agcount - 1)
 			ag_size = (xfs_extlen_t)(mp->m_sb.sb_dblocks -
 				   (xfs_rfsblock_t)mp->m_sb.sb_agblocks * agno);
 #ifdef BTREE_STATS
-		if (btree_find(ag_bmap[agno], 0, NULL)) {
+		if (btree_find(bmap, 0, NULL)) {
 			printf("ag_bmap[%d] btree stats:\n", i);
-			btree_print_stats(ag_bmap[agno], stdout);
+			btree_print_stats(bmap, stdout);
 		}
 #endif
 		/*
@@ -260,11 +281,10 @@ reset_bmaps(xfs_mount_t *mp)
 		 *	ag_hdr_block..ag_size:		XR_E_UNKNOWN
 		 *	ag_size...			XR_E_BAD_STATE
 		 */
-		btree_clear(ag_bmap[agno]);
-		btree_insert(ag_bmap[agno], 0, &states[XR_E_INUSE_FS]);
-		btree_insert(ag_bmap[agno],
-				ag_hdr_block, &states[XR_E_UNKNOWN]);
-		btree_insert(ag_bmap[agno], ag_size, &states[XR_E_BAD_STATE]);
+		btree_clear(bmap);
+		btree_insert(bmap, 0, &states[XR_E_INUSE_FS]);
+		btree_insert(bmap, ag_hdr_block, &states[XR_E_UNKNOWN]);
+		btree_insert(bmap, ag_size, &states[XR_E_BAD_STATE]);
 	}
 
 	if (mp->m_sb.sb_logstart != 0) {
@@ -276,44 +296,58 @@ reset_bmaps(xfs_mount_t *mp)
 	reset_rt_bmap();
 }
 
+static struct bmap *
+alloc_bmaps(
+	unsigned int		nr_groups)
+{
+	struct bmap		*bmap;
+	unsigned int		i;
+
+	bmap = calloc(nr_groups, sizeof(*bmap));
+	if (!bmap)
+		return NULL;
+
+	for (i = 0; i < nr_groups; i++)  {
+		btree_init(&bmap[i].root);
+		pthread_mutex_init(&bmap[i].lock, NULL);
+	}
+
+	return bmap;
+}
+
+static void
+destroy_bmaps(
+	struct bmap		*bmap,
+	unsigned int		nr_groups)
+{
+	unsigned int		i;
+
+	for (i = 0; i < nr_groups; i++) {
+		btree_destroy(bmap[i].root);
+		pthread_mutex_destroy(&bmap[i].lock);
+	}
+
+	free(bmap);
+}
+
 void
-init_bmaps(xfs_mount_t *mp)
+init_bmaps(
+	struct xfs_mount	*mp)
 {
-	xfs_agnumber_t i;
-
-	ag_bmap = calloc(mp->m_sb.sb_agcount, sizeof(struct btree_root *));
-	if (!ag_bmap)
+	ag_bmaps = alloc_bmaps(mp->m_sb.sb_agcount + mp->m_sb.sb_rgcount);
+	if (!ag_bmaps)
 		do_error(_("couldn't allocate block map btree roots\n"));
 
-	ag_locks = calloc(mp->m_sb.sb_agcount, sizeof(struct aglock));
-	if (!ag_locks)
-		do_error(_("couldn't allocate block map locks\n"));
-
-	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
-		btree_init(&ag_bmap[i]);
-		pthread_mutex_init(&ag_locks[i].lock, NULL);
-	}
-
 	init_rt_bmap(mp);
 	reset_bmaps(mp);
 }
 
 void
-free_bmaps(xfs_mount_t *mp)
+free_bmaps(
+	struct xfs_mount	*mp)
 {
-	xfs_agnumber_t i;
-
-	for (i = 0; i < mp->m_sb.sb_agcount; i++)
-		pthread_mutex_destroy(&ag_locks[i].lock);
-
-	free(ag_locks);
-	ag_locks = NULL;
-
-	for (i = 0; i < mp->m_sb.sb_agcount; i++)
-		btree_destroy(ag_bmap[i]);
-
-	free(ag_bmap);
-	ag_bmap = NULL;
+	destroy_bmaps(ag_bmaps, mp->m_sb.sb_agcount + mp->m_sb.sb_rgcount);
+	ag_bmaps = NULL;
 
 	free_rt_bmap(mp);
 }
diff --git a/repair/incore.h b/repair/incore.h
index 07716fc4c01a05..8385043580637f 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -23,6 +23,9 @@ void		init_bmaps(xfs_mount_t *mp);
 void		reset_bmaps(xfs_mount_t *mp);
 void		free_bmaps(xfs_mount_t *mp);
 
+void		lock_ag(xfs_agnumber_t agno);
+void		unlock_ag(xfs_agnumber_t agno);
+
 void		set_bmap_ext(xfs_agnumber_t agno, xfs_agblock_t agbno,
 			     xfs_extlen_t blen, int state);
 int		get_bmap_ext(xfs_agnumber_t agno, xfs_agblock_t agbno,
diff --git a/repair/rmap.c b/repair/rmap.c
index 29af74eee11831..9a7723bf58e7ec 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -761,12 +761,12 @@ mark_reflink_inodes(
 		agno = XFS_INO_TO_AGNO(mp, rciter.ino);
 		agino = XFS_INO_TO_AGINO(mp, rciter.ino);
 
-		pthread_mutex_lock(&ag_locks[agno].lock);
+		lock_ag(agno);
 		irec = find_inode_rec(mp, agno, agino);
 		off = get_inode_offset(mp, rciter.ino, irec);
 		/* lock here because we might go outside this ag */
 		set_inode_is_rl(irec, off);
-		pthread_mutex_unlock(&ag_locks[agno].lock);
+		unlock_ag(agno);
 	}
 	rcbag_ino_iter_stop(rcstack, &rciter);
 }
diff --git a/repair/scan.c b/repair/scan.c
index ed73de4b2477bf..8b118423ce0457 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -340,7 +340,7 @@ _("bad back (left) sibling pointer (saw %llu should be NULL (0))\n"
 		agno = XFS_FSB_TO_AGNO(mp, bno);
 		agbno = XFS_FSB_TO_AGBNO(mp, bno);
 
-		pthread_mutex_lock(&ag_locks[agno].lock);
+		lock_ag(agno);
 		state = get_bmap(agno, agbno);
 		switch (state) {
 		case XR_E_INUSE1:
@@ -407,7 +407,7 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 				state, ino, bno);
 			break;
 		}
-		pthread_mutex_unlock(&ag_locks[agno].lock);
+		unlock_ag(agno);
 	} else {
 		if (search_dup_extent(XFS_FSB_TO_AGNO(mp, bno),
 				XFS_FSB_TO_AGBNO(mp, bno),
@@ -420,9 +420,9 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 	/* Record BMBT blocks in the reverse-mapping data. */
 	if (check_dups && collect_rmaps && !zap_metadata) {
 		agno = XFS_FSB_TO_AGNO(mp, bno);
-		pthread_mutex_lock(&ag_locks[agno].lock);
+		lock_ag(agno);
 		rmap_add_bmbt_rec(mp, ino, whichfork, bno);
-		pthread_mutex_unlock(&ag_locks[agno].lock);
+		unlock_ag(agno);
 	}
 
 	if (level == 0) {

