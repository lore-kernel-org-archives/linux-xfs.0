Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6140C7FFF
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:00:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 28AFC304053
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:00:18 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id BuFjKar6XmEooyXq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:00:12 -0800 (PST)
Subject: [PATCH 34/76] xfs: implement XFS_IOC_SWAPEXT when rmap btree is
	enabled
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:00:08 -0800
Message-ID: <20151219090008.12713.25755.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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

Implement extent swapping when reverse-mapping is enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c      |   17 +++++++
 fs/xfs/libxfs/xfs_rmap.c       |   91 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h |    9 ++++
 fs/xfs/xfs_bmap_util.c         |   46 ++++++++++++++------
 4 files changed, 149 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 56a84e7..34dddd3 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -33,6 +33,7 @@
 #include "xfs_cksum.h"
 #include "xfs_alloc.h"
 #include "xfs_log.h"
+#include "xfs_rmap_btree.h"
 
 /*
  * Cursor allocation zone.
@@ -4001,6 +4002,8 @@ xfs_btree_block_change_owner(
 	struct xfs_btree_block	*block;
 	struct xfs_buf		*bp;
 	union xfs_btree_ptr     rptr;
+	struct xfs_owner_info	old_oinfo, new_oinfo;
+	int			error;
 
 	/* do right sibling readahead */
 	xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
