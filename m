Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A4EBD7F51
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 09:08:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 803D0304051
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 07:08:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id g9MXntJRebXwsy0r (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2015 07:08:29 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 0780C347A41
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 15:08:28 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] xfsprogs: Remove trailing blanks on various places
Date: Thu, 10 Dec 2015 16:08:09 +0100
Message-Id: <1449760089-64498-1-git-send-email-jtulak@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jan Tulak <jtulak@redhat.com>

Clean up the code a little by removing blank characters on line ends.
Most of these (if not all) sits there for long time and it is probable
that without this explicit removal, they will stay in the code for much
longer.

Note:
I decided to remove them because I have enabled highlighting of these,
and they were flashing into my eyes whenever I scrolled around. :-)

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 copy/xfs_copy.c           |  4 +--
 copy/xfs_copy.h           |  1 -
 db/bmap.c                 |  2 +-
 db/check.c                | 76 +++++++++++++++++++++++------------------------
 db/dir2sf.c               |  1 -
 db/frag.c                 | 10 +++----
 db/inode.c                |  4 +--
 db/input.c                |  4 +--
 db/sb.c                   |  2 +-
 db/symlink.c              |  1 -
 include/atomic.h          |  1 -
 include/builddefs.in      |  2 +-
 include/install-sh        | 16 +++++-----
 include/kmem.h            |  2 +-
 include/libxlog.h         |  4 +--
 include/xfs_mount.h       |  1 -
 io/fiemap.c               |  2 +-
 io/mmap.c                 |  2 +-
 io/parent.c               |  2 +-
 libhandle/handle.c        |  2 +-
 libxcmd/paths.c           |  3 +-
 libxfs/Makefile           |  1 -
 libxfs/darwin.c           |  1 -
 libxfs/init.c             |  2 +-
 libxfs/kmem.c             |  3 +-
 libxfs/util.c             |  4 +--
 libxfs/xfs_attr_leaf.c    |  2 +-
 libxfs/xfs_dquot_buf.c    |  1 -
 libxfs/xfs_format.h       |  2 +-
 libxfs/xfs_ialloc.c       |  2 +-
 libxfs/xfs_rtbitmap.c     |  1 -
 libxfs/xfs_trans_resv.c   |  2 +-
 logprint/log_print_all.c  |  8 ++---
 m4/manual_format.m4       |  2 +-
 m4/package_aiodev.m4      |  1 -
 m4/package_libcdev.m4     | 14 ++++-----
 mdrestore/xfs_mdrestore.c |  2 +-
 mkfs/xfs_mkfs.c           |  6 ++--
 quota/edit.c              |  8 ++---
 quota/quota.h             |  1 -
 quota/state.c             |  6 ++--
 repair/agheader.c         |  4 +--
 repair/attr_repair.c      | 32 ++++++++++----------
 repair/da_util.c          |  2 +-
 repair/dinode.c           | 12 ++++----
 repair/phase5.c           |  2 +-
 repair/phase6.c           |  2 +-
 repair/prefetch.c         |  2 +-
 repair/protos.h           |  1 -
 repair/scan.c             |  1 -
 repair/versions.c         |  2 +-
 tools/libxfs-apply        |  2 +-
 52 files changed, 129 insertions(+), 144 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 1dc7c65..b51495b 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -1054,8 +1054,8 @@ main(int argc, char **argv)
 				 * range bigger than required
 				 */
 
