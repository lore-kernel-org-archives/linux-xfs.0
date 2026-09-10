Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15FC328B7F;
	Thu, 10 Sep 2026 22:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789080295; cv=none; b=PPtNfP1ME43WIIxY940unXnrdOQtjU1/pibkOFHbVd6wL/yI1VZYuSAOGa5yoH7FycUkZM94ebJAUpKiCYf1LeTqszazz8kqlHX/N4HTPKDKETqDJY9w68rMBUQb0qRubxPu/oMEqFXek3nXwuef4iDm+Xk3/cuWehTaTz4Yl4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789080295; c=relaxed/simple;
	bh=CZ8nQyucNegn2UDxWN0JvXOSCwRgmP4QSCyjWlJqlmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pe5L4VzVyeRlRLHKVguhBgIEZGypZaUqqZnFeRH4/nh1krhIYoMX8h6h2jKwGkKhbymxti+fPXfhk96V3/Kz72qxYeh+/uM4WGxy29cOqxS9skx33lQrw+FtqhWzXJOIuOUIcOoqaSrJNVf+5oG2XPSkU3FxHYqxrBDh03YHE+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ldkj2rI1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ldkj2rI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C5D1F000FF;
	Thu, 10 Sep 2026 22:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789080293;
	bh=x+Pt5UIyTMBsib1qfVymqrjhCVQnnWBpLVqZNnjtdys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ldkj2rI1yAZIDk7c6RZx6+IkzwKhRv9HDK2yjQQLpbHnhOyrZ+lMKbgqMwsgxMjzW
	 wZEtPaQRDznZmWASBlLQDpbtnUtmFs/QP9bbeANNPe0kAj9AXE9uhlSw1BPalJAer7
	 gV4VenCn9ioo9pC5nNSZi4DwtjrDZJ0t+BOJPMWYAxeuDZDiTnqwYQ1H377zLYVZhZ
	 UjmxFVJKqJQm/StKH/AL6oVSo9lYD1oa9+Q4QPIQXok74C/LL4xN2FSfOkrBigWYDV
	 P6W+gkKb8IpAhn7OnW11hYDKz9d14b0injQYcGZC0HZC/+KA9Rpvjjo6kxFM/DXhbo
	 eN3ntmc0OcHAg==
Date: Fri, 11 Sep 2026 00:44:49 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>, linux-man@vger.kernel.org, 
	pankaj.raghav@linux.dev, linux-xfs@vger.kernel.org, gost.dev@samsung.com, 
	linux-ext4@vger.kernel.org, hch@lst.de, "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v3] man/man2/fallocate.2: Add doc for
 FALLOC_FL_WRITE_ZEROES
Message-ID: <aqMyw2dBeyzicF0s@devuan>
References: <20260910112023.2591987-1-p.raghav@samsung.com>
 <5d02e7dd-fa9e-497b-b1f6-9cc0f2a45c8f@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mrj5i4kujh6ttiqm"
Content-Disposition: inline
In-Reply-To: <5d02e7dd-fa9e-497b-b1f6-9cc0f2a45c8f@huaweicloud.com>


--mrj5i4kujh6ttiqm
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>, linux-man@vger.kernel.org, 
	pankaj.raghav@linux.dev, linux-xfs@vger.kernel.org, gost.dev@samsung.com, 
	linux-ext4@vger.kernel.org, hch@lst.de, "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v3] man/man2/fallocate.2: Add doc for
 FALLOC_FL_WRITE_ZEROES
Message-ID: <aqMyw2dBeyzicF0s@devuan>
References: <20260910112023.2591987-1-p.raghav@samsung.com>
 <5d02e7dd-fa9e-497b-b1f6-9cc0f2a45c8f@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <5d02e7dd-fa9e-497b-b1f6-9cc0f2a45c8f@huaweicloud.com>

Hi Zhang, Pankaj,

> Date: 2026-09-10 20:26:23+0800
> From: Zhang Yi <yi.zhang@huaweicloud.com>
>
> On 9/10/2026 7:20 PM, Pankaj Raghav wrote:
> > This flag was added to the kernel in v6.17.  As of now, only ext4 and
> > block device nodes support this flag.
> >=20
> > Cc: Zhang Yi <yi.zhang@huaweicloud.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Darrick J. Wong <djwong@kernel.org>
> > Cc: gost.dev@samsung.com
> > Cc: linux-ext4@vger.kernel.org
> > Cc: linux-xfs@vger.kernel.org
> > Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>=20
> Looks good to me.
>=20
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Thanks!  I've applied the patch and the tag.


Have a lovely night!
Alex