@@ -4012,6 +4015,20 @@ xfs_btree_block_change_owner(
 	else
 		block->bb_u.s.bb_owner = cpu_to_be32(new_owner);
 
+	/* change rmap owners (bmbt blocks only) */
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		XFS_RMAP_INO_BMBT_OWNER(&old_oinfo,
+				cur->bc_private.b.ip->i_ino,
+				cur->bc_private.b.whichfork);
+		XFS_RMAP_INO_BMBT_OWNER(&new_oinfo,
+				new_owner,
+				cur->bc_private.b.whichfork);
+		error = xfs_rmap_change_bmbt_owner(cur, bp, &old_oinfo,
+				&new_oinfo);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * If the block is a root block hosted in an inode, we might not have a
 	 * buffer pointer here and we shouldn't attempt to log the change as the
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 46d87315..32172d1 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -36,6 +36,7 @@
 #include "xfs_error.h"
 #include "xfs_extent_busy.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
 
 /*
  * Lookup the first record less than or equal to [bno, len, owner, offset]
@@ -1261,3 +1262,93 @@ xfs_rmap_resize(
 
 	return __xfs_rmap_add(mp, rlist, &ri);
 }
+
+/**
+ * Change ownership of a file's BMBT block reverse-mappings.
+ */
+int
+xfs_rmap_change_bmbt_owner(
+	struct xfs_btree_cur	*bcur,
+	struct xfs_buf		*bp,
+	struct xfs_owner_info	*old_owner,
+	struct xfs_owner_info	*new_owner)
+{
+	struct xfs_buf		*agfbp;
+	xfs_fsblock_t		fsbno;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	int			error;
+
+	if (!xfs_sb_version_hasrmapbt(&bcur->bc_mp->m_sb) || !bp)
+		return 0;
+
+	fsbno = XFS_DADDR_TO_FSB(bcur->bc_mp, XFS_BUF_ADDR(bp));
+	agno = XFS_FSB_TO_AGNO(bcur->bc_mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(bcur->bc_mp, fsbno);
+
+	error = xfs_read_agf(bcur->bc_mp, bcur->bc_tp, agno, 0, &agfbp);
+
+	error = xfs_rmap_free(bcur->bc_tp, agfbp, agno, agbno, 1, old_owner);
+	if (error)
+		goto err;
+
+	error = xfs_rmap_alloc(bcur->bc_tp, agfbp, agno, agbno, 1, new_owner);
+	if (error)
+		goto err;
+
+err:
+	xfs_trans_brelse(bcur->bc_tp, agfbp);
+	return error;
+}
+
+/**
+ * Change the ownership on a file's extent's reverse-mappings.
+ */
+int
+xfs_rmap_change_extent_owner(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
+	xfs_ino_t		ino,
+	xfs_fileoff_t		isize,
+	struct xfs_trans	*tp,
+	int			whichfork,
+	xfs_ino_t		new_owner,
+	struct xfs_rmap_list	*rlist)
+{
+	struct xfs_bmbt_irec	imap;
+	int			nimaps;
+	xfs_fileoff_t		offset;
+	xfs_filblks_t		len;
+	int			flags = 0;
+	int			error;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return 0;
+
+	if (whichfork == XFS_ATTR_FORK)
+		flags |= XFS_BMAPI_ATTRFORK;
+
+	offset = 0;
+	len = XFS_B_TO_FSB(mp, isize);
+	nimaps = 1;
+	error = xfs_bmapi_read(ip, offset, len, &imap, &nimaps, flags);
+	while (error == 0 && nimaps > 0) {
+		if (imap.br_startblock == HOLESTARTBLOCK ||
+		    imap.br_startblock == DELAYSTARTBLOCK)
+			goto advloop;
+
+		error = xfs_rmap_delete(mp, rlist, ino, whichfork, &imap);
+		if (error)
+			break;
+		error = xfs_rmap_insert(mp, rlist, new_owner, whichfork, &imap);
+		if (error)
+			break;
+advloop:
+		offset += imap.br_blockcount;
+		len -= imap.br_blockcount;
+		nimaps = 1;
+		error = xfs_bmapi_read(ip, offset, len, &imap, &nimaps, flags);
+	}
+
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 4fe13f3..b4e085c 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -128,4 +128,13 @@ int	xfs_rmap_finish(struct xfs_mount *mp, struct xfs_trans **tpp,
 			struct xfs_inode *ip, struct xfs_rmap_list *rlist,
 			int *committed);
 
+/* functions for changing rmap ownership */
+int xfs_rmap_change_extent_owner(struct xfs_mount *mp, struct xfs_inode *ip,
+		xfs_ino_t ino, xfs_fileoff_t isize, struct xfs_trans *tp,
+		int whichfork, xfs_ino_t new_owner,
+		struct xfs_rmap_list *rlist);
+int xfs_rmap_change_bmbt_owner(struct xfs_btree_cur *bcur, struct xfs_buf *bp,
+		struct xfs_owner_info *old_owner,
+		struct xfs_owner_info *new_owner);
+
 #endif	/* __XFS_RMAP_BTREE_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 677e3aa6..ad4eca7 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1712,6 +1712,18 @@ xfs_swap_extent_flush(
 	return 0;
 }
 
+static int
+change_extent_owner(
+	struct xfs_inode	*ip,
+	struct xfs_trans	*tp,
+	int			whichfork,
+	struct xfs_inode	*tip,
+	struct xfs_rmap_list	*rlist)
+{
+	return xfs_rmap_change_extent_owner(ip->i_mount, ip, ip->i_ino,
+			ip->i_d.di_size, tp, whichfork, tip->i_ino, rlist);
+}
+
 int
 xfs_swap_extents(
 	xfs_inode_t	*ip,	/* target inode */
@@ -1722,25 +1734,15 @@ xfs_swap_extents(
 	xfs_trans_t	*tp;
 	xfs_bstat_t	*sbp = &sxp->sx_stat;
 	xfs_ifork_t	*tempifp, *ifp, *tifp;
+	struct xfs_bmap_free	flist;
 	int		src_log_flags, target_log_flags;
 	int		error = 0;
 	int		aforkblks = 0;
 	int		taforkblks = 0;
 	__uint64_t	tmp;
 	int		lock_flags;
-
-	/*
-	 * We can't swap extents on rmap btree enabled filesystems yet
-	 * as there is no mechanism to update the owner of extents in
-	 * the rmap tree yet. Hence, for the moment, just reject attempts
-	 * to swap extents with EINVAL after emitting a warning once to remind
-	 * us this needs fixing.
-	 */
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
-		WARN_ONCE(1,
-	"XFS: XFS_IOC_SWAPEXT not supported on RMAP enabled filesystems\n");
-		return -EINVAL;
-	}
+	xfs_fsblock_t	firstfsb;
+	struct xfs_trans_res	tres = {.tr_logres = 262144, .tr_logcount = 1, .tr_logflags = 0};
 
 	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
 	if (!tempifp) {
@@ -1778,7 +1780,9 @@ xfs_swap_extents(
 		goto out_unlock;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SWAPEXT);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
+	/* XXX How do we create a potentially huge transaction here? */
+	/* error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0); */
+	error = xfs_trans_reserve(tp, &tres, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp);
 		goto out_unlock;
@@ -1878,6 +1882,20 @@ xfs_swap_extents(
 			goto out_trans_cancel;
 	}
 
+	/* Change owners in the extent rmaps */
+	xfs_bmap_init(&flist, &firstfsb);
+	error = change_extent_owner(ip, tp, XFS_DATA_FORK, tip,
+			&flist.xbf_rlist);
+	if (error)
+		goto out_trans_cancel;
+	error = change_extent_owner(tip, tp, XFS_DATA_FORK, ip,
+			&flist.xbf_rlist);
+	if (error)
+		goto out_trans_cancel;
+	error = __xfs_rmap_finish(mp, tp, &flist.xbf_rlist);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * Swap the data forks of the inodes
 	 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
