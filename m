Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 May 2008 06:43:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m46DhEtc014925
	for <xfs@oss.sgi.com>; Tue, 6 May 2008 06:43:16 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE5EB131933
	for <xfs@oss.sgi.com>; Tue,  6 May 2008 06:43:58 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id jHavppCDootS9Vj0 for <xfs@oss.sgi.com>; Tue, 06 May 2008 06:43:58 -0700 (PDT)
Message-ID: <4820609C.9090306@sandeen.net>
Date: Tue, 06 May 2008 08:43:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net> <480E89B5.8070006@sandeen.net> <481B7FD1.3030107@sandeen.net> <20080505070847.GH155679365@sgi.com> <481FDCD1.2010905@sgi.com>
In-Reply-To: <481FDCD1.2010905@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Timothy Shimmin wrote:
> David Chinner wrote:
>> On Fri, May 02, 2008 at 03:55:45PM -0500, Eric Sandeen wrote:
>>> Eric Sandeen wrote:
>>>> Eric Sandeen wrote:
>>>>> This should fix the longstanding issues with xfs and old ABI
>>>>> arm boxes, which lead to various asserts and xfs shutdowns,
>>>>> and for which an (incorrect) patch has been floating around
>>>>> for years.  (Said patch made ARM internally consistent, but
>>>>> altered the normal xfs on-disk format such that it looked
>>>>> corrupted on other architectures):
>>>>> http://lists.arm.linux.org.uk/lurker/message/20040311.002034.5ecf21a2.html
>>>> ping again...
>>> ping #3...
>> <sigh>
>>
>> Looks like if I don't pick it up then nobody is going to answer.
>> I'll run it through my ia64 and x86_64 test boxes and if it's ok
>> then I'll commit it.
>>
> As it only defines __arch_pack for __arm__,
> I literally can't see how on earth it won't pass for ia64 and x86-64,
> though I realise (I guess) we need to test to be sure :)
> 
> So Eric tested this on qemu-arm with success.
> And there was a little debate over whether ARM-EABI would work
> currently in XFS, 
> with Luca Olivetti saying in one kernel he has success and in another
> he doesn't. And Andre Draszik saying that for ARM-EABI it wouldn't
> work.

The patch should only affect behavior on *old* abi:

+#if defined(__arm__) && !defined(__ARM_EABI__)

it is the only one with the unique alignment that matters here.

There *is* still another issue on some arm chips related to processor
cache flushing; I didn't see the problem in qemu because it the emulator
does not have this behavior.

But, it's a separate issue from the structure alignment this patch
addresses.

One thing at a time. :)

Thanks,

-Eric

> That aside, Eric has tried out on ARM without EABI (old ABI) and has had success,
> so it is at least useful for this case.
> I don't see us doing any arm testing for this ourselves :)
> 
> --Tim
> 
