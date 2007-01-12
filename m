Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 12 Jan 2007 14:38:50 -0800 (PST)
Received: from gaimboi.tmr.com (mail.tmr.com [64.65.253.246])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0CMcTr0020429
	for <xfs@oss.sgi.com>; Fri, 12 Jan 2007 14:38:32 -0800
Message-ID: <45A7F04D.6030804@tmr.com>
Date: Fri, 12 Jan 2007 15:32:13 -0500
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
Subject: Re: Linux Software RAID 5 Performance Optimizations: 2.6.19.1: (211MB/s
 read & 195MB/s write)
References: <Pine.LNX.4.64.0701111832080.3673@p34.internal.lan> <Pine.LNX.4.64.0701120934260.21164@p34.internal.lan> <Pine.LNX.4.64.0701121236470.3840@p34.internal.lan> <200701122235.30288.a1426z@gawab.com>
In-Reply-To: <200701122235.30288.a1426z@gawab.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Al Boldi <a1426z@gawab.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Al Boldi wrote:
> Justin Piszcz wrote:
>   
>> RAID 5 TWEAKED: 1:06.41 elapsed @ 60% CPU
>>
>> This should be 1:14 not 1:06(was with a similarly sized file but not the
>> same) the 1:14 is the same file as used with the other benchmarks.  and to
>> get that I used 256mb read-ahead and 16384 stripe size ++ 128
>> max_sectors_kb (same size as my sw raid5 chunk size)
>>     
>
> max_sectors_kb is probably your key. On my system I get twice the read 
> performance by just reducing max_sectors_kb from default 512 to 192.
>
> Can you do a fresh reboot to shell and then:
> $ cat /sys/block/hda/queue/*
> $ cat /proc/meminfo
> $ echo 3 > /proc/sys/vm/drop_caches
> $ dd if=/dev/hda of=/dev/null bs=1M count=10240
> $ echo 192 > /sys/block/hda/queue/max_sectors_kb
> $ echo 3 > /proc/sys/vm/drop_caches
> $ dd if=/dev/hda of=/dev/null bs=1M count=10240
>   
You can find even more joy on large writes, assuming you have a recent 
2.6 kernel. Look at /proc/sys/vm/dirty-* values. by making the ratio 
smaller, and the ratio smaller you can reduce or eliminate the bursty 
behavior of Linux disk write. However, see my previous thread on poor 
RAID-5 write performance, there's still something not optimal. Note that 
RAID-10, which does more i/o, is faster with default tuning than RAID-5 
by about N-1 taime (N = array drives).

I would say that the numbers posted are interesting, but most people 
don't have a spare GB or more to use for buffer, particularly if you 
have multiple arrays on your disks.

Before someone says "why do that..." here's why:
  /boot - should be mirrored so the BIOS will boot if a drive fails
  swap - RAID-1, because for an given tuning, it's faster than RAID-5. 
Note: RAID-10 is faster yet, but Fedora
    and SuSE rescue CDs don't like RAID-10 swap.
  critical - stuff you can't afford to lose, RAID-6\
  normal - RAID-5

That's why I have partitions of the same drives at different RAID 
levels, and with various tuning settings, depending on how they are used.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979



[[HTML alternate version deleted]]
