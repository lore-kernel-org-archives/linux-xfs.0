Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6FBBB7F54
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 06:29:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 42CFD8F8035
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 04:29:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6KCptRzOg6ffdkYx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Jun 2015 04:29:26 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id D0C7139EC6D
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 11:29:25 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t58BTPfN017981
	for <xfs@oss.sgi.com>; Mon, 8 Jun 2015 07:29:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/4] repair: helper for inode chunk alignment and start/end
	ino number verification
Date: Mon,  8 Jun 2015 07:29:22 -0400
Message-Id: <1433762964-11502-3-git-send-email-bfoster@redhat.com>
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

The inobt scan code executes different routines for processing inobt
records and finobt records. While some verification differs between the
trees, much of it is the same. One such example of this is the inode
record alignment and start/end inode number verification. The only
difference between the inobt and finobt verification is the error
message that is generated as a result of failure.

Factor out these alignment checks into a new helper that takes an enum
parameter that identifies which tree is undergoing the scan. Use a new
string array for this function and subsequent common inobt scan helpers
to convert the enum to the name of the tree for the purposes of
including in any resulting warning messages.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/scan.c | 167 ++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 93 insertions(+), 74 deletions(-)

diff --git a/repair/scan.c b/repair/scan.c
index 1a6f0c5..14a816d 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -764,77 +764,130 @@ ino_issparse(
 	return xfs_inobt_is_sparse_disk(rp, offset);
 }
 
+/*
+ * The following helpers are to help process and validate individual on-disk
+ * inode btree records. We have two possible inode btrees with slightly
+ * different semantics. Many of the validations and actions are equivalent, such
+ * as record alignment constraints, etc. Other validations differ, such as the
+ * fact that the inode chunk block allocation state is set by the content of the
+ * core inobt and verified by the content of the finobt.
+ *
+ * The following structures are used to facilitate common validation routines
+ * where the only difference between validation of the inobt or finobt might be
+ * the error messages that results in the event of failure.
+ */
+
+enum inobt_type {
+	INOBT,
+	FINOBT
+};
+const char *inobt_names[] =	{
+	"inobt",
+	"finobt"
+};
+
 static int
-scan_single_ino_chunk(
+verify_single_ino_chunk_align(
 	xfs_agnumber_t		agno,
-	xfs_inobt_rec_t		*rp,
-	int			suspect)
+	enum inobt_type		type,
+	struct xfs_inobt_rec	*rp,
+	int			suspect,
+	bool			*skip)
 {
+	const char		*inobt_name = inobt_names[type];
 	xfs_ino_t		lino;
 	xfs_agino_t		ino;
 	xfs_agblock_t		agbno;
-	int			j;
-	int			nfree;
-	int			ninodes;
 	int			off;
-	int			state;
-	ino_tree_node_t		*ino_rec = NULL;
-	ino_tree_node_t		*first_rec, *last_rec;
-	int			freecount;
 
+	*skip = false;
 	ino = be32_to_cpu(rp->ir_startino);
 	off = XFS_AGINO_TO_OFFSET(mp, ino);
 	agbno = XFS_AGINO_TO_AGBNO(mp, ino);
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
-	freecount = inorec_get_freecount(mp, rp);
 
 	/*
-	 * on multi-block block chunks, all chunks start
-	 * at the beginning of the block.  with multi-chunk
-	 * blocks, all chunks must start on 64-inode boundaries
-	 * since each block can hold N complete chunks. if
-	 * fs has aligned inodes, all chunks must start
-	 * at a fs_ino_alignment*N'th agbno.  skip recs
-	 * with badly aligned starting inodes.
+	 * on multi-block block chunks, all chunks start at the beginning of the
+	 * block. with multi-chunk blocks, all chunks must start on 64-inode
+	 * boundaries since each block can hold N complete chunks. if fs has
+	 * aligned inodes, all chunks must start at a fs_ino_alignment*N'th
+	 * agbno. skip recs with badly aligned starting inodes.
 	 */
 	if (ino == 0 ||
 	    (inodes_per_block <= XFS_INODES_PER_CHUNK && off !=  0) ||
 	    (inodes_per_block > XFS_INODES_PER_CHUNK &&
 	     off % XFS_INODES_PER_CHUNK != 0) ||
 	    (fs_aligned_inodes && fs_ino_alignment &&
-	     agbno % fs_ino_alignment != 0))  {
+	     agbno % fs_ino_alignment != 0)) {
 		do_warn(
-	_("badly aligned inode rec (starting inode = %" PRIu64 ")\n"),
-			lino);
+	_("badly aligned %s rec (starting inode = %" PRIu64 ")\n"),
+			inobt_name, lino);
 		suspect++;
 	}
 
 	/*
-	 * verify numeric validity of inode chunk first
-	 * before inserting into a tree.  don't have to
-	 * worry about the overflow case because the
-	 * starting ino number of a chunk can only get
-	 * within 255 inodes of max (NULLAGINO).  if it
-	 * gets closer, the agino number will be illegal
-	 * as the agbno will be too large.
+	 * verify numeric validity of inode chunk first before inserting into a
+	 * tree. don't have to worry about the overflow case because the
+	 * starting ino number of a chunk can only get within 255 inodes of max
+	 * (NULLAGINO). if it gets closer, the agino number will be illegal as
+	 * the agbno will be too large.
 	 */
