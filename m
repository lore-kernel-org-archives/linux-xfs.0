Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1480E8191
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:05:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02E2F304064
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:20 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id pQZKR3gL4pwYy8b9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:19 -0800 (PST)
Subject: [PATCH 04/53] libxfs: reorder xfs_bmap_add_free args
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:05:16 -0800
Message-ID: <20151219090516.14255.60823.stgit@birch.djwong.org>
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

Move the mount & transaction arguments to the start of xfs_bmap_add_free,
like most API calls.  The kernel version of rmap makes this change, so
porting it to xfsprogs will make maintenance easier.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_bmap.c       |   12 ++++++------
 libxfs/xfs_bmap.h       |    4 ++--
 libxfs/xfs_bmap_btree.c |    2 +-
 libxfs/xfs_ialloc.c     |    8 ++++----
 4 files changed, 13 insertions(+), 13 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 68869f6..46f8469 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -559,10 +559,10 @@ xfs_bmap_validate_ret(
  */
 void
 xfs_bmap_add_free(
+	struct xfs_mount	*mp,		/* mount point structure */
+	struct xfs_bmap_free	*flist,		/* list of extents */
 	xfs_fsblock_t		bno,		/* fs block number of extent */
-	xfs_filblks_t		len,		/* length of extent */
-	xfs_bmap_free_t		*flist,		/* list of extents */
-	xfs_mount_t		*mp)		/* mount point structure */
+	xfs_filblks_t		len)		/* length of extent */
 {
 	xfs_bmap_free_item_t	*cur;		/* current (next) element */
 	xfs_bmap_free_item_t	*new;		/* new element */
@@ -688,7 +688,7 @@ xfs_bmap_btree_to_extents(
 	cblock = XFS_BUF_TO_BLOCK(cbp);
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
-	xfs_bmap_add_free(cbno, 1, cur->bc_private.b.flist, mp);
+	xfs_bmap_add_free(mp, cur->bc_private.b.flist, cbno, 1);
 	ip->i_d.di_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -4969,8 +4969,8 @@ xfs_bmap_del_extent(
 	 * If we need to, add to list of extents to delete.
 	 */
 	if (do_fx)
-		xfs_bmap_add_free(del->br_startblock, del->br_blockcount, flist,
-			mp);
+		xfs_bmap_add_free(mp, flist, del->br_startblock,
+			del->br_blockcount);
 	/*
 	 * Adjust inode # blocks in the file.
 	 */
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 85143e5..d3daf6d 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -182,8 +182,8 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
-void	xfs_bmap_add_free(xfs_fsblock_t bno, xfs_filblks_t len,
-		struct xfs_bmap_free *flist, struct xfs_mount *mp);
+void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_bmap_free *flist,
+			  xfs_fsblock_t bno, xfs_filblks_t len);
 void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
 int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
 			int *committed);
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 52c9c75..2ef1836 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -523,7 +523,7 @@ xfs_bmbt_free_block(
 	struct xfs_trans	*tp = cur->bc_tp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 
-	xfs_bmap_add_free(fsbno, 1, cur->bc_private.b.flist, mp);
+	xfs_bmap_add_free(mp, cur->bc_private.b.flist, fsbno, 1);
 	ip->i_d.di_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 5039f4b..af670a8 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1822,9 +1822,9 @@ xfs_difree_inode_chunk(
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
-		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno,
+		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno,
 				  XFS_AGINO_TO_AGBNO(mp, rec->ir_startino)),
-				  mp->m_ialloc_blks, flist, mp);
+				  mp->m_ialloc_blks);
 		return;
 	}
 
@@ -1867,8 +1867,8 @@ xfs_difree_inode_chunk(
 
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
-		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
-				  flist, mp);
+		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, agbno),
+				  contigblk);
 
 		/* reset range to current bit and carry on... */
 		startidx = endidx = nextbit;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
