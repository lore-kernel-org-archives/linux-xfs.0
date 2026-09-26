Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A008B451984;
	Sat, 26 Sep 2026 13:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790431104; cv=none; b=HkDCaTwsxcUImmKtvtdvX/xwXCt5J9m5dav0vkcqzTVJtC2KtzKFzmAPRMzfnFAj0Dr7eJplIBJsMo6a3lS/azb7dHplIbnOJCUxp6ShSE4eTvt8FwefvVax4Yz8t/9tXRw79/GBMimEUfzUIQoZZOhccjhOLm+JrptV0ecuiQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790431104; c=relaxed/simple;
	bh=Pgv4gtR6JwK/Ow6u9cMfdlP2zejzoMbK0KOb0++m+zM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XEAvhUyEL/aE5yb81yhTwup/Vn0CXz+hdjOV50QVdkWfLkbJKss/ZlIxX3ip/rxvlFLmwyY+WtLeW+Mts6/ZUBBYuekJpvsInd4GzZjleWXFbs2psHMGvY05rG9Ri7iFQCW7Ilgk4eJTkhQVmiA4AFqvFmA12LSDUEshK4c7HQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D3kwz/E3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D3kwz/E3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44A11F000FF;
	Sat, 26 Sep 2026 13:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790431098;
	bh=T8UahbqwEO7ja3F4h2ywNBxggI/LKEHh/A2SncRVkug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D3kwz/E3AiQrwCEdpgrRK5EBGKYPFfcQ2xwlmrtLXy0qkkDG/kcYNhaH5KrbKDqho
	 IJGONID7QwHaZWRFzMXk1LNSs3hzgGB4boid3pcm63NArhAHyKG4sQ0X97gz0tDZjo
	 IebLEC2YQnl7lmYeeAE8d4g9pe4hI2UjhF6A/138TPA4MiiwJ+oG9DoTrfgATtJxmy
	 /nr2/jjOsZwj4kWSiMicxtrQzTxbipbHzhtEJ9Is6Crerw3VexcVQcnqDX3rmTNJLq
	 +e07XJJ3JpUxML+Aonp0JTkTSohNYxGwbeiQNNUCUni+mU1hP14D4//Dmx0P5Qm0OC
	 8BrCyjPSqXmOQ==
Date: Sat, 26 Sep 2026 15:58:10 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	djwong@kernel.org
Subject: Re: [PATCH v4] man/man2: introduce man page for
 file_getattr/file_setattr syscalls
Message-ID: <arfHy0O0c1cfoSkh@debian>
References: <20260914111107.1735564-1-aalbersh@kernel.org>
 <20260916115141.3500780-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rqz2sg4sh37j4buv"
Content-Disposition: inline
In-Reply-To: <20260916115141.3500780-1-aalbersh@kernel.org>


--rqz2sg4sh37j4buv
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	djwong@kernel.org
Subject: Re: [PATCH v4] man/man2: introduce man page for
 file_getattr/file_setattr syscalls
Message-ID: <arfHy0O0c1cfoSkh@debian>
References: <20260914111107.1735564-1-aalbersh@kernel.org>
 <20260916115141.3500780-1-aalbersh@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260916115141.3500780-1-aalbersh@kernel.org>

Hi Andrey,

> Date: 2026-09-16 13:51:39+0200
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

Thanks!  It looks quite good.  I have another round of small comments.

> Changes from v3:
> - dropped VERSIONS section in file_attr.2type
> - reference arguments and errors from file_setattr to file_getattr
> - Minor wording fixes
> - Minor formatting fixes
> - Removed zero-initialized requirement
> - Interdiff with v3 below
>=20
> Changes from v2:
> - a few grammar fixes
> - styling fixes
> - sashiko.dev fixes (wrong AT_FDCWD combined with AT_EMPTY_PATH
>   description, unused "dfd")
> - dropped requirement to zero fattr before using file_setattr()
> - Pathname -> path
> - Dropped description of why FS_IOC_ aren't usable with special files
> - Fixed backslashes in the code examples
> ---
>  man/man2/file_getattr.2      | 254 +++++++++++++++++++++++++++++++++++
>  man/man2/file_setattr.2      | 180 +++++++++++++++++++++++++
>  man/man2type/file_attr.2type | 151 +++++++++++++++++++++

