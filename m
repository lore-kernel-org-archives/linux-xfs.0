Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AA6PPs081045 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 05:06:26 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7BuKy84wEKVu4DWu for <xfs@oss.sgi.com>;
	Tue, 10 Apr 2012 03:06:23 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SHXxi-0002XU-HD
	for xfs@oss.sgi.com; Tue, 10 Apr 2012 20:06:10 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SHXvD-000703-Ei
	for xfs@oss.sgi.com; Tue, 10 Apr 2012 20:03:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfs: kill XBF_LOCK
Date: Tue, 10 Apr 2012 20:03:31 +1000
Message-Id: <1334052213-26870-2-git-send-email-david@fromorbit.com>
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

Buffers are always returned locked from the lookup routines. Hence
we don't need to tell the lookup routines to return locked buffers,
on to try and lock them. Remove XBF_LOCK from all the callers and
from internal buffer cache usage.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr.c        |    5 ++---
 fs/xfs/xfs_attr_leaf.c   |    2 +-
 fs/xfs/xfs_buf.c         |   20 +++++---------------
 fs/xfs/xfs_buf.h         |    4 +---
 fs/xfs/xfs_fsops.c       |   13 +++++--------
 fs/xfs/xfs_ialloc.c      |    3 +--
 fs/xfs/xfs_inode.c       |   16 +++++++---------
 fs/xfs/xfs_log_recover.c |    7 +++----
 fs/xfs/xfs_rw.c          |    2 +-
 fs/xfs/xfs_trans_buf.c   |    4 ++--
 fs/xfs/xfs_vnodeops.c    |    2 +-
 11 files changed, 29 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 6e9bd7e..c8ef9a9 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -1988,8 +1988,7 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			blkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			error = xfs_read_buf(mp, mp->m_ddev_targp, dblkno,
-					     blkcnt, XBF_LOCK | XBF_DONT_BLOCK,
-					     &bp);
+					     blkcnt, XBF_DONT_BLOCK, &bp);
 			if (error)
 				return(error);
 
@@ -2116,7 +2115,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		blkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
 		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, blkcnt,
-				 XBF_LOCK | XBF_DONT_BLOCK);
+				 XBF_DONT_BLOCK);
 		if (!bp)
 			return ENOMEM;
 
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 76d93dc..3cd5dc6 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -2983,7 +2983,7 @@ xfs_attr_leaf_freextent(xfs_trans_t **trans, xfs_inode_t *dp,
 						map.br_blockcount);
 			bp = xfs_trans_get_buf(*trans,
 					dp->i_mount->m_ddev_targp,
-					dblkno, dblkcnt, XBF_LOCK);
+					dblkno, dblkcnt, 0);
 			if (!bp)
 				return ENOMEM;
 			xfs_trans_binval(*trans, bp);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 7a945fd..8d76df1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -179,7 +179,7 @@ xfs_buf_alloc(
 	/*
 	 * We don't want certain flags to appear in b_flags.
 	 */
-	flags &= ~(XBF_LOCK|XBF_MAPPED|XBF_DONT_BLOCK|XBF_READ_AHEAD);
+	flags &= ~(XBF_MAPPED|XBF_DONT_BLOCK|XBF_READ_AHEAD);
 
 	atomic_set(&bp->b_hold, 1);
 	atomic_set(&bp->b_lru_ref, 1);
@@ -578,19 +578,14 @@ found:
 		if (unlikely(error)) {
 			xfs_warn(target->bt_mount,
 				"%s: failed to map pages\n", __func__);
-			goto no_buffer;
+			xfs_buf_relse(bp);
+			return NULL;
 		}
 	}
 
 	XFS_STATS_INC(xb_get);
 	trace_xfs_buf_get(bp, flags, _RET_IP_);
 	return bp;
-
-no_buffer:
-	if (flags & (XBF_LOCK | XBF_TRYLOCK))
-		xfs_buf_unlock(bp);
-	xfs_buf_rele(bp);
-	return NULL;
 }
 
 STATIC int
