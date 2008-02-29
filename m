Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Feb 2008 15:12:15 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1TNBnAC032101
	for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 15:11:51 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B2B6E4B9E2
	for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 15:12:17 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id ezWFey9lY0MUq7fk for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 15:12:17 -0800 (PST)
Message-ID: <47C89137.3070805@sandeen.net>
Date: Fri, 29 Feb 2008 17:11:51 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com> <1204166101.13569.102.camel@edge.scott.net.au> <47C87775.2010007@thebarn.com>
In-Reply-To: <47C87775.2010007@thebarn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: nscott@aconex.com, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Russell Cattelan wrote:


>> Hmm, that still seems pretty soon to me.  I'd have thought you'd at
>> least want to wait until most of the distributions (esp. SUSE for you
>> guys) have released versions that have kernels sufficiently recent
>> that the default mkfs will work.  Otherwise this will be a recurring
>> problem.
>>   
> I don't suppose there is an easy way to query xfs and find out if it can 
> support
> the lazy SB option?

I thought about that; xfs *could* stick someting in /proc/fs/xfs with
supported features or somesuch.

But, the kernel you mkfs under isn't necessarily the one you're going to
need to fall back to tomorrow, though...

-Eric
