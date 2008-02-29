Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Feb 2008 15:55:46 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1TNtbav003369
	for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 15:55:38 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78B9E634AAD
	for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 15:56:05 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id yXEwB8YHMWIyYskf for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 15:56:05 -0800 (PST)
Message-ID: <47C89B94.4060002@sandeen.net>
Date: Fri, 29 Feb 2008 17:56:04 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com> <1204166101.13569.102.camel@edge.scott.net.au> <47C87775.2010007@thebarn.com> <47C89137.3070805@sandeen.net> <47C89303.7070902@thebarn.com> <47C8997A.9030804@sgi.com>
In-Reply-To: <47C8997A.9030804@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Russell Cattelan <cattelan@thebarn.com>, nscott@aconex.com, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Mark Goodwin wrote:
> 
> Russell Cattelan wrote:
>> Eric Sandeen wrote:
>>> Russell Cattelan wrote:
>>>
>>>
>>>
>>>>> Hmm, that still seems pretty soon to me.  I'd have thought you'd at
>>>>> least want to wait until most of the distributions (esp. SUSE for you
>>>>> guys) have released versions that have kernels sufficiently recent
>>>>> that the default mkfs will work.  Otherwise this will be a recurring
>>>>> problem.
>>>>>
>>>> I don't suppose there is an easy way to query xfs and find out if it
>>>> can support
>>>> the lazy SB option?
>>> I thought about that; xfs *could* stick someting in /proc/fs/xfs with
>>> supported features or somesuch.
> 
> how about /proc/fs/xfs/features
> .. any format suggestions?

maybe just 2 values, with the actual supported features (& features2)
values anded together?  Easy enough to parse in the code.

i.e.

# cat /proc/fs/xfs/features
0xffffffff
0x00000001


?

-Eric
