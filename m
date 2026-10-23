Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792763795;
	b=ll9pUf3eS4NUpK00XiJg89CuA3lZmoeY0U29OG6dsMi+sV/gACAfNtSkLAeJRaQ2KG/O
	 uv2EDXSv+FthY0iv0X79pmCv7EoM082xstkLpMwH+txAKf15qQzKozK9Rf5dhFU5wTPl0
	 yQXR6dlD9Audwwm7BErjpion+XuLzY9zDWL7rRtLdIxCulvbGkFbDTSuQm2JrKNTXvhYb
	 efHprDJtQnUbQu2POsboptUZwX55+ac15dlX9us6Ea6CadS9Ld1nHQ+HpQOUp6QN76PbB
	 xA1UbqN1N4KmkoVTdauy3vc0lyngbmllLgnneExuBEvAVjwhB6lhVQjrZXysF//Wu0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792763795;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=lIJyEq8ZKuIwJ9GhjyFiU/zdqQFZt2seSEYMO8dYYws=;
	b=rqDwYH1wanwLsrhCIVdqWuNpNkj4kgkgTySNuAI+CWHPp1Eh4B+jRKgxVdEWuDM2p++u
	 xLkeeCnzGfupxMCwzdFursQ8a3VuBmKahS2CUxFLjMoZL1nlnkE3mOzpeXjkFinocFzAh
	 nPhSwQwE4JTorsSG4hCVJagRU6lj/O4tZFBpwnYWme3w4pMT4CvvF/70gjr0WpPK03lOg
	 JA9qKQrFOmDRNSX7U47dzZFplDrtae55YBHXHQMecGUHbvWJeJ1s2ixN7FiuoVn+o3nba
	 DEYFRXLUWmaAU6puoU3C9FixeUq2jVWrJs9RcA/C4QHtP4672iQFuQGDNmEI2zgqqNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MPB1CMTS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC35606A31B;
	Fri, 23 Oct 2026 13:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MPB1CMTS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3EA1F01825;
	Fri, 23 Oct 2026 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792763795;
	bh=lIJyEq8ZKuIwJ9GhjyFiU/zdqQFZt2seSEYMO8dYYws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MPB1CMTSu4zCHKYvwWZBFqExMatWRRpkb16SY8XSpHTd3Ozd1PdRtZPLUfXdjguYi
	 dvdNW2dCmykiljYG8gKy6ZIEcO5ONl2y1u0TL7RkRTCKQllycezL9oSzkgFqGEDJ2s
	 boSp8scc5dsiM0JHucAq2B8OBsV+m9NxCXx8bZ/DE12IerpVVbN+ZsVxkrocETfiG9
	 XqgvX72CLJ35n/Qus5aFYwq5no5/tL+7tXsPlLzygY+E952GLJlAkrww69YYEEWrUl
	 9a3GZeuNO/BWOY0hpy1asVsGRez/xgL80nLRD6QdvU2RynOVIWXgoH07/qQqOPnqOJ
	 pF7PRQ64Ywtpw==
Date: Fri, 23 Oct 2026 15:56:30 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 2/2] man/man2: introduce man page for file_setattr(2)
 syscall
Message-ID: <attnd98FtIIuGYA-@debian>
References: <20261021141010.314835-1-aalbersh@kernel.org>
 <20261021141010.314835-3-aalbersh@kernel.org>
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
	protocol="application/pgp-signature"; boundary="6lplldpsfphxly7c"
Content-Disposition: inline
In-Reply-To: <20261021141010.314835-3-aalbersh@kernel.org>


--6lplldpsfphxly7c
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 2/2] man/man2: introduce man page for file_setattr(2)
 syscall
Message-ID: <attnd98FtIIuGYA-@debian>
References: <20261021141010.314835-1-aalbersh@kernel.org>
 <20261021141010.314835-3-aalbersh@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261021141010.314835-3-aalbersh@kernel.org>

> Date: 2026-10-21 16:10:05+0200
> From: Andrey Albershteyn <aalbersh@kernel.org>
>
> Add manual pages for file_setattr() syscall.
>=20
> Link: https://lore.kernel.org/all/20250630-xattrat-syscall-v6-0-c4e3bc352=
27b@kernel.org/
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Hi Andrey,

I've applied this patch with some tweaks.  Thanks!


Cheers,
Alex

