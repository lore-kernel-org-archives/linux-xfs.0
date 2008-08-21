Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Aug 2008 07:59:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7LEx8KH018972
	for <linux-xfs@oss.sgi.com>; Thu, 21 Aug 2008 07:59:09 -0700
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
Date: Thu, 21 Aug 2008 17:00:29 +0200
References: <20080820004326.519405a2.akpm@linux-foundation.org> <20080821082532.GE5706@disturbed> <200808211302.51633.Martin@lichtvoll.de> (sfid-20080821_130438_618949_A1D25F54)
In-Reply-To: <200808211302.51633.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_OMYrIFmVJEzwDPr"
Message-Id: <200808211700.30380.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: Szabolcs Szakacsits <szaka@ntfs-3g.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

--Boundary-00=_OMYrIFmVJEzwDPr
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Am Donnerstag 21 August 2008 schrieb Martin Steigerwald:
> Am Donnerstag 21 August 2008 schrieb Dave Chinner:
> > On Thu, Aug 21, 2008 at 04:04:18PM +1000, Dave Chinner wrote:
> > > On Thu, Aug 21, 2008 at 03:15:08PM +1000, Dave Chinner wrote:
> > > > On Thu, Aug 21, 2008 at 05:46:00AM +0300, Szabolcs Szakacsits 
wrote:
> > > > > On Thu, 21 Aug 2008, Dave Chinner wrote:
> > > > > Everything is default.
> > > > >
> > > > >   % rpm -qf =mkfs.xfs
> > > > >   xfsprogs-2.9.8-7.1
> > > > >
> > > > > which, according to ftp://oss.sgi.com/projects/xfs/cmd_tars, is
> > > > > the latest stable mkfs.xfs. Its output is
> > > > >
> > > > > meta-data=/dev/sda8              isize=256    agcount=4,
> > > > > agsize=1221440 blks =                       sectsz=512   attr=2
> > > > > data     =                       bsize=4096   blocks=4885760,
> > > > > imaxpct=25 =                       sunit=0      swidth=0 blks
> > > > > naming   =version 2              bsize=4096
> > > > > log      =internal log           bsize=4096   blocks=2560,
> > > > > version=2 =                       sectsz=512   sunit=0 blks,
> > > > > lazy-count=0 realtime =none                   extsz=4096
> > > > > blocks=0, rtextents=0
> > > >
> > > > Ok, I thought it might be the tiny log, but it didn't improve
> > > > anything here when increased the log size, or the log buffer
> > > > size.
> > >
> > > One thing I just found out - my old *laptop* is 4-5x faster than
> > > the 10krpm scsi disk behind an old cciss raid controller.  I'm
> > > wondering if the long delays in dispatch is caused by an
> > > interaction with CTQ but I can't change it on the cciss raid
> > > controllers. Are you using ctq/ncq on your machine?  If so, can you
> > > reduce the depth to something less than 4 and see what difference
> > > that makes?
> >
> > Just to point out - this is not a new problem - I can reproduce
> > it on 2.6.24 as well as 2.6.26. Likewise, my laptop shows XFS
> > being faster than ext3 on both 2.6.24 and 2.6.26. So the difference
> > is something related to the disk subsystem on the server....
>
> Interesting. I switched from cfq to deadline some time ago, due to
> abysmal XFS performance on parallel IO - aptitude upgrade and doing
> desktop stuff. Just my subjective perception, but I have seen it crawl,
> even stall for 5-10 seconds easily at times. I found deadline to be way
> faster initially, but then it rarely happened that IO for desktop tasks
> is basically stalled for even longer, say 15 seconds or more, on
> parallel IO. However I can't remember having this problem with the last
> kernel 2.6.26.2.
>
> I am now testing with cfq again. On a ThinkPad T42 internal 160 GB
> harddisk with barriers enabled. But you tell, it only happens on
> certain servers, so I might have seen something different.
>
> Thus I had the rough feeling that something is wrong with at least CFQ
> and XFS together, but I couldn't prove it back then. I have no idea how
> to easily do a reproducable test case. Maybe having a script that
> unpacks kernel source archives while I try to use the desktop...

Okay, some numbers attached:

- On XFS: Barrier versus Nobarrier makes quite a difference with 
compilebench. Also on rm -rf'ing the large directory tree it leaves 
behind. While I did not measure the first barrier related compilebench 
directory deletion I am pretty sure it took way longer. Also vmstat 
throughput it higher without nobarriers.
 
- On XFS: CFQ versus NOOP does not seem to make that much of a difference, 
at least not with barriers enabled (didn't test without). With NOOP 
responsiveness was even weaker than with CFQ. Opening a context menu on a 
webpage link displayed in Konqueror could take easily a minute or more. I 
think it shall never ever take that long for the OS to respond to user 
input.

- Ext3, NILFS, BTRFS with CFQ: Perform quite well. Especially btrfs. nilfs 
text isn't complete, cause likely due to checkpoints those 4G I dedicated 
to it were not enough for the compilebench test to complete.

So at least here performance degration with XFS seems more related to 
barriers than scheduler decision - least when it comes to the two choices 
CFQ and NOOP. But no, I won't switch barriers off permanently on my 
laptop. ;) Would be fine if performance impact of barriers could be 
reduced a bit tough.

At last I appear to see something different than the I/O scheduler issue 
discussed here.

Anyway subjectively I am quite happy with XFS performance nonetheless. But 
then since I can't switch from XFS to ext3 or btrfs in a second I can't 
really compare subjective impressions. Maybe desktop would respond faster 
with ext3 or btrfs? Who knows?

I think a script which does extensive automated testing would be fine:

- have some basic settings like

SCRATCH_DEV=/dev/sda8 (this should be a real partition in order to be able 
to test barriers which do not work over LVM / device mapper)

SCRATCH_MNT=/mnt/test

- have an array of pre-pre-test setups like

[ echo "cfq" >/sys/block/sda/queue/scheduler ]
[ echo "deadline" >/sys/block/sda/queue/scheduler ]
[ echo "anticipatory" >/sys/block/sda/queue/scheduler ]
[ echo "noop" >/sys/block/sda/queue/scheduler ]

- have an array of pre-test setups like

[ mkfs.xfs -f $SCRATCH_DEV
mount $SCRATCH_DEV $SCRATCH_MNT ]
[ mkfs.xfs -f $SCRATCH_DEV
mount -o nobarrier $SCRATCH_DEV $SCRATCH_MNT ]
[ mkfs.xfs -f $SCRATCH_DEV
mount -o logbsize=256k $SCRATCH_DEV $SCRATCH_MNT ]
[ mkfs.btrfs $SCRATCH_DEV
mount $SCRATCH_DEV $SCRATCH_MNT ]

- have an array of tests like

[ ./compilebench -D /mnt/zeit-btrfs -i 5 -r 10 ]
[ postmark whatever ]
[ iozone whatever ]

- and let it run every combination of those array elements unattended 
(over night;-)

- have any results collected with settings for each patch and basic 
machine info in one easy to share text file

- then as additional feature let it test responsiveness during each 
running test. Let it makes sure there are some files that are not in the 
cache and let it access one of those files once in a while and measure 
how long it takes the filesystem to respond

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--Boundary-00=_OMYrIFmVJEzwDPr
Content-Type: text/plain;
  charset="iso 8859-15";
  name="filesystem-benchmarks-compilebench-2008-08-21.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="filesystem-benchmarks-compilebench-2008-08-21.txt"



martin@shambhala:~> date
Do 21. Aug 13:27:49 CEST 2008

shambhala:~> cat /proc/version
Linux version 2.6.26.2-tp42-toi-3.0-rc7a-xfs-ticket-patch
(martin@shambala) (gcc version 4.3.1 (Debian 4.3.1-8) ) #1 PREEMPT Wed
Aug 13 10:10:11 CEST 2008

shambhala:~> apt-show-versions | egrep "(btrfs|nilfs)"
btrfs-modules-2.6.26.2-tp42-toi-3.0-rc7a-xfs-ticket-patch 0.15-1+1
installed: No available version in archive
btrfs-source/lenny uptodate 0.15-1
btrfs-tools/lenny uptodate 0.15-2
nilfs2-modules-2.6.26.2-tp42-toi-3.0-rc7a-xfs-ticket-patch 2.0.4-1+1
installed: No available version in archive
nilfs2-source/sid uptodate 2.0.4-1
nilfs2-tools/lenny uptodate 2.0.5-1

