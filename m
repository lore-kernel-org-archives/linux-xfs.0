Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 08:00:12 -0700 (PDT)
Received: from amanpulo.fs3.ph (amanpulo.fs3.ph [72.51.42.241])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8AF034p001590
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 08:00:05 -0700
Received: from localhost (localhost [127.0.0.1])
	by amanpulo.fs3.ph (Postfix) with ESMTP id 5BB2B1E0D5960
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 23:00:05 +0800 (PHT)
Subject: Re: Attempt to Access Beyond End of Device
From: Federico Sevilla III <jijo@fs3.ph>
In-Reply-To: <Pine.LNX.4.64.0709101041390.897@p34.internal.lan>
References: <1189432747.4385.27.camel@auctoritas.fs3.ph>
	 <Pine.LNX.4.64.0709101041390.897@p34.internal.lan>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yLm0c2VKZRrvdy/ghcrt"
Date: Mon, 10 Sep 2007 22:59:56 +0800
Message-Id: <1189436396.4385.49.camel@auctoritas.fs3.ph>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: Alec Joseph Rivera <agi@fs3.ph>

--=-yLm0c2VKZRrvdy/ghcrt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-10 at 10:44 -0400, Justin Piszcz wrote:
> I believe the logbsize should be in bytes, so 262144, it may also take
> 256k though I have not tried it.

It accepts 256k. The initial mount succeeded, and the problem did not
surface until after some reboot (ie: not the first reboot, either, that
went fine).

> That looks mighty strange, what kind of raid card?

This is the built-in Adaptec AACRAID of the IBM x3400, doing a pretty
simplistic RAID 1.

--=20
Federico Sevilla III
F S 3 Consulting Inc.
http://www.fs3.ph

--=-yLm0c2VKZRrvdy/ghcrt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD4DBQBG5Vvs5rCBSJO3Rr4RAozoAJd5hwk49g1kt1xX5T2jjb0B4Gv4AJ4nXGgL
JMO0gYk6VadF2d3VasR1IA==
=6TmE
-----END PGP SIGNATURE-----

--=-yLm0c2VKZRrvdy/ghcrt--
