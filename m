Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p587BFI3078847 for <xfs@oss.sgi.com>; Wed, 8 Jun 2011 02:11:16 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 054094A9AB4
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2011 00:11:13 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 94EQsaWIPVnMoXR5 for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2011 00:11:13 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Small files perform much faster on newly formatted fs?
Date: Wed, 8 Jun 2011 09:11:10 +0200
References: <20110607163742.GH28625@pyre.virge.net>
In-Reply-To: <20110607163742.GH28625@pyre.virge.net>
MIME-Version: 1.0
Message-Id: <201106080911.11286@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8573602248044027396=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Norbert Veber <nveber@pyre.virge.net>

--===============8573602248044027396==
Content-Type: multipart/signed;
  boundary="nextPart14545136.KOncusAfmJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart14545136.KOncusAfmJ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 7. Juni 2011 Norbert Veber wrote:
> 20 seconds vs 3+ minutes?!  The only difference I can see is
> lazy-count=3D1 and a larger agcount.  Sunit and swidth were also set
> automatically by mkfs this time.

Then retry mounting the old fs with sunit=3D and swidth=3D parameters. Are=
=20
they on the same disks? What are your disks (number, kind)?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart14545136.KOncusAfmJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk3vII8ACgkQzhSR9xwSCbSAxACgwUzQMUNSceJD5bCTNbaXUcUG
DpkAoOMw2cH0QNVN8Wekd83Mb0c2/8gY
=i5k5
-----END PGP SIGNATURE-----

--nextPart14545136.KOncusAfmJ--


--===============8573602248044027396==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8573602248044027396==--