shambhala:~> cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 13
model name      : Intel(R) Pentium(R) M processor 1.80GHz
stepping        : 6
cpu MHz         : 600.000
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr mce cx8 sep mtrr pge mca cmov
pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe bts est tm2
bogomips        : 1197.54
clflush size    : 64
power management:


martin@shambhala:~> cat /proc/mounts | tail -4
/dev/mapper/shambala-ext3 /mnt/zeit-ext3 ext3
rw,errors=continue,data=ordered 0 0
/dev/mapper/shambala-nilfs /mnt/zeit-nilfs2 nilfs2 rw 0 0
/dev/mapper/shambala-btrfs /mnt/zeit-btrfs btrfs rw 0 0
/dev/mapper/shambala-xfs /mnt/zeit-xfs xfs
rw,attr2,nobarrier,logbufs=8,logbsize=256k,noquota 0 0
martin@shambhala:~> df -hT | tail -8
/dev/mapper/shambala-ext3
              ext3    4,0G  137M  3,7G   4% /mnt/zeit-ext3
/dev/mapper/shambala-nilfs
            nilfs2    4,0G   16M  3,8G   1% /mnt/zeit-nilfs2
/dev/mapper/shambala-btrfs
             btrfs    4,0G   40K  4,0G   1% /mnt/zeit-btrfs
/dev/mapper/shambala-xfs
               xfs    4,0G  4,2M  4,0G   1% /mnt/zeit-xfs

shambhala:~> xfs_info /mnt/zeit-xfs
meta-data=/dev/mapper/shambala-xfs isize=256    agcount=4, agsize=262144
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1048576, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

martin@shambhala:~> cat /sys/block/sda/queue/scheduler
noop anticipatory deadline [cfq]


