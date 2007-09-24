Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 14:36:55 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8OLamQ3024789
	for <linux-xfs@oss.sgi.com>; Mon, 24 Sep 2007 14:36:52 -0700
Date: Mon, 24 Sep 2007 17:36:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <20070924213358.GB4082@p15145560.pureserver.info>
Message-ID: <Pine.LNX.4.64.0709241736370.19847@p34.internal.lan>
References: <20070923093841.GH19983@p15145560.pureserver.info>
 <20070924173155.GI19983@p15145560.pureserver.info>
 <Pine.LNX.4.64.0709241400370.12025@p34.internal.lan>
 <20070924203958.GA4082@p15145560.pureserver.info>
 <Pine.LNX.4.64.0709241642110.19847@p34.internal.lan>
 <20070924213358.GB4082@p15145560.pureserver.info>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: linux-xfs@oss.sgi.com



On Mon, 24 Sep 2007, Ralf Gross wrote:

> Justin Piszcz schrieb:
>>
>>
>> On Mon, 24 Sep 2007, Ralf Gross wrote:
>>
>>> Justin Piszcz schrieb:
>>>>> A bit ot: will I waste space on the RAID device with a 256K chunk size
>>>>> and small files? Or does this only depend on the block size of the fs
>>>>> (4KB at the moment).
>>>>
>>>> That's a good question, I believe its only respective of the filesystem
>>>> size, but will wait for someone to confirm, nice benchmarks!
>>>>
>>>> I use a 1 MiB stripe myself as I found that to give the best performance.
>>>
>>> 256KB is the largest chunk size I can choose for a raid set. BTW: the
>>> HW-RAID
>>> is an Overland Ultamus 4800.
>>>
>>> The funny thing is, that performance (256KB chunks) is even better without
>>> adding any sw/su option to the mkfs command.
>>>
>>> mkfs.xfs  /dev/sdd1 -f
>>>
>>> Sequential Reads
>>> File  Blk   Num                   Avg      Maximum      Lat%     Lat%
>>> CPU
>>> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s
>>> Eff
>>> ----- ----- ---  ------ ------ --------- -----------  -------- --------
>>> -----
>>> 20000  4096    1  208.33 23.81%     0.055       49.55   0.00000  0.00000
>>> 875
>>> 20000  4096    2  199.48 43.72%     0.116      376.85   0.00000  0.00000
>>> 456
>>>
>>> Random Reads
>>> File  Blk   Num                   Avg      Maximum      Lat%     Lat%
>>> CPU
>>> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s
>>> Eff
>>> ----- ----- ---  ------ ------ --------- -----------  -------- --------
>>> -----
>>> 20000  4096    1    2.83 0.604%     4.131       38.81   0.00000  0.00000
>>> 469
>>> 20000  4096    2    4.53 1.700%     4.995       67.15   0.00000  0.00000
>>> 266
>>>
>>> Sequential Writes
>>> File  Blk   Num                   Avg      Maximum      Lat%     Lat%
>>> CPU
>>> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s
>>> Eff
>>> ----- ----- ---  ------ ------ --------- -----------  -------- --------
>>> -----
>>> 20000  4096    1  188.15 42.98%     0.047     7547.93   0.00027  0.00000
>>> 438
>>> 20000  4096    2  167.76 76.89%     0.100     7521.34   0.00078  0.00000
>>> 218
>>>
>>> Random Writes
>>> File  Blk   Num                   Avg      Maximum      Lat%     Lat%
>>> CPU
>>> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s
>>> Eff
>>> ----- ----- ---  ------ ------ --------- -----------  -------- --------
>>> -----
>>> 20000  4096    1    2.08 0.869%     0.016        0.13   0.00000  0.00000
>>> 239
>>> 20000  4096    2    1.80 1.501%     0.020        6.28   0.00000  0.00000
>>> 12
>>>
>>
>> I find that to be the case with SW RAID (defaults are best)
>>
>> Although with 16 drives(?) that is awfully slow.
>>
>> I have 6 SATA's I get 160-180 MiB/s raid5 and 250-280 MiB/s raid 0 (sw
>> raid).
>>
>> With 10 raptors I get ~450 MiB/s write and ~550-600 MiB/s read, again
>> XFS+SW raid.
>
> Hm, with the different HW-RAIDs I've used so far (easyRAID,
> Infortrend, internal Areca controller), I always got 160-200 MiB/s
> read/write with 7-15 disks. That's one reason why I asked if there are
> some xfs options I could use for better performance. But I guess fs
> options won't boost performance that much.
>
> Ralf
>
>

What do you get when (reading) from the raw device?

dd if=/dev/sda bs=1M count=10240
