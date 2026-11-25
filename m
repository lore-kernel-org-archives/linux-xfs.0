Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795630233;
	b=ionC9StWx35CU1viC8pQmkGSBrr+N2aY4tOQlG2W8M4pJRhrETcMA4QxHKDAxm9CpSkl
	 T5fw0Pe+3WR72r261RgOi7W6X1i/uy7b3LfPsOL/OMXpdKAVUj4+jmjCHZcoFgsF40VZb
	 3ktfx1yZ24qUEqtPMzAiy+1pm37yREFao3MVnp89h1cFKM3XWo4deYpV0bfAtBR4QC55t
	 QfEXaS92hu0O5/MkPrFTYTFDwEmGtvzZEMn3ju3/VxTTBc9lGnU+8BcUpGv2VP8JZjMT8
	 RWmT+KTfmGH53rYQuhJwyGsegOJ14NtMIKZsgSpgrIKOVfa1K0Gn0mJjMTs9oFEby7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795630233;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=cnvFVVfsDszro7BDTUtT2mGOtTw1Rb1V9/qFs0+J5PM=;
	b=DadCJAl54fMwynwhZpQgkTLO+mBa2s1xTtwbjWZ6bcvR03ONdl71WwwREyM7GAc4rX5p
	 dp8dupVwRPkCEJrUGP6da8FCWuW2XXRNDQktpt/KrrVJ5bvWzcLSbiRXzQxcbx1QQAEOe
	 TeMjqwUn1rtyW76R8HyCu28dMvbPPU4ezv0BgATMhlvtHMYzITHaFfaUh++0HgGuBL9au
	 pHKZTuxY6pleTTB18coaGDYan1X5sqRwcinyjlLVmGu52YM3wPVGyUHcB7qIavvKA8R1y
	 1NZG6at9AbAOwAdEA7mHBG7BZHbHtV8WIXpM+k+bxS2gHnrfSchVApz3MmTif0y2+oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IOnXnaUl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EBC606A326
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 18:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IOnXnaUl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411AC1F000C6;
	Wed, 25 Nov 2026 18:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795630232;
	bh=cnvFVVfsDszro7BDTUtT2mGOtTw1Rb1V9/qFs0+J5PM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IOnXnaUlmILSGMIJjN3KPGDKAnWxx2+N7Vf6Ot3DhLS3bzzUV5ws7e3mhNO6GEjK4
	 4/tgVrDqGUD2wMv8KCNV26XVh7R61lHoe7iQUdhm025M3/j68tkfyhJBnYPg9nIdaS
	 GMtdC9thfQrcELEmldj1xGm10A9RPwnzazzH9KjobXBb0esTBhTIX12rp4wxHfZSb7
	 lExs1lbEGVNeu5nLa8qJnGwWiD68VHbFsv9J52cs9KPUhODYEqh2GVwgeDnrtdBmKA
	 SG4OFpIJw/DdO49P/KNyMBIdFo+lVHyOSaANdp6pkpFoOlimh9Nmw/BlMrPEQ8G8AL
	 oVIiT+qc145cA==
Date: Wed, 25 Nov 2026 19:10:29 +0100
From: Alejandro Colomar <alx@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: Remove incorrect use of '&'
Message-ID: <awckBo8FkdsGtb1t@devuan>
References: <3783cf39b873890896eb889c8c09edb455559fce.1795626969.git.alx@kernel.org>
 <34b824e8-21fc-4271-bd60-29cc8b06a292@sandeen.net>
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
	protocol="application/pgp-signature"; boundary="idyrh6dmakyxj6pq"
Content-Disposition: inline
In-Reply-To: <34b824e8-21fc-4271-bd60-29cc8b06a292@sandeen.net>


--idyrh6dmakyxj6pq
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: Remove incorrect use of '&'
Message-ID: <awckBo8FkdsGtb1t@devuan>
References: <3783cf39b873890896eb889c8c09edb455559fce.1795626969.git.alx@kernel.org>
 <34b824e8-21fc-4271-bd60-29cc8b06a292@sandeen.net>
