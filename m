Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9594B7F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 09:54:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 16F0FAC009
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 07:54:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Bj72mqtzCuHSCi2f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 07:54:12 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OEsBwa007147
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:54:12 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OENA7C029060
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 09/18] xfs: allocate sparse inode chunks on full chunk
	allocation failure
Date: Thu, 24 Jul 2014 10:22:59 -0400
Message-Id: <1406211788-63206-10-git-send-email-bfoster@redhat.com>
In-Reply-To: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
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
chunk. If all else fails, reduce the allocation to inode cluster size
and attempt to allocate a sparse inode chunk.

If sparse chunk allocation succeeds, check whether an inobt record
already exists that can track the chunk. If so, inherit and update the
existing record. Otherwise, insert a new record for the sparse chunk.

Update xfs_inobt_insert_rec() to take the holemask as a parameter and
set the associated field on disk. Convert xfs_inobt_insert() to
xfs_inobt_update_insert() to handle record insertion or update in a
generic fashion. This facilitates the continued use of the same function
for the inobt and finobt.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 105 +++++++++++++++++++++++++++++++++------------
 1 file changed, 77 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index be57b51..4226b1b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -121,28 +121,28 @@ xfs_inobt_get_rec(
 STATIC int
 xfs_inobt_insert_rec(
 	struct xfs_btree_cur	*cur,
+	__uint16_t		holemask,
 	__int32_t		freecount,
 	xfs_inofree_t		free,
 	int			*stat)
 {
-	cur->bc_rec.i.ir_holemask = 0;
+	cur->bc_rec.i.ir_holemask = holemask;
 	cur->bc_rec.i.ir_freecount = freecount;
 	cur->bc_rec.i.ir_free = free;
 	return xfs_btree_insert(cur, stat);
 }
 
 /*
- * Insert records describing a newly allocated inode chunk into the inobt.
+ * Update or insert records describing a newly allocated inode chunk into the
+ * specified inobt.
  */
 STATIC int
-xfs_inobt_insert(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	xfs_agino_t		newino,	/* start inode of record */
-	xfs_agino_t		count,	/* inode count */
-	xfs_inofree_t		free,	/* free mask */
-	xfs_btnum_t		btnum)
+xfs_inobt_update_insert(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	struct xfs_buf			*agbp,
+	struct xfs_inobt_rec_incore	*rec,	/* record to update/insert */
+	xfs_btnum_t			btnum)
 {
 	struct xfs_btree_cur	*cur;
 	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
@@ -152,23 +152,25 @@ xfs_inobt_insert(
 
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
 
-	error = xfs_inobt_lookup(cur, newino, XFS_LOOKUP_EQ, &i);
-	if (error) {
-		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-		return error;
-	}
-	ASSERT(i == 0);
-
-	error = xfs_inobt_insert_rec(cur, count, free, &i);
-	if (error) {
-		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-		return error;
+	error = xfs_inobt_lookup(cur, rec->ir_startino, XFS_LOOKUP_EQ, &i);
+	if (i == 1) {
+		error = xfs_inobt_update(cur, rec);
+		if (error)
+			goto error;
+	} else {
+		error = xfs_inobt_insert_rec(cur, rec->ir_holemask,
+				rec->ir_freecount, rec->ir_free, &i);
+		if (error)
+			goto error;
+		ASSERT(i == 1);
 	}
-	ASSERT(i == 1);
 
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
-
 	return 0;
+
+error:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
 }
 
 /*
@@ -423,6 +425,10 @@ xfs_ialloc_ag_alloc(
 	xfs_agino_t	newlen;		/* new number of inodes */
 	int		isaligned = 0;	/* inode allocation at stripe unit */
 					/* boundary */
+	uint16_t	allocmask = (uint16_t) -1; /* init. to full chunk */
+	struct xfs_inobt_rec_incore rec;
+	int		offset;
+
 	struct xfs_perag *pag;
 
 	memset(&args, 0, sizeof(args));
@@ -538,6 +544,28 @@ xfs_ialloc_ag_alloc(
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
+		args.alignment = xfs_ialloc_cluster_alignment(args.mp);
+
+		/* allocate sparse regions in cluster granularity */
+		args.minlen = xfs_ialloc_cluster_alignment(args.mp);
+		args.maxlen = args.minlen;
+
+		error = xfs_alloc_vextent(&args);
+		if (error)
+			return error;
+
+		newlen = args.len << args.mp->m_sb.sb_inopblog;
+		allocmask = (1 << (newlen / XFS_INODES_PER_SPCHUNK)) - 1;
+	}
+
 	if (args.fsbno == NULLFSBLOCK) {
 		*alloc = 0;
 		return 0;
@@ -572,14 +600,34 @@ xfs_ialloc_ag_alloc(
 	/*
 	 * Insert records describing the new inode chunk into the btrees.
 	 */
-	error = xfs_inobt_insert(args.mp, tp, agbp, newino, newlen,
-				 XFS_INOBT_ALL_FREE, XFS_BTNUM_INO);
+	error = xfs_spchunk_has_record(args.mp, tp, agbp, newino, newlen,
+				       XFS_BTNUM_INO, &rec);
+	if (error)
+		return error;
+	if (rec.ir_startino == NULLAGINO) {
+		/* no existing record, set all fields */
+		rec.ir_startino = newino;
+		rec.ir_holemask = ~allocmask;
+		rec.ir_freecount = newlen;
+		rec.ir_free = XFS_INOBT_ALL_FREE;
+	} else {
+		/* we already have a record, update it */
+		offset = newino - rec.ir_startino;
+		ASSERT(offset % XFS_INODES_PER_SPCHUNK == 0);
+
+		allocmask <<= offset / XFS_INODES_PER_SPCHUNK;
+
+		rec.ir_freecount += newlen;
+		rec.ir_holemask &= ~allocmask;
+	}
+
+	error = xfs_inobt_update_insert(args.mp, tp, agbp, &rec, XFS_BTNUM_INO);
 	if (error)
 		return error;
 
 	if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
-		error = xfs_inobt_insert(args.mp, tp, agbp, newino, newlen,
-					 XFS_INOBT_ALL_FREE, XFS_BTNUM_FINO);
+		error = xfs_inobt_update_insert(args.mp, tp, agbp, &rec,
+						XFS_BTNUM_FINO);
 		if (error)
 			return error;
 	}
@@ -1644,7 +1692,8 @@ xfs_difree_finobt(
 		 */
 		XFS_WANT_CORRUPTED_GOTO(ibtrec->ir_freecount == 1, error);
 
-		error = xfs_inobt_insert_rec(cur, ibtrec->ir_freecount,
+		error = xfs_inobt_insert_rec(cur, ibtrec->ir_holemask,
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
