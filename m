Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792754901;
	b=QUOmSSpN3rnJPzNa8ThF5KGkCRqT065D6ztKvedt/KSi0RdULZUThEJ0z+W4dgQEvBmk
	 0dvD5qTTHt5dun7bh+7cMV9QcA92VOGn5zS2vsDmVFpttNAscSOoP6MDXNuyCcbtj3H4I
	 EMkgCeMAglg8Ya+JuQWe/2iXmCpdldEjGPjr3xUlGWf68nJhYBuHu1qGP9OapavxE9x9S
	 Dbc9gzarVh7G0LF/tZqTnSY7Uhv806TR1k9L6NzT1VodM1VGfkJQBETQ2/lCoxNnC5IYf
	 wC0NCujkNwFf57eMJRQ91GONnsvEZcmrfeSKlggVsYxht1IzGGRXZF1VJD29A1pPByg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792754901;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4KzbfWb4R5EF9vQndbPyhzkZkHPodQ4prV025x9/ldo=;
	b=AijFimZOJWbQFW/T4tH3rSpJCDqyOT8GlVnEvL8dOvJrZPjkneM/h2qOPZU/W6MRIpc9
	 JPecSgV1BwtuDTKLtXoAnpdK2e1p7g8I6ZkdctyJE6othLd9Yge0YAwo3pTThTg13dsW4
	 y1c/YDcPohBz3o7XFesHQpnvBuYGS1V7481PsBKOB5zjxPPgxV6ps4bXycFdYFD9RZhj9
	 pUKhoG++8sLJLEo+TJPWypRIaCyPwGHn/Y9CI34xy5lWQnrL7gRAgMSaFICFTonabaJDB
	 VTz0IXaGOTUdqPdD9HdRChYpRUnzFXpzLIhWiuV4jmqeoq08Naf6604saf3/LDsbTgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kKGPAaof;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD9C606A31A;
	Fri, 23 Oct 2026 11:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kKGPAaof
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04ED1F01825;
	Fri, 23 Oct 2026 11:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792754900;
	bh=4KzbfWb4R5EF9vQndbPyhzkZkHPodQ4prV025x9/ldo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kKGPAaofBrEX7ssLlFpzdZw3es7F0Zv/mPcfDWbhJhFaUcg/SCeBw9GLn4abp+5hD
	 nTWKoDrbvJqwjAQ0hMn62gCFhAmCiYRJSAsi+AtQgM2APlcILhrMbQMs1r7yQoiPAA
	 rXHiFbZ36uObjTepfLoo74ryNPGF3+a+ukmv53FCOXrVd9AGdOs4QfE3Uehz1yJ6ck
	 mYFivhGed/lsICkoBuikZJKTdw+ulAxxXvFER1mtALtgQN5DkqW15+QfOvZTaQdpmx
	 9UMz7N0EtQ6S6KEpxShco6Fza1eEtmBFsjX+rAdcHaPawuLokt8AXmABDXDjtG+BmH
	 MsDzshzGMrs+g==
Date: Fri, 23 Oct 2026 13:28:11 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 1/2] man/man2: introduce man page for file_getattr(2)
 syscall
Message-ID: <attEnAMmcV2YuwtN@debian>
References: <20261021141010.314835-1-aalbersh@kernel.org>
 <20261021141010.314835-2-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="544li3fyfgezh5tt"
Content-Disposition: inline
In-Reply-To: <20261021141010.314835-2-aalbersh@kernel.org>


--544li3fyfgezh5tt
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 1/2] man/man2: introduce man page for file_getattr(2)
 syscall
Message-ID: <attEnAMmcV2YuwtN@debian>
References: <20261021141010.314835-1-aalbersh@kernel.org>
 <20261021141010.314835-2-aalbersh@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261021141010.314835-2-aalbersh@kernel.org>

Hi Andrey,

> Date: 2026-10-21 16:10:04+0200
> From: Andrey Albershteyn <aalbersh@kernel.org>
>
> Add manual page for file_getattr().
>=20
> Link: https://lore.kernel.org/all/20250630-xattrat-syscall-v6-0-c4e3bc352=
27b@kernel.org/
> Reviewed-by: Alejandro Colomar <alx@kernel.org>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Thanks!  I've applied the patch (with very minor tweaks in the commit
message an the diff).


Have a lovely day!
Alex

> ---
>  man/man2/file_getattr.2 | 252 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 252 insertions(+)
>  create mode 100644 man/man2/file_getattr.2
>=20
> diff --git a/man/man2/file_getattr.2 b/man/man2/file_getattr.2
> new file mode 100644
> index 000000000000..9963eeaa7caf
> --- /dev/null
> +++ b/man/man2/file_getattr.2
> @@ -0,0 +1,252 @@
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
> +The
> +.I dirfd
> +and
> +.I path
> +arguments behave in the same way as in
> +.BR openat (2),
> +with the difference that
> +.I path
> +can be NULL meaning an empty string.
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
> 2.56.0
>=20
>=20

--=20
<https://www.alejandro-colomar.es>

--544li3fyfgezh5tt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrbRMsACgkQ64mZXMKQ
wqnYSg/8C3uP8izC0yO8ulYgq2QII1Fx6GtDZM2RzUS5nbltbs3B6TQ+qygT2EII
ziOHSjXT0ZWFNG8xqjTTOt2DUv3j+GlE39idwNwDuBSvA7xiCfF7u7rVqlEdg1HE
GNh/MJjVS5Y7oEldxPHDBeeK6JJifXiJMfaLGbYawQFMJYHarXWv59vUjskbe8D7
0Hr4sPBax6iAmAAGhBdcDsK47I4zlej+VRsOkOU1vqHoJjmhtMekPEanrKlXKhBZ
QVfuX925iv7x/fDqonc7sCVbnoFu/CRTwV3J5nuyN9TeN3t2ISSlc38a3A1bzB05
kkeSUg2IauZqgn5lN26lGaWePUCMToYKkDtmd8WCP/BYBXkKjJiQJv0buQxyv5Ed
oVXe87WxwZT1ulzJYcnMH5gQPsRfr0YC8yowwFKCH5UTKdu1I3Hz4Ivtx3KBj1Mm
52X4Kd4F30bMYM0HsE1coCQy48chzyVoCNh3YYFN9rUOzhTyDK4iDm3a+pFmsCAL
br6EYUbmmxI3fSmuJ2YHILh4pK3CeV7r/gcIqyZSP/vaWLbE+85E/6xVgE5pHl6A
+qTqXaEDyiuL07Q0cPM9A11GwJOuvWXSJLKk9oOJbD2YSD/cdNkorGjqO36BX1j2
ncQfr73e8VIszvaxfDMRZgRckmGXSSRjXzcK6ge4sYeUjlRwjUs=
=BQwW
-----END PGP SIGNATURE-----

--544li3fyfgezh5tt--
