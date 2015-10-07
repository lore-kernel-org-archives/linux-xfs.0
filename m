Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3C65529E9A
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:07:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B58E2AC007
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:07:20 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id uQ50lfp4dhlESCx2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:07:19 -0700 (PDT)
Subject: [PATCH 19/51] libxfs: implement XFS_IOC_SWAPEXT when rmap btree is
	enabled
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:07:15 -0700
Message-ID: <20151007050715.1504.74080.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
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
 libxfs/xfs_btree.c      |   17 +++++++
 libxfs/xfs_rmap.c       |  112 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap_btree.h |    8 +++
 3 files changed, 137 insertions(+)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 8baaf28..000267a 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -29,6 +29,7 @@
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_alloc.h"
+#include "xfs_rmap_btree.h"
 
 /*
  * Cursor allocation zone.
@@ -3989,6 +3990,8 @@ xfs_btree_block_change_owner(
 	struct xfs_btree_block	*block;
 	struct xfs_buf		*bp;
 	union xfs_btree_ptr     rptr;
+	struct xfs_owner_info	old_oinfo, new_oinfo;
+	int			error;
 
 	/* do right sibling readahead */
 	xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
@@ -4000,6 +4003,20 @@ xfs_btree_block_change_owner(
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
index 12aac59..adc561f 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -33,6 +33,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
 
 /*
  * Lookup the first record less than or equal to [bno, len, owner, offset]
@@ -857,3 +859,113 @@ xfs_rmap_resize(
 done:
 	return error;
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
+	xfs_ino_t		new_owner)
+{
+	struct xfs_bmbt_irec	imap;
+	struct xfs_btree_cur	*cur = NULL;
+	struct xfs_buf		*agfbp = NULL;
+	int			nimaps;
+	xfs_fileoff_t		offset;
+	xfs_filblks_t		len;
+	xfs_agnumber_t		agno;
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
+		agno = XFS_FSB_TO_AGNO(mp, imap.br_startblock);
+
+		error = xfs_read_agf(mp, tp, agno, 0, &agfbp);
+		if (error)
+			break;
+
+		cur = xfs_rmapbt_init_cursor(mp, tp, agfbp, agno);
+
+		error = xfs_rmap_delete(cur, ino, whichfork, &imap);
+		if (error)
+			break;
+		error = xfs_rmap_insert(cur, new_owner, whichfork, &imap);
+		if (error)
+			break;
+
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		cur = NULL;
+		xfs_trans_brelse(tp, agfbp);
+		agfbp = NULL;
+advloop:
+		offset += imap.br_blockcount;
+		len -= imap.br_blockcount;
+		nimaps = 1;
+		error = xfs_bmapi_read(ip, offset, len, &imap, &nimaps, flags);
+	}
+
+	if (cur)
+		xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR :
+					  XFS_BTREE_NOERROR);
+	if (agfbp)
+		xfs_trans_brelse(tp, agfbp);
+	return error;
+}
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index 0131d9a..5d248b5 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -88,4 +88,12 @@ int xfs_rmap_slide(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
 int xfs_rmap_resize(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
 		struct xfs_bmbt_irec *PREV, long size_adj);
 
+/* functions for changing rmap ownership */
+int xfs_rmap_change_extent_owner(struct xfs_mount *mp, struct xfs_inode *ip,
+		xfs_ino_t ino, xfs_fileoff_t isize, struct xfs_trans *tp,
+		int whichfork, xfs_ino_t new_owner);
+int xfs_rmap_change_bmbt_owner(struct xfs_btree_cur *bcur, struct xfs_buf *bp,
+		struct xfs_owner_info *old_owner,
+		struct xfs_owner_info *new_owner);
+
 #endif	/* __XFS_RMAP_BTREE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
