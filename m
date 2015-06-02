Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A6EB07F7E
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2580FAC006
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tyRKTPo6EztmClXA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:05 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 5087EBBF6D
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:05 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig4Km019608
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 20/28] repair: validate ir_count field for sparse format
	records
Date: Tue,  2 Jun 2015 14:41:53 -0400
Message-Id: <1433270521-62026-21-git-send-email-bfoster@redhat.com>
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

Sparse format inobt records contain an additional count field that
records the number of physical inodes tracked by the record. Verify the
count is internally consistent according to the holemask, similar to how
freecount is validated against the free mask.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/scan.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/repair/scan.c b/repair/scan.c
index 52c05e2..9b16199 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -758,6 +758,7 @@ scan_single_ino_chunk(
 	xfs_agblock_t		agbno;
 	int			j;
 	int			nfree;
+	int			ninodes;
 	int			off;
 	int			state;
 	ino_tree_node_t		*ino_rec = NULL;
@@ -909,7 +910,7 @@ _("inode rec for ino %" PRIu64 " (%d/%d) overlaps existing rec (start %d/%d)\n")
 	 * Mark sparse inodes as such in the in-core tree. Verify that sparse
 	 * inodes are free and that freecount is consistent with the free mask.
 	 */
-	nfree = 0;
+	nfree = ninodes = 0;
 	for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
 		if (ino_issparse(rp, j)) {
 			if (!suspect && !XFS_INOBT_IS_FREE_DISK(rp, j)) {
@@ -922,9 +923,11 @@ _("ir_holemask/ir_free mismatch, inode chunk %d/%u, holemask 0x%x free 0x%llx\n"
 			}
 			if (!suspect && ino_rec)
 				set_inode_sparse(ino_rec, j);
-		} else if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
-			/* freecount only tracks non-sparse inos */
-			nfree++;
+		} else {
+			/* count fields track non-sparse inos */
+			if (XFS_INOBT_IS_FREE_DISK(rp, j))
+				nfree++;
+			ninodes++;
 		}
 	}
 
@@ -934,6 +937,14 @@ _("ir_freecount/free mismatch, inode chunk %d/%u, freecount %d nfree %d\n"),
 			agno, ino, freecount, nfree);
 	}
 
+	/* verify sparse record formats have a valid inode count */
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
+	    ninodes != rp->ir_u.sp.ir_count) {
+		do_warn(
+_("invalid inode count, inode chunk %d/%u, count %d ninodes %d\n"),
+			agno, ino, rp->ir_u.sp.ir_count, ninodes);
+	}
+
 	return suspect;
 }
 
@@ -948,6 +959,7 @@ scan_single_finobt_chunk(
 	xfs_agblock_t		agbno;
 	int			j;
 	int			nfree;
+	int			ninodes;
 	int			off;
 	int			state;
 	ino_tree_node_t		*ino_rec = NULL;
@@ -1069,11 +1081,13 @@ _("finobt rec for ino %" PRIu64 " (%d/%u) does not match existing rec (%d/%d)\n"
 			return ++suspect;
 		}
 
-		nfree = 0;
+		nfree = ninodes = 0;
 		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
 			int isfree = XFS_INOBT_IS_FREE_DISK(rp, j);
 			int issparse = ino_issparse(rp, j);
 
+			if (!issparse)
+				ninodes++;
 			if (isfree && !issparse)
 				nfree++;
 
@@ -1135,7 +1149,7 @@ _("finobt rec for ino %" PRIu64 " (%d/%u) does not match existing rec (%d/%d)\n"
 	 * Mark sparse inodes as such in the in-core tree. Verify that sparse
 	 * inodes are free and that freecount is consistent with the free mask.
 	 */
-	nfree = 0;
+	nfree = ninodes = 0;
 	for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
 		if (ino_issparse(rp, j)) {
 			if (!suspect && !XFS_INOBT_IS_FREE_DISK(rp, j)) {
@@ -1148,10 +1162,13 @@ _("finobt ir_holemask/ir_free mismatch, inode chunk %d/%u, holemask 0x%x free 0x
 			}
 			if (!suspect && ino_rec)
 				set_inode_sparse(ino_rec, j);
-		} else if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
-			/* freecount only tracks non-sparse inos */
-			nfree++;
+		} else {
+			/* count fields track non-sparse inos */
+			if (XFS_INOBT_IS_FREE_DISK(rp, j))
+				nfree++;
+			ninodes++;
 		}
+
 	}
 
 check_freecount:
@@ -1178,6 +1195,14 @@ _("finobt ir_freecount/free mismatch, inode chunk %d/%u, freecount %d nfree %d\n
 _("finobt record with no free inodes, inode chunk %d/%u\n"), agno, ino);
 	}
 
+	/* verify sparse record formats have a valid inode count */
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
+	    ninodes != rp->ir_u.sp.ir_count) {
+		do_warn(
+_("invalid inode count, inode chunk %d/%u, count %d ninodes %d\n"),
+			agno, ino, rp->ir_u.sp.ir_count, ninodes);
+	}
+
 	return suspect;
 }
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
