Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82HwJRd034429 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:58:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 068A615B1A2F
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:58:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id L2AEtt0bguNXEgzI for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:58:41 -0700 (PDT)
Message-Id: <20090902175841.479553130@bombadil.infradead.org>
Date: Wed, 02 Sep 2009 13:55:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/14] repair: cleanup helpers for tracking block usage
References: <20090902175531.469184575@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-cleanup-bmap-helpers
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Barry Naujok <bnaujok@sgi.com>

Rename get_agbno_state/set_agbno_state to get_bmap/set_bmap because
those names are more self-descriptive.  Remove the superblous mount
argument to the as the current filesystem is a global in repair.
Remove the fsbno taking variant as they just complicated the code.
Bring all uses of them into the canonical form.


Signed-off-by: Barry Naujok <bnaujok@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/dinode.c
===================================================================
--- xfsprogs-dev.orig/repair/dinode.c	2009-08-21 19:05:41.000000000 +0000
+++ xfsprogs-dev/repair/dinode.c	2009-08-21 19:05:51.000000000 +0000
@@ -545,40 +545,33 @@ process_rt_rec(
 			continue;
 		}
 
-		state = get_rtbno_state(mp, ext);
-
+		state = get_rtbmap(ext);
 		switch (state)  {
-			case XR_E_FREE:
-			case XR_E_UNKNOWN:
-				set_rtbno_state(mp, ext, XR_E_INUSE);
+		case XR_E_FREE:
+		case XR_E_UNKNOWN:
+			set_rtbmap(ext, XR_E_INUSE);
+			break;
+		case XR_E_BAD_STATE:
+			do_error(_("bad state in rt block map %llu\n"), ext);
+		case XR_E_FS_MAP:
+		case XR_E_INO:
+		case XR_E_INUSE_FS:
+			do_error(_("data fork in rt inode %llu found "
+				"metadata block %llu in rt bmap\n"),
+				ino, ext);
+		case XR_E_INUSE:
+			if (pwe)
 				break;
-
-			case XR_E_BAD_STATE:
-				do_error(_("bad state in rt block map %llu\n"),
-						ext);
-
-			case XR_E_FS_MAP:
-			case XR_E_INO:
-			case XR_E_INUSE_FS:
-				do_error(_("data fork in rt inode %llu found "
-					"metadata block %llu in rt bmap\n"),
+		case XR_E_MULT:
+			set_rtbmap(ext, XR_E_MULT);
+			do_warn(_("data fork in rt inode %llu claims "
+					"used rt block %llu\n"),
 					ino, ext);
-
-			case XR_E_INUSE:
-				if (pwe)
-					break;
-
-			case XR_E_MULT:
-				set_rtbno_state(mp, ext, XR_E_MULT);
-				do_warn(_("data fork in rt inode %llu claims "
-						"used rt block %llu\n"),
-						ino, ext);
-				return 1;
-
-			case XR_E_FREE1:
-			default:
-				do_error(_("illegal state %d in rt block map "
-						"%llu\n"), state, b);
+			return 1;
+		case XR_E_FREE1:
+		default:
+			do_error(_("illegal state %d in rt block map "
+					"%llu\n"), state, b);
 		}
 	}
 
@@ -770,8 +763,7 @@ process_bmbt_reclist_int(
 
 			}
 