XFS without barriers, since device mapper doesn't support barrier
requests (http://bugzilla.kernel.org/show_bug.cgi?id=9554):


shambhala:/home/martin/Linux/Dateisysteme/Performance-Messung/
compilebench/compilebench-0.6> ./compilebench -D /mnt/zeit-xfs -i 5 -r
10
using working directory /mnt/zeit-xfs, 5 intial dirs 10 runs
native unpatched native-0 222MB in 25.88 seconds (8.59 MB/s)
native patched native-0 109MB in 5.82 seconds (18.84 MB/s)
native patched compiled native-0 691MB in 33.69 seconds (20.53 MB/s)
create dir kernel-0 222MB in 20.38 seconds (10.91 MB/s)
create dir kernel-1 222MB in 27.27 seconds (8.15 MB/s)
create dir kernel-2 222MB in 26.69 seconds (8.33 MB/s)
create dir kernel-3 222MB in 25.17 seconds (8.83 MB/s)
create dir kernel-4 222MB in 29.52 seconds (7.53 MB/s)
patch dir kernel-2 109MB in 38.54 seconds (2.85 MB/s)
compile dir kernel-2 691MB in 41.60 seconds (16.62 MB/s)
compile dir kernel-4 680MB in 49.46 seconds (13.76 MB/s)
patch dir kernel-4 691MB in 118.19 seconds (5.85 MB/s)
read dir kernel-4 in 77.09 11.89 MB/s
read dir kernel-3 in 30.91 7.19 MB/s
create dir kernel-3116 222MB in 42.73 seconds (5.20 MB/s)
clean kernel-4 691MB in 6.48 seconds (106.73 MB/s)
read dir kernel-1 in 32.08 6.93 MB/s
stat dir kernel-0 in 6.94 seconds

run complete:
========================================================================
==
intial create total runs 5 avg 8.75 MB/s (user 2.05s sys 3.72s)
create total runs 1 avg 5.20 MB/s (user 2.40s sys 5.34s)
patch total runs 2 avg 4.35 MB/s (user 0.83s sys 3.93s)
compile total runs 2 avg 15.19 MB/s (user 0.56s sys 2.90s)
clean total runs 1 avg 106.73 MB/s (user 0.07s sys 0.40s)
read tree total runs 2 avg 7.06 MB/s (user 1.93s sys 3.94s)
read compiled tree total runs 1 avg 11.89 MB/s (user 2.29s sys 6.22s)
no runs for delete tree
no runs for delete compiled tree
stat tree total runs 1 avg 6.94 seconds (user 1.13s sys 0.94s)
no runs for stat compiled tree


With barriers on an already heavily populated filesystem - I don't have
an empty one on a raw partition at hand at the moment and I for sure
won't empty this one:

martin@shambhala:~> df -hT | grep /home
/dev/sda5      xfs    112G  104G  8,2G  93% /home

shambhala:~> df -hiT | grep /home
/dev/sda5      xfs       34M    751K     33M    3% /home

shambhala:~> xfs_db -rx /dev/sda5
xfs_db> frag
actual 726986, ideal 703687, fragmentation factor 3.20%
xfs_db> quit
shambhala:~>

martin@shambhala:~> cat /proc/mounts | grep "/home "
/dev/sda5 /home xfs rw,relatime,attr2,logbufs=8,logbsize=256k,noquota 0
0

shambhala:~> xfs_info /home
meta-data=/dev/sda5              isize=256    agcount=6, agsize=4883256
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=29299536,
imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

shambhala:/home/martin/Linux/Dateisysteme/Performance-Messung/
compilebench/compilebench-0.6> ./compilebench -D
/home/martin/Zeit/compilebench -i 5 -r 10
using working directory /home/martin/Zeit/compilebench, 5 intial dirs 10
runs
native unpatched native-0 222MB in 117.37 seconds (1.89 MB/s)
native patched native-0 109MB in 27.46 seconds (3.99 MB/s)
native patched compiled native-0 691MB in 48.03 seconds (14.40 MB/s)
create dir kernel-0 222MB in 83.55 seconds (2.66 MB/s)
create dir kernel-1 222MB in 86.01 seconds (2.59 MB/s)
create dir kernel-2 222MB in 71.61 seconds (3.11 MB/s)
create dir kernel-3 222MB in 71.73 seconds (3.10 MB/s)
create dir kernel-4 222MB in 61.61 seconds (3.61 MB/s)
patch dir kernel-2 109MB in 63.14 seconds (1.74 MB/s)
compile dir kernel-2 691MB in 45.61 seconds (15.16 MB/s)
compile dir kernel-4 680MB in 50.13 seconds (13.58 MB/s)
patch dir kernel-4 691MB in 154.38 seconds (4.48 MB/s)
read dir kernel-4 in 95.04 9.65 MB/s
read dir kernel-3 in 49.49 4.49 MB/s
create dir kernel-3116 222MB in 79.44 seconds (2.80 MB/s)
clean kernel-4 691MB in 8.64 seconds (80.05 MB/s)
read dir kernel-1 in 71.40 3.11 MB/s
stat dir kernel-0 in 14.44 seconds

run complete:
========================================================================
==
intial create total runs 5 avg 3.01 MB/s (user 2.34s sys 4.30s)
create total runs 1 avg 2.80 MB/s (user 2.36s sys 4.12s)
patch total runs 2 avg 3.11 MB/s (user 0.91s sys 4.07s)
compile total runs 2 avg 14.37 MB/s (user 0.60s sys 2.76s)
clean total runs 1 avg 80.05 MB/s (user 0.09s sys 0.45s)
read tree total runs 2 avg 3.80 MB/s (user 2.00s sys 4.05s)
read compiled tree total runs 1 avg 9.65 MB/s (user 2.36s sys 6.42s)
no runs for delete tree
no runs for delete compiled tree
stat tree total runs 1 avg 14.44 seconds (user 1.17s sys 1.07s)
no runs for stat compiled tree

shambhala:/home/martin/Linux/Dateisysteme/Performance-Messung/
compilebench/compilebench-0.6> rm -rf /home/martin/Zeit/compilebench

I didn't measure it, but it took *ages* while rm -rf was mostly in D
state. According to harddisk noise a lot of seeks where involved.

vmstat 1 during the rm -rf:

 0  0   2784 748048     20 247160    0    0   160  4628  352 1224 15 14
71  0
 0  0   2784 748056     20 247308    0    0   148  3848  298  442 11 10
79  0
 0  0   2784 747996     20 247428    0    0   120  3377  260  449  9  9
82  0
 0  0   2784 747764     20 247580    0    0   152  4364  324 1094 20 10
70  0
 1  0   2784 747452     20 247736    0    0   156  4356  279  814 15 11
74  0
 0  0   2784 747408     20 247900    0    0   164  4112  360 1131 13 13
74  0
 0  0   2784 747136     20 248064    0    0   164  5128  318  855 16 10
74  0
 0  0   2784 746780     20 248208    0    0   144  4353  305 1066 20 12
68  0
 0  0   2784 746204     20 248336    0    0   128  5388  275  966 14 11
75  0
 1  0   2784 748352     20 248468    0    0   132  5384  314 1234 22 11
67  0
 0  0   2784 748104     20 248604    0    0   136  4873  284  807 16 11
73  0


Same game on same productively used partition, but now without barriers:

shambhala:~> mount -o remount,nobarrier /home
shambhala:~> cat /proc/mounts | grep "/home "
/dev/sda5 /home xfs
rw,relatime,attr2,nobarrier,logbufs=8,logbsize=256k,noquota 0 0

shambhala:/home/martin/Linux/Dateisysteme/Performance-Messung/
compilebench/compilebench-0.6> mkdir /home/martin/Zeit/compilebench

shambhala:/home/martin/Linux/Dateisysteme/Performance-Messung/
compilebench/compilebench-0.6> ./compilebench -D
/home/martin/Zeit/compilebench -i 5 -r 10
using working directory /home/martin/Zeit/compilebench, 5 intial dirs 10
runs
native unpatched native-0 222MB in 51.44 seconds (4.32 MB/s)
native patched native-0 109MB in 12.69 seconds (8.64 MB/s)
native patched compiled native-0 691MB in 51.75 seconds (13.36 MB/s)
create dir kernel-0 222MB in 47.64 seconds (4.67 MB/s)
create dir kernel-1 222MB in 53.40 seconds (4.16 MB/s)
create dir kernel-2 222MB in 48.04 seconds (4.63 MB/s)
create dir kernel-3 222MB in 38.26 seconds (5.81 MB/s)
create dir kernel-4 222MB in 34.15 seconds (6.51 MB/s)
patch dir kernel-2 109MB in 50.61 seconds (2.17 MB/s)
compile dir kernel-2 691MB in 37.94 seconds (18.23 MB/s)
compile dir kernel-4 680MB in 45.32 seconds (15.02 MB/s)
patch dir kernel-4 691MB in 107.27 seconds (6.45 MB/s)
read dir kernel-4 in 82.18 11.16 MB/s
read dir kernel-3 in 42.35 5.25 MB/s
create dir kernel-3116 222MB in 38.27 seconds (5.81 MB/s)
clean kernel-4 691MB in 5.92 seconds (116.82 MB/s)
read dir kernel-1 in 73.63 3.02 MB/s
stat dir kernel-0 in 13.77 seconds

run complete:
========================================================================
==
intial create total runs 5 avg 5.16 MB/s (user 2.21s sys 4.23s)
create total runs 1 avg 5.81 MB/s (user 2.18s sys 4.89s)
patch total runs 2 avg 4.31 MB/s (user 0.90s sys 4.05s)
compile total runs 2 avg 16.62 MB/s (user 0.59s sys 3.05s)
clean total runs 1 avg 116.82 MB/s (user 0.09s sys 0.41s)
read tree total runs 2 avg 4.14 MB/s (user 1.90s sys 4.02s)
read compiled tree total runs 1 avg 11.16 MB/s (user 2.28s sys 6.36s)
no runs for delete tree
no runs for delete compiled tree
stat tree total runs 1 avg 13.77 seconds (user 1.19s sys 1.01s)
no runs for stat compiled tree


Not as fast as on the clean XFS LV, but still almost everytime almost
twice as fast as with barriers.


shambhala:/home/martin/Linux/Dateisysteme/Performance-Messung/
compilebench/compilebench-0.6> time rm -rf
/home/martin/Zeit/compilebench
rm -rf /home/martin/Zeit/compilebench  0,32s user 19,19s system 15% cpu
2:09,79 total

This is definately faster than before. I didn't measure exact time on
first occasion, but it took ages.

vmstat 1 during the rm -rf indicated much higher metadata throughput:

 3  0   2780 827696     20 162492    0    0   280 11109  449  865 31 15
52  2
 0  0   2780 827304     20 162816    0    0   324  6656  468 1009 57  8 
7 28
 2  0   2636 828992     20 163364    0    0   540  5317  350  545 30 10
30 31
 2  1   2636 837488     20 164020    0    0   656  7691  394  650 39 12 
0 49
 0  0   2224 960360     20 164516    0    0   496 12060  420  549 13 26
56  5
 0  0   2224 959988     20 164904    0    0   388 13704  425  792 16 23
61  0
 0  0   2224 959864     20 165128    0    0   224  6209  363  503 12 10
78  0
 1  0   2224 959376     20 165540    0    0   412 14886  392  513 12 22
66  0


Now with barriers again, but with "noop" as scheduler:

shambhala:~> mount -o remount,barrier /home
shambhala:~> cat /proc/mounts | grep /home
/dev/sda5 /home xfs rw,relatime,attr2,logbufs=8,logbsize=256k,noquota 0
0
shambhala:~> echo "noop" >/sys/block/sda/queue/scheduler
shambhala:~> cat /sys/block/sda/queue/scheduler
[noop] anticipatory deadline cfq

shambhala:/home/martin/Linux/Dateisysteme/Performance-Messung/
compilebench/compilebench-0.6> mkdir /home/martin/Zeit/compilebench

shambhala:/home/martin/Linux/Dateisysteme/Performance-Messung/
compilebench/compilebench-0.6> ./compilebench -D
/home/martin/Zeit/compilebench -i 5 -r 10
using working directory /home/martin/Zeit/compilebench, 5 intial dirs 10
runs
native unpatched native-0 222MB in 97.42 seconds (2.28 MB/s)
native patched native-0 109MB in 20.72 seconds (5.29 MB/s)
native patched compiled native-0 691MB in 46.37 seconds (14.91 MB/s)
create dir kernel-0 222MB in 84.12 seconds (2.64 MB/s)
create dir kernel-1 222MB in 95.18 seconds (2.34 MB/s)
create dir kernel-2 222MB in 74.57 seconds (2.98 MB/s)
create dir kernel-3 222MB in 71.81 seconds (3.10 MB/s)
create dir kernel-4 222MB in 64.77 seconds (3.43 MB/s)
patch dir kernel-2 109MB in 81.22 seconds (1.35 MB/s)
compile dir kernel-2 691MB in 41.87 seconds (16.52 MB/s)
compile dir kernel-4 680MB in 50.35 seconds (13.52 MB/s)
patch dir kernel-4 691MB in 151.03 seconds (4.58 MB/s)
read dir kernel-4 in 82.83 11.07 MB/s
read dir kernel-3 in 48.49 4.59 MB/s
create dir kernel-3116 222MB in 79.43 seconds (2.80 MB/s)
clean kernel-4 691MB in 15.51 seconds (44.59 MB/s)
read dir kernel-1 in 75.36 2.95 MB/s
stat dir kernel-0 in 14.65 seconds

run complete:
========================================================================
==
intial create total runs 5 avg 2.90 MB/s (user 2.35s sys 4.56s)
create total runs 1 avg 2.80 MB/s (user 2.18s sys 3.92s)
patch total runs 2 avg 2.96 MB/s (user 0.87s sys 4.07s)
compile total runs 2 avg 15.02 MB/s (user 0.60s sys 2.73s)
clean total runs 1 avg 44.59 MB/s (user 0.07s sys 0.44s)
read tree total runs 2 avg 3.77 MB/s (user 2.03s sys 3.82s)
read compiled tree total runs 1 avg 11.07 MB/s (user 2.29s sys 6.24s)
no runs for delete tree
no runs for delete compiled tree
stat tree total runs 1 avg 14.65 seconds (user 1.12s sys 1.00s)
no runs for stat compiled tree

Some tests run a bit faster, but on cost of responsiveness to out of
line I/Os (opening a new webpage in Konqueror). Some do not run faster
at all.

Seems that write barriers on/off make the bigger difference here.

As last XFS thing:

vmstat 1 during a rm -rf while switching of XFS from nobarrier to
barrier:

 0  0   1976 422236   1784 516840    0    0   508 17160  410  540  7 23
70  0
 1  0   1976 420624   1784 517576    0    0   736 26904  539 1032 14 35
51  0
 0  0   1976 419176   1784 518152    0    0   576 23842  486 1060 17 33
50  0
 0  0   1976 418316   1784 518460    0    0   308 12812  317  552  6 18
76  0
 2  0   1976 417392   1784 518776    0    0   316 16689  360  882  2 23
75  0
 8  0   1976 432948   1784 519252    0    0   476 16710  452  630  8 39
53  0
 0  0   1976 432892   1784 519392    0    0   140  4146  371 1564 14 26
60  0
 0  0   1976 432628   1784 519572    0    0   180  3844  340  660 11 10
79  0
 0  0   1976 432496   1784 519736    0    0   164  3852  328  534  9  8
83  0
 0  0   1976 432372   1784 519920    0    0   176  4100  359  788 19 11
70  0

Its obvious, where it was switched to barrier ;)



