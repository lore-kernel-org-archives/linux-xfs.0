Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48D6457E6A;
	Mon, 14 Sep 2026 12:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789389824; cv=none; b=eiTaw7breHjU9W/PDDZjzQQH4pFbOb9CA7R+cIF/9wP/YCYsLjD3mzxuc6ncFugmG5wlUzi81LWp0/prDA7+N38984RjakxYVY3RnrOFFOGxL6/wRnb9F9uZYh7Y5m0IJtLrHfWhcE1MhUM+fbSM6qhMNGnvw4MOx4ab5GHVHqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789389824; c=relaxed/simple;
	bh=rn/lbpbRRvZPtlo36MZQuJuoJ86e9IXwrS4za4UOgFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ssn5ds51KAxYPTDCqC5yaRSOvGVB/WXa6f8AtJg8GYDdrf5QBdxbcbzz1A32Ph9ReFzURqld7V8dv6P6C+JpvrlP4tPChfTpHZRYWrzSUErZlIBnJrwFls9Frfm/dPjLWCTImVvDe2OsEGXTXw2FUDXtFlX5SIgL4dEA9DoBP+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kc9KECev; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kc9KECev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66CB1F00898;
	Mon, 14 Sep 2026 12:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789389821;
	bh=7Tevdhj5gsnl3W2F5hS1cltCw+o1ZjKgPsXziPRDiYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kc9KECev8b3SF+2BSgQVKacdX3yeeCr6t4lZY9NYhKWxEvAGiqjAVTR4+ipxcDNFP
	 3f3zk/ddyCtECq/Prb93vG2TfyDubBQL89fTKgZfVm0bE8XTMMaNmul+M4zusvLmS8
	 pG7vEUCQ9lJEHtKIwFlWlco6Dqrm+9cuGdCJnaLcgV66Fve5luBNtJxvrybqJ3ri6P
	 +sPg12hXVBtVWHr27uG7LPOq1fHwo8D5R/MuhD8rzSzr6QF6VB9atzXU+SaxiQyfFS
	 JHDgFjsFRMRJTF8qZ7Oq6KDZuP5VUBf+ehc54Cti3sbL6yhwdz5o0dQAVzPP/SzsJL
	 xOn8jyj/7VJpQ==
Date: Mon, 14 Sep 2026 14:43:36 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	djwong@kernel.org
Subject: Re: [PATCH v3] man/man2: introduce man page for
 file_getattr/file_setattr syscalls
Message-ID: <aqfeV11OEqtb6nkt@devuan>
References: <20260914111107.1735564-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iaiu3zypj6efcqim"
Content-Disposition: inline
In-Reply-To: <20260914111107.1735564-1-aalbersh@kernel.org>


--iaiu3zypj6efcqim
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	djwong@kernel.org
Subject: Re: [PATCH v3] man/man2: introduce man page for
 file_getattr/file_setattr syscalls
Message-ID: <aqfeV11OEqtb6nkt@devuan>
References: <20260914111107.1735564-1-aalbersh@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260914111107.1735564-1-aalbersh@kernel.org>

Hi Andrey,

> Date: 2026-09-14 13:11:05+0200
> From: Andrey Albershteyn <aalbersh@kernel.org>
>
> Add manual pages for file_getattr() and file_setattr() syscalls and
> struct file_attr used as input/output argument.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Link: https://lore.kernel.org/all/20250630-xattrat-syscall-v6-0-c4e3bc352=
27b@kernel.org/
>=20
> ---
> Changes from v2:
> - a few grammar fixes
> - styling fixes
> - sashiko.dev fixes (wrong AT_FDCWD combined with AT_EMPTY_PATH
>   description, unused "dfd")

I'd appreciate if you didn't use sashiko for manual pages.
<https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/CONTRIBUT=
ING.d/ai>

> - dropped requirement to zero fattr before using file_setattr()
> - Pathname -> path
> - Dropped description of why FS_IOC_ aren't usable with special files
> - Fixed backslashes in the code examples

It'd be very useful to see the range-diff too.
<https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/CONTRIBUT=
ING.d/patches/range-diff>

