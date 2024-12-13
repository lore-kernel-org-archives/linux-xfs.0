Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C1E10F7
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052951; cv=none; b=IRJNAA3OMLtZhYBl+OOWDd/UQLGxfJTJjgi37+w1ksY9WLeREBBTiJmDJFVcjJzA2a5gmMWE29YOmTKDp/TZV+CFxARdx65tVNgoCjVrO1+nIComsq8rGsJciqLhZRwiogfTbzyeperUmCidaJOZtoihWmxSqJcnJa4rIgW5wLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052951; c=relaxed/simple;
	bh=lJO24BHcEN1PtFt1v7sR8R8LZfuGAQWLAzaB0FCjUXc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ilcf8LVAo8r1kqGcyOD1TYyGwD7Kczb2a0LyQc76y2PpjTACpGSsdpRwY9kgLYB7omaMoYdBajp0399uDqPPsLESxJBKtgT5vyZP7doxnPZruM1cMlxeX4nUle1l+PAPbydhD78MRnqYhyBbKHCKR/WY/5jYcuLX1PFs4z/nfAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rtTyHIgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rtTyHIgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C522BC4CECE;
	Fri, 13 Dec 2024 01:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052950;
	bh=lJO24BHcEN1PtFt1v7sR8R8LZfuGAQWLAzaB0FCjUXc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rtTyHIgMjZzuh73a4hTAtPjEoPe5RAcJ/nceVMg/FzjJLq6eQdAGTOk4PnPyZVTNc
	 Icgp0TCB/poJghfH6qTsV43XMYJiX/w4T7m0hKZvvdLApN/TcAp+iluz+DghYW0ZS6
	 lDraH7geV76Aq+HLgok4XS8Xa8lo8b+Ku0tPjjZayghgKsFz8w3uBd+o+iMyh/OKOT
	 QXdTkY54o8IFfWdDZ2RJdmqKEMyjzsjrYuDwljTfp+GhN8fNKNIaEc8w1jHpyYdovk
	 JtVTPboowZOFoWC+nFqpMBtdsQf6jlYzwdKF/i8ZBX9AMvg7kmRkOMfExO1VE+6ptU
	 Hsb8sED7VDn9w==
Date: Thu, 12 Dec 2024 17:22:30 -0800
Subject: [PATCH 04/11] xfs: enable CoW when rt extent size is larger than 1
 block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125811.1184063.1464436221145143124.stgit@frogsfrogsfrogs>
In-Reply-To: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
References: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Copy on write encounters a major plot twist when the file being CoW'd
lives on the realtime volume and the realtime extent size is larger than
a single filesystem block.  XFS can only unmap and remap full rt
extents, which means that allocations are always done in units of full
rt extents, and a request to unmap less than one extent is treated as a
request to convert an extent to unwritten status.

This behavioral quirk is not compatible with the existing CoW mechanism,
so we have to intercept every path through which files can be modified
to ensure that we dirty an entire rt extent at once so that we can remap
a full rt extent.  Use the existing VFS unshare functions to dirty the
page cache to set that up.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_file.c    |  270 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_file.h    |    3 +
 fs/xfs/xfs_inode.h   |    6 +
 fs/xfs/xfs_iops.c    |   29 +++++
 fs/xfs/xfs_reflink.c |   39 +++++++
 fs/xfs/xfs_trace.h   |    1 
 6 files changed, 345 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9a435b1ff26475..fad768c0b3f328 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -347,6 +347,116 @@ xfs_file_splice_read(
 	return ret;
 }
 
