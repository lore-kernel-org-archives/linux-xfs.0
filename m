Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 449AD7FDF
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 11:11:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 260A5304066
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:11:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QiUj92qgHkYbd5Yf for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:11:14 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3AGBDRT009772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:11:14 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s3AGBC6C000750
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:11:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 15/20] xfsprogs/repair: pass btree block magic as param to
	build_ino_tree()
Date: Thu, 10 Apr 2014 12:11:05 -0400
Message-Id: <1397146270-42993-16-git-send-email-bfoster@redhat.com>
In-Reply-To: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
References: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
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

A minor cleanup to build_ino_tree() to provide the appropriate
magic value for btree block initialization from the caller. This
facilitates use of separate magic values for finobt blocks when
building the free inode btree.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/phase5.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index 77eb125..10ed1eb 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1097,7 +1097,7 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
  */
 static void
 build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
-		bt_status_t *btree_curs)
+		bt_status_t *btree_curs, __uint32_t magic)
 {
 	xfs_agnumber_t		i;
 	xfs_agblock_t		j;
@@ -1135,11 +1135,11 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
-			xfs_btree_init_block(mp, lptr->buf_p, XFS_IBT_CRC_MAGIC,
+			xfs_btree_init_block(mp, lptr->buf_p, magic,
 						i, 0, agno,
 						XFS_BTREE_CRC_BLOCKS);
 		else
-			xfs_btree_init_block(mp, lptr->buf_p, XFS_IBT_MAGIC,
+			xfs_btree_init_block(mp, lptr->buf_p, magic,
 						i, 0, agno, 0);
 	}
 
@@ -1166,11 +1166,11 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
-			xfs_btree_init_block(mp, lptr->buf_p, XFS_IBT_CRC_MAGIC,
+			xfs_btree_init_block(mp, lptr->buf_p, magic,
 						0, 0, agno,
 						XFS_BTREE_CRC_BLOCKS);
 		else
-			xfs_btree_init_block(mp, lptr->buf_p, XFS_IBT_MAGIC,
+			xfs_btree_init_block(mp, lptr->buf_p, magic,
 						0, 0, agno, 0);
 
 		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
@@ -1483,6 +1483,7 @@ phase5_func(
 	xfs_extlen_t	freeblks2;
 #endif
 	xfs_agblock_t	num_extents;
+	__uint32_t	magic;
 
 	if (verbose)
 		do_log(_("        - agno = %d\n"), agno);
@@ -1616,7 +1617,9 @@ phase5_func(
 		/*
 		 * build inode allocation tree.  this also build the agi
 		 */
-		build_ino_tree(mp, agno, &ino_btree_curs);
+		magic = xfs_sb_version_hascrc(&mp->m_sb) ?
+				XFS_IBT_CRC_MAGIC : XFS_IBT_MAGIC;
+		build_ino_tree(mp, agno, &ino_btree_curs, magic);
 		write_cursor(&ino_btree_curs);
 		/*
 		 * tear down cursors
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
