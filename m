Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC24DF9D6
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000484; cv=none; b=XFQq+uqkmMAFff2STwmcehIDSbYSNhwSbyLoRP+WoGZ0d6z12r4hUk4/oHiUGh0KJVM+njSttRssQtVSGe9A+lDQ9KoGgOGGBtFeZ5T6hQ4iqy109HKgNNrR2b4mrcbtDfn1mgq7J1PCi77CCcnqtQcjXoaxA5PSeKSVgJhFIuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000484; c=relaxed/simple;
	bh=0EJ1NIU6IQ3I5zg4l/vhcWVV1i2iVzA52MVQ9ZnRcyo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NUAhFACCs0Ktiy53C6vC1eL/YFVsywOYLL09gJL9YY3yM6d/4sU/gTCLyKUxd2aQpi1UiZs2oziwizGCBa4afMr7niQBRw5PNRDtc8LptRnuv9Avdo5gFga8f0nZZASsN5PktwvCIr5pBFfsuTvy5l4/3YKSTLKiw85ybhA2HVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cgvfvj8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cgvfvj8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4010C433F1;
	Tue, 27 Feb 2024 02:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000483;
	bh=0EJ1NIU6IQ3I5zg4l/vhcWVV1i2iVzA52MVQ9ZnRcyo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Cgvfvj8J1d7SOQkow6NHQ2ebEuydLt60L/0jbcwxD5/pzGRxZ5BLEO1x9qJLZenzZ
	 t3frAMEVpebEWl4SHSE2cfoznsYYcOM8FZc3kCQ7OboJehoTjWi28pbE4eaC9cG9L4
	 Oc3tdJhrVm8CBXRuPokLf/pO5zhxGuYIuXMNtuBpew2D6HTgvSJuSNitG7HSKn1OMU
	 1OW25ACizjQtb3Tf5ybjkz5zMXv0VI3iu0Fv/nJ2yHjTp7idM2WXnsm7PS37f1RGEj
	 Ibmw++hNogkhJSAOq17vyyqJ5ZdzfPJUf60IO7KbweKJxN9HCwLH3c+2h2DK18nF9U
	 ddoyzFBKBQmmg==
Date: Mon, 26 Feb 2024 18:21:23 -0800
Subject: [PATCH 02/14] xfs: introduce new file range exchange ioctls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900011673.938268.12940080187778287002.stgit@frogsfrogsfrogs>
In-Reply-To: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
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

Introduce a pair of new ioctls to handle exchanging ranges of bytes
between files.  The goal here is to perform the exchange atomically with
respect to applications -- either they see the file contents before the
exchange or they see that A-B is now B-A, even if the kernel crashes.

The simpler of the two ioctls is XFS_IOC_EXCHANGE_RANGE, which performs
the exchange unconditionally.  XFS_IOC_COMMIT_RANGE, on the other hand,
requires the caller to sample the file attributes of one of the files
participating in the exchange, and aborts the exchange if that file has
changed in the meantime (presumably by another thread).

