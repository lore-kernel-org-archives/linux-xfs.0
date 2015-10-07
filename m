Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CA6DD7FB6
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:01:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 58326AC006
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:01:29 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ptFs5WdwUS2P5zqt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:01:27 -0700 (PDT)
Subject: [PATCH 56/58] xfs: unshare a range of blocks via fallocate
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:01:17 -0700
Message-ID: <20151007050117.30457.17142.stgit@birch.djwong.org>
In-Reply-To: <20151007045443.30457.47038.stgit@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Now that we have an fallocate flag to unshare a range of blocks, make
XFS actually implement it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c    |   11 ++
 fs/xfs/xfs_reflink.c |  321 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    3 
 3 files changed, 334 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index fc5b9ea..5756046 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -905,7 +905,7 @@ buffered:
 #define	XFS_FALLOC_FL_SUPPORTED						\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
 		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
-		 FALLOC_FL_INSERT_RANGE)
+		 FALLOC_FL_INSERT_RANGE | FALLOC_FL_UNSHARE_RANGE)
 
 STATIC long
 xfs_file_fallocate(
@@ -982,6 +982,15 @@ xfs_file_fallocate(
 			goto out_unlock;
 		}
 		do_file_insert = 1;
+	} else if (mode & FALLOC_FL_UNSHARE_RANGE) {
+		if (offset + len > i_size_read(inode)) {
+			error = -EINVAL;
+			goto out_unlock;
+		}
+
+		error = xfs_reflink_unshare(ip, file, offset, len);
+		if (error)
+			goto out_unlock;
 	} else {
 		flags |= XFS_PREALLOC_SET;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index dee3556..92d8345 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1571,3 +1571,324 @@ out_error:
 		trace_xfs_reflink_range_error(dest, error, _RET_IP_);
 	return error;
 }
