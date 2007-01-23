Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 09:03:39 -0800 (PST)
Received: from gaimboi.tmr.com (mail.tmr.com [64.65.253.246])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0NH3Oqw011440
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 09:03:27 -0800
Message-ID: <45B64068.9020500@tmr.com>
Date: Tue, 23 Jan 2007 12:05:44 -0500
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba -> RAID5)
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan> <45B5261B.1050104@redhat.com> <17845.13256.284461.992275@notabene.brown> <Pine.LNX.4.64.0701230556050.8978@p34.internal.lan> <45B5ECAA.6000100@tls.msk.ru> <Pine.LNX.4.64.0701230657380.8978@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0701230657380.8978@p34.internal.lan>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>

Justin Piszcz wrote:
> On Tue, 23 Jan 2007, Michael Tokarev wrote:
>
>   
>> Justin Piszcz wrote:
>> []
>>     
>>> Is this a bug that can or will be fixed or should I disable pre-emption on 
>>> critical and/or server machines?
>>>       
>> Disabling pre-emption on critical and/or server machines seems to be a good
>> idea in the first place.  IMHO anyway.. ;)
>>
>> /mjt
>>
>>     
>
> So for a server system, the following options should be as follows:
>
> Preemption Model (No Forced Preemption (Server))  --->
> [ ] Preempt The Big Kernel Lock
>
> Also, my mobo has HPET timer support in the BIOS, is there any reason to 
> use this on a server? I do run X on it via the Intel 965 chipset video.
>
> So bottom line is make sure not to use preemption on servers or else you 
> will get weird spinlock/deadlocks on RAID devices--GOOD To know!

I should actually think it's BAD to know, it has nothing to do with 
servers, either PREEMPT works safely or it doesn't, like being pregnant 
there are no grey areas.

Justin Piszcz wrote:


    This is not a reason. The reason is that preemption usually works worse
    on servers, esp. high-loaded servers - the more often you interrupt a
    (kernel) work, the more nedleess context switches you'll have, and the
    more slow the whole thing works.

    Another point is that with preemption enabled, we have more chances to
    hit one or another bug somewhere. Those bugs should be found and fixed
    for sure, but important servers/data isn't a place usually for 
bughunting.

Unfortunately bugs, like big horn sheep, must be hunted where they can be found, however inconvenient that may be.


I am curious to know if this applies to voluntary preempt as well.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979



[[HTML alternate version deleted]]
