Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E14E97F59
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 12:17:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CF6188F806F
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 10:17:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HM0Wihn2Jh68OEKx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2015 10:17:29 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1CIHTOJ018940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 13:17:29 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1CIHSBt025877
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 13:17:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 08/18] xfs: introduce inode record hole mask for sparse
	inode chunks
Date: Thu, 12 Feb 2015 13:17:15 -0500
Message-Id: <1423765045-15791-9-git-send-email-bfoster@redhat.com>
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

The inode btrees track 64 inodes per record regardless of inode size.
Thus, inode chunks on disk vary in size depending on the size of the
inodes. This creates a contiguous allocation requirement for new inode
chunks that can be difficult to satisfy on an aged and fragmented (free
space) filesystems.

The inode record freecount currently uses 4 bytes on disk to track the
free inode count. With a maximum freecount value of 64, only one byte is
required. Convert the freecount field to a single byte and use two of
the remaining 3 higher order bytes left for the hole mask field. Use the
final leftover byte for the total count field.

The hole mask field tracks holes in the chunks of physical space that
the inode record refers to. This facilitates the sparse allocation of
inode chunks when contiguous chunks are not available and allows the
inode btrees to identify what portions of the chunk contain valid
inodes. The total count field contains the total number of valid inodes
referred to by the record. This can also be deduced from the hole mask.
The count field provides clarity and redundancy for internal record
verification.

Note that neither of the new fields can be written to disk on fs'
without sparse inode support. Doing so writes to the high-order bytes of
freecount and causes corruption from the perspective of older kernels.
The on-disk inobt record data structure is updated with a union to
distinguish between the original, "full" format and the new, "sparse"
format. The conversion routines to get, insert and update records are
updated to translate to and from the on-disk record accordingly such
that freecount remains a 4-byte value on non-supported fs, yet the new
fields of the in-core record are always valid with respect to the
record. This means that higher level code can refer to the current
in-core record format unconditionally and lower level code ensures that
records are translated to/from disk according to the capabilities of the
fs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h       | 34 +++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_ialloc.c       | 48 +++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_ialloc_btree.c | 11 ++++++++-
 3 files changed, 81 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 47005b1..4f2160d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1285,26 +1285,54 @@ typedef	__uint64_t	xfs_inofree_t;
 #define	XFS_INOBT_ALL_FREE		((xfs_inofree_t)-1)
 #define	XFS_INOBT_MASK(i)		((xfs_inofree_t)1 << (i))
 
+#define XFS_INOBT_HOLEMASK_FULL		0	/* holemask for full chunk */
+#define XFS_INOBT_HOLEMASK_BITS		(NBBY * sizeof(__uint16_t))
+#define XFS_INODES_PER_HOLEMASK_BIT	\
+	(XFS_INODES_PER_CHUNK / (NBBY * sizeof(__uint16_t)))
+
 static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
 {
 	return ((n >= XFS_INODES_PER_CHUNK ? 0 : XFS_INOBT_MASK(n)) - 1) << i;
 }
 
 /*
- * Data record structure
+ * The on-disk inode record structure has two formats. The original "full"
+ * format uses a 4-byte freecount. The "sparse" format uses a 1-byte freecount
+ * and replaces the 3 high-order freecount bytes wth the holemask and inode
+ * count.
+ *
+ * The holemask of the sparse record format allows an inode chunk to have holes
+ * that refer to blocks not owned by the inode record. This facilitates inode
+ * allocation in the event of severe free space fragmentation.
  */
 typedef struct xfs_inobt_rec {
 	__be32		ir_startino;	/* starting inode number */
-	__be32		ir_freecount;	/* count of free inodes (set bits) */
+	union {
+		struct {
+			__be32	ir_freecount;	/* count of free inodes */
+		} f;
+		struct {
+			__be16	ir_holemask;/* hole mask for sparse chunks */
+			__u8	ir_count;	/* total inode count */
+			__u8	ir_freecount;	/* count of free inodes */
+		} sp;
+	} ir_u;
 	__be64		ir_free;	/* free inode mask */
 } xfs_inobt_rec_t;
 
 typedef struct xfs_inobt_rec_incore {
 	xfs_agino_t	ir_startino;	/* starting inode number */
-	__int32_t	ir_freecount;	/* count of free inodes (set bits) */
+	__uint16_t	ir_holemask;	/* hole mask for sparse chunks */
+	__uint8_t	ir_count;	/* total inode count */
+	__uint8_t	ir_freecount;	/* count of free inodes (set bits) */
 	xfs_inofree_t	ir_free;	/* free inode mask */
 } xfs_inobt_rec_incore_t;
 