+/*
+ * Decide if this file write requires COWing-around at either end of the write
+ * range.  This is only required if the file allocation unit is larger than
+ * 1FSB and the write range is not aligned with the allocation unit.
+ */
+static bool
+xfs_file_write_needs_cow_around(
+	struct xfs_inode	*ip,
+	loff_t			pos,
+	long long int		count)
+{
+	/*
+	 * No COWing required if this inode doesn't do COW.
+	 *
+	 * If the allocation unit is 1FSB, we do not need to COW around the
+	 * edges of the operation range.  This applies to all files on the data
+	 * device and rt files that have an extent size of 1FSB.
+	 */
+	if (!xfs_inode_needs_cow_around(ip))
+		return false;
+
+	/*
+	 * Otherwise, check that the operation is aligned to the rt extent
+	 * size.  Any unaligned operation /must/ be COWed around since the
+	 * regular reflink code only handles extending writes up to fsblock
+	 * boundaries.
+	 */
+	return !xfs_is_falloc_aligned(ip, pos, count);
+}
+
+/* Do we need to COW-around at this offset to handle a truncate up or down? */
+bool
+xfs_truncate_needs_cow_around(
+	struct xfs_inode	*ip,
+	loff_t			pos)
+{
+	return xfs_file_write_needs_cow_around(ip, pos, 0);
+}
+
+/* Does this file write require COWing around? */
+static inline bool
+xfs_iocb_needs_cow_around(
+	struct xfs_inode	*ip,
+	const struct kiocb	*iocb,
+	const struct iov_iter	*from)
+{
+	return xfs_file_write_needs_cow_around(ip, iocb->ki_pos,
+			iov_iter_count(from));
+}
+
+/* Unshare the allocation unit mapped to the given file position.  */
+inline int
+xfs_file_unshare_at(
+	struct xfs_inode	*ip,
+	loff_t			pos)
+{
+	loff_t			isize = i_size_read(VFS_I(ip));
+	unsigned int		extsize, len;
+	uint32_t		mod;
+
+	len = extsize = xfs_inode_alloc_unitsize(ip);
+
+	/* Open-coded rounddown_64 so that we can skip out if aligned */
+	div_u64_rem(pos, extsize, &mod);
+	if (mod == 0)
+		return 0;
+	pos -= mod;
+
+	/* Do not extend the file. */
+	if (pos >= isize)
+		return 0;
+	if (pos + len > isize)
+		len = isize - pos;
+
+	trace_xfs_file_cow_around(ip, pos, len);
+
+	if (IS_DAX(VFS_I(ip)))
+		return dax_file_unshare(VFS_I(ip), pos, len,
+				&xfs_dax_write_iomap_ops);
+	return iomap_file_unshare(VFS_I(ip), pos, len,
+			&xfs_buffered_write_iomap_ops);
+}
+
+/*
+ * Dirty the pages on either side of a write request as needed to satisfy
+ * alignment requirements if we're going to perform a copy-write.
+ *
+ * This is only needed for realtime files when the rt extent size is larger
+ * than 1 fs block, because we don't allow a logical rt extent in a file to map
+ * to multiple physical rt extents.  In other words, we can only map and unmap
+ * full rt extents.  Note that page cache doesn't exist above EOF, so be
+ * careful to stay below EOF.
+ */
+static int
+xfs_file_cow_around(
+	struct xfs_inode	*ip,
+	loff_t			pos,
+	long long int		count)
+{
+	int			error;
+
+	/* Unshare at the start of the extent. */
+	error = xfs_file_unshare_at(ip,  pos);
+	if (error)
+		return error;
+
+	/* Unshare at the end. */
+	return xfs_file_unshare_at(ip, pos + count);
+}
+
 /*
  * Take care of zeroing post-EOF blocks when they might exist.
  *
@@ -411,6 +521,17 @@ xfs_file_write_zero_eof(
 		return 1;
 	}
 
+	/*
+	 * If we're starting the write past EOF, COW the allocation unit
+	 * containing the current EOF before we start zeroing the range between
+	 * EOF and the start of the write.
+	 */
+	if (xfs_truncate_needs_cow_around(ip, isize)) {
+		error = xfs_file_unshare_at(ip, isize);
+		if (error)
+			return error;
+	}
+
 	trace_xfs_zero_eof(ip, isize, iocb->ki_pos - isize);
 
 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
