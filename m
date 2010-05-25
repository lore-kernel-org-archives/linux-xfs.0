Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PFNTQK261970 for <xfs@oss.sgi.com>; Tue, 25 May 2010 10:23:30 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D632A10A0F12
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 08:27:31 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id hBKg38Kw1nvds8aM for
	<xfs@oss.sgi.com>; Tue, 25 May 2010 08:27:31 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 364FF800183
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 17:25:49 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id DDD8283C804
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 17:25:48 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: LVM snapshot not mountable
Date: Tue, 25 May 2010 17:25:44 +0200
MIME-Version: 1.0
Message-Id: <201005251725.48452@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8052506050782169590=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8052506050782169590==
Content-Type: multipart/signed;
  boundary="nextPart1564460.s3vZlzesEH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1564460.s3vZlzesEH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

This might be LVM specific, please apologize. For the first time I play=20
around with LVM snapshots. I tried this:
lvcreate -s -n dbsnap -L 4G -v /dev/db/mysql
mount /dev/db/dbnap /mnt
but the mount fails, dmesg says:
[  598.440324] XFS: Filesystem dm-1 has duplicate UUID - can't mount

How could I mount it?

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1564460.s3vZlzesEH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkv76/wACgkQzhSR9xwSCbQUhwCg5UidsleNzChOWteN2G9OYapE
6V0AmwXkcwASoM3lbmkRvFUQyY4upLO9
=ntmi
-----END PGP SIGNATURE-----

--nextPart1564460.s3vZlzesEH--


--===============8052506050782169590==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8052506050782169590==--
