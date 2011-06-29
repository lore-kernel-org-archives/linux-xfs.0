Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TCmIhj101236 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 07:48:18 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94EEB1EE0F61
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 05:48:16 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id 9mnAHhzD7CnHXWlE for
	<xfs@oss.sgi.com>; Wed, 29 Jun 2011 05:48:16 -0700 (PDT)
Date: Wed, 29 Jun 2011 14:48:14 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110629124814.GA1762@x4.trippels.de>
References: <20110621212201.GA1755@x4.trippels.de>
	<20110621185701.GB1723@x4.trippels.de>
	<20110622000449.GQ32466@dastard>
	<20110622070647.GA1744@x4.trippels.de>
	<20110622073047.GT32466@dastard> <20110629043143.GA1026@dastard>
	<20110629061954.GA1711@x4.trippels.de>
	<20110629072446.GR561@dastard>
	<20110629074127.GA1746@x4.trippels.de>
	<20110629121001.GS561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110629121001.GS561@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 2011.06.29 at 22:10 +1000, Dave Chinner wrote:
> On Wed, Jun 29, 2011 at 09:41:27AM +0200, Markus Trippelsdorf wrote:
> > On 2011.06.29 at 17:24 +1000, Dave Chinner wrote:
> > > On Wed, Jun 29, 2011 at 08:19:54AM +0200, Markus Trippelsdorf wrote:
> > > > On 2011.06.29 at 14:31 +1000, Dave Chinner wrote:
> > > > > On Wed, Jun 22, 2011 at 05:30:47PM +1000, Dave Chinner wrote:
> > > > > > Jun 22 08:53:09 x4 kernel: XFS (sdb1): ail: ooo splice, tail 0x12000156e7, item 0x12000156e6
> > > > > > Jun 22 08:53:09 x4 kernel: XFS (sdb1): ail: ooo splice, walked 15503 items      
> > > > > > .....
> > > > > > Jun 22 08:53:12 x4 kernel: XFS (sdb1): ail: ooo splice, tail 0x12000156e7, item 0x12000156e6
> > > > > > Jun 22 08:53:12 x4 kernel: XFS (sdb1): ail: ooo splice, walked 16945 items
> > > > > > 
> > > > > > Interesting is the LSN of the tail - it's only one sector further on
> > > > > > than the items being inserted. That's what I'd expect from a commit
> > > > > > record write race between two checkpoints. I'll have a deeper look
> > > > > > into whether this can be avoided later tonight and also whether I
> > > > > > can easily implement a "last insert cursor" easily so subsequent
> > > > > > inserts at the same LSN avoid the walk....
> > > > > 
> > > > > Ok, so here's a patch that does just this. I should probably also do
> > > > > a little bit of cleanup on the cursor code as well, but this avoids
> > > > > the repeated walks of the AIL to find the insert position.
> > > > > 
> > > > > Can you try it without the WQ changes you made, Marcus, and see if
> > > > > the interactivity problems go away?
> > > > 
> > > > Sorry to be the bringer of bad news, but this made things much worse:
> > > > 
> > > > -------cpu0-usage--------------cpu1-usage--------------cpu2-usage--------------cpu3-usage------ --dsk/sdc-- ---system-- ---load-avg--- --dsk/sdc--
> > > > usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq| read  writ| int   csw | 1m   5m  15m |reads writs
> > > >   1   1  98   0   0   0:  0   1  99   0   0   0:  0   1  99   0   0   0:  0   1  99   0   0   0|   0     0 | 603   380 |0.66 0.55 0.28|   0     0 
> > > >   1   0  99   0   0   0:  1   0  99   0   0   0:  1  19  80   0   0   0:  0   0 100   0   0   0|   0     0 | 719   383 |0.66 0.55 0.28|   0     0 
> > > >   3   1  96   0   0   0:  3   1  96   0   0   0:  1  52  47   0   0   0:  0   0 100   0   0   0|   0  6464k|1847   919 |0.66 0.55 0.28|   0   202 
> > > >   2  13  85   0   0   0:  2   2  96   0   0   0:  1  56  43   0   0   0:  1  31  69   0   0   0|4096B  256k|1910  1280 |0.68 0.56 0.28|   1     8 
> > > > > 0   1  99   0   0   0:  0   0 100   0   0   0:  0   1  99   0   0   0:  0 100   0   0   0   0|   0     0 |1256   170 |0.68 0.56 0.28|   0     0 
> > > > > 0   1  99   0   0   0:  1   1  98   0   0   0:  1   0  99   0   0   0:  0  99   0   0   0   1|   0     0 |1395   229 |0.68 0.56 0.28|   0     0 
> > > > > 0   0 100   0   0   0:  0   0 100   0   0   0:  0   3  97   0   0   0:  0 100   0   0   0   0|   0   512B|1304   167 |0.68 0.56 0.28|   0     1 
> > > > > 1   1  98   0   0   0:  1   1  98   0   0   0:  0   0 100   0   0   0:  0  99   0   0   0   1|   0     0 |1211   146 |0.68 0.56 0.28|   0     0 
> > > > > 0   0 100   0   0   0:  0   0 100   0   0   0:  0   1  99   0   0   0:  0  97   0   0   0   3|   0     0 |1270   149 |0.87 0.60 0.30|   0     0 
> > > >   5   2  65  29   0   0:  2   3  95   0   0   0:  1   0  99   0   0   0:  2  24  72   0   0   1|   0  8866k|2654  2398 |0.87 0.60 0.30|   0   496 
> > > >   6   2  25  67   0   0:  3   1  59  37   0   0:  0   0 100   0   0   0:  4   4  92   0   0   0|   0  4554k|2224  2494 |0.87 0.60 0.30|   0   399 
> > > >   1   1  98   0   0   0:  0   0  83  17   0   0:  1   3  96   0   0   0:  0   1  99   0   0   0|   0  2270k|1079  1030 |0.87 0.60 0.30|   0   200 
> > > >   1   1  98   0   0   0:  1   1  98   0   0   0:  0   1  99   0   0   0:  1   0  99   0   0   0|   0  9216B| 713   567 |0.87 0.60 0.30|   0     2 
> > > >   0   0 100   0   0   0:  1   1  98   0   0   0:  0   0 100   0   0   0:  0   1  99   0   0   0|   0     0 | 492   386 |0.80 0.59 0.30|   0     0 
> > > > 
> > > > As you can see in the table above (resolution 1sec) the hang is now
> > > > 5-6 seconds long, instead of the 1-3 seconds seen before.
> > > 
> > > Interesting. I checked that the ordering was correct in each case
> > > adn that it was behaving correctly here.
> > > 
> > > Can you add the following patch and send me the dmesg output over a
> > > hang? It will tell me where the cursor is being initialised and when
> > > it is being dropped, so should indicate if a specific insert chain
> > > is getting stuck or doing something stoopid.
> > 
> > The kernel log is attached.
> > rm -fr && sync starts at Jun 29 09:32:24.
> 
> Add this patch on top of the first one I sent. If it doesn't fix the
> problem, can you readd the debug patch and send the log again?