For userspace programs the goal is to enable defragmentation of files
(it's a replacement for the old swapext ioctl), the atomic commit of
sparse updates to an indexed data file, or emulation of atomic writes on
software defined storage servers.

My original goal with all this code was to make it so that online repair
can build a replacement directory or xattr structure in a temporary file
and commit the repair by atomically exchanging all the data blocks
between the two files.  However, I needed a way to test this mechanism
thoroughly, so I've been evolving an ioctl interface since then.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |   72 +++++++++++
 fs/xfs/xfs_exchrange.c |  307 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_exchrange.h |   38 ++++++
 fs/xfs/xfs_ioctl.c     |   89 ++++++++++++++
 5 files changed, 507 insertions(+)
 create mode 100644 fs/xfs/xfs_exchrange.c
 create mode 100644 fs/xfs/xfs_exchrange.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 20f0bbe4b7102..3e85762a28ee7 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -67,6 +67,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_dir2_readdir.o \
 				   xfs_discard.o \
 				   xfs_error.o \
+				   xfs_exchrange.o \
 				   xfs_export.o \
 				   xfs_extent_busy.o \
 				   xfs_file.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index ca1b17d014377..fe2bd607ac11f 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -772,6 +772,76 @@ struct xfs_scrub_metadata {
 #  define XFS_XATTR_LIST_MAX 65536
 #endif
 
+/*
+ * Exchange part of file1 with part of the file that this ioctl that is being
+ * called against (which we'll call file2).  Filesystems must be able to
+ * restart and complete the operation even after the system goes down.
+ */
+struct xfs_exch_range {
+	__s64		file1_fd;
+	__s64		file1_offset;	/* file1 offset, bytes */
+	__s64		file2_offset;	/* file2 offset, bytes */
+	__u64		length;		/* bytes to exchange */
+
+	__u64		flags;		/* see XFS_EXCHRANGE_* below */
+
+	__u64		pad;		/* must be zeroes */
+};
+
+/*
+ * Using the same definition of file2 as struct xfs_exch_range, commit the
+ * contents of file1 into file2 if file2 has the same inode number, mtime, and
+ * ctime as the arguments provided to the call.  The old contents of file2 will
+ * be moved to file1.
+ *
+ * Returns -EBUSY if there isn't an exact match for the file2 fields.
+ *
+ * Filesystems must be able to restart and complete the operation even after
+ * the system goes down.
+ */
+struct xfs_commit_range {
+	__s64		file1_fd;
+	__s64		file1_offset;	/* file1 offset, bytes */
+	__s64		file2_offset;	/* file2 offset, bytes */
+	__s64		length;		/* bytes to exchange */
+
+	__u64		flags;		/* see XFS_EXCHRANGE_* below */
+
+	/* file2 metadata for freshness checks */
+	__u64		file2_ino;	/* inode number */
+	__s64		file2_mtime;	/* modification time */
+	__s64		file2_ctime;	/* change time */
+	__s32		file2_mtime_nsec; /* mod time, nsec */
+	__s32		file2_ctime_nsec; /* change time, nsec */
+
+	__u64		pad;		/* must be zeroes */
+};
+
+/*
+ * Exchange file data all the way to the ends of both files, and then exchange
+ * the file sizes.  This flag can be used to replace a file's contents with a
+ * different amount of data.  length will be ignored.
+ */
+#define XFS_EXCHRANGE_TO_EOF		(1ULL << 0)
+
+/* Flush all changes in file data and file metadata to disk before returning. */
+#define XFS_EXCHRANGE_DSYNC		(1ULL << 1)
+
+/* Dry run; do all the parameter verification but do not change anything. */
+#define XFS_EXCHRANGE_DRY_RUN		(1ULL << 2)
+
+/*
+ * Exchange only the parts of the two files where the file allocation units
+ * mapped to file1's range have been written to.  This can accelerate
+ * scatter-gather atomic writes with a temp file if all writes are aligned to
+ * the file allocation unit.
+ */
+#define XFS_EXCHRANGE_FILE1_WRITTEN	(1ULL << 3)
+
+#define XFS_EXCHRANGE_ALL_FLAGS		(XFS_EXCHRANGE_TO_EOF | \
+					 XFS_EXCHRANGE_DSYNC | \
+					 XFS_EXCHRANGE_DRY_RUN | \
+					 XFS_EXCHRANGE_FILE1_WRITTEN)
 
 /*
  * ioctl commands that are used by Linux filesystems
@@ -843,6 +913,8 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
+#define XFS_IOC_EXCHANGE_RANGE	     _IOWR('X', 129, struct xfs_exch_range)
+#define XFS_IOC_COMMIT_RANGE	     _IOWR('X', 129, struct xfs_commit_range)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
new file mode 100644
index 0000000000000..d5889db89daeb
--- /dev/null
+++ b/fs/xfs/xfs_exchrange.c
@@ -0,0 +1,307 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_exchrange.h"
+#include <linux/fsnotify.h>
+
+/*
+ * Generic code for exchanging ranges of two files via XFS_IOC_EXCHANGE_RANGE.
+ * This part deals with struct file objects and byte ranges and does not deal
+ * with XFS-specific data structures such as xfs_inodes and block ranges.  It
+ * may some day be ported to the VFS.
+ *
+ * The goal is to exchange fxr.length bytes starting at fxr.file1_offset in
+ * file1 with the same number of bytes starting at fxr.file2_offset in file2.
+ * Implementations must call xfs_generic_exchrange_prep to prepare the two
+ * files prior to taking locks; and they must update the inode change and mod
+ * times of both files as part of the metadata update.  The timestamp update
+ * and freshness checks must be done atomically as part of the data exchange
+ * operation to ensure correctness of the freshness check.
+ * xfs_generic_exchrange_finish must be called after the operation completes
+ * successfully but before locks are dropped.
+ */
+
+/* Verify that we have security clearance to perform this operation. */
+static int
+xfs_generic_exchrange_verify_area(
+	struct xfs_exchrange	*fxr)
+{
+	int			ret;
+
+	ret = remap_verify_area(fxr->file1, fxr->file1_offset, fxr->length,
+			true);
+	if (ret)
+		return ret;
+
+	return remap_verify_area(fxr->file2, fxr->file2_offset, fxr->length,
+			true);
+}
+
+/*
+ * Performs necessary checks before doing a range exchange, having stabilized
+ * mutable inode attributes via i_rwsem.
+ */
+static inline int
+xfs_generic_exchrange_checks(
+	struct xfs_exchrange	*fxr,
+	unsigned int		alloc_unit)
+{
+	struct inode		*inode1 = file_inode(fxr->file1);
+	struct inode		*inode2 = file_inode(fxr->file2);
+	uint64_t		allocmask = alloc_unit - 1;
+	int64_t			test_len;
+	uint64_t		blen;
+	loff_t			size1, size2, tmp;
+	int			error;
+
+	/* Don't touch certain kinds of inodes */
+	if (IS_IMMUTABLE(inode1) || IS_IMMUTABLE(inode2))
+		return -EPERM;
+	if (IS_SWAPFILE(inode1) || IS_SWAPFILE(inode2))
+		return -ETXTBSY;
+
+	size1 = i_size_read(inode1);
+	size2 = i_size_read(inode2);
+
+	/* Ranges cannot start after EOF. */
+	if (fxr->file1_offset > size1 || fxr->file2_offset > size2)
+		return -EINVAL;
+
+	/*
+	 * If the caller said to exchange to EOF, we set the length of the
+	 * request large enough to cover everything to the end of both files.
+	 */
+	if (fxr->flags & XFS_EXCHRANGE_TO_EOF) {
+		fxr->length = max_t(int64_t, size1 - fxr->file1_offset,
+					     size2 - fxr->file2_offset);
+
+		error = xfs_generic_exchrange_verify_area(fxr);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * The start of both ranges must be aligned to the file allocation
+	 * unit.
+	 */
+	if (!IS_ALIGNED(fxr->file1_offset, alloc_unit) ||
+	    !IS_ALIGNED(fxr->file2_offset, alloc_unit))
+		return -EINVAL;
+
+	/* Ensure offsets don't wrap. */
+	if (check_add_overflow(fxr->file1_offset, fxr->length, &tmp) ||
+	    check_add_overflow(fxr->file2_offset, fxr->length, &tmp))
+		return -EINVAL;
+
+	/*
+	 * We require both ranges to end within EOF, unless we're exchanging
+	 * to EOF.
+	 */
+	if (!(fxr->flags & XFS_EXCHRANGE_TO_EOF) &&
+	    (fxr->file1_offset + fxr->length > size1 ||
+	     fxr->file2_offset + fxr->length > size2))
+		return -EINVAL;
+
+	/*
+	 * Make sure we don't hit any file size limits.  If we hit any size
+	 * limits such that test_length was adjusted, we abort the whole
+	 * operation.
+	 */
+	test_len = fxr->length;
+	error = generic_write_check_limits(fxr->file2, fxr->file2_offset,
+			&test_len);
+	if (error)
+		return error;
+	error = generic_write_check_limits(fxr->file1, fxr->file1_offset,
+			&test_len);
+	if (error)
+		return error;
+	if (test_len != fxr->length)
+		return -EINVAL;
+
+	/*
+	 * If the user wanted us to exchange up to the infile's EOF, round up
+	 * to the next allocation unit boundary for this check.  Do the same
+	 * for the outfile.
+	 *
+	 * Otherwise, reject the range length if it's not aligned to an
+	 * allocation unit.
+	 */
+	if (fxr->file1_offset + fxr->length == size1)
+		blen = ALIGN(size1, alloc_unit) - fxr->file1_offset;
+	else if (fxr->file2_offset + fxr->length == size2)
+		blen = ALIGN(size2, alloc_unit) - fxr->file2_offset;
+	else if (!IS_ALIGNED(fxr->length, alloc_unit))
+		return -EINVAL;
+	else
+		blen = fxr->length;
+
+	/* Don't allow overlapped exchanges within the same file. */
+	if (inode1 == inode2 &&
+	    fxr->file2_offset + blen > fxr->file1_offset &&
+	    fxr->file1_offset + blen > fxr->file2_offset)
+		return -EINVAL;
+
+	/*
+	 * Ensure that we don't exchange a partial EOF block into the middle of
+	 * another file.
+	 */
+	if ((fxr->length & allocmask) == 0)
+		return 0;
+
+	blen = fxr->length;
+	if (fxr->file2_offset + blen < size2)
+		blen &= ~allocmask;
+
+	if (fxr->file1_offset + blen < size1)
+		blen &= ~allocmask;
+
+	return blen == fxr->length ? 0 : -EINVAL;
+}
+
+/*
+ * Check that the two inodes are eligible for range exchanges, the ranges make
+ * sense, and then flush all dirty data.  Caller must ensure that the inodes
+ * have been locked against any other modifications.
+ */
+static inline int
+xfs_generic_exchrange_prep(
+	struct xfs_exchrange	*fxr,
+	unsigned int		alloc_unit)
+{
+	struct inode		*inode1 = file_inode(fxr->file1);
+	struct inode		*inode2 = file_inode(fxr->file2);
+	bool			same_inode = (inode1 == inode2);
+	int			error;
+
+	/* Check that we don't violate system file offset limits. */
+	error = xfs_generic_exchrange_checks(fxr, alloc_unit);
+	if (error || fxr->length == 0)
+		return error;
+
+	/* Wait for the completion of any pending IOs on both files */
+	inode_dio_wait(inode1);
+	if (!same_inode)
+		inode_dio_wait(inode2);
+
+	error = filemap_write_and_wait_range(inode1->i_mapping,
+			fxr->file1_offset,
+			fxr->file1_offset + fxr->length - 1);
+	if (error)
+		return error;
+
+	error = filemap_write_and_wait_range(inode2->i_mapping,
+			fxr->file2_offset,
+			fxr->file2_offset + fxr->length - 1);
+	if (error)
+		return error;
+
+	/*
+	 * If the files or inodes involved require synchronous writes, amend
+	 * the request to force the filesystem to flush all data and metadata
+	 * to disk after the operation completes.
+	 */
+	if (((fxr->file1->f_flags | fxr->file2->f_flags) & (__O_SYNC | O_DSYNC)) ||
+	    IS_SYNC(inode1) || IS_SYNC(inode2))
+		fxr->flags |= XFS_EXCHRANGE_DSYNC;
+
+	return 0;
+}
+
+/*
+ * Finish a range exchange operation, if it was successful.  Caller must ensure
+ * that the inodes are still locked against any other modifications.
+ */
+static inline int
+xfs_generic_exchrange_finish(
+	struct xfs_exchrange	*fxr)
+{
+	int			error;
+
+	error = file_remove_privs(fxr->file1);
+	if (error)
+		return error;
+	if (file_inode(fxr->file1) == file_inode(fxr->file2))
+		return 0;
+
+	return file_remove_privs(fxr->file2);
+}
+
+/* Exchange parts of two files. */
+int
+xfs_exchange_range(
+	struct xfs_exchrange	*fxr)
+{
+	struct inode		*inode1 = file_inode(fxr->file1);
+	struct inode		*inode2 = file_inode(fxr->file2);
+	int			ret;
+
+	BUILD_BUG_ON(XFS_IOC_EXCHANGE_RANGE == XFS_IOC_COMMIT_RANGE);
+	BUILD_BUG_ON(XFS_EXCHRANGE_ALL_FLAGS & XFS_EXCHRANGE_PRIVATE_FLAGS);
+
+	if (fxr->flags & ~(XFS_EXCHRANGE_ALL_FLAGS | __XFS_EXCHRANGE_CHECK_FRESH2))
+		return -EINVAL;
+
+	/*
+	 * The ioctl enforces that src and dest files are on the same mount.
+	 * However, they only need to be on the same file system.
+	 */
+	if (inode1->i_sb != inode2->i_sb)
+		return -EXDEV;
+
+	/* Userspace requests only honored for regular files. */
+	if (S_ISDIR(inode1->i_mode) || S_ISDIR(inode2->i_mode))
+		return -EISDIR;
+	if (!S_ISREG(inode1->i_mode) || !S_ISREG(inode2->i_mode))
+		return -EINVAL;
+
+	/* Both files must be opened for read and write. */
+	if (!(fxr->file1->f_mode & FMODE_READ) ||
+	    !(fxr->file1->f_mode & FMODE_WRITE) ||
+	    !(fxr->file2->f_mode & FMODE_READ) ||
+	    !(fxr->file2->f_mode & FMODE_WRITE))
+		return -EBADF;
+
+	/* Neither file can be opened append-only. */
+	if ((fxr->file1->f_flags & O_APPEND) ||
+	    (fxr->file2->f_flags & O_APPEND))
+		return -EBADF;
+
+	/*
+	 * If we're not exchanging to EOF, we can check the areas before
+	 * stabilizing both files' i_size.
+	 */
+	if (!(fxr->flags & XFS_EXCHRANGE_TO_EOF)) {
+		ret = xfs_generic_exchrange_verify_area(fxr);
+		if (ret)
+			return ret;
+	}
+
+	/* Update cmtime if the fd/inode don't forbid it. */
+	if (!(fxr->file1->f_mode & FMODE_NOCMTIME) && !IS_NOCMTIME(inode1))
+		fxr->flags |= __XFS_EXCHRANGE_UPD_CMTIME1;
+	if (!(fxr->file2->f_mode & FMODE_NOCMTIME) && !IS_NOCMTIME(inode2))
+		fxr->flags |= __XFS_EXCHRANGE_UPD_CMTIME2;
+
+	file_start_write(fxr->file2);
+	ret = -EOPNOTSUPP; /* XXX call out to xfs code */
+	file_end_write(fxr->file2);
+	if (ret)
+		return ret;
+
+	fsnotify_modify(fxr->file1);
+	if (fxr->file2 != fxr->file1)
+		fsnotify_modify(fxr->file2);
+	return 0;
+}
diff --git a/fs/xfs/xfs_exchrange.h b/fs/xfs/xfs_exchrange.h
new file mode 100644
index 0000000000000..593a85a644bce
--- /dev/null
+++ b/fs/xfs/xfs_exchrange.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_EXCHRANGE_H__
+#define __XFS_EXCHRANGE_H__
+
+/* Update the mtime/cmtime of file1 and file2 */
+#define __XFS_EXCHRANGE_UPD_CMTIME1	(1ULL << 63)
+#define __XFS_EXCHRANGE_UPD_CMTIME2	(1ULL << 62)
+
+/* Freshness check required */
+#define __XFS_EXCHRANGE_CHECK_FRESH2	(1ULL << 61)
+
+#define XFS_EXCHRANGE_PRIVATE_FLAGS	(__XFS_EXCHRANGE_UPD_CMTIME1 | \
+					 __XFS_EXCHRANGE_UPD_CMTIME2 | \
+					 __XFS_EXCHRANGE_CHECK_FRESH2)
+
+struct xfs_exchrange {
+	struct file		*file1;
+	struct file		*file2;
+
+	loff_t			file1_offset;
+	loff_t			file2_offset;
+	u64			length;
+
+	u64			flags;	/* XFS_EXCHRANGE flags */
+
+	/* file2 metadata for freshness checks if file1_ino != 0 */
+	u64			file2_ino;
+	struct timespec64	file2_mtime;
+	struct timespec64	file2_ctime;
+};
+
+int xfs_exchange_range(struct xfs_exchrange *fxr);
+
+#endif /* __XFS_EXCHRANGE_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1360a551118dd..08fc15881ee51 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -40,6 +40,7 @@
 #include "xfs_xattr.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_file.h"
+#include "xfs_exchrange.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -1930,6 +1931,89 @@ xfs_ioctl_fs_counts(
 	return 0;
 }
 