-	if (verify_aginum(mp, agno, ino))  {
+	if (verify_aginum(mp, agno, ino)) {
 		do_warn(
-_("bad starting inode # (%" PRIu64 " (0x%x 0x%x)) in ino rec, skipping rec\n"),
-			lino, agno, ino);
+_("bad starting inode # (%" PRIu64 " (0x%x 0x%x)) in %s rec, skipping rec\n"),
+			lino, agno, ino, inobt_name);
+		*skip = true;
 		return ++suspect;
 	}
 
 	if (verify_aginum(mp, agno,
-			ino + XFS_INODES_PER_CHUNK - 1))  {
+			ino + XFS_INODES_PER_CHUNK - 1)) {
 		do_warn(
-_("bad ending inode # (%" PRIu64 " (0x%x 0x%zx)) in ino rec, skipping rec\n"),
+_("bad ending inode # (%" PRIu64 " (0x%x 0x%zx)) in %s rec, skipping rec\n"),
 			lino + XFS_INODES_PER_CHUNK - 1,
 			agno,
-			ino + XFS_INODES_PER_CHUNK - 1);
+			ino + XFS_INODES_PER_CHUNK - 1,
+			inobt_name);
+		*skip = true;
 		return ++suspect;
 	}
 
+	return suspect;
+}
+
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
+	int			ninodes;
+	int			off;
+	int			state;
+	ino_tree_node_t		*ino_rec = NULL;
+	ino_tree_node_t		*first_rec, *last_rec;
+	int			freecount;
+	bool			skip = false;
+
+	ino = be32_to_cpu(rp->ir_startino);
+	off = XFS_AGINO_TO_OFFSET(mp, ino);
+	agbno = XFS_AGINO_TO_AGBNO(mp, ino);
+	lino = XFS_AGINO_TO_INO(mp, agno, ino);
+	freecount = inorec_get_freecount(mp, rp);
+
+	/*
+	 * Verify record alignment, start/end inode numbers, etc.
+	 */
+	suspect = verify_single_ino_chunk_align(agno, INOBT, rp, suspect,
+						&skip);
+	if (skip)
+		return suspect;
+
 	/*
 	 * set state of each block containing inodes
 	 */
@@ -979,6 +1032,7 @@ scan_single_finobt_chunk(
 	ino_tree_node_t		*ino_rec = NULL;
 	ino_tree_node_t		*first_rec, *last_rec;
 	int			freecount;
+	bool			skip = false;
 
 	ino = be32_to_cpu(rp->ir_startino);
 	off = XFS_AGINO_TO_OFFSET(mp, ino);
@@ -987,47 +1041,12 @@ scan_single_finobt_chunk(
 	freecount = inorec_get_freecount(mp, rp);
 
 	/*
-	 * on multi-block block chunks, all chunks start at the beginning of the
-	 * block. with multi-chunk blocks, all chunks must start on 64-inode
-	 * boundaries since each block can hold N complete chunks. if fs has
-	 * aligned inodes, all chunks must start at a fs_ino_alignment*N'th
-	 * agbno. skip recs with badly aligned starting inodes.
-	 */
-	if (ino == 0 ||
-	    (inodes_per_block <= XFS_INODES_PER_CHUNK && off !=  0) ||
-	    (inodes_per_block > XFS_INODES_PER_CHUNK &&
-	     off % XFS_INODES_PER_CHUNK != 0) ||
-	    (fs_aligned_inodes && fs_ino_alignment &&
-	     agbno % fs_ino_alignment != 0)) {
-		do_warn(
-	_("badly aligned finobt inode rec (starting inode = %" PRIu64 ")\n"),
-			lino);
-		suspect++;
-	}
-
-	/*
-	 * verify numeric validity of inode chunk first before inserting into a
-	 * tree. don't have to worry about the overflow case because the
-	 * starting ino number of a chunk can only get within 255 inodes of max
-	 * (NULLAGINO). if it gets closer, the agino number will be illegal as
-	 * the agbno will be too large.
+	 * Verify record alignment, start/end inode numbers, etc.
 	 */
-	if (verify_aginum(mp, agno, ino)) {
-		do_warn(
-_("bad starting inode # (%" PRIu64 " (0x%x 0x%x)) in finobt rec, skipping rec\n"),
-			lino, agno, ino);
-		return ++suspect;
-	}
-
-	if (verify_aginum(mp, agno,
-			ino + XFS_INODES_PER_CHUNK - 1)) {
-		do_warn(
-_("bad ending inode # (%" PRIu64 " (0x%x 0x%zx)) in finobt rec, skipping rec\n"),
-			lino + XFS_INODES_PER_CHUNK - 1,
-			agno,
-			ino + XFS_INODES_PER_CHUNK - 1);
-		return ++suspect;
-	}
+	suspect = verify_single_ino_chunk_align(agno, FINOBT, rp, suspect,
+						&skip);
+	if (skip)
+		return suspect;
 
 	/*
 	 * cross check state of each block containing inodes referenced by the
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
