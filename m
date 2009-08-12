Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7CI9Vww215938 for <xfs@oss.sgi.com>; Wed, 12 Aug 2009 13:09:42 -0500
Received: from ngcobalt07.manitu.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A32C1D576C3
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2009 11:09:48 -0700 (PDT)
Received: from ngcobalt07.manitu.net (ngcobalt07.manitu.net [217.11.48.107])
	by cuda.sgi.com with ESMTP id 9FFbFPTxG6wDYBVM for
	<xfs@oss.sgi.com>; Wed, 12 Aug 2009 11:09:48 -0700 (PDT)
From: Roland Eggner <edvx1@systemanalysen.net>
Subject: free space of root partition decreases unaccountably by some 1024
	blocks on every umount+linux shutdown
Date: Wed, 12 Aug 2009 19:54:14 +0200
MIME-Version: 1.0
Message-Id: <200908121955.07682.edvx1@systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7001813575377165987=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: SGI Project XFS mailing list <xfs@oss.sgi.com>

--===============7001813575377165987==
Content-Type: multipart/signed;
  boundary="nextPart2002440.2gsuD8tyeh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2002440.2gsuD8tyeh
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

History which lead to actual problem
=2D-----------------------------------
On July 4th I switched from kernel 2.6.29.5 to 2.6.29.6.

On July 18th I noticed the first time this unaccountable decrease of free s=
pace of my root partition /dev/hda7:
=46or at least several boot-shutdown-cycles it has decreased on every cycle=
 by some 1020 =E2=80=A6 1030 blocks from originally above 100 MB to 96 MB.
Expected change at most =C2=B11 block.  Neither xfs_check nor xfs_repair -d=
n could detect any flaws.
I booted a sidux image with kernel 2.6.27, mounted /dev/hda7 readonly (actu=
ally sidux flavour =E2=80=9C/dev/sda7=E2=80=9D), and compared reported free=
 space =E2=9E=9C decrease seems to occur on umount + system shutdown.  Neit=
her xfs_check nor =E2=80=9Cxfs_repair -dn=E2=80=9D running under sidux kern=
el 2.6.27 could detect any flaws.
Only one other flaw is noteworthy (seperate bugreport scheduled):
Since one of the 2.6.28.? kernels mount procedures require a time randomly =
dithering between less than 1 second and more than 30 seconds with almost n=
o harddisk i/o activity, with
NO difference between =E2=80=9Cmount -a=E2=80=9D during boot and manual mou=
nts,
NO difference between mounts of plain and loop-aes-encrypted partitions,
NO difference between kernels 2.6.29.[1-6] and 2.6.30.4.
Only loop mounts of vfat images happen without remarkable delay.
Just after xfs_check and =E2=80=9Cxfs_repair -dn=E2=80=9D have verified a p=
articular loop-aes-encrypted filesystem errorfree, kernel complains every t=
ime =E2=80=9Csuperblock invalid=E2=80=9D and mounts it successfully.  Kerne=
l 2.6.30.4 shows the same crazy behavior on mounting of the same and additi=
onally another particular loop-aes-encrypted filesystem.  Cannot say, if th=
is extreme slow mounts are XFS specific, because I do not use any other fil=
esystem on this linux system.

On August 10th =E2=80=94 after reading =E2=80=9Ckernel.org/ChangeLog-2.6.30=
=2Ebz2:  xfs: fix bad_features2 fixups for the root filesystem =E2=80=A6=E2=
=80=9D =E2=80=94 I switched to kernel 2.6.30.4, which left the problem UNMO=
DIFIED.

On August 12th free space has decreased to 48 MB, so I am forced to take ac=
tions.


System details
=2D-------------
System based on Debian testing.
Kernel:  from kernel.org tainted by NVIDIA video driver.
Applied patches:  one from loop-aes-source and another one to fs/namespace.=
c setting MNT_STRICTATIME as default mount option.
smartmontools short selftest reports are errorfree.
=E2=80=9Chdparm -W0 /dev/hda=E2=80=9D performed by a bootscript and externa=
l encrypted logdevices are precautions to ensure consistent loop-aes-encryp=
ted xfs filesystems =E2=80=94 during 1 year of usage I encountered a few po=
wer failures, which caused =E2=80=9Cdirty=E2=80=9D shutdowns of my notebook=
 but never any filesystem related problems :)


#  /usr/sbin/xfs_info /
meta-data=3D/dev/root              isize=3D256    agcount=3D4, agsize=3D748=
776 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D1024   blocks=3D2995102, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D1024   ascii-ci=3D0
log      =3Dinternal               bsize=3D1024   blocks=3D10240, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0


$  grep /dev/root /proc/mounts
/dev/root / xfs rw,strictatime,attr2,nobarrier,noquota 0 0


At /var /tmp /home are other partitions mounted, therefore the only known w=
rite activities on root partition apart from atime updates and temporary lo=
ckfiles are concerning at most 6 blocks:
#  ( export LANGUAGE=3Den_GB ; find / -ctime -1 -not -type d -print0 | xarg=
s -0 -- du -bc )
16      /etc/network/run/ifstate
44      /etc/adjtime~
44      /etc/adjtime
23      /etc/resolv.conf
1970    /etc/mtab
2097    total
No known write activities on system startup prior to mount or on shutdown a=
fter umount in directories on root partition, which are hidden by mounts wh=
en system is running.


xfs_metadump output from 2 consecutive linux sessions, lzma compressed, pro=
vided via http-server on request from known XFS developers (preferable gpg =
signed).
Should I perform a xfsdump|mkfs.xfs|xfsrestore-cycle?
Thanks!

=2D-=20
Roland Eggner

--nextPart2002440.2gsuD8tyeh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqDAccACgkQdN/hKfT7G/J9HgCfVNWwvDcM5aQaynFvV7HgjPBw
qaoAniqNAYx2khcOib9VQo7AFq1nWOuE
=lytW
-----END PGP SIGNATURE-----

--nextPart2002440.2gsuD8tyeh--


--===============7001813575377165987==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7001813575377165987==--
