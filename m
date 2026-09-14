Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D64B3C3432
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 11:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789384398; cv=none; b=JberfcifdjQAOo+9UFiht1HCFNjQGgj/MzoE40nQxJF3r0D8WkC8EiymkqSrtcP4JobAUMm4PpQqgZ+C+I8kWRj5inaud83w4YrQP+27AI7PSHavP3hj203WdBtDP9Qony01x/YqGF1XrpJk2nCI4WKg4BBH/XEAK3N6FjFI098=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789384398; c=relaxed/simple;
	bh=uBNI3g009Lb/Z17XD4dhYQOWJmGvmxC/1IDK2vf/eU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bowOZKQLtaJdJ1i+C/+nCOmJf23pWMYbstzk2JpVwXP+f0ORgTC35YZojVxy/xYnOXshznvjBHB57NAwZpYu1shzSNaIQ047jduC4HadhoY3p6gqRNktghlTc+HGGaG6sP2yXswv18PiktiMK2g+22PgF9Trvn53t+W7sFIDPEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wq146Fpu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wq146Fpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3819A1F000FF;
	Mon, 14 Sep 2026 11:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789384397;
	bh=WemTGF9iyxbTABE7c6Y0LJ2rwWzCXDNob2vioSX7oKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wq146FpuGz9/vyZOt+t741KJJ/CLm45A1tvvSrv/1kG6nBGQhUTthndeF1HUB5+3F
	 oJ4WzCPhOYXCO/CVVG2ANwBTj5Qa/N+UKFJRCUz3U1qIp+xu5qsWhYTiCzzZ5vh8hc
	 89DhK5gpvodTjW+uhd84KQHo/h2nOec7VyocIop1gOeAOoZSosVzF8PqEj2uAAvd8Q
	 Hkih4ILx6xfEMaFc9eEnfJJVBFmzn1sFwIon8X7p2zwon5kZRznnd03zfttEMYKBb0
	 4InEd9u4i3+DFjDEbgn/g0rZ/6fE1NVUjv5kNBCaKxHyJWYmMYbszpidC03mwrcgv3
	 PJpyvhOMNuapA==
Date: Mon, 14 Sep 2026 13:13:13 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v2] man: document that XFS_IOC_FS[G|S]ETXATTR can not be
 used on special files
Message-ID: <aqfWdytgDSDDB2Cs@devuan>
References: <20260914104750.1727589-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="a4szdht7c3v4b6eb"
Content-Disposition: inline
In-Reply-To: <20260914104750.1727589-1-aalbersh@kernel.org>


--a4szdht7c3v4b6eb
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v2] man: document that XFS_IOC_FS[G|S]ETXATTR can not be
 used on special files
Message-ID: <aqfWdytgDSDDB2Cs@devuan>
References: <20260914104750.1727589-1-aalbersh@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260914104750.1727589-1-aalbersh@kernel.org>

Hi Andrey,

> Date: 2026-09-14 12:47:48+0200
> From: Andrey Albershteyn <aalbersh@kernel.org>
>
> Add a CAVEATS section with an note that these ioctls can not be used on
> special files and leave a reference to an alternative pathname based
> syscall interface.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Reviewed-by: Alejandro Colomar <alx@kernel.org>
>=20
> ---
> Changes from v1:
> - Use semantic newlines
> - pathname-based
> - RvB
> ---
>  man/man2/ioctl_xfs_fsgetxattr.2 | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
>=20
> diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxa=
ttr.2
> index 25a9ba7965d1..db5eb232319e 100644
> --- a/man/man2/ioctl_xfs_fsgetxattr.2
> +++ b/man/man2/ioctl_xfs_fsgetxattr.2
> @@ -238,6 +238,27 @@ Caller did not have permission to change the attribu=
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
> +operations require the user to open the file,
> +but this may not be possible or
> +lead to side effects on special files such as FIFOs,

I'd break the line before 'FIFOs' too.  Since FIFOs is a member of a
list that follows, it should be treated like the other elements in the
list.

Other than that, LGTM.


Have a lovely day!
Alex

> +sockets,
> +block devices,
> +character devices,
> +and symlinks.
> +.P
> +For a pathname-based interface see the
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
> --=20
> 2.55.0
>=20

--=20
<https://www.alejandro-colomar.es>

--a4szdht7c3v4b6eb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmqn1skACgkQ64mZXMKQ
wqkQ1BAAk9qvUy7emGM7fsP/VrZQ01PQ0UMmpE8CPZao3Cq6BbRhc+2TN/cwFe45
TEaJsbYaDUuknh4DP19KWKMlEoe84voWjaM+odx5LwmekpZhEn91NjE6qH7gZNtX
nTTmxjE3OVKhrvXb81J9k99tu6TRp6tTo4ZISTmFwY7O6ZYmoIScSCAuyxIUnKjF
4mtHelwnj++UovntKMOMQMDej2v/0E9Tva4/kGbl5IYXGhkBwqw2Z4xD090FtCaU
iVZ0AhcKTJZRjN02TFHjVmM7v3EymAiSejoClD8j/j7pdpIimrtgr/EYdhU49DKO
g4Jp4SwkZnwsC45v8fwbpGYGUJ2BZx/UHgux0rhDLu3UFC3jAOUI7zRGw+1E5CUR
Fne4kjSj9Xbk18SaliCi52QGvWyYdwj1vV21P346peJxcwt9ee78hq4AW8QuaW7q
2wa4FvGarxTHSCuJbnKOyJLeC7Kqv1ToEcRt58zvMVzXmEO2idauaBTbMz4HGZMN
RX8InfFnHkiQ6YXdmRoWXKodfcr7DOC/TPu1mp4dqXpsnhTJR29RFQMOXmxeLhRk
XzEEJes+yiUCYduqTYbzieaGRDSfh4hEKCEbMN+n3L73daH26kDnzPdMmWV5k52m
I8t4BhlAIwtZI/KblYVh01tttgVIoT8QiQiCiGwGmjR42/n2ack=
=dq5D
-----END PGP SIGNATURE-----

--a4szdht7c3v4b6eb--
