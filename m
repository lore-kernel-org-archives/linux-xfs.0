Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:55181 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754802AbeDWNUF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Apr 2018 09:20:05 -0400
Received: by mail-it0-f50.google.com with SMTP id h143-v6so10858705ita.4
        for <linux-xfs@vger.kernel.org>; Mon, 23 Apr 2018 06:20:04 -0700 (PDT)
MIME-Version: 1.0
From: Andrea del Monaco <andrea.delmonaco@clustervision.com>
Date: Mon, 23 Apr 2018 15:19:22 +0200
Message-ID: <CA+1g8semVirCEfbQRNt8h-Cj7NV7p1FYP76XLjH4vVMVU7F=aw@mail.gmail.com>
Subject: XFS and Memory allocation
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Since a couple of days, my storage server keeps reporting the
following messages:
XFS: kworker/u16:1(21677) possible memory allocation deadlock size
33568 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33056 in kmem_alloc (mode:0x250)
XFS: kworker/u16:1(21677) possible memory allocation deadlock size
33568 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33056 in kmem_alloc (mode:0x250)
XFS: kworker/u16:1(21677) possible memory allocation deadlock size
33568 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33056 in kmem_alloc (mode:0x250)
XFS: kworker/u16:1(21677) possible memory allocation deadlock size
33568 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33056 in kmem_alloc (mode:0x250)

I am not quite sure about where's the issue from, as there's still
some free memory left.
The only way to make it disappear (temporary) would be by using:
echo 2 > /proc/sys/vm/drop_caches

Please find below the details about the machine:
[root@storage02 ~]# cat /etc/redhat-release
CentOS Linux release 7.3.1611 (Core)
[root@storage02 ~]# uname -r
3.10.0-514.26.2.el7.x86_64
[root@storage02 ~]# lsblk
NAME            MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda               8:0    0 893.8G  0 disk
sdb               8:16   0  58.2T  0 disk
sdc               8:32   0  58.2T  0 disk
sdd               8:48   0 893.8G  0 disk /beegfs/j4-meta1
sde               8:64   0  58.2T  0 disk /beegfs/j4-stor1
sdf               8:80   0  58.2T  0 disk /beegfs/j4-stor2
sdg               8:96   0 893.8G  0 disk /beegfs/j2-meta1
sdh               8:112  0  58.2T  0 disk /beegfs/j2-stor1
sdi               8:128  0  58.2T  0 disk /beegfs/j2-stor2
sdj               8:144  0 893.8G  0 disk
sdk               8:160  0  58.2T  0 disk
sdl               8:176  0  58.2T  0 disk
sdm               8:192  0 110.8G  0 disk
=E2=94=9C=E2=94=80sdm1            8:193  0   256M  0 part /boot
=E2=94=9C=E2=94=80sdm2            8:194  0  11.1G  0 part [SWAP]
=E2=94=94=E2=94=80sdm3            8:195  0  99.5G  0 part
  =E2=94=94=E2=94=80system-root 253:0    0  99.5G  0 lvm  /

[root@storage02 ~]# uname -r
3.10.0-514.26.2.el7.x86_64
[root@storage02 ~]# rpm -qa | grep kernel
kernel-devel-3.10.0-514.26.2.el7.x86_64
kernel-tools-libs-3.10.0-514.26.2.el7.x86_64
kernel-3.10.0-514.26.2.el7.x86_64
kernel-3.10.0-327.36.3.el7.x86_64
kernel-tools-3.10.0-514.26.2.el7.x86_64
kmod-ifs-kernel-updates-3.10.0_514.26.2.el7.x86_64-535.x86_64
ifs-kernel-updates-devel-3.10.0_514.26.2.el7.x86_64-535.x86_64
kernel-devel-3.10.0-327.36.3.el7.x86_64
kernel-headers-3.10.0-514.26.2.el7.x86_64
[root@storage02 ~]# rpm -qa | grep xfs
xfsprogs-4.5.0-10.el7_3.x86_64

