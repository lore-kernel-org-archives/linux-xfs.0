Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78365363C72;
	Wed,  9 Sep 2026 08:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788942581; cv=none; b=icvhq9A56MNuOgxRgEJOamBuudESWFDB3kDOj/I50r5aN8e3xfAVYt86ExmpDJXzJ4BrRSyi3nutxuf5F5lmAiE2jk+XtCZEuIUpmkEANBXiP8Ba64O1xTwzBefLmzw7q0/ik/PuS7yEsDjAJAe4Mw9BvAjdNfBdnuSbR6jjZc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788942581; c=relaxed/simple;
	bh=E3YrmJCeru5U6XrxG/JKK5KzNB2SnpkfSVwvJn8zyMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KuUE8ku3o9yI1eNXjZNefVVvzOCmiN8TwWTJUwlal+2G3vqzEY+H+LxMuhfw852WJHgxYjYFatooQpSyc+HRSCqDPcLQoCh8mIOoYtnqBCqnDaMEDzgpa68QCXn79q6Eyj8uNKs66VFupv0S00gIIYFHxA8vB9j5Wc2GTpapUlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSB1Q2ON; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSB1Q2ON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2431F00A3A;
	Wed,  9 Sep 2026 08:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788942579;
	bh=s56Xxn7cL6FQBeo1UZHjDa5DnfcUUpONIg5cXU8bG04=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TSB1Q2ONG2MvBSpCXT2+YbjHQtIyxGDoiiaf/8qC+WiXvltQgQYmVOZFrvfXkaoJ4
	 lktxOgbxEIUw1aFWLqnZ6+nSPU30YyLlCsw7JYNpqIV6qPVUr1DBJ6tP3KiXq89uMh
	 hhQNgz5QX+wKm1esKX/PZ0RklGV5HolXs5DXRda9UEo8+7SN81jjxW74TBNpm9mEXP
	 nNIpbjCrRGLrkD6qQHvAuS9Ac109YSd9obc4b2aZ0UC216T/8rrFbt3FFfeW1Gxl0w
	 D34aqiqpSIrO3sW0hJkSnVr1PzeX9NehvQ4CdOvInFNa/ivl0fvfTINJyadw/pZ2Ep
	 lp8SVjMXi0G7g==
Date: Wed, 9 Sep 2026 10:29:34 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Alejandro Colomar <alx@kernel.org>, linux-man@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] man/man2: introduce man page for
 file_getattr/file_setattr syscalls
Message-ID: <aqEWjV-NCUuPJlwr@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260907131747.1389798-1-aalbersh@kernel.org>
 <20260908144051.GJ6047@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908144051.GJ6047@frogsfrogsfrogs>

