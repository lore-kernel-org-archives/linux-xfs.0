Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97BqP5I235643 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 06:52:25 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76063152D520
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 04:59:15 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id jcoZcbE0EiiBhJdE for
	<xfs@oss.sgi.com>; Fri, 07 Oct 2011 04:59:15 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 1973B512
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 13:52:21 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id D326BC000AD
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 13:52:20 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: TRIM on XFS
Date: Fri, 7 Oct 2011 13:52:19 +0200
MIME-Version: 1.0
Message-Id: <201110071352.20135@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7491572321647847060=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7491572321647847060==
Content-Type: multipart/signed;
  boundary="nextPart1330469.BvUNM9Bk2M";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1330469.BvUNM9Bk2M
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It's been a long time since I've been reading about TRIM. What is the=20
current state for XFS? I believe there's TRIM support, but only offline.=20
Can someone explain how to activate that and actually run a TRIM?

And there was some talk of "inline TRIM", i.e. always TRIMing on delete.=20
Is that implemented already?

We're on VMware with thin provisioned machines, and that would hugely=20
benefit from TRIM.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart1330469.BvUNM9Bk2M
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk6O5/QACgkQzhSR9xwSCbTdwACg85TKOiDKG1tU0Nk1Yo5WLCKl
f3sAoJzotHiJC0PAXVNtUD5UK0R1KULy
=TGKP
-----END PGP SIGNATURE-----

--nextPart1330469.BvUNM9Bk2M--


--===============7491572321647847060==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7491572321647847060==--