And it'd also be good to get the new versions of patches as replies to
the first mail in v1.  That would allow one to find the entire
discussion in one thread, with one subthread.
<https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/CONTRIBUT=
ING.d/patches/sendmail>

> ---
>  man/man2/file_getattr.2      | 262 +++++++++++++++++++++++++++++
>  man/man2/file_setattr.2      | 314 +++++++++++++++++++++++++++++++++++
>  man/man2type/file_attr.2type | 187 +++++++++++++++++++++
>  3 files changed, 763 insertions(+)
>  create mode 100644 man/man2/file_getattr.2
>  create mode 100644 man/man2/file_setattr.2
>  create mode 100644 man/man2type/file_attr.2type
>=20
> diff --git a/man/man2/file_getattr.2 b/man/man2/file_getattr.2
> new file mode 100644
> index 000000000000..1168b23c5ce5
> --- /dev/null
> +++ b/man/man2/file_getattr.2
> @@ -0,0 +1,262 @@
> +.\" Copyright, the authors of the Linux man-pages project
> +.\"
> +.\" SPDX-License-Identifier: Linux-man-pages-copyleft
> +.\"
> +.TH file_getattr 2 (date) "Linux man-pages (unreleased)"
> +.SH NAME
> +file_getattr \- get filesystem inode attributes
> +.SH SYNOPSIS
> +.nf
> +.BR "#include <linux/fcntl.h>" "      /* " AT_* " constants */"
> +.BR "#include <linux/fs.h>" "         /* " FS_XFLAG_* " constants */"
> +.BR "#include <sys/syscall.h>" "      /* " SYS_* " constants */"
> +.B #include <unistd.h>
> +.P
> +.B long syscall(SYS_file_getattr,
> +.BI "               int " dirfd ", const char *" path ,
> +.BI "               struct file_attr *" fattr ", size_t " size ,
> +.BI "               unsigned int " flags );
> +.fi
> +.SH DESCRIPTION
> +The
> +.BR file_getattr ()
> +system call retrieves filesystem file attributes
> +from the file.

I liked '... specified by path.'.  This is for example what openat2(2)
says.

Alternatively, we could say 's/the file/the specified file/'

> +.P
> +As with
> +.BR openat (2),
> +if
> +.I path
> +is relative,
> +then it is interpreted relative to the directory
> +referred to by the file descriptor
> +.IR dirfd .
> +The special value
> +.B AT_FDCWD
> +could be used to refer to the current working directory of the calling p=
rocess.

s/could/can/

Also, we didn't specify where to pass AT_FDCWD.  We should probably say
something like

	The special
	.I dirfd
	value
	.B AT_FDCWD
	...

> +If
> +.I path
> +is absolute,
> +then
> +.I dirfd
> +is ignored.
> +.P
> +The
> +.I fattr
> +argument is a pointer to a
> +.I file_attr
> +structure.
> +This structure will be filled with file attributes.
> +This structure is described in
> +.BR file_attr (2type).
> +.P
> +The
> +.I size
> +argument specifies the size of the structure pointed to by
> +.IR fattr .
> +The size indicates version of the structure in use, refer to
> +.B file_attr(2type)

I missed this formatting typo:

	.BR file_attr (2type)

> +for more information on versioning.
> +.P
> +Userspace applications should zero-initialize

s/Userspace/User-space/

(reported in v2)

> +.I struct file_attr

For consistency with a few sentences above, let's say:

	... the
	.I file_attr
	structure
	...

Alternatively, 's/struct file_attr/fattr/'.

> +before calling
> +.BR file_getattr ()
> +to ensure that fields not filled in by older kernels
> +will have predictable values.

s/will have predictable values/are cleared/.