+static long
+xfs_ioc_exchange_range(
+	struct file			*file,
+	struct xfs_exch_range __user	*argp)
+{
+	struct xfs_exchrange		fxr = {
+		.file2			= file,
+	};
+	struct xfs_exch_range		args;
+	struct fd			file1;
+	int				error;
+
+	if (copy_from_user(&args, argp, sizeof(args)))
+		return -EFAULT;
+	if (memchr_inv(&args.pad, 0, sizeof(args.pad)))
+		return -EINVAL;
+	if (args.flags & ~XFS_EXCHRANGE_ALL_FLAGS)
+		return -EINVAL;
+
+	fxr.file1_offset	= args.file1_offset;
+	fxr.file2_offset	= args.file2_offset;
+	fxr.length		= args.length;
+	fxr.flags		= args.flags;
+
+	file1 = fdget(args.file1_fd);
+	if (!file1.file)
+		return -EBADF;
+	fxr.file1 = file1.file;
+
+	error = -EXDEV;
+	if (fxr.file1->f_path.mnt != fxr.file2->f_path.mnt)
+		goto fdput;
+
+	error = xfs_exchange_range(&fxr);
+fdput:
+	fdput(file1);
+	return error;
+}
+
+static long
+xfs_ioc_commit_range(
+	struct file			*file,
+	struct xfs_commit_range __user	*argp)
+{
+	struct xfs_exchrange		fxr = {
+		.file2			= file,
+	};
+	struct xfs_commit_range		args;
+	struct fd			file1;
+	int				error;
+
+	if (copy_from_user(&args, argp, sizeof(args)))
+		return -EFAULT;
+	if (memchr_inv(&args.pad, 0, sizeof(args.pad)))
+		return -EINVAL;
+	if (args.flags & ~XFS_EXCHRANGE_ALL_FLAGS)
+		return -EINVAL;
+
+	fxr.file1_offset	= args.file1_offset;
+	fxr.file2_offset	= args.file2_offset;
+	fxr.length		= args.length;
+	fxr.flags		= args.flags | __XFS_EXCHRANGE_CHECK_FRESH2;
+	fxr.file2_ino		= args.file2_ino;
+	fxr.file2_mtime.tv_sec	= args.file2_mtime;
+	fxr.file2_mtime.tv_nsec	= args.file2_mtime_nsec;
+	fxr.file2_ctime.tv_sec	= args.file2_ctime;
+	fxr.file2_ctime.tv_nsec	= args.file2_ctime_nsec;
+
+	file1 = fdget(args.file1_fd);
+	if (!file1.file)
+		return -EBADF;
+	fxr.file1 = file1.file;
+
+	error = -EXDEV;
+	if (fxr.file1->f_path.mnt != fxr.file2->f_path.mnt)
+		goto fdput;
+
+	error = xfs_exchange_range(&fxr);
+fdput:
+	fdput(file1);
+	return error;
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -2170,6 +2254,11 @@ xfs_file_ioctl(
 		return error;
 	}
 
+	case XFS_IOC_EXCHANGE_RANGE:
+		return xfs_ioc_exchange_range(filp, arg);
+	case XFS_IOC_COMMIT_RANGE:
+		return xfs_ioc_commit_range(filp, arg);
+
 	default:
 		return -ENOTTY;
 	}

