Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Feb 2008 15:48:36 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1TNm9wF002553
	for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 15:48:14 -0800
Message-ID: <47C8997A.9030804@sgi.com>
Date: Sat, 01 Mar 2008 10:47:06 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com> <1204166101.13569.102.camel@edge.scott.net.au> <47C87775.2010007@thebarn.com> <47C89137.3070805@sandeen.net> <47C89303.7070902@thebarn.com>
In-Reply-To: <47C89303.7070902@thebarn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, nscott@aconex.com, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>



Russell Cattelan wrote:
> Eric Sandeen wrote:
>> Russell Cattelan wrote:
>>
>>
>>
>>>> Hmm, that still seems pretty soon to me.  I'd have thought you'd at
>>>> least want to wait until most of the distributions (esp. SUSE for you
>>>> guys) have released versions that have kernels sufficiently recent
>>>> that the default mkfs will work.  Otherwise this will be a recurring
>>>> problem.
>>>>
>>> I don't suppose there is an easy way to query xfs and find out if it
>>> can support
>>> the lazy SB option?
>>
>> I thought about that; xfs *could* stick someting in /proc/fs/xfs with
>> supported features or somesuch.

how about /proc/fs/xfs/features
.. any format suggestions?

>> But, the kernel you mkfs under isn't necessarily the one you're going to
>> need to fall back to tomorrow, though...

nor the one you just installed but haven't rebooted into yet

> True but at least it could make a bit of a intelligent decision.
> and maybe a warning for a while about potentially incompatible flags.

yes agree

Cheers

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
