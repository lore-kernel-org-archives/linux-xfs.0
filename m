Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C996FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236116AbiLaB7p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbiLaB7o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:59:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F8B1C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:59:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07A8661C44
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B092C433D2;
        Sat, 31 Dec 2022 01:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451982;
        bh=iql+fvS7EP6D1klVfUP7nuUtyQSa5ntEDqRifMyvqhI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iBZF49Dk8xDy6ZyKUx/YhCbsyJYdhaeroGpHyY9zAXy4kBFDbCiOWPGaOd3H0ViHh
         VnvM+xC+22IQOAnoHE+6r4t66vlAMFwWPdJEUTK2zOC1qUM8Gg5+lbwxIWjX6/KW4p
         pETO8mFS8qN7pmw4UsmjFFE4ZwYqn3FZ+4cipts7MM/4raEeAQt4XkK8jagS0W0CPQ
         rJ82GtpuQaLFyf+e3rrOI1uDruTt2REk0hnRQnR6fkZY47CTHVOYD2yuvpoECmRE7O
         nI6uci9ypIH3biU94yJ9XnKDSPT0l/dozPIdPGB0NgfKcTEMTSTM/B/0zRdng18Yfy
         BRGC1KjZtaXUQ==
Subject: [PATCH 3/9] xfs: enable CoW when rt extent size is larger than 1
 block
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:38 -0800
Message-ID: <167243871846.718512.5400138730721927261.stgit@magnolia>
In-Reply-To: <167243871792.718512.13170681692847163098.stgit@magnolia>
References: <167243871792.718512.13170681692847163098.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
 fs/xfs/xfs_file.c    |  171 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h   |    9 +++
 fs/xfs/xfs_iops.c    |   15 ++++
 fs/xfs/xfs_reflink.c |   39 +++++++++++
 fs/xfs/xfs_trace.h   |    1 
 5 files changed, 235 insertions(+)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 87dfb05640a8..e172ca1b18df 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -32,6 +32,7 @@
 #include <linux/mman.h>
 #include <linux/fadvise.h>
 #include <linux/mount.h>
+#include <linux/buffer_head.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -396,6 +397,13 @@ xfs_file_write_checks(
 			goto restart;
 		}
 
+		if (xfs_inode_needs_cow_around(ip)) {
+			error = xfs_file_cow_around(ip, isize,
+					iocb->ki_pos - isize);
+			if (error)
+				return error;
+		}
+
 		trace_xfs_zero_eof(ip, isize, iocb->ki_pos - isize);
 		error = xfs_zero_range(ip, isize, iocb->ki_pos - isize, NULL);
 		if (error)
