Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82Hvi2s034370 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:57:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D834215B1A29
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:58:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id j5ECizDNz8VHycsP for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:58:40 -0700 (PDT)
Message-Id: <20090902175840.403232401@bombadil.infradead.org>
Date: Wed, 02 Sep 2009 13:55:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/14] repair: split up scanfunc_ino
References: <20090902175531.469184575@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-split-scanfunc_ino
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

Split out a helper to scan a single inode chunk for suspect inodes from
scanfunc_ino to make it more readable.


Signed-off-by: Barry Naujok <bnaujok@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/scan.c
===================================================================
--- xfsprogs-dev.orig/repair/scan.c	2009-08-21 19:00:15.000000000 +0000
+++ xfsprogs-dev/repair/scan.c	2009-08-21 19:03:26.000000000 +0000
@@ -625,6 +625,167 @@ scanfunc_cnt(
 				suspect, isroot, XFS_ABTC_MAGIC);
 }
 
+static int
+scan_single_ino_chunk(
+	xfs_agnumber_t		agno,
+	xfs_inobt_rec_t		*rp,
+	int			suspect)
+{
+	xfs_ino_t		lino;
+	xfs_agino_t		ino;
+	xfs_agblock_t		agbno;
+	int			j;
+	int			nfree;
+	int			off;
+	int			state;
+	ino_tree_node_t		*ino_rec, *first_rec, *last_rec;
+
+	ino = be32_to_cpu(rp->ir_startino);
+	off = XFS_AGINO_TO_OFFSET(mp, ino);
+	agbno = XFS_AGINO_TO_AGBNO(mp, ino);
+	lino = XFS_AGINO_TO_INO(mp, agno, ino);
+
+	/*
+	 * on multi-block block chunks, all chunks start
+	 * at the beginning of the block.  with multi-chunk
+	 * blocks, all chunks must start on 64-inode boundaries
+	 * since each block can hold N complete chunks. if
+	 * fs has aligned inodes, all chunks must start
+	 * at a fs_ino_alignment*N'th agbno.  skip recs
+	 * with badly aligned starting inodes.
+	 */
+	if (ino == 0 ||
+	    (inodes_per_block <= XFS_INODES_PER_CHUNK && off !=  0) ||
+	    (inodes_per_block > XFS_INODES_PER_CHUNK &&
+	     off % XFS_INODES_PER_CHUNK != 0) ||
+	    (fs_aligned_inodes && agbno % fs_ino_alignment != 0))  {
+		do_warn(
+	_("badly aligned inode rec (starting inode = %llu)\n"),
+			lino);
+		suspect++;
+	}
+
+	/*
+	 * verify numeric validity of inode chunk first
+	 * before inserting into a tree.  don't have to
+	 * worry about the overflow case because the
+	 * starting ino number of a chunk can only get
+	 * within 255 inodes of max (NULLAGINO).  if it
+	 * gets closer, the agino number will be illegal
+	 * as the agbno will be too large.
+	 */
+	if (verify_aginum(mp, agno, ino))  {
+		do_warn(
+_("bad starting inode # (%llu (0x%x 0x%x)) in ino rec, skipping rec\n"),
+			lino, agno, ino);
+		return ++suspect;
+	}
+
+	if (verify_aginum(mp, agno,
+			ino + XFS_INODES_PER_CHUNK - 1))  {
+		do_warn(
+_("bad ending inode # (%llu (0x%x 0x%x)) in ino rec, skipping rec\n"),
+			lino + XFS_INODES_PER_CHUNK - 1,
+			agno, ino + XFS_INODES_PER_CHUNK - 1);
+		return ++suspect;
+	}
+
+	/*
+	 * set state of each block containing inodes
+	 */
+	if (off == 0 && !suspect)  {
+		for (j = 0;
+		     j < XFS_INODES_PER_CHUNK;
+		     j += mp->m_sb.sb_inopblock)  {
+			agbno = XFS_AGINO_TO_AGBNO(mp, ino + j);
+			state = get_agbno_state(mp, agno, agbno);
+			if (state == XR_E_UNKNOWN)  {
+				set_agbno_state(mp, agno, agbno, XR_E_INO);
+			} else if (state == XR_E_INUSE_FS && agno == 0 &&
+				   ino + j >= first_prealloc_ino &&
+				   ino + j < last_prealloc_ino)  {
+				set_agbno_state(mp, agno, agbno, XR_E_INO);
+			} else  {
+				do_warn(
+_("inode chunk claims used block, inobt block - agno %d, bno %d, inopb %d\n"),
+					agno, agbno,
+				mp->m_sb.sb_inopblock);
+				/*
+				 * XXX - maybe should mark
+				 * block a duplicate
+				 */
+				return ++suspect;
+			}
+		}
+	}
+
+	/*
+	 * ensure only one avl entry per chunk
+	 */
+	find_inode_rec_range(agno, ino, ino + XFS_INODES_PER_CHUNK,
+			     &first_rec, &last_rec);
+	if (first_rec != NULL)  {
+		/*
+		 * this chunk overlaps with one (or more)
+		 * already in the tree
+		 */
+		do_warn(
+_("inode rec for ino %llu (%d/%d) overlaps existing rec (start %d/%d)\n"),
+			lino, agno, ino, agno, first_rec->ino_startnum);
+		suspect++;
+
+		/*
+		 * if the 2 chunks start at the same place,
+		 * then we don't have to put this one
+		 * in the uncertain list.  go to the next one.
+		 */
+		if (first_rec->ino_startnum == ino)
+			return suspect;
+	}
+
+	nfree = 0;
+
+	/*
+	 * now mark all the inodes as existing and free or used.
+	 * if the tree is suspect, put them into the uncertain
+	 * inode tree.
+	 */
+	if (!suspect)  {
+		if (XFS_INOBT_IS_FREE_DISK(rp, 0)) {
+			nfree++;
+			ino_rec = set_inode_free_alloc(agno, ino);
+		} else  {
+			ino_rec = set_inode_used_alloc(agno, ino);
+		}
+		for (j = 1; j < XFS_INODES_PER_CHUNK; j++) {
+			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
+				nfree++;
+				set_inode_free(ino_rec, j);
+			} else  {
+				set_inode_used(ino_rec, j);
+			}
+		}
+	} else  {
+		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
+			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
+				nfree++;
+				add_aginode_uncertain(agno, ino + j, 1);
+			} else  {
+				add_aginode_uncertain(agno, ino + j, 0);
+			}
+		}
+	}
+
+	if (nfree != be32_to_cpu(rp->ir_freecount)) {
+		do_warn(_("ir_freecount/free mismatch, inode "
+			"chunk %d/%d, freecount %d nfree %d\n"),
+			agno, ino, be32_to_cpu(rp->ir_freecount), nfree);
+	}
+
+	return suspect;
+}
+
+
 /*
  * this one walks the inode btrees sucking the info there into
  * the incore avl tree.  We try and rescue corrupted btree records
@@ -651,18 +812,11 @@ scanfunc_ino(
 	int			isroot
 	)
 {
-	xfs_ino_t		lino;
 	int			i;
-	xfs_agino_t		ino;
-	xfs_agblock_t		agbno;
-	int			j;
-	int			nfree;
-	int			off;
 	int			numrecs;
 	int			state;
 	xfs_inobt_ptr_t		*pp;
 	xfs_inobt_rec_t		*rp;
-	ino_tree_node_t		*ino_rec, *first_rec, *last_rec;
 	int			hdr_errors;
 
 	hdr_errors = 0;
@@ -737,165 +891,8 @@ _("inode btree block claimed (state %d),
 		 * of INODES_PER_CHUNK (64) inodes.  off is the offset into
 		 * the block.  skip processing of bogus records.
 		 */