I prefer 3 patches, eacch of which adds one manual page.  That will
make the 'Subject:' of the patch more explicit.

>  3 files changed, 585 insertions(+)
>  create mode 100644 man/man2/file_getattr.2
>  create mode 100644 man/man2/file_setattr.2
>  create mode 100644 man/man2type/file_attr.2type
>=20
> diff --git a/man/man2/file_getattr.2 b/man/man2/file_getattr.2
> new file mode 100644
> index 000000000000..fe804d97976b
> --- /dev/null
> +++ b/man/man2/file_getattr.2
> @@ -0,0 +1,254 @@
> +.\" Copyright, the authors of the Linux man-pages project
> +.\"
> +.\" SPDX-License-Identifier: Linux-man-pages-copyleft
> +.\"
> +.TH file_getattr 2 (date) "Linux man-pages (unreleased)"
> +.SH NAME
> +file_getattr \- get filesystem file attributes
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

+of the file

> +specified by path.
> +.P
> +As with
> +.BR openat (2),
> +if
> +.I path
> +is relative,
> +then it is interpreted relative to the directory
> +referred to by the file descriptor
> +.IR dirfd .
> +The special
> +.I dirfd
> +value
> +.B AT_FDCWD
> +can be used to refer to the current working directory of the calling pro=
cess.
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

s/version/the &/

> +.B file_attr (2type)
> +for more information on versioning.

I would remove the reference to file_attr(2type) here entirely.  The
only thing the user needs to care at this point is that it's used as
a version.  The user will probably read file_attr(2type) for other
reasons, and will find the HISTORY section, but I think it's not
relevant enough at this point to add a sentence referring to it.

On the other hand, I think we should explicitly say that this should
always be specified as sizeof(struct file_attr).

	This size indicates the version of the structure in use,
	and should always be specified as
	.IR \%sizeof(struct\~file_attr) .

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

s/instead/&,\n/

> +By default, symbolic links are dereferenced.

I think we can get rid of this last sentence.  I seems obvious by the
fact that there's a flag for changing the behavior.

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

s/flag/&s/

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

These two are quite distinct errors, so I'd add two separate entries:

	.TP
	.B ENOENT
	A component of
	.I path
	does not exist.
	.TP
	.B ENOENT
	.I path
	is an empty string and
	.B AT_EMPTY_PATH
	was not specified in
	.IR flags .

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

I'd also split these two, as they're quite distinct.

	.TP
	.B ENOTDIR
	A component of the path prefix of
	.I path
	is not a directory.
	.TP
	.B ENOTDIR
	.I path
	is relative and
	.I dirfd
	is a file descriptor referring to a file other than a directory.

> +.TP
> +.B EOPNOTSUPP
> +The filesystem does not support getting attributes on this type of inode.
> +.SH HISTORY
> +.SS Linux 6.17
> +This system call is introduced.

We often just say this:

	.SH HISTORY
	Linux 6.17.

That's understood as the version in which it was added.

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
> +only the fields that fit within
> +.I size
> +will be filled in.
> +If
> +.I size
> +is larger than the kernel's structure size,
> +the extra bytes are zeroed.
> +.SH EXAMPLES
> +The program below demonstrates the use of
> +.BR file_getattr ()
> +to retrieve and display file attributes.
> +.P
> +.in +4n
> +.EX

