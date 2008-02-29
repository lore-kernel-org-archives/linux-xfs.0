Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Feb 2008 15:24:40 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1TNOE37000897
	for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 15:24:18 -0800
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BF0A6346FD
	for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 15:24:42 -0800 (PST)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202]) by cuda.sgi.com with ESMTP id xRvBMk6biNWFwvft for <xfs@oss.sgi.com>; Fri, 29 Feb 2008 15:24:42 -0800 (PST)
Message-ID: <47C89303.7070902@thebarn.com>
Date: Fri, 29 Feb 2008 17:19:31 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com> <1204166101.13569.102.camel@edge.scott.net.au> <47C87775.2010007@thebarn.com> <47C89137.3070805@sandeen.net>
In-Reply-To: <47C89137.3070805@sandeen.net>
Content-Type: multipart/mixed;
 boundary="------------000907060508040607060901"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: nscott@aconex.com, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------000907060508040607060901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Eric Sandeen wrote:
> Russell Cattelan wrote:
>
>
>   
>>> Hmm, that still seems pretty soon to me.  I'd have thought you'd at
>>> least want to wait until most of the distributions (esp. SUSE for you
>>> guys) have released versions that have kernels sufficiently recent
>>> that the default mkfs will work.  Otherwise this will be a recurring
>>> problem.
>>>   
>>>       
>> I don't suppose there is an easy way to query xfs and find out if it can 
>> support
>> the lazy SB option?
>>     
>
> I thought about that; xfs *could* stick someting in /proc/fs/xfs with
> supported features or somesuch.
>
> But, the kernel you mkfs under isn't necessarily the one you're going to
> need to fall back to tomorrow, though...
>
>   
True but at least it could make a bit of a intelligent decision.
and maybe a warning for a while about potentially incompatible flags.

> -Eric
>
>   


--------------000907060508040607060901
Content-Type: text/x-vcard; charset=utf-8;
 name="cattelan.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cattelan.vcf"

begin:vcard
fn:Russell Cattelan
n:Cattelan;Russell
email;internet:cattelan@thebarn.com
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------000907060508040607060901--
