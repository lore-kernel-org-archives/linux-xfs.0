Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6FKtNdq223901 for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 15:55:24 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF04444CE70
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 13:58:17 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id csB9EPtIKNmB12nP for
	<xfs@oss.sgi.com>; Thu, 15 Jul 2010 13:58:17 -0700 (PDT)
Subject: Re: rsync and corrupt inodes (was xfs_dump problem)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Date: Thu, 15 Jul 2010 22:58:15 +0200
MIME-Version: 1.0
Message-Id: <201007152258.15631@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8717523481020181682=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8717523481020181682==
Content-Type: multipart/signed;
  boundary="nextPart2894284.vLW2t4x5Bq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2894284.vLW2t4x5Bq
Content-Type: multipart/mixed;
  boundary="Boundary-01=_nZ3PMiYCh3CA1Tb"
Content-Transfer-Encoding: 7bit


--Boundary-01=_nZ3PMiYCh3CA1Tb
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Ping?

On Montag, 5. Juli 2010 Dave Chinner wrote:
> > So far, so good. I'm on 2.6.34 now. Is there any chance for a fixed
> > version of xfs_repair, so that I can either get rid of the 4 broken
> > files (i.e. delete them), or repair the filesystem? ATM, xfs_repair
> > asserts on this filesystem.
>=20
> What version of xfs_repair? v3.1.2 does not assert fail here on the
> metadump image you posted, but it does take 3 runs to fix up all the
> problems with the busted inodes....

Do you mean this one?
http://zmi.at/saturn_bigdata.metadump.only_broken.bz2 (197 MB)

I have xfs_repair 3.1.2, and made a shell script which 10x does=20
xfs_repair that image, I attached the output here. Doesn't seem to=20
repair anything, just crashing.

Maybe I did something wrong? I configured xfsprogs 3.1.2 with
CFLAGS=3D-march=3Dathlon64-sse3 ./configure --prefix=3D/usr
and then=20
make;make install

I recompiled the whole thing now with
# gcc --version
gcc (SUSE Linux) 4.4.1 [gcc-4_4-branch revision 150839]

and it's the same output as ever. Either you meant another metadump, or=20
there is a problem somewhere I don't see.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--Boundary-01=_nZ3PMiYCh3CA1Tb
Content-Type: text/x-log;
  charset="utf-8";
  name="repair.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="repair.log"

xfs_repair version 3.1.2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
corrected attribute entry count in inode 649642, was 40, now 0
problem with attribute contents in inode 649642
local inode 649790 attr too small (size = 1, min size = 4)
bad attribute fork in inode 649790, clearing attr fork
clearing inode 649790 attributes
cleared inode 649790
        - agno = 1
