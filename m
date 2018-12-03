Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36686 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbeLCXBf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Dec 2018 18:01:35 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_db: teach the frag command about sparse inode chunks
Message-ID: <d1f68754-46e9-e3d1-c8cc-e76d4accf974@redhat.com>
Date: Mon, 3 Dec 2018 17:01:33 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Matthias Bodenbinder <matthias@bodenbinder.de>

This is the equivalent of:

ea8a48f xfs_check: process sparse inode chunks correctly

for the frag_f() command in xfs_db.

Without this, the xfs_db frag command shows corruption as it
wanders into blocks that are not inodes.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201823
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/frag.c b/db/frag.c
index 6792d47..5f33cb7 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -466,29 +466,56 @@ scanfunc_ino(
 	int			off;
 	xfs_inobt_ptr_t		*pp;
 	xfs_inobt_rec_t		*rp;
+	xfs_agblock_t		agbno;
+	xfs_agblock_t		end_agbno;
+	struct xfs_dinode	*dip;
+	int			blks_per_buf;
+	int			inodes_per_buf;
+	int			ioff;
+
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+		blks_per_buf = xfs_icluster_size_fsb(mp);
+	else
+		blks_per_buf = mp->m_ialloc_blks;
+	inodes_per_buf = min(blks_per_buf << mp->m_sb.sb_inopblog,
+			     XFS_INODES_PER_CHUNK);
 
 	if (level == 0) {
 		rp = XFS_INOBT_REC_ADDR(mp, block, 1);
 		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
 			agino = be32_to_cpu(rp[i].ir_startino);
-			off = XFS_INO_TO_OFFSET(mp, agino);
+			agbno = XFS_AGINO_TO_AGBNO(mp, agino);
+			off = XFS_AGINO_TO_OFFSET(mp, agino);
+			end_agbno = agbno + mp->m_ialloc_blks;
+
 			push_cur();
-			set_cur(&typtab[TYP_INODE],
-				XFS_AGB_TO_DADDR(mp, seqno,
-						 XFS_AGINO_TO_AGBNO(mp, agino)),
-				XFS_FSB_TO_BB(mp, mp->m_ialloc_blks),
-				DB_RING_IGN, NULL);
-			if (iocur_top->data == NULL) {
-				dbprintf(_("can't read inode block %u/%u\n"),
-					seqno, XFS_AGINO_TO_AGBNO(mp, agino));
-				continue;
-			}
-			for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
-				if (XFS_INOBT_IS_FREE_DISK(&rp[i], j))
-					continue;
-				process_inode(agf, agino + j, (xfs_dinode_t *)
-					((char *)iocur_top->data +
-					((off + j) << mp->m_sb.sb_inodelog)));
+			ioff = 0;
+			while (agbno < end_agbno &&
+			       ioff < XFS_INODES_PER_CHUNK) {
+				if (xfs_inobt_is_sparse_disk(&rp[i], ioff))
+					goto next_buf;
+
+				set_cur(&typtab[TYP_INODE],
+					XFS_AGB_TO_DADDR(mp, seqno, agbno),
+					XFS_FSB_TO_BB(mp, blks_per_buf),
+					DB_RING_IGN, NULL);
+				if (iocur_top->data == NULL) {
+					dbprintf(_("can't read inode block %u/%u\n"),
+						 seqno, agbno);
+					goto next_buf;
+				}
+
+				for (j = 0; j < inodes_per_buf; j++) {
+					if (XFS_INOBT_IS_FREE_DISK(&rp[i], ioff + j))
+						goto next_buf;
+					dip = (xfs_dinode_t *)((char *)iocur_top->data +
+						((off + j) << mp->m_sb.sb_inodelog));
+					process_inode(agf, agino + ioff + j, dip);
+				}
+
+next_buf:
+				agbno += blks_per_buf;
+				ioff += inodes_per_buf;
 			}
 			pop_cur();
 		}