> +.P
> +The
> +.I flags
> +argument contains a bitwise OR of zero or more of the following constant=
s:
> +.TP
> +.B AT_EMPTY_PATH
> +If
> +.I path
> +is an empty string,
> +operate on the file referred to by
> +.IR dirfd .
> +In this case,
> +.I dirfd
> +can refer to any type of file,
> +not just a directory.
> +.TP
> +.B AT_SYMLINK_NOFOLLOW
> +If
> +.I path
> +is a symbolic link,
> +do not dereference it;
> +instead get attributes of the symbolic link inode itself.
> +By default, symbolic links are dereferenced.
> +.SH RETURN VALUE
> +On success,
> +zero is returned.
> +On error,
> +\-1 is returned,
> +and
> +.I errno
> +is set to indicate the error.
> +.SH ERRORS
> +.TP
> +.B E2BIG
> +.I size
> +is too big (larger than
> +.BR PAGE_SIZE ).
> +.TP
> +.B EACCES
> +Search permission is denied for one of the directories
> +in the path prefix of
> +.IR path .
> +.TP
> +.B EBADF
> +.I path
> +is relative but
> +.I dirfd
> +is neither
> +.B AT_FDCWD
> +nor a valid file descriptor.
> +.TP
> +.B EBADF
> +.I path
> +is an empty string,
> +.B AT_EMPTY_PATH
> +was specified,
> +but
> +.I dirfd
> +is neither
> +.B AT_FDCWD
> +nor a valid file descriptor.
> +.TP
> +.B EFAULT
> +.I path
> +or
> +.I fattr
> +is an invalid pointer.
> +.TP
> +.B EINVAL
> +Unknown flag specified in
> +.IR flags .
> +.TP
> +.B EINVAL
> +.I size
> +is smaller than
> +.BR FILE_ATTR_SIZE_VER0 .
> +.TP
> +.B ELOOP
> +Too many symbolic links encountered while resolving
> +.IR path .
> +.TP
> +.B ENAMETOOLONG
> +.I path
> +is too long.
> +.TP
> +.B ENOENT
> +A component of
> +.I path
> +does not exist,
> +or
> +.I path
> +is an empty string and
> +.B AT_EMPTY_PATH
> +was not specified in
> +.IR flags .
> +.TP
> +.B ENOMEM
> +Insufficient kernel memory was available.
> +.TP
> +.B ENOTDIR
> +A component of the path prefix of
> +.I path
> +is not a directory, or
> +.I path
> +is relative and
> +.I dirfd
> +is a file descriptor referring to a file other than a directory.
> +.TP
> +.B EOPNOTSUPP
> +The filesystem does not support getting attributes on this type of inode.
> +.SH HISTORY
> +.SS Linux 6.17
> +This system call is introduced as a more flexible alternative to the
> +FS_IOC_FSGETXATTR
> +.BR ioctl (2)
> +which could work on any type of file.
> +.SH NOTES
> +This system call is designed to be extensible.
> +The
> +.I size
> +argument allows userspace applications to indicate
> +which version of the
> +.I file_attr
> +structure they are using,
> +enabling the kernel to support both old and new versions
> +of the structure simultaneously.
> +.P
> +If
> +.I size
> +is smaller than the structure size the kernel expects,
> +only the fields that fit within
> +.I size
> +will be filled in.
> +If
> +.I size
> +is larger than the kernel's structure size,
> +the extra bytes are zeroed.

Hmmm, this seems to contradict the explanation from above.  I'll quote:

	Userspace applications should zero-initialize
	.I struct file_attr
	before calling
	.BR file_getattr ()
	to ensure that fields not filled in by older kernels
	will have predictable values.

So, if old kernels zero any bytes between the (small) size supported by
the kernel and the (large) size used by the user, why would the user
need to zero them?  Isn't the kernel doing exactly that?

