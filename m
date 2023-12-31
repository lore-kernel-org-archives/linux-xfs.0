Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BFC1171B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iqc0Zclb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6759BC433C7;
	Sun, 31 Dec 2023 21:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059794;
	bh=cA56i82jDHrYXEthv9I4eCGmXAAuHI7VU4dLWfEg4vk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Iqc0Zclb/fST+lAUbJ3xUduVENHjJxs5fYPF7AnzVqo6QGekH4RA9XTJTR4Uf9Wo/
	 GKeyEEoZUy1kQkMem4QkfIb/dvQULVPf4RsyEZJJFoF8i+87BWc4ALKrKumagKaQF9
	 3cxcsmQOzqnROk52yBcVGtLyUKp6fxGwa2mX7pglscknEBvjGWiDqzJR3oyBUYVmWg
	 UI/dRIVZ/JzqDHYx/SDL4tLbvJlSKXy4Qm19CCSZzh0e4jTIRRXq7tNP1+B5Kwk6Io
	 l3qMLXB7RLsijYEygRMnvUK72qxbAahDtR31x0BInd51heY2yBteVZCLV3+MtkiaMI
	 HklbvyQmYJyVA==
Date: Sun, 31 Dec 2023 13:56:33 -0800
Subject: [PATCH 2/9] xfs: enable CoW when rt extent size is larger than 1
 block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852703.1767395.4031402007268981201.stgit@frogsfrogsfrogs>
