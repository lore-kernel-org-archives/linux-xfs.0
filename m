Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BF3057F58
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 10:12:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6B957AC005
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 08:12:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YByH2yuhYQxoCK8f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 08:12:29 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sA3GCSlj003972
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:12:29 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sA3GCSfY017059
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:12:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 09/17] xfs: allocate sparse inode chunks on full chunk
	allocation failure
Date: Mon,  3 Nov 2014 11:12:18 -0500
Message-Id: <1415031146-9107-10-git-send-email-bfoster@redhat.com>
In-Reply-To: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
References: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
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
 fs/xfs/libxfs/xfs_ialloc.c | 149 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 136 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 6879213..d22dd8a 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -123,12 +123,16 @@ xfs_inobt_get_rec(
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
@@ -152,6 +156,19 @@ xfs_inobt_insert(
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
 
@@ -165,7 +182,7 @@ xfs_inobt_insert(
 		}
 		ASSERT(i == 0);
 
-		error = xfs_inobt_insert_rec(cur, XFS_INODES_PER_CHUNK,
+		error = xfs_inobt_insert_rec(cur, 0, count, XFS_INODES_PER_CHUNK,
 					     XFS_INOBT_ALL_FREE, &i);
 		if (error) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
@@ -175,8 +192,45 @@ xfs_inobt_insert(
 	}
 
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+}
+
+STATIC int
+xfs_inobt_update_insert(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	struct xfs_buf			*agbp,
+	struct xfs_inobt_rec_incore	*rec,   /* record to update/insert */
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
+	if (i == 1) {
+		error = xfs_inobt_update(cur, rec);
+		if (error)
+			goto error;
+	} else {
+		error = xfs_inobt_insert_rec(cur, rec->ir_holemask,
+				rec->ir_count, rec->ir_freecount, rec->ir_free,
+				&i);
+		if (error)
+			goto error;
+		ASSERT(i == 1);
+	}
 
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	return 0;
+
+error:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
 }
 
 /*
@@ -437,6 +491,10 @@ xfs_ialloc_ag_alloc(
 	xfs_agino_t	newlen;		/* new number of inodes */
 	int		isaligned = 0;	/* inode allocation at stripe unit */
 					/* boundary */
+	uint16_t	allocmask = (uint16_t) -1; /* init. to full chunk */
+	struct xfs_inobt_rec_incore rec;
+	int		offset;
+
 	struct xfs_perag *pag;
 
 	memset(&args, 0, sizeof(args));
@@ -552,6 +610,27 @@ xfs_ialloc_ag_alloc(
 			return error;
 	}
 
+	/*
+	 * Finally, try a sparse allocation if the filesystem supports it.
+	 */
+	if (xfs_sb_version_hassparseinodes(&args.mp->m_sb) &&
+	    args.fsbno == NULLFSBLOCK) {
+		args.type = XFS_ALLOCTYPE_NEAR_BNO;
+		args.agbno = be32_to_cpu(agi->agi_root);
+		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
+		args.alignment = args.mp->m_sb.sb_inoalignmt;
+
+		args.minlen = args.mp->m_ialloc_min_blks;
+		args.maxlen = args.minlen;
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
@@ -583,20 +662,62 @@ xfs_ialloc_ag_alloc(
 	xfs_perag_put(pag);
 	agi->agi_newino = cpu_to_be32(newino);
 
-	/*
-	 * Insert records describing the new inode chunk into the btrees.
-	 */
-	error = xfs_inobt_insert(args.mp, tp, agbp, newino, newlen,
-				 XFS_BTNUM_INO);
-	if (error)
-		return error;
+	if (xfs_inobt_issparse(~allocmask)) {
+		/*
+		 * We've allocated a sparse chunk...
+		 */
+		error = xfs_inobt_rec_exists(args.mp, tp, agbp, newino,
+					     newlen, XFS_BTNUM_INO, &rec);
+		if (error)
+			return error;
+		if (rec.ir_startino == NULLAGINO) {
+			/* no existing record, set all fields */
+			rec.ir_startino = newino;
+			rec.ir_holemask = ~allocmask;
+			rec.ir_count = newlen;
+			rec.ir_freecount = newlen;
+			rec.ir_free = XFS_INOBT_ALL_FREE;
+		} else {
+			/* we already have a record, update it */
+			offset = newino - rec.ir_startino;
+			allocmask <<= offset / XFS_INODES_PER_HOLEMASK_BIT;
+
+			ASSERT(offset % XFS_INODES_PER_HOLEMASK_BIT == 0);
+			ASSERT(rec.ir_count + newlen <= XFS_INODES_PER_CHUNK);
+			ASSERT(rec.ir_freecount + newlen <=
+				XFS_INODES_PER_CHUNK);
+
+			rec.ir_count += newlen;
+			rec.ir_freecount += newlen;
+			rec.ir_holemask &= ~allocmask;
+		}
 
-	if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
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
 		error = xfs_inobt_insert(args.mp, tp, agbp, newino, newlen,
-					 XFS_BTNUM_FINO);
+					 XFS_BTNUM_INO);
 		if (error)
 			return error;
+
+		if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
+			error = xfs_inobt_insert(args.mp, tp, agbp, newino,
+						 newlen, XFS_BTNUM_FINO);
+			if (error)
+				return error;
+		}
 	}
+
 	/*
 	 * Log allocation group header fields
 	 */
@@ -1657,7 +1778,9 @@ xfs_difree_finobt(
 		 */
 		XFS_WANT_CORRUPTED_GOTO(ibtrec->ir_freecount == 1, error);
 
-		error = xfs_inobt_insert_rec(cur, ibtrec->ir_freecount,
+		error = xfs_inobt_insert_rec(cur, ibtrec->ir_holemask,
+					     ibtrec->ir_count,
+					     ibtrec->ir_freecount,
 					     ibtrec->ir_free, &i);
 		if (error)
 			goto error;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
