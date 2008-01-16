Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jan 2008 10:02:55 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0GI2MV0013197
	for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 10:02:24 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67551527FDC
	for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 10:02:41 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id lM5DCpYN5q3XyOtq for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 10:02:41 -0800 (PST)
Date: Wed, 16 Jan 2008 13:02:40 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linux Software RAID 5 + XFS Multi-Benchmarks / 10 Raptors
 Again
In-Reply-To: <200801162027.00791.a1426z@gawab.com>
Message-ID: <alpine.DEB.0.999999.0801161243380.1151@p34.internal.lan>
References: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan> <200801162027.00791.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Al Boldi <a1426z@gawab.com>
Cc: xfs@oss.sgi.com, linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>



On Wed, 16 Jan 2008, Al Boldi wrote:

> Justin Piszcz wrote:
>> For these benchmarks I timed how long it takes to extract a standard 4.4
>> GiB DVD:
>>
>> Settings: Software RAID 5 with the following settings (until I change
>> those too):
>>
>> Base setup:
>> blockdev --setra 65536 /dev/md3
>> echo 16384 > /sys/block/md3/md/stripe_cache_size
>> echo "Disabling NCQ on all disks..."
>> for i in $DISKS
>> do
>>    echo "Disabling NCQ on $i"
>>    echo 1 > /sys/block/"$i"/device/queue_depth
>> done
>>
>> p34:~# grep : *chunk* |sort -n
>> 4-chunk.txt:0:45.31
>> 8-chunk.txt:0:44.32
>> 16-chunk.txt:0:41.02
>> 32-chunk.txt:0:40.50
>> 64-chunk.txt:0:40.88
>> 128-chunk.txt:0:40.21
>> 256-chunk.txt:0:40.14***
>> 512-chunk.txt:0:40.35
>> 1024-chunk.txt:0:41.11
>> 2048-chunk.txt:0:43.89
>> 4096-chunk.txt:0:47.34
>> 8192-chunk.txt:0:57.86
>> 16384-chunk.txt:1:09.39
>> 32768-chunk.txt:1:26.61
>>
>> It would appear a 256 KiB chunk-size is optimal.
>
> Can you retest with different max_sectors_kb on both md and sd?
Remember this is SW RAID, so max_sectors_kb will only affect the 
individual disks underneath the SW RAID, I have benchmarked in the past, 
the defaults chosen by the kernel are optimal, changing them did not make 
any noticable improvements.

> > Also, can you retest using dd with different block-sizes?
I can do this, moment..


I know about oflag=direct but I choose to use dd with sync and measure the 
total time it takes.
/usr/bin/time -f %E -o ~/$i=chunk.txt bash -c 'dd if=/dev/zero 
of=/r1/bigfile bs=1M count=10240; sync'

So I was asked on the mailing list to test dd with various chunk sizes, 
here is the length of time it took
to write 10 GiB and sync per each chunk size:

4=chunk.txt:0:25.46
8=chunk.txt:0:25.63
16=chunk.txt:0:25.26
32=chunk.txt:0:25.08
64=chunk.txt:0:25.55
128=chunk.txt:0:25.26
256=chunk.txt:0:24.72
512=chunk.txt:0:24.71
1024=chunk.txt:0:25.40
2048=chunk.txt:0:25.71
4096=chunk.txt:0:27.18
8192=chunk.txt:0:29.00
16384=chunk.txt:0:31.43
32768=chunk.txt:0:50.11
65536=chunk.txt:2:20.80

Justin.