> +.SH EXAMPLES
> +The program below demonstrates the use of
> +.BR file_getattr ()
> +to retrieve and display file attributes.
> +.P
> +.in +4n
> +.EX
> +#include <fcntl.h>
> +#include <linux/fs.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/syscall.h>
> +#include <unistd.h>
> +
> +#ifndef SYS_file_getattr
> +#define SYS_file_getattr 467
> +#endif
> +
> +int
> +main(int argc, char *argv[])
> +{
> +    struct file_attr fa =3D { 0 };
> +    long ret;
> +
> +    if (argc !=3D 2) {
> +        fprintf(stderr, "Usage: %s <filename>\[rs]n", argv[0]);
> +        exit(EXIT_FAILURE);
> +    }
> +
> +    ret =3D syscall(SYS_file_getattr, AT_FDCWD, argv[1], &fa, sizeof(fa)=
, 0);
> +    if (ret =3D=3D \-1) {
> +        perror("file_getattr");
> +        exit(EXIT_FAILURE);
> +    }
> +
> +    printf("File attributes:\[rs]n");
> +    printf("  xflags:     0x%llx\[rs]n", (unsigned long long) fa.fa_xfla=
gs);
> +    printf("  extsize:    %u\[rs]n", fa.fa_extsize);
> +    printf("  nextents:   %u\[rs]n", fa.fa_nextents);
> +    printf("  projid:     %u\[rs]n", fa.fa_projid);
> +    printf("  cowextsize: %u\[rs]n", fa.fa_cowextsize);
> +
> +    /*
> +     * Try setting NODUMP flag with chattr +d ./foo to see the difference
> +     */
> +    if (fa.fa_xflags & FS_XFLAG_NODUMP)
> +        printf("  NODUMP flag is set\[rs]n");
> +
> +    exit(EXIT_SUCCESS);
> +}
> +.EE
> +.in
> +.SH SEE ALSO
> +.BR file_setattr (2),
> +.BR file_attr (2type),
> +.BR ioctl (2),
> +.BR ioctl_fs (2),
> +.BR openat (2),
> +.BR ioctl_xfs_fssetxattr (2)
> diff --git a/man/man2/file_setattr.2 b/man/man2/file_setattr.2
> new file mode 100644
> index 000000000000..2b30f25c64de
> --- /dev/null
> +++ b/man/man2/file_setattr.2
> @@ -0,0 +1,314 @@
> +.\" Copyright, the authors of the Linux man-pages project
> +.\"
> +.\" SPDX-License-Identifier: Linux-man-pages-copyleft
> +.\"
> +.TH file_setattr 2 (date) "Linux man-pages (unreleased)"
> +.SH NAME
> +file_setattr \- set filesystem inode attributes
> +.SH SYNOPSIS
> +.nf
> +.BR "#include <linux/fcntl.h>" "      /* Definition of " AT_* " constant=
s */"
> +.BR "#include <linux/fs.h>" "         /* Definition of " FILE_ATTR_* \
> +" and " FS_XFLAG_* " constants */"
> +.BR "#include <sys/syscall.h>" "      /* Definition of " SYS_* " constan=
ts */"
> +.B #include <unistd.h>
> +.P
> +.B long syscall(SYS_file_setattr,
> +.BI "               int " dirfd ", const char *" path ,
> +.BI "               struct file_attr *" fattr ", size_t " size ,
> +.BI "               unsigned int " flags );
> +.fi
> +.P
> +.SH DESCRIPTION
> +The
> +.BR file_setattr ()
> +system call sets filesystem file attributes
> +on the file.
> +.P
> +As with
> +.BR openat (2),
> +if
> +.I path
> +is relative,
> +then it is interpreted relative to the directory
> +referred to by the file descriptor
> +.I dirfd
> +(or the current working directory of the calling process,
> +if
> +.I dirfd
> +is the special value
> +.BR AT_FDCWD ).
> +If
> +.I path
> +is absolute,
> +then
> +.I dirfd
> +is ignored.

How about saying that the parameters 'dirfd', 'path', and 'flags' are
interpreted like in file_getattr(2), and we save some paragraphs?

We'd also save the user from checking whether there's a tiny detail that
differs, or if they are identical.

I have a long term plan of removing a lot of paragraphs in manual pages,
by saying that some syscalls or functions behave exactly like others, at
least for some parameters.

> +.P
> +The
> +.I fattr
> +argument is a pointer to a
> +.I file_attr
> +structure,
> +which specifies the attributes to set on the file.
> +This structure is described in
> +.BR file_attr (2type).
> +Userspace applications should use
> +.B file_getattr(2)
> +to initialize
> +.I struct fattr

s/struct fattr/fattr/

It's the name of the parameter, not the struct tag.

Or alternatively, say 'the file_attr structure'.

> +beforehand.
> +.P
> +The
> +.I size
> +argument specifies the size of the structure pointed to by
> +.IR fattr .
> +The size indicates version of the structure in use, refer to
> +.B file_attr(2type)

