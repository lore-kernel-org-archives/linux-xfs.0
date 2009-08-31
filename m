Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7V6ep4n079333 for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 01:41:01 -0500
Received: from mailsrv5.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C552C158D54C
	for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 23:41:14 -0700 (PDT)
Received: from mailsrv5.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 1ALr3lCghAr540nw for
	<xfs@oss.sgi.com>; Sun, 30 Aug 2009 23:41:14 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv5.zmi.at (Postfix) with ESMTP id 944283D1
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 08:41:10 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 4C01B40015E
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 08:41:11 +0200 (CEST)
Subject: Re: bad fs - xfs_repair 3.01 crashes on it
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Date: Mon, 31 Aug 2009 08:40:35 +0200
MIME-Version: 1.0
Message-Id: <200908310840.40778@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4035637018113347879=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4035637018113347879==
Content-Type: multipart/signed;
  boundary="nextPart1438306.76unczFdfp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1438306.76unczFdfp
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sonntag 12 Juli 2009 Eric Sandeen wrote:
> If you do want to try deleting that one file or other such tricks,
> you can do it on a sparse metadata image of the fs as a dry run:
>
> # xfs_metadump -o /dev/whatever metadump.img
> # xfs_mdrestore metadump.img filesystem.img
> # mount -o loop filesystem.img mnt/
> # <fiddle as you please>
> # umount mnt/
> # xfs_repair filesystem.img
> # mount -o loop filesystem.img mnt/
>
> and see what happens...

To warm up the old thread, I did this now:

* make metadump
* mount it
* remove unneeded files/dirs
This already produced lots of errors, where files/dirs couldn't be=20
deleted. I made a metadump of this again, it's on=20
http://zmi.at/xfs.metadump-brokenonly.bz2

Then I tried with v3.0.1:
# xfs_repair xfs.img=20
Phase 1 - find and verify superblock...     =20
Phase 2 - using internal log                =20
        - zero log...                       =20
        - scan filesystem freespace and inode maps...
        - found root inode chunk                    =20
Phase 3 - for each AG...                            =20
        - scan and clear agi unlinked lists...      =20
        - process known inodes and perform inode discovery...
        - agno =3D 0                                          =20
        - agno =3D 1                                          =20
        - agno =3D 2                                          =20
        - agno =3D 3                                          =20
        - agno =3D 4                                          =20
        - agno =3D 5                                          =20
        - agno =3D 6                                          =20
        - agno =3D 7                                          =20
        - agno =3D 8                                          =20
        - agno =3D 9                                          =20
        - agno =3D 10                                         =20
        - agno =3D 11                                         =20
        - agno =3D 12                                         =20
        - agno =3D 13                                         =20
        - agno =3D 14                                         =20
local inode 3857051697 attr too small (size =3D 3, min size =3D 4)
bad attribute fork in inode 3857051697, clearing attr fork   =20
clearing inode 3857051697 attributes                         =20
cleared inode 3857051697                                     =20
        - agno =3D 15                                          =20
        - agno =3D 16                                          =20
        - agno =3D 17                                          =20
        - agno =3D 18                                          =20
        - agno =3D 19                                          =20
        - agno =3D 20                                          =20
        - agno =3D 21                                          =20
        - agno =3D 22                                          =20
        - agno =3D 23                                          =20
        - agno =3D 24                                          =20
        - agno =3D 25                                          =20
        - agno =3D 26                                          =20
        - agno =3D 27                                          =20
        - agno =3D 28                                          =20
        - agno =3D 29                                          =20
        - agno =3D 30                                          =20
        - agno =3D 31                                          =20
        - agno =3D 32                                          =20
        - agno =3D 33                                          =20
        - agno =3D 34                                          =20
        - agno =3D 35                                          =20
        - agno =3D 36                                          =20
        - agno =3D 37                                          =20
        - agno =3D 38                                          =20
        - agno =3D 39                                          =20
        - process newly discovered inodes...                 =20