On 2026-09-08 07:40:51, Darrick J. Wong wrote:
> On Mon, Sep 07, 2026 at 03:17:43PM +0200, Andrey Albershteyn wrote:
> > Add manual pages for file_getattr() and file_setattr() syscalls and
> > struct file_attr used as input/output argument.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > Link: https://lore.kernel.org/all/20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org/
> > ---
> >  man/man2/file_getattr.2      | 286 +++++++++++++++++++++++++++++
> >  man/man2/file_setattr.2      | 340 +++++++++++++++++++++++++++++++++++
> >  man/man2type/file_attr.2type | 187 +++++++++++++++++++
> >  3 files changed, 813 insertions(+)
> >  create mode 100644 man/man2/file_getattr.2
> >  create mode 100644 man/man2/file_setattr.2
> >  create mode 100644 man/man2type/file_attr.2type
> > 
> > diff --git a/man/man2/file_getattr.2 b/man/man2/file_getattr.2
> > new file mode 100644
> > index 000000000000..f1aec2ad8c42
> > --- /dev/null
> > +++ b/man/man2/file_getattr.2
> > @@ -0,0 +1,286 @@
> > +.\" Copyright, the authors of the Linux man-pages project
> > +.\"
> > +.\" SPDX-License-Identifier: Linux-man-pages-copyleft
> > +.\"
> > +.TH file_getattr 2 (date) "Linux man-pages (unreleased)"
> > +.SH NAME
> > +file_getattr \- get filesystem inode attributes
> > +.SH SYNOPSIS
> > +.nf
> > +.BR "#include <linux/fcntl.h>" "      /* " AT_* " constants */"
> > +.BR "#include <linux/fs.h>" "         /* struct " file_attr " and " FS_XFLAG_* " constants */"
> > +.BR "#include <sys/syscall.h>" "      /* " SYS_* " constants */"
> > +.B #include <unistd.h>
> > +.P
> > +.B long syscall(SYS_file_getattr,
> > +.BI "               int " dirfd ", const char *" pathname ,
> > +.BI "               struct file_attr *" fattr ", size_t " size ,
> > +.BI "               unsigned int " flags );
> > +.fi
> > +.P
> > +.IR Note :
> > +glibc provides no wrapper for
> > +.BR file_getattr (),
> > +use
> > +.BR syscall (2)
> > +instead.
> > +.SH DESCRIPTION
> > +The
> > +.BR file_getattr ()
> > +system call retrieves filesystem file attributes
> > +from the file specified by
> > +.IR pathname .
> > +.P
> > +This system call provides functionality similar to the
> > +.B FS_IOC_FSGETXATTR
> > +.BR ioctl (2)
> > +operation,
> > +but with the advantage that the file does not need to be opened.
> > +By using a pathname,
> > +.BR file_getattr ()
> > +can retrieve filesystem file attributes
> > +from all file types,
> > +including special files such as FIFOs, sockets, block devices, character
> > +devices, and symlinks, where opening targeted inode may not be possible.
> 
> opening the targeted inode...
> 
> > +.P
> > +As with
> > +.BR openat (2),
> > +if
> > +.I pathname
> > +is relative,
> > +then it is interpreted relative to the directory
> > +referred to by the file descriptor
> > +.IR dirfd .
> > +The special value
> > +.B AT_FDCWD
> > +could be used to refer to the current working directory of the calling process.
> > +If
> > +.I pathname
> > +is absolute,
> > +then
> > +.I dirfd
> > +is ignored.
> > +.P
> > +The
> > +.I fattr
> > +argument is a pointer to a
> > +.I file_attr
> > +structure.
> > +This structure will be filled with file attributes.
> > +This structure is described in
> > +.BR file_attr(2type) .
> > +.P
> > +The
> > +.I size
> > +argument specifies the size of the buffer pointed to by
> > +.IR fattr .
> > +The size indicates version of the structure in use, refer to
> > +.B file_attr(2type)
> > +for more information on versioning.
> > +.P
> > +Userspace applications should zero-initialize
> > +.I struct file_attr
> > +before calling
> > +.BR file_getattr ()
> > +to ensure that fields not filled in by older kernels
> > +will have predictable values.
> > +.P
> > +The
> > +.I flags
> > +argument is a bit mask, available flags are:
> > +.TP
> > +.B AT_EMPTY_PATH
> > +If
> > +.I pathname
> > +is an empty string,
> > +operate on the file referred to by
> > +.IR dirfd .
> > +In this case,
> > +.I dirfd
> > +can refer to any type of file,
> > +not just a directory.
> > +If
> > +.I dirfd
> > +is
> > +.BR AT_FDCWD ,
> > +the call fails with the error
> > +.BR EBADF .
> > +.TP
> > +.B AT_SYMLINK_NOFOLLOW
> > +If
> > +.I pathname
> > +is a symbolic link,
> > +do not dereference it;
> > +instead get attributes of the symbolic link inode itself.
> > +By default, symbolic links are dereferenced.
> > +.SH RETURN VALUE
> > +On success,
> > +zero is returned.
> > +On error,
> > +\-1 is returned,
> > +and
> > +.I errno
> > +is set to indicate the error.
> > +.SH ERRORS
> > +.TP
> > +.B E2BIG
> > +.I size
> > +is too big (larger than
> > +.BR PAGE_SIZE ).
> > +.TP
> > +.B EACCES
> > +Search permission is denied for one of the directories
> > +in the path prefix of
> > +.IR pathname .
> > +.TP
> > +.B EBADF
> > +.I pathname
> > +is relative but
> > +.I dirfd
> > +is neither
> > +.B AT_FDCWD
> > +nor a valid file descriptor.
> > +.TP
> > +.B EBADF
> > +.I pathname
> > +is an empty string,
> > +.B AT_EMPTY_PATH
> > +was specified,
> > +but
> > +.I dirfd
> > +is an invalid file descriptor.
> > +.TP
> > +.B EFAULT
> > +.I pathname
> > +or
> > +.I fattr
> > +is an invalid pointer.
> > +.TP
> > +.B EINVAL
> > +Invalid flag specified in
> > +.IR flags .
> > +.TP
> > +.B EINVAL
> > +.I size
> > +is smaller than
> > +.BR FILE_ATTR_SIZE_VER0 .
> > +.TP
> > +.B ELOOP
> > +Too many symbolic links encountered while resolving
> > +.IR pathname .
> > +.TP
> > +.B ENAMETOOLONG
> > +.I pathname
> > +is too long.
> > +.TP
> > +.B ENOENT
> > +A component of
> > +.I pathname
> > +does not exist,
> > +or
> > +.I pathname
> > +is an empty string and
> > +.B AT_EMPTY_PATH
> > +was not specified in
> > +.IR flags .
> > +.TP
> > +.B ENOMEM
> > +Insufficient kernel memory was available.
> > +.TP
> > +.B ENOTDIR
> > +A component of the path prefix of
> > +.I pathname
> > +is not a directory or,
> > +.I pathname
> > +is relative and
> > +.I dirfd
> > +is a file descriptor referring to a file other than a directory.
> > +.TP
> > +.B EOPNOTSUPP
> > +The filesystem does not support getting attributes on this type of inode.
> > +.SH HISTORY
> > +.SS Linux 6.17
> > +This system call is introduced as a more flexible alternative to the
> > +FS_IOC_FSGETXATTR
> > +.BR ioctl (2)
> > +which could work on any type of files.
> 
> "...any type of file."
> 
> > +.SH NOTES
> > +This system call is designed to be extensible.
> > +The
> > +.I size
> > +argument allows userspace applications to indicate
> > +which version of the
> > +.I file_attr
> > +structure they are using,
> > +enabling the kernel to support both old and new versions
> > +of the structure simultaneously.
> > +.P
> > +If
> > +.I size
> > +is smaller than the structure size the kernel expects,
> > +only the fields that fit within
> > +.I size
> > +will be filled in.
> > +If
> > +.I size
> > +is larger than the kernel's structure size,
> > +the extra bytes are zeroed.
> 
> The extra bytes at the end are zeroed?  Then why does userspace need to
> zero fattr before passing it in?