[root@storage02 ~]# cat /proc/sys/vm/dirty_background_ratio
1
[root@storage02 ~]# cat /proc/sys/vm/dirty_ratio
75
[root@storage02 ~]# cat  /proc/sys/vm/vfs_cache_pressure
50

rc.local:
#BeeGFS tuning - storage targets
for i in sdb sdc sde sdf sdh sdi sdk sdl; do
  echo deadline > /sys/block/$i/queue/scheduler
  echo 4096 > /sys/block/$i/queue/nr_requests
  echo 4096 > /sys/block/$i/queue/read_ahead_kb
done

#BeeGFS tuning - meta targets
for i in sda sdd sdg sdj; do
  echo deadline > /sys/block/$i/queue/scheduler
  echo 128 > /sys/block/$i/queue/nr_requests
done

echo always > /sys/kernel/mm/transparent_hugepage/enabled
echo always > /sys/kernel/mm/transparent_hugepage/defrag


The error
XFS: kworker/u16:1(21677) possible memory allocation deadlock size
33568 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33056 in kmem_alloc (mode:0x250)
XFS: kworker/u16:1(21677) possible memory allocation deadlock size
33568 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33056 in kmem_alloc (mode:0x250)
XFS: kworker/u16:1(21677) possible memory allocation deadlock size
33568 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33056 in kmem_alloc (mode:0x250)
XFS: kworker/u16:1(21677) possible memory allocation deadlock size
33568 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33056 in kmem_alloc (mode:0x250)
XFS: kworker/u16:1(21677) possible memory allocation deadlock size
33568 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33056 in kmem_alloc (mode:0x250)
XFS: kworker/u16:1(21677) possible memory allocation deadlock size
33568 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33056 in kmem_alloc (mode:0x250)
XFS: kworker/u16:1(21677) possible memory allocation deadlock size
33568 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33056 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33056 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33072 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33072 in kmem_alloc (mode:0x250)
XFS: kworker/u16:2(4526) possible memory allocation deadlock size
33584 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33072 in kmem_alloc (mode:0x250)
XFS: kworker/u16:0(27932) possible memory allocation deadlock size
33072 in kmem_alloc (mode:0x250)

Fix:
echo 2 > /proc/sys/vm/drop_caches


Info about the FSs using XFS:
[root@storage02 ~]# xfs_info /dev/sde
meta-data=3D/dev/sde               isize=3D512    agcount=3D59, agsize=3D26=
8435328 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D0        finobt=3D0 spinodes=3D0
data     =3D                       bsize=3D4096   blocks=3D15625879552, ima=
xpct=3D1
         =3D                       sunit=3D128    swidth=3D2048 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D64 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
[root@storage02 ~]# xfs_info /dev/sdf
meta-data=3D/dev/sdf               isize=3D512    agcount=3D59, agsize=3D26=
8435328 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D0        finobt=3D0 spinodes=3D0
data     =3D                       bsize=3D4096   blocks=3D15625879552, ima=
xpct=3D1
         =3D                       sunit=3D128    swidth=3D2048 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D64 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
[root@storage02 ~]# xfs_info /dev/sdi
meta-data=3D/dev/sdi               isize=3D512    agcount=3D59, agsize=3D26=
8435392 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D0        finobt=3D0 spinodes=3D0
data     =3D                       bsize=3D4096   blocks=3D15625879552, ima=
xpct=3D1
         =3D                       sunit=3D64     swidth=3D1024 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D64 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
[root@storage02 ~]# xfs_info /dev/sdh
meta-data=3D/dev/sdh               isize=3D512    agcount=3D59, agsize=3D26=
8435392 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D0        finobt=3D0 spinodes=3D0
data     =3D                       bsize=3D4096   blocks=3D15625879552, ima=
xpct=3D1
         =3D                       sunit=3D64     swidth=3D1024 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D64 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

