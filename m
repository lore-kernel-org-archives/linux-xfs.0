Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 54A527F51
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 07:22:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 428188F8035
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 05:22:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BeDnAcCAxurypDON for
	<xfs@oss.sgi.com>; Wed, 07 May 2014 05:22:02 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s47CM1HH004819
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 7 May 2014 08:22:02 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s47CM1I0025675
	for <xfs@oss.sgi.com>; Wed, 7 May 2014 08:22:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 14/20] xfsprogs/repair: phase 2 finobt scan
Date: Wed,  7 May 2014 08:21:53 -0400
Message-Id: <1399465319-65066-15-git-send-email-bfoster@redhat.com>
In-Reply-To: <1399465319-65066-1-git-send-email-bfoster@redhat.com>
References: <1399465319-65066-1-git-send-email-bfoster@redhat.com>
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

If one exists, scan the free inode btree in phase 2 of xfs_repair.
We use the same general infrastructure as for the inobt scan, but
trigger finobt chunk scan logic in in scan_inobt() via the magic
value.

The new scan_single_finobt_chunk() function is similar to the inobt
equivalent with some finobt specific logic. We can expect that
underlying inode chunk blocks are already marked used due to the
previous inobt scan. We can also expect to find every record
tracked by the finobt already accounted for in the in-core tree
with equivalent (and internally consistent) inobt record data.

Spit out a warning on any divergences from the above and add the
inodes referenced by the current finobt record to the appropriate
in-core tree.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/scan.c | 251 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 246 insertions(+), 5 deletions(-)

diff --git a/repair/scan.c b/repair/scan.c
index 4b0ea04..1b64d8b 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -46,6 +46,7 @@ struct aghdr_cnts {
 	__uint64_t	fdblocks;
 	__uint64_t	icount;
 	__uint64_t	ifreecount;
+	__uint32_t	fibtfreecount;
 };
 
 void
@@ -897,6 +898,208 @@ _("inode rec for ino %" PRIu64 " (%d/%d) overlaps existing rec (start %d/%d)\n")
 	return suspect;
 }
 
