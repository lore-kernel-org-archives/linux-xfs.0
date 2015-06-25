Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E82577F91
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 18:39:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D7723304039
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 16:39:48 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id JEvOpVmKDDsVaVD6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 16:39:46 -0700 (PDT)
Subject: [PATCH 05/14] xfs: add reflink functions and ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jun 2015 16:39:43 -0700
Message-ID: <20150625233943.4992.6448.stgit@birch.djwong.org>
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

Add to XFS the ability to share arbitrary blocks between one file and
another (reflink).  The userspace ioctl uses the same interface as
the btrfs ioctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |   10 ++
 fs/xfs/xfs_ioctl.c     |  178 +++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl32.c   |    2 
 fs/xfs/xfs_reflink.c   |  296 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h   |   24 ++++
 6 files changed, 511 insertions(+)
 create mode 100644 fs/xfs/xfs_reflink.c
 create mode 100644 fs/xfs/xfs_reflink.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ba89aee..eb9dc8e 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -87,6 +87,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_message.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
+				   xfs_reflink.o \
 				   xfs_super.o \
 				   xfs_symlink.o \
 				   xfs_sysfs.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 9fbdb86..92f21e1 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -560,6 +560,16 @@ typedef struct xfs_swapext
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
+/* reflink ioctls; these should match btrfs */
+struct xfs_ioctl_clone_range_args {
+	__s64 src_fd;
+	__u64 src_offset;
+	__u64 src_length;
+	__u64 dest_offset;
+};
+
+#define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
+#define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_ioctl_clone_range_args)
 
 #ifndef HAVE_BBMACROS
 /*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ea7d85a..efc6e8d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -40,6 +40,7 @@
 #include "xfs_symlink.h"
 #include "xfs_trans.h"
 #include "xfs_pnfs.h"
+#include "xfs_reflink.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -48,6 +49,8 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/exportfs.h>
+#include <linux/fsnotify.h>
+#include <linux/security.h>
 
 /*
  * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
@@ -1502,6 +1505,145 @@ xfs_ioc_swapext(
 	return error;
 }
 
+static int
+wait_for_io(
+	struct inode	*inode,
+	loff_t		offset,
+	size_t		len)
+{
+	loff_t		rounding;
+	loff_t		ioffset;
+	loff_t		iendoffset;
+	loff_t		bs;
+	int		ret;
+
+	bs = inode->i_sb->s_blocksize;
+	inode_dio_wait(inode);
+
+	rounding = max_t(xfs_off_t, bs, PAGE_CACHE_SIZE);
+	ioffset = round_down(offset, rounding);
+	iendoffset = round_up(offset + len, rounding) - 1;
+	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
+					   iendoffset);
+	return ret;
+}
+
+static int
+xfs_ioctl_reflink(
+	struct file	*file_in,
+	loff_t		pos_in,
+	struct file	*file_out,
+	loff_t		pos_out,
+	size_t		len)
+{
+	struct inode	*inode_in;
+	struct inode	*inode_out;
+	ssize_t		ret;
+	loff_t		bs;
+	loff_t		isize;
+	int		same_inode;
+	loff_t		blen;
+
+	if (len == 0)
+		return 0;
+	else if (len != ~0ULL && (ssize_t)len < 0)
+		return -EINVAL;
+
+	/* Do we have the correct permissions? */
+	if (!(file_in->f_mode & FMODE_READ) ||
+	    !(file_out->f_mode & FMODE_WRITE) ||
+	    (file_out->f_flags & O_APPEND))
+		return -EPERM;
+	ret = security_file_permission(file_out, MAY_WRITE);
+	if (ret)
+		return ret;
+
+	inode_in = file_inode(file_in);
+	inode_out = file_inode(file_out);
+	bs = inode_out->i_sb->s_blocksize;
+
+	/* Don't touch certain kinds of inodes */
+	if (IS_IMMUTABLE(inode_out))
+		return -EPERM;
+	if (IS_SWAPFILE(inode_in) ||
+	    IS_SWAPFILE(inode_out))
+		return -ETXTBSY;
+
+	/* Reflink only works within this filesystem. */
+	if (inode_in->i_sb != inode_out->i_sb ||
+	    file_in->f_path.mnt != file_out->f_path.mnt)
+		return -EXDEV;
+	same_inode = (inode_in->i_ino == inode_out->i_ino);
+
+	/* Don't reflink dirs, pipes, sockets... */
+	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
+		return -EISDIR;
+	if (S_ISFIFO(inode_in->i_mode) || S_ISFIFO(inode_out->i_mode))
+		return -ESPIPE;
+	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
+		return -EINVAL;
+
+	/* Are we going all the way to the end? */
+	isize = i_size_read(inode_in);
+	if (isize == 0)
+		return 0;
+	if (len  == ~0ULL)
+		len = isize - pos_in;
+
+	/* Ensure offsets don't wrap and the input is inside i_size */
+	if (pos_in + len < pos_in || pos_out + len < pos_out ||
+	    pos_in + len > isize)
+		return -EINVAL;
+
+	/* If we're linking to EOF, continue to the block boundary. */
+	if (pos_in + len == isize)
+		blen = ALIGN(isize, bs) - pos_in;
+	else
+		blen = len;
+
+	/* Only reflink if we're aligned to block boundaries */
+	if (!IS_ALIGNED(pos_in, bs) || !IS_ALIGNED(pos_in + blen, bs) ||
+	    !IS_ALIGNED(pos_out, bs) || !IS_ALIGNED(pos_out + blen, bs))
+		return -EINVAL;
+
+	/* Don't allow overlapped reflink within the same file */
+	if (same_inode && pos_out + blen > pos_in && pos_out < pos_in + blen)
+		return -EINVAL;
+
+	ret = mnt_want_write_file(file_out);
+	if (ret)
+		return ret;
+
+	/* Wait for the completion of any pending IOs on srcfile */
+	ret = wait_for_io(inode_in, pos_in, len);
+	if (ret)
+		goto out_unlock;
+	ret = wait_for_io(inode_out, pos_out, len);
+	if (ret)
+		goto out_unlock;
+
+	ret = xfs_reflink(XFS_I(inode_in), pos_in, XFS_I(inode_out), pos_out, len);
+	if (ret < 0)
+		goto out_unlock;
+
+	/* Truncate the page cache so we don't see stale data */
+	truncate_inode_pages_range(&inode_out->i_data, pos_out,
+				   PAGE_CACHE_ALIGN(pos_out + len) - 1);
+
+out_unlock:
+	if (ret == 0) {
+		fsnotify_access(file_in);
+		add_rchar(current, len);
+		fsnotify_modify(file_out);
+		add_wchar(current, len);
+	}
+	inc_syscr(current);
+	inc_syscw(current);
+
+	mnt_drop_write_file(file_out);
+	return ret;
+}
+
 /*
  * Note: some of the ioctl's return positive numbers as a
  * byte count indicating success, such as readlink_by_handle.
@@ -1800,6 +1942,42 @@ xfs_file_ioctl(
 		return xfs_icache_free_eofblocks(mp, &keofb);
 	}
 
+	case XFS_IOC_CLONE: {
+		struct fd src;
+
+		src = fdget(p);
+		if (!src.file)
+			return -EBADF;
+
+		error = xfs_ioctl_reflink(src.file, 0, filp, 0, ~0ULL);
+		fdput(src);
+		if (error > 0)
+			error = 0;
+
+		return error;
+	}
+
+	case XFS_IOC_CLONE_RANGE: {
+		struct fd src;
+		struct xfs_ioctl_clone_range_args args;
+
+		if (copy_from_user(&args, arg, sizeof(args)))
+			return -EFAULT;
+		src = fdget(args.src_fd);
+		if (!src.file)
+			return -EBADF;
+		if (args.src_length == 0)
+			args.src_length = ~0ULL;
+
+		error = xfs_ioctl_reflink(src.file, args.src_offset, filp,
+					  args.dest_offset, args.src_length);
+		fdput(src);
+		if (error > 0)
+			error = 0;
+
+		return error;
+	}
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index b88bdc8..76d8729 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -558,6 +558,8 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
+	case XFS_IOC_CLONE:
+	case XFS_IOC_CLONE_RANGE:
 		return xfs_file_ioctl(filp, cmd, p);
 #ifndef BROKEN_X86_ALIGNMENT
 	/* These are handled fine if no alignment issues */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
