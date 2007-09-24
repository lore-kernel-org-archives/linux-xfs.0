Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 11:01:12 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8OI16Q3001147
	for <linux-xfs@oss.sgi.com>; Mon, 24 Sep 2007 11:01:09 -0700
Date: Mon, 24 Sep 2007 14:01:09 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <20070924173155.GI19983@p15145560.pureserver.info>
Message-ID: <Pine.LNX.4.64.0709241400370.12025@p34.internal.lan>
References: <20070923093841.GH19983@p15145560.pureserver.info>
 <20070924173155.GI19983@p15145560.pureserver.info>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: linux-xfs@oss.sgi.com

A bit ot: will I waste space on the RAID device with a 256K chunk size
and small files? Or does this only depend on the block size of the fs
(4KB at the moment).

That's a good question, I believe its only respective of the filesystem 
size, but will wait for someone to confirm, nice benchmarks!

I use a 1 MiB stripe myself as I found that to give the best performance.

Justin.

On Mon, 24 Sep 2007, Ralf Gross wrote:

> Ralf Gross schrieb:
>>
>> we have a new large raid array, the shelf has 48 disks, the max.
>> amount of disks in a single raid 5 set is 16. There will be one global
>> spare disk, thus we have two raid 5 with 15 data disks and one with 14
>> data disk.
>>
>> The data on these raid sets will be video data + some meta data.
>> Typically each set of data consist of a 2 GB + 500 MB + 100 MB + 20 KB
>> +2 KB file. There will be some dozen of these sets in a single
>> directory - but not many hundred or thousend.
>> ...
>> I already played with different mkfs.xfs options (sw, su) but didn't
>> see much of a difference.
>>
>> The volume sets of the hw raid have the following parameters:
>>
>> 11,xx TB (15 data disks):
>> Chunk Size : 64 KB
>> (values of 64/128/256 KB are possible, I'll try 256 KB next week)
>> Stripe Size : 960 KB (15 x 64 KB)
>> ...
>
> I did some more benchmarks with the 64KB/256KB chunk size option of
> the RAID array and 64K/256K sw option for mkfs.xfs.
>
> 4 tests:
> two RAID 5 volumes (sdd + sdh, both in the same 48 disk shelf), each
> with 15 data disks + 1 parity, 750 GB SATA disks
>
> 1. 256KB chunk size (HW RAID, sdd) + su=256K + sw=15
> 2. 256KB chunk size (HW RAID, sdd) + su=64K + sw=15
> 3. 64KB chunk size (HW RAID, sdh) + su=256K + sw=15
> 4. 64KB chunk size (HW RAID, sdh) + su=64K + sw=15
>
> Although the manual of the HW RAID mentions that a 64KB chunk size would be
> better with more drives, the result for the 256KB chunk size seems to
> me better and more important than the mkfs options. The same manual
> states that RAID 5 would be best for databases...
>
> A bit ot: will I waste space on the RAID device with a 256K chunk size
> and small files? Or does this only depend on the block size of the fs
> (4KB at the moment).
>
> 1.)
> Chunk Size:  	 256 KB
> Stripe Size: 	3840 KB
> Array size:	11135 GB
> Logical Drive Block Size:   	  512 bytes (only possible value)
> mkfs.xfs -d su=256k -d sw=15 /dev/sdd1
>
> /mnt# tiobench --numruns 3 --threads 1 --threads 2  --block 4096 --size 20000
>
> Sequential Reads
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1  207.80 23.88%     0.055       50.43   0.00000  0.00000   870
> 20000  4096    2  197.86 44.29%     0.117      373.10   0.00000  0.00000   447
>
> Random Reads
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ------- ---- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1    2.90 0.569%     4.035       42.83   0.00000  0.00000   510
> 20000  4096    2    4.47 1.679%     5.201       69.75   0.00000  0.00000   266
>
> Sequential Writes
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ------- ---- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1  167.84 36.31%     0.055     9151.42   0.00053  0.00000   462
> 20000  4096    2  170.77 84.39%     0.099     8471.22   0.00066  0.00000   202
>
> Random Writes
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ------- ---- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1    1.97 0.990%     0.016        0.05   0.00000  0.00000   199
> 20000  4096    2    1.68 1.739%     0.019        3.04   0.00000  0.00000    97
>
>
> 2.)
> Chunk Size:  	 256 KB
> Stripe Size: 	3840 KB
> Array size:	11135 GB
> Logical Drive Block Size:   	  512 bytes (only possible value)
> mkfs.xfs -d su=64k -d sw=15 /dev/sdd1
>
> Sequential Reads
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1  203.15 25.13%     0.056       47.58   0.00000  0.00000   808
> 20000  4096    2  190.85 44.67%     0.121      370.55   0.00000  0.00000   427
>
> Random Reads
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1    1.98 0.592%     5.908       41.81   0.00000  0.00000   335
> 20000  4096    2    3.55 1.665%     6.417       69.23   0.00000  0.00000   213
>
> Sequential Writes
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1  168.97 35.47%     0.054     8338.06   0.00056  0.00000   476
> 20000  4096    2  159.21 73.18%     0.109     8133.66   0.00103  0.00000   218
>
> Random Writes
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1    2.01 1.046%     0.018        2.46   0.00000  0.00000   192
> 20000  4096    2    1.78 1.668%     0.020        2.98   0.00000  0.00000   107
>
> 3.)
> Chunk Size:  	 64 KB
> Stripe Size: 	960 KB
> Array size:     11135 GB
> Logical Drive Block Size:   	  512 bytes (only possible value)
> mkfs.xfs -d su=256k -d sw=15 /dev/sdh1
>
> Sequential Reads
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1  189.84 23.00%     0.061       43.77   0.00000  0.00000   825
> 20000  4096    2  173.20 40.87%     0.134      365.86   0.00000  0.00000   424
>
> Random Reads
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1    2.16 0.461%     5.415       38.47   0.00000  0.00000   469
> 20000  4096    2    2.94 1.379%     7.772       69.02   0.00000  0.00000   213
>
> Sequential Writes
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1  130.48 26.59%     0.076    10970.30   0.00097  0.00000   491
> 20000  4096    2  124.93 59.08%     0.134    10370.07   0.00173  0.00000   211
>
> Random Writes
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1    1.73 0.827%     0.018        2.32   0.00000  0.00000   209
> 20000  4096    2    1.83 1.609%     0.019        2.88   0.00000  0.00000   114
>
>
> 4.)
> Chunk Size:  	 64 KB
> Stripe Size: 	960 KB
> Array size:     11135 GB
> Logical Drive Block Size:   	  512 bytes (only possible value)
> mkfs.xfs -d su=64k -d sw=15 /dev/sdh1
>
> Sequential Reads
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1  193.87 21.96%     0.059       59.45   0.00000  0.00000   883
> 20000  4096    2  185.08 40.73%     0.125      369.16   0.00000  0.00000   454
>
> Random Reads
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1    2.88 0.565%     4.061       39.23   0.00000  0.00000   510
> 20000  4096    2    4.37 1.640%     5.199       75.55   0.00000  0.00000   266
>
> Sequential Writes
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1  143.80 31.12%     0.068    10424.88   0.00072  0.00000   462
> 20000  4096    2  115.01 53.56%     0.147    11421.10   0.00209  0.00000   215
>
> Random Writes
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1    2.05 0.753%     0.016        0.09   0.00000  0.00000   273
> 20000  4096    2    1.86 1.539%     0.018        0.09   0.00000  0.00000   121
>
>
> Ralf
>
>