+static int
+scan_single_finobt_chunk(
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
+	ino_tree_node_t		*first_rec, *last_rec, *ino_rec;
+
+	ino = be32_to_cpu(rp->ir_startino);
+	off = XFS_AGINO_TO_OFFSET(mp, ino);
+	agbno = XFS_AGINO_TO_AGBNO(mp, ino);
+	lino = XFS_AGINO_TO_INO(mp, agno, ino);
+
+	/*
+	 * on multi-block block chunks, all chunks start at the beginning of the
+	 * block. with multi-chunk blocks, all chunks must start on 64-inode
+	 * boundaries since each block can hold N complete chunks. if fs has
+	 * aligned inodes, all chunks must start at a fs_ino_alignment*N'th
+	 * agbno. skip recs with badly aligned starting inodes.
+	 */
+	if (ino == 0 ||
+	    (inodes_per_block <= XFS_INODES_PER_CHUNK && off !=  0) ||
+	    (inodes_per_block > XFS_INODES_PER_CHUNK &&
+	     off % XFS_INODES_PER_CHUNK != 0) ||
+	    (fs_aligned_inodes && agbno % fs_ino_alignment != 0)) {
+		do_warn(
+	_("badly aligned finobt inode rec (starting inode = %" PRIu64 ")\n"),
+			lino);
+		suspect++;
+	}
+
+	/*
+	 * verify numeric validity of inode chunk first before inserting into a
+	 * tree. don't have to worry about the overflow case because the
+	 * starting ino number of a chunk can only get within 255 inodes of max
+	 * (NULLAGINO). if it gets closer, the agino number will be illegal as
+	 * the agbno will be too large.
+	 */
+	if (verify_aginum(mp, agno, ino)) {
+		do_warn(
+_("bad starting inode # (%" PRIu64 " (0x%x 0x%x)) in finobt rec, skipping rec\n"),
+			lino, agno, ino);
+		return ++suspect;
+	}
+
+	if (verify_aginum(mp, agno,
+			ino + XFS_INODES_PER_CHUNK - 1)) {
+		do_warn(
+_("bad ending inode # (%" PRIu64 " (0x%x 0x%zx)) in finobt rec, skipping rec\n"),
+			lino + XFS_INODES_PER_CHUNK - 1,
+			agno,
+			ino + XFS_INODES_PER_CHUNK - 1);
+		return ++suspect;
+	}
+
+	/*
+	 * cross check state of each block containing inodes referenced by the
+	 * finobt against what we have already scanned from the alloc inobt.
+	 */
+	if (off == 0 && !suspect) {
+		for (j = 0;
+		     j < XFS_INODES_PER_CHUNK;
+		     j += mp->m_sb.sb_inopblock) {
+			agbno = XFS_AGINO_TO_AGBNO(mp, ino + j);
+
+			state = get_bmap(agno, agbno);
+			if (state == XR_E_INO) {
+				continue;
+			} else if ((state == XR_E_UNKNOWN) ||
+				   (state == XR_E_INUSE_FS && agno == 0 &&
+				    ino + j >= first_prealloc_ino &&
+				    ino + j < last_prealloc_ino)) {
+				do_warn(
+_("inode chunk claims untracked block, finobt block - agno %d, bno %d, inopb %d\n"),
+					agno, agbno, mp->m_sb.sb_inopblock);
+
+				set_bmap(agno, agbno, XR_E_INO);
+				suspect++;
+			} else {
+				do_warn(
+_("inode chunk claims used block, finobt block - agno %d, bno %d, inopb %d\n"),
+					agno, agbno, mp->m_sb.sb_inopblock);
+				return ++suspect;
+			}
+		}
+	}
+
+	/*
+	 * ensure we have an incore entry for each chunk
+	 */
+	find_inode_rec_range(mp, agno, ino, ino + XFS_INODES_PER_CHUNK,
+			     &first_rec, &last_rec);
+
+	if (first_rec) {
+		if (suspect)
+			return suspect;
+
+		/*
+		 * verify consistency between finobt record and incore state
+		 */
+		if (first_rec->ino_startnum != ino) {
+			do_warn(
+_("finobt rec for ino %" PRIu64 " (%d/%u) does not match existing rec (%d/%d)\n"),
+				lino, agno, ino, agno, first_rec->ino_startnum);
+			return ++suspect;
+		}
+
+		nfree = 0;
+		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
+			int isfree = XFS_INOBT_IS_FREE_DISK(rp, j);
+
+			if (isfree)
+				nfree++;
+
+			/*
+			 * inode allocation state should be consistent between
+			 * the inobt and finobt
+			 */
+			if (!suspect &&
+			    isfree != is_inode_free(first_rec, j))
+				suspect++;
+		}
+
+		goto check_freecount;
+	}
+
+	/*
+	 * the finobt contains a record that the previous alloc inobt scan never
+	 * found. insert the inodes into the appropriate tree.
+	 */
+	do_warn(_("undiscovered finobt record, ino %" PRIu64 " (%d/%u)\n"),
+		lino, agno, ino);
+
+	if (!suspect) {
+		/*
+		 * inodes previously inserted into the uncertain tree should be
+		 * superceded by these when the uncertain tree is processed
+		 */
+		nfree = 0;
+		if (XFS_INOBT_IS_FREE_DISK(rp, 0)) {
+			nfree++;
+			ino_rec = set_inode_free_alloc(mp, agno, ino);
+		} else  {
+			ino_rec = set_inode_used_alloc(mp, agno, ino);
+		}
+		for (j = 1; j < XFS_INODES_PER_CHUNK; j++) {
+			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
+				nfree++;
+				set_inode_free(ino_rec, j);
+			} else  {
+				set_inode_used(ino_rec, j);
+			}
+		}
+	} else {
+		/*
+		 * this should handle the case where the inobt scan may have
+		 * already added uncertain inodes
+		 */
+		nfree = 0;
+		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
+			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
+				add_aginode_uncertain(mp, agno, ino + j, 1);
+				nfree++;
+			} else {
+				add_aginode_uncertain(mp, agno, ino + j, 0);
+			}
+		}
+	}
+
+check_freecount:
+
+	/*
+	 * Verify that the record freecount matches the actual number of free
+	 * inodes counted in the record. Don't increment 'suspect' here, since
+	 * we have already verified the allocation state of the individual
+	 * inodes against the in-core state. This will have already incremented
+	 * 'suspect' if something is wrong. If suspect hasn't been set at this
+	 * point, these warnings mean that we have a simple freecount
+	 * inconsistency or a stray finobt record (as opposed to a broader tree
+	 * corruption). Issue a warning and continue the scan. The final btree
+	 * reconstruction will correct this naturally.
+	 */
+	if (nfree != be32_to_cpu(rp->ir_freecount)) {
+		do_warn(
+_("finobt ir_freecount/free mismatch, inode chunk %d/%u, freecount %d nfree %d\n"),
+			agno, ino, be32_to_cpu(rp->ir_freecount), nfree);
+	}
+
+	if (!nfree) {
+		do_warn(
+_("finobt record with no free inodes, inode chunk %d/%u\n"), agno, ino);
+	}
+
+	return suspect;
+}
 
 /*
  * this one walks the inode btrees sucking the info there into
@@ -1005,12 +1208,29 @@ _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		 * the block.  skip processing of bogus records.
 		 */
 		for (i = 0; i < numrecs; i++) {
-			agcnts->agicount += XFS_INODES_PER_CHUNK;
-			agcnts->icount += XFS_INODES_PER_CHUNK;
-			agcnts->agifreecount += be32_to_cpu(rp[i].ir_freecount);
-			agcnts->ifreecount += be32_to_cpu(rp[i].ir_freecount);
+			if (magic == XFS_IBT_MAGIC ||
+			    magic == XFS_IBT_CRC_MAGIC) {
+				agcnts->agicount += XFS_INODES_PER_CHUNK;
+				agcnts->icount += XFS_INODES_PER_CHUNK;
+				agcnts->agifreecount +=
+					be32_to_cpu(rp[i].ir_freecount);
+				agcnts->ifreecount +=
+					be32_to_cpu(rp[i].ir_freecount);
+
+				suspect = scan_single_ino_chunk(agno, &rp[i],
+						suspect);
+			} else {
+				/*
+				 * the finobt tracks records with free inodes,
+				 * so only the free inode count is expected to be
+				 * consistent with the agi
+				 */
+				agcnts->fibtfreecount +=
+					be32_to_cpu(rp[i].ir_freecount);
 
-			suspect = scan_single_ino_chunk(agno, &rp[i], suspect);
+				suspect = scan_single_finobt_chunk(agno, &rp[i],
+						suspect);
+			}
 		}
 
 		if (suspect)
