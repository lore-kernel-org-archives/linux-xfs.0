Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1174746D572
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 12:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789129767; cv=none; b=Ca4yEOH6ioh6QdbKGQyNOX1ogeaYWmT3D9wicB68b/iv/cTShHvUV/mMGQWQM2Fn/l4hDws8Ilg0nlfPMxjHnLTbbqUApmKJRkiVjwJMlDDe+lvYhgrXeALhY9GD4nVeB0LKzyIPth99iqhMEZLPsyqY6C48aVNGvh7mKMnLDNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789129767; c=relaxed/simple;
	bh=T3gwrRxJh6Cy97RaI3Cf7lL2JE9EXNvDLhEQKn44Mmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aFHnTCusVCAOKyhrgQfbedaUJfC97vduGSJoyR+PsfB2uZxQ4i03GxQPscFvVZDkgMfvfcVRlYCy/Q2evIJ4m+dU5Qvg94WhPe2l8j3AadJuMXLFchyJg4ElspTQgO/AOFmmWjZICwbpV7HG2GoextmSInWQF7Q9JnYBMcus1Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=heTBO3fQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="heTBO3fQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E311F0089A;
	Fri, 11 Sep 2026 12:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789129764;
	bh=cpzZ2ANgZedef8K8wqKxpGMje/v4n2y0z60TAeNXQdw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=heTBO3fQiHpZ6yuhL8qaJTWRk4+jmHVx+1R6a3lE13jeS5DGzRaGhA0wwv93ODYfW
	 RKtW0auX2IlRwbksN9RwGwTg+wxkm3Y/F71RbgV7Y625S0VnKtrhufH8zoLJTfOpYN
	 +2E5bRttVX5HEVy/CsRWu0DJgnIx1LugCJPAFVmh6kL35riA3TgULrtVkPNRCb+2CZ
	 4zLfZahGhX4yzwQ4eCosdG4OtY8Rc2nMQK1lQMF2kSZI/HL5+7qOaUSZwEsG8PG/CM
	 SX1ulh9mAWu7GwjofRBYmLL3XiEudPWXzAttJt0nMD+ZYdFAp6CtQrwYYMSiun2s+T
	 +9XubCygSYqKw==
Date: Fri, 11 Sep 2026 14:29:21 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH] man: document that XFS_IOC_FS[G|S]ETXATTR can not be
 used on special files
Message-ID: <aqPy-NvMiHD9Vemb@devuan>
References: <20260911114746.343945-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xkovro4qd6lx23iv"
Content-Disposition: inline
In-Reply-To: <20260911114746.343945-1-aalbersh@kernel.org>


--xkovro4qd6lx23iv
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH] man: document that XFS_IOC_FS[G|S]ETXATTR can not be
 used on special files
Message-ID: <aqPy-NvMiHD9Vemb@devuan>
References: <20260911114746.343945-1-aalbersh@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260911114746.343945-1-aalbersh@kernel.org>

Hi Andrey,

> Date: 2026-09-11 13:47:44+0200
> From: Andrey Albershteyn <aalbersh@kernel.org>
>
> Add a CAVEATS section with an note that these ioctls can not be used on
> special files and leave a reference to an alternative pathname based
> syscall interface.
>=20

Please add:

Cc: Alejandro Colomar <alx@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>

> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---

Thanks!

>  man/man2/ioctl_xfs_fsgetxattr.2 | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
>=20
> diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxa=
ttr.2
> index 25a9ba7965d1..5d223138e419 100644
> --- a/man/man2/ioctl_xfs_fsgetxattr.2
> +++ b/man/man2/ioctl_xfs_fsgetxattr.2
> @@ -238,6 +238,23 @@ Caller did not have permission to change the attribu=
tes.
>  This API is implemented by the ext4, xfs, btrfs, and f2fs filesystems on=
 the
>  Linux kernel.
>  Not all fields may be understood by filesystems other than xfs.
> +.SH CAVEATS
> +The
> +.B XFS_IOC_FSGETXATTR
> +and
> +.B XFS_IOC_FSSETXATTR
> +.BR ioctl (2)
> +operations require the user to open the file, but this may not be possib=
le or
> +lead to side effects on special files such as FIFOs, sockets, block devi=
ces,
> +character devices, and symlinks.

I'd recommend that this project should use semantic newlines.
See man-pages(7):

	$ MANWIDTH=3D64 man man-pages | awk '/Use semantic newlines/,/^$/'
	   Use semantic newlines
	     In  the  source  of a manual page, new sentences should be
	     started on new lines, long sentences should be split  into
	     lines at clause breaks (commas, semicolons, colons, and so
	     on),  and  long  clauses  should be split at phrase bound=E2=80=90
	     aries.  This convention, sometimes known as "semantic new=E2=80=90
	     lines", makes it easier to  see  the  effect  of  patches,
	     which  often operate at the level of individual sentences,
	     clauses, or phrases.

However, I notice that the project isn't using them, so it's up to them
whether they want it for new documentation.  I'd recommend using them.

> +.P
> +For a pathname based interface see

s/pathname based/pathname-based/

See <https://www.grammar-monster.com/lessons/hyphens_in_compound_adjectives=
=2Ehtm>

Also, s/see/see the/

> +.BR file_getattr (2)
> +and
> +.BR file_setattr (2)
> +syscalls.
>  .SH SEE ALSO
>  .BR ioctl (2),
> -.BR ioctl_iflags (2)
> +.BR ioctl_iflags (2),
> +.BR file_getattr (2),
> +.BR file_setattr (2)

Other than those minor details:

Reviewed-by: Alejandro Colomar <alx@kernel.org>


Have a lovely day!
Alex

--=20
<https://www.alejandro-colomar.es>

--xkovro4qd6lx23iv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmqj9CEACgkQ64mZXMKQ
wqnWyg//aiijxW1QTtphujsXmrTD0W49wGoF2Cd5bcGRNHQ3K0A3TwA4dtRyshV4
pJM1aU1AhhXVyAErXgBjkJia6y2rO+TYvCgCdKNnvXQRlhmYamSB02ffn5Q7hJNK
AT4KECrRDO9QG0Soah8wxKiJ+WS3pHRE+MYu90t+cuE4+cBdULnMb9n3neICEa5A
W8odiq+QGWQNL2CaTh3tV/WHD3l8uubKv0bHd7y0R7BxC6/9bQdio6hg1Wr6Odgh
y8f6D5LFZxCGQsxLAVq8XW176Pc7drf2UNCeDo8QNEz4fa1j5ovmgWqPyUehC2FV
fBwPl63P33Q09co79x/3TKg+v7dTEOSEhjmCvReiXfFfOHBRneoQniwwUXeTBvOF
98q8oW7+RzP7LtbOjKoD2HOOaRXKYgSku6KFOydi0U7BUIOCPLkJR8nCT/RaSlM/
rAiP5yysm+61L13w6au/y/3/zDiesYOd4Slf/Ud55K+v5j7pBIaVn3uJvSJutPlG
6cZwMIMsdEXpr3DgMeZZUDql1/ufQTwirth+uY+jMXkaxr0R/grEKHx5oqv9li1p
w8etLnAAJXdRUDumadowlxslCFFHSZaqFmZsMCFyEx3UhINoB7H23on8x4ow9ha1
vD4DW7udZW8l7wwGYqtIqBnPFGO62lahzHOtmkgk0JZQFxqTV9M=
=3gSY
-----END PGP SIGNATURE-----

--xkovro4qd6lx23iv--
