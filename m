Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60D5175A9D;
	Sat, 22 Aug 2026 12:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787402500; cv=none; b=ZMDaWqNqqHx77ou/YUy53PHwkEdxF4m8r6SXBYblWOEWNGJeLIG1dsQap5QCPKqZMtKmv0mpvX8LHRCalpb1m3CTkF1j0bLMSZaCOXISjo5ucP86bJ2ectekoOz+uzNGBAW4hWg+qjQrslQCVSZXiJcEDRohZ8Bdikhus9xAqvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787402500; c=relaxed/simple;
	bh=OQVtR1HgPjVO6sGi5O64Cf27ZAkUaXlSE/u1DP1QreE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IRUA3vt6zU1VF7WGdRcbA/VkU3jzHQCg0gR8JH04Wm9j7EDyDsyYiUFYVbpJwBPFvPxyfp9UDLwRnCEKkP+jpCtmoQrZ0EAwnvofXJwVNelROb0XKuidA6RsfSj0DcSddX5aWi0XZpTJY3VR+9isQrMkh2cq26fPRzv+GKD8ESQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FOQPqJ/p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FOQPqJ/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1331F000E9;
	Sat, 22 Aug 2026 12:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787402499;
	bh=SGLicknkCIgRsgg08fxRo1sawmxj4Z8sfoAGg4Hl/k0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FOQPqJ/p8bf+5YnBttB+R+Efa+Nd4ApxYXkS+aVpZe4NGOgf93+4fh+Jm2Wd9Jadf
	 oIcsEEPi2Qs6ZxyunJ3xEo+uPZ/F+lW9TDyw0N/TIoKlA3rOBD5FnnmL5DSPpOO/n9
	 EKHNStOc1iSdshIJWMaVc5r70JolkdM0MU4L4gFuA7mFccem6vrEvcaNe9gVndIsU3
	 22MrT4z19MzUpFwrPEbs5Mum21cdCFxqRh+x5w7XBnSQQlkrX6QzRBsKZcyKwzPt4b
	 nJzWtadMksWKiV87hgTUtkNaTI068ICM1uKeeVJgEF4zKAus77AePVHsuGq7sy2RaW
	 l90sHPiOknSAg==
Date: Sat, 22 Aug 2026 14:41:34 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-man@vger.kernel.org, pankaj.raghav@linux.dev, hch@lst.de, 
	Zhang Yi <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org, gost.dev@samsung.com, 
	"Darrick J . Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
Message-ID: <aomV6Jt7udtAwwcw@devuan>
References: <20260820090400.857720-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mv6tus4g6cufx3gi"
Content-Disposition: inline
In-Reply-To: <20260820090400.857720-1-p.raghav@samsung.com>


--mv6tus4g6cufx3gi
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-man@vger.kernel.org, pankaj.raghav@linux.dev, hch@lst.de, 
	Zhang Yi <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org, gost.dev@samsung.com, 
	"Darrick J . Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZEROES
Message-ID: <aomV6Jt7udtAwwcw@devuan>
References: <20260820090400.857720-1-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20260820090400.857720-1-p.raghav@samsung.com>

Hi Pankaj, Christoph,

> Date: 2026-08-20 11:04:00+0200
> From: Pankaj Raghav <p.raghav@samsung.com>
> Subject: Re: [PATCH v2] man2/fallocate.2: add doc for FALLOC_FL_WRITE_ZER=
OES

We use the full path in the prefix.  That is, 'man/man2/...: ...'.
Also, we use regular sentence conventions for the first letter after
the ':', so s/add/Add/.

> This flag was added to the kernel in v6.17. As of now, only ext4 and

Please use two spaces after period.
<https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/CONTRIBUT=
ING.d/patches/description#n44>

> block device nodes support this flag.
>=20
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Please include the CC list here too.

> ---
> Changes since v1:
> - Change the phrasing around zeroing and its condition (Zhang Yi)
> - Update ext4 support only for extent-based files (Zhang Yi)
>=20
> Note:
> This feature was recently added to XFS and it is expected to land in
> v7.13. I will update this man page again once v7.13 is released.
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

What does it mean that "blocks are preallocated"?  That they must be
allocated prior to this call?  I suspect not.  Otherwise, we'd be saying
'must be' instead of 'are'.

I suspect it means that this call allocates blocks for those regions,
but then I'm not sure we want 'pre' there.

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

Christoph, is this correct?  I remember you said something about block
device nodes in v1.


Have a lovely day!
Alex

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

--mv6tus4g6cufx3gi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmqJmPgACgkQ64mZXMKQ
wqmdIQ/+NgMSJLmaisJwmo5hxhBnexOjXGKPR8AK2s0jC6+HjsVjqEUJPceVPJL4
wBcl49yTr43J1N0fGqbo7IN3tci9Xp9OiHE0gPbyjPAOm0MccHKrccsv5Iw3MWIo
emnocP5Szzw6KHDyI7/tJTAoCw+NDRVJW/JkUz6sI+tAduVxa0w8Kwku27zTbbwd
cF5dJRND2R9LVv4udefMp1DYt9WOQHidrPiv3ucdT6u4dUWUeYX0bFHkpa8GHbI1
7i58j1r1eEHK2aIFCUWk59fz7nafgDuo2T0lPvXCSYMmXnOzgjNdIDQPYleRhhHS
e0NJlwqIsuAPgewKa/k+Qe98tfJBHHr0ZhlNlcmW2T9f7C2vO1qx4YtS2+xwwlZ7
V/+o3lAtoGE7eNO7Uz63oYjLxmEIMtv/e3upHYpYnfN2ysV0FRHq6xg9b+RFVvIj
wLv1IAgDHwCEI0M34zS3/lhrI/nUc+mYqiWC91MmTdm12ZPCB6UbKlfsEpH9DNoR
vEfrsfXei4lEAzXfksR9Ymn4423caS4Z84jgiMi4aOwTGT2jgxI7NYl7DgacysQu
Q/IsuCna5Eh5cVGZ2ZuOSIX+GDKgSDvE0Z6w5SkDxabmS9nP/rqhSU2Ih9wwS5Vc
mowM85CUt1mPxXXdaWU7yjSLW4OeTuB49pcyaid8XDbdvNYKm+M=
=BsSp
-----END PGP SIGNATURE-----

--mv6tus4g6cufx3gi--