@@ -1198,6 +1418,20 @@ validate_agi(
 			be32_to_cpu(agi->agi_root), agno);
 	}
 
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		bno = be32_to_cpu(agi->agi_free_root);
+		if (bno != 0 && verify_agbno(mp, agno, bno)) {
+			magic = xfs_sb_version_hascrc(&mp->m_sb) ?
+					XFS_FIBT_CRC_MAGIC : XFS_FIBT_MAGIC;
+			scan_sbtree(bno, be32_to_cpu(agi->agi_free_level),
+				    agno, 0, scan_inobt, 1, magic, agcnts,
+				    &xfs_inobt_buf_ops);
+		} else {
+			do_warn(_("bad agbno %u for finobt root, agno %d\n"),
+				be32_to_cpu(agi->agi_free_root), agno);
+		}
+	}
+
 	if (be32_to_cpu(agi->agi_count) != agcnts->agicount) {
 		do_warn(_("agi_count %u, counted %u in ag %u\n"),
 			 be32_to_cpu(agi->agi_count), agcnts->agicount, agno);
@@ -1208,6 +1442,13 @@ validate_agi(
 			be32_to_cpu(agi->agi_freecount), agcnts->agifreecount, agno);
 	}
 
+	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	    be32_to_cpu(agi->agi_freecount) != agcnts->fibtfreecount) {
+		do_warn(_("agi_freecount %u, counted %u in ag %u finobt\n"),
+			be32_to_cpu(agi->agi_freecount), agcnts->fibtfreecount,
+			agno);
+	}
+
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
 		xfs_agino_t	agino = be32_to_cpu(agi->agi_unlinked[i]);
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