local inode 2195133988 attr too small (size = 3, min size = 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 2
        - agno = 1
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
data fork in inode 2195133988 claims metadata block 537122652
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err == 0' failed.
xfs_repair version 3.1.2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
corrected attribute entry count in inode 649642, was 40, now 0
problem with attribute contents in inode 649642
local inode 649790 attr too small (size = 1, min size = 4)
bad attribute fork in inode 649790, clearing attr fork
clearing inode 649790 attributes
cleared inode 649790
        - agno = 1
local inode 2195133988 attr too small (size = 3, min size = 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
data fork in inode 2195133988 claims metadata block 537122652
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err == 0' failed.
xfs_repair version 3.1.2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
corrected attribute entry count in inode 649642, was 40, now 0
problem with attribute contents in inode 649642
local inode 649790 attr too small (size = 1, min size = 4)
bad attribute fork in inode 649790, clearing attr fork
clearing inode 649790 attributes
cleared inode 649790
        - agno = 1
local inode 2195133988 attr too small (size = 3, min size = 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
data fork in inode 2195133988 claims metadata block 537122652
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err == 0' failed.
xfs_repair version 3.1.2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
corrected attribute entry count in inode 649642, was 40, now 0
problem with attribute contents in inode 649642
local inode 649790 attr too small (size = 1, min size = 4)
bad attribute fork in inode 649790, clearing attr fork
clearing inode 649790 attributes
cleared inode 649790
        - agno = 1
local inode 2195133988 attr too small (size = 3, min size = 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
data fork in inode 2195133988 claims metadata block 537122652
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err == 0' failed.
xfs_repair version 3.1.2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
corrected attribute entry count in inode 649642, was 40, now 0
problem with attribute contents in inode 649642
local inode 649790 attr too small (size = 1, min size = 4)
bad attribute fork in inode 649790, clearing attr fork
clearing inode 649790 attributes
cleared inode 649790
        - agno = 1
local inode 2195133988 attr too small (size = 3, min size = 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
data fork in inode 649642 claims metadata block 537266460
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err == 0' failed.
xfs_repair version 3.1.2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
corrected attribute entry count in inode 649642, was 40, now 0
problem with attribute contents in inode 649642
local inode 649790 attr too small (size = 1, min size = 4)
bad attribute fork in inode 649790, clearing attr fork
clearing inode 649790 attributes
cleared inode 649790
        - agno = 1
local inode 2195133988 attr too small (size = 3, min size = 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
data fork in inode 2195133988 claims metadata block 537122652
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err == 0' failed.
xfs_repair version 3.1.2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
corrected attribute entry count in inode 649642, was 40, now 0
problem with attribute contents in inode 649642
local inode 649790 attr too small (size = 1, min size = 4)
bad attribute fork in inode 649790, clearing attr fork
clearing inode 649790 attributes
cleared inode 649790
        - agno = 1
local inode 2195133988 attr too small (size = 3, min size = 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
data fork in inode 649642 claims metadata block 537266460
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err == 0' failed.
xfs_repair version 3.1.2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
corrected attribute entry count in inode 649642, was 40, now 0
problem with attribute contents in inode 649642
local inode 649790 attr too small (size = 1, min size = 4)
bad attribute fork in inode 649790, clearing attr fork
clearing inode 649790 attributes
cleared inode 649790
        - agno = 1
local inode 2195133988 attr too small (size = 3, min size = 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
data fork in inode 649642 claims metadata block 537266460
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err == 0' failed.
xfs_repair version 3.1.2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
corrected attribute entry count in inode 649642, was 40, now 0
problem with attribute contents in inode 649642
local inode 649790 attr too small (size = 1, min size = 4)
bad attribute fork in inode 649790, clearing attr fork
clearing inode 649790 attributes
cleared inode 649790
        - agno = 1
local inode 2195133988 attr too small (size = 3, min size = 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
data fork in inode 2195133988 claims metadata block 537122652
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err == 0' failed.
xfs_repair version 3.1.2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
corrected attribute entry count in inode 649642, was 40, now 0
problem with attribute contents in inode 649642
local inode 649790 attr too small (size = 1, min size = 4)
bad attribute fork in inode 649790, clearing attr fork
clearing inode 649790 attributes
cleared inode 649790
        - agno = 1
local inode 2195133988 attr too small (size = 3, min size = 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 1
        - agno = 0
        - agno = 3
        - agno = 2
        - agno = 4
        - agno = 5
data fork in inode 2195133988 claims metadata block 537122652
        - agno = 6
        - agno = 7
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err == 0' failed.

--Boundary-01=_nZ3PMiYCh3CA1Tb--

--nextPart2894284.vLW2t4x5Bq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkw/dmcACgkQzhSR9xwSCbSWhACfdo8IBvEDxs3ZTqpydbjGD10T
Dp8AoOT3+G3gg+DPKF6TXp95tR+MAmgb
=43uX
-----END PGP SIGNATURE-----

--nextPart2894284.vLW2t4x5Bq--


--===============8717523481020181682==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8717523481020181682==--
