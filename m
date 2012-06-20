Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5KCBQXV054966 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 07:11:26 -0500
Received: from blade3.isti.cnr.it (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id Vv8qwDoJZdWWD3QP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Jun 2012 05:11:24 -0700 (PDT)
Received: from [10.0.55.100] ([94.36.116.228])
	by mx.isti.cnr.it (PMDF V6.5-x6 #31988)
	with ESMTPSA id <01OGWTPV85K0OF19E8@mx.isti.cnr.it> for xfs@oss.sgi.com;
	Wed, 20 Jun 2012 14:10:55 +0200 (MEST)
Date: Wed, 20 Jun 2012 14:11:31 +0200
From: Spelic <spelic@shiftmail.org>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
In-reply-to: <20120619015745.GJ25389@dastard>
Message-id: <4FE1BDF3.4080702@shiftmail.org>
MIME-version: 1.0
References: <4FDF9EBE.2030809@shiftmail.org> <20120619015745.GJ25389@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-ext4@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, xfs@oss.sgi.com, Spelic <spelic@shiftmail.org>

Ok guys, I think I found the bug. One or more bugs.


Pool has chunksize 1MB.
In sysfs the thin volume has: queue/discard_max_bytes and 
queue/discard_granularity are 1048576 .
And it has discard_alignment = 0, which based on sysfs-block 
documentation is correct (a less misleading name would have been 
discard_offset imho).
Here is the blktrace from ext4 fstrim:
...
252,9   17      498     0.030466556   841  Q   D 19898368 + 2048 [fstrim]
252,9   17      499     0.030467501   841  Q   D 19900416 + 2048 [fstrim]
252,9   17      500     0.030468359   841  Q   D 19902464 + 2048 [fstrim]
252,9   17      501     0.030469313   841  Q   D 19904512 + 2048 [fstrim]
252,9   17      502     0.030470144   841  Q   D 19906560 + 2048 [fstrim]
252,9   17      503     0.030471381   841  Q   D 19908608 + 2048 [fstrim]
252,9   17      504     0.030472473   841  Q   D 19910656 + 2048 [fstrim]
252,9   17      505     0.030473504   841  Q   D 19912704 + 2048 [fstrim]
252,9   17      506     0.030474561   841  Q   D 19914752 + 2048 [fstrim]
252,9   17      507     0.030475571   841  Q   D 19916800 + 2048 [fstrim]
252,9   17      508     0.030476423   841  Q   D 19918848 + 2048 [fstrim]
252,9   17      509     0.030477341   841  Q   D 19920896 + 2048 [fstrim]
252,9   17      510     0.034299630   841  Q   D 19922944 + 2048 [fstrim]
252,9   17      511     0.034306880   841  Q   D 19924992 + 2048 [fstrim]
252,9   17      512     0.034307955   841  Q   D 19927040 + 2048 [fstrim]
252,9   17      513     0.034308928   841  Q   D 19929088 + 2048 [fstrim]
252,9   17      514     0.034309945   841  Q   D 19931136 + 2048 [fstrim]
252,9   17      515     0.034311007   841  Q   D 19933184 + 2048 [fstrim]
252,9   17      516     0.034312008   841  Q   D 19935232 + 2048 [fstrim]
252,9   17      517     0.034313122   841  Q   D 19937280 + 2048 [fstrim]
252,9   17      518     0.034314013   841  Q   D 19939328 + 2048 [fstrim]
252,9   17      519     0.034314940   841  Q   D 19941376 + 2048 [fstrim]
252,9   17      520     0.034315835   841  Q   D 19943424 + 2048 [fstrim]
252,9   17      521     0.034316662   841  Q   D 19945472 + 2048 [fstrim]
252,9   17      522     0.034317547   841  Q   D 19947520 + 2048 [fstrim]
...

Here is the blktrace from xfs fstrim:
252,12  16        1     0.000000000   554  Q   D 96 + 2048 [fstrim]
252,12  16        2     0.000010149   554  Q   D 2144 + 2048 [fstrim]
252,12  16        3     0.000011349   554  Q   D 4192 + 2048 [fstrim]
252,12  16        4     0.000012584   554  Q   D 6240 + 2048 [fstrim]
252,12  16        5     0.000013685   554  Q   D 8288 + 2048 [fstrim]
252,12  16        6     0.000014660   554  Q   D 10336 + 2048 [fstrim]
252,12  16        7     0.000015707   554  Q   D 12384 + 2048 [fstrim]
252,12  16        8     0.000016692   554  Q   D 14432 + 2048 [fstrim]
252,12  16        9     0.000017594   554  Q   D 16480 + 2048 [fstrim]
252,12  16       10     0.000018539   554  Q   D 18528 + 2048 [fstrim]
252,12  16       11     0.000019434   554  Q   D 20576 + 2048 [fstrim]
252,12  16       12     0.000020879   554  Q   D 22624 + 2048 [fstrim]
252,12  16       13     0.000021856   554  Q   D 24672 + 2048 [fstrim]
252,12  16       14     0.000022786   554  Q   D 26720 + 2048 [fstrim]
252,12  16       15     0.000023699   554  Q   D 28768 + 2048 [fstrim]
252,12  16       16     0.000024672   554  Q   D 30816 + 2048 [fstrim]
252,12  16       17     0.000025467   554  Q   D 32864 + 2048 [fstrim]
252,12  16       18     0.000026374   554  Q   D 34912 + 2048 [fstrim]
252,12  16       19     0.000027194   554  Q   D 36960 + 2048 [fstrim]
252,12  16       20     0.000028137   554  Q   D 39008 + 2048 [fstrim]
252,12  16       21     0.000029524   554  Q   D 41056 + 2048 [fstrim]
252,12  16       22     0.000030479   554  Q   D 43104 + 2048 [fstrim]
252,12  16       23     0.000031306   554  Q   D 45152 + 2048 [fstrim]
252,12  16       24     0.000032134   554  Q   D 47200 + 2048 [fstrim]
252,12  16       25     0.000032964   554  Q   D 49248 + 2048 [fstrim]
252,12  16       26     0.000033794   554  Q   D 51296 + 2048 [fstrim]


As you can see, while ext4 correctly aligns the discards to 1MB, xfs 
does not.
It looks like an fstrim or xfs bug: they don't look at discard_alignment 
(=0 ... a less misleading name would be discard_offset imho) + 
discard_granularity (=1MB) and they don't base alignments on those.
Clearly the dm-thin cannot unmap anything if the 1MB regions are not 
fully covered by a single discard. Note that specifying a large -m 
option for fstrim does NOT widen the discard messages above 2048, and 
this is correct because discard_max_bytes for that device is 1048576 . 
If discard_max_bytes could be made much larger these kind of bugs could 
be ameliorated, especially in complex situations like layers over 
layers, virtualization etc.

Note that also in ext4 there are parts of the discard without the 1MB 
alignment as seen with blktrace (out of my snippet), so this also might 
need to be fixed, but most of it is aligned to 1MB. In xfs there are no 
parts aligned to 1MB.


Now, another problem:
Firstly I wanted to say that in my original post I missed the 
conv=notrunc for dd: I complained about the performances because I 
expected the zerofiles would have been rewritten in-place without block 
re-provisioning by dm-thin, but clearly without conv=notrunc this was 
not happening. I confirm that with conv=notrunc performances are high at 
the first rewrite, also in ext4, and occupied space in the thin volume 
does not increase at every rewrite by dd.
HOWEVER
by NOT specifying conv=notrunc, the behaviour of dd / ext4 / dm-thin is 
different if skip_block_zeroing is specified or not. If 
skip_block_zeroing is not specified (provisioned blocks are pre-zeroed) 
the space occupied by dd truncate + rewrite INCREASES at every rewrite, 
while if skip_block_zeroing is NOT specified, dd truncate + rewrite DOES 
NOT increase space occupied on the thin volume. Note: try this on ext4, 
not xfs.
This looks very strange to me. The only reason I can think of is some 
kind of cooperative behaviour of ext4 with the variable
dm-X/queue/discard_zeroes_data
which is different in the two cases. Can anyone give an explanation or 
check if this is the intended behaviour?


And still an open question is: why the speed of provisioning new blocks 
does not increase with increasing chunk size (64K --> 1MB --> 16MB...), 
not even when skip_block_zeroing has been set and there is no CoW?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
