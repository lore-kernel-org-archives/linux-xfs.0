Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7C9EXNa091900 for <xfs@oss.sgi.com>; Sun, 12 Aug 2012 04:14:33 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id udVuUe0WDnnIAwsn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 Aug 2012 02:14:30 -0700 (PDT)
Received: from mailsrv.i.zmi.at (mailgate.i.zmi.at [10.72.17.3])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPS id E99B31800185
	for <xfs@oss.sgi.com>; Sun, 12 Aug 2012 11:14:27 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	by mailsrv.i.zmi.at (Postfix) with ESMTP id B14B0C8C449
	for <xfs@oss.sgi.com>; Sun, 12 Aug 2012 11:14:36 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: howto keep xfs directory searches fast for a long time
Date: Sun, 12 Aug 2012 11:14:22 +0200
Message-ID: <6344220.LKveJofnHA@saturn>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8584240910641599949=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>


--===============8584240910641599949==
Content-Type: multipart/signed; boundary="nextPart1406184.WAYbJTnMsq"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart1406184.WAYbJTnMsq
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

I need a VMware VM that has 8TB storage. As I can at max create a 2TB=20=

disk, I need to add 4 disks, and use lvm to concat these. All is on top=
=20
of a RAID5 or RAID6 store.

The workload will be storage of mostly large media files (5TB mkv Video=
=20
+ 1TB mp3), plus backup of normal documents (1TB .odt,.doc,.pdf etc).=20=

The server should be able to find files quickly, transfer speed is not=20=

important. There won't be many deletes to media files, mostly uploads=20=

and searching for files. Only when it grows full, old files will be=20
removed. But normal documents will be rsynced (used as backup=20
destination) regularly.
I will set vm.vfs_cache_pressure =3D 10, this helps at least keeping=20=

inodes cached when they were read once.

- What is the best setup to get high speed on directory searches? Find,=
=20
ls, du, etc. should be quick.=20
- Should I use inode64 or not?
- If that's an 8 disk RAID-6, should I mkfs.xfs with 6*4 AGs? Or what=20=

would be a good start, or wouldn't it matter at all?

And as it'll be mostly big media files, should I use sunit/swidth set t=
o=20
64KB/6*64KB, does that make sense?

I'm asking because I had such a VM setup once, and while it was fairly=20=

quick in the beginning, over time it felt much slower on traversing=20
directories, very seek bound. That xfs was only 80% filled, so shouldn'=
t=20
have had a fragmentation problem. And I know nothing to fix that apart=20=

from backup/restore, so maybe there's something to prevent that?

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531
--nextPart1406184.WAYbJTnMsq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlAnc/MACgkQzhSR9xwSCbTSGACeNOZQbhwltGIBGBV9RpZrxKLr
zowAn1c6ykB4P+cBakkV0Hot3rNETdOJ
=fW71
-----END PGP SIGNATURE-----

--nextPart1406184.WAYbJTnMsq--


--===============8584240910641599949==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8584240910641599949==--
