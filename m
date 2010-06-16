Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5GEW0SJ132675 for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 09:32:00 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC45CB0176C
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 07:38:14 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id flAsTtilG9IXcBoj for
	<xfs@oss.sgi.com>; Wed, 16 Jun 2010 07:38:14 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 9252817A
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 16:34:33 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 24D1F83C829
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 16:34:22 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: wrong man page of xfs_metadump
Date: Wed, 16 Jun 2010 16:34:32 +0200
MIME-Version: 1.0
Message-Id: <201006161634.32825@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3060285625230407622=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3060285625230407622==
Content-Type: multipart/signed;
  boundary="nextPart4564665.AI9ZlAWqHW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4564665.AI9ZlAWqHW
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

The man page says:
xfs_metadump should only be used to copy unmounted filesystems, read-
only mounted filesystems, or frozen filesystems (see xfs_freeze(8)). =20
Otherwise, the generated dump could be inconsistent or corrupt.

I tried to use it nevertheless, but it doesn't run at all:
xfs_metadump: /dev/orionStore/data contains a mounted and writable=20
filesystem
fatal error -- couldn't initialize XFS library

So the wording should better be
xfs_metadump can only be used to copy unmounted filesystems, read-only=20
mounted filesystems, or frozen filesystems (see xfs_freeze(8)).  It=20
refuses to work with r/w mounted filesystems.



=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart4564665.AI9ZlAWqHW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwY4PgACgkQzhSR9xwSCbTVygCg6j5Jtc/pHv0OWbjeB2Hgp1FV
sfMAoMwupMnGBEce44N7xYE3m4BuE/J+
=ii+n
-----END PGP SIGNATURE-----

--nextPart4564665.AI9ZlAWqHW--


--===============3060285625230407622==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3060285625230407622==--
