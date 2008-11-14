Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAECFbFt019020 for <xfs@oss.sgi.com>; Fri, 14 Nov 2008 04:15:39 -0800
Received: from smtp-1.hut.fi (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CAE61570C6C
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2008 04:15:36 -0800 (PST)
Received: from smtp-1.hut.fi (smtp-1.hut.fi [130.233.228.91]) by cuda.sgi.com
	with ESMTP id HpEoHeQR8GjYxFnf for <xfs@oss.sgi.com>;
	Fri, 14 Nov 2008 04:15:36 -0800 (PST)
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-1.hut.fi (8.13.6/8.12.10) with ESMTP id mAEAfvbP031070
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2008 12:41:57 +0200
Received: from smtp-1.hut.fi ([130.233.228.91])
	by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new,
	port 10024) with LMTP id 18704-103 for <xfs@oss.sgi.com>;
	Fri, 14 Nov 2008 12:41:57 +0200 (EET)
Received: from going-postal.kurp.hut.fi (quadrant.hut.fi [130.233.157.233])
	by smtp-1.hut.fi (8.13.6/8.12.10) with ESMTP id mAEAfSHe030869
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2008 12:41:28 +0200
Received: from kurp.hut.fi (kurp.hut.fi [130.233.244.1])
	by going-postal.kurp.hut.fi (Postfix) with ESMTP id 54A053BA9F
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2008 12:41:28 +0200 (EET)
Received: from jwagner (helo=localhost)
	by kurp.hut.fi with local-esmtp (Exim 4.50) id 1L0w7E-00065k-8g
	for xfs@oss.sgi.com; Fri, 14 Nov 2008 12:41:28 +0200
Date: Fri, 14 Nov 2008 12:41:28 +0200 (EET)
From: Jan Wagner <jwagner@kurp.hut.fi>
Subject: mkfs.xfs with a 9TB realtime volume hangs
Message-ID: <alpine.DEB.2.00.0811141231390.23165@kurp.hut.fi>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I have a RAID0 with 11x750GB+1x1TB components in the following =

partitionable-md test setup

root@abidal:~# cat /proc/partitions | grep md
  254     0 9035047936 md_d0
  254     1     124983 md_d0p1
  254     2    1828125 md_d0p2
  254     3    1953125 md_d0p3
  254     4 9031141669 md_d0p4

Essentially, four partitions: 128MB, ~1.9GB, 2GB, 9TB. I'd like to use the =

1.9GB partition for xfs and put a realtime subvolume onto the same raid0 =

onto the 9TB partition. The partition tables are GDT instead of MBR to be =

able to have >=3D2TB partitions.

When I create xfs with realtime subvolume on the 2GB partition all is =

fine:

root@abidal:~# mkfs.xfs -f -d su=3D1024k,sw=3D12 -r rtdev=3D/dev/md_d0p3 /d=
ev/md_d0p2
log stripe unit (1048576 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
meta-data=3D/dev/md_d0p2           isize=3D256    agcount=3D4, agsize=3D114=
432 =

blks
          =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D457031, imaxpct=
=3D25
          =3D                       sunit=3D256    swidth=3D3072 blks
naming   =3Dversion 2              bsize=3D4096
log      =3Dinternal log           bsize=3D4096   blocks=3D2560, version=3D2
          =3D                       sectsz=3D512   sunit=3D8 blks, lazy-cou=
nt=3D0
realtime =3D/dev/md_d0p3           extsz=3D4096   blocks=3D488281, rtextent=
s=3D488281

When I try the same but place the realtime subvolume on the 9TB partition =

the mkfs.xfs hangs indefinitely with 100% CPU:

root@abidal:~# mkfs.xfs -f -d su=3D1024k,sw=3D12 -r rtdev=3D/dev/md_d0p4 /d=
ev/md_d0p2
log stripe unit (1048576 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
meta-data=3D/dev/md_d0p2           isize=3D256    agcount=3D4, agsize=3D114=
432 =

blks
          =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D457031, imaxpct=
=3D25
          =3D                       sunit=3D256    swidth=3D3072 blks
naming   =3Dversion 2              bsize=3D4096
log      =3Dinternal log           bsize=3D4096   blocks=3D2560, version=3D2
          =3D                       sectsz=3D512   sunit=3D8 blks, lazy-cou=
nt=3D0
realtime =3D/dev/md_d0p4           extsz=3D4096   blocks=3D2257785417, rtex=
tents=3D2257785417
(hangs...)

When I run strace on the first, it completes with
...
pwrite(4, "IABT\0\0\0\0\377\377\377\377\377\377\377\377\0\0\0\0\0"..., =

4096, 468725760) =3D 4096
pwrite(4, "XAGI\0\0\0\1\0\0\0\1\0\1\277\0\0\0\0\0\0\0\0\3\0\0\0\1"..., =

512, 468714496) =3D 512
pread(4, "XFSB\0\0\20\0\0\0\0\0\0\6\371G\0\0\0\0\0\7sY\0\0\0\0\0"..., 512, =

0) =3D 512
pwrite(4, "XFSB\0\0\20\0\0\0\0\0\0\6\371G\0\0\0\0\0\7sY\0\0\0\0\0"..., =

512, 0) =3D 512
fsync(5)                                =3D 0
ioctl(5, BLKFLSBUF, 0)                  =3D 0
close(5)                                =3D 0
fsync(4)                                =3D 0
ioctl(4, BLKFLSBUF, 0)                  =3D 0
close(4)                                =3D 0
exit_group(0)                           =3D ?

When I run strace on the latter mkfs.xfs it is reading for hours

pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., =

4096, 7802880) =3D 4096
brk(0x1667000)                          =3D 0x1667000
pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., =

4096, 7806976) =3D 4096
pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., =

4096, 7811072) =3D 4096
....

Any ideas?

  - Jan

--
****************************************************
  Helsinki University of Technology
  Dept. of Mets=E4hovi Radio Observatory
  http://www.metsahovi.fi/~jwagner/
  Work +358-9-428320-36

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
