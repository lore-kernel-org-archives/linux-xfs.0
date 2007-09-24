Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 13:40:25 -0700 (PDT)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de [217.160.223.211])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8OKeFQ3013825
	for <linux-xfs@oss.sgi.com>; Mon, 24 Sep 2007 13:40:20 -0700
Received: from rg by stlx01.stz-softwaretechnik.com with local (Exim 3.36 #1 (Debian))
	id 1IZuiu-0001d7-00
	for <linux-xfs@oss.sgi.com>; Mon, 24 Sep 2007 22:40:08 +0200
Date: Mon, 24 Sep 2007 22:39:58 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
Message-ID: <20070924203958.GA4082@p15145560.pureserver.info>
References: <20070923093841.GH19983@p15145560.pureserver.info> <20070924173155.GI19983@p15145560.pureserver.info> <Pine.LNX.4.64.0709241400370.12025@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709241400370.12025@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Justin Piszcz schrieb:
>> A bit ot: will I waste space on the RAID device with a 256K chunk size
>> and small files? Or does this only depend on the block size of the fs
>> (4KB at the moment).
>
> That's a good question, I believe its only respective of the filesystem
> size, but will wait for someone to confirm, nice benchmarks!
>
> I use a 1 MiB stripe myself as I found that to give the best performance.

256KB is the largest chunk size I can choose for a raid set. BTW: the HW-RAID
is an Overland Ultamus 4800.

The funny thing is, that performance (256KB chunks) is even better without
adding any sw/su option to the mkfs command.

mkfs.xfs  /dev/sdd1 -f

Sequential Reads
File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
20000  4096    1  208.33 23.81%     0.055       49.55   0.00000  0.00000   875
20000  4096    2  199.48 43.72%     0.116      376.85   0.00000  0.00000   456

Random Reads
File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
20000  4096    1    2.83 0.604%     4.131       38.81   0.00000  0.00000   469
20000  4096    2    4.53 1.700%     4.995       67.15   0.00000  0.00000   266

Sequential Writes
File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
20000  4096    1  188.15 42.98%     0.047     7547.93   0.00027  0.00000   438
20000  4096    2  167.76 76.89%     0.100     7521.34   0.00078  0.00000   218

Random Writes
File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
20000  4096    1    2.08 0.869%     0.016        0.13   0.00000  0.00000   239
20000  4096    2    1.80 1.501%     0.020        6.28   0.00000  0.00000   12


Ralf
