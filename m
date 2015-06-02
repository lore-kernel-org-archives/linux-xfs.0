Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E93517F6A
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A3057304053
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZKBdGIpb0A8Dcqxc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:05 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 4D84CBBF5E
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:05 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig46Z019605
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 19/28] repair: scan sparse finobt records correctly
Date: Tue,  2 Jun 2015 14:41:52 -0400
Message-Id: <1433270521-62026-20-git-send-email-bfoster@redhat.com>
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

The finobt scan performs similar checks as to the inobt scan, including
internal record consistency checks, consistency with inobt records,
inode block state, etc. Various parts of this mechanism also assume
fully allocated inode records and thus lead to false errors with sparse
records.

Update the finobt scan to detect and handle sparse inode records
correctly. As for the inobt, do not assume that blocks associated with
sparse regions are allocated for inodes and do not account sparse inodes
against the freecount. Additionally, verify that sparse state is
consistent with the in-core record and set up any new in-core records
that might have been missing from the inobt correctly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/scan.c | 51 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/repair/scan.c b/repair/scan.c
index 5b67e15..52c05e2 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -950,7 +950,8 @@ scan_single_finobt_chunk(
 	int			nfree;
 	int			off;
 	int			state;
-	ino_tree_node_t		*first_rec, *last_rec, *ino_rec;
+	ino_tree_node_t		*ino_rec = NULL;
+	ino_tree_node_t		*first_rec, *last_rec;
 	int			freecount;
 
 	ino = be32_to_cpu(rp->ir_startino);
@@ -1014,8 +1015,19 @@ _("bad ending inode # (%" PRIu64 " (0x%x 0x%zx)) in finobt rec, skipping rec\n")
 		     j < XFS_INODES_PER_CHUNK;
 		     j += mp->m_sb.sb_inopblock) {
 			agbno = XFS_AGINO_TO_AGBNO(mp, ino + j);
-
 			state = get_bmap(agno, agbno);
+
+			/* sparse inodes should not refer to inode blocks */
+			if (ino_issparse(rp, j)) {
+				if (state == XR_E_INO) {
+					do_warn(
+_("sparse inode chunk claims inode block, finobt block - agno %d, bno %d, inopb %d\n"),
+						agno, agbno, mp->m_sb.sb_inopblock);
+					suspect++;
+				}
+				continue;
+			}
+
 			if (state == XR_E_INO) {
 				continue;
 			} else if ((state == XR_E_UNKNOWN) ||
@@ -1060,8 +1072,9 @@ _("finobt rec for ino %" PRIu64 " (%d/%u) does not match existing rec (%d/%d)\n"
 		nfree = 0;
 		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
 			int isfree = XFS_INOBT_IS_FREE_DISK(rp, j);
+			int issparse = ino_issparse(rp, j);
 
-			if (isfree)
+			if (isfree && !issparse)
 				nfree++;
 
 			/*
@@ -1071,6 +1084,10 @@ _("finobt rec for ino %" PRIu64 " (%d/%u) does not match existing rec (%d/%d)\n"
 			if (!suspect &&
 			    isfree != is_inode_free(first_rec, j))
 				suspect++;
+
+			if (!suspect &&
+			    issparse != is_inode_sparse(first_rec, j))
+				suspect++;
 		}
 
 		goto check_freecount;
@@ -1088,16 +1105,13 @@ _("finobt rec for ino %" PRIu64 " (%d/%u) does not match existing rec (%d/%d)\n"
 		 * inodes previously inserted into the uncertain tree should be
 		 * superceded by these when the uncertain tree is processed
 		 */
-		nfree = 0;
 		if (XFS_INOBT_IS_FREE_DISK(rp, 0)) {
-			nfree++;
 			ino_rec = set_inode_free_alloc(mp, agno, ino);
 		} else  {
 			ino_rec = set_inode_used_alloc(mp, agno, ino);
 		}
 		for (j = 1; j < XFS_INODES_PER_CHUNK; j++) {
 			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
-				nfree++;
 				set_inode_free(ino_rec, j);
 			} else  {
 				set_inode_used(ino_rec, j);
@@ -1108,17 +1122,38 @@ _("finobt rec for ino %" PRIu64 " (%d/%u) does not match existing rec (%d/%d)\n"
 		 * this should handle the case where the inobt scan may have
 		 * already added uncertain inodes
 		 */
-		nfree = 0;
 		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
 			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
 				add_aginode_uncertain(mp, agno, ino + j, 1);
-				nfree++;
 			} else {
 				add_aginode_uncertain(mp, agno, ino + j, 0);
 			}
 		}
 	}
 
+	/*
+	 * Mark sparse inodes as such in the in-core tree. Verify that sparse
+	 * inodes are free and that freecount is consistent with the free mask.
+	 */
+	nfree = 0;
+	for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
+		if (ino_issparse(rp, j)) {
+			if (!suspect && !XFS_INOBT_IS_FREE_DISK(rp, j)) {
+				do_warn(
+_("finobt ir_holemask/ir_free mismatch, inode chunk %d/%u, holemask 0x%x free 0x%llx\n"),
+					agno, ino,
+					be16_to_cpu(rp->ir_u.sp.ir_holemask),
+					be64_to_cpu(rp->ir_free));
+				suspect++;
+			}
+			if (!suspect && ino_rec)
+				set_inode_sparse(ino_rec, j);
+		} else if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
+			/* freecount only tracks non-sparse inos */
+			nfree++;
+		}
+	}
+
 check_freecount:
 
 	/*
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