@@ -633,7 +628,8 @@ xfs_buf_read(
 			 * Read ahead call which is already satisfied,
 			 * drop the buffer
 			 */
-			goto no_buffer;
+			xfs_buf_relse(bp);
+			return NULL;
 		} else {
 			/* We do not want read in the flags */
 			bp->b_flags &= ~XBF_READ;
@@ -641,12 +637,6 @@ xfs_buf_read(
 	}
 
 	return bp;
-
- no_buffer:
-	if (flags & (XBF_LOCK | XBF_TRYLOCK))
-		xfs_buf_unlock(bp);
-	xfs_buf_rele(bp);
-	return NULL;
 }
 
 /*
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 5b048f7..512d9a6 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -52,7 +52,6 @@ typedef enum {
 #define XBF_FLUSH	(1 << 12)/* flush the disk cache before a write */
 
 /* flags used only as arguments to access routines */
-#define XBF_LOCK	(1 << 15)/* lock requested */
 #define XBF_TRYLOCK	(1 << 16)/* lock requested, but do not wait */
 #define XBF_DONT_BLOCK	(1 << 17)/* do not block in current thread */
 
@@ -74,8 +73,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_SYNCIO,		"SYNCIO" }, \
 	{ XBF_FUA,		"FUA" }, \
 	{ XBF_FLUSH,		"FLUSH" }, \
-	{ XBF_LOCK,		"LOCK" },  	/* should never be set */\
-	{ XBF_TRYLOCK,		"TRYLOCK" }, 	/* ditto */\
+	{ XBF_TRYLOCK,		"TRYLOCK" }, 	/* should never be set */\
 	{ XBF_DONT_BLOCK,	"DONT_BLOCK" },	/* ditto */\
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 019ba5c..874d398 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -193,7 +193,7 @@ xfs_growfs_data_private(
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-				 XFS_FSS_TO_BB(mp, 1), XBF_LOCK | XBF_MAPPED);
+				 XFS_FSS_TO_BB(mp, 1), XBF_MAPPED);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
@@ -230,7 +230,7 @@ xfs_growfs_data_private(
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-				 XFS_FSS_TO_BB(mp, 1), XBF_LOCK | XBF_MAPPED);
+				 XFS_FSS_TO_BB(mp, 1), XBF_MAPPED);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
@@ -259,8 +259,7 @@ xfs_growfs_data_private(
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
-				 BTOBB(mp->m_sb.sb_blocksize),
-				 XBF_LOCK | XBF_MAPPED);
+				 BTOBB(mp->m_sb.sb_blocksize), XBF_MAPPED);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
@@ -286,8 +285,7 @@ xfs_growfs_data_private(
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
-				 BTOBB(mp->m_sb.sb_blocksize),
-				 XBF_LOCK | XBF_MAPPED);
+				 BTOBB(mp->m_sb.sb_blocksize), XBF_MAPPED);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
@@ -314,8 +312,7 @@ xfs_growfs_data_private(
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
-				 BTOBB(mp->m_sb.sb_blocksize),
-				 XBF_LOCK | XBF_MAPPED);
+				 BTOBB(mp->m_sb.sb_blocksize), XBF_MAPPED);
 		if (!bp) {
 			error = ENOMEM;
 			goto error0;
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index dad1a31..d094a23 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -200,8 +200,7 @@ xfs_ialloc_inode_init(
 		 */
 		d = XFS_AGB_TO_DADDR(mp, agno, agbno + (j * blks_per_cluster));
 		fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
-					 mp->m_bsize * blks_per_cluster,
-					 XBF_LOCK);
+					 mp->m_bsize * blks_per_cluster, 0);
 		if (!fbuf)
 			return ENOMEM;
 		/*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 65d7d99..f64b482 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -226,7 +226,7 @@ xfs_inotobp(
 	if (error)
 		return error;
 
-	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XBF_LOCK, imap_flags);
+	error = xfs_imap_to_bp(mp, tp, &imap, &bp, 0, imap_flags);
 	if (error)
 		return error;
 
@@ -782,8 +782,7 @@ xfs_iread(
 	/*
 	 * Get pointers to the on-disk inode and the buffer containing it.
 	 */
-	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp,
-			       XBF_LOCK, iget_flags);
+	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp, 0, iget_flags);
 	if (error)
 		return error;
 	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
