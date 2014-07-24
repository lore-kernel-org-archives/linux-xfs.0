Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1DC987F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:16:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 933C3AC006
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 08:16:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hQK0rMAJYL4lDEFO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 08:16:10 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OFG8MD020274
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 11:16:09 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OEN9h9017000
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 04/18] xfs: introduce inode record hole mask for sparse inode
	chunks
Date: Thu, 24 Jul 2014 10:22:54 -0400
Message-Id: <1406211788-63206-5-git-send-email-bfoster@redhat.com>
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

The inode btrees track 64 inodes per record, regardless of inode size.
Thus, inode chunks on disk vary in size depending on the size of the
inodes. This creates a contiguous allocation requirement for new inode
chunks that can be difficult to satisfy on an aged and fragmented (free
space) filesystem.

The inode record freecount currently uses 4 bytes on disk to track the
free inode count. With a maximum freecount value of 64, only one byte is
required. Convert the freecount field to a single byte and reserve two
of the remaining 3 higher order bytes left to the hole mask field.

The hole mask field tracks potential holes in the chunks of physical
space that the inode record refers to. This facilitates the sparse
allocation of inode chunks when contiguous chunks are not available and
allows the inode btrees to identify what portions of the chunk contain
valid inodes.

Tracking holes means the field is initialized to zero and thus maintains
backwards compatibility with existing filesystems. E.g., the higher
order bytes of a counter with a max value of 64 are already initialized
to 0. Update the inode record management functions to handle the new
field and initialize it to zero for now.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h       | 7 +++++--
 fs/xfs/libxfs/xfs_ialloc.c       | 9 +++++++--
 fs/xfs/libxfs/xfs_ialloc_btree.c | 4 +++-
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 34d85ac..39022d9 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -221,13 +221,16 @@ static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
  */
 typedef struct xfs_inobt_rec {
 	__be32		ir_startino;	/* starting inode number */
-	__be32		ir_freecount;	/* count of free inodes (set bits) */
+	__be16		ir_holemask;	/* hole mask for sparse chunks */
+	__u8		ir_pad;
+	__u8		ir_freecount;	/* count of free inodes (set bits) */
 	__be64		ir_free;	/* free inode mask */
 } xfs_inobt_rec_t;
 
 typedef struct xfs_inobt_rec_incore {
 	xfs_agino_t	ir_startino;	/* starting inode number */
-	__int32_t	ir_freecount;	/* count of free inodes (set bits) */
+	__uint16_t	ir_holemask;	/* hole mask for sparse chunks */
+	__uint8_t	ir_freecount;	/* count of free inodes (set bits) */
 	xfs_inofree_t	ir_free;	/* free inode mask */
 } xfs_inobt_rec_incore_t;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 5448a74..8286fda 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -68,6 +68,7 @@ xfs_inobt_lookup(
 	int			*stat)	/* success/failure */
 {
 	cur->bc_rec.i.ir_startino = ino;
+	cur->bc_rec.i.ir_holemask = 0;
 	cur->bc_rec.i.ir_freecount = 0;
 	cur->bc_rec.i.ir_free = 0;
 	return xfs_btree_lookup(cur, dir, stat);
@@ -85,7 +86,9 @@ xfs_inobt_update(
 	union xfs_btree_rec	rec;
 
 	rec.inobt.ir_startino = cpu_to_be32(irec->ir_startino);
-	rec.inobt.ir_freecount = cpu_to_be32(irec->ir_freecount);
+	rec.inobt.ir_holemask = cpu_to_be16(irec->ir_holemask);
+	rec.inobt.ir_pad = 0;
+	rec.inobt.ir_freecount = irec->ir_freecount;
 	rec.inobt.ir_free = cpu_to_be64(irec->ir_free);
 	return xfs_btree_update(cur, &rec);
 }
@@ -105,7 +108,8 @@ xfs_inobt_get_rec(
 	error = xfs_btree_get_rec(cur, &rec, stat);
 	if (!error && *stat == 1) {
 		irec->ir_startino = be32_to_cpu(rec->inobt.ir_startino);
-		irec->ir_freecount = be32_to_cpu(rec->inobt.ir_freecount);
+		irec->ir_holemask = be16_to_cpu(rec->inobt.ir_holemask);
+		irec->ir_freecount = rec->inobt.ir_freecount;
 		irec->ir_free = be64_to_cpu(rec->inobt.ir_free);
 	}
 	return error;
@@ -121,6 +125,7 @@ xfs_inobt_insert_rec(
 	xfs_inofree_t		free,
 	int			*stat)
 {
+	cur->bc_rec.i.ir_holemask = 0;
 	cur->bc_rec.i.ir_freecount = freecount;
 	cur->bc_rec.i.ir_free = free;
 	return xfs_btree_insert(cur, stat);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index c9b06f3..0c94879 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -169,7 +169,9 @@ xfs_inobt_init_rec_from_cur(
 	union xfs_btree_rec	*rec)
 {
 	rec->inobt.ir_startino = cpu_to_be32(cur->bc_rec.i.ir_startino);
-	rec->inobt.ir_freecount = cpu_to_be32(cur->bc_rec.i.ir_freecount);
+	rec->inobt.ir_holemask = cpu_to_be16(cur->bc_rec.i.ir_holemask);
+	rec->inobt.ir_pad = 0;
+	rec->inobt.ir_freecount = cur->bc_rec.i.ir_freecount;
 	rec->inobt.ir_free = cpu_to_be64(cur->bc_rec.i.ir_free);
 }
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
