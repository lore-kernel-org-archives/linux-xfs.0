Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DD01925BC;
	Thu, 20 Aug 2026 09:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787218123; cv=none; b=FzSyTd58NhwlcAAGN95ONjd/p58PHXrg4+TUEe/GrvkOGgWhcwzdrZzrSbq3jeXvTHymnohUYFd6qCEbvzHGgbstl7eBbr/Rrz9hga1S5rgQ8OVWMThhaz6qvIPLKGNzFD3bzogr3R4rCOud9oWtjuXuHrK8lSK0xH+Iz5sGObY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787218123; c=relaxed/simple;
	bh=R/CLVck5rr+tZI9WVIxOclsFP1jHB4Vyp/OgkL53sWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KVm9gj3ZcSHmdwOwiN034QLg3FD2q0jTE0P01MzxECnIhy3ci8B8n8RbqL9b3V8ikllwUb/Faiy8RmS1UOHcuOKJ+ogcGTO7uEAOuk1D5xxW8ejVhl8hJG/WRj1nLEKMdeNGvR332rkfcwZlaDYhoOqZzCLeDNVTALGzVgw/pNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lvNafI3s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lvNafI3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D51A1F000E9;
	Thu, 20 Aug 2026 09:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787218122;
	bh=H6RJ2pTXp6Y73VaHFbObVI3HGmUsXwCsPBT4ejtjNzo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lvNafI3sCoyIl3VwyNBojWZysZHTvAjqpNg1mktEOge4AbysU88YJ9IZPv1STx47z
	 Jc7L3Lt52VmSxZ5sp+R5cKAB98ws26LIPMNCLG7+WipROWrlW6JRzLX+na7zx2Rbgn
	 GF6HSijw89+9xSvCHNqc2gAuji1CSbcI8Iz5N79t5u6mNWkSE756/3htqyegkcSfLy
	 Zkb6uab8w0rtxpVrNa7VPprhnlN8pS9lMMreDJtuuSMC47JIa7jRsE2oD9hqVmnKIx
	 QkGcqwowH4hjysMGf62afAKD+x2L5aYDHqSdN9Y1zukyJ10vJ8/zr88lT5HF5O/IQQ
	 7y0tvwmrDX+7w==
Date: Thu, 20 Aug 2026 11:28:38 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-man@vger.kernel.org, pankaj.raghav@linux.dev, hch@lst.de, 
	Zhang Yi <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org, gost.dev@samsung.com, 
	"Darrick J . Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
Message-ID: <aobIkmL6d9x5nPPg@devuan>
References: <20260820090400.857720-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5ayqmq3rilqq4ayc"
Content-Disposition: inline
In-Reply-To: <20260820090400.857720-1-p.raghav@samsung.com>


--5ayqmq3rilqq4ayc
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-man@vger.kernel.org, pankaj.raghav@linux.dev, hch@lst.de, 
	Zhang Yi <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org, gost.dev@samsung.com, 
	"Darrick J . Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
Message-ID: <aobIkmL6d9x5nPPg@devuan>
References: <20260820090400.857720-1-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20260820090400.857720-1-p.raghav@samsung.com>

Hi Pankaj,

> Date: 2026-08-20 11:04:00+0200
> From: Pankaj Raghav <p.raghav@samsung.com>
>
> This flag was added to the kernel in v6.17. As of now, only ext4 and
> block device nodes support this flag.
>=20
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
> Changes since v1:
> - Change the phrasing around zeroing and its condition (Zhang Yi)
> - Update ext4 support only for extent-based files (Zhang Yi)
>=20
> Note:
> This feature was recently added to XFS and it is expected to land in
> v7.13. I will update this man page again once v7.13 is released.

Do you really mean Linux v7.13?


Have a lovely day!
Alex

