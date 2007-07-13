Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jul 2007 05:45:51 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6DCjibm028705
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 05:45:45 -0700
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6DCjkfe016192
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 08:45:46 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6DCjkwA482794
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 08:45:46 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6DCjj6l024231
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 08:45:46 -0400
Date: Fri, 13 Jul 2007 18:16:01 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 1/6][TAKE7] manpage for fallocate
Message-ID: <20070713124601.GA22961@amitarora.in.ibm.com>
References: <20070713123816.GA18000@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713123816.GA18000@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: xfs@oss.sgi.com, michael.kerrisk@gmx.net, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com

Following is the modified version of the manpage originally submitted by
David Chinner. Please use `nroff -man fallocate.2 | less` to view.

This includes changes suggested by Heikki Orsila and Barry Naujok.


.TH fallocate 2
.SH NAME
fallocate \- allocate or remove file space
.SH SYNOPSIS
.nf
.B #include <fcntl.h>
.PP
.BI "long fallocate(int " fd ", int " mode ", loff_t " offset ", loff_t " len);
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
Currently there are two modes:
.TP
.B FALLOC_ALLOCATE
allocates and initialises to zero the disk space within the given range.
After a successful call, subsequent writes are guaranteed not to fail because
of lack of disk space.  If the size of the file is less than
.IR offset + len ,
then the file is increased to this size; otherwise the file size is left
unchanged.
.B FALLOC_ALLOCATE
closely resembles
.BR posix_fallocate (3)
and is intended as a method of optimally implementing this function.
.B FALLOC_ALLOCATE
may allocate a larger range than that was specified.
.TP
.B FALLOC_RESV_SPACE
provides the same functionality as
.B FALLOC_ALLOCATE
except it does not ever change the file size. This allows allocation
of zero blocks beyond the end of file and is useful for optimising
append workloads.
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
.BR syscall (2),
.BR posix_fadvise (3),
.BR ftruncate (3).
