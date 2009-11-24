Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAOI1vPl154712 for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 12:01:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E86F818D76BF
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 10:02:23 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id WtEAVy5b72X6AZrX for
	<xfs@oss.sgi.com>; Tue, 24 Nov 2009 10:02:23 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NCziZ-0000gL-IG
	for xfs@oss.sgi.com; Tue, 24 Nov 2009 18:02:23 +0000
Date: Tue, 24 Nov 2009 13:02:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 2/7] xfs: simplify xfs_buf_get / xfs_buf_read interfaces
Message-ID: <20091124180223.GA1211@infradead.org>
References: <20091114161717.233372584@bombadil.infradead.org>
	<20091114161801.411213050@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091114161801.411213050@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Currently these lowlevel buffer cache interfaces are highly confusing
as we have a _flags variant of each that does actually respect the flags,
and one without _flags which has a flags argument that gets ignored and
overriden with a default set.  Given that very few places use the default
arguments get rid of the duplication and convert all callers to pass the
flags explicitly.  Also remove the now confusing _flags postfix.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2009-11-20 14:45:10.771004296 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2009-11-20 14:51:49.614256096 +0100
@@ -187,15 +187,10 @@ extern xfs_buf_t *_xfs_buf_find(xfs_buft
 #define xfs_incore(buftarg,blkno,len,lockit) \
 	_xfs_buf_find(buftarg, blkno ,len, lockit, NULL)
 
-extern xfs_buf_t *xfs_buf_get_flags(xfs_buftarg_t *, xfs_off_t, size_t,
+extern xfs_buf_t *xfs_buf_get(xfs_buftarg_t *, xfs_off_t, size_t,
 				xfs_buf_flags_t);
-#define xfs_buf_get(target, blkno, len, flags) \
-	xfs_buf_get_flags((target), (blkno), (len), XBF_LOCK | XBF_MAPPED)
-
-extern xfs_buf_t *xfs_buf_read_flags(xfs_buftarg_t *, xfs_off_t, size_t,
+extern xfs_buf_t *xfs_buf_read(xfs_buftarg_t *, xfs_off_t, size_t,
 				xfs_buf_flags_t);
-#define xfs_buf_read(target, blkno, len, flags) \
-	xfs_buf_read_flags((target), (blkno), (len), XBF_LOCK | XBF_MAPPED)
 
 extern xfs_buf_t *xfs_buf_get_empty(size_t, xfs_buftarg_t *);
 extern xfs_buf_t *xfs_buf_get_noaddr(size_t, xfs_buftarg_t *);
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2009-11-20 14:45:10.776004095 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2009-11-20 14:48:01.412255985 +0100
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
+	bp = xfs_buf_read(mp->m_ddev_targp, blkno, len, buf_flags);
 	if (XFS_BUF_ISERROR(bp)) {
 		xfs_ioerror_alert("xlog_recover_do..(read#1)", log->l_mp,
 				  bp, blkno);
@@ -2350,8 +2350,8 @@ xlog_recover_do_inode_trans(
 		goto error;
 	}
 
-	bp = xfs_buf_read_flags(mp->m_ddev_targp, in_f->ilf_blkno,
-				in_f->ilf_len, XFS_BUF_LOCK);
+	bp = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
+			  XFS_BUF_LOCK);
 	if (XFS_BUF_ISERROR(bp)) {
 		xfs_ioerror_alert("xlog_recover_do..(read#2)", mp,
 				  bp, in_f->ilf_blkno);
Index: xfs/fs/xfs/xfs_rw.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.c	2009-11-20 14:45:10.781022821 +0100
+++ xfs/fs/xfs/xfs_rw.c	2009-11-20 14:47:08.756036097 +0100
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
+	bp = xfs_buf_read(target, blkno, len, flags);
 	if (!bp)
 		return XFS_ERROR(EIO);
 	error = XFS_BUF_GETERROR(bp);
Index: xfs/fs/xfs/xfs_fsops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fsops.c	2009-11-20 14:45:10.788004088 +0100
+++ xfs/fs/xfs/xfs_fsops.c	2009-11-20 14:50:40.324033258 +0100
@@ -201,8 +201,8 @@ xfs_growfs_data_private(
 		 * AG freelist header block
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
-				  XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-				  XFS_FSS_TO_BB(mp, 1), 0);
+				 XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
+				 XFS_FSS_TO_BB(mp, 1), XBF_LOCK | XBF_MAPPED);
 		agf = XFS_BUF_TO_AGF(bp);
 		memset(agf, 0, mp->m_sb.sb_sectsize);
 		agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
@@ -233,8 +233,8 @@ xfs_growfs_data_private(
 		 * AG inode header block
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
-				  XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-				  XFS_FSS_TO_BB(mp, 1), 0);
+				 XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
+				 XFS_FSS_TO_BB(mp, 1), XBF_LOCK | XBF_MAPPED);
 		agi = XFS_BUF_TO_AGI(bp);
 		memset(agi, 0, mp->m_sb.sb_sectsize);
 		agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
@@ -257,8 +257,9 @@ xfs_growfs_data_private(
 		 * BNO btree root block
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
-			XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
-			BTOBB(mp->m_sb.sb_blocksize), 0);
+				 XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
+				 BTOBB(mp->m_sb.sb_blocksize),
+				 XBF_LOCK | XBF_MAPPED);
 		block = XFS_BUF_TO_BLOCK(bp);
 		memset(block, 0, mp->m_sb.sb_blocksize);
 		block->bb_magic = cpu_to_be32(XFS_ABTB_MAGIC);
@@ -278,8 +279,9 @@ xfs_growfs_data_private(
 		 * CNT btree root block
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
-			XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
-			BTOBB(mp->m_sb.sb_blocksize), 0);
+				 XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
+				 BTOBB(mp->m_sb.sb_blocksize),
+				 XBF_LOCK | XBF_MAPPED);
 		block = XFS_BUF_TO_BLOCK(bp);
 		memset(block, 0, mp->m_sb.sb_blocksize);
 		block->bb_magic = cpu_to_be32(XFS_ABTC_MAGIC);
