Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Jun 2007 16:52:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5DNqkWt012915
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2007 16:52:49 -0700
Date: Thu, 14 Jun 2007 09:52:17 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070613235217.GS86004887@sgi.com>
References: <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070509160102.GA30745@amitarora.in.ibm.com> <20070510005926.GT85884050@sgi.com> <20070510115620.GB21400@amitarora.in.ibm.com> <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <20070612061652.GA6320@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: David Chinner <dgc@sgi.com>, Suparna Bhattacharya <suparna@in.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com

--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 12, 2007 at 11:46:52AM +0530, Amit K. Arora wrote:
> Did you get time to write the above man page ? It will help to push
> further patches in time (eg. for FA_PREALLOCATE mode).

First pass is attached.

`nroff -man fallocate.2 | less` to view.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="fallocate.2"

.TH fallocate 2
.SH NAME
fallocate \- allocate or remove file space
.SH SYNOPSIS
.nf
.B #include <sys/syscall.h>
.PP
.BI "int syscall(int, int fd, int mode, loff_t offset, loff_t len);
.Op
.SH DESCRIPTION
The
.BR fallocate
syscall allows a user to directly manipulate the allocated disk space
for the file referred to by
.I fd
for the byte range starting at
.IR offset
and continuing for
.IR len
bytes.
The
.I mode
parameter determines the operation to be performed on the given range.
Currently there are three modes:
.TP
.B FA_ALLOCATE
allocates and initialises to zero the disk space within the given range.
After a successful call, subsequent writes are guaranteed not to fail because
of lack of disk space.  If the size of the file is less than
IR offset + len ,
then the file is increased to this size; otherwise the file size is left
unchanged.
B FA_ALLOCATE
closely resembles
B posix_fallocate(3)
and is intended as a method of optimally implementing this function.
B FA_ALLOCATE
may allocate a larger range that was specified.
TP
B FA_PREALLOCATE
provides the same functionality as
B FA_ALLOCATE
except it does not ever change the file size. This allows allocation
of zero blocks beyond the end of file and is useful for optimising
append workloads.
TP
B FA_DEALLOCATE
removes the underlying disk space with the given range. The disk space
shall be removed regardless of it's contents so both allocated space
from
B FA_ALLOCATE
and
B FA_PREALLOCATE
as well as from
B write(3)
will be removed.
B FA_DEALLOCATE
shall never remove disk blocks outside the range specified.
B FA_DEALLOCATE
shall never change the file size. If changing the file size
is required when deallocating blocks from an offset to end
of file (or beyond end of file) is required,
B ftuncate64(3)
should be used.

SH "RETURN VALUE"
BR fallocate()
returns zero on success, or an error number on failure.
Note that
IR errno
is not set.
SH "ERRORS"
TP
B EBADF
I fd
is not a valid file descriptor, or is not opened for writing.
TP
B EFBIG
I offset+len
exceeds the maximum file size.
TP
B EINVAL
I offset
or
I len
was less than 0.
TP
B ENODEV
I fd
does not refer to a regular file or a directory.
TP
B ENOSPC
There is not enough space left on the device containing the file
referred to by
IR fd.
TP
B ESPIPE
I fd
refers to a pipe of file descriptor.
B ENOSYS
The filesystem underlying the file descriptor does not support this
operation.
SH AVAILABILITY
The
BR fallocate ()
system call is available since 2.6.XX
SH "SEE ALSO"
BR syscall (2),
BR posix_fadvise (3)
BR ftruncate (3)

--wzJLGUyc3ArbnUjN--