-				sizeb = XFS_AGB_TO_DADDR(mp, agno, 
-					be32_to_cpu(rec_ptr->ar_startblock)) - 
+				sizeb = XFS_AGB_TO_DADDR(mp, agno,
+					be32_to_cpu(rec_ptr->ar_startblock)) -
 						begin;
 				size = roundup(sizeb <<BBSHIFT, wbuf_miniosize);
 				if (size > 0)  {
diff --git a/copy/xfs_copy.h b/copy/xfs_copy.h
index 6b94130..2737068 100644
--- a/copy/xfs_copy.h
+++ b/copy/xfs_copy.h
@@ -87,4 +87,3 @@ typedef struct {
 	int		error;
 	int		err_type;
 } target_control;
-
diff --git a/db/bmap.c b/db/bmap.c
index 92057b4..c71b6b4 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -92,7 +92,7 @@ bmap(
 		fsize = XFS_DFORK_SIZE(dip, mp, whichfork);
 		pp = XFS_BMDR_PTR_ADDR(rblock, 1, xfs_bmdr_maxrecs(fsize, 0));
 		kp = XFS_BMDR_KEY_ADDR(rblock, 1);
-		bno = select_child(curoffset, kp, pp, 
+		bno = select_child(curoffset, kp, pp,
 					be16_to_cpu(rblock->bb_numrecs));
 		for (;;) {
 			set_cur(&typtab[typ], XFS_FSB_TO_DADDR(mp, bno),
diff --git a/db/check.c b/db/check.c
index 9c1541d..982a99e 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2194,7 +2194,7 @@ process_btinode(
 	}
 	if (be16_to_cpu(dib->bb_level) == 0) {
 		xfs_bmbt_rec_t	*rp = XFS_BMDR_REC_ADDR(dib, 1);
-		process_bmbt_reclist(rp, be16_to_cpu(dib->bb_numrecs), type, 
+		process_bmbt_reclist(rp, be16_to_cpu(dib->bb_numrecs), type,
 							id, totd, blkmapp);
 		*nex += be16_to_cpu(dib->bb_numrecs);
 		return;
@@ -2202,10 +2202,10 @@ process_btinode(
 		pp = XFS_BMDR_PTR_ADDR(dib, 1, xfs_bmdr_maxrecs(
 				XFS_DFORK_SIZE(dip, mp, whichfork), 0));
 		for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++)
-			scan_lbtree(be64_to_cpu(pp[i]), 
-					be16_to_cpu(dib->bb_level), 
-					scanfunc_bmap, type, id, totd, toti, 
-					nex, blkmapp, 1, 
+			scan_lbtree(be64_to_cpu(pp[i]),
+					be16_to_cpu(dib->bb_level),
+					scanfunc_bmap, type, id, totd, toti,
+					nex, blkmapp, 1,
 					whichfork == XFS_DATA_FORK ?
 						TYP_BMAPBTD : TYP_BMAPBTA);
 	}
@@ -2341,7 +2341,7 @@ process_data_dir_v2(
 				bf_err += (freeseen & (1 << i)) != 0;
 				freeseen |= 1 << i;
 			} else
-				bf_err += be16_to_cpu(dup->length) > 
+				bf_err += be16_to_cpu(dup->length) >
 						be16_to_cpu(bf[2].length);
 			ptr += be16_to_cpu(dup->length);
 			lastfree = 1;
@@ -2426,19 +2426,19 @@ process_data_dir_v2(
 			if ((char *)&lep[i] >= endptr) {
 				if (!sflag || v)
 					dbprintf(_("dir %lld block %d bad count "
-						 "%u\n"), id->ino, dabno, 
+						 "%u\n"), id->ino, dabno,
 						be32_to_cpu(btp->count));
 				error++;
 				break;
 			}
 			if (be32_to_cpu(lep[i].address) == XFS_DIR2_NULL_DATAPTR)
 				stale++;
-			else if (dir_hash_see(be32_to_cpu(lep[i].hashval), 
+			else if (dir_hash_see(be32_to_cpu(lep[i].hashval),
 						be32_to_cpu(lep[i].address))) {
 				if (!sflag || v)
 					dbprintf(_("dir %lld block %d extra leaf "
-						 "entry %x %x\n"), 
-						id->ino, dabno, 
+						 "entry %x %x\n"),
+						id->ino, dabno,
 						be32_to_cpu(lep[i].hashval),
 						be32_to_cpu(lep[i].address));
 				error++;
@@ -2457,8 +2457,8 @@ process_data_dir_v2(
 	    count != be32_to_cpu(btp->count) - be32_to_cpu(btp->stale)) {
 		if (!sflag || v)
 			dbprintf(_("dir %lld block %d bad block tail count %d "
-				 "(stale %d)\n"), 
-				id->ino, dabno, be32_to_cpu(btp->count), 
+				 "(stale %d)\n"),
+				id->ino, dabno, be32_to_cpu(btp->count),
 				be32_to_cpu(btp->stale));
 		error++;
 	}
@@ -2599,7 +2599,7 @@ process_exinode(
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 	*nex = XFS_DFORK_NEXTENTS(dip, whichfork);
-	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) / 
+	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
 						sizeof(xfs_bmbt_rec_t)) {
 		if (!sflag || id->ilist)
 			dbprintf(_("bad number of extents %d for inode %lld\n"),
@@ -3063,7 +3063,7 @@ process_leaf_node_dir_v3_free(
 
 	free = iocur_top->data;
 	maxent = M_DIROPS(mp)->free_max_bests(mp->m_dir_geo);
-	if (be32_to_cpu(free->hdr.firstdb) != xfs_dir2_da_to_db(mp->m_dir_geo, 
+	if (be32_to_cpu(free->hdr.firstdb) != xfs_dir2_da_to_db(mp->m_dir_geo,
 					dabno - mp->m_dir_geo->freeblk) * maxent) {
 		if (!sflag || v)
 			dbprintf(_("bad free block firstdb %d for dir ino %lld "
@@ -3072,16 +3072,16 @@ process_leaf_node_dir_v3_free(
 		error++;
 		return;
 	}
-	if (be32_to_cpu(free->hdr.nvalid) > maxent || 
+	if (be32_to_cpu(free->hdr.nvalid) > maxent ||
 				be32_to_cpu(free->hdr.nvalid) < 0 ||
-				be32_to_cpu(free->hdr.nused) > maxent || 
+				be32_to_cpu(free->hdr.nused) > maxent ||
 				be32_to_cpu(free->hdr.nused) < 0 ||
-				be32_to_cpu(free->hdr.nused) > 
+				be32_to_cpu(free->hdr.nused) >
 					be32_to_cpu(free->hdr.nvalid)) {
 		if (!sflag || v)
 			dbprintf(_("bad free block nvalid/nused %d/%d for dir "
 				 "ino %lld block %d\n"),
-				be32_to_cpu(free->hdr.nvalid), 
+				be32_to_cpu(free->hdr.nvalid),
 				be32_to_cpu(free->hdr.nused), id->ino, dabno);
 		error++;
 		return;
@@ -3095,21 +3095,21 @@ process_leaf_node_dir_v3_free(
 			if (!sflag || v)
 				dbprintf(_("bad free block ent %d is %d should "
 					 "be %d for dir ino %lld block %d\n"),
-					i, be16_to_cpu(free->bests[i]), ent, 
+					i, be16_to_cpu(free->bests[i]), ent,
 					id->ino, dabno);
 			error++;
 		}
 		if (be16_to_cpu(free->bests[i]) != NULLDATAOFF)
 			used++;
 		if (ent != NULLDATAOFF)
-			freetab->ents[be32_to_cpu(free->hdr.firstdb) + i] = 
+			freetab->ents[be32_to_cpu(free->hdr.firstdb) + i] =
 								NULLDATAOFF;
 	}
 	if (used != be32_to_cpu(free->hdr.nused)) {
 		if (!sflag || v)
 			dbprintf(_("bad free block nused %d should be %d for dir "
 				 "ino %lld block %d\n"),
-				be32_to_cpu(free->hdr.nused), used, id->ino, 
+				be32_to_cpu(free->hdr.nused), used, id->ino,
 				dabno);
 		error++;
 	}
@@ -3143,7 +3143,7 @@ process_leaf_node_dir_v2_free(
 		return;
 	}
 	maxent = M_DIROPS(mp)->free_max_bests(mp->m_dir_geo);
-	if (be32_to_cpu(free->hdr.firstdb) != xfs_dir2_da_to_db(mp->m_dir_geo, 
+	if (be32_to_cpu(free->hdr.firstdb) != xfs_dir2_da_to_db(mp->m_dir_geo,
 					dabno - mp->m_dir_geo->freeblk) * maxent) {
 		if (!sflag || v)
 			dbprintf(_("bad free block firstdb %d for dir ino %lld "
@@ -3152,16 +3152,16 @@ process_leaf_node_dir_v2_free(
 		error++;
 		return;
 	}
-	if (be32_to_cpu(free->hdr.nvalid) > maxent || 
+	if (be32_to_cpu(free->hdr.nvalid) > maxent ||
 				be32_to_cpu(free->hdr.nvalid) < 0 ||
-				be32_to_cpu(free->hdr.nused) > maxent || 
+				be32_to_cpu(free->hdr.nused) > maxent ||
 				be32_to_cpu(free->hdr.nused) < 0 ||
-				be32_to_cpu(free->hdr.nused) > 
+				be32_to_cpu(free->hdr.nused) >
 					be32_to_cpu(free->hdr.nvalid)) {
 		if (!sflag || v)
 			dbprintf(_("bad free block nvalid/nused %d/%d for dir "
 				 "ino %lld block %d\n"),
-				be32_to_cpu(free->hdr.nvalid), 
+				be32_to_cpu(free->hdr.nvalid),
 				be32_to_cpu(free->hdr.nused), id->ino, dabno);
 		error++;
 		return;
@@ -3175,21 +3175,21 @@ process_leaf_node_dir_v2_free(
 			if (!sflag || v)
 				dbprintf(_("bad free block ent %d is %d should "
 					 "be %d for dir ino %lld block %d\n"),
-					i, be16_to_cpu(free->bests[i]), ent, 
+					i, be16_to_cpu(free->bests[i]), ent,
 					id->ino, dabno);
 			error++;
 		}
 		if (be16_to_cpu(free->bests[i]) != NULLDATAOFF)
 			used++;
 		if (ent != NULLDATAOFF)
-			freetab->ents[be32_to_cpu(free->hdr.firstdb) + i] = 
+			freetab->ents[be32_to_cpu(free->hdr.firstdb) + i] =
 								NULLDATAOFF;
 	}
 	if (used != be32_to_cpu(free->hdr.nused)) {
 		if (!sflag || v)
 			dbprintf(_("bad free block nused %d should be %d for dir "
 				 "ino %lld block %d\n"),
-				be32_to_cpu(free->hdr.nused), used, id->ino, 
+				be32_to_cpu(free->hdr.nused), used, id->ino,
 				dabno);
 		error++;
 	}
@@ -3238,13 +3238,13 @@ process_leaf_node_dir_v2_int(
 	switch (be16_to_cpu(leaf->hdr.info.magic)) {
 	case XFS_DIR2_LEAF1_MAGIC:
 	case XFS_DIR3_LEAF1_MAGIC:
-		if (be32_to_cpu(leaf->hdr.info.forw) || 
+		if (be32_to_cpu(leaf->hdr.info.forw) ||
 					be32_to_cpu(leaf->hdr.info.back)) {
 			if (!sflag || v)
 				dbprintf(_("bad leaf block forw/back pointers "
 					 "%d/%d for dir ino %lld block %d\n"),
 					be32_to_cpu(leaf->hdr.info.forw),
-					be32_to_cpu(leaf->hdr.info.back), 
+					be32_to_cpu(leaf->hdr.info.back),
 					id->ino, dabno);
 			error++;
 		}
@@ -3259,7 +3259,7 @@ process_leaf_node_dir_v2_int(
 		ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, leaf);
 		lbp = xfs_dir2_leaf_bests_p(ltp);
 		for (i = 0; i < be32_to_cpu(ltp->bestcount); i++) {
-			if (freetab->nents <= i || freetab->ents[i] != 
+			if (freetab->nents <= i || freetab->ents[i] !=
 						be16_to_cpu(lbp[i])) {
 				if (!sflag || v)
 					dbprintf(_("bestfree %d for dir ino %lld "
@@ -3289,7 +3289,7 @@ process_leaf_node_dir_v2_int(
 			if (!sflag || v)
 				dbprintf(_("bad node block level %d for dir ino "
 					 "%lld block %d\n"),
-					nodehdr.level, id->ino, 
+					nodehdr.level, id->ino,
 					dabno);
 			error++;
 		}
@@ -3298,7 +3298,7 @@ process_leaf_node_dir_v2_int(
 		if (!sflag || v)
 			dbprintf(_("bad directory data magic # %#x for dir ino "
 				 "%lld block %d\n"),
-				be16_to_cpu(leaf->hdr.info.magic), id->ino, 
+				be16_to_cpu(leaf->hdr.info.magic), id->ino,
 				dabno);
 		error++;
 		return;
@@ -3307,11 +3307,11 @@ process_leaf_node_dir_v2_int(
 	for (i = stale = 0; i < xfs_dir3_leaf_ents_count(leaf); i++) {
 		if (be32_to_cpu(lep[i].address) == XFS_DIR2_NULL_DATAPTR)
 			stale++;
-		else if (dir_hash_see(be32_to_cpu(lep[i].hashval), 
+		else if (dir_hash_see(be32_to_cpu(lep[i].hashval),
 						be32_to_cpu(lep[i].address))) {
 			if (!sflag || v)
 				dbprintf(_("dir %lld block %d extra leaf entry "
-					 "%x %x\n"), id->ino, dabno, 
+					 "%x %x\n"), id->ino, dabno,
 					be32_to_cpu(lep[i].hashval),
 					be32_to_cpu(lep[i].address));
 			error++;
@@ -3632,7 +3632,7 @@ process_sf_dir_v2(
 			M_DIROPS(mp)->sf_entsize(sf, sfe->namelen);
 		sfe = M_DIROPS(mp)->sf_nextentry(sf, sfe);
 	}
-	if (i < 0 && (intptr_t)sfe - (intptr_t)sf != 
+	if (i < 0 && (intptr_t)sfe - (intptr_t)sf !=
 					be64_to_cpu(dip->di_size)) {
 		if (!sflag)
 			dbprintf(_("dir %llu size is %lld, should be %u\n"),
@@ -4164,7 +4164,7 @@ scanfunc_bmap(
 	}
 	pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[0]);
 	for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++)
-		scan_lbtree(be64_to_cpu(pp[i]), level, scanfunc_bmap, type, id, 
+		scan_lbtree(be64_to_cpu(pp[i]), level, scanfunc_bmap, type, id,
 					totd, toti, nex, blkmapp, 0, btype);
 }
 
diff --git a/db/dir2sf.c b/db/dir2sf.c
index a56590b..d2b02c1 100644
--- a/db/dir2sf.c
+++ b/db/dir2sf.c
@@ -273,4 +273,3 @@ const field_t	dir3_sf_entry_flds[] = {
 	  FLD_OFFSET, TYP_NONE },
 	{ NULL }
 };
-
diff --git a/db/frag.c b/db/frag.c
index 1cc922e..3beb416 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -258,7 +258,7 @@ process_btinode(
 	pp = XFS_BMDR_PTR_ADDR(dib, 1,
 		xfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0));
 	for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++)
-		scan_lbtree(be64_to_cpu(pp[i]), be16_to_cpu(dib->bb_level), 
+		scan_lbtree(be64_to_cpu(pp[i]), be16_to_cpu(dib->bb_level),
 			scanfunc_bmap, extmapp,
 			whichfork == XFS_DATA_FORK ? TYP_BMAPBTD : TYP_BMAPBTA);
 }
@@ -377,7 +377,7 @@ scan_ag(
 		pop_cur();
 		return;
 	}
-	scan_sbtree(agf, be32_to_cpu(agi->agi_root), 
+	scan_sbtree(agf, be32_to_cpu(agi->agi_root),
 			be32_to_cpu(agi->agi_level), scanfunc_ino, TYP_INOBT);
 	pop_cur();
 	pop_cur();
@@ -457,7 +457,7 @@ scanfunc_bmap(
 	}
 	pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[0]);
 	for (i = 0; i < nrecs; i++)
-		scan_lbtree(be64_to_cpu(pp[i]), level, scanfunc_bmap, extmapp, 
+		scan_lbtree(be64_to_cpu(pp[i]), level, scanfunc_bmap, extmapp,
 									btype);
 }
 
@@ -495,7 +495,7 @@ scanfunc_ino(
 				if (XFS_INOBT_IS_FREE_DISK(&rp[i], j))
 					continue;
 				process_inode(agf, agino + j, (xfs_dinode_t *)
-					((char *)iocur_top->data + 
+					((char *)iocur_top->data +
 					((off + j) << mp->m_sb.sb_inodelog)));
 			}
 			pop_cur();
@@ -504,6 +504,6 @@ scanfunc_ino(
 	}
 	pp = XFS_INOBT_PTR_ADDR(mp, block, 1, mp->m_inobt_mxr[1]);
 	for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++)
-		scan_sbtree(agf, be32_to_cpu(pp[i]), level, scanfunc_ino, 
+		scan_sbtree(agf, be32_to_cpu(pp[i]), level, scanfunc_ino,
 								TYP_INOBT);
 }
diff --git a/db/inode.c b/db/inode.c
index 64b263b..442e6ea 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -337,7 +337,7 @@ inode_a_size(
 		asf = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
 		return bitize(be16_to_cpu(asf->hdr.totsize));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be16_to_cpu(dip->di_anextents) * 
+		return (int)be16_to_cpu(dip->di_anextents) *
 							bitsz(xfs_bmbt_rec_t);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_ASIZE(dip, mp));
@@ -595,7 +595,7 @@ inode_u_size(
 	case XFS_DINODE_FMT_LOCAL:
 		return bitize((int)be64_to_cpu(dip->di_size));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be32_to_cpu(dip->di_nextents) * 
+		return (int)be32_to_cpu(dip->di_nextents) *
 						bitsz(xfs_bmbt_rec_t);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_DSIZE(dip, mp));
diff --git a/db/input.c b/db/input.c
index a90de6c..8f65190 100644
--- a/db/input.c
+++ b/db/input.c
@@ -238,11 +238,11 @@ fetchline(void)
 static char *el_get_prompt(EditLine *e) { return get_prompt(); }
 char *
 fetchline(void)
-{     
+{
 	static EditLine	*el;
 	static History	*hist;
 	HistEvent	hevent;
-	char		*line;    
+	char		*line;
 	int		count;
 
 	if (!el) {
diff --git a/db/sb.c b/db/sb.c
index 17d446c..daddc8d 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -414,7 +414,7 @@ uuid_f(
 			/* Not set; nothing to do.  Success! */
 			if (!xfs_sb_version_hasmetauuid(&tsb))
 				return 0;
-		
+
 			memcpy(&uu, mp->m_sb.sb_meta_uuid, sizeof(uuid_t));
 		} else {
 			if (platform_uuid_parse(argv[1], &uu)) {
diff --git a/db/symlink.c b/db/symlink.c
index ce96556..c99b8ca 100644
--- a/db/symlink.c
+++ b/db/symlink.c
@@ -78,4 +78,3 @@ const struct field	symlink_crc_flds[] = {
 		symlink_count, FLD_COUNT, TYP_NONE },
 	{ NULL }
 };
-
diff --git a/include/atomic.h b/include/atomic.h
index 151c5bf..eb23467 100644
--- a/include/atomic.h
+++ b/include/atomic.h
@@ -34,4 +34,3 @@ typedef	int64_t	atomic64_t;
 #define atomic64_set(x, v)	(*(x) = v)
 
 #endif /* __ATOMIC_H__ */
-
diff --git a/include/builddefs.in b/include/builddefs.in
index c1797fd..b5ce336 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -109,7 +109,7 @@ HAVE_FLS = @have_fls@
 HAVE_FSETXATTR = @have_fsetxattr@
 HAVE_MREMAP = @have_mremap@
 
-GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
+GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
 
 ifeq ($(PKG_PLATFORM),linux)
diff --git a/include/install-sh b/include/install-sh
index c952a71..9fa706d 100755
--- a/include/install-sh
+++ b/include/install-sh
@@ -56,7 +56,7 @@ _chown ()
 		    fi
 		fi
 	       _st=0
-	    fi     
+	    fi
 	fi
     fi
 
@@ -65,7 +65,7 @@ _chown ()
 
 
 _manifest ()
-{ 
+{
     echo $* | sed -e 's/\/\//\//g' >>${DIST_MANIFEST:-/dev/null}
 }
 
@@ -116,14 +116,14 @@ do
 	DIRMODE=`expr $OPTARG`
 	FILEMODE=$DIRMODE
 	;;
-   D) 
+   D)
 	Dflag=true
 	;;
-   S) 
+   S)
 	symlink=$OPTARG
 	Sflag=true
 	;;
-   d) 
+   d)
 	dir=$DIST_ROOT/$OPTARG
 	dflag=true
 	;;
@@ -145,7 +145,7 @@ then
     #
     # first usage
     #
-    $MKDIR -p $dir 
+    $MKDIR -p $dir
     status=$?
     if [ $status -eq 0 ]
     then
@@ -171,7 +171,7 @@ then
     fi
     $LN -s -f $symlink $target
     status=$?
-    $MANIFEST l $symlink ${target#$DIST_ROOT} 
+    $MANIFEST l $symlink ${target#$DIST_ROOT}
 elif $Tflag
 then
     #
@@ -289,7 +289,7 @@ else
 	$CP $f $dir
 	status=$?
 	if [ $status -eq 0 ]
-	then 
+	then
 	    if [ -f $dir/$f ]
 	    then
 		$CHMOD $FILEMODE $dir/$f
diff --git a/include/kmem.h b/include/kmem.h
index 1893b69..5484d32 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -44,7 +44,7 @@ kmem_zone_free(kmem_zone_t *zone, void *ptr)
 extern void	*kmem_alloc(size_t, int);
 extern void	*kmem_zalloc(size_t, int);
 
-static inline void 
+static inline void
 kmem_free(void *ptr) {
 	free(ptr);
 }
diff --git a/include/libxlog.h b/include/libxlog.h
index 6c6e83a..0a11ec8 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -95,7 +95,7 @@ extern int	xlog_bread_noalign(struct xlog *log, xfs_daddr_t blk_no,
 
 extern int	xlog_find_zeroed(struct xlog *log, xfs_daddr_t *blk_no);
 extern int	xlog_find_cycle_start(struct xlog *log, xfs_buf_t *bp,
-				xfs_daddr_t first_blk, xfs_daddr_t *last_blk, 
+				xfs_daddr_t first_blk, xfs_daddr_t *last_blk,
 				uint cycle);
 extern int	xlog_find_tail(struct xlog *log, xfs_daddr_t *head_blk,
 				xfs_daddr_t *tail_blk);
@@ -115,7 +115,7 @@ extern int	xlog_do_recovery_pass(struct xlog *log, xfs_daddr_t head_blk,
 				xfs_daddr_t tail_blk, int pass);
 extern int	xlog_recover_do_trans(struct xlog *log, xlog_recover_t *trans,
 				int pass);
-extern int	xlog_header_check_recover(xfs_mount_t *mp, 
+extern int	xlog_header_check_recover(xfs_mount_t *mp,
 				xlog_rec_header_t *head);
 extern int	xlog_header_check_mount(xfs_mount_t *mp,
 				xlog_rec_header_t *head);
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 67f3b05..14b05a6 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -153,4 +153,3 @@ extern void	libxfs_umount (xfs_mount_t *);
 extern void	libxfs_rtmount_destroy (xfs_mount_t *);
 
 #endif	/* __XFS_MOUNT_H__ */
-
diff --git a/io/fiemap.c b/io/fiemap.c
index 17b38a4..f89da06 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -298,7 +298,7 @@ fiemap_f(
 							  &foff_w, &boff_w,
 							  &tot_w, &flg_w);
 				}
-					
+
 				print_verbose(extent, blocksize, foff_w,
 					      boff_w, tot_w, flg_w,
 					      max_extents, &cur_extent,
diff --git a/io/mmap.c b/io/mmap.c
index 7093650..5970069 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -166,7 +166,7 @@ mmap_f(
 		if (mapping)
 			return maplist_f();
 		fprintf(stderr, file ?
-			_("no mapped regions, try 'help mmap'\n") : 
+			_("no mapped regions, try 'help mmap'\n") :
 			_("no files are open, try 'help open'\n"));
 		return 0;
 	} else if (argc == 2) {
diff --git a/io/parent.c b/io/parent.c
index abc3402..1968516 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -141,7 +141,7 @@ check_parents(parent_t *parentbuf, size_t *parentbuf_size,
 			break;
 		}
 	} while (error == ERANGE);
-	
+
 
 	if (count == 0) {
 		/* no links for inode - something wrong here */
diff --git a/libhandle/handle.c b/libhandle/handle.c
index 7207186..236ed22 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -413,7 +413,7 @@ parents_by_handle(
 	parent_t	*buf,
 	size_t		bufsiz,
 	unsigned int	*count)
-	
+
 {
 	errno = EOPNOTSUPP;
 	return -1;
diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 5c65737..71af25f 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -515,7 +515,7 @@ out_error:
 		progname, strerror(error));
 }
 
-void 
+void
 fs_table_insert_project_path(
 	char		*dir,
 	prid_t		prid)
@@ -536,4 +536,3 @@ fs_table_insert_project_path(
 		exit(1);
 	}
 }
-
diff --git a/libxfs/Makefile b/libxfs/Makefile
index ecf1921..ca1a5ee 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -148,4 +148,3 @@ install-dev: install
 ifndef NODEP
 -include .ltdep
 endif
-
diff --git a/libxfs/darwin.c b/libxfs/darwin.c
index b9c314f..017e190 100644
--- a/libxfs/darwin.c
+++ b/libxfs/darwin.c
@@ -142,4 +142,3 @@ platform_physmem(void)
 	}
 	return physmem >> 10;
 }
-
diff --git a/libxfs/init.c b/libxfs/init.c
index c7f9dc8..8d747e8 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -840,7 +840,7 @@ libxfs_umount(xfs_mount_t *mp)
 	if (mp->m_logdev_targp != mp->m_ddev_targp)
 		kmem_free(mp->m_logdev_targp);
 	kmem_free(mp->m_ddev_targp);
-	
+
 }
 
 /*
diff --git a/libxfs/kmem.c b/libxfs/kmem.c
index 6421304..4f3cd7e 100644
--- a/libxfs/kmem.c
+++ b/libxfs/kmem.c
@@ -13,7 +13,7 @@ kmem_zone_init(int size, char *name)
 
 	if (ptr == NULL) {
 		fprintf(stderr, _("%s: zone init failed (%s, %d bytes): %s\n"),
-			progname, name, (int)sizeof(kmem_zone_t), 
+			progname, name, (int)sizeof(kmem_zone_t),
 			strerror(errno));
 		exit(1);
 	}
@@ -80,4 +80,3 @@ kmem_realloc(void *ptr, size_t new_size, size_t old_size, int flags)
 	}
 	return ptr;
 }
-
diff --git a/libxfs/util.c b/libxfs/util.c
index 0609ba4..90031fd 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -359,7 +359,7 @@ libxfs_iprint(
 		(unsigned long)ip->i_df.if_u1.if_extents);
 	if (ip->i_df.if_flags & XFS_IFEXTENTS) {
 		nextents = ip->i_df.if_bytes / (uint)sizeof(*ep);
-		for (ep = ip->i_df.if_u1.if_extents, i = 0; i < nextents; 
+		for (ep = ip->i_df.if_u1.if_extents, i = 0; i < nextents;
 								i++, ep++) {
 			xfs_bmbt_irec_t rec;
 
@@ -453,7 +453,7 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 	xfs_dinode_to_disk(dip, &ip->i_d);
 
 	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
-	if (XFS_IFORK_Q(ip)) 
+	if (XFS_IFORK_Q(ip))
 		xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK);
 
 	/* update the lsn in the on disk inode if required */
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 1186cac..d0eb0a7 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -421,7 +421,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
 	switch (dp->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		/*
-		 * If there is no attr fork and the data fork is extents, 
+		 * If there is no attr fork and the data fork is extents,
 		 * determine if creating the default attr fork will result
 		 * in the extents form migrating to btree. If so, the
 		 * minimum offset only needs to be the space required for
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 38f9703..fd4aa4b 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -294,4 +294,3 @@ const struct xfs_buf_ops xfs_dquot_buf_ops = {
 	.verify_read = xfs_dquot_buf_read_verify,
 	.verify_write = xfs_dquot_buf_write_verify,
 };
-
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 946bcd1..c0e1b70 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -21,7 +21,7 @@
 /*
  * XFS On Disk Format Definitions
  *
- * This header file defines all the on-disk format definitions for 
+ * This header file defines all the on-disk format definitions for
  * general XFS objects. Directory and attribute related objects are defined in
  * xfs_da_format.h, which log and log item formats are defined in
  * xfs_log_format.h. Everything else goes here.
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 5039f4b..c60b8d3 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1982,7 +1982,7 @@ xfs_difree_inobt(
 			goto error0;
 		}
 
-		/* 
+		/*
 		 * Change the inode free counts and log the ag/sb changes.
 		 */
 		be32_add_cpu(&agi->agi_freecount, 1);
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 0054432..5648ea5 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -983,4 +983,3 @@ xfs_rtfree_extent(
 	}
 	return 0;
 }
-
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 0c40b52..9e519a5 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -136,7 +136,7 @@ xfs_calc_finobt_res(
 
 	res = xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1));
 	if (alloc)
-		res += xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1), 
+		res += xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
 					XFS_FSB_TO_B(mp, 1));
 	if (modify)
 		res += (uint)XFS_FSB_TO_B(mp, 1);
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 9f1a7ab..ba26408 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -104,7 +104,7 @@ xlog_recover_print_buffer(
 		i++;
 		if (blkno == 0) { /* super block */
 			printf(_("	SUPER Block Buffer:\n"));
-			if (!print_buffer) 
+			if (!print_buffer)
 				continue;
 		       printf(_("              icount:%llu ifree:%llu  "),
 			       (unsigned long long)
@@ -123,7 +123,7 @@ xlog_recover_print_buffer(
 			int bucket, buckets;
 			agi = (xfs_agi_t *)p;
 			printf(_("	AGI Buffer: (XAGI)\n"));
-			if (!print_buffer) 
+			if (!print_buffer)
 				continue;
 			printf(_("		ver:%d  "),
 				be32_to_cpu(agi->agi_versionnum));
@@ -157,7 +157,7 @@ xlog_recover_print_buffer(
 		} else if (be32_to_cpu(*(__be32 *)p) == XFS_AGF_MAGIC) {
 			agf = (xfs_agf_t *)p;
 			printf(_("	AGF Buffer: (XAGF)\n"));
-			if (!print_buffer) 
+			if (!print_buffer)
 				continue;
 			printf(_("		ver:%d  seq#:%d  len:%d  \n"),
 				be32_to_cpu(agf->agf_versionnum),
@@ -179,7 +179,7 @@ xlog_recover_print_buffer(
 		} else if (*(uint *)p == XFS_DQUOT_MAGIC) {
 			ddq = (xfs_disk_dquot_t *)p;
 			printf(_("	DQUOT Buffer:\n"));
-			if (!print_buffer) 
+			if (!print_buffer)
 				continue;
 			printf(_("		UIDs 0x%lx-0x%lx\n"),
 			       (unsigned long)be32_to_cpu(ddq->d_id),
diff --git a/m4/manual_format.m4 b/m4/manual_format.m4
index 50c6a91..fa9362f 100644
--- a/m4/manual_format.m4
+++ b/m4/manual_format.m4
@@ -3,7 +3,7 @@
 # Always gzipped on Debian, but not Redhat pre-7.0.
 # We don't deal with bzip2'd man pages, which Mandrake uses,
 # someone will send us a patch sometime hopefully. :-)
-# 
+#
 AC_DEFUN([AC_MANUAL_FORMAT],
   [ have_zipped_manpages=false
     for d in ${prefix}/share/man ${prefix}/man ; do
diff --git a/m4/package_aiodev.m4 b/m4/package_aiodev.m4
index 490d9c8..5510d15 100644
--- a/m4/package_aiodev.m4
+++ b/m4/package_aiodev.m4
@@ -34,4 +34,3 @@ AC_DEFUN([AC_PACKAGE_NEED_LIO_LISTIO],
     fi
     AC_SUBST(librt)
   ])
-
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index b6a7a54..0165310 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -1,6 +1,6 @@
 # 
 # Check if we have a working fadvise system call
-# 
+#
 AC_DEFUN([AC_HAVE_FADVISE],
   [ AC_MSG_CHECKING([for fadvise ])
     AC_TRY_COMPILE([
@@ -15,9 +15,9 @@ AC_DEFUN([AC_HAVE_FADVISE],
     AC_SUBST(have_fadvise)
   ])
 
-# 
+#
 # Check if we have a working madvise system call
-# 
+#
 AC_DEFUN([AC_HAVE_MADVISE],
   [ AC_MSG_CHECKING([for madvise ])
     AC_TRY_COMPILE([
@@ -32,9 +32,9 @@ AC_DEFUN([AC_HAVE_MADVISE],
     AC_SUBST(have_madvise)
   ])
 
-# 
+#
 # Check if we have a working mincore system call
-# 
+#
 AC_DEFUN([AC_HAVE_MINCORE],
   [ AC_MSG_CHECKING([for mincore ])
     AC_TRY_COMPILE([
@@ -49,9 +49,9 @@ AC_DEFUN([AC_HAVE_MINCORE],
     AC_SUBST(have_mincore)
   ])
 
-# 
+#
 # Check if we have a working sendfile system call
-# 
+#
 AC_DEFUN([AC_HAVE_SENDFILE],
   [ AC_MSG_CHECKING([for sendfile ])
     AC_TRY_COMPILE([
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 5764616..ebc5e54 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -156,7 +156,7 @@ perform_restore(
 		if (mb_count > max_indicies)
 			fatal("bad block count: %u\n", mb_count);
 
-		if (fread(block_buffer, mb_count << tmb.mb_blocklog, 
+		if (fread(block_buffer, mb_count << tmb.mb_blocklog,
 								1, src_f) != 1)
 			fatal("error reading from file: %s\n", strerror(errno));
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7cba41a..2f59cc3 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -430,7 +430,7 @@ static void blkid_get_topology(
 	 * terms of 512 bytes blocks (only to convert it to bytes later..)
 	 */
 	*sunit = *sunit >> 9;
-	*swidth = *swidth >> 9;	
+	*swidth = *swidth >> 9;
 
 	if (blkid_topology_get_alignment_offset(tp) != 0) {
 		fprintf(stderr,
@@ -2879,7 +2879,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		 * so, reset the record count to 0 to avoid exposure of an invalid
 		 * record start block.
 		 */
-		arec->ar_blockcount = cpu_to_be32(agsize - 
+		arec->ar_blockcount = cpu_to_be32(agsize -
 					be32_to_cpu(arec->ar_startblock));
 		if (!arec->ar_blockcount)
 			block->bb_numrecs = 0;
@@ -2924,7 +2924,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		 * so, reset the record count to 0 to avoid exposure of an invalid
 		 * record start block.
 		 */
-		arec->ar_blockcount = cpu_to_be32(agsize - 
+		arec->ar_blockcount = cpu_to_be32(agsize -
 					be32_to_cpu(arec->ar_startblock));
 		if (!arec->ar_blockcount)
 			block->bb_numrecs = 0;
diff --git a/quota/edit.c b/quota/edit.c
index d226e89..c55fa1a 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -122,7 +122,7 @@ set_limits(
 	__uint64_t	*bsoft,
 	__uint64_t	*bhard,
 	__uint64_t	*isoft,
-	__uint64_t	*ihard, 
+	__uint64_t	*ihard,
 	__uint64_t	*rtbsoft,
 	__uint64_t	*rtbhard)
 {
@@ -155,7 +155,7 @@ set_user_limits(
 	__uint64_t	*bsoft,
 	__uint64_t	*bhard,
 	__uint64_t	*isoft,
-	__uint64_t	*ihard, 
+	__uint64_t	*ihard,
 	__uint64_t	*rtbsoft,
 	__uint64_t	*rtbhard)
 {
@@ -178,7 +178,7 @@ set_group_limits(
 	__uint64_t	*bsoft,
 	__uint64_t	*bhard,
 	__uint64_t	*isoft,
-	__uint64_t	*ihard, 
+	__uint64_t	*ihard,
 	__uint64_t	*rtbsoft,
 	__uint64_t	*rtbhard)
 {
@@ -201,7 +201,7 @@ set_project_limits(
 	__uint64_t	*bsoft,
 	__uint64_t	*bhard,
 	__uint64_t	*isoft,
-	__uint64_t	*ihard, 
+	__uint64_t	*ihard,
 	__uint64_t	*rtbsoft,
 	__uint64_t	*rtbhard)
 {
diff --git a/quota/quota.h b/quota/quota.h
index a905ce5..416f335 100644
--- a/quota/quota.h
+++ b/quota/quota.h
@@ -82,4 +82,3 @@ extern char *uid_to_name(__uint32_t __uid);
 extern char *gid_to_name(__uint32_t __gid);
 extern char *prid_to_name(__uint32_t __prid);
 extern bool isdigits_only(const char *);
-
diff --git a/quota/state.c b/quota/state.c
index 0173f40..8186762 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -339,14 +339,14 @@ remove_extents(
 	}
 	dir = mount->fs_name;
 	if (type & XFS_USER_QUOTA) {
-		if (remove_qtype_extents(dir, XFS_USER_QUOTA) < 0) 
+		if (remove_qtype_extents(dir, XFS_USER_QUOTA) < 0)
 			return;
 	}
 	if (type & XFS_GROUP_QUOTA) {
-		if (remove_qtype_extents(dir, XFS_GROUP_QUOTA) < 0) 
+		if (remove_qtype_extents(dir, XFS_GROUP_QUOTA) < 0)
 			return;
 	} else if (type & XFS_PROJ_QUOTA) {
-		if (remove_qtype_extents(dir, XFS_PROJ_QUOTA) < 0) 
+		if (remove_qtype_extents(dir, XFS_PROJ_QUOTA) < 0)
 			return;
 	}
 	if (flags & VERBOSE_FLAG)
diff --git a/repair/agheader.c b/repair/agheader.c
index 5e4b066..bd11ac2 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -69,7 +69,7 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
 				be32_to_cpu(agf->agf_length), i,
 				mp->m_sb.sb_agblocks);
 			if (!no_modify)
-				agf->agf_length = 
+				agf->agf_length =
 					cpu_to_be32(mp->m_sb.sb_agblocks);
 		} else  {
 			agblocks = mp->m_sb.sb_dblocks -
@@ -168,7 +168,7 @@ verify_set_agi(xfs_mount_t *mp, xfs_agi_t *agi, xfs_agnumber_t agno)
 				be32_to_cpu(agi->agi_length), agno,
 					mp->m_sb.sb_agblocks);
 			if (!no_modify)
-				agi->agi_length = 
+				agi->agi_length =
 					cpu_to_be32(mp->m_sb.sb_agblocks);
 		} else  {
 			agblocks = mp->m_sb.sb_dblocks -
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index da2800d..40cb5f7 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -243,7 +243,7 @@ process_shortform_attr(
 				do_warn(
 	_("there are no attributes in the fork for inode %" PRIu64 "\n"),
 					ino);
-				asf->hdr.totsize = 
+				asf->hdr.totsize =
 					cpu_to_be16(sizeof(xfs_attr_sf_hdr_t));
 				*repair = 1;
 				return(1);
@@ -325,7 +325,7 @@ process_shortform_attr(
 		if (currententry->flags & XFS_ATTR_ROOT)
 		       junkit |= valuecheck(mp,
 					(char *)&currententry->nameval[0],
-					NULL, currententry->namelen, 
+					NULL, currententry->namelen,
 					currententry->valuelen);
 
 		remainingspace = remainingspace -
@@ -470,7 +470,7 @@ process_leaf_attr_local(
 	xfs_attr_leaf_name_local_t *local;
 
 	local = xfs_attr3_leaf_name_local(leaf, i);
-	if (local->namelen == 0 || namecheck((char *)&local->nameval[0], 
+	if (local->namelen == 0 || namecheck((char *)&local->nameval[0],
 							local->namelen)) {
 		do_warn(
 	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
@@ -497,7 +497,7 @@ process_leaf_attr_local(
 
 	/* Only check values for root security attributes */
 	if (entry->flags & XFS_ATTR_ROOT) {
-		if (valuecheck(mp, (char *)&local->nameval[0], NULL, 
+		if (valuecheck(mp, (char *)&local->nameval[0], NULL,
 				local->namelen, be16_to_cpu(local->valuelen))) {
 			do_warn(
 	_("bad security value for attribute entry %d in attr block %u, inode %" PRIu64 "\n"),
@@ -505,7 +505,7 @@ process_leaf_attr_local(
 			return -1;
 		}
 	}
-	return xfs_attr_leaf_entsize_local(local->namelen, 
+	return xfs_attr_leaf_entsize_local(local->namelen,
 						be16_to_cpu(local->valuelen));
 }
 
@@ -525,10 +525,10 @@ process_leaf_attr_remote(
 
 	remotep = xfs_attr3_leaf_name_remote(leaf, i);
 
-	if (remotep->namelen == 0 || namecheck((char *)&remotep->name[0], 
-						remotep->namelen) || 
-			be32_to_cpu(entry->hashval) != 
-				libxfs_da_hashname((unsigned char *)&remotep->name[0], 
+	if (remotep->namelen == 0 || namecheck((char *)&remotep->name[0],
+						remotep->namelen) ||
+			be32_to_cpu(entry->hashval) !=
+				libxfs_da_hashname((unsigned char *)&remotep->name[0],
 						remotep->namelen) ||
 			be32_to_cpu(entry->hashval) < last_hashval ||
 			be32_to_cpu(remotep->valueblk) == 0) {
@@ -539,7 +539,7 @@ process_leaf_attr_remote(
 
 	if (!(entry->flags & XFS_ATTR_ROOT))
 		goto out;
- 
+
 	value = malloc(be32_to_cpu(remotep->valuelen));
 	if (value == NULL) {
 		do_warn(
@@ -673,14 +673,14 @@ process_leaf_attr_block(
 		 * since the block will get compacted anyhow by the kernel.
 		 */
 
-		if ((leafhdr.holes == 0 && 
+		if ((leafhdr.holes == 0 &&
 				firstb != leafhdr.firstused) ||
 		    		leafhdr.firstused > firstb)  {
 			if (!no_modify)  {
 				do_warn(
 	_("- resetting first used heap value from %d to %d in "
 	  "block %u of attribute fork of inode %" PRIu64 "\n"),
-					leafhdr.firstused, 
+					leafhdr.firstused,
 					firstb, da_bno, ino);
 				leafhdr.firstused = firstb;
 				*repair = 1;
@@ -688,7 +688,7 @@ process_leaf_attr_block(
 				do_warn(
 	_("- would reset first used value from %d to %d in "
 	  "block %u of attribute fork of inode %" PRIu64 "\n"),
-					leafhdr.firstused, 
+					leafhdr.firstused,
 					firstb, da_bno, ino);
 			}
 		}
@@ -698,7 +698,7 @@ process_leaf_attr_block(
 				do_warn(
 	_("- resetting usedbytes cnt from %d to %d in "
 	  "block %u of attribute fork of inode %" PRIu64 "\n"),
-					leafhdr.usedbytes, 
+					leafhdr.usedbytes,
 					usedbs, da_bno, ino);
 				leafhdr.usedbytes = usedbs;
 				*repair = 1;
@@ -706,7 +706,7 @@ process_leaf_attr_block(
 				do_warn(
 	_("- would reset usedbytes cnt from %d to %d in "
 	  "block %u of attribute fork of %" PRIu64 "\n"),
-					leafhdr.usedbytes, 
+					leafhdr.usedbytes,
 					usedbs, da_bno, ino);
 			}
 		}
@@ -988,7 +988,7 @@ process_longform_attr(
 	bno = blkmap_get(blkmap, 0);
 
 	if ( bno == NULLFSBLOCK ) {
-		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS && 
+		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
 				be16_to_cpu(dip->di_anextents) == 0)
 			return(0); /* the kernel can handle this state */
 		do_warn(
diff --git a/repair/da_util.c b/repair/da_util.c
index 89d41cc..a65652f 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -386,7 +386,7 @@ _("bad %s forward block pointer, expected 0, saw %u\n"),
 	}
 	/*
 	 * keep track of greatest block # -- that gets
-	 * us the length of the directory/attribute 
+	 * us the length of the directory/attribute
 	 */
 	if (cursor->level[this_level].bno > cursor->greatest_bno)
 		cursor->greatest_bno = cursor->level[this_level].bno;
diff --git a/repair/dinode.c b/repair/dinode.c
index 43142d6..3fec9f4 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -288,9 +288,9 @@ verify_ag_bno(xfs_sb_t *sbp,
 		xfs_agnumber_t agno,
 		xfs_agblock_t agbno)
 {
-	if (agno < (sbp->sb_agcount - 1)) 
+	if (agno < (sbp->sb_agcount - 1))
 		return (agbno >= sbp->sb_agblocks);
-	if (agno == (sbp->sb_agcount - 1)) 
+	if (agno == (sbp->sb_agcount - 1))
 		return (agbno >= (sbp->sb_dblocks -
 				((xfs_rfsblock_t)(sbp->sb_agcount - 1) *
 				 sbp->sb_agblocks)));
@@ -1159,7 +1159,7 @@ process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dino)
 	int			max_blocks;
 
 	if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp)) {
-		if (dino->di_format == XFS_DINODE_FMT_LOCAL)  
+		if (dino->di_format == XFS_DINODE_FMT_LOCAL)
 			return 0;
 		do_warn(
 _("mismatch between format (%d) and size (%" PRId64 ") in symlink ino %" PRIu64 "\n"),
@@ -1359,7 +1359,7 @@ process_symlink(
 		 * local symlink, just copy the symlink out of the
 		 * inode into the data area
 		 */
-		memmove(symlink, XFS_DFORK_DPTR(dino), 
+		memmove(symlink, XFS_DFORK_DPTR(dino),
 						be64_to_cpu(dino->di_size));
 	} else {
 		int error;
@@ -1934,7 +1934,7 @@ process_inode_data_fork(
 		 */
 		switch (dino->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
-			err = process_lclinode(mp, agno, ino, dino, 
+			err = process_lclinode(mp, agno, ino, dino,
 						XFS_DATA_FORK);
 			break;
 		case XFS_DINODE_FMT_EXTENTS:
@@ -2068,7 +2068,7 @@ process_inode_attr_fork(
 	if (check_dups)  {
 		switch (dino->di_aformat) {
 		case XFS_DINODE_FMT_LOCAL:
-			err = process_lclinode(mp, agno, ino, dino, 
+			err = process_lclinode(mp, agno, ino, dino,
 						XFS_ATTR_FORK);
 			break;
 		case XFS_DINODE_FMT_EXTENTS:
diff --git a/repair/phase5.c b/repair/phase5.c
index 109e37b..5d48848 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1124,7 +1124,7 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 	agi->agi_newino = cpu_to_be32(agi_stat->first_agino);
 	agi->agi_dirino = cpu_to_be32(NULLAGINO);
 
-	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)  
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
 		agi->agi_unlinked[i] = cpu_to_be32(NULLAGINO);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
diff --git a/repair/phase6.c b/repair/phase6.c
index e41bf20..7680deb 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1039,7 +1039,7 @@ mk_orphanage(xfs_mount_t *mp)
 	 */
 	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, &first,
 					&flist, nres);
-	if (error) 
+	if (error)
 		do_error(
 		_("can't make %s, createname error %d\n"),
 			ORPHANAGE, error);
diff --git a/repair/prefetch.c b/repair/prefetch.c
index b11dcb3..b4f20d9 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -945,7 +945,7 @@ prefetch_ag_range_work(
 {
 	struct pf_work_args *wargs = args;
 
-	prefetch_ag_range(work, wargs->start_ag, wargs->end_ag, 
+	prefetch_ag_range(work, wargs->start_ag, wargs->end_ag,
 			  wargs->dirs_only, wargs->func);
 	free(args);
 }
diff --git a/repair/protos.h b/repair/protos.h
index ff42fa7..9d5a2a6 100644
--- a/repair/protos.h
+++ b/repair/protos.h
@@ -55,4 +55,3 @@ void	phase7(struct xfs_mount *);
 int	verify_set_agheader(struct xfs_mount *, struct xfs_buf *,
 		struct xfs_sb *, struct xfs_agf *, struct xfs_agi *,
 		xfs_agnumber_t);
-
diff --git a/repair/scan.c b/repair/scan.c
index 1e7a4da..964ff06 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1803,4 +1803,3 @@ scan_ags(
 			mp->m_sb.sb_fdblocks, fdblocks);
 	}
 }
-
diff --git a/repair/versions.c b/repair/versions.c
index fb1b3e4..1585385 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -84,7 +84,7 @@ update_sb_version(xfs_mount_t *mp)
 		}
 	}
 
-	if (!fs_aligned_inodes && xfs_sb_version_hasalign(sb))  
+	if (!fs_aligned_inodes && xfs_sb_version_hasalign(sb))
 		sb->sb_versionnum &= ~XFS_SB_VERSION_ALIGNBIT;
 }
 
diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index 4a8c8a6..8d78d48 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -17,7 +17,7 @@ usage()
 
 cleanup()
 {
-	rm -f $PATCH 
+	rm -f $PATCH
 }
 
 fail()
-- 
2.6.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