>=20
> > ---
> > Changes since v2:
> > - Changed the commit format based on Alejandro's feedback.
> > - I have retained "preallocated" term based on Zhang Yi's feedback[1]
> >=20
> >=20
> > Note:
> > This feature was recently added to XFS and it is expected to land in
> > v7.3. I will update this man page again once v7.3 is released.
> >=20
> > [1] https://lore.kernel.org/linux-man/3f17d214-f69c-47b6-abf6-4437cc584=
0c0@huaweicloud.com/
> >=20
> >  man/man2/fallocate.2 | 38 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 38 insertions(+)
> >=20
> > diff --git a/man/man2/fallocate.2 b/man/man2/fallocate.2
> > index ef6586c77..48a8c3468 100644
> > --- a/man/man2/fallocate.2
> > +++ b/man/man2/fallocate.2
> > @@ -244,6 +244,43 @@ SMB3 (since Linux 3.17)
> >  .IP \[bu]
> >  Btrfs (since Linux 4.16)
> >  .\" commit f27451f229966874a8793995b8e6b74326d125df
> > +.SS Writing zeroes in file space
> > +Specifying the
> > +.B FALLOC_FL_WRITE_ZEROES
> > +flag (available since Linux 6.17)
> > +.\" commit 7bd43cc79cab3850f34da0a31d5b042b701590ef
> > +in
> > +.I mode
> > +physically zeros space in the byte range starting at
> > +.I offset
> > +and continuing for
> > +.I size
> > +bytes.
> > +Within the specified range,
> > +blocks are preallocated for the regions that span the holes
> > +in the file.
> > +After a successful call,
> > +subsequent reads from this range will return zeros and
> > +subsequent writes to that range do not require further
> > +changes to the file mapping metadata.
> > +.P
> > +Zeroing is done within the filesystem.
> > +The filesystem may use a hardware-accelerated zeroing command
> > +or may submit regular writes.
> > +The behavior depends on the filesystem design and the
> > +available hardware.
> > +.P
> > +No other flags may be specified in
> > +.I mode
> > +in conjunction with
> > +.BR FALLOC_FL_WRITE_ZEROES .
> > +.P
> > +Not all filesystems support
> > +.BR FALLOC_FL_WRITE_ZEROES ;
> > +if a filesystem doesn't support the operation, an error is returned.
> > +The operation is supported only in ext4 (only for extent-based files)
> > +since Linux 6.17.
> > +.\" commit f4265b8d32c49ff95711e6fef7d05245a2905b30
> >  .SS Increasing file space
> >  Specifying the
> >  .B FALLOC_FL_INSERT_RANGE
> > @@ -385,6 +422,7 @@ or
> >  is
> >  .BR FALLOC_FL_COLLAPSE_RANGE ,
> >  .BR FALLOC_FL_ZERO_RANGE ,
> > +.BR FALLOC_FL_WRITE_ZEROES ,
> >  or
> >  .BR FALLOC_FL_INSERT_RANGE ,
> >  but the file referred to by
> >=20
> > base-commit: d926b42e0ea0406d5c2556e18205eced92d053f1
>=20

--=20
<https://www.alejandro-colomar.es>

--mrj5i4kujh6ttiqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmqjMuEACgkQ64mZXMKQ
wqnS7A/+LYEoLVnI/bZ0fbz54C13p9BizrU+aH68+LFDEUURKla2cr993+pmBy3g
3pQkS4O2hBD/gs578XjR8EojVEJ7ctUKUd+cqehl2V3LRB9U4kDu5PyQOXTH6B/g
pFk43bX/oto4j9f1xJhoKEKcPU5x8YVZV4OSp4i/IjSqXszJv0fmetExwDSMR+j9
MsEyPXOP78mgCCFInL5Z5pKNDiiS2rAx6CkXAEefiWVT66673ObJ2RYW9NXNrdKd
CBe4x4/thiVv5rfeIIMYO9HEKPsLMcdKUgpeID3JSe08AX/Bh/n4mrkf2kkQu0qx
egRwgSrHf6IpQvSco6mrnmA6QHVmg5uOud0whiW/7U0D/Z0agem0XqqBsNFNasGc
fcLK7fcvaDhyFI52W9X9Pb8PRwzTL/ZEefxVSq0J9Op7WCFMpFUFdkx8Tg483oLA
9AKx5K76FxhDZ47puNIs5JssAoDqrLRViDf08lwCDQLaj5l6za/3JaWKDDC0Xst/
3MiGGp164gYr4kqxWem715fTcnVWsuVUOQ8IFxjiRJ0u2YbCTdN+BuH7CFO/vG0g
G3zKM9IgYo7nM6XbgAAl40/jtJu3A6rGiusjPTyYR8mEHErxSIKI6+YVN4C/4lAy
H4xN/G0TnJiI3j5sw30CwDE3GVkBJFEPEONw6vOIBqIlkyNNATo=
=Ane6
-----END PGP SIGNATURE-----

--mrj5i4kujh6ttiqm--
