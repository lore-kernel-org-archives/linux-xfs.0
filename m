Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BF3617F60
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 09:23:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8FDB48F804C
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 07:23:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id U5zpEAWfgbdBBfj6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 07:23:12 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OENAfV002642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:11 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OENA46017006
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 15/18] xfs: only free allocated regions of inode chunks
Date: Thu, 24 Jul 2014 10:23:05 -0400
Message-Id: <1406211788-63206-16-git-send-email-bfoster@redhat.com>
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

An inode chunk is currently added to the transaction free list based on
a simple fsb conversion and hardcoded chunk length. The nature of sparse
chunks is such that the physical chunk of inodes on disk may consist of
one or more discontiguous parts. Blocks that reside in the holes of the
inode chunk are not inodes and could be allocated to any other use or
not allocated at all.

Refactor the existing xfs_bmap_add_free() call into the
xfs_difree_inode_chunk() helper. The new helper uses the existing
calculation if a chunk is not sparse. Otherwise, use the inobt record
holemask to free the contiguous regions of the chunk.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 64 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 61 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index f75f191..1be57b1 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1659,6 +1659,66 @@ out_error:
 	return error;
 }
 
+/*
+ * Free the blocks of an inode chunk. We must consider that the inode chunk
+ * might be sparse and only free the regions that are allocated as part of the
+ * chunk.
+ */
+STATIC void
+xfs_difree_inode_chunk(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno,
+	struct xfs_inobt_rec_incore	*rec,
+	struct xfs_bmap_free		*flist)
+{
+	xfs_agblock_t	sagbno = XFS_AGINO_TO_AGBNO(mp, rec->ir_startino);
+	xfs_agblock_t	agbno;
+	int		nextbit;
+	int		contig, contigblk;
+	__uint16_t	allocmask;
+	uint		allocbitmap;
+
+	if (!xfs_inobt_issparse(rec)) {
+		/* not sparse, calculate extent info directly */
+		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno,
+				  XFS_AGINO_TO_AGBNO(mp, rec->ir_startino)),
+				  mp->m_ialloc_blks, flist, mp);
+		return;
+	}
+
+	/*
+	 * The bit flip and type conversion are intentionally done separately
+	 * here to zero-extend the bitmask.
+	 */
+	allocmask = ~rec->ir_holemask;
+	allocbitmap = allocmask;
+
+	/*
+	 * We now have an allocation bitmap in units of inodes at sparse chunk
+	 * granularity (e.g., more than one inode per bit). Use the bitmask
+	 * functions to find each contigious range of bits in the map. For each
+	 * range, convert the start bit and count to block values and use that
+	 * data to add the associated extent to the free list.
+	 */
+	nextbit = xfs_next_bit(&allocbitmap, 1, 0);
+	while (nextbit != -1) {
+		agbno = (nextbit * XFS_INODES_PER_SPCHUNK) /
+				mp->m_sb.sb_inopblock;
+		agbno += sagbno;
+
+		contig = xfs_contig_bits(&allocbitmap, 1, nextbit);
+		contigblk = (contig * XFS_INODES_PER_SPCHUNK) /
+				mp->m_sb.sb_inopblock;
+
+		ASSERT(agbno % xfs_ialloc_cluster_alignment(mp) == 0);
+		ASSERT(contigblk % xfs_ialloc_cluster_alignment(mp) == 0);
+		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
+				  flist, mp);
+
+		nextbit = xfs_next_bit(&allocbitmap, 1, nextbit + contig + 1);
+	}
+}
+
 STATIC int
 xfs_difree_inobt(
 	struct xfs_mount		*mp,
@@ -1750,9 +1810,7 @@ xfs_difree_inobt(
 			goto error0;
 		}
 
-		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno,
-				  XFS_AGINO_TO_AGBNO(mp, rec.ir_startino)),
-				  mp->m_ialloc_blks, flist, mp);
+		xfs_difree_inode_chunk(mp, agno, &rec, flist);
 	} else {
 		*deleted = 0;
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
