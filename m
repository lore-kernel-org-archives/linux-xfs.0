Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4091E0DE5
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416780; cv=none; b=E5nFDm0v4nUCgEgDRdDLCqmiKMv5+nC3jAQz3oGJKO2/WGN3aYeSbNDPRkYBsi6saYjbrDTzIIp29pMOZFy6U3bcZ5zkZlbPLbEbrhkGjzSRvxEOyRfdyq66fYM1Tk0TTd62kkLKbUJMiUuo5qcmzsIAfhh+biKi8+hHz4h0Vmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416780; c=relaxed/simple;
	bh=k63De8AZPDHAyZuP/x4thDkXrhacT+g8Wob6PymeRX4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kUyVnA/puQmdpTFmPB8AcvmcEhIQn9pr2j49NuWlPi8g01pcxvN9yp08g2iB5VvF4w5HIWvAxX1SEtdAdeOgui2HYHOKDiMVB3mMB/+5xCNSqdqQ0DxpdArLrUeA1mZ6xWukpySgPdJzGoFWC76kQgZJ5XZvywae7q5U5pqqWEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUh/i1vk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUh/i1vk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3925C4CEC3;
	Thu, 31 Oct 2024 23:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416778;
	bh=k63De8AZPDHAyZuP/x4thDkXrhacT+g8Wob6PymeRX4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IUh/i1vkT+HuD5nP256oC8cbEChSio1ANnh09Pt7KaLzddms/8Up+yln2w3XXvSZ2
	 kOTDMDpQEnqmSyCxAY0MinKALOjKmPmDxREUw9o0zsWwnKkZ2Vfysx8aHXx4Z/aJ4Q
	 Se/jnpYCWusPuX8SORLgPJCGodMDEM8Q2ROzL7xHsmA6jPDCd9IQctcW6ofrlkw7sU
	 2PvBRBO4Sbi3r4CefoETDeH7yjfN06pQfDBzshBnW3jrQ3qnJzJzYyAf4igm0myJ5t
	 j3WIXf6GEuidOFoVOwCe929jDaBFfpmtPweWk7pGrZPYbv7cTHNk3y+PzsZhHyNSPX
	 79K0lGePv20Bw==
Date: Thu, 31 Oct 2024 16:19:38 -0700
Subject: [PATCH 1/7] man: document file range commit ioctls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566921.963918.12171244688114984215.stgit@frogsfrogsfrogs>
In-Reply-To: <173041566899.963918.1566223803606797457.stgit@frogsfrogsfrogs>
References: <173041566899.963918.1566223803606797457.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Document the two new ioctls to support committing arbitrary dirty data
ranges of two files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_commit_range.2 |  296 +++++++++++++++++++++++++++++++++++++
 man/man2/ioctl_xfs_fsgeometry.2   |    2 
 man/man2/ioctl_xfs_start_commit.2 |    1 
 3 files changed, 298 insertions(+), 1 deletion(-)
 create mode 100644 man/man2/ioctl_xfs_commit_range.2
 create mode 100644 man/man2/ioctl_xfs_start_commit.2