+static inline bool xfs_inobt_issparse(uint16_t holemask)
+{
+	/* non-zero holemask represents a sparse rec. */
+	return holemask;
+}
 
 /*
  * Key structure
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 07cce35..008cb24 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -65,6 +65,8 @@ xfs_inobt_lookup(
 	int			*stat)	/* success/failure */
 {
 	cur->bc_rec.i.ir_startino = ino;
+	cur->bc_rec.i.ir_holemask = 0;
+	cur->bc_rec.i.ir_count = 0;
 	cur->bc_rec.i.ir_freecount = 0;
 	cur->bc_rec.i.ir_free = 0;
 	return xfs_btree_lookup(cur, dir, stat);
@@ -82,7 +84,14 @@ xfs_inobt_update(
 	union xfs_btree_rec	rec;
 
 	rec.inobt.ir_startino = cpu_to_be32(irec->ir_startino);
-	rec.inobt.ir_freecount = cpu_to_be32(irec->ir_freecount);
+	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
+		rec.inobt.ir_u.sp.ir_holemask = cpu_to_be16(irec->ir_holemask);
+		rec.inobt.ir_u.sp.ir_count = irec->ir_count;
+		rec.inobt.ir_u.sp.ir_freecount = irec->ir_freecount;
+	} else {
+		/* ir_holemask/ir_count not supported on-disk */
+		rec.inobt.ir_u.f.ir_freecount = cpu_to_be32(irec->ir_freecount);
+	}
 	rec.inobt.ir_free = cpu_to_be64(irec->ir_free);
 	return xfs_btree_update(cur, &rec);
 }
@@ -100,12 +109,27 @@ xfs_inobt_get_rec(
 	int			error;
 
 	error = xfs_btree_get_rec(cur, &rec, stat);
-	if (!error && *stat == 1) {
-		irec->ir_startino = be32_to_cpu(rec->inobt.ir_startino);
-		irec->ir_freecount = be32_to_cpu(rec->inobt.ir_freecount);
-		irec->ir_free = be64_to_cpu(rec->inobt.ir_free);
+	if (error || *stat == 0)
+		return error;
+
+	irec->ir_startino = be32_to_cpu(rec->inobt.ir_startino);
+	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
+		irec->ir_holemask = be16_to_cpu(rec->inobt.ir_u.sp.ir_holemask);
+		irec->ir_count = rec->inobt.ir_u.sp.ir_count;
+		irec->ir_freecount = rec->inobt.ir_u.sp.ir_freecount;
+	} else {
+		/*
+		 * ir_holemask/ir_count not supported on-disk. Fill in hardcoded
+		 * values for full inode chunks.
+		 */
+		irec->ir_holemask = XFS_INOBT_HOLEMASK_FULL;
+		irec->ir_count = XFS_INODES_PER_CHUNK;
+		irec->ir_freecount =
+				be32_to_cpu(rec->inobt.ir_u.f.ir_freecount);
 	}
-	return error;
+	irec->ir_free = be64_to_cpu(rec->inobt.ir_free);
+
+	return 0;
 }
 
 /*
@@ -114,10 +138,14 @@ xfs_inobt_get_rec(
 STATIC int
 xfs_inobt_insert_rec(
 	struct xfs_btree_cur	*cur,
+	__uint16_t		holemask,
+	__uint8_t		count,
 	__int32_t		freecount,
 	xfs_inofree_t		free,
 	int			*stat)
 {
+	cur->bc_rec.i.ir_holemask = holemask;
+	cur->bc_rec.i.ir_count = count;
 	cur->bc_rec.i.ir_freecount = freecount;
 	cur->bc_rec.i.ir_free = free;
 	return xfs_btree_insert(cur, stat);
@@ -154,7 +182,9 @@ xfs_inobt_insert(
 		}
 		ASSERT(i == 0);
 
-		error = xfs_inobt_insert_rec(cur, XFS_INODES_PER_CHUNK,
+		error = xfs_inobt_insert_rec(cur, XFS_INOBT_HOLEMASK_FULL,
+					     XFS_INODES_PER_CHUNK,
+					     XFS_INODES_PER_CHUNK,
 					     XFS_INOBT_ALL_FREE, &i);
 		if (error) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
@@ -1604,7 +1634,9 @@ xfs_difree_finobt(
 		 */
 		XFS_WANT_CORRUPTED_GOTO(ibtrec->ir_freecount == 1, error);
 
-		error = xfs_inobt_insert_rec(cur, ibtrec->ir_freecount,
+		error = xfs_inobt_insert_rec(cur, ibtrec->ir_holemask,
+					     ibtrec->ir_count,
+					     ibtrec->ir_freecount,
 					     ibtrec->ir_free, &i);
 		if (error)
 			goto error;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 964c465..b95aac5 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -167,7 +167,16 @@ xfs_inobt_init_rec_from_cur(
 	union xfs_btree_rec	*rec)
 {
 	rec->inobt.ir_startino = cpu_to_be32(cur->bc_rec.i.ir_startino);
-	rec->inobt.ir_freecount = cpu_to_be32(cur->bc_rec.i.ir_freecount);
+	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
+		rec->inobt.ir_u.sp.ir_holemask =
+					cpu_to_be16(cur->bc_rec.i.ir_holemask);
+		rec->inobt.ir_u.sp.ir_count = cur->bc_rec.i.ir_count;
+		rec->inobt.ir_u.sp.ir_freecount = cur->bc_rec.i.ir_freecount;
+	} else {
+		/* ir_holemask/ir_count not supported on-disk */
+		rec->inobt.ir_u.f.ir_freecount =
+					cpu_to_be32(cur->bc_rec.i.ir_freecount);
+	}
 	rec->inobt.ir_free = cpu_to_be64(cur->bc_rec.i.ir_free);
 }
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
