Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5K63teW120716 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 01:03:55 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E32F6172CF95
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 23:03:53 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id AwQOvA6BXKVbyTBC for
	<xfs@oss.sgi.com>; Sun, 19 Jun 2011 23:03:53 -0700 (PDT)
Date: Mon, 20 Jun 2011 08:03:51 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110620060351.GC1730@x4.trippels.de>
References: <20110618141950.GA1685@x4.trippels.de>
	<20110619222447.GI561@dastard>
	<20110620005415.GA1730@x4.trippels.de>
	<20110620013449.GO561@dastard>
	<20110620020236.GB1730@x4.trippels.de>
	<20110620023625.GP561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110620023625.GP561@dastard>
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

On 2011.06.20 at 12:36 +1000, Dave Chinner wrote:
> On Mon, Jun 20, 2011 at 04:02:36AM +0200, Markus Trippelsdorf wrote:
> > On 2011.06.20 at 11:34 +1000, Dave Chinner wrote:
> > > On Mon, Jun 20, 2011 at 02:54:15AM +0200, Markus Trippelsdorf wrote:
> > > > On 2011.06.20 at 08:24 +1000, Dave Chinner wrote:
> > > > > On Sat, Jun 18, 2011 at 04:19:50PM +0200, Markus Trippelsdorf wro=
te:
> > > > > > Running the latest git kernel (3.0-rc3) my machine hangs for lo=
ng
> > > > > > periods (1-2 sec) whenever I delete a large directory recursive=
ly on my
> > > > > > xfs partition. During the hang I cannot move the mouse pointer =
or use
> > > > > > the keyboard (but the music keeps playing without stuttering). =
A quick
> > > > > > way to reproduce is to "rm -fr" a kernel tree. =

> > > > > =

> > > > > So what is the system doing when it "hangs"? Is it CPU bound (e.g.
> > > > > cpu scheduler issue)? Is the system running out of memory and
> > > > > stalling everything in memory reclaim? What IO is occurring?
> > > > =

> > > > It's totally idle otherwise; just a desktop with a single xterm. The
> > > > machine has four cores (and also runs with "CONFIG_PREEMPT=3Dy"), s=
o I
> > > > don't think it is CPU bound at all. It has 8GB of memory (and the
> > > > "hangs" even occur after reboot when most of it is free). No other =
IO
> > > > activity is occurring.
> > > =

> > > Sure, the system might be otherwise idle, but what I was asking is
> > > what load does the "rm -rf" cause. What IO does it cause? is it cpu
> > > bound? etc.
> > =

> > I have not measured this, so I cannot tell.
> =

> And so you are speculating as to the cause of the problem. What I'm
> trying to do is work from the bottom up to ensure that the layers
> below the fs are not the cause of the problem.
> =

> > > > > Is your partition correctly sector aligned for however your drive
> > > > > maps it's 4k sectors?
> > > > =

> > > > Yes, it's a GPT partition that is aligned to 1MB.
> > > =

> > > Ok, that is fine, but the big question now is how does the drive
> > > align sector 0? Is that 4k aligned, or is it one of those drives
> > > that aligns an odd 512 byte logical sector to the physical 4k sector
> > > boundary (i.e. sector 63 is 4k aligned to work with msdos
> > > partitions). FYI, some drives have jumpers on them to change this
> > > odd/even sector alignment configuration.....
> > =

> > No, it's none of those (it's a Seagate Barracuda Green ST1500). Sector 0
> > is 4k aligned for sure. The odd 512 byte offset was present only on some
> > first generation drives. =

> > But I think the whole alignment issue is a red herring, because I cannot
> > reproduce the "hangs" on the next partition on the same drive. This
> > partition is larger and contains my music and film collection (so mostly
> > static content and no traffic).
> =

> Which also means you might have one unaligned and one aligned
> partition.  i.e. the test results you have presented does not
> necessarily point at a filesystem problem. We always ask for exact
> details of your storage subsystem for these reasons - so we can
> understand if there's something that you missed or didn't think was
> important enough to tell us. You may have already checked those
> things, but we don't know that if you don't tell us....

Understood.

> So, is the sector alignment of the second partition the same as the
> first partition?

Yes.

> > And as I wrote in my other reply to this
> > thread: =BBit appears that the observed "hangs" are the result of a
> > strongly aged file-system.=AB
> =

> There is no evidence that points to any cause. Hell, I don't even
> know what you consider a "strongly aged filesystem" looks like....
> =

> If the alignment is the cause of the problem, you should be able to
> see a difference in performance when doing random 4k synchronous
> writes to a large file on differently aligned partitions. Can you
> run the same random 4k sync write test on both partitions (make sure
> barriers are enabled) and determine if they perform the same?
> =

> If the filesystem layout is the cause of the problem, you should be
> able to take a metadump of the problematic filesystem, restore it to
> a normal 512 sector drive and reproduce the "rm -rf" problem. Can
> you try this as well?

