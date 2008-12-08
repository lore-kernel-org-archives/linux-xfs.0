Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB8Ke7WX029639 for <xfs@oss.sgi.com>; Mon, 8 Dec 2008 14:40:07 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEB2516ED93C
	for <xfs@oss.sgi.com>; Mon,  8 Dec 2008 12:40:02 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id aEIWmGlcPwEnyFuG for
	<xfs@oss.sgi.com>; Mon, 08 Dec 2008 12:40:02 -0800 (PST)
From: Martin Steigerwald <Martin@Lichtvoll.de>
Subject: benchmark: write barrier/write cache on XFS
Date: Mon, 8 Dec 2008 21:39:53 +0100
MIME-Version: 1.0
Message-Id: <200812082139.58328.Martin@Lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0906749143830831618=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

--===============0906749143830831618==
Content-Type: multipart/signed;
  boundary="nextPart8219326.HcRJf0m3BK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart8219326.HcRJf0m3BK
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Hi!

I got curious about the recent discussions about the write barrier=20
feature[1][2].

Thus I did my own benchmark this evening. Since I use XFS and tested with=
=20
XFS for now only. Write barrier + write cache, no barrier + write cache,=20
no write barrier + no write cache. I just did tar -xf=20
linux-2.6.27.tar.bz2 and rm -rf linux-2.6.27.

My conclusion is: At least for this metadata intensive workload enabling=20
write barries is complete nonsense for XFS filesystems, cause it runs way=
=20
faster without write cache and without barriers. I am completely puzzled=20
about this, cause I always thought that barriers where meant to provide a=
=20
performance improvement versus disabling write cache. I actually=20
advertised them as such in my Linux magazine article, should have benched=
=20
them before it seems. Write barrier seem to be a slow down feature for=20
XFS.

See for yourself. I am interested in other benchmarks like this.=20
Automating this would be good and running it for different filesystems.=20
Maybe adding some different workloads as these are highly selective=20
tests, testing with RAID systems as Justin did and of course testing with=
=20
different filesystems.

I think I will disable write cache and disable barriers on that ThinkPad=20
T42 and I think also other machines.



IBM ThinkPad T42 with 160 GB IDE hitachi drive via libata:

shambhala:~> grep "model name" /proc/cpuinfo
model name      : Intel(R) Pentium(R) M processor 1.80GHz
shambhala:~> cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
ondemand
shambhala:~> cat /proc/version
Linux version 2.6.27.7-tp42-toi-3.0-2008-11-25 (martin@shambhala) (gcc=20
version 4.3.2 (Debian 4.3.2-1) ) #1 PREEMPT Sun Nov 30 10:29:09 CET 2008

shambhala:~> hdparm -I /dev/sda | egrep "(Model Num|device size|power=20
manage|acoustic manage|DMA:|120 ns)"
        Model Number:       Hitachi HTS541616J9AT00
        device size with M =3D 1024*1024:      152627 MBytes
        device size with M =3D 1000*1000:      160041 MBytes (160 GB)
        Advanced power management level: 254
        Recommended acoustic management value: 128, current value: 128
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5



The default - write barrier and write cache enabled:

shambhala:~> hdparm -W /dev/sda

/dev/sda:
 write-caching =3D  1 (on)
shambhala:~> hdparm -I /dev/sda | grep cache
           *    Write cache
shambhala:~> mkfs.xfs -f -L xfs -l lazy-count=3D1 /dev/sda6
meta-data=3D/dev/sda6              isize=3D256    agcount=3D4, agsize=3D134=
4188=20
blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D5376750, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096
log      =3Dinternal log           bsize=3D4096   blocks=3D2625, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
shambhala:~> mount /dev/sda6 /mnt/zeit
shambhala:~> grep zeit /proc/mounts
/dev/sda6 /mnt/zeit xfs rw,attr2,noquota 0 0
shambhala:~> cd /mnt/zeit
shambhala:/mnt/zeit> sync ; time=20
tar -xf /home/martin/Linux/Kernel/Mainline/linux-2.6.27.tar.bz2; time=20
sync
tar -xf /home/martin/Linux/Kernel/Mainline/linux-2.6.27.tar.bz2  46,01s=20
user 5,59s system 41% cpu 2:03,01 total
sync  0,00s user 0,18s system 3% cpu 5,303 total
shambhala:/mnt/zeit> sync ; time rm -rf linux-2.6.27 ; time sync
rm -rf linux-2.6.27  0,08s user 3,49s system 6% cpu 51,482 total
sync  0,00s user 0,15s system 45% cpu 0,320 total
shambhala:/mnt/zeit> cd
shambhala:~> umount /mnt/zeit



