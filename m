Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Apr 2008 07:20:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3OEK3Ol025067
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 07:20:06 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C63815CCDE7
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 07:20:45 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id fkVkfgvwXQaAUPTg for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 07:20:45 -0700 (PDT)
Date: Thu, 24 Apr 2008 10:20:45 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS drops create/delete files to 6.6% of EXT3 (software raid)
 and to 0.6% of EXT3 (3ware hardware raid)
In-Reply-To: <481081CE.1080500@sandeen.net>
Message-ID: <alpine.DEB.1.10.0804241020150.5341@p34.internal.lan>
References: <c33e4330804231848n72ce683cqd48a8d45937f302@mail.gmail.com>  <4810062F.50100@sandeen.net> <20080424053358.GW103491721@sgi.com> <c33e4330804232323p1b6d5121oc56b0c43663a4e84@mail.gmail.com> <481081CE.1080500@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Michael Darling <darlingm@gmail.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com



On Thu, 24 Apr 2008, Eric Sandeen wrote:

> Michael Darling wrote:
>> Eric, for the numbers you provided, are you using a single drive,
>> software raid, or hardware raid?  If a hardware raid, is it a 3ware card?
>
> it's a simple partition on a sata drive.
>
>> I hadn't seen the nobarrier mount option before.  Using that changes
>> sequential creates from about 190/second to about 2500/second, and
>> changes sequential deletes from about 170/second to about 3700/second.
>
> I wasn't recommending, necessarily, that you use it, but was just
> looking for bottlenecks...
>
>> I don't yet have a BBU for the 3ware card, but would certainly get one
>> if we go with the 3ware card before we start putting real data on the
>> raid.  Am I right that with a BBU unit and a battery backup for the
>> server as a whole, that nobarrier would be safe to use?
>>
>> Not using nobarrier, but using logbsize 256k changes sequential creates
>> from about 190/second to about 270/second.  So, it's an improvement, but
>> no where near where a software raid performs (1600/second) or where the
>> hardware raid performs with nobarrier.
>
> Default mkfs & mount w/ 256k logbufs:
>
> xfs,256k logbuf:	1353/s
>
>> On Thu, Apr 24, 2008 at 1:33 AM, David Chinner <dgc@sgi.com
>> <mailto:dgc@sgi.com>> wrote:
>>    > So I played with this a little on 2.6.25, on plain partitions.
>>    >
>>    > I saw similar numbers; for example, sequential creates:
>>    >
>>    > ext3:         23698/s
>>    > xfs:            319/s
>>    > xfs,nobarrier:         4478/s
>>
>>     And with logbsize=256k?
>>
>>     Cheers,
>>
>>     Dave.
>
>

Which program is this that you are using to measure this, bonnie++, or?
