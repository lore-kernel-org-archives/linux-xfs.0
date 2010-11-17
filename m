Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAHLLEMO095898 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 15:21:14 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4131E4D031B
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 13:22:46 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id K5gXtO6IUWJmEtsb for
	<xfs@oss.sgi.com>; Wed, 17 Nov 2010 13:22:46 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfsprogs 2.x vs 3.x logsize changed
Date: Wed, 17 Nov 2010 22:22:43 +0100
References: <201011171549.04806.lukasz.oles@open-e.com>
In-Reply-To: <201011171549.04806.lukasz.oles@open-e.com>
MIME-Version: 1.0
Message-Id: <201011172222.44758@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4141886748676678391=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Artur Piechocki <artur.piechocki@open-e.com>, =?utf-8?q?=C5=81ukasz_Ole=C5=9B?= <lukasz.oles@open-e.com>

--===============4141886748676678391==
Content-Type: multipart/signed;
  boundary="nextPart2385407.tyoou01hYX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2385407.tyoou01hYX
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 17. November 2010 =C5=81ukasz Ole=C5=9B wrote:
> Can I stay with the old log size or maybe there are some good reasons
> to use  new values?

I believe the new defaults are there because it results in faster=20
metadata operations when there are lots of them. I'd guess if you only=20
ever have one writer it wouldn't matter much, but in case you have=20
several parallel writers it could make a difference. But I'm not a dev,=20
maybe they can confirm or clarify.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart2385407.tyoou01hYX
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzkR6QACgkQzhSR9xwSCbThlwCfTisTeAGQkoZ54IKNKM/l4sj4
11IAoKqEn7ymwoav9hhe7HNK0XZ2B2GR
=3vwR
-----END PGP SIGNATURE-----

--nextPart2385407.tyoou01hYX--


--===============4141886748676678391==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4141886748676678391==--
