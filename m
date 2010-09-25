Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8P9fjd5228199 for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 04:41:45 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E357E745A1
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 02:55:22 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id EEjfXtFNX6jNI2HN for
	<xfs@oss.sgi.com>; Sat, 25 Sep 2010 02:55:22 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 3F52917E
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 11:42:36 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id E5301401C3D
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 11:42:35 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Contiguous file sequences
Date: Sat, 25 Sep 2010 11:42:31 +0200
References: <AANLkTikHqjvEGJb0XnNy+nz7+nHLVLwjF_wp5RZdk_1-@mail.gmail.com>
	<4C9A6298.106@sandeen.net>
In-Reply-To: <4C9A6298.106@sandeen.net>
MIME-Version: 1.0
Message-Id: <201009251142.35467@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1904644395964292509=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1904644395964292509==
Content-Type: multipart/signed;
  boundary="nextPart3268364.JCBoJiQJVv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3268364.JCBoJiQJVv
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 22. September 2010 Eric Sandeen wrote:
> preallocation of each image before writing would help make it more
> likely that each image is itself contiguous (but again this is not
> -guaranteed-)
=20
If all images were 1-2MB large, and if there is no parallel create, but=20
all images are copied after each other, wouldn't the mount option=20
"allocsize=3D2M" be sufficient to ensure pics are contigous? I guess XFS=20
would place them behind each other on disk, or why should there be gaps=20
between?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart3268364.JCBoJiQJVv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkydxAsACgkQzhSR9xwSCbQF5ACaA5ZcwXXp9ji0K2mzMS7BMl9j
4YcAn1dHPiudjDPEsyQbEzgxEQjAvTdm
=KOAZ
-----END PGP SIGNATURE-----

--nextPart3268364.JCBoJiQJVv--


--===============1904644395964292509==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1904644395964292509==--
