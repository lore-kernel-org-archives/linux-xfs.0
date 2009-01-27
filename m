Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0R9VSOt034467 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 03:31:28 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F04C2BCA63
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 01:30:44 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id b5AjaJZWMVW2RYwy for
	<xfs@oss.sgi.com>; Tue, 27 Jan 2009 01:30:44 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 39B432A81
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 10:30:43 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 97E9C40016B
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 10:30:43 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Strange fragmentation in nearly empty filesystem
Date: Tue, 27 Jan 2009 10:30:38 +0100
References: <20090123102130.GB8012@doctronic.de>
	<20090127071023.GA16511@doctronic.de>
	<20090127084034.GA16931@doctronic.de>
In-Reply-To: <20090127084034.GA16931@doctronic.de>
MIME-Version: 1.0
Message-Id: <200901271030.43234@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5704110207591981855=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5704110207591981855==
Content-Type: multipart/signed;
  boundary="nextPart1375990.A9ZJ7ipSMV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit


--nextPart1375990.A9ZJ7ipSMV
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Dienstag 27 Januar 2009 Carsten Oberscheid wrote:
> root@ubuntu# cp foo.vmem test

What if you dd if=3Dfoo.vmem of=3Dtest bs=3D1000 ? That would do nearly the=
=20
same as your "create empty file" test.

mfg zmi
--=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart1375990.A9ZJ7ipSMV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkl+1EMACgkQzhSR9xwSCbQTggCfWttNBj/ZybhN2ULFaxRNnUFe
FaUAnR4B3q9giZjwXnobjHaiEkrOAYlW
=Lbre
-----END PGP SIGNATURE-----

--nextPart1375990.A9ZJ7ipSMV--


--===============5704110207591981855==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5704110207591981855==--
