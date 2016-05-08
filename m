Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E205B7CA4
	for <xfs@oss.sgi.com>; Sun,  8 May 2016 14:18:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6797DAC002
	for <xfs@oss.sgi.com>; Sun,  8 May 2016 12:18:25 -0700 (PDT)
Received: from smtp.movistar.es (smtp08.acens.net [86.109.99.132]) by
	cuda.sgi.com with ESMTP id EZEjeNf8O92rzfyG for
	<xfs@oss.sgi.com>; Sun, 08 May 2016 12:18:22 -0700 (PDT)
Received: from Telcontar.valinor (88.1.245.4) by smtp.movistar.es (8.6.122.03)
	(authenticated as robin.listas2)
	id 56BAF15505CB99D3 for xfs@oss.sgi.com; Sun, 8 May 2016 19:18:21 +0000
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 9D0A560D2A
	for <xfs@oss.sgi.com>; Sun,  8 May 2016 21:18:20 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id XAJX-V8KZCSa for <xfs@oss.sgi.com>;
	Sun,  8 May 2016 21:18:20 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 7D1CD604E0
	for <xfs@oss.sgi.com>; Sun,  8 May 2016 21:18:20 +0200 (CEST)
Subject: Re: Unable to mount a XFS filesystem
References: <30479c32-e298-c64b-1964-f9c9824bfe7a@usa.net>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <572F90FC.1020201@telefonica.net>
Date: Sun, 8 May 2016 21:18:20 +0200
MIME-Version: 1.0
In-Reply-To: <30479c32-e298-c64b-1964-f9c9824bfe7a@usa.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0371861051906250025=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mail list <xfs@oss.sgi.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============0371861051906250025==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="jxAee070SrOC0hs81sGq7Uq4VQcWNBUeP"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jxAee070SrOC0hs81sGq7Uq4VQcWNBUeP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2016-05-08 16:12, Issa Gorissen wrote:
> Hello,
>=20
> After I have upgraded my htpc from openSuse 12.3 running kernel 3.7.10
> to openSuse Tumbleweed running kernel 4.5.2; I am unable to mount my XF=
S
> filesystem anymore.

How did you do that upgrade? Zypper dup, or boot dvd, choose upgrade?



> dmesg outputs
>=20
>=20
> [ 5525.861750] SGI XFS with ACLs, security attributes, realtime, no
> debug enabled
> [ 5525.862231] attempt to access beyond end of device
> [ 5525.862232] md0: rw=3D32, want=3D5860529904, limit=3D5860529792
> [ 5525.862234] XFS (md0): last sector read failed

Me, I would try to find out if the array is readable:

dd if=3D/dev/md0 of=3D/dev/null

and see where it stops.

--=20
Cheers / Saludos,

		Carlos E. R.
		(from 13.1 x86_64 "Bottle" at Telcontar)


--jxAee070SrOC0hs81sGq7Uq4VQcWNBUeP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlcvkPwACgkQtTMYHG2NR9VTJgCeJxB5/JH7WUZRcCTqSVDP108C
STUAnAm4qABmo7NQHDbvTgWhnxmImxbp
=kjvE
-----END PGP SIGNATURE-----

--jxAee070SrOC0hs81sGq7Uq4VQcWNBUeP--


--===============0371861051906250025==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0371861051906250025==--