Write barriers disabled, write cache enabled:

shambhala:~> hdparm -W /dev/sda

/dev/sda:
 write-caching =3D  1 (on)
shambhala:~> hdparm -I /dev/sda | grep cache
           *    Write cache
shambhala:~> mkfs.xfs -f -L xfs -l lazy-count=3D1 /dev/sda6
meta-data=3D/dev/sda6              isize=3D256    agcount=3D4, agsize=3D134=
4188=20
blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D5376750, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096
log      =3Dinternal log           bsize=3D4096   blocks=3D2625, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
shambhala:~> mount -o nobarrier /dev/sda6 /mnt/zeit
shambhala:~> cd /mnt/zeit
shambhala:/mnt/zeit> sync ; time=20
tar -xf /home/martin/Linux/Kernel/Mainline/linux-2.6.27.tar.bz2; time=20
sync
tar -xf /home/martin/Linux/Kernel/Mainline/linux-2.6.27.tar.bz2  26,77s=20
user 3,20s system 67% cpu 44,236 total
sync  0,00s user 0,17s system 5% cpu 3,224 total
shambhala:/mnt/zeit> sync ; time rm -rf linux-2.6.27 ; time sync
rm -rf linux-2.6.27  0,05s user 3,20s system 43% cpu 7,442 total
sync  0,00s user 0,14s system 44% cpu 0,309 total
shambhala:/mnt/zeit> cd
shambhala:~> umount /mnt/zeit



Write barriers and write cache disabled:

shambhala:~> hdparm -W0 /dev/sda

/dev/sda:
 setting drive write-caching to 0 (off)
 write-caching =3D  0 (off)
shambhala:~> hdparm -I /dev/sda | grep cache
                Write cache
shambhala:~> mkfs.xfs -f -L xfs -l lazy-count=3D1 /dev/sda6
meta-data=3D/dev/sda6              isize=3D256    agcount=3D4, agsize=3D134=
4188=20
blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D5376750, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096
log      =3Dinternal log           bsize=3D4096   blocks=3D2625, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
shambhala:~> mount -o nobarrier /dev/sda6 /mnt/zeit
shambhala:~> cd /mnt/zeit
shambhala:/mnt/zeit> sync ; time=20
tar -xf /home/martin/Linux/Kernel/Mainline/linux-2.6.27.tar.bz2; time=20
sync
tar -xf /home/martin/Linux/Kernel/Mainline/linux-2.6.27.tar.bz2  35,22s=20
user 3,89s system 53% cpu 1:12,71 total
sync  0,00s user 0,17s system 7% cpu 2,355 total
shambhala:/mnt/zeit> sync ; time rm -rf linux-2.6.27 ; time sync
rm -rf linux-2.6.27  0,07s user 2,82s system 12% cpu 23,391 total
sync  0,00s user 0,14s system 44% cpu 0,329 total
shambhala:/mnt/zeit> cd
shambhala:~> umount /mnt/zeit


shambhala:~> date
Mo 8. Dez 21:24:42 CET 2008





[1] http://oss.sgi.com/archives/xfs/2008-12/msg00219.html
[2] http://oss.sgi.com/archives/xfs/2008-12/msg00161.html or=20=20
http://lkml.org/lkml/2008/12/4/169

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart8219326.HcRJf0m3BK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk9hhkACgkQmRvqrKWZhMdz5gCeMyJdo63zAhZuv1HQDAwV/ou1
6rcAn3m8x+orbxX0LDZEJLezUFszJRUT
=lzgX
-----END PGP SIGNATURE-----

--nextPart8219326.HcRJf0m3BK--


--===============0906749143830831618==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0906749143830831618==--
