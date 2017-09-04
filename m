Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39844 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753120AbdIDBSG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 21:18:06 -0400
Date: Sun, 3 Sep 2017 18:17:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/2] misc: fix more stupid compiler warnings
Message-ID: <20170904011757.GC4671@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Fix more compiler warnings about pointless checks, unchecked return
values, brace problems, and missing parentheses.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c           |    2 --
 libxfs/libxfs_priv.h |    4 ++--
 libxfs/xfs_bmap.c    |    2 +-
 repair/phase6.c      |    4 ----
 repair/rmap.c        |    2 +-
 5 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/db/check.c b/db/check.c
index 12a0aed..6076540 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3220,9 +3220,7 @@ process_leaf_node_dir_v2_free(
 		return;
 	}
 	if (be32_to_cpu(free->hdr.nvalid) > maxent ||
-				be32_to_cpu(free->hdr.nvalid) < 0 ||
 				be32_to_cpu(free->hdr.nused) > maxent ||
-				be32_to_cpu(free->hdr.nused) < 0 ||
 				be32_to_cpu(free->hdr.nused) >
 					be32_to_cpu(free->hdr.nvalid)) {
 		if (!sflag || v)
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 19bdbdb..94804fe 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -504,8 +504,8 @@ int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 
 /* xfs_icache.c */
-#define xfs_inode_set_cowblocks_tag(ip)
-#define xfs_inode_set_eofblocks_tag(ip)
+#define xfs_inode_set_cowblocks_tag(ip)	do { } while (0)
+#define xfs_inode_set_eofblocks_tag(ip)	do { } while (0)
 
 /* xfs_stats.h */
 #define XFS_STATS_CALC_INDEX(member)	0
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 31a631a..ab5853d 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -570,7 +570,7 @@ xfs_bmap_validate_ret(
 
 #else
 #define xfs_bmap_check_leaf_extents(cur, ip, whichfork)		do { } while (0)
-#define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)
+#define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)	do { } while (0)
 #endif /* DEBUG */
 
 /*
diff --git a/repair/phase6.c b/repair/phase6.c
index b051a44..8fdf8e5 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3082,8 +3082,6 @@ mark_standalone_inodes(xfs_mount_t *mp)
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rbmino),
 			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rbmino));
 
-	ASSERT(irec != NULL);
-
 	offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rbmino) -
 			irec->ino_startnum;
 
@@ -3095,8 +3093,6 @@ mark_standalone_inodes(xfs_mount_t *mp)
 	offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rsumino) -
 			irec->ino_startnum;
 
-	ASSERT(irec != NULL);
-
 	add_inode_reached(irec, offset);
 
 	if (fs_quotas)  {
diff --git a/repair/rmap.c b/repair/rmap.c
index 9710565..07d1ba8 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1542,7 +1542,7 @@ rmap_populate_realtime_rmapbt(
 		imap.br_startoff = rm_rec->rm_offset;
 		imap.br_startblock = rm_rec->rm_startblock;
 		imap.br_blockcount = rm_rec->rm_blockcount;
-		imap.br_state = (rm_rec->rm_flags & XFS_RMAP_UNWRITTEN ?
+		imap.br_state = ((rm_rec->rm_flags & XFS_RMAP_UNWRITTEN) ?
 				XFS_EXT_UNWRITTEN : XFS_EXT_NORM);
 		fakei.i_ino = rm_rec->rm_owner;
 		error = -libxfs_rmap_map_extent(mp, &dfops, &fakei,
