Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAEGHfv4193817 for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 10:17:47 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DACD089D09
	for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:18:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Uy8nbzKLJxbhx5g0 for
	<xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:18:01 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1N9LK5-0004Vb-Gt
	for xfs@oss.sgi.com; Sat, 14 Nov 2009 16:18:01 +0000
Message-Id: <20091114161801.411213050@bombadil.infradead.org>
Date: Sat, 14 Nov 2009 11:17:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/7] xfs: remove xfs_buf_get / xfs_buf_read
References: <20091114161717.233372584@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_buf_read
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

The two interfaces are highl confusing as they do have a flags argument
which gets ignored and replaced with default flags.  Switch the few remaining
callers to use xfs_buf_get_flags and xfs_buf_read_flags instead and remove
these wrappers.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2009-11-12 17:13:55.334003777 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2009-11-12 17:17:21.873006402 +0100
@@ -189,13 +189,8 @@ extern xfs_buf_t *_xfs_buf_find(xfs_buft
 
 extern xfs_buf_t *xfs_buf_get_flags(xfs_buftarg_t *, xfs_off_t, size_t,
 				xfs_buf_flags_t);
-#define xfs_buf_get(target, blkno, len, flags) \
-	xfs_buf_get_flags((target), (blkno), (len), XBF_LOCK | XBF_MAPPED)
-
 extern xfs_buf_t *xfs_buf_read_flags(xfs_buftarg_t *, xfs_off_t, size_t,
 				xfs_buf_flags_t);
-#define xfs_buf_read(target, blkno, len, flags) \
-	xfs_buf_read_flags((target), (blkno), (len), XBF_LOCK | XBF_MAPPED)
 
 extern xfs_buf_t *xfs_buf_get_empty(size_t, xfs_buftarg_t *);
 extern xfs_buf_t *xfs_buf_get_noaddr(size_t, xfs_buftarg_t *);
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2009-11-12 17:10:20.286254746 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2009-11-12 17:14:15.274004198 +0100
@@ -2206,6 +2206,7 @@ xlog_recover_do_buffer_trans(
 	xfs_daddr_t		blkno;
 	int			len;
 	ushort			flags;
+	uint			buf_flags;
 
 	buf_f = (xfs_buf_log_format_t *)item->ri_buf[0].i_addr;
 
@@ -2246,12 +2247,11 @@ xlog_recover_do_buffer_trans(
 	}
 
 	mp = log->l_mp;
-	if (flags & XFS_BLI_INODE_BUF) {
-		bp = xfs_buf_read_flags(mp->m_ddev_targp, blkno, len,
-								XFS_BUF_LOCK);
-	} else {
-		bp = xfs_buf_read(mp->m_ddev_targp, blkno, len, 0);
-	}
+	buf_flags = XFS_BUF_LOCK;
+	if (!(flags & XFS_BLI_INODE_BUF))
+		buf_flags |= XFS_BUF_MAPPED;
+
+	bp = xfs_buf_read_flags(mp->m_ddev_targp, blkno, len, buf_flags);
 	if (XFS_BUF_ISERROR(bp)) {
 		xfs_ioerror_alert("xlog_recover_do..(read#1)", log->l_mp,
 				  bp, blkno);
Index: xfs/fs/xfs/xfs_rw.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.c	2009-11-12 17:10:20.326254256 +0100
+++ xfs/fs/xfs/xfs_rw.c	2009-11-12 17:14:15.278004428 +0100
@@ -277,10 +277,10 @@ xfs_read_buf(
 	xfs_buf_t	 *bp;
 	int		 error;
 
-	if (flags)
-		bp = xfs_buf_read_flags(target, blkno, len, flags);
-	else
-		bp = xfs_buf_read(target, blkno, len, flags);
+	if (!flags)
+		flags = XBF_LOCK | XBF_MAPPED;
+
+	bp = xfs_buf_read_flags(target, blkno, len, flags);
 	if (!bp)
 		return XFS_ERROR(EIO);
 	error = XFS_BUF_GETERROR(bp);
Index: xfs/fs/xfs/xfs_fsops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fsops.c	2009-11-12 17:15:17.097272663 +0100
+++ xfs/fs/xfs/xfs_fsops.c	2009-11-12 17:16:53.487005554 +0100
@@ -200,9 +200,9 @@ xfs_growfs_data_private(
 		/*
 		 * AG freelist header block
 		 */
-		bp = xfs_buf_get(mp->m_ddev_targp,
-				  XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-				  XFS_FSS_TO_BB(mp, 1), 0);
+		bp = xfs_buf_get_flags(mp->m_ddev_targp,
+				XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
+				XFS_FSS_TO_BB(mp, 1), XBF_LOCK | XBF_MAPPED);
 		agf = XFS_BUF_TO_AGF(bp);
 		memset(agf, 0, mp->m_sb.sb_sectsize);
 		agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
@@ -232,9 +232,9 @@ xfs_growfs_data_private(
 		/*
 		 * AG inode header block
 		 */
-		bp = xfs_buf_get(mp->m_ddev_targp,
-				  XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-				  XFS_FSS_TO_BB(mp, 1), 0);
+		bp = xfs_buf_get_flags(mp->m_ddev_targp,
+				XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
+				XFS_FSS_TO_BB(mp, 1), XBF_LOCK | XBF_MAPPED);
 		agi = XFS_BUF_TO_AGI(bp);
 		memset(agi, 0, mp->m_sb.sb_sectsize);
 		agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
@@ -256,9 +256,9 @@ xfs_growfs_data_private(
 		/*
 		 * BNO btree root block
 		 */
-		bp = xfs_buf_get(mp->m_ddev_targp,
-			XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
-			BTOBB(mp->m_sb.sb_blocksize), 0);
+		bp = xfs_buf_get_flags(mp->m_ddev_targp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
+				BTOBB(mp->m_sb.sb_blocksize), XBF_LOCK | XBF_MAPPED);
 		block = XFS_BUF_TO_BLOCK(bp);
 		memset(block, 0, mp->m_sb.sb_blocksize);
 		block->bb_magic = cpu_to_be32(XFS_ABTB_MAGIC);
@@ -277,9 +277,9 @@ xfs_growfs_data_private(
 		/*
 		 * CNT btree root block
 		 */
-		bp = xfs_buf_get(mp->m_ddev_targp,
-			XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
-			BTOBB(mp->m_sb.sb_blocksize), 0);
+		bp = xfs_buf_get_flags(mp->m_ddev_targp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
+				BTOBB(mp->m_sb.sb_blocksize), XBF_LOCK | XBF_MAPPED);
 		block = XFS_BUF_TO_BLOCK(bp);
 		memset(block, 0, mp->m_sb.sb_blocksize);
 		block->bb_magic = cpu_to_be32(XFS_ABTC_MAGIC);
@@ -299,9 +299,9 @@ xfs_growfs_data_private(
 		/*
 		 * INO btree root block
 		 */
-		bp = xfs_buf_get(mp->m_ddev_targp,
-			XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
-			BTOBB(mp->m_sb.sb_blocksize), 0);
+		bp = xfs_buf_get_flags(mp->m_ddev_targp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
+				BTOBB(mp->m_sb.sb_blocksize), XBF_LOCK | XBF_MAPPED);
 		block = XFS_BUF_TO_BLOCK(bp);
 		memset(block, 0, mp->m_sb.sb_blocksize);
 		block->bb_magic = cpu_to_be32(XFS_IBT_MAGIC);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
