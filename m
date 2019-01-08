Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44888 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728644AbfAHUdW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 15:33:22 -0500
Subject: [PATCH 6/7] xfs: scrub big block inode btrees correctly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 08 Jan 2019 12:33:12 -0800
Message-ID: <154697959265.2494.12997637561160260241.stgit@magnolia>
In-Reply-To: <154697955494.2494.5221420762912855354.stgit@magnolia>
References: <154697955494.2494.5221420762912855354.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach scrub how to handle the case that there are one or more inobt
records covering a given inode cluster.  This fixes the operation on big
block filesystems (e.g. 64k blocks, 512 byte inodes).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 708f6607db71..1929d79ea6b3 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -162,6 +162,7 @@ xchk_iallocbt_check_cluster_ifree(
 	xfs_ino_t			fsino;
 	xfs_agino_t			agino;
 	unsigned int			offset;
+	unsigned int			cluster_buf_base;
 	bool				irec_free;
 	bool				ino_inuse;
 	bool				freemask_ok;
@@ -174,10 +175,17 @@ xchk_iallocbt_check_cluster_ifree(
 	 * Given an inobt record, an offset of a cluster within the record, and
 	 * an offset of an inode within a cluster, compute which fs inode we're
 	 * talking about and the offset of that inode within the buffer.
+	 *
+	 * Be careful about inobt records that don't align with the start of
+	 * the inode buffer when block sizes are large enough to hold multiple
+	 * inode chunks.  When this happens, cluster_base will be zero but
+	 * ir_startino can be large enough to make cluster_buf_base nonzero.
 	 */
 	agino = irec->ir_startino + cluster_base + cluster_index;
 	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
-	offset = cluster_index * mp->m_sb.sb_inodesize;
+	cluster_buf_base = XFS_INO_TO_OFFSET(mp, irec->ir_startino);
+	ASSERT(cluster_buf_base == 0 || cluster_base == 0);
+	offset = (cluster_buf_base + cluster_index) * mp->m_sb.sb_inodesize;
 	if (offset >= BBTOB(cluster_bp->b_length)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		goto out;
