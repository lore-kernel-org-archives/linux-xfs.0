Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Aug 2008 23:49:31 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7M6nQWA017541
	for <linux-xfs@oss.sgi.com>; Thu, 21 Aug 2008 23:49:26 -0700
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
Date: Fri, 22 Aug 2008 08:49:37 +0200
References: <200808201613.AA00212@capsicum.lab.ntt.co.jp> <Pine.LNX.4.61.0808212031050.4532@dhcppc2> <20080822022459.GL5706@disturbed> (sfid-20080822_083254_078192_2EA5658F)
In-Reply-To: <20080822022459.GL5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808220849.38775.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: Dave Chinner <david@fromorbit.com>, Szabolcs Szakacsits <szaka@ntfs-3g.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Am Freitag 22 August 2008 schrieb Dave Chinner:
> On Thu, Aug 21, 2008 at 08:33:50PM +0300, Szabolcs Szakacsits wrote:
> > On Thu, 21 Aug 2008, Szabolcs Szakacsits wrote:
> > > On Thu, 21 Aug 2008, Dave Chinner wrote:
> > > > On Thu, Aug 21, 2008 at 04:04:18PM +1000, Dave Chinner wrote:
> > > > > One thing I just found out - my old *laptop* is 4-5x faster
> > > > > than the 10krpm scsi disk behind an old cciss raid controller. 
> > > > > I'm wondering if the long delays in dispatch is caused by an
> > > > > interaction with CTQ but I can't change it on the cciss raid
> > > > > controllers. Are you using ctq/ncq on your machine?
> > >
> > > It's a laptop and has NCQ. It makes no difference if NCQ is enabled
> > > or disabled. The problem seems to be XFS only.
> >
> > The 'nobarrier' mount option made a big improvement:
> >
> >                     MB/s    Runtime (s)
> >                    -----    -----------
> >   btrfs unstable   17.09        572
> >   ext3             13.24        877
> >   btrfs 0.16       12.33        793
> >   nilfs2 2nd+ runs 11.29        674
> >   ntfs-3g           8.55        865
> >   reiserfs          8.38        966
> >   xfs nobarrier     7.89        949
> >   nilfs2 1st run    4.95       3800
> >   xfs               1.88       3901
>
> INteresting. Barriers make only a little difference on my laptop;
> 10-20% slower. But yes, barriers will have this effect on XFS.
>
> If you've got NCQ, then you'd do better to turn off write caching
> on the drive, turn off barriers and use NCQ to give you back the
> performance that the write cache used to. That is, of course,
> assuming the NCQ implementation doesn't suck....

See my other post with performance numbers:

Barriers appear to make more than 50% difference on my laptop for some 
operations on some other operations it hardly makes a difference at all - 
I bet it goes slow mainly when creating or deleting lots of small files. 
Looking at vmstat 1 during a rm -rf of a compilebench leftover directory 
while switching off barriers shows a difference of even more than 50% in 
metadata throughput.

It has this controller

00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller 
(rev 01)

and this drive

---------------------------------------------------------------------
shambhala:~> hdparm -I /dev/sda

/dev/sda:

ATA device, with non-removable media
        Model Number:       Hitachi HTS541616J9AT00
        Serial Number:      SB0442SJDVDDHH
        Firmware Revision:  SB4OA70H
Standards:
        Used: ATA/ATAPI-7 T13 1532D revision 1
        Supported: 7 6 5 4
Configuration:
        Logical         max     current
        cylinders       16383   16383
        heads           16      16
        sectors/track   63      63
        --
        CHS current addressable sectors:   16514064
        LBA    user addressable sectors:  268435455
        LBA48  user addressable sectors:  312581808
        device size with M = 1024*1024:      152627 MBytes
        device size with M = 1000*1000:      160041 MBytes (160 GB)
Capabilities:
        LBA, IORDY(can be disabled)
        Standby timer values: spec'd by Vendor, no device specific minimum
        R/W multiple sector transfer: Max = 16  Current = 16
        Advanced power management level: 254
        Recommended acoustic management value: 128, current value: 128
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=240ns  IORDY flow control=120ns
Commands/features:
        Enabled Supported:
           *    SMART feature set
                Security Mode feature set
           *    Power Management feature set
           *    Write cache
           *    Look-ahead
           *    Host Protected Area feature set
           *    WRITE_BUFFER command
           *    READ_BUFFER command
           *    NOP cmd
           *    DOWNLOAD_MICROCODE
           *    Advanced Power Management feature set
                Power-Up In Standby feature set
           *    SET_FEATURES required to spinup after power up
                Address Offset Reserved Area Boot
           *    SET_MAX security extension
           *    Automatic Acoustic Management feature set
           *    48-bit Address feature set
           *    Device Configuration Overlay feature set
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
           *    SMART error logging
           *    SMART self-test
           *    General Purpose Logging feature set
           *    WRITE_{DMA|MULTIPLE}_FUA_EXT
           *    64-bit World wide name
           *    IDLE_IMMEDIATE with UNLOAD
Security:
        Master password revision code = 65534
                supported
        not     enabled
        not     locked
                frozen
        not     expired: security count
        not     supported: enhanced erase
        82min for SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 5000cca525da17b6
        NAA             : 5
        IEEE OUI        : cca
        Unique ID       : 525da17b6
HW reset results:
        CBLID- above Vih
        Device num = 0 determined by the jumper
---------------------------------------------------------------------

with libata driver which doesn't use FUA while its advertised above:

---------------------------------------------------------------------
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:0:0: [sda] Starting disk
---------------------------------------------------------------------

So AFAIK that should be without NCQ since its not a SATA drive and 
apparently its also without FUA (maybe due to controller?). Maybe the bad 
results are due to lack of NCQ and FUA?

Here the relevant parts from my other mail:

---------------------------------------------------------------------
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

[...]

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
---------------------------------------------------------------------

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
