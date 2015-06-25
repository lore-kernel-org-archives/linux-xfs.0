Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5AACB7F78
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 18:40:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3A6848F8037
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 16:40:40 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id dD6RkmpMeOutwCLb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 16:40:38 -0700 (PDT)
Subject: [PATCH 12/14] xfs: support XFS_XFLAG_REFLINK (and FS_NOCOW_FL) on
	reflink filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jun 2015 16:40:30 -0700
Message-ID: <20150625234030.4992.96116.stgit@birch.djwong.org>
In-Reply-To: <20150625233909.4992.68314.stgit@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
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

Report the reflink/nocow flags as appropriate in the XFS-specific and
"standard" getattr ioctls.  For now we'll implicilty report all reflink
files as also being nodefrag, to prevent the defragger from corrupting
the extent maps.

Allow the user to clear the reflink flag (or set the nocow flag), which
will try to remap all shared blocks to private blocks on disk.  If this
succeeds, the file will become a non-reflinked file.

Transfer the reflink flag between inodes when swapping extents, and
quietly ignore attempts to set the reflink flag, so that xfs_fsr can
defragment reflinked file (albeit by breaking the reflink...) unless
of course nodefrag is set.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    1 
 fs/xfs/xfs_bmap_util.c |    5 +
 fs/xfs/xfs_inode.c     |    2 
 fs/xfs/xfs_ioctl.c     |   42 +++++-
 fs/xfs/xfs_reflink.c   |  321 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h   |   10 +
 6 files changed, 374 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 7f4d886..6b1b71c 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -67,6 +67,7 @@ struct fsxattr {
 #define XFS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
 #define XFS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
 #define XFS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
+#define XFS_XFLAG_REFLINK	0x00008000	/* file is reflinked */
 #define XFS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /*
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index be010c9..e5b4752 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1920,6 +1920,11 @@ xfs_swap_extents(
 		break;
 	}
 
+	if (ip->i_d.di_flags & XFS_DIFLAG_REFLINK) {
+		tip->i_d.di_flags |= XFS_DIFLAG_REFLINK;
+		ip->i_d.di_flags &= ~XFS_DIFLAG_REFLINK;
+	}
+
 	xfs_trans_log_inode(tp, ip,  src_log_flags);
 	xfs_trans_log_inode(tp, tip, target_log_flags);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e688732..4aa51f4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -592,6 +592,8 @@ _xfs_dic2xflags(
 			flags |= XFS_XFLAG_NODEFRAG;
 		if (di_flags & XFS_DIFLAG_FILESTREAM)
 			flags |= XFS_XFLAG_FILESTREAM;
+		if (di_flags & XFS_DIFLAG_REFLINK)
+			flags |= XFS_XFLAG_REFLINK;
 	}
 
 	return flags;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index da4d7b7..5a9c161 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -870,6 +870,10 @@ xfs_merge_ioc_xflags(
 		xflags |= XFS_XFLAG_NODUMP;
 	else
 		xflags &= ~XFS_XFLAG_NODUMP;
+	if (flags & FS_NOCOW_FL)
+		xflags &= ~XFS_XFLAG_REFLINK;
+	else
+		xflags |= XFS_XFLAG_REFLINK;
 
 	return xflags;
 }
@@ -939,7 +943,8 @@ xfs_set_diflags(
 	unsigned int		di_flags;
 
 	/* can't set PREALLOC this way, just preserve it */
-	di_flags = (ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
+	di_flags = (ip->i_d.di_flags &
+			(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_REFLINK));
 	if (xflags & XFS_XFLAG_IMMUTABLE)
 		di_flags |= XFS_DIFLAG_IMMUTABLE;
 	if (xflags & XFS_XFLAG_APPEND)
@@ -1002,9 +1007,11 @@ static int
 xfs_ioctl_setattr_xflags(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
-	struct fsxattr		*fa)
+	struct fsxattr		*fa,
+	struct file		*filp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
 
 	/* Can't change realtime flag if any extents are allocated. */
 	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
@@ -1028,6 +1035,9 @@ xfs_ioctl_setattr_xflags(
 		return -EPERM;
 
 	xfs_set_diflags(ip, fa->fsx_xflags);
+	error = xfs_reflink_end_unshare(ip, fa->fsx_xflags);
+	if (error)
+		return error;
 	xfs_diflags_to_linux(ip);
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
@@ -1170,7 +1180,8 @@ xfs_ioctl_setattr_check_projid(
 STATIC int
 xfs_ioctl_setattr(
 	xfs_inode_t		*ip,
-	struct fsxattr		*fa)
+	struct fsxattr		*fa,
+	struct file		*filp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
@@ -1181,6 +1192,10 @@ xfs_ioctl_setattr(
 
 	trace_xfs_ioctl_setattr(ip);
 
+	code = xfs_reflink_check_flag_adjust(ip, &fa->fsx_xflags);
+	if (code)
+		return code;
+
 	code = xfs_ioctl_setattr_check_projid(ip, fa);
 	if (code)
 		return code;
@@ -1201,6 +1216,10 @@ xfs_ioctl_setattr(
 			return code;
 	}
 
+	code = xfs_reflink_start_unshare(ip, fa->fsx_xflags, filp);
+	if (code)
+		return code;
+
 	tp = xfs_ioctl_setattr_get_trans(ip);
 	if (IS_ERR(tp)) {
 		code = PTR_ERR(tp);
@@ -1220,7 +1239,7 @@ xfs_ioctl_setattr(
 	if (code)
 		goto error_trans_cancel;
 
-	code = xfs_ioctl_setattr_xflags(tp, ip, fa);
+	code = xfs_ioctl_setattr_xflags(tp, ip, fa, filp);
 	if (code)
 		goto error_trans_cancel;
 
@@ -1290,7 +1309,7 @@ xfs_ioc_fssetxattr(
 	error = mnt_want_write_file(filp);
 	if (error)
 		return error;
-	error = xfs_ioctl_setattr(ip, &fa);
+	error = xfs_ioctl_setattr(ip, &fa, filp);
 	mnt_drop_write_file(filp);
 	return error;
 }
@@ -1303,6 +1322,7 @@ xfs_ioc_getxflags(
 	unsigned int		flags;
 
 	flags = xfs_di2lxflags(ip->i_d.di_flags);
+	xfs_reflink_get_lxflags(ip, &flags);
 	if (copy_to_user(arg, &flags, sizeof(flags)))
 		return -EFAULT;
 	return 0;
@@ -1324,22 +1344,30 @@ xfs_ioc_setxflags(
 
 	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
-		      FS_SYNC_FL))
+		      FS_SYNC_FL | FS_NOCOW_FL))
 		return -EOPNOTSUPP;
 
 	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
 
+	error = xfs_reflink_check_flag_adjust(ip, &fa.fsx_xflags);
+	if (error)
+		return error;
+
 	error = mnt_want_write_file(filp);
 	if (error)
 		return error;
 
+	error = xfs_reflink_start_unshare(ip, fa.fsx_xflags, filp);
+	if (error)
+		return error;
+
 	tp = xfs_ioctl_setattr_get_trans(ip);
 	if (IS_ERR(tp)) {
 		error = PTR_ERR(tp);
 		goto out_drop_write;
 	}
 
-	error = xfs_ioctl_setattr_xflags(tp, ip, &fa);
+	error = xfs_ioctl_setattr_xflags(tp, ip, &fa, filp);
 	if (error) {
 		xfs_trans_cancel(tp);
 		goto out_drop_write;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 325dd14..23ce9fc 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1008,3 +1008,324 @@ out:
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/**
+ * xfs_reflink_get_lxflags() - set reflink-related linux inode flags
+ *
+ * @ip: XFS inode
+ * @flags: Pointer to the user-visible inode flags
+ */
+void
+xfs_reflink_get_lxflags(
+	struct xfs_inode	*ip,		/* XFS inode */
+	unsigned int		*flags)		/* user flags */
+{
+	/*
+	 * If this is a reflink-capable filesystem and there are no shared
+	 * blocks, then this is a "nocow" file.
+	 */
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
+	    (ip->i_d.di_flags & XFS_DIFLAG_REFLINK))
+		return;
+	*flags |= FS_NOCOW_FL;
+}
+
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
+		rpage = xfs_get_page(filp->f_inode, pos);
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
+		if (!PageUptodate(page))
+			printk(KERN_ERR "%s: STALE? ino=%lu pos=%llu\n", __func__, filp->f_inode->i_ino, pos);
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
+/**
+ * xfs_reflink_check_flag_adjust() - the only change we allow to the inode
+ * reflink flag is to clear it when the fs supports reflink.
+ *
+ * @ip: XFS inode
+ * @xflags: XFS in-core inode flags
+ */
+int						/* error */
+xfs_reflink_check_flag_adjust(
+	struct xfs_inode	*ip,		/* XFS inode */
+	unsigned int		*xflags)		/* in-core flags */
+{
+	unsigned int		chg;
+
+	compiletime_assert(XFS_XFLAG_REFLINK == XFS_DIFLAG_REFLINK,
+			"in-core and on-disk inode reflink flags must match");
+	chg = (*xflags & XFS_XFLAG_REFLINK) ^
+	      (ip->i_d.di_flags & XFS_DIFLAG_REFLINK);
+
+	if (!chg)
+		return 0;
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
+		return -EOPNOTSUPP;
+	if (*xflags & XFS_XFLAG_REFLINK) {
+		*xflags &= ~XFS_XFLAG_REFLINK;
+		return 0;
+	}
+	return 0;
+}
+
+/**
+ * xfs_reflink_start_unshare() - dirty all the shared blocks so that they
+ * can be reallocated elsewhere, in preparation for clearing the reflink
+ * hint.
+ *
+ * @ip: XFS inode
+ * @xflags: XFS in-core inode flags
+ * @filp: VFS file structure
+ */
+int						/* error */
+xfs_reflink_start_unshare(
+	struct xfs_inode	*ip,		/* XFS inode */
+	unsigned int		xflags,		/* in-core flags */
+	struct file		*filp)		/* VFS file structure */
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error = 0;
+	xfs_fileoff_t		fbno;
+	xfs_filblks_t		end;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	xfs_extlen_t		len;
+	xfs_nlink_t		nr;
+	xfs_off_t		isize;
+	xfs_off_t		fpos;
+	xfs_off_t		flen;
+	struct xfs_bmbt_irec	map[2];
+	int			nmaps;
+
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
+	    (xflags & XFS_XFLAG_REFLINK) ||
+	    !(ip->i_d.di_flags & XFS_DIFLAG_REFLINK))
+		return 0;
+
+	inode_dio_wait(VFS_I(ip));
+
+	/*
+	 * The user wants to preemptively CoW all shared blocks in this file,
+	 * which enables us to turn off the reflink flag.  Iterate all
+	 * extents which are not prealloc/delalloc to see which ranges are
+	 * mentioned in the refcount tree, then read those blocks into the
+	 * pagecache, dirty them, fsync them back out, and then we can update
+	 * the inode flag.  What happens if we run out of memory? :)
+	 */
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	fbno = 0;
+	isize = i_size_read(VFS_I(ip));
+	if (isize == 0) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		return 0;
+	}
+	end = XFS_B_TO_FSB(mp, isize);
+	while (end - fbno > 0) {
+		nmaps = 1;
+		/*
+		 * Look for extents in the file.  Skip holes, delalloc, or
+		 * unwritten extents; they can't be reflinked.
+		 */
+		error = xfs_bmapi_read(ip, fbno, end - fbno, map, &nmaps, 0);
+		if (error)
+			goto out_unlock;
+		if (nmaps == 0)
+			break;
+		if (map[0].br_startblock == HOLESTARTBLOCK ||
+		    map[0].br_startblock == DELAYSTARTBLOCK ||
+		    map[0].br_state == XFS_EXT_UNWRITTEN)
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
+							 &len, &nr);
+			if (error)
+				goto out_unlock;
+			XFS_WANT_CORRUPTED_GOTO(mp, len != 0, out_unlock);
+			if (len > map[1].br_blockcount)
+				len = map[1].br_blockcount;
+			if (nr < 2)
+				goto skip_copy;
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			fpos = XFS_FSB_TO_B(mp, map[1].br_startoff);
+			flen = XFS_FSB_TO_B(mp, len);
+			if (fpos + flen > isize)
+				flen = isize - fpos;
+			error = xfs_reflink_dirty_range(filp, fpos, flen);
+			xfs_ilock(ip, XFS_ILOCK_EXCL);
+			if (error)
+				goto out_unlock;
+skip_copy:
+			map[1].br_blockcount -= len;
+			map[1].br_startoff += len;
+			map[1].br_startblock += len;
+		}
+
+next:
+		fbno = map[0].br_startoff + map[0].br_blockcount;
+	}
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error == 0)
+		error = filemap_write_and_wait(filp->f_mapping);
+	return error;
+}
+
+/**
+ * xfs_reflink_end_unshare() - finish removing reflink flag from inode
+ *
+ * @ip: XFS inode
+ * @xflags: XFS in-core inode flags
+ */
+int						/* error */
+xfs_reflink_end_unshare(
+	struct xfs_inode	*ip,		/* XFS inode */
+	unsigned int		xflags)		/* VFS file structure */
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+	xfs_fileoff_t		fbno;
+	xfs_filblks_t		end;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	xfs_extlen_t		len;
+	xfs_nlink_t		nr;
+	struct xfs_bmbt_irec	map[2];
+	int			nmaps;
+
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
+	    (xflags & XFS_XFLAG_REFLINK) ||
+	    !(ip->i_d.di_flags & XFS_DIFLAG_REFLINK))
+		return 0;
+
+	/*
+	 * Earlier we copied all the shared blocks in this file to new blocks.
+	 * However, we dropped the ilock before getting the transaction, so
+	 * check that nobody wandered in and added more reflinks.
+	 */
+	fbno = 0;
+	end = XFS_B_TO_FSB(mp, i_size_read(VFS_I(ip)));
+	while (end - fbno > 0) {
+		nmaps = 1;
+		/*
+		 * Look for extents in the file.  Skip holes, delalloc, or
+		 * unwritten extents; they can't be reflinked.
+		 */
+		error = xfs_bmapi_read(ip, fbno, end - fbno, map, &nmaps, 0);
+		if (error)
+			goto out_unlock;
+		if (nmaps == 0)
+			break;
+		if (map[0].br_startblock == HOLESTARTBLOCK ||
+		    map[0].br_startblock == DELAYSTARTBLOCK ||
+		    map[0].br_state == XFS_EXT_UNWRITTEN)
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
+							 &len, &nr);
+			if (error)
+				goto out_unlock;
+			XFS_WANT_CORRUPTED_GOTO(mp, len != 0, out_unlock);
+			if (len > map[1].br_blockcount)
+				len = map[1].br_blockcount;
+			if (nr > 1) {
+				error = -EINTR;
+				goto out_unlock;
+			}
+			map[1].br_blockcount -= len;
+			map[1].br_startblock += len;
+		}
+
+next:
+		fbno = map[0].br_startoff + map[0].br_blockcount;
+	}
+
+	ip->i_d.di_flags &= ~XFS_DIFLAG_REFLINK;
+out_unlock:
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 7f9660d..6f1ecf8 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -50,4 +50,14 @@ extern int xfs_reflink_finish_fork_buf(xfs_mount_t  *mp, xfs_inode_t *ip,
 	xfs_buf_t *bp, xfs_fileoff_t fileoff, xfs_trans_t *tp,
 	int write_error);
 
+extern void xfs_reflink_get_lxflags(struct xfs_inode *ip, unsigned int *flags);
+
+extern int xfs_reflink_check_flag_adjust(struct xfs_inode *ip,
+	unsigned int *xflags);
+
+extern int xfs_reflink_start_unshare(struct xfs_inode *ip, unsigned int xflags,
+	struct file *filp);
+
+extern int xfs_reflink_end_unshare(struct xfs_inode *ip, unsigned int xflags);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
