Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 01:42:34 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8Q8gMaX003086
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 01:42:28 -0700
Date: Wed, 26 Sep 2007 04:42:22 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <20070926082322.GA30287@p15145560.pureserver.info>
Message-ID: <Pine.LNX.4.64.0709260442070.31289@p34.internal.lan>
References: <498689.78850.qm@web32907.mail.mud.yahoo.com>
 <Pine.LNX.4.64.0709251938400.7763@p34.internal.lan>
 <20070926082322.GA30287@p15145560.pureserver.info>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: linux-xfs@oss.sgi.com



On Wed, 26 Sep 2007, Ralf Gross wrote:

> Justin Piszcz schrieb:
>>
>>
>> On Tue, 25 Sep 2007, Bryan J. Smith wrote:
>>
>>> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>>> Just out of curisosity have you tried SW RAID5 on this array?
>>>> Also what do you get if you use RAID0 (hw or sw)?
>>>
>>> According to him, if I read it correclty, it is an external FC RAID-5
>>> chassis.  I.e., all of the logic is in the chassis.  So your question
>>> is N/A.
>>>
>>> Although I'm more than ready to be proven incorrect.
>>>
>>> Furthermore, what benchmark do you use?  If dd on the volume itself,
>>> software RAID wins, hands down.  Doesn't matter what size you give
>>> it, it literally copies (and doesn't recalculate) the parity.  It's
>>> the rawest form of non-blocking I/O, and uses virtually no system
>>> interconnect to the CPU (just pushes disk-mem-disk).
>>
>> bonnie++, iozone, etc..
>>
>> all show ~430-460 MiB/s write and ~550 MiB/s read
>
> I'm happy :) I was able to boost the read performance by setting
>
> blockdev --setra 16384 /dev/sdc
>
> I knew this parameter is neccessary for 3ware controllers, but I
> haven't noticed any difference with areca controllers or ext. raids yet.
>
> The write performance may not be ideal, but these read numbers makes much
> more sense now because the FC controller is the limiting factor.
>
> Sequential Reads
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1  391.20 50.24%     0.019       43.01   0.00000  0.00000   779
> 20000  4096    2  387.79 92.22%     0.040      278.71   0.00000  0.00000   420
>
> Random Reads
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1    2.87 0.698%     2.720       27.47   0.00000  0.00000   411
> 20000  4096    2    4.37 2.013%     3.473       47.35   0.00000  0.00000   217
>
> Sequential Writes
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1  189.23 42.73%     0.029     5670.66   0.00014  0.00000   443
> 20000  4096    2  173.92 84.93%     0.064     4590.56   0.00029  0.00000   205
>
> Random Writes
> File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
> Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
> ----- ----- ---  ------ ------ --------- -----------  -------- -------- -----
> 20000  4096    1    1.85 0.662%     0.011        0.05   0.00000  0.00000   279
> 20000  4096    2    1.68 0.772%     0.012        0.05   0.00000  0.00000   217
>
>
>
>
> Ralf
>
>

What was the command line you used for that output?
tiobench.. ?

Justin.
