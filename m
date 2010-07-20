Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KEvtad026065 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 09:57:56 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43E53BEB96E
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 08:07:36 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id mJCcPxnx0CGT3fFb for
	<xfs@oss.sgi.com>; Tue, 20 Jul 2010 08:07:36 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id B6D74701
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 17:00:52 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 9037283C82E
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 17:00:04 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Calculating swidth On A RAID6 Volume
Date: Tue, 20 Jul 2010 17:00:51 +0200
References: <3C5E029826A0704DB5998577FCFF46F0094DA1AD69@dagobah>
	<4C45AF09.5090901@dermichi.com>
	<20100720164444.4c1cef88@harpe.intellique.com>
In-Reply-To: <20100720164444.4c1cef88@harpe.intellique.com>
MIME-Version: 1.0
Message-Id: <201007201700.51977@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7312389795790663111=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7312389795790663111==
Content-Type: multipart/signed;
  boundary="nextPart1326818.FHYVZJv4IG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1326818.FHYVZJv4IG
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 20. Juli 2010 Emmanuel Florac wrote:
> > so a sunit value of 512 would mean 256KB stripe size which
> > is correct :-)
>=20
> exactly. Or use su and sw to specify the size in k, m, etc.
=20
Ah, I remember the difference now, that's why I use su=3D and sw=3D. This=20
mix of different units is... irritating.

I corrected the FAQ now to use su+sw:
http://xfs.org/index.php/XFS_FAQ#Q:_How_to_calculate_the_correct_sunit.2Csw=
idth_values_for_optimal_performance
And I mentioned "swidth" and "sunit" in a sentence in the end.

I'd say using su+sw is more future proof than swidth+sunit, as 4K sector=20
drives will become standard, and then using 512B units will be outdated=20
anyway, right? And using su+sw seems simpler to me to explain. YMMV,=20

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

--nextPart1326818.FHYVZJv4IG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxFuiMACgkQzhSR9xwSCbRMzQCgxl0H6Ghk/z1j3RdEqTAPHJgz
+4EAn3dGrdOzsJmLzM+q+5GEmLvso75B
=Xc1O
-----END PGP SIGNATURE-----

--nextPart1326818.FHYVZJv4IG--


--===============7312389795790663111==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7312389795790663111==--