=2EBR file_attr (2type)

> +for more information on versioning.
> +.P
> +The
> +.I flags
> +argument contains a bitwise OR of zero or more of the following constant=
s:
> +.TP
> +.B AT_EMPTY_PATH
> +If
> +.I path
> +is an empty string,
> +operate on the file referred to by
> +.I dirfd
> +(which may have been obtained using the
> +.BR open (2)
> +.B O_PATH
> +flag).
> +In this case,
> +.I dirfd
> +can refer to any type of file,
> +not just a directory.
> +.TP
> +.B AT_SYMLINK_NOFOLLOW
> +If
> +.I path
> +is a symbolic link,
> +do not dereference it:
> +instead set attributes on the symbolic link itself.
> +By default (i.e., if this flag is not specified),
> +symbolic links are dereferenced.

The wording here should be consistent with the 'get' function, which
doesn't have the parenthetical (or, ideally, de-duplicated, by saying
'flags' is interpreted like in the 'get' function.

> +.SH RETURN VALUE
> +On success,
> +zero is returned.
> +On error,
> +\-1 is returned,
> +and
> +.I errno
> +is set to indicate the error.
> +.SH ERRORS
> +.TP
> +.B E2BIG
> +.I size
> +is larger than
> +.BR PAGE_SIZE .
> +.TP
> +.B E2BIG
> +.I size
> +indicates the version which kernel doesn't support (the size is larger t=
han the

s/the version with/a version with the/

> +kernel expects) and new fields are non-zero.

Please break the lines before '(' and after ')'.

> +.TP
> +.B EACCES
> +Search permission is denied for one of the directories
> +in the path prefix of
> +.IR path .
> +(See also
> +.BR path_resolution (7).)

The wording should be consistent with the 'get' function.

Alternatively, we could say this (if we've specified the parameters as
being interpreted as if the 'get' function):

	.TP
	.B EACCESS
	See
	.BR file_setattr (2).

And the same for other errors about path/dirfd/flags that are exactly
as in file_getattr(2).

> +.TP
> +.B EBADF
> +.I path
> +is relative but
> +.I dirfd
> +is neither
> +.B AT_FDCWD
> +nor a valid file descriptor.
> +.TP
> +.B EBADF
> +.I path
> +is an empty string,
> +.B AT_EMPTY_PATH
> +was specified in
> +.IR flags ,
> +and
> +.I dirfd
> +is neither
> +.B AT_FDCWD
> +nor a valid file descriptor.
> +.TP
> +.B EFAULT
> +.I path
> +or
> +.I fattr
> +is an invalid pointer.
> +.TP
> +.B EINVAL
> +Unknown flag specified in
> +.IR flags .
> +.TP
> +.B EINVAL
> +.I size
> +is smaller than
> +.BR FILE_ATTR_SIZE_VER0 .
> +.TP
> +.B EINVAL
> +Invalid combination of parameters provided in
> +.I fattr
> +for this type of file or filesystem.
> +.TP
> +.B ELOOP
> +Too many symbolic links encountered while resolving
> +.IR path .
> +.TP
> +.B ENAMETOOLONG
> +.I path
> +is too long.
> +.TP
> +.B ENOENT
> +A component of
> +.I path
> +does not exist,
> +or
> +.I path
> +is an empty string and
> +.B AT_EMPTY_PATH
> +was not specified in
> +.IR flags .
> +.TP
> +.B ENOMEM
> +Insufficient kernel memory was available.
> +.TP
> +.B ENOTDIR
> +A component of the path prefix of
> +.I path
> +is not a directory, or
> +.I path
> +is relative and
> +.I dirfd
> +is a file descriptor referring to a file other than a directory.
> +.TP
> +.B EOPNOTSUPP
> +The filesystem does not support setting attributes on this type of inode.
> +.TP
> +.B EPERM
> +The caller does not have the necessary permissions
> +to change the file attributes.
> +.TP
> +.B EROFS
> +The file is on a read-only filesystem.
> +.SH HISTORY
> +.SS Linux 6.17
> +This system call is introduced as a more flexible alternative to the
> +FS_IOC_FSSETXATTR
> +.BR ioctl (2)
> +which could work on any type of files.

