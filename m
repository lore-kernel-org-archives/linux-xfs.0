Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jul 2007 01:50:26 -0700 (PDT)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6E8oJbm015599
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 01:50:21 -0700
Content-Type: text/plain; charset="us-ascii"
Date: Sat, 14 Jul 2007 10:23:42 +0200
From: "Michael Kerrisk" <michael.kerrisk@gmx.net>
In-Reply-To: <20070713124601.GA22961@amitarora.in.ibm.com>
Message-ID: <20070714082342.174830@gmx.net>
MIME-Version: 1.0
References: <20070713123816.GA18000@amitarora.in.ibm.com>
 <20070713124601.GA22961@amitarora.in.ibm.com>
Subject: Re: [PATCH 1/6][TAKE7] manpage for fallocate
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: mtk-manpages@gmx.net, dgc@sgi.com, adilger@clusterfs.com, suparna@in.ibm.com, cmm@us.ibm.com, tytso@mit.edu, xfs@oss.sgi.com

[CC += mtk-manpages@gmx.net]

Amit,

Thanks for this page.  I will endeavour to review it in 
the coming days.  In the meantime, the better address to CC
me on fot man pages stuff is mtk-manpages@gmx.net.

Cheers,

Michael

> Following is the modified version of the manpage originally submitted by
> David Chinner. Please use `nroff -man fallocate.2 | less` to view.
> 
> This includes changes suggested by Heikki Orsila and Barry Naujok.
> 
> 
> .TH fallocate 2
> .SH NAME
> fallocate \- allocate or remove file space
> .SH SYNOPSIS
> .nf
> .B #include <fcntl.h>
> .PP
> .BI "long fallocate(int " fd ", int " mode ", loff_t " offset ", loff_t "
> len);
> .SH DESCRIPTION
> The
> .B fallocate
> syscall allows a user to directly manipulate the allocated disk space
> for the file referred to by
> .I fd
> for the byte range starting at
> .I offset
> and continuing for
> .I len
> bytes.
> The
> .I mode
> parameter determines the operation to be performed on the given range.
> Currently there are two modes:
> .TP
> .B FALLOC_ALLOCATE
> allocates and initialises to zero the disk space within the given range.
> After a successful call, subsequent writes are guaranteed not to fail
> because
> of lack of disk space.  If the size of the file is less than
> .IR offset + len ,
> then the file is increased to this size; otherwise the file size is left
> unchanged.
> .B FALLOC_ALLOCATE
> closely resembles
> .BR posix_fallocate (3)
> and is intended as a method of optimally implementing this function.
> .B FALLOC_ALLOCATE
> may allocate a larger range than that was specified.
> .TP
> .B FALLOC_RESV_SPACE
> provides the same functionality as
> .B FALLOC_ALLOCATE
> except it does not ever change the file size. This allows allocation
> of zero blocks beyond the end of file and is useful for optimising
> append workloads.
> .SH RETURN VALUE
> .B fallocate
> returns zero on success, or an error number on failure.
> Note that
> .I errno
> is not set.
> .SH ERRORS
> .TP
> .B EBADF
> .I fd
> is not a valid file descriptor, or is not opened for writing.
> .TP
> .B EFBIG
> .IR offset + len
> exceeds the maximum file size.
> .TP
> .B EINVAL
> .I offset
> was less than 0, or
> .I len
> was less than or equal to 0.
> .TP
> .B ENODEV
> .I fd
> does not refer to a regular file or a directory.
> .TP
> .B ENOSPC
> There is not enough space left on the device containing the file
> referred to by
> .IR fd .
> .TP
> .B ESPIPE
> .I fd
> refers to a pipe of file descriptor.
> .TP
> .B ENOSYS
> The filesystem underlying the file descriptor does not support this
> operation.
> .TP
> .B EINTR
> A signal was caught during execution
> .TP
> .B EIO
> An I/O error occurred while reading from or writing to a file system.
> .TP
> .B EOPNOTSUPP
> The mode is not supported on the file descriptor.
> .SH AVAILABILITY
> The
> .B fallocate
> system call is available since 2.6.XX
> .SH SEE ALSO
> .BR syscall (2),
> .BR posix_fadvise (3),
> .BR ftruncate (3).

-- 
Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten 
Browser-Versionen downloaden: http://www.gmx.net/de/go/browser
