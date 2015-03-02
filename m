Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D02747F6A
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 07:28:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 694CDAC002
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 05:28:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BjiBUVOazMiumLBU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 05:28:10 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t22DS9gn008926
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 2 Mar 2015 08:28:10 -0500
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t22DS98D012624
	for <xfs@oss.sgi.com>; Mon, 2 Mar 2015 08:28:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v6 16/18] xfs: only free allocated regions of inode chunks
Date: Mon,  2 Mar 2015 08:28:06 -0500
Message-Id: <1425302888-4962-17-git-send-email-bfoster@redhat.com>
In-Reply-To: <1425302888-4962-1-git-send-email-bfoster@redhat.com>
References: <1425302888-4962-1-git-send-email-bfoster@redhat.com>
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
 fs/xfs/libxfs/xfs_ialloc.c | 81 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 6451a80..47be76e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1801,6 +1801,83 @@ out_error:
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
+	int		startidx, endidx;
+	int		nextbit;
+	xfs_agblock_t	agbno;
+	int		contigblk;
+	DECLARE_BITMAP(holemask, XFS_INOBT_HOLEMASK_BITS);
+
+	if (!xfs_inobt_issparse(rec->ir_holemask)) {
+		/* not sparse, calculate extent info directly */
+		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno,
+				  XFS_AGINO_TO_AGBNO(mp, rec->ir_startino)),
+				  mp->m_ialloc_blks, flist, mp);
+		return;
+	}
+
+	/* holemask is only 16-bits (fits in an unsigned long) */
+	ASSERT(sizeof(rec->ir_holemask) <= sizeof(holemask[0]));
+	holemask[0] = rec->ir_holemask;
+
+	/*
+	 * Find contiguous ranges of zeroes (i.e., allocated regions) in the
+	 * holemask and convert the start/end index of each range to an extent.
+	 * We start with the start and end index both pointing at the first 0 in
+	 * the mask.
+	 */
+	startidx = endidx = find_first_zero_bit(holemask,
+						XFS_INOBT_HOLEMASK_BITS);
+	nextbit = startidx + 1;
+	while (startidx < XFS_INOBT_HOLEMASK_BITS) {
+		nextbit = find_next_zero_bit(holemask, XFS_INOBT_HOLEMASK_BITS,
+					     nextbit);
+		/*
+		 * If the next zero bit is contiguous, update the end index of
+		 * the current range and continue.
+		 */
+		if (nextbit != XFS_INOBT_HOLEMASK_BITS &&
+		    nextbit == endidx + 1) {
+			endidx = nextbit;
+			goto next;
+		}
+
+		/*
+		 * nextbit is not contiguous with the current end index. Convert
+		 * the current start/end to an extent and add it to the free
+		 * list.
+		 */
+		agbno = sagbno + (startidx * XFS_INODES_PER_HOLEMASK_BIT) /
+				  mp->m_sb.sb_inopblock;
+		contigblk = ((endidx - startidx + 1) *
+			     XFS_INODES_PER_HOLEMASK_BIT) /
+			    mp->m_sb.sb_inopblock;
+
+		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
+		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
+		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
+				  flist, mp);
+
+		/* reset range to current bit and carry on... */
+		startidx = endidx = nextbit;
+
+next:
+		nextbit++;
+	}
+}
+
 STATIC int
 xfs_difree_inobt(
 	struct xfs_mount		*mp,
@@ -1895,9 +1972,7 @@ xfs_difree_inobt(
 			goto error0;
 		}
 
-		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno,
-				  XFS_AGINO_TO_AGBNO(mp, rec.ir_startino)),
-				  mp->m_ialloc_blks, flist, mp);
+		xfs_difree_inode_chunk(mp, agno, &rec, flist);
 	} else {
 		*deleted = 0;
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
