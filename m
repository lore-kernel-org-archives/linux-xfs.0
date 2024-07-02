Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A5CD50F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881625; cv=none; b=JXL3xCGy+jX2wXea16wxB4icekF/GqG3JQMuhPQYVjl+WhBM7/QRMZWzrBvAkxRVFYBFLLD6/nGKriFFGw4Ye+v0QDUluBqJUGrDgaynV9GB/DySU3FN7RvCOS/XQeX1DS36R38K0SLDivo1lDqV3fuFWKgqakQYHHAZT5tBIA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881625; c=relaxed/simple;
	bh=8/gMQPTBN/sabomYY3UypayLB+aYsg98BOFKGMqYlNs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WiG3Ep0InAIWkPJNVIP6ez2SWycBpEtuHrezK6v9IB3NfClDs+eF55WsNbNtGGbad9iCsNzLEgrnygIcwqP6O0S3L1iK98LvW/bBYwqkvm7tgde+gZ3U5l7O9C2MlJmcp0Smao/gA1kYGO0RKbTQa7aH+eBCIKfMeOI3Z5b+HNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FzFr4OAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FzFr4OAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39165C116B1;
	Tue,  2 Jul 2024 00:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881625;
	bh=8/gMQPTBN/sabomYY3UypayLB+aYsg98BOFKGMqYlNs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FzFr4OAl3V8Y0MW2NuOXcmBOkhY1cmcRdb+32oO8m4HZS53ac9gcd4Vf0NYEFrNjF
	 X9Put1ZMRM1hR4qfPZpLlvd498sYbXwJgZsz0WJG74p2iIAhhmWpvzvab2371QZruO
	 avg998WDAyrnvR5gAXj9OllTcSjCiXbEvLPNJlh0eZPy6wDFXBHGFSjqhoWoRnq1W0
	 PcSQ1pRYmxCTOoJT9o+2TUFrH1jIBfPiqlJqn0pORXbCYXEV64M6/LLPBZyjWlkm2W
	 pJPqdsnwwj6jV9pdpJTUOpUGZJJCFJ7UEZ/EYzxnc3LoDJqWeoj89mRKR9hv7z+XeY
	 QYPv4rJCb5NLQ==
Date: Mon, 01 Jul 2024 17:53:44 -0700
Subject: [PATCH 01/12] man: document the exchange-range ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988116726.2006519.12422589085600264393.stgit@frogsfrogsfrogs>
In-Reply-To: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
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

Document the new file data exchange ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man2/ioctl_xfs_exchange_range.2 |  278 +++++++++++++++++++++++++++++++++++
 1 file changed, 278 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_exchange_range.2


diff --git a/man/man2/ioctl_xfs_exchange_range.2 b/man/man2/ioctl_xfs_exchange_range.2
new file mode 100644
index 000000000000..450db9c25c12
--- /dev/null
+++ b/man/man2/ioctl_xfs_exchange_range.2
@@ -0,0 +1,278 @@
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
+.TH IOCTL-XFS-EXCHANGE-RANGE 2  2024-02-10 "XFS"
+.SH NAME
+ioctl_xfs_exchange_range \- exchange the contents of parts of two files
+.SH SYNOPSIS
+.br
+.B #include <sys/ioctl.h>
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " file2_fd ", XFS_IOC_EXCHANGE_RANGE, struct xfs_exchange_range *" arg );
+.SH DESCRIPTION
+Given a range of bytes in a first file
+.B file1_fd
+and a second range of bytes in a second file
+.BR file2_fd ,
+this
+.BR ioctl (2)
+exchanges the contents of the two ranges.
+.PP
+Exchanges are atomic with regards to concurrent file operations.
+Implementations must guarantee that readers see either the old contents or the
+new contents in their entirety, even if the system fails.
+.PP
+The system call parameters are conveyed in structures of the following form:
+.PP
+.in +4n
+.EX
+struct xfs_exchange_range {
+    __s32    file1_fd;
+    __u32    pad;
+    __u64    file1_offset;
+    __u64    file2_offset;
+    __u64    length;
+    __u64    flags;
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
+In all cases, application software must coordinate updates to the file
+because the exchange is performed unconditionally.
+.PP
+The first is a data storage program that wants to commit non-contiguous updates
+to a file atomically and coordinates write access to that file.
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
+struct xfs_exchange_range args = {
+    .file1_fd = temp_fd,
+    .flags = XFS_EXCHANGE_RANGE_TO_EOF,
+};
+
+ioctl(fd, XFS_IOC_EXCHANGE_RANGE, &args);
+.EE
+.in
+.PP
+The second is a software-defined storage host (e.g. a disk jukebox) which
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
+The temporary file should be truncated or punched out completely before being
+reused to stage another write.
+.PP
+An example program might look like this:
+.PP
+.in +4n
+.EX
+int fd = open("/some/file", O_RDWR);
+int temp_fd = open("/some", O_TMPFILE | O_RDWR);
+struct stat sb;
+int blksz;
+
+fstat(fd, &sb);
+blksz = sb.st_blksize;
+
+/* land scatter gather writes between 100fsb and 500fsb */
+pwrite(temp_fd, data1, blksz * 2, blksz * 100);
+pwrite(temp_fd, data2, blksz * 20, blksz * 480);
+pwrite(temp_fd, data3, blksz * 7, blksz * 257);
+
+/* commit the entire update */
+struct xfs_exchange_range args = {
+    .file1_fd = temp_fd,
+    .file1_offset = blksz * 100,
+    .file2_offset = blksz * 100,
+    .length       = blksz * 400,
+    .flags        = XFS_EXCHANGE_RANGE_FILE1_WRITTEN |
+                    XFS_EXCHANGE_RANGE_FILE1_DSYNC,
+};
+
+ioctl(fd, XFS_IOC_EXCHANGE_RANGE, &args);
+.EE
+.in
+.B
+.SH NOTES
+.PP
+Some filesystems may limit the amount of data or the number of extents that can
+be exchanged in a single call.
+.SH SEE ALSO
+.BR ioctl (2)

