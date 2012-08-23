Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53Jrg135024 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:20 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	e89mEnjA0bxFlqMF for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:03 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PaA-0003G8-IM
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:50 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pa0-0003dY-F7
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 029/102] xfs: remove the i_size field in struct xfs_inode
Date: Thu, 23 Aug 2012 15:01:47 +1000
Message-Id: <1345698180-13612-30-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: ce7ae151ddada3dbf67301464343c154903166b3

There is no fundamental need to keep an in-memory inode size copy in the XFS
inode.  We already have the on-disk value in the dinode, and the separate
in-memory copy that we need for regular files only in the XFS inode.

Remove the xfs_inode i_size field and change the XFS_ISIZE macro to use the
VFS inode i_size field for regular files.  Switch code that was directly
accessing the i_size field in the xfs_inode to XFS_ISIZE, or in cases where
we are limited to regular files direct access of the VFS inode i_size field.

This also allows dropping some fairly complicated code in the write path
which dealt with keeping the xfs_inode i_size uptodate with the VFS i_size
that is getting updated inside ->write_end.

Note that we do not bother resetting the VFS i_size when truncating a file
that gets freed to zero as there is no point in doing so because the VFS inode
is no longer in use at this point.  Just relax the assert in xfs_ifree to
only check the on-disk size instead.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c    |    2 +-
 fs/xfs/linux-2.6/xfs_file.c    |   45 ++++++++++------------------------------
 fs/xfs/linux-2.6/xfs_fs_subr.c |    2 +-
 fs/xfs/xfs_bmap.c              |   15 ++++++--------
 fs/xfs/xfs_iget.c              |    1 -
 fs/xfs/xfs_inode.c             |   20 +++++++-----------
 fs/xfs/xfs_inode.h             |   16 ++++++++++----
 fs/xfs/xfs_iomap.c             |   14 ++++++-------
 fs/xfs/xfs_vnodeops.c          |   39 +++++++++++++++++-----------------
 9 files changed, 65 insertions(+), 89 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 2426ecd..a284ea7 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -145,7 +145,7 @@ xfs_ioend_new_eof(
 	xfs_fsize_t		bsize;
 
 	bsize = ioend->io_offset + ioend->io_size;
-	isize = MAX(ip->i_size, ip->i_new_size);
+	isize = MAX(i_size_read(VFS_I(ip)), ip->i_new_size);
 	isize = MIN(isize, bsize);
 	return isize > ip->i_d.di_size ? isize : 0;
 }
diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 185a337..78a9cf4 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -320,7 +320,7 @@ xfs_file_aio_read(
 				mp->m_rtdev_targp : mp->m_ddev_targp;
 		if ((iocb->ki_pos & target->bt_smask) ||
 		    (size & target->bt_smask)) {
-			if (iocb->ki_pos == ip->i_size)
+			if (iocb->ki_pos == i_size_read(inode))
 				return 0;
 			return -XFS_ERROR(EINVAL);
 		}
@@ -405,30 +405,6 @@ xfs_file_splice_read(
 	return ret;
 }
 
-STATIC void
-xfs_aio_write_isize_update(
-	struct inode	*inode,
-	loff_t		*ppos,
-	ssize_t		bytes_written)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	xfs_fsize_t		isize = i_size_read(inode);
-
-	if (bytes_written > 0)
-		XFS_STATS_ADD(xs_write_bytes, bytes_written);
-
-	if (unlikely(bytes_written < 0 && bytes_written != -EFAULT &&
-					*ppos > isize))
-		*ppos = isize;
-
-	if (*ppos > ip->i_size) {
-		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
-		if (*ppos > ip->i_size)
-			ip->i_size = *ppos;
-		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
-	}
-}
-
 /*
  * If this was a direct or synchronous I/O that failed (such as ENOSPC) then
  * part of the I/O may have been written to disk before the error occurred.  In
@@ -444,8 +420,8 @@ xfs_aio_write_newsize_update(
 		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
 		if (new_size == ip->i_new_size)
 			ip->i_new_size = 0;
-		if (ip->i_d.di_size > ip->i_size)
-			ip->i_d.di_size = ip->i_size;
+		if (ip->i_d.di_size > i_size_read(VFS_I(ip)))
+			ip->i_d.di_size = i_size_read(VFS_I(ip));
 		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 }
@@ -485,15 +461,16 @@ xfs_file_splice_write(
 	new_size = *ppos + count;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (new_size > ip->i_size)
+	if (new_size > i_size_read(inode))
 		ip->i_new_size = new_size;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
 
 	ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
+	if (ret > 0)
+		XFS_STATS_ADD(xs_write_bytes, ret);
 
-	xfs_aio_write_isize_update(inode, ppos, ret);
 	xfs_aio_write_newsize_update(ip, new_size);
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	return ret;
@@ -723,14 +700,14 @@ restart:
 	 * values are still valid.
 	 */
 	if ((ip->i_new_size && *pos > ip->i_new_size) ||
-	    (!ip->i_new_size && *pos > ip->i_size)) {
+	    (!ip->i_new_size && *pos > i_size_read(inode))) {
 		if (*iolock == XFS_IOLOCK_SHARED) {
 			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
 			*iolock = XFS_IOLOCK_EXCL;
 			xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
 			goto restart;
 		}
-		error = -xfs_zero_eof(ip, *pos, ip->i_size);
+		error = -xfs_zero_eof(ip, *pos, i_size_read(inode));
 	}
 
 	/*
@@ -739,7 +716,7 @@ restart:
 	 * ip->i_new_size if this IO ends beyond any other in-flight writes.
 	 */
 	new_size = *pos + *count;