@@ -456,9 +577,11 @@ xfs_file_write_checks(
 
 	/*
 	 * For changing security info in file_remove_privs() we need i_rwsem
-	 * exclusively.
+	 * exclusively.  We also need it to COW around the range being written.
 	 */
-	if (*iolock == XFS_IOLOCK_SHARED && !IS_NOSEC(inode)) {
+	if (*iolock == XFS_IOLOCK_SHARED &&
+	    (!IS_NOSEC(inode) ||
+	     xfs_iocb_needs_cow_around(XFS_I(inode), iocb, from))) {
 		xfs_iunlock(XFS_I(inode), *iolock);
 		*iolock = XFS_IOLOCK_EXCL;
 		error = xfs_ilock_iocb(iocb, *iolock);
@@ -469,6 +592,22 @@ xfs_file_write_checks(
 		goto restart;
 	}
 
+	/*
+	 * The write is not aligned to the file's allocation unit.  If either
+	 * of the allocation units at the start or end of the write range are
+	 * shared, unshare them through the page cache.
+	 */
+	if (xfs_iocb_needs_cow_around(XFS_I(inode), iocb, from)) {
+		ASSERT(*iolock == XFS_IOLOCK_EXCL);
+
+		inode_dio_wait(inode);
+		drained_dio = true;
+
+		error = xfs_file_cow_around(XFS_I(inode), iocb->ki_pos, count);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * If the offset is beyond the size of the file, we need to zero all
 	 * blocks that fall between the existing EOF and the start of this
@@ -594,6 +733,16 @@ xfs_file_dio_write_aligned(
 	unsigned int		iolock = XFS_IOLOCK_SHARED;
 	ssize_t			ret;
 
+	/*
+	 * If the range to write is not aligned to an allocation unit, we will
+	 * have to COW the allocation units on both ends of the write.  Because
+	 * this runs through the page cache, it requires IOLOCK_EXCL.  This
+	 * predicate performs an unlocked access of the rt and reflink inode
+	 * state.
+	 */
+	if (xfs_iocb_needs_cow_around(ip, iocb, from))
+		iolock = XFS_IOLOCK_EXCL;
+
 	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
 	if (ret)
 		return ret;
@@ -928,6 +1077,24 @@ xfs_falloc_setsize(
 			&iattr);
 }
 
+static int
+xfs_falloc_punch_range(
+	struct xfs_inode	*ip,
+	loff_t			offset,
+	loff_t			len)
+{
+	int			error;
+
+	/* Unshare around the region to punch, if needed. */
+	if (xfs_file_write_needs_cow_around(ip, offset, len)) {
+		error = xfs_file_cow_around(ip, offset, len);
+		if (error)
+			return error;
+	}
+
+	return xfs_free_file_space(ip, offset, len);
+}
+
 static int
 xfs_falloc_collapse_range(
 	struct file		*file,
@@ -1017,6 +1184,13 @@ xfs_falloc_zero_range(
 	if (error)
 		return error;
 
+	/* Unshare around the region to zero, if needed. */
+	if (xfs_file_write_needs_cow_around(XFS_I(inode), offset, len)) {
+		error = xfs_file_cow_around(XFS_I(inode), offset, len);
+		if (error)
+			return error;
+	}
+
 	error = xfs_free_file_space(XFS_I(inode), offset, len);
 	if (error)
 		return error;
@@ -1044,6 +1218,23 @@ xfs_falloc_unshare_range(
 	if (error)
 		return error;
 
+	/*
+	 * Enlarge the unshare region to align to a full allocation unit.
+	 */
+	if (xfs_inode_needs_cow_around(XFS_I(inode))) {
+		unsigned int	rextsize;
+		uint32_t	mod;
+
+		rextsize = xfs_inode_alloc_unitsize(XFS_I(inode));
+		div_u64_rem(offset, rextsize, &mod);
+		offset -= mod;
+		len += mod;
+
+		div_u64_rem(offset + len, rextsize, &mod);
+		if (mod)
+			len += rextsize - mod;
+	}
+
 	error = xfs_reflink_unshare(XFS_I(inode), offset, len);
 	if (error)
 		return error;
@@ -1124,7 +1315,7 @@ xfs_file_fallocate(
 
 	switch (mode & FALLOC_FL_MODE_MASK) {
 	case FALLOC_FL_PUNCH_HOLE:
-		error = xfs_free_file_space(ip, offset, len);
+		error = xfs_falloc_punch_range(ip, offset, len);
 		break;
 	case FALLOC_FL_COLLAPSE_RANGE:
 		error = xfs_falloc_collapse_range(file, offset, len);
@@ -1458,6 +1649,70 @@ xfs_dax_read_fault(
 	return ret;
 }
 
+/* dax version of folio_mkwrite_check_truncate since vmf->page == NULL */
+static inline ssize_t
+dax_write_fault_check(
+	struct vm_fault		*vmf,
+	struct inode		*inode,
+	unsigned int		order)
+{
+	loff_t			size = i_size_read(inode);
+	pgoff_t			index = size >> PAGE_SHIFT;
+	size_t			len = 1U << (PAGE_SHIFT + order);
+	size_t			offset = size & (len - 1);
+
+	if (!IS_ENABLED(CONFIG_FS_DAX)) {
+		ASSERT(0);
+		return -EFAULT;
+	}
+
+	/* fault is wholly inside EOF */
+	if (vmf->pgoff + (1U << order) - 1 < index)
+		return len;
+	/* fault is wholly past EOF */
+	if (vmf->pgoff > index || !offset)
+		return -EFAULT;
+	/* fault is partially inside EOF */
+	return offset;
+}
+
+static int
+xfs_filemap_fault_around(
+	struct vm_fault		*vmf,
+	struct inode		*inode,
+	unsigned int		order)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	loff_t			pos;
+	ssize_t			len;
+
+	if (!xfs_inode_needs_cow_around(ip))
+		return 0;
+
+	if (IS_DAX(inode)) {
+		len = dax_write_fault_check(vmf, inode, order);
+		if (len < 0)
+			return len;
+		pos = vmf->pgoff << PAGE_SHIFT;
+	} else {
+		struct folio	*folio = page_folio(vmf->page);
+
+		folio_lock(folio);
+		len = folio_mkwrite_check_truncate(folio, inode);
+		if (len < 0) {
+			folio_unlock(folio);
+			return len;
+		}
+		pos = folio_pos(folio);
+		folio_unlock(folio);
+	}
+
+	if (!xfs_file_write_needs_cow_around(ip, pos, len))
+		return 0;
+
+	return xfs_file_cow_around(XFS_I(inode), pos, len);
+}
+
 /*
  * Locking for serialisation of IO during page faults. This results in a lock
  * ordering of:
@@ -1476,6 +1731,7 @@ xfs_write_fault(
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	unsigned int		lock_mode = XFS_MMAPLOCK_SHARED;
+	int			error;
 	vm_fault_t		ret;
 
 	trace_xfs_write_fault(ip, order);
@@ -1495,10 +1751,18 @@ xfs_write_fault(
 		lock_mode = XFS_MMAPLOCK_EXCL;
 	}
 
+	/* Unshare all the blocks in this rt extent surrounding this page. */
+	error = xfs_filemap_fault_around(vmf, inode, order);
+	if (error) {
+		ret = vmf_fs_error(error);
+		goto out_unlock;
+	}
+
 	if (IS_DAX(inode))
 		ret = xfs_dax_fault_locked(vmf, order, true);
 	else
 		ret = iomap_page_mkwrite(vmf, &xfs_buffered_write_iomap_ops);
+out_unlock:
 	xfs_iunlock(ip, lock_mode);
 
 	sb_end_pagefault(inode->i_sb);
diff --git a/fs/xfs/xfs_file.h b/fs/xfs/xfs_file.h
index 2ad91f755caf35..24490ea49e16c6 100644
--- a/fs/xfs/xfs_file.h
+++ b/fs/xfs/xfs_file.h
@@ -12,4 +12,7 @@ extern const struct file_operations xfs_dir_file_operations;
 bool xfs_is_falloc_aligned(struct xfs_inode *ip, loff_t pos,
 		long long int len);
 
+bool xfs_truncate_needs_cow_around(struct xfs_inode *ip, loff_t pos);
+int xfs_file_unshare_at(struct xfs_inode *ip, loff_t pos);
+
 #endif /* __XFS_FILE_H__ */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c08093a65352ec..71ca16db369913 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -349,6 +349,12 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
 	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
 }
 
+/* Decide if we need to unshare the blocks around a range that we're writing. */
+static inline bool xfs_inode_needs_cow_around(struct xfs_inode *ip)
+{
+	return xfs_is_cow_inode(ip) && xfs_inode_has_bigrtalloc(ip);
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 207e0dadffc3c5..114ebddaa7bc0d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -29,6 +29,7 @@
 #include "xfs_xattr.h"
 #include "xfs_file.h"
 #include "xfs_bmap.h"
+#include "xfs_reflink.h"
 
 #include <linux/posix_acl.h>
 #include <linux/security.h>
@@ -886,10 +887,38 @@ xfs_setattr_size(
 	 * truncate.
 	 */
 	if (newsize > oldsize) {
+		/*
+		 * Extending the file size, so COW around the allocation unit
+		 * containing EOF before we zero the new range of the file.
+		 */
+		if (xfs_truncate_needs_cow_around(ip, oldsize)) {
+			error = xfs_file_unshare_at(ip, oldsize);
+			if (error)
+				return error;
+		}
+
 		trace_xfs_zero_eof(ip, oldsize, newsize - oldsize);
 		error = xfs_zero_range(ip, oldsize, newsize - oldsize,
 				&did_zeroing);
 	} else {
+		/*
+		 * We're reducing the size of the file, so COW around the new
+		 * EOF allocation unit before truncation zeroes the part of the
+		 * EOF block after the new EOF.  Flush the dirty pages to disk
+		 * before we start truncating the pagecache because truncation
+		 * zeroing doesn't preflush written mappings.
+		 */
+		if (xfs_truncate_needs_cow_around(ip, newsize)) {
+			error = xfs_file_unshare_at(ip, newsize);
+			if (error)
+				return error;
+
+			error = filemap_write_and_wait_range(inode->i_mapping,
+					newsize, newsize);
+			if (error)
+				return error;
+		}
+
 		error = xfs_truncate_page(ip, newsize, &did_zeroing);
 	}
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 59f7fc16eb8093..4f87f7041995c4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -34,6 +34,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_rtgroup.h"
 #include "xfs_metafile.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -302,9 +303,26 @@ xfs_reflink_convert_cow_locked(
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_irec	got;
 	struct xfs_btree_cur	*dummy_cur = NULL;
+	struct xfs_mount	*mp = ip->i_mount;
 	int			dummy_logflags;
 	int			error = 0;
 
+	/*
+	 * We can only remap full rt extents, so make sure that we convert the
+	 * entire extent.  The caller must ensure that this is either a direct
+	 * write that's aligned to the rt extent size, or a buffered write for
+	 * which we've dirtied extra pages to make this work properly.
+	 */
+	if (xfs_inode_needs_cow_around(ip)) {
+		xfs_fileoff_t	new_off;
+
+		new_off = xfs_fileoff_rounddown_rtx(mp, offset_fsb);
+		count_fsb += offset_fsb - new_off;
+		offset_fsb = new_off;
+
+		count_fsb = xfs_blen_roundup_rtx(mp, count_fsb);
+	}
+
 	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got))
 		return 0;
 
@@ -626,11 +644,21 @@ xfs_reflink_cancel_cow_blocks(
 	bool				cancel_real)
 {
 	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
+	struct xfs_mount		*mp = ip->i_mount;
 	struct xfs_bmbt_irec		got, del;
 	struct xfs_iext_cursor		icur;
 	bool				isrt = XFS_IS_REALTIME_INODE(ip);
 	int				error = 0;
 
+	/*
+	 * Shrink the range that we're cancelling if they don't align to the
+	 * realtime extent size, since we can only free full extents.
+	 */
+	if (xfs_inode_needs_cow_around(ip)) {
+		offset_fsb = xfs_fileoff_roundup_rtx(mp, offset_fsb);
+		end_fsb = xfs_fileoff_rounddown_rtx(mp, end_fsb);
+	}
+
 	if (!xfs_inode_has_cow_data(ip))
 		return 0;
 	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
@@ -923,6 +951,7 @@ xfs_reflink_end_cow(
 	xfs_off_t			offset,
 	xfs_off_t			count)
 {
+	struct xfs_mount		*mp = ip->i_mount;
 	xfs_fileoff_t			offset_fsb;
 	xfs_fileoff_t			end_fsb;
 	int				error = 0;
@@ -932,6 +961,16 @@ xfs_reflink_end_cow(
 	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
 	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
 
+	/*
+	 * Make sure the end is aligned with a rt extent (if desired), since
+	 * the end of the range could be EOF.  The _convert_cow function should
+	 * have set us up to swap only full rt extents.
+	 */
+	if (xfs_inode_needs_cow_around(ip)) {
+		offset_fsb = xfs_fileoff_rounddown_rtx(mp, offset_fsb);
+		end_fsb = xfs_fileoff_roundup_rtx(mp, end_fsb);
+	}
+
 	/*
 	 * Walk forwards until we've remapped the I/O range.  The loop function
 	 * repeatedly cycles the ILOCK to allocate one transaction per remapped
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8af9c38bea152f..e744f9435ff88d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3970,6 +3970,7 @@ TRACE_EVENT(xfs_ioctl_clone,
 
 /* unshare tracepoints */
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_unshare);
+DEFINE_SIMPLE_IO_EVENT(xfs_file_cow_around);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
 #ifdef CONFIG_XFS_RT
 DEFINE_SIMPLE_IO_EVENT(xfs_convert_rtbigalloc_file_space);