Now the other filesystems with CFQ enabled.

Ext3:

shambhala:~> echo "cfq" >/sys/block/sda/queue/scheduler
shambhala:~> cat /sys/block/sda/queue/scheduler
noop anticipatory deadline [cfq]

shambhala:/home/martin/Linux/Dateisysteme/Performance-Messung/
compilebench/compilebench-0.6> ./compilebench -D /mnt/zeit-ext3 -i 5
-r 10
using working directory /mnt/zeit-ext3, 5 intial dirs 10 runs
native unpatched native-0 222MB in 16.90 seconds (13.16 MB/s)
native patched native-0 109MB in 4.63 seconds (23.69 MB/s)
native patched compiled native-0 691MB in 39.78 seconds (17.39 MB/s)
create dir kernel-0 222MB in 12.24 seconds (18.17 MB/s)
create dir kernel-1 222MB in 16.71 seconds (13.31 MB/s)
create dir kernel-2 222MB in 18.50 seconds (12.02 MB/s)
create dir kernel-3 222MB in 18.25 seconds (12.18 MB/s)
create dir kernel-4 222MB in 27.24 seconds (8.16 MB/s)
patch dir kernel-2 109MB in 29.26 seconds (3.75 MB/s)
compile dir kernel-2 691MB in 53.41 seconds (12.95 MB/s)
compile dir kernel-4 680MB in 55.24 seconds (12.32 MB/s)
patch dir kernel-4 691MB in 108.66 seconds (6.36 MB/s)
read dir kernel-4 in 79.38 11.55 MB/s
read dir kernel-3 in 21.65 10.27 MB/s
create dir kernel-3116 222MB in 28.22 seconds (7.88 MB/s)
clean kernel-4 691MB in 17.05 seconds (40.56 MB/s)
read dir kernel-1 in 23.67 9.39 MB/s
stat dir kernel-0 in 9.63 seconds

