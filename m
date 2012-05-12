Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4CCoAhM179235 for <xfs@oss.sgi.com>; Sat, 12 May 2012 07:50:10 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id VprbZOk1KYB4aEZB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 May 2012 05:50:05 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106014.dyn.cm.kabsi.at [81.217.106.14])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id F11A4182242E
	for <xfs@oss.sgi.com>; Sat, 12 May 2012 14:50:02 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	by mailsrv.i.zmi.at (Postfix) with ESMTP id D94BCCD7C8C
	for <xfs@oss.sgi.com>; Sat, 12 May 2012 14:50:25 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: badly destroyed XFS (on LVM) - how to repair?
Date: Sat, 12 May 2012 14:49:56 +0200
Message-ID: <1763478.Vy9F5bcWiZ@saturn>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8848226917830900338=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============8848226917830900338==
Content-Type: multipart/signed; boundary="nextPart2208163.aUDL4mXbIg"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart2208163.aUDL4mXbIg
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

(This might be an LVM problem, but who knows?)

I have here an XFS that was on a server running within a XenServer=20
machine. In the end it existed of 4x 2TB disks:
# pvscan=20
  PV /dev/xvdg   VG sharestore   lvm2 [1.95 TiB / 0    free]
  PV /dev/xvdf   VG sharestore   lvm2 [1.95 TiB / 0    free]
  PV /dev/xvdc   VG sharestore   lvm2 [1.95 TiB / 0    free]
  PV /dev/xvde   VG sharestore   lvm2 [1.95 TiB / 0    free]
  Total: 4 [7.81 TiB] / in use: 4 [7.81 TiB] / in no VG: 0 [0   ]

Then by accident the admin made "fdisk /dev/xvdg", created a partition
like this:
Platte /dev/xvdg: 1073 MByte, 1073741824 Byte
139 K=C3=B6pfe, 8 Sektoren/Spuren, 1885 Zylinder
Einheiten =3D Zylinder von 1112 =C3=97 512 =3D 569344 Bytes
Disk identifier: 0xb30cf4db

    Ger=C3=A4t  boot.     Anfang        Ende     Bl=C3=B6cke   Id  Syst=
em
/dev/xvdg1               1        1886     1048448   82  Linux Swap

(partittion starting sector 63), and did "mkswap /dev/xvdg1". After a=20=

reboot, LVM did not recognize the full disk anymore.

# pvscan=20
  Couldn't find device with uuid 396XfX-EbMZ-0J6q-C3bj-3n6d-vruJ-6Oiy7w=
.
  PV unknown device   VG sharestore   lvm2 [1.95 TiB / 0    free]
  PV /dev/xvdf        VG sharestore   lvm2 [1.95 TiB / 0    free]
  PV /dev/xvdc        VG sharestore   lvm2 [1.95 TiB / 0    free]
  PV /dev/xvde        VG sharestore   lvm2 [1.95 TiB / 0    free]
  Total: 4 [7.81 TiB] / in use: 4 [7.81 TiB] / in no VG: 0 [0=20

This is where I jumped in. I must say that in the meantime the source V=
M=20
got deleted, and that I only got access to the data disks. I believe=20=

/dev/xvdg was the very first of those LVM disks before, but I'm not=20
sure.

I tried "pvcreate --uuid 396XfX-EbMZ-0J6q-C3bj-3n6d-vruJ-6Oiy7w --
norestorefile /dev/xvdg", which did not succeed.
Then I made a backup of the first sectors of /dev/xvdg, and did
"dd if=3D/dev/xvdf of=3D/dev/xvdg bs=3D512 count=3D63", and tried again=
 with
"pvcreate --uuid 396XfX-EbMZ-0J6q-C3bj-3n6d-vruJ-6Oiy7w --norestorefile=
=20
/dev/xvdg" - this time it worked. Strange thing: /dev/sharestore/public=
=20
is not created, it's only accessible via /dev/dm-0, but=20
I can mount the XFS but it's destroyed, "ls" shows:
ls: cannot access /1/hope: Invalid argument
ls: cannot access /1/jog: Invalid argument
ls: cannot access /1/maza: Invalid argument
ls: cannot access /1/public: Invalid argument
ls: cannot access /1/upload: Invalid argument
ls: cannot access /1/du.old: Invalid argument
ls: cannot access /1/.fsr: Invalid argument
total 45
drwxrwx---  17 root       1000 4096 May  1 00:00 ./
drwxr-xr-x  25 root    root     632 May 12 12:42 ../
???????????  ? ?       ?          ?            ? .fsr
drwx------   7    1007 nogroup 4096 Oct 19  2010 anse/
-rw-r--r--   1 root    root     951 Jan  1 00:10 du.20120101
-rw-r--r--   1 root    root     456 Feb  1 00:10 du.20120201
-rw-r--r--   1 root    root     455 Mar  1 00:11 du.20120301
-rw-r--r--   1 root    root     464 Apr  1 00:06 du.20120401
-rw-r--r--   1 root    root     464 May  1 00:00 du.20120501
???????????  ? ?       ?          ?            ? du.old
-rwx------   1 root    root     253 Nov  7  2010 find-inode.sh*
???????????  ? ?       ?          ?            ? hope
drwxrwxr-x+  4    1007 nogroup   49 Nov 29  2009 itm/
???????????  ? ?       ?          ?            ? jog
drwx------   6 makedns nogroup 4096 Aug 24  2010 lama/
???????????  ? ?       ?          ?            ? maza
drwx------   2    1008 nogroup   68 Jan 12  2010 paan/
???????????  ? ?       ?          ?            ? public
drwxrwxr-t   5 root    www     4096 Mar 17 11:33 tmp/
drwxr-xr-x   2 nobody  root     144 Mar 17 11:41 torrent/
???????????  ? ?       ?          ?            ? upload
drwx------   2    1003 nogroup   88 Nov 23  2009 vop/

Then I made a xfs_metadump, and xfs_repair, both with version 3.0.1,=20=

which seems to not work. xfs_repair said this:

# xfs_repair -n /dev/dm-0 2>&1|tee xfs.log
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
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
        - agno =3D 6
        - agno =3D 7
        - agno =3D 8
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 2
        - agno =3D 1
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 8
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

So it found no error. I then installed xfsprogs 3.1.8, and tried the=20=

repair on the metadump:

# xfs_repair xfs.metadump
Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!

attempting to find secondary superblock...
.......................................................................=
.......................................................................=
.......................................................................=
.......................................................................=
.......................................................................=
.......................................................................=
.......................................................................=
.......................................................................=
.......................................................................=
.................................................found=20
candidate secondary superblock...
superblock read failed, offset 1073976639488, size 131072, ag 1, rval 0=


fatal error -- No such file or directory

I tried the xfs_repair with v3.1.8 on the volume - again without any=20=

inconsistencies? I guess I still have a problem with the underlying LVM=
,=20
or it's an error which is currently not checked for in xfs_repair.

Could someone help me?
1) Maybe I need to do more on the /dev/xvdg volume in order to fix that=
?
2) I can give access to that machine for a developer if that helps.
3) I put the metadump on http://sonbae.zmi.at/xfs.metadump.bz2

