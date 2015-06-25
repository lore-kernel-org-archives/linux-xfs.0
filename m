Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EC1757F7E
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 18:40:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BBF4A304039
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 16:40:19 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id pUwqQDIESbBoF6jc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 16:40:17 -0700 (PDT)
Subject: [PATCH 09/14] xfs: copy-on-write reflinked blocks when zeroing
	ranges of blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jun 2015 16:40:09 -0700
Message-ID: <20150625234009.4992.77950.stgit@birch.djwong.org>
In-Reply-To: <20150625233909.4992.68314.stgit@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
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
 fs/xfs/xfs_bmap_util.c |   13 +++-
 fs/xfs/xfs_reflink.c   |  172 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h   |    7 ++
 3 files changed, 191 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 090cf75..9c931a7 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -40,6 +40,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_log.h"
+#include "xfs_reflink.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -1087,7 +1088,8 @@ xfs_zero_remaining_bytes(
 	xfs_buf_t		*bp;
 	xfs_mount_t		*mp = ip->i_mount;
 	int			nimap;
-	int			error = 0;
+	int			error = 0, err2;
+	xfs_trans_t		*tp;
 
 	/*
 	 * Avoid doing I/O beyond eof - it's not necessary
@@ -1150,10 +1152,19 @@ xfs_zero_remaining_bytes(
 				(offset - XFS_FSB_TO_B(mp, imap.br_startoff)),
 		       0, lastoffset - offset + 1);
 
+		tp = NULL;
+		error = xfs_reflink_fork_buf(mp, ip, bp, &tp);
+		if (error)
+			return error;
+
 		error = xfs_bwrite(bp);
+		err2 = xfs_reflink_finish_fork_buf(mp, ip, bp, offset_fsb,
+						   tp, error);
 		xfs_buf_relse(bp);
 		if (error)
 			return error;
+		if (err2)
+			return err2;
 	}
 	return error;
 }
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3f4d9a3..d796280 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -679,3 +679,175 @@ xfs_reflink_should_fork_block(
 	*type = (nr > 1);
 	return error;
 }
+
+/**
+ * xfs_reflink_fork_buf() - start a transaction to fork a buffer (if needed)
+ *
+ * @mp: XFS mount point
+ * @ip: XFS inode
+ * @bp: the buffer that we might need to fork
+ * @ptp: pointer to an XFS transaction
+ */
+int					/* error */
+xfs_reflink_fork_buf(
+	xfs_mount_t	*mp,		/* XFS mount object */
+	xfs_inode_t	*ip,		/* XFS inode */
+	xfs_buf_t	*bp,		/* the buffer that we might fork */
+	xfs_trans_t	**ptp)		/* out: transaction for forking buffer */
+{
+	xfs_trans_t	*tp;
+	xfs_fsblock_t	fsbno;
+	xfs_agnumber_t	agno;
+	xfs_agblock_t	agbno;
+	xfs_extlen_t	len;
+	xfs_nlink_t	nr;
+	xfs_alloc_arg_t	args;		/* allocation arguments */
+	uint		resblks;
+	int		error;
+
+	/*
+	 * Do we need to fork this block?
+	 */
+	if (!xfs_sb_version_hasreflink(&mp->m_sb) ||
+	    XFS_IS_REALTIME_INODE(ip)) {
+		*ptp = NULL;
+		return 0;
+	}
+
+	fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	CHECK_AG_NUMBER(mp, agno);
+	CHECK_AG_EXTENT(mp, agno, 1);
+
+	error = xfs_reflink_get_refcount(mp, agno, agbno, &len, &nr);
+	if (error)
+		return error;
+	ASSERT(len != 0);
+	if (nr < 2) {
+		*ptp = NULL;
+		return 0;
+	}
+
+	/*
+	 * Yes we do, so prepare a transaction...
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
+		goto error0;
+	}
+	error = xfs_trans_reserve_quota(tp, mp,
+			ip->i_udquot, ip->i_gdquot, ip->i_pdquot,
+			resblks, 0, XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		goto error0;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	/*
+	 * Now allocate a block, and stash the new mapping.
+	 *
+	 * XXX: Ideally we'd scan up and down the incore extent list
+	 * looking for a block, but do this stupid thing for now.
+	 */
+	memset(&args, 0, sizeof(args));
+	args.tp = tp;
+	args.mp = mp;
+	args.type = XFS_ALLOCTYPE_START_BNO;
+	args.firstblock = args.fsbno = fsbno;
+	args.minlen = args.maxlen = args.prod = 1;
+	args.userdata = XFS_ALLOC_USERDATA;
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		goto error0;
+	ASSERT(args.len == 1);
+
+	XFS_BUF_SET_ADDR(bp, XFS_FSB_TO_DADDR(mp, args.fsbno));
+	*ptp = tp;
+	return 0;
+error0:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+/**
+ * xfs_reflink_finish_fork_buf() - finish forking a file buffer
+ *
+ * @mp: XFS mount object
+ * @ip: XFS inode
+ * @bp: the buffer that was forked
+ * @fileoff: file offset of the buffer
+ * @tp: transaction that was returned from xfs_reflink_fork_buf()
+ * @write_error: status code from writing the block
+ */
+int						/* error */
+xfs_reflink_finish_fork_buf(
+	xfs_mount_t		*mp,		/* XFS mount object */
+	xfs_inode_t		*ip,		/* XFS inode */
+	xfs_buf_t		*bp,		/* block buffer object */
+	xfs_fileoff_t		fileoff,	/* file offset */
+	xfs_trans_t		*tp,		/* transaction object */
+	int			write_error)	/* status code from writing buffer */
+{
+	xfs_bmap_free_t		free_list;
+	xfs_fsblock_t		firstfsb;
+	xfs_fsblock_t		fsbno;
+	xfs_bmbt_irec_t		imaps[1];
+	int			nimaps = 1;
+	int			done;
+	int			error;
+	int			committed;
+
+	if (tp == NULL)
+		return 0;
+
+	fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	if (write_error != 0) {
+		error = xfs_free_extent(tp, fsbno, 1, ip->i_ino);
+		goto out;
+	}
+
+	/*
+	 * Remap the old blocks.
+	 */
+	xfs_bmap_init(&free_list, &firstfsb);
+	error = xfs_bunmapi(tp, ip, fileoff, 1, 0, 1, &firstfsb, &free_list,
+			    &done);
+	if (error)
+		goto error2;
+	ASSERT(done == 1);
+
+	error = xfs_bmapi_write(tp, ip, fileoff, 1, XFS_BMAPI_REFLINK, &fsbno,
+					0, &imaps[0], &nimaps, &free_list);
+	if (error)
+		goto error2;
+
+	/*
+	 * complete the transaction
+	 */
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	if (error)
+		goto out;
+
+	error = xfs_trans_commit(tp);
+	return error;
+error2:
+	xfs_bmap_finish(&tp, &free_list, &committed);
+	done = xfs_free_extent(tp, fsbno, 1, ip->i_ino);
+	if (error == 0)
+		error = done;
+out:
+	xfs_trans_cancel(tp);
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 295a9c7..adfd99c 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -39,4 +39,11 @@ extern int xfs_reflink_end_io(struct xfs_mount *mp, struct xfs_inode *ip,
 extern int xfs_reflink_should_fork_block(struct xfs_inode *ip,
 	xfs_bmbt_irec_t *imap, xfs_off_t offset, bool *type);
 
+extern int xfs_reflink_fork_buf(xfs_mount_t *mp, xfs_inode_t *ip, xfs_buf_t *bp,
+	xfs_trans_t **ptp);
+
+extern int xfs_reflink_finish_fork_buf(xfs_mount_t  *mp, xfs_inode_t *ip,
+	xfs_buf_t *bp, xfs_fileoff_t fileoff, xfs_trans_t *tp,
+	int write_error);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
