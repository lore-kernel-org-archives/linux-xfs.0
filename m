Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2CC9829E08
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:07:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0416D30405F
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:07:02 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 2BMcCaDCYipMZyN7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:07:01 -0800 (PST)
Subject: [PATCH 19/53] libxfs: implement XFS_IOC_SWAPEXT when rmap btree is
	enabled
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:06:59 -0800
Message-ID: <20151219090659.14255.44463.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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

Synchronize the libxfs components of the kernel patch.  No code
in xfsprogs actually calls this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_btree.c      |   17 +++++++++
 libxfs/xfs_rmap.c       |   90 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap_btree.h |    9 +++++
 3 files changed, 116 insertions(+)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 9b918d2..1622ddd 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -29,6 +29,7 @@
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_alloc.h"
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
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 43354b9..5ae4c1e 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -1260,3 +1260,93 @@ xfs_rmap_resize(
 
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
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index 4fe13f3..b4e085c 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
