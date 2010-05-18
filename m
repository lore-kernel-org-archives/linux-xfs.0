Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4IBm1rm050049 for <xfs@oss.sgi.com>; Tue, 18 May 2010 06:48:01 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E375013F7D28
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 04:50:17 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id YBipEnrhcSxUnZsk for
	<xfs@oss.sgi.com>; Tue, 18 May 2010 04:50:17 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 1863F800139
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 13:50:16 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id C87A883C804
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 13:50:15 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: rsync from xfs to nfs+xfs and ACL problems
Date: Tue, 18 May 2010 13:50:15 +0200
MIME-Version: 1.0
Message-Id: <201005181350.15308@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2210268666997794125=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2210268666997794125==
Content-Type: multipart/signed;
  boundary="nextPart2098071.Zbsv3MNRes";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2098071.Zbsv3MNRes
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello, I'm trying to rsync from an xfs with ACLs set to another server=20
which has an xfs filesystem. I mounted the nfs using=20
rw,noatime,nodiratime,acl,rsize=3D65536,wsize=3D65536,nfsvers=3D3,proto=3Dt=
cp,mountproto=3Dtcp
and I get these errors:

rsync: rsync_xal_set: lsetxattr("anse/Software=20
ANDY/Bfort.exe","trusted.SGI_ACL_FILE") failed: Operation not supported=20
(95)
rsync: rsync_xal_set: lsetxattr("anse/Software=20
ANDY/CWShredLast.exe","trusted.SGI_ACL_FILE") failed: Operation not=20
supported (95)
rsync: rsync_xal_set: lsetxattr("anse/Software=20
ANDY/CWSysinfo_130.zip","trusted.SGI_ACL_FILE") failed: Operation not=20
supported (95)

Does it mean I can't sync ACLs? How could I do it? I need a full backup=20
including ACLs, as I want to move all data and then restore.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart2098071.Zbsv3MNRes
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkvyfvcACgkQzhSR9xwSCbSsUwCffAXnbVJir09oRG6YK+CRBXC8
sBcAoN+fDHsAoh5w3H1GGPAO4pgIJ27w
=Lvrs
-----END PGP SIGNATURE-----

--nextPart2098071.Zbsv3MNRes--


--===============2210268666997794125==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2210268666997794125==--
