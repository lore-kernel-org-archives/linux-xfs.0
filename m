Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p497o2Ek070983 for <xfs@oss.sgi.com>; Mon, 9 May 2011 02:50:04 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D2BE15A0911
	for <xfs@oss.sgi.com>; Mon,  9 May 2011 00:53:41 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 6UG1rnPZNaaxuOPA for
	<xfs@oss.sgi.com>; Mon, 09 May 2011 00:53:41 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id B6BE0522
	for <xfs@oss.sgi.com>; Mon,  9 May 2011 09:53:38 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 4794A401C3A
	for <xfs@oss.sgi.com>; Mon,  9 May 2011 09:53:35 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 2.6.38.4: xfs speed problem?
Date: Mon, 9 May 2011 09:53:34 +0200
References: <alpine.DEB.2.02.1105071042210.20162@p34.internal.lan>
	<20110508003321.GI26837@dastard>
	<4DC6D067.1080208@hardwarefreak.com>
In-Reply-To: <4DC6D067.1080208@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201105090953.35090@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0822843354851686935=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0822843354851686935==
Content-Type: multipart/signed;
  boundary="nextPart1586613.nOVb0Pkeg8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1586613.nOVb0Pkeg8
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

[removed some recipients]

On Sonntag, 8. Mai 2011 Stan Hoeppner wrote:
> remake the fs on the above device with 'sw=3D16' or remount with=20
> appropriate sunit and swidth values?

A remount wouldn't help the existing metadata layout. Would it be=20
sufficient to remount with sw=3D16 and then create a top-level dir,=20
wherein you recreate all existing dirs new, then hard-link each file and=20
remove the old directory structure?
Or would it be needed to copy the files too to get advantage of the new=20
sw?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart1586613.nOVb0Pkeg8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk3HnX8ACgkQzhSR9xwSCbR+xACbBRgo5xZgFVrkQm0R45Db9Pqb
mn0AoOvVtgxw8Wd3A3v+JhfQsss5J7c+
=CN/n
-----END PGP SIGNATURE-----

--nextPart1586613.nOVb0Pkeg8--


--===============0822843354851686935==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0822843354851686935==--