OK. I was able to reproduce the same hang on a conventional 512 sector driv=
e.
The partition that I've used was the predecessor to the one on the 4k drive=
. So
it saw roughly the same usage pattern.
This is the output of "dstat -cdyl -C 0,1,2,3 -D sdc --disk-tps" during the
hang:

-------cpu0-usage--------------cpu1-usage--------------cpu2-usage----------=
----cpu3-usage------ --dsk/sdc-- ---system-- ---load-avg--- --dsk/sdc--
usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr=
 sys idl wai hiq siq| read  writ| int   csw | 1m   5m  15m |reads writs

  0   0 100   0   0   0:  1   0  99   0   0   0:  0   1  99   0   0   0:  1=
   0  99   0   0   0|   0     0 | 249   354 |0.33 0.58 0.38|   0     0 =

  0   0 100   0   0   0:  0   0 100   0   0   0:  0   0 100   0   0   0:  0=
   0 100   0   0   0|   0     0 | 244   228 |0.33 0.58 0.38|   0     0 =

  1   2  97   0   0   0:  0   1  99   0   0   0:  0   1  99   0   0   0:  0=
   1  99   0   0   0|   0     0 | 559   614 |0.33 0.58 0.38|   0     0 =

  0   0 100   0   0   0:  1   0  99   0   0   0:  1   0  99   0   0   0:  1=
   0  99   0   0   0|   0     0 | 341   426 |0.33 0.58 0.38|   0     0 =

  1   0  99   0   0   0:  1   4  95   0   0   0:  0   1  99   0   0   0:  1=
  16  83   0   0   0|   0     0 | 874   796 |0.33 0.58 0.38|   0     0 =

  2  50  49   0   0   0:  1   9  90   0   0   0:  1   9  90   0   0   0:  1=
  23  76   0   0   0|   0  6400k|2803  2073 |0.46 0.60 0.39|   0    25 =

  1  29  70   0   0   0:  1   1  98   0   0   0:  1   9  90   0   0   0:  1=
  53  46   0   0   0|   0  6400k|2047  1414 |0.46 0.60 0.39|   0    25 =

  0   4  96   0   0   0:  0   0 100   0   0   0:  1  19  80   0   0   0:  0=
  80  20   0   0   0|   0  2048k|1425   685 |0.46 0.60 0.39|   0     8 =

  2   1  97   0   0   0:  1   6  93   0   0   0:  0   5  95   0   0   0:  0=
  83  17   0   0   0|   0  4608k|1624   849 |0.46 0.60 0.39|   0    18 =

  2  45  53   0   0   0:  1  16  83   0   0   0:  3  20  77   0   0   0:  1=
  15  84   0   0   0|   0  6400k|2420  1984 |0.46 0.60 0.39|   0    26 =

  1  19  80   0   0   0:  2   8  90   0   0   0:  0  33  67   0   0   0:  0=
  33  67   0   0   0|   0  6400k|2694  2134 |0.59 0.63 0.40|   0    25 =

  2   7  91   0   0   0:  2   1  97   0   0   0:  1   0  99   0   0   0:  0=
  49  10  41   0   0|   0  8269k|1865  1571 |0.59 0.63 0.40|   0   363 =

  1   1  98   0   0   0:  1   1  98   0   0   0:  1   1  98   0   0   0:  0=
   1   0  99   0   0|   0  4778k|1509  1639 |0.59 0.63 0.40|   0   410 =

  2   0  98   0   0   0:  2   1  97   0   0   0:  1   1  98   0   0   0:  2=
   0   0  98   0   0|   0  5318k|1663  1809 |0.59 0.63 0.40|   0   426 =

  1   1  98   0   0   0:  2   7  91   0   0   0:  1   0  99   0   0   0:  1=
   0   0  99   0   0|   0  5446k|1659  1806 |0.59 0.63 0.40|   0   432 =

  0   1  99   0   0   0:  1   0  99   0   0   0:  2   0  98   0   0   0:  0=
   1  17  82   0   0|   0  5472k|1572  1837 |0.62 0.63 0.40|   0   439 =

  2   0  98   0   0   0:  2   2  96   0   0   0:  0   1  99   0   0   0:  0=
   1  99   0   0   0|   0   397k|1058  1049 |0.62 0.63 0.40|   0    36 =

  1   1  98   0   0   0:  1   1  98   0   0   0:  1   1  98   0   0   0:  0=
   0 100   0   0   0|   0     0 | 617   689 |0.62 0.63 0.40|   0     0 =

  9   4  87   0   0   0:  4   0  96   0   0   0:  1   1  98   0   0   0:  8=
   6  87   0   0   0|   0     0 |1234  1961 |0.62 0.63 0.40|   0     0 =

  0   1  99   0   0   0:  1   1  98   0   0   0:  0   1  99   0   0   0:  0=
   1  99   0   0   0|   0     0 | 391   403 |0.62 0.63 0.40|   0     0 =

  1   0  99   0   0   0:  1   1  98   0   0   0:  0   0 100   0   0   0:  0=
   0 100   0   0   0|   0     0 | 366   375 |0.57 0.62 0.40|   0     0 =




-- =

Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
