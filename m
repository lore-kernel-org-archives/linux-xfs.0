Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9QMWKLb110645 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 17:32:21 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2FA41600381
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 15:33:38 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id lUFVJotrOxIjUCcs for
	<xfs@oss.sgi.com>; Tue, 26 Oct 2010 15:33:38 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 1FF5B17C
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 00:33:37 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 2B7EF401C3D
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 00:33:36 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: XFS Performance on NetApp
Date: Wed, 27 Oct 2010 00:33:35 +0200
MIME-Version: 1.0
Message-Id: <201010270033.35894@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3134247249871137003=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3134247249871137003==
Content-Type: multipart/signed;
  boundary="nextPart1760448.QiIqxk3psY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1760448.QiIqxk3psY
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Does anybody have a report how XFS behaves on a NetApp storage with thin=20
provisioning? They have a completely "weird" storage, their WAFL (write=20
anywhere file layout) together with deduplication and other things make=20
me think the best is to not-at-all specify any "performance options" in=20
mkfs/mount, like sunit/swidth or largeio, swalloc, etc.

Does someone have information on that?

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Radiointerview zum Thema Spam ******
http://www.it-podcast.at/archiv.html#podcast-100716

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1760448.QiIqxk3psY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzHVz8ACgkQzhSR9xwSCbS7CACgkkFuufq6T9nqCThDuWoTrr/V
HWcAnRP8LsibNpPKCH96/5DxWmU5gd+G
=KBcz
-----END PGP SIGNATURE-----

--nextPart1760448.QiIqxk3psY--


--===============3134247249871137003==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3134247249871137003==--
