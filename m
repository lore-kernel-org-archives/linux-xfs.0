Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9541829E09
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 22:27:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7505C8F8035
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:27:08 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 7VamAmLDHpHzPqTk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 20:27:06 -0700 (PDT)
Subject: [PATCH 13/15] xfs_repair: process reverse-mapping data into
	refcount data
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 20:27:02 -0700
Message-ID: <20150630032702.572.69539.stgit@birch.djwong.org>
In-Reply-To: <20150630032538.572.20293.stgit@birch.djwong.org>
References: <20150630032538.572.20293.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Take all the reverse-mapping data we've acquired and use it to generate
reference count data.  This data is used in phase 5 to rebuild the
reflink btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase4.c |   65 +++++++++
 repair/rmap.c   |  414 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.h   |    4 +
 3 files changed, 481 insertions(+), 2 deletions(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index 2c2cccb..64627a5 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -30,6 +30,8 @@
 #include "versions.h"
 #include "dir2.h"
 #include "progress.h"
+#include "slab.h"
+#include "rmap.h"
 
 bool collect_rmaps = false;
 
@@ -154,6 +156,61 @@ process_ags(
 	do_inode_prefetch(mp, ag_stride, process_ag_func, true, false);
 }
 
+static void
+process_ag_rmaps(
+	work_queue_t	*wq,
+	xfs_agnumber_t	agno,
+	void		*arg)
+{
+	int		error;
+
+	do_log(_("        - agno = %d\n"), agno);
+	error = rebuild_ag_rlrmap_records(wq->mp, agno);
+	if (error)
+		do_error(
+_("%s while processing reverse-mapping records.\n"),
+			 strerror(-error));
+}
+
+static void
+process_inode_reflink_flags(
+	work_queue_t	*wq,
+	xfs_agnumber_t	agno,
+	void		*arg)
+{
+	int		error;
+
+	error = reflink_fix_inode_flags(wq->mp, agno);
+	if (error)
+		do_error(
+_("%s while fixing inode reflink flags.\n"),
+			 strerror(-error));
+}
+
+static void
+process_rmaps(
+	xfs_mount_t		*mp)
+{
+	struct work_queue	wq;
+	xfs_agnumber_t		i;
+
+	if (!needs_rmap_work(mp))
+		return;
+
+	do_log(_("        - processing reverse mapping data...\n"));
+	create_work_queue(&wq, mp, libxfs_nproc());
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+		queue_work(&wq, process_ag_rmaps, i, NULL);
+	destroy_work_queue(&wq);
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return;
+
+	create_work_queue(&wq, mp, libxfs_nproc());
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+		queue_work(&wq, process_inode_reflink_flags, i, NULL);
+	destroy_work_queue(&wq);
+}
 
 void
 phase4(xfs_mount_t *mp)
@@ -302,6 +359,14 @@ phase4(xfs_mount_t *mp)
 	 * already in phase 3.
 	 */
 	process_ags(mp);
+
+
+	/*
+	 * Rebuild the reverse mapping and reflink records based on the
+	 * mappings we observed.
+	 */
+	process_rmaps(mp);
+
 	print_final_rpt();
 
 	/*
diff --git a/repair/rmap.c b/repair/rmap.c
index 2e1829c..cc34570 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -40,7 +40,6 @@ typedef struct xfs_rmap {
 	xfs_fileoff_t	rm_startoff;	/* starting file offset */
 	xfs_agblock_t	rm_startblock;	/* starting AG block number */
 	xfs_extlen_t	rm_blockcount;	/* number of AG blocks */
-	struct xfs_rmap	*rm_next;	/* next item in stack */
 } xfs_rmap_t;
 
 /* per-AG rmap object anchor */
@@ -150,7 +149,6 @@ add_rmap(
 	rmap.rm_startoff = irec->br_startoff;
 	rmap.rm_startblock = agbno;
 	rmap.rm_blockcount = irec->br_blockcount;
-	rmap.rm_next = NULL;
 	return slab_add(rmaps, &rmap);
 }
 
