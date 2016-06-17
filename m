Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 11FC07EAE
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:28:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B97C48F804C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:28:09 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id cTlEJpWOx9oClJjB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:28:07 -0700 (PDT)
Subject: [PATCH 094/119] xfs: unshare a range of blocks via fallocate
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:27:58 -0700
Message-ID: <146612687793.12839.6066978539560923776.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Now that we have an fallocate flag to unshare a range of blocks, make
XFS actually implement it.

v2: NFS doesn't pass around struct file pointers, which means that our
unshare functions all crash when filp == NULL.  We don't need filp
anyway, so remove all the parts where we pass filp around.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch@lst.de: pass inode instead of file to xfs_reflink_dirty_range]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c    |    6 +
 fs/xfs/xfs_reflink.c |  314 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    2 
 3 files changed, 321 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 02e9139..618bd12 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1011,9 +1011,13 @@ xfs_file_fallocate(
 
 		if (mode & FALLOC_FL_ZERO_RANGE)
 			error = xfs_zero_file_space(ip, offset, len);
-		else
+		else {
+			error = xfs_reflink_unshare(ip, offset, len);
+			if (error)
+				goto out_unlock;
 			error = xfs_alloc_file_space(ip, offset, len,
 						     XFS_BMAPI_PREALLOC);
+		}
 		if (error)
 			goto out_unlock;
 	}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index c42a6e1..78f24c3 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1426,3 +1426,317 @@ out_error:
 		trace_xfs_reflink_remap_range_error(dest, error, _RET_IP_);
 	return error;
 }
+
+/*
+ * Dirty all the shared blocks within a byte range of a file so that they're
+ * rewritten elsewhere.  Similar to generic_perform_write().
+ */
+static int
+xfs_reflink_dirty_range(
+	struct inode		*inode,
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
+	mapping = inode->i_mapping;
+	a_ops = mapping->a_ops;
+	flags = AOP_FLAG_UNINTERRUPTIBLE;
+	do {
+
+		offset = (pos & (PAGE_SIZE - 1));
+		bytes = min_t(unsigned long, PAGE_SIZE - offset, len);
+		rpage = xfs_get_page(inode, pos);
+		if (IS_ERR(rpage)) {
+			error = PTR_ERR(rpage);
+			break;
+		}
+
+		unlock_page(rpage);
+		error = a_ops->write_begin(NULL, mapping, pos, bytes, flags,
+					   &page, &fsdata);
+		put_page(rpage);
+		if (error < 0)
+			break;
+
+		trace_xfs_reflink_unshare_page(inode, page, pos, bytes);
+
+		if (!PageUptodate(page)) {
+			xfs_err(XFS_I(inode)->i_mount,
+					"%s: STALE? ino=%llu pos=%llu\n",
+					__func__, XFS_I(inode)->i_ino, pos);
+			WARN_ON(1);
+		}
+		if (mapping_writably_mapped(mapping))
+			flush_dcache_page(page);
+
+		error = a_ops->write_end(NULL, mapping, pos, bytes, bytes,
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
+			error = xfs_reflink_dirty_range(VFS_I(ip), fpos, flen);
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
+	/* Start a rolling transaction to remove the mappings */
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	if (old_isize != i_size_read(VFS_I(ip)))
+		goto cancel;
+	if (!(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK))
+		goto cancel;
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
+			goto cancel;
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
+				goto cancel;
+			/* Is there still a shared block here? */
+			if (rlen > 0) {
+				error = 0;
+				goto cancel;
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
+	/*
+	 * We didn't find any shared blocks so turn off the reflink flag.
+	 * First, get rid of any leftover CoW mappings.
+	 */
+	error = xfs_reflink_cancel_cow_blocks(ip, &tp, 0, NULLFILEOFF);
+	if (error)
+		goto cancel;
+
+	/* Clear the inode flag. */
+	trace_xfs_reflink_unset_inode_flag(ip);
+	ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+	xfs_trans_ijoin(tp, ip, 0);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out;
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return 0;
+cancel:
+	xfs_trans_cancel(tp);
+out:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
+/*
+ * Pre-COW all shared blocks within a given byte range of a file and turn off
+ * the reflink flag if we unshare all of the file's blocks.
+ */
+int
+xfs_reflink_unshare(
+	struct xfs_inode	*ip,
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
+	error = xfs_reflink_dirty_extents(ip, fbno, end, isize);
+	if (error)
+		goto out_unlock;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	/* Wait for the IO to finish */
+	error = filemap_write_and_wait(VFS_I(ip)->i_mapping);
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
index 1d38b97..a369b2a 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -48,6 +48,8 @@ extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
 extern int xfs_reflink_remap_range(struct xfs_inode *src, xfs_off_t srcoff,
 		struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len,
 		unsigned int flags);
+extern int xfs_reflink_unshare(struct xfs_inode *ip, xfs_off_t offset,
+		xfs_off_t len);
 
 /* xfs_aops.c */
 extern int xfs_map_cow_blocks(struct inode *inode, xfs_off_t offset,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
