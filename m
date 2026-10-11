Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7FA25228D;
	Sun, 11 Oct 2026 17:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791738399; cv=none; b=j7m2nM87q/kNj91wNJ9baFeF+FOh520c4lYZFgcrZqkGX8gw68LIgLUEJat3/xornqnUePDF9+qBFzUtWiPTOoKd5n9m5nXulRUxZdrJQ6u1a/NpmDQFI5sW+UZ+5NiZd+foOd5bvWvkCgSxJVQtgBzFQMx5izn1isr9O47hbks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791738399; c=relaxed/simple;
	bh=eyJdnrqMafxUGVdi8qRCkTqeRrwpRzv8KW4MzoYzWgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0RYLQSU6igeqL6pa+aaHtbQnW0w7SuxPLj05iHZ6FB+Bk+zsedWhJ8NE+x2yVPQKmY/W2EuLp9h65G/FwQUuJu8I/GUr9IeTrclaDzIFrHWeAhJnJAEkqcFZZ2yeqcH0pafn0vWrloj5TzGeIRwf5586xo+EvCtJ0UR16ILIm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kPMAO9y5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kPMAO9y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7F21F0089B;
	Sun, 11 Oct 2026 17:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791738397;
	bh=Lb+Cymi2/MzaxYkS/UKlF/tR6jp9c8Cmm2shKZ/qh4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kPMAO9y5jEbrHAyJFmnZXX2TxqDQk29oi/0ajd1AsRsFAxKCHgesbLrdj3sPwQXxw
	 Wx76WUCDTYT+wtH7mbr+v/fJfAJR0aUdY6sQmC0Dk8GcsqYU/aQiPkdakFyYK0rpYX
	 uS7cPwwmyzkaUOJ09LLLBS8/5Czx2XVhXmEN058OOJugVHePHRwBKGWG6nMMC3Au1U
	 whTh1qslkHmC3Xisvo5s0KYQ25heir13DBLM2D26u00PvNJOWUEnBeRzbQrekGbZ37
	 cqAG+drxqtgTbxzxiyON8tdJiD0i5TIJv4jCxtxYAe9YFdfULrTzd58LDg2y9mQIAb
	 Nt70SEGQqFhHw==
Date: Sun, 11 Oct 2026 19:06:32 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	djwong@kernel.org
Subject: Re: [PATCH v5 2/3] man/man2: introduce man page for file_getattr(2)
 syscall
Message-ID: <asvBPbDfCIVm71jg@debian>
References: <20260916115141.3500780-1-aalbersh@kernel.org>
 <20260929130234.3547891-3-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tnn6ka6oooda2yt2"
Content-Disposition: inline
In-Reply-To: <20260929130234.3547891-3-aalbersh@kernel.org>


--tnn6ka6oooda2yt2
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	djwong@kernel.org
Subject: Re: [PATCH v5 2/3] man/man2: introduce man page for file_getattr(2)
 syscall
Message-ID: <asvBPbDfCIVm71jg@debian>
References: <20260916115141.3500780-1-aalbersh@kernel.org>
 <20260929130234.3547891-3-aalbersh@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260929130234.3547891-3-aalbersh@kernel.org>

Hi Andrey,

> Date: 2026-09-29 15:02:31+0200
> From: Andrey Albershteyn <aalbersh@kernel.org>
>
> Add manual page for file_getattr().
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Link: https://lore.kernel.org/all/20250630-xattrat-syscall-v6-0-c4e3bc352=
27b@kernel.org/
> ---
>  man/man2/file_getattr.2 | 262 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 262 insertions(+)
>  create mode 100644 man/man2/file_getattr.2
>=20
> diff --git a/man/man2/file_getattr.2 b/man/man2/file_getattr.2
> new file mode 100644
> index 000000000000..e3c86fc45711
> --- /dev/null
> +++ b/man/man2/file_getattr.2
> @@ -0,0 +1,262 @@
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
> +of the file
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

Is there any difference with openat(2) regarding the handling of 'path'
and 'dirfd'?  If not, we could say:

	The
	.I dirfd
	and
	.I path
	arguments behave in the same way as in
	.BR openat (2).

Is there any small difference, or is it exactly as in openat(2)?

Other than that small doubt:

	Reviewed-by: Alejandro Colomar <alx@kernel.org>


