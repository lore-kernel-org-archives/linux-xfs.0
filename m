Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795630311;
	b=XLHDz+Hk5PwgLOgG+tFHW99AzndtyZVcszs7QUwSqaADym8zOv6AeFs+2eBy/zF+TMxW
	 QGVM/sny2MXRVsAfRFQZYm6XyNZJ25Zt5ZBzjOqY3Xs2GLFj0pY+MZreGomAyEX8QVPJD
	 kg4W7musczLtMUDIuG/LKxR1YhsDyp80hgX6C4EBcb30nsKtz2wHcK0bdFAMl7xG54ejX
	 WlSPQwr3k5t3N+m1zJLBfEoeD3coxvjVWItPDhmo50qqAuBXiMqA0J4dqh34JKCfezsuI
	 RxTsfk/qVPilRx5O6md8F53nkjbebw0nT2OBx1tRSTSl/diqLrgLlIqSt2Mzu8Au8Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795630311;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=xtMBFMoouCpDoeqK4+6LdrZDGz7E08Ldy1RfvHC/uag=;
	b=TBUlhmPZHx9D/nLvCTOR2V7QFjDebSSZMFJv7LDMngETkZBGoaQSq8KeANZ1Ncscte8d
	 XwLEiKsq41zAn0hxCOINc3P2V1doJairjDJUx/Gj0apZMoVlI6t0c+i7JZZ2Y0+S+Bl3i
	 3T2Cd8qr7PhzGE8WIH9apzQVpn883Tjl0llvgtyH37X0Ma3wxuFlLuVenI7JSDEWHKwDq
	 5HWH6WrBast9BZrMb8YkFIjmz9TELPsqMWTUoJrRRSEuHpYl6cRXPGwKqjyUKNA9WAAK8
	 C8H9kc3DXlwixsy0REL4KXCCCsGelhug3Fx7K0k+h2K10hlgrgV7Ldun6izqfcjdO9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zu0+CJ3F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5169606A339
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 18:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zu0+CJ3F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFF81F000C4;
	Wed, 25 Nov 2026 18:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795630311;
	bh=xtMBFMoouCpDoeqK4+6LdrZDGz7E08Ldy1RfvHC/uag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zu0+CJ3FsiCVn7sUVtN7Zrtc8ghf2v0JZsZntfoqB3CFdmrSPSXaj97VHx6jEM9/R
	 n2xrHpvv95alUxW2CSL/yxxuOn/ZFM3J816KyLLgKI1cNJOuKAk/Ki6P2E4QbuOx4E
	 bRQEPI6qZOPUS7cNLZp1MW0gDVWKnfxGkF3M/rjikzjCL3VlxvGnQB/ctDs7ngF5lf
	 bRBWit/epRgupUY2iWlNTo2/L1mYwftD0J/lmUtsQGnw9ObsIeyQDnZ4I3pNLZ4U77
	 QbwGXTyNka9zFbizblVsNifQGs691h+5Hlyu4bCHYaeRy0snMlsUVL4Ewh3a3dGjm+
	 Jz4GkqWmP+8gQ==
Date: Wed, 25 Nov 2026 19:11:48 +0100
From: Alejandro Colomar <alx@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: Remove incorrect use of '&'
Message-ID: <awckyI8cAWM_kLzb@devuan>
References: <3783cf39b873890896eb889c8c09edb455559fce.1795626969.git.alx@kernel.org>
 <awccmN95lHSd7vp2@cronus.toxiclabs.cc>
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
	protocol="application/pgp-signature"; boundary="qaozjenvmtvwtfjt"
Content-Disposition: inline
In-Reply-To: <awccmN95lHSd7vp2@cronus.toxiclabs.cc>


--qaozjenvmtvwtfjt
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: Remove incorrect use of '&'
Message-ID: <awckyI8cAWM_kLzb@devuan>
References: <3783cf39b873890896eb889c8c09edb455559fce.1795626969.git.alx@kernel.org>
 <awccmN95lHSd7vp2@cronus.toxiclabs.cc>
MIME-Version: 1.0
In-Reply-To: <awccmN95lHSd7vp2@cronus.toxiclabs.cc>

Hi Carlos,

> Date: 2026-11-25 18:38:11+0100
> From: Carlos Maiolino <cem@kernel.org>
>
> On Wed, Nov 25, 2026 at 06:16:45PM +0100, Alejandro Colomar wrote:
> > We want to pass the character array, not a pointer to it.
> >=20
> > This seems an obvious typo, introduced in a48373e7d35a (2026-01-20;
> > "xfs: start creating infrastructure for health monitoring").
> >=20
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
>=20
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Thanks!  Will you take the patch?


Cheers,
Alex

>=20
> >  }
> > --=20
> > 2.55.0
> >=20
>=20
>=20

--=20
<https://www.alejandro-colomar.es>

--qaozjenvmtvwtfjt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmsHJOQACgkQ64mZXMKQ
wql7+w/9GZ+ytOlJNUAdtRKyCbsQc8eYveHtjGr2vzeFCo84LUx72/8po3mTZgns
LWBOOdMaOwam0ZuUdp3z79nH0vd58xHCzgtSv16o19aN4ByB8NeaRHeAS8QJFEmF
1i0SzkrKhcFEW7JFG9rpB9cjQD9ObHAaQKR1pegGyZc/OG4BJA69D1ihZwkU4+6R
AGgClRHHamIxSO5Ex2Hq2Uvyn99eOm7ZgUpHqwM6JhLNnmQAp902Qib6RVJc4Ba/
qAgENJUupJCp/nwb5nND/ac3AI0mdg9LA4YYlwB1RQ10l+zhH6e0CsBnKBDeuhbM
R1k50MJ7Idmo+Oy7D7HRBL1kZ/qCjZfHa7AaTLZ/N9DBoInXP+5KRm+XmrugLiFH
SRyapA21wntRdWpmuakfZCjSnKYSwgxUwIc/5iw5315pZjt1yliMn5WqW6krdiKi
0gA/mu2fLpYJqvIwMgFKDGQi45QQn8QFaAyjG0jnJVpp7DZZOKhZ8GLpbLjZeeOt
1Ueh0ka33zpOU7Q2TwEwlijeODL9tdD/9w1o/8spGb7ja5sjrwlak269UPbLeF67
SK6qtKIe/AD66wrjLa2lDGcyHXMQITsX7X7ufNfMzxjvVJnGhrnB22c0e9E2Wrid
yig+odw9rwKYdi7ZcoGzVuwTsRCefj+7JwKpGKAN3HPRe5TrJf8=
=qaZE
-----END PGP SIGNATURE-----

--qaozjenvmtvwtfjt--
