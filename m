Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5AB3eAt070413 for <xfs@oss.sgi.com>; Thu, 10 Jun 2010 06:03:41 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A45510DEE79
	for <xfs@oss.sgi.com>; Thu, 10 Jun 2010 04:09:16 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id X3qHg4H1NVpToiwZ for
	<xfs@oss.sgi.com>; Thu, 10 Jun 2010 04:09:16 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 6342C400
	for <xfs@oss.sgi.com>; Thu, 10 Jun 2010 13:06:09 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 98D9783C804
	for <xfs@oss.sgi.com>; Thu, 10 Jun 2010 13:06:08 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: xfs_repair 3.1.2 crashing
Date: Thu, 10 Jun 2010 13:06:07 +0200
MIME-Version: 1.0
Message-Id: <201006101306.07587@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3579947457296519614=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

--===============3579947457296519614==
Content-Type: multipart/signed;
  boundary="nextPart1330499.8yamHWJK84";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1330499.8yamHWJK84
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Dear devs, I have a massive problem with a filesystem in our internal=20
server. We've had an overheating problem with the RAID controller CPU,=20
as it's very hot here and aircondition was turn off... the system "just"=20
stopped working. This is a XenServer with some Linuxen on it, and one of=20
them (of course our main server :-) reports this on xfs_repair:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 1
local inode 2267035928 attr too small (size =3D 3, min size =3D 4)
bad attribute fork in inode 2267035928, clearing attr fork
clearing inode 2267035928 attributes
cleared inode 2267035928
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 2
        - agno =3D 1
data fork in regular inode 2267035928 claims used block 537158068
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err =3D=3D 0=
'=20
failed.

Any ideas?

Before that, I had 3.0.3 installed, it found tons of errors before also=20
crashing. I'll send that log later.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1330499.8yamHWJK84
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwQxx8ACgkQzhSR9xwSCbTnaACgiMsTakowJQTkyJZFOfroe/YC
tWYAoOLOBla8HjNo5b0HR2c/paAXkG0I
=Uq3N
-----END PGP SIGNATURE-----

--nextPart1330499.8yamHWJK84--


--===============3579947457296519614==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3579947457296519614==--
