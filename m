Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6GEEWTn005931 for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 09:14:33 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98562451EE4
	for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 07:17:27 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id dmr3n9ZHmJAmZyEe for
	<xfs@oss.sgi.com>; Fri, 16 Jul 2010 07:17:27 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: rsync and corrupt inodes (was xfs_dump problem)
Date: Fri, 16 Jul 2010 16:17:21 +0200
References: <201007152258.15631@zmi.at> <20100715225713.GK30737@dastard>
In-Reply-To: <20100715225713.GK30737@dastard>
MIME-Version: 1.0
Message-Id: <201007161617.25548@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2579069972304118997=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2579069972304118997==
Content-Type: multipart/signed;
  boundary="nextPart5887918.RSDVjVT6SN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart5887918.RSDVjVT6SN
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 16. Juli 2010 Dave Chinner wrote:
> > Maybe I did something wrong? I configured xfsprogs 3.1.2 with
> > CFLAGS=3D-march=3Dathlon64-sse3 ./configure --prefix=3D/usr
> > and then
> > make;make install
>=20
> Drop the CFLAGS and see what happens when you just use a generic
> arch target.

OK, I'll retry this.
=20
> Regardless, can you run xfs_repair -P and see if that prevents the
>  assert failure?

I did this 10 times manually. It started good, but after a while repeats=20
itself again:

# xfs_repair -P saturn_bigdata.only_broken                =20
Phase 1 - find and verify superblock...                               =20
Phase 2 - using internal log                                          =20
        - zero log...                                                 =20
        - scan filesystem freespace and inode maps...                 =20
        - found root inode chunk                                      =20
Phase 3 - for each AG...                                              =20
        - scan and clear agi unlinked lists...                        =20
        - process known inodes and perform inode discovery...         =20
        - agno =3D 0
corrected attribute entry count in inode 649642, was 40, now 0
problem with attribute contents in inode 649642
local inode 649790 attr too small (size =3D 1, min size =3D 4)
bad attribute fork in inode 649790, clearing attr fork
clearing inode 649790 attributes
cleared inode 649790
        - agno =3D 1
