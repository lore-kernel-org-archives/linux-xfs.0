Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5KBE3IV141338 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 06:14:03 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AF1F172E722
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 04:14:01 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id pWzsD2c0MFuiaND2 for
	<xfs@oss.sgi.com>; Mon, 20 Jun 2011 04:14:01 -0700 (PDT)
Date: Mon, 20 Jun 2011 13:13:59 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110620111359.GA12632@x4.trippels.de>
References: <20110618141950.GA1685@x4.trippels.de>
	<20110619222447.GI561@dastard>
	<20110620005415.GA1730@x4.trippels.de>
	<20110620013449.GO561@dastard>
	<20110620020236.GB1730@x4.trippels.de>
	<20110620023625.GP561@dastard>
	<20110620060351.GC1730@x4.trippels.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110620060351.GC1730@x4.trippels.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 2011.06.20 at 08:03 +0200, Markus Trippelsdorf wrote:
> On 2011.06.20 at 12:36 +1000, Dave Chinner wrote:
> > On Mon, Jun 20, 2011 at 04:02:36AM +0200, Markus Trippelsdorf wrote:
> > > On 2011.06.20 at 11:34 +1000, Dave Chinner wrote:
> > > > On Mon, Jun 20, 2011 at 02:54:15AM +0200, Markus Trippelsdorf wrote:
> > > > > On 2011.06.20 at 08:24 +1000, Dave Chinner wrote:
> > > > > > On Sat, Jun 18, 2011 at 04:19:50PM +0200, Markus Trippelsdorf w=
rote:
> > > > > > > Running the latest git kernel (3.0-rc3) my machine hangs for =
long
> > > > > > > periods (1-2 sec) whenever I delete a large directory recursi=
vely on my
> > > > > > > xfs partition. During the hang I cannot move the mouse pointe=
r or use
> > > > > > > the keyboard (but the music keeps playing without stuttering)=
. A quick
> > > > > > > way to reproduce is to "rm -fr" a kernel tree. =

> > > > > > =

> > > > > > So what is the system doing when it "hangs"? Is it CPU bound (e=
.g.
> > > > > > cpu scheduler issue)? Is the system running out of memory and
> > > > > > stalling everything in memory reclaim? What IO is occurring?
> > > > > =

> > > > > It's totally idle otherwise; just a desktop with a single xterm. =
The
> > > > > machine has four cores (and also runs with "CONFIG_PREEMPT=3Dy"),=
 so I
> > > > > don't think it is CPU bound at all. It has 8GB of memory (and the
> > > > > "hangs" even occur after reboot when most of it is free). No othe=
r IO
> > > > > activity is occurring.
> > > > =

> > > > Sure, the system might be otherwise idle, but what I was asking is
> > > > what load does the "rm -rf" cause. What IO does it cause? is it cpu
> > > > bound? etc.
> > > =

> > > I have not measured this, so I cannot tell.
> > =

> > And so you are speculating as to the cause of the problem. What I'm
> > trying to do is work from the bottom up to ensure that the layers
> > below the fs are not the cause of the problem.
> > =

> > > > > > Is your partition correctly sector aligned for however your dri=
ve
> > > > > > maps it's 4k sectors?
> > > > > =

> > > > > Yes, it's a GPT partition that is aligned to 1MB.
> > > > =

> > > > Ok, that is fine, but the big question now is how does the drive
> > > > align sector 0? Is that 4k aligned, or is it one of those drives
> > > > that aligns an odd 512 byte logical sector to the physical 4k sector
> > > > boundary (i.e. sector 63 is 4k aligned to work with msdos
> > > > partitions). FYI, some drives have jumpers on them to change this
> > > > odd/even sector alignment configuration.....
> > > =

> > > No, it's none of those (it's a Seagate Barracuda Green ST1500). Secto=
r 0
> > > is 4k aligned for sure. The odd 512 byte offset was present only on s=
ome
> > > first generation drives. =

> > > But I think the whole alignment issue is a red herring, because I can=
not
> > > reproduce the "hangs" on the next partition on the same drive. This
> > > partition is larger and contains my music and film collection (so mos=
tly
> > > static content and no traffic).
> > =

> > Which also means you might have one unaligned and one aligned
> > partition.  i.e. the test results you have presented does not
> > necessarily point at a filesystem problem. We always ask for exact
> > details of your storage subsystem for these reasons - so we can
> > understand if there's something that you missed or didn't think was
> > important enough to tell us. You may have already checked those
> > things, but we don't know that if you don't tell us....
> =

