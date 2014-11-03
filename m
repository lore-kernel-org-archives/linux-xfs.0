Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7249B7F58
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 10:12:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E505BAC005
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 08:12:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id G7WA0wiqVznDj1X0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 08:12:30 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sA3GCTup027598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:12:29 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sA3GCSJD017055
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:12:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 15/17] xfs: use actual inode count for sparse records in
	bulkstat/inumbers
Date: Mon,  3 Nov 2014 11:12:24 -0500
Message-Id: <1415031146-9107-16-git-send-email-bfoster@redhat.com>
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
 fs/xfs/libxfs/xfs_ialloc.c | 29 +++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |  5 +++++
 fs/xfs/xfs_itable.c        | 16 +++++++++++-----
 3 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 1fbd0a8..5e92422 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1002,6 +1002,35 @@ xfs_inobt_first_free_inode(
 }
 
 /*
+ * Calculate the real count of inodes in a chunk.
+ */
+int
+xfs_inobt_count(
+	struct xfs_mount		*mp,
+	struct xfs_inobt_rec_incore	*rec)
+{
+	int	inocount;
+	DECLARE_BITMAP(allocbmap, XFS_INODES_PER_CHUNK);
+
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb)) {
+		/*
+		 * allocated inode bit count should match ir_count
+		 *
+		 * TODO: it might be preferable to tie this validation to an
+		 * fs operation rather than a simple utility function call
+		 */
+		xfs_inobt_ialloc_bitmap(allocbmap, rec);
+		inocount = bitmap_weight(allocbmap, XFS_INODES_PER_CHUNK);
+		WARN_ON(inocount != rec->ir_count);
+	}
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
index 5aa8d6f..527d889 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -166,4 +166,9 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
 			  xfs_agnumber_t agno, xfs_agblock_t agbno,
 			  xfs_agblock_t length, unsigned int gen);
 
+/*
+ * Calculate the real count of inodes in a chunk.
+ */
+int xfs_inobt_count(struct xfs_mount *mp, struct xfs_inobt_rec_incore *rec);
+
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 7765ff7..b44a9f0 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -254,7 +254,8 @@ xfs_bulkstat_grab_ichunk(
 		}
 
 		irec->ir_free |= xfs_inobt_maskn(0, idx);
-		*icount = XFS_INODES_PER_CHUNK - irec->ir_freecount;
+		*icount = xfs_inobt_count(cur->bc_mp, irec) -
+			  irec->ir_freecount;
 	}
 
 	return 0;
@@ -285,7 +286,7 @@ xfs_bulkstat_ag_ichunk(
 
 	for (agino = irbp->ir_startino, chunkidx = clustidx = 0;
 	     XFS_BULKSTAT_UBLEFT(ubleft) &&
-	     irbp->ir_freecount < XFS_INODES_PER_CHUNK;
+	     irbp->ir_freecount < xfs_inobt_count(mp, irbp);
 	     chunkidx++, clustidx++, agino++) {
 		int		fmterror;	/* bulkstat formatter result */
 		int		ubused;
@@ -430,6 +431,8 @@ xfs_bulkstat(
 				goto del_cursor;
 			if (icount) {
 				irbp->ir_startino = r.ir_startino;
+				irbp->ir_holemask = r.ir_holemask;
+				irbp->ir_count = r.ir_count;
 				irbp->ir_freecount = r.ir_freecount;
 				irbp->ir_free = r.ir_free;
 				irbp++;
@@ -461,13 +464,16 @@ xfs_bulkstat(
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
 			/*
 			 * Set agino to after this chunk and bump the cursor.
@@ -620,7 +626,7 @@ xfs_inumbers(
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