@@ -300,8 +302,9 @@ xfs_growfs_data_private(
 		 * INO btree root block
 		 */
 		bp = xfs_buf_get(mp->m_ddev_targp,
-			XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
-			BTOBB(mp->m_sb.sb_blocksize), 0);
+				 XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
+				 BTOBB(mp->m_sb.sb_blocksize),
+				 XBF_LOCK | XBF_MAPPED);
 		block = XFS_BUF_TO_BLOCK(bp);
 		memset(block, 0, mp->m_sb.sb_blocksize);
 		block->bb_magic = cpu_to_be32(XFS_IBT_MAGIC);
Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2009-11-20 14:48:08.972276171 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2009-11-20 14:51:31.077256872 +0100
@@ -582,7 +582,7 @@ found:
  *	although backing storage may not be.
  */
 xfs_buf_t *
-xfs_buf_get_flags(
+xfs_buf_get(
 	xfs_buftarg_t		*target,/* target for buffer		*/
 	xfs_off_t		ioff,	/* starting offset of range	*/
 	size_t			isize,	/* length of range		*/
@@ -661,7 +661,7 @@ _xfs_buf_read(
 }
 
 xfs_buf_t *
-xfs_buf_read_flags(
+xfs_buf_read(
 	xfs_buftarg_t		*target,
 	xfs_off_t		ioff,
 	size_t			isize,
@@ -671,7 +671,7 @@ xfs_buf_read_flags(
 
 	flags |= XBF_READ;
 
-	bp = xfs_buf_get_flags(target, ioff, isize, flags);
+	bp = xfs_buf_get(target, ioff, isize, flags);
 	if (bp) {
 		if (!XFS_BUF_ISDONE(bp)) {
 			XB_TRACE(bp, "read", (unsigned long)flags);
@@ -718,7 +718,7 @@ xfs_buf_readahead(
 		return;
 
 	flags |= (XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD);
-	xfs_buf_read_flags(target, ioff, isize, flags);
+	xfs_buf_read(target, ioff, isize, flags);
 }
 
 xfs_buf_t *
Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2009-11-20 14:49:18.048254421 +0100
+++ xfs/fs/xfs/xfs_attr.c	2009-11-20 14:51:13.539256422 +0100
@@ -2143,8 +2143,8 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
 		blkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
-		bp = xfs_buf_get_flags(mp->m_ddev_targp, dblkno, blkcnt,
-				       XFS_BUF_LOCK | XBF_DONT_BLOCK);
+		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, blkcnt,
+				 XFS_BUF_LOCK | XBF_DONT_BLOCK);
 		ASSERT(bp);
 		ASSERT(!XFS_BUF_GETERROR(bp));
 
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2009-11-20 14:45:56.032003740 +0100
+++ xfs/fs/xfs/xfs_mount.c	2009-11-20 14:47:03.268005820 +0100
@@ -583,8 +583,8 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 	sector_size = xfs_getsize_buftarg(mp->m_ddev_targp);
 	extra_flags = XFS_BUF_LOCK | XFS_BUF_MANAGE | XFS_BUF_MAPPED;
 
-	bp = xfs_buf_read_flags(mp->m_ddev_targp, XFS_SB_DADDR,
-				BTOBB(sector_size), extra_flags);
+	bp = xfs_buf_read(mp->m_ddev_targp, XFS_SB_DADDR, BTOBB(sector_size),
+			  extra_flags);
 	if (!bp || XFS_BUF_ISERROR(bp)) {
 		xfs_fs_mount_cmn_err(flags, "SB read failed");
 		error = bp ? XFS_BUF_GETERROR(bp) : ENOMEM;
@@ -624,8 +624,8 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 		XFS_BUF_UNMANAGE(bp);
 		xfs_buf_relse(bp);
 		sector_size = mp->m_sb.sb_sectsize;
-		bp = xfs_buf_read_flags(mp->m_ddev_targp, XFS_SB_DADDR,
-					BTOBB(sector_size), extra_flags);
+		bp = xfs_buf_read(mp->m_ddev_targp, XFS_SB_DADDR,
+				  BTOBB(sector_size), extra_flags);
 		if (!bp || XFS_BUF_ISERROR(bp)) {
 			xfs_fs_mount_cmn_err(flags, "SB re-read failed");
 			error = bp ? XFS_BUF_GETERROR(bp) : ENOMEM;
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2009-11-20 14:45:56.049003881 +0100
+++ xfs/fs/xfs/xfs_trans_buf.c	2009-11-20 14:51:59.741006218 +0100
@@ -79,11 +79,8 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 	/*
 	 * Default to a normal get_buf() call if the tp is NULL.
 	 */
-	if (tp == NULL) {
-		bp = xfs_buf_get_flags(target_dev, blkno, len,
-							flags | BUF_BUSY);
-		return(bp);
-	}
+	if (tp == NULL)
+		return xfs_buf_get(target_dev, blkno, len, flags | BUF_BUSY);
 
 	/*
 	 * If we find the buffer in the cache with this transaction
@@ -129,7 +126,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 	 * easily deadlock with our current transaction as well as cause
 	 * us to run out of stack space.
 	 */
-	bp = xfs_buf_get_flags(target_dev, blkno, len, flags | BUF_BUSY);
+	bp = xfs_buf_get(target_dev, blkno, len, flags | BUF_BUSY);
 	if (bp == NULL) {
 		return NULL;
 	}
@@ -302,7 +299,7 @@ xfs_trans_read_buf(
 	 * Default to a normal get_buf() call if the tp is NULL.
 	 */
 	if (tp == NULL) {
-		bp = xfs_buf_read_flags(target, blkno, len, flags | BUF_BUSY);
+		bp = xfs_buf_read(target, blkno, len, flags | BUF_BUSY);
 		if (!bp)
 			return (flags & XFS_BUF_TRYLOCK) ?
 					EAGAIN : XFS_ERROR(ENOMEM);
@@ -398,7 +395,7 @@ xfs_trans_read_buf(
 	 * easily deadlock with our current transaction as well as cause
 	 * us to run out of stack space.
 	 */
-	bp = xfs_buf_read_flags(target, blkno, len, flags | BUF_BUSY);
+	bp = xfs_buf_read(target, blkno, len, flags | BUF_BUSY);
 	if (bp == NULL) {
 		*bpp = NULL;
 		return 0;
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2009-11-20 14:45:56.058003701 +0100
+++ xfs/fs/xfs/xfs_vnodeops.c	2009-11-20 14:47:59.262256187 +0100
@@ -538,9 +538,8 @@ xfs_readlink_bmap(
 		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
 		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 
-		bp = xfs_buf_read_flags(mp->m_ddev_targp, d, BTOBB(byte_cnt),
-					XBF_LOCK | XBF_MAPPED |
-					XBF_DONT_BLOCK);
+		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt),
+				  XBF_LOCK | XBF_MAPPED | XBF_DONT_BLOCK);
 		error = XFS_BUF_GETERROR(bp);
 		if (error) {
 			xfs_ioerror_alert("xfs_readlink",

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