> Understood.
> =

> > So, is the sector alignment of the second partition the same as the
> > first partition?
> =

> Yes.
> =

> > > And as I wrote in my other reply to this
> > > thread: =BBit appears that the observed "hangs" are the result of a
> > > strongly aged file-system.=AB
> > =

> > There is no evidence that points to any cause. Hell, I don't even
> > know what you consider a "strongly aged filesystem" looks like....
> > =

> > If the alignment is the cause of the problem, you should be able to
> > see a difference in performance when doing random 4k synchronous
> > writes to a large file on differently aligned partitions. Can you
> > run the same random 4k sync write test on both partitions (make sure
> > barriers are enabled) and determine if they perform the same?
> > =

> > If the filesystem layout is the cause of the problem, you should be
> > able to take a metadump of the problematic filesystem, restore it to
> > a normal 512 sector drive and reproduce the "rm -rf" problem. Can
> > you try this as well?
> =

> OK. I was able to reproduce the same hang on a conventional 512 sector dr=
ive.
> The partition that I've used was the predecessor to the one on the 4k dri=
ve. So
> it saw roughly the same usage pattern.
> This is the output of "dstat -cdyl -C 0,1,2,3 -D sdc --disk-tps" during t=
he
> hang:
> =

> -------cpu0-usage--------------cpu1-usage--------------cpu2-usage--------=
------cpu3-usage------ --dsk/sdc-- ---system-- ---load-avg--- --dsk/sdc--
> usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq:u=
sr sys idl wai hiq siq| read  writ| int   csw | 1m   5m  15m |reads writs
> =

>   0   0 100   0   0   0:  1   0  99   0   0   0:  0   1  99   0   0   0: =
 1   0  99   0   0   0|   0     0 | 249   354 |0.33 0.58 0.38|   0     0 =

>   0   0 100   0   0   0:  0   0 100   0   0   0:  0   0 100   0   0   0: =
 0   0 100   0   0   0|   0     0 | 244   228 |0.33 0.58 0.38|   0     0 =

>   1   2  97   0   0   0:  0   1  99   0   0   0:  0   1  99   0   0   0: =
 0   1  99   0   0   0|   0     0 | 559   614 |0.33 0.58 0.38|   0     0 =

>   0   0 100   0   0   0:  1   0  99   0   0   0:  1   0  99   0   0   0: =
 1   0  99   0   0   0|   0     0 | 341   426 |0.33 0.58 0.38|   0     0 =

>   1   0  99   0   0   0:  1   4  95   0   0   0:  0   1  99   0   0   0: =
 1  16  83   0   0   0|   0     0 | 874   796 |0.33 0.58 0.38|   0     0 =

>   2  50  49   0   0   0:  1   9  90   0   0   0:  1   9  90   0   0   0: =
 1  23  76   0   0   0|   0  6400k|2803  2073 |0.46 0.60 0.39|   0    25 =

>   1  29  70   0   0   0:  1   1  98   0   0   0:  1   9  90   0   0   0: =
 1  53  46   0   0   0|   0  6400k|2047  1414 |0.46 0.60 0.39|   0    25 =

>   0   4  96   0   0   0:  0   0 100   0   0   0:  1  19  80   0   0   0: =
 0  80  20   0   0   0|   0  2048k|1425   685 |0.46 0.60 0.39|   0     8 =

>   2   1  97   0   0   0:  1   6  93   0   0   0:  0   5  95   0   0   0: =
 0  83  17   0   0   0|   0  4608k|1624   849 |0.46 0.60 0.39|   0    18 =

>   2  45  53   0   0   0:  1  16  83   0   0   0:  3  20  77   0   0   0: =
 1  15  84   0   0   0|   0  6400k|2420  1984 |0.46 0.60 0.39|   0    26 =

>   1  19  80   0   0   0:  2   8  90   0   0   0:  0  33  67   0   0   0: =
 0  33  67   0   0   0|   0  6400k|2694  2134 |0.59 0.63 0.40|   0    25 =

>   2   7  91   0   0   0:  2   1  97   0   0   0:  1   0  99   0   0   0: =
 0  49  10  41   0   0|   0  8269k|1865  1571 |0.59 0.63 0.40|   0   363 =

>   1   1  98   0   0   0:  1   1  98   0   0   0:  1   1  98   0   0   0: =
 0   1   0  99   0   0|   0  4778k|1509  1639 |0.59 0.63 0.40|   0   410 =

