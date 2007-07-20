Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Jul 2007 06:58:55 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6KDwobm026744
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2007 06:58:52 -0700
Date: Fri, 20 Jul 2007 09:58:50 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Software RAID 5 - Two reads are faster than one on a SW RAID5?
Message-ID: <Pine.LNX.4.64.0707200952270.25069@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com, apiszcz@solarrain.com

I have a multi-core Q6600 CPU on a 10-disk Raptor RAID 5 running XFS.

I just pulled down the Debian Etch 4.0 DVD ISO's, one for x86 and one for 
x86_64, when I ran md5sum -c MD5SUMS, I see ~280-320MB/s.  When I ran the 
second one I see upwards of what I should be seeing 500-520MB/s.

NOTE:: These MD5 contain the 3 DVD ISO's for each platform, 6 total ISOs.

I know md5sum is cpubound to a degree, do you think that is what is 
happening here?  Each core can only sustain ~300MB/s and then with two of 
four cores working, it can exceed that amount or is there some similarity 
with RAID1 in linux compared to RAID5?

With RAID1, if you use a single read thread, you will get 60-70MB/s read 
on a dual raptor raid1.  If you use two(?) or three threads, it will read 
from both disks and you will see 120-140MB/s.

Is there some commonality with software RAID1 and RAID5 in Linux in this 
regard?

$ vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  1  0    128  46344    648 6702340    0    0   357   418   21    1  1  1 99  0
  1  0    128  48476    648 6700664    0    0 294912     0 3862 1505 20 10 71  0
  1  0    128  46144    648 6703448    0    0 327680     0 3951 1815 20 10 70  0
  1  0    128  47280    648 6704488    0    0 295632    92 3747 1937 20  8 72  1
< kicked off the next md5sum -c >
  1  1    128  47956    644 6704156    0    0 423256   128 4730 2149 22 11 62  5
  2  0    128  47684    492 6705700    0    0 491520     0 5598 2484 31 12 48  9
  1  1    128  46412    492 6708432    0    0 524288 41008 5648 6541 31 16 45  8
  2  0    128  48136    492 6706840    0    0 491520     0 5730 2606 29 13 47 11
  1  1    128  46464    492 6708432    0    0 491520    17 5571 2597 30 12 48 10
  2  0    128  47512    492 6709392    0    0 524288     0 5751 2875 32 12 48  8
  2  0    128  47076    304 6711152    0    0 524288     0 5671 2677 31 13 49  7
  3  0    128  48000    304 6706512    0    0 356388    12 4475 2097 22 10 50 19
  2  0    128  47656    304 6713716    0    0 495580    48 5726 2452 30 13 47  9
  2  0    128  47676    304 6713852    0    0 524468    32 5768 2739 31 13 48 8

Thoughts?