+
+/**
+ * xfs_reflink_dirty_range() -- Dirty all the shared blocks in the file so that
+ * they're rewritten elsewhere.  Similar to generic_perform_write().
+ *
+ * @filp: VFS file pointer
+ * @pos: offset to start dirtying
+ * @len: number of bytes to dirty
+ */
+STATIC int
+xfs_reflink_dirty_range(
+	struct file		*filp,
+	xfs_off_t		pos,
+	xfs_off_t		len)
+{
+	struct address_space	*mapping;
+	const struct address_space_operations *a_ops;
+	int			error;
+	unsigned int		flags;
+	struct page		*page;
+	struct page		*rpage;
+	unsigned long		offset;	/* Offset into pagecache page */
+	unsigned long		bytes;	/* Bytes to write to page */
+	void			*fsdata;
+
+	mapping = filp->f_mapping;
+	a_ops = mapping->a_ops;
+	flags = AOP_FLAG_UNINTERRUPTIBLE;
+	do {
+
+		offset = (pos & (PAGE_CACHE_SIZE - 1));
+		bytes = min_t(unsigned long, len, PAGE_CACHE_SIZE) - offset;
+		rpage = xfs_get_page(file_inode(filp), pos);
+		if (IS_ERR(rpage)) {
+			error = PTR_ERR(rpage);
+			break;
+		} else if (!rpage) {
+			error = -ENOMEM;
+			break;
+		}
+
+		error = a_ops->write_begin(filp, mapping, pos, bytes, flags,
+					   &page, &fsdata);
+		page_cache_release(rpage);
+		if (error < 0)
+			break;
+
+		trace_xfs_reflink_unshare_page(file_inode(filp), page,
+				pos, bytes);
+
+		if (!PageUptodate(page)) {
+			pr_err("%s: STALE? ino=%lu pos=%llu\n",
+				__func__, filp->f_inode->i_ino, pos);
+			WARN_ON(1);
+		}
+		if (mapping_writably_mapped(mapping))
+			flush_dcache_page(page);
+
+		error = a_ops->write_end(filp, mapping, pos, bytes, bytes,
+					 page, fsdata);
+		if (error < 0)
+			break;
+		else if (error == 0) {
+			error = -EIO;
+			break;
+		} else {
+			bytes = error;
+			error = 0;
+		}
+
+		cond_resched();
+
+		pos += bytes;
+		len -= bytes;
+
+		balance_dirty_pages_ratelimited(mapping);
+		if (fatal_signal_pending(current)) {
+			error = -EINTR;
+			break;
+		}
+	} while (len > 0);
+
+	return error;
+}
+
+/*
+ * The user wants to preemptively CoW all shared blocks in this file,
+ * which enables us to turn off the reflink flag.  Iterate all
+ * extents which are not prealloc/delalloc to see which ranges are
+ * mentioned in the refcount tree, then read those blocks into the
+ * pagecache, dirty them, fsync them back out, and then we can update
+ * the inode flag.  What happens if we run out of memory? :)
+ */
+STATIC int
+xfs_reflink_dirty_extents(
+	struct xfs_inode	*ip,
+	struct file		*filp,
+	xfs_fileoff_t		fbno,
+	xfs_filblks_t		end,
+	xfs_off_t		isize)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	xfs_extlen_t		rlen;
+	xfs_nlink_t		nr;
+	xfs_off_t		fpos;
+	xfs_off_t		flen;
+	struct xfs_bmbt_irec	map[2];
+	int			nmaps;
+	int			error;
+
+	while (end - fbno > 0) {
+		nmaps = 1;
+		/*
+		 * Look for extents in the file.  Skip holes, delalloc, or
+		 * unwritten extents; they can't be reflinked.
+		 */
+		error = xfs_bmapi_read(ip, fbno, end - fbno, map, &nmaps, 0);
+		if (error)
+			goto out;
+		if (nmaps == 0)
+			break;
+		if (map[0].br_startblock == HOLESTARTBLOCK ||
+		    map[0].br_startblock == DELAYSTARTBLOCK ||
+		    ISUNWRITTEN(&map[0]))
+			goto next;
+
+		map[1] = map[0];
+		while (map[1].br_blockcount) {
+			agno = XFS_FSB_TO_AGNO(mp, map[1].br_startblock);
+			agbno = XFS_FSB_TO_AGBNO(mp, map[1].br_startblock);
+			CHECK_AG_NUMBER(mp, agno);
+			CHECK_AG_EXTENT(mp, agbno, 1);
+
+			error = xfs_reflink_get_refcount(mp, agno, agbno,
+							 &rlen, &nr);
+			if (error)
+				goto out;
+			XFS_WANT_CORRUPTED_GOTO(mp, rlen != 0, out);
+			if (rlen > map[1].br_blockcount)
+				rlen = map[1].br_blockcount;
+			if (nr < 2)
+				goto skip_copy;
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			fpos = XFS_FSB_TO_B(mp, map[1].br_startoff);
+			flen = XFS_FSB_TO_B(mp, rlen);
+			if (fpos + flen > isize)
+				flen = isize - fpos;
+			error = xfs_reflink_dirty_range(filp, fpos, flen);
+			xfs_ilock(ip, XFS_ILOCK_EXCL);
+			if (error)
+				goto out;
+skip_copy:
+			map[1].br_blockcount -= rlen;
+			map[1].br_startoff += rlen;
+			map[1].br_startblock += rlen;
+		}
+
+next:
+		fbno = map[0].br_startoff + map[0].br_blockcount;
+	}
+out:
+	return error;
+}
+
+/* Iterate the extents; if there are no reflinked blocks, clear the flag. */
+STATIC int
+xfs_reflink_try_clear_inode_flag(
+	struct xfs_inode	*ip,
+	xfs_off_t		old_isize)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	xfs_fileoff_t		fbno;
+	xfs_filblks_t		end;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	xfs_extlen_t		rlen;
+	xfs_nlink_t		nr;
+	struct xfs_bmbt_irec	map[2];
+	int			nmaps;
+	int			error = 0;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	if (old_isize != i_size_read(VFS_I(ip)))
+		goto out;
+	if (!(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK))
+		goto out;
+
+	fbno = 0;
+	end = XFS_B_TO_FSB(mp, old_isize);
+	while (end - fbno > 0) {
+		nmaps = 1;
+		/*
+		 * Look for extents in the file.  Skip holes, delalloc, or
+		 * unwritten extents; they can't be reflinked.
+		 */
+		error = xfs_bmapi_read(ip, fbno, end - fbno, map, &nmaps, 0);
+		if (error)
+			goto out;
+		if (nmaps == 0)
+			break;
+		if (map[0].br_startblock == HOLESTARTBLOCK ||
+		    map[0].br_startblock == DELAYSTARTBLOCK ||
+		    ISUNWRITTEN(&map[0]))
+			goto next;
+
+		map[1] = map[0];
+		while (map[1].br_blockcount) {
+			agno = XFS_FSB_TO_AGNO(mp, map[1].br_startblock);
+			agbno = XFS_FSB_TO_AGBNO(mp, map[1].br_startblock);
+			CHECK_AG_NUMBER(mp, agno);
+			CHECK_AG_EXTENT(mp, agbno, 1);
+
+			error = xfs_reflink_get_refcount(mp, agno, agbno,
+							 &rlen, &nr);
+			if (error)
+				goto out;
+			XFS_WANT_CORRUPTED_GOTO(mp, rlen != 0, out);
+			if (rlen > map[1].br_blockcount)
+				rlen = map[1].br_blockcount;
+			/* Someone else is reflinking */
+			if (nr >= 2) {
+				error = 0;
+				goto out;
+			}
+
+			map[1].br_blockcount -= rlen;
+			map[1].br_startoff += rlen;
+			map[1].br_startblock += rlen;
+		}
+
+next:
+		fbno = map[0].br_startoff + map[0].br_blockcount;
+	}
+
+	/* No reflinked blocks, so clear the flag */
+	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out;
+	}
+	trace_xfs_reflink_unset_inode_flag(ip);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	error = xfs_trans_commit(tp);
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out;
+	}
+
+	return 0;
+out:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
+/**
+ * xfs_reflink_unshare() - Pre-COW all shared blocks within a given range
+ *			   of a file and turn off the reflink flag if we
+ *			   unshare all of the file's blocks.
+ * @ip: XFS inode
+ * @filp: VFS file structure
+ * @offset: Offset to start
+ * @len: Length to ...
+ */
+int
+xfs_reflink_unshare(
+	struct xfs_inode	*ip,
+	struct file		*filp,
+	xfs_off_t		offset,
+	xfs_off_t		len)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		fbno;
+	xfs_filblks_t		end;
+	xfs_off_t		old_isize, isize;
+	int			error;
+
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
+	    !xfs_is_reflink_inode(ip))
+		return 0;
+
+	trace_xfs_reflink_unshare(ip);
+
+	inode_dio_wait(VFS_I(ip));
+
+	/* Try to CoW the selected ranges */
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	fbno = XFS_B_TO_FSB(mp, offset);
+	old_isize = isize = i_size_read(VFS_I(ip));
+	end = XFS_B_TO_FSB(mp, offset + len);
+	error = xfs_reflink_dirty_extents(ip, filp, fbno, end, isize);
+	if (error)
+		goto out_unlock;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	/* Wait for the IO to finish */
+	error = filemap_write_and_wait(filp->f_mapping);
+	if (error)
+		goto out;
+
+	/* Turn off the reflink flag if we unshared the whole file */
+	if (offset == 0 && len == isize) {
+		error = xfs_reflink_try_clear_inode_flag(ip, old_isize);
+		if (error)
+			goto out;
+	}
+
+	return 0;
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out:
+	trace_xfs_reflink_unshare_error(ip, error, _RET_IP_);
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index c60a9bd..4ce2cba6 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -51,4 +51,7 @@ extern int xfs_reflink(struct xfs_inode *src, xfs_off_t srcoff,
 		struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len,
 		unsigned int flags);
 
+extern int xfs_reflink_unshare(struct xfs_inode *ip, struct file *filp,
+		xfs_off_t offset, xfs_off_t len);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