-		for (i = 0; i < numrecs; i++) {
-			ino = be32_to_cpu(rp[i].ir_startino);
-			off = XFS_AGINO_TO_OFFSET(mp, ino);
-			agbno = XFS_AGINO_TO_AGBNO(mp, ino);
-			lino = XFS_AGINO_TO_INO(mp, agno, ino);
-			/*
-			 * on multi-block block chunks, all chunks start
-			 * at the beginning of the block.  with multi-chunk
-			 * blocks, all chunks must start on 64-inode boundaries
-			 * since each block can hold N complete chunks. if
-			 * fs has aligned inodes, all chunks must start
-			 * at a fs_ino_alignment*N'th agbno.  skip recs
-			 * with badly aligned starting inodes.
-			 */
-			if (ino == 0 ||
-			    (inodes_per_block <= XFS_INODES_PER_CHUNK &&
-			     off !=  0) ||
-			    (inodes_per_block > XFS_INODES_PER_CHUNK &&
-			     off % XFS_INODES_PER_CHUNK != 0) ||
-			    (fs_aligned_inodes &&
-			     agbno % fs_ino_alignment != 0))  {
-				do_warn(
-			_("badly aligned inode rec (starting inode = %llu)\n"),
-					lino);
-				suspect++;
-			}
-
-			/*
-			 * verify numeric validity of inode chunk first
-			 * before inserting into a tree.  don't have to
-			 * worry about the overflow case because the
-			 * starting ino number of a chunk can only get
-			 * within 255 inodes of max (NULLAGINO).  if it
-			 * gets closer, the agino number will be illegal
-			 * as the agbno will be too large.
-			 */
-			if (verify_aginum(mp, agno, ino))  {
-				do_warn(
-_("bad starting inode # (%llu (0x%x 0x%x)) in ino rec, skipping rec\n"),
-					lino, agno, ino);
-				suspect++;
-				continue;
-			}
-
-			if (verify_aginum(mp, agno,
-					ino + XFS_INODES_PER_CHUNK - 1))  {
-				do_warn(
-_("bad ending inode # (%llu (0x%x 0x%x)) in ino rec, skipping rec\n"),
-					lino + XFS_INODES_PER_CHUNK - 1,
-					agno, ino + XFS_INODES_PER_CHUNK - 1);
-				suspect++;
-				continue;
-			}
-
-			/*
-			 * set state of each block containing inodes
-			 */
-			if (off == 0 && !suspect)  {
-				for (j = 0;
-				     j < XFS_INODES_PER_CHUNK;
-				     j += mp->m_sb.sb_inopblock)  {
-					agbno = XFS_AGINO_TO_AGBNO(mp, ino + j);
-					state = get_agbno_state(mp,
-							agno, agbno);
-
-					if (state == XR_E_UNKNOWN)  {
-						set_agbno_state(mp, agno,
-							agbno, XR_E_INO);
-					} else if (state == XR_E_INUSE_FS &&
-						agno == 0 &&
-						ino + j >= first_prealloc_ino &&
-						ino + j < last_prealloc_ino)  {
-						set_agbno_state(mp, agno,
-							agbno, XR_E_INO);
-					} else  {
-						do_warn(
-_("inode chunk claims used block, inobt block - agno %d, bno %d, inopb %d\n"),
-							agno, bno,
-							mp->m_sb.sb_inopblock);
-						suspect++;
-						/*
-						 * XXX - maybe should mark
-						 * block a duplicate
-						 */
-						continue;
-					}
-				}
-			}
-			/*
-			 * ensure only one avl entry per chunk
-			 */
-			find_inode_rec_range(agno, ino,
-					ino + XFS_INODES_PER_CHUNK,
-					&first_rec,
-					&last_rec);
-			if (first_rec != NULL)  {
-				/*
-				 * this chunk overlaps with one (or more)
-				 * already in the tree
-				 */
-				do_warn(
-_("inode rec for ino %llu (%d/%d) overlaps existing rec (start %d/%d)\n"),
-					lino, agno, ino,
-					agno, first_rec->ino_startnum);
-				suspect++;
-
-				/*
-				 * if the 2 chunks start at the same place,
-				 * then we don't have to put this one
-				 * in the uncertain list.  go to the next one.
-				 */
-				if (first_rec->ino_startnum == ino)
-					continue;
-			}
-
-			nfree = 0;
-
-			/*
-			 * now mark all the inodes as existing and free or used.
-			 * if the tree is suspect, put them into the uncertain
-			 * inode tree.
-			 */
-			if (!suspect)  {
-				if (XFS_INOBT_IS_FREE_DISK(&rp[i], 0)) {
-					nfree++;
-					ino_rec = set_inode_free_alloc(agno,
-									ino);
-				} else  {
-					ino_rec = set_inode_used_alloc(agno,
-									ino);
-				}
-				for (j = 1; j < XFS_INODES_PER_CHUNK; j++) {
-					if (XFS_INOBT_IS_FREE_DISK(&rp[i], j)) {
-						nfree++;
-						set_inode_free(ino_rec, j);
-					} else  {
-						set_inode_used(ino_rec, j);
-					}
-				}
-			} else  {
-				for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
-					if (XFS_INOBT_IS_FREE_DISK(&rp[i], j)) {
-						nfree++;
-						add_aginode_uncertain(agno,
-								ino + j, 1);
-					} else  {
-						add_aginode_uncertain(agno,
-								ino + j, 0);
-					}
-				}
-			}
-
-			if (nfree != be32_to_cpu(rp[i].ir_freecount)) {
-				do_warn(_("ir_freecount/free mismatch, inode "
-					"chunk %d/%d, freecount %d nfree %d\n"),
-					agno, ino,
-					be32_to_cpu(rp[i].ir_freecount), nfree);
-			}
-		}
+		for (i = 0; i < numrecs; i++)
+			suspect = scan_single_ino_chunk(agno, &rp[i], suspect);
 
 		if (suspect)
 			bad_ino_btree = 1;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