run complete:
========================================================================
==
intial create total runs 5 avg 12.77 MB/s (user 1.96s sys 3.24s)
create total runs 1 avg 7.88 MB/s (user 1.57s sys 2.39s)
patch total runs 2 avg 5.06 MB/s (user 0.78s sys 3.92s)
compile total runs 2 avg 12.64 MB/s (user 0.54s sys 3.75s)
clean total runs 1 avg 40.56 MB/s (user 0.08s sys 0.36s)
read tree total runs 2 avg 9.83 MB/s (user 1.82s sys 4.32s)
read compiled tree total runs 1 avg 11.55 MB/s (user 2.32s sys 7.02s)
no runs for delete tree
no runs for delete compiled tree
stat tree total runs 1 avg 9.63 seconds (user 1.11s sys 0.89s)
no runs for stat compiled tree


nilfs2:

shambhala:/home/martin/Linux/Dateisysteme/Performance-Messung/
compilebench/compilebench-0.6> ./compilebench -D /mnt/zeit-nilfs2 -i 5
-r 10
using working directory /mnt/zeit-nilfs2, 5 intial dirs 10 runs
native unpatched native-0 222MB in 20.28 seconds (10.97 MB/s)
native patched native-0 109MB in 8.83 seconds (12.42 MB/s)
native patched compiled native-0 691MB in 42.44 seconds (16.30 MB/s)
create dir kernel-0 222MB in 20.89 seconds (10.65 MB/s)
create dir kernel-1 222MB in 21.13 seconds (10.52 MB/s)
create dir kernel-2 222MB in 20.22 seconds (11.00 MB/s)
create dir kernel-3 222MB in 21.60 seconds (10.30 MB/s)
create dir kernel-4 222MB in 20.63 seconds (10.78 MB/s)
patch dir kernel-2 109MB in 20.97 seconds (5.23 MB/s)
compile dir kernel-2 691MB in 44.40 seconds (15.58 MB/s)
Traceback (most recent call last):
  File "./compilebench", line 631, in <module>
    total_runs += func(dset, rnd)
  File "./compilebench", line 368, in compile_one_dir
    mbs = run_directory(ch[0], dir, "compile dir")
  File "./compilebench", line 241, in run_directory
    fp.write(buf[:cur])
