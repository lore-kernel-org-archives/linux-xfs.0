Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 770417F56
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 06:29:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6218D8F8039
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 04:29:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3AKrQtqjdFaGWjfE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Jun 2015 04:29:26 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id CE00219F25A
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 11:29:25 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t58BTPKC021624
	for <xfs@oss.sgi.com>; Mon, 8 Jun 2015 07:29:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/4] repair: helper to import on-disk inobt records to in-core
	trees
Date: Mon,  8 Jun 2015 07:29:23 -0400
Message-Id: <1433762964-11502-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433762964-11502-1-git-send-email-bfoster@redhat.com>
References: <1433762964-11502-1-git-send-email-bfoster@redhat.com>
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

In the common case, the in-core inode state from the on-disk inobt
records is imported from the inobt and validated against the finobt (if
one exists). When both trees exist along with some form of corruption,
it's possible to find inodes in the finobt not tracked by the inobt.
While this is unexpected, we attempt to repair by importing the inodes
from the finobt.

The associated code in the finobt scan function mirrors the associated
code in the inobt scan function. Factor this into a separate helper that
can be called by either tree scan.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/scan.c | 199 +++++++++++++++++++++++++++-------------------------------
 1 file changed, 91 insertions(+), 108 deletions(-)

diff --git a/repair/scan.c b/repair/scan.c
index 14a816d..8711b94 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -855,6 +855,81 @@ _("bad ending inode # (%" PRIu64 " (0x%x 0x%zx)) in %s rec, skipping rec\n"),
 	return suspect;
 }
 
+/*
+ * Process the state of individual inodes in an on-disk inobt record and import
+ * into the appropriate in-core tree based on whether the on-disk tree is
+ * suspect. Return the total and free inode counts based on the record free and
+ * hole masks.
+ */
+static int
+import_single_ino_chunk(
+	xfs_agnumber_t		agno,
+	enum inobt_type		type,
+	struct xfs_inobt_rec	*rp,
+	int			suspect,
+	int			*p_nfree,
+	int			*p_ninodes)
+{
+	struct ino_tree_node	*ino_rec = NULL;
+	const char		*inobt_name = inobt_names[type];
+	xfs_agino_t		ino;
+	int			j;
+	int			nfree;
+	int			ninodes;
+
+	ino = be32_to_cpu(rp->ir_startino);
+
+	if (!suspect) {
+		if (XFS_INOBT_IS_FREE_DISK(rp, 0))
+			ino_rec = set_inode_free_alloc(mp, agno, ino);
+		else
+			ino_rec = set_inode_used_alloc(mp, agno, ino);
+		for (j = 1; j < XFS_INODES_PER_CHUNK; j++) {
+			if (XFS_INOBT_IS_FREE_DISK(rp, j))
+				set_inode_free(ino_rec, j);
+			else
+				set_inode_used(ino_rec, j);
+		}
+	} else {
+		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
+			if (XFS_INOBT_IS_FREE_DISK(rp, j))
+				add_aginode_uncertain(mp, agno, ino + j, 1);
+			else
+				add_aginode_uncertain(mp, agno, ino + j, 0);
+		}
+	}
+
+	/*
+	 * Mark sparse inodes as such in the in-core tree. Verify that sparse
+	 * inodes are free and that freecount is consistent with the free mask.
+	 */
+	nfree = ninodes = 0;
+	for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
+		if (ino_issparse(rp, j)) {
+			if (!suspect && !XFS_INOBT_IS_FREE_DISK(rp, j)) {
+				do_warn(
+_("ir_holemask/ir_free mismatch, %s chunk %d/%u, holemask 0x%x free 0x%llx\n"),
+					inobt_name, agno, ino,
+					be16_to_cpu(rp->ir_u.sp.ir_holemask),
+					be64_to_cpu(rp->ir_free));
+				suspect++;
+			}
+			if (!suspect && ino_rec)
+				set_inode_sparse(ino_rec, j);
+		} else {
+			/* count fields track non-sparse inos */
+			if (XFS_INOBT_IS_FREE_DISK(rp, j))
+				nfree++;
+			ninodes++;
+		}
+	}
+
+	*p_nfree = nfree;
+	*p_ninodes = ninodes;
+
+	return suspect;
+}
+
 static int
 scan_single_ino_chunk(
 	xfs_agnumber_t		agno,
@@ -869,7 +944,6 @@ scan_single_ino_chunk(
 	int			ninodes;
 	int			off;
 	int			state;
-	ino_tree_node_t		*ino_rec = NULL;
 	ino_tree_node_t		*first_rec, *last_rec;
 	int			freecount;
 	bool			skip = false;
@@ -946,57 +1020,13 @@ _("inode rec for ino %" PRIu64 " (%d/%d) overlaps existing rec (start %d/%d)\n")
 	}
 
 	/*
-	 * now mark all the inodes as existing and free or used.
-	 * if the tree is suspect, put them into the uncertain
-	 * inode tree.
-	 */
-	if (!suspect)  {
-		if (XFS_INOBT_IS_FREE_DISK(rp, 0)) {
-			ino_rec = set_inode_free_alloc(mp, agno, ino);
-		} else  {
-			ino_rec = set_inode_used_alloc(mp, agno, ino);
-		}
-		for (j = 1; j < XFS_INODES_PER_CHUNK; j++) {
-			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
-				set_inode_free(ino_rec, j);
-			} else  {
-				set_inode_used(ino_rec, j);
-			}
-		}
-	} else  {
-		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
-			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
-				add_aginode_uncertain(mp, agno, ino + j, 1);
-			} else  {
-				add_aginode_uncertain(mp, agno, ino + j, 0);
-			}
-		}
-	}
-
-	/*
-	 * Mark sparse inodes as such in the in-core tree. Verify that sparse
-	 * inodes are free and that freecount is consistent with the free mask.
+	 * Import the state of individual inodes into the appropriate in-core
+	 * trees, mark them free or used, and get the resulting total and free
+	 * inode counts.
 	 */
 	nfree = ninodes = 0;