@@ -1342,7 +1341,7 @@ xfs_iunlink(
 		 * Here we put the head pointer into our next pointer,
 		 * and then we fall through to point the head at us.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, XBF_LOCK);
+		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0);
 		if (error)
 			return error;
 
@@ -1423,7 +1422,7 @@ xfs_iunlink_remove(
 		 * of dealing with the buffer when there is no need to
 		 * change it.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, XBF_LOCK);
+		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0);
 		if (error) {
 			xfs_warn(mp, "%s: xfs_itobp() returned error %d.",
 				__func__, error);
@@ -1484,7 +1483,7 @@ xfs_iunlink_remove(
 		 * Now last_ibp points to the buffer previous to us on
 		 * the unlinked list.  Pull us from the list.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, XBF_LOCK);
+		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0);
 		if (error) {
 			xfs_warn(mp, "%s: xfs_itobp(2) returned error %d.",
 				__func__, error);
@@ -1566,8 +1565,7 @@ xfs_ifree_cluster(
 		 * to mark all the active inodes on the buffer stale.
 		 */
 		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
-					mp->m_bsize * blks_per_cluster,
-					XBF_LOCK);
+					mp->m_bsize * blks_per_cluster, 0);
 
 		if (!bp)
 			return ENOMEM;
@@ -1737,7 +1735,7 @@ xfs_ifree(
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	error = xfs_itobp(ip->i_mount, tp, ip, &dip, &ibp, XBF_LOCK);
+	error = xfs_itobp(ip->i_mount, tp, ip, &dip, &ibp, 0);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0872d71..6353eb3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2127,7 +2127,7 @@ xlog_recover_buffer_pass2(
 
 	trace_xfs_log_recover_buf_recover(log, buf_f);
 
-	buf_flags = XBF_LOCK;
+	buf_flags = 0;
 	if (!(buf_f->blf_flags & XFS_BLF_INODE_BUF))
 		buf_flags |= XBF_MAPPED;
 
@@ -2225,8 +2225,7 @@ xlog_recover_inode_pass2(
 	}
 	trace_xfs_log_recover_inode_recover(log, in_f);
 
-	bp = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
-			  XBF_LOCK);
+	bp = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len, 0);
 	if (!bp) {
 		error = ENOMEM;
 		goto error;
@@ -3099,7 +3098,7 @@ xlog_recover_process_one_iunlink(
 	/*
 	 * Get the on disk inode to find the next inode in the bucket.
 	 */
-	error = xfs_itobp(mp, NULL, ip, &dip, &ibp, XBF_LOCK);
+	error = xfs_itobp(mp, NULL, ip, &dip, &ibp, 0);
 	if (error)
 		goto fail_iput;
 
diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
index 597d044..2ce9775 100644
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
@@ -114,7 +114,7 @@ xfs_read_buf(
 	int		 error;
 
 	if (!flags)
-		flags = XBF_LOCK | XBF_MAPPED;
+		flags = XBF_MAPPED;
 
 	bp = xfs_buf_read(target, blkno, len, flags);
 	if (!bp)
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 2ec196b..f9cb7ee 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -142,7 +142,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 	xfs_buf_log_item_t	*bip;
 
 	if (flags == 0)
-		flags = XBF_LOCK | XBF_MAPPED;
+		flags = XBF_MAPPED;
 
 	/*
 	 * Default to a normal get_buf() call if the tp is NULL.
@@ -275,7 +275,7 @@ xfs_trans_read_buf(
 	int			error;
 
 	if (flags == 0)
-		flags = XBF_LOCK | XBF_MAPPED;
+		flags = XBF_MAPPED;
 
 	/*
 	 * Default to a normal get_buf() call if the tp is NULL.
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 445c224..8f99c77 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -82,7 +82,7 @@ xfs_readlink_bmap(
 		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 
 		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt),
-				  XBF_LOCK | XBF_MAPPED | XBF_DONT_BLOCK);
+				  XBF_MAPPED | XBF_DONT_BLOCK);
 		if (!bp)
 			return XFS_ERROR(ENOMEM);
 		error = bp->b_error;
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
