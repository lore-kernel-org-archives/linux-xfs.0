Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE4B229E01
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:34:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB91D304051
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 15:34:48 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id AUEsDW0TTjRyctHQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 15:34:47 -0700 (PDT)
Subject: [PATCH 16/24] xfs: copy-on-write reflinked blocks when zeroing
	ranges of blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 Jul 2015 15:34:41 -0700
Message-ID: <20150729223441.17414.70951.stgit@birch.djwong.org>
In-Reply-To: <20150729223258.17414.91354.stgit@birch.djwong.org>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
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

When we're writing zeroes to a reflinked block (such as when we're
punching a reflinked range), we need to fork the the block and write
to that, otherwise we can corrupt the other reflinks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   25 +++++++-
 fs/xfs/xfs_reflink.c   |  156 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h   |    6 ++
 3 files changed, 185 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 17975fe..345ea79 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -40,6 +40,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_log.h"
+#include "xfs_reflink.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -1087,7 +1088,9 @@ xfs_zero_remaining_bytes(
 	xfs_buf_t		*bp;
 	xfs_mount_t		*mp = ip->i_mount;
 	int			nimap;
-	int			error = 0;
+	int			error = 0, err2;
+	bool			should_fork;
+	struct xfs_trans	*tp;
 
 	/*
 	 * Avoid doing I/O beyond eof - it's not necessary
@@ -1128,8 +1131,14 @@ xfs_zero_remaining_bytes(
 		if (lastoffset > endoff)
 			lastoffset = endoff;
 
+		/* Do we need to CoW this block? */
+		error = xfs_reflink_should_fork_block(ip, &imap, offset,
+				&should_fork);
+		if (error)
+			return error;
+
 		/* DAX can just zero the backing device directly */