> ---
>  man/man2/file_setattr.2 | 183 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 183 insertions(+)
>  create mode 100644 man/man2/file_setattr.2
>=20
> diff --git a/man/man2/file_setattr.2 b/man/man2/file_setattr.2
> new file mode 100644
> index 000000000000..b11c9ff9277f
> --- /dev/null
> +++ b/man/man2/file_setattr.2
> @@ -0,0 +1,183 @@
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
> +.BI "               const struct file_attr *" fattr ", size_t " size ,
> +.BI "               unsigned int " flags );
> +.fi
> +.SH DESCRIPTION
> +The
> +.BR file_setattr ()
> +system call sets filesystem file attributes
> +on the file specified by path.
> +.P
> +The
> +.IR dirfd ,
> +.IR path ,
> +.IR size ,
> +and
> +.I flags
> +arguments behave in the same way as in
> +.BR file_getattr (2).
> +The
> +.IR fattr ,
> +is read-only argument with
> +file attributes to set.
> +User-space applications should use
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
> +.\" SRC BEGIN (file_setattr.c)
> +.EX
> +#define _GNU_SOURCE
> +#include <fcntl.h>
> +#include <linux/fs.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/syscall.h>
> +#include <unistd.h>
> +\&
> +#ifndef SYS_file_getattr
> +#define SYS_file_getattr 467
> +#endif
> +\&
> +#ifndef SYS_file_setattr
> +#define SYS_file_setattr 468
> +#endif
> +\&
> +int
> +main(int argc, char *argv[])
> +{
> +    struct file_attr fa;
> +    int dfd;
> +    long ret;
> +\&
> +    if (argc !=3D 2) {
> +        fprintf(stderr, "Usage: %s <filename>\[rs]n", argv[0]);
> +        exit(EXIT_FAILURE);
> +    }
> +\&
> +    dfd =3D open(argv[1], O_RDONLY);
> +    if (dfd =3D=3D \-1) {
> +        perror("open");
> +        exit(EXIT_FAILURE);
> +    }
> +\&
> +    ret =3D syscall(SYS_file_getattr, dfd, "", &fa, sizeof(fa),
> +                  AT_EMPTY_PATH);
> +    if (ret =3D=3D \-1) {
> +        perror("file_getattr");
> +        exit(EXIT_FAILURE);
> +    }
> +\&
> +    printf("Current flags: 0x%w64x\[rs]n", fa.fa_xflags);
> +\&
> +    fa.fa_xflags |=3D FS_XFLAG_NODUMP;
> +\&
> +    ret =3D syscall(SYS_file_setattr, dfd, "", &fa, sizeof(fa),
> +                  AT_EMPTY_PATH);
> +    if (ret =3D=3D \-1) {
> +        perror("file_setattr");
> +        exit(EXIT_FAILURE);
> +    }
> +\&
> +    ret =3D syscall(SYS_file_getattr, dfd, "", &fa, sizeof(fa),
> +                  AT_EMPTY_PATH);
> +    if (ret =3D=3D \-1) {
> +        perror("file_getattr");
> +        exit(EXIT_FAILURE);
> +    }
> +\&
> +    if (fa.fa_xflags & FS_XFLAG_NODUMP)
> +        printf("flags 0x%w64x (NODUMP flag is set)\[rs]n", fa.fa_xflags);
> +\&
> +    exit(EXIT_SUCCESS);
> +}
> +.EE
> +.\" SRC END
> +.in
> +.SH SEE ALSO
> +.BR file_getattr (2),
> +.BR ioctl (2),
> +.BR ioctl_fs (2),
> +.BR openat (2),
> +.BR file_attr (2type),
> +.BR path_resolution (7),
> +.BR ioctl_xfs_fssetxattr (2)
> --=20
> 2.56.0
>=20
>=20

--=20
<https://www.alejandro-colomar.es>

--6lplldpsfphxly7c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrbZ40ACgkQ64mZXMKQ
wqnfYA/+M1RS8G+Fb54XK+3BeSdRr1wQ7l7BiSa/aYW+J4IAfYIggc7wF+5The7a
qTkeRYSTFVtXjjEkkDfU/Zd54kjegSURkzdN5jjBYx4WHhE7VTqY4r0YrnwwF5D2
jl4aK6MkHJ4MdXRVskEsE0sCX/yQn2+gY7TWGv6+J0JDbGe2zBgrpp/L8AvkBB+w
ReLGG4RG/ntJb22cusjYEKHiSaSpV5xP4KH0IxviJLKkqi4R0k+YMietwUYhSNlO
xUB8NSUgam55jm3uAr/lnfZUwEk7BvEJX7wRuFwD1qictgKamVnfd/XzzByqf+lQ
TwEMz9rcNfkuraeftG1dIPUJRdVRBA0KwQPGgHlOHmIwnx2d+7hEHXEAC0efZLD1
nZ11iGql30ikBZ7hWdv1tG7tZQbCnmu86FEQhro2xtQa1YOKN4bDRmAp7ql7aZgD
Y5jwubN4cWrA0QP2qM8Z6Ihq7ng++mdRvlttqI5im6lmYCZ/7DPCH9xNyLPvAT9c
We6rT0GIV68aBXYYYAgckYwi3SW1uggyR3gSW8cLydhmyvc8sHzPoyw2lznl4SE8
Y6w2kCD9U87KIW310D73g3PNlDF3j5Z8HObd/1iGvwlDVy27CDWFAmPhp9qAClDU
ppP3o0RsyzfY8zYbOp0DRUUaePBi9OVCBNX2hjUEV2LYIH1H710=
=FcUn
-----END PGP SIGNATURE-----

--6lplldpsfphxly7c--