I think this paragraph could be removed, and only specified in the XFS
manual page.

> +.SH NOTES
> +This system call is designed to be extensible.
> +The
> +.I size
> +argument allows user-space applications to indicate
> +which version of the
> +.I file_attr
> +structure they are using,
> +enabling the kernel to support both old and new versions
> +of the structure simultaneously.
> +.P
> +If
> +.I size
> +is smaller than the structure size the kernel expects,
> +the kernel treats the missing fields as having zero values
> +(which is a no-op).
> +If
> +.I size
> +is larger than expected,
> +the kernel checks that all unknown (to the kernel) fields are zero;
> +if not,
> +the call fails with
> +.BR E2BIG .
> +.SH EXAMPLES
> +The program below demonstrates the use of
> +.BR file_setattr ()
> +to set the
> +.B FS_XFLAG_NODUMP
> +flag on a file.
> +.P
> +.in +4n
> +.EX
> +#include <fcntl.h>
> +#include <linux/fcntl.h>
> +#include <linux/fs.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/syscall.h>
> +#include <unistd.h>
> +
> +#ifndef SYS_file_getattr
> +#define SYS_file_getattr 467
> +#endif
> +
> +#ifndef SYS_file_setattr
> +#define SYS_file_setattr 468
> +#endif
> +
> +int
> +main(int argc, char *argv[])
> +{
> +    struct file_attr fa =3D { 0 };
> +    int dfd;
> +    long ret;
> +
> +    if (argc !=3D 2) {
> +        fprintf(stderr, "Usage: %s <filename>\[rs]n", argv[0]);
> +        exit(EXIT_FAILURE);
> +    }
> +
> +    dfd =3D open(argv[1], O_RDONLY);
> +    if (dfd =3D=3D \-1) {
> +        perror("open");
> +        exit(EXIT_FAILURE);
> +    }
> +
> +    ret =3D syscall(SYS_file_getattr, dfd, "", &fa, sizeof(fa), AT_EMPTY=
_PATH);
> +    if (ret =3D=3D \-1) {
> +        perror("file_getattr");
> +        exit(EXIT_FAILURE);
> +    }
> +
> +    printf("Current flags: 0x%llx\[rs]n", (unsigned long long) fa.fa_xfl=
ags);
> +
> +    fa.fa_xflags |=3D FS_XFLAG_NODUMP;
> +
> +    ret =3D syscall(SYS_file_setattr, dfd, "", &fa, sizeof(fa), AT_EMPTY=
_PATH);
> +    if (ret =3D=3D \-1) {
> +        perror("file_setattr");
> +        exit(EXIT_FAILURE);
> +    }
> +
> +    ret =3D syscall(SYS_file_getattr, dfd, "", &fa, sizeof(fa), AT_EMPTY=
_PATH);
> +    if (ret =3D=3D \-1) {
> +        perror("file_getattr");
> +        exit(EXIT_FAILURE);
> +    }
> +
> +    if (fa.fa_xflags & FS_XFLAG_NODUMP)
> +        printf("flags 0x%llx (NODUMP flag is set)\[rs]n",
> +            (unsigned long long) fa.fa_xflags);
> +
> +    exit(EXIT_SUCCESS);
> +}
> +.EE
> +.in
> +.SH SEE ALSO
> +.BR file_getattr (2),
> +.BR ioctl (2),
> +.BR ioctl_fs (2),
> +.BR openat (2),
> +.BR file_attr (2type),
> +.BR path_resolution (7),
> +.BR ioctl_xfs_fssetxattr (2)
> diff --git a/man/man2type/file_attr.2type b/man/man2type/file_attr.2type
> new file mode 100644
> index 000000000000..fd426c19f5f0
> --- /dev/null
> +++ b/man/man2type/file_attr.2type
> @@ -0,0 +1,187 @@
> +.\" Copyright, the authors of the Linux man-pages project
> +.\"
> +.\" SPDX-License-Identifier: Linux-man-pages-copyleft
> +.\"
> +.TH file_attr 2type (date) "Linux man-pages (unreleased)"
> +.SH NAME
> +file_attr \- describe filesystem file attributes to get or set
> +.SH SYNOPSIS
> +.EX
> +.B #include <linux/fs.h>
> +.P
> +.B struct file_attr {
> +.BR "    u64  fa_xflags;" "     /* Extended flags */"
> +.BR "    u32  fa_extsize;" "    /* Extent size hint */"
> +.BR "    u32  fa_nextents;" "   /* Number of extents (read-only) */"
> +.BR "    u32  fa_projid;" "     /* Project identifier */"
> +.BR "    u32  fa_cowextsize;" " /* CoW extent size hint */"
> +.B };
> +.EE
> +.SH DESCRIPTION
> +Describes filesystem file attributes
> +for use with the
> +.BR file_getattr (2)
> +and
> +.BR file_setattr (2)
> +system calls.
> +.P
> +The fields are as follows:
> +.TP
> +.I fa_xflags
> +This field contains file attribute flags.
> +It is a bit mask consisting of zero or more of the
> +.B FS_XFLAG_*
> +flags.
> +Refer to the section
> +.B FLAGS
> +below for a list of all flags.
> +.TP
> +.I fa_extsize
> +Extent size allocator hint in bytes.
> +This value suggests a preferred extent size
> +for new allocations to this file.
> +.TP
> +.I fa_nextents
> +Number of data extents in the file (read-only).
> +This field is filled in by
> +.BR file_getattr (2)
> +and is ignored by
> +.BR file_setattr (2).
> +.TP
> +.I fa_projid
> +Project identifier.
> +Used by quota systems to group related files.
> +.TP
> +.I fa_cowextsize
> +Copy-on-Write (CoW) extent size hint in bytes.
> +This value suggests a preferred extent size
> +for CoW operations.
> +.SH FLAGS
> +Flags can be:
> +.RS
> +.TP
> +.B FS_XFLAG_REALTIME
> +Data is stored in a realtime volume.
> +.TP
> +.B FS_XFLAG_IMMUTABLE
> +File cannot be modified.
> +.TP
> +.B FS_XFLAG_APPEND
> +All writes must append to the end of the file.
> +.TP
> +.B FS_XFLAG_SYNC
> +All writes are synchronous.
> +.TP
> +.B FS_XFLAG_NOATIME
> +Do not update file access time on reads.
> +.TP
> +.B FS_XFLAG_NODUMP
> +Do not include file in backups.
> +.TP
> +.B FS_XFLAG_DAX
> +Use Direct Access (DAX) for I/O operations.
> +.TP
> +.B FS_XFLAG_NODEFRAG
> +Exclude this file from defragmentation operations.
> +.TP
> +.B FS_XFLAG_FILESTREAM
> +Use filestream allocator for this file.
> +.TP
> +.B FS_XFLAG_EXTSIZE
> +Use the extent size hint from the
> +.I fa_extsize
> +field.
> +.TP
> +.B FS_XFLAG_COWEXTSIZE
> +Use the CoW extent size hint from the
> +.I fa_cowextsize
> +field.
> +.RE
> +.P
> +Directory only flags:
> +.RS
> +.TP
> +.B FS_XFLAG_RTINHERIT
> +New files created in this directory inherit the realtime flag.
> +.TP
> +.B FS_XFLAG_NOSYMLINKS
> +Disallow creation of symbolic links in this directory.
> +.TP
> +.B FS_XFLAG_EXTSZINHERIT
> +New files created in this directory inherit the extent size hint.
> +.TP
> +.B FS_XFLAG_PROJINHERIT
> +New files created in this directory inherit the project identifier.
> +.RE
> +.P
> +The following flags are read-only:
> +.RS
> +.TP
> +.B FS_XFLAG_PREALLOC
> +File has preallocated extents.
> +.TP
> +.B FS_XFLAG_HASATTR
> +File has extended attributes.
> +.TP
> +.B FS_XFLAG_VERITY
> +File has fs-verity enabled.
> +.TP
> +.B FS_XFLAG_CASEFOLD
> +The filesystem performs case-insensitive lookups (file and directory name
> +comparisons ignore case).
> +.TP
> +.B FS_XFLAG_CASENONPRESERVING
> +The filesystem does not preserve the case of file and directory names.
> +.RE
> +.P
> +Not all filesystems support all flags.
> +Setting unsupported flags may result in an
> +.B EINVAL
> +or
> +.B EOPNOTSUPP
> +error.
> +.SH VERSIONS
> +.SS Structure size
> +The structure size is defined by
> +.B FILE_ATTR_SIZE_VER*
> +which is also a version of the structure being used.