local inode 2195133988 attr too small (size =3D 3, min size =3D 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
data fork in inode 649642 claims metadata block 537266460
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err =3D=3D 0=
'=20
failed.
Aborted

=2D--------------------------------------------------
# xfs_repair -P saturn_bigdata.only_broken 2>&1|tee broken.log         =20
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
corrected attribute entry count in inode 649642, was 40, now 0
problem with attribute contents in inode 649642
local inode 649790 attr too small (size =3D 1, min size =3D 4)
bad attribute fork in inode 649790, clearing attr fork
clearing inode 649790 attributes
cleared inode 649790
        - agno =3D 1
local inode 2195133988 attr too small (size =3D 3, min size =3D 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 1
data fork in inode 2195133988 claims metadata block 537122652
        - agno =3D 2
        - agno =3D 3
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err =3D=3D 0=
'=20
failed.

=2D------------------------------------------------
# xfs_repair -P saturn_bigdata.only_broken 2>&1|tee broken2.log        =20
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
corrected attribute entry count in inode 649642, was 40, now 0             =
        =20
problem with attribute contents in inode 649642                            =
        =20
local inode 649790 attr too small (size =3D 1, min size =3D 4)
bad attribute fork in inode 649790, clearing attr fork
clearing inode 649790 attributes
cleared inode 649790
        - agno =3D 1
local inode 2195133988 attr too small (size =3D 3, min size =3D 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 2
data fork in inode 649642 claims metadata block 537266460
        - agno =3D 3
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err =3D=3D 0=
'=20
failed.
        - agno =3D 4
        - agno =3D 5

=2D------------------------------------------------
# xfs_repair -P saturn_bigdata.only_broken 2>&1|tee broken3.log       =20
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
corrected attribute entry count in inode 649642, was 40, now 0             =
       =20
problem with attribute contents in inode 649642                            =
       =20
local inode 649790 attr too small (size =3D 1, min size =3D 4)             =
           =20
bad attribute fork in inode 649790, clearing attr fork                     =
       =20
clearing inode 649790 attributes                                           =
       =20
cleared inode 649790                                                       =
       =20
        - agno =3D 1
local inode 2195133988 attr too small (size =3D 3, min size =3D 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 2
        - agno =3D 1
data fork in inode 2195133988 claims metadata block 537122652
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
data fork in inode 649642 claims metadata block 537266460
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err =3D=3D 0=
'=20
failed.
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err =3D=3D 0=
'=20
failed.

=2D------------------------------------------------
# xfs_repair -P saturn_bigdata.only_broken 2>&1|tee broken4.log      =20
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
corrected attribute entry count in inode 649642, was 40, now 0             =
      =20
problem with attribute contents in inode 649642                            =
      =20
local inode 649790 attr too small (size =3D 1, min size =3D 4)             =
          =20
bad attribute fork in inode 649790, clearing attr fork                     =
      =20
clearing inode 649790 attributes                                           =
      =20
cleared inode 649790
        - agno =3D 1
local inode 2195133988 attr too small (size =3D 3, min size =3D 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 1
data fork in inode 2195133988 claims metadata block 537122652
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err =3D=3D 0=
'=20
failed.

=2D------------------------------------------------
# xfs_repair -P saturn_bigdata.only_broken 2>&1|tee broken5.log     =20
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
corrected attribute entry count in inode 649642, was 40, now 0             =
     =20
problem with attribute contents in inode 649642                            =
     =20
local inode 649790 attr too small (size =3D 1, min size =3D 4)             =
         =20
bad attribute fork in inode 649790, clearing attr fork                     =
     =20
clearing inode 649790 attributes                                           =
     =20
cleared inode 649790
        - agno =3D 1
local inode 2195133988 attr too small (size =3D 3, min size =3D 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 1
        - agno =3D 0
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
data fork in inode 649642 claims metadata block 537266460
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err =3D=3D 0=
'=20
failed.

=2D------------------------------------------------
# xfs_repair -P saturn_bigdata.only_broken 2>&1|tee broken6.log    =20
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
corrected attribute entry count in inode 649642, was 40, now 0             =
    =20
problem with attribute contents in inode 649642                            =
    =20
local inode 649790 attr too small (size =3D 1, min size =3D 4)             =
        =20
bad attribute fork in inode 649790, clearing attr fork                     =
    =20
clearing inode 649790 attributes                                           =
    =20
cleared inode 649790
        - agno =3D 1
local inode 2195133988 attr too small (size =3D 3, min size =3D 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 2
        - agno =3D 1
data fork in inode 2195133988 claims metadata block 537122652
        - agno =3D 0
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err =3D=3D 0=
'=20
failed.
=2D------------------------------------------------
The next run gave the same output, only the order of AG's was different:
# diff broken6.log broken7.log=20
34,39c34                                  =20
<         - agno =3D 3                      =20
<         - agno =3D 4                      =20
<         - agno =3D 5                      =20
<         - agno =3D 6                      =20
<         - agno =3D 7                      =20
<         - agno =3D 2                      =20
=2D--                                       =20
>         - agno =3D 0                      =20
42d36                                     =20
<         - agno =3D 0                      =20

=2D------------------------------------------------
# xfs_repair -P saturn_bigdata.only_broken 2>&1|tee broken8.log
Phase 1 - find and verify superblock...                                   =
=20
Phase 2 - using internal log                                              =
=20
        - zero log...                                                     =
=20
        - scan filesystem freespace and inode maps...                     =
=20
        - found root inode chunk                                          =
=20
Phase 3 - for each AG...                                                  =
=20
        - scan and clear agi unlinked lists...                            =
=20
        - process known inodes and perform inode discovery...             =
=20
        - agno =3D 0                                                       =
 =20
corrected attribute entry count in inode 649642, was 40, now 0            =
=20
problem with attribute contents in inode 649642                           =
=20
local inode 649790 attr too small (size =3D 1, min size =3D 4)             =
   =20
bad attribute fork in inode 649790, clearing attr fork                    =
=20
clearing inode 649790 attributes                                          =
=20
cleared inode 649790
        - agno =3D 1
local inode 2195133988 attr too small (size =3D 3, min size =3D 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 1
data fork in inode 2195133988 claims metadata block 537122652
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err =3D=3D 0=
'=20
failed.
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7

=2D------------------------------------------------
The next run gave the same output as "broken5.log", only the order of=20
AG's was different:
# diff broken9.log broken5.log
34d33
<         - agno =3D 0
35a35,41
>         - agno =3D 0
>         - agno =3D 2
>         - agno =3D 3
>         - agno =3D 4
>         - agno =3D 5
>         - agno =3D 6
>         - agno =3D 7


I made another 20 runs, all the same.

And I retried with the "CFLAGS":
CFLAGS=3D"-march=3Dathlon64-sse3 -g -Os" ./configure --prefix=3D/usr

No matter what I use for CFLAGS, the resulting binary repair/xfs_repair=20
is always the same. So it seems to be ignored during compile anyway.=20
Smells like a bug? Because config.status gets the CFLAGS set, it's just=20
not used during compile. Comparing a "config.status" with CFLAGS set and=20
without:

# diff config.status config.status.default
360c360                                                                =20
<   with options \"'--prefix=3D/usr' 'CFLAGS=3D-march=3Dathlon64-sse3 -g -
Os'\"
=2D--
>   with options \"\"
439c439
<   set X '/bin/sh' './configure'  '--prefix=3D/usr' 'CFLAGS=3D-
march=3Dathlon64-sse3 -g -Os' $ac_configure_extra_args --no-create --no-
recursion
=2D--
>   set X '/bin/sh' './configure'  $ac_configure_extra_args --no-create=20
=2D-no-recursion
488c488
< max_cmd_len=3D'1572864'
=2D--
> max_cmd_len=3D'3458764513820540925'
507c507
< CFLAGS=3D'-march=3Dathlon64-sse3 -g -Os'
=2D--
> CFLAGS=3D'-g -O2'
591c591
< LTCFLAGS=3D'-march=3Dathlon64-sse3 -g -Os'
=2D--
> LTCFLAGS=3D'-g -O2'
717c717
< S["have_zipped_manpages"]=3D"true"
=2D--
> S["have_zipped_manpages"]=3D"false"
835c835
< S["CFLAGS"]=3D"-march=3Dathlon64-sse3 -g -Os"
=2D--
> S["CFLAGS"]=3D"-g -O2"

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart5887918.RSDVjVT6SN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxAafUACgkQzhSR9xwSCbSVLgCgjUkVACaRf804QvHfssFONxc4
CXIAoNiyBpXdQGVCLL5qN43fhP5xhhEP
=S1Xc
-----END PGP SIGNATURE-----

--nextPart5887918.RSDVjVT6SN--


--===============2579069972304118997==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2579069972304118997==--
