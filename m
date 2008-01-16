Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jan 2008 14:52:53 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0GMqn1E008804
	for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 14:52:50 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03D42529F50
	for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 14:53:06 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id FzQkZ4MGPnnZ7nDE for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 14:53:06 -0800 (PST)
Date: Wed, 16 Jan 2008 17:53:05 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linux Software RAID 5 + XFS Multi-Benchmarks / 10 Raptors
 Again
In-Reply-To: <200801170019.04836.a1426z@gawab.com>
Message-ID: <alpine.DEB.0.999999.0801161752420.4552@p34.internal.lan>
References: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan> <200801162027.00791.a1426z@gawab.com> <alpine.DEB.0.999999.0801161243380.1151@p34.internal.lan> <200801170019.04836.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Al Boldi <a1426z@gawab.com>
Cc: xfs@oss.sgi.com, linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>



On Thu, 17 Jan 2008, Al Boldi wrote:

> Justin Piszcz wrote:
>> On Wed, 16 Jan 2008, Al Boldi wrote:
>>>> Also, can you retest using dd with different block-sizes?
>>
>> I can do this, moment..
>>
>>
>> I know about oflag=direct but I choose to use dd with sync and measure the
>> total time it takes.
>> /usr/bin/time -f %E -o ~/$i=chunk.txt bash -c 'dd if=/dev/zero
>> of=/r1/bigfile bs=1M count=10240; sync'
>>
>> So I was asked on the mailing list to test dd with various chunk sizes,
>> here is the length of time it took
>> to write 10 GiB and sync per each chunk size:
>>
>> 4=chunk.txt:0:25.46
>> 8=chunk.txt:0:25.63
>> 16=chunk.txt:0:25.26
>> 32=chunk.txt:0:25.08
>> 64=chunk.txt:0:25.55
>> 128=chunk.txt:0:25.26
>> 256=chunk.txt:0:24.72
>> 512=chunk.txt:0:24.71
>> 1024=chunk.txt:0:25.40
>> 2048=chunk.txt:0:25.71
>> 4096=chunk.txt:0:27.18
>> 8192=chunk.txt:0:29.00
>> 16384=chunk.txt:0:31.43
>> 32768=chunk.txt:0:50.11
>> 65536=chunk.txt:2:20.80
>
> What do you get with bs=512,1k,2k,4k,8k,16k...
>
>
> Thanks!
>
> --
> Al
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Done testing for now, but I did test with 256k with a 256k chunk and 
obviously that got good results, just like 1m with a 1mb chunk, 460-480 
MiB/s.

Justin.
