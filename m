Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 96C227CB1
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 11:52:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 49F1A304032
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 09:52:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CpPrjtAlkThOPQr0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 Jun 2016 09:52:44 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 1C80DC05FBD5
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 16:52:44 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-179.bos.redhat.com [10.18.41.179])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u5KGqhbr024837
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 12:52:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] Revert "xfs_db: make check work for sparse inodes"
Date: Mon, 20 Jun 2016 12:52:41 -0400
Message-Id: <1466441562-12317-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1466441562-12317-1-git-send-email-bfoster@redhat.com>
References: <1466441562-12317-1-git-send-email-bfoster@redhat.com>
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

This reverts commit bb2f98b78f20f4abbfbbd442162d9f535c84888a.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 db/check.c | 249 ++++++++++++-------------------------------------------------
 1 file changed, 49 insertions(+), 200 deletions(-)

diff --git a/db/check.c b/db/check.c
index 0871ed7..750ecc1 100644
--- a/db/check.c
+++ b/db/check.c
@@ -4311,51 +4311,6 @@ scanfunc_cnt(
 		scan_sbtree(agf, be32_to_cpu(pp[i]), level, 0, scanfunc_cnt, TYP_CNTBT);
 }
 
-static bool
-ino_issparse(
-	struct xfs_inobt_rec	*rp,
-	int			offset)
-{
-	if (!xfs_sb_version_hassparseinodes(&mp->m_sb))
-		return false;
-
-	return xfs_inobt_is_sparse_disk(rp, offset);
-}
-
-static int
-find_one_ino_bit(
-	__u16		mask,
-	int		startino)
-{
-	int		n;
-	int		b;
-
-	startino /= XFS_INODES_PER_HOLEMASK_BIT;
-	b = startino;
-	mask >>= startino;
-	for (n = startino; n < sizeof(mask) * NBBY && !(mask & 1); n++, mask >>= 1)
-		b++;
-
-	return b * XFS_INODES_PER_HOLEMASK_BIT;
-}
-
-static int
-find_zero_ino_bit(
-	__u16		mask,
-	int		startino)
-{
-	int		n;
-	int		b;
-
-	startino /= XFS_INODES_PER_HOLEMASK_BIT;
-	b = startino;
-	mask >>= startino;
-	for (n = startino; n < sizeof(mask) * NBBY && (mask & 1); n++, mask >>= 1)
-		b++;
-
-	return b * XFS_INODES_PER_HOLEMASK_BIT;
-}
-
 static void
 scanfunc_ino(
 	struct xfs_btree_block	*block,
@@ -4373,13 +4328,6 @@ scanfunc_ino(
 	int			off;
 	xfs_inobt_ptr_t		*pp;
 	xfs_inobt_rec_t		*rp;
-	bool			sparse, crc;
-	int			inodes_per_chunk;
-	int			freecount;
-	int			startidx, endidx;
-	__u16			holemask;
-	xfs_agino_t		rino;
-	xfs_extlen_t		cblocks;
 
 	if (be32_to_cpu(block->bb_magic) != XFS_IBT_MAGIC &&
 	    be32_to_cpu(block->bb_magic) != XFS_IBT_CRC_MAGIC) {
@@ -4407,111 +4355,59 @@ scanfunc_ino(
 			return;
 		}
 		rp = XFS_INOBT_REC_ADDR(mp, block, 1);
-		sparse = xfs_sb_version_hassparseinodes(&mp->m_sb);
-		crc = xfs_sb_version_hascrc(&mp->m_sb);
 		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
-			nfree = 0;
-
-			/* First let's look at the inode chunk alignment */
 			agino = be32_to_cpu(rp[i].ir_startino);
 			off = XFS_INO_TO_OFFSET(mp, agino);
-			if (off == 0 &&
-			    (sbversion & XFS_SB_VERSION_ALIGNBIT) &&
-			    mp->m_sb.sb_inoalignmt &&
-			    (XFS_INO_TO_AGBNO(mp, agino) %
-			     mp->m_sb.sb_inoalignmt)) {
-				if (sparse || crc) {
-					dbprintf(_("incorrect record %u/%u "
-						 "alignment in inobt block "
-						 "%u/%u\n"),
-						 seqno, agino, seqno, bno);
-					error++;
-				} else
+			if (off == 0) {
+				if ((sbversion & XFS_SB_VERSION_ALIGNBIT) &&
+				    mp->m_sb.sb_inoalignmt &&
+				    (XFS_INO_TO_AGBNO(mp, agino) %
+				     mp->m_sb.sb_inoalignmt))
 					sbversion &= ~XFS_SB_VERSION_ALIGNBIT;
+				set_dbmap(seqno, XFS_AGINO_TO_AGBNO(mp, agino),
+					(xfs_extlen_t)MAX(1,
+						XFS_INODES_PER_CHUNK >>
+						mp->m_sb.sb_inopblog),
+					DBM_INODE, seqno, bno);
 			}
-
-			/* Move on to examining the inode chunks */
-			if (sparse) {
-				inodes_per_chunk = rp[i].ir_u.sp.ir_count;
-				freecount = rp[i].ir_u.sp.ir_freecount;
-				holemask = be16_to_cpu(rp[i].ir_u.sp.ir_holemask);
-				startidx = find_zero_ino_bit(holemask, 0);
-			} else {
-				inodes_per_chunk = XFS_INODES_PER_CHUNK;
-				freecount = be32_to_cpu(rp[i].ir_u.f.ir_freecount);
-				holemask = 0;
-				startidx = 0;
-			}
-
-			/* For each allocated chunk, look at each inode. */
-			endidx = find_one_ino_bit(holemask, startidx);
-			do {
-				rino = agino + startidx;
-				cblocks = (endidx - startidx) >>
-						mp->m_sb.sb_inopblog;
-
-				/* Check the sparse chunk alignment */
-				if (sparse &&
-				    (XFS_INO_TO_AGBNO(mp, rino) %
-				     mp->m_sb.sb_spino_align)) {
-					dbprintf(_("incorrect chunk %u/%u "
-						 "alignment in inobt block "
+			icount += XFS_INODES_PER_CHUNK;
+			agicount += XFS_INODES_PER_CHUNK;
+			ifree += be32_to_cpu(rp[i].ir_u.f.ir_freecount);
+			agifreecount += be32_to_cpu(rp[i].ir_u.f.ir_freecount);
+			push_cur();
+			set_cur(&typtab[TYP_INODE],
+				XFS_AGB_TO_DADDR(mp, seqno,
+						 XFS_AGINO_TO_AGBNO(mp, agino)),
+				(int)XFS_FSB_TO_BB(mp, mp->m_ialloc_blks),
+				DB_RING_IGN, NULL);
+			if (iocur_top->data == NULL) {
+				if (!sflag)
+					dbprintf(_("can't read inode block "
 						 "%u/%u\n"),
-						 seqno, rino, seqno, bno);
-					error++;
-				}
-
-				/* Check the block map */
-				set_dbmap(seqno, XFS_AGINO_TO_AGBNO(mp, rino),
-					cblocks, DBM_INODE, seqno, bno);
-
-				push_cur();
-				set_cur(&typtab[TYP_INODE],
-					XFS_AGB_TO_DADDR(mp, seqno,
-							 XFS_AGINO_TO_AGBNO(mp, rino)),
-					(int)XFS_FSB_TO_BB(mp, cblocks),
-					DB_RING_IGN, NULL);
-				if (iocur_top->data == NULL) {
-					if (!sflag)
-						dbprintf(_("can't read inode block "
-							 "%u/%u\n"),
-							seqno,
-							XFS_AGINO_TO_AGBNO(mp, agino));
-					error++;
-					pop_cur();
-					continue;
-				}
-
-				/* Examine each inode in this chunk */
-				for (j = startidx; j < endidx; j++) {
-					if (ino_issparse(&rp[i], j))
-						continue;
-					isfree = XFS_INOBT_IS_FREE_DISK(&rp[i], j);
-					if (isfree)
-						nfree++;
-					process_inode(agf, agino + j,
-						(xfs_dinode_t *)((char *)iocur_top->data + ((j - startidx) << mp->m_sb.sb_inodelog)),
-							isfree);
-				}
+						seqno,
+						XFS_AGINO_TO_AGBNO(mp, agino));
+				error++;
 				pop_cur();
-
-				startidx = find_zero_ino_bit(holemask, endidx);
-				endidx = find_one_ino_bit(holemask, startidx);
-			} while (endidx < XFS_INODES_PER_CHUNK);
-			icount += inodes_per_chunk;
-			agicount += inodes_per_chunk;
-			ifree += freecount;
-			agifreecount += freecount;
-
-			if (nfree != freecount) {
+				continue;
+			}
+			for (j = 0, nfree = 0; j < XFS_INODES_PER_CHUNK; j++) {
+				isfree = XFS_INOBT_IS_FREE_DISK(&rp[i], j);
+				if (isfree)
+					nfree++;
+				process_inode(agf, agino + j,
+					(xfs_dinode_t *)((char *)iocur_top->data + ((off + j) << mp->m_sb.sb_inodelog)),
+						isfree);
+			}
+			if (nfree != be32_to_cpu(rp[i].ir_u.f.ir_freecount)) {
 				if (!sflag)
 					dbprintf(_("ir_freecount/free mismatch, "
 						 "inode chunk %u/%u, freecount "
 						 "%d nfree %d\n"),
 						seqno, agino,
-						freecount, nfree);
+						be32_to_cpu(rp[i].ir_u.f.ir_freecount), nfree);
 				error++;
 			}
+			pop_cur();
 		}
 		return;
 	}
@@ -4543,11 +4439,6 @@ scanfunc_fino(
 	int			off;
 	xfs_inobt_ptr_t		*pp;
 	struct xfs_inobt_rec	*rp;
-	bool			sparse, crc;
-	int			startidx, endidx;
-	__u16			holemask;
-	xfs_agino_t		rino;
-	xfs_extlen_t		cblocks;
 
 	if (be32_to_cpu(block->bb_magic) != XFS_FIBT_MAGIC &&
 	    be32_to_cpu(block->bb_magic) != XFS_FIBT_CRC_MAGIC) {
@@ -4575,63 +4466,21 @@ scanfunc_fino(
 			return;
 		}
 		rp = XFS_INOBT_REC_ADDR(mp, block, 1);
-		sparse = xfs_sb_version_hassparseinodes(&mp->m_sb);
-		crc = xfs_sb_version_hascrc(&mp->m_sb);
 		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
-			/* First let's look at the inode chunk alignment */
 			agino = be32_to_cpu(rp[i].ir_startino);
 			off = XFS_INO_TO_OFFSET(mp, agino);
-			if (off == 0 &&
-			    (sbversion & XFS_SB_VERSION_ALIGNBIT) &&
-			    mp->m_sb.sb_inoalignmt &&
-			    (XFS_INO_TO_AGBNO(mp, agino) %
-			     mp->m_sb.sb_inoalignmt)) {
-				if (sparse || crc) {
-					dbprintf(_("incorrect record %u/%u "
-						 "alignment in finobt block "
-						 "%u/%u\n"),
-						 seqno, agino, seqno, bno);
-					error++;
-				} else
+			if (off == 0) {
+				if ((sbversion & XFS_SB_VERSION_ALIGNBIT) &&
+				    mp->m_sb.sb_inoalignmt &&
+				    (XFS_INO_TO_AGBNO(mp, agino) %
+				     mp->m_sb.sb_inoalignmt))
 					sbversion &= ~XFS_SB_VERSION_ALIGNBIT;
+				check_set_dbmap(seqno, XFS_AGINO_TO_AGBNO(mp, agino),
+					(xfs_extlen_t)MAX(1,
+						XFS_INODES_PER_CHUNK >>
+						mp->m_sb.sb_inopblog),
+					DBM_INODE, DBM_INODE, seqno, bno);
 			}
-
-			/* Move on to examining the inode chunks */
-			if (sparse) {
-				holemask = be16_to_cpu(rp[i].ir_u.sp.ir_holemask);
-				startidx = find_zero_ino_bit(holemask, 0);
-			} else {
-				holemask = 0;
-				startidx = 0;
-			}
-
-			/* For each allocated chunk... */
-			endidx = find_one_ino_bit(holemask, startidx);
-			do {
-				rino = agino + startidx;
-				cblocks = (endidx - startidx) >>
-						mp->m_sb.sb_inopblog;
-
-				/* Check the sparse chunk alignment */
-				if (sparse &&
-				    (XFS_INO_TO_AGBNO(mp, rino) %
-				     mp->m_sb.sb_spino_align)) {
-					dbprintf(_("incorrect chunk %u/%u "
-						 "alignment in finobt block "
-						 "%u/%u\n"),
-						 seqno, rino, seqno, bno);
-					error++;
-				}
-
-				/* Check the block map */
-				check_set_dbmap(seqno,
-					XFS_AGINO_TO_AGBNO(mp, rino),
-					cblocks, DBM_INODE, DBM_INODE,
-					seqno, bno);
-
-				startidx = find_zero_ino_bit(holemask, endidx);
-				endidx = find_one_ino_bit(holemask, startidx);
-			} while (endidx < XFS_INODES_PER_CHUNK);
 		}
 		return;
 	}
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