>=20
>  man/man2/fallocate.2 | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>=20
> diff --git a/man/man2/fallocate.2 b/man/man2/fallocate.2
> index ef6586c77..48a8c3468 100644
> --- a/man/man2/fallocate.2
> +++ b/man/man2/fallocate.2
> @@ -244,6 +244,43 @@ SMB3 (since Linux 3.17)
>  .IP \[bu]
>  Btrfs (since Linux 4.16)
>  .\" commit f27451f229966874a8793995b8e6b74326d125df
> +.SS Writing zeroes in file space
> +Specifying the
> +.B FALLOC_FL_WRITE_ZEROES
> +flag (available since Linux 6.17)
> +.\" commit 7bd43cc79cab3850f34da0a31d5b042b701590ef
> +in
> +.I mode
> +physically zeros space in the byte range starting at
> +.I offset
> +and continuing for
> +.I size
> +bytes.
> +Within the specified range,
> +blocks are preallocated for the regions that span the holes
> +in the file.
> +After a successful call,
> +subsequent reads from this range will return zeros and
> +subsequent writes to that range do not require further
> +changes to the file mapping metadata.
> +.P
> +Zeroing is done within the filesystem.
> +The filesystem may use a hardware-accelerated zeroing command
> +or may submit regular writes.
> +The behavior depends on the filesystem design and the
> +available hardware.
> +.P
> +No other flags may be specified in
> +.I mode
> +in conjunction with
> +.BR FALLOC_FL_WRITE_ZEROES .
> +.P
> +Not all filesystems support
> +.BR FALLOC_FL_WRITE_ZEROES ;
> +if a filesystem doesn't support the operation, an error is returned.
> +The operation is supported only in ext4 (only for extent-based files)
> +since Linux 6.17.
> +.\" commit f4265b8d32c49ff95711e6fef7d05245a2905b30
>  .SS Increasing file space
>  Specifying the
>  .B FALLOC_FL_INSERT_RANGE
> @@ -385,6 +422,7 @@ or
>  is
>  .BR FALLOC_FL_COLLAPSE_RANGE ,
>  .BR FALLOC_FL_ZERO_RANGE ,
> +.BR FALLOC_FL_WRITE_ZEROES ,
>  or
>  .BR FALLOC_FL_INSERT_RANGE ,
>  but the file referred to by
>=20
> base-commit: d926b42e0ea0406d5c2556e18205eced92d053f1
> --=20
> 2.51.2
>=20

--=20
<https://www.alejandro-colomar.es>

--5ayqmq3rilqq4ayc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmqGyMYACgkQ64mZXMKQ
wqnpKQ/+JIdcRkwyrmbdFrw3A8SzRaFRhr1T2Zn2ijobjxrSWPGqdgg0Xe5omDxO
qUWjwYiDdNYwsaDyWkqU6TIVJckTeYWaBhmU1LdEMt5xVlA91zfrjNVt8BIjq6ki
6PW0jRQkqriOCELr6e6JK+LTkyTkHAe3l/j9+ecA3czWQznoYsrI85TyVzhlXb17
+6BNfPn1Gzo1ddoGOksAJhsbNj+j9Th55X3kjJ/1sboXb2dyKGLnf9/0+LVdHt+J
fZBOltqiWSZLd2B4qNxgoRk6dC9DwU4enFpBoW8fp13At6ceukcp9M9YKu6y9+Zq
csYaJLu95hCN3Xo5uqgBNphP5NJ8F54USR0BlVGCFcApFu+v83PdBdGu9t47g/ho
g47jXBDJiYWrH98euWk1Yf6kHyf4xipUfJSD7Ktf9OtONqBhwrmpsp3iTYzBVVs3
TwKnPsYQoj5xtOfAwKDJrfDWLCPQp7jOdPJNvwYmZFBt70UCljUj0jUOSB8j4ECx
1djuw19B9i43HPwyCaDoNSA/eVnoynUjzGTk6Vwk5wTrtl237XXRJ5kw/ecumCqC
VPIR7qKeDGOr8H4H/dJKX9XXaS6YKoqkydi/mOIsoA0rUCEFHlAoSB5HfMEppRTu
S4nJlnCRSwLJV8uDGm9aDaO1hxv9MDeWRtvmTKKOhwExr7qInSQ=
=9NJj
-----END PGP SIGNATURE-----

--5ayqmq3rilqq4ayc--
