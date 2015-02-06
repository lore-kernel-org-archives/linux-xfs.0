Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0046D804A
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 13:53:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3DB18AC00B
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 11:53:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HSmYLC2Rbvz2gwsl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Feb 2015 11:53:07 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t16Jr7ft026133
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 6 Feb 2015 14:53:08 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t16Jr7wZ017039
	for <xfs@oss.sgi.com>; Fri, 6 Feb 2015 14:53:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 16/18] xfs: use actual inode count for sparse records in
	bulkstat/inumbers
Date: Fri,  6 Feb 2015 14:53:03 -0500
Message-Id: <1423252385-3063-17-git-send-email-bfoster@redhat.com>
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

The bulkstat and inumbers mechanisms make the assumption that inode
records consist of a full 64 inode chunk in several places. For example,
this is used to track how many inodes have been processed overall as
well as to determine whether a record has allocated inodes that must be
handled.

This assumption is invalid for sparse inode records. While sparse inodes
will be marked as free in the ir_free mask, they are not accounted as
free in ir_freecount because they cannot be allocated. Therefore,
ir_freecount may be less than 64 inodes in an inode record for which all
physically allocated inodes are free (and in turn ir_freecount < 64 does
not signify that the record has allocated inodes).

Create the xfs_inobt_count() helper to calculate the total number of
physically allocated inodes based on the holemask. Use the helper in
xfs_bulkstat() and xfs_inumbers() instead of the fixed
XFS_INODE_PER_CHUNK value to ensure correct accounting in the event of
sparse inode records.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 16 ++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |  5 +++++
 fs/xfs/xfs_itable.c        | 14 ++++++++++----
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index c104ee5..4d151ed 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1207,6 +1207,22 @@ xfs_inobt_first_free_inode(
 }
 
 /*
+ * Calculate the real count of inodes in a chunk.
+ */
+int
+xfs_inobt_count(
+	struct xfs_mount		*mp,
+	struct xfs_inobt_rec_incore	*rec)
+{
+	ASSERT(!xfs_inobt_rec_check_count(mp, rec));
+
+	if (!xfs_inobt_issparse(rec->ir_holemask))
+		return XFS_INODES_PER_CHUNK;
+
+	return rec->ir_count;
+}
+
+/*
  * Allocate an inode using the inobt-only algorithm.
  */
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 12401fe..065abfc 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -170,4 +170,9 @@ int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agnumber_t agno, struct xfs_buf **bpp);
 
 
+/*
+ * Calculate the real count of inodes in a chunk.
+ */
+int xfs_inobt_count(struct xfs_mount *mp, struct xfs_inobt_rec_incore *rec);
+
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 82e3142..34eecdf 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -252,7 +252,8 @@ xfs_bulkstat_grab_ichunk(
 		}
 
 		irec->ir_free |= xfs_inobt_maskn(0, idx);
-		*icount = XFS_INODES_PER_CHUNK - irec->ir_freecount;
+		*icount = xfs_inobt_count(cur->bc_mp, irec) -
+			  irec->ir_freecount;
 	}
 
 	return 0;
@@ -415,6 +416,8 @@ xfs_bulkstat(
 				goto del_cursor;
 			if (icount) {
 				irbp->ir_startino = r.ir_startino;
+				irbp->ir_holemask = r.ir_holemask;
+				irbp->ir_count = r.ir_count;
 				irbp->ir_freecount = r.ir_freecount;
 				irbp->ir_free = r.ir_free;
 				irbp++;
@@ -447,13 +450,16 @@ xfs_bulkstat(
 			 * If this chunk has any allocated inodes, save it.
 			 * Also start read-ahead now for this chunk.
 			 */
-			if (r.ir_freecount < XFS_INODES_PER_CHUNK) {
+			if (r.ir_freecount < xfs_inobt_count(mp, &r)) {
 				xfs_bulkstat_ichunk_ra(mp, agno, &r);
 				irbp->ir_startino = r.ir_startino;
+				irbp->ir_holemask = r.ir_holemask;
+				irbp->ir_count = r.ir_count;
 				irbp->ir_freecount = r.ir_freecount;
 				irbp->ir_free = r.ir_free;
 				irbp++;
-				icount += XFS_INODES_PER_CHUNK - r.ir_freecount;
+				icount += xfs_inobt_count(mp, &r) -
+					  r.ir_freecount;
 			}
 			error = xfs_btree_increment(cur, 0, &stat);
 			if (error || stat == 0) {
@@ -600,7 +606,7 @@ xfs_inumbers(
 		buffer[bufidx].xi_startino =
 			XFS_AGINO_TO_INO(mp, agno, r.ir_startino);
 		buffer[bufidx].xi_alloccount =
-			XFS_INODES_PER_CHUNK - r.ir_freecount;
+			xfs_inobt_count(mp, &r) - r.ir_freecount;
 		buffer[bufidx].xi_allocmask = ~r.ir_free;
 		if (++bufidx == bcount) {
 			long	written;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