-	for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
-		if (ino_issparse(rp, j)) {
-			if (!suspect && !XFS_INOBT_IS_FREE_DISK(rp, j)) {
-				do_warn(
-_("ir_holemask/ir_free mismatch, inode chunk %d/%u, holemask 0x%x free 0x%llx\n"),
-					agno, ino,
-					be16_to_cpu(rp->ir_u.sp.ir_holemask),
-					be64_to_cpu(rp->ir_free));
-				suspect++;
-			}
-			if (!suspect && ino_rec)
-				set_inode_sparse(ino_rec, j);
-		} else {
-			/* count fields track non-sparse inos */
-			if (XFS_INOBT_IS_FREE_DISK(rp, j))
-				nfree++;
-			ninodes++;
-		}
-	}
+	suspect = import_single_ino_chunk(agno, INOBT, rp, suspect, &nfree,
+					 &ninodes);
 
 	if (nfree != freecount) {
 		do_warn(
@@ -1029,7 +1059,6 @@ scan_single_finobt_chunk(
 	int			ninodes;
 	int			off;
 	int			state;
-	ino_tree_node_t		*ino_rec = NULL;
 	ino_tree_node_t		*first_rec, *last_rec;
 	int			freecount;
 	bool			skip = false;
@@ -1138,68 +1167,22 @@ _("finobt rec for ino %" PRIu64 " (%d/%u) does not match existing rec (%d/%d)\n"
 	}
 
 	/*
-	 * the finobt contains a record that the previous alloc inobt scan never
-	 * found. insert the inodes into the appropriate tree.
+	 * The finobt contains a record that the previous inobt scan never
+	 * found. Warn about it and import the inodes into the appropriate
+	 * trees.
+	 *
+	 * Note that this should do the right thing if the previous inobt scan
+	 * had added these inodes to the uncertain tree. If the finobt is not
+	 * suspect, these inodes should supercede the uncertain ones. Otherwise,
+	 * the uncertain tree helpers handle the case where uncertain inodes
+	 * already exist.
 	 */
 	do_warn(_("undiscovered finobt record, ino %" PRIu64 " (%d/%u)\n"),
 		lino, agno, ino);
 
-	if (!suspect) {
-		/*
-		 * inodes previously inserted into the uncertain tree should be
-		 * superceded by these when the uncertain tree is processed
-		 */
-		if (XFS_INOBT_IS_FREE_DISK(rp, 0)) {
-			ino_rec = set_inode_free_alloc(mp, agno, ino);
-		} else  {
-			ino_rec = set_inode_used_alloc(mp, agno, ino);
-		}
-		for (j = 1; j < XFS_INODES_PER_CHUNK; j++) {
-			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
-				set_inode_free(ino_rec, j);
-			} else  {
-				set_inode_used(ino_rec, j);
-			}
-		}
-	} else {
-		/*
-		 * this should handle the case where the inobt scan may have
-		 * already added uncertain inodes
-		 */
-		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
-			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
-				add_aginode_uncertain(mp, agno, ino + j, 1);
-			} else {
-				add_aginode_uncertain(mp, agno, ino + j, 0);
-			}
-		}
-	}
-
-	/*
-	 * Mark sparse inodes as such in the in-core tree. Verify that sparse
-	 * inodes are free and that freecount is consistent with the free mask.
-	 */
 	nfree = ninodes = 0;
-	for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
-		if (ino_issparse(rp, j)) {
-			if (!suspect && !XFS_INOBT_IS_FREE_DISK(rp, j)) {
-				do_warn(
-_("finobt ir_holemask/ir_free mismatch, inode chunk %d/%u, holemask 0x%x free 0x%llx\n"),
-					agno, ino,
-					be16_to_cpu(rp->ir_u.sp.ir_holemask),
-					be64_to_cpu(rp->ir_free));
-				suspect++;
-			}
-			if (!suspect && ino_rec)
-				set_inode_sparse(ino_rec, j);
-		} else {
-			/* count fields track non-sparse inos */
-			if (XFS_INOBT_IS_FREE_DISK(rp, j))
-				nfree++;
-			ninodes++;
-		}
-
-	}
+	suspect = import_single_ino_chunk(agno, FINOBT, rp, suspect, &nfree,
+					 &ninodes);
 
 check_freecount:
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