-	if (new_size > ip->i_size) {
+	if (new_size > i_size_read(inode)) {
 		if (new_size > ip->i_new_size)
 			ip->i_new_size = new_size;
 		*new_sizep = new_size;
@@ -952,11 +929,11 @@ xfs_file_aio_write(
 		ret = xfs_file_buffered_aio_write(iocb, iovp, nr_segs, pos,
 						ocount, &new_size, &iolock);
 
-	xfs_aio_write_isize_update(inode, &iocb->ki_pos, ret);
-
 	if (ret <= 0)
 		goto out_unlock;
 
+	XFS_STATS_ADD(xs_write_bytes, ret);
+
 	/* Handle various SYNC-type writes */
 	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
 		loff_t end = pos + ret - 1;
diff --git a/fs/xfs/linux-2.6/xfs_fs_subr.c b/fs/xfs/linux-2.6/xfs_fs_subr.c
index ed88ed1..652b875 100644
--- a/fs/xfs/linux-2.6/xfs_fs_subr.c
+++ b/fs/xfs/linux-2.6/xfs_fs_subr.c
@@ -90,7 +90,7 @@ xfs_wait_on_pages(
 
 	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
 		return -filemap_fdatawait_range(mapping, first,
-					last == -1 ? ip->i_size - 1 : last);
+					last == -1 ? XFS_ISIZE(ip) - 1 : last);
 	}
 	return 0;
 }
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 05ea68f..51b3489 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4045,11 +4045,8 @@ xfs_bmap_one_block(
 	xfs_bmbt_irec_t	s;		/* internal version of extent */
 
 #ifndef DEBUG
-	if (whichfork == XFS_DATA_FORK) {
-		return ((ip->i_d.di_mode & S_IFMT) == S_IFREG) ?
-			(ip->i_size == ip->i_mount->m_sb.sb_blocksize) :
-			(ip->i_d.di_size == ip->i_mount->m_sb.sb_blocksize);
-	}
+	if (whichfork == XFS_DATA_FORK)
+		return XFS_ISIZE(ip) == ip->i_mount->m_sb.sb_blocksize;
 #endif	/* !DEBUG */
 	if (XFS_IFORK_NEXTENTS(ip, whichfork) != 1)
 		return 0;
@@ -4061,7 +4058,7 @@ xfs_bmap_one_block(
 	xfs_bmbt_get_all(ep, &s);
 	rval = s.br_startoff == 0 && s.br_blockcount == 1;
 	if (rval && whichfork == XFS_DATA_FORK)
-		ASSERT(ip->i_size == ip->i_mount->m_sb.sb_blocksize);
+		ASSERT(XFS_ISIZE(ip) == ip->i_mount->m_sb.sb_blocksize);
 	return rval;
 }
 
@@ -5346,7 +5343,7 @@ xfs_getbmapx_fix_eof_hole(
 	if (startblock == HOLESTARTBLOCK) {
 		mp = ip->i_mount;
 		out->bmv_block = -1;
-		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, ip->i_size));
+		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, XFS_ISIZE(ip)));
 		fixlen -= out->bmv_offset;
 		if (prealloced && out->bmv_offset + out->bmv_length == end) {
 			/* Came to hole at EOF. Trim it. */
@@ -5434,7 +5431,7 @@ xfs_getbmap(
 			fixlen = XFS_MAXIOFFSET(mp);
 		} else {
 			prealloced = 0;
-			fixlen = ip->i_size;
+			fixlen = XFS_ISIZE(ip);
 		}
 	}
 