This completely fixes the issue. As a bonus "rm -fr && sync" completes
much quicker now.

Here are three different examples of the "remove kernel tree" workload:

-------cpu0-usage--------------cpu1-usage--------------cpu2-usage--------------cpu3-usage------ --dsk/sdb-- ---system-- ---load-avg--- --dsk/sdb--
usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq| read  writ| int   csw | 1m   5m  15m |reads writs

  0   0 100   0   0   0:  1   0  99   0   0   0:  0   0 100   0   0   0:  1  20  79   0   0   0|   0     0 | 761   254 |0.86 0.29 0.10|   0     0 
  9   1  90   0   0   0:  3   8  89   0   0   0:  7   5  88   0   0   0:  7  51  41   0   0   0|   0  6464k|3250  2742 |0.86 0.29 0.10|   0   202 
  1   0  99   0   0   0:  2  51  47   0   0   0:  1   1  98   0   0   0:  0   3  97   0   0   0|4096B 5856k|1895   905 |0.86 0.29 0.10|   1   177 
  5   1  94   0   0   0:  1   0  99   0   0   0:  4   0  96   0   0   0:  8   9  83   0   0   0|   0   559k|1662  1470 |0.86 0.29 0.10|   0   148 
  5   1  94   0   0   0:  1   1  98   0   0   0:  1   1  98   0   0   0:  6   5  89   0   0   0|   0     0 |1697  1568 |0.86 0.29 0.10|   0     0 

  1   1  98   0   0   0:  0   0 100   0   0   0:  0   0 100   0   0   0:  0   1  99   0   0   0|   0     0 | 741   392 |1.04 0.43 0.16|   0     0 
  9   6  85   0   0   0:  6   1  93   0   0   0:  1   1  98   0   0   0:  2  61  37   0   0   0|   0    32k|2070  1383 |0.96 0.42 0.16|   0     0 
  6   3  91   0   0   0:  3   1  95   0   0   0:  2  44  54   0   0   0:  3   4  92   0   0   0|   0  6432k|2495  1663 |0.96 0.42 0.16|   0   202 
  2   6  92   0   0   0:  2   1  97   0   0   0:  2   7  91   0   0   0:  3   8  90   0   0   0|4096B 6140k|2394  1805 |0.96 0.42 0.16|   1   258 
  4   1  95   0   0   0:  3   3  94   0   0   0:  0   0 100   0   0   0:  3   2  95   0   0   0|   0     0 |1473   730 |0.96 0.42 0.16|   0     0 

  1   1  98   0   0   0:  0   1  99   0   0   0:  1   3  96   0   0   0:  1   1  98   0   0   0|   0     0 | 926   433 |0.60 0.42 0.19|   0     0 
  5   2  93   0   0   0:  3   0  97   0   0   0:  2  60  38   0   0   0:  7   3  90   0   0   0|   0  5312k|2328  1897 |0.60 0.42 0.19|   0   161 
  2  62  36   0   0   0:  6   2  92   0   0   0:  2   0  98   0   0   0:  8   7  85   0   0   0|4096B 4000k|2439  1827 |0.60 0.42 0.19|   1   129 
  8   1  91   0   0   0:  3   1  96   0   0   0:  0   0 100   0   0   0: 12  18  69   0   0   1|   0  3293k|2568  2223 |0.63 0.43 0.20|   0   170 
  4   1  95   0   0   0:  1   2  97   0   0   0:  2   1  97   0   0   0:  6   7  87   0   0   0|   0     0 |1606  1627 |0.63 0.43 0.20|   0     0 

So many thanks Dave. Your prompt help is very much appreciated.

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