Zeroing is not required for "file_getattr"

> 
> (I mean, it's good practice, if nothing else to shut up valgrind not
> being able to notice that an ioctl initializes what otherwise looks like
> an uninitialized stack object.)
> 
> > +.SH EXAMPLES
> > +The program below demonstrates the use of
> > +.BR file_getattr ()
> > +to retrieve and display file attributes.
> > +.P
> > +.in +4n
> > +.EX
> > +#include <fcntl.h>
> > +#include <linux/fs.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <sys/syscall.h>
> > +#include <unistd.h>
> > +
> > +#ifndef SYS_file_getattr
> > +#define SYS_file_getattr 467
> > +#endif
> > +
> > +int
> > +main(int argc, char *argv[])
> > +{
> > +    struct file_attr fa = { 0 };
> > +    int dfd;
> > +    long ret;
> > +
> > +    if (argc != 2) {
> > +        fprintf(stderr, "Usage: %s <filename>\\n", argv[0]);
> > +        exit(EXIT_FAILURE);
> > +    }
> > +
> > +    ret = syscall(SYS_file_getattr, AT_FDCWD, argv[1], &fa, sizeof(fa), 0);
> > +    if (ret == \-1) {
> > +        perror("file_getattr");
> > +        exit(EXIT_FAILURE);
> > +    }
> > +
> > +    printf("File attributes:\\n");
> > +    printf("  xflags:     0x%llx\\n", (unsigned long long)fa.fa_xflags);
> > +    printf("  extsize:    %u\\n", fa.fa_extsize);
> > +    printf("  nextents:   %u\\n", fa.fa_nextents);
> > +    printf("  projid:     %u\\n", fa.fa_projid);
> > +    printf("  cowextsize: %u\\n", fa.fa_cowextsize);
> > +
> > +    /*
> > +     * Try setting NODUMP flag with chattr +d ./foo to see the difference
> > +     */
> > +    if (fa.fa_xflags & FS_XFLAG_NODUMP)
> > +        printf("  NODUMP flag is set\\n");
> > +
> > +    exit(EXIT_SUCCESS);
> > +}
> > +.EE
> > +.in
> > +.SH SEE ALSO
> > +.BR file_setattr (2),
> > +.BR file_attr (2type),
> > +.BR ioctl (2),
> > +.BR ioctl_fs (2),
> > +.BR openat (2)
> > diff --git a/man/man2/file_setattr.2 b/man/man2/file_setattr.2
> > new file mode 100644
> > index 000000000000..596750dc79c8
> > --- /dev/null
> > +++ b/man/man2/file_setattr.2
> > @@ -0,0 +1,340 @@
> > +.\" Copyright, the authors of the Linux man-pages project
> > +.\"
> > +.\" SPDX-License-Identifier: Linux-man-pages-copyleft
> > +.\"
> > +.TH file_setattr 2 (date) "Linux man-pages (unreleased)"
> > +.SH NAME
> > +file_setattr \- set filesystem inode attributes
> > +.SH SYNOPSIS
> > +.nf
> > +.BR "#include <linux/fcntl.h>" "      /* Definition of " AT_* " constants */"
> > +.BR "#include <linux/fs.h>" "         /* Definition of " FILE_ATTR_* \
> > +" and " FS_XFLAG_* " constants */"
> > +.BR "#include <sys/syscall.h>" "      /* Definition of " SYS_* " constants */"
> > +.B #include <unistd.h>
> > +.P
> > +.B long syscall(SYS_file_setattr,
> > +.BI "               int " dirfd ", const char *" pathname ,
> > +.BI "               struct file_attr *" fattr ", size_t " size ,
> > +.BI "               unsigned int " flags );
> > +.fi
> > +.P
> > +.IR Note :
> > +glibc provides no wrapper for
> > +.BR file_setattr (),
> > +necessitating the use of
> > +.BR syscall (2).
> > +.SH DESCRIPTION
> > +The
> > +.BR file_setattr ()
> > +system call sets filesystem inode attributes
> > +on the file specified by
> > +.IR pathname .
> > +.P
> > +This system call provides functionality similar to the
> > +.B FS_IOC_FSSETXATTR
> > +.BR ioctl (2)
> > +operation,
> > +but with the advantage that the file does not need to be opened.
> > +By using a pathname instead of requiring an open file descriptor,
> > +.BR file_setattr ()
> > +can manipulate filesystem inode attributes
> > +on all file types,
> > +including special files (FIFOs, sockets, block devices, character devices)
> > +where opening the file may have side effects or may not be possible.
> > +With
> > +.BR ioctl (2),
> > +it is not always possible to obtain a file descriptor that refers
> > +directly to the filesystem inode for special files.
> > +.P
> > +As with
> > +.BR openat (2),
> > +if
> > +.I pathname
> > +is relative,
> > +then it is interpreted relative to the directory
> > +referred to by the file descriptor
> > +.I dirfd
> > +(or the current working directory of the calling process,
> > +if
> > +.I dirfd
> > +is the special value
> > +.BR AT_FDCWD ).
> > +If
> > +.I pathname
> > +is absolute,
> > +then
> > +.I dirfd
> > +is ignored.
> > +.P
> > +The
> > +.I fattr
> > +argument is a pointer to a
> > +.I file_attr
> > +structure,
> > +which specifies the attributes to set on the file.
> > +This structure is described in
> > +.BR file_attr (2type).
> > +.P
> > +The
> > +.I size
> > +argument specifies the size of the buffer pointed to by
> > +.IR fattr .
> > +The size indicates version of the structure in use, refer to
> > +.B file_attr(2type)
> > +for more information on versioning.
> > +.P
> > +User-space applications should zero-initialize
> > +.I struct file_attr
> > +to ensure that future fields added to the structure
> > +will be treated as no-ops if the structure definition is updated
> > +but the application is not.
> 
> I thought they were supposed to call file_getattr() to initialize fattr
> before making whatever changes they want and calling file_setattr()?

Yes, if file_getattr() is used for initialization then zeroing is
not required as kernel will zero/check that everything fits, but if
used by itself then zeroing would be necessary to work with older
kernels. What about this:

	.P
	User-space applications should use
	.B file_getattr(2)
	to initialize
	.I fattr
	structure beforehand or zero-initialize
	.I struct file_attr
	to ensure that future fields added to the structure
	will be treated as no-ops if the structure definition is updated
	but the application is not.

-- 
- Andrey