Phase 4 - check for duplicate blocks...                      =20
        - setting up duplicate extent list...                =20
        - check for inodes claiming duplicate blocks...      =20
        - agno =3D 0                                           =20
        - agno =3D 1                                           =20
        - agno =3D 2                                           =20
        - agno =3D 3                                           =20
        - agno =3D 4                                           =20
        - agno =3D 5                                           =20
        - agno =3D 6                                           =20
        - agno =3D 7                                           =20
        - agno =3D 8                                           =20
        - agno =3D 9                                           =20
        - agno =3D 10                                          =20
        - agno =3D 11                                          =20
        - agno =3D 12                                          =20
        - agno =3D 13                                          =20
        - agno =3D 14                                          =20
        - agno =3D 15                                          =20
        - agno =3D 16                                          =20
        - agno =3D 17                                          =20
        - agno =3D 18                                          =20
data fork in regular inode 3857051697 claims used block 537546384
        - agno =3D 19                                             =20
xfs_repair: dinode.c:2108: process_inode_data_fork: Zusicherung =BBerr =3D=
=3D=20
0=AB nicht erf=FCllt.
Abgebrochen                                                                =
             =20

So I patched out the ASSERT in #dinode.c:2108 and this made:

# xfs_repair xfs.img                                            =20
Phase 1 - find and verify superblock...                                    =
             =20
Phase 2 - using internal log                                               =
             =20
        - zero log...                                                      =
             =20
        - scan filesystem freespace and inode maps...                      =
             =20
        - found root inode chunk                                           =
             =20
Phase 3 - for each AG...                                                   =
             =20
        - scan and clear agi unlinked lists...                             =
             =20
        - process known inodes and perform inode discovery...              =
             =20
        - agno =3D 0                                                       =
               =20
        - agno =3D 1                                                       =
               =20
        - agno =3D 2                                                       =
               =20
        - agno =3D 3                                                       =
               =20
        - agno =3D 4                                                       =
               =20
        - agno =3D 5                                                       =
               =20
        - agno =3D 6                                                       =
               =20
        - agno =3D 7                                                       =
               =20
        - agno =3D 8                                                       =
               =20
        - agno =3D 9                                                       =
               =20
        - agno =3D 10                                                      =
               =20
        - agno =3D 11                                                      =
               =20
        - agno =3D 12                                                      =
               =20
        - agno =3D 13                                                      =
               =20
        - agno =3D 14                                                      =
               =20
local inode 3857051697 attr too small (size =3D 3, min size =3D 4)         =
                 =20
bad attribute fork in inode 3857051697, clearing attr fork                 =
             =20
clearing inode 3857051697 attributes                                       =
             =20
cleared inode 3857051697                                                   =
             =20
        - agno =3D 15                                                      =
               =20
        - agno =3D 16                                                      =
               =20
        - agno =3D 17                                                      =
               =20
        - agno =3D 18                                                      =
               =20
        - agno =3D 19                                                      =
               =20
        - agno =3D 20                                                      =
               =20
        - agno =3D 21                                                      =
               =20
        - agno =3D 22                                                      =
               =20
        - agno =3D 23                                                      =
               =20
        - agno =3D 24                                                      =
               =20
        - agno =3D 25                                                      =
               =20
        - agno =3D 26                                                      =
               =20
        - agno =3D 27                                                      =
               =20
        - agno =3D 28                                                      =
               =20
        - agno =3D 29                                                      =
               =20
        - agno =3D 30                                                      =
               =20
        - agno =3D 31                                                      =
               =20
        - agno =3D 32                                                      =
               =20
        - agno =3D 33                                                      =
               =20
        - agno =3D 34                                                      =
               =20
        - agno =3D 35                                                      =
               =20
        - agno =3D 36                                                      =
               =20
        - agno =3D 37                                                      =
               =20
        - agno =3D 38                                                      =
               =20
        - agno =3D 39                                                      =
               =20
        - process newly discovered inodes...                               =
             =20
Phase 4 - check for duplicate blocks...                                    =
             =20
        - setting up duplicate extent list...                              =
             =20
        - check for inodes claiming duplicate blocks...                    =
             =20
        - agno =3D 0                                                       =
               =20
        - agno =3D 1                                                       =
               =20
        - agno =3D 2                                                       =
               =20
        - agno =3D 3                                                       =
               =20
        - agno =3D 4                                                       =
               =20
        - agno =3D 5                                                       =
               =20
        - agno =3D 6                                                       =
               =20
        - agno =3D 7                                                       =
               =20
        - agno =3D 8                                                       =
               =20
        - agno =3D 9                                                       =
               =20
        - agno =3D 10                                                      =
               =20
        - agno =3D 11                                                      =
               =20
        - agno =3D 12                                                      =
               =20
        - agno =3D 13                                                      =
               =20
        - agno =3D 14
        - agno =3D 15
        - agno =3D 16
        - agno =3D 17
        - agno =3D 18
        - agno =3D 19
        - agno =3D 20
