Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7EAC129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dw/qBhLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83BBC433C8;
	Sun, 31 Dec 2023 22:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061654;
	bh=xD2jXyNVgIDCrtbkgeO7OCuY66l3drp5+AwcoaDG428=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Dw/qBhLRX70VvEEGnAmcek9iyCNO8SlPrLKcATuD3q7kAFBruDVskjHRP/M9bhP2w
	 chY3dasslccsmTqBHh+J/ZNem86yPpU2hA1EUwoZ59Vq2BwC1rgJEf/GhAxQvNQCZr
	 iWa2rL3Go7lUN8y83dUXIQkmwmgszarYxRmpc1ovr/ufEwj9qx4M+g8PtEapth9504
	 DUlo0V5AXOltg5xyfdY0BhgYi99AZMLE7wXiw9vMv1JriKpZfKHc5UzNYFJtGOY0JP
	 j08lkr0jy4AoK2y7cWpKh3oManu6y90iMvUQbW2ke8aHlZeJFk3ZkB9cC9BEiBf629
	 2sYiUUlmeDS1g==
Date: Sun, 31 Dec 2023 14:27:34 -0800
Subject: [PATCH 02/20] xfs: introduce new file range exchange ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996301.1796128.17214457854099877041.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
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

Introduce a new ioctl to handle swapping ranges of bytes between files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h                     |    1 
 libxfs/xfs_fs_staging.h             |   89 +++++++++++
 man/man2/ioctl_xfs_exchange_range.2 |  296 +++++++++++++++++++++++++++++++++++
 3 files changed, 386 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_exchange_range.2


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index ca1b17d0143..ec92e6ded6b 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -843,6 +843,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
+/*	XFS_IOC_EXCHANGE_RANGE -------- staging 129	 */
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/libxfs/xfs_fs_staging.h b/libxfs/xfs_fs_staging.h
index d220790d5b5..e3d9f3b32b0 100644
--- a/libxfs/xfs_fs_staging.h
+++ b/libxfs/xfs_fs_staging.h
@@ -15,4 +15,93 @@
  * explaining where it went.
  */
 
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
+	__u64		flags;		/* see XFS_EXCH_RANGE_* below */
+
+	/* file2 metadata for optional freshness checks */
+	__s64		file2_ino;	/* inode number */
+	__s64		file2_mtime;	/* modification time */
+	__s64		file2_ctime;	/* change time */
+	__s32		file2_mtime_nsec; /* mod time, nsec */
+	__s32		file2_ctime_nsec; /* change time, nsec */
+
+	__u64		pad[6];		/* must be zeroes */
+};
+
+/*
+ * Atomic exchange operations are not required.  This relaxes the requirement
+ * that the filesystem must be able to complete the operation after a crash.
+ */
+#define XFS_EXCH_RANGE_NONATOMIC	(1 << 0)
+
+/*
+ * Check that file2's inode number, mtime, and ctime against the values
+ * provided, and return -EBUSY if there isn't an exact match.
+ */
+#define XFS_EXCH_RANGE_FILE2_FRESH	(1 << 1)
+
+/*
+ * Check that the file1's length is equal to file1_offset + length, and that
+ * file2's length is equal to file2_offset + length.  Returns -EDOM if there
+ * isn't an exact match.
+ */
+#define XFS_EXCH_RANGE_FULL_FILES	(1 << 2)
+
+/*
+ * Exchange file data all the way to the ends of both files, and then exchange
+ * the file sizes.  This flag can be used to replace a file's contents with a
+ * different amount of data.  length will be ignored.
+ */
+#define XFS_EXCH_RANGE_TO_EOF		(1 << 3)
+
+/* Flush all changes in file data and file metadata to disk before returning. */
+#define XFS_EXCH_RANGE_FSYNC		(1 << 4)
+
+/* Dry run; do all the parameter verification but do not change anything. */
+#define XFS_EXCH_RANGE_DRY_RUN		(1 << 5)
+
+/*
+ * Exchange only the parts of the two files where the file allocation units
+ * mapped to file1's range have been written to.  This can accelerate
+ * scatter-gather atomic writes with a temp file if all writes are aligned to
+ * the file allocation unit.
+ */
+#define XFS_EXCH_RANGE_FILE1_WRITTEN	(1 << 6)
+
+/*
+ * Commit the contents of file1 into file2 if file2 has the same inode number,
+ * mtime, and ctime as the arguments provided to the call.  The old contents of
+ * file2 will be moved to file1.
+ *
+ * With this flag, all committed information can be retrieved even if the
+ * system crashes or is rebooted.  This includes writing through or flushing a
+ * disk cache if present.  The call blocks until the device reports that the
+ * commit is complete.
+ *
+ * This flag should not be combined with NONATOMIC.  It can be combined with
+ * FILE1_WRITTEN.
+ */
+#define XFS_EXCH_RANGE_COMMIT		(XFS_EXCH_RANGE_FILE2_FRESH | \
+					 XFS_EXCH_RANGE_FSYNC)
+
+#define XFS_EXCH_RANGE_ALL_FLAGS	(XFS_EXCH_RANGE_NONATOMIC | \
+					 XFS_EXCH_RANGE_FILE2_FRESH | \
+					 XFS_EXCH_RANGE_FULL_FILES | \
+					 XFS_EXCH_RANGE_TO_EOF | \
+					 XFS_EXCH_RANGE_FSYNC | \
+					 XFS_EXCH_RANGE_DRY_RUN | \
+					 XFS_EXCH_RANGE_FILE1_WRITTEN)
+
+#define XFS_IOC_EXCHANGE_RANGE	_IOWR('X', 129, struct xfs_exch_range)
+
 #endif /* __XFS_FS_STAGING_H__ */