Why do those macros exist?  I expect users should just use sizeof(),
right?  In fact, the example program doesn't show its use at all.
Should we remove that macro entirely?

> +The
> +.I size
> +parameter passed to
> +.BR file_getattr (2)
> +and
> +.BR file_setattr (2)
> +indicates the version of
> +.I struct file_attr\fP.
> +.SS FILE_ATTR_SIZE_VER0
> +Size is 24 bytes.

This implementation detail seems unnecessary for programmers.
'24' is something programmers shouldn't know, IMO.

> +.SH HISTORY
> +.SS Linux v6.17
> +This structure is introduced.
> +The
> +.I struct file_attr
> +provides similar functionality to
> +.I struct fsxattr
> +used by the
> +.B FS_IOC_FSGETXATTR
> +and
> +.B FS_IOC_FSSETXATTR
> +.BR ioctl (2)
> +operations,
> +but is designed to be extensible through the
> +.I size
> +parameter of the system calls.

I'd remove this paragraph.  Users of this API shouldn't need that info.
It's only users of the ioctl that need to be aware of these APIs, and
thus this belongs in the XPF manual pages but not here.

> +.P
> +Extra fields may be appended to the structure in future kernel versions.
> +The kernel will expect new fields to be zeros
> +for older versions of the structure.
> +Therefore, a user
> +.I must
> +zero-fill the structure on initialization to keep compatibility with old=
er
> +kernels.


