Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 01 Nov 2008 05:14:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA1CEibX007056
	for <xfs@oss.sgi.com>; Sat, 1 Nov 2008 05:14:44 -0700
Received: from hole.yuiop.co.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D90131B71EB8
	for <xfs@oss.sgi.com>; Sat,  1 Nov 2008 05:14:45 -0700 (PDT)
Received: from hole.yuiop.co.uk (hole.yuiop.co.uk [89.145.97.62]) by cuda.sgi.com with ESMTP id sZAt6uBWmkezPo4Q for <xfs@oss.sgi.com>; Sat, 01 Nov 2008 05:14:45 -0700 (PDT)
Message-ID: <490C4834.3050404@anonymous.org.uk>
Date: Sat, 01 Nov 2008 12:14:44 +0000
From: John Robinson <john.robinson@anonymous.org.uk>
MIME-Version: 1.0
Subject: Re: Linux RAID & XFS Question - Multiple levels of concurrency =
 faster I/O on md/RAID 5?
References: <alpine.DEB.1.10.0811010424270.16517@p34.internal.lan> <490C359F.7080504@anonymous.org.uk> <alpine.DEB.1.10.0811010758240.1053@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0811010758240.1053@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com

On 01/11/2008 12:00, Justin Piszcz wrote:
> On Sat, 1 Nov 2008, John Robinson wrote:
>> On 01/11/2008 08:29, Justin Piszcz wrote:
>> [...]
>>> Why is running 3 jobs con-currently that take care of two parts each 
>>> more than
>>> twice as fast than running one job for six parts?
>>
>> Because you have multiple CPUs?
> 
> So 1/4 of a quad core q6600 cannot achieve higher rates of I/O due to the
> parity operations being that costly?
> 
> Is the only way to increase the single-threaded speed to increase the 
> maximum
> CPU core speed/get a faster CPU, and/or theoretically a multi-threaded 
> md-raid
> could maximize throughput?

Actually I was thinking that your test job - I think you said it used 
tar - is single-threaded and CPU-bound on one core, and doesn't saturate 
the MD subsystem. Your jobs are 75% user time to 25% system time, and 
the user time is not parellelisable until you do it yourself by 
splitting the work up.

Cheers,

John.
