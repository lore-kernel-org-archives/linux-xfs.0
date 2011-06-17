Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5HDD3Gn119964 for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 08:13:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D40DF1E4A1E3
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 06:13:02 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	XeRfOk2iR4gH2bbo for <xfs@oss.sgi.com>;
	Fri, 17 Jun 2011 06:13:02 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QXYr7-0000gu-TM
	for xfs@oss.sgi.com; Fri, 17 Jun 2011 13:13:01 +0000
Date: Fri, 17 Jun 2011 09:13:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: kill xfs_itruncate_start
Message-ID: <20110617131301.GB2141@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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

xfs_itruncate_start is a rather length wrapper that evaluates to a call
to xfs_ioend_wait and xfs_tosspages, and only has two callers.

Instead of using the complicated checks left over from IRIX where we
can to truncate the pagecache just call xfs_tosspages
(aka truncate_inode_pages) directly as we want to get rid of all data
after i_size, and truncate_inode_pages handles incorrect alignments
and too large offsets just fine.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-05-23 20:54:39.043447167 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-05-23 21:02:18.231947817 +0200
@@ -1217,165 +1217,8 @@ xfs_isize_check(
 #endif	/* DEBUG */
 
 /*
- * Calculate the last possible buffered byte in a file.  This must
- * include data that was buffered beyond the EOF by the write code.
- * This also needs to deal with overflowing the xfs_fsize_t type
- * which can happen for sizes near the limit.
- *
- * We also need to take into account any blocks beyond the EOF.  It
- * may be the case that they were buffered by a write which failed.
- * In that case the pages will still be in memory, but the inode size
- * will never have been updated.
- */
-STATIC xfs_fsize_t
-xfs_file_last_byte(
-	xfs_inode_t	*ip)
-{
-	xfs_mount_t	*mp;
-	xfs_fsize_t	last_byte;
-	xfs_fileoff_t	last_block;
-	xfs_fileoff_t	size_last_block;
-	int		error;
-
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED));
-
-	mp = ip->i_mount;
-	/*
-	 * Only check for blocks beyond the EOF if the extents have
-	 * been read in.  This eliminates the need for the inode lock,
-	 * and it also saves us from looking when it really isn't
-	 * necessary.
-	 */
-	if (ip->i_df.if_flags & XFS_IFEXTENTS) {
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-		error = xfs_bmap_last_offset(NULL, ip, &last_block,
-			XFS_DATA_FORK);
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-		if (error) {
-			last_block = 0;
-		}
-	} else {
-		last_block = 0;
-	}
-	size_last_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)ip->i_size);
-	last_block = XFS_FILEOFF_MAX(last_block, size_last_block);
-
-	last_byte = XFS_FSB_TO_B(mp, last_block);
-	if (last_byte < 0) {
-		return XFS_MAXIOFFSET(mp);
-	}
-	last_byte += (1 << mp->m_writeio_log);
-	if (last_byte < 0) {
-		return XFS_MAXIOFFSET(mp);
-	}
-	return last_byte;
-}
-
-/*
- * Start the truncation of the file to new_size.  The new size
- * must be smaller than the current size.  This routine will
- * clear the buffer and page caches of file data in the removed
- * range, and xfs_itruncate_finish() will remove the underlying
- * disk blocks.
- *
- * The inode must have its I/O lock locked EXCLUSIVELY, and it
- * must NOT have the inode lock held at all.  This is because we're
- * calling into the buffer/page cache code and we can't hold the
- * inode lock when we do so.
- *
- * We need to wait for any direct I/Os in flight to complete before we
- * proceed with the truncate. This is needed to prevent the extents
- * being read or written by the direct I/Os from being removed while the
- * I/O is in flight as there is no other method of synchronising
- * direct I/O with the truncate operation.  Also, because we hold
- * the IOLOCK in exclusive mode, we prevent new direct I/Os from being
- * started until the truncate completes and drops the lock. Essentially,
- * the xfs_ioend_wait() call forms an I/O barrier that provides strict
- * ordering between direct I/Os and the truncate operation.
- *
- * The flags parameter can have either the value XFS_ITRUNC_DEFINITE
- * or XFS_ITRUNC_MAYBE.  The XFS_ITRUNC_MAYBE value should be used
- * in the case that the caller is locking things out of order and
- * may not be able to call xfs_itruncate_finish() with the inode lock
- * held without dropping the I/O lock.  If the caller must drop the
- * I/O lock before calling xfs_itruncate_finish(), then xfs_itruncate_start()
- * must be called again with all the same restrictions as the initial
- * call.
- */
-int
-xfs_itruncate_start(
-	xfs_inode_t	*ip,
-	uint		flags,
-	xfs_fsize_t	new_size)
-{
-	xfs_fsize_t	last_byte;
-	xfs_off_t	toss_start;
-	xfs_mount_t	*mp;
-	int		error = 0;
-
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
-	ASSERT((new_size == 0) || (new_size <= ip->i_size));
-	ASSERT((flags == XFS_ITRUNC_DEFINITE) ||
-	       (flags == XFS_ITRUNC_MAYBE));
-
-	mp = ip->i_mount;
-
-	/* wait for the completion of any pending DIOs */
-	if (new_size == 0 || new_size < ip->i_size)
-		xfs_ioend_wait(ip);
-
-	/*
-	 * Call toss_pages or flushinval_pages to get rid of pages
-	 * overlapping the region being removed.  We have to use
-	 * the less efficient flushinval_pages in the case that the
-	 * caller may not be able to finish the truncate without
-	 * dropping the inode's I/O lock.  Make sure
-	 * to catch any pages brought in by buffers overlapping
-	 * the EOF by searching out beyond the isize by our
-	 * block size. We round new_size up to a block boundary
-	 * so that we don't toss things on the same block as
-	 * new_size but before it.
-	 *
-	 * Before calling toss_page or flushinval_pages, make sure to
-	 * call remapf() over the same region if the file is mapped.
-	 * This frees up mapped file references to the pages in the
-	 * given range and for the flushinval_pages case it ensures
-	 * that we get the latest mapped changes flushed out.
-	 */
-	toss_start = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
-	toss_start = XFS_FSB_TO_B(mp, toss_start);
-	if (toss_start < 0) {
-		/*
-		 * The place to start tossing is beyond our maximum
-		 * file size, so there is no way that the data extended
-		 * out there.
-		 */
-		return 0;
-	}
-	last_byte = xfs_file_last_byte(ip);
-	trace_xfs_itruncate_start(ip, new_size, flags, toss_start, last_byte);
-	if (last_byte > toss_start) {
-		if (flags & XFS_ITRUNC_DEFINITE) {
-			xfs_tosspages(ip, toss_start,
-					-1, FI_REMAPF_LOCKED);
-		} else {
-			error = xfs_flushinval_pages(ip, toss_start,
-					-1, FI_REMAPF_LOCKED);
-		}
-	}
-
-#ifdef DEBUG
-	if (new_size == 0) {
-		ASSERT(VN_CACHED(VFS_I(ip)) == 0);
-	}
-#endif
-	return error;
-}
-
-/*
- * Shrink the file to the given new_size.  The new size must be smaller than
- * the current size.  This will free up the underlying blocks in the removed
- * range after a call to xfs_itruncate_start() or xfs_atruncate_start().
+ * Free up the underlying blocks past new_size.  The new size must be
+ * smaller than the current size.
  *
  * The transaction passed to this routine must have made a permanent log
  * reservation of at least XFS_ITRUNCATE_LOG_RES.  This routine may commit the
@@ -1387,7 +1230,7 @@ xfs_itruncate_start(
  * will be "held" within the returned transaction.  This routine does NOT
  * require any disk space to be reserved for it within the transaction.
  *
- * The fork parameter must be either xfs_attr_fork or xfs_data_fork, and it
+ * The fork parameter must be either XFS_ATTR_FORK or XFS_DATA_FORK, and it
  * indicates the fork which is to be truncated.  For the attribute fork we only
  * support truncation to size 0.
  *
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2011-05-23 20:54:39.055445403 +0200
+++ xfs/fs/xfs/xfs_vnodeops.c	2011-05-23 20:57:30.379948217 +0200
@@ -197,13 +197,6 @@ xfs_free_eofblocks(
 		 */
 		tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
 
