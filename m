Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A9DCD29E05
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 22:17:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7C39D8F8039
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 20:17:07 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	urPUTN9blpNum0rT for <xfs@oss.sgi.com>;
	Mon, 07 Mar 2016 20:17:05 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ad94T-0004A7-0h
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:33 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ad94G-0007uI-F8
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/16] libxfs: rearrange xfs_bmap_add_free parameters
Date: Tue,  8 Mar 2016 15:16:06 +1100
Message-Id: <1457410578-30233-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1457410578-30233-1-git-send-email-david@fromorbit.com>
References: <1457410578-30233-1-git-send-email-david@fromorbit.com>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

The order is different to convention, making it a bit strange.
Reorder it according to convention before we start adding new
parameters.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 12 ++++++------
 fs/xfs/libxfs/xfs_bmap.h       |  4 ++--
 fs/xfs/libxfs/xfs_bmap_btree.c |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c     |  9 ++++-----
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cb58d72..7aef8d8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -573,10 +573,10 @@ xfs_bmap_validate_ret(
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
@@ -702,7 +702,7 @@ xfs_bmap_btree_to_extents(
 	cblock = XFS_BUF_TO_BLOCK(cbp);
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
-	xfs_bmap_add_free(cbno, 1, cur->bc_private.b.flist, mp);
+	xfs_bmap_add_free(mp, cur->bc_private.b.flist, cbno, 1);
 	ip->i_d.di_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -5016,8 +5016,8 @@ xfs_bmap_del_extent(
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
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 423a34e..e081c76 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -191,8 +191,8 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
-void	xfs_bmap_add_free(xfs_fsblock_t bno, xfs_filblks_t len,
-		struct xfs_bmap_free *flist, struct xfs_mount *mp);
+void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_bmap_free *flist,
+			  xfs_fsblock_t bno, xfs_filblks_t len);
 void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
 int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
 			struct xfs_inode *ip);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 6282f6e..db0c71e 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -526,7 +526,7 @@ xfs_bmbt_free_block(
 	struct xfs_trans	*tp = cur->bc_tp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 
-	xfs_bmap_add_free(fsbno, 1, cur->bc_private.b.flist, mp);
+	xfs_bmap_add_free(mp, cur->bc_private.b.flist, fsbno, 1);
 	ip->i_d.di_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 22297f9..e3c0af7 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1828,9 +1828,8 @@ xfs_difree_inode_chunk(
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
-		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno,
-				  XFS_AGINO_TO_AGBNO(mp, rec->ir_startino)),
-				  mp->m_ialloc_blks, flist, mp);
+		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, sagbno),
+				  mp->m_ialloc_blks);
 		return;
 	}
 
@@ -1873,8 +1872,8 @@ xfs_difree_inode_chunk(
 
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
-		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
-				  flist, mp);
+		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, agbno),
+				  contigblk);
 
 		/* reset range to current bit and carry on... */
 		startidx = endidx = nextbit;
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
