Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3FBBA80D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:05:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DD688304053
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:08 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ugQBVFkspSxNiZoj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:06 -0800 (PST)
Subject: [PATCH 02/53] xfs_db: make check work for sparse inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:05:03 -0800
Message-ID: <20151219090503.14255.91925.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

Teach the inobt/finobt scanning functions how to deal with sparse
inode chunks well enough that we can pass the spot-check.  Should
fix the xfs/076 failures.

v2: Put the alignment checks back in, and for each individual chunk
of inodes hanging off an inobt record, parse each chunk separately.
There is no (future) guarantee that all the inodes in a sparse inobt
record will be contiguous.

Cc: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c |  249 ++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 200 insertions(+), 49 deletions(-)


diff --git a/db/check.c b/db/check.c
index 9c1541d..f1620f8 100644
--- a/db/check.c
+++ b/db/check.c
@@ -4319,6 +4319,51 @@ scanfunc_cnt(
 		scan_sbtree(agf, be32_to_cpu(pp[i]), level, 0, scanfunc_cnt, TYP_CNTBT);
 }
 
+static bool
+ino_issparse(
+	struct xfs_inobt_rec	*rp,
+	int			offset)
+{
+	if (!xfs_sb_version_hassparseinodes(&mp->m_sb))
+		return false;
+
+	return xfs_inobt_is_sparse_disk(rp, offset);
+}
+
+static int
+find_one_ino_bit(
+	__u16		mask,
+	int		startino)
+{
+	int		n;
+	int		b;
+
+	startino /= XFS_INODES_PER_HOLEMASK_BIT;
+	b = startino;
+	mask >>= startino;
+	for (n = startino; n < sizeof(mask) * NBBY && !(mask & 1); n++, mask >>= 1)
+		b++;
+
+	return b * XFS_INODES_PER_HOLEMASK_BIT;
+}
+
+static int
+find_zero_ino_bit(
+	__u16		mask,
+	int		startino)
+{
+	int		n;
+	int		b;
+
+	startino /= XFS_INODES_PER_HOLEMASK_BIT;
+	b = startino;
+	mask >>= startino;
+	for (n = startino; n < sizeof(mask) * NBBY && (mask & 1); n++, mask >>= 1)
+		b++;
+
+	return b * XFS_INODES_PER_HOLEMASK_BIT;
+}
+
 static void
 scanfunc_ino(
 	struct xfs_btree_block	*block,
@@ -4336,6 +4381,13 @@ scanfunc_ino(
 	int			off;
 	xfs_inobt_ptr_t		*pp;
 	xfs_inobt_rec_t		*rp;
+	bool			sparse, crc;
+	int			inodes_per_chunk;
+	int			freecount;
+	int			startidx, endidx;
+	__u16			holemask;
+	xfs_agino_t		rino;
+	xfs_extlen_t		cblocks;
 
 	if (be32_to_cpu(block->bb_magic) != XFS_IBT_MAGIC &&
 	    be32_to_cpu(block->bb_magic) != XFS_IBT_CRC_MAGIC) {
@@ -4363,59 +4415,111 @@ scanfunc_ino(
 			return;
 		}
 		rp = XFS_INOBT_REC_ADDR(mp, block, 1);
+		sparse = xfs_sb_version_hassparseinodes(&mp->m_sb);
+		crc = xfs_sb_version_hascrc(&mp->m_sb);
 		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
+			nfree = 0;
+
+			/* First let's look at the inode chunk alignment */
 			agino = be32_to_cpu(rp[i].ir_startino);
 			off = XFS_INO_TO_OFFSET(mp, agino);
-			if (off == 0) {
-				if ((sbversion & XFS_SB_VERSION_ALIGNBIT) &&
-				    mp->m_sb.sb_inoalignmt &&
-				    (XFS_INO_TO_AGBNO(mp, agino) %
-				     mp->m_sb.sb_inoalignmt))
+			if (off == 0 &&
+			    (sbversion & XFS_SB_VERSION_ALIGNBIT) &&
+			    mp->m_sb.sb_inoalignmt &&
+			    (XFS_INO_TO_AGBNO(mp, agino) %
+			     mp->m_sb.sb_inoalignmt)) {
+				if (sparse || crc) {
+					dbprintf(_("incorrect record %u/%u "
+						 "alignment in inobt block "
+						 "%u/%u\n"),
+						 seqno, agino, seqno, bno);
+					error++;
+				} else
 					sbversion &= ~XFS_SB_VERSION_ALIGNBIT;
-				set_dbmap(seqno, XFS_AGINO_TO_AGBNO(mp, agino),
-					(xfs_extlen_t)MAX(1,
-						XFS_INODES_PER_CHUNK >>
-						mp->m_sb.sb_inopblog),
-					DBM_INODE, seqno, bno);
 			}
-			icount += XFS_INODES_PER_CHUNK;
-			agicount += XFS_INODES_PER_CHUNK;
-			ifree += be32_to_cpu(rp[i].ir_u.f.ir_freecount);
-			agifreecount += be32_to_cpu(rp[i].ir_u.f.ir_freecount);
-			push_cur();
-			set_cur(&typtab[TYP_INODE],
-				XFS_AGB_TO_DADDR(mp, seqno,
-						 XFS_AGINO_TO_AGBNO(mp, agino)),
-				(int)XFS_FSB_TO_BB(mp, mp->m_ialloc_blks),
-				DB_RING_IGN, NULL);
-			if (iocur_top->data == NULL) {
-				if (!sflag)
-					dbprintf(_("can't read inode block "
+
+			/* Move on to examining the inode chunks */
+			if (sparse) {
+				inodes_per_chunk = rp[i].ir_u.sp.ir_count;
+				freecount = rp[i].ir_u.sp.ir_freecount;
+				holemask = be16_to_cpu(rp[i].ir_u.sp.ir_holemask);
+				startidx = find_zero_ino_bit(holemask, 0);
+			} else {
+				inodes_per_chunk = XFS_INODES_PER_CHUNK;
+				freecount = be32_to_cpu(rp[i].ir_u.f.ir_freecount);
+				holemask = 0;
+				startidx = 0;
+			}
+
+			/* For each allocated chunk, look at each inode. */
+			endidx = find_one_ino_bit(holemask, startidx);
+			do {
+				rino = agino + startidx;
+				cblocks = (endidx - startidx) >>
+						mp->m_sb.sb_inopblog;
+
+				/* Check the sparse chunk alignment */
+				if (sparse &&
+				    (XFS_INO_TO_AGBNO(mp, rino) %
+				     mp->m_sb.sb_spino_align)) {
+					dbprintf(_("incorrect chunk %u/%u "
+						 "alignment in inobt block "
 						 "%u/%u\n"),
-						seqno,
-						XFS_AGINO_TO_AGBNO(mp, agino));
-				error++;
+						 seqno, rino, seqno, bno);
+					error++;
+				}
+
+				/* Check the block map */
+				set_dbmap(seqno, XFS_AGINO_TO_AGBNO(mp, rino),
+					cblocks, DBM_INODE, seqno, bno);
+
+				push_cur();
+				set_cur(&typtab[TYP_INODE],
+					XFS_AGB_TO_DADDR(mp, seqno,
+							 XFS_AGINO_TO_AGBNO(mp, rino)),
+					(int)XFS_FSB_TO_BB(mp, cblocks),
+					DB_RING_IGN, NULL);
+				if (iocur_top->data == NULL) {
+					if (!sflag)
+						dbprintf(_("can't read inode block "
+							 "%u/%u\n"),
+							seqno,
+							XFS_AGINO_TO_AGBNO(mp, agino));
+					error++;
+					pop_cur();
+					continue;
+				}
+
+				/* Examine each inode in this chunk */
+				for (j = startidx; j < endidx; j++) {
+					if (ino_issparse(&rp[i], j))
+						continue;
+					isfree = XFS_INOBT_IS_FREE_DISK(&rp[i], j);
+					if (isfree)
+						nfree++;
+					process_inode(agf, agino + j,
+						(xfs_dinode_t *)((char *)iocur_top->data + ((j - startidx) << mp->m_sb.sb_inodelog)),
+							isfree);
+				}
 				pop_cur();
-				continue;
-			}
-			for (j = 0, nfree = 0; j < XFS_INODES_PER_CHUNK; j++) {
-				isfree = XFS_INOBT_IS_FREE_DISK(&rp[i], j);
-				if (isfree)
-					nfree++;
-				process_inode(agf, agino + j,
-					(xfs_dinode_t *)((char *)iocur_top->data + ((off + j) << mp->m_sb.sb_inodelog)),
-						isfree);
-			}
-			if (nfree != be32_to_cpu(rp[i].ir_u.f.ir_freecount)) {
+
+				startidx = find_zero_ino_bit(holemask, endidx);
+				endidx = find_one_ino_bit(holemask, startidx);
+			} while (endidx < XFS_INODES_PER_CHUNK);
+			icount += inodes_per_chunk;
+			agicount += inodes_per_chunk;
+			ifree += freecount;
+			agifreecount += freecount;
+
+			if (nfree != freecount) {
 				if (!sflag)
 					dbprintf(_("ir_freecount/free mismatch, "
 						 "inode chunk %u/%u, freecount "
 						 "%d nfree %d\n"),
 						seqno, agino,
-						be32_to_cpu(rp[i].ir_u.f.ir_freecount), nfree);
+						freecount, nfree);
 				error++;
 			}
-			pop_cur();
 		}
 		return;
 	}
@@ -4447,6 +4551,11 @@ scanfunc_fino(
 	int			off;
 	xfs_inobt_ptr_t		*pp;
 	struct xfs_inobt_rec	*rp;
+	bool			sparse, crc;
+	int			startidx, endidx;
+	__u16			holemask;
+	xfs_agino_t		rino;
+	xfs_extlen_t		cblocks;
 
 	if (be32_to_cpu(block->bb_magic) != XFS_FIBT_MAGIC &&
 	    be32_to_cpu(block->bb_magic) != XFS_FIBT_CRC_MAGIC) {
@@ -4474,21 +4583,63 @@ scanfunc_fino(
 			return;
 		}
 		rp = XFS_INOBT_REC_ADDR(mp, block, 1);
+		sparse = xfs_sb_version_hassparseinodes(&mp->m_sb);
+		crc = xfs_sb_version_hascrc(&mp->m_sb);
 		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
+			/* First let's look at the inode chunk alignment */
 			agino = be32_to_cpu(rp[i].ir_startino);
 			off = XFS_INO_TO_OFFSET(mp, agino);
-			if (off == 0) {
-				if ((sbversion & XFS_SB_VERSION_ALIGNBIT) &&
-				    mp->m_sb.sb_inoalignmt &&
-				    (XFS_INO_TO_AGBNO(mp, agino) %
-				     mp->m_sb.sb_inoalignmt))
+			if (off == 0 &&
+			    (sbversion & XFS_SB_VERSION_ALIGNBIT) &&
+			    mp->m_sb.sb_inoalignmt &&
+			    (XFS_INO_TO_AGBNO(mp, agino) %
+			     mp->m_sb.sb_inoalignmt)) {
+				if (sparse || crc) {
+					dbprintf(_("incorrect record %u/%u "
+						 "alignment in finobt block "
+						 "%u/%u\n"),
+						 seqno, agino, seqno, bno);
+					error++;
+				} else
 					sbversion &= ~XFS_SB_VERSION_ALIGNBIT;
-				check_set_dbmap(seqno, XFS_AGINO_TO_AGBNO(mp, agino),
-					(xfs_extlen_t)MAX(1,
-						XFS_INODES_PER_CHUNK >>
-						mp->m_sb.sb_inopblog),
-					DBM_INODE, DBM_INODE, seqno, bno);
 			}
+
+			/* Move on to examining the inode chunks */
+			if (sparse) {
+				holemask = be16_to_cpu(rp[i].ir_u.sp.ir_holemask);
+				startidx = find_zero_ino_bit(holemask, 0);
+			} else {
+				holemask = 0;
+				startidx = 0;
+			}
+
+			/* For each allocated chunk... */
+			endidx = find_one_ino_bit(holemask, startidx);
+			do {
+				rino = agino + startidx;
+				cblocks = (endidx - startidx) >>
+						mp->m_sb.sb_inopblog;
+
+				/* Check the sparse chunk alignment */
+				if (sparse &&
+				    (XFS_INO_TO_AGBNO(mp, rino) %
+				     mp->m_sb.sb_spino_align)) {
+					dbprintf(_("incorrect chunk %u/%u "
+						 "alignment in finobt block "
+						 "%u/%u\n"),
+						 seqno, rino, seqno, bno);
+					error++;
+				}
+
+				/* Check the block map */
+				check_set_dbmap(seqno,
+					XFS_AGINO_TO_AGBNO(mp, rino),
+					cblocks, DBM_INODE, DBM_INODE,
+					seqno, bno);
+
+				startidx = find_zero_ino_bit(holemask, endidx);
+				endidx = find_one_ino_bit(holemask, startidx);
+			} while (endidx < XFS_INODES_PER_CHUNK);
 		}
 		return;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