MIME-Version: 1.0
In-Reply-To: <34b824e8-21fc-4271-bd60-29cc8b06a292@sandeen.net>

Hi Eric,

> Date: 2026-11-25 11:43:00-0600
> From: Eric Sandeen <sandeen@sandeen.net>
>
> On 11/25/26 11:16 AM, Alejandro Colomar wrote:
> > We want to pass the character array, not a pointer to it.
> >=20
> > This seems an obvious typo, introduced in a48373e7d35a (2026-01-20;
> > "xfs: start creating infrastructure for health monitoring").
>=20
>=20
> So,
>=20
> Fixes: a48373e7d35a ("xfs: start creating infrastructure for health monit=
oring")
> Cc: stable@vger.kernel.org

It's unnecessary, because the binary will have the same exact value
passed.  It's only a type-system issue, which affects diagnostics etc.,
but doesn't create an actual bug.

I would add the 'Fixes' tag, but without stable@, since it doesn't need
to be backported.  I didn't include the 'Fixes' tag because some
maintainers don't want to see them if there's no bug in the binary.

Let me know your preference.


Cheers,
Alex

>=20
> > Cc: Darrick J. Wong <djwong@kernel.org>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Alejandro Colomar <alx@kernel.org>
> > ---
> >  fs/xfs/xfs_healthmon.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
> > index 2bdd747f1ead..56d19ffb02b3 100644
> > --- a/fs/xfs/xfs_healthmon.c
> > +++ b/fs/xfs/xfs_healthmon.c
> > @@ -1061,7 +1061,7 @@ xfs_healthmon_validate(
> >  		return false;
> >  	if (hmo->format !=3D XFS_HEALTH_MONITOR_FMT_V0)
> >  		return false;
> > -	if (memchr_inv(&hmo->pad, 0, sizeof(hmo->pad)))
> > +	if (memchr_inv(hmo->pad, 0, sizeof(hmo->pad)))
> >  		return false;
> >  	return true;
> >  }
>=20

--=20
<https://www.alejandro-colomar.es>

--idyrh6dmakyxj6pq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmsHJJQACgkQ64mZXMKQ
wqlqvw/+IeveRZFtAXq3JbUIqgHUO0v2vtJueoeX8VWiGEtZoVCxoS8Pd8/ZqBpV
GGQ5EXgyeSX9sPU5VnTZz4wC5oW8OBrxUs01oX1DO8pEATaYBP0rkGh/zpWEK6XW
2V84aSWD2ELsjz65yMaN8YKtpW4OGHQn+clnnTWAV6DNLREzAsnI3he5tm75q6/+
k5pjN0pW+Qhf6BA7L9pFwkk5MpZgnhZP+gNkkiW1IdOXzI2cCeq/vxH92u6qEDQq
8g1maP9e8BFnGoSpZA6egthCbxb8KZZlGu/l71ujnkkmcBH9SExyTdJFGjn+6GTa
6h1tzcMiFSYi0p7jPee/mOSF4j+Q/5o0QRdkSTDpd38gKM38GDh0N/MBXMbf2v6z
DiN1QyHrfdQ8qhOiMIoI/FuQYV7p5iF1Bcm45u3KDJQq2QQyWSF9D8kGCxR+/SvN
i2Q96nLfumVBgg+8msJ7YCmJm42pMF/oxnzP7+9g2N00EN9XXfLjFiBoUkVazUEJ
Ka7MnxswHfD1VFGJb67bh68E/1gI0Spto/p5V0gy0TbZAswbuJir5TDWGNAGIjM4
ZXebZSw7eanYddsp0AQOwy/yrI+0JZiz+AYf/qwhqpgYsPJL08SmCb0TB0I1Rkw5
80bvDGKsCNeBKjoi/UnosrIx8vdFcf9L29ecTIGTimClHWvOPEw=
=H/ZC
-----END PGP SIGNATURE-----

--idyrh6dmakyxj6pq--