Have a lovely night!
Alex

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
> +The size indicates the version of the structure in use,
> +and should always be specified as
> +.IR sizeof(struct file_attr) .
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
> +instead,
> +get attributes of the symbolic link inode itself.
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
> +Unknown flags specified in
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
> +does not exist.
> +.TP
> +.B ENOENT
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
> +is not a directory.
> +.TP
> +.B ENOTDIR
> +.I path
> +is relative and
> +.I dirfd
> +is a file descriptor referring to a file other than a directory.
> +.TP
> +.B EOPNOTSUPP
> +The filesystem does not support getting attributes on this type of inode.
> +.SH HISTORY
> +Linux 6.17
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
> +.\" SRC BEGIN (file_getattr.c)
> +.EX
> +#define _GNU_SOURCE
> +#include <fcntl.h>
> +#include <linux/fs.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/syscall.h>
> +#include <unistd.h>
> +\&
> +#ifndef SYS_file_getattr
> +#define SYS_file_getattr 467
> +#endif
> +\&
> +int
> +main(int argc, char *argv[])
> +{
> +    struct file_attr fa;
> +    long ret;
> +\&
> +    if (argc !=3D 2) {
> +        fprintf(stderr, "Usage: %s <filename>\[rs]n", argv[0]);
> +        exit(EXIT_FAILURE);
> +    }
> +\&
> +    ret =3D syscall(SYS_file_getattr, AT_FDCWD, argv[1], &fa,
> +                  sizeof(fa), 0);
> +    if (ret =3D=3D \-1) {
> +        perror("file_getattr");
> +        exit(EXIT_FAILURE);
> +    }
> +\&
> +    printf("File attributes:\[rs]n");
> +    printf("  xflags:     0x%w64x\[rs]n", fa.fa_xflags);
> +    printf("  extsize:    %w32u\[rs]n", fa.fa_extsize);
> +    printf("  nextents:   %w32u\[rs]n", fa.fa_nextents);
> +    printf("  projid:     %w32u\[rs]n", fa.fa_projid);
> +    printf("  cowextsize: %w32u\[rs]n", fa.fa_cowextsize);
> +\&
> +    /*
> +     * Try setting NODUMP flag with chattr +d ./foo to see
> +     * the difference.
> +     */
> +    if (fa.fa_xflags & FS_XFLAG_NODUMP)
> +        printf("  NODUMP flag is set\[rs]n");
> +\&
> +    exit(EXIT_SUCCESS);
> +}
> +.EE
> +.\" SRC END
> +.in
> +.SH SEE ALSO
> +.BR file_setattr (2),
> +.BR file_attr (2type),
> +.BR ioctl (2),
> +.BR ioctl_fs (2),
> +.BR openat (2),
> +.BR ioctl_xfs_fssetxattr (2)
> --=20
> 2.55.0
>=20

--=20
<https://www.alejandro-colomar.es>

--tnn6ka6oooda2yt2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrLwhgACgkQ64mZXMKQ
wqli8xAAoBkCEUZEyPbdEHWrfW5vNFAzl9D5NOZfEahywCR866rToaJcj84Yo5Ce
KDaNx91otDFfjUeN+/pwEO+0QtxvSlL1Eeq+7ZwmI9e39EQfszceJdpZc3GWZinH
h7x4o5DtagKREod2CcEv4A54uTRsWjEhnpDdOQadJrFZagfvSzsIdu3BoTzHWPi5
iyf+s5tgYEih+gMnftxYN0rdeCUZTHTaG+JNr9iARdvC/0BSZ4ofvpNO5V9nkVVx
t8bfuxEIKbuDtI41+M655+qXRQbfRD3KYN4AXtf+JL3GizaXi+ub7HKs2OeBa1p8
zNSjrQODDdAb7DcvgTImAc0vkd2+xl6waTis1Xtj9CzIFPxyVckXsxn7Lwte/FM6
cbmEROCJcRJkexskZ/rcwiFNBRY8+TKGGtIeMryzwK1Q6+k/FPiqboGdCwonISeA
mf2AimX2fKvaz2RMJCrgFENPH6Gi9LxF/1x9l1Mtv/nt0L+pCGNXmgK9JlNsH2o1
/TieBckYbfVDHqWDMh9+5MhD/sonSBislLWP+FDLd2V7xTaI4QgJ8kwUqjgmpndU
jsJBTTvkp4syLcSGuN9DbdGTEjO6iHZoci+NRJLGckcSUP1IMx6US6mqzzrqg3Jf
lIg036fVQ208vULD4qHv8PE53U8gm3AMrwrHjsIXCrrPHi9/mS4=
=foun
-----END PGP SIGNATURE-----

--tnn6ka6oooda2yt2--
