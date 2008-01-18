Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Jan 2008 07:04:57 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0IF4q0f019071
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 07:04:54 -0800
Received: from gaimboi.tmr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26DDC534FFD
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 07:05:10 -0800 (PST)
Received: from gaimboi.tmr.com (mail.tmr.com [64.65.253.246]) by cuda.sgi.com with ESMTP id E5gCxytx0HKmTrGD for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 07:05:10 -0800 (PST)
Message-ID: <4790C4BC.90802@tmr.com>
Date: Fri, 18 Jan 2008 10:24:44 -0500
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
Subject: Re: Linux Software RAID 5 + XFS Multi-Benchmarks / 10 Raptors Again
References: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan> <200801162027.00791.a1426z@gawab.com> <alpine.DEB.0.999999.0801161243380.1151@p34.internal.lan> <200801170019.04836.a1426z@gawab.com> <alpine.DEB.0.999999.0801161754180.4552@p34.internal.lan>
In-Reply-To: <alpine.DEB.0.999999.0801161754180.4552@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Al Boldi <a1426z@gawab.com>, xfs@oss.sgi.com, linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>

Justin Piszcz wrote:
>
>
> On Thu, 17 Jan 2008, Al Boldi wrote:
>
>> Justin Piszcz wrote:
>>> On Wed, 16 Jan 2008, Al Boldi wrote:
>>>>> Also, can you retest using dd with different block-sizes?
>>>
>>> I can do this, moment..
>>>
>>>
>>> I know about oflag=direct but I choose to use dd with sync and 
>>> measure the
>>> total time it takes.
>>> /usr/bin/time -f %E -o ~/$i=chunk.txt bash -c 'dd if=/dev/zero
>>> of=/r1/bigfile bs=1M count=10240; sync'
>>>
>>> So I was asked on the mailing list to test dd with various chunk sizes,
>>> here is the length of time it took
>>> to write 10 GiB and sync per each chunk size:
>>>
>>> 4=chunk.txt:0:25.46
>>> 8=chunk.txt:0:25.63
>>> 16=chunk.txt:0:25.26
>>> 32=chunk.txt:0:25.08
>>> 64=chunk.txt:0:25.55
>>> 128=chunk.txt:0:25.26
>>> 256=chunk.txt:0:24.72
>>> 512=chunk.txt:0:24.71
>>> 1024=chunk.txt:0:25.40
>>> 2048=chunk.txt:0:25.71
>>> 4096=chunk.txt:0:27.18
>>> 8192=chunk.txt:0:29.00
>>> 16384=chunk.txt:0:31.43
>>> 32768=chunk.txt:0:50.11
>>> 65536=chunk.txt:2:20.80
>>
>> What do you get with bs=512,1k,2k,4k,8k,16k...
>>
>>
>> Thanks!
>>
>> -- 
>> Al
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> root      4621  0.0  0.0  12404   760 pts/2    D+   17:53   0:00 mdadm 
> -S /dev/md3
> root      4664  0.0  0.0   4264   728 pts/5    S+   17:54   0:00 grep D
>
> Tried to stop it when it was re-syncing, DEADLOCK :(
>
> [  305.464904] md: md3 still in use.
> [  314.595281] md: md_do_sync() got signal ... exiting
>
> Anyhow, done testing, time to move data back on if I can kill the 
> resync process w/out deadlock.

So does that indicate that there is still a deadlock issue, or that you 
don't have the latest patches installed?

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 