-		/*
-		 * Do the xfs_itruncate_start() call before
-		 * reserving any log space because
-		 * itruncate_start will call into the buffer
-		 * cache and we can't
-		 * do that within a transaction.
-		 */
 		if (flags & XFS_FREE_EOF_TRYLOCK) {
 			if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
 				xfs_trans_cancel(tp, 0);
@@ -212,13 +205,6 @@ xfs_free_eofblocks(
 		} else {
 			xfs_ilock(ip, XFS_IOLOCK_EXCL);
 		}
-		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
-				    ip->i_size);
-		if (error) {
-			xfs_trans_cancel(tp, 0);
-			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-			return error;
-		}
 
 		error = xfs_trans_reserve(tp, 0,
 					  XFS_ITRUNCATE_LOG_RES(mp),
@@ -657,20 +643,9 @@ xfs_inactive(
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
 	if (truncate) {
-		/*
-		 * Do the xfs_itruncate_start() call before
-		 * reserving any log space because itruncate_start
-		 * will call into the buffer cache and we can't
-		 * do that within a transaction.
-		 */
 		xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
-		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0);
-		if (error) {
-			xfs_trans_cancel(tp, 0);
-			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-			return VN_INACTIVE_CACHE;
-		}
+		xfs_ioend_wait(ip);
 
 		error = xfs_trans_reserve(tp, 0,
 					  XFS_ITRUNCATE_LOG_RES(mp),
Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2011-05-23 20:59:44.039946364 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2011-05-23 21:00:06.955570292 +0200
@@ -1029,40 +1029,6 @@ DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enos
 DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
 DEFINE_SIMPLE_IO_EVENT(xfs_get_blocks_notfound);
 
-
-TRACE_EVENT(xfs_itruncate_start,
-	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size, int flag,
-		 xfs_off_t toss_start, xfs_off_t toss_finish),
-	TP_ARGS(ip, new_size, flag, toss_start, toss_finish),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_fsize_t, size)
-		__field(xfs_fsize_t, new_size)
-		__field(xfs_off_t, toss_start)
-		__field(xfs_off_t, toss_finish)
-		__field(int, flag)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->size = ip->i_d.di_size;
-		__entry->new_size = new_size;
-		__entry->toss_start = toss_start;
-		__entry->toss_finish = toss_finish;
-		__entry->flag = flag;
-	),
-	TP_printk("dev %d:%d ino 0x%llx %s size 0x%llx new_size 0x%llx "
-		  "toss start 0x%llx toss finish 0x%llx",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __print_flags(__entry->flag, "|", XFS_ITRUNC_FLAGS),
-		  __entry->size,
-		  __entry->new_size,
-		  __entry->toss_start,
-		  __entry->toss_finish)
-);
-
 DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),
 	TP_ARGS(ip, new_size),
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2011-05-23 20:59:23.304947922 +0200
+++ xfs/fs/xfs/xfs_inode.h	2011-05-23 20:59:34.971947361 +0200
@@ -448,16 +448,6 @@ static inline void xfs_ifunlock(xfs_inod
 extern struct lock_class_key xfs_iolock_reclaimable;
 
 /*
- * Flags for xfs_itruncate_start().
- */
-#define	XFS_ITRUNC_DEFINITE	0x1
-#define	XFS_ITRUNC_MAYBE	0x2
-
-#define XFS_ITRUNC_FLAGS \
-	{ XFS_ITRUNC_DEFINITE,	"DEFINITE" }, \
-	{ XFS_ITRUNC_MAYBE,	"MAYBE" }
-
-/*
  * For multiple groups support: if S_ISGID bit is set in the parent
  * directory, group of new file is set to that of the parent, and
  * new subdirectory gets S_ISGID bit from parent.
@@ -491,7 +481,6 @@ uint		xfs_ip2xflags(struct xfs_inode *);
 uint		xfs_dic2xflags(struct xfs_dinode *);
 int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
 			   struct xfs_bmap_free *);
-int		xfs_itruncate_start(xfs_inode_t *, uint, xfs_fsize_t);
 int		xfs_itruncate_finish(struct xfs_trans **, xfs_inode_t *,
 				     xfs_fsize_t, int, int);
 int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