Here are some LVM stats if that helps:

# pvdisplay=20
  --- Physical volume ---
  PV Name               /dev/xvdg
  VG Name               sharestore
  PV Size               1.95 TiB / not usable 64.00 MiB
  Allocatable           yes (but full)
  PE Size               64.00 MiB
  Total PE              32007
  Free PE               0
  Allocated PE          32007
  PV UUID               396XfX-EbMZ-0J6q-C3bj-3n6d-vruJ-6Oiy7w
  =20
  --- Physical volume ---
  PV Name               /dev/xvdf
  VG Name               sharestore
  PV Size               1.95 TiB / not usable 64.00 MiB
  Allocatable           yes (but full)
  PE Size               64.00 MiB
  Total PE              32007
  Free PE               0
  Allocated PE          32007
  PV UUID               fEDk3P-JLRj-cKVj-3AsG-hcbP-LQbi-QcdTl5
  =20
  --- Physical volume ---
  PV Name               /dev/xvdc
  VG Name               sharestore
  PV Size               1.95 TiB / not usable 64.00 MiB
  Allocatable           yes (but full)
  PE Size               64.00 MiB
  Total PE              32007
  Free PE               0
  Allocated PE          32007
  PV UUID               yQ2GQ4-EX38-Dlb4-RPOB-58Nn-0mg4-CN4w9a
  =20
  --- Physical volume ---
  PV Name               /dev/xvde
  VG Name               sharestore
  PV Size               1.95 TiB / not usable 64.00 MiB
  Allocatable           yes (but full)
  PE Size               64.00 MiB
  Total PE              32007
  Free PE               0
  Allocated PE          32007
  PV UUID               7exsxJ-F4Cm-eEiv-I1sS-qmIY-7Oxj-caAss5
  =20
# vgdisplay=20
  --- Volume group ---
  VG Name               sharestore
  System ID            =20
  Format                lvm2
  Metadata Areas        4
  Metadata Sequence No  10
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                4
  Act PV                4
  VG Size               7.81 TiB
  PE Size               64.00 MiB
  Total PE              128028
  Alloc PE / Size       128028 / 7.81 TiB
  Free  PE / Size       0 / 0  =20
  VG UUID               Ieov6b-2qof-KjzF-ypN1-QwZK-YE3C-DcVPeP
  =20
# lvdisplay=20
  /dev/mapper/sharestore-public: open failed: No such file or directory=

  --- Logical volume ---
  LV Name                /dev/sharestore/public
  VG Name                sharestore
  LV UUID                VsZljE-lUU2-oqvm-u4y6-xYz7-cpNA-8zBsRH
  LV Write Access        read/write
  LV Status              NOT available
  LV Size                7.81 TiB
  Current LE             128028
  Segments               4
  Allocation             inherit
  Read ahead sectors     1536

The volume is accessible only via /dev/dm-0, it seems this might be my=20=

problem?

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart2208163.aUDL4mXbIg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk+uXHkACgkQzhSR9xwSCbSW3ACeMPtQJTFlrIAOn53u8AVtm7AI
qoYAoOpS1rbWxvXT7eOuSaN8+39mCBIw
=Avmb
-----END PGP SIGNATURE-----

--nextPart2208163.aUDL4mXbIg--


--===============8848226917830900338==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8848226917830900338==--