>   2   0  98   0   0   0:  2   1  97   0   0   0:  1   1  98   0   0   0: =
 2   0   0  98   0   0|   0  5318k|1663  1809 |0.59 0.63 0.40|   0   426 =

>   1   1  98   0   0   0:  2   7  91   0   0   0:  1   0  99   0   0   0: =
 1   0   0  99   0   0|   0  5446k|1659  1806 |0.59 0.63 0.40|   0   432 =

>   0   1  99   0   0   0:  1   0  99   0   0   0:  2   0  98   0   0   0: =
 0   1  17  82   0   0|   0  5472k|1572  1837 |0.62 0.63 0.40|   0   439 =

>   2   0  98   0   0   0:  2   2  96   0   0   0:  0   1  99   0   0   0: =
 0   1  99   0   0   0|   0   397k|1058  1049 |0.62 0.63 0.40|   0    36 =

>   1   1  98   0   0   0:  1   1  98   0   0   0:  1   1  98   0   0   0: =
 0   0 100   0   0   0|   0     0 | 617   689 |0.62 0.63 0.40|   0     0 =

>   9   4  87   0   0   0:  4   0  96   0   0   0:  1   1  98   0   0   0: =
 8   6  87   0   0   0|   0     0 |1234  1961 |0.62 0.63 0.40|   0     0 =

>   0   1  99   0   0   0:  1   1  98   0   0   0:  0   1  99   0   0   0: =
 0   1  99   0   0   0|   0     0 | 391   403 |0.62 0.63 0.40|   0     0 =

>   1   0  99   0   0   0:  1   1  98   0   0   0:  0   0 100   0   0   0: =
 0   0 100   0   0   0|   0     0 | 366   375 |0.57 0.62 0.40|   0     0 =

> =


Here are two more examples. The time when the hang occurs is marked with
"=3D>":
------cpu0-usage--------------cpu1-usage--------------cpu2-usage-----------=
---cpu3-usage------ --dsk/sdb-- ---system-- ---load-avg--- --dsk/sdb--
usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr=
 sys idl wai hiq siq| read  writ| int   csw | 1m   5m  15m |reads writs
  0   0 100   0   0   0:  1   1  98   0   0   0:  1   0  99   0   0   0:  0=
   1  99   0   0   0|   0     0 | 411   498 |1.14 0.58 0.27|   0     0 =

  1   1  98   0   0   0:  0   1  99   0   0   0:  0   1  99   0   0   0:  0=
   0 100   0   0   0|   0     0 | 580   649 |1.05 0.57 0.27|   0     0 =

  0   1  99   0   0   0:  0   0 100   0   0   0:  0   0 100   0   0   0:  1=
   0  99   0   0   0|   0     0 | 297   353 |1.05 0.57 0.27|   0     0 =

  1   0  99   0   0   0:  0   1  99   0   0   0:  0   1  99   0   0   0:  0=
   1  99   0   0   0|   0     0 | 322   393 |1.05 0.57 0.27|   0     0 =

  0   0 100   0   0   0:  1   0  99   0   0   0:  1   0  99   0   0   0:  0=
   1  99   0   0   0|   0     0 | 301   382 |1.05 0.57 0.27|   0     0 =

  1  16  83   0   0   0:  1  21  78   0   0   0:  0  13  87   0   0   0:  1=
  13  87   0   0   0|   0  2016k|2169  1495 |1.05 0.57 0.27|   0    57 =

  1  10  89   0   0   0:  2  38  61   0   0   0:  1   8  81  10   0   0:  0=
  64  36   0   0   0|   0  4476k|2378  2010 |1.12 0.59 0.28|   0   146 =