@@ -174,6 +172,312 @@ dump_rmap(
 #endif
 
 /**
+ * rmap_compare() -- Compare rmap observations for array sorting.
+ */
+static int
+rmap_compare(
+	const void		*a,
+	const void		*b)
+{
+	const xfs_rmap_t	*pa;
+	const xfs_rmap_t	*pb;
+
+	pa = a; pb = b;
+	if (pa->rm_startblock < pb->rm_startblock)
+		return -1;
+	else if (pa->rm_startblock > pb->rm_startblock)
+		return 1;
+	else if (pa->rm_ino < pb->rm_ino)
+		return -1;
+	else if (pa->rm_ino > pb->rm_ino)
+		return 1;
+	else if (pa->rm_startoff < pb->rm_startoff)
+		return 1;
+	else if (pa->rm_startoff > pb->rm_startoff)
+		return 1;
+	else
+		return 0;
+}
+
+/**
+ * rmap_sb_compare() -- Compare function for rmap observations so that they
+ *                      come out in pblk order.
+ */
+static int
+rmap_sb_compare(
+	const void		*a,
+	const void		*b)
+{
+	const xfs_rmap_t	*pa;
+	const xfs_rmap_t	*pb;
+
+	pa = a; pb = b;
+	if (pa->rm_startblock < pb->rm_startblock)
+		return -1;
+	else if (pa->rm_startblock > pb->rm_startblock)
+		return 1;
+	else
+		return 0;
+}
+
+/**
+ * mark_inode_rl() -- Mark all inodes in the reverse-mapping observation stack
+ *                    has requiring the reflink inode flag, if the stack depth
+ *                    is greater than 1.
+ *
+ * @mp: XFS mount object.
+ * @rmaps: Head of the stack of rmap observations.
+ * @nr_rmaps: Depth of the stack.
+ */
+static void
+mark_inode_rl(
+	xfs_mount_t		*mp,
+	xfs_bag_t		*rmaps)
+{
+	xfs_agnumber_t		iagno;
+	xfs_rmap_t		*rmap;
+	ino_tree_node_t		*irec;
+	int			off;
+	size_t			idx;
+	xfs_agino_t		ino;
+
+	if (bag_count(rmaps) < 2)
+		return;
+
+	/* Reflink flag accounting */
+	foreach_bag_ptr(rmaps, idx, rmap) {
+		iagno = XFS_INO_TO_AGNO(mp, rmap->rm_ino);
+		ino = XFS_INO_TO_AGINO(mp, rmap->rm_ino);
+		pthread_mutex_lock(&ag_locks[iagno].lock);
+		irec = find_inode_rec(mp, iagno, ino);
+		off = get_inode_offset(mp, rmap->rm_ino, irec);
+		/* lock here because we might go outside this ag */
+		set_inode_is_rl(irec, off);
+		pthread_mutex_unlock(&ag_locks[iagno].lock);
+	}
+}
+
+/**
+ * rmap_emit() -- Emit reverse-mapping objects for rmapbt reconstruction
+ *                during phase 5.
+ *
+ * @mp: XFS mount object.
+ * @agno: The AG number.
+ * @agbno: AG block number of the reverse mapping extent.
+ * @len: Length of the extent.
+ * @rmaps: Stack of reverse-mapping observations.
+ * @nr_rmaps: Depth of the stack.
+ */
+static void
+rmap_emit(
+	xfs_mount_t		*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len,
+	xfs_bag_t		*rmaps)
+{
+	xfs_rmap_t		*rmap;
+	size_t			n;
+
+	ASSERT(bag_count(rmaps) > 0);
+
+	foreach_bag_ptr(rmaps, n, rmap) {
+		ASSERT(rmap->rm_blockcount >= len);
+		ASSERT(rmap->rm_startblock <= agbno);
+		dbg_printf("RMAP(%zu): agno=%lu pblk=%llu, len=%lu -> ino=%llu, lblk=%llu\n",
+			n, (unsigned long)agno, (unsigned long long)agbno,
+			(unsigned long)len, (unsigned long long)rmap->rm_ino,
+			(unsigned long long)rmap->rm_startoff);
+	}
+}
+
+/**
+ * refcount_emit() -- Emit a reflink object for rlbt reconstruction
+ *                    during phase 5.
+ *
+ * @mp: XFS mount object.
+ * @agno: The AG number.
+ * @agbno: AG block number of the reverse mapping extent.
+ * @len: Length of the extent.
+ * @rmaps: Stack of reverse-mapping observations.
+ * @nr_rmaps: Depth of the stack.
+ * @is_rmap: True if reverse-mapping is enabled.
+ * @is_reflink: True if reflinking is enabled.
+ */
+#define REFCOUNT_CLAMP(nr)	((nr) > MAXRLCOUNT ? MAXRLCOUNT : (nr))
+static void
+refcount_emit(
+	xfs_mount_t		*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len,
+	size_t			nr_rmaps)
+{
+	xfs_reflink_rec_incore_t	rlrec;
+	int			error;
+	xfs_slab_t		*rlslab;
+
+	rlslab = ag_rmaps[agno].ar_reflink_items;
+	ASSERT(nr_rmaps > 0);
+
+	dbg_printf("REFL: agno=%u pblk=%u, len=%u -> refcount=%zu\n",
+		agno, agbno, len, nr_rmaps);
+	rlrec.rr_startblock = agbno;
+	rlrec.rr_blockcount = len;
+	rlrec.rr_nlinks = REFCOUNT_CLAMP(nr_rmaps);
+	error = slab_add(rlslab, &rlrec);
+	if (error)
+		do_error(
+_("Insufficient memory while recreating reflink tree."));
+}
+#undef REFCOUNT_CLAMP
+
+/**
+ * rebuild_ag_rlrmap_records() - transform a pile of physical block mapping
+ * 				 observations into reflink and rmap data for
+ * 				 eventual rebuilding of the btrees.
+ *
+ * XXX: Should the stack be sorted in order of last pblk?
+ * @mp: XFS mount object.
+ * @agno: AG number.
+ */
+#define RMAP_END(r)	((r)->rm_startblock + (r)->rm_blockcount)
+int
+rebuild_ag_rlrmap_records(
+	xfs_mount_t		*mp,
+	xfs_agnumber_t		agno)
+{
+	xfs_bag_t		*stack_top = NULL;
+	xfs_slab_t		*rmaps;
+	xfs_slab_cursor_t	*rmaps_cur;
+	xfs_rmap_t		*array_cur;
+	xfs_rmap_t		*rmap;
+	xfs_agblock_t		sbno;	/* first bno of this rmap set */
+	xfs_agblock_t		cbno;	/* first bno of this refcount set */
+	xfs_agblock_t		nbno;	/* next bno where rmap set changes */
+	size_t			n, idx;
+	size_t			old_stack_nr;
+	bool			is_rmap;
+	bool			is_reflink;
+	int			error;
+
+	is_reflink = xfs_sb_version_hasreflink(&mp->m_sb);
+	is_rmap = xfs_sb_version_hasrmapbt(&mp->m_sb);
+	if (!is_reflink && !is_rmap)
+		return 0;
+
+	rmaps = ag_rmaps[agno].ar_rmaps;
+	qsort_slab(rmaps, rmap_compare);
+
+	error = init_slab_cursor(rmaps, rmap_sb_compare, &rmaps_cur);
+	if (error)
+		return error;
+
+	error = init_bag(&stack_top);
+	if (error)
+		goto err;
+
+	/* While there are rmaps to be processed... */
+	n = 0;
+	while (n < slab_count(rmaps)) {
+		array_cur = peek_slab_cursor(rmaps_cur);
+		sbno = cbno = array_cur->rm_startblock;
+		/* Push all rmaps with pblk == sbno onto the stack */
+		for (;
+		     array_cur && array_cur->rm_startblock == sbno;
+		     array_cur = peek_slab_cursor(rmaps_cur)) {
+			advance_slab_cursor(rmaps_cur); n++;
+			dump_rmap("push0", agno, array_cur);
+			error = bag_add(stack_top, array_cur);
+			if (error)
+				goto err;
+		}
+		mark_inode_rl(mp, stack_top);
+
+		/* Set nbno to the bno of the next refcount change */
+		if (n < slab_count(rmaps))
+			nbno = array_cur->rm_startblock;
+		else
+			nbno = NULLAGBLOCK;
+		foreach_bag_ptr(stack_top, idx, rmap) {
+			nbno = min(nbno, RMAP_END(rmap));
+		}
+
+		/* Emit reverse mappings, if needed */
+		ASSERT(nbno > sbno);
+		if (is_rmap) {
+			rmap_emit(mp, agno, sbno, nbno - sbno, stack_top);
+		}
+		old_stack_nr = bag_count(stack_top);
+
+		/* While stack isn't empty... */
+		while (bag_count(stack_top)) {
+			/* Pop all rmaps that end at nbno */
+			foreach_bag_ptr_reverse(stack_top, idx, rmap) {
+				if (RMAP_END(rmap) != nbno)
+					continue;
+				dump_rmap("pop", agno, rmap);
+				error = bag_remove(stack_top, idx);
+				if (error)
+					goto err;
+			}
+
+			/* Push array items that start at nbno */
+			for (;
+			     array_cur && array_cur->rm_startblock == nbno;
+			     array_cur = peek_slab_cursor(rmaps_cur)) {
+				advance_slab_cursor(rmaps_cur); n++;
+				dump_rmap("push1", agno, array_cur);
+				error = bag_add(stack_top, array_cur);
+				if (error)
+					goto err;
+			}
+			mark_inode_rl(mp, stack_top);
+
+			/* Emit refcount if necessary */
+			ASSERT(nbno > cbno);
+			if (bag_count(stack_top) != old_stack_nr) {
+				if (is_reflink && old_stack_nr > 1) {
+					refcount_emit(mp, agno, cbno,
+						      nbno - cbno,
+						      old_stack_nr);
+				}
+				cbno = nbno;
+			}
+
+			/* Stack empty, go find the next rmap */
+			if (bag_count(stack_top) == 0)
+				break;
+			old_stack_nr = bag_count(stack_top);
+			sbno = nbno;
+
+			/* Set nbno to the bno of the next refcount change */
+			if (n < slab_count(rmaps))
+				nbno = array_cur->rm_startblock;
+			else
+				nbno = NULLAGBLOCK;
+			foreach_bag_ptr(stack_top, idx, rmap) {
+				nbno = min(nbno, RMAP_END(rmap));
+			}
+
+			/* Emit reverse mappings, if needed */
+			ASSERT(nbno > sbno);
+			if (is_rmap) {
+				rmap_emit(mp, agno, sbno, nbno - sbno,
+					  stack_top);
+			}
+		}
+	}
+err:
+	free_bag(&stack_top);
+	free_slab_cursor(&rmaps_cur);
+	free_slab(&ag_rmaps[agno].ar_rmaps);
+
+	return error;
+}
+#undef RMAP_END
+
+/**
  * reflink_record_inode_flag() -- Record that an inode had the reflink flag
  *                                set when repair started.  The inode reflink
  *                                flag will be adjusted as necessary.
@@ -204,3 +508,109 @@ reflink_record_inode_flag(
 	dbg_printf("set was_rl lino=%llu was=0x%llx\n",
 		(unsigned long long)lino, (unsigned long long)irec->ino_was_rl);
 }
+
+/**
+ * set_rl() -- Fix an inode's reflink flag.
+ *
+ * @mp: XFS mount object.
+ * @agno: AG number.
+ * @agino: per-AG inode number.
+ * @set: True if the flag must be set; False if it must be cleared.
+ */
+static int
+set_rl(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agno,
+	xfs_agino_t	agino,
+	bool		set)
+{
+	xfs_dinode_t	*dino;
+	xfs_buf_t	*buf;
+
+	buf = get_agino_buf(mp, agno, agino, &dino);
+	if (!buf)
+		return 1;
+	ASSERT(XFS_AGINO_TO_INO(mp, agno, agino) == be64_to_cpu(dino->di_ino));
+
+	if (set)
+		do_warn(
+_("setting reflink flag on inode %"PRIu64"\n"),
+			XFS_AGINO_TO_INO(mp, agno, agino));
+	else if (!no_modify) /* && !set */
+		do_warn(
+_("clearing reflink flag on inode %"PRIu64"\n"),
+			XFS_AGINO_TO_INO(mp, agno, agino));
+	if (no_modify) {
+		libxfs_putbuf(buf);
+		return 0;
+	}
+	if (set)
+		dino->di_flags |= cpu_to_be16(XFS_DIFLAG_REFLINK);
+	else
+		dino->di_flags &= cpu_to_be16(~XFS_DIFLAG_REFLINK);
+	libxfs_dinode_calc_crc(mp, dino);
+	libxfs_writebuf(buf, 0);
+
+	return 0;
+}
+
+/**
+ * reflink_fix_inode_flags() -- Fix discrepancies between the state of the
+ *                              inode reflink flag and our observations as to
+ *                              whether or not the inode really needs it.
+ * @mp: XFS mountpoint.
+ * @agno: AG number.
+ */
+int
+reflink_fix_inode_flags(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agno)
+{
+	ino_tree_node_t	*irec;
+	int		bit;
+	__uint64_t	was;
+	__uint64_t	is;
+	__uint64_t	diff;
+	__uint64_t	mask;
+	int		error = 0;
+	xfs_agino_t	agino;
+
+	/*
+	 * Update the reflink flag for any inode where there's a discrepancy
+	 * between the inode flag and whether or not we found any reflinked
+	 * extents.
+	 */
+	for (irec = findfirst_inode_rec(agno);
+	     irec != NULL;
+	     irec = next_ino_rec(irec)) {
+		ASSERT((irec->ino_was_rl & irec->ir_free) == 0);
+		ASSERT((irec->ino_is_rl & irec->ir_free) == 0);
+		was = irec->ino_was_rl;
+		is = irec->ino_is_rl;
+		if (was == is)
+			continue;
+		diff = was ^ is;
+		dbg_printf("mismatch ino=%llu was=0x%lx is=0x%lx dif=0x%lx\n",
+			(unsigned long long)XFS_AGINO_TO_INO(mp, agno,
+						irec->ino_startnum),
+			was, is, diff);
+
+		for (bit = 0, mask = 1; bit < 64; bit++, mask <<= 1) {
+			agino = bit + irec->ino_startnum;
+			if (!(diff & mask))
+				continue;
+			else if (was & mask)
+				error = set_rl(mp, agno, agino, false);
+			else if (is & mask)
+				error = set_rl(mp, agno, agino, true);
+			else
+				ASSERT(0);
+			if (error)
+				do_error(
+_("Unable to fix reflink flag on inode %"PRIu64".\n"),
+					XFS_AGINO_TO_INO(mp, agno, agino));
+		}
+	}
+
+	return error;
+}
diff --git a/repair/rmap.h b/repair/rmap.h
index 16ad157..7dc709f 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -31,4 +31,8 @@ extern void reflink_record_inode_flag(xfs_mount_t *mp, xfs_dinode_t *dino,
 
 extern bool needs_rmap_work(xfs_mount_t *mp);
 
+extern int reflink_fix_inode_flags(xfs_mount_t *mp, xfs_agnumber_t agno);
+
+extern int rebuild_ag_rlrmap_records(xfs_mount_t *mp, xfs_agnumber_t agno);
+
 #endif /* RMAP_H_ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
