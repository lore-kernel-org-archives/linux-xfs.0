Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 137A97F50
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:16:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C984B8F8033
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 08:16:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MdKXet9TLPGVj1DQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 08:16:10 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OFG8MF020274
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 11:16:10 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OENAdv017005
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 17/18] xfs: use actual inode count for sparse records in
	bulkstat/inumbers
Date: Thu, 24 Jul 2014 10:23:07 -0400
Message-Id: <1406211788-63206-18-git-send-email-bfoster@redhat.com>
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

The bulkstat and inumbers mechanisms make the assumption that inode
records consist of a full 64 inode chunk in several places. E.g., this
is used to track how many inodes have been processed overall as well as
to determine when all in-use inodes of a record have been processed. The
record processing, in particular, increments the record freecount for
each in-use inode until it hits the expected max of 64.

This is invalid for sparse inode records. While all inodes might be
marked free in the free mask regardless of whether they are allocated on
disk, ir_freecount is based on the total number of physically allocated
inodes and thus may be less than 64 inodes on a completely free inode
chunk.

Create the xfs_inobt_count() helper to calculate the total number of
physically allocated inodes based on the holemask. Use the helper in
xfs_bulkstat() and xfs_inumbers() instead of the fixed
XFS_INODE_PER_CHUNK value to ensure correct accounting in the event of
sparse inode records.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 27 +++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |  5 +++++
 fs/xfs/xfs_itable.c        | 12 +++++++-----
 3 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 86c6ccd..daf317f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -951,6 +951,33 @@ xfs_inobt_first_free_inode(
 }
 
 /*
+ * Calculate the real count of inodes in a chunk.
+ */
+int
+xfs_inobt_count(
+	struct xfs_inobt_rec_incore	*rec)
+{
+	__uint16_t	allocmask;
+	uint		allocbitmap;
+	int		nextbit;
+	int		count = 0;
+
+	if (!xfs_inobt_issparse(rec))
+		return XFS_INODES_PER_CHUNK;
+
+	allocmask = ~rec->ir_holemask;
+	allocbitmap = allocmask;
+
+	nextbit = xfs_next_bit(&allocbitmap, 1, 0);
+	while (nextbit != -1) {
+		count += XFS_INODES_PER_SPCHUNK;
+		nextbit = xfs_next_bit(&allocbitmap, 1, nextbit + 1);
+	}
+
+	return count;
+}
+
+/*
  * Allocate an inode using the inobt-only algorithm.
  */
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 5aa8d6f..4230b22 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -166,4 +166,9 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
 			  xfs_agnumber_t agno, xfs_agblock_t agbno,
 			  xfs_agblock_t length, unsigned int gen);
 
+/*
+ * Calculate the real count of inodes in a chunk.
+ */
+int xfs_inobt_count(struct xfs_inobt_rec_incore *rec);
+
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 7e54992..8ba967c 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -312,11 +312,12 @@ xfs_bulkstat(
 				}
 				r.ir_free |= xfs_inobt_maskn(0, chunkidx);
 				irbp->ir_startino = r.ir_startino;
+				irbp->ir_holemask = r.ir_holemask;
 				irbp->ir_freecount = r.ir_freecount;
 				irbp->ir_free = r.ir_free;
 				irbp++;
 				agino = r.ir_startino + XFS_INODES_PER_CHUNK;
-				icount = XFS_INODES_PER_CHUNK - r.ir_freecount;
+				icount = xfs_inobt_count(&r) - r.ir_freecount;
 			} else {
 				/*
 				 * If any of those tests failed, bump the
@@ -376,7 +377,7 @@ xfs_bulkstat(
 			 * If this chunk has any allocated inodes, save it.
 			 * Also start read-ahead now for this chunk.
 			 */
-			if (r.ir_freecount < XFS_INODES_PER_CHUNK) {
+			if (r.ir_freecount < xfs_inobt_count(&r)) {
 				struct blk_plug	plug;
 				/*
 				 * Loop over all clusters in the next chunk.
@@ -397,10 +398,11 @@ xfs_bulkstat(
 				}
 				blk_finish_plug(&plug);
 				irbp->ir_startino = r.ir_startino;
+				irbp->ir_holemask = r.ir_holemask;
 				irbp->ir_freecount = r.ir_freecount;
 				irbp->ir_free = r.ir_free;
 				irbp++;
-				icount += XFS_INODES_PER_CHUNK - r.ir_freecount;
+				icount += xfs_inobt_count(&r) - r.ir_freecount;
 			}
 			/*
 			 * Set agino to after this chunk and bump the cursor.
@@ -427,7 +429,7 @@ xfs_bulkstat(
 			 */
 			for (agino = irbp->ir_startino, chunkidx = clustidx = 0;
 			     XFS_BULKSTAT_UBLEFT(ubleft) &&
-				irbp->ir_freecount < XFS_INODES_PER_CHUNK;
+				irbp->ir_freecount < xfs_inobt_count(irbp);
 			     chunkidx++, clustidx++, agino++) {
 				ASSERT(chunkidx < XFS_INODES_PER_CHUNK);
 
@@ -654,7 +656,7 @@ xfs_inumbers(
 		buffer[bufidx].xi_startino =
 			XFS_AGINO_TO_INO(mp, agno, r.ir_startino);
 		buffer[bufidx].xi_alloccount =
-			XFS_INODES_PER_CHUNK - r.ir_freecount;
+			xfs_inobt_count(&r) - r.ir_freecount;
 		buffer[bufidx].xi_allocmask = ~r.ir_free;
 		bufidx++;
 		left--;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
