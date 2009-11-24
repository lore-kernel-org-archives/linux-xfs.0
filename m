Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAOB3xKJ122812 for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 05:04:00 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56A8AD7AE5A
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 03:04:22 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id ucT3JJ4CBTI1jfPs for
	<xfs@oss.sgi.com>; Tue, 24 Nov 2009 03:04:22 -0800 (PST)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 7F3EFC00406
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 12:04:21 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 706C583C824
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 12:06:52 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: XFS quota setup
Date: Tue, 24 Nov 2009 12:03:45 +0100
MIME-Version: 1.0
Message-Id: <200911241203.45604@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6797679146973749997=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6797679146973749997==
Content-Type: multipart/signed;
  boundary="nextPart12598626.lvofjm31aH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart12598626.lvofjm31aH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I took this from the manpage:
xfs_quota -x -c 'project -s upload' /disks/sharestore/upload/
xfs_quota: cannot setup path for mount /disks/sharestore/upload/: No=20
such device or address

but this works:
cd /disks/sharestore/
xfs_quota -x -c 'project -s upload'

Maybe the docs can be simpler? It's confusing now.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

--nextPart12598626.lvofjm31aH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAksLvZEACgkQzhSR9xwSCbQEWQCgumBr2lhj17H6JeyqvbiBE1vW
ElAAn2cqzRCpPXc2CNBs+BEdq6wGG/XO
=6ha5
-----END PGP SIGNATURE-----

--nextPart12598626.lvofjm31aH--


--===============6797679146973749997==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6797679146973749997==--
