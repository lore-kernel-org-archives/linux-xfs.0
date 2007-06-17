Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Jun 2007 19:39:17 -0700 (PDT)
Received: from smtpout.eastlink.ca (smtpout.eastlink.ca [24.222.0.30])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5J2dCdo024134
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2007 19:39:13 -0700
Received: from ip03.eastlink.ca ([24.222.10.15])
 by mta01.eastlink.ca (Sun Java System Messaging Server 6.2-4.03 (built Sep 22
 2005)) with ESMTP id <0JJR008QRYU20AT0@mta01.eastlink.ca> for xfs@oss.sgi.com;
 Sun, 17 Jun 2007 07:08:26 -0300 (ADT)
Received: from peter by llama.cordes.ca with local (Exim 3.36 #1 (Debian))
	id 1HzrgF-00067w-00	for <xfs@oss.sgi.com>; Sun, 17 Jun 2007 07:08:23 -0300
Date: Sun, 17 Jun 2007 07:08:23 -0300
From: Peter Cordes <peter@cordes.ca>
Subject: XFS_IOC_RESVSP64 for swap files
Message-id: <20070617100822.GA4586@cordes.ca>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=1yeeQ81UyVL57Vl7
Content-disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

 Hi XFS list.  I'm not subscribed, please CC me.

 Programs such as swapspace and swapd create new swap files when vmem runs
low.  They would benefit hugely from being able to create a swapfile without
any significant disk I/O.  (If a process grabs a lot of memory quickly, the
system will be swapping hard while swapspace(8) is writing a swapfile.)

unfortunately,
 touch foo
 xfs_io -c 'truncate 1000000000' -c "resvsp 0 1000000000" foo
 mkswap foo
 sudo swapon foo
doesn't work.  The kernel complains:
 swapon: swapfile has holes

 foo is a ~1GB file with disk space allocated for it, though.  But reading
it doesn't create any disk I/O and reads all zero, so it's treated like a
sparse file.  Is this because my filesystem flags unwritten extents?  And if
my FS was created with that option off, would RESVSP make the file contain
the previous contents of that disk space?  That would be an obvious security
hole, but it would still be useful for making swap files even if only root
could do it.

 So, any ideas on how to make swap files without writing the whole file?
(swapd and swapspace both avoid deleting swap files right away, IIRC, so
don't suggest workarounds unless you have something really clever...)

 Could swapon(2) in the kernel be made to work on XFS files with reserved
space?  i.e. call something that would give XFS a chance to mark all the
extents as written, even though they're not.  Memory content is at least
as sensitive as anything in the filesystem, and if this file is going to be
trusted with that, it hardly matters if it also has parts of deleted files.




 I'm on GNU/Linux: Ubuntu Feisty AMD64, Linux 2.6.20-16-generic.
xfs_io version 2.8.18

peter@tesla:/var/tmp/peter$ xfs_info /var/tmp
meta-data=3D/dev/evms/temp         isize=3D256    agcount=3D16, agsize=3D80=
0767 blks
         =3D                       sectsz=3D512   attr=3D0
data     =3D                       bsize=3D4096   blocks=3D12812272, imaxpc=
t=3D25
         =3D                       sunit=3D0      swidth=3D0 blks, unwritte=
n=3D1
naming   =3Dversion 2              bsize=3D4096=20=20
log      =3Dinternal               bsize=3D4096   blocks=3D3328, version=3D1
         =3D                       sectsz=3D512   sunit=3D0 blks
realtime =3Dnone                   extsz=3D65536  blocks=3D0, rtextents=3D0


 BTW, I think xfs_allocsp has its args reversed, or something.
touch bar
xfs_io -c "allocsp 0 1000000" bar; ll -h
-rw-rw-r-- 1 peter peter    0 2007-06-17 06:45 bar
xfs_io -c "allocsp 1000000 0" bar; ll -h
-rw-rw-r-- 1 peter peter 977K 2007-06-17 06:45 bar

--=20
#define X(x,y) x##y
Peter Cordes ;  e-mail: X(peter@cor , des.ca)

"The gods confound the man who first found out how to distinguish the hours!
 Confound him, too, who in this place set up a sundial, to cut and hack
 my day so wretchedly into small pieces!" -- Plautus, 200 BC

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iQC1AwUBRnUIFgWkmhLkWuRTAQI2GAUArdnx0qcgnb8zSKSPjA7XQvAUS/mePJEr
lq7yFqgByftDbMd/7A4so4WJ2cB2LfylAIs+mlClpVm6n5Pwn61jwFGPypGdNhiK
Anlwd9zBa7B0Mic3Sw8DvDBwzsBPS9lUxiU0maGMpIfHw5MntZPvI6OA3feoCfI2
1aYYgj1Um5enASHBj/vHV4ORcXYX3NH2URmlucFGPCG7o6sspytZ8w==
=xxC2
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