IOError: [Errno 28] No space left on device


Okay, possibly due to those 11 checkpoints it stored. Seems I would need
more than 4 GB for the test to complete. But enough testing for today
;).


btrfs 0.15:

shambhala:/home/martin/Linux/Dateisysteme/Performance-Messung/
compilebench/compilebench-0.6> ./compilebench -D /mnt/zeit-btrfs -i 5
-r 10
using working directory /mnt/zeit-btrfs, 5 intial dirs 10 runs
native unpatched native-0 222MB in 13.61 seconds (16.34 MB/s)
native patched native-0 109MB in 3.12 seconds (35.15 MB/s)
native patched compiled native-0 691MB in 28.84 seconds (23.98 MB/s)
create dir kernel-0 222MB in 10.99 seconds (20.23 MB/s)
create dir kernel-1 222MB in 13.95 seconds (15.94 MB/s)
create dir kernel-2 222MB in 14.99 seconds (14.83 MB/s)
create dir kernel-3 222MB in 15.00 seconds (14.82 MB/s)
create dir kernel-4 222MB in 16.16 seconds (13.76 MB/s)
patch dir kernel-2 109MB in 30.09 seconds (3.64 MB/s)
compile dir kernel-2 691MB in 58.05 seconds (11.91 MB/s)
compile dir kernel-4 680MB in 55.23 seconds (12.32 MB/s)
patch dir kernel-4 691MB in 134.20 seconds (5.15 MB/s)
read dir kernel-4 in 108.58 8.44 MB/s
read dir kernel-3 in 43.47 5.12 MB/s
create dir kernel-3116 222MB in 27.81 seconds (8.00 MB/s)
clean kernel-4 691MB in 17.63 seconds (39.23 MB/s)
read dir kernel-1 in 70.31 3.16 MB/s
stat dir kernel-0 in 32.85 seconds

run complete:
========================================================================
==
intial create total runs 5 avg 15.92 MB/s (user 1.06s sys 5.43s)
create total runs 1 avg 8.00 MB/s (user 1.17s sys 7.41s)
patch total runs 2 avg 4.40 MB/s (user 0.88s sys 10.55s)
compile total runs 2 avg 12.12 MB/s (user 0.56s sys 5.34s)
clean total runs 1 avg 39.23 MB/s (user 0.05s sys 2.30s)
read tree total runs 2 avg 4.14 MB/s (user 1.85s sys 10.00s)
read compiled tree total runs 1 avg 8.44 MB/s (user 2.19s sys 16.50s)
no runs for delete tree
no runs for delete compiled tree
stat tree total runs 1 avg 32.85 seconds (user 1.01s sys 3.35s)
no runs for stat compiled tree




--Boundary-00=_OMYrIFmVJEzwDPr--
