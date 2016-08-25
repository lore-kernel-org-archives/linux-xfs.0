Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4A6F87E25
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:37:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1E648304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:37:32 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id uvkTXfOGYyJ4EfXs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:37:31 -0700 (PDT)
Subject: [PATCH 50/71] xfs: unshare a range of blocks via fallocate
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:37:23 -0700
Message-ID: <147216824384.867.12107593689756610488.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Now that we have an fallocate flag to unshare a range of blocks, make
XFS actually implement it.

v2: NFS doesn't pass around struct file pointers, which means that our
unshare functions all crash when filp == NULL.  We don't need filp
anyway, so remove all the parts where we pass filp around.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch: pass inode instead of file to xfs_reflink_dirty_range,
      use iomap infrastructure for copy up]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c    |    6 +
 fs/xfs/xfs_reflink.c |  237 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    2 
 3 files changed, 244 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 14ec085..28d03c3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -993,9 +993,13 @@ xfs_file_fallocate(
 
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
index d7eea9e..d717e80 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1464,3 +1464,240 @@ out_error:
 		trace_xfs_reflink_remap_range_error(dest, error, _RET_IP_);
 	return error;
 }
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
+			error = xfs_reflink_find_shared(mp, agno, agbno, aglen,
+					&rbno, &rlen, true);
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
+			error = iomap_file_dirty(VFS_I(ip), fpos, flen,
+					&xfs_iomap_ops);
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
+			error = xfs_reflink_find_shared(mp, agno, agbno, aglen,
+					&rbno, &rlen, false);
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
index 6a67c08..906c74d 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -49,5 +49,7 @@ extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
 extern int xfs_reflink_remap_range(struct xfs_inode *src, xfs_off_t srcoff,
 		struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len,
 		unsigned int flags);
+extern int xfs_reflink_unshare(struct xfs_inode *ip, xfs_off_t offset,
+		xfs_off_t len);
 
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
