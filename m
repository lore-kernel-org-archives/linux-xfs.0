Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 01 Nov 2008 05:00:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA1C0cGT005898
	for <xfs@oss.sgi.com>; Sat, 1 Nov 2008 05:00:39 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 295FA1B71C12
	for <xfs@oss.sgi.com>; Sat,  1 Nov 2008 05:00:39 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id VjUdaIVvJ2PDnRBn for <xfs@oss.sgi.com>; Sat, 01 Nov 2008 05:00:39 -0700 (PDT)
Date: Sat, 1 Nov 2008 08:00:34 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linux RAID & XFS Question - Multiple levels of concurrency =
 faster I/O on md/RAID 5?
In-Reply-To: <490C359F.7080504@anonymous.org.uk>
Message-ID: <alpine.DEB.1.10.0811010758240.1053@p34.internal.lan>
References: <alpine.DEB.1.10.0811010424270.16517@p34.internal.lan> <490C359F.7080504@anonymous.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com



On Sat, 1 Nov 2008, John Robinson wrote:

> On 01/11/2008 08:29, Justin Piszcz wrote:
> [...]
>> Why is running 3 jobs con-currently that take care of two parts each more 
>> than
>> twice as fast than running one job for six parts?
>
> Because you have multiple CPUs?

So 1/4 of a quad core q6600 cannot achieve higher rates of I/O due to the
parity operations being that costly?

Is the only way to increase the single-threaded speed to increase the maximum
CPU core speed/get a faster CPU, and/or theoretically a multi-threaded md-raid
could maximize throughput?

Justin.