[root@storage02 ~]# mount | grep beegfs
/dev/sdd on /beegfs/j4-meta1 type ext4
(rw,noatime,nodiratime,nobarrier,data=3Dordered)
/dev/sdg on /beegfs/j2-meta1 type ext4
(rw,noatime,nodiratime,nobarrier,data=3Dordered)
/dev/sde on /beegfs/j4-stor1 type xfs
(rw,noatime,nodiratime,swalloc,attr2,largeio,nobarrier,inode64,logbufs=3D8,=
logbsize=3D256k,sunit=3D1024,swidth=3D16384,usrquota,gqnoenforce)
/dev/sdf on /beegfs/j4-stor2 type xfs
(rw,noatime,nodiratime,swalloc,attr2,largeio,nobarrier,inode64,logbufs=3D8,=
logbsize=3D256k,sunit=3D1024,swidth=3D16384,usrquota,gqnoenforce)
/dev/sdi on /beegfs/j2-stor2 type xfs
(rw,noatime,nodiratime,swalloc,attr2,largeio,nobarrier,inode64,logbufs=3D8,=
logbsize=3D256k,sunit=3D512,swidth=3D8192,usrquota,gqnoenforce)
/dev/sdh on /beegfs/j2-stor1 type xfs
(rw,noatime,nodiratime,swalloc,attr2,largeio,nobarrier,inode64,logbufs=3D8,=
logbsize=3D256k,sunit=3D512,swidth=3D8192,usrquota,gqnoenforce)


While the issue was present, i've tried to gather some data:
[root@storage02 ~]# dmesg
[18038038.420617] XFS: kworker/u16:4(14255) possible memory allocation
deadlock size 33712 in kmem_alloc (mode:0x250)
[18038039.884236] XFS: kworker/u16:4(14255) possible memory allocation
deadlock size 33712 in kmem_alloc (mode:0x250)
[18038041.894279] XFS: kworker/u16:4(14255) possible memory allocation
deadlock size 33712 in kmem_alloc (mode:0x250)
[root@storage02 ~]# free -mh
              total        used        free      shared  buff/cache   avail=
able
Mem:            62G        4.3G        979M         19M         57G        =
 56G
Swap:           11G        211M         10G

[root@storage02 ~]# cat /proc/buddyinfo
Node 0, zone      DMA      1      0      0      1      1      0      0
     0      0      1      2
Node 0, zone    DMA32   2311   4049  12054   1094      3      0      0
     0      0      0      0
Node 0, zone   Normal 100457  23750   5087   1342      1      0      0
     0      0      0      0

[root@storage02 ~]# ps aux | grep " D "
root     14255  0.2  0.0      0     0 ?        D    10:22   0:01 [kworker/u=
16:4]
root     15729  0.0  0.0      0     0 ?        D    10:28   0:00 [kworker/2=
:42]
root     15732  0.0  0.0      0     0 ?        D    10:28   0:00 [kworker/2=
:43]
root     15734  0.0  0.0      0     0 ?        D    10:28   0:00 [kworker/2=
:44]
root     15735  0.0  0.0      0     0 ?        D    10:28   0:00 [kworker/2=
:45]
root     16508  0.0  0.0 112648   968 pts/1    S+   10:31   0:00 grep
--color=3Dauto  D

[root@storage02 ~]# vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu=
-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id =
wa st
58  1 216804 1000156 5714032 54494696    0    0  1228  3505    0    0
2  4 93  1  0
[root@storage02 ~]# vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu=
-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id =
wa st
 1  1 216804 986720 5714132 54506996    0    0  1228  3505    0    0
2  4 93  1  0
[root@storage02 ~]# vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu=
-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id =
wa st
63  1 216804 1016120 5714176 54478188    0    0  1228  3505    0    0
2  4 93  1  0
[root@storage02 ~]# vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu=
-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id =
wa st
 1  1 216804 1012572 5714196 54482276    0    0  1228  3505    0    0
2  4 93  1  0

[root@storage02 ~]# vmstat  1
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu=
-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id =
wa st
 1  0 216804 884428 5714688 54606884    0    0  1228  3505    0    0
