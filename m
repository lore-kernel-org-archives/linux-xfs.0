Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KItdIl035184 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 13:55:39 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CF3245CB80
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 11:58:37 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id dtyFdj34JfqvgNcI for
	<xfs@oss.sgi.com>; Tue, 20 Jul 2010 11:58:37 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 2201B400
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 20:58:36 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id C226983C82E
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 20:57:47 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: 4k sector drives
Date: Tue, 20 Jul 2010 20:58:27 +0200
MIME-Version: 1.0
Message-Id: <201007202058.35141@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3347529337919464080=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3347529337919464080==
Content-Type: multipart/signed;
  boundary="nextPart2946653.uYl0X8xdK7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2946653.uYl0X8xdK7
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Dear list, I don't know who else to ask this:

I recently bought 2 new 4k sector drives (WD Caviar Green 2TB,=20
WD20EARS), but Linux kernel 2.6.34.1 still says:

# blockdev --getss /dev/sdd
512

Shouldn't that be 4096? Where is the problem?


=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart2946653.uYl0X8xdK7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxF8dsACgkQzhSR9xwSCbSVUACfTqWNQecKS/Ys5PfDAjt4N9F3
Q9kAnjAy7eHybdNjwwnEJZTKAdWSN4Br
=oCe6
-----END PGP SIGNATURE-----

--nextPart2946653.uYl0X8xdK7--


--===============3347529337919464080==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3347529337919464080==--
