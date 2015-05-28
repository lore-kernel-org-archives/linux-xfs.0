Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C4C047F56
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 15:17:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52440AC002
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 13:17:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xOcfHTUPLwdQPpD8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 13:16:59 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 7AD9819CB9B
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 20:16:58 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t4SKGwUt005183
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 16:16:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/3] xfs: remove entire inode chunks when all inodes are free
Date: Thu, 28 May 2015 16:16:55 -0400
Message-Id: <1432844216-5820-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1432844216-5820-1-git-send-email-bfoster@redhat.com>
References: <1432844216-5820-1-git-send-email-bfoster@redhat.com>
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

Inode chunks are typically removed when the last allocated inode tracked
by the inobt record is freed. However, this only occurs under
circumstances where a chunk is tracked by a single inobt record because
only the context for the single record is available at the time an inode
is freed.

Add infrastructure to detect whether the overall chunk that happens to
own a particular inobt record is free. The xfs_inobt_ischunkfree()
helper first considers the more likely single-record-per-chunk case to
avoid unnecessary overhead. Otherwise, it uses the xfs_inobt_peek() low
level helper to tally the total real and free inode count over a set of
records that map to a chunk. If the entire chunk is free, the starting
agino of the chunk is returned.

We can remove multiple inobt records of a chunk now that chunk free
state is available. Update the xfs_inobt_delete() callers to free an
entire chunk at a time based on the variable inode allocation count in
the mount structure. Note that this is safe from a transaction
standpoint due to the same reasoning that multiple inode record
insertion is safe from xfs_inobt_insert(). Specifically, the transaction
reservation covers enough for a single bottom-to-top tree split or
merge. We can safely insert or remove ~50% of an inobt leaf block's
worth of records under this reservation and the maximum possible ratio
of inode records to inode chunks is 4:1 (i.e., maximum 64k block size
with minimum 256b inode size).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 206 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 187 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 745d965..f4d3e23 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -39,6 +39,9 @@
 #include "xfs_icache.h"
 #include "xfs_trace.h"
 
