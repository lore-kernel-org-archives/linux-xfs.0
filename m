Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4C1C98095
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:32:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B8C20AC003
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:32:24 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ELGHDP6WYe4fpkFU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:32:22 -0700 (PDT)
Subject: [PATCH 015/145] xfs: refactor btree maxlevels computation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:32:18 -0700
Message-ID: <146612713862.16048.9572556591745823314.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Create a common function to calculate the maximum height of a per-AG
btree.  This will eventually be used by the rmapbt and refcountbt code
to calculate appropriate maxlevels values for each.  This is important
because the verifiers and the transaction block reservations depend on
accurate estimates of many blocks are needed to satisfy a btree split.

We were mistakenly using the max bnobt height for all the btrees,
which creates a dangerous situation since the larger records and keys
in an rmapbt make it very possible that the rmapbt will be taller than
the bnobt and so we can run out of transaction block reservation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc.c  |   15 ++-------------
 libxfs/xfs_btree.c  |   19 +++++++++++++++++++
 libxfs/xfs_btree.h  |    2 ++
 libxfs/xfs_ialloc.c |   19 +++++--------------
 4 files changed, 28 insertions(+), 27 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 2998af8..7276419 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1835,19 +1835,8 @@ void
 xfs_alloc_compute_maxlevels(
 	xfs_mount_t	*mp)	/* file system mount structure */
 {
-	int		level;
-	uint		maxblocks;
-	uint		maxleafents;
-	int		minleafrecs;
-	int		minnoderecs;
-
-	maxleafents = (mp->m_sb.sb_agblocks + 1) / 2;
-	minleafrecs = mp->m_alloc_mnr[0];
-	minnoderecs = mp->m_alloc_mnr[1];
-	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
-	for (level = 1; maxblocks > 1; level++)
-		maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
-	mp->m_ag_maxlevels = level;
+	mp->m_ag_maxlevels = xfs_btree_compute_maxlevels(mp, mp->m_alloc_mnr,
+			(mp->m_sb.sb_agblocks + 1) / 2);
 }
 
 /*
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 27e58b2..623841f 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -4154,6 +4154,25 @@ xfs_btree_sblock_verify(
 }
 
 /*
+ * Calculate the number of btree levels needed to store a given number of
+ * records in a short-format btree.
+ */
+uint
+xfs_btree_compute_maxlevels(
+	struct xfs_mount	*mp,
+	uint			*limits,
+	unsigned long		len)
+{
+	uint			level;
+	unsigned long		maxblocks;
+
+	maxblocks = (len + limits[0] - 1) / limits[0];
+	for (level = 1; maxblocks > 1; level++)
+		maxblocks = (maxblocks + limits[1] - 1) / limits[1];
+	return level;
+}
+
+/*
  * Calculate the number of blocks needed to store a given number of records
  * in a short-format (per-AG metadata) btree.
  */
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index b330f19..b955e5d 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -477,5 +477,7 @@ bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
 
 xfs_extlen_t xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,
 		unsigned long long len);
+uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
+		unsigned long len);
 
 #endif	/* __XFS_BTREE_H__ */
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 4f0e4ee..249512b 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2388,20 +2388,11 @@ void
 xfs_ialloc_compute_maxlevels(
 	xfs_mount_t	*mp)		/* file system mount structure */
 {
-	int		level;
-	uint		maxblocks;
-	uint		maxleafents;
-	int		minleafrecs;
-	int		minnoderecs;
-
-	maxleafents = (1LL << XFS_INO_AGINO_BITS(mp)) >>
-		XFS_INODES_PER_CHUNK_LOG;
-	minleafrecs = mp->m_inobt_mnr[0];
-	minnoderecs = mp->m_inobt_mnr[1];
-	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
-	for (level = 1; maxblocks > 1; level++)
-		maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
-	mp->m_in_maxlevels = level;
+	uint		inodes;
+
+	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
+	mp->m_in_maxlevels = xfs_btree_compute_maxlevels(mp, mp->m_inobt_mnr,
+							 inodes);
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
