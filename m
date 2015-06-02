Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2AEAD7F73
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 08ACE304051
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id y8wFQwA4ENccGqnU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:06 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 4004F31ED2A
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:05 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig4XY016939
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 15/28] repair: handle sparse format inobt record freecount
	correctly
Date: Tue,  2 Jun 2015 14:41:48 -0400
Message-Id: <1433270521-62026-16-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
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

The sparse inode chunk feature introduces a new inobt record format that
converts ir_freecount from 4 bytes to 1 byte. ir_freecount references
throughout repair currently assume the 'full' format and endian-convert
from the 32-bit value.

Update the xfs_repair inobt scan and tree rebuild codepaths to use the
correct record format for ir_freecount when sparse inodes is enabled.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/phase5.c |  6 +++++-
 repair/scan.c   | 37 +++++++++++++++++++++++++------------
 2 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index d01e72b..04bf049 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1240,7 +1240,11 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 				inocnt += is_inode_free(ino_rec, k);
 			}
 
-			bt_rec[j].ir_u.f.ir_freecount = cpu_to_be32(inocnt);
+			if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+				bt_rec[j].ir_u.sp.ir_freecount = inocnt;
+			else
+				bt_rec[j].ir_u.f.ir_freecount =
+							cpu_to_be32(inocnt);
 			freecount += inocnt;
 			count += XFS_INODES_PER_CHUNK;
 
diff --git a/repair/scan.c b/repair/scan.c
index e64d0e5..f42459c 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -751,11 +751,16 @@ scan_single_ino_chunk(
 	int			off;
 	int			state;
 	ino_tree_node_t		*ino_rec, *first_rec, *last_rec;
+	int			freecount;
 
 	ino = be32_to_cpu(rp->ir_startino);
 	off = XFS_AGINO_TO_OFFSET(mp, ino);
 	agbno = XFS_AGINO_TO_AGBNO(mp, ino);
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+		freecount = rp->ir_u.sp.ir_freecount;
+	else
+		freecount = be32_to_cpu(rp->ir_u.f.ir_freecount);
 
 	/*
 	 * on multi-block block chunks, all chunks start
@@ -890,10 +895,10 @@ _("inode rec for ino %" PRIu64 " (%d/%d) overlaps existing rec (start %d/%d)\n")
 		}
 	}
 
-	if (nfree != be32_to_cpu(rp->ir_u.f.ir_freecount)) {
-		do_warn(_("ir_freecount/free mismatch, inode "
-			"chunk %d/%u, freecount %d nfree %d\n"),
-			agno, ino, be32_to_cpu(rp->ir_u.f.ir_freecount), nfree);
+	if (nfree != freecount) {
+		do_warn(
+_("ir_freecount/free mismatch, inode chunk %d/%u, freecount %d nfree %d\n"),
+			agno, ino, freecount, nfree);
 	}
 
 	return suspect;
@@ -913,11 +918,16 @@ scan_single_finobt_chunk(
 	int			off;
 	int			state;
 	ino_tree_node_t		*first_rec, *last_rec, *ino_rec;
+	int			freecount;
 
 	ino = be32_to_cpu(rp->ir_startino);
 	off = XFS_AGINO_TO_OFFSET(mp, ino);
 	agbno = XFS_AGINO_TO_AGBNO(mp, ino);
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+		freecount = rp->ir_u.sp.ir_freecount;
+	else
+		freecount = be32_to_cpu(rp->ir_u.f.ir_freecount);
 
 	/*
 	 * on multi-block block chunks, all chunks start at the beginning of the
@@ -1089,10 +1099,10 @@ check_freecount:
 	 * corruption). Issue a warning and continue the scan. The final btree
 	 * reconstruction will correct this naturally.
 	 */
-	if (nfree != be32_to_cpu(rp->ir_u.f.ir_freecount)) {
+	if (nfree != freecount) {
 		do_warn(
 _("finobt ir_freecount/free mismatch, inode chunk %d/%u, freecount %d nfree %d\n"),
-			agno, ino, be32_to_cpu(rp->ir_u.f.ir_freecount), nfree);
+			agno, ino, freecount, nfree);
 	}
 
 	if (!nfree) {
@@ -1137,6 +1147,7 @@ scan_inobt(
 	xfs_inobt_ptr_t		*pp;
 	xfs_inobt_rec_t		*rp;
 	int			hdr_errors;
+	int			freecount;
 
 	hdr_errors = 0;
 
@@ -1210,14 +1221,17 @@ _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		 * the block.  skip processing of bogus records.
 		 */
 		for (i = 0; i < numrecs; i++) {
+			if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+				freecount = rp[i].ir_u.sp.ir_freecount;
+			else
+				freecount = be32_to_cpu(rp[i].ir_u.f.ir_freecount);
+
 			if (magic == XFS_IBT_MAGIC ||
 			    magic == XFS_IBT_CRC_MAGIC) {
 				agcnts->agicount += XFS_INODES_PER_CHUNK;
 				agcnts->icount += XFS_INODES_PER_CHUNK;
-				agcnts->agifreecount +=
-					be32_to_cpu(rp[i].ir_u.f.ir_freecount);
-				agcnts->ifreecount +=
-					be32_to_cpu(rp[i].ir_u.f.ir_freecount);
+				agcnts->agifreecount += freecount;
+				agcnts->ifreecount += freecount;
 
 				suspect = scan_single_ino_chunk(agno, &rp[i],
 						suspect);
@@ -1227,8 +1241,7 @@ _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 				 * so only the free inode count is expected to be
 				 * consistent with the agi
 				 */
-				agcnts->fibtfreecount +=
-					be32_to_cpu(rp[i].ir_u.f.ir_freecount);
+				agcnts->fibtfreecount += freecount;
 
 				suspect = scan_single_finobt_chunk(agno, &rp[i],
 						suspect);
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
