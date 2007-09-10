Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 08:55:53 -0700 (PDT)
Received: from amanpulo.fs3.ph (amanpulo.fs3.ph [72.51.42.241])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8AFst4p014594
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 08:54:57 -0700
Received: from localhost (localhost [127.0.0.1])
	by amanpulo.fs3.ph (Postfix) with ESMTP id CB8C91E0D5976
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 23:54:57 +0800 (PHT)
Subject: Re: Attempt to Access Beyond End of Device
From: Federico Sevilla III <jijo@fs3.ph>
In-Reply-To: <46E5670E.9000703@sandeen.net>
References: <1189432747.4385.27.camel@auctoritas.fs3.ph>
	 <46E5670E.9000703@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8wE5xQWAx1sfYkeJWp2V"
Date: Mon, 10 Sep 2007 23:54:49 +0800
Message-Id: <1189439689.18040.17.camel@auctoritas.fs3.ph>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: Alec Joseph Rivera <agi@fs3.ph>

--=-8wE5xQWAx1sfYkeJWp2V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-10 at 10:47 -0500, Eric Sandeen wrote:
> can you send along the results of:
>=20
> 	# xfs_db -r -c "sb 0" -c "print" /dev/sda8?

Will do first thing tomorrow when I get back access to the machine, and
will revert to the list.

> and
> 	# cat /proc/partitions
>=20
> ... and does the hardware raid have a funky sector size?

Please advise as to how best to usually find this out. For whatever it's
worth, it doesn't allow us to pick a stripe width for RAID 1 (as we
probably shouldn't be able to specify one, anyway). So whatever we're
using is our only choice as far as the hardware RAID 1 goes. (We could
probably use software RAID 1, though, if push comes to shove.)

Thank you very much for your time.

--=20
Federico Sevilla III
F S 3 Consulting Inc.
http://www.fs3.ph

--=-8wE5xQWAx1sfYkeJWp2V
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG5WjJ5rCBSJO3Rr4RAiFRAJ4+Dxw+Y7Eu0c+Sfgw/PVbSu3RiqgCeNgZk
0CQhWIv9UX0UXwKmbvQyQY0=
=O5Y1
-----END PGP SIGNATURE-----

--=-8wE5xQWAx1sfYkeJWp2V--