Have a lovely day!
Alex

> +.SS Linux v7.2
> +The FS_XFLAG_CASEFOLD and FS_XFLAG_CASENONPRESERVING are introduced to e=
nable
> +upper layers, such as NFSD, to retrieve case sensitivity information.
> +.SH SEE ALSO
> +.BR file_getattr (2),
> +.BR file_setattr (2)
> --=20
> 2.55.0
>=20
>=20

--=20
<https://www.alejandro-colomar.es>

--iaiu3zypj6efcqim
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmqn6+wACgkQ64mZXMKQ
wqnAExAAiPedoS0uaGDriIgAxz13Bm4QrdlTOH3KUjuIcFG35nO00vOWILxrUBhu
tHyxxHuk+Fnq6FpvAnkxgJTZV2EC/sxCscJ74AATpR1w1vD+DanLmNkwTvnbnFyo
jpdAz81aCWhikEJpWsr4RFyICDzlTj2jBu+xERXX3vVK3/B0tBV98aaZ7FeE4dNH
Y2lB5olf1JrQV3S7DJo+lrPGm02hgSQgifYRIPvaABzUOGtWQlMPOhdrz1WB4k9g
htoa9Y+qMJN9Id7TC7mQYIU0nr7dvHx1jl5+NkYTfgXGNmOYQ/YtMjxv0slDsiGM
Fuu7s9Dq6JCSdAXgU4TwrcEJ+n+QwU7y4xGxb3zDtFqCrnB3Ja/qbYYsfMLKfYO+
/R/+TSMboEIVdL6SkdIFpy5fmQ3SzYTfTLIk/+jmeDPQi9LDLGw2glYe7eFcPmp/
hbDojbct+n0Wj+U9LDjmT0EZg2J/2ouFAOk31bTJqA4iWbO3wgoZwwUgHzJkNi+x
vPhMGRI/mGRUK4XQPnlxFvF/mOn7mecPP5PxhKf/4LTnl+huQ4+tvBTwIHKBh5L0
w+wpOpFgEHLkWN7OFWeP8iL1pri5c0QJVG/tJrZqyM4nW13ElWJJMER/m1f16bFe
gl/5vMTfVGcPR7D+0NE682VVwE+vad+pdjDJa42+yF8Snjv4O2E=
=/Qx9
-----END PGP SIGNATURE-----

--iaiu3zypj6efcqim--