2  4 93  1  0
 0  0 216804 869488 5714744 54621520    0    0     4  2248 90864
280824  7 16 76  0  0
 0  0 216804 854532 5714828 54636236    0    0     4  7188 68939
215948  6 13 81  1  0
 0  0 216804 839072 5714900 54651260    0    0    12 66796 121773
390372 10 23 67  0  0
 0  0 216804 824832 5714948 54665660    0    0     0     0 65629
182502  4 11 85  0  0
 1  0 216804 806356 5715004 54679580    0    0     8 10296 108415
337787  9 20 71  0  0
 0  0 216804 792212 5715088 54694268    0    0     0  2340 129698
400597 10 24 67  0  0
 0  0 216804 777452 5715144 54708688    0    0     0  3252 92331
282641  8 16 76  0  0
39  0 216804 763512 5715700 54722608    0    0   540  5408 84641
265557  7 15 78  0  0
 0  0 216804 749560 5715748 54737136    0    0     0     0 117451
385523 10 23 67  0  0
 0  0 216804 734860 5715792 54751596    0    0     0     0 125409
391832  9 24 67  0  0
 0  0 216804 720656 5715852 54766136    0    0     0  2476 78634
234247  6 14 80  0  0
 0  0 216804 706948 5715920 54779868    0    0    24 10756 85675
270733  7 16 77  0  0
 0  0 216804 693056 5715956 54793888    0    0     4  6844 122175
389915 10 23 67  0  0
41  0 216804 678724 5716012 54808844    0    0     0     0 100977
312065  8 18 74  0  0
 0  0 216804 664360 5716088 54822964    0    0     0     0 79725
250138  6 14 79  0  0
 0  0 216804 649820 5716144 54837296    0    0     0  2288 114461
378085 11 22 68  0  0
42  0 216804 635924 5716204 54851240    0    0     0 10652 97495
298287  7 18 75  0  0
 0  0 216804 621596 5716240 54865476    0    0     8 12432 86449
261807  7 15 78  0  0

[Mon Apr 23 10:41:11 2018] XFS: kworker/u16:4(14255) possible memory
allocation deadlock size 33200 in kmem_alloc (mode:0x250)
[Mon Apr 23 10:41:13 2018] XFS: kworker/u16:4(14255) possible memory
allocation deadlock size 33200 in kmem_alloc (mode:0x250)
[root@storage02 ~]# date
Mon Apr 23 10:35:17 UTC 2018
[root@storage02 ~]# vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu=
-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id =
wa st
 1  1 216804 1010596 5727768 54464024    0    0  1228  3505    0    0
2  4 93  1  0
[root@storage02 ~]# vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu=
-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id =
wa st
 1  1 216804 990480 5727912 54483820    0    0  1228  3505    0    0
2  4 93  1  0
 1  1 216804 1018588 5727944 54456272    0    0     0     4 65812
181488  5 10 75 11  0
 0  1 216804 1010200 5728004 54464252    0    0     0  2276 95495
323022  8 20 63  9  0
 0  1 216804 1002040 5728076 54472092    0    0     0    20 126184
395655 10 23 59  8  0
 0  1 216804 993956 5728164 54480232    0    0     0  7500 83897
236594  6 13 71 10  0
 0  1 216804 985940 5728212 54488112    0    0     0     0 81325
268329  7 16 67 10  0
 0  1 216804 1001508 5728248 54472076    0    0     0     8 125449
395975 10 23 59  8  0
 1  1 216804 993664 5728324 54479908    0    0     0  2344 113745
346333  9 20 62  9  0
 0  1 216804 985376 5728384 54488012    0    0     0     0 56207
172372  5 10 75 11  0
 0  1 216804 1014060 5728456 54460392    0    0     0  3216 121451
388402 10 22 59  9  0
 1  1 216804 1005640 5728508 54468004    0    0    24 23228 97042
281593  7 17 67  9  0
 0  1 216804 996884 5728560 54476676    0    0     0     0 70147
