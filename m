Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 651757F61
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 12:17:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 26ED1304067
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 10:17:31 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id t88FOzufMDvBupJU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2015 10:17:29 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1CIHTfP020188
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 13:17:29 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1CIHSpc030673
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 13:17:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 13/18] xfs: allocate sparse inode chunks on full chunk
	allocation failure
Date: Thu, 12 Feb 2015 13:17:20 -0500
Message-Id: <1423765045-15791-14-git-send-email-bfoster@redhat.com>
In-Reply-To: <1423765045-15791-1-git-send-email-bfoster@redhat.com>
References: <1423765045-15791-1-git-send-email-bfoster@redhat.com>
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
chunk. If all else fails, reduce the allocation to the sparse length and
alignment and attempt to allocate a sparse inode chunk.

If sparse chunk allocation succeeds, check whether an inobt record
already exists that can track the chunk. If so, inherit and update the
existing record. Otherwise, insert a new record for the sparse chunk.

Create helpers to align sparse chunk inode records and insert or update
existing records in the inode btrees. The xfs_inobt_insert_sprec()
helper implements the merge or update semantics required for sparse
inode records with respect to both the inobt and finobt. To update the
inobt, either insert a new record or merge with an existing record. To
update the finobt, use the updated inobt record to either insert or
replace an existing record.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c       | 332 +++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_ialloc_btree.c |  21 +++
 fs/xfs/libxfs/xfs_ialloc_btree.h |   7 +
 fs/xfs/xfs_trace.h               |  47 ++++++
 4 files changed, 393 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 7c002f2..1c81f08 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -378,6 +378,216 @@ xfs_ialloc_inode_init(
 }
 
 /*
+ * Align startino and allocmask for a recently allocated sparse chunk such that
+ * they are fit for insertion (or merge) into the on-disk inode btrees.
+ *
+ * Background:
+ *
+ * When enabled, sparse inode support increases the inode alignment from cluster
+ * size to inode chunk size. This means that the minimum range between two
+ * non-adjacent inode records in the inobt is large enough for a full inode
+ * record. This allows for cluster sized, cluster aligned block allocation
+ * without need to worry about whether the resulting inode record overlaps with
+ * another record in the tree. Without this basic rule, we would have to deal
+ * with the consequences of overlap by potentially undoing recent allocations in
+ * the inode allocation codepath.
+ *
+ * Because of this alignment rule (which is enforced on mount), there are two
+ * inobt possibilities for newly allocated sparse chunks. One is that the
+ * aligned inode record for the chunk covers a range of inodes not already
+ * covered in the inobt (i.e., it is safe to insert a new sparse record). The
+ * other is that a record already exists at the aligned startino that considers
+ * the newly allocated range as sparse. In the latter case, record content is
+ * merged in hope that sparse inode chunks fill to full chunks over time.
+ */
+STATIC void
+xfs_align_sparse_ino(
+	struct xfs_mount		*mp,
+	xfs_agino_t			*startino,
+	uint16_t			*allocmask)
+{
+	xfs_agblock_t			agbno;
+	xfs_agblock_t			mod;
+	int				offset;
+
+	agbno = XFS_AGINO_TO_AGBNO(mp, *startino);
+	mod = agbno % mp->m_sb.sb_inoalignmt;
+	if (!mod)
+		return;
+
+	/* calculate the inode offset and align startino */
+	offset = mod << mp->m_sb.sb_inopblog;
+	*startino -= offset;
+
+	/*
+	 * Since startino has been aligned down, left shift allocmask such that
+	 * it continues to represent the same physical inodes relative to the
+	 * new startino.
+	 */
+	*allocmask <<= offset / XFS_INODES_PER_HOLEMASK_BIT;
+}
+
+/*
+ * Determine whether the source inode record can merge into the target. Both
+ * records must be sparse, the inode ranges must match and there must be no
+ * allocation overlap between the records.
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
+	/* both records must track some inodes */
+	if (!trec->ir_count || !srec->ir_count)
+		return false;
+
+	/* can't exceed capacity of a full record */
+	if (trec->ir_count + srec->ir_count > XFS_INODES_PER_CHUNK)
+		return false;
+
+	/* verify there is no allocation overlap */
+	xfs_inobt_irec_to_allocmap(talloc, trec);
+	xfs_inobt_irec_to_allocmap(salloc, srec);
+
+	bitmap_and(tmp, salloc, talloc, 64);
+	if (!bitmap_empty(tmp, 64))
+		return false;
+
+	return true;
+}
+
+/*
+ * Merge the source inode record into the target. The caller must call
+ * __xfs_inobt_can_merge() to ensure the merge is valid.
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
+	/*
+	 * Merge the holemask and free mask. For both fields, 0 bits refer to
+	 * allocated inodes. We combine the allocated ranges with bitwise AND.
+	 */
+	trec->ir_holemask &= srec->ir_holemask;
+	trec->ir_free &= srec->ir_free;
+}
+
+/*
+ * Insert a new sparse inode chunk into the associated inode btree. The inode
+ * record for the sparse chunk is pre-aligned to a startino that should match
+ * any pre-existing sparse inode record in the tree. This allows sparse chunks
+ * to fill over time.
+ *
+ * This function supports two modes of handling preexisting records depending on
+ * the merge flag. If merge is true, the provided record is merged with the
+ * existing record and updated in place. The merged record is returned in nrec.
+ * If merge is false, an existing record is replaced with the provided record.
+ * If no preexisting record exists, the provided record is always inserted.
+ *
+ * It is considered corruption if a merge is requested and not possible. Given
+ * the sparse inode alignment constraints, this should never happen.
+ */
+STATIC int
+xfs_inobt_insert_sprec(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	struct xfs_buf			*agbp,
+	int				btnum,
+	struct xfs_inobt_rec_incore	*nrec,	/* in/out: new/merged rec. */
+	bool				merge)	/* merge or replace */
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
+	/* if nothing there, insert a new record and return */
+	if (i == 0) {
+		error = xfs_inobt_insert_rec(cur, nrec->ir_holemask,
+					     nrec->ir_count, nrec->ir_freecount,
+					     nrec->ir_free, &i);
+		if (error)
+			goto error;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error);
+
+		goto out;
+	}
+
+	/*
+	 * A record exists at this startino. Merge or replace the record
+	 * depending on what we've been asked to do.
+	 */
+	if (merge) {
+		error = xfs_inobt_get_rec(cur, &rec, &i);
+		if (error)
+			goto error;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error);
+		XFS_WANT_CORRUPTED_GOTO(rec.ir_startino == nrec->ir_startino,
+					error);
+
+		/*
+		 * This should never fail. If we have coexisting records that
+		 * cannot merge, something is seriously wrong.
+		 */
+		XFS_WANT_CORRUPTED_GOTO(__xfs_inobt_can_merge(nrec, &rec),
+					error);
+
+		trace_xfs_irec_merge_pre(mp, agno, rec.ir_startino,
+					 rec.ir_holemask, nrec->ir_startino,
+					 nrec->ir_holemask);
+
+		/* merge to nrec to output the updated record */
+		__xfs_inobt_rec_merge(nrec, &rec);
+
+		trace_xfs_irec_merge_post(mp, agno, nrec->ir_startino,
+					  nrec->ir_holemask);
+
+		error = xfs_inobt_rec_check_count(mp, nrec);
+		if (error)
+			goto error;
+	}
+
+	error = xfs_inobt_update(cur, nrec);
+	if (error)
+		goto error;
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
@@ -395,6 +605,8 @@ xfs_ialloc_ag_alloc(
 	xfs_agino_t	newlen;		/* new number of inodes */
 	int		isaligned = 0;	/* inode allocation at stripe unit */
 					/* boundary */
+	uint16_t	allocmask = (uint16_t) -1; /* init. to full chunk */
+	struct xfs_inobt_rec_incore rec;
 	struct xfs_perag *pag;
 
 	memset(&args, 0, sizeof(args));
@@ -510,6 +722,45 @@ xfs_ialloc_ag_alloc(
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
+		args.alignment = args.mp->m_sb.sb_spino_align;
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
@@ -534,6 +785,73 @@ xfs_ialloc_ag_alloc(
 	 * Convert the results.
 	 */
 	newino = XFS_OFFBNO_TO_AGINO(args.mp, args.agbno, 0);
+
+	if (xfs_inobt_issparse(~allocmask)) {
+		/*
+		 * We've allocated a sparse chunk. Align the startino and mask.
+		 */
+		xfs_align_sparse_ino(args.mp, &newino, &allocmask);
+
+		rec.ir_startino = newino;
+		rec.ir_holemask = ~allocmask;
+		rec.ir_count = newlen;
+		rec.ir_freecount = newlen;
+		rec.ir_free = XFS_INOBT_ALL_FREE;
+
+		/*
+		 * Insert the sparse record into the inobt and allow for a merge
+		 * if necessary. If a merge does occur, rec is updated to the
+		 * merged record.
+		 */
+		error = xfs_inobt_insert_sprec(args.mp, tp, agbp, XFS_BTNUM_INO,
+					       &rec, true);
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
+		/*
+		 * We can't merge the part we've just allocated as for the inobt
+		 * due to finobt semantics. The original record may or may not
+		 * exist independent of whether physical inodes exist in this
+		 * sparse chunk.
+		 *
+		 * We must update the finobt record based on the inobt record.
+		 * rec contains the fully merged and up to date inobt record
+		 * from the previous call. Set merge false to replace any
+		 * existing record with this one.
+		 */
+		if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
+			error = xfs_inobt_insert_sprec(args.mp, tp, agbp,
+						       XFS_BTNUM_FINO, &rec,
+						       false);
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
@@ -542,20 +860,6 @@ xfs_ialloc_ag_alloc(
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
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 6ee8697..aaa78c7 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -518,3 +518,24 @@ xfs_inobt_irec_to_allocmask(
 	xfs_inobt_irec_to_allocmap(allocmap, irec);
 	return bitmap_to_u64(allocmap, 64);
 }
+
+#if defined(DEBUG) || defined(XFS_WARN)
+/*
+ * Verify that an in-core inode record has a valid inode count.
+ */
+int
+xfs_inobt_rec_check_count(
+	struct xfs_mount		*mp,
+	struct xfs_inobt_rec_incore	*rec)
+{
+	int	inocount;
+	DECLARE_BITMAP(allocbmap, XFS_INODES_PER_CHUNK);
+
+	xfs_inobt_irec_to_allocmap(allocbmap, rec);
+	inocount = bitmap_weight(allocbmap, XFS_INODES_PER_CHUNK);
+	if (inocount != rec->ir_count)
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+#endif	/* DEBUG */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index cc20850..686c9de 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -69,4 +69,11 @@ uint64_t bitmap_to_u64(const unsigned long *, int);
 void xfs_inobt_irec_to_allocmap(unsigned long *, struct xfs_inobt_rec_incore *);
 u64 xfs_inobt_irec_to_allocmask(struct xfs_inobt_rec_incore *);
 
+#if defined(DEBUG) || defined(XFS_WARN)
+int xfs_inobt_rec_check_count(struct xfs_mount *,
+			      struct xfs_inobt_rec_incore *);
+#else
+#define xfs_inobt_rec_check_count(mp, rec)	0
+#endif	/* DEBUG */
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */
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
