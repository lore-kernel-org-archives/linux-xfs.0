Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 166C37F69
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 17:14:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E759A304039
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 15:14:17 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 6ENAy7kCLH0metxV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Jul 2015 15:14:15 -0700 (PDT)
Date: Thu, 30 Jul 2015 15:14:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/24] xfs: define the on-disk refcount btree format
Message-ID: <20150730221411.GJ10043@birch.djwong.org>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
	<20150729223330.17414.82692.stgit@birch.djwong.org>
	<20150730004215.GI16638@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150730004215.GI16638@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 30, 2015 at 10:42:15AM +1000, Dave Chinner wrote:
> On Wed, Jul 29, 2015 at 03:33:30PM -0700, Darrick J. Wong wrote:
> > Start constructing the refcount btree implementation by establishing
> > the on-disk format and everything needed to read, write, and
> > manipulate the refcount btree blocks.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ....
> > +STATIC bool
> > +xfs_refcountbt_verify(
> > +	struct xfs_buf		*bp)
> 
> feel free to shorten that prefix to xfs_refcbt_.....

Ok, will do for next release.

> 
> > +{
> > +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> > +	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
> > +	struct xfs_perag	*pag = bp->b_pag;
> > +	unsigned int		level;
> > +
> > +	if (block->bb_magic != cpu_to_be32(XFS_REFC_CRC_MAGIC))
> > +		return false;
> > +
> > +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> > +		return false;
> > +	if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
> > +		return false;
> > +	if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
> > +		return false;
> > +	if (pag &&
> > +	    be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
> > +		return false;
> > +
> > +	level = be16_to_cpu(block->bb_level);
> > +	if (pag && pag->pagf_init) {
> > +		if (level >= pag->pagf_refcount_level)
> > +			return false;
> > +	} else if (level >= mp->m_ag_maxlevels)
> > +		return false;
> > +
> > +	/* numrecs verification */
> > +	if (be16_to_cpu(block->bb_numrecs) > mp->m_refc_mxr[level != 0])
> > +		return false;
> > +
> > +	/* sibling pointer verification */
> > +	if (!block->bb_u.s.bb_leftsib ||
> > +	    (be32_to_cpu(block->bb_u.s.bb_leftsib) >= mp->m_sb.sb_agblocks &&
> > +	     block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK)))
> > +		return false;
> > +	if (!block->bb_u.s.bb_rightsib ||
> > +	    (be32_to_cpu(block->bb_u.s.bb_rightsib) >= mp->m_sb.sb_agblocks &&
> > +	     block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK)))
> > +		return false;
> 
> I'm starting to think there's a xfs_btree_sblock_verify() function
> we need to factor out of all these btree verification functions...

Something like this?

--D

From: Darrick J. Wong <darrick.wong@oracle.com>
Subject: [PATCH] libxfs: refactor short btree block verification

Create xfs_btree_sblock_verify() to verify short-format btree blocks
(i.e. the per-AG btrees with 32-bit block pointers) instead of
open-coding them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc_btree.c  |   34 ++--------------------
 fs/xfs/libxfs/xfs_btree.c        |   58 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h        |    3 ++
 fs/xfs/libxfs/xfs_ialloc_btree.c |   30 +++-----------------
 fs/xfs/libxfs/xfs_rmap_btree.c   |   25 +++-------------
 5 files changed, 73 insertions(+), 77 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 59d521c..1352322 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -293,14 +293,7 @@ xfs_allocbt_verify(
 	level = be16_to_cpu(block->bb_level);
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_ABTB_CRC_MAGIC):
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
-			return false;
-		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
-			return false;
-		if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
-			return false;
-		if (pag &&
-		    be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
+		if (!xfs_btree_sblock_v5hdr_verify(bp))
 			return false;
 		/* fall through */
 	case cpu_to_be32(XFS_ABTB_MAGIC):
@@ -311,14 +304,7 @@ xfs_allocbt_verify(
 			return false;
 		break;
 	case cpu_to_be32(XFS_ABTC_CRC_MAGIC):
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
-			return false;
-		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
-			return false;
-		if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
-			return false;
-		if (pag &&
-		    be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
+		if (!xfs_btree_sblock_v5hdr_verify(bp))
 			return false;
 		/* fall through */
 	case cpu_to_be32(XFS_ABTC_MAGIC):
@@ -332,21 +318,7 @@ xfs_allocbt_verify(
 		return false;
 	}
 
-	/* numrecs verification */
-	if (be16_to_cpu(block->bb_numrecs) > mp->m_alloc_mxr[level != 0])
-		return false;
-
-	/* sibling pointer verification */
-	if (!block->bb_u.s.bb_leftsib ||
-	    (be32_to_cpu(block->bb_u.s.bb_leftsib) >= mp->m_sb.sb_agblocks &&
-	     block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK)))
-		return false;
-	if (!block->bb_u.s.bb_rightsib ||
-	    (be32_to_cpu(block->bb_u.s.bb_rightsib) >= mp->m_sb.sb_agblocks &&
-	     block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK)))
-		return false;
-
-	return true;
+	return xfs_btree_sblock_verify(bp, mp->m_alloc_mxr[level != 0]);
 }
 
 static void
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4c9b9b3..d0ca2ca 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4068,3 +4068,61 @@ xfs_btree_change_owner(
 
 	return 0;
 }
