Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4R6tILm117906 for <xfs@oss.sgi.com>; Thu, 27 May 2010 01:55:18 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 943F237AB20
	for <xfs@oss.sgi.com>; Wed, 26 May 2010 23:57:41 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id o7ltVTYynj1KMiis for
	<xfs@oss.sgi.com>; Wed, 26 May 2010 23:57:41 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id CC239800184
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 08:57:39 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 7615983C804
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 08:57:39 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: puzzling error: XenServer, LVM and XFS
Date: Thu, 27 May 2010 08:57:38 +0200
MIME-Version: 1.0
Message-Id: <201005270857.39048@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6883727878221218155=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6883727878221218155==
Content-Type: multipart/signed;
  boundary="nextPart1400176.4lrSpho5rt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1400176.4lrSpho5rt
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I have a problem I can recreate, but have no idea where to ask/report=20
it. I have a XenServer 5.5 based Virtual Machine with a running openSUSE=20
11.2. Everything running fine.

Now I add another disk (which is an LVM volume on the host), there there=20
I create a partition. In this partition, I create an LVM volume:
pvcreate ..
vgcreate ..
lvcreate ..
So far no problem.

Now I create an XFS:
mkfs.xfs /dev/test/test
mount /dev/test/test /1

I can reproduce and get tons of these errors on 2 different XenServers=20
in 2 different VMs:

May 27 08:32:11 zdb13 kernel: [  738.046895] end_request: I/O error, dev=20
xvdc, sector 0

This only happens after XFS is mounted from the LVM volume. On another=20
machine where active I/O is happening, I get tons of these errors every=20
some seconds.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1400176.4lrSpho5rt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkv+F+MACgkQzhSR9xwSCbTc3ACgmI2qeDY02o7MdaRxxxVvuatr
c+UAoOLokTjKCirI0jR4BPWp+Ie+nLrs
=bTBF
-----END PGP SIGNATURE-----

--nextPart1400176.4lrSpho5rt--


--===============6883727878221218155==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6883727878221218155==--