@@ -508,6 +516,7 @@ xfs_file_dio_write_aligned(
 	struct iov_iter		*from)
 {
 	unsigned int		iolock = XFS_IOLOCK_SHARED;
+	size_t			count = iov_iter_count(from);
 	ssize_t			ret;
 
 	ret = xfs_ilock_iocb(iocb, iolock);
@@ -517,6 +526,17 @@ xfs_file_dio_write_aligned(
 	if (ret)
 		goto out_unlock;
 
+	/*
+	 * We can't unshare a partial rt extent yet, which means that we can't
+	 * handle direct writes that are block-aligned but not rtextent-aligned.
+	 */
+	if (xfs_inode_needs_cow_around(ip) &&
+	    !xfs_is_falloc_aligned(ip, iocb->ki_pos, count)) {
+		trace_xfs_reflink_bounce_dio_write(iocb, from);
+		ret = -ENOTBLK;
+		goto out_unlock;
+	}
+
 	/*
 	 * We don't need to hold the IOLOCK exclusively across the IO, so demote
 	 * the iolock back to shared if we had to take the exclusive lock in
@@ -753,6 +773,68 @@ xfs_file_buffered_write(
 	return ret;
 }
 
+/* Unshare the rtextent at the given file position.  */
+static inline int
+xfs_file_unshare_at(
+	struct xfs_inode	*ip,
+	loff_t			isize,
+	unsigned int		extsize,
+	loff_t			pos)
+{
+	loff_t			len = extsize;
+	uint32_t		mod;
+
+	div_u64_rem(pos, extsize, &mod);
+	if (mod == 0)
+		return 0;
+
+	pos -= mod;
+	if (pos >= isize)
+		return 0;
+
+	if (pos + len > isize)
+		len = isize - pos;
+
+	trace_xfs_file_cow_around(ip, pos, len);
+
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
+int
+xfs_file_cow_around(
+	struct xfs_inode	*ip,
+	loff_t			pos,
+	long long int		count)
+{
+	unsigned int		extsize = xfs_inode_alloc_unitsize(ip);
+	loff_t			isize = i_size_read(VFS_I(ip));
+	int			error;
+
+	if (xfs_is_falloc_aligned(ip, pos, count))
+		return 0;
+
+	inode_dio_wait(VFS_I(ip));
+
+	/* Unshare at the start of the extent. */
+	error = xfs_file_unshare_at(ip, isize, extsize, pos);
+	if (error)
+		return error;
+
+	/* Unshare at the end. */
+	return xfs_file_unshare_at(ip, isize, extsize, pos + count);
+}
+
 STATIC ssize_t
 xfs_file_write_iter(
 	struct kiocb		*iocb,
@@ -774,6 +856,16 @@ xfs_file_write_iter(
 	if (IS_DAX(inode))
 		return xfs_file_dax_write(iocb, from);
 
+	if (xfs_inode_needs_cow_around(ip)) {
+		ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_EXCL);
+		if (ret)
+			return ret;
+		ret = xfs_file_cow_around(ip, iocb->ki_pos, ocount);
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+		if (ret)
+			return ret;
+	}
+
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		/*
 		 * Allow a directio write to fall back to a buffered
@@ -929,6 +1021,13 @@ xfs_file_fallocate(
 		goto out_unlock;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
+		/* Unshare around the region to punch, if needed. */
+		if (xfs_inode_needs_cow_around(ip)) {
+			error = xfs_file_cow_around(ip, offset, len);
+			if (error)
+				goto out_unlock;
+		}
+
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
 			goto out_unlock;
@@ -999,6 +1098,14 @@ xfs_file_fallocate(
 
 			trace_xfs_zero_file_space(ip);
 
+			/* Unshare around the region to zero, if needed. */
+			if (xfs_inode_needs_cow_around(ip)) {
+				error = xfs_file_cow_around(ip, offset,
+						len);
+				if (error)
+					goto out_unlock;
+			}
+
 			error = xfs_free_file_space(ip, offset, len);
 			if (error)
 				goto out_unlock;
@@ -1007,6 +1114,26 @@ xfs_file_fallocate(
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
@@ -1341,6 +1468,35 @@ xfs_dax_fault(
 }
 #endif
 
+static int
+xfs_filemap_fault_around(
+	struct vm_fault		*vmf,
+	struct inode		*inode)
+{
+	struct folio		*folio = page_folio(vmf->page);
+	loff_t			pos;
+	ssize_t			len;
+	int			error;
+
+	if (!xfs_inode_needs_cow_around(XFS_I(inode)))
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
+	error = xfs_file_cow_around(XFS_I(inode), pos, len);
+	if (error)
+		return error;
+
+	return 0;
+}
+
 /*
  * Locking for serialisation of IO during page faults. This results in a lock
  * ordering of:
@@ -1378,7 +1534,21 @@ __xfs_filemap_fault(
 		xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	} else {
 		if (write_fault) {
+			int	error;
+
 			xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+
+			/*
+			 * Unshare all the blocks in this rt extent surrounding
+			 * this page.
+			 */
+			error = xfs_filemap_fault_around(vmf, inode);
+			if (error) {
+				xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+				ret = block_page_mkwrite_return(error);
+				goto out;
+			}
+
 			ret = iomap_page_mkwrite(vmf,
 					&xfs_page_mkwrite_iomap_ops);
 			xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
@@ -1387,6 +1557,7 @@ __xfs_filemap_fault(
 		}
 	}
 
+out:
 	if (write_fault)
 		sb_end_pagefault(inode->i_sb);
 	return ret;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ca7ebb07efc7..32a1d114dfaf 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -309,6 +309,12 @@ static inline bool xfs_inode_has_bigrtextents(struct xfs_inode *ip)
 	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
 }
 
+/* Decide if we need to unshare the blocks around a range that we're writing. */
+static inline bool xfs_inode_needs_cow_around(struct xfs_inode *ip)
+{
+	return xfs_is_reflink_inode(ip) && xfs_inode_has_bigrtextents(ip);
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */
@@ -636,4 +642,7 @@ int xfs_icreate_dqalloc(const struct xfs_icreate_args *args,
 		struct xfs_dquot **udqpp, struct xfs_dquot **gdqpp,
 		struct xfs_dquot **pdqpp);
 
+int xfs_file_cow_around(struct xfs_inode *ip, loff_t pos,
+		long long int count);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 626ce6c4e2bf..c0a827b23948 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -26,6 +26,7 @@
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
 #include "xfs_bmap.h"
+#include "xfs_reflink.h"
 
 #include <linux/posix_acl.h>
 #include <linux/security.h>
@@ -861,10 +862,24 @@ xfs_setattr_size(
 	 * truncate.
 	 */
 	if (newsize > oldsize) {
+		if (xfs_inode_needs_cow_around(ip)) {
+			error = xfs_file_cow_around(ip, oldsize,
+					newsize - oldsize);
+			if (error)
+				return error;
+		}
+
 		trace_xfs_zero_eof(ip, oldsize, newsize - oldsize);
 		error = xfs_zero_range(ip, oldsize, newsize - oldsize,
 				&did_zeroing);
 	} else {
+		if (xfs_inode_needs_cow_around(ip)) {
+			error = xfs_file_cow_around(ip, newsize,
+					oldsize - newsize);
+			if (error)
+				return error;
+		}
+
 		/*
 		 * iomap won't detect a dirty page over an unwritten block (or a
 		 * cow block over a hole) and subsequently skips zeroing the
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 13a613c077df..8690017beb9b 100644
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
@@ -942,6 +970,7 @@ xfs_reflink_end_cow(
 	xfs_off_t			offset,
 	xfs_off_t			count)
 {
+	struct xfs_mount		*mp = ip->i_mount;
 	xfs_fileoff_t			offset_fsb;
 	xfs_fileoff_t			end_fsb;
 	int				error = 0;
@@ -951,6 +980,16 @@ xfs_reflink_end_cow(
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
index d07947451ec9..d5b0dc3c5a0d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3888,6 +3888,7 @@ TRACE_EVENT(xfs_ioctl_clone,
 
 /* unshare tracepoints */
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_unshare);
+DEFINE_SIMPLE_IO_EVENT(xfs_file_cow_around);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
 #ifdef CONFIG_XFS_RT
 DEFINE_SIMPLE_IO_EVENT(xfs_rtfile_convert_unwritten);

