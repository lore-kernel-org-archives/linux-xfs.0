Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 99A327CA0
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 00:45:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F3B5EAC006
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 22:45:39 -0700 (PDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
	by cuda.sgi.com with ESMTP id jkH8lZgn3kkeNfLs (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Jun 2016 22:45:36 -0700 (PDT)
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH] xfs: simplify the calculation of tpp at xfs_bmdr_to_bmbt
Date: Fri, 24 Jun 2016 13:39:20 +0800
Message-ID: <1466746760-155962-1-git-send-email-houtao1@huawei.com>
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
To: xfs@oss.sgi.com
Cc: miaoxie@huawei.com, fangwei1@huawei.com

remove the usage of rblocklen at xfs_bmdr_to_bmbt, and
use be16_to_cpu(dblock->bb_numrecs) instead. It also
reduces an extra calculation.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/libxfs/xfs_bmap_btree.c | 5 ++---
 fs/xfs/libxfs/xfs_bmap_btree.h | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 6282f6e..452cad9 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -59,8 +59,7 @@ xfs_bmdr_to_bmbt(
 	struct xfs_inode	*ip,
 	xfs_bmdr_block_t	*dblock,
 	int			dblocklen,
-	struct xfs_btree_block	*rblock,
-	int			rblocklen)
+	struct xfs_btree_block	*rblock)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	int			dmxr;
@@ -85,8 +84,8 @@ xfs_bmdr_to_bmbt(
 	fkp = XFS_BMDR_KEY_ADDR(dblock, 1);
 	tkp = XFS_BMBT_KEY_ADDR(mp, rblock, 1);
 	fpp = XFS_BMDR_PTR_ADDR(dblock, 1, dmxr);
-	tpp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, rblocklen);
 	dmxr = be16_to_cpu(dblock->bb_numrecs);
+	tpp = XFS_BMBT_PTR_ADDR(mp, rblock, 1, dmxr);
 	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
 	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
 }
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 819a8a4..b1d30f7 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -105,7 +105,7 @@ struct xfs_trans;
  * Prototypes for xfs_bmap.c to call.
  */
 extern void xfs_bmdr_to_bmbt(struct xfs_inode *, xfs_bmdr_block_t *, int,
-			struct xfs_btree_block *, int);
+			struct xfs_btree_block *);
 extern void xfs_bmbt_get_all(xfs_bmbt_rec_host_t *r, xfs_bmbt_irec_t *s);
 extern xfs_filblks_t xfs_bmbt_get_blockcount(xfs_bmbt_rec_host_t *r);
 extern xfs_fsblock_t xfs_bmbt_get_startblock(xfs_bmbt_rec_host_t *r);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index bbcc8c7..23967aa 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -433,7 +433,7 @@ xfs_iformat_btree(
 	 * to the in-memory structure.
 	 */
 	xfs_bmdr_to_bmbt(ip, dfp, XFS_DFORK_SIZE(dip, ip->i_mount, whichfork),
-			 ifp->if_broot, size);
+			 ifp->if_broot);
 	ifp->if_flags &= ~XFS_IFEXTENTS;
 	ifp->if_flags |= XFS_IFBROOT;
 
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
