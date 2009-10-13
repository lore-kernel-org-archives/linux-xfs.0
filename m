Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DFTobD124021 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 10:29:50 -0500
Received: from mail-yw0-f191.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B85E14BEA20
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 08:31:18 -0700 (PDT)
Received: from mail-yw0-f191.google.com (mail-yw0-f191.google.com
	[209.85.211.191]) by cuda.sgi.com with ESMTP id
	v9IT94cL7i0vG1CV for <xfs@oss.sgi.com>;
	Tue, 13 Oct 2009 08:31:18 -0700 (PDT)
Received: by ywh29 with SMTP id 29so11187493ywh.32
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 08:31:18 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 13 Oct 2009 09:31:18 -0600
Message-ID: <2c27bf870910130831u4d1b9d62j8a7c793b9042956d@mail.gmail.com>
Subject: xfs_growfs for Realtime partition returns error
From: Amit Agarwal <agarwala@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4396526957274267725=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4396526957274267725==
Content-Type: multipart/alternative; boundary=000e0cd48b70d5a8210475d2bc31

--000e0cd48b70d5a8210475d2bc31
Content-Type: text/plain; charset=ISO-8859-1

Hi,

When I am trying to grow my real time partition from 945GB to 975GB  i am
getting error. I am using Linux 2.6.18
and xfsprogs 3.0


Below is the output for all


*1) Created drive with 4 partitions (10, 15, 945, 30) GB*

/var/mnt/mine # fdisk -lu /dev/sda

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
1 heads, 63 sectors/track, 31008336 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes

  Device Boot    Start       End    Blocks   Id  System
/dev/sda1              63    19531313     9765625+  83  Linux
Partition 1 does not end on cylinder boundary.
/dev/sda2        19531315    48828190    14648438   83  Linux
Partition 2 does not end on cylinder boundary.
/dev/sda3        48828192  1894531317   922851563   83  Linux
Partition 3 does not end on cylinder boundary.
/dev/sda4      1894531319  1953525167    29496924+  83  Linux
Partition 4 does not end on cylinder boundary.


*2) Created files systems (1, 4 regular partitions) while (2 will be
meta-data and 3 will be realtime partition)*

*mkfs.xfs -f /dev/sda1*

meta-data=/dev/sda1       isize=256    agcount=4, agsize=610352 blks
                =                       sectsz=512   attr=2
data         =                       bsize=4096   blocks=2441406, imaxpct=25
                =                       sunit=0      swidth=0 blks
naming   =version 2         bsize=4096   ascii-ci=0
log          =internal log     bsize=4096   blocks=2560, version=2
               =                       sectsz=512   sunit=0 blks,
lazy-count=0
realtime =none               extsz=4096   blocks=0, rtextents=0

* mkfs.xfs -fr extsize=2m,rtdev=/dev/sda3 -l internal,size=18240b /dev/sda2*

meta-data=/dev/sda2       isize=256    agcount=4, agsize=915528 blks
                =                       sectsz=512   attr=2
data        =                       bsize=4096   blocks=3662109, imaxpct=25
               =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log        =internal log           bsize=4096   blocks=18240, version=2
               =                       sectsz=512   sunit=0 blks,
lazy-count=0
realtime =/dev/sda3              extsz=2097152 blocks=230712890,
rtextents=450611

* mkfs.xfs -f /dev/sda4*

meta-data=/dev/sda4              isize=256    agcount=4, agsize=1843558 blks
        =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=7374231, imaxpct=25
        =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=3600, version=2
        =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0


* 3) After some operations partition 4 is deleted and partition 3 is
expanded to end of drive (10,15, 975)*

/var/mnt/mine # fdisk -lu /dev/sda

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
1 heads, 63 sectors/track, 31008336 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes

  Device Boot    Start       End    Blocks   Id  System
/dev/sda1              63    19531313     9765625+  83  Linux
Partition 1 does not end on cylinder boundary.
/dev/sda2        19531315    48828190    14648438   83  Linux
Partition 2 does not end on cylinder boundary.
/dev/sda3        48828192  1953525167   952348488   83  Linux
Partition 3 does not end on cylinder boundary.


* 4) Now when i try to grow the realtime partition to end of drive growfs
fails*

mount -t xfs -o rtdev=/dev/sda3 /dev/sda2 /mnt/HDD_ROOT/