Please wrap the program code with markers so that the build system can
actually build the program (and run linters on it).  Please look at
man2/membarrier.2 for an example of how it's done (it's just a comment
in the manual page's source code).

	$ grep -C2 SRC man2/membarrier.2
	.P
	.in +4n
	.\" SRC BEGIN (membarrier.c)
	.EX
	#include <stdlib.h>
	--
	}
	.EE
	.\" SRC END
	.in
	.P


> +#include <fcntl.h>
> +#include <linux/fs.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/syscall.h>
> +#include <unistd.h>
> +

Blank lines should contain a "dummy" character (to avoid a diagnostic):

	...
	#include <unistd.h>
	\&
	#ifndef SYS_file_getattr
	...

> +#ifndef SYS_file_getattr
> +#define SYS_file_getattr 467
> +#endif
> +
> +int
> +main(int argc, char *argv[])
> +{
> +    struct file_attr fa;
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

We could use ISO C23's "%w64x" for printing a 64-bit integer.  That
avoids a cast.

> +    printf("  extsize:    %u\[rs]n", fa.fa_extsize);
> +    printf("  nextents:   %u\[rs]n", fa.fa_nextents);
> +    printf("  projid:     %u\[rs]n", fa.fa_projid);
> +    printf("  cowextsize: %u\[rs]n", fa.fa_cowextsize);

Since these are u32, it might make more sense to print them with
"%w32u".

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
> index 000000000000..0389f42afb50
> --- /dev/null
> +++ b/man/man2/file_setattr.2
> @@ -0,0 +1,180 @@
> +.\" Copyright, the authors of the Linux man-pages project
> +.\"
> +.\" SPDX-License-Identifier: Linux-man-pages-copyleft
> +.\"
> +.TH file_setattr 2 (date) "Linux man-pages (unreleased)"
> +.SH NAME
> +file_setattr \- set filesystem file attributes
> +.SH SYNOPSIS
> +.nf
> +.BR "#include <linux/fcntl.h>" "      /* Definition of " AT_* " constant=
s */"
> +.BR "#include <linux/fs.h>" "         /* Definition of " FS_XFLAG_* " co=
nstants */"
> +.BR "#include <sys/syscall.h>" "      /* Definition of " SYS_* " constan=
ts */"
> +.B #include <unistd.h>
> +.P
> +.B long syscall(SYS_file_setattr,
> +.BI "               int " dirfd ", const char *" path ,
> +.BI "               struct file_attr *" fattr ", size_t " size ,

I expect in the 'set' version, the 'fattr' argument will be read-only,
right?  Then it should be 'const'.

> +.BI "               unsigned int " flags );
> +.fi
> +.P
> +.SH DESCRIPTION
> +The
> +.BR file_setattr ()
> +system call sets filesystem file attributes
> +on the file specified by path.
> +.P
> +The
> +.IR dirfd ,
> +.IR path ,
> +.IR fattr ,

I expect 'fattr' will be read instead of written to.  That's an
important difference to be documented (if I'm assuming correctly).

> +.IR size ,
> +and
> +.I flags
> +arguments behaves in the same way as in

s/behaves/behave/

> +.BR file_getattr (2).
> +The only difference is that
> +user-space applications should use
> +.BR file_getattr (2)
> +to initialize
> +.I fattr
> +argument beforehand.
> +.SH RETURN VALUE
> +On success,
> +zero is returned.
> +On error,
> +\-1 is returned,
> +and
> +.I errno
> +is set to indicate the error.
> +.SH ERRORS
> +.P
> +The errors are the same as returned by
> +.BR file_getattr (2)
> +with the addition of following ones:
> +.TP
> +.B E2BIG
> +.I size
> +indicates a version which the kernel doesn't support
> +(the size is larger than the kernel expects)
> +and new fields are non-zero.
> +.TP
> +.B EINVAL
> +Invalid combination of parameters provided in
> +.I fattr
> +for this type of file or filesystem.
> +.TP
> +.B EPERM
> +The caller does not have the necessary permissions
> +to change the file attributes.
> +.TP
> +.B EROFS
> +The file is on a read-only filesystem.
> +.SH HISTORY
> +.SS Linux 6.17
> +This system call is introduced.

To simplify:

	.SH HISTORY
	Linux 6.17.

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

\&

> +#ifndef SYS_file_getattr
> +#define SYS_file_getattr 467
> +#endif
> +

\&

> +#ifndef SYS_file_setattr
> +#define SYS_file_setattr 468
> +#endif
> +

\&
=20
> +int
> +main(int argc, char *argv[])
> +{
> +    struct file_attr fa;
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
> index 000000000000..221d97b5220d
> --- /dev/null
> +++ b/man/man2type/file_attr.2type
> @@ -0,0 +1,151 @@
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

Should we maybe have a reference to any quota pages (e.g., quotactl(2))
instead of just saying quota?

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
> +.SH HISTORY
> +.SS Linux v6.17
> +This structure is introduced.
> +.SS Linux v7.2
> +The FS_XFLAG_CASEFOLD and FS_XFLAG_CASENONPRESERVING are introduced to e=
nable
> +upper layers, such as NFSD, to retrieve case sensitivity information.
> +.SH SEE ALSO
> +.BR file_getattr (2),
> +.BR file_setattr (2)


Have a lovely day!
Alex

>=20
> Interdiff against v3:
>   diff --git a/man/man2/file_getattr.2 b/man/man2/file_getattr.2
>   index 1168b23c5ce5..fe804d97976b 100644
>   --- a/man/man2/file_getattr.2
>   +++ b/man/man2/file_getattr.2
>   @@ -4,7 +4,7 @@
>    .\"
>    .TH file_getattr 2 (date) "Linux man-pages (unreleased)"
>    .SH NAME
>   -file_getattr \- get filesystem inode attributes
>   +file_getattr \- get filesystem file attributes
>    .SH SYNOPSIS
>    .nf
>    .BR "#include <linux/fcntl.h>" "      /* " AT_* " constants */"
>   @@ -21,7 +21,7 @@ file_getattr \- get filesystem inode attributes
>    The
>    .BR file_getattr ()
>    system call retrieves filesystem file attributes
>   -from the file.
>   +specified by path.
>    .P
>    As with
>    .BR openat (2),
>   @@ -31,9 +31,11 @@ is relative,
>    then it is interpreted relative to the directory
>    referred to by the file descriptor
>    .IR dirfd .
>   -The special value
>   +The special
>   +.I dirfd
>   +value
>    .B AT_FDCWD
>   -could be used to refer to the current working directory of the calling=
 process.
>   +can be used to refer to the current working directory of the calling p=
rocess.
>    If
>    .I path
>    is absolute,
>   @@ -55,16 +57,9 @@ The
>    argument specifies the size of the structure pointed to by
>    .IR fattr .
>    The size indicates version of the structure in use, refer to
>   -.B file_attr(2type)
>   +.B file_attr (2type)
>    for more information on versioning.
>    .P
>   -Userspace applications should zero-initialize
>   -.I struct file_attr
>   -before calling
>   -.BR file_getattr ()
>   -to ensure that fields not filled in by older kernels
>   -will have predictable values.
>   -.P
>    The
>    .I flags
>    argument contains a bitwise OR of zero or more of the following consta=
nts:
>   @@ -176,15 +171,12 @@ is a file descriptor referring to a file other th=
an a directory.
>    The filesystem does not support getting attributes on this type of ino=
de.
>    .SH HISTORY
>    .SS Linux 6.17
>   -This system call is introduced as a more flexible alternative to the
>   -FS_IOC_FSGETXATTR
>   -.BR ioctl (2)
>   -which could work on any type of file.
>   +This system call is introduced.
>    .SH NOTES
>    This system call is designed to be extensible.
>    The
>    .I size
>   -argument allows userspace applications to indicate
>   +argument allows user-space applications to indicate
>    which version of the
>    .I file_attr
>    structure they are using,
>   @@ -222,7 +214,7 @@ to retrieve and display file attributes.
>    int
>    main(int argc, char *argv[])
>    {
>   -    struct file_attr fa =3D { 0 };
>   +    struct file_attr fa;
>        long ret;
>   =20
>        if (argc !=3D 2) {
>   diff --git a/man/man2/file_setattr.2 b/man/man2/file_setattr.2
>   index 2b30f25c64de..0389f42afb50 100644
>   --- a/man/man2/file_setattr.2
>   +++ b/man/man2/file_setattr.2
>   @@ -4,12 +4,11 @@
>    .\"
>    .TH file_setattr 2 (date) "Linux man-pages (unreleased)"
>    .SH NAME
>   -file_setattr \- set filesystem inode attributes
>   +file_setattr \- set filesystem file attributes
>    .SH SYNOPSIS
>    .nf
>    .BR "#include <linux/fcntl.h>" "      /* Definition of " AT_* " consta=
nts */"
>   -.BR "#include <linux/fs.h>" "         /* Definition of " FILE_ATTR_* \
>   -" and " FS_XFLAG_* " constants */"
>   +.BR "#include <linux/fs.h>" "         /* Definition of " FS_XFLAG_* " =
constants */"
>    .BR "#include <sys/syscall.h>" "      /* Definition of " SYS_* " const=
ants */"
>    .B #include <unistd.h>
>    .P
>   @@ -23,77 +22,23 @@ file_setattr \- set filesystem inode attributes
>    The
>    .BR file_setattr ()
>    system call sets filesystem file attributes
>   -on the file.
>   -.P
>   -As with
>   -.BR openat (2),
>   -if
>   -.I path
>   -is relative,
>   -then it is interpreted relative to the directory
>   -referred to by the file descriptor
>   -.I dirfd
>   -(or the current working directory of the calling process,
>   -if
>   -.I dirfd
>   -is the special value
>   -.BR AT_FDCWD ).
>   -If
>   -.I path
>   -is absolute,
>   -then
>   -.I dirfd
>   -is ignored.
>   -.P
>   -The
>   -.I fattr
>   -argument is a pointer to a
>   -.I file_attr
>   -structure,
>   -which specifies the attributes to set on the file.
>   -This structure is described in
>   -.BR file_attr (2type).
>   -Userspace applications should use
>   -.B file_getattr(2)
>   -to initialize
>   -.I struct fattr
>   -beforehand.
>   -.P
>   -The
>   -.I size
>   -argument specifies the size of the structure pointed to by
>   -.IR fattr .
>   -The size indicates version of the structure in use, refer to
>   -.B file_attr(2type)
>   -for more information on versioning.
>   +on the file specified by path.
>    .P
>    The
>   +.IR dirfd ,
>   +.IR path ,
>   +.IR fattr ,
>   +.IR size ,
>   +and
>    .I flags
>   -argument contains a bitwise OR of zero or more of the following consta=
nts:
>   -.TP
>   -.B AT_EMPTY_PATH
>   -If
>   -.I path
>   -is an empty string,
>   -operate on the file referred to by
>   -.I dirfd
>   -(which may have been obtained using the
>   -.BR open (2)
>   -.B O_PATH
>   -flag).
>   -In this case,
>   -.I dirfd
>   -can refer to any type of file,
>   -not just a directory.
>   -.TP
>   -.B AT_SYMLINK_NOFOLLOW
>   -If
>   -.I path
>   -is a symbolic link,
>   -do not dereference it:
>   -instead set attributes on the symbolic link itself.
>   -By default (i.e., if this flag is not specified),
>   -symbolic links are dereferenced.
>   +arguments behaves in the same way as in
>   +.BR file_getattr (2).
>   +The only difference is that
>   +user-space applications should use
>   +.BR file_getattr (2)
>   +to initialize
>   +.I fattr
>   +argument beforehand.
>    .SH RETURN VALUE
>    On success,
>    zero is returned.
>   @@ -103,98 +48,22 @@ and
>    .I errno
>    is set to indicate the error.
>    .SH ERRORS
>   +.P
>   +The errors are the same as returned by
>   +.BR file_getattr (2)
>   +with the addition of following ones:
>    .TP
>    .B E2BIG
>    .I size
>   -is larger than
>   -.BR PAGE_SIZE .
>   -.TP
>   -.B E2BIG
>   -.I size
>   -indicates the version which kernel doesn't support (the size is larger=
 than the
>   -kernel expects) and new fields are non-zero.
>   -.TP
>   -.B EACCES
>   -Search permission is denied for one of the directories
>   -in the path prefix of
>   -.IR path .
>   -(See also
>   -.BR path_resolution (7).)
>   -.TP
>   -.B EBADF
>   -.I path
>   -is relative but
>   -.I dirfd
>   -is neither
>   -.B AT_FDCWD
>   -nor a valid file descriptor.
>   -.TP
>   -.B EBADF
>   -.I path
>   -is an empty string,
>   -.B AT_EMPTY_PATH
>   -was specified in
>   -.IR flags ,
>   -and
>   -.I dirfd
>   -is neither
>   -.B AT_FDCWD
>   -nor a valid file descriptor.
>   -.TP
>   -.B EFAULT
>   -.I path
>   -or
>   -.I fattr
>   -is an invalid pointer.
>   -.TP
>   -.B EINVAL
>   -Unknown flag specified in
>   -.IR flags .
>   -.TP
>   -.B EINVAL
>   -.I size
>   -is smaller than
>   -.BR FILE_ATTR_SIZE_VER0 .
>   +indicates a version which the kernel doesn't support
>   +(the size is larger than the kernel expects)
>   +and new fields are non-zero.
>    .TP
>    .B EINVAL
>    Invalid combination of parameters provided in
>    .I fattr
>    for this type of file or filesystem.
>    .TP
>   -.B ELOOP
>   -Too many symbolic links encountered while resolving
>   -.IR path .
>   -.TP
>   -.B ENAMETOOLONG
>   -.I path
>   -is too long.
>   -.TP
>   -.B ENOENT
>   -A component of
>   -.I path
>   -does not exist,
>   -or
>   -.I path
>   -is an empty string and
>   -.B AT_EMPTY_PATH
>   -was not specified in
>   -.IR flags .
>   -.TP
>   -.B ENOMEM
>   -Insufficient kernel memory was available.
>   -.TP
>   -.B ENOTDIR
>   -A component of the path prefix of
>   -.I path
>   -is not a directory, or
>   -.I path
>   -is relative and
>   -.I dirfd
>   -is a file descriptor referring to a file other than a directory.
>   -.TP
>   -.B EOPNOTSUPP
>   -The filesystem does not support setting attributes on this type of ino=
de.
>   -.TP
>    .B EPERM
>    The caller does not have the necessary permissions
>    to change the file attributes.
>   @@ -203,10 +72,7 @@ to change the file attributes.
>    The file is on a read-only filesystem.
>    .SH HISTORY
>    .SS Linux 6.17
>   -This system call is introduced as a more flexible alternative to the
>   -FS_IOC_FSSETXATTR
>   -.BR ioctl (2)
>   -which could work on any type of files.
>   +This system call is introduced.
>    .SH NOTES
>    This system call is designed to be extensible.
>    The
>   @@ -259,7 +125,7 @@ flag on a file.
>    int
>    main(int argc, char *argv[])
>    {
>   -    struct file_attr fa =3D { 0 };
>   +    struct file_attr fa;
>        int dfd;
>        long ret;
>   =20
>   diff --git a/man/man2type/file_attr.2type b/man/man2type/file_attr.2type
>   index fd426c19f5f0..221d97b5220d 100644
>   --- a/man/man2type/file_attr.2type
>   +++ b/man/man2type/file_attr.2type
>   @@ -140,45 +140,9 @@ Setting unsupported flags may result in an
>    or
>    .B EOPNOTSUPP
>    error.
>   -.SH VERSIONS
>   -.SS Structure size
>   -The structure size is defined by
>   -.B FILE_ATTR_SIZE_VER*
>   -which is also a version of the structure being used.
>   -The
>   -.I size
>   -parameter passed to
>   -.BR file_getattr (2)
>   -and
>   -.BR file_setattr (2)
>   -indicates the version of
>   -.I struct file_attr\fP.
>   -.SS FILE_ATTR_SIZE_VER0
>   -Size is 24 bytes.
>    .SH HISTORY
>    .SS Linux v6.17
>    This structure is introduced.
>   -The
>   -.I struct file_attr
>   -provides similar functionality to
>   -.I struct fsxattr
>   -used by the
>   -.B FS_IOC_FSGETXATTR
>   -and
>   -.B FS_IOC_FSSETXATTR
>   -.BR ioctl (2)
>   -operations,
>   -but is designed to be extensible through the
>   -.I size
>   -parameter of the system calls.
>   -.P
>   -Extra fields may be appended to the structure in future kernel version=
s.
>   -The kernel will expect new fields to be zeros
>   -for older versions of the structure.
>   -Therefore, a user
>   -.I must
>   -zero-fill the structure on initialization to keep compatibility with o=
lder
>   -kernels.
>    .SS Linux v7.2
>    The FS_XFLAG_CASEFOLD and FS_XFLAG_CASENONPRESERVING are introduced to=
 enable
>    upper layers, such as NFSD, to retrieve case sensitivity information.
> --=20
> 2.55.0
>=20
>=20

--=20
<https://www.alejandro-colomar.es>

--rqz2sg4sh37j4buv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmq3z2YACgkQ64mZXMKQ
wqnrWA/9GhcVzoaIjvbmUQzy+zr2Nk6Aq4p/oQ0kx1eULMEfKkCH6/Z/elTB4GDD
H3hcZ+CDec1aO9QZo7ph7bCCDsvB35LQAZ0A577otixP8Nvqt5NtMl6d6hOraZt8
k9GJD1HVWqpSX2wXmb5rFnyjEM3hh96RvN/N7teDGY490U78ZK3YaUYxfMz1jbke
TsIu0dM50MjtDm1I2AC0+bTkgIPmuMQGnb+IgYYo5sOwA0DLRQelqCd7bE2uNvX+
k6P3ZK0MyvmSu1k7e2ZJYfy6Tpgb1JhJ5+8QAG06GGYuuSWASr1vYcbPfWHlcEP5
pZ9+xlIGevYolAX5M+LL1v4Q41zivb9iRrfvj1sd11rkJ5KwqgllYlbjTWky13fT
OMJhSHdrJatOHxLY4lTV/epmSbL+nZN7Ho2gZcpPtAYC0kB35wEWqklDRyxZ0BHV
rtV+E2kJiZgMNRS8ZDrH0G5g69PJytP9NYH1+AYEqV03P5UB28mq6L4L+Mghs8Tp
Srp7fwWmXArhUfhWwiF2y4FCJSaNT9JxbfE6NUudfYMJGfJWzUeUtGpGoVET2BtS
FXrVs3MNCOisOWCcsJIGyNtG6QkBStxZNlyQo6fP12W9G0FC9v8XCvbH0yhicErk
nOV98oh4CWuWkCFRsOZhaHso7nbZi/R17ORJ328VHIom/c8cl2o=
=QH3n
-----END PGP SIGNATURE-----

--rqz2sg4sh37j4buv--