+STATIC int
+xfs_ialloc_next_rec(struct xfs_btree_cur *, struct xfs_inobt_rec_incore *,
+		    int *, int);
 
 /*
  * Allocation group level functions.
@@ -246,6 +249,155 @@ out_error:
 }
 
 /*
+ * Peek forward in the provided inobt cursor and sum up the real and free inode
+ * counts. The returned count covers the range of [agino,agino+len). Absent
+ * records do not affect the count.
+ */
+static int
+xfs_inobt_peek(
+	struct xfs_mount		*mp,
+	struct xfs_btree_cur		*cur,
+	xfs_agino_t			agino,		/* start agino */
+	int				ilen,		/* range length */
+	int				*count,		/* out: inode count */
+	int				*freecount)	/* out: free count */
+{
+	struct xfs_inobt_rec_incore	rec;
+	xfs_agino_t			agino_end;
+	int				error;
+	int				i;
+
+	ASSERT(ilen % XFS_INODES_PER_CHUNK == 0);
+	agino_end = agino + ilen;
+	*count = *freecount = 0;
+
+	/*
+	 * Look up the first at or beyond the start of the range. Note that
+	 * records for legitimate inode chunks might not exist if we're looking
+	 * at the finobt.
+	 */
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE, &i);
+	if (error)
+		goto out_error;
+	if (i == 0)
+		return 0;
+
+	error = xfs_inobt_get_rec(cur, &rec, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+
+	/*
+	 * Sum the real and free inode counts across all records in the range.
+	 */
+	while (rec.ir_startino < agino_end) {
+		*count += rec.ir_count;
+		*freecount += rec.ir_freecount;
+
+		error = xfs_ialloc_next_rec(cur, &rec, &i, 0);
+		if (error)
+			goto out_error;
+		if (i)	/* done */
+			break;
+	}
+
+	return 0;
+
+out_error:
+	return error;
+}
+
+/*
+ * Determine whether an inode chunk covered by a particular inobt record is
+ * free. This handles large block size cases where the inode chunk requires
+ * multiple inobt records by mapping from the inode offset of the first inode in
+ * the provided record to the record with inode offset 0 in the chunk. From
+ * there we determine whether each record in the chunk is completely free.
+ *
+ * An in-core record of the chunk to check is passed in rec. Any record that
+ * covers a portion of the chunk is suitable. The in-core record must be
+ * modified in advance if an inode is being freed. The expected free inode count
+ * for a free chunk is passed in icount. This is generally mp->m_ialloc_inos,
+ * but the caller must account for when an inode to be freed is not yet
+ * reflected as such in the inobt.
+ *
+ * If the chunk is free, the starting agino of the chunk is returned in
+ * freeagino. Otherwise, freeagino is set to NULLAGINO.
+ */
+static int
+xfs_inobt_ischunkfree(
+	struct xfs_mount		*mp,
+	struct xfs_btree_cur		*ocur,
+	struct xfs_inobt_rec_incore	*rec,
+	int				icount,/* icount for free chunk */
+	xfs_agino_t			*freeagino)/* out: first free agino */
+{
+	struct xfs_btree_cur		*cur;
+	xfs_agino_t			agino;
+	xfs_agblock_t			agbno;
+	int				count;
+	int				freecount;
+	int				error;
+
+	ASSERT(icount <= mp->m_ialloc_inos);
+
+	*freeagino = NULLAGINO;
+
+	/* if the record isn't free, the chunk certainly isn't */
+	if (rec->ir_free != XFS_INOBT_ALL_FREE)
+		return 0;
+
+	/*
+	 * The record is free so if the chunk corresponds to a single record, it
+	 * is free as well.
+	 */
+	if (mp->m_ialloc_inos == XFS_INODES_PER_CHUNK) {
+		ASSERT(rec->ir_free == XFS_INOBT_ALL_FREE);
+		*freeagino = rec->ir_startino;
+		return 0;
+	}
+
+	/*
+	 * A chunk corresponds to multiple inobt records. This typically occurs
+	 * for large block sizes where a single block of inodes requires
+	 * multiple records.
+	 *
+	 * Get the record that is aligned to the start of the block and verify
+	 * whether all inodes across the chunk are free. Dup the cursor so we
+	 * don't affect the caller's inobt update operation in progress and sum
+	 * the free inodes across the chunk.
+	 */
+	ASSERT(mp->m_ialloc_inos > XFS_INODES_PER_CHUNK);
+	error = xfs_btree_dup_cursor(ocur, &cur);
+	if (error)
+		return error;
+
+	/* get the agblock and the inode at offset 0 */
+	agbno = XFS_AGINO_TO_AGBNO(mp, rec->ir_startino);
+	agino = XFS_OFFBNO_TO_AGINO(mp, agbno, 0);
+
+	error = xfs_inobt_peek(mp, cur, agino, mp->m_ialloc_inos, &count,
+			       &freecount);
+	if (error)
+		goto out_cur;
+
+	/*
+	 * Check the free inode count against the count that indicates a free
+	 * chunk. Sparse records are irrelevant in this context since this is a
+	 * single block allocation.
+	 */
+	if (freecount == icount)
+		*freeagino = agino;
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+
+out_cur:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/*
  * Verify that the number of free inodes in the AGI is correct.
  */
 #ifdef DEBUG
@@ -1944,6 +2096,7 @@ xfs_difree_inobt(
 	int				error;
 	int				i;
 	int				off;
+	xfs_agino_t			freeagino;
 
 	ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
 	ASSERT(XFS_AGINO_TO_AGBNO(mp, agino) < be32_to_cpu(agi->agi_length));
@@ -1986,23 +2139,38 @@ xfs_difree_inobt(
 	rec.ir_freecount++;
 
 	/*
-	 * When an inode chunk is free, it becomes eligible for removal. Don't
-	 * remove the chunk if the block size is large enough for multiple inode
-	 * chunks (that might not be free).
+	 * An inode chunk becomes eligible for removal when it is free. Check
+	 * whether this chunk is free while taking into consideration that the
+	 * chunk might consist of multiple records.
+	 *
+	 * Note that the free chunk inode count parameter must account for the
+	 * fact that this inode has not yet been freed in the inobt's...
 	 */
-	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
-	    rec.ir_free == XFS_INOBT_ALL_FREE &&
-	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
+	error = xfs_inobt_ischunkfree(mp, cur, &rec, mp->m_ialloc_inos - 1,
+				      &freeagino);
+	if (error)
+		goto error0;
+
+	if (!(mp->m_flags & XFS_MOUNT_IKEEP) && freeagino != NULLAGINO) {
 		xic->deleted = 1;
-		xic->first_ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
+		xic->first_ino = XFS_AGINO_TO_INO(mp, agno, freeagino);
 		xic->alloc = xfs_inobt_irec_to_allocmask(&rec);
 
 		/*
+		 * Use the freecount if the record is sparse. Otherwise use the
+		 * chunk inode allocation count as the chunk could be larger
+		 * than a single record.
+		 */
+		if (xfs_inobt_issparse(rec.ir_holemask))
+			ilen = rec.ir_freecount;
+		else
+			ilen = mp->m_ialloc_inos;
+
+		/*
 		 * Remove the inode cluster from the AGI B+Tree, adjust the
 		 * AGI and Superblock inode counts, and mark the disk space
 		 * to be freed when the transaction is committed.
 		 */
-		ilen = rec.ir_freecount;
 		be32_add_cpu(&agi->agi_count, -ilen);
 		be32_add_cpu(&agi->agi_freecount, -(ilen - 1));
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
@@ -2012,8 +2180,8 @@ xfs_difree_inobt(
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, -ilen);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));
 
-		error = xfs_inobt_delete(mp, cur, agno, rec.ir_startino,
-					 XFS_INODES_PER_CHUNK);
+		error = xfs_inobt_delete(mp, cur, agno, freeagino,
+					 mp->m_ialloc_inos);
 		if (error) {
 			xfs_warn(mp, "%s: xfs_inobt_delete returned error %d.",
 				__func__, error);
@@ -2073,6 +2241,7 @@ xfs_difree_finobt(
 	int				offset = agino - ibtrec->ir_startino;
 	int				error;
 	int				i;
+	xfs_agino_t			freeagino;
 
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_FINO);
 
@@ -2124,16 +2293,15 @@ xfs_difree_finobt(
 	 * free inode. Hence, if all of the inodes are free and we aren't
 	 * keeping inode chunks permanently on disk, remove the record.
 	 * Otherwise, update the record with the new information.
-	 *
-	 * Note that we currently can't free chunks when the block size is large
-	 * enough for multiple chunks. Leave the finobt record to remain in sync
-	 * with the inobt.
 	 */
-	if (rec.ir_free == XFS_INOBT_ALL_FREE &&
-	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK &&
-	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
-		error = xfs_inobt_delete(mp, cur, agno, rec.ir_startino,
-					 XFS_INODES_PER_CHUNK);
+	error = xfs_inobt_ischunkfree(mp, cur, &rec, mp->m_ialloc_inos - 1,
+				      &freeagino);
+	if (error)
+		goto error;
+
+	if (!(mp->m_flags & XFS_MOUNT_IKEEP) && freeagino != NULLAGINO) {
+		error = xfs_inobt_delete(mp, cur, agno, freeagino,
+					 mp->m_ialloc_inos);
 		if (error)
 			goto error;
 		ASSERT(i == 1);
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