-			state = get_agbno_state(mp, agno, agbno);
-
+			state = get_bmap(agno, agbno);
 			switch (state)  {
 			case XR_E_FREE:
 			case XR_E_FREE1:
@@ -780,7 +772,7 @@ process_bmbt_reclist_int(
 					forkname, ino, (__uint64_t) b);
 				/* fall through ... */
 			case XR_E_UNKNOWN:
-				set_agbno_state(mp, agno, agbno, XR_E_INUSE);
+				set_bmap(agno, agbno, XR_E_INUSE);
 				break;
 
 			case XR_E_BAD_STATE:
@@ -796,7 +788,7 @@ process_bmbt_reclist_int(
 
 			case XR_E_INUSE:
 			case XR_E_MULT:
-				set_agbno_state(mp, agno, agbno, XR_E_MULT);
+				set_bmap(agno, agbno, XR_E_MULT);
 				do_warn(_("%s fork in %s inode %llu claims "
 					"used block %llu\n"),
 					forkname, ftype, ino, (__uint64_t) b);
Index: xfsprogs-dev/repair/dino_chunks.c
===================================================================
--- xfsprogs-dev.orig/repair/dino_chunks.c	2009-08-21 19:05:40.000000000 +0000
+++ xfsprogs-dev/repair/dino_chunks.c	2009-08-21 19:05:51.000000000 +0000
@@ -151,7 +151,8 @@ verify_inode_chunk(xfs_mount_t		*mp,
 
 		pthread_mutex_lock(&ag_locks[agno]);
 
-		switch (state = get_agbno_state(mp, agno, agbno))  {
+		state = get_bmap(agno, agbno);
+		switch (state) {
 		case XR_E_INO:
 			do_warn(
 		_("uncertain inode block %d/%d already known\n"),
@@ -160,7 +161,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
-			set_agbno_state(mp, agno, agbno, XR_E_INO);
+			set_bmap(agno, agbno, XR_E_INO);
 			break;
 		case XR_E_MULT:
 		case XR_E_INUSE:
@@ -172,14 +173,14 @@ verify_inode_chunk(xfs_mount_t		*mp,
 			do_warn(
 		_("inode block %d/%d multiply claimed, (state %d)\n"),
 				agno, agbno, state);
-			set_agbno_state(mp, agno, agbno, XR_E_MULT);
+			set_bmap(agno, agbno, XR_E_MULT);
 			pthread_mutex_unlock(&ag_locks[agno]);
 			return(0);
 		default:
 			do_warn(
 		_("inode block %d/%d bad state, (state %d)\n"),
 				agno, agbno, state);
-			set_agbno_state(mp, agno, agbno, XR_E_INO);
+			set_bmap(agno, agbno, XR_E_INO);
 			break;
 		}
 
@@ -434,7 +435,8 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	pthread_mutex_lock(&ag_locks[agno]);
 	for (j = 0, cur_agbno = chunk_start_agbno;
 			cur_agbno < chunk_stop_agbno; cur_agbno++)  {
-		switch (state = get_agbno_state(mp, agno, cur_agbno))  {
+		state = get_bmap(agno, cur_agbno);
+		switch (state) {
 		case XR_E_MULT:
 		case XR_E_INUSE:
 		case XR_E_INUSE_FS:
@@ -442,7 +444,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 			do_warn(
 		_("inode block %d/%d multiply claimed, (state %d)\n"),
 				agno, cur_agbno, state);
-			set_agbno_state(mp, agno, cur_agbno, XR_E_MULT);
+			set_bmap(agno, cur_agbno, XR_E_MULT);
 			j = 1;
 			break;
 		case XR_E_INO:
@@ -486,7 +488,8 @@ verify_inode_chunk(xfs_mount_t		*mp,
 
 	for (cur_agbno = chunk_start_agbno;
 			cur_agbno < chunk_stop_agbno; cur_agbno++)  {
-		switch (state = get_agbno_state(mp, agno, cur_agbno))  {
+		state = get_bmap(agno, cur_agbno);
+		switch (state) {
 		case XR_E_INO:
 			do_error(
 		_("uncertain inode block %llu already known\n"),
@@ -495,7 +498,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
-			set_agbno_state(mp, agno, cur_agbno, XR_E_INO);
+			set_bmap(agno, cur_agbno, XR_E_INO);
 			break;
 		case XR_E_MULT:
 		case XR_E_INUSE:
@@ -509,7 +512,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 			do_warn(
 		_("inode block %d/%d bad state, (state %d)\n"),
 				agno, cur_agbno, state);
-			set_agbno_state(mp, agno, cur_agbno, XR_E_INO);
+			set_bmap(agno, cur_agbno, XR_E_INO);
 			break;
 		}
 	}
@@ -742,22 +745,23 @@ process_inode_chunk(
 	 * mark block as an inode block in the incore bitmap
 	 */
 	pthread_mutex_lock(&ag_locks[agno]);
-	switch (state = get_agbno_state(mp, agno, agbno))  {
-		case XR_E_INO:	/* already marked */
-			break;
-		case XR_E_UNKNOWN:
-		case XR_E_FREE:
-		case XR_E_FREE1:
-			set_agbno_state(mp, agno, agbno, XR_E_INO);
-			break;
-		case XR_E_BAD_STATE:
-			do_error(_("bad state in block map %d\n"), state);
-			break;
-		default:
-			set_agbno_state(mp, agno, agbno, XR_E_MULT);
-			do_warn(_("inode block %llu multiply claimed, state was %d\n"),
-				XFS_AGB_TO_FSB(mp, agno, agbno), state);
-			break;
+	state = get_bmap(agno, agbno);
+	switch (state) {
+	case XR_E_INO:	/* already marked */
+		break;
+	case XR_E_UNKNOWN:
+	case XR_E_FREE:
+	case XR_E_FREE1:
+		set_bmap(agno, agbno, XR_E_INO);
+		break;
+	case XR_E_BAD_STATE:
+		do_error(_("bad state in block map %d\n"), state);
+		break;
+	default:
+		set_bmap(agno, agbno, XR_E_MULT);
+		do_warn(_("inode block %llu multiply claimed, state was %d\n"),
+			XFS_AGB_TO_FSB(mp, agno, agbno), state);
+		break;
 	}
 	pthread_mutex_unlock(&ag_locks[agno]);
 
@@ -923,20 +927,21 @@ process_inode_chunk(
 			agbno++;
 
 			pthread_mutex_lock(&ag_locks[agno]);
-			switch (state = get_agbno_state(mp, agno, agbno))  {
+			state = get_bmap(agno, agbno);
+			switch (state) {
 			case XR_E_INO:	/* already marked */
 				break;
 			case XR_E_UNKNOWN:
 			case XR_E_FREE:
 			case XR_E_FREE1:
-				set_agbno_state(mp, agno, agbno, XR_E_INO);
+				set_bmap(agno, agbno, XR_E_INO);
 				break;
 			case XR_E_BAD_STATE:
 				do_error(_("bad state in block map %d\n"),
 					state);
 				break;
 			default:
-				set_agbno_state(mp, agno, agbno, XR_E_MULT);
+				set_bmap(agno, agbno, XR_E_MULT);
 				do_warn(_("inode block %llu multiply claimed, "
 					  "state was %d\n"),
 					XFS_AGB_TO_FSB(mp, agno, agbno), state);
Index: xfsprogs-dev/repair/phase4.c
===================================================================
--- xfsprogs-dev.orig/repair/phase4.c	2009-08-21 18:59:24.000000000 +0000
+++ xfsprogs-dev/repair/phase4.c	2009-08-21 19:05:51.000000000 +0000
@@ -247,8 +247,7 @@ phase4(xfs_mount_t *mp)
 				}
 			}
 
-			bstate = get_agbno_state(mp, i, j);
-
+			bstate = get_bmap(i, j);
 			switch (bstate)  {
 			case XR_E_BAD_STATE:
 			default:
@@ -305,9 +304,7 @@ phase4(xfs_mount_t *mp)
 	rt_len = 0;
 
 	for (bno = 0; bno < mp->m_sb.sb_rextents; bno++)  {
-
-		bstate = get_rtbno_state(mp, bno);
-
+		bstate = get_rtbmap(bno);
 		switch (bstate)  {
 		case XR_E_BAD_STATE:
 		default:
@@ -366,7 +363,7 @@ phase4(xfs_mount_t *mp)
 		    roundup((mp->m_sb.sb_agblocks+(NBBY/XR_BB)-1)/(NBBY/XR_BB),
 						sizeof(__uint64_t)));
 		for (j = 0; j < ag_hdr_block; j++)
-			set_agbno_state(mp, i, j, XR_E_INUSE_FS);
+			set_bmap(i, j, XR_E_INUSE_FS);
 	}
 	set_bmap_rt(mp->m_sb.sb_rextents);
 	set_bmap_log(mp);
Index: xfsprogs-dev/repair/phase5.c
===================================================================
--- xfsprogs-dev.orig/repair/phase5.c	2009-08-21 18:59:24.000000000 +0000
+++ xfsprogs-dev/repair/phase5.c	2009-08-21 19:05:51.000000000 +0000
@@ -123,7 +123,7 @@ mk_incore_fstree(xfs_mount_t *mp, xfs_ag
 	for (agbno = 0; agbno < ag_end; agbno++)  {
 #if 0
 		old_state = state;
-		state = get_agbno_state(mp, agno, agbno);
+		state = get_bmap(agno, agbno);
 		if (state != old_state)  {
 			fprintf(stderr, "agbno %u - new state is %d\n",
 					agbno, state);
@@ -142,7 +142,7 @@ mk_incore_fstree(xfs_mount_t *mp, xfs_ag
 			}
 
 		}
-		if (get_agbno_state(mp, agno, agbno) < XR_E_INUSE)  {
+		if (get_bmap(agno, agbno) < XR_E_INUSE)  {
 			free_blocks++;
 			if (in_extent == 0)  {
 				/*
Index: xfsprogs-dev/repair/scan.c
===================================================================
--- xfsprogs-dev.orig/repair/scan.c	2009-08-21 19:05:32.000000000 +0000
+++ xfsprogs-dev/repair/scan.c	2009-08-21 19:06:51.000000000 +0000
@@ -148,6 +148,9 @@ scanfunc_bmap(
 	xfs_dfiloff_t		last_key;
 	char			*forkname;
 	int			numrecs;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	int			state;
 
 	if (whichfork == XFS_DATA_FORK)
 		forkname = _("data");
@@ -229,11 +232,15 @@ _("bad back (left) sibling pointer (saw 
 		bm_cursor->level[level].right_fsbno =
 					be64_to_cpu(block->bb_u.l.bb_rightsib);
 
-		switch (get_fsbno_state(mp, bno))  {
+		agno = XFS_FSB_TO_AGNO(mp, bno);
+		agbno = XFS_FSB_TO_AGBNO(mp, bno);
+
+		state = get_bmap(agno, agbno);
+		switch (state) {
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
-			set_fsbno_state(mp, bno, XR_E_INUSE);
+			set_bmap(agno, agbno, XR_E_INUSE);
 			break;
 		case XR_E_FS_MAP:
 		case XR_E_INUSE:
@@ -245,19 +252,17 @@ _("bad back (left) sibling pointer (saw 
 			 * we made it here, the block probably
 			 * contains btree data.
 			 */
-			set_fsbno_state(mp, bno, XR_E_MULT);
+			set_bmap(agno, agbno, XR_E_MULT);
 			do_warn(
 		_("inode 0x%llx bmap block 0x%llx claimed, state is %d\n"),
-				ino, (__uint64_t) bno,
-				get_fsbno_state(mp, bno));
+				ino, (__uint64_t) bno, state);
 			break;
 		case XR_E_MULT:
 		case XR_E_INUSE_FS:
-			set_fsbno_state(mp, bno, XR_E_MULT);
+			set_bmap(agno, agbno, XR_E_MULT);
 			do_warn(
 		_("inode 0x%llx bmap block 0x%llx claimed, state is %d\n"),
-				ino, (__uint64_t) bno,
-				get_fsbno_state(mp, bno));
+				ino, (__uint64_t) bno, state);
 			/*
 			 * if we made it to here, this is probably a bmap block
 			 * that is being used by *another* file as a bmap block
@@ -272,8 +277,7 @@ _("bad back (left) sibling pointer (saw 
 		default:
 			do_warn(
 		_("bad state %d, inode 0x%llx bmap block 0x%llx\n"),
-				get_fsbno_state(mp, bno),
-				ino, (__uint64_t) bno);
+				state, ino, (__uint64_t) bno);
 			break;
 		}
 	} else  {
@@ -476,19 +480,15 @@ scanfunc_allocbt(
 	/*
 	 * check for btree blocks multiply claimed
 	 */
-	state = get_agbno_state(mp, agno, bno);
-
-	switch (state)  {
-	case XR_E_UNKNOWN:
-		set_agbno_state(mp, agno, bno, XR_E_FS_MAP);
-		break;
-	default:
-		set_agbno_state(mp, agno, bno, XR_E_MULT);
+	state = get_bmap(agno, bno);
+	switch (state != XR_E_UNKNOWN)  {
+		set_bmap(agno, bno, XR_E_MULT);
 		do_warn(
 _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 				name, state, agno, bno, suspect);
 		return;
 	}
+	set_bmap(agno, bno, XR_E_FS_MAP);
 
 	numrecs = be16_to_cpu(block->bb_numrecs);
 
@@ -523,11 +523,10 @@ _("%s freespace btree block claimed (sta
 				continue;
 
 			for ( ; b < end; b++)  {
-				state = get_agbno_state(mp, agno, b);
+				state = get_bmap(agno, b);
 				switch (state) {
 				case XR_E_UNKNOWN:
-					set_agbno_state(mp, agno, b,
-							XR_E_FREE1);
+					set_bmap(agno, b, XR_E_FREE1);
 					break;
 				case XR_E_FREE1:
 					/*
@@ -535,8 +534,7 @@ _("%s freespace btree block claimed (sta
 					 * FREE1 blocks later
 					 */
 					if (magic != XFS_ABTB_MAGIC) {
-						set_agbno_state(mp, agno, b,
-								XR_E_FREE);
+						set_bmap(agno, b, XR_E_FREE);
 						break;
 					}
 				default:
@@ -698,13 +696,14 @@ _("bad ending inode # (%llu (0x%x 0x%x))
 		     j < XFS_INODES_PER_CHUNK;
 		     j += mp->m_sb.sb_inopblock)  {
 			agbno = XFS_AGINO_TO_AGBNO(mp, ino + j);
-			state = get_agbno_state(mp, agno, agbno);
+
+			state = get_bmap(agno, agbno);
 			if (state == XR_E_UNKNOWN)  {
-				set_agbno_state(mp, agno, agbno, XR_E_INO);
+				set_bmap(agno, agbno, XR_E_INO);
 			} else if (state == XR_E_INUSE_FS && agno == 0 &&
 				   ino + j >= first_prealloc_ino &&
 				   ino + j < last_prealloc_ino)  {
-				set_agbno_state(mp, agno, agbno, XR_E_INO);
+				set_bmap(agno, agbno, XR_E_INO);
 			} else  {
 				do_warn(
 _("inode chunk claims used block, inobt block - agno %d, bno %d, inopb %d\n"),
@@ -842,16 +841,15 @@ scanfunc_ino(
 	 * check for btree blocks multiply claimed, any unknown/free state
 	 * is ok in the bitmap block.
 	 */
-	state = get_agbno_state(mp, agno, bno);
-
+	state = get_bmap(agno, bno);
 	switch (state)  {
 	case XR_E_UNKNOWN:
 	case XR_E_FREE1:
 	case XR_E_FREE:
-		set_agbno_state(mp, agno, bno, XR_E_FS_MAP);
+		set_bmap(agno, bno, XR_E_FS_MAP);
 		break;
 	default:
-		set_agbno_state(mp, agno, bno, XR_E_MULT);
+		set_bmap(agno, bno, XR_E_MULT);
 		do_warn(
 _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 			state, agno, bno, suspect);
@@ -953,7 +951,7 @@ scan_freelist(
 	if (XFS_SB_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
 	    XFS_AGF_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
 	    XFS_AGI_BLOCK(mp) != XFS_AGFL_BLOCK(mp))
-		set_agbno_state(mp, agno, XFS_AGFL_BLOCK(mp), XR_E_FS_MAP);
+		set_bmap(agno, XFS_AGFL_BLOCK(mp), XR_E_FS_MAP);
 
 	if (be32_to_cpu(agf->agf_flcount) == 0)
 		return;
@@ -971,7 +969,7 @@ scan_freelist(
 	for (;;) {
 		bno = be32_to_cpu(agfl->agfl_bno[i]);
 		if (verify_agbno(mp, agno, bno))
-			set_agbno_state(mp, agno, bno, XR_E_FREE);
+			set_bmap(agno, bno, XR_E_FREE);
 		else
 			do_warn(_("bad agbno %u in agfl, agno %d\n"),
 				bno, agno);
Index: xfsprogs-dev/repair/Makefile
===================================================================
--- xfsprogs-dev.orig/repair/Makefile	2009-08-21 19:05:38.000000000 +0000
+++ xfsprogs-dev/repair/Makefile	2009-08-21 19:05:51.000000000 +0000
@@ -32,9 +32,7 @@ include $(BUILDRULES)
 
 #
 # Tracing flags:
-# -DXR_BMAP_DBG		incore block bitmap debugging
 # -DXR_INODE_TRACE	inode processing
-# -DXR_BMAP_TRACE	bmap btree processing
 # -DXR_DIR_TRACE	directory processing
 # -DXR_DUP_TRACE	duplicate extent processing
 # -DXR_BCNT_TRACE	incore bcnt freespace btree building
Index: xfsprogs-dev/repair/incore.c
===================================================================
--- xfsprogs-dev.orig/repair/incore.c	2009-08-21 18:59:24.000000000 +0000
+++ xfsprogs-dev/repair/incore.c	2009-08-21 19:05:51.000000000 +0000
@@ -185,7 +185,8 @@ set_bmap_log(xfs_mount_t *mp)
 	logend = mp->m_sb.sb_logstart + mp->m_sb.sb_logblocks;
 
 	for (i = mp->m_sb.sb_logstart; i < logend ; i++)  {
-		set_fsbno_state(mp, i, XR_E_INUSE_FS);
+		set_bmap(XFS_FSB_TO_AGNO(mp, i),
+			 XFS_FSB_TO_AGBNO(mp, i), XR_E_INUSE_FS);
 	}
 
 	return;
@@ -205,7 +206,7 @@ set_bmap_fs(xfs_mount_t *mp)
 
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		for (j = 0; j < end; j++)
-			set_agbno_state(mp, i, j, XR_E_INUSE_FS);
+			set_bmap(i, j, XR_E_INUSE_FS);
 
 	return;
 }
@@ -227,7 +228,7 @@ set_bmap_fs_bt(xfs_mount_t *mp)
 		 * account for btree roots
 		 */
 		for (j = begin; j < end; j++)
-			set_agbno_state(mp, i, j, XR_E_INUSE_FS);
+			set_bmap(i, j, XR_E_INUSE_FS);
 	}
 
 	return;
@@ -253,44 +254,3 @@ incore_init(xfs_mount_t *mp)
 
 	return;
 }
-
-#if defined(XR_BMAP_TRACE) || defined(XR_BMAP_DBG)
-int
-get_agbno_state(xfs_mount_t *mp, xfs_agnumber_t agno,
-		xfs_agblock_t ag_blockno)
-{
-	__uint64_t *addr;
-
-	addr = ba_bmap[(agno)] + (ag_blockno)/XR_BB_NUM;
-
-	return((*addr >> (((ag_blockno)%XR_BB_NUM)*XR_BB)) & XR_BB_MASK);
-}
-
-void set_agbno_state(xfs_mount_t *mp, xfs_agnumber_t agno,
-	xfs_agblock_t ag_blockno, int state)
-{
-	__uint64_t *addr;
-
-	addr = ba_bmap[(agno)] + (ag_blockno)/XR_BB_NUM;
-
-	*addr = (((*addr) &
-	  (~((__uint64_t) XR_BB_MASK << (((ag_blockno)%XR_BB_NUM)*XR_BB)))) |
-	 (((__uint64_t) (state)) << (((ag_blockno)%XR_BB_NUM)*XR_BB)));
-}
-
-int
-get_fsbno_state(xfs_mount_t *mp, xfs_dfsbno_t blockno)
-{
-	return(get_agbno_state(mp, XFS_FSB_TO_AGNO(mp, blockno),
-			XFS_FSB_TO_AGBNO(mp, blockno)));
-}
-
-void
-set_fsbno_state(xfs_mount_t *mp, xfs_dfsbno_t blockno, int state)
-{
-	set_agbno_state(mp, XFS_FSB_TO_AGNO(mp, blockno),
-		XFS_FSB_TO_AGBNO(mp, blockno), state);
-
-	return;
-}
-#endif
Index: xfsprogs-dev/repair/incore.h
===================================================================
--- xfsprogs-dev.orig/repair/incore.h	2009-08-21 18:59:24.000000000 +0000
+++ xfsprogs-dev/repair/incore.h	2009-08-21 19:05:51.000000000 +0000
@@ -72,51 +72,23 @@ void			teardown_bmap_finish(xfs_mount_t 
  * you want to use the regular block map.
  */
 
-#if defined(XR_BMAP_TRACE) || defined(XR_BMAP_DBG)
-/*
- * implemented as functions for debugging purposes
- */
-int get_agbno_state(xfs_mount_t *mp, xfs_agnumber_t agno,
-	xfs_agblock_t ag_blockno);
-void set_agbno_state(xfs_mount_t *mp, xfs_agnumber_t agno,
-	xfs_agblock_t ag_blockno, int state);
-
-int get_fsbno_state(xfs_mount_t *mp, xfs_dfsbno_t blockno);
-void set_fsbno_state(xfs_mount_t *mp, xfs_dfsbno_t blockno, int state);
-#else
-/*
- * implemented as macros for performance purposes
- */
-
-#define get_agbno_state(mp, agno, ag_blockno) \
+#define get_bmap(agno, ag_blockno) \
 			((int) (*(ba_bmap[(agno)] + (ag_blockno)/XR_BB_NUM) \
 				 >> (((ag_blockno)%XR_BB_NUM)*XR_BB)) \
 				& XR_BB_MASK)
-#define set_agbno_state(mp, agno, ag_blockno, state) \
+#define set_bmap(agno, ag_blockno, state) \
 	*(ba_bmap[(agno)] + (ag_blockno)/XR_BB_NUM) = \
 		((*(ba_bmap[(agno)] + (ag_blockno)/XR_BB_NUM) & \
 	  (~((__uint64_t) XR_BB_MASK << (((ag_blockno)%XR_BB_NUM)*XR_BB)))) | \
 	 (((__uint64_t) (state)) << (((ag_blockno)%XR_BB_NUM)*XR_BB)))
 
-#define get_fsbno_state(mp, blockno) \
-		get_agbno_state(mp, XFS_FSB_TO_AGNO(mp, (blockno)), \
-				XFS_FSB_TO_AGBNO(mp, (blockno)))
-#define set_fsbno_state(mp, blockno, state) \
-		set_agbno_state(mp, XFS_FSB_TO_AGNO(mp, (blockno)), \
-			XFS_FSB_TO_AGBNO(mp, (blockno)), (state))
-
-
-#define get_agbno_rec(mp, agno, ag_blockno) \
-			(*(ba_bmap[(agno)] + (ag_blockno)/XR_BB_NUM))
-#endif /* XR_BMAP_TRACE */
-
 /*
  * these work in real-time extents (e.g. fsbno == rt extent number)
  */
-#define get_rtbno_state(mp, fsbno) \
+#define get_rtbmap(fsbno) \
 			((*(rt_ba_bmap + (fsbno)/XR_BB_NUM) >> \
 			(((fsbno)%XR_BB_NUM)*XR_BB)) & XR_BB_MASK)
-#define set_rtbno_state(mp, fsbno, state) \
+#define set_rtbmap(fsbno, state) \
 	*(rt_ba_bmap + (fsbno)/XR_BB_NUM) = \
 	 ((*(rt_ba_bmap + (fsbno)/XR_BB_NUM) & \
 	  (~((__uint64_t) XR_BB_MASK << (((fsbno)%XR_BB_NUM)*XR_BB)))) | \
Index: xfsprogs-dev/repair/phase2.c
===================================================================
--- xfsprogs-dev.orig/repair/phase2.c	2009-08-21 18:59:24.000000000 +0000
+++ xfsprogs-dev/repair/phase2.c	2009-08-21 19:05:51.000000000 +0000
@@ -176,7 +176,7 @@ phase2(xfs_mount_t *mp)
 		 * also mark blocks
 		 */
 		for (b = 0; b < mp->m_ialloc_blks; b++)  {
-			set_agbno_state(mp, 0,
+			set_bmap(0,
 				b + XFS_INO_TO_AGBNO(mp, mp->m_sb.sb_rootino),
 				XR_E_INO);
 		}
Index: xfsprogs-dev/repair/phase3.c
===================================================================
--- xfsprogs-dev.orig/repair/phase3.c	2009-08-21 18:59:24.000000000 +0000
+++ xfsprogs-dev/repair/phase3.c	2009-08-21 19:05:51.000000000 +0000
@@ -61,14 +61,8 @@ walk_unlinked_list(xfs_mount_t *mp, xfs_
 				agbno = XFS_AGINO_TO_AGBNO(mp, current_ino);
 
 				pthread_mutex_lock(&ag_locks[agno]);
-				switch (state = get_agbno_state(mp,
-							agno, agbno))  {
-				case XR_E_UNKNOWN:
-				case XR_E_FREE:
-				case XR_E_FREE1:
-					set_agbno_state(mp, agno, agbno,
-						XR_E_INO);
-					break;
+				state = get_bmap(agno, agbno);
+				switch (state) {
 				case XR_E_BAD_STATE:
 					do_error(_(
 						"bad state in block map %d\n"),
@@ -85,8 +79,7 @@ walk_unlinked_list(xfs_mount_t *mp, xfs_
 					 * anyway, hopefully without
 					 * losing too much other data
 					 */
-					set_agbno_state(mp, agno, agbno,
-						XR_E_INO);
+					set_bmap(agno, agbno, XR_E_INO);
 					break;
 				}
 				pthread_mutex_unlock(&ag_locks[agno]);
Index: xfsprogs-dev/repair/rt.c
===================================================================
--- xfsprogs-dev.orig/repair/rt.c	2009-08-21 18:59:24.000000000 +0000
+++ xfsprogs-dev/repair/rt.c	2009-08-21 19:05:51.000000000 +0000
@@ -91,7 +91,7 @@ generate_rtinfo(xfs_mount_t	*mp,
 		bits = 0;
 		for (i = 0; i < sizeof(xfs_rtword_t) * NBBY &&
 				extno < mp->m_sb.sb_rextents; i++, extno++)  {
-			if (get_rtbno_state(mp, extno) == XR_E_FREE)  {
+			if (get_rtbmap(extno) == XR_E_FREE)  {
 				sb_frextents++;
 				bits |= freebit;
 
@@ -218,7 +218,7 @@ process_rtbitmap(xfs_mount_t	*mp,
 		     bit < bitsperblock && extno < mp->m_sb.sb_rextents;
 		     bit++, extno++) {
 			if (xfs_isset(words, bit)) {
-				set_rtbno_state(mp, extno, XR_E_FREE);
+				set_rtbmap(extno, XR_E_FREE);
 				sb_frextents++;
 				if (prevbit == 0) {
 					start_bmbno = bmbno;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