data fork in regular inode 3857051697 claims used block 537546384
bad attribute format 1 in inode 3857051697, resetting value
correcting nblocks for inode 3857051697, was 10135251 - counted 8388604
        - agno =3D 21
        - agno =3D 22
        - agno =3D 23
        - agno =3D 24
data fork in regular inode 6174936063 claims used block 537240415
correcting nblocks for inode 6174936063, was 1 - counted 0
data fork in regular inode 6180186880 claims used block 537242879
correcting nblocks for inode 6180186880, was 1 - counted 0
        - agno =3D 25
        - agno =3D 26
        - agno =3D 27
data fork in regular inode 7257143306 claims used block 537251790
correcting nblocks for inode 7257143306, was 1 - counted 0
data fork in regular inode 7257143307 claims used block 537257951
correcting nblocks for inode 7257143307, was 1 - counted 0
data fork in regular inode 6720520457 claims used block 537246687
correcting nblocks for inode 6720520457, was 1 - counted 0
data fork in regular inode 6720520458 claims used block 537247327
correcting nblocks for inode 6720520458, was 1 - counted 0
        - agno =3D 28
        - agno =3D 29
        - agno =3D 30
        - agno =3D 31
data fork in regular inode 8326467385 claims used block 537198367
correcting nblocks for inode 8326467385, was 1 - counted 0
        - agno =3D 32
inode block 537201328 multiply claimed, state was 3
inode block 537201329 multiply claimed, state was 3
inode block 537201330 multiply claimed, state was 3
data fork in regular inode 8595221283 claims used block 537201683
correcting nblocks for inode 8595221283, was 1 - counted 0
data fork in regular inode 8595221284 claims used block 537201684
        - agno =3D 33
correcting nblocks for inode 8595221284, was 5 - counted 0
data fork in regular inode 8595221285 claims used block 537201689
correcting nblocks for inode 8595221285, was 1 - counted 0
data fork in regular inode 8595221286 claims used block 537201690
correcting nblocks for inode 8595221286, was 6 - counted 0
data fork in regular inode 8326763299 claims used block 537270223
correcting nblocks for inode 8326763299, was 1 - counted 0
data fork in regular inode 8326763300 claims used block 537271439
correcting nblocks for inode 8326763300, was 1 - counted 0
data fork in regular inode 8595221287 claims used block 537201696
correcting nblocks for inode 8595221287, was 1 - counted 0
data fork in regular inode 8595221288 claims used block 537201699
attr fork in regular inode 8595221288 claims used block 537201698
xfs_repair: dinode.c:2241: process_inode_attr_fork: Zusicherung =BBerr =3D=
=3D=20
0=AB nicht erf=FCllt.
data fork in regular inode 8058708772 claims used block 537258543
correcting nblocks for inode 8058708772, was 1 - counted 0
data fork in regular inode 8058708773 claims used block 537260719
correcting nblocks for inode 8058708773, was 1 - counted 0
Abgebrochen

So again patch dinode.c:2241 ASSERT away:
# xfs_repair xfs.img
(about 550KB output, see http://zmi.at/xfs_repair.txt )
corrupt dinode 8326467385, extent total =3D 1, nblocks =3D 0.  This is a=20
bug.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.
cache_node_purge: refcount was 1, not zero (node=3D0x7f90c4de34e0)

fatal error -- couldn't map inode 8326467385, err =3D 117

Now, should I PANIC? Doesn't all seem to be nice...
I mounted this image, made "rm -r *" so all files/dirs which were good=20
were deleted. There are still a lot in there which can't be deleted. Can=20
someone help me fix it please?
I made another metadump image, it's on=20
http://zmi.at/xfs.metadump-brokenonly2.bz2

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4



--nextPart1438306.76unczFdfp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkqbcGgACgkQzhSR9xwSCbSvfgCfQDTYdZ3gBY37DvJnAamskbyZ
yaoAnigViCS8UAeC5lpg1KsNfPpAkWpV
=OBHu
-----END PGP SIGNATURE-----

--nextPart1438306.76unczFdfp--


--===============4035637018113347879==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4035637018113347879==--
