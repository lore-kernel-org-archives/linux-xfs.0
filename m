Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 May 2008 21:21:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m464L4wD032543
	for <xfs@oss.sgi.com>; Mon, 5 May 2008 21:21:07 -0700
Message-ID: <481FDCD1.2010905@sgi.com>
Date: Tue, 06 May 2008 14:21:37 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net> <480E89B5.8070006@sandeen.net> <481B7FD1.3030107@sandeen.net> <20080505070847.GH155679365@sgi.com>
In-Reply-To: <20080505070847.GH155679365@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> On Fri, May 02, 2008 at 03:55:45PM -0500, Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> Eric Sandeen wrote:
>>>> This should fix the longstanding issues with xfs and old ABI
>>>> arm boxes, which lead to various asserts and xfs shutdowns,
>>>> and for which an (incorrect) patch has been floating around
>>>> for years.  (Said patch made ARM internally consistent, but
>>>> altered the normal xfs on-disk format such that it looked
>>>> corrupted on other architectures):
>>>> http://lists.arm.linux.org.uk/lurker/message/20040311.002034.5ecf21a2.html
>>> ping again...
>> ping #3...
> 
> <sigh>
> 
> Looks like if I don't pick it up then nobody is going to answer.
> I'll run it through my ia64 and x86_64 test boxes and if it's ok
> then I'll commit it.
> 
As it only defines __arch_pack for __arm__,
I literally can't see how on earth it won't pass for ia64 and x86-64,
though I realise (I guess) we need to test to be sure :)

So Eric tested this on qemu-arm with success.
And there was a little debate over whether ARM-EABI would work
currently in XFS, 
with Luca Olivetti saying in one kernel he has success and in another
he doesn't. And Andre Draszik saying that for ARM-EABI it wouldn't
work.
That aside, Eric has tried out on ARM without EABI (old ABI) and has had success,
so it is at least useful for this case.
I don't see us doing any arm testing for this ourselves :)

--Tim
