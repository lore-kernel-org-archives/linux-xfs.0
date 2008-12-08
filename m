Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB8Lht5t000327 for <xfs@oss.sgi.com>; Mon, 8 Dec 2008 15:43:55 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E71A35E5
	for <xfs@oss.sgi.com>; Mon,  8 Dec 2008 13:43:52 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id EoBZ14DhxEHAK0HS for
	<xfs@oss.sgi.com>; Mon, 08 Dec 2008 13:43:52 -0800 (PST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: benchmark: write barrier/write cache on XFS
Date: Mon, 8 Dec 2008 22:43:14 +0100
References: <200812082139.58328.Martin@Lichtvoll.de>
	(sfid-20081208_214015_115571_1580D367)
In-Reply-To: <200812082139.58328.Martin@Lichtvoll.de>
MIME-Version: 1.0
Message-Id: <200812082243.19525.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0302394339905605746=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

--===============0302394339905605746==
Content-Type: multipart/signed;
  boundary="nextPart8041931.ao1rTqzOyJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart8041931.ao1rTqzOyJ
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag 08 Dezember 2008 schrieb Martin Steigerwald:
> Hi!
>
> I got curious about the recent discussions about the write barrier
> feature[1][2].
>
> Thus I did my own benchmark this evening. Since I use XFS and tested
> with XFS for now only. Write barrier + write cache, no barrier + write
> cache, no write barrier + no write cache. I just did tar -xf
> linux-2.6.27.tar.bz2 and rm -rf linux-2.6.27.

I disabled write cache and barriers for my XFS filesystems on my TP 42=20
shambhala. During that I did further tests. This time I also include IO=20
scheduler settings. They are default and have been the same during my=20
previous tests.

Write cache has about 13 seconds benefit on the barrier enabled XFS for=20
the tar -xf linux-2.6.27.tar.bz2 workload but no benefit at all for the=20
rm -rf linux-2.6.27 workload!

And again nobarrier and no cache wins.


On a heavily used /home-XFS - I know it should have more free space:

martin@shambhala:~ -> LANG=3DC df -hT /home/
Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/sda5      xfs    112G  107G  5.1G  96% /home



It has been grown two times - since 6 AGs instead of the default of 4:

shambhala:~> xfs_info /home
meta-data=3D/dev/sda5              isize=3D256    agcount=3D6, agsize=3D488=
3256=20
blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D29299536, imaxpc=
t=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096
log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0



IO scheduler settings:

martin@shambhala:~> cat /sys/block/sda/queue/scheduler
noop anticipatory deadline [cfq]
martin@shambhala:~> grep "" /sys/block/sda/queue/iosched/*
/sys/block/sda/queue/iosched/back_seek_max:16384
/sys/block/sda/queue/iosched/back_seek_penalty:2
/sys/block/sda/queue/iosched/fifo_expire_async:250
/sys/block/sda/queue/iosched/fifo_expire_sync:123
/sys/block/sda/queue/iosched/quantum:4
/sys/block/sda/queue/iosched/slice_async:40
/sys/block/sda/queue/iosched/slice_async_rq:2
/sys/block/sda/queue/iosched/slice_idle:6
/sys/block/sda/queue/iosched/slice_sync:100



Write barriers and no write cache:

shambhala:~> hdparm -W /dev/sda

/dev/sda:
 write-caching =3D  0 (off)

shambhala:> cat /proc/mounts | egrep "(/ |home)"
rootfs / rootfs rw 0 0
/dev/disk/by-uuid/7fcd9766-bf1a-426a-8a07-2c3e0c510898 / xfs=20
rw,relatime,attr2,noquota 0 0
/dev/sda5 /home xfs rw,relatime,attr2,logbufs=3D8,logbsize=3D256k,noquota 0=
 0
martin@shambhala:~/Zeit> sync; time tar -xf=20
~/Linux/Kernel/Mainline/linux-2.6.27.tar.bz2 ; time sync
tar -xf ~/Linux/Kernel/Mainline/linux-2.6.27.tar.bz2  36,71s user 4,22s=20
system 36% cpu 1:51,58 total
sync  0,00s user 0,05s system 0% cpu 12,689 total
martin@shambhala:~/Zeit> sync; time rm -rf linux-2.6.27 ; time sync
rm -rf linux-2.6.27  0,06s user 3,90s system 17% cpu 22,906 total
sync  0,00s user 0,01s system 6% cpu 0,103 total



Write barriers and write cache:

shambhala:~> hdparm -W1 /dev/sda

/dev/sda:
 setting drive write-caching to 1 (on)
 write-caching =3D  1 (on)

martin@shambhala:~/Zeit> sync; time tar -xf=20
~/Linux/Kernel/Mainline/linux-2.6.27.tar.bz2 ; time sync
tar -xf ~/Linux/Kernel/Mainline/linux-2.6.27.tar.bz2  34,38s user 3,91s=20
system 38% cpu 1:38,84 total
sync  0,00s user 0,04s system 0% cpu 10,493 total
martin@shambhala:~/Zeit> sync; time rm -rf linux-2.6.27 ; time sync
rm -rf linux-2.6.27  0,07s user 3,98s system 17% cpu 23,511 total
sync  0,00s user 0,01s system 5% cpu 0,126 total



No write barriers and no write cache:

shambhala:> vim fstab
shambhala:> mount -o remount /
shambhala:> mount -o remount /home
shambhala:> cat /proc/mounts | egrep "(/ |home)"
rootfs / rootfs rw 0 0
/dev/disk/by-uuid/7fcd9766-bf1a-426a-8a07-2c3e0c510898 / xfs=20
rw,relatime,attr2,nobarrier,noquota 0 0
/dev/sda5 /home xfs=20
rw,relatime,attr2,nobarrier,logbufs=3D8,logbsize=3D256k,noquota 0 0

martin@shambhala:~/Zeit> sync; time tar -xf=20
~/Linux/Kernel/Mainline/linux-2.6.27.tar.bz2 ; time sync
tar -xf ~/Linux/Kernel/Mainline/linux-2.6.27.tar.bz2  30,36s user 3,31s=20
system 48% cpu 1:08,94 total
sync  0,00s user 0,08s system 0% cpu 17,462 total
martin@shambhala:~/Zeit> sync; time rm -rf linux-2.6.27 ; time sync
rm -rf linux-2.6.27  0,07s user 3,87s system 20% cpu 19,172 total
sync  0,00s user 0,01s system 4% cpu 0,142 total



martin@shambhala:~> date
Mo 8. Dez 22:38:06 CET 2008

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart8041931.ao1rTqzOyJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk9lPMACgkQmRvqrKWZhMdGpACdG0Sbfn1QSynsFIjNlHXGC1EM
oXAAoLF2KDf9MK5+jpQHGrUVGOLXW9iN
=Vk//
-----END PGP SIGNATURE-----

--nextPart8041931.ao1rTqzOyJ--


--===============0302394339905605746==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0302394339905605746==--
