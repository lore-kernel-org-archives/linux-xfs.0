Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jul 2007 11:46:17 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6DIkAbm003146
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 11:46:13 -0700
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6DIkCMF002809
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 14:46:12 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6DIkC9I216530
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 12:46:12 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6DIkBwd004382
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 12:46:12 -0600
Date: Sat, 14 Jul 2007 00:16:25 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 1/5][TAKE8] manpage for fallocate
Message-ID: <20070713184625.GB12156@amitarora.in.ibm.com>
References: <20070713184125.GA12156@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713184125.GA12156@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: xfs@oss.sgi.com, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com, michael.kerrisk@gmx.net

Following is the modified version of the manpage originally submitted by
David Chinner. Please use `nroff -man fallocate.2 | less` to view.

Following changed from TAKE7:
* Removed FALLOC_ALLOCATE and FALLOCATE_RESV_SPACE modes.
* Described only single flag for mode, i.e. FALLOC_FL_KEEP_SIZE.
* s/zero blocks/zeroed blocks/ as suggested by Dave.
* Included <linux/falloc.h> instead of <fcntl.h>.

Following changed from TAKE6 to TAKE7:
Included changes suggested by Heikki Orsila and Barry Naujok.


.TH fallocate 2
.SH NAME
fallocate \- manipulate file space
.SH SYNOPSIS
.nf
.B #include <linux/falloc.h>
.PP
.BI "long fallocate(int " fd ", int " mode ", loff_t " offset ", loff_t " len ");
.SH DESCRIPTION
The
.B fallocate
syscall allows a user to directly manipulate the allocated disk space
for the file referred to by
.I fd
for the byte range starting at
.I offset
and continuing for
.I len
bytes.
The
.I mode
parameter determines the operation to be performed on the given range.
Currently there is only one flag supported for the mode argument.
.TP
.B FALLOC_FL_KEEP_SIZE
allocates and initialises to zero the disk space within the given range.
After a successful call, subsequent writes are guaranteed not to fail because
of lack of disk space.  Even if the size of the file is less than
.IR offset + len ,
the file size is not changed. This allows allocation of zeroed blocks beyond
the end of file and is useful for optimising append workloads.
.PP
If
.B FALLOC_FL_KEEP_SIZE
flag is not specified in the mode argument, the default behavior of this system
call is almost same as when this flag is passed. The only difference is that
on success, the file size will be changed if the
.IR offset + len
is greater than the file size. This default behavior closely resembles
.BR posix_fallocate (3)
and is intended as a method of optimally implementing this function.
.PP
.B fallocate
may allocate a larger range than that was specified.
.SH RETURN VALUE
.B fallocate
returns zero on success, or an error number on failure.
Note that
.I errno
is not set.
.SH ERRORS
.TP
.B EBADF
.I fd
is not a valid file descriptor, or is not opened for writing.
.TP
.B EFBIG
.IR offset + len
exceeds the maximum file size.
.TP
.B EINVAL
.I offset
was less than 0, or
.I len
was less than or equal to 0.
.TP
.B ENODEV
.I fd
does not refer to a regular file or a directory.
.TP
.B ENOSPC
There is not enough space left on the device containing the file
referred to by
.IR fd .
.TP
.B ESPIPE
.I fd
refers to a pipe of file descriptor.
.TP
.B ENOSYS
The filesystem underlying the file descriptor does not support this
operation.
.TP
.B EINTR
A signal was caught during execution
.TP
.B EIO
An I/O error occurred while reading from or writing to a file system.
.TP
.B EOPNOTSUPP
The mode is not supported on the file descriptor.
.SH AVAILABILITY
The
.B fallocate
system call is available since 2.6.XX
.SH SEE ALSO
.BR posix_fallocate (3),
.BR posix_fadvise (3),
.BR ftruncate (3).
