Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88C1B7F90
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 13:53:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2FDEE30407F
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 11:53:10 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DszqFBFHi2IaHFfw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Feb 2015 11:53:08 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t16Jr7wm020999
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 6 Feb 2015 14:53:08 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t16Jr7Q2022354
	for <xfs@oss.sgi.com>; Fri, 6 Feb 2015 14:53:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 10/18] xfs: allocate sparse inode chunks on full chunk
	allocation failure
Date: Fri,  6 Feb 2015 14:52:57 -0500
Message-Id: <1423252385-3063-11-git-send-email-bfoster@redhat.com>
In-Reply-To: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
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

xfs_ialloc_ag_alloc() makes several attempts to allocate a full inode
chunk. If all else fails, reduce the allocation to the minimum sparse
granularity and attempt to allocate a sparse inode chunk.

If sparse chunk allocation succeeds, check whether an inobt record
already exists that can track the chunk. If so, inherit and update the
existing record. Otherwise, insert a new record for the sparse chunk.

Update xfs_inobt_insert_rec() to take the holemask as a parameter and
set the associated field on disk. Create the xfs_inobt_update_insert()
helper to handle the sparse chunk allocation case - insert or update an
existing record depending on whether it already exists.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 397 +++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_trace.h         |  47 ++++++
 2 files changed, 426 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index fc001d9..090d114 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -122,12 +122,16 @@ xfs_inobt_get_rec(
 STATIC int
 xfs_inobt_insert_rec(
 	struct xfs_btree_cur	*cur,
+	__uint16_t		holemask,
+	__uint8_t		count,
 	__int32_t		freecount,
 	xfs_inofree_t		free,
 	int			*stat)
 {
-	cur->bc_rec.i.ir_holemask = 0;
-	cur->bc_rec.i.ir_count = 0; /* zero for backwards compatibility */
+	ASSERT(count == 0 || xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb));
+
+	cur->bc_rec.i.ir_holemask = holemask;
+	cur->bc_rec.i.ir_count = count;
 	cur->bc_rec.i.ir_freecount = freecount;
 	cur->bc_rec.i.ir_free = free;
 	return xfs_btree_insert(cur, stat);
@@ -151,6 +155,19 @@ xfs_inobt_insert(
 	xfs_agino_t		thisino;
 	int			i;
 	int			error;
+	uint8_t			count;
+
+	/*
+	 * Only set ir_count in the inobt record if the sparse inodes feature is
+	 * enabled. If disabled, we must maintain backwards compatibility with
+	 * the older inobt record format where the current count and holemask
+	 * fields map to the higher order bytes of freecount and thus must be
+	 * zeroed.
+	 */
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+		count = XFS_INODES_PER_CHUNK;
+	else
+		count = 0;
 
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
 
@@ -164,7 +181,7 @@ xfs_inobt_insert(
 		}
 		ASSERT(i == 0);
 
-		error = xfs_inobt_insert_rec(cur, XFS_INODES_PER_CHUNK,
+		error = xfs_inobt_insert_rec(cur, 0, count, XFS_INODES_PER_CHUNK,
 					     XFS_INOBT_ALL_FREE, &i);
 		if (error) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
@@ -174,8 +191,58 @@ xfs_inobt_insert(
 	}
 
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+}
 
+/*
+ * Update or insert a new record based on a sparse inode chunk allocation.
+ *
+ * If a record already exists, the new record is an updated version of that
+ * record based on a merge of sparse inode chunks. Update the record in place.
+ * Otherwise, insert a new record in the tree. Note that the record to insert
+ * must already have been aligned and merged, if necessary.
+ */
+STATIC int
+xfs_inobt_update_insert(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	struct xfs_buf			*agbp,
+	struct xfs_inobt_rec_incore	*rec,
+	xfs_btnum_t			btnum)
+{
+	struct xfs_btree_cur		*cur;
+	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
+	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
+	int				i;
+	int				error;
+
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
+
+	error = xfs_inobt_lookup(cur, rec->ir_startino, XFS_LOOKUP_EQ, &i);
+	if (error)
+		goto error;
+	if (i == 1) {
+		/* found a record, update it with the merged record */
+		error = xfs_inobt_update(cur, rec);
+		if (error)
+			goto error;
+		goto out;
+	}
+
+	/* no existing record, insert a new one */
+	error = xfs_inobt_insert_rec(cur, rec->ir_holemask, rec->ir_count,
+				     rec->ir_freecount, rec->ir_free, &i);
+	if (error)
+		goto error;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
+
+out:
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	return 0;
+
+error:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
 }
 
 /*
@@ -215,8 +282,36 @@ xfs_check_agi_freecount(
 	}
 	return 0;
 }
+
+/*
+ * Verify that an inode record has a valid inode count. With sparse inode chunk
+ * support enabled, the count must be consistent with the holemask. Otherwise,
+ * the count is set to 0.
+ */
+STATIC int
+xfs_inobt_rec_check_count(
+	struct xfs_mount		*mp,
+	struct xfs_inobt_rec_incore	*rec)
+{
+	int	inocount;
+	DECLARE_BITMAP(allocbmap, XFS_INODES_PER_CHUNK);
+
+	if (!xfs_sb_version_hassparseinodes(&mp->m_sb)) {
+		if (rec->ir_count)
+			return -EFSCORRUPTED;
+		return 0;
+	}
+
+	xfs_inobt_ialloc_bitmap(allocbmap, rec);
+	inocount = bitmap_weight(allocbmap, XFS_INODES_PER_CHUNK);
+	if (inocount != rec->ir_count)
+		return -EFSCORRUPTED;
+
+	return 0;
+}
 #else
 #define xfs_check_agi_freecount(cur, agi)	0
+#define xfs_inobt_rec_check_count(mp, rec)	0
 #endif
 
 /*
@@ -358,6 +453,183 @@ xfs_ialloc_inode_init(
 }
 
 /*
+ * Align a record for a recently allocated sparse chunk. The input is a record
+ * that describes the unaligned chunk. The record is aligned such that it is fit
+ * for insertion (or merge) into the on-disk inode btrees.
+ */
+STATIC void
+xfs_align_sparse_rec(
+	struct xfs_mount		*mp,
+	struct xfs_inobt_rec_incore	*rec)
+{
+	xfs_agblock_t			agbno;
+	xfs_agblock_t			mod;
+	int				offset;
+	uint16_t			allocmask;
+
+	agbno = XFS_AGINO_TO_AGBNO(mp, rec->ir_startino);
+	mod = agbno % mp->m_sb.sb_inoalignmt;
+	if (!mod)
+		return;
+
+	/* calculate the inode offset and align startino */
+	offset = mod << mp->m_sb.sb_inopblog;
+	rec->ir_startino -= offset;
+
+	/*
+	 * Since startino has been aligned down, we have to left shift
+	 * ir_holemask such that it continues to represent the same physical
+	 * inodes as the unaligned record. The unaligned record by definition
+	 * tracks the allocated inodes with the lowest order bits.
+	 *
+	 * ir_holemask is inverted before the shift such that set bits represent
+	 * allocated inodes. This makes it safe for the bit-shift to introduce
+	 * zeroes in the lower order bits without corrupting the record.
+	 *
+	 * Note that no change is required for ir_count, ir_freecount or
+	 * ir_free. The count values are not affected by alignment and ir_free
+	 * is initialized to 1s for all inodes, sparse or otherwise.
+	 */
+	allocmask = ~rec->ir_holemask;
+	allocmask <<= offset / XFS_INODES_PER_HOLEMASK_BIT;
+	rec->ir_holemask = ~allocmask;
+}
+
+/*
+ * Determine whether two sparse inode records can be merged. The inode ranges
+ * must match and there must be no allocation overlap between the records.
+ */
+STATIC bool
+__xfs_inobt_can_merge(
+	struct xfs_inobt_rec_incore	*trec,	/* tgt record */
+	struct xfs_inobt_rec_incore	*srec)	/* src record */
+{
+	DECLARE_BITMAP(talloc, 64);
+	DECLARE_BITMAP(salloc, 64);
+	DECLARE_BITMAP(tmp, 64);
+
+	/* records must cover the same inode range */
+	if (trec->ir_startino != srec->ir_startino)
+		return false;
+
+	/* both records must be sparse */
+	if (!xfs_inobt_issparse(trec->ir_holemask) ||
+	    !xfs_inobt_issparse(srec->ir_holemask))
+		return false;
+
+	/* can't exceed capacity of a full record */
+	if (trec->ir_count + srec->ir_count > XFS_INODES_PER_CHUNK)
+		return false;
+
+	/* verify there is no allocation overlap */
+	xfs_inobt_ialloc_bitmap(talloc, trec);
+	xfs_inobt_ialloc_bitmap(salloc, srec);
+
+	bitmap_and(tmp, salloc, talloc, 64);
+	if (!bitmap_empty(tmp, 64))
+		return false;
+
+	return true;
+}
+
+/*
+ * Merge two sparse inode records. The caller must call __xfs_inobt_can_merge()
+ * to ensure the merge is valid.
+ */
+STATIC void
+__xfs_inobt_rec_merge(
+	struct xfs_inobt_rec_incore	*trec,	/* target */
+	struct xfs_inobt_rec_incore	*srec)	/* src */
+{
+	ASSERT(trec->ir_startino == srec->ir_startino);
+
+	/* combine the counts */
+	trec->ir_count += srec->ir_count;
+	trec->ir_freecount += srec->ir_freecount;
+
+	/* merge the holemask */
+	trec->ir_holemask &= srec->ir_holemask;
+
+	/* merge the free mask */
+	trec->ir_free &= srec->ir_free;
+}
+
+/*
+ * Determine whether a newly allocated sparse inode chunk record overlaps with
+ * an existing sparse record in the inobt. When sparse inode chunks are enabled,
+ * all inode chunk alignment is increased from cluster size to physical inode
+ * chunk size. This means that the smallest, non-zero gap between two inode
+ * chunks is at least one full inode chunk. When a sparse inode chunk is
+ * allocated, the containing record is also aligned in this manner such that
+ * future sparse allocations within that same range all align to the same record
+ * startino. This alignment policy supports the ability to merge sparse chunks
+ * into complete chunks over time.
+ *
+ * Given an newly allocated/aligned sparse inode record, look up whether a
+ * sparse record already exists at this startino. If so, merge the two records
+ * and return the merged record in nrec.
+ *
+ * An error is returned if records overlap but a merge is not possible. Given
+ * the alignment constraints described above, this should never happen and thus
+ * is treated as fs corruption.
+ */
+STATIC int
+xfs_inobt_rec_merge(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	struct xfs_buf			*agbp,
+	xfs_btnum_t			btnum,
+	struct xfs_inobt_rec_incore	*nrec)	/* in/out: new/merged rec. */
+{
+	struct xfs_btree_cur		*cur;
+	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
+	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
+	int				error;
+	int				i;
+	struct xfs_inobt_rec_incore	rec;
+
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
+
+	/* the new record is pre-aligned so we know where to look */
+	error = xfs_inobt_lookup(cur, nrec->ir_startino, XFS_LOOKUP_EQ, &i);
+	if (error)
+		goto error;
+	/* if nothing there, we're done */
+	if (i == 0)
+		goto out;
+
+	error = xfs_inobt_get_rec(cur, &rec, &i);
+	if (error)
+		goto error;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
+	ASSERT(rec.ir_startino == nrec->ir_startino);
+
+	/*
+	 * This should never happen. If we have coexisting records that cannot
+	 * merge, something is seriously wrong.
+	 */
+	if (!__xfs_inobt_can_merge(nrec, &rec)) {
+		error = -EFSCORRUPTED;
+		goto error;
+	}
+
+	trace_xfs_irec_merge_pre(mp, agno, rec.ir_startino, rec.ir_holemask,
+				 nrec->ir_startino, nrec->ir_holemask);
+
+	__xfs_inobt_rec_merge(nrec, &rec);
+
+	trace_xfs_irec_merge_post(mp, agno, nrec->ir_startino,
+				  nrec->ir_holemask);
+
+out:
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+error:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/*
  * Allocate new inodes in the allocation group specified by agbp.
  * Return 0 for success, else error code.
  */
@@ -375,6 +647,9 @@ xfs_ialloc_ag_alloc(
 	xfs_agino_t	newlen;		/* new number of inodes */
 	int		isaligned = 0;	/* inode allocation at stripe unit */
 					/* boundary */
+	uint16_t	allocmask = (uint16_t) -1; /* init. to full chunk */
+	struct xfs_inobt_rec_incore rec;
+
 	struct xfs_perag *pag;
 
 	memset(&args, 0, sizeof(args));
@@ -490,6 +765,45 @@ xfs_ialloc_ag_alloc(
 			return error;
 	}
 
+	/*
+	 * Finally, try a sparse allocation if the filesystem supports it and
+	 * the sparse allocation length is smaller than a full chunk.
+	 */
+	if (xfs_sb_version_hassparseinodes(&args.mp->m_sb) &&
+	    args.mp->m_ialloc_min_blks < args.mp->m_ialloc_blks &&
+	    args.fsbno == NULLFSBLOCK) {
+		args.type = XFS_ALLOCTYPE_NEAR_BNO;
+		args.agbno = be32_to_cpu(agi->agi_root);
+		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
+		args.alignment = args.mp->m_sb.sb_spinoalignmt;
+		args.prod = 1;
+
+		args.minlen = args.mp->m_ialloc_min_blks;
+		args.maxlen = args.minlen;
+
+		/*
+		 * The inode record will be aligned to full chunk size. We must
+		 * prevent sparse allocation from AG boundaries that result in
+		 * invalid inode records, such as records that start at agbno 0
+		 * or extend beyond the AG.
+		 *
+		 * Set min agbno to the first aligned, non-zero agbno and max to
+		 * the last aligned agbno that is at least one full chunk from
+		 * the end of the AG.
+		 */
+		args.min_agbno = args.mp->m_sb.sb_inoalignmt;
+		args.max_agbno = round_down(args.mp->m_sb.sb_agblocks,
+					    args.mp->m_sb.sb_inoalignmt) -
+				 args.mp->m_ialloc_blks;
+
+		error = xfs_alloc_vextent(&args);
+		if (error)
+			return error;
+
+		newlen = args.len << args.mp->m_sb.sb_inopblog;
+		allocmask = (1 << (newlen / XFS_INODES_PER_HOLEMASK_BIT)) - 1;
+	}
+
 	if (args.fsbno == NULLFSBLOCK) {
 		*alloc = 0;
 		return 0;
@@ -514,6 +828,65 @@ xfs_ialloc_ag_alloc(
 	 * Convert the results.
 	 */
 	newino = XFS_OFFBNO_TO_AGINO(args.mp, args.agbno, 0);
+
+	if (xfs_inobt_issparse(~allocmask)) {
+		/*
+		 * We've allocated a sparse chunk...
+		 */
+		rec.ir_startino = newino;
+		rec.ir_holemask = ~allocmask;
+		rec.ir_count = newlen;
+		rec.ir_freecount = newlen;
+		rec.ir_free = XFS_INOBT_ALL_FREE;
+
+		/* align record and update newino for agi_newino */
+		xfs_align_sparse_rec(args.mp, &rec);
+		newino = rec.ir_startino;
+
+		error = xfs_inobt_rec_merge(args.mp, tp, agbp, XFS_BTNUM_INO,
+					    &rec);
+		if (!error)
+			error = xfs_inobt_rec_check_count(args.mp, &rec);
+		if (error == -EFSCORRUPTED) {
+			xfs_alert(args.mp,
+	"invalid sparse inode record: ino 0x%llx holemask 0x%x count %u",
+				  XFS_AGINO_TO_INO(args.mp, agno,
+						   rec.ir_startino),
+				  rec.ir_holemask, rec.ir_count);
+			xfs_force_shutdown(args.mp, SHUTDOWN_CORRUPT_INCORE);
+		}
+		if (error)
+			return error;
+
+		error = xfs_inobt_update_insert(args.mp, tp, agbp, &rec,
+						XFS_BTNUM_INO);
+		if (error)
+			return error;
+
+		if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
+			error = xfs_inobt_update_insert(args.mp, tp, agbp, &rec,
+							XFS_BTNUM_FINO);
+			if (error)
+				return error;
+		}
+	} else {
+		/* full chunk - insert new records to both btrees */
+		error = xfs_inobt_insert(args.mp, tp, agbp, newino, newlen,
+					 XFS_BTNUM_INO);
+		if (error)
+			return error;
+
+		if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
+			error = xfs_inobt_insert(args.mp, tp, agbp, newino,
+						 newlen, XFS_BTNUM_FINO);
+			if (error)
+				return error;
+		}
+	}
+
+	/*
+	 * Update AGI counts and newino.
+	 */
 	be32_add_cpu(&agi->agi_count, newlen);
 	be32_add_cpu(&agi->agi_freecount, newlen);
 	pag = xfs_perag_get(args.mp, agno);
@@ -522,20 +895,6 @@ xfs_ialloc_ag_alloc(
 	agi->agi_newino = cpu_to_be32(newino);
 
 	/*
-	 * Insert records describing the new inode chunk into the btrees.
-	 */
-	error = xfs_inobt_insert(args.mp, tp, agbp, newino, newlen,
-				 XFS_BTNUM_INO);
-	if (error)
-		return error;
-
-	if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
-		error = xfs_inobt_insert(args.mp, tp, agbp, newino, newlen,
-					 XFS_BTNUM_FINO);
-		if (error)
-			return error;
-	}
-	/*
 	 * Log allocation group header fields
 	 */
 	xfs_ialloc_log_agi(tp, agbp,
@@ -1672,7 +2031,9 @@ xfs_difree_finobt(
 		 */
 		XFS_WANT_CORRUPTED_GOTO(ibtrec->ir_freecount == 1, error);
 
-		error = xfs_inobt_insert_rec(cur, ibtrec->ir_freecount,
+		error = xfs_inobt_insert_rec(cur, ibtrec->ir_holemask,
+					     ibtrec->ir_count,
+					     ibtrec->ir_freecount,
 					     ibtrec->ir_free, &i);
 		if (error)
 			goto error;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 51372e3..12a4bf4 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -734,6 +734,53 @@ TRACE_EVENT(xfs_iomap_prealloc_size,
 		  __entry->blocks, __entry->shift, __entry->writeio_blocks)
 )
 
+TRACE_EVENT(xfs_irec_merge_pre,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agino_t agino,
+		 uint16_t holemask, xfs_agino_t nagino, uint16_t nholemask),
+	TP_ARGS(mp, agno, agino, holemask, nagino, nholemask),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+		__field(uint16_t, holemask)
+		__field(xfs_agino_t, nagino)
+		__field(uint16_t, nholemask)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agino = agino;
+		__entry->holemask = holemask;
+		__entry->nagino = nagino;
+		__entry->nholemask = holemask;
+	),
+	TP_printk("dev %d:%d agno %d inobt (%u:0x%x) new (%u:0x%x)",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
+		  __entry->agino, __entry->holemask, __entry->nagino,
+		  __entry->nholemask)
+)
+
+TRACE_EVENT(xfs_irec_merge_post,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agino_t agino,
+		 uint16_t holemask),
+	TP_ARGS(mp, agno, agino, holemask),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, agino)
+		__field(uint16_t, holemask)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agino = agino;
+		__entry->holemask = holemask;
+	),
+	TP_printk("dev %d:%d agno %d inobt (%u:0x%x)", MAJOR(__entry->dev),
+		  MINOR(__entry->dev), __entry->agno, __entry->agino,
+		  __entry->holemask)
+)
+
 #define DEFINE_IREF_EVENT(name) \
 DEFINE_EVENT(xfs_iref_class, name, \
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip), \
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
