Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FE94C96
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300842; cv=none; b=rwObBWOOmuMFeJBGbmtQWgbU15o9NBRRWh+LuyVYAZBHEJM/Lu2idpQtSMsRpQN3Rzn9dXRu+NcDhVIVyhPbFKHT2K3oAQZfLxmMEz0L6Mh8wR07vWR9EDSgiRXjlbp4Q6U0AqPTSsJLffVBsmduFy02OPeBA8St7peaWb6vQn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300842; c=relaxed/simple;
	bh=I99bfiMLejt5Hi6gGN3eO/DX/MGIcHk7Wj5IGm/4uaI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rzk0WDmHqkM8aAWW34neQ8XGta9lS7q7g0epfPyN55A5GdTidygrPK7iN0XolATTBKBJ+AiNQNC4iZL5Gfeap7ji5wEydp2viXHL4K2APKSnhJNm3qgcerRD9WQJZkZKT/jz0X8Lq+jJqxBzdGTAJ4bI1ODyMxXXHMrNZjxMuRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Az1g8j54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Az1g8j54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927D1C32786;
	Tue, 30 Jul 2024 00:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300842;
	bh=I99bfiMLejt5Hi6gGN3eO/DX/MGIcHk7Wj5IGm/4uaI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Az1g8j54DgTO2sYiibkhbjc0l7Y61hBpkUtW6twV9se1MOZnEoksm+wLZUE8r9xwP
	 p+/8J8zzPfaM+3KaIJLN6OzlBSkT7ItiaAiXUK7wlr7dnvNbUi5kUSJC0OqKqb6C5y
	 rJG6SBDVFG79TwsjIb/eNIO8L27vGYycmccPXpCUSN3YkO54MN4Y4EarWKKzIk+jUm
	 L/IZim5Z4mpP5r9+yIxX3YQi8VxSsASI/RhOZcPVJ0YPWmUvyEyTqfwwa1NR64+mFg
	 dbMV1Tlk+Awis1BzwJlvNu08O7watOcNEjO/OvkyFYtLMPnnjEBFzDVk6kRHj1zJ7t
	 ScGOYKUf1RK1g==
Date: Mon, 29 Jul 2024 17:54:02 -0700
Subject: [PATCH 01/12] man: document the exchange-range ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229844420.1344699.8776197084743871916.stgit@frogsfrogsfrogs>
In-Reply-To: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
References: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_exchange_range.2 |  278 +++++++++++++++++++++++++++++++++++
 1 file changed, 278 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_exchange_range.2


diff --git a/man/man2/ioctl_xfs_exchange_range.2 b/man/man2/ioctl_xfs_exchange_range.2
new file mode 100644
index 000000000..450db9c25
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