diff --git a/man/man2/ioctl_xfs_exchange_range.2 b/man/man2/ioctl_xfs_exchange_range.2
new file mode 100644
index 00000000000..a292d8e9641
--- /dev/null
+++ b/man/man2/ioctl_xfs_exchange_range.2
@@ -0,0 +1,296 @@
+.\" Copyright (c) 2020-2024 Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" This is free documentation; you can redistribute it and/or
+.\" modify it under the terms of the GNU General Public License as
+.\" published by the Free Software Foundation; either version 2 of
+.\" the License, or (at your option) any later version.
+.\"
+.\" The GNU General Public License's references to "object code"
+.\" and "executables" are to be interpreted as the output of any
+.\" document formatting or typesetting system, including
+.\" intermediate and printed output.
+.\"
+.\" This manual is distributed in the hope that it will be useful,
+.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\" GNU General Public License for more details.
+.\"
+.\" You should have received a copy of the GNU General Public
+.\" License along with this manual; if not, see
+.\" <http://www.gnu.org/licenses/>.
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-EXCHANGE-RANGE 2  2023-05-08 "XFS"
+.SH NAME
+ioctl_xfs_exchange_range \- exchange the contents of parts of two files
+.SH SYNOPSIS
+.br
+.B #include <sys/ioctl.h>
+.br
+.B #include <xfs/xfs_fs_staging.h>
+.PP
+.BI "int ioctl(int " file2_fd ", XFS_IOC_EXCHANGE_RANGE, struct xfs_exch_range *" arg );
+.SH DESCRIPTION
+Given a range of bytes in a first file
+.B file1_fd
+and a second range of bytes in a second file
+.BR file2_fd ,
+this
+.BR ioctl (2)
+exchanges the contents of the two ranges.
+.PP
+Exchanges are atomic with regards to concurrent file operations, so no
+userspace-level locks need to be taken to obtain consistent results.
+Implementations must guarantee that readers see either the old contents or the
+new contents in their entirety, even if the system fails.
+.PP
+The exchange parameters are conveyed in a structure of the following form:
+.PP
+.in +4n
+.EX
+struct xfs_exch_range {
+    __s64    file1_fd;
+    __s64    file1_offset;
+    __s64    file2_offset;
+    __s64    length;
+
+    __u64    flags;
+
+    __s64    file2_ino;
+    __s64    file2_mtime;
+    __s64    file2_ctime;
+    __s32    file2_mtime_nsec;
+    __s32    file2_ctime_nsec;
+
+    __u64    pad[6];
+};
+.EE
+.in
+.PP
+The field
+.I pad
+must be zero.
+.PP
+The fields
+.IR file1_fd ", " file1_offset ", and " length
+define the first range of bytes to be exchanged.
+.PP
+The fields
+.IR file2_fd ", " file2_offset ", and " length
+define the second range of bytes to be exchanged.
+.PP
+Both files must be from the same filesystem mount.
+If the two file descriptors represent the same file, the byte ranges must not
+overlap.
+Most disk-based filesystems require that the starts of both ranges must be
+aligned to the file block size.
+If this is the case, the ends of the ranges must also be so aligned unless the
+.B XFS_EXCH_RANGE_TO_EOF
+flag is set.
+
+.PP
+The field
+.I flags
+control the behavior of the exchange operation.
+.RS 0.4i
+.TP
+.B XFS_EXCH_RANGE_FILE2_FRESH
+Check the freshness of
+.I file2_fd
+after locking the file but before exchanging the contents.
+The supplied
+.IR file2_ino " field"
+must match file2's inode number, and the supplied
+.IR file2_mtime ", " file2_mtime_nsec ", " file2_ctime ", and " file2_ctime_nsec
+fields must match the modification time and change time of file2.
+If they do not match,
+.B EBUSY
+will be returned.
+.TP
+.B XFS_EXCH_RANGE_TO_EOF
+Ignore the
+.I length
+parameter.
+All bytes in
+.I file1_fd
+from
+.I file1_offset
+to EOF are moved to
+.IR file2_fd ,
+and file2's size is set to
+.RI ( file2_offset "+(" file1_length - file1_offset )).
+Meanwhile, all bytes in file2 from
+.I file2_offset
+to EOF are moved to file1 and file1's size is set to
+.RI ( file1_offset "+(" file2_length - file2_offset )).
+This option is not compatible with
+.BR XFS_EXCH_RANGE_FULL_FILES .
+.TP
+.B XFS_EXCH_RANGE_FSYNC
+Ensure that all modified in-core data in both file ranges and all metadata
+updates pertaining to the exchange operation are flushed to persistent storage
+before the call returns.
+Opening either file descriptor with
+.BR O_SYNC " or " O_DSYNC
+will have the same effect.
+.TP
+.B XFS_EXCH_RANGE_FILE1_WRITTEN
+Only exchange sub-ranges of
+.I file1_fd
+that are known to contain data written by application software.
+Each sub-range may be expanded (both upwards and downwards) to align with the
+file allocation unit.
+For files on the data device, this is one filesystem block.
+For files on the realtime device, this is the realtime extent size.
+This facility can be used to implement fast atomic scatter-gather writes of any
+complexity for software-defined storage targets if all writes are aligned to
+the file allocation unit.
+.TP
+.B XFS_EXCH_RANGE_DRY_RUN
+Check the parameters and the feasibility of the operation, but do not change
+anything.
+.TP
+.B XFS_EXCH_RANGE_COMMIT
+This flag is a combination of
+.BR XFS_EXCH_RANGE_FILE2_FRESH " | " XFS_EXCH_RANGE_FSYNC
+and can be used to commit changes to
+.I file2_fd
+to persistent storage if and only if file2 has not changed.
+.TP
+.B XFS_EXCH_RANGE_FULL_FILES
+Require that
+.IR file1_offset " and " file2_offset
+are zero, and that the
+.I length
+field matches the lengths of both files.
+If not,
+.B EDOM
+will be returned.
+This option is not compatible with
+.BR XFS_EXCH_RANGE_TO_EOF .
+.TP
+.B XFS_EXCH_RANGE_NONATOMIC
+This flag relaxes the requirement that readers see only the old contents or
+the new contents in their entirety.
+If the system fails before all modified in-core data and metadata updates
+are persisted to disk, the contents of both file ranges after recovery are not
+defined and may be a mix of both.
+
+Do not use this flag unless the contents of both ranges are known to be
+identical and there are no other writers.
+.RE
+.PP
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EBADF
+.IR file1_fd
+is not open for reading and writing or is open for append-only writes; or
+.IR file2_fd
+is not open for reading and writing or is open for append-only writes.
+.TP
+.B EBUSY
+The inode number and timestamps supplied do not match
+.IR file2_fd
+and
+.B XFS_EXCH_RANGE_FILE2_FRESH
+was set in
+.IR flags .
+.TP
+.B EDOM
+The ranges do not cover the entirety of both files, and
+.B XFS_EXCH_RANGE_FULL_FILES
+was set in
+.IR flags .
+.TP
+.B EINVAL
+The parameters are not correct for these files.
+This error can also appear if either file descriptor represents
+a device, FIFO, or socket.
+Disk filesystems generally require the offset and length arguments
+to be aligned to the fundamental block sizes of both files.
+.TP
+.B EIO
+An I/O error occurred.
+.TP
+.B EISDIR
+One of the files is a directory.
+.TP
+.B ENOMEM
+The kernel was unable to allocate sufficient memory to perform the
+operation.
+.TP
+.B ENOSPC
+There is not enough free space in the filesystem exchange the contents safely.
+.TP
+.B EOPNOTSUPP
+The filesystem does not support exchanging bytes between the two
+files.
+.TP
+.B EPERM
+.IR file1_fd " or " file2_fd
+are immutable.
+.TP
+.B ETXTBSY
+One of the files is a swap file.
+.TP
+.B EUCLEAN
+The filesystem is corrupt.
+.TP
+.B EXDEV
+.IR file1_fd " and " file2_fd
+are not on the same mounted filesystem.
+.SH CONFORMING TO
+This API is XFS-specific.
+.SH USE CASES
+.PP
+Three use cases are imagined for this system call.
+.PP
+The first is a filesystem defragmenter, which copies the contents of a file
+into another file and wishes to exchange the space mappings of the two files,
+provided that the original file has not changed.  The flags
+.BR NONATOMIC " and " FILE2_FRESH
+are recommended for this application.
+.PP
+The second is a data storage program that wants to commit non-contiguous updates
+to a file atomically.  This can be done by creating a temporary file, calling
+.BR FICLONE (2)
+to share the contents, and staging the updates into the temporary file.
+Either of the
+.BR FULL_FILES " or " TO_EOF
+flags are recommended, along with
+.BR FSYNC .
+Depending on the application's locking design, the flags
+.BR FILE2_FRESH " or " COMMIT
+may be applicable here.
+The temporary file can be deleted or punched out afterwards.
+.PP
+The third is a software-defined storage host (e.g. a disk jukebox) which
+implements an atomic scatter-gather write command.
+Provided the exported disk's logical block size matches the file's allocation
+unit size, this can be done by creating a temporary file and writing the data
+at the appropriate offsets.
+It is recommended that the temporary file be truncated to the size of the
+regular file before any writes are staged to the temporary file to avoid issues
+with zeroing during EOF extension.
+Use this call with the
+.B FILE1_WRITTEN
+flag to exchange only the file allocation units involved in the emulated
+device's write command.
+The use of the
+.B FSYNC
+flag is recommended here.
+The temporary file should be deleted or punched out completely before being
+reused to stage another write.
+.B
+.SH NOTES
+.PP
+Some filesystems may limit the amount of data or the number of extents that can
+be exchanged in a single call.
+.SH SEE ALSO
+.BR ioctl (2)

