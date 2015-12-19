Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6E3E80D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:04:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2B718AC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:10 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 6Kb3y7HSh8GzkuX5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:07 -0800 (PST)
Subject: [PATCH 69/76] xfs: unshare a range of blocks via fallocate
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:04:04 -0800
Message-ID: <20151219090404.12713.38510.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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

Now that we have an fallocate flag to unshare a range of blocks, make
XFS actually implement it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c    |    6 +
 fs/xfs/xfs_reflink.c |  317 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    3 
 3 files changed, 325 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index afca713..e6bc6ab 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1011,9 +1011,13 @@ xfs_file_fallocate(
 
 		if (mode & FALLOC_FL_ZERO_RANGE)
 			error = xfs_zero_file_space(ip, offset, len);
-		else
+		else {
+			error = xfs_reflink_unshare(ip, file, offset, len);
+			if (error)
+				goto out_unlock;
 			error = xfs_alloc_file_space(ip, offset, len,
 						     XFS_BMAPI_PREALLOC);
+		}
 		if (error)
 			goto out_unlock;
 	}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index c686583..f68df66 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1285,3 +1285,320 @@ out_error:
 		trace_xfs_reflink_remap_range_error(dest, error, _RET_IP_);
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
+	xfs_extlen_t		aglen;
+	xfs_agblock_t		rbno;
+	xfs_extlen_t		rlen;
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
+			aglen = map[1].br_blockcount;
+
+			error = xfs_refcount_find_shared(mp, agno, agbno, aglen,
+							 &rbno, &rlen, true);
+			if (error)
+				goto out;
+			if (rlen == 0)
+				goto skip_copy;
+
+			/* Dirty the pages */
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			fpos = XFS_FSB_TO_B(mp, map[1].br_startoff +
+					(rbno - agbno));
+			flen = XFS_FSB_TO_B(mp, rlen);
+			if (fpos + flen > isize)
+				flen = isize - fpos;
+			error = xfs_reflink_dirty_range(filp, fpos, flen);
+			xfs_ilock(ip, XFS_ILOCK_EXCL);
+			if (error)
+				goto out;
+skip_copy:
+			map[1].br_blockcount -= (rbno - agbno + rlen);
+			map[1].br_startoff += (rbno - agbno + rlen);
+			map[1].br_startblock += (rbno - agbno + rlen);
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
+	xfs_extlen_t		aglen;
+	xfs_agblock_t		rbno;
+	xfs_extlen_t		rlen;
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
+			aglen = map[1].br_blockcount;
+
+			error = xfs_refcount_find_shared(mp, agno, agbno, aglen,
+							 &rbno, &rlen, false);
+			if (error)
+				goto out;
+			/* Is there still a shared block here? */
+			if (rlen > 0) {
+				error = 0;
+				goto out;
+			}
+
+			map[1].br_blockcount -= aglen;
+			map[1].br_startoff += aglen;
+			map[1].br_startblock += aglen;
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
+	if (!xfs_is_reflink_inode(ip))
+		return 0;
+
+	trace_xfs_reflink_unshare(ip, offset, len);
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
index 42eb860..1904b32 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -44,4 +44,7 @@ extern int xfs_reflink_remap_range(struct xfs_inode *src, xfs_off_t srcoff,
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
