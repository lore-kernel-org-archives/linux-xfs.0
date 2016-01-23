Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0079D7F61
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 18:35:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 81845AC004
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:35:29 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id SpeHJsnRWVs0pViN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:35:27 -0800 (PST)
Subject: [PATCH 4/5] xfs_db: don't error out when blocksize > 64 * inodesize
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Jan 2016 16:35:25 -0800
Message-ID: <20160123003525.2475.44264.stgit@birch.djwong.org>
In-Reply-To: <20160123003502.2475.99558.stgit@birch.djwong.org>
References: <20160123003502.2475.99558.stgit@birch.djwong.org>
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

When the block size is large enough that multiple inode chunks can fit
in a single block (e.g. 64k blocks, 512 byte inodes) we must calculate
the per-chunk block size and the buffer offset correctly so that check
actually examines the correct metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)


diff --git a/db/check.c b/db/check.c
index 838db53..4e2768e 100644
--- a/db/check.c
+++ b/db/check.c
@@ -4386,6 +4386,7 @@ scanfunc_ino(
 	__u16			holemask;
 	xfs_agino_t		rino;
 	xfs_extlen_t		cblocks;
+	int			bufoff;
 
 	if (be32_to_cpu(block->bb_magic) != XFS_IBT_MAGIC &&
 	    be32_to_cpu(block->bb_magic) != XFS_IBT_CRC_MAGIC) {
@@ -4455,6 +4456,8 @@ scanfunc_ino(
 				rino = agino + startidx;
 				cblocks = (endidx - startidx) >>
 						mp->m_sb.sb_inopblog;
+				if (cblocks == 0)
+					cblocks = 1;
 
 				/* Check the sparse chunk alignment */
 				if (sparse &&
@@ -4468,8 +4471,9 @@ scanfunc_ino(
 				}
 
 				/* Check the block map */
-				set_dbmap(seqno, XFS_AGINO_TO_AGBNO(mp, rino),
-					cblocks, DBM_INODE, seqno, bno);
+				if (XFS_AGINO_TO_OFFSET(mp, rino) == 0)
+					set_dbmap(seqno, XFS_AGINO_TO_AGBNO(mp, rino),
+						cblocks, DBM_INODE, seqno, bno);
 
 				push_cur();
 				set_cur(&typtab[TYP_INODE],
@@ -4489,14 +4493,15 @@ scanfunc_ino(
 				}
 
 				/* Examine each inode in this chunk */
-				for (j = startidx; j < endidx; j++) {
+				bufoff = ((XFS_AGINO_TO_OFFSET(mp, rino) - startidx) << mp->m_sb.sb_inodelog);
+				for (j = startidx; j < endidx; j++, bufoff += (1 << mp->m_sb.sb_inodelog)) {
 					if (ino_issparse(&rp[i], j))
 						continue;
 					isfree = XFS_INOBT_IS_FREE_DISK(&rp[i], j);
 					if (isfree)
 						nfree++;
 					process_inode(agf, agino + j,
-						(xfs_dinode_t *)((char *)iocur_top->data + ((j - startidx) << mp->m_sb.sb_inodelog)),
+						(xfs_dinode_t *)((char *)iocur_top->data + bufoff),
 							isfree);
 				}
 				pop_cur();

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
