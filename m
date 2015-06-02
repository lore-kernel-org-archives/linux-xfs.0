Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1DEB87F6C
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BEB59AC002
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HHRPw4ADkMzkC7Ac (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:06 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 55026359998
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:05 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig4bk016949
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 18/28] repair: scan and track sparse inode chunks correctly
Date: Tue,  2 Jun 2015 14:41:51 -0400
Message-Id: <1433270521-62026-19-git-send-email-bfoster@redhat.com>
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

Phase 2 of xfs_repair scans the on-disk inobt and creates in-core
records for all inodes in the fs. This also involves marking
free/allocated state of all inodes, internal record verification and
block state management for the inode chunks tracked by inode records.
Various parts of the inobt scan mechanism assume fully allocated inode
records and thus lead to spurious errors when sparse inode records are
encountered.

Update the inobt scan to detect and handle sparse inode records
correctly. Do not set the allocation state of blocks in sparse inode
regions as these blocks do not belong to the record. Do not account
sparse inodes against the ir_freecount as these inodes do not exist and
are not available for allocation by the fs. Finally, track the sparse
status of each individual inode in the in-core inode records for future
reference.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 include/libxfs.h    | 16 ++++++++++++++++
 repair/incore.h     | 14 ++++++++++++++
 repair/incore_ino.c |  1 +
 repair/scan.c       | 48 +++++++++++++++++++++++++++++++++++++++++-------
 4 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 6a59cc0..3321c50 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -183,6 +183,22 @@ extern unsigned long	libxfs_physmem(void);	/* in kilobytes */
 #define XFS_INOBT_IS_FREE_DISK(rp,i)		\
 			((be64_to_cpu((rp)->ir_free) & XFS_INOBT_MASK(i)) != 0)
 
+static inline bool
+XFS_INOBT_IS_SPARSE_DISK(
+	struct xfs_inobt_rec	*rp,
+	int			offset)
+{
+	int			spshift;
+	uint16_t		holemask;
+
+	holemask = be16_to_cpu(rp->ir_u.sp.ir_holemask);
+	spshift = offset / XFS_INODES_PER_HOLEMASK_BIT;
+	if ((1 << spshift) & holemask)
+		return true;
+
+	return false;
+}
+
 static inline void
 libxfs_bmbt_disk_get_all(
 	struct xfs_bmbt_rec	*rp,
diff --git a/repair/incore.h b/repair/incore.h
index ba819b4..d4e44a7 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -285,6 +285,7 @@ typedef struct ino_tree_node  {
 	avlnode_t		avl_node;
 	xfs_agino_t		ino_startnum;	/* starting inode # */
 	xfs_inofree_t		ir_free;	/* inode free bit mask */
+	__uint64_t		ir_sparse;	/* sparse inode bitmask */
 	__uint64_t		ino_confirmed;	/* confirmed bitmask */
 	__uint64_t		ino_isa_dir;	/* bit == 1 if a directory */
 	__uint8_t		nlink_size;
@@ -477,6 +478,19 @@ static inline int is_inode_free(struct ino_tree_node *irec, int offset)
 }
 
 /*
+ * set/test is inode sparse (not physically allocated)
+ */
+static inline void set_inode_sparse(struct ino_tree_node *irec, int offset)
+{
+	irec->ir_sparse |= XFS_INOBT_MASK(offset);
+}
+
+static inline bool is_inode_sparse(struct ino_tree_node *irec, int offset)
+{
+	return irec->ir_sparse & XFS_INOBT_MASK(offset);
+}
+
+/*
  * add_inode_reached() is set on inode I only if I has been reached
  * by an inode P claiming to be the parent and if I is a directory,
  * the .. link in the I says that P is I's parent.
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 9502648..cda6c2b 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -258,6 +258,7 @@ alloc_ino_node(
 	irec->ino_confirmed = 0;
 	irec->ino_isa_dir = 0;
 	irec->ir_free = (xfs_inofree_t) - 1;
+	irec->ir_sparse = 0;
 	irec->ino_un.ex_data = NULL;
 	irec->nlink_size = sizeof(__uint8_t);
 	irec->disk_nlinks.un8 = alloc_nlink_array(irec->nlink_size);
diff --git a/repair/scan.c b/repair/scan.c
index 8677e41..5b67e15 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -736,6 +736,17 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 	}
 }
 
+static bool
+ino_issparse(
+	struct xfs_inobt_rec	*rp,
+	int			offset)
+{
+	if (!xfs_sb_version_hassparseinodes(&mp->m_sb))
+		return false;
+
+	return XFS_INOBT_IS_SPARSE_DISK(rp, offset);
+}
+
 static int
 scan_single_ino_chunk(
 	xfs_agnumber_t		agno,
@@ -749,7 +760,8 @@ scan_single_ino_chunk(
 	int			nfree;
 	int			off;
 	int			state;
-	ino_tree_node_t		*ino_rec, *first_rec, *last_rec;
+	ino_tree_node_t		*ino_rec = NULL;
+	ino_tree_node_t		*first_rec, *last_rec;
 	int			freecount;
 
 	ino = be32_to_cpu(rp->ir_startino);
@@ -815,8 +827,12 @@ _("bad ending inode # (%" PRIu64 " (0x%x 0x%zx)) in ino rec, skipping rec\n"),
 		for (j = 0;
 		     j < XFS_INODES_PER_CHUNK;
 		     j += mp->m_sb.sb_inopblock)  {
-			agbno = XFS_AGINO_TO_AGBNO(mp, ino + j);
 
+			/* inodes in sparse chunks don't use blocks */
+			if (ino_issparse(rp, j))
+				continue;
+
+			agbno = XFS_AGINO_TO_AGBNO(mp, ino + j);
 			state = get_bmap(agno, agbno);
 			if (state == XR_E_UNKNOWN)  {
 				set_bmap(agno, agbno, XR_E_INO);
@@ -861,8 +877,6 @@ _("inode rec for ino %" PRIu64 " (%d/%d) overlaps existing rec (start %d/%d)\n")
 			return suspect;
 	}
 
-	nfree = 0;
-
 	/*
 	 * now mark all the inodes as existing and free or used.
 	 * if the tree is suspect, put them into the uncertain
@@ -870,14 +884,12 @@ _("inode rec for ino %" PRIu64 " (%d/%d) overlaps existing rec (start %d/%d)\n")
 	 */
 	if (!suspect)  {
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
@@ -886,7 +898,6 @@ _("inode rec for ino %" PRIu64 " (%d/%d) overlaps existing rec (start %d/%d)\n")
 	} else  {
 		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
 			if (XFS_INOBT_IS_FREE_DISK(rp, j)) {
-				nfree++;
 				add_aginode_uncertain(mp, agno, ino + j, 1);
 			} else  {
 				add_aginode_uncertain(mp, agno, ino + j, 0);
@@ -894,6 +905,29 @@ _("inode rec for ino %" PRIu64 " (%d/%d) overlaps existing rec (start %d/%d)\n")
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
+_("ir_holemask/ir_free mismatch, inode chunk %d/%u, holemask 0x%x free 0x%llx\n"),
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
 	if (nfree != freecount) {
 		do_warn(
 _("ir_freecount/free mismatch, inode chunk %d/%u, freecount %d nfree %d\n"),
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