222651  6 13 71 10  0
20  1 216804 988500 5728632 54484516    0    0    36  5872 129464
406727 10 24 58  8  0
36  1 216804 1016252 5728688 54457816    0    0     4   276 112221
350346  9 21 62  9  0
 0  1 216804 1008208 5728752 54465104    0    0     0  3076 75175
222589  5 12 72 10  0
 1  0 216804 1000872 5728804 54473236    0    0    16 203248 120988
376914 10 22 60  8  0
 3  1 216804 1672876 5728852 53799244    0    0     4     4 135322
404492 10 25 57  8  0
 0  1 216804 8276484 5728892 47196952    0    0    28  2320 15461
20558  1 11 76 12  0
 0  1 216804 8278968 5728912 47197548    0    0     0     0 3449 4218
0  0 87 13  0
 0  1 216804 8278316 5728940 47198152    0    0     0  7220 4725 4765
0  0 87 13  0
 0  1 216804 8277780 5728960 47198788    0    0     0  4112 4895 5154
0  0 87 12  0
 0  1 216804 8276972 5728972 47199444    0    0     0  4560 4198 5250
0  1 87 12  0
 0  1 216804 8277036 5729000 47199360    0    0    96  6868 4027 4939
0  0 87 12  0
 0  1 216804 8276372 5729016 47199876    0    0     0     4 3148 3896
0  0 87 12  0
 1  1 216804 8276004 5729028 47200336    0    0     0     0 3020 3803
0  0 87 12  0
 0  1 216804 8276344 5729036 47199936    0    0    52  7916 2695 3601
0  0 87 12  0
 0  1 216804 8276200 5729040 47200076    0    0     0     0 1381 1782
0  0 87 12  0
 0  1 216804 8276084 5729064 47200136    0    0     0  1136 6262 6581
0  0 87 12  0
 0  1 216804 8276076 5729068 47200140    0    0     0     0  999 1366
0  0 87 13  0
 0  1 216804 8276076 5729068 47200140    0    0     0     0  687  900
0  0 87 12  0
 0  1 216804 8276076 5729068 47200140    0    0     0     0  440  660
0  0 88 13  0
 0  1 216804 8276108 5729068 47200108    0    0     0     0  426  644
0  0 87 12  0
 0  1 216804 8276136 5729068 47200076    0    0     0     0 1303 1256
0  0 87 12  0
 0  1 216804 8276132 5729076 47200076    0    0     0   192  516  702
0  0 87 12  0
 0  1 216804 8276164 5729076 47200044    0    0     0  2764 1065  919
0  0 88 12  0
 0  1 216804 8276164 5729076 47200044    0    0     0     0  491  683
0  0 87 12  0
^C
[root@storage02 ~]# ps aux | grep " D "
root     14255  0.5  0.0      0     0 ?        D    10:22   0:04 [kworker/u=
16:4]
root     15649  0.0  0.0      0     0 ?        D    10:28   0:00 [kworker/3=
:1]
root     15686  0.0  0.0      0     0 ?        D    10:28   0:00 [kworker/3=
:3]
root     15717  0.0  0.0      0     0 ?        D    10:28   0:00 [kworker/3=
:5]
root     16627  0.0  0.0      0     0 ?        D    10:32   0:00 [kworker/3=
:9]
root     17614  0.0  0.0 112648   964 pts/1    S+   10:36   0:00 grep
--color=3Dauto  D
[root@storage02 ~]# cat /proc/buddyinfo
Node 0, zone      DMA      1      0      0      1      1      0      0
     0      0      1      2
Node 0, zone    DMA32   2964   4379  13405    954      4      0      0
     0      0      0      0
Node 0, zone   Normal 490525 563348  71048  11427     49      0      0
     0      0      0      0
[root@storage02 ~]# free -mh
              total        used        free      shared  buff/cache   avail=
able
Mem:            62G        4.3G        7.9G         19M         50G        =
 56G
Swap:           11G        211M         10G

Does anybody have any idea about what might be wrong here?
I would suspect a kernel bug. We couldn't try another version yet.

Regards,