* xfs_growfs -r /mnt/HDD_ROOT/*

meta-data=/dev/sda2              isize=256    agcount=4, agsize=915528 blks
        =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=3662109, imaxpct=25
        =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=18240, version=2
        =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =/dev/sda3              extsz=2097152
blocks=230712890,rtextents=450611

xfs_growfs: XFS_IOC_FSGROWFSRT xfsctl failed: Input/output error
realtime blocks changed from 230712890 to 238087122


[88376.347000] attempt to access beyond end of device [88376.348000]
sda2: rw=0, want=4231282112, limit=29296876
[88376.349000] I/O error in filesystem ("sda2") meta-data dev sda2 block
0xfc343db8       ("xfs_trans_read_buf") error 5 buf count 4096
[88376.350000] xfs_force_shutdown(sda2,0x1) called from line 415 of file
fs/xfs/xfs_trans_buf.c.  Return address = 0xc028afe0 [88376.361000]
Filesystem "sda2": I/O Error Detected.  Shutting down filesystem: sda2
[88376.362000] Please umount the filesystem, and rectify the problem(s)


Thanks
Amit

--000e0cd48b70d5a8210475d2bc31
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">Hi,<br><br>When I am trying to grow my real time=
 partition from 945GB to 975GB=A0 i am getting error. I am using Linux 2.6.=
18<br>and xfsprogs 3.0<br><br><br>Below is the output for all <br><br><br><=
b>1) Created drive with 4 partitions (10, 15, 945, 30) GB</b><br>

<br>
/var/mnt/mine # fdisk -lu /dev/sda<br>
<br>
Disk /dev/sda: 1000.2 GB, 1000204886016 bytes<br>
1 heads, 63 sectors/track, 31008336 cylinders, total 1953525168 sectors<br>
Units =3D sectors of 1 * 512 =3D 512 bytes<br>
<br>
 =A0 Device Boot =A0 =A0Start =A0 =A0 =A0 End =A0 =A0Blocks =A0 Id =A0Syste=
m<br>
/dev/sda1 =A0 =A0 =A0 =A0 =A0 =A0 =A063 =A0 =A019531313 =A0 =A0 9765625+ =
=A083 =A0Linux<br>
Partition 1 does not end on cylinder boundary.<br>
/dev/sda2 =A0 =A0 =A0 =A019531315 =A0 =A048828190 =A0 =A014648438 =A0 83 =
=A0Linux<br>
Partition 2 does not end on cylinder boundary.<br>
/dev/sda3 =A0 =A0 =A0 =A048828192 =A01894531317 =A0 922851563 =A0 83 =A0Lin=
ux<br>
Partition 3 does not end on cylinder boundary.<br>
/dev/sda4 =A0 =A0 =A01894531319 =A01953525167 =A0 =A029496924+ =A083 =A0Lin=
ux<br>
Partition 4 does not end on cylinder boundary.<br>
<br>
<br>
<b>2) Created files systems (1, 4 regular partitions) while (2 will be
meta-data and 3 will be realtime partition)</b><br><br><b>mkfs.xfs -f
/dev/sda1</b><br>
<br>meta-data=3D/dev/sda1=A0 =A0 =A0=A0 isize=3D256 =A0 =A0agcount=3D4, ags=
ize=3D610352
blks<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 sectsz=3D512 =A0 attr=3D2<br>
data =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=
=3D4096 =A0 blocks=3D2441406, imaxpct=3D25<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sunit=3D0 =A0 =A0 =A0sw=
idth=3D0 blks<br>
naming =A0 =3Dversion 2 =A0 =A0=A0 =A0=A0 bsize=3D4096 =A0 ascii-ci=3D0<br>
log =A0 =A0 =A0=A0=A0=A0 =3Dinternal log =A0 =A0 bsize=3D4096 =A0 blocks=3D=
2560, version=3D2<br>=A0 =A0 =A0 =A0=A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D512 =A0 sunit=3D0 blks, lazy-count=3D0<br=
>
realtime =3Dnone =A0 =A0 =A0 =A0 =A0 =A0 =A0 extsz=3D4096 =A0 blocks=3D0, r=
textents=3D0<br>
<br><b>
mkfs.xfs -fr extsize=3D2m,rtdev=3D/dev/sda3 -l
internal,size=3D18240b /dev/sda2</b><br>
<br>
meta-data=3D/dev/sda2 =A0 =A0=A0=A0 isize=3D256 =A0 =A0agcount=3D4, agsize=
=3D915528
blks<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 sectsz=3D512 =A0 attr=3D2<br>
data =A0 =A0 =A0=A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=
=3D4096 =A0 blocks=3D3662109, imaxpct=3D25<br>
 =A0 =A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 sunit=3D0 =A0 =A0 =A0swidth=3D0 blks<br>
naming =A0 =3Dversion 2 =A0 =A0 =A0 =A0 =A0 =A0 =A0bsize=3D4096 =A0 ascii-c=
i=3D0<br>
log =A0 =A0 =A0=A0 =3Dinternal log =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =A0 blo=
cks=3D18240, version=3D2<br>=A0 =A0 =A0 =A0=A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D512 =A0 sunit=3D0 blks, lazy-count=
=3D0<br>
realtime =3D/dev/sda3 =A0 =A0 =A0 =A0 =A0 =A0 =A0extsz=3D2097152 blocks=3D2=
30712890,
rtextents=3D450611<br>
<br><b>
mkfs.xfs -f /dev/sda4</b><br>
<br>
meta-data=3D/dev/sda4 =A0 =A0 =A0 =A0 =A0 =A0 =A0isize=3D256 =A0 =A0agcount=
=3D4, agsize=3D1843558
blks<br>
 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D5=
12 =A0 attr=3D2<br>
data =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =
=A0 blocks=3D7374231, imaxpct=3D25<br>
 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sunit=3D0 =
=A0 =A0 =A0swidth=3D0 blks<br>
naming =A0 =3Dversion 2 =A0 =A0 =A0 =A0 =A0 =A0 =A0bsize=3D4096 =A0 ascii-c=
i=3D0<br>
log =A0 =A0 =A0=3Dinternal log =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =A0 blocks=
=3D3600, version=3D2<br>
 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D5=
12 =A0 sunit=3D0 blks, lazy-count=3D0<br>
realtime =3Dnone =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 extsz=3D4096 =A0 block=
s=3D0, rtextents=3D0<br>
<br>
<br><b>
3) After some operations partition 4 is deleted and partition 3 is=A0
expanded to end of drive (10,15, 975)</b><br>
<br>
/var/mnt/mine # fdisk -lu /dev/sda<br>
<br>
Disk /dev/sda: 1000.2 GB, 1000204886016 bytes<br>
1 heads, 63 sectors/track, 31008336 cylinders, total 1953525168 sectors<br>
Units =3D sectors of 1 * 512 =3D 512 bytes<br>
<br>
 =A0 Device Boot =A0 =A0Start =A0 =A0 =A0 End =A0 =A0Blocks =A0 Id =A0Syste=
m<br>
/dev/sda1 =A0 =A0 =A0 =A0 =A0 =A0 =A063 =A0 =A019531313 =A0 =A0 9765625+ =
=A083 =A0Linux<br>
Partition 1 does not end on cylinder boundary.<br>
/dev/sda2 =A0 =A0 =A0 =A019531315 =A0 =A048828190 =A0 =A014648438 =A0 83 =
=A0Linux<br>
Partition 2 does not end on cylinder boundary.<br>
/dev/sda3 =A0 =A0 =A0 =A048828192 =A01953525167 =A0 952348488 =A0 83 =A0Lin=
ux<br>
Partition 3 does not end on cylinder boundary.<br>
<br>
<br><b>
4) Now when i try to grow the realtime partition to end of drive growfs fai=
ls</b><br>
<br>
mount -t xfs -o rtdev=3D/dev/sda3 /dev/sda2 /mnt/HDD_ROOT/<br><br><b>
xfs_growfs -r /mnt/HDD_ROOT/</b><br>
<br>
meta-data=3D/dev/sda2 =A0 =A0 =A0 =A0 =A0 =A0 =A0isize=3D256 =A0 =A0agcount=
=3D4, agsize=3D915528
blks<br>
 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D5=
12 =A0 attr=3D2<br>
data =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =
=A0 blocks=3D3662109, imaxpct=3D25<br>
 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sunit=3D0 =
=A0 =A0 =A0swidth=3D0 blks<br>
naming =A0 =3Dversion 2 =A0 =A0 =A0 =A0 =A0 =A0 =A0bsize=3D4096 =A0 ascii-c=
i=3D0<br>
log =A0 =A0 =A0=3Dinternal =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =A0 blo=
cks=3D18240, version=3D2<br>
 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D5=
12 =A0 sunit=3D0 blks, lazy-count=3D0<br>
realtime =3D/dev/sda3 =A0 =A0 =A0 =A0 =A0 =A0 =A0extsz=3D2097152 blocks=3D2=
30712890,rtextents=3D450611<br><br>
xfs_growfs: XFS_IOC_FSGROWFSRT xfsctl failed: Input/output error<br>
realtime blocks changed from 230712890 to 238087122<br>
<br>
<br>
[88376.347000] attempt to access beyond end of device [88376.348000]<br>
sda2: rw=3D0, want=3D4231282112, limit=3D29296876<br>
[88376.349000] I/O error in filesystem (&quot;sda2&quot;) meta-data dev sda=
2 block<br>
0xfc343db8 =A0 =A0 =A0 (&quot;xfs_trans_read_buf&quot;) error 5 buf count 4=
096<br>
[88376.350000] xfs_force_shutdown(sda2,0x1) called from line 415 of file<br=
>
fs/xfs/xfs_trans_buf.c. =A0Return address =3D 0xc028afe0 [88376.361000]<br>
Filesystem &quot;sda2&quot;: I/O Error Detected. =A0Shutting down filesyste=
m: sda2<br>
[88376.362000] Please umount the filesystem, and rectify the problem(s)<br>
<br><br>Thanks<br>Amit<br><br>
</div><br>

--000e0cd48b70d5a8210475d2bc31--


--===============4396526957274267725==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4396526957274267725==--
