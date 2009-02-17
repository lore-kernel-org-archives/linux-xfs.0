Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1H90VHS213621 for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 03:00:32 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 07349128DD9
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 00:59:56 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id r9az6iMshDOQ6c2t for
	<xfs@oss.sgi.com>; Tue, 17 Feb 2009 00:59:56 -0800 (PST)
Received: from saturn.localnet (h081217054243.dyn.cm.kabsi.at [81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv1.zmi.at (Postfix) with ESMTP id D91FF401B
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 09:59:54 +0100 (CET)
Subject: XFS and XEN
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Date: Tue, 17 Feb 2009 09:59:54 +0100
MIME-Version: 1.0
Message-Id: <200902170959.55077@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0426473665266870107=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0426473665266870107==
Content-Type: multipart/signed;
  boundary="nextPart1234890518.tZPUzdmzcX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1234890518.tZPUzdmzcX
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Now I'm sure that the following configuration can destroy a PostgreSQL=20
8.3.5 database:

* Linux host with XEN, XFS filesystem with "nobarrier", RAID controller=20
with battery backed cache.
* XEN vm with XFS filesystem with "nobarrier" with postgresql
* your daughter with 3.5 years switching off the power supply of the=20
server

I guess one shouldn't use "nobarrier" on a XEN XFS domU machine.
Would that help? I'd like to enter this in the FAQ, as people (including=20
me) will be very upset to loose data, or destroy databases.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4






--nextPart1234890518.tZPUzdmzcX
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmafIsACgkQzhSR9xwSCbTqyACgnN66/1p9WmW6yJgmujK+GqHp
fggAn278FJri3ebJQUeuP8ZTDZ+QwYyi
=7ILG
-----END PGP SIGNATURE-----

--nextPart1234890518.tZPUzdmzcX--


--===============0426473665266870107==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0426473665266870107==--
