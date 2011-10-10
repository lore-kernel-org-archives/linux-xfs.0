Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A6TolM156369 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 01:29:51 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FF56152F32F
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 23:36:57 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 14KgY7LyRGnART52 for
	<xfs@oss.sgi.com>; Sun, 09 Oct 2011 23:36:57 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 4969C41D
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 08:29:47 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 03B7FC000AD
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 08:29:47 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: TRIM on XFS
Date: Mon, 10 Oct 2011 08:29:44 +0200
References: <201110071352.20135@zmi.at> <20111007233450.GK3159@dastard>
In-Reply-To: <20111007233450.GK3159@dastard>
MIME-Version: 1.0
Message-Id: <201110100829.45823@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0469652275136954008=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0469652275136954008==
Content-Type: multipart/signed;
  boundary="nextPart4075793.PJRUQKi2J8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4075793.PJRUQKi2J8
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Samstag, 8. Oktober 2011 Dave Chinner wrote:
> e84661a xfs: add online discard support
>=20
> and=20
>=20
> a46db60 xfs: add FITRIM support

I guess that means those patches are not released by now? Sorry, I know=20
that these numbers are the patch ID, but don't know what to do with it.

> So both online and background trim methods are available.=20

I found the threads in the mailing list. FITRIM v3 Patch was posted=20
7.Jan.2011, but even if it's in default kernel already - how would you=20
call it?

> Test well before using them in production, though, as buggy hardware
> or thinp implementations are quite common....

I have a NetApp Storage here that is quite capable :-)
Just having no idea how to activate filesystem discard support :-(

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart4075793.PJRUQKi2J8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk6SkNkACgkQzhSR9xwSCbRt4wCcDnXo/fVgtpU4hpAWkKx9bRCA
fPoAoNcv/r3urszA1Z/Sc20dHTsFo5fd
=a0TZ
-----END PGP SIGNATURE-----

--nextPart4075793.PJRUQKi2J8--


--===============0469652275136954008==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0469652275136954008==--
