Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8JbrMk051789 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 13:37:53 -0600
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 9KQBzNCFwq1yQ9CP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 08 Dec 2012 11:40:18 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS write cache flush policy
Date: Sat, 08 Dec 2012 20:40:07 +0100
Message-ID: <5955806.tSHc7WOiJd@saturn>
In-Reply-To: <20121208192927.GA17875@citd.de>
References: <CAA_rkDfFUmZzT_kMznsTSNVxdfqfmz=bmJ400wdBOzocgP32eA@mail.gmail.com>
	<20121208192927.GA17875@citd.de>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4418179763122290949=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Lin Li <sdeber@gmail.com>


--===============4418179763122290949==
Content-Type: multipart/signed; boundary="nextPart48405543.jmpvORZaXi"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart48405543.jmpvORZaXi
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Samstag, 8. Dezember 2012, 20:29:27 schrieb Matthias Schniedermeyer:=

> I have the same problem, several times.

I'd like to chime in here, with a similar issue: I have Linux on my=20
desktop, xfs is the home partition, 16G RAM. One day my system froze, n=
o=20
chance to do a buffer flush via SYS-S/U/B, I had to press the reset=20
button (no power off, just reset). Upon restart, *lots* of files were=20=

gone, destroyed, etc, and my KDE desktop wouldn't work anymore. Luckily=
=20
I have backups, and could restore - but this just shouldn't happen, and=
=20
it was *much* better with older kernels. What is the problem that=20
metadata isn't written to disk occasionally? I was on 3.6.6 when that=20=

happened, now on 3.6.8, so very recent.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531
XING: https://www.xing.com/profile/Michael_Monnerie
Twitter: @MichaelMonnerie https://twitter.com/MichaelMonnerie
FaceBook: https://www.facebook.com/michael.monnerie
LinkedIn: http://lnkd.in/uGx6ug

--nextPart48405543.jmpvORZaXi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlDDl54ACgkQzhSR9xwSCbRZdACgmXdFpQ2/0QUxdO8LWUE+g1kT
T0wAoKa+1xkGSEkDAsOjqJbx+FAxKjXC
=KWsB
-----END PGP SIGNATURE-----

--nextPart48405543.jmpvORZaXi--


--===============4418179763122290949==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4418179763122290949==--