-		if (IS_DAX(VFS_I(ip))) {
+		if (IS_DAX(VFS_I(ip)) && !should_fork) {
 			error = dax_zero_page_range(VFS_I(ip), offset,
 						    lastoffset - offset + 1,
 						    xfs_get_blocks_direct);
@@ -1150,10 +1159,22 @@ xfs_zero_remaining_bytes(
 				(offset - XFS_FSB_TO_B(mp, imap.br_startoff)),
 		       0, lastoffset - offset + 1);
 
+		tp = NULL;
+		if (should_fork) {
+			error = xfs_reflink_fork_buf(ip, bp, offset_fsb, &tp);
+			if (error)
+				return error;
+		}
+
 		error = xfs_bwrite(bp);
+
+		err2 = xfs_reflink_finish_fork_buf(ip, bp, offset_fsb, tp,
+						   error, imap.br_startblock);
 		xfs_buf_relse(bp);
 		if (error)
 			return error;
+		if (err2)
+			return err2;
 	}
 	return error;
 }
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 29e7da8..04eeb30 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -772,3 +772,159 @@ xfs_reflink_add_ioend(
 {
 	list_add_tail(&eio->rlei_list, &ioend->io_reflink_endio_list);
 }
+
+/**
+ * xfs_reflink_fork_buf() - start a transaction to fork a buffer (if needed)
+ *
+ * @mp: XFS mount point
+ * @ip: XFS inode
+ * @bp: the buffer that we might need to fork
+ * @fileoff: file offset of the buffer
+ * @ptp: pointer to an XFS transaction
+ */
+int
+xfs_reflink_fork_buf(
+	struct xfs_inode	*ip,
+	struct xfs_buf		*bp,
+	xfs_fileoff_t		fileoff,
+	struct xfs_trans	**ptp)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	xfs_fsblock_t		fsbno;
+	xfs_fsblock_t		new_fsbno;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	uint			resblks;
+	int			error;
+
+	fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	CHECK_AG_NUMBER(mp, agno);
+	CHECK_AG_EXTENT(mp, agno, 1);
+
+	/*
+	 * Get ready to remap the thing...
+	 */
+	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 3);
+	tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, resblks, 0);
+
+	/*
+	 * check for running out of space
+	 */
+	if (error) {
+		/*
+		 * Free the transaction structure.
+		 */
+		ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+		goto out_cancel;
+	}
+	error = xfs_trans_reserve_quota(tp, mp,
+			ip->i_udquot, ip->i_gdquot, ip->i_pdquot,
+			resblks, 0, XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		goto out_cancel;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	/* fork block, remap buffer */
+	error = fork_one_block(mp, tp, ip, fsbno, &new_fsbno);
+	if (error)
+		goto out_cancel;
+
+	trace_xfs_reflink_fork_buf(ip, fileoff, fsbno, 1, new_fsbno);
+
+	XFS_BUF_SET_ADDR(bp, XFS_FSB_TO_DADDR(mp, new_fsbno));
+	*ptp = tp;
+	return error;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+	trace_xfs_reflink_fork_buf_error(ip, error, _RET_IP_);
+	return error;
+}
+
+/**
+ * xfs_reflink_finish_fork_buf() - finish forking a file buffer
+ *
+ * @ip: XFS inode
+ * @bp: the buffer that was forked
+ * @fileoff: file offset of the buffer
+ * @tp: transaction that was returned from xfs_reflink_fork_buf()
+ * @write_error: status code from writing the block
+ */
+int
+xfs_reflink_finish_fork_buf(
+	struct xfs_inode	*ip,
+	struct xfs_buf		*bp,
+	xfs_fileoff_t		fileoff,
+	struct xfs_trans	*tp,
+	int			write_error,
+	xfs_fsblock_t		old_fsbno)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_bmap_free	free_list;
+	xfs_fsblock_t		firstfsb;
+	xfs_fsblock_t		fsbno;
+	struct xfs_bmbt_irec	imaps[1];
+	xfs_agnumber_t		agno;
+	int			nimaps = 1;
+	int			done;
+	int			error;
+	int			committed;
+
+	if (tp == NULL)
+		return 0;
+
+	fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	if (write_error != 0) {
+		error = xfs_free_extent(tp, fsbno, 1, ip->i_ino);
+		if (error)
+			goto out_cancel;
+		xfs_trans_cancel(tp);
+		return error;
+	}
+
+	trace_xfs_reflink_fork_buf(ip, fileoff, old_fsbno, 1, fsbno);
+	/*
+	 * Remap the old blocks.
+	 */
+	xfs_bmap_init(&free_list, &firstfsb);
+	error = xfs_bunmapi(tp, ip, fileoff, 1, 0, 1, &firstfsb, &free_list,
+			    &done);
+	if (error)
+		goto out_free;
+	ASSERT(done == 1);
+
+	error = xfs_bmapi_write(tp, ip, fileoff, 1, XFS_BMAPI_EXACT, &fsbno,
+					0, &imaps[0], &nimaps, &free_list);
+	if (error)
+		goto out_free;
+
+	/*
+	 * complete the transaction
+	 */
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	if (error)
+		goto out_cancel;
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_error;
+
+	return error;
+out_free:
+	xfs_bmap_finish(&tp, &free_list, &committed);
+	done = xfs_free_extent(tp, fsbno, 1, ip->i_ino);
+	if (error == 0)
+		error = done;
+out_cancel:
+	xfs_trans_cancel(tp);
+out_error:
+	trace_xfs_reflink_finish_fork_buf_error(ip, error, _RET_IP_);
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index b3e12d2..ce00cf6 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -38,4 +38,10 @@ extern void xfs_reflink_add_ioend(struct xfs_ioend *ioend,
 extern int xfs_reflink_should_fork_block(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap, xfs_off_t offset, bool *type);
 
+extern int xfs_reflink_fork_buf(struct xfs_inode *ip, struct xfs_buf *bp,
+		xfs_fileoff_t fileoff, struct xfs_trans **ptp);
+extern int xfs_reflink_finish_fork_buf(struct xfs_inode *ip, struct xfs_buf *bp,
+		xfs_fileoff_t fileoff, struct xfs_trans *tp, int write_error,
+		xfs_fsblock_t old_fsbno);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
