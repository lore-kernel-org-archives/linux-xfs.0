Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Nov 2006 12:34:42 -0800 (PST)
Received: from randymail-a9.dreamhost.com (sd-green-bigip-119.dreamhost.com [208.97.132.119])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAUKYWaG006800
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 12:34:35 -0800
Message-ID: <456F401F.3030902@delusion.com>
Date: Thu, 30 Nov 2006 12:33:35 -0800
From: Deanan <delusion@delusion.com>
MIME-Version: 1.0
Subject: Re: inode64 workaround
References: <200611290027.AA04740@TNESG9305.tnes.nec.co.jp> <1164838985.4992.30.camel@edge> <456E1B08.7090802@delusion.com> <456E2A30.4010101@melbourne.sgi.com> <456E2D0E.2000007@delusion.com> <456E30A5.6080109@melbourne.sgi.com> <456E35CA.2000601@delusion.com> <456E67EB.2030008@sandeen.net>
In-Reply-To: <456E67EB.2030008@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: chatz@melbourne.sgi.com, xfs@oss.sgi.com

It's a generic 2.6.9 kernel (AFAIK).
I tried the same setting on a different box with SLES 9 SP3 (2.6.5) 
which does have rotorstep.
With inode64 I can sustain 235+MB/s on the same array test after test.
When I do not mount with inode64, I get the same results as the 32bit 
machine (~100-130MB/s)
Without inode64 plus rotorstep (set to 255), the perfomance improves to 
about 140-160MB/s.

Generally the first test is fast and then drops over the next few tests 
(even writing as few
as 100 16mb files per test).

Thanks,

Deanan

> Deanan wrote:
>> Thanks. Unfortunately 2.6.9 doesn't have it. :(
>
> Is this rhel4?
>
> You could probably pretty easily add the inode rotor code into the xfs 
> modules that you're using, if that's the case.
>
> -Eric
>
>>> This is a sysctl, see sysctl(8).
>>>
>>> It was introduced to XFS in October 2004, I'm not sure if it made 
>>> 2.6.9.
>>>
>>> If this doesn't help a little then I'm unsure why you think that 
>>> inode64 is
>>> going to solve your problem?
>>>
>>> David
>>>   
>>
>>
>
>