new file mode 100644
index 0000000..ce5feeb
--- /dev/null
+++ b/fs/xfs/xfs_reflink.c
@@ -0,0 +1,296 @@
+/*
+ * Copyright (c) 2015 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_inode_item.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_error.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_ioctl.h"
+#include "xfs_trace.h"
+#include "xfs_log.h"
+#include "xfs_icache.h"
+#include "xfs_pnfs.h"
+#include "xfs_reflink_btree.h"
+#include "xfs_reflink.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_bit.h"
+#include "xfs_alloc.h"
+#include "xfs_quota_defs.h"
+#include "xfs_quota.h"
+
+/**
+ * xfs_reflink() - link a range of blocks from one inode to another
+ *
+ * @src: Inode to clone from
+ * @srcoff: Offset within source to start clone from
+ * @dest: Inode to clone to
+ * @destoff: Offset within @inode to start clone
+ * @len: Original length, passed by user, of range to clone
+ */
+int					/* error */
+xfs_reflink(
+	struct xfs_inode	*src,	/* XFS inode to copy extents from */
+	xfs_off_t		srcoff, /* offset in source file */
+	struct xfs_inode	*dest,	/* XFS inode to copy extents to */
+	xfs_off_t		destoff,/* offset in destination file */
+	xfs_off_t		len)	/* number of bytes to copy */
+{
+	struct xfs_mount	*mp = src->i_mount;
+	loff_t			uninitialized_var(offset);
+	xfs_fileoff_t		fsbno, dfsbno, fsbnext;
+	xfs_filblks_t		end;
+	int			error;
+	xfs_bmbt_irec_t		imaps[1];
+	int			nimaps = 1;
+	uint			resblks;
+	xfs_bmap_free_t		free_list;
+	xfs_bmbt_irec_t		map, dmap;
+	xfs_trans_t		*tp;
+	int			committed;
+	xfs_fsblock_t		firstfsb;
+	struct xfs_buf		*agbp;
+	xfs_agnumber_t		agno;		/* allocation group number */
+	xfs_agblock_t		agbno;
+	int			done;
+	xfs_off_t		blen = ALIGN(len, mp->m_sb.sb_blocksize);
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	/* For now, we won't reflink realtime inodes */
+	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
+		return -EINVAL;
+
+	/* Lock both files against IO */
+	if (src->i_ino == dest->i_ino) {
+		xfs_ilock(src, XFS_IOLOCK_EXCL);
+		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
+	} else {
+		xfs_lock_two_inodes(src, dest, XFS_IOLOCK_EXCL);
+		xfs_lock_two_inodes(src, dest, XFS_MMAPLOCK_EXCL);
+	}
+
+	/*
+	 * Try to read extents from the first block indicated
+	 * by fsbno to the end block of the file.
+	 */
+	dfsbno = XFS_B_TO_FSBT(mp, destoff);
+	fsbno = fsbnext = XFS_B_TO_FSBT(mp, srcoff);
+	end = XFS_B_TO_FSB(mp, srcoff + blen);
+
+	/*
+	 * free file space until done or until there is an error
+	 */
+	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+	error = done = 0;
+	while (!error && !done) {
+		/*
+		 * allocate and setup the transaction. Allow this
+		 * transaction to dip into the reserve blocks to ensure
+		 * the freeing of the space succeeds at ENOSPC.
+		 */
+		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, resblks, 0);
+
+		/*
+		 * check for running out of space
+		 */
+		if (error) {
+			/*
+			 * Free the transaction structure.
+			 */
+			ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+			goto error0;
+		}
+		error = xfs_trans_reserve_quota(tp, mp,
+				dest->i_udquot, dest->i_gdquot, dest->i_pdquot,
+				resblks, 0, XFS_QMOPT_RES_REGBLKS);
+		if (error)
+			goto error0;
+
+		xfs_ilock(dest, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, dest, XFS_ILOCK_EXCL);
+
+		/*
+		 * issue the bunmapi() call to free the blocks
+		 */
+		xfs_bmap_init(&free_list, &firstfsb);
+		error = xfs_bunmapi(tp, dest, dfsbno,
+				  XFS_B_TO_FSBT(mp, destoff + blen) - dfsbno,
+				  0, 2, &firstfsb, &free_list, &done);
+		if (error)
+			goto error1;
+
+		/*
+		 * complete the transaction
+		 */
+		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		if (error)
+			goto error0;
+
+		error = xfs_trans_commit(tp);
+	}
+	if (error)
+		goto out_unlock_io;
+
+	while (end - fsbnext > 0) {
+		/* Read extent from the source file */
+		nimaps = 1;
+		xfs_ilock(src, XFS_ILOCK_EXCL);
+		error = xfs_bmapi_read(src, fsbnext, end - fsbnext, &map,
+				       &nimaps, 0);
+		xfs_iunlock(src, XFS_ILOCK_EXCL);
+		if (error)
+			goto out_unlock_io;
+
+		/* No extents at given offset, must be beyond EOF */
+		if (nimaps == 0)
+			break;
+
+		if (map.br_startblock == HOLESTARTBLOCK ||
+		    map.br_startblock == DELAYSTARTBLOCK)
+			goto next;
+
+		/* Shrink the map to whatever we're linking */
+		dmap = map;
+		dmap.br_startoff = dfsbno + dmap.br_startoff - fsbno;
+		nimaps = 1;
+
+		/*
+		 * Allocate and setup the transaction.
+		 */
+		resblks = XFS_DIOSTRAT_SPACE_RES(mp, dmap.br_blockcount * 2);
+		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+					  resblks, 0);
+		/*
+		 * Check for running out of space
+		 */
+		if (error) {
+			/*
+			 * Free the transaction structure.
+			 */
+			ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+			goto error0;
+		}
+
+		xfs_ilock(dest, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, dest, XFS_ILOCK_EXCL);
+
+		xfs_bmap_init(&free_list, &firstfsb);
+
+		/* Update the refcount tree */
+		agno = XFS_FSB_TO_AGNO(mp, dmap.br_startblock);
+		agbno = XFS_FSB_TO_AGBNO(mp, dmap.br_startblock);
+		error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+		if (error)
+			goto error1;
+		error = xfs_reflinkbt_adjust_refcount(mp, tp, agbp, agno, agbno,
+					      dmap.br_blockcount, 1);
+		if (error)
+			goto error1;
+		xfs_trans_brelse(tp, agbp);
+
+		// XXX: should this be a separate transaction?
+
+		/* Add this extent to the destination file */
+		error = xfs_bmapi_write(tp, dest, dmap.br_startoff,
+					dmap.br_blockcount,
+					XFS_BMAPI_REFLINK, &dmap.br_startblock,
+					0, &imaps[0], &nimaps, &free_list);
+		if (error)
+			goto error1;
+
+		/*
+		 * Complete the transaction
+		 */
+		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		if (error)
+			goto error0;
+
+		error = xfs_trans_commit(tp);
+		if (error)
+			goto out_unlock_io;
+
+		/* Keep going */
+next:
+		fsbnext = map.br_startoff + map.br_blockcount;
+	}
+
+	/* Update inode size */
+	if (destoff + len > i_size_read(VFS_I(dest))) {
+		tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
+
+		/*
+		 * check for running out of space
+		 */
+		if (error) {
+			/*
+			 * Free the transaction structure.
+			 */
+			ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
+			goto error0;
+		}
+
+		xfs_ilock(dest, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, dest, XFS_ILOCK_EXCL);
+
+		i_size_write(VFS_I(dest), destoff + len);
+		dest->i_d.di_size = destoff + len;
+		xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
+
+		error = xfs_trans_commit(tp);
+		if (error)
+			goto out_unlock_io;
+	}
+
+	goto out_unlock_io;
+
+error1:
+	/* Cancel bmap, unlock inode, unreserve quota blocks, cancel trans */
+	xfs_bmap_cancel(&free_list);
+error0:
+	xfs_trans_cancel(tp);
+
+out_unlock_io:
+	xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
+	xfs_iunlock(src, XFS_IOLOCK_EXCL);
+	if (src->i_ino != dest->i_ino) {
+		xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
+		xfs_iunlock(dest, XFS_IOLOCK_EXCL);
+	}
+
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
new file mode 100644
index 0000000..7cccd50
--- /dev/null
+++ b/fs/xfs/xfs_reflink.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2015 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_REFLINK_H
+#define __XFS_REFLINK_H 1
+
+extern int xfs_reflink(struct xfs_inode *src, xfs_off_t srcoff,
+	struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len);
+
+#endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
