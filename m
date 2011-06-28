Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5SA1Zpo207096 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 05:01:35 -0500
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfs_repair: Check if agno is inside the filesystem
Date: Tue, 28 Jun 2011 12:01:19 +0200
Message-Id: <1309255279-15608-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>, aelder@sgi.com

When getting an inode tree pointer from an array inode_tree_ptrs, we
should check if agno, which is used as a pointer to the array, lives
within the file system, because if it is not, we can end up touching
uninitialized memory.

This commit fixes it by passing xfs_mount to affected functions and
checking if agno really is inside the file system.

This solves Red Hat bug #694706

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 repair/dino_chunks.c |   24 ++++++++++++------------
 repair/dinode.c      |    2 +-
 repair/dir.c         |    5 +++--
 repair/dir2.c        |    6 ++++--
 repair/incore.h      |   21 +++++++++++++++------
 repair/incore_ino.c  |   31 +++++++++++++++++++------------
 repair/phase2.c      |    4 ++--
 repair/phase3.c      |    2 +-
 repair/phase4.c      |    6 +++---
 repair/phase5.c      |    2 +-
 repair/phase6.c      |   25 +++++++++++++------------
 repair/scan.c        |    6 +++---
 12 files changed, 77 insertions(+), 57 deletions(-)

diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 734e9a8..9739da2 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -194,9 +194,9 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		 * put new inode record(s) into inode tree
 		 */
 		for (j = 0; j < chunks_pblock; j++)  {
-			if ((irec_p = find_inode_rec(agno, start_agino))
+			if ((irec_p = find_inode_rec(mp, agno, start_agino))
 					== NULL)  {
-				irec_p = set_inode_free_alloc(agno,
+				irec_p = set_inode_free_alloc(mp, agno,
 							start_agino);
 				for (i = 1; i < XFS_INODES_PER_CHUNK; i++)
 					set_inode_free(irec_p, i);
@@ -254,7 +254,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		start_agino = XFS_OFFBNO_TO_AGINO(mp, start_agbno, 0);
 		*start_ino = XFS_AGINO_TO_INO(mp, agno, start_agino);
 
-		irec_p = set_inode_free_alloc(agno,
+		irec_p = set_inode_free_alloc(mp, agno,
 				XFS_OFFBNO_TO_AGINO(mp, start_agbno, 0));
 
 		for (i = 1; i < XFS_INODES_PER_CHUNK; i++)
@@ -292,7 +292,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	 */
 	irec_before_p = irec_after_p = NULL;
 
-	find_inode_rec_range(agno, XFS_OFFBNO_TO_AGINO(mp, start_agbno, 0),
+	find_inode_rec_range(mp, agno, XFS_OFFBNO_TO_AGINO(mp, start_agbno, 0),
 		XFS_OFFBNO_TO_AGINO(mp, end_agbno, mp->m_sb.sb_inopblock - 1),
 		&irec_before_p, &irec_after_p);
 
@@ -470,9 +470,9 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	start_agino = XFS_OFFBNO_TO_AGINO(mp, chunk_start_agbno, 0);
 	*start_ino = XFS_AGINO_TO_INO(mp, agno, start_agino);
 
-	ASSERT(find_inode_rec(agno, start_agino) == NULL);
+	ASSERT(find_inode_rec(mp, agno, start_agino) == NULL);
 
-	irec_p = set_inode_free_alloc(agno, start_agino);
+	irec_p = set_inode_free_alloc(mp, agno, start_agino);
 	for (i = 1; i < XFS_INODES_PER_CHUNK; i++)
 		set_inode_free(irec_p, i);
 
@@ -554,7 +554,7 @@ verify_aginode_chunk_irec(xfs_mount_t	*mp,
 	ino_tree_node_t *irec = NULL;
 
 	if (verify_aginode_chunk(mp, agno, agino, &start_agino))
-		irec = find_inode_rec(agno, start_agino);
+		irec = find_inode_rec(mp, agno, start_agino);
 
 	return(irec);
 }
@@ -1049,7 +1049,7 @@ process_aginodes(
 				if ((ino_rec = next_ino_rec(ino_rec)) != NULL)
 					num_inos += XFS_INODES_PER_CHUNK;
 
-				get_inode_rec(agno, prev_ino_rec);
+				get_inode_rec(mp, agno, prev_ino_rec);
 				free_inode_rec(agno, prev_ino_rec);
 			}
 
@@ -1117,14 +1117,14 @@ check_uncertain_aginodes(xfs_mount_t *mp, xfs_agnumber_t agno)
 					XFS_INODES_PER_CHUNK)
 				continue;
 
-			if ((nrec = find_inode_rec(agno, agino)) == NULL)
+			if ((nrec = find_inode_rec(mp, agno, agino)) == NULL)
 				if (!verify_aginum(mp, agno, agino))
 					if (verify_aginode_chunk(mp, agno,
 							agino, &start))
 						got_some = 1;
 		}
 
-		get_uncertain_inode_rec(agno, irec);
+		get_uncertain_inode_rec(mp, agno, irec);
 		free_inode_rec(agno, irec);
 
 		irec = findfirst_uncertain_inode_rec(agno);
@@ -1207,7 +1207,7 @@ process_uncertain_aginodes(xfs_mount_t *mp, xfs_agnumber_t agno)
 					XFS_INODES_PER_CHUNK)
 				continue;
 
-			if ((nrec = find_inode_rec(agno, agino)) != NULL)
+			if ((nrec = find_inode_rec(mp, agno, agino)) != NULL)
 				continue;
 
 			/*
@@ -1238,7 +1238,7 @@ process_uncertain_aginodes(xfs_mount_t *mp, xfs_agnumber_t agno)
 		 * now return the uncertain inode record to the free pool
 		 * and pull another one off the list for processing
 		 */
-		get_uncertain_inode_rec(agno, irec);
+		get_uncertain_inode_rec(mp, agno, irec);
 		free_inode_rec(agno, irec);
 
 		irec = findfirst_uncertain_inode_rec(agno);
diff --git a/repair/dinode.c b/repair/dinode.c
index 3a092e4..f035321 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -854,7 +854,7 @@ get_agino_buf(xfs_mount_t	 *mp,
 	xfs_buf_t *bp;
 	int size;
 
-	if ((irec = find_inode_rec(agno, agino)) == NULL)
+	if ((irec = find_inode_rec(mp, agno, agino)) == NULL)
 		return(NULL);
 
 	size = XFS_FSB_TO_BB(mp, MAX(1, XFS_INODES_PER_CHUNK/inodes_per_block));
diff --git a/repair/dir.c b/repair/dir.c
index 6e0d54b..9039360 100644
--- a/repair/dir.c
+++ b/repair/dir.c
@@ -173,7 +173,8 @@ process_shortform_dir(
 	_("entry in shortform dir %llu references group quota inode %llu\n"),
 				ino, lino);
 			junkit = 1;
-		} else if ((irec_p = find_inode_rec(XFS_INO_TO_AGNO(mp, lino),
+		} else if ((irec_p = find_inode_rec(mp,
+					XFS_INO_TO_AGNO(mp, lino),
 					XFS_INO_TO_AGINO(mp, lino))) != NULL)  {
 			/*
 			 * if inode is marked free and we're in inode
@@ -1658,7 +1659,7 @@ _("entry #%d, bno %d in directory %llu references group quota inode %llu\n"),
 				_("\twould clear ino number in entry %d...\n"),
 					i);
 			}
-		} else if ((irec_p = find_inode_rec(
+		} else if ((irec_p = find_inode_rec(mp,
 				XFS_INO_TO_AGNO(mp, lino),
 				XFS_INO_TO_AGINO(mp, lino))) != NULL)  {
 			/*
diff --git a/repair/dir2.c b/repair/dir2.c
index 55fe8ec..67ee274 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -928,7 +928,8 @@ process_sf_dir2(
 		} else if (lino == mp->m_sb.sb_gquotino)  {
 			junkit = 1;
 			junkreason = _("group quota");
-		} else if ((irec_p = find_inode_rec(XFS_INO_TO_AGNO(mp, lino),
+		} else if ((irec_p = find_inode_rec(mp,
+					XFS_INO_TO_AGNO(mp, lino),
 					XFS_INO_TO_AGINO(mp, lino))) != NULL) {
 			/*
 			 * if inode is marked free and we're in inode
@@ -1448,7 +1449,8 @@ process_dir2_data(
 		} else if (ent_ino == mp->m_sb.sb_gquotino) {
 			clearreason = _("group quota");
 		} else {
-			irec_p = find_inode_rec(XFS_INO_TO_AGNO(mp, ent_ino),
+			irec_p = find_inode_rec(mp,
+						XFS_INO_TO_AGNO(mp, ent_ino),
 						XFS_INO_TO_AGINO(mp, ent_ino));
 			if (irec_p == NULL) {
 				if (ino_discovery) {
diff --git a/repair/incore.h b/repair/incore.h
index 99853fb..5e3d95d 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -307,7 +307,8 @@ void		free_inode_rec(xfs_agnumber_t agno, ino_tree_node_t *ino_rec);
 /*
  * get pulls the inode record from the good inode tree
  */
-void		get_inode_rec(xfs_agnumber_t agno, ino_tree_node_t *ino_rec);
+void		get_inode_rec(struct xfs_mount *mp, xfs_agnumber_t agno,
+			      ino_tree_node_t *ino_rec);
 
 extern avltree_desc_t     **inode_tree_ptrs;
 static inline ino_tree_node_t *
@@ -316,12 +317,17 @@ findfirst_inode_rec(xfs_agnumber_t agno)
 	return((ino_tree_node_t *) inode_tree_ptrs[agno]->avl_firstino);
 }
 static inline ino_tree_node_t *
-find_inode_rec(xfs_agnumber_t agno, xfs_agino_t ino)
+find_inode_rec(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agino_t ino)
 {
+	/*
+	 * Is the AG inside the file system
+	 */
+	if (agno >= mp->m_sb.sb_agcount)
+		return NULL;
 	return((ino_tree_node_t *)
 		avl_findrange(inode_tree_ptrs[agno], ino));
 }
-void		find_inode_rec_range(xfs_agnumber_t agno,
+void		find_inode_rec_range(struct xfs_mount *mp, xfs_agnumber_t agno,
 			xfs_agino_t start_ino, xfs_agino_t end_ino,
 			ino_tree_node_t **first, ino_tree_node_t **last);
 
@@ -330,8 +336,10 @@ void		find_inode_rec_range(xfs_agnumber_t agno,
  * automatically marks it as "existing".  Note -- all the inode
  * add/set/get routines assume a valid inode number.
  */
-ino_tree_node_t	*set_inode_used_alloc(xfs_agnumber_t agno, xfs_agino_t ino);
-ino_tree_node_t	*set_inode_free_alloc(xfs_agnumber_t agno, xfs_agino_t ino);
+ino_tree_node_t	*set_inode_used_alloc(struct xfs_mount *mp, xfs_agnumber_t agno,
+				      xfs_agino_t ino);
+ino_tree_node_t	*set_inode_free_alloc(struct xfs_mount *mp, xfs_agnumber_t agno,
+				      xfs_agino_t ino);
 
 void		print_inode_list(xfs_agnumber_t agno);
 void		print_uncertain_inode_list(xfs_agnumber_t agno);
@@ -346,7 +354,8 @@ void			add_inode_uncertain(xfs_mount_t *mp,
 						xfs_ino_t ino, int free);
 void			add_aginode_uncertain(xfs_agnumber_t agno,
 						xfs_agino_t agino, int free);
-void			get_uncertain_inode_rec(xfs_agnumber_t agno,
+void			get_uncertain_inode_rec(struct xfs_mount *mp,
+						xfs_agnumber_t agno,
 						ino_tree_node_t *ino_rec);
 void			clear_uncertain_ino_cache(xfs_agnumber_t agno);
 
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index febe0c9..7827ff5 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -418,9 +418,11 @@ add_inode_uncertain(xfs_mount_t *mp, xfs_ino_t ino, int free)
  * pull the indicated inode record out of the uncertain inode tree
  */
 void
-get_uncertain_inode_rec(xfs_agnumber_t agno, ino_tree_node_t *ino_rec)
+get_uncertain_inode_rec(struct xfs_mount *mp, xfs_agnumber_t agno,
+			ino_tree_node_t *ino_rec)
 {
 	ASSERT(inode_tree_ptrs != NULL);
+	ASSERT(agno < mp->m_sb.sb_agcount);
 	ASSERT(inode_tree_ptrs[agno] != NULL);
 
 	avl_delete(inode_uncertain_tree_ptrs[agno], &ino_rec->avl_node);
@@ -474,7 +476,7 @@ clear_uncertain_ino_cache(xfs_agnumber_t agno)
  * don't.
  */
 static ino_tree_node_t *
-add_inode(xfs_agnumber_t agno, xfs_agino_t ino)
+add_inode(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agino_t ino)
 {
 	ino_tree_node_t *ino_rec;
 
@@ -495,9 +497,10 @@ add_inode(xfs_agnumber_t agno, xfs_agino_t ino)
  * pull the indicated inode record out of the inode tree
  */
 void
-get_inode_rec(xfs_agnumber_t agno, ino_tree_node_t *ino_rec)
+get_inode_rec(struct xfs_mount *mp, xfs_agnumber_t agno, ino_tree_node_t *ino_rec)
 {
 	ASSERT(inode_tree_ptrs != NULL);
+	ASSERT(agno < mp->m_sb.sb_agcount);
 	ASSERT(inode_tree_ptrs[agno] != NULL);
 
 	avl_delete(inode_tree_ptrs[agno], &ino_rec->avl_node);
@@ -518,14 +521,18 @@ free_inode_rec(xfs_agnumber_t agno, ino_tree_node_t *ino_rec)
 }
 
 void
-find_inode_rec_range(xfs_agnumber_t agno, xfs_agino_t start_ino,
-			xfs_agino_t end_ino, ino_tree_node_t **first,
-			ino_tree_node_t **last)
+find_inode_rec_range(struct xfs_mount *mp, xfs_agnumber_t agno,
+			xfs_agino_t start_ino, xfs_agino_t end_ino,
+			ino_tree_node_t **first, ino_tree_node_t **last)
 {
 	*first = *last = NULL;
 
-	avl_findranges(inode_tree_ptrs[agno], start_ino,
-		end_ino, (avlnode_t **) first, (avlnode_t **) last);
+	/*
+	 * Is the AG inside the file system ?
+	 */
+	if (agno < mp->m_sb.sb_agcount)
+		avl_findranges(inode_tree_ptrs[agno], start_ino,
+			end_ino, (avlnode_t **) first, (avlnode_t **) last);
 }
 
 /*
@@ -534,7 +541,7 @@ find_inode_rec_range(xfs_agnumber_t agno, xfs_agino_t start_ino,
  * whichever alignment is larger.
  */
 ino_tree_node_t *
-set_inode_used_alloc(xfs_agnumber_t agno, xfs_agino_t ino)
+set_inode_used_alloc(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agino_t ino)
 {
 	ino_tree_node_t *ino_rec;
 
@@ -543,7 +550,7 @@ set_inode_used_alloc(xfs_agnumber_t agno, xfs_agino_t ino)
 	 * is too see if the chunk overlaps another chunk
 	 * already in the tree
 	 */
-	ino_rec = add_inode(agno, ino);
+	ino_rec = add_inode(mp, agno, ino);
 
 	ASSERT(ino_rec != NULL);
 	ASSERT(ino >= ino_rec->ino_startnum &&
@@ -555,11 +562,11 @@ set_inode_used_alloc(xfs_agnumber_t agno, xfs_agino_t ino)
 }
 
 ino_tree_node_t *
-set_inode_free_alloc(xfs_agnumber_t agno, xfs_agino_t ino)
+set_inode_free_alloc(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agino_t ino)
 {
 	ino_tree_node_t *ino_rec;
 
-	ino_rec = add_inode(agno, ino);
+	ino_rec = add_inode(mp, agno, ino);
 
 	ASSERT(ino_rec != NULL);
 	ASSERT(ino >= ino_rec->ino_startnum &&
diff --git a/repair/phase2.c b/repair/phase2.c
index 1e9377e..51bd04e 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -145,7 +145,7 @@ phase2(
 	/*
 	 * make sure we know about the root inode chunk
 	 */
-	if ((ino_rec = find_inode_rec(0, mp->m_sb.sb_rootino)) == NULL)  {
+	if ((ino_rec = find_inode_rec(mp, 0, mp->m_sb.sb_rootino)) == NULL)  {
 		ASSERT(mp->m_sb.sb_rbmino == mp->m_sb.sb_rootino + 1 &&
 			mp->m_sb.sb_rsumino == mp->m_sb.sb_rootino + 2);
 		do_warn(_("root inode chunk not found\n"));
@@ -153,7 +153,7 @@ phase2(
 		/*
 		 * mark the first 3 used, the rest are free
 		 */
-		ino_rec = set_inode_used_alloc(0,
+		ino_rec = set_inode_used_alloc(mp, 0,
 				(xfs_agino_t) mp->m_sb.sb_rootino);
 		set_inode_used(ino_rec, 1);
 		set_inode_used(ino_rec, 2);
diff --git a/repair/phase3.c b/repair/phase3.c
index 32e855c..fea81f8 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -56,7 +56,7 @@ walk_unlinked_list(xfs_mount_t *mp, xfs_agnumber_t agno, xfs_agino_t start_ino)
 			 * inode.  if so, put it on the uncertain inode list
 			 * and set block map appropriately.
 			 */
-			if (find_inode_rec(agno, current_ino) == NULL)  {
+			if (find_inode_rec(mp, agno, current_ino) == NULL)  {
 				add_aginode_uncertain(agno, current_ino, 1);
 				agbno = XFS_AGINO_TO_AGBNO(mp, current_ino);
 
diff --git a/repair/phase4.c b/repair/phase4.c
index aaef1f9..374ed39 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -49,7 +49,7 @@ quotino_check(xfs_mount_t *mp)
 		if (verify_inum(mp, mp->m_sb.sb_uquotino))
 			irec = NULL;
 		else
-			irec = find_inode_rec(
+			irec = find_inode_rec(mp,
 				XFS_INO_TO_AGNO(mp, mp->m_sb.sb_uquotino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_uquotino));
 
@@ -65,7 +65,7 @@ quotino_check(xfs_mount_t *mp)
 		if (verify_inum(mp, mp->m_sb.sb_gquotino))
 			irec = NULL;
 		else
-			irec = find_inode_rec(
+			irec = find_inode_rec(mp,
 				XFS_INO_TO_AGNO(mp, mp->m_sb.sb_gquotino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_gquotino));
 
@@ -206,7 +206,7 @@ phase4(xfs_mount_t *mp)
 
 	set_progress_msg(PROG_FMT_DUP_EXTENT, (__uint64_t) glob_agcount);
 
-	irec = find_inode_rec(XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
 
 	/*
diff --git a/repair/phase5.c b/repair/phase5.c
index d6a0f6a..125ea01 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1383,7 +1383,7 @@ keep_fsinos(xfs_mount_t *mp)
 	ino_tree_node_t		*irec;
 	int			i;
 
-	irec = find_inode_rec(XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
 
 	for (i = 0; i < 3; i++)
diff --git a/repair/phase6.c b/repair/phase6.c
index d056063..ad6d16f 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -806,7 +806,7 @@ mk_root_dir(xfs_mount_t *mp)
 
 	libxfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
 
-	irec = find_inode_rec(XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
 	set_inode_isadir(irec, XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino) -
 				irec->ino_startnum);
@@ -897,7 +897,8 @@ mk_orphanage(xfs_mount_t *mp)
 	 * for .. in the new directory
 	 */
 	pip->i_d.di_nlink++;
-	add_inode_ref(find_inode_rec(XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
+	add_inode_ref(find_inode_rec(mp,
+				XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino)), 0);
 
 
@@ -966,7 +967,7 @@ mv_orphanage(
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
 	if (isa_dir)  {
-		irec = find_inode_rec(XFS_INO_TO_AGNO(mp, orphanage_ino),
+		irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, orphanage_ino),
 				XFS_INO_TO_AGINO(mp, orphanage_ino));
 		if (irec)
 			ino_offset = XFS_INO_TO_AGINO(mp, orphanage_ino) -
@@ -1379,7 +1380,7 @@ lf_block_dir_entry_check(xfs_mount_t		*mp,
 		/*
 		 * ok, now handle the rest of the cases besides '.' and '..'
 		 */
-		irec = find_inode_rec(XFS_INO_TO_AGNO(mp, lino),
+		irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, lino),
 					XFS_INO_TO_AGINO(mp, lino));
 
 		if (irec == NULL)  {
@@ -2044,7 +2045,7 @@ longform_dir2_entry_check_data(
 		fname[dep->namelen] = '\0';
 		ASSERT(inum != NULLFSINO);
 
-		irec = find_inode_rec(XFS_INO_TO_AGNO(mp, inum),
+		irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, inum),
 					XFS_INO_TO_AGINO(mp, inum));
 		if (irec == NULL)  {
 			nbad++;
@@ -2680,7 +2681,7 @@ shortform_dir_entry_check(xfs_mount_t	*mp,
 		ASSERT(no_modify || lino != NULLFSINO);
 		ASSERT(no_modify || !verify_inum(mp, lino));
 
-		irec = find_inode_rec(XFS_INO_TO_AGNO(mp, lino),
+		irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, lino),
 					XFS_INO_TO_AGINO(mp, lino));
 		if (irec == NULL) {
 			do_warn(_("entry \"%s\" in shortform dir %llu "
@@ -3004,7 +3005,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 			continue;
 		}
 
-		irec = find_inode_rec(XFS_INO_TO_AGNO(mp, lino),
+		irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, lino),
 					XFS_INO_TO_AGINO(mp, lino));
 
 		if (irec == NULL)  {
@@ -3493,7 +3494,7 @@ mark_standalone_inodes(xfs_mount_t *mp)
 	ino_tree_node_t		*irec;
 	int			offset;
 
-	irec = find_inode_rec(XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rbmino),
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rbmino),
 			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rbmino));
 
 	ASSERT(irec != NULL);
@@ -3503,7 +3504,7 @@ mark_standalone_inodes(xfs_mount_t *mp)
 
 	add_inode_reached(irec, offset);
 
-	irec = find_inode_rec(XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rsumino),
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rsumino),
 			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rsumino));
 
 	offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rsumino) -
@@ -3516,7 +3517,7 @@ mark_standalone_inodes(xfs_mount_t *mp)
 	if (fs_quotas)  {
 		if (mp->m_sb.sb_uquotino
 				&& mp->m_sb.sb_uquotino != NULLFSINO)  {
-			irec = find_inode_rec(XFS_INO_TO_AGNO(mp,
+			irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp,
 						mp->m_sb.sb_uquotino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_uquotino));
 			offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_uquotino)
@@ -3525,7 +3526,7 @@ mark_standalone_inodes(xfs_mount_t *mp)
 		}
 		if (mp->m_sb.sb_gquotino
 				&& mp->m_sb.sb_gquotino != NULLFSINO)  {
-			irec = find_inode_rec(XFS_INO_TO_AGNO(mp,
+			irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp,
 						mp->m_sb.sb_gquotino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_gquotino));
 			offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_gquotino)
@@ -3723,7 +3724,7 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 
 	do_log(_("        - traversing filesystem ...\n"));
 
-	irec = find_inode_rec(XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
 
 	/*
diff --git a/repair/scan.c b/repair/scan.c
index afed693..aeb31fc 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -810,7 +810,7 @@ _("inode chunk claims used block, inobt block - agno %d, bno %d, inopb %d\n"),
 	/*
 	 * ensure only one avl entry per chunk
 	 */
-	find_inode_rec_range(agno, ino, ino + XFS_INODES_PER_CHUNK,
+	find_inode_rec_range(mp, agno, ino, ino + XFS_INODES_PER_CHUNK,
 			     &first_rec, &last_rec);
 	if (first_rec != NULL)  {
 		/*
@@ -841,9 +841,9 @@ _("inode rec for ino %llu (%d/%d) overlaps existing rec (start %d/%d)\n"),
 	if (!suspect)  {
 		if (XFS_INOBT_IS_FREE_DISK(rp, 0)) {
 			nfree++;
-			ino_rec = set_inode_free_alloc(agno, ino);
+			ino_rec = set_inode_free_alloc(mp, agno, ino);
 		} else  {
-			ino_rec = set_inode_used_alloc(agno, ino);
+			ino_rec = set_inode_used_alloc(mp, agno, ino);
 		}
 		for (j = 1; j < XFS_INODES_PER_CHUNK; j++) {
 			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