+
+/**
+ * xfs_btree_sblock_v5hdr_verify() -- verify the v5 fields of a short-format
+ *				      btree block
+ *
+ * @bp: buffer containing the btree block
+ * @max_recs: pointer to the m_*_mxr max records field in the xfs mount
+ * @pag_max_level: pointer to the per-ag max level field
+ */
+bool
+xfs_btree_sblock_v5hdr_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_perag	*pag = bp->b_pag;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return false;
+	if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
+		return false;
+	if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
+		return false;
+	if (pag && be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
+		return false;
+	return true;
+}
+
+/**
+ * xfs_btree_sblock_verify() -- verify a short-format btree block
+ *
+ * @bp: buffer containing the btree block
+ * @max_recs: maximum records allowed in this btree node
+ */
+bool
+xfs_btree_sblock_verify(
+	struct xfs_buf		*bp,
+	unsigned int		max_recs)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+
+	/* numrecs verification */
+	if (be16_to_cpu(block->bb_numrecs) > max_recs)
+		return false;
+
+	/* sibling pointer verification */
+	if (!block->bb_u.s.bb_leftsib ||
+	    (be32_to_cpu(block->bb_u.s.bb_leftsib) >= mp->m_sb.sb_agblocks &&
+	     block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK)))
+		return false;
+	if (!block->bb_u.s.bb_rightsib ||
+	    (be32_to_cpu(block->bb_u.s.bb_rightsib) >= mp->m_sb.sb_agblocks &&
+	     block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK)))
+		return false;
+
+	return true;
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 48ab2b1..dd29d15 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -471,4 +471,7 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
 #define XFS_BTREE_TRACE_ARGR(c, r)
 #define	XFS_BTREE_TRACE_CURSOR(c, t)
 
+bool xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
+bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index b96db1c..2d692fb 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -222,7 +222,6 @@ xfs_inobt_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	struct xfs_perag	*pag = bp->b_pag;
 	unsigned int		level;
 
 	/*
@@ -238,14 +237,7 @@ xfs_inobt_verify(
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_IBT_CRC_MAGIC):
 	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
-			return false;
-		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
-			return false;
-		if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
-			return false;
-		if (pag &&
-		    be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
+		if (!xfs_btree_sblock_v5hdr_verify(bp))
 			return false;
 		/* fall through */
 	case cpu_to_be32(XFS_IBT_MAGIC):
@@ -255,24 +247,12 @@ xfs_inobt_verify(
 		return 0;
 	}
 
-	/* numrecs and level verification */
+	/* level verification */
 	level = be16_to_cpu(block->bb_level);
 	if (level >= mp->m_in_maxlevels)
-		return false;
-	if (be16_to_cpu(block->bb_numrecs) > mp->m_inobt_mxr[level != 0])
-		return false;
-
-	/* sibling pointer verification */
-	if (!block->bb_u.s.bb_leftsib ||
-	    (be32_to_cpu(block->bb_u.s.bb_leftsib) >= mp->m_sb.sb_agblocks &&
-	     block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK)))
-		return false;
-	if (!block->bb_u.s.bb_rightsib ||
-	    (be32_to_cpu(block->bb_u.s.bb_rightsib) >= mp->m_sb.sb_agblocks &&
-	     block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK)))
-		return false;
-
-	return true;
+			return false;
+
+	return xfs_btree_sblock_verify(bp, mp->m_inobt_mxr[level != 0]);
 }
 
 static void
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 0b396e6..208435e 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -235,35 +235,18 @@ xfs_rmapbt_verify(
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return false;
-	if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
-		return false;
-	if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
-		return false;
-	if (pag && be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
+	if (!xfs_btree_sblock_v5hdr_verify(bp))
 		return false;
 
+	/* level verification */
 	level = be16_to_cpu(block->bb_level);
 	if (pag && pag->pagf_init) {
 		if (level >= pag->pagf_levels[XFS_BTNUM_RMAPi])
 			return false;
 	} else if (level >= mp->m_ag_maxlevels)
-		return false;
-
-	/* numrecs verification */
-	if (be16_to_cpu(block->bb_numrecs) > mp->m_rmap_mxr[level != 0])
-		return false;
-
-	/* sibling pointer verification */
-	if (!block->bb_u.s.bb_leftsib ||
-	    (be32_to_cpu(block->bb_u.s.bb_leftsib) >= mp->m_sb.sb_agblocks &&
-	     block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK)))
-		return false;
-	if (!block->bb_u.s.bb_rightsib ||
-	    (be32_to_cpu(block->bb_u.s.bb_rightsib) >= mp->m_sb.sb_agblocks &&
-	     block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK)))
-		return false;
+			return false;
 
-	return true;
+	return xfs_btree_sblock_verify(bp, mp->m_rmap_mxr[level != 0]);
 }
 
 static void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