@@ -5463,7 +5460,7 @@ xfs_getbmap(
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
-		if (ip->i_delayed_blks || ip->i_size > ip->i_d.di_size) {
+		if (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size) {
 			error = xfs_flush_pages(ip, 0, -1, 0, FI_REMAPF);
 			if (error)
 				goto out_unlock_iolock;
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index ca752f0..4c8df0b 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -96,7 +96,6 @@ xfs_inode_alloc(
 	ip->i_update_core = 0;
 	ip->i_delayed_blks = 0;
 	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
-	ip->i_size = 0;
 	ip->i_new_size = 0;
 
 	return ip;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2966b4d..1c6788a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -357,7 +357,6 @@ xfs_iformat(
 			return XFS_ERROR(EFSCORRUPTED);
 		}
 		ip->i_d.di_size = 0;
-		ip->i_size = 0;
 		ip->i_df.if_u2.if_rdev = xfs_dinode_get_rdev(dip);
 		break;
 
@@ -868,7 +867,6 @@ xfs_iread(
 	}
 
 	ip->i_delayed_blks = 0;
-	ip->i_size = ip->i_d.di_size;
 
 	/*
 	 * Mark the buffer containing the inode as something to keep
@@ -1058,7 +1056,6 @@ xfs_ialloc(
 	}
 
 	ip->i_d.di_size = 0;
-	ip->i_size = 0;
 	ip->i_d.di_nextents = 0;
 	ASSERT(ip->i_d.di_nblocks == 0);
 
@@ -1257,7 +1254,7 @@ xfs_file_last_byte(
 	} else {
 		last_block = 0;
 	}
-	size_last_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)ip->i_size);
+	size_last_block = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
 	last_block = XFS_FILEOFF_MAX(last_block, size_last_block);
 
 	last_byte = XFS_FSB_TO_B(mp, last_block);
@@ -1314,14 +1311,14 @@ xfs_itruncate_start(
 	int		error = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
-	ASSERT((new_size == 0) || (new_size <= ip->i_size));
+	ASSERT(new_size == 0 || new_size <= XFS_ISIZE(ip));
 	ASSERT((flags == XFS_ITRUNC_DEFINITE) ||
 	       (flags == XFS_ITRUNC_MAYBE));
 
 	mp = ip->i_mount;
 
 	/* wait for the completion of any pending DIOs */
-	if (new_size == 0 || new_size < ip->i_size)
+	if (new_size == 0 || new_size < XFS_ISIZE(ip))
 		xfs_ioend_wait(ip);
 
 	/*
@@ -1438,7 +1435,7 @@ xfs_itruncate_finish(
 	int		error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
-	ASSERT((new_size == 0) || (new_size <= ip->i_size));
+	ASSERT(new_size == 0 || new_size <= XFS_ISIZE(ip));
 	ASSERT(*tp != NULL);
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(ip->i_transp == *tp);
@@ -1522,9 +1519,8 @@ xfs_itruncate_finish(
 			 * flushed to disk then the files may be full of
 			 * holes (ie NULL files bug).
 			 */
-			if (ip->i_size != new_size) {
+			if (ip->i_d.di_size != new_size) {
 				ip->i_d.di_size = new_size;
-				ip->i_size = new_size;
 				xfs_trans_log_inode(ntp, ip, XFS_ILOG_CORE);
 			}
 		}
@@ -1648,9 +1644,8 @@ xfs_itruncate_finish(
 		 * flushed to disk then the files may be full of
 		 * holes (ie NULL files bug).
 		 */
-		if (ip->i_size != new_size) {
+		if (ip->i_d.di_size != new_size) {
 			ip->i_d.di_size = new_size;
-			ip->i_size = new_size;
 		}
 	}
 	xfs_trans_log_inode(ntp, ip, XFS_ILOG_CORE);
@@ -2085,8 +2080,7 @@ xfs_ifree(
 	ASSERT(ip->i_d.di_nlink == 0);
 	ASSERT(ip->i_d.di_nextents == 0);
 	ASSERT(ip->i_d.di_anextents == 0);
-	ASSERT((ip->i_d.di_size == 0 && ip->i_size == 0) ||
-	       ((ip->i_d.di_mode & S_IFMT) != S_IFREG));
+	ASSERT(ip->i_d.di_size == 0 || !S_ISREG(ip->i_d.di_mode));
 	ASSERT(ip->i_d.di_nblocks == 0);
 
 	/*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 8a0979a..ed1c89e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -256,7 +256,6 @@ typedef struct xfs_inode {
 
 	xfs_icdinode_t		i_d;		/* most of ondisk inode */
 
-	xfs_fsize_t		i_size;		/* in-memory size */
 	xfs_fsize_t		i_new_size;	/* size when write completes */
 	atomic_t		i_iocount;	/* outstanding I/O count */
 
@@ -264,9 +263,6 @@ typedef struct xfs_inode {
 	struct inode		i_vnode;	/* embedded VFS inode */
 } xfs_inode_t;
 
-#define XFS_ISIZE(ip)	(((ip)->i_d.di_mode & S_IFMT) == S_IFREG) ? \
-				(ip)->i_size : (ip)->i_d.di_size;
-
 /* Convert from vfs inode to xfs inode */
 static inline struct xfs_inode *XFS_I(struct inode *inode)
 {
@@ -280,6 +276,18 @@ static inline struct inode *VFS_I(struct xfs_inode *ip)
 }
 
 /*
+ * For regular files we only update the on-disk filesize when actually
+ * writing data back to disk.  Until then only the copy in the VFS inode
+ * is uptodate.
+ */
+static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
+{
+	if (S_ISREG(ip->i_d.di_mode))
+		return i_size_read(VFS_I(ip));
+	return ip->i_d.di_size;
+}
+
+/*
  * i_flags helper functions
  */
 static inline void
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 091d82b..4460beb 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -68,14 +68,14 @@ xfs_iomap_eof_align_last_fsb(
 	 * stripe width and we are allocating past the allocation eof.
 	 */
 	else if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC) &&
-	        (ip->i_size >= XFS_FSB_TO_B(mp, mp->m_swidth)))
+	        (XFS_ISIZE(ip) >= XFS_FSB_TO_B(mp, mp->m_swidth)))
 		new_last_fsb = roundup_64(*last_fsb, mp->m_swidth);
 	/*
 	 * Roundup the allocation request to a stripe unit (m_dalign) boundary
 	 * if the file size is >= stripe unit size, and we are allocating past
 	 * the allocation eof.
 	 */
-	else if (mp->m_dalign && (ip->i_size >= XFS_FSB_TO_B(mp, mp->m_dalign)))
+	else if (mp->m_dalign && (XFS_ISIZE(ip) >= XFS_FSB_TO_B(mp, mp->m_dalign)))
 		new_last_fsb = roundup_64(*last_fsb, mp->m_dalign);
 
 	/*
@@ -154,7 +154,7 @@ xfs_iomap_write_direct(
 
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
-	if ((offset + count) > ip->i_size) {
+	if ((offset + count) > XFS_ISIZE(ip)) {
 		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
 		if (error)
 			goto error_out;
@@ -211,7 +211,7 @@ xfs_iomap_write_direct(
 	xfs_trans_ijoin(tp, ip);
 
 	bmapi_flag = XFS_BMAPI_WRITE;
-	if (offset < ip->i_size || extsz)
+	if (offset < XFS_ISIZE(ip) || extsz)
 		bmapi_flag |= XFS_BMAPI_PREALLOC;
 
 	/*
@@ -288,7 +288,7 @@ xfs_iomap_eof_want_preallocate(
 	int		found_delalloc = 0;
 
 	*prealloc = 0;
-	if ((offset + count) <= ip->i_size)
+	if (offset + count <= XFS_ISIZE(ip))
 		return 0;
 
 	/*
@@ -342,7 +342,7 @@ xfs_iomap_prealloc_size(
 		 * if we pass in alloc_blocks = 0. Hence the "+ 1" to
 		 * ensure we always pass in a non-zero value.
 		 */
-		alloc_blocks = XFS_B_TO_FSB(mp, ip->i_size) + 1;
+		alloc_blocks = XFS_B_TO_FSB(mp, XFS_ISIZE(ip)) + 1;
 		alloc_blocks = XFS_FILEOFF_MIN(MAXEXTLEN,
 					rounddown_pow_of_two(alloc_blocks));
 
@@ -571,7 +571,7 @@ xfs_iomap_write_allocate(
 			 * back....
 			 */
 			nimaps = 1;
-			end_fsb = XFS_B_TO_FSB(mp, ip->i_size);
+			end_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
 			error = xfs_bmap_last_offset(NULL, ip, &last_block,
 							XFS_DATA_FORK);
 			if (error)
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 44f780c..23a25e6 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -179,9 +179,11 @@ xfs_setattr(
 	 * Truncate file.  Must have write permission and not be a directory.
 	 */
 	if (mask & ATTR_SIZE) {
+		loff_t	old_size = XFS_ISIZE(ip);
+
 		/* Short circuit the truncate case for zero length files */
 		if (iattr->ia_size == 0 &&
-		    ip->i_size == 0 && ip->i_d.di_nextents == 0) {
+		    old_size == 0 && ip->i_d.di_nextents == 0) {
 			xfs_iunlock(ip, XFS_ILOCK_EXCL);
 			lock_flags &= ~XFS_ILOCK_EXCL;
 			if (mask & ATTR_CTIME) {
@@ -216,14 +218,14 @@ xfs_setattr(
 		 * to the transaction, because the inode cannot be unlocked
 		 * once it is a part of the transaction.
 		 */
-		if (iattr->ia_size > ip->i_size) {
+		if (iattr->ia_size > old_size) {
 			/*
 			 * Do the first part of growing a file: zero any data
 			 * in the last block that is beyond the old EOF.  We
 			 * need to do this before the inode is joined to the
 			 * transaction to modify the i_size.
 			 */
-			code = xfs_zero_eof(ip, iattr->ia_size, ip->i_size);
+			code = xfs_zero_eof(ip, iattr->ia_size, old_size);
 			if (code)
 				goto error_return;
 		}
@@ -242,7 +244,7 @@ xfs_setattr(
 		 * really care about here and prevents waiting for other data
 		 * not within the range we care about here.
 		 */
-		if (ip->i_size != ip->i_d.di_size &&
+		if (old_size != ip->i_d.di_size &&
 		    iattr->ia_size > ip->i_d.di_size) {
 			code = xfs_flush_pages(ip,
 					ip->i_d.di_size, iattr->ia_size,
@@ -287,18 +289,17 @@ xfs_setattr(
 		 * VFS set these flags explicitly if it wants a timestamp
 		 * update.
 		 */
-		if (iattr->ia_size != ip->i_size &&
+		if (iattr->ia_size != old_size &&
 		    (!(mask & (ATTR_CTIME | ATTR_MTIME)))) {
 			iattr->ia_ctime = iattr->ia_mtime =
 				current_fs_time(inode->i_sb);
 			mask |= ATTR_CTIME | ATTR_MTIME;
 		}
 
-		if (iattr->ia_size > ip->i_size) {
+		if (iattr->ia_size > old_size) {
 			ip->i_d.di_size = iattr->ia_size;
-			ip->i_size = iattr->ia_size;
 			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		} else if (iattr->ia_size <= ip->i_size ||
+		} else if (iattr->ia_size <= old_size ||
 			   (iattr->ia_size == 0 && ip->i_d.di_nextents)) {
 			/*
 			 * signal a sync transaction unless
@@ -598,7 +599,7 @@ xfs_free_eofblocks(
 	 * Figure out if there are any blocks beyond the end
 	 * of the file.  If not, then there is nothing to do.
 	 */
-	end_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)ip->i_size));
+	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
 	last_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_MAXIOFFSET(mp));
 	if (last_fsb <= end_fsb)
 		return 0;
@@ -643,7 +644,7 @@ xfs_free_eofblocks(
 			xfs_ilock(ip, XFS_IOLOCK_EXCL);
 		}
 		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
-				    ip->i_size);
+				    XFS_ISIZE(ip));
 		if (error) {
 			xfs_trans_cancel(tp, 0);
 			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
@@ -665,7 +666,7 @@ xfs_free_eofblocks(
 		xfs_trans_ijoin(tp, ip);
 
 		error = xfs_itruncate_finish(&tp, ip,
-					     ip->i_size,
+					     XFS_ISIZE(ip),
 					     XFS_DATA_FORK,
 					     0);
 		/*
@@ -981,7 +982,7 @@ xfs_release(
 		return 0;
 
 	if ((((ip->i_d.di_mode & S_IFMT) == S_IFREG) &&
-	     ((ip->i_size > 0) || (VN_CACHED(VFS_I(ip)) > 0 ||
+	     ((XFS_ISIZE(ip) > 0) || (VN_CACHED(VFS_I(ip)) > 0 ||
 	       ip->i_delayed_blks > 0)) &&
 	     (ip->i_df.if_flags & XFS_IFEXTENTS))  &&
 	    (!(ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {
@@ -1059,7 +1060,7 @@ xfs_inactive(
 	 * only one with a reference to the inode.
 	 */
 	truncate = ((ip->i_d.di_nlink == 0) &&
-	    ((ip->i_d.di_size != 0) || (ip->i_size != 0) ||
+	    ((ip->i_d.di_size != 0) || XFS_ISIZE(ip) != 0 ||
 	     (ip->i_d.di_nextents > 0) || (ip->i_delayed_blks > 0)) &&
 	    ((ip->i_d.di_mode & S_IFMT) == S_IFREG));
 
@@ -1073,7 +1074,7 @@ xfs_inactive(
 
 	if (ip->i_d.di_nlink != 0) {
 		if ((((ip->i_d.di_mode & S_IFMT) == S_IFREG) &&
-                     ((ip->i_size > 0) || (VN_CACHED(VFS_I(ip)) > 0 ||
+                     ((XFS_ISIZE(ip) > 0) || (VN_CACHED(VFS_I(ip)) > 0 ||
                        ip->i_delayed_blks > 0)) &&
 		      (ip->i_df.if_flags & XFS_IFEXTENTS) &&
 		     (!(ip->i_d.di_flags &
@@ -2431,11 +2432,11 @@ xfs_zero_remaining_bytes(
 	 * since nothing can read beyond eof.  The space will
 	 * be zeroed when the file is extended anyway.
 	 */
-	if (startoff >= ip->i_size)
+	if (startoff >= XFS_ISIZE(ip))
 		return 0;
 
-	if (endoff > ip->i_size)
-		endoff = ip->i_size;
+	if (endoff > XFS_ISIZE(ip))
+		endoff = XFS_ISIZE(ip);
 
 	bp = xfs_buf_get_uncached(XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp,
@@ -2729,7 +2730,7 @@ xfs_change_file_space(
 		bf->l_start += offset;
 		break;
 	case 2: /*SEEK_END*/
-		bf->l_start += ip->i_size;
+		bf->l_start += XFS_ISIZE(ip);
 		break;
 	default:
 		return XFS_ERROR(EINVAL);
@@ -2746,7 +2747,7 @@ xfs_change_file_space(
 	bf->l_whence = 0;
 
 	startoffset = bf->l_start;
-	fsize = ip->i_size;
+	fsize = XFS_ISIZE(ip);
 
 	/*
 	 * XFS_IOC_RESVSP and XFS_IOC_UNRESVSP will reserve or unreserve
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
