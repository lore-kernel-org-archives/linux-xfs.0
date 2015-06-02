Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 266887F66
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B7680AC007
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QS62hEU0lEyTzHL3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:05 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id AFD49B6E65
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:05 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig59Z010523
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 28/28] metadump: support sparse inode records
Date: Tue,  2 Jun 2015 14:42:01 -0400
Message-Id: <1433270521-62026-29-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
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

xfs_metadump currently uses mp->m_ialloc_blks sized buffers to copy
inode chunks. If a filesystem supports sparse inodes, some clusters
within inode chunks can point to arbitrary data. If the buffer used to
read inodes includes these sparse clusters, inode read verification
fails and prints filesystem corruption warnings.

Update copy_inode_chunks() to support using a cluster sized buffer to
read a full inode chunk in multiple iterations if sparse inodes is
enabled. For each cluster read, check whether the first inode in the
cluster is sparse and skip the cluster if so. This is safe because
sparse records are allocated at cluster granularity.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 db/metadump.c | 83 ++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 60 insertions(+), 23 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index e101501..5391c4c 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1830,13 +1830,43 @@ copy_inode_chunk(
 	xfs_agino_t 		agino;
 	int			off;
 	xfs_agblock_t		agbno;
+	xfs_agblock_t		end_agbno;
 	int			i;
 	int			rval = 0;
+	int			blks_per_buf;
+	int			inodes_per_buf;
+	int			ioff;
 
 	agino = be32_to_cpu(rp->ir_startino);
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
+	end_agbno = agbno + mp->m_ialloc_blks;
 	off = XFS_INO_TO_OFFSET(mp, agino);
 
+	/*
+	 * If the fs supports sparse inode records, we must process inodes a
+	 * cluster at a time because that is the sparse allocation granularity.
+	 * Otherwise, we risk CRC corruption errors on reads of inode chunks.
+	 *
+	 * Also make sure that that we don't process more than the single record
+	 * we've been passed (large block sizes can hold multiple inode chunks).
+	 */
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+		blks_per_buf = xfs_icluster_size_fsb(mp);
+	else
+		blks_per_buf = mp->m_ialloc_blks;
+	inodes_per_buf = min(blks_per_buf << mp->m_sb.sb_inopblog,
+			     XFS_INODES_PER_CHUNK);
+
+	/*
+	 * Sanity check that we only process a single buffer if ir_startino has
+	 * a buffer offset. A non-zero offset implies that the entire chunk lies
+	 * within a block.
+	 */
+	if (off && inodes_per_buf != XFS_INODES_PER_CHUNK) {
+		print_warning("bad starting inode offset %d", off);
+		return 0;
+	}
+
 	if (agino == 0 || agino == NULLAGINO || !valid_bno(agno, agbno) ||
 			!valid_bno(agno, XFS_AGINO_TO_AGBNO(mp,
 					agino + XFS_INODES_PER_CHUNK - 1))) {
@@ -1863,36 +1893,43 @@ copy_inode_chunk(
 	}
 
 	push_cur();
-	set_cur(&typtab[TYP_INODE], XFS_AGB_TO_DADDR(mp, agno, agbno),
-			XFS_FSB_TO_BB(mp, mp->m_ialloc_blks),
-			DB_RING_IGN, NULL);
-	if (iocur_top->data == NULL) {
-		print_warning("cannot read inode block %u/%u", agno, agbno);
-		rval = !stop_on_read_error;
-		goto pop_out;
-	}
 
-	/*
-	 * scan through inodes and copy any btree extent lists, directory
-	 * contents and extended attributes.
-	 */
-	for (i = 0; i < XFS_INODES_PER_CHUNK; i++) {
-		xfs_dinode_t            *dip;
+	ioff = 0;
+	while (agbno < end_agbno && ioff < XFS_INODES_PER_CHUNK) {
+		if (XFS_INOBT_IS_SPARSE_DISK(rp, ioff))
+			goto next_bp;
+
+		set_cur(&typtab[TYP_INODE], XFS_AGB_TO_DADDR(mp, agno, agbno),
+			XFS_FSB_TO_BB(mp, blks_per_buf), DB_RING_IGN, NULL);
+		if (iocur_top->data == NULL) {
+			print_warning("cannot read inode block %u/%u",
+				      agno, agbno);
+			rval = !stop_on_read_error;
+			goto pop_out;
+		}
 
-		if (XFS_INOBT_IS_FREE_DISK(rp, i))
-			continue;
+		for (i = 0; i < inodes_per_buf; i++) {
+			xfs_dinode_t	*dip;
 
-		dip = (xfs_dinode_t *)((char *)iocur_top->data +
+			if (XFS_INOBT_IS_FREE_DISK(rp, ioff + i))
+				continue;
+
+			dip = (xfs_dinode_t *)((char *)iocur_top->data +
 				((off + i) << mp->m_sb.sb_inodelog));
 
-		if (!process_inode(agno, agino + i, dip))
-			goto pop_out;
-	}
+			if (!process_inode(agno, agino + ioff + i, dip))
+				goto pop_out;
 
-	if (write_buf(iocur_top))
-		goto pop_out;
+			inodes_copied++;
+		}
 
-	inodes_copied += XFS_INODES_PER_CHUNK;
+		if (write_buf(iocur_top))
+			goto pop_out;
+
+next_bp:
+		agbno += blks_per_buf;
+		ioff += inodes_per_buf;
+	}
 
 	if (show_progress)
 		print_progress("Copied %u of %u inodes (%u of %u AGs)",
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
