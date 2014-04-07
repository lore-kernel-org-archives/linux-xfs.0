Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1FE2A7F92
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:59:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 82740AC014
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:59:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dZlgVuVHrZpq1rEV for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:59:08 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 03/19] xfs: remove unused mp arg from xfs_bmdr_maxrecs()
Date: Mon,  7 Apr 2014 14:58:50 -0500
Message-Id: <1396900746-22201-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
References: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
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

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_bmap.c       |    2 +-
 fs/xfs/xfs_bmap_btree.c |    8 +++-----
 fs/xfs/xfs_bmap_btree.h |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index b308097..eeb673b 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -94,7 +94,7 @@ xfs_bmap_compute_maxlevels(
 		maxleafents = MAXAEXTNUM;
 		sz = XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	}
-	maxrootrecs = xfs_bmdr_maxrecs(mp, sz, 0);
+	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
 	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index 706bc3f..a9d6b7b 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -84,7 +84,7 @@ xfs_bmdr_to_bmbt(
 	rblock->bb_level = dblock->bb_level;
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
 	rblock->bb_numrecs = dblock->bb_numrecs;
-	dmxr = xfs_bmdr_maxrecs(mp, dblocklen, 0);
+	dmxr = xfs_bmdr_maxrecs(dblocklen, 0);
 	fkp = XFS_BMDR_KEY_ADDR(dblock, 1);
 	tkp = XFS_BMBT_KEY_ADDR(mp, rblock, 1);
 	fpp = XFS_BMDR_PTR_ADDR(dblock, 1, dmxr);
@@ -443,7 +443,7 @@ xfs_bmbt_to_bmdr(
 	ASSERT(rblock->bb_level != 0);
 	dblock->bb_level = rblock->bb_level;
 	dblock->bb_numrecs = rblock->bb_numrecs;
-	dmxr = xfs_bmdr_maxrecs(mp, dblocklen, 0);
+	dmxr = xfs_bmdr_maxrecs(dblocklen, 0);
 	fkp = XFS_BMBT_KEY_ADDR(mp, rblock, 1);
 	tkp = XFS_BMDR_KEY_ADDR(dblock, 1);
 	fpp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, rblocklen);
@@ -672,8 +672,7 @@ xfs_bmbt_get_dmaxrecs(
 {
 	if (level != cur->bc_nlevels - 1)
 		return cur->bc_mp->m_bmap_dmxr[level != 0];
-	return xfs_bmdr_maxrecs(cur->bc_mp, cur->bc_private.b.forksize,
-				level == 0);
+	return xfs_bmdr_maxrecs(cur->bc_private.b.forksize, level == 0);
 }
 
 STATIC void
@@ -914,7 +913,6 @@ xfs_bmbt_maxrecs(
  */
 int
 xfs_bmdr_maxrecs(
-	struct xfs_mount	*mp,
 	int			blocklen,
 	int			leaf)
 {
diff --git a/fs/xfs/xfs_bmap_btree.h b/fs/xfs/xfs_bmap_btree.h
index 6e42e1e..819a8a4 100644
--- a/fs/xfs/xfs_bmap_btree.h
+++ b/fs/xfs/xfs_bmap_btree.h
@@ -130,7 +130,7 @@ extern void xfs_bmbt_to_bmdr(struct xfs_mount *, struct xfs_btree_block *, int,
 			xfs_bmdr_block_t *, int);
 
 extern int xfs_bmbt_get_maxrecs(struct xfs_btree_cur *, int level);
-extern int xfs_bmdr_maxrecs(struct xfs_mount *, int blocklen, int leaf);
+extern int xfs_bmdr_maxrecs(int blocklen, int leaf);
 extern int xfs_bmbt_maxrecs(struct xfs_mount *, int blocklen, int leaf);
 
 extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
