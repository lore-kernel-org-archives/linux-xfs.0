Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 20:10:37 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8L3ASgf010453
	for <linux-xfs@oss.sgi.com>; Thu, 20 Sep 2007 20:10:33 -0700
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1IYYuV-0005FP-1W
	for linux-xfs@oss.sgi.com; Thu, 20 Sep 2007 20:10:31 -0700
Message-ID: <12809900.post@talk.nabble.com>
Date: Thu, 20 Sep 2007 20:10:31 -0700 (PDT)
From: Hxsrmeng <hxsrmeng@gmail.com>
Subject: Questions about testing the Filestream feature
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hi all,

I need to use the "Filestreams" feature. I wrote a script to write files to
two directories concurrently.  When I check the file bitmap, I found
sometimes the files written in the different directories still interleave
extents on disk. I don't know whether there is something wrong with my
script, or, I misunderstand something.

I am using Opensuse10.2, the kernel is linux-2.6.23-rc4 (source code was
check out from cvs of oss.sgi.com). The filestreams feature is enabled with
a "-o filestreams" mount option.
Here is my script: 
"
  1 #try filestreams
  2 a=$1
  3 filenumber=`expr $a - 1`
  4 filesize=$2
  5
  6 umount /xfs_disk
  7 /sbin/mkfs -t xfs -f /dev/hda5 #>> logfile
  8 mount -t xfs -o filestreams /dev/hda5 /xfs_disk
  9 #enable filestreams
 10
 11 cd /xfs_disk
 12 for dirname in dira dirb
 13     do
 14     mkdir $dirname
 15     for filename in `seq 0 $filenumber`
 16         do
 17         dd if=/dev/zero of=$dirname/$filename bs=$filesize count=1 >
/dev/null 2>&1 &
 18     done
 19 done
 20
 21 wait
 22 for dirname in dira dirb
 23     do
 24     for filename in `seq 0 $filenumber`
 25         do
 26         /usr/sbin/xfs_bmap -v $dirname/$filename > bmapresult
 27         cat bmapresult >> bitmap
 28         a="expr `wc -l bmapresult | awk '{print $1}'` - 2"
 29         b=`$a`
 30         c=`tail -$b bmapresult | awk '{ print $4 }'`
 31         echo $dirname/$filename is in AG $c:>>agmap
 32     done
 33 done
"

Then I got the information of my xfs device first :  
meta-data=/dev/hda5              isize=256      agcount=8, agsize=159895
blks
              =                             sectsz=512   attr=0
data        =                             bsize=4096   blocks=1279160,
imaxpct=25
              =                             sunit=0         swidth=0 blks,
unwritten=1
naming    =                             version 2      bsize=4096
log          =                             internal log    bsize=4096  
blocks=2560, version=1
              =                             sectsz=512   sunit=0 blks
realtime   =                             none            extsz=65536 
blocks=0, rtextents=0


First run, I wrote 3 "big" files, which are 768M, to each directories. The
files in directory dira share AG 0,2,5,7 and files in directory dirb share
AG 1, 3, 4, 6,  which I assume should be correct. But the files extents
doesn't use contiguous blocks, and all files in the same directory put some
of their extents in AG 0. I am not sure whether this is correct.  Here is
part of file bitmap:
"
dira/0:
 EXT: FILE-OFFSET         BLOCK-RANGE      AG AG-OFFSET          TOTAL
   0: [0..7615]:          96..7711          0 (96..7711)          7616
   1: [7616..7679]:       33312..33375      0 (33312..33375)        64
   2: [7680..24063]:      33448..49831      0 (33448..49831)     16384
   3: [24064..52999]:     60608..89543      0 (60608..89543)     28936
   4: [53000..61191]:     95496..103687     0 (95496..103687)     8192
   5: [61192..90791]:     119088..148687    0 (119088..148687)   29600
   6: [90792..131751]:    170264..211223    0 (170264..211223)   40960
   7: [131752..144223]:   219480..231951    0 (219480..231951)   12472
   8: [144224..168799]:   240144..264719    0 (240144..264719)   24576
   ...
dira/1:
 EXT: FILE-OFFSET         BLOCK-RANGE      AG AG-OFFSET           TOTAL
   0: [0..12791]:         7712..20503       0 (7712..20503)       12792
   1: [12792..12863]:     33376..33447      0 (33376..33447)         72
   2: [12864..13391]:     49832..50359      0 (49832..50359)        528
   3: [13392..19575]:     112904..119087    0 (112904..119087)     6184
   4: [19576..27767]:     148688..156879    0 (148688..156879)     8192
   5: [27768..35959]:     211224..219415    0 (211224..219415)     8192
   6: [35960..44151]:     231952..240143    0 (231952..240143)     8192
   7: [44152..68727]:     264784..289359    0 (264784..289359)    24576
   8: [68728..79047]:     309400..319719    0 (309400..319719)    10320
"

Second run, I wrote 1024 "small" files, which are 1M, to each directories. 
Files in directory dira use AG 0,1,3 and files in directory b use AG
2,1,5,6,7,4. So files written in directory dirb use the allocation group 1,
which should be reserved for directory dira . And, sometimes even one file
is written to two AGs. The following is part of file bitmap:
"
 ...
dira/498:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..63]:         570848..570911    0 (570848..570911)    64
   1: [64..2047]:      1666600..1668583  1 (387440..389423)  1984
dira/499:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..23]:         571672..571695    0 (571672..571695)    24
   1: [24..79]:        571776..571831    0 (571776..571831)    56
   2: [80..1839]:      1650616..1652375  1 (371456..373215)  1760
   3: [1840..1903]:    1662240..1662303  1 (383080..383143)    64
   4: [1904..2047]:    1676984..1677127  1 (397824..397967)   144
 ...
dirb/4:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..2047]:       1279264..1281311  1 (104..2151)       2048
dirb/5:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..63]:         1352136..1352199  1 (72976..73039)      64
   1: [64..415]:       1451896..1452247  1 (172736..173087)   352
   2: [416..1279]:     1633616..1634479  1 (354456..355319)   864
   3: [1280..1343]:    1647288..1647351  1 (368128..368191)    64
   4: [1344..2047]:    1677128..1677831  1 (397968..398671)   704
dirb/6:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..2047]:       1285408..1287455  1 (6248..8295)      2048
....
"
I don't know whether the filestreams feature may works this way, or I made
some mistakes?

Thank you so much!
-- 
View this message in context: http://www.nabble.com/Questions-about-testing-the-Filestream-feature-tf4491605.html#a12809900
Sent from the linux-xfs mailing list archive at Nabble.com.