diff --git a/man/man2/ioctl_xfs_commit_range.2 b/man/man2/ioctl_xfs_commit_range.2
new file mode 100644
index 00000000000000..3244e52c3e0946
--- /dev/null
+++ b/man/man2/ioctl_xfs_commit_range.2
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
+.TH IOCTL-XFS-COMMIT-RANGE 2  2024-02-18 "XFS"
+.SH NAME
+ioctl_xfs_start_commit \- prepare to exchange the contents of two files
+ioctl_xfs_commit_range \- conditionally exchange the contents of parts of two files
+.SH SYNOPSIS
+.br
+.B #include <sys/ioctl.h>
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " file2_fd ", XFS_IOC_START_COMMIT, struct xfs_commit_range *" arg );
+.PP
+.BI "int ioctl(int " file2_fd ", XFS_IOC_COMMIT_RANGE, struct xfs_commit_range *" arg );
+.SH DESCRIPTION
+Given a range of bytes in a first file
+.B file1_fd
+and a second range of bytes in a second file
+.BR file2_fd ,
+this
+.BR ioctl (2)
+exchanges the contents of the two ranges if
+.B file2_fd
+passes certain freshness criteria.
+
+Before exchanging the contents, the program must call the
+.B XFS_IOC_START_COMMIT
+ioctl to sample freshness data for
+.BR file2_fd .
+If the sampled metadata does not match the file metadata at commit time,
+.B XFS_IOC_COMMIT_RANGE
+will return
+.BR EBUSY .
+.PP
+Exchanges are atomic with regards to concurrent file operations.
+Implementations must guarantee that readers see either the old contents or the
+new contents in their entirety, even if the system fails.
+.PP
+The system call parameters are conveyed in structures of the following form:
+.PP
+.in +4n
+.EX
+struct xfs_commit_range {
+    __s32    file1_fd;
+    __u32    pad;
+    __u64    file1_offset;
+    __u64    file2_offset;
+    __u64    length;
+    __u64    flags;
+    __u64    file2_freshness[5];
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
+The field
+.I file2_freshness
+is an opaque field whose contents are determined by the kernel.
+These file attributes are used to confirm that
+.B file2_fd
+has not changed by another thread since the current thread began staging its
+own update.
+.PP
+Both files must be from the same filesystem mount.
+If the two file descriptors represent the same file, the byte ranges must not
+overlap.
+Most disk-based filesystems require that the starts of both ranges must be
+aligned to the file block size.
+If this is the case, the ends of the ranges must also be so aligned unless the
+.B XFS_EXCHANGE_RANGE_TO_EOF
+flag is set.
+
+.PP
+The field
+.I flags
+control the behavior of the exchange operation.
+.RS 0.4i
+.TP
+.B XFS_EXCHANGE_RANGE_TO_EOF
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
+.TP
+.B XFS_EXCHANGE_RANGE_DSYNC
+Ensure that all modified in-core data in both file ranges and all metadata
+updates pertaining to the exchange operation are flushed to persistent storage
+before the call returns.
+Opening either file descriptor with
+.BR O_SYNC " or " O_DSYNC
+will have the same effect.
+.TP
+.B XFS_EXCHANGE_RANGE_FILE1_WRITTEN
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
+.B XFS_EXCHANGE_RANGE_DRY_RUN
+Check the parameters and the feasibility of the operation, but do not change
+anything.
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
+The file2 inode number and timestamps supplied do not match
+.IR file2_fd .
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
+Several use cases are imagined for this system call.
+Coordination between multiple threads is performed by the kernel.
+.PP
+The first is a filesystem defragmenter, which copies the contents of a file
+into another file and wishes to exchange the space mappings of the two files,
+provided that the original file has not changed.
+.PP
+An example program might look like this:
+.PP
+.in +4n
+.EX
+int fd = open("/some/file", O_RDWR);
+int temp_fd = open("/some", O_TMPFILE | O_RDWR);
+struct stat sb;
+struct xfs_commit_range args = {
+    .flags = XFS_EXCHANGE_RANGE_TO_EOF,
+};
+
+/* gather file2's freshness information */
+ioctl(fd, XFS_IOC_START_COMMIT, &args);
+fstat(fd, &sb);
+
+/* make a fresh copy of the file with terrible alignment to avoid reflink */
+clone_file_range(fd, NULL, temp_fd, NULL, 1, 0);
+clone_file_range(fd, NULL, temp_fd, NULL, sb.st_size - 1, 0);
+
+/* commit the entire update */
+args.file1_fd = temp_fd;
+ret = ioctl(fd, XFS_IOC_COMMIT_RANGE, &args);
+if (ret && errno == EBUSY)
+    printf("file changed while defrag was underway\\n");
+.EE
+.in
+.PP
+The second is a data storage program that wants to commit non-contiguous updates
+to a file atomically.
+This program cannot coordinate updates to the file and therefore relies on the
+kernel to reject the COMMIT_RANGE command if the file has been updated by
+someone else.
+This can be done by creating a temporary file, calling
+.BR FICLONE (2)
+to share the contents, and staging the updates into the temporary file.
+The
+.B FULL_FILES
+flag is recommended for this purpose.
+The temporary file can be deleted or punched out afterwards.
+.PP
+An example program might look like this:
+.PP
+.in +4n
+.EX
+int fd = open("/some/file", O_RDWR);
+int temp_fd = open("/some", O_TMPFILE | O_RDWR);
+struct xfs_commit_range args = {
+    .flags = XFS_EXCHANGE_RANGE_TO_EOF,
+};
+
+/* gather file2's freshness information */
+ioctl(fd, XFS_IOC_START_COMMIT, &args);
+
+ioctl(temp_fd, FICLONE, fd);
+
+/* append 1MB of records */
+lseek(temp_fd, 0, SEEK_END);
+write(temp_fd, data1, 1000000);
+
+/* update record index */
+pwrite(temp_fd, data1, 600, 98765);
+pwrite(temp_fd, data2, 320, 54321);
+pwrite(temp_fd, data2, 15, 0);
+
+/* commit the entire update */
+args.file1_fd = temp_fd;
+ret = ioctl(fd, XFS_IOC_COMMIT_RANGE, &args);
+if (ret && errno == EBUSY)
+    printf("file changed before commit; will roll back\\n");
+.EE
+.in
+.B
+.SH NOTES
+.PP
+Some filesystems may limit the amount of data or the number of extents that can
+be exchanged in a single call.
+.SH SEE ALSO
+.BR ioctl (2)
diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index 54fd89390883c1..db7698fa922b87 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -212,7 +212,7 @@ .SH FILESYSTEM FEATURE FLAGS
 .B XFS_FSOP_GEOM_FLAGS_REFLINK
 Filesystem supports sharing blocks between files.
 .TP
-.B XFS_FSOP_GEOM_FLAGS_EXCHRANGE
+.B XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE
 Filesystem can exchange file contents atomically via XFS_IOC_EXCHANGE_RANGE.
 .RE
 .SH XFS METADATA HEALTH REPORTING
diff --git a/man/man2/ioctl_xfs_start_commit.2 b/man/man2/ioctl_xfs_start_commit.2
new file mode 100644
index 00000000000000..f11410120f698d
--- /dev/null
+++ b/man/man2/ioctl_xfs_start_commit.2
@@ -0,0 +1 @@
+.so man2/ioctl_xfs_commit_range.2