In-Reply-To: <170404852650.1767395.17654728220580066333.stgit@frogsfrogsfrogs>
References: <170404852650.1767395.17654728220580066333.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c    |  224 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_file.h    |    3 +
 fs/xfs/xfs_inode.h   |    6 +
 fs/xfs/xfs_iops.c    |   22 +++++
 fs/xfs/xfs_reflink.c |   39 +++++++++
 fs/xfs/xfs_trace.h   |    1 
 6 files changed, 293 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index fdbeb6c3fbc44..ebdda286cb2a2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -358,6 +358,116 @@ xfs_file_splice_read(
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
  * Common pre-write limit and setup checks.
  *
@@ -397,9 +507,10 @@ xfs_file_write_checks(
 
 	/*
 	 * For changing security info in file_remove_privs() we need i_rwsem
-	 * exclusively.
+	 * exclusively.  We also need it to COW around the range being written.
 	 */
-	if (*iolock == XFS_IOLOCK_SHARED && !IS_NOSEC(inode)) {
+	if (*iolock == XFS_IOLOCK_SHARED &&
+	    (!IS_NOSEC(inode) || xfs_iocb_needs_cow_around(ip, iocb, from))) {
 		xfs_iunlock(ip, *iolock);
 		*iolock = XFS_IOLOCK_EXCL;
 		error = xfs_ilock_iocb(iocb, *iolock);
@@ -410,6 +521,22 @@ xfs_file_write_checks(
 		goto restart;
 	}
 
+	/*
+	 * The write is not aligned to the file's allocation unit.  If either
+	 * of the allocation units at the start or end of the write range are
+	 * shared, unshare them through the page cache.
+	 */
+	if (xfs_iocb_needs_cow_around(ip, iocb, from)) {
+		ASSERT(*iolock == XFS_IOLOCK_EXCL);
+
+		inode_dio_wait(VFS_I(ip));
+		drained_dio = true;
+
+		error = xfs_file_cow_around(ip, iocb->ki_pos, count);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * If the offset is beyond the size of the file, we need to zero any
 	 * blocks that fall between the existing EOF and the start of this
@@ -461,6 +588,17 @@ xfs_file_write_checks(
 			goto restart;
 		}
 
+		/*
+		 * If we're starting the write past EOF, COW the allocation
+		 * unit containing the current EOF before we start zeroing the
+		 * range between EOF and the start of the write.
+		 */
+		if (xfs_truncate_needs_cow_around(ip, isize)) {
+			error = xfs_file_unshare_at(ip, isize);
+			if (error)
+				return error;
+		}
+
 		trace_xfs_zero_eof(ip, isize, iocb->ki_pos - isize);
 		error = xfs_zero_range(ip, isize, iocb->ki_pos - isize, NULL);
 		if (error)
@@ -575,6 +713,16 @@ xfs_file_dio_write_aligned(
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
@@ -927,6 +1075,13 @@ xfs_file_fallocate(
 		goto out_unlock;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
+		/* Unshare around the region to punch, if needed. */
+		if (xfs_file_write_needs_cow_around(ip, offset, len)) {
+			error = xfs_file_cow_around(ip, offset, len);
+			if (error)
+				goto out_unlock;
+		}
+
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
 			goto out_unlock;
@@ -997,6 +1152,13 @@ xfs_file_fallocate(
 
 			trace_xfs_zero_file_space(ip);
 
+			/* Unshare around the region to zero, if needed. */
+			if (xfs_file_write_needs_cow_around(ip, offset, len)) {
+				error = xfs_file_cow_around(ip, offset, len);
+				if (error)
+					goto out_unlock;
+			}
+
 			error = xfs_free_file_space(ip, offset, len);
 			if (error)
 				goto out_unlock;
@@ -1005,6 +1167,26 @@ xfs_file_fallocate(
 			      round_down(offset, blksize);
 			offset = round_down(offset, blksize);
 		} else if (mode & FALLOC_FL_UNSHARE_RANGE) {
+			/*
+			 * Enlarge the unshare region to align to a full
+			 * allocation unit.
+			 */
+			if (xfs_inode_needs_cow_around(ip)) {
+				loff_t		isize = i_size_read(VFS_I(ip));
+				unsigned int	rextsize;
+				uint32_t	mod;
+
+				rextsize = xfs_inode_alloc_unitsize(ip);
+				div_u64_rem(offset, rextsize, &mod);
+				offset -= mod;
+				len += mod;
+
+				div_u64_rem(offset + len, rextsize, &mod);
+				if (mod)
+					len += rextsize - mod;
+				if (offset + len > isize)
+					len = isize - offset;
+			}
 			error = xfs_reflink_unshare(ip, offset, len);
 			if (error)
 				goto out_unlock;
@@ -1272,6 +1454,34 @@ xfs_dax_fault(
 }
 #endif
 
+static int
+xfs_filemap_fault_around(
+	struct vm_fault		*vmf,
+	struct inode		*inode)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct folio		*folio = page_folio(vmf->page);
+	loff_t			pos;
+	ssize_t			len;
+
+	if (!xfs_inode_needs_cow_around(ip))
+		return 0;
+
+	folio_lock(folio);
+	len = folio_mkwrite_check_truncate(folio, inode);
+	if (len < 0) {
+		folio_unlock(folio);
+		return len;
+	}
+	pos = folio_pos(folio);
+	folio_unlock(folio);
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
@@ -1310,11 +1520,21 @@ __xfs_filemap_fault(
 		if (ret & VM_FAULT_NEEDDSYNC)
 			ret = dax_finish_sync_fault(vmf, order, pfn);
 	} else if (write_fault) {
+		/*
+		 * Unshare all the blocks in this rt extent surrounding
+		 * this page.
+		 */
+		int error = xfs_filemap_fault_around(vmf, inode);
+		if (error) {
+			ret = vmf_fs_error(error);
+			goto out_unlock;
+		}
 		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
 	} else {
 		ret = filemap_fault(vmf);
 	}
 
+out_unlock:
 	if (lock_mode)
 		xfs_iunlock(XFS_I(inode), lock_mode);
 
diff --git a/fs/xfs/xfs_file.h b/fs/xfs/xfs_file.h
index 2ad91f755caf3..24490ea49e16c 100644
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
index 6013a97d02c5d..df8197fe4cb82 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -331,6 +331,12 @@ static inline bool xfs_inode_has_bigallocunit(struct xfs_inode *ip)
 	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
 }
 
+/* Decide if we need to unshare the blocks around a range that we're writing. */
+static inline bool xfs_inode_needs_cow_around(struct xfs_inode *ip)
+{
+	return xfs_is_cow_inode(ip) && xfs_inode_has_bigallocunit(ip);
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 461e77dd54e38..71a4398fd36ac 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -27,6 +27,7 @@
 #include "xfs_xattr.h"
 #include "xfs_file.h"
 #include "xfs_bmap.h"
+#include "xfs_reflink.h"
 
 #include <linux/posix_acl.h>
 #include <linux/security.h>
@@ -877,10 +878,31 @@ xfs_setattr_size(
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
+		 * Truncating the file, so COW around the new EOF allocation
+		 * unit before truncation zeroes the part of the EOF block
+		 * after the new EOF.
+		 */
+		if (xfs_truncate_needs_cow_around(ip, newsize)) {
+			error = xfs_file_unshare_at(ip, newsize);
+			if (error)
+				return error;
+		}
+
 		/*
 		 * iomap won't detect a dirty page over an unwritten block (or a
 		 * cow block over a hole) and subsequently skips zeroing the
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b0f3170c11c8b..d5773f9b7ec54 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -34,6 +34,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_rtgroup.h"
 #include "xfs_imeta.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -297,9 +298,26 @@ xfs_reflink_convert_cow_locked(
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
+		new_off = xfs_rtb_rounddown_rtx(mp, offset_fsb);
+		count_fsb += offset_fsb - new_off;
+		offset_fsb = new_off;
+
+		count_fsb = xfs_rtb_roundup_rtx(mp, count_fsb);
+	}
+
 	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got))
 		return 0;
 
@@ -635,11 +653,21 @@ xfs_reflink_cancel_cow_blocks(
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
+		offset_fsb = xfs_rtb_roundup_rtx(mp, offset_fsb);
+		end_fsb = xfs_rtb_rounddown_rtx(mp, end_fsb);
+	}
+
 	if (!xfs_inode_has_cow_data(ip))
 		return 0;
 	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
@@ -946,6 +974,7 @@ xfs_reflink_end_cow(
 	xfs_off_t			offset,
 	xfs_off_t			count)
 {
+	struct xfs_mount		*mp = ip->i_mount;
 	xfs_fileoff_t			offset_fsb;
 	xfs_fileoff_t			end_fsb;
 	int				error = 0;
@@ -955,6 +984,16 @@ xfs_reflink_end_cow(
 	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
 	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
 
+	/*
+	 * Make sure the end is aligned with a rt extent (if desired), since
+	 * the end of the range could be EOF.  The _convert_cow function should
+	 * have set us up to swap only full rt extents.
+	 */
+	if (xfs_inode_needs_cow_around(ip)) {
+		offset_fsb = xfs_rtb_rounddown_rtx(mp, offset_fsb);
+		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
+	}
+
 	/*
 	 * Walk forwards until we've remapped the I/O range.  The loop function
 	 * repeatedly cycles the ILOCK to allocate one transaction per remapped
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f94f144f9a39d..643cffaf3add2 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3892,6 +3892,7 @@ TRACE_EVENT(xfs_ioctl_clone,
 
 /* unshare tracepoints */
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_unshare);
+DEFINE_SIMPLE_IO_EVENT(xfs_file_cow_around);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
 #ifdef CONFIG_XFS_RT
 DEFINE_SIMPLE_IO_EVENT(xfs_convert_bigalloc_file_space);