=3D>0   0 100   0   0   0:  0   1  99   0   0   0:  0   1   0  99   0   0: =
 0 100   0   0   0   0|   0     0 |1237   283 |1.12 0.59 0.28|   0     0 =

  0  27  73   0   0   0:  1   0  99   0   0   0:  0   0  47  53   0   0:  0=
  56  44   0   0   0|   0  5812k|1596   857 |1.12 0.59 0.28|   0   182 =

  1   5  35  59   0   0:  2   0  85  13   0   0:  1   0  99   0   0   0:  0=
   7  28  65   0   0|   0  6263k|1789  1835 |1.12 0.59 0.28|   0   555 =

  1   0  99   0   0   0:  0   1  99   0   0   0:  1   0  99   0   0   0:  0=
   4   6  90   0   0|   0  2664k|1074  1155 |1.12 0.59 0.28|   0   286 =

  4   1  95   0   0   0:  4   2  94   0   0   0:  2   1  97   0   0   0:  6=
   4  91   0   0   0|   0  1189k|1628  2106 |1.11 0.60 0.28|   0   137 =

  1   0  99   0   0   0:  0   1  99   0   0   0:  0   1  99   0   0   0:  0=
   1  99   0   0   0|   0  1024B| 491   438 |1.11 0.60 0.28|   0     1 =

  1   1  98   0   0   0:  2   0  98   0   0   0:  1   0  99   0   0   0:  0=
   0 100   0   0   0|   0     0 | 583   524 |1.11 0.60 0.28|   0     0 =

  5   1  94   0   0   0:  1   1  98   0   0   0:  0   1  99   0   0   0:  7=
   7  87   0   0   0|   0     0 |1148  1823 |1.11 0.60 0.28|   0     0

  5   3  92   0   0   0:  4   1  95   0   0   0:  2   0  98   0   0   0:  5=
   2  93   0   0   0|   0     0 |1374  1678 |0.70 0.65 0.40|   0     0 =

  2   2  96   0   0   0:  1   1  98   0   0   0:  0   0 100   0   0   0:  1=
   0  99   0   0   0|   0     0 | 913   635 |0.70 0.65 0.40|   0     0 =

  0   3  97   0   0   0:  1   0  99   0   0   0:  1   1  98   0   0   0:  1=
   5  94   0   0   0|   0   512B| 898   697 |0.70 0.65 0.40|   0     1 =

  7  41  52   0   0   0:  2  11  87   0   0   0:  5   6  89   0   0   0:  3=
   1  96   0   0   0|   0  5856k|2771  2751 |0.70 0.65 0.40|   0   177 =

  7  26  67   0   0   0:  4   1  95   0   0   0:  1  37  62   0   0   0:  3=
  38  59   0   0   0|   0   864k|2904  2806 |0.70 0.65 0.40|   0    33 =

=3D>2   1  97   0   0   0:  1   0  99   0   0   0:  0   1  99   0   0   0: =
 0 100   0   0   0   0|   0     0 |1725   639 |0.89 0.69 0.41|   0     0 =

  1   1  98   0   0   0:  2   1  97   0   0   0:  2   1  97   0   0   0:  0=
  71  29   0   0   0|   0  3968k|1793   852 |0.89 0.69 0.41|   0   123 =

  4   1  95   0   0   0:  3  48  49   0   0   0:  4  18  78   0   0   0:  5=
   6  89   0   0   0|   0  5120k|2920  3050 |0.89 0.69 0.41|   0   159 =

  3  54  43   0   0   0:  1   8  91   0   0   0:  1   4  95   0   0   0:  1=
   5  94   0   0   0|4096B 4160k|2705  1936 |0.89 0.69 0.41|   1   132 =

  1  40  59   0   0   0:  1   3  96   0   0   0:  1  13  86   0   0   0:  1=
   1  98   0   0   0|   0  5984k|2312  1568 |0.89 0.69 0.41|   0   187 =

  1  23  76   0   0   0:  0   5  95   0   0   0:  1  16  83   0   0   0:  1=
  13  86   0   0   0|   0  6976k|2310  1751 |0.90 0.70 0.41|   0   213 =

  0   1  31  68   0   0:  0  20  80   0   0   0:  0  19  36  45   0   0:  1=
  22  76   0   0   1|   0  8645k|2364  1773 |0.90 0.70 0.41|   0   578 =

  1   0  98   1   0   0:  1   3  96   0   0   0:  1   1  28  70   0   0:  1=
   3  96   0   0   0|   0  4506k|1520  1358 |0.90 0.70 0.41|   0   374 =

  2   2  96   0   0   0:  2   1  97   0   0   0:  0   0 100   0   0   0:  0=
   6  94   0   0   0|   0   504k| 877   726 |0.90 0.70 0.41|   0    92 =

  1   1  98   0   0   0:  1   1  98   0   0   0:  1   0  99   0   0   0:  2=
   0  98   0   0   0|   0    78k| 907   753 |0.90 0.70 0.41|   0    17 =

  1   3  96   0   0   0:  2   1  97   0   0   0:  0   1  99   0   0   0:  1=
   1  98   0   0   0|   0     0 | 894   710 |0.83 0.69 0.41|   0     0 =

  2   0  98   0   0   0:  2   0  98   0   0   0:  1   0  99   0   0   0:  1=
   0  99   0   0   0|   0     0 | 901   682 |0.83 0.69 0.41|   0     0 =


-- =

Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
