Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AA6F6Y081024 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 05:06:15 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	edRY8SfF4vGsfC3V for <xfs@oss.sgi.com>;
	Tue, 10 Apr 2012 03:06:13 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SHXxi-0002XV-Hv
	for xfs@oss.sgi.com; Tue, 10 Apr 2012 20:06:10 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SHXvD-000705-GH
	for xfs@oss.sgi.com; Tue, 10 Apr 2012 20:03:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: kill xfs_read_buf()
Date: Tue, 10 Apr 2012 20:03:32 +1000
Message-Id: <1334052213-26870-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1334052213-26870-1-git-send-email-david@fromorbit.com>
References: <1334052213-26870-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

xfs_read_buf() is effectively the same as xfs_trans_read_buf() when called
outside a transaction context. The error handling is slightly different in that
xfs_read_buf stales the errored buffer it gets back, but there is probably good
reason for xfs_trans_read_buf() for doing this.

Hence update xfs_trans_read_buf() to the same error handling as xfs_read_buf(),
and convert all the callers of xfs_read_buf() to use the former function. We can
then remove xfs_read_buf().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr.c        |    4 +-
 fs/xfs/xfs_fsops.c       |    2 +-
 fs/xfs/xfs_log_recover.c |   11 +++------
 fs/xfs/xfs_rw.c          |   50 ----------------------------------------------
 fs/xfs/xfs_rw.h          |    3 --
 fs/xfs/xfs_trans_buf.c   |    4 +++
 6 files changed, 11 insertions(+), 63 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index c8ef9a9..ad85bed 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -1987,8 +1987,8 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
 			       (map[i].br_startblock != HOLESTARTBLOCK));
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			blkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			error = xfs_read_buf(mp, mp->m_ddev_targp, dblkno,
-					     blkcnt, XBF_DONT_BLOCK, &bp);
+			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+						   dblkno, blkcnt, 0, &bp);
 			if (error)
 				return(error);
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 874d398..e9f5bc0 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -402,7 +402,7 @@ xfs_growfs_data_private(
 
 	/* update secondary superblocks. */
 	for (agno = 1; agno < nagcount; agno++) {
-		error = xfs_read_buf(mp, mp->m_ddev_targp,
+		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
 				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
 				  XFS_FSS_TO_BB(mp, 1), 0, &bp);
 		if (error) {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6353eb3..b700ced 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2535,14 +2535,11 @@ xlog_recover_dquot_pass2(
 		return XFS_ERROR(EIO);
 	ASSERT(dq_f->qlf_len == 1);
 
-	error = xfs_read_buf(mp, mp->m_ddev_targp,
-			     dq_f->qlf_blkno,
-			     XFS_FSB_TO_BB(mp, dq_f->qlf_len),
-			     0, &bp);
-	if (error) {
-		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#3)");
+	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dq_f->qlf_blkno,
+				   XFS_FSB_TO_BB(mp, dq_f->qlf_len), 0, &bp);
+	if (error)
 		return error;
-	}
+
 	ASSERT(bp);
 	ddq = (xfs_disk_dquot_t *)xfs_buf_offset(bp, dq_f->qlf_boffset);
 
diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
index 2ce9775..3c2488a 100644
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
@@ -92,56 +92,6 @@ xfs_do_force_shutdown(
 }
 
 /*
- * This isn't an absolute requirement, but it is
- * just a good idea to call xfs_read_buf instead of
- * directly doing a read_buf call. For one, we shouldn't
- * be doing this disk read if we are in SHUTDOWN state anyway,
- * so this stops that from happening. Secondly, this does all
- * the error checking stuff and the brelse if appropriate for
- * the caller, so the code can be a little leaner.
- */
-
-int
-xfs_read_buf(
-	struct xfs_mount *mp,
-	xfs_buftarg_t	 *target,
-	xfs_daddr_t	 blkno,
-	int              len,
-	uint             flags,
-	xfs_buf_t	 **bpp)
-{
-	xfs_buf_t	 *bp;
-	int		 error;
-
-	if (!flags)
-		flags = XBF_MAPPED;
-
-	bp = xfs_buf_read(target, blkno, len, flags);
-	if (!bp)
-		return XFS_ERROR(EIO);
-	error = bp->b_error;
-	if (!error && !XFS_FORCED_SHUTDOWN(mp)) {
-		*bpp = bp;
-	} else {
-		*bpp = NULL;
-		if (error) {
-			xfs_buf_ioerror_alert(bp, __func__);
-		} else {
-			error = XFS_ERROR(EIO);
-		}
-		if (bp) {
-			XFS_BUF_UNDONE(bp);
-			xfs_buf_stale(bp);
-			/*
-			 * brelse clears B_ERROR and b_error
-			 */
-			xfs_buf_relse(bp);
-		}
-	}
-	return (error);
-}
-
-/*
  * helper function to extract extent size hint from inode
  */
 xfs_extlen_t
diff --git a/fs/xfs/xfs_rw.h b/fs/xfs/xfs_rw.h
index bbdb9ad..967b3a4 100644
--- a/fs/xfs/xfs_rw.h
+++ b/fs/xfs/xfs_rw.h
@@ -39,9 +39,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
 /*
  * Prototypes for functions in xfs_rw.c.
  */
-extern int xfs_read_buf(struct xfs_mount *mp, xfs_buftarg_t *btp,
-			xfs_daddr_t blkno, int len, uint flags,
-			struct xfs_buf **bpp);
 extern xfs_extlen_t xfs_get_extsz_hint(struct xfs_inode *ip);
 
 #endif /* __XFS_RW_H__ */
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index f9cb7ee..5e4cf61 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -274,6 +274,8 @@ xfs_trans_read_buf(
 	xfs_buf_log_item_t	*bip;
 	int			error;
 
+	*bpp = NULL;
+
 	if (flags == 0)
 		flags = XBF_MAPPED;
 
@@ -289,6 +291,8 @@ xfs_trans_read_buf(
 		if (bp->b_error) {
 			error = bp->b_error;
 			xfs_buf_ioerror_alert(bp, __func__);
+			XFS_BUF_UNDONE(bp);
+			xfs_buf_stale(bp);
 			xfs_buf_relse(bp);
 			return error;
 		}
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
