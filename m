Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAFADu6u041303 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 04:13:56 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CB0E24F270
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 02:13:54 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 9odG11Gl4h5wCbZR for
	<xfs@oss.sgi.com>; Tue, 15 Nov 2011 02:13:54 -0800 (PST)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 1CEC7182242E
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 11:13:53 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 280F6E18C15
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 11:13:56 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: xfs_repair believes filesystem is mounted
Date: Tue, 15 Nov 2011 11:13:47 +0100
MIME-Version: 1.0
Message-Id: <201111151113.52228@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0117734493159876267=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0117734493159876267==
Content-Type: multipart/signed;
  boundary="nextPart2415195.lviGoeDqk2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2415195.lviGoeDqk2
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

******************************************
# xfs_repair -n /dev/xvdc1
xfs_repair: /dev/xvdc1 contains a mounted and writable filesystem

fatal error -- couldn't initialize XFS library
******************************************
I did a clean umount, then this error came. So I mounted and umounted=20
again, no way. I tested with
# mount|grep xvdc
and there's no output, so the filesystem shouldn't be mounted. Am I=20
missing something? I did=20
# xfs_repair -nf /dev/xvdc1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
sb_icount 417856, counted 421696
sb_ifree 9530, counted 8156
sb_fdblocks 74472418, counted 245931172
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 5
        - agno =3D 4
        - agno =3D 3
        - agno =3D 2
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

So should I do it without "-n"?

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart2415195.lviGoeDqk2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk7CO2AACgkQzhSR9xwSCbSuPwCgzfJUBN5M2dMF/2GutajhelDz
SFEAn2YTts2Pd70TSdOt6C0Q7W5q3viO
=eE/T
-----END PGP SIGNATURE-----

--nextPart2415195.lviGoeDqk2--


--===============0117734493159876267==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0117734493159876267==--
